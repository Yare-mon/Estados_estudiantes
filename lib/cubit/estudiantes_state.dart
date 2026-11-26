import 'package:equatable/equatable.dart';

import '../models/estudiante.dart';

// sealed: el compilador exige cubrir todos los estados en el switch.
sealed class EstudiantesState extends Equatable {
  const EstudiantesState();

  @override
  List<Object?> get props => [];
}

class EstudiantesInicial extends EstudiantesState {
  const EstudiantesInicial();
}

class EstudiantesCarga extends EstudiantesState {
  const EstudiantesCarga();
}

class EstudiantesVacio extends EstudiantesState {
  const EstudiantesVacio();
}

class EstudiantesExito extends EstudiantesState {
  final List<Estudiante> estudiantes;

  const EstudiantesExito(this.estudiantes);

  @override
  List<Object?> get props => [estudiantes];
}

class EstudiantesError extends EstudiantesState {
  final String mensaje;

  const EstudiantesError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}
