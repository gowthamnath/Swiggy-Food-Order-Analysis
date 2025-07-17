--Find Top 10 Revenue Generating Projects

SELECT top 10 product_id, sum(sale_price) as Sales
FROM
df_orders
GROUP BY product_id
ORDER BY Sales desc;

-- Find top 5 highest selling product from Each region

With CTE AS(
SELECT region,product_id, sum(sale_price) as Sales
FROM
df_orders
GROUP BY region,product_id)

SELECT * FROM (
SELECT *
, ROW_NUMBER() over (PARTITION by region ORDER BY Sales DESC) AS rn
FROM CTE) A
WHERE rn < = 5;

-- find month over month growth comparision for 2022 and 2023
WITH CTE AS (
SELECT year(order_date) AS order_year, month(order_date) AS order_month,
SUM(sale_price) AS Sales
FROM df_orders
GROUP BY year(order_date), month(order_date)
)           

SELECT order_month,
SUM(CASE WHEN order_year =2022 THEN Sales ELSE 0 END)as sales_2022,
SUM(CASE WHEN order_year = 2023 THEN Sales ELSE 0 END) as sales_2023
FROM CTE
GROUP BY order_month
ORDER BY order_month;

-- Monthly wise highest sales for each category
with cte as (
select category,format(order_date,'yyyyMM') as order_year_month
, sum(sale_price) as sales 
from df_orders
group by category,format(order_date,'yyyyMM')
--order by category,format(order_date,'yyyyMM')
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as rn
from cte
) a
where rn=1;

--which sub category had highest growth by profit in 2023 compare to 2022
WITH CTE AS (
SELECT sub_category, year(order_date) AS order_year,
SUM(sale_price) AS Sales
FROM df_orders
GROUP BY year(order_date), sub_category
),
CTE2 AS (
SELECT sub_category,
SUM(CASE WHEN order_year =2022 THEN Sales ELSE 0 END)as sales_2022,
SUM(CASE WHEN order_year = 2023 THEN Sales ELSE 0 END) as sales_2023
FROM CTE
GROUP BY sub_category)
select top 5 *
,(sales_2023-sales_2022)AS GROWTH
from  cte2
order by (sales_2023-sales_2022) desc

