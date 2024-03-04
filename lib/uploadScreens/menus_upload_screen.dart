import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/mainScreens/home_screen.dart';
import 'package:seller_app/widgets/progress_bar.dart';

import '../global/global.dart';
import '../widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({Key? key}) : super(key: key);

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading=false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.yellow
                ]
            ),
          ),
        ),
        title: const Text(
          "Add New Menu",
          style: TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
        } ,
            icon: Icon(Icons.arrow_back, color: Colors.white,)),

      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.yellow
              ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_2, color: Colors.grey, size:100.0),
              ElevatedButton(
                  child: Text(
                    "Add New Menu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ))
                ),
                onPressed: (){
                    takeImage(context);

                },
              ),
            ],
          ) ,
        ),
      ),
    );
  }

  takeImage(mContext){
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            title: const Text("Menu Image", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, ),),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Capture with Camera", style: TextStyle(color: Colors.grey),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Select from gallery", style: TextStyle(color: Colors.grey),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel", style: TextStyle(color: Colors.red),
                ),
                onPressed: ()=> Navigator.pop(context),
              ),
            ],
          );
        },



    );
    
  }

  captureImageWithCamera() async
  {
    Navigator.pop(context);
    imageXFile= await _picker.pickImage(source: ImageSource.camera,
    maxHeight: 720,
    maxWidth: 1280,);

    setState(() {
      imageXFile;
    });

  }

  pickImageFromGallery() async
  {
    Navigator.pop(context);
    imageXFile= await _picker.pickImage(source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,);

    setState(() {
      imageXFile;
    });

  }

  menusUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.yellow
                ]
            ),
          ),
        ),
        title: const Text(
          "Uploading New Menu",
          style: TextStyle(fontSize: 20, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(onPressed:(){
          clearMenuUploadForm();
        } ,
            icon: Icon(Icons.arrow_back, color: Colors.white,)),
        actions: [
          TextButton(
              child: const Text("Add",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,
                fontSize: 20,
              ),),
            onPressed: uploading ? null: ()=> validateUploadForm(),
          )
        ],

      ),
      body: ListView(
        children: [
          uploading==true ? linearProgress() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width*0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(imageXFile!.path)),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
            ),
          ),
           ListTile(
            leading: const Icon(Icons.perm_device_information, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "Menu Info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.title, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Menu Title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearMenuUploadForm(){
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile=null;
    });
  }

  validateUploadForm() async{

    if(imageXFile != null){
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty){
        setState(() {
          uploading=true;
        });
//upload image
      String downloadUrl = await uploadImage(File(imageXFile!.path));
      //save info to firebase
        saveInfo(downloadUrl);




      }
      else{
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(message: "Please write tile and info",);

            }
        );
      }

    }
    else{
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(message: "Please pick an image",);

          }
      );

    }

  }
  uploadImage(mImageFile) async
  {
    storageRef.Reference reference= storageRef.FirebaseStorage.instance.ref().child("menus");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;

  }

  saveInfo(String downloadUrl){
    final ref= FirebaseFirestore.instance
        .collection("sellers").doc(sharedPreferences!.getString("uid")).collection("menus");
    ref.doc(uniqueIdName).set({
      "menuID": uniqueIdName,
      "sellerUID":  sharedPreferences!.getString("uid"),
      "menuInfo":shortInfoController.text.toString(),
      "menuTitle": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });

    clearMenuUploadForm();
    setState(() {
      uniqueIdName= DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });

  }

  @override
  Widget build(BuildContext context)
  {
    return imageXFile ==null ? defaultScreen() : menusUploadFormScreen();
  }
}
