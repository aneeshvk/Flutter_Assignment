const { INTEGER } = require("sequelize");

module.exports = (sequelize, Sequelize) => {
  const Passenger = sequelize.define(
    "passenger",
    {
      passenger_name: { type: Sequelize.STRING },
      passenger_email: { type: Sequelize.STRING },
      passenger_mob: { type: Sequelize.STRING },
      passenger_age: { type: Sequelize.INTEGER },
      passenger_address: { type: Sequelize.STRING(100) },
    },
    {
      indexes: [
        { fields: ["passenger_email"], name: "UQ_passenger_email", unique: true },
      ],
    }
  );
  return Passenger;
};
