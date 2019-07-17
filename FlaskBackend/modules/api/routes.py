from flask import Flask,render_template,jsonify,Blueprint
mod = Blueprint('api',__name__,template_folder='templates')
from modules.dataBase import collection as db
from bson.json_util import dumps

@mod.route('/')
def api():
    return dumps(db.getAllImages())