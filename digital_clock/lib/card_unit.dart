/**
 * MIT License

    Copyright (c) 2019 John Zhu

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * Created by jzhu on 2019-12-26.
 *
 * Class CardUnit is a widget for boxed text
 */
class CardUnit extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final double fontSize;
  final FontWeight fontWeight;
  final FractionalOffset align;
  final bool withBoxDecoration;

  CardUnit(
      {Key key,
      this.text,
      this.height = 150.0,
      this.width = 150.0,
      this.fontSize = 100.0,
      this.fontWeight = FontWeight.bold,
      this.align = FractionalOffset.center,
      this.withBoxDecoration = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: withBoxDecoration
            ? Border.all(color: new Color(0xFF9E9E9E))
            : null, //Border.all(color: new Color(0xFF9E9E9E)),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
