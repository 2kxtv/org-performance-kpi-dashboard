-- 03_kpi_queries.sql
-- KPI views for Power BI (simple, fast, reusable)

DROP VIEW IF EXISTS ops.v_kpi_daily;
CREATE VIEW ops.v_kpi_daily AS
SELECT
  order_date,
  COUNT(*) AS total_orders,
  AVG(delay_days)::numeric(10,2) AS avg_delay_days,
  SUM(is_delayed) AS delayed_orders,
  (AVG(on_time_flag)::numeric(10,4)) AS on_time_rate,
  AVG(risk_score)::numeric(10,3) AS avg_risk_score,
  SUM(shipping_cost_usd)::numeric(14,2) AS total_shipping_cost
FROM ops.v_fact_operations
GROUP BY 1;

DROP VIEW IF EXISTS ops.v_kpi_monthly;
CREATE VIEW ops.v_kpi_monthly AS
SELECT
  date_trunc('month', order_date)::date AS month,
  COUNT(*) AS total_orders,
  AVG(delay_days)::numeric(10,2) AS avg_delay_days,
  (AVG(on_time_flag)::numeric(10,4)) AS on_time_rate,
  AVG(risk_score)::numeric(10,3) AS avg_risk_score,
  SUM(shipping_cost_usd)::numeric(14,2) AS total_shipping_cost
FROM ops.v_fact_operations
GROUP BY 1;

DROP VIEW IF EXISTS ops.v_driver_breakdown;
CREATE VIEW ops.v_driver_breakdown AS
SELECT
  transportation_mode,
  route_type,
  product_category,
  disruption_event,
  risk_band,
  COUNT(*) AS total_orders,
  AVG(delay_days)::numeric(10,2) AS avg_delay_days,
  (AVG(on_time_flag)::numeric(10,4)) AS on_time_rate,
  AVG(risk_score)::numeric(10,3) AS avg_risk_score,
  SUM(shipping_cost_usd)::numeric(14,2) AS total_shipping_cost
FROM ops.v_fact_operations
GROUP BY 1,2,3,4,5;
