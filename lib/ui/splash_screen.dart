import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/ui/weather_dashboard.dart';

import '../helper/color_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                WeatherDashboard()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.appColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            SizedBox(
                height: 200,
                width: 200,
                child:
                    // Image.asset("assets/images/logo.png")),
                    Lottie.asset("assets/animations/sunny_rainy_weather.json")),
            Text(
              "WeatherApp",
              style: TextStyle(fontFamily: "TimesRoman", fontSize: 24,
                  fontWeight: FontWeight.bold,
                color: ColorManager.white
              ),
            )
          ],
        ),
      ),
    );
  }
}
