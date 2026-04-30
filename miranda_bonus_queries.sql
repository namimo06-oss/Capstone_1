-- BONUS QUESTIONS

-- SELECT,FILTERING AND SORTING
USE sample_sales;

-- 1. Transactions on January 15, 2024 sorted by highest sale amount
SELECT * 
FROM store_sales
WHERE Transaction_Date = '2024-01-15' -- Filter for only this date
ORDER BY sale_amount DESC; -- Sort from highest to lowest

-- 2. Transactions greater than $500
SELECT 
	Transaction_Date, 
    Store_ID,
    Prod_Num,
    Sale_Amount
FROM store_sales
WHERE Sale_Amount >500; -- Filter transactions higher than 500

-- 3. Products starting with 105250 and their category
SELECT 
    ProdNum, 
    Category
FROM products
JOIN inventory_categories
    ON products.categoryID = inventory_categories.CategoryID -- Match product to category
WHERE products.ProdNum LIKE '105250%'; -- Filter with pruducts that start with 105250

-- AGGREGATION

-- 4. Total revenue and average transaction amount
SELECT 
    SUM(Sale_Amount) AS TotalRevenue,
    AVG(Sale_Amount) AS AvgTransaction
FROM store_sales;

-- 5. Transactions per category
SELECT 
    ic.Category,
    COUNT(*) AS TotalTransactions
FROM store_sales ss
JOIN products p
    ON ss.Prod_Num = p.ProdNum -- connect sales to products 
JOIN inventory_categories ic
    ON p.CategoryID = ic.CategoryID -- connect to category
GROUP BY ic.Category -- Group by category
ORDER BY TotalTransactions DESC; -- Highest first 

-- 6. Store revenue (highest to lowest)
SELECT 
    Store_ID,
    SUM(Sale_Amount) AS TotalRevenue
FROM store_sales
GROUP BY Store_ID
ORDER BY TotalRevenue DESC;

-- 7. Total revenue by category
SELECT 
    ic.Category,
    SUM(ss.Sale_Amount) AS TotalRevenue
FROM store_sales ss
JOIN products p
    ON ss.Prod_Num = p.ProdNum -- Join product 
JOIN inventory_categories ic
    ON p.CategoryID = ic.CategoryID -- Join category
GROUP BY ic.Category
ORDER BY TotalRevenue DESC;

-- 8. Stores with revenue above $50,000
SELECT 
    Store_ID,
    SUM(Sale_Amount) AS TotalRevenue
FROM store_sales
GROUP BY Store_ID
HAVING SUM(Sale_Amount) > 50000; 

-- JOINS
-- 9. Sales where category is Textbooks or Technology & Accessories
SELECT *
FROM store_sales ss
JOIN products p
    ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories ic
    ON p.CategoryID = ic.CategoryID
WHERE ic.Category IN ('Textbooks', 'Technology & Accessories');

-- 10. Transactions between $100 and $200 in Textbooks
SELECT *
FROM store_sales ss
JOIN products p
    ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories ic
    ON p.CategoryID = ic.CategoryID
WHERE ss.Sale_Amount BETWEEN 100 AND 200 -- to filter results 
AND ic.Category = 'Textbooks';

-- 11. Each store's total sales with city and state
SELECT 
    ss.Store_ID,
    sl.StoreLocation AS City,
    sl.State,
    SUM(ss.Sale_Amount) AS TotalSales
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
GROUP BY ss.Store_ID, sl.storelocation, sl.State;

-- 12. Transaction date, amount, city, state, and manager
SELECT 
    ss.Transaction_Date,
    ss.Sale_Amount,
    sl.StoreLocation AS City,
    sl.State,
    m.SalesManager
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
JOIN management m
    ON sl.State = m.State;
    
-- 13. Total sales by region
SELECT 
	m.SalesManager, -- Added so data looks better for PivotChart 
    sl.State,  -- Added so data looks better for PivotChart 
    m.Region,
    SUM(ss.Sale_Amount) AS TotalRevenue
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
JOIN management m
    ON sl.State = m.State
GROUP BY m.SalesManager, sl.State, m.Region
ORDER BY TotalRevenue DESC;

-- 14. Total sales with preferred shipper and discount
SELECT 
    sl.State, -- use the alias given in join sl 
    SUM(ss.Sale_Amount) AS TotalRevenue,
    shipper_list.PreferredShipper,
    shipper_list.VolumeDiscount
FROM store_sales ss
JOIN store_locations sl -- Alias for store_location will be sl
    ON ss.Store_ID = sl.StoreId
JOIN shipper_list
    ON sl.State = shipper_list.ShipToState
GROUP BY 
    sl.State, 
    shipper_list.PreferredShipper, 
    shipper_list.VolumeDiscount;

-- 15. States with sales not in Shipper_List
SELECT DISTINCT sl.State, s.ShiptoState
	FROM store_locations sl
		LEFT JOIN Shipper_List s
			ON sl.State = s.ShiptoState
WHERE s.ShiptoState IS NULL
ORDER BY sl.state; -- No null results

-- A validation query was performed to identify store states not represented in the shipper list. 
-- No unmatched states were found, indicating complete alignment between store locations and shipping coverage.
SELECT DISTINCT sl.State, s.ShipToState
FROM store_locations sl
LEFT JOIN Shipper_List s
    ON sl.State = s.ShipToState;


-- 16. Total revenue by regional director
SELECT 
    m.RegionalDirector,
    SUM(ss.Sale_Amount) AS TotalRevenue
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
JOIN management m
    ON sl.State = m.State
GROUP BY m.RegionalDirector;

-- SUBQUERIES
-- 17. Transactions from stores in Texas (subquery)
SELECT *
FROM store_sales
WHERE Store_ID IN (
    SELECT StoreId
    FROM store_locations
    WHERE State = 'Texas'
); 

-- 18. Stores above average revenue
SELECT 
    Store_ID,
    SUM(Sale_Amount) AS TotalRevenue
FROM store_sales
GROUP BY Store_ID
HAVING SUM(Sale_Amount) > (
    SELECT AVG(TotalStoreRevenue)
    FROM (
        SELECT SUM(Sale_Amount) AS TotalStoreRevenue
        FROM store_sales
        GROUP BY Store_ID
    ) AS sub
);

-- 19. Top 5 stores with location
SELECT 
    top_stores.Store_ID,
    sl.StoreLocation AS City,
    sl.State,
    top_stores.TotalRevenue
FROM (
    SELECT 
        Store_ID,
        SUM(Sale_Amount) AS TotalRevenue
    FROM store_sales
    GROUP BY Store_ID
    ORDER BY TotalRevenue DESC
    LIMIT 5
) AS top_stores
JOIN store_locations sl
    ON top_stores.Store_ID = sl.StoreId;
    
-- 20. Sales from Northeast region managers
SELECT *
FROM store_sales ss
WHERE ss.Store_ID IN (
    SELECT sl.StoreId
    FROM store_locations sl
    JOIN management m
        ON sl.State = m.State
    WHERE m.Region = 'Northeast'
);
-- Other way to do 20 just that I wanted to include the Region on the results 
SELECT 
    ss.*,
    m.Region
FROM store_sales ss
JOIN store_locations sl
    ON ss.Store_ID = sl.StoreId
JOIN management m
    ON sl.State = m.State
WHERE m.Region = 'Northeast';


