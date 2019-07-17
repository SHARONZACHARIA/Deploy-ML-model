import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:galleryapp/network/NetworkCall.dart';

class Upload extends StatefulWidget{
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  File img_path;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
        title: Text("Upload Image"),),
        body: Container(
         child: Center(
                    child: Column(children: <Widget>[
                       SizedBox(height:50),
              img_path!=null?
              new Image.file(img_path): new Text("Select an image to upload"),
              SizedBox(height:20),
              RaisedButton( 
                color:Colors.blue,
                textColor:Colors.white,
                 child:Text("Pick Image from gallery",),
                onPressed: ()async
                {
                   var filename = await ImagePicker.pickImage(source:ImageSource.gallery);
                   setState(() {
                    img_path = filename;
                   });
                   
                },
              ),
               SizedBox(height:20),
               RaisedButton(
                 color:Colors.blue,
                  textColor:Colors.white,
                 child:Text("Upload to server"),
                onPressed: ()
                {
                  uploadImageToServer(img_path);
                },
              ),
               SizedBox(height:20),

            ],),
         )
          ),);
  }


  uploadImageToServer(File imageFile)async
  {
    print("attempting to connecto server......");
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      print(length);

      var uri = Uri.parse('http://192.168.1.103:5000/predict');
       print("connection established.");
     var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
          //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
  }
}