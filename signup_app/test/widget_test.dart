import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:signup_app/screens/signup_screen.dart';

Widget createTestApp() => const MaterialApp(home: SignupScreen());

void main() {
  testWidgets('Test 1: empty submit shows validation errors', (tester) async {
    await tester.pumpWidget(createTestApp());

    await tester.tap(find.text('Join the Mansion'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Pick your birth date'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('Test 2: bad email shows error', (tester) async {
    await tester.pumpWidget(createTestApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'Adi Tauqir');
    await tester.enterText(find.byType(TextFormField).at(1), 'bademail');

    await tester.tap(find.text('Join the Mansion'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('Test 3: short password shows error', (tester) async {
    await tester.pumpWidget(createTestApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'Adi Tauqir');
    await tester.enterText(find.byType(TextFormField).at(1), 'adi@example.com');
    // Password is at index 3 now (index 2 is birth date)
    await tester.enterText(find.byType(TextFormField).at(3), '123');

    await tester.tap(find.text('Join the Mansion'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('Test 4: password visibility toggles with eye icon', (tester) async {
    await tester.pumpWidget(createTestApp());

    // Initially obscureText is true
    expect(find.byIcon(Icons.visibility), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pumpAndSettle();

    // Now visibility_off is shown
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  testWidgets('Test 5: local demo tip shows preset tip', (tester) async {
    await tester.pumpWidget(createTestApp());

    expect(find.text('Get a signup tip'), findsOneWidget);
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();

    expect(find.text('Loading demo tip...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.textContaining('Tip:'), findsOneWidget);
  });

  testWidgets('Test 6: local error and retry flow', (tester) async {
    await tester.pumpWidget(createTestApp());

    // Long press triggers the forced error state
    await tester.longPress(find.text('Get a signup tip'));
    await tester.pumpAndSettle();

    expect(find.text('Could not load tip. Tap retry.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    // Tap retry to recover
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.textContaining('Tip:'), findsOneWidget);
  });
}
