# ListView bugs

The AHK dbg wnd allows you to sort by clicking for example `hWnd` but if you copy stuff, it will not be the sorted data but rather the old data.

You also can't select for example line #34 and line #38 and then copypaste them, it'll copypaste #34 and #35 instead.

When the ListView is sorted and it adds new ones, then the new ones aren't getting sorted automatically just yet. They simply get added to the bottom.