import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/image_controller.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  final ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logodeteksi.png',
              height: 30,
            ),
            SizedBox(width: 10),
            Text(
              'LEAFSENSE',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/bannerdeteksi.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'), // Path gambar background
              fit: BoxFit
                  .contain, // Gambar akan menyesuaikan layar tanpa terpotong
              alignment:
                  Alignment.topCenter, // Sesuaikan ukuran gambar dengan layar
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Obx(() => imageController.image.value == null
                    ? Text("Pilih gambar tanaman", textAlign: TextAlign.center)
                    : Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.file(
                                        imageController.image.value!,
                                        height: 200),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: imageController.clearImage,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.0,
                                              horizontal: 16.0)),
                                      icon: Image.asset(
                                        'assets/deleteicon.png',
                                        height: 24,
                                      ),
                                      label: Text('Hapus Gambar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            imageController.pickImage(ImageSource.gallery),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0)),
                        icon: Icon(Icons.photo_library, color: Colors.white),
                        label: Text('Pilih dari Galeri',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            imageController.pickImage(ImageSource.camera),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0)),
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        label: Text('Ambil dari Kamera',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Obx(() => imageController.isLoading.value
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: imageController.detectDisease,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.green),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 32.0)),
                          child: Text('Deteksi',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )),
                SizedBox(height: 16),
                Obx(() => imageController.result.isNotEmpty
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Hasil Deteksi",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Table(
                                border: TableBorder.all(color: Colors.green),
                                columnWidths: {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(2),
                                },
                                children: [
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Penyakit:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(imageController.result.value),
                                    ),
                                  ]),
                                ],
                              ),
                              SizedBox(height: 16),
                              imageController.inferencedImage.value != null
                                  ? Column(
                                      children: [
                                        Text("Gambar Hasil Inferensi",
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.memory(
                                              imageController
                                                  .inferencedImage.value!,
                                              height: 200),
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(height: 16),
                              imageController.insight.value.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("Insight Penyakit",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        Text(
                                          imageController.insight.value,
                                          style: TextStyle(fontSize: 14),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
