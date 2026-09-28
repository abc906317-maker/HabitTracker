import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showingAdd = false
    @State private var newName = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(habits) { habit in
                    HStack {
                        Button { toggle(habit) } label: {
                            Image(systemName: habit.isCompleted() ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                        Text(habit.name)
                        Spacer()
                        Label("\(habit.currentStreak)", systemImage: "flame.fill")
                            .foregroundStyle(.orange)
                    }
                }
                .onDelete { offsets in
                    offsets.map { habits[$0] }.forEach(context.delete)
                }
            }
            .overlay {
                if habits.isEmpty {
                    ContentUnavailableView("No habits yet",
                                           systemImage: "list.bullet",
                                           description: Text("Tap + to add one"))
                }
            }
            .navigationTitle("Today")
            .toolbar {
                Button { showingAdd = true } label: { Image(systemName: "plus") }
            }
            .alert("New Habit", isPresented: $showingAdd) {
                TextField("Name", text: $newName)
                Button("Add") { add() }
                Button("Cancel", role: .cancel) { newName = "" }
            }
        }
    }

    private func toggle(_ habit: Habit) {
        if let log = habit.logs.first(where: { Calendar.current.isDateInToday($0.date) }) {
            context.delete(log)
        } else {
            context.insert(HabitLog(habit: habit))
        }
    }

    private func add() {
        let name = newName.trimmingCharacters(in: .whitespaces)
        newName = ""
        guard !name.isEmpty else { return }
        context.insert(Habit(name: name))
    }
}
