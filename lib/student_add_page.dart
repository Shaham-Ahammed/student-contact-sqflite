import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'student_list.dart';
import 'package:flutter/services.dart';
import 'db_helper.dart';
import 'package:image_picker/image_picker.dart';

class StudentAdd extends StatefulWidget {
  StudentAdd({Key? key}) : super(key: key);

  @override
  State<StudentAdd> createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAdd> {
  String? groupValue;
   String? imagePath;
  late ImageSource _imageSource ;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> allData = [];

  void refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

 

  Future<void> addData() async {
    await SQLHelper.createData(nameController.text, ageController.text,
        phoneController.text, imagePath.toString(), groupValue.toString());
    refreshData();
  }

  bool _isPhotoSelected = false;
  bool photoerrorVisible = false;
  bool genderErrorVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        title: Text(
          "ADD STUDENT",
          style: GoogleFonts.alatsi(),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
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
                        color: Colors.cyan),
                    child: imagePath == null
                        ? Image.asset(
                            'assets/users.png',
                            fit: BoxFit.cover,
                          )
                        : Image.file(
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
                    backgroundColor: Color.fromARGB(255, 10, 199, 251),
                  )),
              Positioned(right: 80, top: 107, child: Icon(Icons.add_a_photo))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          if (photoerrorVisible && imagePath==null)
            Text(
              'Please add a photo',
              style: TextStyle(color: Colors.red),
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
                              style: myStyle(12, FontWeight.bold, Colors.black))
                        ],
                      ),
                    ],
                  ),
                  if (genderErrorVisible && groupValue==null)
                    Text(
                      'Please select a gender',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.cyan)),
              onPressed: () async {
                if (!_isPhotoSelected) {
                  setState(() {
                    photoerrorVisible = true;
                  });
                }
                if (groupValue == null) {
                  setState(() {
                    genderErrorVisible = true;
                  });
                }
                if (_formKey.currentState!.validate() &&
                    _isPhotoSelected == true &&
                    groupValue != null) {
                  await addData();

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => StudentList()),
                      (route) => false);
                } else {
                  return;
                }
              },
              child: Text(
                "ADD STUDENT",
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
        _isPhotoSelected = true;
      });
    }
  }
}

myStyle(double size, FontWeight weight, Color clr) {
  return TextStyle(fontSize: size, fontWeight: weight, color: clr);
}
