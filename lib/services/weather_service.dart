import 'dart:convert';

import 'package:flutter_ui_11/components/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// "?q={city name}&appid={API key}"

class WeatherService {
  static const BASE_URL = "api.openweathermap.org/data/2.5/forecast";
  String apiKey;

  WeatherService(this.apiKey);

  Future<WeatherModel> getWeather(String cityName) async {
    final response = await http.get(
        Uri.parse("https://$BASE_URL?q=$cityName&appid=$apiKey&units=metric"));
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load data.");
    }
  }

  Future<String> getCurrentCity() async {
    //Get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    //convert location into a list of placemark objects
    List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    //extract the city name from list of placemarks
    String? city = placemark[0].locality;

    return city ?? "London";
  }
}
