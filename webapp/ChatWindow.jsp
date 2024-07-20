<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<html>
<head>
<title>웹소켓 채팅</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script>
	var webSocket = new WebSocket("ws://localhost:8181/WebSocketTest/ChatingServer"); // ws:webSocket(https x)
//  			= new WebSocket("ws://192.168.219.113:8181/ChatingServer"); 
	var chatWindow, chatMessage, chatId;
	
	// 채팅창이 열리면 대화창, 메세지 입력창, 대화명 표시란으로 사용할 DOM 객체 저장
	window.onload=function(){
		chatWindow=document.getElementById("chatWindow");
		chatMessage=document.getElementById("chatMessage");
		chatId=document.getElementById('chatId').value;
	}
	
	//메세지 전송
	function sendMessage(){
		if(chatMessage.value==""){ // 채팅창 비었을 때 리턴
			return;
		} else {
			// 대화창에 표시
			chatWindow.innerHTML += "<div class='border border-1 bg-warning text-end form-control mt-2 align-self-end'>" + chatMessage.value+ "</div>";
			webSocket.send(chatId+'|'+chatMessage.value); // 서버로 전송
			chatMessage.value=""; // 메세지 입력창 내용 지우기
			chatWindow.scrollTop=chatWindow.scrollHeight; // 대화창 스크롤
		}
	}
	
	//서버와의 연결 종료
	function disconnect(){
		webSocket.close();
	}
	
	//엔터키 입력 처리
	function enterKey() {
		if(window.event.keyCode==13){ // 13:enter key의 코드 값
			sendMessage();
		}
	}
	// 웹 소켓 서버에 연결 됬을 때 실행
	webSocket.onopen=function(event){
		chatWindow.innerHTML +="<div class='align-self-center mt-2'>매너 채팅 부탁드립니다. <br>귓속말: /w 닉네임 내용</div>";
	}
	
	// 웹 소켓 서버와 연결이 끊겼을 때 실행
	webSocket.onclose=function(event){
		chatWindow.innerHTML +="<div class='align-self-center mt-2'>채팅방과의 접속이 끊겼습니다.</div>";
	}
	
	// 에러 발생 시 실행
	webSocket.onerror = function(event){
		alert(event.data);
		chatWindow.innerHTML +="<div class='align-self-center mt-2'>채팅 중 에러가 발생되었습니다.<div>";
	}
	
	// 메세지를 받았을 때 실행
	webSocket.onmessage = function(event){
		var message = event.data.split("|"); // 대화명과 메세지 분리
		var sender=message[0];
		var content=message[1];
		if (content!=""){
			if(content.match(/^\/w\s+/i)){
				if(content.match(new RegExp("^\/w\\s"+chatId+"\\s+","i"))){
					var temp=content.replace("/w "+chatId,"<b>[귓속말] </b>");
					chatWindow.innerHTML += "<div class='ps-2 mt-2'><b>"+sender+"</b></div><div class='border border-1 bg-light form-control align-self-start'>"+temp+"</div>";
				}
			} else {
				chatWindow.innerHTML += "<div class='ps-2 mt-2'><b>"+sender+"</b></div><div class='border border-1 bg-light form-control align-self-start'>"+content+"</div>";
			}
		}
		chatWindow.scrollTop = chatWindow.scrollHeight;
		
	}
</script>
<style> 
	#chatWindow{width:470px; height:450px; overflow:auto;}
	#chatWindow div{width:auto; max-width:55%; word-wrap: break-word;}
</style>
</head>
<body>
	<div class="input-group d-flex justify-content-between mt-4 px-3">
	    <div><input type="hidden" id="chatId" value="${param.chatId }"></div>
	    <div><mark><b>${param.chatId}</b></mark>님의 채팅방</div> 
		<button id="closeBtn" class="btn btn-outline-warning" onclick="disconnect();">접속 종료</button>
	</div>
	
	<div id="chatWindow" class="border border-dark border-3 form-control bg-info mx-auto mt-2 py-2 d-flex flex-column">
	</div>
	
	<div class="input-group justify-content-end mt-3 px-3">
		<input type="text" id="chatMessage" class="form-control border border-3" onkeyup="enterKey();" placeholder="하고 싶은 말을 적어보세요">
		<button id="sendBtn" class="btn btn-primary" onclick="sendMessage();" style="width:20%;">
			<i class="fa-solid fa-location-arrow"></i>
		</button>
	</div>
</body>
</html>