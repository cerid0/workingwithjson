import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'serviceCards.dart';
import 'service.dart';
import 'main_screen.dart';

class CardScreen extends StatefulWidget {
  final CardItem cardItem;

  const CardScreen({Key? key, required this.cardItem}) : super(key: key);

  @override
  State<CardScreen> createState() => CardScreenState();
}

class CardScreenState extends State<CardScreen> {
  final dio = Dio();
  Person? _selectedPerson; // Eşleşen kişi buraya atanacak
  bool _isLoading = false;

  static const urlPersons =
      "http://10.0.2.2:3000/persons"; // Kişi verisi URL'si

  @override
  void initState() {
    super.initState();
    fetchSelectedPerson();
  }

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> fetchSelectedPerson() async {
    _changeLoading();
    try {
      final response = await dio.get(urlPersons);

      if (response.statusCode == HttpStatus.ok) {
        final data = response.data;

        if (data is List) {
          final items = data.map((e) => Person.fromJson(e)).toList();

          // Tıklanan kartın ID'sine göre eşleşen kişiyi bul
          final person = items.firstWhere(
            (item) => item.id == widget.cardItem.id,
            orElse: () => Person(id: "0", name: "Bulunamadı", age: 0),
          );

          setState(() {
            _selectedPerson = person;
          });
        }
      }
    } catch (e) {
      print("Kişiyi Çekerken Hata: $e");
    }
    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card: ${widget.cardItem.title}")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _selectedPerson != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ad: ${_selectedPerson?.name}",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text("Yaş: ${_selectedPerson?.age}",
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                )
              : const Center(child: Text("Veri bulunamadı")),
    );
  }
}
