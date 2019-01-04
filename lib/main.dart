import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/SoundPlayer.dart';
import 'package:weather_app/WeatherEntity.dart';
import 'package:weather_app/urls.dart';

var weatherBean = new Weatherentity();

Geolocator _location = Geolocator()..forceAndroidLocationManager = true;
var locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 300000);

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(new MaterialApp(
            home: new WeatherApp(),
          )));
}

class WeatherApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _WeatherApp();
  }
}

class _WeatherApp extends State<WeatherApp> {
  @override
  void initState() {
    super.initState();

    getFusedLocation();
    _location.getPositionStream(locationOptions).listen((Position _position) {
      getLocation(_position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold(context);
  }

  void getLocation(Position position) async {
    await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude)
        .then((place) {
      setState(() {
        city = place[0].locality.toString();
        Future<Weatherentity> list = getjson();
        list.then((data) {
          setState(() {
            weatherBean = data;
            SoundManager().playLocal(_soundPath());
          });
        });
      });
    });
  }

  void getFusedLocation() async {
    await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high)
        .then((_position) {
      getLocation(_position);
    });
  }
}

String _time(data) {
  var time = new DateTime.fromMillisecondsSinceEpoch(data * 1000);
  var format = new DateFormat.jm();
  return format.format(time);
}

String _image() {
  return weatherBean.weather != null
      ? weatherBean.weather[0].main == 'Smoke'
          ? mistUrl
          : weatherBean.weather[0].main == 'Mist'
              ? mistUrl
              : weatherBean.weather[0].main == 'Fog'
                  ? fogUrl
                  : weatherBean.weather[0].main == 'Clear'
                      ? clear
                      : weatherBean.weather[0].main == 'Rain'
                          ? rainUrl
                          : weatherBean.weather[0].main == 'Clouds'
                              ? stormUrl
                              : weatherBean.weather[0].main == 'Hazy'
                                  ? hazeUrl
                                  : sunnyUrl
      : sunnyUrl;
}

String _soundPath() {
  return weatherBean.weather != null
      ? weatherBean.weather[0].main == 'Smoke'
          ? 'clear.mp3'
          : weatherBean.weather[0].main == 'Fog'
              ? 'clear.mp3'
              : weatherBean.weather[0].main == 'Mist'
                  ? 'clear.mp3'
                  : weatherBean.weather[0].main == 'Clear'
                      ? 'sunny.mp3'
                      : weatherBean.weather[0].main == 'Rain'
                          ? 'rainbird.mp3'
                          : weatherBean.weather[0].main == 'Clouds'
                              ? 'dust.mp3'
                              : weatherBean.weather[0].main == 'Hazy'
                                  ? 'rain.mp3'
                                  : 'sunny.mp3'
      : 'sunny.mp3';
}

Color _color() {
  return weatherBean.weather != null
      ? weatherBean.weather[0].main == 'Smoke'
          ? Colors.white
          : weatherBean.weather[0].main == 'Fog'
              ? Colors.white
              : weatherBean.weather[0].main == 'Clear'
                  ? Colors.blue
                  : weatherBean.weather[0].main == 'Rain'
                      ? Colors.blue
                      : weatherBean.weather[0].main == 'Clouds'
                          ? Colors.red
                          : weatherBean.weather[0].main == 'Hazy'
                              ? Colors.teal
                              : weatherBean.weather[0].main == 'Mist'
                                  ? Colors.yellow
                                  : Colors.blue
      : Colors.blue;
}

Stack _blank(String load) {
  return new Stack(
    children: <Widget>[
      new Image.asset(
        'raw/ic_launcher_image.png',
        height: 1024.0,
        width: 400.0,
        fit: BoxFit.fitHeight,
      ),
      Center(
        child: new AnimatedDefaultTextStyle(
            child: new Text(
              '$load',
              style: new TextStyle(
                fontSize: 16.5,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(10.0, 10.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            style: new TextStyle(
              fontSize: 16.5,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(10.0, 10.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
            duration: new Duration(seconds: 15)),
      ),
    ],
  );
}

Future<Weatherentity> getjson() async {
  String apiUrl =
      'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
  http.Response response = await http.get(apiUrl);
  Map userMap = jsonDecode(response.body);
  var weatherBean = new Weatherentity.fromJson(userMap);
  return weatherBean;
}

Scaffold _scaffold(BuildContext context) {
  return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('Weather Forecast'.toUpperCase()),
//        centerTitle: true,
//        backgroundColor: Colors.redAccent,
//        actions: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: new IconButton(icon: new Icon(Icons.menu), onPressed: null),
//          )
//        ],
//      ),
      body: new Center(
    child: weatherBean.name == null
        ? _blank('Loading...')
        : new Container(
            child: new Stack(
              children: <Widget>[
                new CachedNetworkImage(
                  imageUrl: _image(),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(right: 20, top: 50),
                    child: new Text(
                      '${city.toUpperCase()}, ${weatherBean.sys.country}',
                      textAlign: TextAlign.center,
                      style: new TextStyle(color: _color(), fontSize: 18.0),
                    ),
                  ),
                ),
                new Container(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Image.network(
                            sunriseUrl,
                            height: 30.0,
                            width: 30.0,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 40),
                            child: new Image.network(
                                'https://hanslodge.com/images2/sky-clipart-clear-weather/sunny-weather-icon-13.jpg?raw=true',
                                height: 30.0,
                                width: 30.0),
                          ),
                          new Image.network(
                            sunsetUrl,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                new Container(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: new Text(
                              ' SunRise\n ${_time(weatherBean.sys.sunrise)}',
                              style: new TextStyle(
                                color: _color(),
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 150),
                              child: new Text('')),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: new Text(
                              '  SunSet\n ${_time(weatherBean.sys.sunset)}',
                              style: new TextStyle(color: _color()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 380),
                  child: new Text(
                    'Max temp.\n     ${weatherBean.main.tempMax} C',
                    style: new TextStyle(color: _color()),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: new Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20, right: 60),
                      child: new Text(
                        'Temp - ${weatherBean.main.temp}${HtmlEscapeMode(escapeApos: true, name: '\'')}C  ${weatherBean.weather != null ? weatherBean.weather[0].main : ''}'
                            '\nWind - ${weatherBean.wind.speed} Km/Hrs\nHumidity - ${weatherBean.main.humidity}\nPresssure - ${weatherBean.main.pressure}',
                        style: new TextStyle(color: _color(), fontSize: 18.5),
                      )),
                ),
              ],
            ),
          ),
  ));
}
