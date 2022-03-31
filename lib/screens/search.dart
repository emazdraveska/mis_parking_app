import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mis_parking_app/services/locator_service.dart';
import 'package:mis_parking_app/services/marker_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/parking_spot.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<ParkingSpot>>>(context);
    final geoService = LocatorService();
    final markerService = MarkerService();

    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
        body: (currentPosition != null)
            ? Consumer<List<ParkingSpot>>(
          builder: (_, parkingSpots, __) {
            var markers = (parkingSpots != null) ? markerService.getMarkers(parkingSpots) : <Marker>[];
            return (parkingSpots != null)
                ? Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentPosition.latitude,
                            currentPosition.longitude),
                        zoom: 16.0),
                    zoomGesturesEnabled: true,
                    markers: Set<Marker>.of(markers),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: (parkingSpots.length > 0) ? ListView.builder(
                      itemCount: parkingSpots.length,
                      itemBuilder: (context, index) {
                        return FutureProvider(
                          create: (context) =>
                              geoService.getDistance(
                                  currentPosition.latitude,
                                  currentPosition.longitude,
                                  parkingSpots[index]
                                      .geometry
                                      .location
                                      .lat,
                                  parkingSpots[index]
                                      .geometry
                                      .location
                                      .lng),
                          child: Card(
                            child: ListTile(
                              title: Text(parkingSpots[index].name),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  (parkingSpots[index].rating != null)
                                      ? Row(
                                    children: <Widget>[
                                      RatingBarIndicator(
                                        rating: parkingSpots[index]
                                            .rating,
                                        itemBuilder: (context,
                                            index) =>
                                            Icon(Icons.star,
                                                color: Colors
                                                    .amber),
                                        itemCount: 5,
                                        itemSize: 10.0,
                                        direction:
                                        Axis.horizontal,
                                      )
                                    ],
                                  )
                                      : Row(),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Consumer<double>(
                                    builder:
                                        (context, meters, wiget) {
                                      return (meters != null)
                                          ? Text(
                                          '${parkingSpots[index].name} \u00b7 ${(meters / 1609).round()} mi')
                                          : Container();
                                    },
                                  )
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.directions),
                                color:
                                Theme.of(context).primaryColor,
                                onPressed: () {
                                  _launchMapsUrl(
                                      parkingSpots[index]
                                          .geometry
                                          .location
                                          .lat,
                                      parkingSpots[index]
                                          .geometry
                                          .location
                                          .lng);
                                },
                              ),
                            ),
                          ),
                        );
                      }) : Center(child:Text('No Parking Found Nearby'),),
                )
              ],
            )
                : Center(child: CircularProgressIndicator());
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
