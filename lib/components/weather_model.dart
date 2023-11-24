class WeatherModel {
  String cityName;
  double temperature;
  String mainCondition;
  double windSpeed;
  int humidity;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.windSpeed,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json["city"]["name"],
      temperature: json["list"][0]["main"]["temp"].toDouble(),
      mainCondition: json["list"][0]["weather"][0]["main"],
      windSpeed: json["list"][0]["wind"]["speed"],
      humidity: json["list"][0]["main"]["humidity"],
    );
  }
}
