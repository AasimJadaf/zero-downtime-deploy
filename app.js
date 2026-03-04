const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;
const VERSION = process.env.VERSION || "v1";
const ENVIRONMENT = process.env.ENVIRONMENT || "BLUE";

app.get("/", (req, res) => {
  res.json({
    message: "Zero Downtime Deployment Demo ok",
    version: VERSION,
    environment: ENVIRONMENT,
    timestamp: new Date()
  });
});

app.get("/health", (req, res) => {
  res.status(500).json({ status: "OK" });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});