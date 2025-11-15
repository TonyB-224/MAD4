import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var moodDescriptionLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var savedEntryLabel: UILabel!

    // Keep last computed mood for save
    private var currentMoodEmoji: String = "😐"
    private var currentMoodDescription: String = "Neutral"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateMoodDisplay(for: Int(slider.value))
    }

    private func setupUI() {
        // Slider configuration (already settable in storyboard)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.isContinuous = true

        // Date picker: use date only
        if #available(iOS 15.6, *) {
            datePicker.preferredDatePickerStyle = .compact
        }
        datePicker.datePickerMode = .date

        // Saved label initial
        savedEntryLabel.text = "No saved mood yet."
        savedEntryLabel.numberOfLines = 0
        savedEntryLabel.textAlignment = .center
    }

    // MARK: - IBActions

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        // Round slider to integer for nicer thresholds
        let intVal = Int(sender.value.rounded())
        updateMoodDisplay(for: intVal)
    }

    @IBAction func saveMoodTapped(_ sender: UIButton) {
        let selectedDate = datePicker.date
        let formatted = formattedDate(selectedDate)
        // Build sentence: "On May 30, you felt 😄"
        let sentence = "On \(formatted), you felt \(currentMoodEmoji) (\(currentMoodDescription))."
        savedEntryLabel.text = sentence
    }

    // MARK: - Mood mapping
    private func updateMoodDisplay(for value: Int) {
        // Map value to description + emoji
        let (desc, emoji) = moodFor(value: value)
        currentMoodEmoji = emoji
        currentMoodDescription = desc
        let display = "Feeling: \(desc) \(emoji)"
        moodDescriptionLabel.text = display
    }

    private func moodFor(value: Int) -> (String, String) {
        switch value {
        case ...20:
            return ("Very Sad", "😢")
        case 21...40:
            return ("Sad", "🙁")
        case 41...60:
            return ("Neutral", "😐")
        case 61...80:
            return ("Happy", "🙂")
        case 81...100:
            return ("Very Happy", "😄")
        default:
            return ("Neutral", "😐")
        }
    }

    // MARK: - Date formatting
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // e.g., "May 30, 2025"
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}

