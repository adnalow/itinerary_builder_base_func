import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:itineray_builder_base_func/displayChoice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          UserChoice(),
        ],
      ),
    );
  }
}

class UserChoice extends StatefulWidget {
  @override
  UserChoiceState createState() => UserChoiceState();
}

class UserChoiceState extends State<UserChoice> {
  final List<String> options = [
    "Nature",
    "Scenic",
    "Water Activities",
    "Beach",
    "Cultural",
    "Relaxation",
    "Nightlife",
    "Shopping",
    "Family Friendly",
    "Sports",
    "Hiking",
    "Luxury",
    "Food and Drink",
    "Mountain",
    "Wildlife",
    "Thrill",
    "Historical",
    "Budget",
    "Festivals",
    "Romantic"
  ];
  final List<String> selectedOptions = []; // Store selected options here

  String? country;
  String? province = "";
  String? municipality = "";
  String? preference;
  String promptFormat = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CSCPicker(
            layout: Layout.vertical,
            flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
            stateDropdownLabel: "Province",
            cityDropdownLabel: "Municipality",
            dropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            onCountryChanged: (value) {
              setState(() {
                country = value;
              });
            },
            onStateChanged: (value) {
              setState(() {
                province = value;
              });
            },
            onCityChanged: (value) {
              setState(() {
                municipality = value; // Update selected municipality
              });
            },
          ),
          const SizedBox(height: 20),
          Wrap(
            children: options.map((option) {
              final isSelected = selectedOptions.contains(option);
              return Container(
                margin: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedOptions.remove(option);
                      } else {
                        selectedOptions.add(option);
                      }
                      // Update preference with selected options
                      preference = selectedOptions.join(", ");
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF48B89F) : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          offset: const Offset(2, 2), // Offset of the shadow
                          blurRadius: 4.0, // Blur radius
                          spreadRadius: 1.0, // How much the shadow spreads
                        ),
                      ],
                    ),
                    child: Text(
                      option,
                      style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () async {
              // Check if municipality is empty and set the prompt accordingly
              if (municipality == null || municipality!.isEmpty) {
                promptFormat =
                    "Give me one place in $country, in any part of province of $province that is fitted in this description: $preference. Use this format in giving my request: Name: {name of the place} Description: {2 sentences description of the place}.";
              } else {
                promptFormat =
                    "Give me one place in $country, province of $province, municipality of $municipality that is fitted in this description: $preference. Use this format in giving my request: Name: {name of the place} Description: {2 sentences description of the place}.";
              }

              // Navigate to the DisplayChoice screen with the promptFormat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayChoice(promptFormat: promptFormat),
                ),
              );
            },
            child: const Text('Find me a destination'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
