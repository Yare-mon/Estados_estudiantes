import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/estudiantes_cubit.dart';
import '../cubit/estudiantes_state.dart';
import '../models/estudiante.dart';

class EstudiantesPage extends StatefulWidget {
  const EstudiantesPage({super.key});

  @override
  State<EstudiantesPage> createState() => _EstudiantesPageState();
}

class _EstudiantesPageState extends State<EstudiantesPage> {
  final TextEditingController _busquedaController = TextEditingController();
  String _filtro = '';

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  List<Estudiante> _filtrarEstudiantes(List<Estudiante> estudiantes) {
    if (_filtro.isEmpty) return estudiantes;

    return estudiantes.where((estudiante) {
      return estudiante.nombre.toLowerCase().contains(_filtro) ||
          estudiante.correo.toLowerCase().contains(_filtro) ||
          estudiante.ciudad.toLowerCase().contains(_filtro);
    }).toList();
  }

  Widget _construirLista(List<Estudiante> estudiantes) {
    final resultados = _filtrarEstudiantes(estudiantes);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _busquedaController,
            onChanged: (valor) =>
                setState(() => _filtro = valor.trim().toLowerCase()),
            decoration: InputDecoration(
              labelText: 'Buscar estudiantes',
              hintText: 'Nombre, correo o ciudad',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _busquedaController.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Limpiar búsqueda',
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() {
                        _busquedaController.clear();
                        _filtro = '';
                      }),
                    ),
            ),
          ),
        ),
        Expanded(
          child: resultados.isEmpty
              ? Center(
                  child: Text(
                    _filtro.isEmpty
                        ? 'No hay estudiantes registrados'
                        : 'No se encontraron coincidencias',
                  ),
                )
              : ListView.builder(
                  itemCount: resultados.length,
                  itemBuilder: (context, index) {
                    final estudiante = resultados[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${estudiante.id}')),
                      title: Text(estudiante.nombre),
                      subtitle: Text(
                        '${estudiante.correo}\n${estudiante.ciudad}',
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<EstudiantesCubit, EstudiantesState>(
          builder: (context, state) {
            if (state is EstudiantesExito) {
              return Text(
                'Consulta de estudiantes (${state.estudiantes.length})',
              );
            }
            return const Text('Consulta de estudiantes');
          },
        ),
        // botón para regresar al estado Inicial.
        actions: [
          IconButton(
            tooltip: 'Reiniciar',
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<EstudiantesCubit>().reiniciar(),
          ),
        ],
      ),
      body: BlocBuilder<EstudiantesCubit, EstudiantesState>(
        builder: (context, state) {
          return switch (state) {
            EstudiantesInicial() => const Center(
              child: Text('Presiona el botón para comenzar'),
            ),
            EstudiantesCarga() => const Center(
              child: CircularProgressIndicator(),
            ),
            EstudiantesVacio() => const Center(
              child: Text('No hay estudiantes registrados'),
            ),
            EstudiantesError(:final mensaje) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text(mensaje, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<EstudiantesCubit>().cargarEstudiantes(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
            EstudiantesExito(:final estudiantes) => _construirLista(
              estudiantes,
            ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<EstudiantesCubit>().cargarEstudiantes(),
        icon: const Icon(Icons.download),
        label: const Text('Cargar estudiantes'),
      ),
    );
  }
}
