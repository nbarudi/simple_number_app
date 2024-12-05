

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsAlert {

  static sendSettingsAlert(BuildContext context, {minNum = 1, maxNum = 50, numbersPerLine = 7, numberOfLines = 1}) {
    return showDialog(context: context, builder: (context) {
      final settings = SettingsWidget(minNum, maxNum, numbersPerLine, numberOfLines);
      return AlertDialog(
        content: settings,
        actions: [
          TextButton(onPressed: () {
            final result = {
              "min": settings.minNumCTRL.text,
              "max": settings.maxNumCTRL.text,
              "perLine": settings.numbersPerLineCTRL.text,
              "lines": settings.numberOfLinesCTRL.text
            };

            Navigator.of(context).pop(result);
          }, child: const Text("Submit"))
        ],
      );

    });
  }

}

class SettingsWidget extends StatelessWidget {

  final int minNum;
  final int maxNum;
  final int numbersPerLine;
  final int numberOfLines;

  SettingsWidget(this.minNum, this.maxNum, this.numbersPerLine, this.numberOfLines, {super.key});

  late TextEditingController minNumCTRL = TextEditingController(text: "$minNum");
  late TextEditingController maxNumCTRL = TextEditingController(text: "$maxNum");
  late TextEditingController numbersPerLineCTRL = TextEditingController(text: "$numbersPerLine");
  late TextEditingController numberOfLinesCTRL = TextEditingController(text: "$numberOfLines");

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          const Text("Generator Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          TextField(
            controller: minNumCTRL,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: "Minimum Number"
            ),
          ),
          TextField(
            controller: maxNumCTRL,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                labelText: "Maximum Number"
            ),
          ),
          TextField(
            controller: numbersPerLineCTRL,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                labelText: "Numbers Per Line"
            ),
          ),
          TextField(
            controller: numberOfLinesCTRL,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                labelText: "Number of Lines"
            ),
          )
        ],
      ),
    );
  }



}