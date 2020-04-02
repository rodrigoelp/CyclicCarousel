import SwiftUI

struct ContentView: View {
    var body: some View {
        CarouselView {
            [
                Group { Text("testing 0") }
                    .frame(width: 300, height: 500)
                    .background(Color.purple),
                Group { Text("testing 1") }
                    .frame(width: 300, height: 500)
                    .background(Color.blue),
                Group { Text("testing 2") }
                    .frame(width: 300, height: 500)
                    .background(Color.green),
                Group { Text("testing 3") }
                    .frame(width: 300, height: 500)
                    .background(Color.orange),
                Group { Text("testing 4") }
                    .frame(width: 300, height: 500)
                    .background(Color.yellow),
                Group { Text("testing 5") }
                    .frame(width: 300, height: 500)
                    .background(Color.red),
                Group { Text("testing 6") }
                    .frame(width: 300, height: 500)
                    .background(Color.purple)
            ]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
