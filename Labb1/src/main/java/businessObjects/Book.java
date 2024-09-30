package businessObjects;

import java.util.regex.Pattern;

public class Book {
    private static final Pattern ISBN_PATTERN = Pattern.compile("^\\d{12}[\\d|X]$");
    private final int bookId;
    private final String isbn;
    private final String title;
    private final Genre genre;
    //private final String publisher;
    //private final Date publicationDate;
    private final String author;
    private int nrOfCopies;

    public static boolean isIsbnValid(String isbn) {
        return ISBN_PATTERN.matcher(isbn).matches();
    }

    public Book(int bookId, String isbn, String title, Genre genre, String author, int nrOfCopies) {
        this.bookId = bookId;
        if (!isIsbnValid(isbn))
            throw new IllegalArgumentException("Not a valid isbn");
        this.isbn = isbn;
        this.title = title;
        this.genre = genre;
        this.author = author;
        if (nrOfCopies < 0)
            throw new IllegalArgumentException("Not valid number of copies");
        this.nrOfCopies = nrOfCopies;
    }

    public int getBookId() {
        return bookId;
    }

    public String getIsbn() {
        return isbn;
    }

    public String getTitle() {
        return title;
    }

    public Genre getGenre() {
        return genre;
    }

    public String getAuthor() {
        return author;
    }

    public int getNrOfCopies() {
        return nrOfCopies;
    }

    public void setNrOfCopies(int nrOfCopies) {
        if (nrOfCopies < 0)
            throw new IllegalArgumentException("Not valid number of copies");
        this.nrOfCopies = nrOfCopies;
    }

    @Override
    public String toString() {
        return "Book {" +
                "bookId=" + bookId +
                ", isbn='" + isbn + '\'' +
                ", title='" + title + '\'' +
                ", genre=" + genre +
                ", author='" + author + '\'' +
                ", nrOfCopies=" + nrOfCopies +
                '}';
    }
}