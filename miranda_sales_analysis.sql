-- The sales territory I will be analyzing is Connecticut.
USE sample_sales;

-- Total revenue and date range
SELECT 
	SUM(Sale_Amount) AS TotalRevenue, 
    MIN(Transaction_Date) AS StartDate,
    MAX(Transaction_Date) AS EndDate
FROM store_sales
JOIN store_locations 
	ON store_sales.Store_ID = store_locations.StoreId
WHERE state = 'Connecticut';

-- Montly revenue breakdown
SELECT 
	YEAR(Transaction_Date) AS Year,
    MONTH(Transaction_Date) AS Month,
    SUM(Sale_Amount) AS MontlyRevenue
FROM  store_sales
JOIN store_locations 
	ON store_sales.Store_ID = store_locations.StoreId
WHERE state = 'Connecticut'
GROUP BY YEAR (Transaction_Date), MONTH(Transaction_Date)
ORDER BY YEAR ASC;

-- Territory(Connecticut) Vs Region revenue(East)
SELECT
	'Connecticut Territory' AS Comparison_Group,
	SUM(ss.sale_amount) AS total_revenue
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.storeid
WHERE sl.state = 'Connecticut'
UNION ALL 
SELECT 
	'East Region' AS comaprison_group,
	SUM(ss.sale_amount) AS total_revenue
FROM store_sales ss
JOIN store_locations sl
	ON ss.store_id = sl.storeid
JOIN management m
	ON sl.state = m.state
WHERE m.Region = 'East';

-- Number of transactions per month and average transaction size by product category
-- for the sale territory 
SELECT
	YEAR(ss.transaction_date) AS SaleYear, 
    MONTH(ss.transaction_date) AS Month, 
	ic.Category,
    COUNT(*) AS total_transactions,
    ROUND(AVG(ss.sale_amount),2) AS Avg_transaction_Size
FROM store_sales ss
JOIN products p 
	ON ss.prod_num = p.ProdNum
JOIN inventory_categories ic
	ON p.Categoryid = ic.Categoryid
JOIN store_locations sl
	ON ss.store_id = sl.storeid    
WHERE sl.state = 'Connecticut' 
GROUP BY SaleYear, Month, ic.Category
ORDER BY SaleYear, Month, total_transactions DESC;

--  Q5: Ranking of in-store sales performance by each store in my sales territory 
SELECT	
	Store_ID,
	SUM(Sale_Amount) AS TotalSales-- add up sales totals
FROM
	store_sales
WHERE
	store_sales.Store_ID IN (865,866,867,868,869,870,871,872) -- limit to my stores
GROUP BY
	store_sales.Store_ID -- separate by store id
ORDER BY
	TotalSales desc; -- show the largest total first
    

