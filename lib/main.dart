import 'dart:io';
import 'dart:math';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:submisstion_form/form_data.dart';
import 'package:submisstion_form/student_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDir.path);
  Hive.registerAdapter(formdataAdapter());
  var box = await Hive.openBox('testBox');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Submisstion_form(),
  ));
}

class Submisstion_form extends StatefulWidget {
  form_data? ob;

  Submisstion_form([this.ob]);

  @override
  State<Submisstion_form> createState() => _Submisstion_formState();
}

class _Submisstion_formState extends State<Submisstion_form> {
  Box box = Hive.box('testBox');
  bool screen = false;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();

  //MultiValueDropDownController t5 = MultiValueDropDownController();
  SingleValueDropDownController t6 = SingleValueDropDownController();

  ImagePicker picker = ImagePicker();

  PickedFile? images;

  //List value1=["V1","V2","V3","V4"];
  //List Skill=["Flutter","Laravel","Recat Native"];
  bool check = false;
  bool check1 = false;
  bool check2 = false;
  String Gender = "Male";
  String Sel_City = "surat";
  bool is_img = false;

  bool _passwordVisible=false;

  bool name_ = false;
  bool contact_ = false;
  bool email_ = false;
  bool password_ = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permission();

    if (widget.ob != null) {
      t1.text = widget.ob!.name;
      t2.text = widget.ob!.contact;
      t3.text = widget.ob!.email;
      t4.text = widget.ob!.passwrod;
      Gender = widget.ob!.gender;
      Sel_City = widget.ob!.city;

      List l = widget.ob!.skill.split("/");
      if (l.contains("Flutter")) {
        check = true;
      }
      if (l.contains("Laravel")) {
        check1 = true;
      }
      if (l.contains("Recat Native")) {
        check2 = true;
      }
    }
    _passwordVisible=false;
  }


  permission() async {
    var status = await Permission.camera.status;
    var status1 = await Permission.storage.status;
    if (status.isDenied && status1.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.camera,
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (Orientation.portrait == Orientation) {
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          screen = true;
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.bottom]);
          screen = false;
        }

        return Scaffold(
          appBar: AppBar(
            title: (widget.ob != null)
                ? Text("Update Details")
                : Text("Submission Form"),
          ),
          backgroundColor: Colors.lightBlueAccent,
          body: SingleChildScrollView(
            child: Column(children: [
              TextField(
                cursorColor: Colors.black,
                controller: t1,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    errorText: (name_=true) ? "Enter Your Name" : null,
                    hintText: "Enter Name"),
              ),
              // IntlPhoneField( controller: t2,
              //   decoration: InputDecoration(
              //     hintText: 'Phone Number',
              //     // icon: Icon(Icons.account_circle),
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(),
              //     ),
              //   ),
              //   onChanged: (phone) {
              //     print(phone.completeNumber);
              //   },
              //   onCountryChanged: (country) {
              //     print('Country changed to: ' + country.name);
              //   },
              // ),

              TextField(
                cursorColor: Colors.black,
                controller: t2,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    errorText: (contact_=true) ? "Enter Your Contact No" : null,
                    hintText: "Enter Contact No"),
              ),
              TextField(
                cursorColor: Colors.black,
                controller: t3,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    errorText: (email_=true) ? "Enter Your Email Id" : null,
                    hintText: "Enter Email Id"),
              ),
              TextField(
                obscureText: !_passwordVisible,
                cursorColor: Colors.black,
                controller: t4,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _passwordVisible = true;
                        });
                      },
                      onLongPressUp: () {
                        setState(() {
                          _passwordVisible = false;
                        });
                      },
                      child: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off),
                    ) ,
                    errorText:  (password_=true)?"Enter Your Password":null ,
                    hintText: "Enter Pass"),

              ),

              // DropDownTextField(controller: t6,
              //    clearOption: true,
              //    dropdownColor: Colors.blue,
              //    dropDownList: [
              //      DropDownValueModel(name: "Surat", value: "Surat"),
              //      DropDownValueModel(name: "Rajkot", value: "Rajkot"),
              //      DropDownValueModel(name: "Baroda", value: "Baroda"),
              //      DropDownValueModel(name: "Mumbai", value: "Mumbai"),
              //   ],onChanged: (value) {
              //   Sel_City=value!;
              //        print(value);
              //    setState(() {});
              //   },),
              Text("Select the City"),
              DropdownButton(
                value: Sel_City,
                dropdownColor: Colors.blue,
                items: [
                  DropdownMenuItem(
                    child: Text("surat"),
                    value: "surat",
                  ),
                  DropdownMenuItem(
                    child: Text("Baroda"),
                    value: "Baroda",
                  ),
                  DropdownMenuItem(
                    child: Text("Mumbai"),
                    value: "Mumbai",
                  ),
                  DropdownMenuItem(
                    child: Text("Rajkot"),
                    value: "Rajkot",
                  ),
                ],
                onChanged: (value) {
                  Sel_City = value.toString();
                  setState(() {});
                },
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Text(
                  "Gender",
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RadioMenuButton(
                      value: "Male",
                      groupValue: Gender,
                      onChanged: (value) {
                        Gender = value!;
                        print(Gender);

                        setState(() {});
                      },
                      child: Text("Male")),
                  RadioMenuButton(
                      value: "Female",
                      groupValue: Gender,
                      onChanged: (value) {
                        Gender = value!;

                        setState(() {});
                      },
                      child: Text("Female")),
                  RadioMenuButton(
                      value: "Other",
                      groupValue: Gender,
                      onChanged: (value) {
                        Gender = value!;

                        setState(() {});
                      },
                      child: Text("Other")),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Text(
                  "Skill",
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                children: [
                  CheckboxMenuButton(
                      value: check,
                      onChanged: (value) {
                        check = value as bool;
                        setState(() {});
                      },
                      child: Text("Flutter")),
                  CheckboxMenuButton(
                      value: check1,
                      onChanged: (value) {
                        check1 = value as bool;

                        setState(() {});
                      },
                      child: Text("Laravel")),
                  CheckboxMenuButton(
                      value: check2,
                      onChanged: (value) {
                        check2 = value as bool;

                        setState(() {});
                      },
                      child: Text("Recat Native")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Text("Upload Images"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Upload the Images"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      images = await picker.getImage(
                                          source: ImageSource.camera);
                                      is_img = true;
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text("Camera")),
                                TextButton(
                                    onPressed: () async {
                                      images = await picker.getImage(
                                          source: ImageSource.gallery);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text("Gallary"))
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Upload")),
                  Container(
                    height: 100,
                    width: 100,
                    child: (widget.ob != null)
                        ? (is_img == true)
                            ? Image.file(File(images!.path))
                            : Image.file(File(widget.ob!.images))
                        : (images != null)
                            ? Image.file(File(images!.path))
                            : Icon(Icons.account_circle),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {

                        String name,
                            contact,
                            email,
                            passwrod,
                            city,
                            gender,
                            _skill,
                            img;
                        var dir_path = await ExternalPath
                            .getExternalStoragePublicDirectory(
                            ExternalPath.DIRECTORY_DOWNLOADS) +
                            "/studentimage";
                        Directory dir = Directory(dir_path);
                        if (!await dir.exists()) {
                          dir.create();
                        }
                        String img_name = "myimg${Random().nextInt(1000)}.jpg";
                        File file = File("${dir_path}/${img_name}");
                        print("Images Path:- ${file.path}");

                        file.writeAsBytes(await images!.readAsBytes());
                        name = t1.text;
                        contact = t2.text;
                        email = t3.text;
                        passwrod = t4.text;
                        city = Sel_City;
                        gender = Gender;
                        img = file.path;

                        name_ = false;
                        contact_ = false;
                        email_ = false;
                        password_ = false;

                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = new RegExp(pattern);

                        if (name == "") {
                           name_ == true;
                           ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text("Enter YOur  Name")));
                           setState(() {});


                        } else if (contact == "") {
                          contact_ = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter YOur  NUmber")));
                          setState(() {});
                        } else if(!regExp.hasMatch(contact)){

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter YOur  NUmber")));
                          setState(() {});
                        }

                        else if (email == "") {
                          email_ = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter YOur  Mail ID")));
                          setState(() {});
                        }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email)){
                          email_ = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter YOur  Mail ID")));
                          setState(() {});

                        }
                        else if (passwrod == "") {
                          password_ = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter YOur  Passwrod")));
                          setState(() {});
                        } else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                            .hasMatch(passwrod)){
                          password_ = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter Your  Strong Passwrod")));
                          setState(() {});
                        }

                        else {
                          StringBuffer sb = StringBuffer();
                          if (check == true) {
                            sb.write("Flutter");
                          }
                          if (check1 == true) {
                            if (sb.length > 0) {
                              sb.write("/");
                            }
                            sb.write("Laravel");
                          }
                          if (check2 == true) {
                            if (sb.length > 0) {
                              sb.write("/");
                            }
                            sb.write("Recat Native");
                          }
                          _skill = sb.toString();

                          if (widget.ob != null) {

                            if (is_img = true) {
                              File f1 = File("${widget.ob!.images}");
                              f1.delete();

                              File file = File("${dir_path}/${img_name}");
                              img = file.path;
                              file.writeAsBytes(await images!.readAsBytes());
                            } else {
                              img = file.path;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Upload IMages")));
                            }
                          } else {
                            if (is_img = true) {
                              File file = File("${dir_path}/${img_name}");
                              img = file.path;
                              file.writeAsBytes(await images!.readAsBytes());
                            } else {
                              img = file.path;
                            }
                          }

                          if (widget.ob != null) {

                            widget.ob!.name = name;
                            widget.ob!.contact = contact;
                            widget.ob!.email = email;
                            widget.ob!.passwrod = passwrod;
                            widget.ob!.city = city;
                            widget.ob!.gender = gender;
                            widget.ob!.skill = _skill;
                            widget.ob!.images = img;


                          } else {
                            if (is_img == true) {
                              form_data f = form_data(name, contact, email,
                                  passwrod, city, gender, _skill, img);
                              box.add(f);
                              print(f);
                            }
                          }
                        }
                      },


                      child: Text("Submit")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Student_List();
                          },
                        ));
                      },
                      child: Text("View"))
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}
