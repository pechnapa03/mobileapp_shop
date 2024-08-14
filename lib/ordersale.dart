import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class OrderSale extends StatefulWidget {
  const OrderSale({
    super.key,
    required this.sale_no,
    required this.sale_date,
    required this.user_name,
    required this.product_id,
    required this.sale_num,
    required this.sale_status,
    required this.image_slip,
  });

  final int sale_no;
  final DateTime sale_date;
  final String user_name;
  final String product_id;
  final int sale_num;
  final String sale_status;
  final String image_slip;

  @override
  State<OrderSale> createState() => _SaleState();
}

class _SaleState extends State<OrderSale> {
  TextEditingController sale_num = TextEditingController();

  var sale = '';

  final IP = '172.20.10.14';

  void ordersale(
      int sale_no,
      DateTime sale_date,
      String user_name,
      String product_id,
      int sale_num,
      String sale_status,
      String image_slip) async {
    try {
      String url =
          "http://${IP}/appsale/getSale.php?user_name=$user_name&product_id=$product_id&sale_num=$sale_num";

      print(url);
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });
      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var rsInsert = convert.jsonDecode(rs);


        setState(() {
          sale = rsInsert['sale'];
          if (sale.contains('OK')) {
           
            //alert สั่งซื้อสำเร็จ
          } else {
            //alert มีข้อผิดพลาด
          }
          Navigator.pop(context);
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }
  } //getProduct

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.show_chart),
        title: Text('ป้อนจำนวนที่ต้องการซื้อ'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Image.network(
                '${widget.image_slip}',
                width: 100,
                height: 100,
              ),
            ),
            Container(
                padding: EdgeInsets.all(20),
                child: Text(
                    'รหัสสินค้า: ${widget.product_id} (${widget.user_name})')),
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
                      ordersale(
                          widget.sale_no,
                          widget.sale_date,
                          widget.user_name,
                          widget.product_id,
                          widget.sale_num,
                          widget.sale_status,
                          widget.image_slip);
                    });
                  },
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 228, 155, 229)),
                )),
          ],
        ),
      ),
    );
  }
}
