import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var displaySearchKey: String = "東京駅"
    @State private var displayMapType: MapType = .standard

    var body: some View {
        VStack {
            TextField("キーワード", text: $inputText, prompt: Text("キーワードを入力してください"))
                .onSubmit {
                    displaySearchKey = inputText
                }
                .padding()

            ZStack(alignment: .bottomTrailing) {
                MapView(searchKey: displaySearchKey, mapType: displayMapType)

                Button {
                    if displayMapType == .standard {
                        displayMapType = .satellite
                    } else if displayMapType == .satellite {
                        displayMapType = .hybrid
                    } else {
                        displayMapType = .standard
                    }
                } label: {
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                        .padding(.trailing, 20.0)
                        .padding(.bottom, 10.0)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
