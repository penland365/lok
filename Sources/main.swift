import Foundation

let scanner = Scanner()
let geolocate = Geolocate(networks: scanner.networks)

let googleApiKey = ""
let jsonData = try? JSONSerialization.data(withJSONObject: geolocate.asDictionary())
let url = URL(string: "https://www.googleapis.com/geolocation/v1/geolocate?key=\(googleApiKey)")!
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.httpBody = jsonData
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.addValue("application/json", forHTTPHeaderField: "Accept")

let semaphore = DispatchSemaphore(value: 0)
let task = URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {
        print(error?.localizedDescription ?? "No data")
        semaphore.signal()
        return
    }
    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
    if let responseJSON = responseJSON as? [String: Any] {
        if let location = responseJSON["location"] as? [String : Any] {
            let lat      = location["lat"] ?? "NaN"
            let lng      = location["lng"] ?? "NaN"
            let accuracy = responseJSON["accuracy"] ?? "NaN"
          print("\(lat) \(lng) \(accuracy)m")
        }
    }
    semaphore.signal()
}
task.resume()

let _ = semaphore.wait(timeout:  DispatchTime.now() + .seconds(7))
