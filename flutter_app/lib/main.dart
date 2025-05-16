import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(SciBERTApp());
}

class SciBERTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SciBERT Chat',
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  String _response = "";

  void _sendQuestion() async {
    final text = _controller.text;
    final res = await http.post(
      Uri.parse("http://10.0.2.2:8000/ask"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"text": text}),
    );
    final body = json.decode(res.body);
    setState(() {
      _response = body["message"] + "\nAnteprima embedding: " + body["embedding_preview"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SciBERT Chat")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: InputDecoration(labelText: "Domanda scientifica")),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _sendQuestion, child: Text("Invia")),
            SizedBox(height: 20),
            Text("Risposta:
$_response"),
          ],
        ),
      ),
    );
  }
}
