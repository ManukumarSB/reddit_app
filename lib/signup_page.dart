import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_reddit_app/services/user_management.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _firstName;
  String _phoneNumber;
  File sampleImage;
  String _path;
  bool isLoading = false;

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  final TextEditingController _confirmPassController =
      new TextEditingController();

  Future getImage(var imagesource) async {
    var tempImage = await ImagePicker.pickImage(source: imagesource);

    setState(() {
      sampleImage = tempImage;
    });
  }

  Future<Null> uploadProfile() async {}

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
              color: Colors.grey[50],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      iconSize: 40.0,
                                      onPressed: () {
                                        getImage(ImageSource.camera);

                                        Navigator.pop(context);
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.image),
                                      iconSize: 40.0,
                                      onPressed: () {
                                        getImage(ImageSource.gallery);

                                        Navigator.pop(context);
                                      })
                                ]));
                          });
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      alignment: FractionalOffset.center,
                      decoration: new BoxDecoration(
                        color: const Color.fromRGBO(247, 64, 106, 1.0),
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(50.0)),
                      ),
                      child: sampleImage == null
                          ? new Text(
                              "Add photo",
                              style: new TextStyle(
                                color: Colors.amber,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.3,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(50.0))),
                              child: Image.file(sampleImage)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'First name',
                        labelText: "First name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    onChanged: (value) {
                      setState(() {
                        _firstName = value;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Phone',
                        labelText: "Phone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    onChanged: (value) {
                      setState(() {
                        _phoneNumber = value;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  TextField(
                    controller: _passController,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    obscureText: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  TextField(
                    controller: _confirmPassController,
                    decoration: InputDecoration(
                        hintText: 'Re-enter password',
                        labelText: "Re-enter password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    obscureText: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Back"),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 7.0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      RaisedButton(
                        child: Text("Signup"),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 7.0,
                        onPressed: () async {
                          var _email = _emailController.text;
                          var _password = _passController.text;
                          var _confirmPass = _confirmPassController.text;
                          if (_confirmPass != _password) {
                            AlertDialog dialog = new AlertDialog(
                              title: new Text("Passwords didn't match"),
                              actions: <Widget>[
                                new FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'))
                              ],
                            );
                            showDialog(context: context, child: dialog);
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });

                          final StorageReference ref = FirebaseStorage.instance
                              .ref()
                              .child("${Random().nextInt(10000)}.jpg");

                          StorageUploadTask uploadTask =
                              ref.putFile(sampleImage);

                          StorageTaskSnapshot storageTaskSnapshot =
                              await uploadTask.onComplete;

                          String downloadUrl =
                              await storageTaskSnapshot.ref.getDownloadURL();
                          _path = downloadUrl.toString();
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _email, password: _password)
                              .then((signedInUser) {
                            UserManagement().storeNewUser(_firstName,
                                _phoneNumber, signedInUser, _path, context);
                          }).catchError((e) {
                            print(e);
                          });

                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                    ],
                  )
                ],
              )),
        ],
      )));
    }
  }
}