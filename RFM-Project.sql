-- Use a new database for this project or an existing one where you have write permissions.
-- For demonstration, let's create a temporary database.
-- CREATE DATABASE IF NOT EXISTS rfm_project;
-- USE rfm_project;

-- If you are using an existing database, replace 'rfm_project' with your database name.
-- For simplicity, if you're just running this locally, you can use a test database.
-- For this example, let's assume you're operating within a suitable database.

-- Drop the table if it already exists to ensure a clean start
DROP TABLE IF EXISTS customer_orders;

-- 1. Create the hypothetical customer_orders table
CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_amount DECIMAL(10, 2) NOT NULL
);

-- 2. Insert sample data into the customer_orders table
-- This data represents various customer purchasing behaviors.
INSERT INTO customer_orders (customer_id, order_date, order_amount) VALUES
(101, '2025-06-10', 50.00),  -- Recent, moderate amount
(101, '2025-05-15', 75.00),  -- Frequent
(101, '2025-04-01', 100.00),
(102, '2025-06-08', 200.00), -- Recent, high amount
(103, '2025-03-20', 30.00),  -- Less recent, low amount
(103, '2025-01-10', 45.00),
(104, '2025-06-05', 120.00), -- Recent, moderate amount
(104, '2025-05-20', 80.00),
(104, '2025-05-01', 90.00),
(104, '2025-04-10', 150.00), -- Very Frequent
(105, '2025-02-28', 15.00),  -- Not recent, low amount
(106, '2025-06-12', 300.00), -- Very recent, very high amount
(107, '2025-05-01', 60.00),
(108, '2025-06-09', 90.00),
(108, '2025-06-01', 110.00),
(109, '2024-11-20', 25.00),  -- Oldest Recency
(110, '2025-06-11', 85.00),
(110, '2025-06-07', 40.00),
(110, '2025-06-03', 60.00),
(111, '2025-05-25', 180.00),
(112, '2025-06-06', 220.00);

-- Verify the inserted data
SELECT * FROM customer_orders;


-- Important: For Recency, we use DATEDIFF from a "current date".
-- For a real-time system, you'd use CURDATE() or NOW().
-- For reproducible results in this example, we'll fix a "snapshot date".
SET @snapshot_date = '2025-06-14';

SELECT
    customer_id,
    DATEDIFF(@snapshot_date, MAX(order_date)) AS Recency, -- Recency: Days since last purchase (lower is better, so DATEDIFF is good)
    COUNT(DISTINCT order_id) AS Frequency, -- Frequency: Number of unique orders
    SUM(order_amount) AS Monetary -- Monetary: Total amount spent
FROM
    customer_orders
GROUP BY
    customer_id
ORDER BY
    customer_id;


-- Important: This step requires MySQL 8.0+ for window functions (NTILE).
-- If you are using an older MySQL version, scoring would be more complex,
-- typically involving subqueries to find percentiles or fixed thresholds.

SET @snapshot_date = '2025-06-14';

-- First, calculate the raw R, F, M values for each customer
WITH CustomerRFM AS (
    SELECT
        customer_id,
        DATEDIFF(@snapshot_date, MAX(order_date)) AS Recency,
        COUNT(DISTINCT order_id) AS Frequency,
        SUM(order_amount) AS Monetary
    FROM
        customer_orders
    GROUP BY
        customer_id
)
SELECT
    customer_id,
    Recency,
    Frequency,
    Monetary,-- Assign Recency Score (lower days = higher score)
    NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score, -- Use DESC for Recency (smaller days = better = higher score)
    -- Assign Frequency Score (higher count = higher score)
    NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score, -- Use ASC for Frequency (smaller count = worse = lower score)
    -- Assign Monetary Score (higher amount = higher score)
    NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score   -- Use ASC for Monetary (smaller amount = worse = lower score)
FROM
    CustomerRFM
ORDER BY
    customer_id;

-- NOTE ON NTILE SCORING LOGIC:
-- NTILE(N) divides rows into N groups and assigns a group number.
-- For Recency: Lower days means more recent. So, we order by Recency DESC (largest days first)
-- to assign higher scores (5,4,3,2,1) to the most recent customers (smallest DATEDIFF values).
-- For Frequency: Higher count means more frequent. So, we order by Frequency ASC (smallest count first)
-- to assign higher scores (5,4,3,2,1) to the most frequent customers (largest COUNT values).
-- For Monetary: Higher amount means more spend. So, we order by Monetary ASC (smallest amount first)
-- to assign higher scores (5,4,3,2,1) to the highest spending customers (largest SUM values).

-- Important: This step requires MySQL 8.0+ for window functions.

SET @snapshot_date = '2025-06-14';

WITH CustomerRFM AS (
    SELECT
        customer_id,
        DATEDIFF(@snapshot_date, MAX(order_date)) AS Recency,
        COUNT(DISTINCT order_id) AS Frequency,
        SUM(order_amount) AS Monetary
    FROM
        customer_orders
    GROUP BY
        customer_id
),
CustomerRFMScores AS (
    SELECT
        customer_id,
        Recency,
        Frequency,
        Monetary,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM
        CustomerRFM
)
SELECT
    customer_id,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    -- Concatenate scores to create the RFM Segment
    CONCAT(R_Score, F_Score, M_Score) AS RFM_Segment,
    -- Categorize customers based on their RFM Segment
    CASE
        WHEN CONCAT(R_Score, F_Score, M_Score) IN ('555', '545', '455', '554') THEN 'Champions' -- Most valuable customers
        WHEN CONCAT(R_Score, F_Score, M_Score) IN ('544', '454', '445', '535', '355') THEN 'Loyal Customers'
        WHEN CONCAT(R_Score, F_Score, M_Score) IN ('551', '515', '155', '541', '145') THEN 'New/High-Value but Infrequent' -- Needs frequency boost
        WHEN CONCAT(R_Score, F_Score, M_Score) LIKE '5%' AND F_Score < 3 THEN 'New Customers (Potential)' -- Recently joined, low frequency
        WHEN CONCAT(R_Score, F_Score, M_Score) LIKE '_5_' OR CONCAT(R_Score, F_Score, M_Score) LIKE '__5' THEN 'High-Value/Frequent (Needs Recency)' -- High F/M, but not recent
        WHEN CONCAT(R_Score, F_Score, M_Score) IN ('333', '323', '233') THEN 'At Risk'
        WHEN CONCAT(R_Score, F_Score, M_Score) IN ('111', '112', '121', '211', '122', '212', '221') THEN 'Lost Customers' -- Least engaged
        ELSE 'Other' -- Catch-all for less common combinations
    END AS Customer_Segment
FROM
    CustomerRFMScores
ORDER BY
    customer_id;

