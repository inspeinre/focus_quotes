import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorite_ids';

  // Загрузить избранные ID из памяти устройства
  Future<Set<int>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList(_key);
    if (saved == null) return {};
    return saved.map((s) => int.parse(s)).toSet();
  }

  // Сохранить избранные ID в память устройства
  Future<void> saveFavorites(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> toSave = ids.map((id) => id.toString()).toList();
    await prefs.setStringList(_key, toSave);
  }
}
