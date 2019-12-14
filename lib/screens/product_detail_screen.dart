import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';

import '../screens/cart_screen.dart';
import '../widgets/badge.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, CartScreen.routName);
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                width: double.infinity,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Rs ${loadedProduct.price.round()}',
                style: TextStyle(color: Colors.grey, fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.max,
                alignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    child: Text(
                      'Add To Cart',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      cart.addItem(loadedProduct.id, loadedProduct.price,
                          loadedProduct.title, loadedProduct.imageUrl);
                    },
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    child: Text(
                      'Buy Now',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      cart.addItem(loadedProduct.id, loadedProduct.price,
                          loadedProduct.title, loadedProduct.imageUrl);
                      Navigator.pushReplacementNamed(
                          context, CartScreen.routName);
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}
