import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../screens/orders_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Ankit !'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text('My Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routName);
              }),
          Divider(),
          ListTile(
              leading: Icon(MdiIcons.shopping),
              title: Text('Your Shopping Cart'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(CartScreen.routName);
              }),
          Divider(),
          ListTile(
              leading: Icon(MdiIcons.accountDetails),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routName);
              }),
        ],
      ),
    );
  }
}
