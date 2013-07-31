<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE HTML>
<html manifest="/firstgrademath/manifest.jsp">
<%
	//
	// What is the maximum number for tables. Could be 5, 10, 15, 20
	//
	String maxNum = request.getParameter("maxnum");
	if (maxNum == null || maxNum.equals("")) {
		maxNum = "10";
	}

	//
	// What is the operation type for tables. Could be 5, 10, 15, 20
	//
	String opType = request.getParameter("opType");
	if (opType == null || opType.equals("")) {
		opType = "+";
	}

	//
	// To show Show All and Hide All. "1" means Yes, else No
	//
	String showHideAll = request.getParameter("showhideall");
	if (showHideAll == null || showHideAll.equals("")) {
		showHideAll = "0";
	}

	//
	// To show Tap or not. "1" means Yes, else No
	//
	String showTap = request.getParameter("showtap");
	if (showTap == null || showTap.equals("")) {
		showTap = "0";
	}

	//
	// To show answers or not. "1" means Yes, else No
	//
	String showAnswers = request.getParameter("showanswers");
	if (showAnswers == null || showAnswers.equals("")) {
		showAnswers = "0";
	}

	//
	// To show jumbles or not.
	//
	String showJumble = request.getParameter("jumble");
	if (showJumble == null || showJumble.equals("")) {
		showJumble = "0";
	}
%>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width; target-densitydpi=device-dpi; initial-scale=1.0; maximum-scale=1.0; minimum-scale=1.0; user-scalable=no;" />

<title>First Grade Math</title>

<script type="text/javascript" charset="utf-8" src="jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="global.js"></script>
<script type="text/javascript" charset="utf-8" src="cache_model.js"></script>

<script>

	var gMaxNum = <%=maxNum%>;
	var gOpType = '<%=opType%>';	
	var gShowHideAll = <%=showHideAll%>;
	var gShowTap = <%=showTap%>;
	var gShowAnswers = <%=showAnswers%>;
	var gShowJumble = <%=showJumble%>;
	
</script>

<script type="text/javascript" charset="utf-8" src="common_function.js"></script>

<script>
	$(document).ready(function()
	{
		//console.log("***********************************in ready");
		document.addEventListener("deviceready", onDeviceReady, false);
		onDeviceReady();
	});

	function onDeviceReady()
	{
		//console.log("***********************************in onDeviceReady");
		initMethod();
	}

	function changeNumber(newNumber)
	{
		setTableOf(newNumber);
		initMethod();
	}

	function changeOperatorType(newOperatorType)
	{
		gOpType = newOperatorType;
		initMethod();
	}

	function initMethod()
	{
		var table_of = getTableOf();
		var operatorType = gOpType;
		var strOperatorType;
		var i = 1;
        var randomArray;
		if(gShowJumble)
		{
			randomArray = getRandomCounterArray(10);
		}
		
        console.log("randomArray="+randomArray);

		var htmlStr = "<div style='display: table; width:100%' class='tableClass'>";
		for (i = 1; i <= 10; i++)
		{
			var counterValue = i;
			if(gShowJumble)
			{
				counterValue = randomArray[i-1];
			}
			
			var rowValue;
			if (operatorType == '+')
			{
				rowValue = table_of + counterValue;
			}
			else if (operatorType == '*')
			{
				rowValue = table_of * counterValue;
			}
			else if (operatorType == '/')
			{
				rowValue = counterValue * table_of;
			}
			else if (operatorType == '-')
			{
				rowValue = counterValue + table_of;
			}

			// convert to html string
			strOperatorType = convertOperatorTypeToString(operatorType);
			
			if (operatorType == '+' || operatorType == '*')
			{
				htmlStr += "<div id='row" + i + "' style='display: table-row' class='rowClass'>"
						+ "<div style='display: table-cell; width:16%' class='cellClass' align='right'>"
						+ table_of
						+ "</div>"
						+ "<div style='display: table-cell; width:16%' class='cellClass' align='center'>"
						+ strOperatorType
						+ "</div>"
						+ "<div style='display: table-cell; width:16%' class='cellClass' align='left'>"
						+ counterValue
						+ "</div>"
						+ "<div style='display: table-cell; width:16%' class='cellClass' align='left'>=</div>"
						+ "<div style='display: table-cell; width:16%' class='cellClass'> <div id='calcValue" + i + "' class='calcValue'>"
						+ rowValue
						+ "</div></div>"
						+ "<div style='display: table-cell; width:20%' class='cellClass' align='center'><div style='display:none' class='clickButton' onTouchStart='showHide("
						+ i
						+ ")' onClick='kb_stopEventProgress()'>Tap</div></div>"
						+ "</div>";
			}
			else if (operatorType == '/' || operatorType == '-')
			{
				htmlStr += "<div id='row" + i + "' style='display: table-row' class='rowClass'>"
						+ "<div style='display: table-cell; width:16%' class='cellClass' align='right'>"
						+ rowValue
						+ "</div>"
						+ "<div style='display: table-cell; width:16%' class='cellClass' align='center'>"
						+ strOperatorType
						+ "</div>"
						+ "<div style='display: table-cell; width:16%' class='cellClass' align='left'>"
						+ table_of
						+ "</div>"
						+ "<div style='display: table-cell; width:16%' class='cellClass' align='left'>=</div>"
						+ "<div style='display: table-cell; width:16%' class='cellClass'> <div id='calcValue" + i + "' class='calcValue'>"
						+ counterValue
						+ "</div></div>"
						+ "<div style='display: table-cell; width:20%' class='cellClass' align='center'><div style='display:none' class='clickButton' onTouchStart='showHide("
						+ i
						+ ")' onClick='kb_stopEventProgress()'>Tap</div></div>"
						+ "</div>";
			}

		}

		htmlStr = htmlStr + "</div>";
		$("#table1").html(htmlStr);
		
		//
		// other UI layout
		//
		
		// show/hide all buttons
		if(gShowHideAll)
		{
			$('#showHideAllDiv').show();			
		}
		else
		{
			$('#showHideAllDiv').hide();
		}

		// show/hide tap buttons
		if(gShowTap)
		{
			$('.clickButton').show();			
		}
		else
		{
			$('.clickButton').hide();
		}

		// show/hide answers
		if(gShowAnswers)
		{
			$('.calcValue').show();			
		}
		else
		{
			$('.calcValue').hide();
		}

		hideClickAll();

	}

	// toggle value for the rowNum
	function showHide(rowNum)
	{
		$('#calcValue' + rowNum).toggle();
	}

	// show all values for the table
	function showClickAll()
	{
		$('.calcValue').show();
	}

	// hide all values for the table
	function hideClickAll()
	{
		if(!gShowAnswers)
		{
			$('.calcValue').hide();			
		}
	}

	// utility function to convert operator type to html based operator string
	function convertOperatorTypeToString(operatorType)
	{
		var strOperatorType = operatorType;
		
		if (operatorType == '+')
		{
			strOperatorType = '+';
		}
		else if (operatorType == '*')
		{
			strOperatorType = '&times;';
		}
		else if (operatorType == '/')
		{
			strOperatorType = '&divide;';
		}
		else if (operatorType == '-')
		{
			strOperatorType = '-';
		}
		
		return strOperatorType;
	}
	
