import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_asset/qrscan.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR code asset"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Get.off(const Qrcode());
            },
            child: const Text("Scan QR code")),
      ),
    );
  }
}
