import 'package:control3_flutter/services/service.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _direccionController.dispose();
    _emailController.dispose();
    _rutController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _crearUsuario() async {
    Map<String, dynamic> userData = {
      "nombre": _nombreController.text,
      "apellido": _apellidoController.text,
      "direccion": _direccionController.text,
      "email": _emailController.text,
      "rut": _rutController.text,
      "pass": _passwordController.text,
    };

    try {
      await ApiService.crearNuevoUsuario(userData);

      _mostrarDialogoExito();
    } catch (e) {
      print('Error al crear usuario: $e');

      _mostrarDialogoError(e.toString());
    }
  }

  void _mostrarDialogoExito() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registro Completo'),
          content: const Text('Usuario creado con éxito.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => LoginPage()), // Navegar a LoginPage
                  ModalRoute.withName('/'),
                );
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoError(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo crear el usuario: $error'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido')),
            TextField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Dirección')),
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: _rutController,
                decoration: const InputDecoration(labelText: 'RUT')),
            TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _crearUsuario,
              child: Text('Crear Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
