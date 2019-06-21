import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_reddit_app/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: new SizedBox(
          height: 50.0,
          width: 50.0,
          child: new CircularProgressIndicator(
            value: null,
            strokeWidth: 7.0,
          ),
        ),
      );
    } else {
      return new Scaffold(
          body: Center(
              child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(25.0),
            // color: Colors.blue[50],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 150.0,
                  width: 150.0,
                  // color: Colors.blue[50],
                  child: Image.network(
                      "http://pngriver.com/wp-content/uploads/2018/04/Download-Reddit-Free-PNG-Image.png"),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          child: RaisedButton(
                              child: Text("Signup"),
                              color: Colors.orange[800],
                              textColor: Colors.white,
                              elevation: 7.0,
                              onPressed: () {
                                Navigator.of(context).pushNamed('/signup');
                              }),
                        ),
                        RaisedButton(
                            child: Text("Login"),
                            color: Colors.blue,
                            textColor: Colors.white,
                            elevation: 7.0,
                            onPressed: () {
                              if (_email != null && _password != null) {
                                setState(() {
                                  isLoading = true;
                                });

                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: _email,
                                  password: _password,
                                )
                                    .then((FirebaseUser user) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(
                                              email: _email,
                                            )),
                                  );
                                }).catchError((e) {
                                  print(e);
                                });
                              }
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text("Forgot password ?")
                  ],
                ),
              ],
            ),
          ),
        ],
      )));
    }
  }
}
