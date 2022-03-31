import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mis_parking_app/models/geometry.dart';

class ParkingSpot{
  final String name;
  final double rating;
  final int userRatingCount;
  final Geometry geometry;
  final BitmapDescriptor icon;

  ParkingSpot({required this.geometry, required this.name, required this.rating, required this.userRatingCount, required this.icon});

  ParkingSpot.fromJson(Map<dynamic, dynamic> parsedJson, BitmapDescriptor icon)
      :name = parsedJson['name'],
        rating = (parsedJson['rating'] !=null) ? parsedJson['rating'].toDouble() : null,
        userRatingCount = (parsedJson['user_ratings_total'] != null) ? parsedJson['user_ratings_total'] : null,
        geometry = Geometry.fromJson(parsedJson['geometry']),
        icon=icon;

}