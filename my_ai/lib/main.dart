import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_ai/secrete.dart';

void main() {
  runApp(MYAI());
}

class MYAI extends StatefulWidget {
  @override
  State<MYAI> createState() {
    return Ai();
  }
}

class Ai extends State<MYAI> {
  late String response = "welcom to niggas ai";
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    gemini();
    //   textEditingController = TextEditingController();
  }

  Future<String> gemini() async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apikey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": textEditingController.text},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final answer = data['candidates'][0]['content']['parts'][0]['text'];

        return answer;
      } else {
        throw 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "WELCOME TO MY AI",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
              // backgroundColor: Color.fromARGB(218, 73, 102, 98),
            ),
          ),
          backgroundColor: Color.fromARGB(53, 91, 68, 68),
          centerTitle: true,
          elevation: 50,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: gemini(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator.adaptive());
              } //else if (snapshot.hasError) {
              //return Center(child: Text('Error: ${snapshot.error}'));
              //}

              final data = snapshot.data!;

              // print(data);

              //  print(cn);

              return Column(
                children: [
                  SizedBox(height: 30),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: TextField(
                      textInputAction: TextInputAction.done,

                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "Enter your prompt",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 214, 208, 208),
                        ),
                        label: Icon(Icons.comment_outlined),
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              // textEditingController.text = "";
                              gemini();
                            });
                          },
                          icon: Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 224, 217, 217),
                          ),
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 212, 204, 204),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 580,
                    width: double.infinity,

                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: Card(
                      shadowColor: Color.fromARGB(244, 204, 2, 2),
                      elevation: 20,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            data,
                            style: GoogleFonts.roboto(
                              //   backgroundColor: Color.fromARGB(129, 7, 7, 7),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //  SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }
}
