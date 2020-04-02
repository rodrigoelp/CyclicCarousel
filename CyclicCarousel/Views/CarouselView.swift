import SwiftUI
/**
 Carousel host or view, rendering whatever card provided as content.
 */
struct CarouselView<Content>: View where Content: View {
    private let content: () -> [Content]
    private let views: [Content]
    private let cardSize: CGSize
    private let unfocusedPageHeight: CGFloat = 0.8
    private let padding: CGFloat

    @GestureState private var dragState = DragState.inactive
    @State private var indexWindow = CarouselIndexWindow(indexes: [0], activeIndex: 0)

    /**
     Initializes a carousel which takes every view listed and organizes it in a circular ring
     the user can swipe between eachother.

     - Parameter spacing: Spacing between elements.
     - Parameter cardSize: Size given to the card frame once is layed out on screen.
     - Parameter content: Content builder used to generate a list of views to enumerate and display at any given point in time. Content will be evaluated at initialization
     */
    @inlinable init(spacing padding: CGFloat = 20,
                    cardSize: CGSize = .init(width: 300, height: 500),
                    @ViewBuilder content: @escaping () -> [Content]) {
        let views = content()
        self.views = views
        self.content = content
        self.padding = padding
        self.cardSize = cardSize
    }

    var body: some View {
        ZStack {
            ForEach(0..<views.count) { index in
                VStack {
                    Spacer()
                    self.views[index]
                        .frame(width: self.cardSize.width, height: self.elementHeight(index)) // TODO: read the element size using GeometryReader
                        .animation(.interpolatingSpring(stiffness: 200, damping: 20, initialVelocity: 10))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    Spacer()
                }
                .offset(x: self.elementLateralOffset(index))
                .animation(.interpolatingSpring(stiffness: 200, damping: 15))
                .opacity(self.elementOpacity(index))
                .animation(.interpolatingSpring(stiffness: 200, damping: 20, initialVelocity: 10))
            }
            VStack {
                Spacer()
                Text("\(indexWindow.leftMost) \(indexWindow.left) \(indexWindow.active) \(indexWindow.right) \(indexWindow.rightMost)")
            }
        }.gesture(
            DragGesture()
                .updating(self.$dragState) { drag, state, trans in
                    state = .active(translation: drag.translation)
            }.onEnded(self.dragEnded)
        ).onAppear(perform: {
            self.loadCards()
        })
    }

    private func loadCards() {
        let indexes: [Int] = (0..<views.count).map { $0 }
        let initialState = CarouselIndexWindow(indexes: indexes,
                                               activeIndex: 0)
        indexWindow = initialState
    }

    private func dragEnded(value: DragGesture.Value) {
        let halfway = cardSize.width * 0.51
        var newIndex = indexWindow.active
        if value.predictedEndTranslation.width > halfway
            || value.translation.width > halfway {
            newIndex = (newIndex - 1) % views.count
            if newIndex < 0 {
                newIndex = (views.count - 1)
            }
        } else if value.predictedEndTranslation.width < -halfway
            || value.translation.width < -halfway {
            newIndex = abs(newIndex + 1) % views.count
        }

        indexWindow = indexWindow.update(activeIndex: newIndex)
    }

    private func elementHeight(_ index: Int) -> CGFloat {
        index == indexWindow.active ? cardSize.height : cardSize.height * unfocusedPageHeight
    }

    private func elementOpacity(_ index: Int) -> Double {
        if index == indexWindow.active { return 1 }
        if [ indexWindow.leftMost,
             indexWindow.left,
             indexWindow.right,
             indexWindow.rightMost
            ].contains(index) {
            return 0.75
        }
        return 0
    }

    private func elementLateralOffset(_ index: Int) -> CGFloat {
        if index == indexWindow.active { return dragState.translation.width }
        if index == indexWindow.left { return dragState.translation.width - (cardSize.width + padding) }
        if index == indexWindow.leftMost { return dragState.translation.width - 2*(cardSize.width + padding) }
        if index == indexWindow.right { return dragState.translation.width + cardSize.width + padding }
        if index == indexWindow.rightMost { return dragState.translation.width +  2 * (cardSize.width + padding) }
        return 4 * cardSize.width
    }
}

private enum DragState {
    case inactive
    case active(translation: CGSize)

    var isDragging: Bool {
        if case .active = self { return true }
        return false
    }

    var translation: CGSize {
        if case let .active(translation) = self {
            return translation
        }
        return .zero
    }
}

private struct CarouselIndexWindow {
    let leftMost: Int
    let left: Int
    let active: Int
    let right: Int
    let rightMost: Int

    private let indexes: [Int]

    init(indexes: [Int], activeIndex: Int = 0) {
        active = activeIndex
        left = Helper.getLeft(from: active, on: indexes)
        leftMost = Helper.getLeft(from: left, on: indexes)
        right = Helper.getRight(from: active, on: indexes)
        rightMost = Helper.getRight(from: right, on: indexes)
        self.indexes = indexes
    }

    func update(activeIndex: Int) -> CarouselIndexWindow {
        return .init(indexes: indexes, activeIndex: activeIndex)
    }
}

private enum Helper {
    static func getLeft(from index: Int, on indexes: [Int]) -> Int {
        guard indexes.count != 1 else { return index }
        if index == 0 {
            if let left = indexes.last { return left }
            return index
        } else {
            return indexes[index - 1]
        }
    }

    static func getRight(from index: Int, on indexes: [Int]) -> Int {
        guard indexes.count != 1 else { return index }
        if index == indexes.count - 1 {
            if let right = indexes.first { return right }
            return index
        } else {
            return indexes[index + 1]
        }
    }
}
