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



