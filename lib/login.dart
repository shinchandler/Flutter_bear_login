import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //valid email and pass
  String validEmail = 'pranavrishi8@gmail.com';
  String validPassword = '123';

  //input form controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  //rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<double>? numLook;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD6E2EA),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: RiveAnimation.asset(
                    'assets/2244-7248-animated-login-character.riv',
                    fit: BoxFit.fitHeight,
                    stateMachines: const [
                      'Login Machine'
                    ],
                    onInit: (artboard) {
                      controller = StateMachineController.fromArtboard(artboard, 'Login Machine');
                      if (controller == null) return;

                      artboard.addController(controller!);
                      isChecking = controller?.findInput('isChecking');
                      isHandsUp = controller?.findInput('isHandsUp');
                      numLook = controller?.findInput('numLook');
                      trigSuccess = controller?.findInput('trigSuccess');
                      trigFail = controller?.findInput('trigFail');
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 300, 30, 0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
                          child: TextFormField(
                            focusNode: emailFocusNode,
                            controller: emailController,
                            onChanged: (value) {
                              numLook?.change(value.length.toDouble());
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(value)) {
                                return 'Enter valid e-mail';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(prefixIcon: const Icon(Icons.mail), label: const Text('Email'), hintText: 'Enter your e-mail', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
                          child: TextFormField(
                            focusNode: passwordFocusNode,
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(prefixIcon: const Icon(Icons.lock), label: const Text('Password'), hintText: 'Enter your Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                            onChanged: (value) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter valid password';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            emailFocusNode.unfocus();
                            passwordFocusNode.unfocus();
                            final email = emailController.text;
                            final password = passwordController.text;
                            if (_formKey.currentState!.validate()) {
                              if (email == validEmail && password == validPassword) {
                                trigSuccess?.change(true);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Logging in...'),
                                  duration: Duration(seconds: 1),
                                ));
                              } else {
                                trigFail?.change(true);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[800], fixedSize: const Size.fromWidth(250)),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20)
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
