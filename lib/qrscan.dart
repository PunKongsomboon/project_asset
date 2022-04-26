import 'package:flutter/material.dart';
import 'package:project_asset/AssetsDetail.dart';
import 'package:project_asset/home.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Qrcode extends StatefulWidget {
  const Qrcode({Key? key}) : super(key: key);

  @override
  State<Qrcode> createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {
  Result? currentResult;
  bool startScan = true;

  void getData() async {
    setState(() {
      startScan = false;
    });
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Loading',
      content: const CircularProgressIndicator(),
    );
    final String _url = dotenv.env['ngrok']! + '/calldata';
    Response response =
        await GetConnect().post(_url, {'AssetNumber': currentResult?.text});
    if (response.status.isOk) {
      Get.back();
      List result = response.body;
      if (result.isEmpty) {
        Get.defaultDialog(
          middleText: "Asset not find!",
          onConfirm: () {
            setState(() {
              Get.back();
              Get.back();
              startScan = true;
            });
          },
        );
      } else {
        setState(() {
          startScan = true;
          Get.off(() => Itemdetail(dataItem: result));
        });
      }
    } else {
      Get.back();
      Get.defaultDialog(
        title: "Try again!",
        content: const Text('Database error'),
      );
      throw Exception('Error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.off(const Home());
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('QR code scan'),
      ),
      body: startScan
          ? QRCodeDartScanView(
              scanInvertedQRCode: true,
              onCapture: (Result result) {
                setState(() {
                  currentResult = result;
                  getData();
                });
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Text: ${currentResult?.text ?? 'Not found'}'),
                      Text(
                          'Format: ${currentResult?.barcodeFormat ?? 'Not found'}'),
                    ],
                  ),
                ),
              ))
          : Container(),
    );
  }
}
