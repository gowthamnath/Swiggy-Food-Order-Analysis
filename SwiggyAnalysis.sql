-- SWIGGY Data Analysis 

-- 1. To get unique item names or the item list
SELECT DISTINCT name as Menu
FROM items

-- 2. To get the count of Unique Items
SELECT COUNT(DISTINCT (name)) as Item_Count 
FROM items;

-- 3. Distribution of Veg & Non-Veg Items
SELECT is_veg,COUNT(name) as Items 
from items 
group by is_veg;

-- 4. To get count of unique orders
SELECT COUNT(DISTINCT(order_id)) AS Order_Count
FROM items

-- 5. To get chicken items
SELECT * 
FROM items
WHERE name like '%Chicken%'

-- 6. To get paratha items
SELECT * 
FROM items
WHERE name like '%Paratha%'

-- 7. To get average number of items per order
SELECT COUNT(name)/COUNT(DISTINCT order_id) AS Average_Order
FROM items 

-- 8. To find number of times each item was ordered and highest ordered item
SELECT name, COUNT(name) As Order_Count
FROM items
GROUP BY name 
ORDER BY Order_Count DESC  

-- 9. To find distinct rain mode from Orders( 0 --> No Rain, 2--> Medium Rain, 5--> Heavy Rain)
SELECT DISTINCT rain_mode
FROM orders

-- 10. to find on_time orders (0 --> delayed, 1 --> ontime )
SELECT on_time as Delivery_Status, COUNT(on_time) Delivery_count  
From orders
GROUP BY on_time

-- 11. to find the count of distinct restuarants
SELECT COUNT(DISTINCT restaurant_name) AS restuarant_count
FROM orders

-- 13. to find the favourite restuarant
SELECT restaurant_name, COUNT(*) AS Number_of_times_ordered
FROM orders
GROUP BY restaurant_name
ORDER BY COUNT(*) DESC

-- 14. to find which month has the highest orders
SELECT format(order_time, 'yyyy-MM') AS Year_Month, COUNT(distinct order_id) AS order_count
FROM orders
GROUP BY format(order_time, 'yyyy-MM')
ORDER BY COUNT(distinct order_id) DESC

-- 15. to find the recent or lastorder 
SELECT MAX(order_time) AS Recent_Order
FROM orders

-- 16. to find the total revenue in a month by desc
SELECT format(order_time, 'yyyy-MM') As Year_Month, SUM(order_total) as total_revenue
FROM orders
GROUP BY format(order_time, 'yyyy-MM')
ORDER BY total_revenue desc

-- 17. to find the average order value
SELECT  sum(order_total)/COUNT(DISTINCT order_id) AS Average_Order_Value
from orders;

-- 18. to find year on year sales revenue and change in revenue(value and percentage)
with final as ( 
SELECT year(order_time) AS Order_Year, SUM(order_total) AS revenue
FROM orders
GROUP BY year(order_time))
SELECT Order_Year, revenue, lag(revenue) OVER(order by Order_Year) AS previous_year_revenue,
revenue - lag(revenue) over(order by Order_Year) as change_in_revenue,
(revenue - lag(revenue) over(order by Order_Year))/lag(revenue) over(order by Order_Year) * 100 AS _Change_In_Revenue_Percentage
FROM final;

-- 19. to find the rank based on yearly revenue
with final as ( 
SELECT year(order_time) AS Order_Year, SUM(order_total) AS revenue
FROM orders
GROUP BY year(order_time))
SELECT Order_Year, revenue, rank() over(order by revenue desc) as Rank
FROM final;

-- 20. to find rank by restuarant name
with final as ( 
SELECT restaurant_name, SUM(order_total) AS revenue
FROM orders
GROUP BY restaurant_name)
SELECT  restaurant_name, revenue, rank() over(order by revenue desc) as Rank
FROM final

-- 21. to find rank without CTE
SELECT  restaurant_name, Sum(order_total) As revenue , rank() over(order by SUM(order_total) desc) as Rank
FROM orders
GROUP by restaurant_name

-- 22. to fnd revenue by rain mode ( 0 --> No rain, 2 --> Medium Rain 5 --> Heavy Rain)
SELECT rain_mode, SUM(order_total) AS revenue
FROM orders
GROUP BY rain_mode

-- 23. to find the items list in each order
SELECT a.name, b.restaurant_name, b.order_id, b.order_time
FROM items a
JOIN orders b
ON a.order_id = b.order_id

-- 24. To get Unique combo orders
SELECT a.order_id, a.name, b.name, a.name + ' + ' + b.name as combo
FROM items a
JOIN items b ON
a.order_id = b.order_id
WHERE a.name! = b.name and a.name<b.name

