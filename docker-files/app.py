from flask import Flask

# Create a Flask application instance
app = Flask(__name__)

# Define a route for the homepage
@app.route('/')
def hello_world():
    return "Hello, World!"

# Run the application
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
