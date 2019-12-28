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

  CardUnit({Key key, this.text, this.height, this.width, this.fontSize } ): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: FractionalOffset.center,
      height: height ?? 150.0,
      width: width ?? 150.0,
//      decoration: new BoxDecoration(
//        border: new Border.all(color: new Color(0xFF9E9E9E)),
//      ),
      child: Text(text,
        style: new TextStyle(
            fontSize: fontSize ?? 100.0,
            color: Colors.black,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}