import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:v_vpn/screens/splash_screen.dart';

void main() {
  // Makes sure everything is set up before the app starts.
  WidgetsFlutterBinding.ensureInitialized();

  // Hides the system UI (like the status and navigation bars) for a fullscreen experience.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // Keeps the app in portrait mode (no rotation).
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    // Starts the app by calling the MyApp widget.
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VPN PROJECT',

      //theme
      theme: ThemeData(
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),

      home: SplashScreen(),
    );
  }
}
