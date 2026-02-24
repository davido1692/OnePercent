# Import Flask and the render_template function
# Flask is the web framework; render_template loads HTML files from /templates
from flask import Flask, render_template

# Create the Flask application instance
# __name__ tells Flask where to find resources like templates and static files
app = Flask(__name__)

# -----------------------------
# ROUTE: Home page
# When a user visits "/", return the index.html file from the templates folder
# -----------------------------
@app.route("/")
def home():
    return render_template("index.html")

# -----------------------------
# ROUTE: Health check endpoint
# Used by Kubernetes, ALBs, or uptime monitors to confirm the app is alive
# Returns simple "OK" with HTTP 200 status
# -----------------------------
@app.route("/healthz")
def health():
    return "OK", 200

# -----------------------------
# LOCAL DEVELOPMENT ENTRY POINT
# This only runs when you execute: python app.py
# In Docker/Kubernetes, Gunicorn runs the app instead
# -----------------------------
if __name__ == "__main__":
    # Run the Flask development server on port 8080
    app.run(host="0.0.0.0", port=8080)
