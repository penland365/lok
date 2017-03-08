import CoreWLAN
import Foundation

final class Scanner {

  var networks: [Network] = []

  init() {
    networks = scan()
  }

  func scan() -> [Network] {
    let interface = CWWiFiClient.shared().interface()
    var networks: Set<CWNetwork> = []
    var xs: [Network] = []
    do {
      networks = try interface?.scanForNetworks(withName: nil) ?? []
      xs = networks.map { Network.fromCWNetwork(network: $0) }
    } catch {}

    return xs
  }

  
}
