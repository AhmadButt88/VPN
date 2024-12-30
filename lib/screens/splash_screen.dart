import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:v_vpn/screens/home_screen.dart';

/// A stateful widget that represents the splash screen of the application.
/// Displays an animated logo and transitions to the home screen after a delay.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// Controller for managing the animation.
  late AnimationController _controller;

  /// Animation for the fade transition effect.
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration and synchronization context.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Define a curved animation to create a smooth fade-in effect.
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Start the fade-in animation.
    _controller.forward();

    // Delay for 3 seconds before transitioning to the home screen.
    Timer(const Duration(seconds: 3), () {
      // Enable full edge-to-edge system UI for immersive experience.
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // Navigate to the home screen and replace the splash screen in the navigation stack.
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(),
      //   ),
      // );
      Get.off(HomeScreen());
    });
  }

  @override
  void dispose() {
    // Dispose of the animation controller to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the device's screen size for responsive layout.
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Centered logo with a fade-in transition animation.
          Center(
            child: FadeTransition(
              opacity: _animation, // Apply the fade animation to the logo.
              child: Image.asset(
                'assets/images/logo.png', // Path to the logo image asset.
                width: mediaQuery.width *
                    0.3, // Set logo width to 30% of screen width.
              ),
            ),
          ),

          // Animated typewriter-style text displayed at the bottom of the screen.
          Positioned(
            bottom: 20, // Position the text 20 pixels from the bottom.
            left: 0,
            right: 0,
            child: TweenAnimationBuilder(
              // Tween animates the value from 0 to 1 over the specified duration.
              tween: Tween<double>(begin: 0, end: 1),
              duration:
                  const Duration(milliseconds: 1500), // Animation duration.
              builder: (context, double value, child) {
                // Calculate how many characters to display based on animation progress.
                int length = 'MADE BY HAMEED'.length;
                int charactersToShow = (value * length).round();

                // Display the animated substring of the text.
                return Text(
                  'MADE BY HAMEED'.substring(0, charactersToShow),
                  textAlign: TextAlign.center, // Center-align the text.
                  style: TextStyle(
                    fontSize: 16, // Font size of the text.
                    fontWeight: FontWeight.bold, // Make the text bold.
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
