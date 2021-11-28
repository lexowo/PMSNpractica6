class ProductDAO{
  String? nomprod;
  String? descprod;
  String? imgprod;

  ProductDAO({this.nomprod,this.descprod,this.imgprod});
  Map<String,dynamic> toMap(){
    return{
      'nomprod'   : nomprod,
      'descprod'  : descprod,
      'imgprod'   : imgprod
    };
  }
}