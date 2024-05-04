import 'package:flutter/material.dart';
import 'pago.dart';

class CarritoPage extends StatefulWidget {
  final List<Map<String, dynamic>> carrito;

  CarritoPage({required this.carrito});

  @override
  _CarritoPageState createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  int totalCarrito = 0;

  @override
  void initState() {
    super.initState();
    actualizarTotalCarrito();
  }

  void actualizarTotalCarrito() {
    setState(() {
      totalCarrito = widget.carrito.fold(
        0,
        (previousValue, producto) =>
            previousValue +
            (int.tryParse(producto['cantidad'].toString()) ?? 0) *
                (int.tryParse(producto['precio'].toString()) ?? 0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito'),
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
          itemCount: widget.carrito.length,
          itemBuilder: (context, index) {
            final producto = widget.carrito[index];
            final precioProducto =
                double.tryParse(producto['precio'].toString()) ?? 0;
            final cantidad = int.tryParse(producto['cantidad'].toString()) ?? 1;
            final totalProducto = cantidad * precioProducto;
            return ListTile(
              leading: producto['foto1'] != ''
                  ? Image.network(producto['foto1'])
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(color: Colors.grey[300])),
              title: Text(producto['descripProd'],
                  style: TextStyle(color: Colors.white)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stock: ${producto['stock']}',
                      style: TextStyle(color: Colors.white70)),
                  Text('Precio: \$${precioProducto.toString()}',
                      style: TextStyle(color: Colors.white70)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            if (cantidad > 1) {
                              producto['cantidad'] = cantidad - 1;
                              actualizarTotalCarrito();
                            }
                          });
                        },
                      ),
                      Text('$cantidad', style: TextStyle(color: Colors.white)),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            if (cantidad < producto['stock']) {
                              producto['cantidad'] = cantidad + 1;
                              actualizarTotalCarrito();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            widget.carrito.removeAt(index);
                            actualizarTotalCarrito();
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total: \$${totalProducto.toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey[800],
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Carrito: \$${totalCarrito.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PagoPage(carrito: widget.carrito)),
                  );
                },
                style: ElevatedButton.styleFrom(),
                child: Text('Pagar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
