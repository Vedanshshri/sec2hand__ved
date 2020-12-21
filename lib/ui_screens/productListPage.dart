import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sec2hand/staticdata.dart';
import 'package:sec2hand/theme.dart';
import 'package:sec2hand/ui_screens/productDetailsPage.dart';
import 'package:sec2hand/ui_screens/shared/loading.dart';

class ProductListPage extends StatefulWidget {
  final categoryProduct;
  final cityProduct;

  ProductListPage(this.categoryProduct, this.cityProduct);
  @override
  State<StatefulWidget> createState() {
    return _ProductListPage();
  }
}

class _ProductListPage extends State<ProductListPage> {
  Dio dio = new Dio();
  var categoryProduct;
  var cityProduct;
  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;
  int offset = 0;
  List productList = new List();
  var hasMore = true;

  var sortvar = 'All';
  @override
  void initState() {
    categoryProduct = widget.categoryProduct;
    cityProduct = widget.cityProduct;
    this.fetchProduct();

    super.initState();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          hasMore) {
        fetchProduct();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sec2Hand",
          style: ThemeApp().appBarTheme(),
        ),
        /*actions: [
          IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "sortpage");
              })
        ],*/
        bottom: sortList(),
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: getList(),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new Loading(),
        ),
      ),
    );
  }

  Widget sortList() {
    if (categoryProduct == "Bike") {
      return PreferredSize(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: DropdownButton<String>(
            value: sortvar,
            //icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: Colors.grey,
            ),
            onChanged: (String newValue) {
              setState(() {
                sortvar = newValue;
                fetchProduct();
                getList();
              });
            },
            items: <String>[
              'All',
              'Maruti',
              'BMW',
              'Pulshur',
              'Hornet',
              'TVS',
              'Hero',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        preferredSize: Size.fromHeight(40.0),
      );
    } else if (categoryProduct == "car") {
      return PreferredSize(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: DropdownButton<String>(
            value: sortvar,
            //icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: Colors.grey,
            ),
            onChanged: (String newValue) {
              setState(() {
                sortvar = newValue;
                fetchProduct();
                getList();
              });
            },
            items: <String>[
              'All',
              'Maruti',
              'BMW',
              'Ferreri',
              'Tesla',
              'Renault',
              'Hero',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        preferredSize: Size.fromHeight(40.0),
      );
    } else if (categoryProduct == "mobile") {
      return PreferredSize(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: DropdownButton<String>(
            value: sortvar,
            //icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: Colors.grey,
            ),
            onChanged: (String newValue) {
              setState(() {
                sortvar = newValue;
              });
              fetchProduct();
              getList();
            },
            items: <String>[
              'All',
              'MI',
              'Realme',
              'Samsung',
              'Apple',
              'POCO',
              'ASUS',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        preferredSize: Size.fromHeight(40.0),
      );
    }
  }

  Widget getList() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: ListView.builder(
        itemCount: productList.length + 1,
        itemBuilder: (buildContext, index) {
          if (index == productList.length) {
            return _buildProgressIndicator();
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductDetail(
                          productList[productList.length - index - 1]);
                    },
                  ),
                );
              },
              child: Material(

                  // borderRadius: BorderRadius.circular(2),
                  child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.width * 0.36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      new ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image: hostUrl +
                                productList[productList.length - index - 1]
                                    ['images'][0]['image'],
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.36,
                            height: MediaQuery.of(context).size.width * 0.36,
                          )

                          // CachedNetworkImage(
                          //   imageUrl: baseUrl
                          //       + productList[productList.length -
                          //           index -
                          //           1]['images'][0]['image']
                          //   , fit: BoxFit.cover,
                          //   width: MediaQuery.of(context).size.width * 0.36,
                          //   height: MediaQuery.of(context).size.width * 0.36,
                          //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                          //       Loading(),
                          //   errorWidget: (context, url, error) => Icon(Icons.error),
                          // ),
                          ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Container(
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    "Model : " +
                                        productList[productList.length -
                                            index -
                                            1]['model'],
                                    style: ThemeApp().textBoldTheme(),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Price : " +
                                        productList[productList.length -
                                                index -
                                                1]['price']
                                            .toString() +
                                        " /-",
                                    style: ThemeApp().textTheme(),
                                  ),
                                ],
                              ),
                              // Visibility(
                              //     visible: widget.category=="mobile" ? false : true,
                              //     child:
                              //     SizedBox(height: 5,)),
                              // Visibility(
                              //     visible: widget.category=="mobile" ? false : true,
                              //     child:
                              //     Row(
                              //       children: <Widget>[
                              //         Text(
                              //             "Km : "+productList[productList.length-index-1]['km'].toString(),
                              //             style: ThemeApp().textTheme()
                              //         ),
                              //       ],
                              //     )),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Color : " +
                                        productList[productList.length -
                                            index -
                                            1]['color'],
                                    style: ThemeApp().textTheme(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  widget.categoryProduct != "mobile"
                                      ? (widget.categoryProduct == "car"
                                          ? Text(
                                              "Fuel : " +
                                                  productList[
                                                      productList.length -
                                                          index -
                                                          1]['fuel_type'],
                                              style: ThemeApp().textTheme(),
                                            )
                                          : Text(
                                              "Type : " +
                                                  productList[
                                                      productList.length -
                                                          index -
                                                          1]['type'],
                                              style: ThemeApp().textTheme(),
                                            ))
                                      : Container(),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
            );
          }
        },
        controller: _scrollController,
      ),
    );
  }

//mymark to get the product deatails
  fetchProduct() async {
    print(productListApi);
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var response;
      print(categoryProduct);

      if (token == "") {
        response = await dio.get(productListApi, queryParameters: {
          "category": categoryProduct,
          "city": cityProduct,
          "limit": 10,
          "offset": offset
        });
      } else {
        response = await dio.get(productListApi,
            queryParameters: {
              "category": categoryProduct,
              "city": cityProduct,
              "limit": 10,
              "offset": offset
            },
            options: Options(
              contentType: 'application/json',
              headers: {HttpHeaders.authorizationHeader: "Token " + token},
            ));
      }
      //mymark2
      print("data" + response.data.toString());

      if (response.statusCode ==
              200 /*&&
          response.data['products'][1].brand == sortvar*/
          ) {
        List tempList = new List();

        for (int i = 0; i < response.data['products'].length; i++) {
          if (sortvar == 'All') {
            tempList.add(response.data['products'][i]);
            print("aaaaaaa" + response.data['products'][i]['brand']);
          } else if (response.data['products'][i]['brand'] == sortvar) {
            tempList.add(response.data['products'][i]);
            print("aaaaaa" + response.data['products'][i]['brand']);
          } else {
            print("Its a failure");
          }
        }
        setState(() {
          hasMore = response.data['has_more'];
          isLoading = false;
          offset = offset + 10;
          productList.addAll(tempList);
          print(productList);
        });
      } else {
        print(response.statusCode);
        setState(() {
          isLoading = false;
        });
        print(isLoading);
      }
    }
  }
}
