<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"%> 
<%@ page import="java.util.ArrayList" import="tlvparser.TLVObject" %> 
<%@ taglib prefix="c" uri= "http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
<title>Input HexaString</title> 
</head> 
  
<style> 
    #main {
	    width: 70%;
	    height: 400px;
	    margin: auto;
  	}
	input {
		width: 100%;
		height: 100%;
	}
   
</style> 
<%! 
	String result; 
	ArrayList<TLVObject> list; 
	int lastRowPos;  //열 
	int lastColPos;  //행 
%> 
<% 
	list = (ArrayList<TLVObject>) request.getAttribute("TlvList"); 
     
%> 
<%!// <tr> 생성 
// Tag는 if(val == construct) (construct로 시작된 Depth에서 마지막 Depth 열의 위치 - 현재 열의 위치)의 값만큼 병합. primitive라면 병합 없음 
// Length는 무난하게 td로 붙음 
// value는 (그 어떤 것이라도 가장 깊은 마지막 Depth 행의 위치 - 현재 행의 위치 => depth + 2)의 값만큼 병합. primitive라면 값 넣고 같은 방식으로 병합 
// </tr> 닫아 그리고   재귀 함수로들어가  
  
//how 
//1. construct로 시작된 Depth에서 마지막 Depth의 열 위치를 어떻게 구하지? 
//  1 답 : 현재 list에서 primitive가 나올 때까지 계속 들어가. 들어갈 때마다 열의 위치를 알 수 있는 point를 +1해줘.  point의 초기값은 1이다 
//  그렇게 가다가 primitive가 잡혔을 때. 그때의 point 만큼 열을 병합한다. 
// point는 list에서 primitive를 만나게 될 경우 다시 1로 초기화 
//2. 그 어떤 것이라도 가장 깊은 마지막 Depth 행의 위치는 어떻게 구하지? 
//   2 답 : 현재 주어진 최상위 depth가 0인 list의 primitive가 나올 때까지 계속 들어가 계속 들어가면 depth가 나올테지. primitive를 발견했을 때의 (depth + 3)을 임시 tmp에 넣고 
// 그담 또 돌아서 더 큰 값을 tmp에 넣어 그게 바로 가장 깊은 마지막 depth 행의 위치임 
  
//처음 rowDepthOrg는 0 
//현재 오브젝트의 깊이만 구한다. 
  
	public int getLastRow(ArrayList<TLVObject> tlvList, int rowDepthOrg){ 
	    TLVObject tlvObject; 
		String tag = ""; 
		String length = ""; 
		String stringValue = ""; 
		String result = ""; 
		int rowDepth = rowDepthOrg; 
		  
		for (int i = 0; i < tlvList.size(); i++) { 
			tlvObject = tlvList.get(i); //처음만 
			  
			if (tlvObject.getValue() != null) { 
				rowDepth = getLastRow(tlvObject.getValue(), rowDepth + 1); 
			} else { 
				rowDepth++; 
			} 
		} 
	  
	return rowDepth; 
	} 
	  
	  
	//가장 마지막 행 구하기 테이블 가로 구하기 
	public int getLastCol(ArrayList<TLVObject> tlvList, int depthOrg, int colDepthOrg) { 
		TLVObject tlvObject; 
		String tag = ""; 
		String length = ""; 
		String stringValue = ""; 
		String result = ""; 
		int depth = depthOrg; 
		int colDepth = colDepthOrg; 
		for (int i = 0; i < tlvList.size(); i++) { 
			tlvObject = tlvList.get(i); 
			  
			if (tlvObject.getValue() != null) { 
				colDepth = getLastCol(tlvObject.getValue(), depth + 1, colDepth); 
			} 
			  
				if (colDepth < depth + 3) { 
			colDepth = depth + 3; 
			} 
		} 
		  
		return colDepth; 
	} 
	  
	//여기서 point는 depth와 별개로 테이블의 열을 의미함 
	public String getTLV(ArrayList<TLVObject> tlvList, int depthOrg) { 
	TLVObject tlvObject; 
	String tag = ""; 
	String length = ""; 
	String stringValue = ""; 
	String result = ""; 
	int depth = depthOrg; 
	String depthTap = ""; 
	int rowspanTmp = 0; 
	int colspanTmp = depth + 2; 
	  
	if (depthOrg == 0) { 
	result += "<table border='1'>"; 
	/* result += "<table>";  */
	} 
	  
	result += "<tr>"; 
	  
	for (int i = 0; i < tlvList.size(); i++) { 
		tlvObject = tlvList.get(i); 
		tag = tlvObject.getTag(); 
		length = tlvObject.getLength(); 
		  
		//construct가 있다는 것 
		if (tlvObject.getValue() != null) { 
			result += "<td rowspan='" + getLastRow(tlvObject.getValue(), 1) + "' valign=top >"; 
		} else { 
			result += "<td valign=top>"; 
		} 
		result += tag; 
		result += "</td>"; 
		  
		  
		//construct가 있다는 것 
		if (tlvObject.getValue() != null) { 
			  
			result += "<td colspan='" + (lastColPos - colspanTmp + 1) + "' valign=top >"; 
			result += length; 
			  
			result += getTLV(tlvObject.getValue(), depth + 1); 
			} else { 
			result += "<td valign=top>"; 
			result += length; 
			result += "</td>"; 
			  
			stringValue = tlvObject.getStringValue(); 
			result += "<td colspan='" + (lastColPos - colspanTmp) + "' valign=top>"; 
			result += stringValue; 
		} 
		  
		result += "</td>"; 
		result += "</tr>"; 
	  
	} 
	  
	if (depthOrg == 0) { 
	result += "</table>"; 
	} 
	  
	return result; 
}%> 
  
