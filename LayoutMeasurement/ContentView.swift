//
//  ContentView.swift
//  LayoutMeasurement
//
//  Created by Chris Eidhof on 09.08.22.
//

import SwiftUI

extension View {
    func logSizes(_ label: String) -> some View {
        LogSizes(label: label) { self }
    }
}

extension CGFloat {
    var pretty: String {
        String(format: "%.2f", self)
    }
}

extension CGSize {
    var pretty: String {
        "\(width.pretty)⨉\(height.pretty)"
    }
}

extension Optional where Wrapped == CGFloat {
    var pretty: String {
        self?.pretty ?? "nil"
    }
}

extension ProposedViewSize {
    var pretty: String {
        "\(width.pretty)⨉\(height.pretty)"
    }
}

struct LogSizes: Layout {
    var label: String
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        assert(subviews.count == 1)
        print("Propose \(label): \(proposal.pretty)")
        let result = subviews[0].sizeThatFits(proposal)
        print("Report \(label): \(result.pretty)")
        return result
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews[0].place(at: bounds.origin, proposal: proposal)
    }
}

struct ContentView: View {
    @State var proposedSize: CGSize = CGSize(width: 100, height: 100)
    var body: some View {
        VStack {
            Text("Hello, world!")
                .font(.title)
                .logSizes("Text")
                .padding(10)
                .logSizes("Padding")
                .background {
                    Color.orange
                        .frame(width: 200, height: 200)
                        .logSizes("Orange")
                }
                .logSizes("Background")
                .border(Color.red)
                .frame(width: proposedSize.width, height: proposedSize.height)
                .border(Color.green)
            Slider(value: $proposedSize.width, in: 0...300, label: { Text("Width")})
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
