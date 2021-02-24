import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta/screens/Home.dart';
import 'package:insta/screens/registration.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email, _password;

  var _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.all(10),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (item) {
                          return item.contains("@")
                              ? null
                              : "Enter Valid Email";
                        },
                        onChanged: (item) {
                          setState(() {
                            _email = item;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Email",
                            labelText: "Email",
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (item) => item.length >= 6
                            ? null
                            : "Password must be 6 characters",
                        onChanged: (item) {
                          setState(() {
                            _password = item;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            login();
                          },
                          child: Text('Login'),
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Registration()));
                            },
                            child: Text(
                              'Register Here',
                              style: TextStyle(fontSize: 15),
                            )),
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  )),
            ),
    );
  }

  void login() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "error" + onError.toString());
      });
    }
  }
}
