/* ===============================================================
   Description : This file contains SQL Views for calculating 
                 key marketing and customer performance KPIs.

   KPIs Included:
   - Conversion Rate
   - Customer Engagement Rate
   - Average Order Value (AOV)
   - Customer Feedback Score
   - Cost Per Acquisition (CPA) and ROI
================================================================= */
-- View 1: Conversion KPI
CREATE OR ALTER VIEW vw_kpi_conversion AS
SELECT 
    COUNT(DISTINCT JourneyID) AS total_visits,
    COUNT(DISTINCT CASE WHEN Action = 'Purchase' THEN JourneyID END) AS total_conversions,
    COUNT(DISTINCT CASE WHEN Action = 'Purchase' THEN JourneyID END) * 1.0 /
    NULLIF(COUNT(DISTINCT JourneyID),0) AS conversion_rate
FROM vw_customer_journey_cta
GO
-- 
 select * from vw_kpi_conversion
 
 -- ==============================================================
 -- View 2: Conversion KPI

CREATE OR ALTER VIEW vw_kpi_engagement AS
SELECT 
    SUM(CAST(Views AS BIGINT) + CAST(Clicks AS BIGINT) + CAST(Likes AS BIGINT)) AS total_interactions,
    COUNT(DISTINCT CustomerID) AS total_customers,
    SUM(CAST(Views AS BIGINT) + CAST(Clicks AS BIGINT) + CAST(Likes AS BIGINT)) * 1.0 / 
    NULLIF(COUNT(DISTINCT CustomerID),0) AS engagement_rate
FROM vw_engagement_data_final e
LEFT JOIN vw_customer_journey_cta j
    ON e.ProductID = j.ProductID;
GO

select * from vw_kpi_engagement

 -- ==============================================================
 -- View 3: Average Order Value (AOV)

CREATE OR ALTER VIEW vw_kpi_aov AS
SELECT
    SUM(p.Price) AS total_revenue,
    COUNT(DISTINCT j.JourneyID) AS total_orders,
    SUM(p.Price) * 1.0 / NULLIF(COUNT(DISTINCT j.JourneyID),0) AS AOV
FROM vw_customer_journey_cta j
JOIN vw_products_final p
    ON j.ProductID = p.ProductID
WHERE j.Action = 'Purchase';
GO

select * from vw_kpi_aov

 -- ==============================================================
 -- View 4: Customer Feedback Score

CREATE OR ALTER VIEW vw_kpi_feedback AS
SELECT
    AVG(r.Rating) AS avg_rating
FROM vw_customer_reviews_final r
JOIN vw_customer_journey_cta j
    ON r.CustomerID = j.CustomerID
    AND r.ProductID = j.ProductID;
GO

select * from vw_kpi_feedback

 -- ==============================================================
 -- View 5: Cost per Acquisition (CPA) – Approx Academic Version

CREATE OR ALTER VIEW vw_kpi_cpa AS
SELECT
    COUNT(DISTINCT j.JourneyID) AS total_conversions,
    COUNT(DISTINCT e.CampaignID) AS total_campaigns,
    COUNT(DISTINCT e.CampaignID) * 1.0 /
    NULLIF(COUNT(DISTINCT j.JourneyID),0) AS CPA
FROM vw_customer_journey_cta j
JOIN vw_engagement_data_final e
    ON j.ProductID = e.ProductID
WHERE j.Action = 'Purchase';
GO

select * from vw_kpi_cpa

