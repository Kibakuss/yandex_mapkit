import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapWindow? _mapWindow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        onMapCreated: (mapWindow) {
          _mapWindow = mapWindow;
          _mapWindow?.map.move(const CameraPosition(
            Point(latitude: 59.935493, longitude: 30.327392),
            zoom: 13.0,
            azimuth: 0.0,
            tilt: 0.0,
          ));
          // вот это не работает, 'Animation' isn't a function.
          // Try correcting the name to match an existing function, or define a method or function named 'Animation'.
          // _mapWindow?.map.moveWithAnimation(const CameraPosition(
          //   Point(latitude: 59.935493, longitude: 30.327392),
          //   zoom: 13.0,
          //   azimuth: 0.0,
          //   tilt: 0.0,
          // ),Animation());
        },
      ),
    );
  }
}

//ios console output
// a/d4k/Eanplu7/GkOTw3 <warn>: Vendor: 4203
// ha1Ah10RAQWRkyFKxeCu <warn>: Physical device: Apple iOS simulator GPU (285475818)
// 4q53Pg5bnJt4vcIFEvrM <warn>: Depth image format: D32_SFLOAT
// 83XarQEbRzkrSysgbit3 <warn>: Integrated GPU detected
// ualyMnYeh+ZQZe4tBeNt <warn>: Dynamic MSAA: not supported
// JIj5jvHVmC6+ajl6aVTx <warn>: Supported multisampling: 1; 4;
// 6fAydQPpqDDyD5Efa+ON <warn>: Ignore an attempt to render into the viewport with zero dimensions
// 3
// kwpL23U0dFSmJ3sD3wir <warn>: Image with VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT allocated
// cPczFUwLR3AwlAHGB/YS <warn>: Creating frame context circular buffer #0
// cPczFUwLR3AwlAHGB/YS <warn>: Creating frame context circular buffer #1
// cPczFUwLR3AwlAHGB/YS <warn>: Creating frame context circular buffer #2
// 75
// kwpL23U0dFSmJ3sD3wir <warn>: Image with VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT allocated

