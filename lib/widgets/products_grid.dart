import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app3/providers/products.dart';
import 'package:flutter_app3/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final items = products.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: items.length,
      itemBuilder: (ctx, i) => ProductItem(
        items[i].id,
        items[i].title,
        items[i].imageUrl,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
