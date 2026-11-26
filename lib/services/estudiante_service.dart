import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/estudiante.dart';

class EstudianteService {
  // Si es true, simula una consulta correcta que devuelve una lista vacía.
  // Sirve para demostrar el estado Vacío.
  final bool simularVacio;

  const EstudianteService({this.simularVacio = false});

  Future<List<Estudiante>> obtenerEstudiantes() async {
    if (simularVacio) {
      await Future.delayed(const Duration(seconds: 1));
      return [];
    }

    // Actividad 5 (estado Carga): si la respuesta llega muy rápido,
    // quita el comentario de la línea de abajo para alcanzar a tomar la captura.
    // await Future.delayed(const Duration(seconds: 3));

    final respuesta = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/users'))
        .timeout(const Duration(seconds: 10));

    if (respuesta.statusCode != 200) {
      throw Exception('Error del servidor: ${respuesta.statusCode}');
    }

    final List<dynamic> datos = jsonDecode(respuesta.body);
    return datos
        .map((json) => Estudiante.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
