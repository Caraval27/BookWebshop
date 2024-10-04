package ui;

import businessObjects.BookHandler;
import businessObjects.Genre;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Collection;

@WebServlet(name = "bookServlet", value = "/book-servlet")
public class BookServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        Collection<BookInfo> books = BookHandler.getAllBooks();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/books.jsp").forward(request, response); // Forward to JSP page
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createBook(request, response);
        } else if ("edit".equals(action)) {
            editBook(request, response);
        } else if ("delete".equals(action)) {
            deleteBook(request, response);
        }
    }

    private void createBook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String isbn = request.getParameter("isbn");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String genre = request.getParameter("genre");
        int price = Integer.parseInt(request.getParameter("price"));
        int nrOfCopies = Integer.parseInt(request.getParameter("nrOfCopies"));

        BookHandler.createBook(new BookInfo(isbn, title, Genre.valueOf(genre), author, price, nrOfCopies));

        response.sendRedirect("products.jsp");
    }

    private void editBook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String itemIdStr = request.getParameter("itemId");
        String priceStr = request.getParameter("price");
        String nrOfCopiesStr = request.getParameter("nrOfCopies");
        int itemId = Integer.parseInt(itemIdStr);
        BookInfo book = BookHandler.getBookByItemId(itemId);
        int newPrice = book.getPrice();
        int newNrOfCopies = book.getNrOfCopies();

        if (priceStr != null && !priceStr.isEmpty()) {
            newPrice = Integer.parseInt(priceStr);
        }

        if (nrOfCopiesStr != null && !nrOfCopiesStr.isEmpty()) {
            newNrOfCopies = Integer.parseInt(nrOfCopiesStr);
        }

        BookHandler.updateBook(book, newNrOfCopies, newPrice);

        response.sendRedirect("products.jsp");
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String itemIdStr = request.getParameter("itemId");
        BookHandler.deleteBookById(Integer.parseInt(itemIdStr));
        response.sendRedirect("products.jsp");
    }
}