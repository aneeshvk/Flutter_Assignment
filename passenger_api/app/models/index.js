const dbConfig = require("../config/db.config.js");
const Sequelize = require("sequelize");

//connnection to mysql using sequelize
const sequelizeConn = new Sequelize(
  dbConfig.DB,
  dbConfig.USER,
  dbConfig.PASSWORD,
  {
    host: dbConfig.HOST,
    dialect: dbConfig.dialect,
    operatorsAliases: false,
    logging: false,
    logQueryParameters: true,
    pool: {
      max: dbConfig.pool.max,
      min: dbConfig.pool.min,
      acquire: dbConfig.pool.acquire,
      idle: dbConfig.pool.idle,
    },
  }
);

const db = {};
db.Sequelize = Sequelize;
db.sequelizeConn = sequelizeConn;

db.passenger = require("./passenger.model.js")(sequelizeConn, Sequelize);

//sync database
db.sequelizeConn
  .sync({ force: false, alter: true })
  .then(() => {
    console.log("Synced db.");
  })
  .catch((err) => {
    console.log("Failed to sync db: " + err.message);
  });

module.exports = db;
