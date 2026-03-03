-- ==========================================================
-- >    Project: Marketing Analytics – ShopEasy
-- >    Layer: Clean Views (Non-Destructive)
-- >    Purpose: Prepare analysis-ready datasets for Power BI
-- ==========================================================

-- View: Clean Customer Journey Data
-- Purpose:
-- Single CTA View: Clean Customer Journey
CREATE OR ALTER VIEW vw_customer_journey_cta AS
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
             PARTITION BY CustomerID, ProductID, VisitDate, Stage
             ORDER BY JourneyID
           ) AS rn
    FROM customer_journey
	)
	SELECT
		JourneyID,
		CustomerID,
		ProductID,
		VisitDate,
		Stage,
		Action,
		COALESCE(Duration, 0) AS Duration,  
		CASE 
			WHEN LOWER(Stage) = 'checkout' THEN 'Checkout'
			WHEN LOWER(Stage) = 'productpage' THEN 'Product Page'
			ELSE Stage
		END AS Stage_Clean
FROM cte
WHERE rn = 1;
GO

select * from vw_customer_journey_cta
-- ===================================================
-- View: Clean Engagement Data
-- Purpose:
-- 1. Split combined views/clicks column
-- 2. Standardize content types
-- 3. Prepare engagement metrics for KPI calculation
CREATE OR ALTER VIEW vw_engagement_data_final AS
SELECT
    EngagementID,
    ContentID,

    CASE 
        WHEN LOWER(ContentType) = 'video' THEN 'Video'
        WHEN LOWER(ContentType) = 'newsletter' THEN 'Newsletter'
        WHEN LOWER(ContentType) = 'socialmedia' THEN 'Social Media'
        ELSE ContentType
    END AS ContentType,

	Likes,
	CampaignID,
    EngagementDate,
	productID,

	-- Views
    TRY_CAST(
        LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1)
        AS INT
    ) AS Views,

	-- Clicks
    TRY_CAST(
        SUBSTRING(
            ViewsClicksCombined,
            CHARINDEX('-', ViewsClicksCombined) + 1,
            LEN(ViewsClicksCombined)
        )
        AS INT
    ) AS Clicks

FROM engagement_data
WHERE ViewsClicksCombined IS NOT NULL
  AND CHARINDEX('-', ViewsClicksCombined) > 0;
GO

-- ===================================================
-- View: Clean Customer Data

CREATE OR ALTER VIEW vw_customers_final AS
SELECT
    CustomerID,
    CustomerName,
    Email,
    Gender,
    Age,
    GeographyID
FROM customers;
GO

-- ===================================================
-- View: Clean Products Data

CREATE OR ALTER VIEW vw_products_final AS
SELECT
    ProductID,
    ProductName,
    Category,
    Price
FROM products;
GO

-- ===================================================
-- View: Clean Customer Reviews Data

CREATE OR ALTER VIEW vw_customer_reviews_final AS
SELECT
    ReviewID,
    CustomerID,
    ProductID,
    ReviewDate,
    Rating,
    ReviewText
FROM customer_reviews;
GO

-- ===================================================
-- View: Clean Geography Data

CREATE OR ALTER VIEW vw_geography_final AS
SELECT
    GeographyID,
    Country,
    City
FROM geography;
GO