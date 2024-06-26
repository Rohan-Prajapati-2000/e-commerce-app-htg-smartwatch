import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:htg_smart_watch/models/products.dart';
import 'package:htg_smart_watch/models/shop.dart';
import 'package:htg_smart_watch/product_image_array.dart';
import 'package:provider/provider.dart';

class CartContent extends StatefulWidget {
  @override
  State<CartContent> createState() => _CartContentState();
}

class _CartContentState extends State<CartContent> {
  late List<Product> cart;

  @override
  void initState() {
    super.initState();
    // Load cart data from Firestore only once during initialization
    context.read<Shop>().loadCartFromFirestore();
  }

  void removeToCart(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Remove this item from cart"),
        actions: [
          // Cancel button
          MaterialButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          // Remove button
          MaterialButton(
            child: Text("Remove"),
            onPressed: () {
              Navigator.pop(context);
              // Remove item from cart
              context.read<Shop>().removeToCart(product);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use watch to rebuild the widget when cart data changes
    cart = context.watch<Shop>().cart;
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Center(
        child: ListView.builder(
          itemCount: cart.length,
          itemBuilder: (context, index) {
            final item = cart[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color: Colors.blue,
                                    height: 120,
                                    width: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ImageListViewArray(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25),
                                    child: Container(
                                      height: 60,
                                      child: ListView(
                                        children: [
                                          Text(item.description,
                                              textAlign: TextAlign.justify
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (item.quantity > 1) {
                                            item.quantity--;
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "${item.quantity}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          item.quantity++;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        CupertinoColors.systemYellow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    removeToCart(context, item);
                                  },
                                  child: Text("Remove"),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        CupertinoColors.systemYellow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text("Pay"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
