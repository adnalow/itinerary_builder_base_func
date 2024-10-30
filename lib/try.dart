import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
          InputBoxExample()
        ],
      ),
    );
  }
}

class InputBoxExample extends StatefulWidget {
  @override
  InputBoxExampleState createState() => InputBoxExampleState();
}

class InputBoxExampleState extends State<InputBoxExample> {
  final TextEditingController _country = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _preference = TextEditingController();

  late GenerativeModel model;  // Declare without initializing here
  String? generatedResponse;   // Variable to store and display the generated response
  String? placeName;
  String? description;

  String? country;
  String? city;
  String? preference;
  String promptFormat = "";

  @override
  void initState() {
    super.initState();

    // Initialize the model in initState
    const apiKey = 'AIzaSyBcuuGqcpZbi_o6uZB8TODmBUqXaQzy-14';
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
  }

  void  sendRequest(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      setState(() {
        generatedResponse = response.text;  // Directly access the generated text
        _extractNameAndDescription(generatedResponse!);
      });
      debugPrint(generatedResponse);
    } catch (error) {
      setState(() {
        generatedResponse = "Error: $error";
      });
      debugPrint("Error: $error");
    }
  }

  // Function to extract name and description
  void _extractNameAndDescription(String response) {
    final nameMatch = RegExp(r"Name:\s*\*\*(.*)\*\*").firstMatch(response);
    final descriptionMatch = RegExp(r"Description:\s*(.*)").firstMatch(response);

    setState(() {
      // Remove ** from name if found
      placeName = nameMatch?.group(1) ?? "Name not found";
      description = descriptionMatch?.group(1) ?? "Description not found";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _country,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Country',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _city,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter City/Municipality',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _preference,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Preference',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              country = _country.text;
              city = _city.text;
              preference = _preference.text;
              promptFormat = "Give me one place in $country , $city that is fitted in this description: $preference . Use this format in giving my request: Name: {name of the place} Description: {2 sentences description of the place}";
              sendRequest(promptFormat);
            },
            child: const Text('Submit'),
          ),
          const SizedBox(height: 20),
          if (placeName != null && description != null) ...[
            Text("Place Name: $placeName"),
            const SizedBox(height: 10),
            Text("Description: $description"),
          ],
          if (generatedResponse != null && (placeName == null || description == null))
            Text(generatedResponse!), // Display the full response in case of parsing issues
        ],
      ),
    );
  }
}
