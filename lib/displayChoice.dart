import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DisplayChoice extends StatefulWidget {
  final String promptFormat; // Declare the promptFormat variable

  // Updated constructor to require promptFormat
  const DisplayChoice({super.key, required this.promptFormat});

  @override
  State<DisplayChoice> createState() => DisplayChoiceState();
}

class DisplayChoiceState extends State<DisplayChoice> {
  late GenerativeModel model; // Declare without initializing here
  String? generatedResponse; // Variable to store and display the generated response
  String? placeName;
  String? description;

  bool loading = true; // Start with loading to show initial progress indicator

  var newPrompt;

  @override
  void initState() {
    super.initState();

    // Initialize the model in initState
    const apiKey = 'AIzaSyDxrEyb5uvig_l6zHoYUnsohReFjzuPkDc'; // Replace with your actual API key
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    // Call sendRequest to trigger the API call
    sendRequest(widget.promptFormat);
  }

  // Updated method to send the promptFormat when called
  void sendRequest(String prompt) async {
    setState(() {
      loading = true; // Set loading to true when request starts
      placeName = null; // Clear place name and description before the new request
      description = null;
    });

    try {
      final content = [Content.text(prompt)]; // Use widget.promptFormat
      final response = await model.generateContent(content);

      setState(() {
        generatedResponse = response.text; // Directly access the generated text
        _extractNameAndDescription(generatedResponse!);
      });
      debugPrint(generatedResponse);
    } catch (error) {
      setState(() {
        generatedResponse = "Error: $error";
      });
      debugPrint("Error: $error");
    } finally {
      setState(() {
        loading = false; // Set loading to false when request finishes
      });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Mate'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container for Place Name and Description or loading indicator
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25), // Shadow color
                    blurRadius: 4, // Blur radius of the shadow
                  ),
                ],
              ),
              child: loading
                  ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$placeName",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 3.0), // Space between name and line
                        const Divider(color: Colors.black), // Line separator
                        const SizedBox(height: 3.0), // Space between line and description
                        Text(
                          "$description",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            // Row for Back and Next Destination buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  child: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loading = true; // Set loading to true for next destination request
                    });
                    newPrompt = "Aside from $placeName, suggest a new destination that is within the same area or province. Use this format in giving my request: Name: {name of the place} Description: {2 sentences description of the place}.";
                    sendRequest(newPrompt);
                  },
                  child: const Text("Next Destination"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
