from flask import Flask, Response, request
import requests
from datetime import datetime, timedelta
import pandas as pd
from StringIO import StringIO
from flask_cors import CORS
import logging

app = Flask(__name__)
CORS(app)

def buoy_df(bid):
    url = 'http://www.ndbc.noaa.gov/data/realtime2/{}.ocean'
    text = requests.get(url.format(bid)).text
    return pd.read_csv(StringIO(text), na_values=['MM'], skiprows=[1], sep='\s+')

class BuoyCache(object):
    def __init__(self, timeout=timedelta(minutes=10)):
        self.cache = {}
        self.timeout = timeout
    def get_df(self, buoy_id):
        ts, df = self.cache.get(buoy_id, (datetime(1900,1,1), None))
        if ts < datetime.now() - self.timeout:
            logging.info("fetching data for " + buoy_id)
            df = buoy_df(buoy_id)
            ts = datetime.now()
            self.cache[buoy_id] = (ts, df)
        else:
            logging.info("returning cached data for " + buoy_id)
        return df
    def get_json(self, buoy_id):
        return self.get_df(buoy_id).to_json(orient='records')
    def get_csv(self, buoy_id, **kwargs):
        sio = StringIO()
        self.get_df(buoy_id).to_csv(sio, index=False, **kwargs)
        return sio.getvalue()

BUOYCACHE = BuoyCache()

@app.route("/<bid>.json")
def bouy_json(bid):
    json = BUOYCACHE.get_json(bid)
    return Response(json, mimetype = 'text/json')

@app.route("/<bid>.csv")
def bouy_csv(bid):
    kwargs = {k: str(v) for k, v in request.args.iteritems()}
    csv = BUOYCACHE.get_csv(bid, **kwargs)
    return Response(csv, mimetype = 'text/plain')
