import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_5/db_helper.dart';
import 'package:task_5/student_list.dart';

class StudentEdit extends StatefulWidget {
  final int id;
  final String name;
  final String age;
  final String image;
  final String gender;
  final String phone;
  const StudentEdit(
      {required this.id,
      required this.name,
      required this.age,
      required this.image,
      required this.gender,
      required this.phone});

  @override
  State<StudentEdit> createState() => _StudentEditState();
}

class _StudentEditState extends State<StudentEdit> {
  List<Map<String, dynamic>> allData = [];

  void refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ImageSource _imageSource = ImageSource.camera;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? imagePath;
  String? groupValue;

  Future<void> updateData(int id) async {
    await SQLHelper.updateData(id, nameController.text, ageController.text,
        phoneController.text, imagePath.toString(), groupValue.toString());
    refreshData();
  }

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    ageController = TextEditingController(text: widget.age);

    phoneController = TextEditingController(text: widget.phone);
    imagePath = widget.image;
    groupValue=widget.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "EDIT STUDENT",
          style: GoogleFonts.alatsi(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Colors.cyan[50],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(width: 5, color: Colors.cyan)),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Camera',
                                      style: myStyle(
                                          18, FontWeight.bold, Colors.black),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _imageSource = ImageSource.camera;
                                          _getImage();
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        icon: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 35,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Gallery',
                                      style: myStyle(
                                          18, FontWeight.bold, Colors.black),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _imageSource = ImageSource.gallery;
                                          _getImage();
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        icon: Icon(
                                          Icons.photo_outlined,
                                          size: 35,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ));
                },
                child: Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent),
                    child: Image.file(
                      File(
                        imagePath!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                  right: 70,
                  top: 100,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.cyan,
                  )),
              Positioned(right: 79, top: 107, child: Icon(Icons.edit))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Form(
            key: _formKey,
            child: Container(
                width: double.infinity,
                height: 360,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: "Name"),
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      validator: (value) {
                        if (value == "") {
                          return "please enter your name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: "Age"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
                      controller: ageController,
                      validator: (value) {
                        if (value == "") {
                          return "please enter your age";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          labelText: "Phone Number"),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      controller: phoneController,
                      validator: (value) {
                        if (value == "") {
                          return "please enter your phone Number";
                        } else if (value!.length != 10) {
                          return "phone number not valid";
                        } else {
                          return null;
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Select Gender :',
                          style: myStyle(16, FontWeight.bold, Colors.black),
                        ),
                        Row(
                          children: [
                            Radio(
                                activeColor: Colors.red,
                                value: 'Male',
                                groupValue: groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    groupValue = value;
                                  });
                                }),
                            Text('Male',
                                style:
                                    myStyle(12, FontWeight.bold, Colors.black)),
                            Radio(
                                activeColor: Colors.red,
                                value: 'Female',
                                groupValue: groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    groupValue = value;
                                  });
                                }),
                            Text('Female',
                                style:
                                    myStyle(12, FontWeight.bold, Colors.black))
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.cyan)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await updateData(widget.id);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => StudentList()),
                      (route) => false);
                }
              },
              child: Text(
                "EDIT STUDENT",
                style: GoogleFonts.akayaKanadaka(),
              ))
        ]),
      ),
    );
  }

  void _getImage() async {
    final selectedImage = await ImagePicker().pickImage(source: _imageSource);
    if (selectedImage != null) {
      setState(() {
        imagePath = selectedImage.path;
      });
    }
  }
}

myStyle(double size, FontWeight weight, Color clr) {
  return TextStyle(fontSize: size, fontWeight: weight, color: clr);
}
