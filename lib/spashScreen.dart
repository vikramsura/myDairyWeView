import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmydairy/homePage.dart';
import 'package:webmydairy/homeProvider.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    Provider.of<HomeProvider>(context, listen: false).getData();
    Provider.of<HomeProvider>(context, listen: false).initUrlData();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/Splash.png'),
              fit: BoxFit.cover)),
    ));
  }
}
