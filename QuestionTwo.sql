-- Assuming relevant columns in Dataset_Purchases are 'City', 'ProductCategory', and 'Quantity'
-- Assuming relevant columns in Dataset_Cities are 'City' and 'Average Temperature (C)'
SELECT
    p.City,
    c."Average Temperature (C)",
    p.ProductCategory,
    SUM(p.Quantity) AS TotalQuantity
FROM
    Dataset_Purchases p
JOIN
    Dataset_Cities c ON p.City = c.City
GROUP BY
    p.City, c."Average Temperature (C)", p.ProductCategory;
-- Analyze the results to identify any trends or correlations

