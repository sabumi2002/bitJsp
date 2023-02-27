let initPage = (id) => {    // get으로 작동했을때 얘가 실행되어야함.
    let temp = new URLSearchParams(window.location.search).get("id");
    let data;
    data = {"id": temp}

    $.ajax({
        url: "/board/printOne", // 요청이 전송될 URL 주소
        method: "GET",  // http 요청 방식 (default: ‘GET’)
        data: data,     // 요청 시 포함되어질 데이터
        success: (message) => {
            // 정상적으로 응답 받았을 경우에는 success 콜백이 호출되게 됩니다.
            // 이 콜백 함수의 파라미터에서는 응답 바디, 응답 코드 그리고 XHR 헤더를 확인할 수 있습니다.
            let result = JSON.parse(message);
            if (result.status == "success") {
                let data = JSON.parse(result.data);
                printData(data);
                console.log(data);
            } else {
                // sweetalert2 라이브러리
                swal.fire({
                    title: "!!! ERROR !!!",
                    text: result.message,
                    icon: "error"
                }).then(() => {
                    location.href = result.nextPath;
                })
            }


        }
    });
}

function printData(data) {
    $('#input-id').val(data.id + "번");
    $('#input-title').val(data.title);
    $('#editor').text(data.content);

    // ckeditor5 (text작성 꾸미기)
    ClassicEditor.create(document.querySelector("#editor")).catch(error => {
        console.log(error);
    });


}

let updateBoard = () => {
    let id = $('#input-id').val().replace("번", "");
    let formData = {
        id : id,
        title : $('#input-title').val(),
        content : $('.ck-editor__editable').html(),

    };
    $.ajax({
        url: "/board/update",
        method: "post",
        data: formData,
        success: (response) => {
            let result = JSON.parse(response);
            swal.fire({
                icon: result.status,
                text:result.message
            }).then(() =>{
                location.href = result.nextPath;
            })
        }
    })
}