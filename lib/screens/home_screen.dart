import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart' show rootBundle;

import '../models/vpn_config.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initial VPN state set to disconnected
  String _vpnState = VpnEngine.vpnDisconnected;

  // List to store VPN configurations
  final List<VpnConfig> _listVpn = [];

  // Currently selected VPN configuration
  VpnConfig? _selectedVpn;

  @override
  void initState() {
    super.initState();

    // Add listener to update VPN state
    VpnEngine.vpnStageSnapshot().listen((event) {
      setState(() => _vpnState = event);
    });

    initVpn();
  }

  void initVpn() async {
    //sample vpn config file (you can get more from https://www.vpngate.net/)
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString(
            'assets/vpn/vpngate_public-vpn-39.opengw.net_tcp_443.ovpn'),
        country: 'Japan',
        username: 'vpn',
        password: 'vpn'));

    // _listVpn.add(VpnConfig(
    //     config: await rootBundle.loadString('assets/vpn/thailand.ovpn'),
    //     country: 'Thailand',
    //     username: 'vpn',
    //     password: 'vpn'));

    SchedulerBinding.instance.addPostFrameCallback(
        (t) => setState(() => _selectedVpn = _listVpn.first));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OpenVPN Demo')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          physics: BouncingScrollPhysics(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: _connectClick,
                    child: Text(
                      _vpnState == VpnEngine.vpnDisconnected
                          ? 'Connect VPN'
                          : _vpnState.replaceAll("_", " ").toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                StreamBuilder<VpnStatus?>(
                  initialData: VpnStatus(),
                  stream: VpnEngine.vpnStatusSnapshot(),
                  builder: (context, snapshot) => Text(
                      "${snapshot.data?.byteIn ?? ""}, ${snapshot.data?.byteOut ?? ""}",
                      textAlign: TextAlign.center),
                ),

                //sample vpn list
                Column(
                    children: _listVpn
                        .map(
                          (e) => ListTile(
                            title: Text(e.country),
                            leading: SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                  child: _selectedVpn == e
                                      ? CircleAvatar(
                                          backgroundColor: Colors.green)
                                      : CircleAvatar(
                                          backgroundColor: Colors.grey)),
                            ),
                            onTap: () {
                              log("${e.country} is selected");
                              setState(() => _selectedVpn = e);
                            },
                          ),
                        )
                        .toList())
              ]),
        ),
      ),
    );
  }

  void _connectClick() {
    ///Stop right here if user not select a vpn
    if (_selectedVpn == null) return;

    if (_vpnState == VpnEngine.vpnDisconnected) {
      ///Start if stage is disconnected
      VpnEngine.startVpn(_selectedVpn!);
    } else {
      ///Stop if stage is "not" disconnected
      VpnEngine.stopVpn();
    }
  }
}