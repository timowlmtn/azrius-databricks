CREATE or replace TABLE tim_dev.cleanroom.identity_spine (
  hashed_email STRING,
  provider_id STRING,
  last_seen TIMESTAMP
)
USING DELTA;