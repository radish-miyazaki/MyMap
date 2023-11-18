import SwiftUI
import MapKit

enum MapType {
    case standard
    case satellite
    case hybrid
}

struct MapView: View {
    let searchKey: String
    let mapType: MapType

    @State private var targetCoordinate = CLLocationCoordinate2D()
    @State private var cameraPosition: MapCameraPosition = .automatic

    var mapStyle: MapStyle {
        switch mapType {
        case .standard:
            return MapStyle.standard()
        case .satellite:
            return MapStyle.imagery()
        case .hybrid:
            return MapStyle.hybrid()
        }
    }

    var body: some View {
        Map(position: $cameraPosition) {
            Marker(searchKey, coordinate: targetCoordinate)
        }
        .mapStyle(mapStyle)
        .onChange(of: searchKey, initial: true) { oldValue, newValue in
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = newValue

            let search = MKLocalSearch(request: request)

            search.start { response, error in
                if let mapItems = response?.mapItems,
                   let mapItem = mapItems.first {
                    targetCoordinate = mapItem.placemark.coordinate

                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: targetCoordinate,
                            latitudinalMeters: 500.0,
                            longitudinalMeters: 500.0
                        )
                    )
                }
            }
        }
    }
}

#Preview {
    MapView(searchKey: "東京駅", mapType: .standard)
}
