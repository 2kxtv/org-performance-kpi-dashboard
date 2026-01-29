-- 01_create_tables.sql (PostgreSQL)
CREATE SCHEMA IF NOT EXISTS ops;

DROP TABLE IF EXISTS ops.raw_operations;

CREATE TABLE ops.raw_operations (
  order_id                   TEXT,
  order_date                 TEXT,
  origin_city                TEXT,
  destination_city           TEXT,
  route_type                 TEXT,
  transportation_mode        TEXT,
  product_category           TEXT,
  base_lead_time_days        INT,
  scheduled_lead_time_days   INT,
  actual_lead_time_days      INT,
  delay_days                 INT,
  delivery_status            TEXT,
  disruption_event           TEXT,
  geopolitical_risk_index    NUMERIC(10,4),
  weather_severity_index     NUMERIC(10,4),
  inflation_rate_pct         NUMERIC(10,4),
  shipping_cost_usd          NUMERIC(12,2),
  order_weight_kg            NUMERIC(12,3),
  mitigation_action_taken    TEXT
);

--  a cleaned view that Power BI can use directly
DROP VIEW IF EXISTS ops.v_fact_operations;

CREATE VIEW ops.v_fact_operations AS
SELECT
  order_id,
  to_date(order_date, 'MM/DD/YYYY') AS order_date,
  origin_city,
  destination_city,
  route_type,
  transportation_mode,
  product_category,
  base_lead_time_days,
  scheduled_lead_time_days,
  actual_lead_time_days,
  delay_days,
  delivery_status,
  disruption_event,
  geopolitical_risk_index,
  weather_severity_index,
  inflation_rate_pct,
  shipping_cost_usd,
  order_weight_kg,
  mitigation_action_taken,

  -- Derived fields (for KPIs)
  CASE WHEN delay_days > 0 THEN 1 ELSE 0 END AS is_delayed,
  (actual_lead_time_days - scheduled_lead_time_days) AS lead_time_variance_days,
  CASE WHEN actual_lead_time_days <= scheduled_lead_time_days THEN 1 ELSE 0 END AS on_time_flag,

  -- Simple risk score (rule-based, easy to explain in interviews)
  ROUND(
    COALESCE(geopolitical_risk_index,0) * 0.45 +
    COALESCE(weather_severity_index,0) * 0.35 +
    COALESCE(inflation_rate_pct,0) * 0.20
  , 3) AS risk_score,

  CASE
    WHEN (
      COALESCE(geopolitical_risk_index,0) * 0.45 +
      COALESCE(weather_severity_index,0) * 0.35 +
      COALESCE(inflation_rate_pct,0) * 0.20
    ) >= 7 THEN 'High'
    WHEN (
      COALESCE(geopolitical_risk_index,0) * 0.45 +
      COALESCE(weather_severity_index,0) * 0.35 +
      COALESCE(inflation_rate_pct,0) * 0.20
    ) >= 4 THEN 'Medium'
    ELSE 'Low'
  END AS risk_band

FROM ops.raw_operations;
