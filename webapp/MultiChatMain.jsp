<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8" %>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<title>웹 소켓 채팅</title>

</head>
<body>
	<script>
	function chatWinOpen(){
		var id= document.getElementById("chatID");
		if (id.value==""){
			alert("닉네임을 입력 후 채팅창을 열어주세요.");
			id.focus();
			return;
		}
		if (id.value.length>10){
			alert("닉네임은 10글자 까지 가능합니다.");
			id.focus();
			return;
		}
		window.open("ChatWindow.jsp?chatId="+id.value,"","width=500,height=600");
		id.value="";
		}
	</script>
	<div class="container mt-5">
	<h2 align="center"> 웹 소켓 채팅 </h2>
	<div class= "input-group d-flex justify-content-center mt-3">
		<div class="w-25 me-1"><input type= "text" id="chatID" class="form-control" placeholder="닉네임을 입력하세요"/></div>
		<div calss="w-25"><button class="btn btn-primary" onclick="chatWinOpen();">채팅 참여</button></div>
	</div>
	</div>
</body>	
</html>	