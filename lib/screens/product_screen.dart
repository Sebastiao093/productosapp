import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider( productService.selectedProduct! ),
      child: _ProductScreenBody(productService: productService),
    );

   
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {

    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
       /*  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,    permite que al tocar o mover la pantalla con un movimiento de tipo drag, el teclado se esconda */
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productService.selectedProduct!.picture,),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.white,)
                    )),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      final picker = new ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.camera, // tambien se puede poner ImageSource.gallery
                        imageQuality: 100,
                        );
                      
                      if( pickedFile == null ){/* 
                        print('No seleccionó nada'); */
                        return;
                      }

                      /* print('Tenemos imagen ${pickedFile.path}'); */

                      productService.updateSelectedProductImage(pickedFile.path);

                    }, 
                    icon: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white,)
                    ))
              ],
            ),
            _ProductForm(),

            SizedBox(height: 100,)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: productService.isSaving 
          ? CircularProgressIndicator( color: Colors.white,)
          : Icon(Icons.save_outlined),
        onPressed: productService.isSaving 
        ? null 
        : () async {

          if (!productFormProvider.isValidForm()){
            return;
          } else {
            final String? imageUrl = await productService.uploadImage();

            if( imageUrl != null){
              productFormProvider.product.picture = imageUrl;
            }

            await productService.saveOrCreateProduct(productFormProvider.product);
          }          

        },),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productFormProvider = Provider.of<ProductFormProvider>(context);
    final product = productFormProvider.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productFormProvider.formKey,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if( value == null || value.length < 1){
                    return 'El nombre es obligatorio';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto', 
                  labelText: 'Nombre:'),
              ),
              SizedBox(height: 30,),

              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  if( double.tryParse(value) == null){
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }

                  
                },
                validator: (value) {
                  if( value == null || value.length < 1){
                    return 'El precio es obligatorio';
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Precio:'),
              ),
              SizedBox(height: 30,),

              SwitchListTile.adaptive(
                value: product.available, 
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: (value) => productFormProvider.updateAvailability(value),

                
              ),

              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(25),
        bottomLeft: Radius.circular(25)
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
          offset: Offset(0,5)
        )
      ]
    );
  }
}