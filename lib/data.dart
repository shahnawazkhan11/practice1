import 'dart:convert';
import 'package:flutter/services.dart';

class Plant {
  final String name;
  final String category;
  // Using generic placeholder if image fails, simple string for json
  final String image;

  Plant({required this.name, required this.category, required this.image});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'],
      category: json['category'],
      image: json['image'] ?? '',
    );
  }
}

Future<List<Plant>> loadPlants() async {
  final String response = await rootBundle.loadString('assets/plant.json');
  final List<dynamic> data = json.decode(response);
  return data.map((json) => Plant.fromJson(json)).toList();
}