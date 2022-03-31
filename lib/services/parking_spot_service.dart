import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:mis_parking_app/models/parking_spot.dart';

class ParkingSpotsService {
  final key = 'YOUR_KEY';

  Future<List<ParkingSpot>> getPlaces(double lat, double lng, BitmapDescriptor icon) async {
    var response = await http.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=parking&rankby=distance&key=$key');
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((parkingSpot) => ParkingSpot.fromJson(parkingSpot,icon)).toList();
  }

}