//
//  ContentView.swift
//  SnowfallAnimation
//
//  Created by Pavankumar Arepu on 13/07/23.
//

import SwiftUI

struct ContentView: View {
    @State private var snowflakes: [Snowflake] = []
    let snowflakeSize: CGFloat = 20

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                ForEach(snowflakes) { snowflake in
                    Image(systemName: "snow")
                        .resizable()
                        .frame(width: snowflakeSize, height: snowflakeSize)
                        .foregroundColor(.white)
                        .position(x: snowflake.x, y: snowflake.y)
                }
            }
            .onAppear {
                addInitialSnowflakes(size: geometry.size)
                startSnowfall()
            }
        }
    }

    func addInitialSnowflakes(size: CGSize) {
        let numberOfSnowflakes = 100
        for _ in 0..<numberOfSnowflakes {
            let randomX = CGFloat.random(in: 0...size.width)
            let randomY = CGFloat.random(in: 0...size.height)
            snowflakes.append(Snowflake(x: randomX, y: randomY))
        }
    }

    func startSnowfall() {
        let coordinator = Coordinator(snowflakes: $snowflakes, size: UIScreen.main.bounds.size, snowflakeSize: snowflakeSize)
        coordinator.startSnowfall()
    }
}

struct Snowflake: Identifiable {
    var id = UUID()
    var x: CGFloat
    var y: CGFloat
}

class Coordinator {
    private var displayLink: CADisplayLink?
    @Binding var snowflakes: [Snowflake]
    let size: CGSize
    let snowflakeSize: CGFloat

    init(snowflakes: Binding<[Snowflake]>, size: CGSize, snowflakeSize: CGFloat) {
        _snowflakes = snowflakes
        self.size = size
        self.snowflakeSize = snowflakeSize
    }

    func startSnowfall() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc private func update() {
        updateSnowflakesPosition()
    }

    private func updateSnowflakesPosition() {
        snowflakes.indices.forEach { index in
            var snowflake = snowflakes[index]
            
            let speed: CGFloat = 5
            let wind: CGFloat = CGFloat.random(in: -0.5...0.5)
            
            let deltaY = speed
            let deltaX = wind * deltaY
            
            snowflake.x += deltaX
            snowflake.y += deltaY
            
            let maxX = size.width + snowflakeSize / 2
            if snowflake.x > maxX {
                snowflake.x = -snowflakeSize / 2
            }
            
            let maxY = size.height + snowflakeSize / 2
            if snowflake.y > maxY {
                snowflake.y = -snowflakeSize / 2
            }
            
            snowflakes[index] = snowflake
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
