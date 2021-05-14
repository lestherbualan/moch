import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'dart:async';
import '../utilities/database.dart';

class SendSms extends StatefulWidget {
  @override
  _SendSmsState createState() => _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  final Telephony telephony = Telephony.instance;

  final numberController = TextEditingController();
  final textController = TextEditingController();

  String smsNumber;
  String smsText;

  bool isPaid = false;

  int isPaidBinary;

  bool getNumber(String number) {
    return '123456890'.split('').contains(number);
  }

  bool getLetter(String number) {
    return 'abcdefghijklmnopqrstuvwxyz'.split('').contains(number);
  }

  Future<dynamic> sendSms(String number, String text) async {
    var alphaRegex = new RegExp(r'[a-zA-Z]');
    var numRegex = new RegExp(r'[0-9]');

    var numChars = text.replaceAll(alphaRegex, '');
    var alphaChars = text.replaceAll(numRegex, '');

    //print("to : $number and msg: $text and Paid: $isPaid");
    telephony.sendSms(to: number, message: alphaChars + numChars);
    //Navigator.of(context).pop();

    if (isPaid) {
      isPaidBinary = 1;
    } else {
      isPaidBinary = 0;
    }

    var resp =
        DatabaseHelper.database.saveLoad(number, text, isPaidBinary, numChars);
    print(resp);
    return resp;
  }

  Future checkSMSStatus(String number, String text) async {
    bool permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted) {
      var resp = sendSms(number, text);
      return resp;
    }
  }

  getSMS() async {
    final _sms = await DatabaseHelper.database.getLoadInfo();
    print(_sms);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send Load'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: "Recipient"),
                  controller: numberController,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Input Text here"),
                  controller: textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                Text('Is this paid? '),
                Checkbox(
                  value: this.isPaid,
                  onChanged: (bool value) {
                    setState(() {
                      this.isPaid = value;
                    });
                  },
                ),
                TextButton(
                    style: TextButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () {
                      checkSMSStatus(numberController.text, textController.text)
                          .then((value) {
                        if (value) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    child: Text("Send SMS")),
                TextButton(
                    style: TextButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () {
                      getSMS();
                    },
                    child: Text("get SMS from Db")),
              ],
            ),
          )
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
