import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MAX_PIN_LENGTH = 7;

class CustomPinText extends StatefulWidget {
  final Color errorBorderColor;
  final Color focusBorderColor;
  final Color normalBorderColor;
  final bool isError;
  double borderWidth;
  double borderRadius;
  double paddingBetweenText = 0;
  double height;
  bool showHint;
  String hintText;
  Color cursorColor;
  double focusedBorderWidth = 2;
  Function(String pinText) onPinEntered1;

  CustomPinText(
      {Key key,
      this.pinLength,
      this.errorBorderColor,
      this.onPinEntered1,
      this.focusBorderColor,
      this.normalBorderColor,
      this.isError,
      this.borderRadius = 10.0,
      this.paddingBetweenText = 10,
      this.height = 150,
      this.hintText = "🤑",
        this.showHint=false,
      this.cursorColor = Colors.white,
      this.borderWidth = 1.0})
      : super(key: key) {
    assert(this.hintText.length>1);

  }

  final int pinLength;

  @override
  _CustomPinTextState createState() => _CustomPinTextState(this.isError);
}

class _CustomPinTextState extends State<CustomPinText> {
  List<TextEditingController> listController = [];
  List<FocusNode> focusNodes = [];
  FocusNode curr;
  int currentFocusedIndex = 0;
  List<Widget> fields = List();
  List<String> pinData = [];
  final bool isErroree;
  StreamController<int> streamFocusedContainer =
      StreamController<int>.broadcast();

  _CustomPinTextState(this.isErroree);

  @override
  Widget build(BuildContext context) => Container(
        child: generatePinItem(),
        width: MediaQuery.of(context).size.width,
      );

  Widget generatePinItem() {
    if (listController.isEmpty) {
      pinData = List<String>.generate(widget.pinLength, (i) => "");
      focusNodes =
          List<FocusNode>.generate(widget.pinLength, (i) => FocusNode());

      listController = List<TextEditingController>.generate(
          widget.pinLength, (i) => TextEditingController());

      for (int index = 0; index < widget.pinLength; ++index) {
        fields.add(
          Expanded(
            child: StreamBuilder(
              initialData: 0,
              stream: streamFocusedContainer.stream,
              builder: (context, snapshot) {
                currentFocusedIndex = snapshot.data;
                return Padding(
                  padding: EdgeInsets.all(widget.paddingBetweenText),
                  child: Container(
                    height: widget.height,
                    decoration: getDecoration(index),
                    child: Center(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: widget.showHint?widget.hintText:'',
                            counterText: "", border: InputBorder.none),
                        onTap: () {
                          if (currentFocusedIndex != index) {
                            streamFocusedContainer.add(index);
                          }
                        },
                        cursorColor: widget.cursorColor,
                        textAlign: TextAlign.center,
                        controller: listController[index],
                        focusNode: focusNodes[index],
                        maxLength: 1,
                        keyboardType: TextInputType.phone,
                        enableInteractiveSelection: false,
                        onFieldSubmitted: (term) {
                          gotoNextFocus(focusNodes[index], index, true);
                        },
                        onChanged: (text) {
                          if (text.isEmpty && index != 0) {
                            gotoNextFocus(focusNodes[index], index, false);
                          } else if (text.isNotEmpty &&
                              index != widget.pinLength) {
                            gotoNextFocus(focusNodes[index], index, true);
                          }
                        },
                        textInputAction: index == widget.pinLength - 1
                            ? TextInputAction.done
                            : TextInputAction.next,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: fields);
  }

  gotoNextFocus(FocusNode currentFocus, int currentIndex, bool isNext) {
    pinData[currentIndex] = listController[currentIndex].text.toString();
    widget.onPinEntered1(pinData.join().toString());

    focusNodes[currentIndex].unfocus(focusPrevious: false);
    int nextFocus = isNext ? currentIndex + 1 : currentIndex - 1;
    FocusScope.of(context).requestFocus(focusNodes[nextFocus]);
    curr = focusNodes[nextFocus];
    if (currentFocusedIndex != nextFocus) {
      streamFocusedContainer.add(nextFocus);
    }
  }

  BoxDecoration getDecoration(int index) {
    double borderWidth = widget.borderWidth;
    if (!isErroree && currentFocusedIndex == index) {
      borderWidth = widget.focusedBorderWidth;
    }
    return BoxDecoration(
      border: Border.all(
        width: borderWidth,
        color: getBorderColor(index),
      ),
      borderRadius: BorderRadius.all(Radius.circular(
              widget.borderRadius) //         <--- border radius here
          ),
    );
  }

  Color getBorderColor(int index) {
    if (isErroree) {
      return widget.errorBorderColor;
    } else if (currentFocusedIndex == index) {
      return widget.focusBorderColor;
    } else {
      return widget.normalBorderColor;
    }
  }

  @override
  void dispose() {
    super.dispose();
    streamFocusedContainer.close();
  }
}
