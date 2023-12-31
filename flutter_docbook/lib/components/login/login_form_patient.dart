import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_docbook/components/button.dart';
import 'package:flutter_docbook/components/snackBar.dart';
import 'package:flutter_docbook/providers/dio_provider.dart';
import 'package:flutter_docbook/utils/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../models/auth_model.dart';

class LoginFormPatient extends StatefulWidget {
  const LoginFormPatient({super.key});

  @override
  State<LoginFormPatient> createState() => _LoginFormPatientState();
}

class _LoginFormPatientState extends State<LoginFormPatient> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obsecurePass = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              filled: true,
              fillColor: Color.fromRGBO(206, 222, 239, 1),
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            validator: (value) {
              if (value == '') {
                return 'email field is required';
              } else {
                return null;
              }
            },
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              filled: true,
              fillColor: const Color.fromRGBO(206, 222, 239, 1),
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.lock_outlined),
              prefixIconColor: Config.primaryColor,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obsecurePass = !obsecurePass;
                  });
                },
                icon: obsecurePass
                    ? const Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.black38,
                      )
                    : const Icon(
                        Icons.visibility_outlined,
                        color: Config.primaryColor,
                      ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            validator: (value) {
              if (value == '') {
                return "password field is required";
              } else {
                return null;
              }
            },
          ),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('register');
                },
                child: Text(
                  textAlign: TextAlign.left,
                  'Don\'t have an account?',
                  style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          // Config.spaceSmall,
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: isLoading ? 'Please wait' : 'Sign In',
                disable: isLoading ? true : false,
                color: Config.primaryColor,
                backgroundColor: const Color.fromRGBO(239, 247, 255, 1),
                borderRadius: BorderRadius.circular(0),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    final token = await DioProvider().getTokenPatient(
                        _emailController.text, _passwordController.text);
                    if (token) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final tokenValue = prefs.getString('token') ?? '';
                      if (tokenValue.isNotEmpty && tokenValue != '') {
                        //get user data
                        final response =
                            await DioProvider().getUserPatient(tokenValue);
                        if (response != null) {
                          setState(() {
                            final user = json.decode(response);

                            auth.loginSuccess(user, tokenValue);
                          });
                          MyApp.navigatorKey.currentState!
                              .pushNamed('main_patient');
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      snackBar(
                          context,
                          'Incorrect email or password',
                          const Color.fromRGBO(244, 67, 54, 1),
                          const Duration(seconds: 4));
                    }
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}
