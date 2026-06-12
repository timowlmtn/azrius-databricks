# AWS NAT Gateway Cleanup and Restore Guide

## Purpose

This document describes how to temporarily remove an AWS NAT Gateway to eliminate monthly charges while preserving the ability to restore the environment later.

This procedure was used for the `owlmtn` account to suspend an unused Databricks proof-of-concept environment.

---

## Environment

| Resource         | Value                 |
| ---------------- | --------------------- |
| Region           | us-east-1             |
| VPC              | vpc-0f27cba446a3b734d |
| NAT Gateway      | nat-012b2e779fc496879 |
| NAT Public IP    | 100.25.170.33         |
| Route Table      | rtb-03c8358d10505c7a5 |
| Route Table Type | Main Route Table      |

---

## Background

AWS NAT Gateways cannot be stopped or paused.

As long as a NAT Gateway exists, AWS charges for:

* NAT Gateway hourly usage
* NAT Gateway data processing

To stop billing, the NAT Gateway must be deleted.

The environment can later be restored by recreating a NAT Gateway and updating the route table.

---

# Backup Existing Configuration

Before making changes, save the current configuration.

## Save NAT Gateway Configuration

```bash
aws ec2 describe-nat-gateways \
  --profile owlmtn \
  --region us-east-1 \
  --nat-gateway-ids nat-012b2e779fc496879 \
  > nat-gateway-backup.json
```

## Save Route Table Configuration

```bash
aws ec2 describe-route-tables \
  --profile owlmtn \
  --region us-east-1 \
  --route-table-ids rtb-03c8358d10505c7a5 \
  > route-table-backup.json
```

---

# Verify Route Table Usage

Confirm the route table is the VPC's main route table.

```bash
aws ec2 describe-route-tables \
  --profile owlmtn \
  --region us-east-1 \
  --route-table-ids rtb-03c8358d10505c7a5 \
  --query 'RouteTables[0].Associations'
```

Expected output:

```json
[
  {
    "Main": true
  }
]
```

---

# Delete NAT Gateway

Delete the NAT Gateway to stop billing.

```bash
aws ec2 delete-nat-gateway \
  --profile owlmtn \
  --region us-east-1 \
  --nat-gateway-id nat-012b2e779fc496879
```

Monitor status:

```bash
aws ec2 describe-nat-gateways \
  --profile owlmtn \
  --region us-east-1 \
  --nat-gateway-ids nat-012b2e779fc496879 \
  --query 'NatGateways[0].State'
```

States:

```text
available
deleting
deleted
```

---

# Release Elastic IP

After the NAT Gateway has been deleted, check for unassociated Elastic IPs.

```bash
aws ec2 describe-addresses \
  --profile owlmtn \
  --region us-east-1 \
  --query 'Addresses[*].{PublicIp:PublicIp,AllocationId:AllocationId,AssociationId:AssociationId}'
```

Locate the EIP associated with the NAT Gateway.

If it is no longer attached to any resource:

```bash
aws ec2 release-address \
  --profile owlmtn \
  --region us-east-1 \
  --allocation-id eipalloc-xxxxxxxxxxxxxxxxx
```

---

# Restore Procedure

When Databricks or another workload requires outbound internet access again:

## Create a New NAT Gateway

Identify a public subnet in the VPC.

Allocate a new Elastic IP:

```bash
aws ec2 allocate-address \
  --profile owlmtn \
  --region us-east-1 \
  --domain vpc
```

Create the NAT Gateway:

```bash
aws ec2 create-nat-gateway \
  --profile owlmtn \
  --region us-east-1 \
  --subnet-id subnet-0286e4abd64b34f97 \
  --allocation-id eipalloc-0e0ab0608175acbfc
```

Record the new NAT Gateway ID.

---

## Update the Route Table

Replace the default route:

```bash
aws ec2 replace-route \
  --profile owlmtn \
  --region us-east-1 \
  --route-table-id rtb-03c8358d10505c7a5 \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id nat-xxxxxxxxxxxxxxxxx
```

---

## Verify Connectivity

Confirm the route exists:

```bash
aws ec2 describe-route-tables \
  --profile owlmtn \
  --region us-east-1 \
  --route-table-ids rtb-03c8358d10505c7a5
```

Verify outbound connectivity from an EC2 instance or Databricks cluster.

---

# Notes

* Deleting the NAT Gateway stops NAT Gateway billing immediately.
* Deleting the NAT Gateway does not delete the VPC, route table, or subnets.
* Any private resources depending on internet egress will lose outbound connectivity until a replacement NAT Gateway is created.
* The route table remains intact and can be reattached to a newly created NAT Gateway at any time.

---

Last Updated: June 2026
