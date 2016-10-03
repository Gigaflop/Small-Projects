package nPad_v2;

import javax.swing.JOptionPane;
import javax.swing.JTextArea;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;

/**
 *
 * @author 01625371
 * @author Austin McKay
 * 
 * Part of a class project. I handled the Find and Replace functionality of a text editor.
 */
public class Finder {
    
    /**
     * Find the index of the next occurrence of a given word in a given document
     * @param subjectMaterial The Document to search through
     * @param findMe The string to search for
     * @param caretPosition The position of the caret in the document
     * @param matchCase Do you want to match case exactly?
     * @return -1, or index of next occurrence of findMe
     */
    public static int findNext(Document subjectMaterial, String findMe, int caretPosition, boolean matchCase){
        String text; 
        String target;
        
        try {
            text = subjectMaterial.getText(0, subjectMaterial.getLength());
            target = findMe;
        } catch (BadLocationException ex) {
            //Something bad happened, bail out
            System.out.println("Bad Location Exception, re: subjectMaterial.getText(0, length)");
            return -1;
        }
        
        //match case?
        if (!matchCase){
            text = text.toLowerCase();
            target = findMe.toLowerCase();
        }
        
        return text.indexOf(target, caretPosition);
        
        
        //keep the IDE happy
        //return -1;
    }
    
    /**
     * Find the index of the previous occurrence of a given word in a given document
     * @param subjectMaterial The Document to search through
     * @param findMe The string to search for
     * @param caretPosition The position of the caret in the document
     * @param matchCase Do you want to match case exactly?
     * @return -1, or the index of previous occurrence of findMe
     */
    public static int findLast(Document subjectMaterial, String findMe, int caretPosition, boolean matchCase){
        //Very similar to findNext
        
        String text; 
        String target;
        
        try {
            text = subjectMaterial.getText(0, subjectMaterial.getLength());
            target = findMe;
        } catch (BadLocationException ex) {
            //Something bad happened, bail out
            System.out.println("Bad Location Exception, re: subjectMaterial.getText(0, length)");
            return -1;
        }
        
        //match case?
        if (!matchCase){
            text = text.toLowerCase();
            target = findMe.toLowerCase();
        }
        
        return text.lastIndexOf(target, caretPosition);
        
    }
    
    /**
     * Find the index of and highlight next  or previous occurrence of a given word in a given TextArea
     * @param subjectMaterial JTextArea to search through and apply caret changes to
     * @param findMe String to search for
     * @param matchCase Do you want to match case exactly?
     * @param searchForward True for next, False for previous
     */
    public static void findAndMove(JTextArea subjectMaterial, String findMe, boolean matchCase, boolean searchForward){
        int newPosition;
        System.out.println("____");
        //Set newPosition based on which direction to search
        if (searchForward){
            newPosition = findNext(subjectMaterial.getDocument(), findMe, subjectMaterial.getCaretPosition(), matchCase);
            System.out.println("Direction: ->");
        }
        else{
            //caret must be manually tweaked, in order to not continuously find what's already selected.
            //Tweak caret position by -(1 + findMe.length())
            newPosition = findLast(subjectMaterial.getDocument(), findMe, subjectMaterial.getCaretPosition() - (findMe.length() + 1), matchCase);
            System.out.println("Direction: <-");
        }
        
        if (newPosition == -1){
            //Not found
            //Do nothing
            JOptionPane.showMessageDialog(subjectMaterial, "Not found");
            return;
        }
        //System.out.println("___");
        System.out.println("Caret old: " + subjectMaterial.getCaretPosition());
        System.out.println("Caret new: " + newPosition);
        //Request focus, highlight the text
        subjectMaterial.requestFocus();
        subjectMaterial.select(newPosition, findMe.length() + newPosition);
    }
    
    /**
     * Automatically replaces the next or previous occurrence of a given string with another given string.
     * @param subjectMaterial JTextArea to search and apply changes to
     * @param old String to replace
     * @param next The String to replace old
     * @param matchCase Match case exactly?
     * @param searchForward  True for next, False for previous
     */
    public static void replace(JTextArea subjectMaterial, String old, String next, boolean matchCase, boolean searchForward){
        int prevCaret = subjectMaterial.getCaretPosition();
        
        findAndMove(subjectMaterial, old, matchCase, searchForward);
        
        if (prevCaret != subjectMaterial.getCaretPosition()){
            //If the caret hasn't changed positions, don't do anything
            //If not for this, String next could be inserted in error at cursor position
            subjectMaterial.replaceSelection(next);   
        }
    }
}
