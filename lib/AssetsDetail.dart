import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_asset/qrscan.dart';

class Itemdetail extends StatefulWidget {
  const Itemdetail({
    Key? key,
    required this.dataItem,
  }) : super(key: key);
  final List dataItem;

  @override
  State<Itemdetail> createState() => _ItemdetailState();
}

class _ItemdetailState extends State<Itemdetail> {
  TextEditingController tclocaltion = TextEditingController();
  TextEditingController tcRoom = TextEditingController();
  int? statusItem;

  void setdata() {
    statusItem = widget.dataItem[0]['Status'];
    tclocaltion.text = widget.dataItem[0]['Location'];
    tcRoom.text = widget.dataItem[0]['Room'];
  }

  void update() async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Loading',
      content: const CircularProgressIndicator(),
    );
    final String _url = dotenv.env['ngrok']! + '/updateData';
    Response response = await GetConnect().post(_url, {
      "emailCommittee": "ksm_punn@hotmail.com",
      "Inventory_Number": widget.dataItem[0]['Inventory_Number'],
      "year": widget.dataItem[0]['Year'],
      "localtion": tclocaltion.text,
      "room": tcRoom.text,
      "status": statusItem,
      "dateScan": formattedDate
    });
    if (response.status.isOk) {
      Get.back();
      Get.defaultDialog(
        barrierDismissible: false,
        title: 'Success',
        middleText: "Asset checked!",
        onConfirm: () {
          Get.back();
          Get.off(() => const Qrcode());
        },
      );
    } else {
      Get.back();
      Get.defaultDialog(
        title: "Try again!",
        content: Text(response.body),
      );
      throw Exception('Error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.off(const Qrcode());
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Asset Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Inventory number: "),
            Text(
              widget.dataItem[0]['Inventory_Number'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.dataItem[0]['Asset_Description'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: tclocaltion,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Building',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: tcRoom,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Room',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                    value: 0,
                    groupValue: statusItem,
                    onChanged: widget.dataItem[0]['status_scan'] == 0
                        ? (value) {
                            setState(() {
                              statusItem = value as int;
                            });
                          }
                        : null),
                Text('Lost',
                    style: TextStyle(
                      color: widget.dataItem[0]['status_scan'] == 0
                          ? Colors.black
                          : Colors.grey,
                    )),
                Radio(
                    value: 1,
                    groupValue: statusItem,
                    onChanged: widget.dataItem[0]['status_scan'] == 0
                        ? (value) {
                            setState(() {
                              statusItem = value as int;
                            });
                          }
                        : null),
                Text("Normal",
                    style: TextStyle(
                      color: widget.dataItem[0]['status_scan'] == 0
                          ? Colors.black
                          : Colors.grey,
                    )),
                Radio(
                    value: 2,
                    groupValue: statusItem,
                    onChanged: widget.dataItem[0]['status_scan'] == 0
                        ? (value) {
                            setState(() {
                              statusItem = value as int;
                            });
                          }
                        : null),
                Text(
                  "Degraded",
                  style: TextStyle(
                    color: widget.dataItem[0]['status_scan'] == 0
                        ? Colors.black
                        : Colors.grey,
                  ),
                )
              ],
            ),
            widget.dataItem[0]['status_scan'] == 0
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: update,
                    child: const Text(
                      "Check",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                : const Text('The asset is checked'),
          ],
        ),
      ),
    );
  }
}
