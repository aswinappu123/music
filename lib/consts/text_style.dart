import 'package:flutter/material.dart';

const bold = "bold";
const regular = "regular";

ourstyle({family = regular, double? size = 14, Colorsblack}) {
  return TextStyle(
    fontSize: size,
    color: Colors.black,
    fontFamily: family,
  );
}
