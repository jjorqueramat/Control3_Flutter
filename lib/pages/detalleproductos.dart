import 'package:flutter/material.dart';

class DetalleProductos extends StatelessWidget {
  final Map<String, dynamic> producto;
  final Function(Map<String, dynamic>) agregarProductoAlCarrito;

  DetalleProductos(
      {required this.producto, required this.agregarProductoAlCarrito});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Producto'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[800]!, Colors.blueGrey[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  producto['foto1'],
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                producto['descripProd'],
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'Precio: \$${producto['precio']}',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              Text(
                'Stock: ${producto['stock']}',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final productoConCantidad =
                      Map<String, dynamic>.from(producto);
                  productoConCantidad['cantidad'] = 1;
                  agregarProductoAlCarrito(productoConCantidad);
                },
                style: ElevatedButton.styleFrom(),
                child: Text('Agregar al Carrito'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
