import 'package:location/location.dart';

class LocationService {
  Location location = Location(); // Create a Location instance

  Future<bool> checkAndRequestLocationService() async {
    var isServiceEnabled = await location.serviceEnabled(); // Check if location service is enabled
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService(); // Request to enable location service if not enabled
      if (!isServiceEnabled) {
        return false; // Return false if service could not be enabled
      }
    }

    return true; // Return true if service is enabled
  }

  Future<bool> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission(); // Check location permission status
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false; // Return false if permission is permanently denied
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission(); // Request location permission if denied
      return permissionStatus == PermissionStatus.granted; // Return true if permission is granted
    }

    return true; // Return true if permission is already granted
  }

  void getRealTimeLocationData(void Function(LocationData)? onData) {
    location.onLocationChanged.listen(onData); // Listen for real-time location updates
  }
}
