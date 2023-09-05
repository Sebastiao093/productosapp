
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(url: product.picture,),

            _ProductDetails(name: this.product.name, id: this.product.id!,),

            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(price: this.product.price,)
              ),

            if(!product.available)
            Positioned(
              top: 0,
              left: 0,
              child: _NotAvailable(available: this.product.available)
              )

          ],
        )
          
        ,
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0,7)
        )
      ]
        
      );
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({
    Key? key, required this.available,

  }) : super(key: key);

  final bool available;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(available ? 'disponible' : 'No disponible', style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),),),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25)

        )
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({
    Key? key,
    required double this.price,
  }) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$$price' /* + '${this.price}' */, style: TextStyle(
            color: Colors.white, fontSize: 20
          ),),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.indigo, 
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25)
      ))
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    Key? key, required this.id, required this.name,
  }) : super(key: key);

  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${name}', 
            style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            ),
            Text('${id}', 
            style: TextStyle(
              fontSize: 15, color: Colors.white,)
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25) )
    );
  } 
}

class _BackgroundImage extends StatelessWidget {

  final String? url;

  const _BackgroundImage({
    Key? key, this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url == null ? Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover) 
        : FadeInImage(
          image: NetworkImage(url!),
          placeholder: AssetImage('assets/jar-loading.gif'),
          fit: BoxFit.cover,),
      ),
    );
  }
}