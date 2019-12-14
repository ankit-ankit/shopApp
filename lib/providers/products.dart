import 'dart:convert'; // provides tools to convert data from one format to another. Here we are using it to convert to the json file

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((current) => current.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndLoad() async {
    const url = 'https://flutter-update-a725e.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            price: prodData['price'],
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product comingProduct) async {
    const url = 'https://flutter-update-a725e.firebaseio.com/products.json';
    try {
      final response =
          await http // await tells dart to wait for this code to execute and it automatically wrap the next block in then()
              .post(
        url,
        body: jsonEncode({
          // you can not pass a object to the json but a map
          'title': comingProduct.title,
          'description': comingProduct.description,
          'price': comingProduct.price,
          'imageUrl': comingProduct.imageUrl,
          'isFavorite': comingProduct.isFavorite
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: comingProduct.title,
          description: comingProduct.description,
          price: comingProduct.price,
          imageUrl: comingProduct.imageUrl);
      _items.add(newProduct);
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product comingProduct) async {
    final productIndex = _items.indexWhere((prodData) => prodData.id == id);
    final url = 'https://flutter-update-a725e.firebaseio.com/products/$id.json';
    try {
      await http.patch(url,
          body: json.encode({
            'title': comingProduct.title,
            'description': comingProduct.description,
            'imageUrl': comingProduct.imageUrl,
            'price': comingProduct.price
          }));
    } catch (error) {
      print(error);
    }
    _items[productIndex] = comingProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-update-a725e.firebaseio.com/products/$id.json';
    final existingProductIndex =
        _items.indexWhere((prodData) => prodData.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete');
    }
    existingProduct = null;
  }
}
