import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? image;
  File? firimage;

  String imageURL = "";

  final image_picker = ImagePicker();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> pickImage() async {
    final picked_image =
        await image_picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (picked_image != null) {
        image = File(picked_image.path);
      } else {
        print("No file selected");
      }
    });
  }

  Future<void> uploadImage() async {
    if (image == null) return;
    try {
      final Reference ref = _storage.ref().child('images/temp2.jpg');
      await ref.putFile(image!);

      print('Image uploaded to Firebase Storage.');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> fetchImage() async {
    try {
      String getUrl = await _storage.ref('images/temp2.jpg').getDownloadURL();
      setState(() {
        imageURL = getUrl;
      });
    } on FirebaseException catch (e) {
      print('Error loading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Image Upload"),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: 500,
            child: imageURL.isNotEmpty
                ? Image.network(imageURL) // Display image using imageURL
                : Text("No image taken"),
          ),
          ElevatedButton(onPressed: pickImage, child: Text("Take an Image")),
          ElevatedButton(
              onPressed: uploadImage, child: Text("Upload an Image")),
          ElevatedButton(onPressed: fetchImage, child: Text("Fetch an Image")),
        ],
      ),
    );
  }
}
