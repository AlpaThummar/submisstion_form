import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'form_data.dart';

class Form extends StatefulWidget {

  form_data  f;
  Form(this.f);



  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {

  Box box = Hive.box('testBox');
  @override
  Widget build(BuildContext context) {
    return Scaffold(


    );
  }
}

