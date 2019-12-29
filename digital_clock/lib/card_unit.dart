import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * Created by jzhu on 2019-12-26.
 *
 * Put class description. No logic
 *
 * @param T the type of a member in this group.
 * @property name the name of this group.
 * @constructor Creates an empty group.
 */
class CardUnit extends StatelessWidget {

  final String text;
  final double height;
  final double width;
  final double fontSize;
  final FontWeight fontWeight;
  final FractionalOffset align;
  final bool  withBoxDecoration;

  CardUnit({Key key,
    this.text,
    this.height = 150.0,
    this.width = 150.0,
    this.fontSize = 100.0,
    this.fontWeight = FontWeight.bold,
    this.align = FractionalOffset.center,
    this.withBoxDecoration = false} ): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      height: height,
      width: width,

      decoration: BoxDecoration(
      border: withBoxDecoration? Border.all(color: new Color(0xFF9E9E9E)) :  null,//Border.all(color: new Color(0xFF9E9E9E)),
    ),
      child: Text(text,
        style: new TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
        ),
      ),
    );
  }
}