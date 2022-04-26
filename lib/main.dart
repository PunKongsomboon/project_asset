import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:project_asset/AssetsDetail.dart';
import 'package:project_asset/home.dart';
import 'package:project_asset/qrscan.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}
