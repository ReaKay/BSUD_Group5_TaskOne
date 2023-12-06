

-- Create the 'Cities' database if it doesn't exist
CREATE DATABASE IF NOT EXISTS Cities;

-- Switch to the 'Cities' database
USE Cities;

-- Create the 'City' table
CREATE TABLE IF NOT EXISTS City (
    CityID INT PRIMARY KEY,
    CityName VARCHAR(255),
    -- Add more columns as needed
);

-- Create the 'Population_2021' table
CREATE TABLE IF NOT EXISTS Population_2021 (
    PopulationID INT PRIMARY KEY,
    PopulationCount INT,
    -- Add more columns as needed
);

-- Create the 'Average_Temperature_C' table
CREATE TABLE IF NOT EXISTS Average_Temperature_C (
    TemperatureID INT PRIMARY KEY,
    AverageTemperature DECIMAL(5, 2),
    -- Add more columns as needed
);

-- Create the 'Local_Cuisine' table
CREATE TABLE IF NOT EXISTS Local_Cuisine (
    CuisineID INT PRIMARY KEY,
    CuisineName VARCHAR(255),
    -- Add more columns as needed
);

-- Create the 'Average_Monthly_Salary_USD' table
CREATE TABLE IF NOT EXISTS Average_Monthly_Salary_USD (
    SalaryID INT PRIMARY KEY,
    MonthlySalary DECIMAL(10, 2),
    -- Add more columns as needed
);

-- Create the 'Financial_Situation' table
CREATE TABLE IF NOT EXISTS Financial_Situation (
    SituationID INT PRIMARY KEY,
    FinancialStatus VARCHAR(255),
    -- Add more columns as needed
);

-- Load data into tables (Replace 'your_table_name' with the actual table name)
-- Note: Adjust the file paths and table names as per your setup
LOAD DATA INFILE 'C:/Users/Rea Blatter/OneDrive - FHNW/Desktop/BSUD_Group5/Task_1/SQLDB/Dataset_Cities.csv'
INTO TABLE City
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load data into tables

-- Load data for the 'City' table
LOAD DATA INFILE 'C:/Users/Rea Blatter/OneDrive - FHNW/Desktop/BSUD_Group5/Task_1/SQLDB/Dataset_Cities.csv'
INTO TABLE City
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip the header row if it exists

-- Load data for the 'Population_2021' table
LOAD DATA INFILE 'C:/Users/Rea Blatter/OneDrive - FHNW/Desktop/BSUD_Group5/Task_1/SQLDB/Dataset_Population_2021.csv'
INTO TABLE Population_2021
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip the header row if it exists

-- Load data for the 'Average_Temperature_C' table
LOAD DATA INFILE 'C:/Users/Rea Blatter/OneDrive - FHNW/Desktop/BSUD_Group5/Task_1/SQLDB/Dataset_Average_Temperature_C.csv'
INTO TABLE Average_Temperature_C
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip the header row if it exists

-- Load data for the 'Local_Cuisine' table
LOAD DATA INFILE 'C:/Users/Rea Blatter/OneDrive - FHNW/Desktop/BSUD_Group5/Task_1/SQLDB/Dataset_Local_Cuisine.csv'
INTO TABLE Local_Cuisine
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip the header row if it exists

-- Load data for the 'Average_Monthly_Salary_USD' table
LOAD DATA INFILE 'C:/Users/Rea Blatter/OneDrive - FHNW/Desktop/BSUD_Group5/Task_1/SQLDB/Dataset_Average_Monthly_Salary_USD.csv'
INTO TABLE Average_Monthly_Salary_USD
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip the header row if it exists

-- Load data for the 'Financial_Situation' table
LOAD DATA INFILE 'C:/Users/Rea Blatter/OneDrive - FHNW/Desktop/BSUD_Group5/Task_1/SQLDB/Dataset_Financial_Situation.csv'
INTO TABLE Financial_Situation
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip the header row if it exists;

-- Output queries

-- Assuming relevant fields are 'City' and 'CustomerID' in purchases and 'City' and 'Population (2021)' in cities
SELECT
    p.City,
    COUNT(DISTINCT p.CustomerID) * 100.0 / c.Population AS PercentageBuying
FROM
    Dataset_Purchases p
LEFT JOIN
    Dataset_Cities c ON p.City = c.City
GROUP BY
    p.City, c.Population;

-- Assuming relevant fields are 'City', 'ProductCategory', 'Quantity' in purchases, and 'City', 'Average Temperature (C)' in cities
SELECT
    p.City,
    c."Average Temperature (C)",
    p.ProductCategory,
    SUM(p.Quantity) AS TotalQuantity
FROM
    Dataset_Purchases p
LEFT JOIN
    Dataset_Cities c ON p.City = c.City
GROUP BY
    p.City, c."Average Temperature (C)", p.ProductCategory;

-- Assuming relevant fields are 'City', 'TotalAmount' in purchases, and 'City', 'Average Monthly Salary (USD)', 'Financial Situation' in cities
SELECT
    p.City,
    AVG(p.TotalAmount) AS AveragePurchaseAmount,
    c."Average Monthly Salary (USD)",
    c."Financial Situation",
    AVG(p.TotalAmount) / c."Average Monthly Salary (USD)" * 100 AS PriceToSalaryRatio
FROM
    Dataset_Purchases p
LEFT JOIN
    Dataset_Cities c ON p.City = c.City
GROUP BY
    p.City, c."Average Monthly Salary (USD)", c."Financial Situation";
