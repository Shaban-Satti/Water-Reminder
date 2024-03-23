import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_reminder/manager/DataManager.dart';
import 'package:water_reminder/manager/LocalNotificationManager.dart';
import 'package:water_reminder/settings/RouteGenerator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  LocalNotificationManager.init();

  runApp(FlutterWaterReminderApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
}

class FlutterWaterReminderApp extends StatefulWidget {
  @override
  _FlutterWaterReminderAppState createState() =>
      _FlutterWaterReminderAppState();
}

class _FlutterWaterReminderAppState extends State<FlutterWaterReminderApp> {
  @override
  void initState() {
    DataManager.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.lightBlue.shade200),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
