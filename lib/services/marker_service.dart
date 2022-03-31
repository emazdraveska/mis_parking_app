import 'package:mis_parking_app/models/parking_spot.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerService {

  List<Marker> getMarkers(List<ParkingSpot> parkingSpots){
    var markers;

    parkingSpots.forEach((place){
      Marker marker = Marker(
          markerId: MarkerId(place.name),
          draggable: false,
          icon: place.icon,
          infoWindow: InfoWindow(title: place.name),
          position: LatLng(place.geometry.location.lat, place.geometry.location.lng)
      );

      markers.add(marker);
    });

    return markers;
  }
}