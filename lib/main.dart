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
      title: 'Temu Clone Pro',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MainNavigation(),
    );
  }
}

// --- MODELO DE DATOS MEJORADO ---
class Product {
  final String name, price, discount, imageUrl, desc, category;
  const Product({
    required this.name, required this.price, required this.discount, 
    required this.imageUrl, required this.desc, required this.category,
  });
}

// --- ESTADO GLOBAL ---
List<Product> cartItems = [];
String selectedCategory = "Todos";

// --- LISTA MAESTRA DE PRODUCTOS (OPCIÓN 3) ---
const List<Product> allProducts = [
  Product(category: "Moda", name: "Zapatos Deportivos Ultra", price: "15.50", discount: "60% dto.", imageUrl: "https://picsum.photos/id/21/400/400", desc: "Zapatos cómodos para correr."),
  Product(category: "Electrónica", name: "Reloj Inteligente Pro", price: "12.99", discount: "45% dto.", imageUrl: "https://picsum.photos/id/20/400/400", desc: "Monitorea tu salud y notificaciones."),
  Product(category: "Electrónica", name: "Audífonos Bluetooth", price: "8.00", discount: "30% dto.", imageUrl: "https://picsum.photos/id/26/400/400", desc: "Sonido envolvente de alta calidad."),
  Product(category: "Hogar", name: "Cámara Vintage Pro", price: "45.00", discount: "10% dto.", imageUrl: "https://picsum.photos/id/250/400/400", desc: "Captura momentos con estilo retro."),
  Product(category: "Moda", name: "Chaqueta Térmica", price: "25.00", discount: "20% dto.", imageUrl: "https://picsum.photos/id/1059/400/400", desc: "Ideal para climas fríos."),
  Product(category: "Hogar", name: "Lámpara de Escritorio", price: "10.50", discount: "15% dto.", imageUrl: "https://picsum.photos/id/1068/400/400", desc: "Iluminación LED ajustable."),
  Product(category: "Belleza", name: "Set de Maquillaje", price: "18.99", discount: "50% dto.", imageUrl: "https://picsum.photos/id/1027/400/400", desc: "Completo set para profesionales."),
  Product(category: "Deportes", name: "Balón de Fútbol", price: "12.00", discount: "5% dto.", imageUrl: "https://picsum.photos/id/1058/400/400", desc: "Tamaño oficial de competencia."),
  Product(category: "Moda", name: "Gafas de Sol", price: "5.99", discount: "80% dto.", imageUrl: "https://picsum.photos/id/1067/400/400", desc: "Protección UV total."),
  Product(category: "Electrónica", name: "Tablet Pro 10", price: "89.99", discount: "15% dto.", imageUrl: "https://picsum.photos/id/101/400/400", desc: "Pantalla retina de alta definición."),
  Product(category: "Juguetes", name: "Oso de Peluche", price: "7.50", discount: "10% dto.", imageUrl: "https://picsum.photos/id/1084/400/400", desc: "Suave y antialérgico."),
  Product(category: "Hogar", name: "Cafetera Express", price: "35.00", discount: "25% dto.", imageUrl: "https://picsum.photos/id/1060/400/400", desc: "Café perfecto en segundos."),
];

// --- NAVEGACIÓN PRINCIPAL ---
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
          setState(() {
            selectedCategory = cat;
            _selectedIndex = 0; // Vuelve al inicio para ver los productos filtrados
          });
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
            icon: Badge(
              label: Text('${cartItems.length}'),
              isLabelVisible: cartItems.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Carrito',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tú'),
        ],
      ),
    );
  }
}

