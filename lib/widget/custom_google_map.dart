import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../utils/location_service.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPostion; // Declare initial camera position

  late LocationService locationService; // Declare location service
  @override
  void initState() {
    initialCameraPostion = const CameraPosition(
        zoom: 17, target: LatLng(31.187084851056554, 29.928110526889437)); // Initialize camera position with default location
    locationService = LocationService(); // Initialize location service
    updateMyLocation(); // Update current location
    super.initState();
  }

  GoogleMapController? googleMapController; // Declare GoogleMapController

  Set<Marker> markers = {}; // Declare set of markers
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers, // Set markers on the map
      zoomControlsEnabled: true, // Enable zoom controls
      onMapCreated: (controller) {
        googleMapController = controller; // Initialize GoogleMapController when map is created
      },
      initialCameraPosition: initialCameraPostion, // Set initial camera position
    );
  }

  void updateMyLocation() async {
    await locationService.checkAndRequestLocationService(); // Check and request location services
    var hasPermission =
    await locationService.checkAndRequestLocationPermission(); // Check and request location permissions
    if (hasPermission) {
      locationService.getRealTimeLocationData((locationData) { // Get real-time location data
        setMyLocationMarker(locationData); // Set marker for current location
        setMyCameraPosition(locationData); // Update camera position to current location
      });
    } else {}
  }

  void setMyCameraPosition(LocationData locationData) {

    var camerPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!), // Set camera position to current location
        zoom: 15);

    googleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(camerPosition)); // Animate camera to new position
  }

  void setMyLocationMarker(LocationData locationData) {
    var myLocationMarker = Marker(
        markerId: const MarkerId('my_location_marker'), // Create marker for current location
        position: LatLng(locationData.latitude!, locationData.longitude!));

    markers.add(myLocationMarker); // Add marker to set of markers
    setState(() {}); // Update the UI
  }
}
