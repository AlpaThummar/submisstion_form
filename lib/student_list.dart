import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:submisstion_form/form_data.dart';
import 'main.dart';

class Student_List extends StatefulWidget {
  const Student_List({Key? key}) : super(key: key);

  @override
  State<Student_List> createState() => _Student_ListState();
}

class _Student_ListState extends State<Student_List> {
  @override
  Widget build(BuildContext context) {
      Box box = Hive.box('testBox');

    return Scaffold(
        appBar: AppBar(
          title: Text("Student List"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Submisstion_form();
                    },
                  ));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            form_data f = box.getAt(index);
            return Card(
              child: InkWell( //Form details open
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(File(f.images)))),
                          ),
                          Container(height: 50,width: double.infinity,child: Text("Name :-${f.name}",style: TextStyle(fontSize: 15,color: Colors.white),),),
                          Container(height: 50,width: double.infinity,child: Text("Contact :-${f.contact}",style: TextStyle(fontSize: 15,color: Colors.white)),),
                          Container(height: 50,width: double.infinity,child: Text("City :-${f.city}",style: TextStyle(fontSize: 15,color: Colors.white)),),
                          Container(height: 50,width: double.infinity,child: Text("Gender :-${f.gender}",style: TextStyle(fontSize: 15,color: Colors.white)),),
                          Container(height: 50,width: double.infinity,child: Text("Skill :-${f.skill}",style: TextStyle(fontSize: 15,color: Colors.white)),),
                        ],
                      );
                    },
                  ));
                },
                child: ListTile(
                  title: Text("${f.name}"),
                  subtitle: Text("${f.contact}" "|" "${f.city}"),
                  leading: CircleAvatar(
                    backgroundImage: FileImage(File(f.images)),
                  ),
                  trailing: Wrap(children: [
                    IconButton(
                        onPressed: () {
                          box.deleteAt(index);
                          File i = File("${f.images}");
                          i.delete();
                          setState(() {});
                        },
                        icon: Icon(Icons.delete)),
                    IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Submisstion_form(f);
                            },
                          ));
                          setState(() {});
                        },
                        icon: Icon(Icons.edit))
                  ]),
                ),
              ),
            );
          },
        ));
  }
}
