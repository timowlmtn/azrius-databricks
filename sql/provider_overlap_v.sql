CREATE OR REPLACE VIEW tim_dev.cleanroom.provider_overlap_v
COMMENT 'Simplified provider overlap view for Genie. Shows how much identity overlap exists between providers.'
AS
SELECT
    left_provider_id,
    right_provider_id,
    left_universe,
    right_universe,
    overlap_count,
    left_overlap_rate,
    right_overlap_rate
FROM tim_dev.cleanroom.overlap_results;