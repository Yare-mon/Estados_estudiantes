// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practica_estudiantes/cubit/estudiantes_cubit.dart';
import 'package:practica_estudiantes/models/estudiante.dart';
import 'package:practica_estudiantes/screens/estudiantes_page.dart';
import 'package:practica_estudiantes/services/estudiante_service.dart';

void main() {
  testWidgets('filtra estudiantes por ciudad sin distinguir mayúsculas', (
    tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => EstudiantesCubit(const ServicioEstudiantesFalso()),
        child: const MaterialApp(home: EstudiantesPage()),
      ),
    );

    await tester.tap(find.text('Cargar estudiantes'));
    await tester.pumpAndSettle();

    expect(find.text('Carlos Pérez'), findsOneWidget);
    expect(find.text('Lucía Gómez'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'VALENCIA');
    await tester.pumpAndSettle();

    expect(find.text('Carlos Pérez'), findsOneWidget);
    expect(find.text('Lucía Gómez'), findsNothing);
  });
}

class ServicioEstudiantesFalso extends EstudianteService {
  const ServicioEstudiantesFalso();

  @override
  Future<List<Estudiante>> obtenerEstudiantes() async => const [
    Estudiante(
      id: 1,
      nombre: 'Carlos Pérez',
      correo: 'carlos@example.com',
      ciudad: 'Valencia',
    ),
    Estudiante(
      id: 2,
      nombre: 'Lucía Gómez',
      correo: 'lucia@example.com',
      ciudad: 'Sevilla',
    ),
  ];
}
