import 'package:flutter/material.dart';
import 'passenger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String pageName = "home";
  String pageCaption = "Home Page";
  Widget homeWidget() {
    return (Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PassengerWidget();
                }));
              },
              child: const Text("Passenger Entry Page")),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(pageCaption),
              const Spacer(),
            ],
          ),
        ),
        body: homeWidget());
  }
}
