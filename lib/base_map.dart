import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class BaseMapPage extends StatefulWidget {
  @override
  _BaseMapPageState createState() => _BaseMapPageState();
}

class _BaseMapPageState extends State<BaseMapPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();

  MapType _mapType = MapType.Basic;
  LocationTrackingMode _trackingMode = LocationTrackingMode.NoFollow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          NaverMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.566570, 126.978442),
              zoom: 17,
            ),
            onMapCreated: onMapCreated,
            mapType: _mapType,
            initLocationTrackingMode: _trackingMode,
            locationButtonEnable: true,
            indoorEnable: true,
            onCameraIdle: _onCameraIdle,
            onMapTap: _onMapTap,
            onMapLongTap: _onMapLongTap,
            onMapDoubleTap: _onMapDoubleTap,
            onMapTwoFingerTap: _onMapTwoFingerTap,
            maxZoom: 17,
            minZoom: 15,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: _mapTypeSelector(),
          ),
          _trackingModeSelector(),
        ],
      ),
    );
  }

  _onMapTap(LatLng position) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
      Text('[onTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onMapLongTap(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onLongTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onMapDoubleTap(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onDoubleTap] lat: ${position.latitude}, lon: ${position
              .longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onMapTwoFingerTap(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onTwoFingerTap] lat: ${position.latitude}, lon: ${position
              .longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onSymbolTap(LatLng position, String caption) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onSymbolTap] caption: $caption, lat: ${position
              .latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _mapTypeSelector() {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView.separated(
        itemCount: MapType.values.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (_, index) {
          final type = MapType.values[index];
          String title;
          switch (type) {
            case MapType.Basic:
              title = '??????';
              break;
            case MapType.Navi:
              title = '??????';
              break;
            case MapType.Satellite:
              title = '??????';
              break;
            case MapType.Hybrid:
              title = '????????????';
              break;
            case MapType.Terrain:
              title = '?????????';
              break;
          }

          return GestureDetector(
            onTap: () => _onTapTypeSelector(type),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)]),
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }

  _trackingModeSelector() {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: _onTapTakeSnapShot,
        child: Container(
          margin: EdgeInsets.only(right: 16, bottom: 48),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                )
              ]),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.photo_camera,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ?????? ?????? ?????????
  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  /// ?????? ?????? ?????????
  void _onTapTypeSelector(MapType type) async {
    if (_mapType != type) {
      setState(() {
        _mapType = type;
      });
    }
  }

  /// my location button
  // void _onTapLocation() async {
  //   final controller = await _controller.future;
  //   controller.setLocationTrackingMode(LocationTrackingMode.Follow);
  // }

  void _onCameraChange(LatLng latLng, CameraChangeReason reason,
      bool isAnimated) {
    print('????????? ????????? >>> ?????? : ${latLng.latitude}, ${latLng.longitude}'
        '\n??????: $reason'
        '\n??????????????? ??????: $isAnimated');
  }

  void _onCameraIdle() {
    print('????????? ????????? ??????');
  }

  /// ?????? ?????????
  void _onTapTakeSnapShot() async {
    final controller = await _controller.future;
    controller.takeSnapshot((path) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: path != null
                  ? Image.file(
                File(path),
              )
                  : Text('path is null!'),
              titlePadding: EdgeInsets.zero,
            );
          });
    });
  }
}