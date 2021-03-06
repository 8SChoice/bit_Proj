<%-- <%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<script>
function insertDB() {
	alert("클릭됨")
}

</script>
<title>Insert title here</title>
</head>
<body>
	<h1>공연 상세 페이지</h1>
	<br>
	<img src="${requestScope.festival.src}"/>
	<h2>${requestScope.festival.fname}</h2>
	<h2>${requestScope.festival.startDate}</h2>
	<h2>${requestScope.festival.endDate}</h2>
	<h2>${requestScope.festival.floc}</h2>
	
	<h1>---라인업----</h1>
	<c:forEach items="${requestScope.artistList }" var="artist">
		<!-- 이미지 엑박 처리 필요 -->
		<span>
			<a href="${pageContext.request.contextPath}/artist/${artist.aid }">
				<img src="${artist.src }" width="150" height="150">		
			</a>			
			<h5>${artist.aname }</h5>
		</span>
	</c:forEach>
	
	<hr>
	<h1>댓글</h1>
	<form>
		<textarea rows="3" placeholder="댓글을 입력하세요"></textarea>
		<button type="submit" id="submit" onclick="insertDB()">등록</button>
	</form>
	
	<table>
		<thead>
			<th>작성자</th>
			<th>내용</th>
			<th>작성시간</th>
		</thead>
		<tbody>
			<tr>
				<td>d</td>
				<td>d</td>
				<td>d</td>
			</tr>
		</tbody>
	</table>
</body>
</html> --%>

<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script>
<script>
	$(document).ready(function(){
		getComments();
	});
	
	function deleteComment(no) {
		if(confirm("정말 삭제하시겠습니까?")==true) {
	 		$.ajax({
				url : "${pageContext.request.contextPath}/festival/comments/delete/" +no,
				type : "post",
				success : function(data) {
					alert("삭제 완료!");
					getComments();
				}
			});			
		} else {
			return;
		}
	}
	
	function updateComment(no) {
 		var content = $('#comment'+no+' #content').val().trim();
 		if (content ==="") {
			alert("댓글을 입력하세요");
			$('#comment'+no+' #content').focus();
 		} else {
			$.ajax({
				url : "${pageContext.request.contextPath}/festival/comments/update/"+no,
				type: "post",
				data : {
					'content' : content,
					'no' : no
				},
				success : function(data) {
					getComments();
				},
			    error:function(request,status,error){
			        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);}
			});	
 		}
	}
	
	function editComment(no, content){
 		var date = $('#comment'+no+ '> #commentDate').text();
 		var writer = $('#comment'+no+ '> #commentWriter').text();
	    var editForm ='';
	    editForm += "<td>"+writer+"</td>";
	    editForm += "<td><input type='text' placeholder='댓글을 입력하세요' name='content' id='content'></td>";
	    editForm += "<td>"+date+"</td>";	    
	    editForm += "<td><input id='btn' type='button' onclick='updateComment("+no+")' value='수정'>";
	    editForm += "<input id='btn' type='button' onclick='getComments()' value='취소'></td>";
	    
	    $('#comment'+no).html(editForm);
	}
	
	function insertComment() {
		var content = $("#content").val().trim();
		if(content ==="") {
			alert("댓글을 입력하세요");
			$("#content").focus();
		} else {
			$.ajax({
				url: "${pageContext.request.contextPath}/festival/comments/${requestScope.festival.fid}",
				type : "POST",
				data : $("#comments").serialize(),
				success: function(data) {
					$("#content").val("");
					$("#writer").val("");
					getComments();
				},
				error: function(error) {
					console.log(error);
				}
			});
		}
	}
	
	function getComments() {
		$.ajax({
			type: "get",
			url : "${pageContext.request.contextPath}/festival/comments/${requestScope.festival.fid}",
			success: function(data) {
				var output = "";
				for(var i in data) {
					output += "<tr id='comment"+data[i].no+"'>";
					output += "<td id='commentWriter'>"+data[i].writer +"</td>";
					output += "<td id='commentContent'>"+data[i].content +"</td>";
					output += "<td id='commentDate'>"+data[i].regDate +"</td>";
					output += "<td>";
					output += "<button type='button' id='btnDelete' onclick='deleteComment("+data[i].no+")'>삭제</button>";
					output += "<button type='button' id='btnUpdate' onclick='editComment("+data[i].no+",\""+data[i].content+"\")'>수정</button>";
					output += "</td>";
					output += "</tr>";
				}
				$("#commentsList").html(output);
			}
		});
	}
</script>

<title>Insert title here</title>
</head>
<body>
	<h1>공연 상세 페이지</h1>
	<br>
	<img src="${requestScope.festival.src}" />
	<h2>${requestScope.festival.fname}</h2>
	<h2>${requestScope.festival.startDate}</h2>
	<h2>${requestScope.festival.endDate}</h2>
	<h2>${requestScope.festival.floc}</h2>

	<h1>---라인업----</h1>
	<!-- 이미지 엑박 처리 필요 -->
	<c:forEach items="${requestScope.artistList }" var="artist">
		<span> <a
			href="${pageContext.request.contextPath}/artist/${artist.aid }">
				<img src="${artist.src }" width="150" height="150">
		</a>
			<h5>${artist.aname }</h5>
		</span>
	</c:forEach>

	<hr>
	<h1>댓글</h1>
	<form id="comments">
		writer : <input type="text" placeholder="작성자" name="writer" id="writer"><br>
		content : <input type="text" placeholder="댓글을 입력하세요" name="content" id="content">
	</form>
	<input id="btn" type="button" onclick="insertComment()" value="등록">
	<br><hr>
	
	<div>
		<table border="1">
			<thead>
				<tr>
					<th>작성자
					<th>댓글
					<th>작성일
					<th>버튼?
				</tr>
			</thead>
			<tbody id="commentsList">
			</tbody>
		</table>
	</div>
</body>
</html>