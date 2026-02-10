# 🛒 Target E-Commerce SQL Analysis Project

##  Project Overview
This project performs an **end-to-end SQL analysis** on a real-world **Target-style e-commerce dataset** to derive **business-ready insights** across customers, orders, payments, sellers, products, delivery performance, and reviews.

The objective is to demonstrate **company-level analytical thinking**, strong **SQL querying skills**, and the ability to translate raw data into **actionable business insights** 

---

##  Dataset Description
The project uses multiple relational tables representing an e-commerce marketplace.

### Tables Used
- **customers** – Customer demographic and location details  
- **geolocation** – City/state level geographic data  
- **orders** – Order lifecycle details and timestamps  
- **order_items** – Product-level order details  
- **payments** – Payment type and transaction values  
- **order_reviews** – Customer review scores  
- **products** – Product and category information  
- **sellers** – Seller details  

All tables are joined using **primary–foreign key relationships** such as `order_id`, `customer_id`, `product_id`, and `seller_id`.

---

##  Key Business Questions Answered
- What is the **order time range** of the business?
- How many **cities and states** does the company operate in?
- How has **revenue evolved over time**?
- Which **product categories and sellers** generate the most revenue?
- What is the **repeat customer rate**?
- Does **late delivery impact customer reviews**?
- What are the most commonly used **payment methods**?
- Which **regions contribute the highest revenue**?

---

##  Analysis Approach
1. **Exploratory Data Analysis (EDA)**
   - Validate schema and timestamps  
   - Understand data coverage  

2. **Business-Focused SQL**
   - Aggregations, joins, window functions    

3. **Insight Generation**
   - Translate results into business actions  

---


##  Tools & Technologies
- SQL (BigQuery / PostgreSQL style)
- Relational Data Modeling
- Window Functions & Aggregations
- Business Analytics

---
 
