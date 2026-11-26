import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/estudiantes_cubit.dart';
import 'screens/estudiantes_page.dart';
import 'services/estudiante_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica Cubit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: BlocProvider(
        // Actividad 5 (estado Vacío): cambia temporalmente a
        // EstudianteService(simularVacio: true) para la captura.
        create: (_) => EstudiantesCubit(const EstudianteService()),
        child: const EstudiantesPage(),
      ),
    );
  }
}
