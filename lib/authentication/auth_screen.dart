import 'package:flutter/material.dart';
import 'package:seller_app/authentication/login.dart';
import 'package:seller_app/authentication/register.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(

            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.yellow
                  ]
                ),
              ),
            ),
            automaticallyImplyLeading:false ,
            title: Text(
                "Hunger Up",
              style:TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: "Lobster"
              ) ,
            ),
            centerTitle: true,
            bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.lock, color: Colors.indigoAccent),
                    text: "LOGIN"
                        ),
                  Tab(
                    icon: Icon(Icons.lock, color: Colors.indigoAccent),
                    text: "REGISTER",
                  ),
                ]),
          ),

          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                  0.9
                ],
                colors: [
                  Colors.yellow,
                  Colors.red,
                  Colors.indigo,
                  Colors.teal
                ],

              ),
            ),
            child: const TabBarView(
              children: [
                LoginScreen(),
                RegisterScreen()
              ],
            ),
          ),

    ));
  }
}
