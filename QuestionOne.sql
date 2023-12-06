-- Assuming the relevant columns in Dataset_Purchases are 'City' and 'CustomerID'
SELECT
    p.City,
    COUNT(DISTINCT p.CustomerID) * 100.0 / c."Population (2021)" AS PercentageBuying
FROM
    Dataset_Purchases p
JOIN
    Dataset_Cities c ON p.City = c.City
GROUP BY
    p.City, c."Population (2021)";

-- OR --

SELECT
    p.City,
    COUNT(DISTINCT p.CustomerID) * 100.0 / c.Population AS PercentageBuying
FROM
    Dataset_Purchases p
JOIN
    Dataset_Cities c ON p.City = c.City
GROUP BY
    p.City, c.Population;