</script>

<link type="text/css" href="common_style.css" rel="stylesheet">
<link type="text/css" href="table_comp.css" rel="stylesheet">

</head>

<body>

	<script type="text/javascript">
		var admob_vars = {
			pubid : 'a14e7e374628b8b', // publisher id
			bgcolor : 'C62919', // background color (hex)
			text : 'FFFFFF', // font-color (hex)
			test : false
		// test mode, set to false to receive live ads
		};
	</script>
	<script type="text/javascript" src="http://mmv.admob.com/static/iphone/iadmob.js"></script>

	<div class="separator1"></div>

	<div id="table1" class="pageClass"></div>

	<div style='display: table; width: 100%'>
		<div style='display: table-row'>
			<div style='display: table-cell; width: 20%' onTouchStart="changeNumber(1)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">1</div>
			</div>
			<div style='display: table-cell; width: 20%' onTouchStart="changeNumber(2)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">2</div>
			</div>
			<div style='display: table-cell; width: 20%' onTouchStart="changeNumber(3)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">3</div>
			</div>
			<div style='display: table-cell; width: 20%' onTouchStart="changeNumber(4)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">4</div>
			</div>
			<div style='display: table-cell; width: 20%' onTouchStart="changeNumber(5)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">5</div>
			</div>
		</div>
		<div style='display: table-row'>
			<div style='display: table-cell; width: 20%'>&nbsp;</div>
			<div style='display: table-cell; width: 20%'></div>
			<div style='display: table-cell; width: 20%'></div>
			<div style='display: table-cell; width: 20%'></div>
			<div style='display: table-cell; width: 20%'></div>
		</div>
		<div style='display: table-row'>
			<div style='display: table-cell; width: 20%' onTouchStart="changeNumber(6)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">6</div>
			</div>
			<div style='display: table-cell; width: 20%' onTouchStart="changeNumber(7)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">7</div>
			</div>
			<div style='display: table-cell; width: 20%' onTouchStart="changeNumber(8)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">8</div>
			</div>
			<div style='display: table-cell; width: 20%' onTouchStart="changeNumber(9)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">9</div>
			</div>
			<div style='display: table-cell; width: 20%;' onTouchStart="changeNumber(10)" onClick='kb_stopEventProgress()'>
				<div class="numberButton">10</div>
			</div>
		</div>
	</div>

	<div class="separator1"></div>

	<div id='showHideAllDiv' style='display: none; width: 100%'>
		<div style='display: table-row'>
			<div style='display: table-cell; width: 10%'></div>
			<div style='display: table-cell; width: 40%; text-align: center;'>
				<input type="button" value="Show All" onTouchStart="showClickAll()" onClick='kb_stopEventProgress()'>
			</div>
			<div style='display: table-cell; width: 40%; text-align: center;'>
				<input type="button" value="Hide All" onTouchStart="hideClickAll()" onClick='kb_stopEventProgress()'>
			</div>
			<div style='display: table-cell; width: 10%'></div>
		</div>
	</div>

</body>
</html>
