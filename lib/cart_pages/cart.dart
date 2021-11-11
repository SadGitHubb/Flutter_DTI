import 'package:dti/cart_pages/purchase.dart';
import 'package:dti/cart_pages/total_controller.dart';
import 'package:dti/pages/drawer_widget.dart';
import 'package:dti/sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  final user = FirebaseAuth.instance.currentUser!;
  late Query _ref;

  @override
  void initState() {
    super.initState();

    _ref = FirebaseDatabase.instance.reference()
        .child('${user.displayName.toString()} cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Seu carrinho'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.blueAccent,
        actions: [
          FlatButton(
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: const Icon(
              Icons.logout,
              color: Colors.black,
              size: 20,),
            onPressed: () {
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
          ),
        ],
      ),
      body: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map equipment = snapshot.value;
            return _buildEquipmentItem(equipment: equipment);
          }),
      

      persistentFooterButtons: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Confirmação'),
                                        content: const Text('Realizar o pagamento?'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: const Text('Não'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: const Text('Sim'),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const Purchase(),
                                                  ));
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Consumer<TotalController>(
                                      builder: (context, value, child) => Text("Realizar pagamento: R\$ ${value.total.toString()}.00"),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  /// Build para fazer os Carts**/
  Widget _buildEquipmentItem({required Map equipment}) {
    return Container(
      padding: const EdgeInsets.all(4),
      height: 112,
      color: Colors.white,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(width: 5,),
                const Icon(Icons.wallet_travel,
                  color: Colors.black,
                  size: 20,),
                const SizedBox(width: 2,),
                Text(equipment["equipment"], style: const TextStyle(fontSize: 16,
                    color: Colors.black,//Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),),
              ],
            ),
            const SizedBox(height: 1,),
            Row(
              children: [
                const SizedBox(width: 10,),
                const Icon(Icons.monetization_on,
                  color: Colors.green,
                  size: 20,),
                const SizedBox(width: 6,),
                Text("R\$ "+equipment["price_day"].toString()+ ",00 por dia",
                  style: const TextStyle(fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),),
                const SizedBox(width: 90,),
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: () {

                  },
                ),
                const SizedBox(width: 5,),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Colors.green,
                  onPressed: () {

                  },
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 5,),
                Text("Quantidade: "+equipment["quantity"].toString(), style: const TextStyle(fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
              ],
            ),
            const Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }

}
