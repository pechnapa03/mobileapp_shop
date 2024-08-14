import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:appshop01/order.dart';

class Product extends StatefulWidget {
  const Product({super.key, required this.user_name});
  final String user_name;



  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {

  final IP = '172.20.10.14';
  // var user_name = [];
  var product_id = [];
  var product_name = [];
  var product_price = [];
  var image_path = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }

  void getProduct() async {
    try {
      String url = "http://${IP}/appsale/getProduct.php";

      print(url);
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });
      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var product = convert.jsonDecode(rs);

        setState(() {});

        product.forEach((value) {
          product_id.add(value['product_id']);
          product_name.add(value['product_name']);
          product_price.add(value['product_price']);
          image_path.add(value['image_path']);
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
    return GridView.builder(
      itemCount: product_id.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2)),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkWell(
            onTap: () {
             Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(
                        user_name: widget.user_name,
                        product_id: product_id[index].toString(),
                        product_name: product_name[index].toString(),
                        image_path:
                            'http://${IP}/appsale/images/${image_path[index].toString()}'),
                  ));
            }, //foodImage: foodImages[index]
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.network(
                  'http://${IP}/appsale/images/${image_path[index].toString()}',
                  height: 50,
                  width: 50,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        product_name[index].toString(),
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'ราคา ${product_price[index].toString()} บาท',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}