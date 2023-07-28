import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'global.dart';

class PassengerWidget extends StatefulWidget {
  const PassengerWidget({super.key});

  @override
  State<PassengerWidget> createState() => _PassengerWidgetState();
}

class _PassengerWidgetState extends State<PassengerWidget> {
  TextEditingController passengerName = TextEditingController();
  TextEditingController passengerEmail = TextEditingController();
  TextEditingController passengerMob = TextEditingController();
  TextEditingController passengerAge = TextEditingController();
  TextEditingController passengerAddress = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  String passengerId = "";
  List<Passenger> passengerList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Passenger Details"),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  clearScreen();
                },
                child: const Text("NEW")),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  if (formGlobalKey.currentState!.validate()) {
                    saveRecord();
                  }
                },
                child: const Text("SAVE"))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                  },
                  decoration: const InputDecoration(labelText: "Name"),
                  controller: passengerName,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Address"),
                  controller: passengerAddress,
                ),
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Age is required";
                    }
                  },
                  decoration: const InputDecoration(labelText: "Age"),
                  controller: passengerAge,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: "Email"),
                  controller: passengerEmail,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mobile No is required";
                    }
                  },
                  decoration: const InputDecoration(labelText: "Mobile No"),
                  controller: passengerMob,
                ),
              ),
              FutureBuilder(
                future: getList(),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: passengerList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(148, 142, 226, 1),
                              border: Border(
                                  bottom: BorderSide(color: Colors.black))),
                          child: InkWell(
                            onTap: () {
                              passengerId = passengerList[index].id.toString();
                              passengerName.text =
                                  passengerList[index].passengerName ?? "";
                              passengerEmail.text =
                                  passengerList[index].passengerEmail ?? "";
                              passengerAddress.text =
                                  passengerList[index].passengerAddress ?? "";
                              passengerAge.text =
                                  passengerList[index].passengerAge.toString();
                              passengerMob.text =
                                  passengerList[index].passengerMob ?? "";
                            },
                            child: ListTile(
                              leading: const Icon(Icons.man),
                              title: Text(
                                  passengerList[index].passengerName ?? ""),
                              subtitle: Text(
                                  " Age : ${passengerList[index].passengerAge} Email :${passengerList[index].passengerEmail}"),
                              trailing: ElevatedButton(
                                  onPressed: () {
                                    passengerId =
                                        passengerList[index].id.toString();
                                    deleteRecord();
                                  },
                                  child: const Text("Delete")),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearScreen() {
    passengerId = "";
    passengerName.text = "";
    passengerEmail.text = "";
    passengerMob.text = "";
    passengerAge.text = "";
    passengerAddress.text = "";
  }

  Future<void> saveRecord() async {
    try {
      Map<String, dynamic> body = {
        'id': passengerId,
        'passenger_name': passengerName.text,
        'passenger_email': passengerEmail.text,
        'passenger_mob': passengerMob.text,
        'passenger_age': passengerAge.text,
        'passenger_address': passengerAddress.text,
      };
      Uri url = Uri.parse("http://localhost:8080/passenger/create");
      if (passengerId.isNotEmpty) {
        url = Uri.parse("http://localhost:8080/passenger/update");
      }
      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode(body),
      );
      Map<String, dynamic> data = jsonDecode(response.body);
      String msg = data["message"];
      if (msg.toLowerCase().contains("success")) {
        showMessage(context, msg);
        if (passengerId.isEmpty) {
          passengerId = data["id"].toString();
        }
        clearScreen();
        setState(() {});
      } else {
        showMessage(context, msg);
      }
    } catch (e) {}
  }

  Future<void> getList() async {
    try {
      Map<String, dynamic> body = {
        'user_id': "test",
      };

      Uri url = Uri.parse("http://localhost:8080/passenger/getlist");

      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode(body),
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      String msg = data["message"];
      if (msg.toLowerCase().contains("success")) {
        var jsonData = data["listData"];

        passengerList.clear();
        jsonData.forEach((jsonItem) {
          Passenger passenger = Passenger();
          passenger.id = jsonItem['id'];
          passenger.passengerName = jsonItem['passenger_name'];
          passenger.passengerAge = jsonItem['passenger_age'];
          passenger.passengerEmail = jsonItem['passenger_email'];
          passenger.passengerMob = jsonItem['passenger_mob'];
          passenger.passengerAddress = jsonItem['passenger_address'];
          passengerList.add(passenger);
        });
      } else {
        showMessage(context, msg);
      }
    } catch (e) {
      showMessage(context, "Error : $e");
    }
  }

  Future<void> deleteRecord() async {
    try {
      Map<String, dynamic> body = {
        'id': passengerId,
        'passenger_name': passengerName.text,
        'passenger_email': passengerEmail.text,
        'passenger_mob': passengerMob.text,
        'passenger_age': passengerAge.text,
        'passenger_address': passengerAddress.text,
      };
      if (passengerId.isEmpty) {
        showMessage(context, "Select a record...");
      }
      Uri url = Uri.parse("http://localhost:8080/passenger/delete");

      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode(body),
      );
      Map<String, dynamic> data = jsonDecode(response.body);
      String msg = data["message"];
      if (msg.toLowerCase().contains("success")) {
        showMessage(context, msg);

        clearScreen();
        setState(() {});
      } else {
        showMessage(context, msg);
      }
    } catch (e) {
      showMessage(context, "Error : $e");
    }
  }
}

class Passenger {
  int? id;
  String? passengerName;
  String? passengerEmail;
  String? passengerMob;
  int? passengerAge;
  String? passengerAddress;
}
