// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/avatar.dart';
import 'package:digital_clock/card_unit.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  // _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  AnimationController _controllerHour, _controllerMinute;
  Animation<Offset> _offsetAnimation;

  bool toggleMinute = true;
  bool toggleHour = true;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();

    _controllerHour =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _controllerMinute =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    //..forward();

//    _controller = AnimationController(
//      duration: const Duration(seconds: 2),
//      vsync: this,
//    )..repeat(reverse: true);
//    _offsetAnimation = Tween<Offset>(
//      begin: Offset.zero,
//      end: const Offset(1.5, 0.0),
//    ).animate(CurvedAnimation(
//      parent: _controller,
//      curve: Curves.elasticIn,
//    ));
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    _controllerHour.dispose();
    _controllerMinute.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      toggleMinute = !toggleMinute;
      // Update once per minute. If you want to update every second, use the
      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = _dateTime.second;

    final offset = 2.0; //-fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      //fontFamily: 'PressStart2P',
      //fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(5, 0),
        ),
      ],
    );

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final boxSize = height / 1.5;
    final fontSize = boxSize - 40;

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: 0,
                  top: offset,
                  bottom: offset,
                  right: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(seconds: 5),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: Padding(
                            key: ValueKey<int>(int.parse(hour)),
                            padding: EdgeInsets.all(8.0),
                            child: CardUnit(
                              width: boxSize,
                              height: boxSize,
                              text: hour,
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                        Icon(Icons.audiotrack,
                            color: (toggleMinute)
                                ? Colors.teal
                                : Colors.black),
                        AnimatedSwitcher(
                          duration: Duration(seconds: 4),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: Padding(
                            key: ValueKey<int>(int.parse(minute)),
                            padding: EdgeInsets.all(8.0),
                            child: CardUnit(
                              width: boxSize,
                              height: boxSize,
                              text: minute,
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}
