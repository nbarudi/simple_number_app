import 'package:flutter/material.dart';
import 'package:lottogenerator/helpers/numbergen.dart';
import 'package:lottogenerator/helpers/themes.dart';

class SpinnerWidget extends StatefulWidget {
  final int min;
  final int max;
  final int result;

  final double width;
  final double height;

  SpinnerWidget(this.min, this.max, this.result, this.width, this.height, {super.key});


  @override
  State<StatefulWidget> createState() => SpinnerWidgetState();

}

class SpinnerWidgetState extends State<SpinnerWidget> {
  late ScrollController scrollController;
  late List<int> numRange;
  final Map<int, GlobalKey> itemKeys = {};

  bool spinning = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _initializeKeysAndRange();
  }

  void _initializeKeysAndRange() {
    numRange = SpecialNumberGenerator().rangeListGenerator(widget.min, widget.max);

    // Assign keys for each number
    for (var num in numRange) {
      itemKeys[num] = GlobalKey();
    }
  }

  Future<void> triggerScroll() async {
    if(spinning) return;
    spinning = true;

    while(spinning) {

      if(!scrollController.hasClients) break;

      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
      if(!spinning || !scrollController.hasClients) continue;
      await scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }
  }

  Future<void> scrollToResult() async {
    int number = widget.result;
    if(!spinning) return;
    spinning = false;
    if (!scrollController.hasClients) {
      print("ScrollController is not attached to any scroll view.");
      return;
    }

    if (number < widget.min || number > widget.max) {
      print("Number $number is out of range.");
      return;
    }

    final key = itemKeys[number];
    if (key?.currentContext == null) {
      print("No valid context found for number $number.");
      return;
    }

    int time = ((1 + number/numRange.length) * 1000).floor();

    await Scrollable.ensureVisible(
      key!.currentContext!,
      alignment: 0.5,
      duration: Duration(milliseconds: time),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: const BoxDecoration(
        gradient: RadialGradient(colors: [ksixth, kseventh]),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: numRange.map((num) {
            return Center(
              key: itemKeys[num],
              child: Text(
                "$num",
                style: TextStyle(
                  fontSize: widget.width/2,
                  fontWeight: FontWeight.bold,
                  color: ktext,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
