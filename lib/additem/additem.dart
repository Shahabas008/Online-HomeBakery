import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nihaljumailamrathaju/resources/authpageforadditem.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:path/path.dart';

List<String> list = <String>[
  'Cake',
  'Pudding',
  'Snack',
  'Ice Cream ',
  'Sweets',
  'Pizza'
];

class Additempage extends StatefulWidget {
  const Additempage({super.key});

  @override
  State<Additempage> createState() => _AdditempageState();
}

class _AdditempageState extends State<Additempage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String fileName = "";
  String downloadUrl = "";

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path());
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path());
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }




  Future uploadFile() async {
    if (_photo == null) return;
    fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final uploadimage = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await uploadimage.putFile(_photo!);

      downloadUrl = await uploadimage.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Add item')
          .doc(dropdownValue)
          .collection('item')
          .add({"url": downloadUrl, "name": fileName});
    } catch (e) {
      print('error occured');
    }
  }

  final itemdescription = TextEditingController();
  final priceofitem = TextEditingController();
  final netweight = TextEditingController();
  final bakersdescription = TextEditingController();
  final itemname = TextEditingController();

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xffffafcc),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          child: _photo != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.zero,
                                  child: Image.file(
                                    _photo!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 100,
                                  height: 100,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        )))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: itemname,
                  maxLines: null,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 254, 254),
                          width: 2.0),
                    ),
                    labelText: 'Item Name',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: itemdescription,
                  maxLines: null,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 254, 254),
                          width: 2.0),
                    ),
                    labelText: 'Item Description',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: priceofitem,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 254, 254),
                          width: 2.0),
                    ),
                    labelText: 'Price of Item',
                  ),
                  inputFormatters: <TextInputFormatter>[
                    CurrencyTextInputFormatter(
                      locale: 'en',
                      decimalDigits: 0,
                      symbol: '₹ ',
                    ),
                  ],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: netweight,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 254, 254),
                          width: 2.0),
                    ),
                    labelText: 'Net Weight',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: bakersdescription,
                  maxLines: null,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 254, 254),
                          width: 2.0),
                    ),
                    labelText: 'Baker Description',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  DropdownButton<String>(
                    hint: const Text('Select An Item'),
                    value: dropdownValue,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.blue,
                    ),
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ])
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      String res = await Authmethods3().additem(
                          itemname :itemname.text,
                          itemdescription: itemdescription.text,
                          priceofitem: priceofitem.text,
                          netweight: netweight.text,
                          bakersdescription: bakersdescription.text,
                          dropdownValue: dropdownValue,
                          fileName: fileName,
                          downloadUrl: downloadUrl
                          );

                      debugPrint(res);
                      push();
                    },
                    child: const Text('Submit'))
              ],
            )
          ]),
        ),
      ),
    ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void push() {
    Navigator.pushNamed(this.context, "homelayout");
  }
}
