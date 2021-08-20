import 'package:flutter/material.dart';

final url = Uri.https('chat.rtirl.com', '/auth/twitch/redirect');

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: Text("MuxModem",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white))),
      const Padding(
          padding: EdgeInsets.only(bottom: 64),
          child: Text("Sign in with your Muxable account")),
      if (_isLoading)
        const CircularProgressIndicator()
      else
        Column(
          children: const [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            )
          ],
        ),
    ]);
  }
}
