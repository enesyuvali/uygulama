import 'dart:js';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicinereminder/animations/fade_animation.dart';
import 'package:medicinereminder/widgets/AddMedicine.dart';
import 'package:medicinereminder/widgets/MedicineEmptyState.dart';
import 'package:scoped_model/scoped_model.dart';

import 'database/moor_database.dart';
import 'enums/icon_enum.dart';
import 'models/Medicine.dart';
import 'widgets/AppBar.dart';
import 'widgets/DeleteIcon.dart';
import 'widgets/MedicineGridView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // dismiss the keyboard or focus
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Medicine Reminder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff3EB16E),
          accentColor: Color(0xff00c853),
        ),
        home: MyMedicineRemainder(),
      ),
    );
  }
}

class MyMedicineRemainder extends StatefulWidget {
  MyMedicineRemainder();

  @override
  _MyMedicineReminder createState() => _MyMedicineReminder();
}

class _MyMedicineReminder extends State<MyMedicineRemainder> {
  var BorderRadius;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    MedicineModel model;
    return ScopedModel<MedicineModel>(
      model: model = MedicineModel(),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              buildBottomSheet(deviceHeight, model);
            },
            child: Icon(
              Icons.add,
              size: 40,
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).accentColor,
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                MyAppBar(greenColor: Theme.of(context).primaryColor),
                Expanded(
                  child: ScopedModelDescendant<MedicineModel>(
                    builder: (context, child, model) {
                      return Stack(children: <Widget>[
                        buildMedicinesView(model),
                        (model.getCurrentIconState() == DeleteIconState.hide)
                            ? Container()
                            : DeleteIcon()
                      ]);
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }

  FutureBuilder buildMedicinesView(model) {
    return FutureBuilder(
      future: model.getMedicineList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          if (snapshot.data.length == 0) {
            // No data
            return Center(child: MedicineEmptyState());
          }
          return MedicineGridView(snapshot.data);
        }
        return (Container());
      },
    );
  }

  void buildBottomSheet(double height, MedicineModel model) async {
    var medicineId = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45))),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FadeAnimation(
            .6,
            AddMedicine(height, model.getDatabase(), model.notificationManager),
          );
        });

    if (medicineId != null) {
      Fluttertoast.showToast(
          msg: "The Medicine was added!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white,
          fontSize: 20.0);

      setState(() {});
    }
  }

  void setState(Null Function() param0) {}

  Center({child}) {}

  FutureBuilder({future, Function(dynamic context, dynamic snapshot)? builder}) {}
}

mixin FutureBuilder {
}

class FutureBuilder {
}







class MedicineEmptyState {
}

class Container {
}

showModalBottomSheet({required RoundedRectangleBorder shape, required JsObject context, required bool isScrollControlled, required FadeAnimation Function(dynamic context) builder}) {
}

class RoundedRectangleBorder {
}



class Radius {
  static circular(int i) {}
}

class FadeAnimation {
  FadeAnimation(double d, AddMedicine addMedicine);
}

class AddMedicine {
  AddMedicine(double height, AppDatabase database, notificationManager);
}

class Fluttertoast {
  static void showToast({required String msg, toastLength, gravity, required int timeInSecForIos, backgroundColor, textColor, required double fontSize}) {}
}

mixin LENGTH_SHORT {
}

class Toast {
  static var LENGTH_SHORT;
}

class BOTTOM {
}


class ToastGravity {
  static var BOTTOM;
}

class Theme {
  static of(JsObject context) {}
}

class Colors {
  static var white;
}
