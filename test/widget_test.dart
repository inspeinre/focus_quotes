import 'package:flutter/material.dart'; // Добавь этот импорт для Icons
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_quotes/main.dart';
import 'package:focus_quotes/data/quotes_data.dart';

void main() {
  // Тест 1 (уже есть у тебя)
  testWidgets('Проверка отображения заголовка и первой цитаты', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FocusQuotesApp());
    expect(find.text('Focus Quotes'), findsOneWidget);
    expect(find.text(quotes[0].text), findsOneWidget);
    expect(find.text('1 / ${quotes.length}'), findsOneWidget);
  });

  // Тест 2 (НОВЫЙ: переключение цитат)
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
}
