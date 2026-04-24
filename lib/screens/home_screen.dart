import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../data/quotes_data.dart';
import '../services/favorites_service.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Set<int> _favoriteIds = {};
  final FavoritesService _favService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final loaded = await _favService.loadFavorites();
    setState(() {
      _favoriteIds.addAll(loaded);
    });
  }

  @override
  Widget build(BuildContext context) {
    final quote = quotes[_currentIndex];
    final isFav = _favoriteIds.contains(quote.id);

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
              // Заголовок
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48), // пустышка для центровки
                    const Text(
                      'Focus Quotes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FavoritesScreen(favoriteIds: _favoriteIds),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite, size: 28),
                    ),
                  ],
                ),
              ),

              // Цитата по центру
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity == null) return;
                    if (details.primaryVelocity! < 0) {
                      // Свайп влево → следующая
                      if (_currentIndex < quotes.length - 1) {
                        setState(() => _currentIndex++);
                      }
                    } else if (details.primaryVelocity! > 0) {
                      // Свайп вправо → предыдущая
                      if (_currentIndex > 0) {
                        setState(() => _currentIndex--);
                      }
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '❝',
                            style: TextStyle(
                              fontSize: 48,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            quote.text,
                            style: const TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '— ${quote.author}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepPurpleAccent.shade100,
                            ),
                          ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 32,
                              onPressed: () {
                                Share.share('"${quote.text}" — ${quote.author}');
                              },
                              icon: const Icon(Icons.share, color: Colors.white70),
                            ),
                            const SizedBox(width: 24),
                            IconButton(
                              iconSize: 36,
                              onPressed: () {
                                setState(() {
                                  if (isFav) {
                                    _favoriteIds.remove(quote.id);
                                  } else {
                                    _favoriteIds.add(quote.id);
                                  }
                                });
                                _favService.saveFavorites(_favoriteIds);
                              },
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.redAccent : Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Навигация внизу
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _currentIndex > 0
                          ? () => setState(() => _currentIndex--)
                          : null,
                      icon: const Icon(Icons.arrow_back_ios, size: 28),
                    ),
                    Text(
                      '${_currentIndex + 1} / ${quotes.length}',
                      style: const TextStyle(color: Colors.white54),
                    ),
                    IconButton(
                      onPressed: _currentIndex < quotes.length - 1
                          ? () => setState(() => _currentIndex++)
                          : null,
                      icon: const Icon(Icons.arrow_forward_ios, size: 28),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
