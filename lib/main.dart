import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mis_parking_app/parking_spot.dart';
import 'package:mis_parking_app/parking_spot_service.dart';
import 'package:provider/provider.dart';

import 'locator_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final locatorService = LocatorService();
  final parkingSpotsService = ParkingSpotsService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (context) => locatorService.getLocation()),
        FutureProvider(create: (context) {
          ImageConfiguration configuration = createLocalImageConfiguration(context);
          return BitmapDescriptor.fromAssetImage(configuration, 'assets/images/parking-icon.png');
        }),
        ProxyProvider2<Position,BitmapDescriptor,Future<List<ParkingSpot>>>(
          update: (context,position,icon,places){
            return (position !=null) ? parkingSpotsService.getPlaces(position.latitude, position.longitude,icon) :null;
          },
        )
      ],
      child: MaterialApp(
        title: 'Parking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: Search(),
      ),
    );
  }
}
