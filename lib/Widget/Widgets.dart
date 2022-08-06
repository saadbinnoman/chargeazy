import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle/Utils/Colors.dart';



class NormalText extends StatelessWidget {
  String text = "";
  double fsize;


  NormalText({required this.text, required this.fsize, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Text(
        text,
        style: GoogleFonts.poppins(fontSize: fsize,color:Colors.black ),

    );
  }
}
class BoldText extends StatelessWidget {
  String text = "";
  double fsize;
  dynamic fweight;


  BoldText({required this.text, required this.fsize,required this.fweight, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Text(
        text,
        style: GoogleFonts.poppins(fontSize: fsize,fontWeight: fweight),
      );

  }

}
class BigButton extends StatelessWidget {
  String text='';

   BigButton({required this.text,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width:double.infinity,
      height: 45.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.themeColor,
      ),
      child:Center(

          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),

      ),
    );
  }
}



