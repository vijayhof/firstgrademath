<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE HTML>
<html manifest='/firstgrademath/manifest.jsp'>
<%
	//
	// What is the maximum number for tables. Could be 5, 10, 15, 20
	//
	String maxNum = request.getParameter("maxnum");
	if (maxNum == null || maxNum.equals("")) {
		maxNum = "10";
	}

	//
	// What is the number questions.
	//
	String numQuestions = request.getParameter("numquestions");
	if (numQuestions == null || numQuestions.equals("")) {
		numQuestions = "10";
	}

	//
	// What is the maximum number for tables. Could be 5, 10, 15, 20
	//
	String isFixedFirstNum = request.getParameter("isfixedfirstnumber");
	if (isFixedFirstNum == null || isFixedFirstNum.equals("")) {
		isFixedFirstNum = "0";
	}

	//
	// What is the operation type for tables. Could be 5, 10, 15, 20
	//
	String opType = request.getParameter("opType");
	if (opType == null || opType.equals("")) {
		opType = "";
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
	var gNumQuestions = <%=numQuestions%>;
	var gOpType = '<%=opType%>';	
	var gIsFixedFirstNum = <%=isFixedFirstNum%>;
	var gShowJumble = <%=showJumble%>;
	
</script>

<script type="text/javascript" charset="utf-8" src="common_function.js"></script>
<script type="text/javascript" charset="utf-8" src="popup.js"></script>

<script>

    var firstNumbers = new Array();
    var secondNumbers = new Array();
    var operatorArr = new Array();
    var answersArr = new Array();
    var rightOrWrong = new Array();

    $(document).ready(function(){
        //console.log("***********************************in ready");
        document.addEventListener("deviceready", onDeviceReady, false);
        onDeviceReady();
    });
 
    function onDeviceReady() 
    {
        //console.log("***********************************in onDeviceReady");
        initMethod();
    }
    
    function getCounter()
    {
        return parseInt(localStorage.getItem("flashCardCounter"));
    }

    function setCounter(counter)
    {
        localStorage.setItem("flashCardCounter", counter);
    }

    function incrementCounter()
    {
        setCounter(getCounter() + 1);
    }

    function initMethod()
    {
    	initQuestionAnswerData();
        setCounter(0);
        showQuestion();
    }

	function initQuestionAnswerData()
	{
		if(gIsFixedFirstNum)
		{
	        var randomArray;
			if(gShowJumble)
			{
				randomArray = getRandomCounterArray(gNumQuestions);
			}

			var fixedFirstNumber = Math.round(gMaxNum*Math.random());
	        for(i=0; i <gNumQuestions; i++)
	        {
	        	firstNumbers[i] = fixedFirstNumber;
	        	if(gShowJumble)
	        	{
	        		secondNumbers[i] = randomArray[i];
	        	}
	        	else
	        	{
	        		secondNumbers[i] = i + 1;
	        	}
	        }
		}
		else
		{
        	for(i=0; i <gNumQuestions; i++)
        	{
            	firstNumbers[i] = Math.round(gMaxNum*Math.random());
            	secondNumbers[i] = Math.round(gMaxNum*Math.random());
        	}
		}
		
        for(i=0; i <gNumQuestions; i++)
        {
        	rightOrWrong[i] = 1; // means right
        	operatorArr[i] = calcOperatorType();
        	answersArr[i] = "";

        	// switch big and small numbers for subtraction
        	if(operatorArr[i] == '-')
        	{
            	if(firstNumbers[i] < secondNumbers[i])
            	{
                	var tmpNum = secondNumbers[i];
                	secondNumbers[i] = firstNumbers[i];
                	firstNumbers[i] = tmpNum;
            	}
        	}

       		// switch big and small numbers for division
        	if(operatorArr[i] == '/')
        	{
            	firstNumbers[i] = secondNumbers[i]*Math.round(gMaxNum*Math.random());
        	}
        }
	}

	function changeOperatorType(opType)
    {
          gOpType = opType;
          initMethod();
    }

    function calcOperatorType()
    {
        var opType = gOpType;

        if(opType == null || opType == '')
        {
            var tmpNum = Math.random();
            if(tmpNum >= 0 && tmpNum < 0.25)         return "+";
            else if(tmpNum >= 0.25 && tmpNum < 0.50) return "-";
            else if(tmpNum >= 0.50 && tmpNum < 0.75) return "*";
            else if(tmpNum >= 0.75 && tmpNum <= 1)   return "/";
            else                                     return "+";
        }

        return opType;
    }

    function clickEnter()
    {
        if(checkAnswer())
        {
            incrementCounter();
            //console.log("counter="+getCounter());
            //console.log("gNumQuestions="+gNumQuestions);
            if(getCounter() >= gNumQuestions)
            {
                console.log("You are done");
                var retArr = computeRightOrWrong();
                var okMethod = function(){hidePopupBox(); initMethod();}; 
                var cancelMethod = function() {hidePopupBox();console.log("hey1");history.back();console.log("hey2");};
                showScore(gNumQuestions, retArr[0], okMethod, cancelMethod);
                //if(confirm("You are done.\nCorrect Answers: " + retArr[0] + " out of " + gNumQuestions + "\n\nDo you want to continue?"))
                //{
                    // start over again
                 //   initMethod();                	
                //}
                //else
                //{
                	// go back
                	//history.back();
                //}
            }
            else
            {
                showQuestion();
            }
          }
          else
          {
                $('#answerValue').addClass('wrongAnswer');
                rightOrWrong[getCounter()] = 0;
                answersArr[getCounter()] = '';
          }
    }

    function computeRightOrWrong()
    {
        var wrongAnswer = 0;
        var rightAnswer = gNumQuestions;
        for(i=0; i< gNumQuestions;i++)
        {
            if(rightOrWrong[i] == 0)
            {
                wrongAnswer += 1;
                rightAnswer -= 1;
            }
        }

        return new Array(rightAnswer, wrongAnswer);
    }

    function clickClear()
    {
        answersArr[getCounter()] = "";
        $('#answerValue').html('&nbsp;');
    }

    function checkAnswer()
    {
        var currentOperation = operatorArr[getCounter()];
        //console.log("operatorArr[getCounter()]=" + operatorArr[getCounter()]);
        //console.log("firstNumbers[getCounter()]=" + firstNumbers[getCounter()]);
        //console.log("secondNumbers[getCounter()]=" + secondNumbers[getCounter()]);
        //console.log("answersArr[getCounter()]=" + answersArr[getCounter()]);
        var correctAnswer;

        if(currentOperation == '+')
        {
            correctAnswer = firstNumbers[getCounter()] + secondNumbers[getCounter()];
        }
        else if(currentOperation == '-')
        {
            correctAnswer = firstNumbers[getCounter()] - secondNumbers[getCounter()];
        }
        else if(currentOperation == '*')
        {
            correctAnswer = firstNumbers[getCounter()] * secondNumbers[getCounter()];
        }
        else if(currentOperation == '/')
        {
            correctAnswer = firstNumbers[getCounter()] / secondNumbers[getCounter()];
        }

        if(correctAnswer == answersArr[getCounter()])
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    function clickNumber(newNumber)
    {
        $('#answerValue').removeClass('wrongAnswer');
        answersArr[getCounter()] += new String(newNumber);
        $('#answerValue').html(answersArr[getCounter()]);
        return false;
    }

    function showQuestion()
    {
        var counter = getCounter();
        $('#firstNumber').html(firstNumbers[counter]);
        $('#secondNumber').html(secondNumbers[counter]);
        if(operatorArr[counter] == '*')
        {
            $('#operatorType').html('&times;');
        }
        else if(operatorArr[counter] == '/')
        {
            $('#operatorType').html('&divide;');
        }
        else
        {
            $('#operatorType').html(operatorArr[counter] );
        }
        $('#answerValue').html('&nbsp;');
    }

    function showScore(totalQuestions, correctAnswers, okCallback, cancelCallback)
    {
      var json = new Object();
      json.title = "Done!";
      json.message = correctAnswers + " out of " + totalQuestions + " right.<br><br>Do another one?";
      json.firstButtonText = "Yes";
      json.firstButtonAction = okCallback;
      json.secondButtonText = "No";
      json.secondButtonAction = cancelCallback;

      showPopupBox(json);
    }

    
</script>

<link type="text/css" href="common_style.css" rel="stylesheet">
<link type="text/css" href="flash_cards.css" rel="stylesheet">
<link type="text/css" href="popup.css" rel="stylesheet">

</head>

<body style='background-color: #effaff;'>

	<script type="text/javascript">
		var admob_vars = {
					 		pubid: 'a14e7e374628b8b', // publisher id
 							bgcolor: 'C62919', // background color (hex)
 							text: 'FFFFFF', // font-color (hex)
 							test: false // test mode, set to false to receive live ads
						 };
	</script>
	<script type="text/javascript" src="http://mmv.admob.com/static/iphone/iadmob.js"></script>

	<div class="separator1"></div>

	<div style='display: table; width: 100%;' class='questionTable'>
		<div style='display: table-row; width: 100%'>
			<div id='firstNumber' style='display: table-cell; width: 33%; text-align: right;'></div>
			<div id='operatorType' style='display: table-cell; width: 34%; text-align: center;'></div>
			<div id='secondNumber' style='display: table-cell; width: 33%; text-align: left;'></div>
		</div>
	</div>

	<div style='display: table; width: 100%'>
		<div style='display: table-row; width: 100%'>
			<div style='display: table-cell; width: 100%'>
				<div id="answerValue" class="calcLikeButton" style='width: 100%'>&nbsp;</div>
			</div>
		</div>
	</div>

	<div style='display: table; width: 100%'>
		<div style='display: table-row; width: 100%'>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(1)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">1</div>
			</div>
			<div style='display: table-cell; width: 5%'></div>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(2)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">2</div>
			</div>
			<div style='display: table-cell; width: 5%'></div>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(3)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">3</div>
			</div>
		</div>
		<div style='display: table-row'>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(4)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">4</div>
			</div>
			<div style='display: table-cell; width: 5%'></div>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(5)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">5</div>
			</div>
			<div style='display: table-cell; width: 5%'></div>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(6)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">6</div>
			</div>
		</div>
		<div style='display: table-row'>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(7)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">7</div>
			</div>
			<div style='display: table-cell; width: 5%'></div>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(8)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">8</div>
			</div>
			<div style='display: table-cell; width: 5%'></div>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(9)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">9</div>
			</div>
		</div>
		<div style='display: table-row'>
			<div style='display: table-cell; width: 30%'>
				<div class="calcLikeButton" onTouchStart='clickClear()' onClick='kb_stopEventProgress()'>Clear</div>
			</div>
			<div style='display: table-cell; width: 5%'></div>
			<div style='display: table-cell; width: 30%' onTouchStart="clickNumber(0)" onClick="kb_stopEventProgress()">
				<div class="calcLikeButton">0</div>
			</div>
			<div style='display: table-cell; width: 5%'></div>
			<div style='display: table-cell; width: 30%'>
				<div class="calcLikeButton" onTouchStart='clickEnter()' onClick='kb_stopEventProgress()'>Enter</div>
			</div>
		</div>

	</div>

	<div class="separator1"></div>

	<div id="generalPopup" class="generalPopup">

		<div id="generalpopupdiv" align="center">
			<div id="popupTitle" class="popupTitle">
			</div>

			<div class="popupMessageBg">
				<div id="popupMessage" class="popupMessage"></div>
			</div>
		</div>

		<div id="popbottomdivstyle" align="center" class="popbottomdivstyle">
			<div id="twoButtonDiv" class="twoButtonCls">
				<div style="display: table-cell; width: 50%; float: left;" align="left">
					<button type="button" id="firstButtonDiv" class="clsButton generalPopUpFirstButton" ontouchstart="highlightItem(this)" ontouchend="disHighlightItem(this)"></button>
				</div>
				<div style="display: table-cell; width: 50%; float: right;" align="right">
					<button type="button" id="secondButtonDiv" class="clsButton generalPopUpSecondButton" ontouchstart="highlightItem(this)" ontouchend="disHighlightItem(this)"></button>
				</div>
			</div>
			<div id="oneButtonDiv" class="oneButtonCls">
				<button type="button" id="onlyButtonDiv" class="clsButton generalPopUpOnlyButton" ontouchstart="highlightItem(this)" ontouchend="disHighlightItem(this)"></button>
			</div>
		</div>
	</div>

</html>
