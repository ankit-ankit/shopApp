import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItems extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productId;
  final String imageUrl;

  CartItems(
      {this.id,
      this.price,
      this.quantity,
      this.title,
      this.productId,
      this.imageUrl});

  confirmResult(bool value, BuildContext context, Cart obj) {
    if (value) {
      obj.removeItem(productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: Text('$title')),
                    Text(
                      'Rs${(price * quantity).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('x $quantity'),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_upward,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            cart.increaseQuantity(productId);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_downward,
                              //  size: 80,
                              color: Theme.of(context).primaryColorDark),
                          onPressed: () {
                            cart.decreaseQuantity(productId);
                          },
                        ),
                      ],
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(10),
                      color: Theme.of(context).primaryColorDark,
                      child: Text(
                        'Delete item',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text('Are you sure !'),
                                content: Text('Do you really want to delete'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('DELETE'),
                                    onPressed: () {
                                      Navigator.of(ctx)
                                          .pop(confirmResult(true, ctx, cart));
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('KEEP'),
                                    onPressed: () {
                                      Navigator.of(ctx)
                                          .pop(confirmResult(false, ctx, cart));
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
