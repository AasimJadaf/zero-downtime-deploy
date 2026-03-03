const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;
const VERSION = process.env.VERSION || "v2";
const ENVIRONMENT = process.env.ENVIRONMENT || "BLUE";

app.get("/", (req, res) => {
  res.json({
    message: "Zero Downtime Deployment Demo",
    version: VERSION,
    environment: ENVIRONMENT,
    timestamp: new Date()
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({ status: "OK" });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});