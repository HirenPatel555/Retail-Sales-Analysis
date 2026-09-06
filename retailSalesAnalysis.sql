-- SQL Retail Sales Analysis
-- Project 01

-- 1. DATABASE CREATION

CREATE DATABASE sql_project_01;

-- 2. TABLE CREATION

-- DROP TABLE IF EXISTS retail_sale_tb;

CREATE TABLE retail_sale_tb (
    transactions_id INT PRIMARY KEY,
    sale_date       DATE,
    sale_time       TIME,
    customer_id     INT,
    gender          VARCHAR(25),
    age             INT,
    category        VARCHAR(25),
    quantiy         INT,
    price_per_unit  FLOAT,
    cogs            FLOAT,
    total_sale      FLOAT
);

-- 3. BASIC DATA CHECKS

-- View all records
SELECT *
FROM retail_sale_tb;

-- View a specific transaction
SELECT *
FROM retail_sale_tb
WHERE transactions_id = 1;

-- Count total records
SELECT COUNT(*)
FROM retail_sale_tb;

-- TRUNCATE TABLE retail_sale_tb;

-- Check for NULL ages
SELECT *
FROM retail_sale_tb
WHERE age IS NULL;

-- 4. DATA CLEANING

-- Check for NULL values across important columns
SELECT *
FROM retail_sale_tb
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- 5. DATA EXPLORATION

-- How many sales do we have?
SELECT COUNT(*) AS total_sale
FROM retail_sale_tb;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id)
FROM retail_sale_tb;

-- How many unique categories do we have?
SELECT COUNT(DISTINCT category)
FROM retail_sale_tb;

-- List all unique categories
SELECT DISTINCT category
FROM retail_sale_tb;

-- 6. DATA ANALYSIS & BUSINESS KEY PROBLEMS

-- Q.1 Retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sale_tb
WHERE sale_date = '2022-11-05';

-- Q.2 Retrieve all transactions where: Category = 'Clothing' Quantity >= 4 Month = November 2022

SELECT *
FROM retail_sale_tb
WHERE category = 'Clothing'
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11
  AND quantiy >= 4;

-- Q.3 Calculate total sales for each category

SELECT
    category,
    SUM(total_sale) AS net_sale
FROM retail_sale_tb
GROUP BY category;

-- Q.4 Find the average age of customers who purchased items from the 'Beauty' category

SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sale_tb
WHERE category = 'Beauty';

-- Q.5 Find all transactions where total sales are >= 1000

SELECT *
FROM retail_sale_tb
WHERE total_sale >= 1000;

-- Q.6 Find the total number of transactions made by each gender in each category

SELECT
    category,
    gender,
    COUNT(*) AS total_trans
FROM retail_sale_tb
GROUP BY category, gender
ORDER BY category;

-- Q.7 Calculate the average sale for each month and find the best-selling month in each year

SELECT
    year,
    month,
    avg_sale
FROM (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS sale_rank
    FROM retail_sale_tb
    GROUP BY 1, 2
) AS t1
WHERE sale_rank = 1;

-- Q.8 Find the top 5 customers based on highest total sales

SELECT
    customer_id,
    SUM(total_sale) AS total_sale
FROM retail_sale_tb
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Find the number of unique customers who purchased items from each category

SELECT
    category,
    COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sale_tb
GROUP BY category;

-- Q.10 Create shifts and calculate the number of orders Morning   : Before 12 Afternoon : 12 to 17 Evening   : After 17

WITH hourly_sale AS (
    SELECT
        *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12
                THEN 'morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17
                THEN 'Afternoon'
            ELSE 'evening'
        END AS shift
    FROM retail_sale_tb
)

SELECT
    shift,
    COUNT(transactions_id) AS total_orders
FROM hourly_sale
GROUP BY shift;