//
//  CellView.swift
//  CalendarSample
//
//  Created by Tadashi on 2017/04/18.
//  Copyright © 2017 T@d. All rights reserved.
//

import JTAppleCalendar

class CellView: JTAppleCell {
    @IBOutlet var selectedView: UIView!
    @IBOutlet var dayLabel: UILabel!
	@IBOutlet weak var check: UIImageView!
}
