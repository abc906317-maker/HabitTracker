import Foundation
import SwiftData

@Model
final class Habit {
    var name: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \HabitLog.habit)
    var logs: [HabitLog] = []

    init(name: String, createdAt: Date = .now) {
        self.name = name
        self.createdAt = createdAt
    }

    func isCompleted(on date: Date = .now, calendar: Calendar = .current) -> Bool {
        logs.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }

    var currentStreak: Int {
        StreakCalculator.currentStreak(completedDates: logs.map(\.date))
    }
}

@Model
final class HabitLog {
    /// Always stored as start-of-day so one log = one day.
    var date: Date
    var habit: Habit?

    init(date: Date = .now, habit: Habit? = nil, calendar: Calendar = .current) {
        self.date = calendar.startOfDay(for: date)
        self.habit = habit
    }
}
