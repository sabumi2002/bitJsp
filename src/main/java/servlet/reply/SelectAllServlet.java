package servlet.reply;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import connector.ConnectionMaker;
import connector.MySqlConnectionMaker;
import controller.ReplyController;
import controller.UserController;
import model.ReplyDTO;
import model.UserDTO;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

@WebServlet(name = "SelectAllServlet", value = "/reply/selectAll")
public class SelectAllServlet extends HttpServlet {
    JsonObject object = new JsonObject();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int boardId = Integer.parseInt(request.getParameter("boardId"));
        JsonObject object = new JsonObject();

        try {
            ConnectionMaker connectionMaker = new MySqlConnectionMaker();
            ReplyController replyController = new ReplyController(connectionMaker);
            UserController userController = new UserController(connectionMaker);

            HttpSession session = request.getSession();
            UserDTO logIn = (UserDTO) session.getAttribute("logIn");

            ArrayList<ReplyDTO> list = replyController.selectAll(boardId);
            JsonArray array = new JsonArray();
            SimpleDateFormat sdf = new SimpleDateFormat();
            for (ReplyDTO r : list) {
                JsonObject temp = new JsonObject();
                temp.addProperty("id", r.getId());
                temp.addProperty("content", r.getContent());
                temp.addProperty("writer", userController.selectOne(r.getWriterId()).getNickname());
                if (r.getModifyDate() != null) {
                    temp.addProperty("date", sdf.format(r.getModifyDate()));
                } else {
                    temp.addProperty("date", sdf.format(r.getEntryDate()));
                }
                temp.addProperty("isOwned", logIn.getId() == r.getWriterId());

                array.add(temp);
            }
            object.addProperty("status", "success");
            object.addProperty("list", array.toString());


        } catch (Exception e) {
            object.addProperty("status", "fail");
        }
        PrintWriter writer = response.getWriter();
        writer.print(object);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
