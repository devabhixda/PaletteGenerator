import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:palette_generator/palette_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Palette Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  late File file;
  late Uint8List uint8list;
  bool hasFile = false;
  late PaletteGenerator paletteGenerator;
  ScrollController sc = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: hasFile ? SizedBox(
          width: 500,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: paletteGenerator.colors.length,
            controller: sc,
            itemBuilder: (_, index) {
              return SizedBox(
                height: 550,
                width: 200,
                child: Column(
                  children: [
                    Card(
                      elevation: 0,
                      color: paletteGenerator.colors.elementAt(index).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child:  Image.memory(
                              uint8list,
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                      ),
                    ),
                    SelectableText("HEX: " + paletteGenerator.colors.elementAt(index).toString().substring(10, 16))
                  ],
                ),
              );
            }
          ),
        ) : const Text("No file selected"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            paletteGenerator = await PaletteGenerator.fromImageProvider(
              Image.memory(result.files.first.bytes??Uint8List(2)).image,
            );
            setState(() {
              uint8list = result.files.first.bytes??Uint8List(2);
              hasFile = true;
            });
          } else {
            // User canceled the picker
          }
        },
        tooltip: 'Pick File',
        child: const Icon(Icons.add),
      )
    );
  }
}
