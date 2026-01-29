-- 04_data_quality_checks.sql
-- Data quality KPIs (your differentiator)

-- 1) Missing key fields %
SELECT
  ROUND(100.0 * AVG(CASE WHEN origin_city IS NULL OR origin_city = '' THEN 1 ELSE 0 END), 2) AS missing_origin_city_pct,
  ROUND(100.0 * AVG(CASE WHEN destination_city IS NULL OR destination_city = '' THEN 1 ELSE 0 END), 2) AS missing_destination_city_pct,
  ROUND(100.0 * AVG(CASE WHEN transportation_mode IS NULL OR transportation_mode = '' THEN 1 ELSE 0 END), 2) AS missing_transport_mode_pct,
  ROUND(100.0 * AVG(CASE WHEN product_category IS NULL OR product_category = '' THEN 1 ELSE 0 END), 2) AS missing_product_category_pct
FROM ops.raw_operations;

-- 2) Duplicate order_id check
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT order_id) AS distinct_order_id,
  (COUNT(*) - COUNT(DISTINCT order_id)) AS duplicate_rows
FROM ops.raw_operations;

-- 3) Invalid values (negatives)
SELECT
  COUNT(*) FILTER (WHERE delay_days < 0) AS negative_delay_rows,
  COUNT(*) FILTER (WHERE actual_lead_time_days < 0) AS negative_actual_lead_rows,
  COUNT(*) FILTER (WHERE shipping_cost_usd < 0) AS negative_shipping_cost_rows
FROM ops.raw_operations;

-- 4) Date parse failures
SELECT
  COUNT(*) FILTER (WHERE to_date(order_date,'MM/DD/YYYY') IS NULL) AS bad_date_rows
FROM ops.raw_operations;

-- 5) Data Health Score (simple scoring)
-- Start at 100, subtract penalties (easy to explain)
SELECT
  GREATEST(0,
    100
    - (ROUND(100.0 * AVG(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END),2) * 0.6)
    - (ROUND(100.0 * AVG(CASE WHEN order_date IS NULL OR order_date = '' THEN 1 ELSE 0 END),2) * 0.6)
    - ((COUNT(*) - COUNT(DISTINCT order_id))::numeric / NULLIF(COUNT(*),0) * 100 * 0.8)
  )::numeric(10,2) AS data_health_score
FROM ops.raw_operations;
