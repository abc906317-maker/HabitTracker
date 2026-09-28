import XCTest
@testable import HabitTracker  // change to your app's module name

final class StreakCalculatorTests: XCTestCase {

    private var calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }()

    private let today = ISO8601DateFormatter().date(from: "2026-09-28T10:00:00Z")!

    private func daysAgo(_ n: Int) -> Date {
        calendar.date(byAdding: .day, value: -n, to: today)!
    }

    private func streak(_ dates: [Date]) -> Int {
        StreakCalculator.currentStreak(completedDates: dates, today: today, calendar: calendar)
    }

    func testNoLogsIsZero() {
        XCTAssertEqual(streak([]), 0)
    }

    func testOnlyTodayIsOne() {
        XCTAssertEqual(streak([daysAgo(0)]), 1)
    }

    func testThreeConsecutiveDaysIncludingToday() {
        XCTAssertEqual(streak([daysAgo(0), daysAgo(1), daysAgo(2)]), 3)
    }

    func testStreakAliveIfTodayNotDoneButYesterdayIs() {
        XCTAssertEqual(streak([daysAgo(1), daysAgo(2)]), 2)
    }

    func testGapBreaksStreak() {
        XCTAssertEqual(streak([daysAgo(0), daysAgo(1), daysAgo(3)]), 2)
    }

    func testMissedYesterdayAndTodayIsZero() {
        XCTAssertEqual(streak([daysAgo(2), daysAgo(3)]), 0)
    }

    func testDuplicateLogsSameDayCountOnce() {
        XCTAssertEqual(streak([daysAgo(0), daysAgo(0), daysAgo(1)]), 2)
    }
}
