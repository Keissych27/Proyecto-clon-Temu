import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temu Clone',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MainNavigation(),
    );
  }
}

// --- MODELO DE DATOS PARA PRODUCTO ---
class Product {
  final String name, price, discount, imageUrl, desc;
  const Product({
    required this.name,
    required this.price,
    required this.discount,
    required this.imageUrl,
    required this.desc,
  });
}

// --- ESTADO GLOBAL SENCILLO PARA EL CARRITO ---
List<Product> cartItems = [];

// --- NAVEGACIÓN PRINCIPAL ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Función para refrescar la UI cuando añadimos algo al carrito
  void _updateUI() => setState(() {});

  List<Widget> get _pages => [
        ProductGridScreen(onAddToCart: _updateUI),
        const CategoriesScreen(),
        const CartScreen(), // Cambiamos Ofertas por el Carrito para que sea funcional
        const ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange[900],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          const BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categorías'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                      constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                      child: Text(
                        '${cartItems.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Carrito',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tú'),
        ],
      ),
    );
  }
}

// --- PANTALLA DE INICIO (PRODUCTOS) ---
class ProductGridScreen extends StatelessWidget {
  final VoidCallback onAddToCart;
  const ProductGridScreen({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final List<String> banners = [
      "https://picsum.photos/id/1073/800/300",
      "https://picsum.photos/id/1080/800/300",
      "https://picsum.photos/id/102/800/300",
    ];

    final List<Product> products = [
      Product(name: "Tacones Blancos elegantes", price: "55.550", discount: "60% dto.", imageUrl: "https://picsum.photos/id/21/400/400", desc: "Zapatos cómodos para correr."),
      Product(name: "Reloj Inteligente Pro", price: "15.000", discount: "45% dto.", imageUrl: "https://picsum.photos/id/20/400/400", desc: "Monitorea tu salud."),
      Product(name: "Audífonos Bluetooth", price: "80.000", discount: "30% dto.", imageUrl: "https://picsum.photos/id/26/400/400", desc: "Sonido envolvente."),
      Product(name: "Cámara Vintage Pro", price: "450.000", discount: "10% dto.", imageUrl: "https://picsum.photos/id/250/400/400", desc: "Captura momentos retro."),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Temu Clone", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: banners.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(image: NetworkImage(banners[index]), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Align(alignment: Alignment.centerLeft, child: Text("Recomendados", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: item, onAddToCart: onAddToCart))),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Image.network(item.imageUrl, fit: BoxFit.cover, width: double.infinity)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                              Text("\$${item.price}", style: const TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- PANTALLA DE CATEGORÍAS ---
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Moda', 'icon': Icons.checkroom},
      {'name': 'Hogar', 'icon': Icons.home_repair_service},
      {'name': 'Electrónica', 'icon': Icons.devices},
      {'name': 'Belleza', 'icon': Icons.face},
      {'name': 'Juguetes', 'icon': Icons.toys},
      {'name': 'Deportes', 'icon': Icons.sports_soccer},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Categorías")),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) => Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.orange[100],
              child: Icon(categories[index]['icon'] as IconData, color: Colors.orange[900]),
            ),
            const SizedBox(height: 5),
            Text(categories[index]['name'] as String, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// --- PANTALLA DE PERFIL ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 50, backgroundColor: Colors.orange, child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 10),
          const Text("Keissy Choconta", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Divider(height: 40),
          ListTile(leading: const Icon(Icons.location_on), title: const Text("Dirección"), subtitle: const Text("Carrera felicidad # 27 - 12")),
          ListTile(leading: const Icon(Icons.phone), title: const Text("Teléfono"), subtitle: const Text("3194059767")),
          ListTile(leading: const Icon(Icons.email), title: const Text("Email"), subtitle: const Text("keissy@ejemplo.com")),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), child: const Text("Cerrar Sesión")),
          ),
        ],
      ),
    );
  }
}

// --- PANTALLA DE CARRITO ---
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Carrito de Compras")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Tu carrito está vacío"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Image.network(cartItems[index].imageUrl, width: 50),
                      title: Text(cartItems[index].name),
                      subtitle: Text("\$${cartItems[index].price}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => cartItems.removeAt(index)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("¡Compra Exitosa!"),
                          content: const Text("Gracias por tu compra, Keissy. Tu pedido va en camino a Carrera felicidad."),
                          actions: [TextButton(onPressed: () {
                            setState(() => cartItems.clear());
                            Navigator.pop(context);
                          }, child: const Text("Aceptar"))],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 55)),
                    child: const Text("REALIZAR PEDIDO", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
    );
  }
}

// --- DETALLE DEL PRODUCTO (ACTUALIZADO) ---
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  const ProductDetailScreen({super.key, required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalles")),
      body: Column(
        children: [
          Image.network(product.imageUrl, height: 300, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text("\$${product.price}", style: const TextStyle(fontSize: 22, color: Colors.orange, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(product.desc),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    cartItems.add(product);
                    onAddToCart();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Añadido al carrito")));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                  child: const Text("AÑADIR AL CARRITO"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}