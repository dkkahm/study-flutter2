import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app3/providers/products.dart';
import 'package:flutter_app3/providers/cart.dart';
import 'package:flutter_app3/providers/orders.dart';

import 'package:flutter_app3/screens/product_detail_screen.dart';
import 'package:flutter_app3/screens/products_overview_screen.dart';
import 'package:flutter_app3/screens/cart_screen.dart';
import 'package:flutter_app3/screens/orders_screen.dart';

import 'package:flutter_app3/widgets/app_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductsOverview(),
        routes: {
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
        },
      ),
    );
  }
}
