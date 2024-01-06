import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:noted/constants/routes.dart';
import 'package:noted/enums/menu_action.dart';
import 'package:noted/services/auth/auth_service.dart';
import 'package:noted/utilities/show_logout_dialog.dart';

var logger = Logger();

class NotedView extends StatefulWidget {
  const NotedView({super.key});

  @override
  State<NotedView> createState() => _NotedViewState();
}

class _NotedViewState extends State<NotedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noted'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.signout:
                final shouldLogout = await showLogOutDialog(context);
                logger.d(shouldLogout.toString());
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                }
                break;
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.signout,
                child: Text('Sign out'),
              )
            ];
          })
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}
