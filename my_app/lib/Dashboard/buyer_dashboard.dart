import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/notification_service.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Electronics',
    'Furniture',
    'Clothing',
    'Books',
  ];

  // Sample product data - replace with actual data from your backend
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Smartphone',
      'price': 499.99,
      'image': 'https://via.placeholder.com/150',
      'address': '123 Market St, New York',
      'category': 'Electronics',
    },
    {
      'id': '2',
      'name': 'Wooden Chair',
      'price': 89.99,
      'image': 'https://via.placeholder.com/150',
      'address': '456 Furniture Ave, Chicago',
      'category': 'Furniture',
    },
    // Add more sample products as needed
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products;
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesCategory = _selectedCategory == 'All' ||
            product['category'] == _selectedCategory;
        final matchesSearch = product['name'].toLowerCase().contains(query) ||
            product['description']?.toLowerCase().contains(query) == true;
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showCart() async {
    final cartItems = await CartService.getCart();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Shopping Cart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (cartItems.isEmpty)
                const Text('Your cart is empty')
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          item['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item['name']),
                        subtitle:
                            Text('\$${item['price']} x ${item['quantity']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await CartService.removeFromCart(item['id']);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    await CartService.addToCart(product);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart!')),
    );
  }

  Future<void> _showNotifications() async {
    final notifications = await NotificationService.getNotifications();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (notifications.isEmpty)
                const Text('No notifications')
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return ListTile(
                        title: Text(notification['message']),
                        subtitle: Text(DateTime.parse(notification['timestamp'])
                            .toString()),
                        trailing: notification['read']
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () async {
                                  await NotificationService.markAsRead(
                                      notification['id']);
                                  setState(() {});
                                },
                              ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                      _filterProducts();
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showProductDetails(Map<String, dynamic> product) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${product['price'].toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    product['address'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    product['category'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _addToCart(product),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _filterProducts();
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChoiceChip(
                  label: Text(_categories[index]),
                  selected: _selectedCategory == _categories[index],
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = _categories[index];
                      _filterProducts();
                    });
                  },
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          product['image'],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '\$${product['price'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                product['address'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () => _showProductDetails(product),
                                icon: const Icon(Icons.visibility),
                                label: const Text('View Details'),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _addToCart(product),
                                icon: const Icon(Icons.shopping_cart),
                                label: const Text('Add to Cart'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    return const Center(
      child: Text('Favorites Tab'),
    );
  }

  Widget _buildProfileTab() {
    return const Center(
      child: Text('Profile Tab'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Dashboard'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _showCart,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildFavoritesTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
