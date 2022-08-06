import 'package:flutter/material.dart';
import 'package:vehicle/Screens/LoginScreen.dart';
import 'package:vehicle/Widget/Widgets.dart';

import '../Dimes.dart';
import '../Utils/Colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  late String email, password, confirm, username;

  final _scaffoldkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Form(
          key: _scaffoldkey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spaceheight30,

                  Align(
                    alignment: Alignment.topLeft,
                    child: BoldText(
                        text: 'Register',
                        fsize: 24.sp,
                        fweight: FontWeight.w600),
                  ),
                  Spaceheight15,
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'User name is mandatory';
                      }
                    },
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: "UserName",
                    ),
                  ),
                  Spaceheight10,
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      email = value; // get value from TextField
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'email is required';
                      }

                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please enter a valid email address";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: "Email Id",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    //   controller:passwordController,
                    onChanged: (value) {
                      password = value; //get the value entered by user.
                    },
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "password is mandatory";
                      } else if (value == null || value.length < 8) {
                        return "Password must be 8 digit";
                      }
                    },
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: "Password",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    //   controller:passwordController,
                    onChanged: (value) {
                      confirm = value; //get the value entered by user.
                    },
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null) {
                        return "Confirm password is mandatory";
                      } else if (value != password) {
                        return "Not Match";
                      }
                    },
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: "Confirm Password",
                    ),
                  ),
                  Spaceheight30,
                  InkWell(
                    onTap: () async {
                      if (_scaffoldkey.currentState!.validate()) {
                        setState(() {
                          showProgress = true;
                        });
                        try {
                          final newuser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newuser != null) {
                            debugPrint("Button Pressed");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text('Signup Successfull')));
                            setState(() {
                              showProgress = false;
                            });
                          }
                        } catch (e) {}
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Fill All Required Details")));
                      }
                    },
                    child: BigButton(text: "Register"),
                  ),
                  Spaceheight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoldText(
                          text: "Already have an account",
                          fsize: 13.sp,
                          fweight: FontWeight.w500),
                      Spacewidth5,
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BoldText(
                                text: "Login Now",
                                fsize: 15.sp,
                                fweight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Image.asset(
        "assets/images/img.png",
      ),
    );
  }
}
