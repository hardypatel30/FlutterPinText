import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const MAX_PIN_LENGTH = 5;

class CustomPinText extends StatefulWidget {
  final Color errorBorderColor;
  final  onPinEntered;

  CustomPinText({Key key, this.pinLength, this.errorBorderColor,    this.onPinEntered})
      : super(key: key);

  final int pinLength;

  @override
  _CustomPinTextState createState() => _CustomPinTextState();
}

class _CustomPinTextState extends State<CustomPinText> {
  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";

  bool hasError = false;
  String errorMessage;

  List<TextEditingController> listController = [];
  List<FocusNode> focusNodes = [];
  FocusNode curr;
  List<Widget> fields = List();
  List<String> pinData = [];

  Widget generatePinItem() {
    if (listController.isEmpty) {
      listController = List<TextEditingController>.generate(
          widget.pinLength, (i) => TextEditingController(text: " "));
      focusNodes =
          List<FocusNode>.generate(widget.pinLength, (i) => FocusNode());

      for (int index = 0; index < widget.pinLength; ++index) {
        print("Focus Assigned :: " + index.toString());
        fields.add(
          Expanded(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 2.0)),
              child: Center(
                child: TextFormField(
                  decoration: InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  textAlign: TextAlign.center,
                  focusNode: focusNodes[index],
                  maxLength: 1,
                  enableInteractiveSelection: false,
                  onFieldSubmitted: (term) {
                    print('submitCalled');
                    gotoNextFocus(focusNodes[index], index, true);
                  },
                  onChanged: (text) {
                    pinData[index] = text;
                    if (text.isEmpty && index != 0) {
                      gotoNextFocus(focusNodes[index], index, false);
                    } else if (!text.isEmpty && index != widget.pinLength) {
                      widget.onPinEntered(pinData.join().trim());
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
        );
      }
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: fields);
  }

  gotoNextFocus(FocusNode currentFocus, int currentIndex, bool isNext) {
    focusNodes[currentIndex].unfocus(focusPrevious: false);

    int nextFocus = isNext ? currentIndex + 1 : currentIndex - 1;

    FocusScope.of(context).requestFocus(focusNodes[nextFocus]);
    curr = focusNodes[nextFocus];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Focus Build Called');
    return generatePinItem();
  }
}
