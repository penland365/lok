import Foundation

final class Geolocate {

  let networks = NSMutableArray()

  init(networks: [Network]) {
    for network in networks {
      self.networks.add(network.asDictionary())
    }
  }

  func asDictionary() -> [String : Any] {
    return [
      "considerIp" : true,
      "wifiAccessPoints" : networks
    ]
  }
}
