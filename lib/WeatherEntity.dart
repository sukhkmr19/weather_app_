class Weatherentity {
  dynamic dt;
  Coord coord;
  dynamic visibility;
  List<Weather> weather;
  String name;
  dynamic cod;
  Main main;
  Clouds clouds;
  dynamic id;
  Sys sys;
  String base;
  Wind wind;

  Weatherentity(
      {this.dt,
      this.coord,
      this.visibility,
      this.weather,
      this.name,
      this.cod,
      this.main,
      this.clouds,
      this.id,
      this.sys,
      this.base,
      this.wind});

  Weatherentity.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    coord = json['coord'] != null ? new Coord.fromJson(json['coord']) : null;
    visibility = json['visibility'];
    if (json['weather'] != null) {
      weather = new List<Weather>();
      json['weather'].forEach((v) {
        weather.add(new Weather.fromJson(v));
      });
    }
    name = json['name'];
    cod = json['cod'];
    main = json['main'] != null ? new Main.fromJson(json['main']) : null;
    clouds =
        json['clouds'] != null ? new Clouds.fromJson(json['clouds']) : null;
    id = json['id'];
    sys = json['sys'] != null ? new Sys.fromJson(json['sys']) : null;
    base = json['base'];
    wind = json['wind'] != null ? new Wind.fromJson(json['wind']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    if (this.coord != null) {
      data['coord'] = this.coord.toJson();
    }
    data['visibility'] = this.visibility;
    if (this.weather != null) {
      data['weather'] = this.weather.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['cod'] = this.cod;
    if (this.main != null) {
      data['main'] = this.main.toJson();
    }
    if (this.clouds != null) {
      data['clouds'] = this.clouds.toJson();
    }
    data['id'] = this.id;
    if (this.sys != null) {
      data['sys'] = this.sys.toJson();
    }
    data['base'] = this.base;
    if (this.wind != null) {
      data['wind'] = this.wind.toJson();
    }
    return data;
  }
}

class Coord {
  double lon;
  double lat;

  Coord({this.lon, this.lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    return data;
  }
}

class Weather {
  dynamic id;
  String main;
  String description;
  String icon;

  Weather({this.id, this.main, this.description, this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main'] = this.main;
    data['description'] = this.description;
    data['icon'] = this.icon;
    return data;
  }
}

class Main {
  dynamic temp;
  dynamic pressure;
  dynamic humidity;
  dynamic tempMin;
  dynamic tempMax;

  Main({this.temp, this.pressure, this.humidity, this.tempMin, this.tempMax});

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    pressure = json['pressure'];
    humidity = json['humidity'];
    tempMin = json['temp_min'];
    tempMax = json['temp_max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp'] = this.temp;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['temp_min'] = this.tempMin;
    data['temp_max'] = this.tempMax;
    return data;
  }
}

class Clouds {
  dynamic all;

  Clouds({this.all});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = json['all'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this.all;
    return data;
  }
}

class Sys {
  dynamic type;
  dynamic id;
  double message;
  String country;
  dynamic sunrise;
  dynamic sunset;

  Sys(
      {this.type,
      this.id,
      this.message,
      this.country,
      this.sunrise,
      this.sunset});

  Sys.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    message = json['message'];
    country = json['country'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['message'] = this.message;
    data['country'] = this.country;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    return data;
  }
}

class Wind {
  double speed;
  dynamic deg;

  Wind({this.speed, this.deg});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'];
    deg = json['deg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speed'] = this.speed;
    data['deg'] = this.deg;
    return data;
  }
}
