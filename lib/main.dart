// Importaciones necesarias para utilizar Flutter y Provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// Punto de entrada de la aplicación
void main() {
  runApp(const MyApp());
}


// Clase principal de la aplicación 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PetAppState(),
      child: MaterialApp(
        title: 'AnimalKing',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
        // Modificar la AppBar predeterminada para agregar un logo
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0), // Aumentar el espacio superior
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo a la izquierda del título
                      Image.asset('assets/logo.png', width: 45),
                      // Título de la aplicación
                      const SizedBox(width: 10), // Espacio entre el logo y el texto
                      const Text('AnimalKing',  style: TextStyle(fontSize: 35)),
                    ],
                  ),
                ),
              ),
            ),
            body: child,
          );
        },
      ),
    );
  }
}

// Clase que representa una mascota
class Pet {
  final String id; // Identificador único de la mascota
  String name; // Nombre de la mascota
  String type; // Tipo de mascota
  String ownerName; // Nombre del dueño de la mascota
  String ownerId; // Identificación del dueño de la mascota

  // Constructor de la clase Pet
  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.ownerName,
    required this.ownerId,
  });
}

// Clase que gestiona el estado de la aplicación relacionado con las mascotas
class PetAppState extends ChangeNotifier {
  List<Pet> pets = []; // Lista de mascotas

  // Método para agregar una nueva mascota
  void addPet(Pet pet) {
    pets.add(pet); // Añadir la mascota a la lista
    notifyListeners(); // Notificar a los widgets que dependen de este estado
  }

  // Método para actualizar la información de una mascota existente
  void updatePet(Pet updatedPet) {
    var petIndex = pets.indexWhere((pet) => pet.id == updatedPet.id);
    if (petIndex != -1) {
      pets[petIndex] = updatedPet; // Actualizar la mascota en la lista
      notifyListeners(); // Notificar a los widgets que dependen de este estado
    }
  }

  // Método para eliminar una mascota existente
  void deletePet(String id) {
    pets.removeWhere((pet) => pet.id == id); // Eliminar la mascota de la lista
    notifyListeners(); // Notificar a los widgets que dependen de este estado
  }
}

// Página principal de la aplicación
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


// Esta clase representa el estado de la página principal de la aplicación.
// Maneja la lógica para construir la interfaz de usuario de la página principal.
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // Índice de la página seleccionada

  // Método para construir la interfaz de usuario de la página principal
  @override
  Widget build(BuildContext context) {
    Widget page; // Widget para almacenar la página seleccionada
    switch (selectedIndex) {
      case 0:
        page = AddPetPage(); // Página para agregar mascotas
        break;
      case 1:
        page = PetListPage(); // Página para mostrar la lista de mascotas
        break;
      default:
        throw UnimplementedError('No hay widget para $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            // title: Text('AnimalKing'), // Título de la aplicación
          ),
          body: Row(
            children: [
              // Barra de navegación lateral
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.add),
                      label: Text('Agregar'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.list),
                      label: Text('Lista'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex =
                          value; // Actualizar el índice de la página seleccionada
                    });
                  },
                ),
              ),
              // Contenedor para mostrar la página seleccionada
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Página para agregar una nueva mascota
class AddPetPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController ownerIdController = TextEditingController();

  // Método para construir la interfaz de usuario de la página de agregar mascotas
  @override
  Widget build(BuildContext context) {
    var appState =
        context.watch<PetAppState>(); // Obtener el estado de la aplicación

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campos para ingresar los datos de la mascota
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre de la mascota'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Tipo de mascota'),
            ),
            TextField(
              controller: ownerNameController,
              decoration: InputDecoration(labelText: 'Nombre del dueño'),
            ),
            TextField(
              controller: ownerIdController,
              decoration:
                  InputDecoration(labelText: 'Identificación del dueño'),
            ),
            SizedBox(height: 20),
            // Botón para agregar la mascota
            ElevatedButton(
              onPressed: () {
                var name = nameController.text;
                var type = typeController.text;
                var ownerName = ownerNameController.text;
                var ownerId = ownerIdController.text;
                if (name.isNotEmpty &&
                    type.isNotEmpty &&
                    ownerName.isNotEmpty &&
                    ownerId.isNotEmpty) {
                  var pet = Pet(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    type: type,
                    ownerName: ownerName,
                    ownerId: ownerId,
                  );
                  appState.addPet(
                      pet); // Agregar la mascota al estado de la aplicación
                  nameController.clear();
                  typeController.clear();
                  ownerNameController.clear();
                  ownerIdController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Mascota agregada: $name'),
                  ));
                }
              },
              child: Text('Agregar Mascota'), // Texto del botón
            ),
          ],
        ),
      ),
    );
  }
}

