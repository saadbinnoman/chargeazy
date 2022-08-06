import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vehicle/Dimes.dart';
import 'package:vehicle/Screens/ForgotPswScreen.dart';
import 'package:vehicle/Screens/HomeScreen.dart';
import 'package:vehicle/Screens/SignupScreen.dart';
import 'package:vehicle/Widget/Widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  late String email, password;
  String errorMessage = '';
  bool isLoading = false;

  final _scaffoldkey = GlobalKey<FormState>();
  bool isChecked = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _scaffoldkey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spaceheight50,

                  Align(
                    alignment: Alignment.topLeft,
                    child: BoldText(
                      text: 'Welcome Back',
                      fsize: 24.sp,
                      fweight: FontWeight.w600,
                    ),
                  ),

                  Spaceheight15,

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
                    height: 10.h,
                  ),

                  TextFormField(
                    obscureText: true,
                    //   controller:passwordController,
                    onChanged: (value) {
                      password = value; //get the value entered by user.
                    },
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null) {
                        return "password is mandatory";
                      } else if (value != password) {
                        return "Wrong Password";
                      }
                    },
                    decoration: const InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: "Password",
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPswScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NormalText(
                          text: 'Forgot Password?',
                          fsize: 13,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 37.h,
                  ),

                  InkWell(
                    onTap: () async {
                      if (_scaffoldkey.currentState!.validate()) {
                        setState(() {
                          showProgress = true;
                        });
                        try {
                          final newUser =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(newUser.toString());
                          if (newUser != null) {
                            debugPrint("Pressed");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>HomeScreen()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login Successfull"),
                              ),
                            );


                            setState(() {
                              showProgress = false;
                            });
                          }
                        } on FirebaseAuthException catch (error) {
                          errorMessage = error.message!;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid Credential"),
                            ),
                          );
                        }
                        setState(() => isLoading = false);
                      }
                    },
                    child: BigButton(text: "Login"),
                  ),

                  Spaceheight30,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoldText(
                          text: "Don't have a account?",
                          fsize: 13.sp,
                          fweight: FontWeight.w600),
                      Spacewidth5,
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BoldText(
                                text: "Register",
                                fsize: 13.sp,
                                fweight: FontWeight.w600,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spaceheight20,
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text('Skip'),
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
