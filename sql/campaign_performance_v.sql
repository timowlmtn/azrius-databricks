CREATE OR REPLACE VIEW tim_dev.cleanroom.campaign_performance_v
COMMENT 'Business-friendly campaign performance view for Genie. Each row represents aggregated campaign performance by date, provider, device type, and state.'
AS
SELECT
    ae.event_date,

    -- Identity / Provider
    ae.provider_id,

    -- Campaign
    ae.campaign_id,
    ae.campaign_name,
    ae.advertiser_name,
    ae.genre,

    -- Dimensions
    ae.device_type,
    id.state,

    -- Core Metrics
    COUNT(DISTINCT ae.hashed_email) AS unique_users,
    COUNT(*) AS event_count,
    SUM(ae.impressions) AS total_impressions,
    ROUND(SUM(ae.media_cost), 2) AS total_media_cost,

    -- Derived Metrics
    ROUND(SUM(ae.media_cost) / NULLIF(SUM(ae.impressions), 0), 4) AS cost_per_impression

FROM tim_dev.cleanroom.ad_events ae
LEFT JOIN tim_dev.cleanroom.identity_spine id
    ON ae.hashed_email = id.hashed_email

GROUP BY
    ae.event_date,
    ae.provider_id,
    ae.campaign_id,
    ae.campaign_name,
    ae.advertiser_name,
    ae.genre,
    ae.device_type,
    id.state;