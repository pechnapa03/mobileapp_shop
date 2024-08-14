import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:appshop01/order.dart';

class OrderPage extends StatefulWidget {
  const OrderPage(
      {super.key,
      required this.user_name,
      required this.product_id,
      required this.product_name,
      required this.image_path});

  final String user_name;
  final String product_id;
  final String product_name;
  final String image_path;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController sale_num = TextEditingController();

  var sale = '';

  final IP = '172.20.10.14';

  void insertOrder(String user_name, String product_id, String sale_num) async {
    try {
      String url =
          "http://${IP}/appsale/insertOrder.php?user_name=$user_name&product_id=$product_id&sale_num=$sale_num";

      print(url);
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });
   if (response.statusCode == 200) {
        // Show alert for successful order
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('สั่งซื้อสำเร็จ'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();//กลับหน้าproduct
                      },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('สั่งซื้อไม่สำเร็จ'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  } //getProduct

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('ป้อนจำนวนที่ต้องการซื้อ'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Image.network(
                '${widget.image_path}',
                width: 100,
                height: 100,
              ),
            ),
            Container(
                padding: EdgeInsets.all(20),
                child: Text(
                    'รหัสสินค้า: ${widget.product_id} (${widget.product_name})')),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: sale_num,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ป้อนจำนวนสินค้า',
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      insertOrder(
                          widget.user_name, widget.product_id, sale_num.text);
                    });
                  },
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 248, 155, 250)),
                )),
          ],
        ),
      ),
    );
  }
}