<body> 

<table border='1'><tr><td rowspan='18' valign=top >6F</td><td colspan='6' valign=top >6F<tr><td valign=top>84</td><td valign=top>08</td><td colspan='4' valign=top>A000000003000000</td></tr><td rowspan='15' valign=top >A5</td><td colspan='5' valign=top >59<tr><td valign=top>9F65</td><td valign=top>01</td><td colspan='3' valign=top>FF</td></tr><td valign=top>9F6E</td><td valign=top>06</td><td colspan='3' valign=top>479173512E00</td></tr><td rowspan='12' valign=top >73</td><td colspan='4' valign=top >4A<tr><td valign=top>06</td><td valign=top>07</td><td colspan='2' valign=top>2A864886FC6B01</td></tr><td rowspan='2' valign=top >60</td><td colspan='3' valign=top >0C<tr><td valign=top>06</td><td valign=top>0A</td><td colspan='1' valign=top>2A864886FC6B02020101</td></tr></td></tr><td rowspan='2' valign=top >63</td><td colspan='3' valign=top >09<tr><td valign=top>06</td><td valign=top>07</td><td colspan='1' valign=top>2A864886FC6B03</td></tr></td></tr><td rowspan='2' valign=top >64</td><td colspan='3' valign=top >0B<tr><td valign=top>06</td><td valign=top>09</td><td colspan='1' valign=top>2A864886FC6B040215</td></tr></td></tr><td rowspan='2' valign=top >65</td><td colspan='3' valign=top >0B<tr><td valign=top>06</td><td valign=top>09</td><td colspan='1' valign=top>2B8510864864020103</td></tr></td></tr><td rowspan='2' valign=top >66</td><td colspan='3' valign=top >0C<tr><td valign=top>06</td><td valign=top>0A</td><td colspan='1' valign=top>2B060104012A026E0102</td></tr></td></tr></td></tr></td></tr><td valign=top>84</td><td valign=top>08</td><td colspan='4' valign=top>A000000003000000</td></tr></td></tr><td rowspan='18' valign=top >6F</td><td colspan='6' valign=top >6F<tr><td valign=top>84</td><td valign=top>08</td><td colspan='4' valign=top>A000000003000000</td></tr><td rowspan='15' valign=top >A5</td><td colspan='5' valign=top >59<tr><td valign=top>9F65</td><td valign=top>01</td><td colspan='3' valign=top>FF</td></tr><td valign=top>9F6E</td><td valign=top>06</td><td colspan='3' valign=top>479173512E00</td></tr><td rowspan='12' valign=top >73</td><td colspan='4' valign=top >4A<tr><td valign=top>06</td><td valign=top>07</td><td colspan='2' valign=top>2A864886FC6B01</td></tr><td rowspan='2' valign=top >60</td><td colspan='3' valign=top >0C<tr><td valign=top>06</td><td valign=top>0A</td><td colspan='1' valign=top>2A864886FC6B02020101</td></tr></td></tr><td rowspan='2' valign=top >63</td><td colspan='3' valign=top >09<tr><td valign=top>06</td><td valign=top>07</td><td colspan='1' valign=top>2A864886FC6B03</td></tr></td></tr><td rowspan='2' valign=top >64</td><td colspan='3' valign=top >0B<tr><td valign=top>06</td><td valign=top>09</td><td colspan='1' valign=top>2A864886FC6B040215</td></tr></td></tr><td rowspan='2' valign=top >65</td><td colspan='3' valign=top >0B<tr><td valign=top>06</td><td valign=top>09</td><td colspan='1' valign=top>2B8510864864020103</td></tr></td></tr><td rowspan='2' valign=top >66</td><td colspan='3' valign=top >0C<tr><td valign=top>06</td><td valign=top>0A</td><td colspan='1' valign=top>2B060104012A026E0102</td></tr></td></tr></td></tr></td></tr><td valign=top>84</td><td valign=top>08</td><td colspan='4' valign=top>A000000003000000</td></tr></td></tr></table>

	<% lastColPos = getLastCol(list, 0, 0); %> 
	
	<table id="main" width="500" cellpadding="0" cellspacing="0" border="1" >
		<form action="convert2" method="post">
			<tr>
				<td> HexaString </td>
				<td> <input type="text" name="HexaString" value="${HexaString}"> </td>
			</tr>
			<tr id="result" >
				<td> Result </td>
				<td>
					<div style="overflow:scroll; width:100%; height: 200px; padding:10px"><% out.println(getTLV(list, 0)); %> <div>
				</td>
			</tr>
			<tr>
				<td colspan="2"> <input type="submit" value="변환"></a></td>
			</tr>
		</form>
	</table>
</body> 
</html>
