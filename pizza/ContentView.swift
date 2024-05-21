import SwiftUI

struct Pizza {
    var size: PizzaSize = .medium
    var toppings: [Topping] = []
}

enum PizzaSize: CGFloat, CaseIterable {
    case small = 200
    case medium = 300
    case large = 370 
}

struct Topping: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct ContentView: View {
    @State private var pizza = Pizza()
    @State private var showSplash = true
    
    let toppings: [Topping] = [
        Topping(name: "Tomato", imageName: "tomato3"),
        Topping(name: "Onion", imageName: "onion"),
        Topping(name: "Capsicum", imageName: "capsicum"),
        Topping(name: "Mushroom", imageName: "cheese"),
        Topping(name: "Corn", imageName: "corn"),
        Topping(name: "Mushroom1", imageName: "mushroom")
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                // Splash screen
                if showSplash {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showSplash = false
                                }
                            }
                        }
                } else {
                    // Main content
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Image(systemName: "flame.fill")
                                .foregroundColor(.red)
                                .font(.largeTitle)
                                .padding(.trailing, 20) // Adjusted padding
                            Text("PizzaArena")
                                .font(Font.custom("Avenir-Black", size: 40)) // Dope font for PizzaArena
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .offset(x: -25) // Adjusted position
                            Spacer()
                        }
                        .padding(.horizontal, 20) // Adjusted padding
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                pizza.size = .small
                            }) {
                                Text("Small")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                pizza.size = .medium
                            }) {
                                Text("Medium")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                pizza.size = .large
                            }) {
                                Text("Large")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20) // Adjusted padding
                        
                        Spacer()
                        
                        PizzaView(pizza: $pizza, toppings: toppings)
                            .padding()
                            .aspectRatio(contentMode: .fit) // Ensure pizza fits in the screen
                            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 20) // Adjusted padding here
                            .animation(.spring()) // Added animation for pizza
                        
                        Spacer()
                        
                        ScrollView(.horizontal, showsIndicators: false) { // Disable horizontal indicator
                            HStack(spacing: 20) {
                                ForEach(toppings) { topping in
                                    Button(action: {
                                        toggleTopping(topping)
                                    }) {
                                        VStack {
                                            ToppingButton(topping: topping, isSelected: pizza.toppings.contains { $0.id == topping.id })
                                                .padding(5) // Adjusted padding here
                                            Text(topping.name) // Added text indicating topping
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        }
                                        .frame(width: 90) // Adjusted width of button
                                    }
                                    .frame(height: 120) // Adjusted height of button
                                }
                            }
                            .padding(.horizontal, 20) // Adjusted padding here
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
        }
    }
    
    func toggleTopping(_ topping: Topping) {
        if let index = pizza.toppings.firstIndex(where: { $0.id == topping.id }) {
            pizza.toppings.remove(at: index)
        } else {
            pizza.toppings.append(topping)
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.red
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image("splashb")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .scaleEffect(1.5)
                    .animation(.spring())
                Spacer()
            }
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        Image("back3")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

struct PizzaView: View {
    @Binding var pizza: Pizza
    let toppings: [Topping]
    
    var body: some View {
        ZStack {
            Image("pizza1") // Placeholder for pizza crust image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: pizza.size.rawValue, height: pizza.size.rawValue)
                .padding()
                .offset(y: pizza.size == .large ? -20 : 0) // Offset for large pizza
                .scaleEffect(pizza.size == .large ? 1.1 : 1.0) // Increased scale for large pizza
            
            ForEach(pizza.toppings) { topping in
                ToppingImage(imageName: topping.imageName)
                    .frame(width: pizza.size.rawValue * 0.8, height: pizza.size.rawValue * 0.8) // Adjusted size of toppings
                    .position(x: pizza.size.rawValue / 2 + 20, y: pizza.size.rawValue / 2 - 10) // Adjusted position of toppings
                    .transition(.scale)
                    .animation(.spring()) // Added animation
            }
        }
        .padding()
    }
}

struct ToppingImage: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct ToppingButton: View {
    let topping: Topping
    let isSelected: Bool
    
    var body: some View {
        Image(topping.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(color: isSelected ? .yellow : .clear, radius: 5) // Added shadow for selection effect
            .scaleEffect(isSelected ? 1.2 : 1.0) // Added scale effect for selection
            .animation(.spring()) // Added animation
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

