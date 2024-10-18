import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var parks: [Park] = []
    
    var body: some View {
        NavigationStack { // Wrap the top-level view in a NavigationStack
            ScrollView {
                LazyVStack {
                    ForEach(parks) { park in
                        NavigationLink(value: park) { // Add NavigationLink for each park
                            ParkRow(park: park)
                        }
                    }
                }
            }
            .onAppear(perform: {
                Task {
                    await fetchParks()
                }
            })
            .navigationDestination(for: Park.self) { park in // Define the navigation destination
                ParkDetailView(park: park) // ParkDetailView will be shown on navigation
            }
            .navigationTitle("National Parks")
        }
    }

    private func fetchParks() async {
        // URL for the API endpoint (replace with your API key)
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=ca&api_key=z1jy9jjf0iq8JyIdSTNTl4B74fhPo7c0uDAD9XfT")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)
            self.parks = parksResponse.data
        } catch {
            print(error.localizedDescription)
        }
    }
}
struct ParkRow: View {
    let park: Park

    var body: some View {
        
        // Park row
        Rectangle()
            .aspectRatio(4/3, contentMode: .fit)
            .overlay {
            
                let image = park.images.first
                let urlString = image?.url
                let url = urlString.flatMap { string in
                    URL(string: string)
                }
                
            
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.systemGray4)
                }
            }
            .overlay(alignment: .bottomLeading) {
                Text(park.name)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
            }
            .cornerRadius(16)
            .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
