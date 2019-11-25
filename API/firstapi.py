from flask import Flask, request,jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from flask_bcrypt import Bcrypt
import uuid

app = Flask(__name__)

app.config["SECRET_KEY"] = 'thisissecret'
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///appdata.db"

db = SQLAlchemy(app)
bcrypt = Bcrypt(app)

class User(db.Model):
	id = db.Column(db.Integer, primary_key = True)
	public_id = db.Column(db.String(50), unique=True)
	first = db.Column(db.String(30), nullable=False)
	last = db.Column(db.String(30), nullable=False)
	shopname = db.Column(db.String(50), nullable=False)
	email = db.Column(db.String(60), nullable=False)
	password = db.Column(db.String(60), nullable=False)
	creation_date = db.Column(db.DateTime, default = datetime.utcnow, nullable=False )
	customers = db.relationship('Customer', backref ="supplier", lazy=True, cascade="all, delete-orphan")

class Customer(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	first = db.Column(db.String(30), nullable=False)
	last = db.Column(db.String(30), nullable=False)
	phone = db.Column(db.String(15))
	image = db.Column(db.String(50))
	address = db.Column(db.String(250))
	landmark = db.Column(db.String(50))
	mobile = db.Column(db.String(15))
	aadharno = db.Column(db.String(20))
	email = db.Column(db.String(60), nullable=False)
	creation_date = db.Column(db.DateTime, default = datetime.utcnow, nullable=False )
	appuser = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"), nullable=False)

@app.route("/")
def home():
	return jsonify({"message":"running"})

@app.route("/user", methods=["POST"])
def createUser():
	data = request.get_json(force=True)
	print(data)
	if(User.query.filter_by(email=data['email']).first()):
		return jsonify({"response":"Already exist"})
	hashed_password = bcrypt.generate_password_hash(data["password"]).decode('utf-8')
	user = User(public_id =str(uuid.uuid4()), first=data['first'], last = data['last'], email=data['email'], password=hashed_password, shopname=data['shopname'])
	db.session.add(user)
	db.session.commit()
	return jsonify({"response":"success"})


@app.route("/user/<public_id>", methods=["GET"])
def get_one_user(public_id):
	user = User.query.filter_by(public_id=public_id).first()
	if not user:
		return jsonify({"message":"No user found!"})
	user_data = {}
	user_data["public_id"] = user.public_id
	user_data["first"] = user.first
	user_data['last'] = user.last
	user_data['shopname'] = user.shopname
	user_data['email'] = user.email
	user_data['password'] = user.password
	return jsonify({"user":user_data})

@app.route("/user", methods=["GET"])
def get_all_users():
	users = User.query.all()
	userlist =[]
	for user in users:
		apidata = {}
		apidata["public_id"] = user.public_id
		apidata["first"] = user.first
		apidata['last'] = user.last
		apidata['email'] = user.email
		apidata['shopname'] = user.shopname
		userlist.append(apidata)
	return jsonify({"users": userlist})


@app.route("/user/<public_id>", methods=["DELETE"])
def delete_user(public_id):
	user = User.query.filter_by(public_id=public_id).first()
	db.session.delete(user)
	db.session.commit()
	return jsonify({"message":"User deleted Successfully!"})

@app.route("/login", methods=["POST"])
def login():
	data = request.get_json(force=True)
	print(data)
	user = User.query.filter_by(email=data['email']).first()
	if not user:
		return jsonify({"message":"user not found"})
	if bcrypt.check_password_hash(user.password, data['password']):
		return jsonify({"message":user.public_id})
	return jsonify({"message":"password not match"})

@app.route("/customer/<public_id>", methods=["POST"])
def createcustomer(public_id):
	data = request.get_json(force=True)
	user = User.query.filter_by(public_id = public_id).first()
	if not user:
		return jsonify({"message":"User not found"})
	print(data)
	customer = Customer(first = data['first'], last = data['last'], phone=data['phone'],
				address = data['address'], landmark=data['landmark'], mobile=data['mobile'],
				aadharno = data['aadharno'], email=data['email'], appuser = user.id )
	db.session.add(customer)
	db.session.commit()
	return jsonify({"message":"Customer added "})

@app.route("/customer/<public_id>", methods=["GET"])
def get_all_customers(public_id):
	user = User.query.filter_by(public_id=public_id).first()
	if not user:
		return jsonify({"message":"User not found"})
	customers = Customer.query.filter_by(appuser = user.id).all()
	data_list =[]
	for customer in customers:
		obj ={}
		obj['id'] = customer.id
		obj['first'] = customer.first
		obj['email'] = customer.email
		data_list.append(obj)
	return jsonify({"customers":data_list})	

@app.route("/customer/<public_id>/<id>", methods=["DELETE"])
def deletecustomer(public_id,id):
	user = User.query.filter_by(public_id=public_id).first()
	if not user:
		return jsonify({"message":"User not found"})
	customer = Customer.query.filter_by(id=id).first()
	db.session.delete(customer)
	db.session.commit()
	return jsonify({"message":"Customer deleted"})


if __name__ == "__main__":
	app.run(debug = True, host="0.0.0.0")
















