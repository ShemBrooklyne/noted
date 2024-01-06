import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:noted/constants/routes.dart';
import 'package:noted/services/auth/auth_service.dart';
import 'package:noted/views/login_view.dart';
import 'package:noted/views/notes_view.dart';
import 'package:noted/views/register_view.dart';
import 'package:noted/views/verify_email_view.dart';

var logger = Logger();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotedView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                logger.i('Email is verified');
                return const NotedView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
