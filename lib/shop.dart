import 'package:appshop01/main.dart';
import 'package:flutter/material.dart';
import 'package:appshop01/screens/product.dart';
import 'package:appshop01/screens/sale.dart';
import 'package:appshop01/screens/slip.dart';



class ShopPage extends StatelessWidget {
  const ShopPage({Key? key});
   
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: MenuPage(user_name: ''),
    );
  }
}

class MenuPage extends StatefulWidget {
  final String user_name;

  const MenuPage({Key? key, required this.user_name}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<Widget> menu;
  int index = 0;

  @override
  void initState() {
    super.initState();
    menu = [
      Product(user_name: widget.user_name),
      SalePage(user_name: widget.user_name),
      Slip(user_name: widget.user_name),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text('รายการอาหารและเครื่องดื่ม🍻',style: TextStyle( fontFamily: 'BE',fontSize: 17,
               color: Color.fromARGB(255, 0, 0, 0),
              ),),
               backgroundColor: Color.fromARGB(255, 255, 255, 255),
          
        
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Profile'), //icon name
                  value: 'profile',
                ),
               
                // PopupMenuItem(
                //   child: Text('Logout'),
                //   value: 'logout',
                // ),
              ];
            },
            onSelected: (String value) {
              // Handle menu item selection here
              print('Selected menu item: $value');
            },
            child: IconButton(
              icon: Icon(Icons.account_circle, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 100, 0, 0),
                  items: [
                    PopupMenuItem(
                      child: Text('ชื่อผู้ใช้งาน ${widget.user_name}'),
                      
                    
                    ),
                  //    PopupMenuItem(
                  // child: Text('Logout'),),
                       
                  ],
                );
              },
            ),
          ),
           
        ],
      ),
      
      body: menu[index],
      backgroundColor: Color.fromARGB(255, 255, 183, 230),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 87, 3, 87),
        unselectedItemColor: Color.fromARGB(255, 253, 87, 206),
        // backgroundColor: Color.fromARGB(255, 189, 83, 191),
        
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'สินค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sailing),
            label: 'สั่งซื้อ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'ชำระ',
          ),
        ],
      ),
    );
  }
}