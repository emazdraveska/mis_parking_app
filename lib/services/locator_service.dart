import 'package:geolocator/geolocator.dart';

class LocatorService{

  Future<Position> getLocation() async {

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<double> getDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) async {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }

}