import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/customPinText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  String errorMessage;
  StreamController<bool> streamError = StreamController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            inputFormatters: [
              MultiMaskedTextInputFormatter(
                  masks: ['xxx-xxxx-xxxxxxx-x'], separator: '-')
            ],
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'PhoneNumber', hintText: '000-0000-000000-0'),
          ),
          StreamBuilder(
            initialData: false,
            stream: streamError.stream,
            builder: (context, snapshot) {
              print(' initState called  snapSHot' + snapshot.data.toString());
              return Expanded(
                child: CustomPinText(
                  pinLength: 4,
                  errorBorderColor: Colors.red,
                  focusBorderColor: Colors.green,
                  normalBorderColor: Colors.black,
                  onPinEntered1: onPinEntered2,
                  isError: snapshot.data,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onPinEntered2(String pinText) {
    if (pinText.length == 4 && pinText != "1234") {
      hasError = true;
      streamError.add(true);
    } else {
      hasError = false;
      streamError.add(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    streamError.close();
  }
}
