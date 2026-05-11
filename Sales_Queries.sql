-- create database ECommerce;
use ECommerce;

-- Q 1. Orders & Sales
-- Retrieve all completed orders
Create View Completed_Orders as
Select * from sales
where order_status = 'Shipped - Delivered to Buyer';
-- Calculate total revenue (only completed orders)
create view total_revenue as
Select round(sum(purchase_amount),2) as total_revenue
from sales
where order_status = 'Shipped - Delivered to Buyer';
-- Find monthly sales trend
create view monthly_sales_trend as
select month, sum(purchase_amount) as purchased_amount
from sales
group by month;
-- Get total number of orders by status
Create view total_orders_by_status as
select order_status, count(order_id) as total_orders
from sales
group by order_status;
-- Find average order value (AOV)
create view avg_order_value as
select round(avg(purchase_amount),2) as average_order 
from sales;


-- Q 2. Customer Analysis
-- List top 5 customers by total purchase amount
create view customer_highest_purchase as
select customerid, round(sum(purchase_amount),2) as total_purchase_amount
from sales
group by customerid
order by total_purchase_amount desc
limit 5;
-- Find number of orders per customer
create view total_order_per_customer as
select customerid, count(order_id) as total_orders 
from sales
group by customerid;
-- Calculate average purchase amount by gender
create view avg_purchase_amount as
select gender, round(avg(purchase_amount),2) as avg_purchase_amount
from sales
group by gender;
-- Find repeat customers (customers with more than 1 order)
create view repeated_customers as
select customerid, count(order_id) as total_orders
from sales
group by customerid
having count(order_id) > 1;


-- Q 3. Product & Category Analysis
-- Find top 5 best-selling products (by quantity)
create view best_selling_products as
select item_purchased, sum(quantity) as total_quantity
from sales
group by item_purchased
order by total_quantity desc
limit 5;
-- Get revenue by category
create view total_revenue_by_category as
select category, round(sum(purchase_amount),2) as total_revenue
from sales
group by category;
-- Find most frequently purchased category
create view most_frequently_purchased_category as
select category, sum(quantity) as no_of_purchases 
from sales
group by category
order by no_of_purchases desc
limit 1;


-- Q 4. Discounts & Impact
-- Calculate total discount given
create view total_discount_given as
select count(discount_applied) as total_discount
from sales
where discount_applied = 'Yes';
-- Compare revenue with vs without discount
create view revenue_by_discount as
select discount_applied, round(sum(purchase_amount),2) as total_revenue
from sales
group by discount_applied;


-- Q 5. Shipping & Operations
-- Find most used shipping mode
create view mostly_used_ship_mode as
select ship_mode, count(ship_mode) as ship_mode_usage
from sales
group by ship_mode
order by ship_mode_usage desc
limit 1;
-- Calculate average shipping cost per ship mode
create view avg_ship_cost_by_mode as
select ship_mode, round(avg(shipping_cost),2) as avg_ship_cost
from sales
group by ship_mode;
-- Find total shipping cost impact on revenue
create view shipping_impact_percentage as
select round((sum(purchase_amount)+sum(shipping_cost)),2) as total_revenue, 
round(sum(shipping_cost),2) as shipping_cost,
round((sum(shipping_cost)/(select * from total_revenue)*100),2) as shipping_impact_percentage
from sales;


-- Q 6. Customer Satisfaction
-- Calculate average review rating
create view avg_review_rating as
select round(avg(review_rating),2) as avg_review_rating
from sales;
-- Find average rating by category
create view avg_rating_category as
select category, round(avg(review_rating),2) as avg_review_rating
from sales
group by category;
-- Identify low-rated order
create view low_rated_order as
select * from sales
where review_rating < 3;