// Página para mostrar la lista de mascotas
class PetListPage extends StatefulWidget {
  @override
  PetListPageState createState() => PetListPageState();
}

// Página para mostrar la lista de mascotas
class PetListPageState extends State<PetListPage> {
  late TextEditingController searchController;

  // Inicialización de la página
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  // Método para construir la interfaz de usuario de la página de lista de mascotas
  @override
  Widget build(BuildContext context) {
    var appState =
        context.watch<PetAppState>(); // Obtener el estado de la aplicación

    // Filtrar las mascotas según el texto de búsqueda
    List<Pet> filteredPets = appState.pets.where((pet) {
      var searchQuery = searchController.text.toLowerCase();
      return pet.name.toLowerCase().contains(searchQuery) ||
          pet.ownerName.toLowerCase().contains(searchQuery);
    }).toList();

    // Verificar si no hay mascotas agregadas
    if (appState.pets.isEmpty) {
      return Center(
        child: Text('No tienes mascotas agregadas.',
            style: TextStyle(fontSize: 20)),
      );
    }

    // Construir la interfaz de usuario de la página de lista de mascotas
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText:
                  'Buscar por nombre de mascota o dueño', // Campo de búsqueda
              prefixIcon: Icon(Icons.search), // Icono de búsqueda
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredPets.length,
            itemBuilder: (context, index) {
              var pet = filteredPets[index];
              return ListTile(
                leading: Icon(Icons.pets), // Icono de mascota
                title: Text(
                    '${pet.name} (${pet.type})'), // Nombre y tipo de mascota
                subtitle: Text(
                    'Dueño: ${pet.ownerName}, ID: ${pet.ownerId}'), // Dueño y ID de mascota
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPetPage(
                          pet:
                              pet), // Navegar a la página de edición de mascotas
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete), // Icono de eliminar
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'Eliminar Mascota'), // Título del diálogo de confirmación
                          content: Text(
                              '¿Estás seguro de que quieres eliminar a ${pet.name}?'), // Mensaje de confirmación
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Cancelar la eliminación
                              },
                              child: Text(
                                  'Cancelar'), // Texto del botón de cancelar
                            ),
                            TextButton(
                              onPressed: () {
                                appState
                                    .deletePet(pet.id); // Eliminar la mascota
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo
                              },
                              child: Text(
                                  'Eliminar'), // Texto del botón de eliminar
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Página para editar la información de una mascota
class EditPetPage extends StatefulWidget {
  final Pet pet; // Mascota a editar

  EditPetPage({required this.pet});

  @override
  EditPetPageState createState() => EditPetPageState();
}

class EditPetPageState extends State<EditPetPage> {
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController ownerNameController;
  late TextEditingController ownerIdController;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores de texto con los datos de la mascota
    nameController = TextEditingController(text: widget.pet.name);
    typeController = TextEditingController(text: widget.pet.type);
    ownerNameController = TextEditingController(text: widget.pet.ownerName);
    ownerIdController = TextEditingController(text: widget.pet.ownerId);
  }

  // Método para construir la interfaz de usuario de la página de edición de mascotas
  @override
  Widget build(BuildContext context) {
    var appState =
        context.watch<PetAppState>(); // Obtener el estado de la aplicación
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Mascota'), // Título de la página
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campos para editar la información de la mascota
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre de la mascota'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Tipo de mascota'),
            ),
            TextField(
              controller: ownerNameController,
              decoration: InputDecoration(labelText: 'Nombre del dueño'),
            ),
            TextField(
              controller: ownerIdController,
              decoration:
                  InputDecoration(labelText: 'Identificación del dueño'),
            ),
            SizedBox(height: 20),
            // Botón para guardar los cambios realizados
            ElevatedButton(
              onPressed: () {
                var newName = nameController.text;
                var newType = typeController.text;
                var newOwnerName = ownerNameController.text;
                var newOwnerId = ownerIdController.text;
                if (newName.isNotEmpty &&
                    newType.isNotEmpty &&
                    newOwnerName.isNotEmpty &&
                    newOwnerId.isNotEmpty) {
                  // Crear un objeto Pet con los datos actualizados
                  var updatedPet = Pet(
                    id: widget.pet.id,
                    name: newName,
                    type: newType,
                    ownerName: newOwnerName,
                    ownerId: newOwnerId,
                  );
                  appState.updatePet(
                      updatedPet); // Actualizar la mascota en el estado de la aplicación
                  Navigator.pop(context); // Regresar a la página anterior
                }
              },
              child: Text('Guardar Cambios'), // Texto del botón
            ),
          ],
        ),
      ),
    );
  }
}