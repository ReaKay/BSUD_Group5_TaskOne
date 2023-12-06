// Assuming relevant fields are 'City' and 'CustomerID' in purchases and 'City' and 'Population (2021)' in cities
db.Dataset_Purchases.aggregate([
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
]);

// Assuming relevant fields are 'City', 'ProductCategory', 'Quantity' in purchases, and 'City', 'Average Temperature (C)' in cities
db.Dataset_Purchases.aggregate([
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
]);

// Assuming relevant fields are 'City', 'TotalAmount' in purchases, and 'City', 'Average Monthly Salary (USD)', 'Financial Situation' in cities
db.Dataset_Purchases.aggregate([
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
]);
