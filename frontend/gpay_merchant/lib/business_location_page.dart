import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';

import 'business_phone_page.dart';
import 'location_confirm_on_map_page.dart';

class BusinessDetailsPageTwo extends StatefulWidget {
  @override
  _BusinessDetailsPageTwoState createState() => _BusinessDetailsPageTwoState();
}

/*
 * This class contains the view to accept the business address such as: street name, area, city and state.
 * It also redirects to a google maps page to confirm the location of the business.
 */
class _BusinessDetailsPageTwoState extends State<BusinessDetailsPageTwo> {
  TextEditingController pincodeController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  final formValidationKey = GlobalKey<FormState>();
  bool validate = false;
  bool isMapValid = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextStyle styleBold = GoogleFonts.montserrat(fontWeight: FontWeight.w500);
    TextStyle style = GoogleFonts.montserrat();

    showAlertDialog(String title, String alertMessage, BuildContext context) {

      // This is the setup of the button to give user the choice to click on OK after reading the dialog.
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      // This is the setup of the alert dialog based on the provided title.
      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(alertMessage, style: GoogleFonts.montserrat(),),
        actions: [
          okButton,
        ],
      );

      // This is where the alert dialog is displayed.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Form(key: formValidationKey,
    child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.01, width * 0.05, height * 0.05),
          child: ListView(
            children: <Widget>[
              Text("Business location (2/3)",
                style: styleBold.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
              Text("put location and confirm on map",
                style: styleBold.copyWith(
                  color: Colors.black26,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: (height * 0.03),
              ),
              TextFormField(
                controller: pincodeController,
                style: style,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cannot be empty";
                  }
                  try {
                    var pincode = int.parse(value);
                    if (pincode < 100000 || pincode > 999999) {
                       return "Invalid Pincode";
                    }
                  }
                  on FormatException {
                    return "Invalid Pincode";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'PIN code',
                  hintStyle: style.copyWith(color: Colors.black38),
                ),
              ),
              SizedBox(
                height: (height * 0.015),
              ),
              TextFormField(
                controller: streetController,
                style: style,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cannot be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Shop number and street name',
                  hintStyle: style.copyWith(color: Colors.black38),
                ),
              ),
              SizedBox(
                height: (height * 0.015),
              ),
              TextFormField(
                controller: areaController,
                style: style,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cannot be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Area/locality/village',
                  hintStyle: style,
                ),
              ),
              SizedBox(
                height: (height * 0.015),
              ),
              TextFormField(
                controller: cityController,
                style: style,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cannot be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'City',
                  hintStyle: style,
                ),
              ),
              SizedBox(
                height: (height * 0.015),
              ),
              TextFormField(
                controller: stateController,
                style: style,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cannot be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'State/County',
                  hintStyle: style,
                ),
              ),
              SizedBox(
                height: (height * 0.015),
              ),
              FloatingActionButton.extended(
                icon: validate? Icon(Icons.check) : Icon(Icons.map),
                label: Text("Confirm on map"),
                backgroundColor: isMapValid ? Colors.blue : Colors.red,
                onPressed: () async{
                 if  ((cityController.text == null || cityController.text.isEmpty)
                     || (streetController.text == null || streetController.text.isEmpty)) {
                   showAlertDialog("Error", "Select city and street", context);
                 }
                 else {
                      final query = streetController.text + ", " + cityController.text;
                      var addresses;
                      try {
                        addresses = await Geocoder.local.findAddressesFromQuery(query);}
                      catch (err) {
                        showAlertDialog("Error","Error with processing address", context);
                      }
                      var first = addresses.first;
                    var result = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          MapView(city: cityController.text,
                            street: streetController.text,
                            latitude: first.coordinates.latitude,
                            longitude: first.coordinates.longitude,)));
                    showAlertDialog("Success","Location Selected", context);
                    setState(() {
                      validate = true;
                      isMapValid = true;
                    });
                  }
                },
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      //TODO: UPDATE STORE OBJECT
                      if (formValidationKey.currentState.validate() && validate)
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              BusinessDetailsPageThree()));
                              else setState(() {
                                isMapValid = false;
                              });;
                    },
                    child: Text(
                      "Next",
                      style: style,
                    ),
                  )
              )
            ],
          ),
        ),
      ),)
    );
  }
}
