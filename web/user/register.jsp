<%--
  Created by IntelliJ IDEA.
  User: Sabeom
  Date: 2023-02-10
  Time: 오전 10:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- CSS only -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <!-- JavaScript Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
            crossorigin="anonymous"></script>
    <%--    sweetalert2 라이브러리 // 에러상자 꾸미기--%>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
    <script>
        let result = false;

        function validateUsername(username) {

            var data = {
                "username": username
            };

            $.ajax({
                url: "/user/validate",
                type: "get",
                data: data,
                success: function (message) {
                    // console.log(message);
                    // let jsonResult = JSON.parse(message);
                    // console.log(typeof (jsonResult));

                    let jsonResult = JSON.parse(message)

                    if(!jsonResult.result) {
                        swal.fire({title:'실패', text: jsonResult.message})
                    }
                }
            });

            return false;
        }

        function validatePassword(password) {
            if (password.includes('!')) {
                return true;
            }
            return false;
        }

        function validateInput() {
            let username = document.getElementById('username');
            let password = document.getElementById('password');
            result = validateUsername(username.value) && validatePassword(password.value);

            if (result) {
                document.forms[0].submit(); // 해당 도쿠먼트에 들어있는 form 태그중 0번쨰에있는것을 가져와라
            } else {
                swal.fire({title: '!!! 오류 !!!', text: '잘못 입력하셨습니다.', icon: 'error'});
            }
            console.log(result);
        }

    </script>

    <title>회원가입</title>
</head>
<body>
<div class="container-fluid">
    <div class="row vh-100 align-items-center text-center">
        <div class="row justify-content-center">
            <form action="/user/register_logic.jsp" method="post">
                <div class="row justify-content-center mb-2">
                    <div class="col-6">
                        <div class="form-floating">
                            <input type="text" id="username" name="username" class="form-control" placeholder="아이디">
                            <label for="username">아이디</label>
                        </div>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-6">
                        <div class="form-floating">
                            <input type="text" id="password" name="password" class="form-control" placeholder="비밀번호">
                            <label for="username">비밀번호</label>
                        </div>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-6">
                        <div class="form-floating">
                            <input type="text" id="nickname" name="nickname" class="form-control" placeholder="닉네임">
                            <label for="nickname">닉네임</label>
                        </div>
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="btn btn-outline-primary col-6 m-1" onclick="validateInput()">회원가입</div>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>