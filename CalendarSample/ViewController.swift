//
//  ViewController.swift
//  CalendarSample
//
//  Created by Tadashi on 2017/04/18.
//  Copyright © 2017 T@d. All rights reserved.
//

import JTAppleCalendar

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
	@IBOutlet weak var tableView: UITableView!

	let months = [
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December" ]
	let kStartDate = "2015 01 01"
	let kEndDate = "2049 12 31"
    var numberOfRows = 6
    let formatter = DateFormatter()
    var myCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    var hasStrictBoundaries = true
    let firstDayOfWeek: DaysOfWeek = .sunday
    var monthSize: MonthSize? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

		self.tableView.tableFooterView = UIView()
		let border = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 0.3))
		border.backgroundColor = UIColor.lightGray
		self.tableView.addSubview(border)

		let swipeGestureL = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
		swipeGestureL.direction = .left
		swipeGestureL.delegate = self
		self.calendarView.addGestureRecognizer(swipeGestureL)

		let swipeGestureR = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
		swipeGestureR.direction = .right
		swipeGestureR.delegate = self
		self.calendarView.addGestureRecognizer(swipeGestureR)

		self.calendarView.selectDates([NSDate() as Date])
		self.calendarView.scrollToDate(NSDate() as Date, animateScroll: false)
		self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
			self.setupViewsOfCalendar(from: visibleDates)
		})
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

	@IBAction func next(_ sender: Any) {
        self.calendarView.scrollToSegment(.next) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
	}

	@IBAction func prev(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
	}

	@IBAction func today(_ sender: Any) {
		self.calendarView.selectDates([NSDate() as Date])
		self.calendarView.scrollToDate(NSDate() as Date, animateScroll: true)
		self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
			self.setupViewsOfCalendar(from: visibleDates)
		})
	}

	func swipe(sender: UISwipeGestureRecognizer) {
		print (sender.direction)
		if sender.direction == .right {
			self.prev(UIButton())
		} else if sender.direction == .left {
			self.next(UIButton())
		}
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = myCalendar.dateComponents([.month], from: startDate).month!
		let monthName = months[(month-1) % 12]
        let year = myCalendar.component(.year, from: startDate)
		self.navigationItem.title = monthName + " " + String(year)
    }

    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CellView  else {
            return
        }

        if cellState.isSelected {
			cell.dayLabel.textColor = UIColor.white
        } else {
			if cellState.dateBelongsTo == .thisMonth {
				if myCalendar.isDateInToday(cellState.date) {
					cell.dayLabel.textColor = UIColor.red
				} else {
					cell.dayLabel.textColor = UIColor.black
				}
            } else {
                cell.dayLabel.textColor = UIColor.init(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
            }
        }
    }

    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CellView else {return }
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  cell.selectedView.frame.size.width / 2
            cell.selectedView.isHidden = false
			if myCalendar.isDateInToday(cellState.date) {
				cell.selectedView.backgroundColor = UIColor.red
			} else {
				cell.selectedView.backgroundColor = UIColor.black
			}
        } else {
            cell.selectedView.isHidden = true
        }

		cell.selectedView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
		UIView.animate(
			withDuration: 0.5,
			delay: 0, usingSpringWithDamping: 0.3,
			initialSpringVelocity: 0.1,
			options: UIViewAnimationOptions.beginFromCurrentState,
			animations: {
				cell.selectedView.transform = CGAffineTransform(scaleX: 1, y: 1)
			},
			completion: nil
		)
    }

    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return	1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return	5
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		cell.textLabel?.text = String(indexPath.row)

		return cell
	}

	func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = myCalendar.timeZone
        formatter.locale = myCalendar.locale

        let startDate = formatter.date(from: kStartDate)!
        let endDate = formatter.date(from: kEndDate)!

        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: myCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek,
                                                 hasStrictBoundaries: hasStrictBoundaries)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        
        cell.dayLabel.text = cellState.text
		cell.backgroundColor = UIColor.white
        handleCellConfiguration(cell: cell, cellState: cellState)
		cell.check.isHidden = false
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        let visibleDates = calendarView.visibleDates()
        self.setupViewsOfCalendar(from: visibleDates)
    }

    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return monthSize
    }
}
