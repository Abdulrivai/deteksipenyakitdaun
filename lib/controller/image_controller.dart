import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var image = Rx<File?>(null);
  var inferencedImage = Rx<Uint8List?>(null);
  var result = "".obs;
  var insight = "".obs;
  var isLoading = false.obs;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      inferencedImage.value = null;
      result.value = "";
      insight.value = "";
      isLoading.value = false;
    }
  }

  Future<File?> compressImage(File file) async {
    final String targetPath = file.path.replaceAll(".jpg", "_compressed.jpg");
    final XFile? compressedXFile =
        await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );
    return compressedXFile != null ? File(compressedXFile.path) : null;
  }

  Future<void> detectDisease() async {
    if (image.value == null) return;
    isLoading.value = true;
    result.value = "";
    insight.value = "";

    final String apiUrl =
        "https://mencoba-skripsi-production.up.railway.app/predict";
    final File? compressedImage = await compressImage(image.value!);
    if (compressedImage == null) {
      result.value = "Gagal mengompresi gambar.";
      isLoading.value = false;
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files
        .add(await http.MultipartFile.fromPath('file', compressedImage.path));
    request.headers['Content-Type'] = 'multipart/form-data';

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(responseData);
        List<String> labels =
            List<String>.from(decodedResponse["detected_label"]);
        Set<String> uniqueLabels = labels.toSet();
        String? base64Image = decodedResponse["inferenced_image"];
        Uint8List? inferenced;
        if (base64Image != null && base64Image.isNotEmpty) {
          inferenced = base64Decode(base64Image);
        }
        insight.value =
            decodedResponse["insight"] ?? "Tidak ada informasi tambahan.";
        result.value = uniqueLabels.join(", ");
        inferencedImage.value = inferenced;
      } else {
        result.value =
            "Gagal mendeteksi penyakit. Kode: ${response.statusCode}";
        insight.value = "";
      }
    } catch (e) {
      result.value = "Terjadi kesalahan: $e";
      insight.value = "";
    } finally {
      isLoading.value = false;
    }
  }

  void clearImage() {
    image.value = null;
    inferencedImage.value = null;
    result.value = "";
    insight.value = "";
  }
}
