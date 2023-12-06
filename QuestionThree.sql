-- Assuming relevant columns in Dataset_Purchases are 'City' and 'TotalAmount'
-- Assuming relevant columns in Dataset_Cities are 'City', 'Average Monthly Salary (USD)', and 'Financial Situation'
SELECT
    p.City,
    AVG(p.TotalAmount) AS AveragePurchaseAmount,
    c."Average Monthly Salary (USD)",
    c."Financial Situation",
    AVG(p.TotalAmount) / c."Average Monthly Salary (USD)" * 100 AS PriceToSalaryRatio
FROM
    Dataset_Purchases p
JOIN
    Dataset_Cities c ON p.City = c.City
GROUP BY
    p.City, c."Average Monthly Salary (USD)", c."Financial Situation";
-- Analyze the results to compare pricing to the city's financial situation or average monthly salary --

