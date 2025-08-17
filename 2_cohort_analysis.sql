

WITH sales_data AS (
SELECT 
 customerkey,
 SUM(quantity*netprice/exchangerate) AS net_revenue
FROM sales;

)


SELECT 
	* 
FROM  sales_data ;