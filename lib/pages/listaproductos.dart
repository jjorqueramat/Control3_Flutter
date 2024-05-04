import 'package:flutter/material.dart';
import '../services/service.dart';
import 'detalleproductos.dart'; // Importa la página de detalles

class ListaProductos extends StatefulWidget {
  final Function(Map<String, dynamic>) agregarProductoAlCarrito;
  final String searchTerm; // Término de búsqueda

  ListaProductos({
    required this.agregarProductoAlCarrito,
    required this.searchTerm,
  });

  @override
  _ListaProductosState createState() => _ListaProductosState();
}

class _ListaProductosState extends State<ListaProductos> {
  List<dynamic> _productos = [];
  List<String> _categorias = [];
  String _categoriaSeleccionada = 'Todas';

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final listaProductos = await ApiService.obtenerListaProductos();
      setState(() {
        _productos = listaProductos;
        _categorias = _obtenerCategorias();
      });
    } catch (e) {
      print('Error al cargar la lista de productos: $e');
    }
  }

  List<String> _obtenerCategorias() {
    Set<String> categorias = {'Todas'};
    for (var producto in _productos) {
      categorias.add(producto['categoria']);
    }
    return categorias.toList();
  }

  List<dynamic> _filtrarProductosPorCategoria() {
    List<dynamic> productosFiltrados = _productos;
    if (_categoriaSeleccionada != 'Todas') {
      productosFiltrados = productosFiltrados
          .where((producto) => producto['categoria'] == _categoriaSeleccionada)
          .toList();
    }
    if (widget.searchTerm.isNotEmpty) {
      productosFiltrados = productosFiltrados.where((producto) {
        final String descripcion = producto['descripProd'].toLowerCase();
        return descripcion.contains(widget.searchTerm.toLowerCase());
      }).toList();
    }
    return productosFiltrados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        actions: [
          DropdownButton<String>(
            value: _categoriaSeleccionada,
            items: _categorias.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _categoriaSeleccionada = newValue!;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[800]!, Colors.blueGrey[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: _filtrarProductosPorCategoria().length,
          itemBuilder: (context, index) {
            final producto = _filtrarProductosPorCategoria()[index];
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleProductos(
                      producto: producto,
                      agregarProductoAlCarrito: widget.agregarProductoAlCarrito,
                    ),
                  ),
                );
              },
              leading: producto['foto1'] != ''
                  ? Image.network(
                      producto['foto1'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(color: Colors.grey[300])),
              title: Text(
                producto['descripProd'],
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precio: ${producto['precio']}',
                          style: TextStyle(color: Colors.white70)),
                      Text('Stock: ${producto['stock']}',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final productoConCantidad =
                          Map<String, dynamic>.from(producto);
                      productoConCantidad['cantidad'] =
                          1; // Cantidad predeterminada
                      widget.agregarProductoAlCarrito(productoConCantidad);
                    },
                    child: Text('Agregar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
