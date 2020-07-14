import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app3/screens/product_detail_screen.dart';
import 'package:flutter_app3/providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          print(product.id);
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: Consumer<Product>(
            builder: (ctx, pd, ch) => Icon(
              pd.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () {
            product.toggleFavoriteStatus();
          },
        ),
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          color: Theme.of(context).accentColor,
          onPressed: () {},
        ),
      ),
    );
  }
}
