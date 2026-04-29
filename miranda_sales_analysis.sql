-- The sales territory I will be analyzing is Connecticut. 

USE sample_sales;
SELECT * FROM management; -- To see what territory I have based on the SalesManager assigned to me "Ellen Lemon". Territory is Connecticut

SELECT * FROM store_locations -- Find my storeIds for Connecticut which are from 865 to 872.
WHERE State = 'Connecticut';  -- Filter to only stores in Connecticut(IDs 865-872)

-- Q1. Total revenue and date range
SELECT 
	SUM(Sale_Amount) AS TotalRevenue, -- Calculate total revenue 
    MIN(Transaction_Date) AS StartDate, -- To find startdate, I used MIN equal to earliest date
    MAX(Transaction_Date) AS EndDate -- To find enddate, I use MAX to find the latest date
FROM store_sales
JOIN store_locations 
	ON store_sales.Store_ID = store_locations.StoreId -- I join the store_locations to use storeID and find revenue for only Connecticut
WHERE state = 'Connecticut';

-- Q2. Montly revenue breakdown
SELECT 
	State, -- Sales Territory
	YEAR(Transaction_Date) AS Year, -- I used year to find transaction date	by year (extract year from date)
    MONTH(Transaction_Date) AS Month, -- To get transaction by month (extract month from date)
    SUM(Sale_Amount) AS MontlyRevenue -- To get total sales amount per month
FROM  store_sales
JOIN store_locations 
	ON store_sales.Store_ID = store_locations.StoreId -- JOIN store_locations table again so I can get sales from only Connecticut state (Filter by location)
WHERE state = 'Connecticut' -- Only Connecticut data
GROUP BY YEAR (Transaction_Date), MONTH(Transaction_Date) -- Will start with the year and then month
ORDER BY YEAR ASC; -- The earliest transaction year is shown first

-- Q3. Territory(Connecticut) Vs Region Revenue(East)
SELECT
	'Connecticut Territory' AS Comparison_Group, -- Label for territory 
	SUM(Sale_Amount) AS total_revenue -- Sum revenue for territory	
FROM store_sales ss 
JOIN store_locations sl
	ON ss.store_id = sl.storeid -- Join to access location (state)
WHERE sl.state = 'Connecticut' -- Filter for territory
UNION ALL 
SELECT 
	'East Region' AS Comparison_group, -- Label for region 
	SUM(ss.sale_amount) AS total_revenue -- Sum revenue for region 
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id= sl.storeid -- Join to access location
JOIN management m
	ON sl.state = m.state -- Connect state to region
WHERE m.Region = 'East'; -- Filter for region

-- Q4. Number of transactions per month and average transaction size by product category
-- for the sale territory 
SELECT
	YEAR(ss.transaction_date) AS SaleYear, -- To organized data by year (Extract year)
    MONTH(ss.transaction_date) AS Month, -- Extrat month
	ic.Category, -- ic is from the inventory_categories table -- Get product category
    COUNT(*) AS total_transactions, -- Count number of transaction 
    ROUND(AVG(ss.sale_amount),2) AS Avg_transaction_Size -- Calculate average transaction
FROM store_sales ss
JOIN products p 
	ON ss.prod_num = p.ProdNum -- Link sales to products
JOIN inventory_categories ic
	ON p.Categoryid = ic.Categoryid -- Link product to category
JOIN store_locations sl
	ON ss.store_id = sl.storeid -- Link to location
WHERE sl.state = 'Connecticut' -- Filter for territory
GROUP BY SaleYear, Month, ic.Category -- Group by time and category
ORDER BY SaleYear, Month, total_transactions DESC; -- Sort results by DESC order 

--  Q5: Ranking of in-store sales performance by each store in my sales territory 
SELECT	
	Store_ID, -- Identify Ids for each store	
    StoreLocation, -- Identify location for each store
    State,
	SUM(Sale_Amount) AS TotalSales-- add up sales totals
FROM
	store_sales
JOIN store_locations
	ON store_sales.store_id = store_locations.StoreID
WHERE
	store_sales.Store_ID IN (865,866,867,868,869,870,871,872) -- limit to Connecticut stores
GROUP BY
	store_sales.Store_ID -- separate by store id
ORDER BY
	TotalSales DESC; -- show the largest total first (from highest to lowest sales)
    
-- Q6. Recommendation for where to focus sales attention in the next quarter.
-- Based on the analysis of the Connecticut territory, sales efforts for the next quarter 
-- should focus on high-performing stores such as New London, Bridgeport, and Hartford, 
-- as they consistently generate the highest revenue.
-- Additionally, product categories like Technology & Accessories and Textbooks should 
-- be prioritized, since they show the highest average transaction values and contribute 
-- significantly to overall revenue.
-- Lower-performing stores, such as Old Saybrook, should be evaluated to identify potential issues, 
-- such as lower foot traffic or less demand. 
-- Furthermore, the transaction data reveals that Technology & Accessories and Textbooks
-- not only drive revenue but also have higher average transaction sizes. Thus, strategies like bundling or upselling should be applied 
-- to boost average transaction size in these categories. Finally, since monthly revenue fluctuates, we should leverage high-demand months 
-- by increasing promotions and inventory during those periods to maximize growth in the next quarter.




