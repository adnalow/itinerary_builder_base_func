import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = 'AIzaSyBcuuGqcpZbi_o6uZB8TODmBUqXaQzy-14';

void main() async {
  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
  );

  const prompt = 'Give me one place in Philippines, Batangas city that is fitted in this description: seaSide. Also give a 2-3 sentences description about the place.';
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  print(response.text);
}