import '../pages/pages.dart';

class PrincipalPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  PrincipalPage({required this.userData});

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _carrito = []; // Lista de productos en el carrito
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0 ? _buildSearchField() : Text(''),
      ),
      body: _selectedIndex == 0
          ? ListaProductos(
              agregarProductoAlCarrito: _agregarProductoAlCarrito,
              searchTerm: _searchController.text,
            )
          : _selectedIndex == 1
              ? CarritoPage(carrito: _carrito)
              : CuentaPage(userData: widget.userData),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Cuenta',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Buscar productos...',
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _agregarProductoAlCarrito(Map<String, dynamic> producto) {
    setState(() {
      _carrito.add(producto);
    });
  }
}
