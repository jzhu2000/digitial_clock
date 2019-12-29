// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/avatar.dart';
import 'package:digital_clock/card_unit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

enum _Element {
  background,
  text,
  shadow,
  weatherText,
  locationText,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.black,
  _Element.shadow: Colors.black,
  _Element.weatherText: Colors.teal,
  _Element.locationText: Colors.teal,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
  _Element.weatherText: Colors.teal,
  _Element.locationText: Colors.teal,
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

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  bool toggleSecond = true;

  //location
  String location;

  //temp
  String tempDegree;
  String tempUnit;
  int tempLow;
  int tempHigh;

  IconData weatherIcon;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
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
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
      location = widget.model.location;
      var tempString = widget.model.temperatureString;
      tempDegree = tempString
          .substring(0, tempString.length - 2)
          .substring(0, tempString.lastIndexOf('.'));
      tempUnit = tempString.substring(tempString.length - 2);
      tempHigh = widget.model.high.round();
      tempLow = widget.model.low.round();

      WeatherCondition weatherCondition = widget.model.weatherCondition;
      switch (weatherCondition) {
        case (WeatherCondition.cloudy):
          weatherIcon = WeatherIcons.cloudy;
          break;

        case (WeatherCondition.foggy):
          weatherIcon = WeatherIcons.fog;
          break;

        case (WeatherCondition.rainy):
          weatherIcon = WeatherIcons.rain;
          break;

        case (WeatherCondition.sunny):
          weatherIcon = WeatherIcons.day_sunny;
          break;

        case (WeatherCondition.thunderstorm):
          weatherIcon = WeatherIcons.thunderstorm;
          break;

        case (WeatherCondition.windy):
          weatherIcon = WeatherIcons.windy;
          break;

        default:
          weatherIcon = null;
          break;
      }
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      toggleSecond = !toggleSecond;
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
    final am = DateFormat('a').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = _dateTime.second;
    final today = DateFormat('yMd').format(_dateTime);


    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      //fontFamily: 'PressStart2P',
      //fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(4, 0),
        ),
      ],
    );

    final weatherStyle = TextStyle(
      color: colors[_Element.weatherText],
      //fontFamily: 'PressStart2P',
      //fontSize: fontSize,
    );

    final locationStyle = TextStyle(
      color: colors[_Element.locationText],
      //fontFamily: 'PressStart2P',
      //fontSize: fontSize,
    );

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final boxSize = height / 1.5;
    final fontSize = boxSize * 0.85;
    final fontSizeSecond = boxSize * 0.4;
    final offset = 2.0; //-fontSize / 7;

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: Stack(
          children: <Widget>[
            //location
            Positioned(
              top: offset,
              left: offset,
              //right: offset,
              child: DefaultTextStyle(
                style: locationStyle,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CardUnit(
                    width: width / 2,
                    height: boxSize / 4,
                    text: location,
                    fontSize: fontSize / 8,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Positioned(
              top: offset,
              right: offset,
              child: DefaultTextStyle(
                style: locationStyle,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CardUnit(
                    width: width / 3,
                    height: boxSize / 4,
                    text: today,
                    fontSize: fontSize / 10,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),

            //clock with am pm
            Positioned(
                left: 0,
                top: offset,
                bottom: offset,
                right: 0,
                child: DefaultTextStyle(
                    style: defaultStyle,
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
                          Text(
                            ":",
                            style: new TextStyle(
                                color:
                                    toggleSecond ? Colors.black : Colors.white,
                                fontSize: fontSizeSecond ?? 20.0,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 0,
                                    offset: Offset(0, 0),
                                  ),
                                ]),
                          ),
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
                        ]))),
            Positioned(
              bottom: offset * 20,
              right: offset,
              child: CardUnit(
                width: boxSize / 2.5,
                height: boxSize / 4,
                text: widget.model.is24HourFormat ? am : am,
                fontSize: fontSize / 4,
              ),
            ),

            Positioned(
              bottom: offset,
              left: offset * 15,
              child: CardUnit(
                width: width / 2,
                height: boxSize / 4,
                text: "Hi ${tempHigh}  Lo ${tempLow}",
                fontSize: fontSize / 10,
                fontWeight: FontWeight.normal,
              ),
            ),

            Positioned(
              bottom: offset * 2,
              left: offset,
              right: offset,
              child: CardUnit(
                width: width,
                height: boxSize / 4,
                text: tempDegree,
                fontSize: fontSize / 4,
                fontWeight: FontWeight.normal,
              ),
            ),

            Positioned(
              bottom: offset * 8,
              left: width / 2 - 30,
              child: CardUnit(
                width: boxSize / 4,
                height: boxSize / 4,
                text: tempUnit,
                fontSize: fontSize / 10,
                fontWeight: FontWeight.normal,
              ),
            ),

            Positioned(
                bottom: height / 5,
                left: width / 3 + boxSize / 4,
                child: Icon(
                  weatherIcon,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );
  }
}
