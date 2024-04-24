import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webmydairy/SharedPreferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeProvider extends ChangeNotifier {
  var value;
  bool isLoading = false;
  WebViewController webController = WebViewController();
  initUrlData() {
    webController.loadRequest(Uri.parse(value == true
        ? "https://www.mydairy.tech/sy-admin"
        : "https://www.mydairy.tech/sy-admin"));
  }

  getData() {
    value = UserData.getData<bool>(UserData.loginKey);
  }

  Future<void> refresh() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      await webController.reload();
      await Future.delayed(const Duration(seconds: 2));
      isLoading = false;
      notifyListeners();
    }
  }

  signIn(urlValue) async {
    final url = urlValue;
    if (url == "https://www.mydairy.tech/sy-admin") {
      UserData.setData(UserData.loginKey, true);
      await UserData.getUserDetails();
    }
  }

  logOut(urlValue) async {
    final url = urlValue;
    if (url == "https://www.mydairy.tech/sy-admin/logout") {
      UserData.clearUserDetails();
    }
  }

  // Future downloadFile(context, {value, fileName}) async {
  //   try {
  //     final url = value.url;
  //     var status = await Permission.storage.request();
  //     final directory = await getDownloadsDirectory();
  //
  //     if (status.isGranted) {
  //       var nameF = DateTime.now().toString() + fileName;
  //       print("uuu...$url");
  //       await FlutterDownloader.enqueue(
  //         fileName: nameF,
  //         url: url.toString(),
  //         savedDir: directory!.path,
  //         showNotification: true,
  //         openFileFromNotification: true,
  //         requiresStorageNotLow: true,
  //         saveInPublicStorage: true,
  //         allowCellular: true,
  //       );
  //       print("object........$nameF");
  //       // await OpenFile.open(nameF);
  //       snackMessage(context, "PDF downloaded successfully!", no: 2);
  //     } else {
  //       snackMessage(context, "File downloaded error");
  //     }
  //   } catch (error) {
  //     snackMessage(context, "Error downloading PDF: $error");
  //   }
  // }

  bool isSnackBarVisible = false;

  void snackMessage(BuildContext context, String msg, {int no = 1}) {
    if (!isSnackBarVisible) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg,
              style: TextStyle(
                  color: no == 1 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w900,
                  fontSize: 16)),
          backgroundColor: Colors.white,
        ),
      );
      isSnackBarVisible = true;
      Future.delayed(const Duration(seconds: 3), () {
        isSnackBarVisible = false;
      });
    }
  }

  File? imageFile;
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }

  launchURL(urlValue) async {
    final url = urlValue;
    if (await launchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
