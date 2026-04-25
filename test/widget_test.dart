import 'package:flutter/material.dart'; // Добавь этот импорт для Icons
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_quotes/main.dart';
import 'package:focus_quotes/data/quotes_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Тест 1
  testWidgets('Проверка отображения заголовка и первой цитаты', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FocusQuotesApp());
    expect(find.text('Focus Quotes'), findsOneWidget);
    expect(find.text(quotes[0].text), findsOneWidget);
    expect(find.text('1 / ${quotes.length}'), findsOneWidget);
  });

  // Тест 2 (переключение цитат)
  testWidgets('Проверка переключения на следующую цитату', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FocusQuotesApp());

    // Находим кнопку "вперед" и нажимаем
    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pump(); // Ждем перерисовки кадра

    // Теперь должна быть вторая цитата
    expect(find.text(quotes[1].text), findsOneWidget);
    expect(find.text('2 / ${quotes.length}'), findsOneWidget);
  });

  // Тест 3: Добавление в избранное
  testWidgets('Проверка добавления цитаты в избранное', (
    WidgetTester tester,
  ) async {
    // Инициализируем мок для SharedPreferences
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const FocusQuotesApp());
    // 1. Ищем кнопку сердечка под цитатой (она должна быть Icons.favorite_border)
    // Важно: одна иконка favorite уже есть в шапке (переход в список),
    // поэтому ищем именно контурную.
    final favButton = find.byIcon(Icons.favorite_border);
    expect(favButton, findsOneWidget);
    // 2. Нажимаем на неё
    await tester.tap(favButton);
    await tester.pump(); // Перерисовываем экран
    // 3. Теперь контурной иконки быть не должно
    expect(find.byIcon(Icons.favorite_border), findsNothing);

    // 4. Должно быть 2 закрашенных иконки Icons.favorite (одна в шапке, одна под цитатой)
    expect(find.byIcon(Icons.favorite), findsNWidgets(2));
  });

  // Тест 4: Переход на экран Избранного и проверка наличия там цитаты
  testWidgets('Проверка отображения цитаты на экране Избранного', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const FocusQuotesApp());
    // 1. Добавляем первую цитату в избранное
    final favButton = find.byIcon(Icons.favorite_border);
    await tester.tap(favButton);
    await tester.pump();
    // 2. Нажимаем на иконку избранного в шапке для перехода
    // Ищем иконку favorite с размером 28 (как в коде HomeScreen)
    final goToFavorites = find.byWidgetPredicate(
      (widget) =>
          widget is Icon && widget.icon == Icons.favorite && widget.size == 28,
    );
    await tester.tap(goToFavorites);

    // 3. Ждем завершения анимации перехода (pumpAndSettle)
    await tester.pumpAndSettle();
    // 4. Проверяем, что мы на экране "Избранное"
    expect(find.text('Избранное'), findsOneWidget);
    // 5. Проверяем, что наша цитата там отображается
    expect(find.text(quotes[0].text), findsOneWidget);
  });
}
