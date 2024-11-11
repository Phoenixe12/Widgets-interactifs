import 'dart:ffi';

import 'package:flutter/material.dart';

class CarSelectorPage extends StatefulWidget {
  const CarSelectorPage({super.key});

  @override
  State<CarSelectorPage> createState() => _CarSelectorPageState();
}

class _CarSelectorPageState extends State<CarSelectorPage> {
  String _result = "";
  String _firstname = "";
  double _kms = 0;
  bool _electrique = true;
  final List<int> _places = [2, 4, 5, 7];
  int _placesSelected = 2;
  final Map<String, bool> _options = {
    "GPS": false,
    "Caméra de recul": false,
    "Clim par zone": false,
    "Régulateur de vitesse": false,
    "Toit ouvrant": false,
    "Sièges chauffants": false,
    "Roue de secours": false,
    "Jantes alu": false,
  };

  Car? _carSelected;

  final List<Car> _cars = [

    Car(name: "MG cvberster", image: "MG", places: 2, isElectrique: true),
    Car(name: "R5 électrique", image: "R5", places: 4, isElectrique: true),
    Car(name: "van VW", image: "Van", places: 5, isElectrique: true),
    Car(name: "Tesla", image: "tesla", places: 7, isElectrique: true),
    Car(name: "Alpine", image: "Alpine", places: 2, isElectrique: false),
    Car(name: "Fiat", image: "Fiat 500", places: 4, isElectrique: false),
    Car(name:  "Peugeot 3008", image: "P3008", places: 5, isElectrique: false),
    Car(name: "Dacia Jogger", image: "Jogger", places: 7, isElectrique: false),

  ];

  String? _image;
  Padding _interactiveWidget(
      {required List<Widget> children, bool isRow = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (isRow)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          if (!isRow)
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }

  void _updateFirstname(String newValue) {
    setState(() {
      _firstname = newValue;
    });
  }

  void _updateKms(double newValue) {
    setState(() {
      _kms = newValue;
    });
  }

  void _updateEngine(bool newValue) {
    setState(() {
      _electrique = newValue;
    });
  }

  void _updatePlaces(int? newValue) {
    setState(() {
      _placesSelected = newValue ?? 2;
    });
  }

  void _updateOptions(Map<String, bool> newOptions) {
    setState(() {
      _options.addAll(newOptions);
    });
  }

  void _handleResult() {
    setState(() {
      _result = isGoodChoise();
      _carSelected = _cars.firstWhere((car) {
        return  car.isElectrique == _electrique && car.places == _placesSelected;

      });
    });
  }

  String isGoodChoise() {
    if (_kms > 15000 && _electrique) {
      return "vous devriez prendre une voiture thermique comptenu de votre nombre de kilomètres annuels";
    } else if (_kms < 15000 && !_electrique) {
      return "vous faites peu de kilomètres, une voiture électrique serait plus adaptée";
    } else {
      return "voici la voiture faites pour vous";
    }
  }

  void electriqueCar(int places) {
    Switch(places) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurateur de voiture"),
        actions: [
          ElevatedButton(
            onPressed:_handleResult , 
          child: const Text("Je valide"))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Bonjour $_firstname",
              style: const TextStyle(color: Colors.blue, fontSize: 20),
            ),
            Card(
              margin: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(_result),
                    (_carSelected == null)
                        ? const SizedBox(
                            height: 0,
                          )
                        : Image.asset(_carSelected!.urlString, fit: BoxFit.contain),
                        Text(_carSelected?.name ?? "Oui Oui mobile"), 
                  ],
                ),
              ),
            ),
            _interactiveWidget(children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Nom au complet",
                  hintText: "Entrez votre prénom",
                ),
                onSubmitted: (newValue) {
                  _updateFirstname(newValue);
                },
              ),
            ], isRow: false),
            _interactiveWidget(children: [
              Text("Nombre de kilomètres annuels : ${_kms.toInt()}"),
              Slider(
                value: _kms,
                onChanged: (newValue) {
                  _updateKms(newValue);
                },
                min: 0,
                max: 25000,
                divisions: 100,
                label: _kms.round().toString(),
              ),
            ]),
            _interactiveWidget(children: [
              Text(_electrique ? "Moteur électrique" : "Moteur thermique"),
              Switch(
                value: _electrique,
                onChanged: (newValue) {
                  _updateEngine(newValue);
                },
              ),
            ], isRow: true),
            _interactiveWidget(children: [
              Text("Nombre de places : $_placesSelected"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: _places.map((place) {
                  return Column(
                    children: [
                      Radio(
                        value: place,
                        groupValue: _placesSelected,
                        onChanged: (newValue) {
                          _updatePlaces(newValue);
                        },
                      )
                    ],
                  );
                }).toList(),
              )
            ], isRow: false),
            _interactiveWidget(
              children: _options.keys.map((keys) {
                return CheckboxListTile(
                  title: Text(keys),
                  value: _options[keys],
                  onChanged: (newValue) {
                    setState(() {
                      _options[keys] = newValue!;
                    });
                  },
                );
              }).toList(),
              isRow: false,
            ),
          ],
        ),
      ),
    );
  }
}

class Car {
  String name;
  String image;
  int places;
  bool isElectrique;

  Car(
      {required this.name,
      required this.image,
      required this.places,
      required this.isElectrique});

      String get urlString => "assets/$image.jpg";
}
