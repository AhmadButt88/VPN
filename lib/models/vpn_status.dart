// Model class to represent the status of a VPN connection
class VpnStatus {
  VpnStatus({this.duration, this.lastPacketReceive, this.byteIn, this.byteOut});

  // Duration of the VPN connection
  String? duration;

  // Timestamp of the last packet received
  String? lastPacketReceive;

  // Bytes received
  String? byteIn;

  // Bytes sent
  String? byteOut;

  // Factory constructor to create a VpnStatus instance from a JSON map
  factory VpnStatus.fromJson(Map<String, dynamic> json) => VpnStatus(
        duration: json['duration'],
        lastPacketReceive: json['last_packet_receive'],
        byteIn: json['byte_in'],
        byteOut: json['byte_out'],
      );

  // Method to convert a VpnStatus instance to a JSON map
  Map<String, dynamic> toJson() => {
        'duration': duration,
        'last_packet_receive': lastPacketReceive,
        'byte_in': byteIn,
        'byte_out': byteOut
      };
}
