import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ARKitController? _arkitController;
  ARKitNode? _node;

  void onAddNode() {
    if (_node != null) {
      _arkitController?.remove(_node!.name);
    }
    final node = ARKitNode(
      geometry: ARKitPyramid(
        width: 0.1,
        height: 0.1,
        length: 0.1,
      ),
      position: vector.Vector3(0, 0, -.5),
      eulerAngles: vector.Vector3.zero(),
    );
    _node = node;
    _arkitController?.add(_node!);
    setState(() {});
  }

  void onChangeSize(double newSize) {
    setState(() {
      _node?.scale = vector.Vector3(newSize, newSize, newSize);
    });
  }

  void onChangePosition({double? x, double? y, double? z}) {
    setState(() {
      _node?.position = vector.Vector3(x ?? _node!.position.x,
          y ?? _node!.position.y, z ?? _node!.position.z);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: onAddNode,
          child: const Icon(Icons.add),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: ARKitSceneView(
                onARKitViewCreated: (controller) {
                  _arkitController = controller;
                },
              ),
            ),
            if (_node != null)
              Positioned(
                bottom: 20 + MediaQuery.of(context).padding.bottom,
                left: 20,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  onChangePosition(y: _node!.position.y + 0.1);
                                },
                                icon: const Icon(Icons.keyboard_arrow_up),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                  horizontal: -4,
                                  vertical: -4,
                                ),
                                onPressed: () {
                                  onChangePosition(x: _node!.position.x - 0.1);
                                },
                                icon: const Icon(Icons.chevron_left),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                  horizontal: -4,
                                  vertical: -4,
                                ),
                                onPressed: () {
                                  onChangePosition(x: _node!.position.x + 0.1);
                                },
                                icon: const Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  onChangePosition(y: _node!.position.y - 0.1);
                                },
                                icon: const Icon(Icons.keyboard_arrow_down),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    RotatedBox(
                      quarterTurns: -1,
                      child: Slider(
                        value: _node?.scale.x ?? 1,
                        onChanged: (v) {
                          onChangeSize(v);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    RotatedBox(
                      quarterTurns: -1,
                      child: Slider(
                        min: -1,
                        max: 1,
                        value: _node?.position.z ?? 1,
                        onChanged: (v) {
                          onChangePosition(z: v);
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
