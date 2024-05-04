import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<void> actualizarStockProductos(
      List<Map<String, dynamic>> productos) async {
    var url = Uri.parse(
        'https://sandeonline.cl:2082/taskfocus/multimedia/api/Registro/GrabarActualizaStockproductos');

    List<Map<String, dynamic>> productosParaActualizar =
        productos.map((producto) {
      return {
        "codigo": producto['codigoProd'],
        "cantidad": int.tryParse(producto['cantidad'].toString()) ?? 0
      };
    }).toList();

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(productosParaActualizar),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Falló la actualización de stock. Código de respuesta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al actualizar stock: $e');
      throw Exception('Error al actualizar stock: $e');
    }
  }

  static Future<Map<String, dynamic>> buscarUsuario(
      String usuario, String pass) async {
    final url =
        'https://sandeonline.cl:2082/taskfocus/multimedia/api/Registro/BusquedaUsuario?usuario=$usuario&pass=$pass';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData[0];
    } else {
      throw Exception('Error al buscar usuario: ${response.reasonPhrase}');
    }
  }

  static Future<List<dynamic>> obtenerListaProductos() async {
    final response = await http.get(Uri.parse(
        'https://sandeonline.cl:2082/taskfocus/multimedia/api/Registro/listaProductos'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener la lista de productos');
    }
  }

  static Future<void> crearNuevoUsuario(Map<String, dynamic> userData) async {
    var url = Uri.parse(
        'https://sandeonline.cl:2082/taskfocus/multimedia/api/Registro/GrabarNuevoUsuario');

    var payload = json.encode([
      {
        "nombre": userData['nombre'],
        "apellido": userData['apellido'],
        "direccion": userData['direccion'],
        "email": userData['email'],
        "rut": userData['rut'],
        "pass": userData['pass'],
      }
    ]);

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Falló la creación del usuario. Código de respuesta: ${response.statusCode}. Detalles: ${response.body}');
      } else {
        print('Usuario creado exitosamente.');
      }
    } catch (e) {
      print('Error al crear usuario: $e');
      throw Exception('Error al crear usuario: $e');
    }
  }
}
