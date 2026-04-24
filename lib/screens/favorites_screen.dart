import 'package:flutter/material.dart';
import '../data/quotes_data.dart';
import '../models/quote.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<int> favoriteIds;

  const FavoritesScreen({super.key, required this.favoriteIds});

  @override
  Widget build(BuildContext context) {
    final List<Quote> favoriteQuotes = quotes
        .where((q) => favoriteIds.contains(q.id))
        .toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Шапка с кнопкой «Назад»
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const Text(
                      'Избранное',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),

              // Список или пустое состояние
              Expanded(
                child: favoriteQuotes.isEmpty
                    ? const Center(
                        child: Text(
                          'Пока ничего нет.\nНажмите ❤️ на понравившейся цитате.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: favoriteQuotes.length,
                        itemBuilder: (context, index) {
                          final q = favoriteQuotes[index];
                          return Card(
                            color: Colors.white.withValues(alpha: 0.08),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    q.text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '— ${q.author}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.deepPurpleAccent.shade100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
