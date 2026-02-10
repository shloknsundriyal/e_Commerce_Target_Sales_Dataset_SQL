--EDA Steps
--Import dataset.
--Check column data types in customers table.
--Find order time range
--Count distinct customer cities and states.

select * 
from `target-project-486905.sqldata.customers`
limit 10 

SELECT * from `target-project-486905.sqldata.geolocation `
limit 5 

# Find order time range betweeen which orders were placed 
Select
min(order_purchase_timestamp) as start_time,
max(order_purchase_timestamp) as end_time 
from `target-project-486905.sqldata.orders`

# Display the details of cities and states who ordered during the given period 

select 
c.customer_city ,c.customer_state
from `target-project-486905.sqldata.orders` o
join `target-project-486905.sqldata.customers` c 
on o.customer_id = c.customer_id
where EXTRACT(YEAR from o.order_purchase_timestamp) = 2018
AND EXTRACT(MONTH FROM order_purchase_timestamp) BETWEEN 1 AND 3 

# FIND THE GROWING TREND IN PAST YEARS 
select 
EXTRACT(month from order_purchase_timestamp) as month,
count(order_id) as count_of_order 
from `target-project-486905.sqldata.orders`
group by EXTRACT(month from order_purchase_timestamp)
order by count_of_order desc 

# FIND WHAT TIME OF DAY CUSTOMERS MOSTLY PLACE THEIR ORDER ?(DAWN , MORNING , AFTERNOON OR NIGHT)
-- 0-6 hrs : Dawn
-- 7-12 hrs : Mornings
-- 13-18 hrs : Afternoon
-- 19-23 hrs : Night
SELECT 
EXTRACT(hour from order_purchase_timestamp) as hour,
count(order_id) as count_of_order 
from `target-project-486905.sqldata.orders`
group by EXTRACT(hour from order_purchase_timestamp)
order by count_of_order desc 

# get month on month n.o of orders acc to each state 
select 
extract( month from order_purchase_timestamp) as month,
extract( year from order_purchase_timestamp) as year,
count(*) as orders_count
from `target-project-486905.sqldata.orders`
group by year, month 
order by year, month

# CUSTOMER DIST ACROSS THE STATE
select customer_state,customer_city,
count(distinct(customer_id)) as count_of_customer 
from `target-project-486905.sqldata.customers`
group by customer_state,customer_city
order by  count_of_customer desc

# How much revenue is the company generating month-over-month?
SELECT 
EXTRACT(MONTH from  o.order_purchase_timestamp) AS month,
SUM(p.payment_value) AS total_revenue
FROM `target-project-486905.sqldata.orders` o
JOIN `target-project-486905.sqldata.payments ` p 
ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1

# Get the % increase in the cost of orders from year 2017 to 2018(include months between Jan to Aug only)

with cte as (
select 
EXTRACT(YEAR from  o.order_purchase_timestamp) AS year,
round(sum(p.payment_value),2) as total_payment
from `target-project-486905.sqldata.payments ` p 
join `target-project-486905.sqldata.orders` o 
on p.order_id = o.order_id 
where EXTRACT(YEAR from  o.order_purchase_timestamp) in ( 2017,2018)
and EXTRACT(MONTH from  o.order_purchase_timestamp) between 1 and 8 
group by EXTRACT(YEAR from  o.order_purchase_timestamp)
),
year_compare as (
select
year,
total_payment,
LEAD(total_payment)over(order by year desc) as prv_year
from cte
)

select round(((total_payment - prv_year)/prv_year)*100,2)
from year_compare

# total and avg value of order price for each state 
select round(sum(p.payment_value),2)as total_value, 
round(avg(p.payment_value),2) as avg_value,
c.customer_State
from `target-project-486905.sqldata.payments ` p 
join `target-project-486905.sqldata.orders` o on p.order_id = o.order_id 
join `target-project-486905.sqldata.customers` c on o.customer_id = c.customer_id
group by c.customer_State



# Find the no. of days taken to deliver each order from the order purchase date as delivery time
# Also calculate the difference (in days) between the estimated & actual delivery date of an order and status 

select order_id , 
DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp), DAY) AS delivery_days,
DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_estimated_delivery_date), DAY) AS diff_est_Delivery,
case 
    WHEN DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_estimated_delivery_date), DAY) < 0 THEN
    'delayed delivery'
    WHEN DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_estimated_delivery_date), DAY) = 0 THEN 
    'on time delivery'
    else 'Early'
END AS delivery_status
from `target-project-486905.sqldata.orders`

# Find out the top 5 states with the highest & lowest average freight value


select c.customer_State,
round(AVG(freight_value),2) as avg_freight_val
from `target-project-486905.sqldata.orders` o 
join `target-project-486905.sqldata.order_items ` oi on o.order_id = oi.order_id 
join `target-project-486905.sqldata.customers` c on o.customer_id = c.customer_id
group by c.customer_State
order by avg_freight_val desc 
limit 5 

# What % of customers are repeat customers?
WITH customer_orders AS (
    SELECT 
      customer_id,
      COUNT(DISTINCT order_id) AS total_orders
    FROM `target-project-486905.sqldata.orders`
    GROUP BY customer_id
)
SELECT
  COUNT(CASE WHEN total_orders > 1 THEN 1 END) * 100.0 / COUNT(*) AS repeat_customer_pct
FROM customer_orders;


# Who are the top 10% highest spending customers

WITH customer_spend AS (
  SELECT 
    o.customer_id,
    SUM(p.payment_value) AS total_spent
    FROM `target-project-486905.sqldata.orders` o
    JOIN `target-project-486905.sqldata.payments ` p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.customer_id
)
SELECT *
FROM (
    SELECT *,
      NTILE(10) OVER (ORDER BY total_spent DESC) AS spend_bucket
      FROM customer_spend
) t
WHERE spend_bucket = 1;


#  Preference on payment methods ?
SELECT 
    payment_type,
    COUNT(*) AS transactions,
    SUM(payment_value) AS total_value
FROM `target-project-486905.sqldata.payments `
GROUP BY payment_type
ORDER BY total_value DESC;

# Orders placed but never delivered ( sign of revenue lost)
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM `target-project-486905.sqldata.orders`
GROUP BY order_status;

