
import 'dart:math';

class NormalNumberGenerator {

  late Random _rng;

  NormalNumberGenerator() {
    _rng = Random();
  }

  int getNumberInRange(int min, int max) {
    return _rng.nextInt(max) + min;
  }

  List<int> multiGetNumberInRange(int min, int max, int count) {
    List<int> result = [];
    for(var i = 0; i < count; i++) {
      result.add(_rng.nextInt(max) + min);
    }
    return result;
  }

}


class SpecialNumberGenerator extends NormalNumberGenerator {

  List<int> rangeListGenerator(int min, int max){
    List<int> options = [];
    for(var i = min; i < max+1; i++){
      options.add(i);
    }
    return options;
  }

  List<int> limitedMultiNumberInRange(int min, int max, int count){
    List<int> options = rangeListGenerator(min, max);
    if(count > options.length) return [];

    List<int> result = [];
    for(var i = 0; i < count; i++){
      int num = options.removeAt(_rng.nextInt(options.length));
      result.add(num);
    }

    return result;
  }

}