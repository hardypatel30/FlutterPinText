import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MAX_PIN_LENGTH = 5;

class CustomPinText extends StatefulWidget {
  final Color errorBorderColor;
  final Color focusBorderColor;
  final Color normalBorderColor;
  final bool isError;
  Function(String pinText) onPinEntered1;

  CustomPinText(
      {Key key,
      this.pinLength,
      this.errorBorderColor,
      this.onPinEntered1,
      this.focusBorderColor,
      this.normalBorderColor,
      this.isError})
      : super(key: key) {
    print(' initState called  constructor' + isError.toString());
  }

  final int pinLength;

  @override
  _CustomPinTextState createState() {
    print(' initState called  createState ' + isError.toString());
    return _CustomPinTextState(this.isError);
  }
}

class _CustomPinTextState extends State<CustomPinText> {
  List<TextEditingController> listController = [];
  List<FocusNode> focusNodes = [];
  FocusNode curr;
  List<Widget> fields = List();
  List<String> pinData = [];
  final bool isErroree;

  _CustomPinTextState(this.isErroree);

  @override
  void initState() {
    print(' initState called  widget' + widget.isError.toString());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(CustomPinText oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => Container(
        child: generatePinItem(),
        width: MediaQuery.of(context).size.width,
      );

  Widget generatePinItem() {
    if (listController.isEmpty) {
      listController = List<TextEditingController>.generate(
          widget.pinLength, (i) => TextEditingController());

      pinData = List<String>.generate(widget.pinLength, (i) => "");
      focusNodes =
          List<FocusNode>.generate(widget.pinLength, (i) => FocusNode());

      for (int index = 0; index < widget.pinLength; ++index) {
        fields.add(
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 120,
                child: Center(
                  child: TextFormField(
                    decoration: InputDecoration(
                      counterText: "",
                      errorText: this.isErroree ? '' : null,
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 3, color: widget.focusBorderColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1, color: widget.normalBorderColor)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 3, color: widget.focusBorderColor),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 2, color: widget.errorBorderColor)),
                    ),
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
                      } else if (text.isNotEmpty && index != widget.pinLength) {
                        gotoNextFocus(focusNodes[index], index, true);
                      }
                    },
                    textInputAction: index == widget.pinLength - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                  ),
                ),
              ),
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
  }
}
