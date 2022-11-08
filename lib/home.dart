import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  XFile? _image;
  List? _output;
  final picker = ImagePicker();

  void initState() {
    loadModel().then((value) {
      setState(() {});
    });
  }

  detectImage(XFile image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.2,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //select image from camera
  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = XFile(image.path);
    });
    detectImage(_image!);
  }

  //select image from gallery
  pickGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = XFile(image.path);
    });
    detectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "S-Code",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Cats and Dogs Finder App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: _loading
                    ? Container(
                        width: 200,
                        child: Column(
                          children: [
                            Image.asset("assets/cat_dog_icon.png"),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                          children: [
                            // SizedBox(
                            //   height: 250,
                            //   child: Image.file(),
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            _output != null
                                ? Text(
                                    "${_output![0]['label']}",
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Capture Image",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        pickGallery();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Image from Gallery",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
