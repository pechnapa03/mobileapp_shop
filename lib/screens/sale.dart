import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

 class SalePage extends StatefulWidget {
  const SalePage({Key? key, required this.user_name}) : super(key: key);
  final String user_name;

  
  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  void initState() {
    super.initState();
    getSales();
  }

  final IP = '172.20.10.14';
  var sale_no = [];
  var sale_date = [];
  var user_name = [];
  var product_id = [];
  var sale_num = [];
  var sale_status = [];

  File? imagePath;
  String? imageName;
  String? imageData;

  ImagePicker imagePicker = new ImagePicker();

  void getSales() async {
    try {
      String url = "http://${IP}/appsale/getSales.php?user_name=${widget.user_name}";
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
          sale_no.add(value['sale_no']);
          sale_date.add(value['sale_date']);
          user_name.add(value['user_name']);
          product_id.add(value['product_id']);
          sale_num.add(value['sale_num']);
          sale_status.add(value['sale_status']);
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getImage() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imagePath = File(getImage!.path);
      imageName = getImage.path.split('/').last;
      imageData = base64Encode(imagePath!.readAsBytesSync());
    });
  }

  Future<void> uploadImage(String saleNo, String userName, String productId,
      String saleNum, String saleStatus) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://172.20.10.14/appsale/imageUpload.php'));
      request.fields.addAll({
        'sale_no': '${saleNo}',
        'sale_status': 'ชำระเงินเสร็จสิ้น',
        'image_name': '${imageName}',
        'image_data': '${imageData}',
      });
      print("${imageName}----> ${imageData}------> ${imagePath}");
      
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('อัปโหลดสำเร็จ'),
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
      } else {
        print(response.reasonPhrase);
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void _showUploadDialog(String saleNo, String userName, String productId,
      String saleNum, String saleStatus, String saleDate) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('รายละเอียดการสั่งซื้อ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ชื่อ: $userName'),
              Text('รหัสสินค้า: $productId'),
              Text('จำนวน: $saleNum'),
              Text('สถานะการสั่งซื้อ: $saleStatus'),
              Text('วัน/เวลาสั่งซื้อ: $saleDate'),
              ElevatedButton(
                onPressed: () async {
                  getImage();
                  // Implement file selection logic
                },
                child: Icon(Icons.add_a_photo),
              ),
              Flexible(
                child: Center(
                  child: imagePath != null
                      ? Image.file(imagePath!)
                      : Text(''),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  uploadImage(saleNo, userName, productId, saleNum, saleStatus);

                });
                Navigator.of(context).pop();
                // Implement file upload logic
              },
              child: Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return sale_no.isEmpty
        ? Center(
            child: Text(
              'ไม่มีรายการสั่งซื้อ',
              style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 34, 34, 34)),
            ),
          )
        : ListView.builder(
            itemCount: sale_no.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: InkWell(
                  onTap: () {
                    _showUploadDialog(
                      sale_no[index],
                      user_name[index],
                      product_id[index],
                      sale_num[index].toString(), // Convert to string
                      sale_status[index],
                      sale_date[index],
                    );
                  },
                   child: Card(
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('ชื่อ: ${user_name[index]}'),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('รหัสสินค้า: ${product_id[index]}'),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('จำนวนสินค้า: ${sale_num[index]} ชิ้น'),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('สถานะ: ${sale_status[index]}'),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('วันที่และเวลา: ${sale_date[index]}'),
                            ),
                              Container(
      padding: EdgeInsets.all(10),
      width: 330,
      height: 40,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 247, 155, 232),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Color.fromARGB(255, 247, 83, 219),
          width: 1,
        ),
      ),
        
      child: const Text(
        '>>>>>>>>>คลิกเพื่อดูรายละเอียดการสั่งซื้อ<<<<<<<<<',
        style: TextStyle(fontSize: 13),
      ),
    ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}