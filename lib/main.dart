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
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: const MainNavigation(),
    );
  }
}

// --- NAVEGACIÓN PRINCIPAL ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ProductGridScreen(),
    Center(child: Text('Categorías', style: TextStyle(fontSize: 24))),
    Center(child: Text('Promociones', style: TextStyle(fontSize: 24))),
    Center(child: Text('Perfil', style: TextStyle(fontSize: 24))),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Ofertas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tú'),
        ],
      ),
    );
  }
}

// --- MODELO DE DATOS PARA PRODUCTO ---
class Product {
  final String name;
  final String price;
  final String discount;
  final String imageUrl;
  final String desc;

  const Product({
    required this.name,
    required this.price,
    required this.discount,
    required this.imageUrl,
    required this.desc,
  });
}

// --- PANTALLA DE CATÁLOGO (GRID) ---
class ProductGridScreen extends StatelessWidget {
  const ProductGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de Banners
    final List<String> banners = [
      "https://picsum.photos/id/1073/800/300",
      "https://picsum.photos/id/1080/800/300",
      "https://picsum.photos/id/102/800/300",
    ];

    // Lista de Productos (La misma de antes)
    final List<Product> products = [
      Product(
        name: "Zapatos Deportivos Ultra",
        price: "15.50",
        discount: "60% dto.",
        imageUrl: "https://picsum.photos/id/21/400/400",
        desc: "Zapatos cómodos para correr.",
      ),
      Product(
        name: "Reloj Inteligente Pro",
        price: "12.99",
        discount: "45% dto.",
        imageUrl: "https://picsum.photos/id/20/400/400",
        desc: "Monitorea tu salud.",
      ),
      Product(
        name: "Audífonos Bluetooth",
        price: "8.00",
        discount: "30% dto.",
        imageUrl: "https://picsum.photos/id/26/400/400",
        desc: "Sonido envolvente.",
      ),
      Product(
        name: "Cámara Vintage Pro",
        price: "45.00",
        discount: "10% dto.",
        imageUrl: "https://picsum.photos/id/250/400/400",
        desc: "Captura momentos retro.",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Temu Clone", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        // Permite que toda la pantalla haga scroll
        child: Column(
          children: [
            // --- SECCIÓN DEL BANNER MEJORADA ---
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(banners[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              colors: [
                                Colors.orange.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "OFERTA RELÁMPAGO ⚡",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Termina en: 00:59:59",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Puntos indicadores (Dots)
                Positioned(
                  bottom: 25,
                  right: 30,
                  child: Row(
                    children: List.generate(
                      banners.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // --- TÍTULO DE SECCIÓN ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recomendados para ti",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // --- GRID DE PRODUCTOS ---
            // Usamos GridView.count o builder con shrinkWrap para que funcione dentro de un ScrollView
            GridView.builder(
              shrinkWrap: true, // Importante: evita conflictos de scroll
              physics:
                  const NeverScrollableScrollPhysics(), // El scroll lo maneja el SingleChildScrollView
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: item),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                "\$${item.price}",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item.discount,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
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

// --- PANTALLA DE DETALLE DEL PRODUCTO ---
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          Image.network(
            product.imageUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "\$${product.price}",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      product.discount,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(product.desc, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para añadir al carrito
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} añadido al carrito!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Añadir al Carrito",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
