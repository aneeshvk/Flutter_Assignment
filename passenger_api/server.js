const express = require("express");
const app = express();
const cors = require("cors");

// parse requests of content-type - application/json
app.use(express.json());

// parse requests of content-type - application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));

app.use(cors());

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, x-access-token");
  next();
});

//route for testing
app.get("/",(req,res)=>{
res.json({"meassage":"This is an API for Passenger"});
});

//add more routes
require("./app/routes/passenger.routes")(app);


// start server and port listening
app.listen(8080, () => {
  console.log("App Server is running");
});
