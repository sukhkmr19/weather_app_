import 'package:weather_app/WeatherEntity.dart';

class BeanFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "Weatherentity") {
      return Weatherentity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}