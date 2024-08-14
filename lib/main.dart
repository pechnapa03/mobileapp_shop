import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:appshop01/shop.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController us = TextEditingController();
  TextEditingController pw = TextEditingController();
  var resultLogin = '', login = '';
  bool notShowPassword=true;

  final IP = '172.20.10.14';   //IP WIFI เราที่เชื่อม

 void checkLogin(String username, String password) async {
    try {
      String url = "http://${IP}/appsale/login.php?us=$username&pw=$password";

      print(url);
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });
      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var rsLogin = convert.jsonDecode(rs);

        setState(() {
          login = rsLogin['login'];
          if (login.contains('OK')) {
            resultLogin = 'Login ถูกต้อง';
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context)=> MenuPage(user_name: us.text)
              ));
          } else {
            resultLogin = 'Login ผิดพลาด';
          }
        });
        // print(_lsProducts?[0].title);
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }
  } //searchBusinessByGroup

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
       
      ),
      body: Container(
             
        padding: EdgeInsets.all(30),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

             CircleAvatar(
                radius: 60.0,
                child: CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('images/II.png',
                    ),
                ),
             ),

              Image.asset('images/BEAM.png', width: 190, height: 70),
 
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              
              child: TextField(
                controller: us,
                style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 87, 3, 87)),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.people, color: Color.fromARGB(255, 87, 3, 87)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                    color: Colors.black
                    )
                  ),
                hintText: 'Username',
                  
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: TextField(
                controller: pw,
                style: TextStyle(fontSize: 15),
                obscureText: notShowPassword,
          
                decoration: InputDecoration(
                  
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          notShowPassword = !notShowPassword;
                        });
                      },
                      icon: notShowPassword
                          ? Icon(Icons.visibility_off, color: Color.fromARGB(255, 87, 3, 87))
                          : Icon(Icons.visibility)),
                  border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Password',
                  
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      checkLogin(us.text, pw.text);
                    });
                  },
                  child: Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 228, 155, 229)),
                )),
            Container(
              child: Text(
                '$resultLogin',
                style: TextStyle(color: Color.fromARGB(255, 241, 46, 104), fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}