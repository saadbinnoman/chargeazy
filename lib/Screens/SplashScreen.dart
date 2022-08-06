import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vehicle/Screens/LoginScreen.dart';

import '../Dimes.dart';
import '../Utils/Colors.dart';
import 'Models/SliderModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<SliderModel> mySLides = <SliderModel>[];
  int slideIndex = 0;
  late PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 700,
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    slideIndex = index;
                  });
                },
                children: <Widget>[
                  SlideTile(
                    imagePath: mySLides[0].getImageAssetPath(),
                    title: mySLides[0].getTitle(),
                    desc: mySLides[0].getDesc(),
                  ),
                  SlideTile(
                    imagePath: mySLides[1].getImageAssetPath(),
                    title: mySLides[1].getTitle(),
                    desc: mySLides[1].getDesc(),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                    controller: controller,
                    // PageController
                    count: 2,
                    effect: const ExpandingDotsEffect(
                        dotHeight: 7,
                        dotWidth: 6,
                        dotColor: Colors.grey,
                        activeDotColor: AppColor.themeColor),
                    // your preferred effect
                    onDotClicked: (index) {}),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 80,
        decoration: const BoxDecoration(color: Colors.white),
        child: slideIndex != 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      controller.animateToPage(slideIndex + 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          color: AppColor.themeColor,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: Text(
                        "Next",
                        style: GoogleFonts.muli(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            : InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 45,
                      width: 350,
                      decoration: BoxDecoration(
                          color: AppColor.themeColor,
                          borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.center,
                      child: Text(
                        "Let's Get Started",
                        style: GoogleFonts.muli(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

  SlideTile({required this.imagePath, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Spaceheight100,
          Image.asset(
            imagePath,
            height: 328,
            width: 352,
          ),
          Spaceheight50,
          Text(
            title,
            textAlign: TextAlign.left,
            style: GoogleFonts.muli(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Spaceheight20,
          Text(
            desc,
            textAlign: TextAlign.left,
            style: GoogleFonts.muli(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
