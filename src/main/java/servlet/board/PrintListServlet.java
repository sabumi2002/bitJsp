package servlet.board;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import connector.ConnectionMaker;
import connector.MySqlConnectionMaker;
import controller.BoardController;
import controller.UserController;
import model.BoardDTO;
import model.UserDTO;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

@WebServlet(name = "PrintListServlet", value = "/board/printList")
public class PrintListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(); // 세션 가져오기
        UserDTO logIn = (UserDTO) session.getAttribute("logIn");    // 세션에서 로그인객체 가져오기

        int pageNo = Integer.parseInt(request.getParameter("pageNo"));  // url파라미터에서 pageNo 가져오기

        ConnectionMaker connectionMaker = new MySqlConnectionMaker();
        BoardController boardController = new BoardController(connectionMaker);
        UserController userController = new UserController(connectionMaker);

        ArrayList<BoardDTO> list = boardController.selectAll(pageNo);
        int totalPage = boardController.countTotalPage();


        SimpleDateFormat sdf = new SimpleDateFormat("y/M/d");   // 날짜포맷

        // 통신할때 json 형식으로 데이터를 보내야함.
        JsonArray array = new JsonArray();

        for(BoardDTO b : list){
            JsonObject object = new JsonObject();
            object.addProperty("id", b.getId());
            object.addProperty("title", b.getTitle());
            object.addProperty("entryDate", sdf.format(b.getEntryDate()));
            object.addProperty("modifyDate", sdf.format(b.getModifyDate()));
            object.addProperty("writerNickname", userController.selectOne(b.getWriterId()).getNickname());
            array.add(object);
        }
        JsonObject result = new JsonObject();
        result.addProperty("result", "success");
        result.addProperty("data", array.toString());
        result.addProperty("totalPage", totalPage);

        // response
        PrintWriter writer = response.getWriter();
        writer.print(result);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
