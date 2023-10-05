// import express (after npm install express)
import express, { json } from "express";
// create new express app and save it as "app"
const app = express();
// server configuration
const PORT = 8080;
/** Decode JSON data */
app.use(json({ limit: "25mb" }));
let blocks = [];
let createdContracts = [];
let transactionLog = [];
// create a route for the app
app.get("/", (req, res) => {
  res.send("Hello World!");
});
// start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});