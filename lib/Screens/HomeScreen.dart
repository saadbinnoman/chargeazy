import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

const kGoogleApiKey = "AIzaSyCw8i6oxkbsQuNTaFkr7APe7er2QHr55nY";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const LatLng _center = LatLng(23.037531, 72.566551);
  late GoogleMapController _controller;

  //Location currentLocation = Location();
  Set<Marker> _markers = {};
  Mode? _mode = Mode.overlay;
  var city = '';
  Future<Position> _currentLocation = Geolocator.getCurrentPosition();
  late LatLng _userLocation;

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocation();
    });
    //_currentLocation = Geolocator.getCurrentPosition();
  }

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      //_retrieveNearbyRestaurants(_userLocation);
    });

    //_userLocation = LatLng(23.037531, 72.566551);
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 12.0,
        ),
      ),
    );
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('Home'),
          position: LatLng(position.latitude, position.longitude),
        ),
      );
    });

    //debugPrint("Locaion : $location");LatLng(23.037531, 72.566551)
  }

  Future<void> displayPrediction(Prediction? p, BuildContext context) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 13.0,
          ),
        ),
      );
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('Home'),
            position: LatLng(lat, lng),
          ),
        );
        LatLng _userLocations1 = LatLng(lat, lng);
        _retrieveNearbyRestaurants(_userLocations1);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location : ${p.description} - $lat/$lng")),
      );
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        offset: 0,
        //radius: 1000,
        strictbounds: false,
        //region: "ind",
        language: "en",
        context: context,
        mode: Mode.overlay,
        apiKey: kGoogleApiKey,
        //sessionToken: sessionToken,
        components: [
          Component(Component.country, "ind"),
          Component(Component.country, "us"),
          Component(Component.country, "fr"),
          Component(Component.country, "uk"),
        ],
        types: ["(cities)"],
        hint: "Search City",
        startText: city == null || city == "" ? "" : city);

    displayPrediction(p, context);
  }

  final places =
      //GoogleMapsPlaces(apiKey: "AIzaSyAoXUubsBdH5IsSVKITSE9qxchVJWo_phs");
      GoogleMapsPlaces(apiKey: "AIzaSyCw8i6oxkbsQuNTaFkr7APe7er2QHr55nY");

  //_userLocation = LatLng(23.037531, 72.566551);
  Future<void> _retrieveNearbyRestaurants(LatLng _userLocation) async {
    PlacesSearchResponse _response = await places.searchNearbyWithRadius(
        Location(lat: _userLocation.latitude, lng: _userLocation.longitude),
        10000,
        keyword: "EVChargingStations",
        type: "EVChargingStations");
//type: "restaurant"
    debugPrint('Result : ${_response.results.length}');
    Set<Marker> _restaurantMarkers = _response.results
        .map(
          (result) => Marker(
            markerId: MarkerId(result.name),
            // Use an icon with different colors to differentiate between current location
            // and the restaurants
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
              title: result.name,
              snippet: "Ratings: " + (result.rating?.toString() ?? "Not Rated"),

            ),
            position: LatLng(
                result.geometry!.location.lat, result.geometry!.location.lng),
          ),
        )
        .toSet();

    setState(() {
      _markers.addAll(_restaurantMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('NearBy EV Charing Station'),
        backgroundColor: Color(0XFF2CBDC5),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _currentLocation,
            builder: (context, snapshot) {
              /*   return GoogleMap(
                markers: _markers,
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            }, */
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // The user location returned from the snapshot
                  Position snapshotData = snapshot.data as Position;
                  LatLng _userLocations =
                      LatLng(snapshotData.latitude, snapshotData.longitude);

                  /*    if (_markers.isNotEmpty) {
                    _retrieveNearbyRestaurants(_userLocation);
                  }*/
                  _retrieveNearbyRestaurants(_userLocations);
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _userLocations,
                      zoom: 13,
                    ),
                    onMapCreated: _onMapCreated,

                    markers: _markers
                      ..add(
                        Marker(
                          markerId: MarkerId("User Location"),
                          infoWindow: InfoWindow(title: "User Location"),
                          position: _userLocations,
                        ),
                      ),
                  );
                } else {
                  return Center(child: const Text("Failed to get user location."));
                }
              }
              // While the connection is not in the done state yet
              return Center(child: const CircularProgressIndicator());
            },
          ),
          /* GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _userLocation,
              //target: _center,
              zoom: 12,
            ),
            //mapType: MapType.satellite,
            onMapCreated: _onMapCreated,
            markers: _markers
              ..add(
                Marker(
                  markerId: const MarkerId("User Location"),
                  infoWindow: const InfoWindow(title: "User Location"),
                  position: _userLocation,
                ),
              ),
          ),*/
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                onPressed: () {
                  getLocation();
                },
                //onPressed: () => _handlePressButton(),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Color(0XFF2CBDC5),
                child: const Icon(Icons.map, size: 36.0),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: _handlePressButton,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.cyan),
          child: const Icon(
            Icons.search,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
