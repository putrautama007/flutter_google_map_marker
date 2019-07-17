import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);
  Set<Marker> markers = Set();
  MapType _currentMapType = MapType.normal;
  LatLng centerPosition;
  String latlang= "", address = "";

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
      print("dddd" + _currentMapType.toString());
    });
  }

  void _onAddMarkerButtonPressed() {
    Marker marker = Marker(
      markerId: MarkerId(markers.length.toString()),
      position: centerPosition,
    );
    setState(() {
     latlang = "position  latitude: ${marker.position.latitude}, longitude : ${marker.position.longitude}";
     _getAddress(marker);
    });
  }

  void _getAddress(Marker marker) async{
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(marker.position.latitude, marker.position.longitude);
    setState(() {
      if(placemark[0].subLocality == '')
        address="${placemark[0].thoroughfare} ${placemark[0].subThoroughfare},${placemark[0].locality},${placemark[0].subAdministrativeArea},${placemark[0].administrativeArea} ${placemark[0].postalCode},${placemark[0].country}";
      else
        address="${placemark[0].thoroughfare} ${placemark[0].subThoroughfare},${placemark[0].subLocality},${placemark[0].locality},${placemark[0].subAdministrativeArea},${placemark[0].administrativeArea} ${placemark[0].postalCode},${placemark[0].country}";

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFF02BB9F),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Google map widget',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              mapType: _currentMapType,
              myLocationEnabled: true,
              markers: markers,
              onCameraMove: _onCameraMove,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              onCameraIdle: _onAddMarkerButtonPressed,
            ),
            Center(
              child: Icon(Icons.add_location, color: Colors.red, size: 30,),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: new FloatingActionButton(
                  onPressed: _onMapTypeButtonPressed,
                  child: new Icon(
                    Icons.map,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.blue,
                height: 50,
                width: 300,
                margin: EdgeInsets.all(16),
                child: Text('$latlang'),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.blue,
                height: 50,
                width: 300,
                margin: EdgeInsets.only(right: 16, left: 16, bottom: 100),
                child: Text('$address'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    centerPosition = position.target;
  }
}
