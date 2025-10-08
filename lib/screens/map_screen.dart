import 'package:car_convoy_app/widgets/maps/recenter_button_widget.dart';
import 'package:car_convoy_app/widgets/maps/searchable_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geo;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;
  bool _isMapReady = false;
  bool _showRecenterButton = false;
  geo.Position? _userPosition;

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      // TODO: Implement your map search/geocoding logic here
      print('Search Query Submitted: $query');

      // Optional: Hide the keyboard after submission
      FocusScope.of(context).unfocus();
    }
  }

  /// Recenter the camera on the user's last known location.
  void _recenterCamera() {
    if (_userPosition == null || mapboxMap == null) return;

    // Animate the camera to the user's position.
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            _userPosition!.longitude,
            _userPosition!.latitude,
          ),
        ),
        zoom: 15.0, // A closer zoom level for recentering.
        bearing: 0,
        pitch: 0,
      ),
      MapAnimationOptions(
        duration: 1000,
      ), // 2-second animation for a smooth transition.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The MapWidget is wrapped in an Opacity widget to prevent a flicker on load.
          Opacity(
            opacity: _isMapReady ? 1.0 : 0.0,
            child: MapWidget(
              cameraOptions: CameraOptions(
                // Default center, will be updated to user's location.
                center: Point(coordinates: Position(5.291266, 52.132633)),
                zoom: 4,
                bearing: 0,
                pitch: 0,
              ),
              onMapCreated: (MapboxMap map) {
                mapboxMap = map;
                _setupMap();
              },
              // This listener is called whenever the camera position changes.
              onCameraChangeListener: (CameraChangedEventData data) async {
                if (_userPosition == null || !_isMapReady || mapboxMap == null)
                  return;

                // Access the camera state directly from the mapboxMap property.
                final cameraState = await mapboxMap!.getCameraState();

                // Calculate the distance between the map's center and the user's location.
                final distance = geo.Geolocator.distanceBetween(
                  _userPosition!.latitude,
                  _userPosition!.longitude,
                  cameraState.center.coordinates.lat.toDouble(),
                  cameraState.center.coordinates.lng.toDouble(),
                );

                // A threshold in meters to decide when to show the button.
                const double RECENTER_THRESHOLD_METERS = 50.0;

                // Update the button's visibility based on the distance.
                final shouldShow = distance > RECENTER_THRESHOLD_METERS;
                if (shouldShow != _showRecenterButton) {
                  setState(() {
                    _showRecenterButton = shouldShow;
                  });
                }
              },
            ),
          ),
          // A simple loading indicator until the map is ready.
          if (!_isMapReady) const Center(child: CircularProgressIndicator()),

          // The Recenter Button is now its own widget.
          RecenterButton(
            isVisible: _showRecenterButton,
            onPressed: _recenterCamera,
          ),

          Positioned(
            top: 70.0, // Adjust this value to clear the status bar
            left: 10.0,
            right: 10.0,
            child: CustomSearchBar(
              onSubmitted: _onSearchSubmitted, // Pass the handler
              buttons: [
                {
                  'text': 'Home',
                  'icon': Icons.home_outlined,
                  'onPressed': () {},
                },
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Initializes map settings and requests user location.
  void _setupMap() async {
    // Hide default map UI elements for a cleaner look.
    await mapboxMap?.logo.updateSettings(LogoSettings(enabled: false));
    await mapboxMap?.attribution.updateSettings(
      AttributionSettings(enabled: false),
    );
    await mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    // Request location permission from the user.
    var status = await Permission.location.request();

    if (status.isGranted) {
      // Enable the location puck to show the user's current position.
      await mapboxMap?.location.updateSettings(
        LocationComponentSettings(enabled: true, pulsingEnabled: true),
      );

      // Get the current location and zoom to it.
      try {
        geo.Position position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high,
        );

        // Store the user's position to use for recentering.
        _userPosition = position;

        // Animate the camera to the user's initial location.
        await mapboxMap?.flyTo(
          CameraOptions(
            center: Point(
              coordinates: Position(position.longitude, position.latitude),
            ),
            zoom: 15.0, // Adjust zoom level as needed.
          ),
          MapAnimationOptions(duration: 2000), // 2-second animation.
        );
      } catch (e) {
        // Handle any errors while getting the location.
        print('Error getting location: $e');
      }
    } else {
      print('Location permission denied');
    }

    // Once setup is complete, make the map visible.
    if (mounted) {
      setState(() {
        _isMapReady = true;
      });
    }
  }
}
