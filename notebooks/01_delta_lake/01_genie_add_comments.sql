COMMENT ON TABLE tim_dev.cleanroom.identity_spine IS
'Identity spine for natural-language analytics. Each row represents a provider-specific identity record. The primary cross-provider linkage key in this sample model is hashed_email.';

COMMENT ON TABLE tim_dev.cleanroom.ad_events IS
'Advertising exposure events for natural-language analytics. Each row represents an ad exposure tied to an identity and campaign.';

COMMENT ON TABLE tim_dev.cleanroom.overlap_results IS
'Provider-to-provider overlap summary derived from identity records using hashed_email as the match key.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN provider_id
COMMENT 'Source identity provider. Expected values include provider_a, provider_b, and provider_c.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN provider_person_id
COMMENT 'Provider-specific identifier for a person. Unique within a provider but not guaranteed unique across all providers.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN household_id
COMMENT 'Synthetic household identifier used to group related people into a household.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN hashed_email
COMMENT 'SHA-256 hash of the email address. This is the primary cross-provider match key in the sample data.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN hashed_device_id
COMMENT 'SHA-256 hash of a provider-specific device identifier.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN state
COMMENT 'Two-letter US state code associated with the identity record, such as CA, NY, or TX.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN device_type
COMMENT 'Primary device category associated with the identity, such as mobile, connected_tv, tablet, or desktop.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN first_seen_ts
COMMENT 'First timestamp when this identity was observed by the source system.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN last_seen_ts
COMMENT 'Most recent timestamp when this identity was observed by the source system.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN match_confidence
COMMENT 'Synthetic confidence score indicating how strongly this provider record maps to the shared identity.';

ALTER TABLE tim_dev.cleanroom.identity_spine
ALTER COLUMN source_system
COMMENT 'Upstream source that produced the identity record, such as crm, site_events, or identity_graph.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN event_id
COMMENT 'Unique identifier for an advertising exposure event.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN provider_id
COMMENT 'Source provider that supplied the ad event.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN provider_person_id
COMMENT 'Provider-specific person identifier associated with the exposure event.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN hashed_email
COMMENT 'SHA-256 hash of email used to join ad events to the identity spine in this sample model.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN hashed_device_id
COMMENT 'SHA-256 hash of the device identifier associated with the event.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN household_id
COMMENT 'Synthetic household identifier associated with the exposed identity.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN campaign_id
COMMENT 'Campaign identifier, such as cmp_1001.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN campaign_name
COMMENT 'Business-friendly campaign name, such as Max March Drama or TNT Playoffs Push.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN advertiser_name
COMMENT 'Advertiser or brand associated with the campaign.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN genre
COMMENT 'High-level campaign content category, such as Streaming, News, Sports, Lifestyle, Entertainment, or Food.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN device_type
COMMENT 'Device type on which the ad exposure occurred.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN event_ts
COMMENT 'Timestamp when the advertising event occurred.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN event_date
COMMENT 'Calendar date derived from event_ts. Useful for filtering and time-based aggregation.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN impressions
COMMENT 'Number of ad impressions represented by this event row.';

ALTER TABLE tim_dev.cleanroom.ad_events
ALTER COLUMN media_cost
COMMENT 'Synthetic media cost in US dollars associated with the event row.';

ALTER TABLE tim_dev.cleanroom.overlap_results
ALTER COLUMN left_provider_id
COMMENT 'Left-side provider in the overlap comparison.';

ALTER TABLE tim_dev.cleanroom.overlap_results
ALTER COLUMN right_provider_id
COMMENT 'Right-side provider in the overlap comparison.';

ALTER TABLE tim_dev.cleanroom.overlap_results
ALTER COLUMN left_universe
COMMENT 'Distinct identity count for the left-side provider.';

ALTER TABLE tim_dev.cleanroom.overlap_results
ALTER COLUMN right_universe
COMMENT 'Distinct identity count for the right-side provider.';

ALTER TABLE tim_dev.cleanroom.overlap_results
ALTER COLUMN overlap_count
COMMENT 'Number of shared identities between the two providers based on hashed_email.';

ALTER TABLE tim_dev.cleanroom.overlap_results
ALTER COLUMN left_overlap_rate
COMMENT 'Overlap count divided by the left-side provider universe.';

ALTER TABLE tim_dev.cleanroom.overlap_results
ALTER COLUMN right_overlap_rate
COMMENT 'Overlap count divided by the right-side provider universe.';

ALTER TABLE tim_dev.cleanroom.overlap_results
ALTER COLUMN computed_ts
COMMENT 'Timestamp when the overlap summary was computed.';