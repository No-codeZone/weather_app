import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../helper/color_manager.dart';
import 'package:http/http.dart' as http;

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({super.key});

  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  String? place;
  double? temperature;
  String? details;
  String? weatherIcon;
  String? weatherType;

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  Future<void> fetchWeather(String? place) async {
    if (place == null) return;

    debugPrint("Place\t$place");
    final url = "API_KEY/weather?q=$place&units=metric&appid";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Response\t===${response.body}");

        setState(() {
          temperature = data["main"]["temp"].toDouble();
          details = data["weather"][0]["description"];
          weatherIcon = data["weather"][0]["icon"];
          weatherType = data["weather"][0]["main"];
          place = data["name"];
        });

        debugPrint("Temperature\t===$temperature°C");
        debugPrint("Details\t===$details");
        debugPrint("Success!");
      } else {
        setState(() {
          temperature = null;
          details = "City not found!";
          weatherIcon = null;
        });
      }
    } catch (exception) {
      debugPrint("Exception\t$exception");
      setState(() {
        temperature = null;
        details = "Error fetching weather data";
        weatherIcon = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.appColor,
        title: Text(
          "WeatherApp",
          style: TextStyle(
            fontFamily: "TimesRoman",
            color: ColorManager.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: ColorManager.appbackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Card(
                  color: Colors.white,
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorManager.appColor.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                "Weather Forecast",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: ColorManager.appColor,
                                  fontFamily: "TimesRoman"
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Enter your city",
                                  labelStyle: TextStyle(fontFamily: "TimesRoman"),
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onSubmitted: (value) {
                                  debugPrint("Value entered\t$value");
                                  fetchWeather(value);
                                },
                              ),
                            ],
                          ),
                        ),
                        if (temperature != null)
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        "https://raw.githubusercontent.com/ioBroker/ioBroker.openweathermap/6b3cebc070e1600a7b33f03ac23d4089066dcd91/admin/openweathermap.png",
                                        height: 80,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        place ?? "",
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                            fontFamily: "TimesRoman"
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "${temperature?.toStringAsFixed(1)}°C",
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: ColorManager.appColor,
                                            fontFamily: "TimesRoman"
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorManager.appColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          details?.toUpperCase() ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: ColorManager.appColor,
                                              fontFamily: "TimesRoman"
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  color: ColorManager.appColor,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Enter a city to get weather information",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                      fontFamily: "TimesRoman"
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
