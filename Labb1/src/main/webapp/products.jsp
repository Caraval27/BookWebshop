<%@ page import="ui.view.UserInfo" %>
<%@ page import="ui.view.BookInfo" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="businessObjects.Authority" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/navBarStyle.css">
    <link rel="stylesheet" href="css/productStyle.css">
    <link rel="stylesheet" href="css/handleBookForms.css">
    <title>Manage products</title>
</head>
<body>
    <% UserInfo currentUser = (UserInfo) session.getAttribute("currentUser"); %>

    <div class="topnav">
        <a class="active" href="shop-servlet">Home</a>
        <a href="orders-servlet">Orders</a>
        <a href="product-servlet">Products</a>
        <% if(currentUser != null && currentUser.getAuthority() == Authority.Admin) { %>
            <a href="user-servlet">Users</a>
        <% } %>
        <a href="profile-servlet">Profile</a>
        <% if(currentUser == null) { %>
        <a href="login.jsp">Login</a>
        <% } else { %>
        <form action="login-servlet" method="POST">
            <input type="hidden" name="action" value="logout">
            <button class="log-out" type="submit">Logout</button>
        </form>
            <a class="view-user">Logged in: <%= currentUser.getName()%></a>
        <% } %>
    </div>

    <div class="product-list">
        <div class="list-item">
            <div class="item-info">
                <a> </a>
                <a>Id</a>
                <a>ISBN</a>
                <a>Title</a>
                <a>Author</a>
                <a>Genre</a>
                <a>Stock</a>
                <a>Price</a>

                <!-- Add Book Button -->
                <input type="checkbox" id="createBookToggle" hidden>
                <div class="form-container" id="createBookForm">
                    <label for="createBookToggle" class="close-btn">&times;</label>
                    <h2>Add New Book</h2>
                    <form action="product-servlet" method="POST">
                        <input type="hidden" name="action" value="create">
                        <label for="isbn">ISBN:</label>
                        <input type="text" id="isbn" name="isbn" required>
                        <label for="title">Title:</label>
                        <input type="text" id="title" name="title" required>
                        <label for="author">Author:</label>
                        <input type="text" id="author" name="author" required>
                        <label for="genre">Genre:</label>
                        <select id="genre" name="genre" required>
                            <% ArrayList<String> genres = (ArrayList<String>) request.getAttribute("genres");
                                for (String genre : genres) { %>
                                <option value="<%= genre %>"><%= genre %></option>
                            <% } %>
                            <option value="other"> </option>
                        </select>
                        <label for="price">Price:</label>
                        <input type="number" id="price" name="price" required>
                        <label for="nrOfCopies">Number of Copies:</label>
                        <input type="number" id="nrOfCopies" name="nrOfCopies" required>
                        <button type="submit">Add Book</button>
                    </form>
                </div>

                <!-- Add Category Button -->
                <input type="checkbox" id="addCategoryToggle" hidden>
                <div class="form-container" id="addCategoryForm">
                    <label for="addCategoryToggle" class="close-btn">&times;</label>
                    <h2>Add New Category</h2>
                    <form action="product-servlet" method="POST">
                        <input type="hidden" name="action" value="category">
                        <label for="newGenre">Category (genre):</label>
                        <input type="text" id="newGenre" name="newGenre" required>
                        <label>Existing Categories:</label>
                        <ul class="category-list">
                            <% for (String genre : genres) { %>
                            <li><%= genre %></li>
                            <% } %>
                        </ul>
                        <button type="submit">Add Category</button>
                    </form>
                </div>

                <% if(currentUser != null && currentUser.getAuthority() == Authority.Admin) { %>
                <label for="createBookToggle" class="toggle-link">Add Book</label>
                <a> </a>
                <label for="addCategoryToggle" class="toggle-link">Add Category</label>
                <% } %>
            </div>
        </div>

        <%  Collection<BookInfo> books = (Collection<BookInfo>) request.getAttribute("booksInfo");
            Iterator<BookInfo> it = books.iterator();
            for (; it.hasNext();) {
                BookInfo book = it.next();
                int id = book.getItemId();
        %>
            <div class="list-item">
                <div class="item-info">
                    <img src="resources/<%= book.getIsbn() %>.jpg" alt="<%= book.getIsbn() %>">
                    <p><%= id %></p>
                    <p><%= book.getIsbn() %></p>
                    <p><%= book.getTitle() %></p>
                    <p><%= book.getAuthor() %></p>
                    <p><%= book.getGenre() %></p>
                    <p><%= book.getNrOfCopies() %></p>
                    <p><%= book.getPrice() %> kr</p>

                    <!-- Edit Button -->
                    <input type="checkbox" id="editBookToggle<%=id%>" hidden>
                    <div class="form-container" id="editBookForm<%=id%>">
                        <label for="editBookToggle<%=id%>" class="close-btn">&times;</label>
                        <h2>Edit item: <%=id%></h2>
                        <form action="product-servlet" method="POST">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="itemId" value="<%=id%>">

                            <% if(currentUser != null && currentUser.getAuthority() == Authority.Admin) { %>
                                <label for="newPrice<%=id%>">New Price (leave empty to keep unchanged):</label>
                                <input type="number" id="newPrice<%=id%>" name="price" placeholder="Enter new price">
                            <% } else { %>
                                <input type="hidden" name="price" value="">
                            <% } %>

                            <label for="newNrOfCopies<%=id%>">New Number of Copies (leave empty to keep unchanged):</label>
                            <input type="number" id="newNrOfCopies<%=id%>" name="nrOfCopies" placeholder="Enter new number of copies">

                            <button type="submit">Save Changes</button>
                        </form>
                    </div>
                    <label for="editBookToggle<%=id%>" class="toggle-link">Edit</label>

                    <!-- Delete Button -->
                    <% if(currentUser != null && currentUser.getAuthority() == Authority.Admin) { %>
                        <form action="product-servlet" method="POST" onsubmit="return confirm('Are you sure you want to delete this book?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="itemId" value="<%= id %>">
                            <button type="submit" class="delete-btn">Delete</button>
                        </form>
                    <% } %>
                </div>
            </div>
         <%}%>
    </div>
</body>
</html>
