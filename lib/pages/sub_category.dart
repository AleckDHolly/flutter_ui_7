import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class SubCategories extends StatelessWidget {
  SubCategories({
    super.key,
    required this.subCategory,
    required this.lottie,
  });

  String? subCategory;
  String lottie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 11, 85, 146),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 80,
          width: 80,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Lottie.asset(lottie),
          ),
        ),
        Text(
          "${subCategory}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
