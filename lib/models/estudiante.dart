class Estudiante {
  final int id;
  final String nombre;
  final String correo;
  final String ciudad; // Actividad 1

  const Estudiante({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.ciudad,
  });

  // Convierte el JSON de la API en un objeto Estudiante.
  factory Estudiante.fromJson(Map<String, dynamic> json) {
    final direccion = json['address'] as Map<String, dynamic>;
    return Estudiante(
      id: json['id'] as int,
      nombre: json['name'] as String,
      correo: json['email'] as String,
      ciudad: direccion['city'] as String,
    );
  }
}
