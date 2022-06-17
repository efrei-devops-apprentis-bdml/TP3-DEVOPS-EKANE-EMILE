import requests
import json
import os

from flask import Flask, render_template, request

app = Flask(__name__)

# create a function that returns the weather for a specific location using env lat and lon
@app.route('/')
def index( ):
    args = request.args
    
    lat = args['lat']
    lon = args['lon']
    api_key = os.environ['API_KEY']
    
    res = requests.get(f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}').text
    
    return f"{res}\n"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)