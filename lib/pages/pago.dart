import '../pages/pages.dart';

class PagoPage extends StatefulWidget {
  final List<Map<String, dynamic>> carrito;

  PagoPage({required this.carrito});

  @override
  _PagoPageState createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalCarrito = widget.carrito.fold(
      0,
      (previousValue, producto) =>
          previousValue +
          (int.tryParse(producto['cantidad'].toString()) ?? 0) *
              (int.tryParse(producto['precio'].toString()) ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pago'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total a Pagar: \$${totalCarrito.toString()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _enviarCorreo(context, _emailController.text);
              },
              child: Text('Pagar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _enviarCorreo(BuildContext context, String destinatario) async {
    const String username = 'soporte@sande.cl';
    const String password = 'Sande1771';

    final smtpServer = gmail(username, password);

    String cuerpoCorreo = 'Productos comprados:\n\n';
    for (var producto in widget.carrito) {
      cuerpoCorreo += '${producto['descripProd']} - \$${producto['precio']}\n';
    }

    final message = Message()
      ..from = Address(username)
      ..recipients.add(Address(destinatario))
      ..subject = 'Confirmación de compra'
      ..text = cuerpoCorreo;

    try {
      final sendReport = await send(message, smtpServer);
      print('Correo electrónico enviado: ${sendReport.toString()}');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Mensaje enviado'),
            content: Text('Correo electrónico enviado con éxito'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await ApiService.actualizarStockProductos(widget.carrito);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginApp()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar el correo electrónico: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
