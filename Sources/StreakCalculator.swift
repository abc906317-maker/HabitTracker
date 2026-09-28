import Foundation

/// Pure logic, no SwiftData dependency, so it is trivial to test.
enum StreakCalculator {

    /// Consecutive completed days ending today.
    /// If today isn't done yet, the streak is still alive as long as
    /// yesterday was completed (user hasn't "missed" yet).
    static func currentStreak(
        completedDates: [Date],
        today: Date = .now,
        calendar: Calendar = .current
    ) -> Int {
        let days = Set(completedDates.map { calendar.startOfDay(for: $0) })
        let todayStart = calendar.startOfDay(for: today)

        var cursor = days.contains(todayStart)
            ? todayStart
            : calendar.date(byAdding: .day, value: -1, to: todayStart)!

        var streak = 0
        while days.contains(cursor) {
            streak += 1
            cursor = calendar.date(byAdding: .day, value: -1, to: cursor)!
        }
        return streak
    }
}
