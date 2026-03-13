import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- 1. MODELO DE DATOS (DEBE IR ARRIBA) ---
class Product {
  final String name, price, discount, imageUrl, desc, category;
  const Product({
    required this.name, required this.price, required this.discount, 
    required this.imageUrl, required this.desc, required this.category,
  });
}

// --- 2. ESTADO GLOBAL ---
List<Product> cartItems = [];
String selectedCategory = "Todos";
String nombreUsuarioActual = "Invitado"; 

// --- 3. FUNCIÓN DE LA API ---
Future<void> enviarPedidoAInternet(Product producto) async {
  final String urlMockAPI = "https://69b35a09e224ec066bdbf818.mockapi.io/Pedidos";

  try {
    await http.post(
      Uri.parse(urlMockAPI),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "Nombre": producto.name,
        "Pedido": producto.name,
        "Usuario": nombreUsuarioActual, 
        "Fecha": DateTime.now().toString(),
      }),
    );
  } catch (e) {
    print("Error: $e");
  }
}

void main() {
  runApp(const MyApp());
}

// --- 4. CONFIGURACIÓN DE LA APP ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temu Clone Pro',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const LoginScreen(), 
    );
  }
}

// --- 5. PANTALLA DE LOGIN ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_mall, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              const Text("¡Bienvenido a Temu Clone!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nombre completo",
                  prefixIcon: const Icon(Icons.person, color: Colors.orange),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    setState(() { nombreUsuarioActual = _nameController.text; });
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("INGRESAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 6. LISTA DE PRODUCTOS ---
const List<Product> allProducts = [
  Product(category: "Moda", name: "Tacones Blancos Elegantes", price: "55500", discount: "60% dto.", imageUrl: "https://picsum.photos/id/21/400/400", desc: "Zapatos cómodos para oficina."),
  Product(category: "Electrónica", name: "Celular iphone 16 pro", price: "1250000", discount: "45% dto.", imageUrl: "https://picsum.photos/id/20/400/400", desc: "Último modelo de alta gama."),
  Product(category: "Electrónica", name: "SET reloj, gafas, audifonos..", price: "180000", discount: "30% dto.", imageUrl: "https://picsum.photos/id/26/400/400", desc: "Kit completo de accesorios."),
  Product(category: "Hogar", name: "Cámara Vintage Pro", price: "450000", discount: "10% dto.", imageUrl: "https://picsum.photos/id/250/400/400", desc: "Captura momentos con estilo."),
  Product(category: "Moda", name: "Chaqueta Térmica vintage", price: "255000", discount: "20% dto.", imageUrl: "https://picsum.photos/id/1059/400/400", desc: "Ideal para el frío de Bogotá."),
  Product(category: "Hogar", name: "Lámpara de Escritorio", price: "100550", discount: "15% dto.", imageUrl: "https://picsum.photos/id/1068/400/400", desc: "Luz LED para estudiar."),
  Product(category: "Belleza", name: "Set de Maquillaje", price: "25000", discount: "50% dto.", imageUrl: "https://picsum.photos/id/1027/400/400", desc: "Calidad profesional."),
  Product(category: "Deportes", name: "Tapete de Fútbol", price: "55000", discount: "5% dto.", imageUrl: "https://picsum.photos/id/1058/400/400", desc: "Entrena en casa."),
];

// --- 7. NAVEGACIÓN Y PANTALLAS ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  void _updateUI() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        ProductGridScreen(onAddToCart: _updateUI),
        CategoriesScreen(onCategorySelected: (cat) {
          setState(() { selectedCategory = cat; _selectedIndex = 0; });
        }),
        const CartScreen(),
        const ProfileScreen(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange[900],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          const BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categorías'),
          BottomNavigationBarItem(
            icon: Badge(label: Text('${cartItems.length}'), isLabelVisible: cartItems.isNotEmpty, child: const Icon(Icons.shopping_cart)),
            label: 'Carrito',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tú'),
        ],
      ),
    );
  }
}

class ProductGridScreen extends StatefulWidget {
  final VoidCallback onAddToCart;
  const ProductGridScreen({super.key, required this.onAddToCart});
  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategory == "Todos" ? allProducts : allProducts.where((p) => p.category == selectedCategory).toList();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange, title: const Text("Temu Clone Pro", style: TextStyle(color: Colors.white))),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: filtered.length,
        itemBuilder: (context, index) => Card(
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: filtered[index], onAddToCart: widget.onAddToCart))),
            child: Column(
              children: [
                Expanded(child: Image.network(filtered[index].imageUrl, fit: BoxFit.cover)),
                Text(filtered[index].name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("\$${filtered[index].price}", style: const TextStyle(color: Colors.orange)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  final Function(String) onCategorySelected;
  const CategoriesScreen({super.key, required this.onCategorySelected});
  @override
  Widget build(BuildContext context) {
    final cats = ['Moda', 'Electrónica', 'Hogar', 'Belleza', 'Deportes', 'Todos'];
    return Scaffold(
      appBar: AppBar(title: const Text("Categorías")),
      body: ListView.builder(
        itemCount: cats.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(cats[i]),
          onTap: () => onCategorySelected(cats[i]),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (sum, item) => sum + double.parse(item.price));
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Carrito")),
      body: cartItems.isEmpty 
        ? const Center(child: Text("Carrito vacío"))
        : Column(
            children: [
              Expanded(child: ListView.builder(itemCount: cartItems.length, itemBuilder: (context, i) => ListTile(title: Text(cartItems[i].name), subtitle: Text("\$${cartItems[i].price}")))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    for (var item in cartItems) { await enviarPedidoAInternet(item); }
                    setState(() { cartItems.clear(); });
                    showDialog(context: context, builder: (c) => const AlertDialog(title: Text("Éxito"), content: Text("Pedido guardado en MockAPI")));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)),
                  child: Text("PAGAR \$${total.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil"),
        actions: [
          // BOTÓN PARA SALIR
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              // Limpiamos los datos actuales
              nombreUsuarioActual = "Invitado";
              cartItems.clear();

              // Regresamos a la pantalla de Login y borramos el historial de navegación
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              nombreUsuarioActual, // Aquí saldrá María o el que pongas
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text("Bogotá, Colombia", style: TextStyle(color: Colors.grey)),
            const Divider(height: 40),
            const ListTile(
              leading: Icon(Icons.history),
              title: Text("Mis Pedidos"),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configuración"),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
            ),
            const Spacer(),
            Text("Temu Clone v1.0 - Proyecto Ingeniería", 
              style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {   
  final Product product;
  final VoidCallback onAddToCart;
  const ProductDetailScreen({super.key, required this.product, required this.onAddToCart});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          Image.network(product.imageUrl, height: 300, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text("\$${product.price}", style: const TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text(product.desc),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () { cartItems.add(product); onAddToCart(); Navigator.pop(context); },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)),
                  child: const Text("AÑADIR AL CARRITO", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}