import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app3/providers/product.dart';
import 'package:flutter_app3/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode(); // Move to next input control
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  var _initProductId;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'isFavorite': ''
  };
  var _initIsFavorite = false;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      print(productId);
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initProductId = productId;
        _initValues = {
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'imageUrl': product.imageUrl,
        };
        _initIsFavorite = product.isFavorite;
        _imageUrlController.text = _initValues['imageUrl'];
      }

      _isInit = false;
    }

    print(_initValues);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose(); // dispos, or memory leak happens
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = _form.currentState.validate();
      if (isValid) {
        _form.currentState.save();

        if (_initProductId != null) {
          await Provider.of<Products>(context, listen: false).updateProduct(
            _initProductId,
            Product(
              id: _initProductId,
              title: _initValues['title'],
              price: double.parse(_initValues['price']),
              description: _initValues['description'],
              imageUrl: _initValues['imageUrl'],
              isFavorite: _initIsFavorite,
            ),
          );
        } else {
          await Provider.of<Products>(context, listen: false).addProduct(
            Product(
              id: _initProductId,
              title: _initValues['title'],
              price: double.parse(_initValues['price']),
              description: _initValues['description'],
              imageUrl: _initValues['imageUrl'],
            ),
          );
        }
      }

      Navigator.of(context).pop();
    } catch (err) {
      print(err);

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction:
                          TextInputAction.next, // Move to next input control
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            _priceFocusNode); // Move to next input control
                      },
                      validator: (value) {
                        value = value.trim();
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _initValues['title'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        value = value.trim();
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _initValues['price'] = value;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        value = value.trim();
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 5) {
                          return 'Should be at least 5 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _initValues['description'] = value;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              print('onFieldSubmitted');
                              _saveForm();
                            },
                            validator: (value) {
                              value = value.trim();
                              if (value.isEmpty) {
                                return 'Please enter a URL.';
                              }
                              if (!value.startsWith('http')) {
                                return 'Please enter a valid URL.';
                              }
                              // if (!value.endsWith('.png') ||
                              //     !value.endsWith('.jpg') ||
                              //     !value.endsWith('.jpeg')) {
                              //   return 'Please enter a valid image URL.';
                              // }
                              return null;
                            },
                            onSaved: (value) {
                              _initValues['imageUrl'] = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
