// Import required modules
const MongoClient = require('mongodb').MongoClient;
const fs = require('fs');
const csv = require('fast-csv');

// MongoDB connection details
const url = 'mongodb://localhost:27017';
const dbName = 'your_database_name'; // Replace with your actual database name

// Create a new MongoClient
const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true });

// Main function to read CSV files, import data into MongoDB, and execute queries
async function importDataAndExecuteQueries() {
    try {
        // Connect to MongoDB
        await client.connect();
        console.log('Connected to MongoDB');

        const db = client.db(dbName);

        // Read CSV files and insert data into MongoDB collections
        await importCsvData(db, 'Dataset_Purchases.csv', 'Dataset_Purchases');
        await importCsvData(db, 'Dataset_Cities.csv', 'Dataset_Cities');

        // Execute MongoDB queries
        await calculatePercentageBuying(db);
        await calculateTotalQuantityByCategory(db);
        await calculatePriceToSalaryRatio(db);

        console.log('Data import and query execution successful');
    } finally {
        // Close MongoDB connection
        await client.close();
        console.log('Disconnected from MongoDB');
    }
}

// Function to calculate Percentage Buying
async function calculatePercentageBuying(db) {
    return db.collection('Dataset_Purchases').aggregate([
        {
            $lookup: {
                from: "Dataset_Cities",
                localField: "City",
                foreignField: "City",
                as: "cityInfo"
            }
        },
        {
            $group: {
                _id: "$City",
                PercentageBuying: {
                    $multiply: [
                        {
                            $divide: [
                                { $addToSet: "$CustomerID" },
                                { $arrayElemAt: ["$cityInfo.Population (2021)", 0] }
                            ]
                        },
                        100
                    ]
                }
            }
        }
    ]).toArray();
}

// Function to calculate Total Quantity by Category
async function calculateTotalQuantityByCategory(db) {
    return db.collection('Dataset_Purchases').aggregate([
        {
            $lookup: {
                from: "Dataset_Cities",
                localField: "City",
                foreignField: "City",
                as: "cityInfo"
            }
        },
        {
            $group: {
                _id: { City: "$City", Temperature: "$cityInfo.Average Temperature (C)", Category: "$ProductCategory" },
                TotalQuantity: { $sum: "$Quantity" }
            }
        }
    ]).toArray();
}

// Function to calculate Price To Salary Ratio
async function calculatePriceToSalaryRatio(db) {
    return db.collection('Dataset_Purchases').aggregate([
        {
            $lookup: {
                from: "Dataset_Cities",
                localField: "City",
                foreignField: "City",
                as: "cityInfo"
            }
        },
        {
            $group: {
                _id: "$City",
                AveragePurchaseAmount: { $avg: "$TotalAmount" },
                AverageMonthlySalary: { $avg: "$cityInfo.Average Monthly Salary (USD)" },
                FinancialSituation: { $first: "$cityInfo.Financial Situation" },
            }
        },
        {
            $project: {
                _id: 1,
                AveragePurchaseAmount: 1,
                AverageMonthlySalary: 1,
                FinancialSituation: 1,
                PriceToSalaryRatio: {
                    $multiply: [
                        { $divide: ["$AveragePurchaseAmount", "$AverageMonthlySalary"] },
                        100
                    ]
                }
            }
        }
    ]).toArray();
}

// Function to import CSV data into MongoDB
async function importCsvData(db, csvFilePath, collectionName) {
    return new Promise((resolve, reject) => {
        // Get the MongoDB collection
        const collection = db.collection(collectionName);

        // Read CSV file using fast-csv
        const stream = fs.createReadStream(csvFilePath)
            .pipe(csv.parse({ headers: true })) // Parse CSV with headers
            .transform((data) => {
                // Perform transformations if needed before inserting into MongoDB
                return data;
            })
            .on('data', (data) => {
                // Insert each row of data into MongoDB collection
                collection.insertOne(data);
            })
            .on('end', () => {
                // Resolve the promise when CSV parsing is complete
                resolve();
            })
            .on('error', (error) => {
                // Reject the promise if an error occurs during CSV parsing
                reject(error);
            });
    });
}

// Run the data import and query execution process
importDataAndExecuteQueries();
