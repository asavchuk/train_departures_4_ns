import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:train_departures_4_ns/providers/septa_provider.dart';
import 'package:train_departures_4_ns/screens/departures.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SeptaProvider(),
      child: MaterialApp(
        title: 'Train Departures',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF282828),
            foregroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            brightness: Brightness.dark,
            primary: Colors.cyan,
            secondary: Colors.deepOrangeAccent,
            background: Colors.green,
          ),
          textTheme: TextTheme(
              bodyMedium: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                      color: Colors.deepOrangeAccent, fontSize: 12.0)),
              bodyLarge: GoogleFonts.orbitron(
                  textStyle:
                      const TextStyle(color: Colors.cyan, fontSize: 14.0)),
              titleLarge: GoogleFonts.orbitron(
                  textStyle:
                      const TextStyle(color: Colors.cyan, fontSize: 18.0))),
        ),
        home: Departures(),
      ),
    );
  }
}
