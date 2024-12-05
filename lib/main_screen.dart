import 'dart:io';
import 'package:flutter/material.dart';
import 'card_screen.dart';
import 'package:dio/dio.dart';
import 'serviceCards.dart';
part './widgets/organization_app_bar.dart';

class CardItem {
  final String id;
  final String title;
  final String? imageUrl;

  CardItem({required this.id, required this.title, this.imageUrl});

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['id'],
      title: 'Card ${json['id']}',
      imageUrl: json['url'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<CardScreenState> cardScreenKey = GlobalKey();
  static const urlCards = "http://10.0.2.2:3000/cards";
  final dio = Dio();
  List<CardItem> cardItems = [];

  Future<void> fetchCard() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await dio.get(urlCards);
      if (response.statusCode == HttpStatus.ok) {
        final data = response.data;

        if (data is List) {
          final items = data.map((e) => CardItem.fromJson(e)).toList();
          setState(() {
            cardItems = items;
          });
        }
      }
    } catch (exception) {
      print("Kartlardan Veri çekme hatası: $exception");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCard(); // Başlatıldığında kartları çek
  }

  Future<void> _refreshList() async {
    // Verileri yenilemek için yeniden çekiyoruz
    await fetchCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartlar'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: ListView(
          children: [
            const Padding(
              padding: const EdgeInsets.only(left: 50),
              child: const Text(
                'Hangi Hizmete İhtiyacınız Var ?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              child: PageView.builder(
                padEnds: false,
                physics: const ClampingScrollPhysics(),
                controller: PageController(viewportFraction: 0.9),
                itemCount: cardItems.length,
                itemBuilder: (context, index) {
                  final cardItem = cardItems[index];
                  return UnconstrainedBox(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CardScreen(cardItem: cardItem),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.red,
                          child: cardItem.imageUrl != null
                              ? Image.network(
                                  cardItem.imageUrl!,
                                  fit: BoxFit.contain,
                                )
                              : const Center(
                                  child: const Text(
                                    'Resim Yok',
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
