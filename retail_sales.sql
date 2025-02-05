-- Selecting Table
SELECT * FROM retail_sales;

-- Changing Column Name 
ALTER TABLE retail_sales
CHANGE COLUMN `ï»¿transactions_id` transactions_id INT;

ALTER TABLE retail_sales
CHANGE COLUMN `quantiy` quantity INT;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL 
    OR sale_date IS NULL 
    OR sale_time  IS NULL 
    OR customer_id IS NULL
    OR gender IS NULL 
    OR age IS NULL 
    OR category IS NULL
    OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
    OR total_sale IS NULL
;

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL 
    OR sale_date IS NULL 
    OR sale_time  IS NULL 
    OR customer_id IS NULL
    OR gender IS NULL 
    OR age IS NULL 
    OR category IS NULL
    OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
    OR total_sale IS NULL
;

-- Data Exploration
SELECT COUNT(*) AS total_count 
FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) AS customer_id 
FROM retail_sales;

SELECT DISTINCT category AS category 
FROM retail_sales;

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
 AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11' 
 AND quantity >=4
 ORDER BY sale_date ASC;
 
 -- Write a SQL query to calculate the total sales (total_sale) for each category.
 SELECT category, SUM(total_sale) AS net_sales,
 COUNT(*) AS total_sales
 FROM retail_sales
  GROUP BY 1;
  
  -- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
  SELECT ROUND(AVG(age), 2) AS avg_age
  FROM retail_sales
  WHERE category = 'Beauty';
  
  -- Write a SQL query to find all transactions where the total_sale is greater than 1000.
  SELECT * 
  FROM retail_sales
  WHERE total_sale > 1000;
  
  -- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
  SELECT category, gender, COUNT(*) AS total_trans
  FROM retail_sales
  GROUP BY category, gender
  ORDER BY 1
  ;
  
  -- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, avg_sale FROM
 (
 SELECT 
  YEAR(sale_date) AS year,
  MONTH(sale_date) AS month,
  ROUND(AVG(total_sale),2) AS avg_sale,
  RANK() OVER(PARTITION BY YEAR(sale_date)  ORDER BY AVG(total_sale) DESC) AS month_rank
  FROM retail_sales
  GROUP BY 1,2
  ) AS sale_month
  WHERE month_rank = 1
  ;
  
  -- Write a SQL query to find the top 5 customers based on the highest total sales 
  SELECT customer_id, SUM(total_sale) AS total_sales
 FROM retail_sales
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 5;
 
 -- Write a SQL query to find the number of unique customers who purchased items from each category.
 SELECT category, COUNT(DISTINCT(customer_id)) AS customer
 FROM retail_sales
 GROUP BY category;
 
 -- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
 WITH hourly_sale AS
 (
 SELECT *, 
	CASE 
		WHEN HOUR(sale_time) < 12 THEN 'Morning' 
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS Shift
 FROM retail_sales
 )
 SELECT Shift, COUNT(*) AS total_sales
 FROM hourly_sale
 GROUP BY Shift
 ;
 
-- Write a SQL query to compare weekday sales to weekend sales 
 SELECT category,
 SUM(CASE 
		WHEN DAYOFWEEK(sale_date) IN (1, 7) THEN quantity ELSE 0 
	END) AS weekend_sales,
 SUM(CASE 
		WHEN DAYOFWEEK(sale_date) BETWEEN 2 AND 6 THEN quantity ELSE 0 
	END) AS weekday_sales
FROM retail_sales
GROUP BY 1;																																																																																																													;

-- Write a SQL query to calculate the total profit generated (Total Sale - COGS)
SELECT category,
SUM((total_sale- cogs) * quantity) AS total_profit
FROM retail_sales
GRoup BY 1
;