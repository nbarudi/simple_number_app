import 'package:flutter/material.dart';
import 'package:lottogenerator/helpers/numbergen.dart';
import 'package:lottogenerator/helpers/themes.dart';
import 'package:lottogenerator/views/SettingsAlert.dart';
import 'package:lottogenerator/widgets/SpinnerWidget.dart';

class GameViewPage extends StatefulWidget {
  GameViewPage({super.key});

  @override
  State<StatefulWidget> createState() => _GameViewPageState();
}

class _GameViewPageState extends State<GameViewPage> {
  int minNum = 1;
  int maxNum = 50;
  int numbersPerLine = 7;
  int numberOfLines = 1;

  List<List<SpinnerWidget>> spinners = [];
  SpecialNumberGenerator specialNumberGenerator = SpecialNumberGenerator();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSpinners();
    });
  }

  void _initializeSpinners() {
    setState(() {
      final baseW = MediaQuery.of(context).size.width;

      final widthPer =
          (baseW - spinnerPadding * (numbersPerLine + 1)) / numbersPerLine;

      for (int i = 0; i < numberOfLines; i++) {
        final result = specialNumberGenerator.limitedMultiNumberInRange(
            minNum, maxNum, numbersPerLine);

        List<SpinnerWidget> spinnerWidgets = result.map((value) {
          final spinnerKey = GlobalKey<SpinnerWidgetState>();
          return SpinnerWidget(
            minNum,
            maxNum,
            value,
            widthPer,
            widthPer,
            key: spinnerKey,
          );
        }).toList();

        spinners.add(spinnerWidgets);
      }
    });
  }

  Future<void> _triggerSpinner(List<SpinnerWidget> line) async {
    for (final spinner in line) {
      final spinnerKey = spinner.key as GlobalKey<SpinnerWidgetState>?;
      if (spinnerKey != null && spinnerKey.currentState != null) {
        spinnerKey.currentState!.triggerScroll();
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }

    for(final spinner in line) {
      final spinnerKey = spinner.key as GlobalKey<SpinnerWidgetState>?;
      if (spinnerKey != null && spinnerKey.currentState != null) {
        await spinnerKey.currentState!.scrollToResult();
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  void _triggerAllSpinners() {
    for (final line in spinners) {
      _triggerSpinner(line);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kprimary, ksecondary])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const Padding(padding: EdgeInsets.all(8)),
              Text("Lotto Number Generator",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.1,
                      color: ktertiery)),
              const Padding(padding: EdgeInsets.all(40)),
              if (spinners.isNotEmpty)
                SizedBox(
                  height: height * 0.3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(numberOfLines, (line) {
                        return Padding(
                          padding: const EdgeInsets.all(spinnerPadding),
                          child: Wrap(
                            spacing: spinnerPadding,
                            children: List.generate(numbersPerLine, (column) {
                              return spinners[line][column];
                            }),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              const Padding(padding: EdgeInsets.all(40)),
              Center(
                child: SizedBox(
                  width: width * 0.5,
                  child: ElevatedButton(
                      onPressed: () async {
                        _triggerAllSpinners();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: kfifth),
                      child: Text("Spin!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.5 * 0.15))),
                ),
              )
            ],
          ),
          floatingActionButton: IconButton(
              onPressed: () async {
                final result = await SettingsAlert.sendSettingsAlert(context,
                    minNum: minNum,
                    maxNum: maxNum,
                    numbersPerLine: numbersPerLine,
                    numberOfLines: numberOfLines);
                if (result == null || result is! Map) return;

                final _minNum = int.parse(result["min"]);
                final _maxNum = int.parse(result["max"]);
                final _perLine = int.parse(result["perLine"]);
                final _lines = int.parse(result["lines"]);

                if (_minNum > _maxNum || (_maxNum - _minNum) < _perLine) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Invalid Options. Ignored")));
                  return;
                }

                minNum = _minNum;
                maxNum = _maxNum;
                numbersPerLine = _perLine;
                numberOfLines = _lines;
                _initializeSpinners();
              },
              iconSize: 50,
              color: ktertiery,
              icon: const Icon(Icons.settings)),
        ));
  }
}
