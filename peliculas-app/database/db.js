const mysql2 = require('mysql2');

const createConnection = (user, password) => {
    return mysql2.createConnection({
        host: process.env.DB_HOST,
        user: user || process.env.DB_USER,
        password: password || process.env.DB_PASSWORD,
        database: process.env.DB_DATABASE
    });
};

module.exports = createConnection;