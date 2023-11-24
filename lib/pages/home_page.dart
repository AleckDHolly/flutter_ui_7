import 'package:flutter/material.dart';
import 'package:flutter_ui_11/components/weather_model.dart';
import 'package:flutter_ui_11/pages/sub_category.dart';
import 'package:flutter_ui_11/services/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //apiKey
  final _weatherService = WeatherService("1bc6e61ace96f8e393531c314df9e298");

  WeatherModel? _weather;

  //fetch main original weather
  _fetchOriginalWeather() async {
    //get weather city
    String cityName = await _weatherService.getCurrentCity();
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint("${e.toString()} fuck");
    }
  }

  //fetch searched weather
  _fetchWeather(String cityName) async {
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Which lottie to show
  String weatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/videos/sunny.json";

    switch (mainCondition.toLowerCase()) {
      case "rain":
      case "drizzle":
        return "assets/videos/rainy.json";
      case "thunderstorm":
        return "assets/videos/thunder.json";
      case "snow":
        return "assets/videos/snowy.json";
      case "clouds":
        return "assets/videos/cloudy.json";
      case "clear":
        return "assets/videos/sunny.json";
      default:
        return "assets/videos/sunny.json";
    }
  }

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchOriginalWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //cityName
        title: Text(
          _weather?.cityName ?? "Search a city..",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "e.g.: San francisco",
                            labelText: "A city of your choice.",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          autocorrect: true,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            setState(() {
                              _fetchWeather(_controller.text);
                              _controller.text = "";
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),
                    );
                  });
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: SafeArea(
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${_weather?.mainCondition ?? "Nothing"}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                GradientText(
                  "${_weather?.temperature.round() ?? 0}°C",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 100,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -10),
                  colors: [
                    Colors.white,
                    Colors.white60,
                  ],
                ),
                Lottie.asset(weatherAnimation(_weather?.mainCondition)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SubCategories(
                      lottie: "assets/videos/wind.json",
                      subCategory: "${_weather?.windSpeed.round() ?? 0}km/h",
                    ),
                    SubCategories(
                      lottie: "assets/videos/humidity.json",
                      subCategory: "${_weather?.humidity ?? 0}%",
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
