import 'dart:async'; // TimeoutException (Actividad 2)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; // http.ClientException (Actividad 2)

import '../services/estudiante_service.dart';
import 'estudiantes_state.dart';

class EstudiantesCubit extends Cubit<EstudiantesState> {
  final EstudianteService _servicio;

  EstudiantesCubit(this._servicio) : super(const EstudiantesInicial());

  Future<void> cargarEstudiantes() async {
    emit(const EstudiantesCarga());
    try {
      final datos = await _servicio.obtenerEstudiantes();
      if (datos.isEmpty) {
        emit(const EstudiantesVacio());
      } else {
        emit(EstudiantesExito(datos));
      }
    } on TimeoutException {
      // La API tardó más de 10 segundos en responder.
      emit(const EstudiantesError(
        'La consulta tardó demasiado. Inténtalo de nuevo en un momento.',
      ));
    } on http.ClientException {
      // No se pudo conectar: sin internet, modo avión o dominio inexistente.
      emit(const EstudiantesError(
        'Sin conexión a internet. Revisa tu red e inténtalo de nuevo.',
      ));
    } catch (_) {
      // Cualquier otro problema, por ejemplo un código 404 o 500.
      emit(const EstudiantesError(
        'El servidor respondió con un error. Inténtalo más tarde.',
      ));
    }
  }

  void reiniciar() => emit(const EstudiantesInicial());
}
