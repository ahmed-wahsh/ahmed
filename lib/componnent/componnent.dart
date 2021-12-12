import 'package:flutter/material.dart';

Widget DefaultButton({
 Color BackGround = Colors.blue,
  double width = double.infinity,
  Function function,
 @required String text,
  bool UPPERCASE =true,
  double Radius,

})=> Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Radius),
        color: BackGround,
      ),

  width: width,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      UPPERCASE?text.toUpperCase():text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  ),
);

Widget DefaultFormTextField({
  @required TextInputType type ,
  @required bool obscureText ,
  @required String text,
  @required IconData Prefix ,
  IconData Suffix ,
  Function Submited,
  Function  changed,
  Function suffixPressed,
  Function ONTAP,
   Controller,
  Function validate,

})=>TextFormField(
keyboardType: type,
obscureText: obscureText,
onFieldSubmitted: Submited,
onChanged:  changed,
onTap: ONTAP,

controller: Controller,
validator: validate,
decoration: InputDecoration(
labelText: text,
border: OutlineInputBorder(),
prefixIcon: Icon(Prefix,) ,

suffixIcon: IconButton(icon: Icon(Suffix),onPressed:suffixPressed,),



),
);