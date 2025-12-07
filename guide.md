# Loading Dynamic Data from JSON in Flutter

## Overview
This guide explains how to load data from `assets/plant.json` and use it in your Flutter app.

## Steps

### 1. Create the JSON File
Create `assets/plant.json` with your data:
```json
[
  {
    "name": "Aloe Vera",
    "category": "Indoor",
    "image": "assets/images/plant1.png"
  },
  {
    "name": "Snake Plant",
    "category": "Indoor",
    "image": "assets/images/plant2.png"
  }
]
```

### 2. Register Assets in pubspec.yaml
Add the asset path in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/plant.json
    - assets/images/
```

### 3. Create Data Model (data.dart)
```dart
import 'dart:convert';
import 'package:flutter/services.dart';

class Plant {
  final String name;
  final String category;
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
```

### 4. Load Data in Widget (home.dart)
```dart
class _HomesScreenState extends State<HomesScreen> {
  List<Plant> _allPlants = [];
  List<Plant> _filteredPlants = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var plants = await loadPlants();
    setState(() {
      _allPlants = plants;
      _filteredPlants = plants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _filteredPlants.length,
      itemBuilder: (context, index) {
        final plant = _filteredPlants[index];
        return ListTile(
          leading: Image.asset(plant.image),
          title: Text(plant.name),
          subtitle: Text(plant.category),
        );
      },
    );
  }
}
```

## Key Points
- Use `rootBundle.loadString()` to read JSON files from assets
- `json.decode()` converts JSON string to Dart objects
- Load data in `initState()` when the widget is created
- Use `setState()` to update the UI after data loads
- Access data with `plant.name`, `plant.category`, `plant.image`

---

## Detailed Explanations

### What is `factory` in Dart?

A **factory constructor** is a special type of constructor that doesn't always create a new instance of the class. It can:
- Return a cached instance
- Return a subclass instance
- Perform complex initialization logic before creating an object

```dart
factory Plant.fromJson(Map<String, dynamic> json) {
  return Plant(
    name: json['name'],
    category: json['category'],
    image: json['image'] ?? '',
  );
}
```

**Why use factory here?**
- Named constructor pattern: `Plant.fromJson` clearly indicates it creates a Plant from JSON
- Flexibility: Could add validation, caching, or error handling before returning the object
- Common pattern in Dart for deserialization

### Understanding `Plant.fromJson(Map<String, dynamic> json)`

**Are these parameters fixed?**
- `Plant.fromJson` - The name can be anything (e.g., `Plant.fromMap`, `Plant.parse`)
- `Map<String, dynamic>` - **This is the standard type for JSON objects in Dart**
  - `Map<String, dynamic>` means: a map with String keys and values of any type
  - This matches JSON structure: `{"name": "Aloe", "category": "Indoor"}`
- The parameter name `json` can be anything (e.g., `data`, `map`)

**Example variations:**
```dart
factory Plant.fromMap(Map<String, dynamic> data) { ... }
factory Plant.parse(Map<String, dynamic> input) { ... }
```

### Understanding `data.map((json) => Plant.fromJson(json)).toList()`

Let's break down this line step by step:

```dart
return data.map((json) => Plant.fromJson(json)).toList();
```

**Step 1: `data`**
- This is `List<dynamic>` - a list of JSON objects
- Example: `[{"name": "Aloe", "category": "Indoor"}, {"name": "Snake Plant", "category": "Indoor"}]`

**Step 2: `.map((json) => Plant.fromJson(json))`**
- `map()` transforms each item in the list
- For each item (called `json` here), it runs `Plant.fromJson(json)`
- Converts each JSON object into a Plant object
- Returns an `Iterable<Plant>` (not a List yet)

**Step 3: `.toList()`**
- Converts the `Iterable<Plant>` into `List<Plant>`
- Now you have a proper list of Plant objects

**Visual Example:**
```dart
// Input data:
[
  {"name": "Aloe", "category": "Indoor"},
  {"name": "Snake Plant", "category": "Indoor"}
]

// After .map():
Iterable<Plant> [
  Plant(name: "Aloe", category: "Indoor"),
  Plant(name: "Snake Plant", category: "Indoor")
]

// After .toList():
List<Plant> [
  Plant(name: "Aloe", category: "Indoor"),
  Plant(name: "Snake Plant", category: "Indoor")
]
```

**Alternative (more verbose) way to write the same thing:**
```dart
List<Plant> plants = [];
for (var json in data) {
  Plant plant = Plant.fromJson(json);
  plants.add(plant);
}
return plants;
```

The `.map().toList()` pattern is just a shorter, more functional way to write this loop!
