//
//  ContentView.swift
//  Shared
//
//  Created by Eduardo Shinkawa on 09/08/22.
//

import SwiftUI

struct Welcome: Decodable {
    let results: [Result]
}

// MARK: - Result
struct Result: Decodable {
    let id: Int
    let name: String
    let type: String
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct ContentView: View {
    @State private var characters = [Result]()
    
    var body: some View {
        NavigationView {
            List(characters, id: \.id) { character in
                    ZStack {
                        HStack(alignment: .center) {
                            
                            AsyncImage(url: URL(string: character.image),
                                       content: { image in
                                           image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                                .frame(maxWidth: 80, maxHeight: 80)
                                                .clipShape(RoundedRectangle(cornerRadius:10, style: .continuous))
                                       },
                                       placeholder: {
                                           ProgressView()
                                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                       })
                            VStack(alignment: .leading) {
                                Text(character.name)
                                    .font(.system(size: 18, weight: .bold))
                                Text(character.type.isEmpty ? "type not available" : character.type)
                            }
                            Spacer()
                            Image(systemName: "heart.fill")
                                .renderingMode(.original)
                    }
                }
            }
        }
        .task {
            await getCharacters()
        }
    }
    
    func getCharacters() async {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            print("something is wrong")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            let result = try? JSONDecoder().decode(Welcome.self, from: data)
            if let result = result {
                characters = result.results
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
