-- 02_load_clean.sql (PostgreSQL)
-- 1) Update the file path to your local CSV location.
-- 2) Run this COPY command in pgAdmin Query Tool.

-- Example path (change this):
-- COPY ops.raw_operations FROM 'C:/Users/<you>/Downloads/supply_chain_operations.csv'
-- WITH (FORMAT csv, HEADER true);

-- After loading, run quick sanity checks:
SELECT COUNT(*) AS row_count FROM ops.raw_operations;

-- Check date parse success:
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE to_date(order_date,'MM/DD/YYYY') IS NULL) AS bad_dates
FROM ops.raw_operations;

-- Check delay distribution:
SELECT
  MIN(delay_days) AS min_delay,
  MAX(delay_days) AS max_delay,
  AVG(delay_days)::numeric(10,2) AS avg_delay
FROM ops.raw_operations;

-- Check distinct categories:
SELECT 'transportation_mode' AS field, COUNT(DISTINCT transportation_mode) AS distinct_cnt FROM ops.raw_operations
UNION ALL
SELECT 'route_type', COUNT(DISTINCT route_type) FROM ops.raw_operations
UNION ALL
SELECT 'product_category', COUNT(DISTINCT product_category) FROM ops.raw_operations;
