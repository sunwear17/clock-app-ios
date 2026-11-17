import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.086, green: 0.125, blue: 0.180),
                         Color(red: 0.043, green: 0.055, blue: 0.078)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { context in
                let now = context.date
                VStack(spacing: 36) {
                    AnalogClock(date: now)
                        .frame(width: 300, height: 300)

                    VStack(spacing: 10) {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text(Self.hm(now))
                                .font(.system(size: 58, weight: .semibold, design: .rounded))
                                .monospacedDigit()
                            Text(":" + Self.pad(Self.second(now)))
                                .font(.system(size: 30, weight: .medium, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(Color(red: 0.30, green: 0.64, blue: 1.0))
                        }
                        .foregroundStyle(.white)

                        Text(Self.dateLine(now))
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .tracking(1.2)
                            .foregroundStyle(.white.opacity(0.45))
                    }
                }
            }
        }
    }

    static func pad(_ n: Int) -> String { String(format: "%02d", n) }
    static func hm(_ d: Date) -> String {
        let c = Calendar.current.dateComponents([.hour, .minute], from: d)
        return pad(c.hour ?? 0) + ":" + pad(c.minute ?? 0)
    }
    static func second(_ d: Date) -> Int { Calendar.current.component(.second, from: d) }
    static func dateLine(_ d: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_Hant_HK")
        f.dateFormat = "yyyy年M月d日 · EEEE"
        return f.string(from: d)
    }
}

struct AnalogClock: View {
    let date: Date

    private var parts: (h: Double, m: Double, s: Double) {
        let c = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        let sec = Double(c.second ?? 0) + Double(c.nanosecond ?? 0) / 1_000_000_000
        let min = Double(c.minute ?? 0) + sec / 60
        let hour = Double((c.hour ?? 0) % 12) + min / 60
        return (hour, min, sec)
    }

    var body: some View {
        Canvas { ctx, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 6

            // face
            let face = Path(ellipseIn: CGRect(
                x: center.x - radius, y: center.y - radius,
                width: radius * 2, height: radius * 2))
            ctx.fill(face, with: .color(Color(red: 0.07, green: 0.086, blue: 0.12)))
            ctx.stroke(face, with: .color(Color(red: 0.12, green: 0.153, blue: 0.20)), lineWidth: 1.5)

            // ticks
            for i in 0..<60 {
                let major = i % 5 == 0
                let angle = Double(i) / 60 * 2 * .pi
                let outer = radius - 4
                let inner = radius - (major ? 14 : 8)
                let p1 = CGPoint(x: center.x + sin(angle) * outer, y: center.y - cos(angle) * outer)
                let p2 = CGPoint(x: center.x + sin(angle) * inner, y: center.y - cos(angle) * inner)
                var tick = Path()
                tick.move(to: p1)
                tick.addLine(to: p2)
                ctx.stroke(tick,
                           with: .color(major
                                ? Color(red: 0.42, green: 0.49, blue: 0.59)
                                : Color(red: 0.23, green: 0.27, blue: 0.34)),
                           style: StrokeStyle(lineWidth: major ? 2.2 : 1, lineCap: .round))
            }

            let p = parts

            // hour hand
            drawHand(&ctx, center: center, angle: p.h * 30, length: radius * 0.50,
                     width: 5.5, color: .white, tail: 0)
            // minute hand
            drawHand(&ctx, center: center, angle: p.m * 6, length: radius * 0.72,
                     width: 3.5, color: Color(red: 0.83, green: 0.87, blue: 0.92), tail: 0)
            // second hand
            let accent = Color(red: 0.30, green: 0.64, blue: 1.0)
            drawHand(&ctx, center: center, angle: p.s * 6, length: radius * 0.86,
                     width: 1.6, color: accent, tail: radius * 0.14)

            // hub
            let hubSize: CGFloat = 10
            let hub = Path(ellipseIn: CGRect(x: center.x - hubSize / 2, y: center.y - hubSize / 2,
                                             width: hubSize, height: hubSize))
            ctx.fill(hub, with: .color(Color(red: 0.07, green: 0.086, blue: 0.12)))
            ctx.stroke(hub, with: .color(accent), lineWidth: 2.2)
        }
    }

    private func drawHand(_ ctx: inout GraphicsContext, center: CGPoint, angle: Double,
                          length: CGFloat, width: CGFloat, color: Color, tail: CGFloat) {
        let rad = angle * .pi / 180
        var path = Path()
        path.move(to: CGPoint(x: center.x - sin(rad) * tail, y: center.y + cos(rad) * tail))
        path.addLine(to: CGPoint(x: center.x + sin(rad) * length, y: center.y - cos(rad) * length))
        ctx.stroke(path, with: .color(color),
                   style: StrokeStyle(lineWidth: width, lineCap: .round))
    }
}

#Preview {
    ContentView()
}
