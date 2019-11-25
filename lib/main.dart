import 'dart:ffi';

import 'package:flutter/material.dart';
import "dart:async";
import 'package:http/http.dart' as http;
import 'dart:convert';

String public_id = "";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.blue
        primaryColor: Color.fromRGBO(15, 30, 52, 1),
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailid = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  void _LoginUser() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = "http://192.168.0.105:5000/login";
    try {
      String json =
          '{"email":"${_emailid.text}","password":"${_password.text}"}';
      http.Response response =
          await http.post(url, headers: headers, body: json);
      // int statusCode = response.statusCode;
      var body = response.body;
      print(body.substring(16, 52));
      public_id = body.substring(16, 52);
      if (body.contains("password")) {
        _showDialog("Login Failed", "Check your email and Password");
        print("Failed");
      } else {
        // _showDialog("Login Successfully","You can login now and manage your customers record.");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        print("success");
      }
    } catch (Exception) {
      print("someting went wrong");
    }
  }

  void _showDialog(String title, String content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Login"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  BoxDecoration myFieldDecoration = BoxDecoration(
    border: Border.all(color: Colors.transparent),
    borderRadius: BorderRadius.all(Radius.circular(50)),
    color: Color.fromRGBO(255, 255, 255, 0.2),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            "images/mountbackground.jpg",
            fit: BoxFit.fitWidth,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.0,
                    0.4,
                    1
                  ],
                  colors: [
                    Color.fromRGBO(18, 57, 78, 0.2),
                    Color.fromRGBO(8, 62, 92, 0.7),
                    Color.fromRGBO(15, 30, 52, 1)
                  ]),
            ),
            child: SafeArea(
              child: ListView(
                children: <Widget>[
                  Text(
                    "Customer",
                    style: TextStyle(fontSize: 55, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Management",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.person_outline,
                    color: Colors.grey[200],
                    size: MediaQuery.of(context).size.width / 2,
                  ),
                  Text(
                    "Login ",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: myFieldDecoration,
                    child: TextFormField(
                      controller: _emailid,
                      decoration: InputDecoration(
                        hintText: "Email ID",
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: myFieldDecoration,
                    child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: validateLoign,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 42,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightBlueAccent[400],
                            Color.fromRGBO(18, 72, 102, 1),
                          ],
                        ),
                      ),
                      child: Text(
                        'LogIn',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                                color: Colors.black,
                                offset: Offset.fromDirection(0.5))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("tap");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: Text(
                      "Don't Have an Account? ",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateLoign() {
    print(_emailid.text);
    print(_password.text);
    _LoginUser();
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstname = new TextEditingController();
  final TextEditingController _lastname = new TextEditingController();
  final TextEditingController _emailid = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _confirmpassword = new TextEditingController();
  final TextEditingController _shopname = new TextEditingController();

  void _CreateUser() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = "http://192.168.0.105:5000/user";
    try {
      String json =
          '{"first":"${_firstname.text}","last":"${_lastname.text}","email":"${_emailid.text}","password":"${_password.text}", "shopname":"${_shopname.text}"}';
      http.Response response =
          await http.post(url, headers: headers, body: json);
      // int statusCode = response.statusCode;
      var body = response.body;
      print(body);
      if (body.contains("success")) {
        _showDialog("Registered Successfully",
            "You can login now and manage your customers record.");
        print("success");
      } else {
        _showDialog(
            "Registered Failed", "User with this email id is already exist.");
        print("success");
      }
    } catch (Exception) {
      print("someting went wrong");
    }
  }

  void _showDialog(String title, String content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Login"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  BoxDecoration myFieldDecoration = BoxDecoration(
    border: Border.all(color: Colors.transparent),
    borderRadius: BorderRadius.all(Radius.circular(50)),
    color: Color.fromRGBO(255, 255, 255, 0.2),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            "images/mountbackground.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.0,
                    0.4,
                    1
                  ],
                  colors: [
                    Color.fromRGBO(18, 57, 78, 0.2),
                    Color.fromRGBO(8, 62, 92, 0.7),
                    Color.fromRGBO(15, 30, 52, 1)
                  ]),
            ),
            child: SafeArea(
              child: ListView(
                children: <Widget>[
                  Text(
                    "Customer",
                    style: TextStyle(fontSize: 55, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Management",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.person_outline,
                    color: Colors.grey[200],
                    size: MediaQuery.of(context).size.width / 2,
                  ),
                  Text(
                    "Register",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: myFieldDecoration,
                            child: TextFormField(
                              controller: _firstname,
                              decoration: InputDecoration(
                                hintText: "First Name",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: myFieldDecoration,
                            child: TextFormField(
                              controller: _lastname,
                              decoration: InputDecoration(
                                hintText: "Last Name",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: myFieldDecoration,
                    child: TextFormField(
                      controller: _shopname,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        hintText: "Shop Name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: myFieldDecoration,
                    child: TextFormField(
                      controller: _emailid,
                      decoration: InputDecoration(
                        hintText: "Email ID",
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: myFieldDecoration,
                    child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: myFieldDecoration,
                    child: TextFormField(
                      controller: _confirmpassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: registerUser,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 42,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightBlueAccent[400],
                            Color.fromRGBO(18, 72, 102, 1),
                          ],
                        ),
                      ),
                      child: Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                                color: Colors.black,
                                offset: Offset.fromDirection(0.5))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("tap");
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Already Have an Account? ",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void registerUser() {
    print("${_firstname.text}");
    print(_password.text);
    print(_confirmpassword.text);
    if (_password.text == _confirmpassword.text) {
      _CreateUser();
    } else {
      print("password does not match");
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<LCustomer>> _get_local_customer() async {
    var data = await http.get("http://192.168.0.105:5000/customer/$public_id");
    var jsonData = json.decode(data.body);
    List<LCustomer> customers = [];
    for (var c in jsonData["customers"]) {
      LCustomer customer = LCustomer(c["id"], c["first"], c["email"]);
      customers.add(customer);
      print(c["first"]);
    }
    return customers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateCustomer()));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("All customers"),
        ),
        body: Container(
          child: FutureBuilder(
            future: _get_local_customer(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(),
                      title: Text(snapshot.data[index].first),
                      subtitle: Text(snapshot.data[index].email),
                      trailing: Text(snapshot.data[index].id.toString()),
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class CreateCustomer extends StatefulWidget {
  @override
  _CreateCustomerState createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomer> {
  final TextEditingController _firstname = new TextEditingController();
  final TextEditingController _lastname = new TextEditingController();
  final TextEditingController _mobile = new TextEditingController();
  final TextEditingController _address = new TextEditingController();
  final TextEditingController _landmark = new TextEditingController();
  final TextEditingController _phoneno = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _aadharno = new TextEditingController();

  void _CreateUser() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String url = "http://192.168.0.105:5000/customer/${public_id}";
    try {
      String json =
          '{"first":"${_firstname.text}","last":"${_lastname.text}","email":"${_email.text}", "phone":"${_phoneno.text}","address":"${_address.text}", "landmark":"${_landmark.text}","mobile":"${_mobile.text}","aadharno":"${_aadharno.text}"}';
        print(json);
      http.Response response =
          await http.post(url, headers: headers, body: json);
      // int statusCode = response.statusCode;
      var body = response.body;
      print(body);
      if (body.contains("added")) {
        _showDialog("Creaded",
            "Customer added Successfully");
        print("success");
      } else {
        _showDialog(
            "Failed", "Something went wrong! please try again.");
        print("failed");
      }
    } catch (Exception) {
      print("someting went wrong");
    }
  }

  void _showDialog(String title, String content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Go Back"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Customers"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "First Name"),
                    controller: _firstname,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Last Name"),
                    controller: _lastname,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Mobile no"),
              controller: _mobile,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Address"),
              controller: _address,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Landmark"),
              controller: _landmark,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Email"),
              controller: _email,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Aadhar no"),
              controller: _aadharno,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Phone no"),
              controller: _phoneno,
            ),
            
            SizedBox(height: 20),
            RaisedButton(
              onPressed: _addCustomer,
              child: Text("Add Customer", style: TextStyle(fontSize: 18)),
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _addCustomer(){
    print(_aadharno.text);
    _CreateUser();
  }

}

class LCustomer {
  final int id;
  final String first;
  final String email;
  LCustomer(this.id, this.first, this.email);
}

class Customer {
  final int id;
  final String first;
  final String last;
  final String mobile;
  final String address;
  final String landmark;
  final String email;
  final String aadharno;
  final String phoneno;
  Customer(this.id, this.first, this.last, this.mobile, this.address, this.landmark, this.email, this.aadharno, this.phoneno);
}
