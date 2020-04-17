extension UITextView {
    func numOfLines() -> Int {

        // Save previous height to reset after caculation
        let previousHeight = textContainer.size.height

        // Set text container size to max value to calculate line number
        // Texts out of text container is not enumerated by layout manager.
        textContainer.size.height = CGFloat.greatestFiniteMagnitude

        // Array to save locations of the first character of each lines.
        var firstIndexArray: [Int] = []

        // Convert character range to glyph range to prevent miscalculater due to emoji.
        let characterRange = NSRange(location: 0, length: attributedText.length)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange,
                                                  actualCharacterRange: nil)

        // Loop through line fragments and save locations
        layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { (_, _, _, rangeOfLine, _) in

            firstIndexArray.append(rangeOfLine.location)

        }

        // Get unique location values
        // Layout manager sometimes enumerates same line fragment more than twice
        firstIndexArray = firstIndexArray.unique()

        // Number of lines without extra fragment
        var numberOfLines = firstIndexArray.count

        // If text ends with new line character, extra line fragment should be counted too.
        // layoutManager.enumerateLineFragments does not contains extra?LineFragment.
       if layoutManager.extraLineFragmentRect.height != 0 {
           numberOfLines += 1
       }

        // Restore text container's height
        textContainer.size.height = previousHeight

        // If nothing, return 1
        if numberOfLines == 0 {
            return 1
        }

        return numberOfLines
    }
}
