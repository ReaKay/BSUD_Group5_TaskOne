const mysql = require('mysql');

// Create a connection to the MySQL server
const connection = mysql.createConnection({
  host: '127.0.0.1',
  user: 'Rea',
  password: 'uE7E4P*W',
  database: 'Cities', 
  database: 'Purchases', 

});

// Connect to the MySQL server
connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL server:', err);
    return;
  }
  console.log('Connected to MySQL server');
});

// Example SQL query
const sqlQuery = 'SELECT * FROM Cities';

// Execute the query
connection.query(sqlQuery, (err, results, fields) => {
  if (err) {
    console.error('Error executing query:', err);
    return;
  }
  // Process the query results
  console.log('Query Results:', results);
});

// Close the connection after executing queries
connection.end((err) => {
  if (err) {
    console.error('Error closing connection:', err);
    return;
  }
  console.log('Connection closed');
});
