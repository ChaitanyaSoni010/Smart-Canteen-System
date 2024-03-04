import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/itemsScreen.dart';

import '../model/menus.dart';



class InfoDesignWidget extends StatefulWidget
{
  Menus? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  _InfoDesignWidgetState createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  deleteMenu(String menuID){
    FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(menuID)
        .delete();

    Fluttertoast.showToast(msg: "Menu Deleted Successfully");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=>ItemsScreen(model: widget.model)));
      },

      splashColor: Colors.amber,
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Divider(
                    height: 4,
                    thickness: 3,
                    color: Colors.grey[300],
                  ),
                  Image.network(widget.model!.thumbnailUrl!,
                    height: 210.0,
                    fit:  BoxFit.cover,
                  ),
                  const SizedBox(height: 1.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.model!.menuTitle!,
                        style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Train"
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 30,
                          ),
                        onPressed:(){
                            deleteMenu(widget.model!.menuID!);
                            //delete item
                        }
                        ,
                      ),

                    ],
                  ),
                  // Text(
                  //   widget.model!.menuInfo!,
                  //   style: const TextStyle(
                  //     color: Colors.deepOrange,
                  //     fontSize: 18,
                  //   ),
                  // ),
                  Divider(
                    height: 4,
                    thickness: 3,
                    color: Colors.grey[300],
                  ),
                ],
              )
          )
      ),
    );
  }
}