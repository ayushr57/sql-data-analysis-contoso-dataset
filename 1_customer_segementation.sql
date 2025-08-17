
WITH customer_ltv AS (
	SELECT
		customerkey,
		cleaned_name,
		SUM(net_revenue) AS total_ltv
	FROM cohort_analysis
	GROUP BY 
	customerkey,
	cleaned_name
),

customer_segements AS (
	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv ) AS ltv_25th_percentile,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv ) AS ltv_75th_percentile
	FROM
		customer_ltv
),

segment_values AS (

	SELECT 
		c.*,
		CASE 
			WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1-low-value'
			WHEN c.total_ltv <= cs.ltv_75th_percentile THEN '2-mid-value'
			ELSE  '3-high-value'
		
		END AS customer_segment
	FROM
		customer_ltv c,
		customer_segements cs
)

SELECT 
	customer_segment,
	SUM(total_ltv) AS total_ltv,
	COUNT(customerkey) AS customer_count,
	SUM(total_ltv) / COUNT(customerkey) AS avg_ltv
FROM segment_values 
GROUP BY customer_segment 
ORDER BY customer_segment DESC 
	
	
	
	
	
	
	