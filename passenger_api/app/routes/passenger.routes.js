

const controller = require("../controllers/passenger.controller")

module.exports = function (app) {
  
  app.post("/passenger/create", controller.createRecord);

  app.post("/passenger/update", controller.updateRecord);

  app.post("/passenger/getlist", controller.getList);

  app.post("/passenger/delete", controller.deleteRecord);

};
