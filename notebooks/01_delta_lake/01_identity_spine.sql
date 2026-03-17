CREATE or replace TABLE tim_dev.cleanroom.identity_spine (
  hashed_email STRING,
  provider_id STRING,
  last_seen TIMESTAMP
)
USING DELTA;

INSERT INTO tim_dev.cleanroom.identity_spine VALUES
('abc123', 'provider_a', current_timestamp()),
('def456', 'provider_b', current_timestamp());