// --- PANTALLA DE INICIO CON ANIMACIONES (OPCIÓN 2) ---
class ProductGridScreen extends StatelessWidget {
  final VoidCallback onAddToCart;
  const ProductGridScreen({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    // Filtrar productos según la categoría seleccionada
    final filteredProducts = selectedCategory == "Todos" 
        ? allProducts 
        : allProducts.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(selectedCategory == "Todos" ? "Temu Clone" : selectedCategory, 
             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          if (selectedCategory != "Todos")
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () { (context as Element).markNeedsBuild(); selectedCategory = "Todos"; onAddToCart(); },
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner (Solo se muestra en "Todos")
            if (selectedCategory == "Todos")
              SizedBox(
                height: 180,
                child: PageView(
                  children: [
                    _buildBanner("https://picsum.photos/id/1073/800/300", "REBAJAS DE MARZO"),
                    _buildBanner("https://picsum.photos/id/1080/800/300", "ENVÍO GRATIS"),
                  ],
                ),
              ),
            
            // Grid de productos con animación
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return AnimatedProductCard(
                  product: filteredProducts[index], 
                  index: index,
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: filteredProducts[index], onAddToCart: onAddToCart))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(String url, String text) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, backgroundColor: Colors.black26))),
    );
  }
}

// --- WIDGET DE TARJETA ANIMADA (OPCIÓN 2) ---
class AnimatedProductCard extends StatefulWidget {
  final Product product;
  final int index;
  final VoidCallback onTap;
  const AnimatedProductCard({super.key, required this.product, required this.index, required this.onTap});

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400 + (widget.index * 100)));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: InkWell(
          onTap: widget.onTap,
          child: Card(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(10)), child: Image.network(widget.product.imageUrl, fit: BoxFit.cover, width: double.infinity))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                      Text("\$${widget.product.price}", style: const TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(widget.product.discount, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- PANTALLA DE CATEGORÍAS ---
class CategoriesScreen extends StatelessWidget {
  final Function(String) onCategorySelected;
  const CategoriesScreen({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Moda', 'icon': Icons.checkroom},
      {'name': 'Electrónica', 'icon': Icons.devices},
      {'name': 'Hogar', 'icon': Icons.home_repair_service},
      {'name': 'Belleza', 'icon': Icons.face},
      {'name': 'Juguetes', 'icon': Icons.toys},
      {'name': 'Deportes', 'icon': Icons.sports_soccer},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Explorar Categorías")),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5, mainAxisSpacing: 15, crossAxisSpacing: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () => onCategorySelected(categories[index]['name'] as String),
          child: Container(
            decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.orange.withOpacity(0.2))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(categories[index]['icon'] as IconData, size: 40, color: Colors.orange[800]),
                Text(categories[index]['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- PERFIL Y CARRITO (SE MANTIENEN IGUAL PERO MEJORADOS) ---
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
          const Divider(),
          ListTile(leading: const Icon(Icons.location_on), title: const Text("Carrera felicidad # 27 - 12")),
          ListTile(leading: const Icon(Icons.phone), title: const Text("3194059767")),
          const Spacer(),
          Padding(padding: const EdgeInsets.all(20), child: ElevatedButton(onPressed: (){}, child: const Text("Configuración"))),
        ],
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
        ? const Center(child: Text("¡Está muy vacío! Agrega algo."))
        : Column(
            children: [
              Expanded(child: ListView.builder(itemCount: cartItems.length, itemBuilder: (context, i) => ListTile(
                leading: Image.network(cartItems[i].imageUrl, width: 40),
                title: Text(cartItems[i].name),
                trailing: Text("\$${cartItems[i].price}"),
              ))),
              Container(padding: const EdgeInsets.all(20), color: Colors.grey[100], child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Total:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text("\$${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20))]),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: (){ 
                  setState(() => cartItems.clear());
                  showDialog(context: context, builder: (c) => const AlertDialog(title: Text("Pedido Realizado"), content: Text("Keissy, tu pedido llegará pronto.")));
                }, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)), child: const Text("COMPRAR AHORA", style: TextStyle(color: Colors.white)))
              ]))
            ],
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
      appBar: AppBar(title: const Text("Detalle")),
      body: ListView(children: [
        Image.network(product.imageUrl, height: 350, fit: BoxFit.cover),
        Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("\$${product.price}", style: const TextStyle(fontSize: 22, color: Colors.orange, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Text(product.desc),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: (){ cartItems.add(product); onAddToCart(); Navigator.pop(context); }, 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 50)), child: const Text("AÑADIR AL CARRITO", style: TextStyle(color: Colors.white)))
        ]))
      ]),
    );
  }
}