/***************************/
//@Author: Adrian "yEnS" Mato Gondelle
//@website: www.yensdesign.com
//@email: yensamg@gmail.com
//@license: Feel free to use it, but keep this credits please!					
/** ************************ */

// Assumptions
// div exists with name #backgroundPopup
// div exists with name #loadingPopup
// css exists with name loadingWhitePopup clsLoadingPopupBk (used for white background)
// css exists with loadingWhitePopupLandscape clsLoadingPopupBk (used for white background)

// SETTING UP OUR POPUP
// 0 means disabled; 1 means enabled;
var GLOBAL_DIV_popupStatus = 0;
var GLOBAL_DIV_CONTENTDIV = "";
var GLOBAL_DIV_isWhiteBk = 0;
var GLOBAL_PREV_ASPECT_RATIO = 0;
var lockedScreen = false;

// loading popup with jQuery magic!
function loadPopup(contentDiv, bkDiv)
{
	// loads popup only if it is disabled
	initialPopup(contentDiv, bkDiv);
	centerPopup(contentDiv);
}

function lockScreen(e)
{
	e.preventDefault();
	e.stopPropagation();
}

// disabling popup with jQuery magic!
function disablePopup(contentDiv, bkDiv)
{
	var bkDivId = "#" + bkDiv;
	var contentDivId = "#" + contentDiv;
	
	// disables popup only if it is enabled
	if (GLOBAL_DIV_popupStatus == 1)
	{
		if (lockedScreen)
		{
			document.removeEventListener('touchmove', lockScreen, false);
			lockedScreen = false;
		}
		if (GLOBAL_DIV_isWhiteBk == 1)
		{
			GLOBAL_DIV_isWhiteBk = 0;
			$(contentDivId).hide();
		}
		else
		{
			$(bkDivId).fadeOut("slow");
			$(contentDivId).fadeOut("slow");
		}
		GLOBAL_DIV_popupStatus = 0;
	}
}

// centering popup
function centerPopup(contentDiv)
{
	var contentDivId = "#" + contentDiv;
	// request data for centering
	var windowWidth = kb_getScreenWidth();
	var windowHeight = kb_getScreenHeight();
	console.log("w width " + windowWidth + " w height " + windowHeight);

	// change css base on portait or landscape
	var iWidth = parseInt(windowWidth);
	var iHeight = parseInt(windowHeight);
	var cssName = contentDiv;
	if (iWidth > iHeight)
	{
		cssName = contentDiv + "Landscape";
	}

	if ("loadingPopup" == contentDiv)
	{
		cssName += " clsLoadingPopupBk";
	}
	document.getElementById(contentDiv).className = cssName;
	// centering
	var popupHeight = $(contentDivId).height();
	var popupWidth = $(contentDivId).width();
	console.log("popup width " + popupWidth + " height " + popupHeight);
	console.log("i width " + iWidth + " i height " + iHeight);
	var topPosition = 0;
	if (lockedScreen)
	{
		document.removeEventListener('touchmove', lockScreen, false);
		lockedScreen = false;
	}

	var h = window.innerHeight;
	var outerHeight = $(contentDivId).outerHeight();
	// centering
	$(contentDivId).hide();
	if (outerHeight > h)
	{
		topPosition = window.pageYOffset + (h / 8);
		$(contentDivId).css({
			"position" : 'absolute',
			"top" : topPosition,
			"left" : (iWidth - popupWidth) / 2
		});
	}
	else
	{
		topPosition = (h - outerHeight) / 2;
		$(contentDivId).css({
			"position" : 'fixed',
			"top" : topPosition,
			"left" : (iWidth - popupWidth) / 2
		});
		document.addEventListener('touchmove', lockScreen, false);
		lockedScreen = true;
	}
	$(contentDivId).show();
}

function initialPopup(contentDiv, bkDiv)
{
	var contentDivId = "#" + contentDiv;
	var bkDivId = "#" + bkDiv;
	if (GLOBAL_DIV_popupStatus == 0)
	{
		$(bkDivId).show();
		$(contentDivId).show();
		$(bkDivId).css({
			"opacity" : "0.7"
		});
		$(bkDivId).fadeIn("slow");
		$(contentDivId).fadeIn("slow");
		GLOBAL_DIV_popupStatus = 1;
		GLOBAL_DIV_CONTENTDIV = contentDiv;
	}
}

function initialPopupForBk(contentDiv, bkDiv)
{
	var contentDivId = "#" + contentDiv;
	var bkDivId = "#" + bkDiv;
	if (GLOBAL_DIV_popupStatus == 0)
	{
		$(bkDivId).hide();
		$(contentDivId).show();
		GLOBAL_DIV_popupStatus = 1;
		GLOBAL_DIV_CONTENTDIV = contentDiv;
	}
}

function loadPopupForBk(contentDiv, bkDiv, topOfBk, heightofBk)
{
	// loads popup only if it is disabled
	GLOBAL_DIV_isWhiteBk = 1;
	initialPopupForBk(contentDiv, bkDiv);
	centerPopupForBk(contentDiv, topOfBk, heightofBk);
}

// centering popup
function centerPopupForBk(contentDiv, topOfBk, heightofBk)
{

	$("#backgroundPopup").css({
		"top" : topOfBk,
		"height" : heightofBk
	});

	var contentDivId = "#" + contentDiv;
	// request data for centering
	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = heightofBk;
	// change css base on portait or landscape
	var iWidth = parseInt(windowWidth);
	var iHeight = parseInt(windowHeight);
	var cssName = "loadingWhitePopup clsLoadingPopupBk";
	if (iWidth > iHeight)
	{
		cssName = "loadingWhitePopupLandscape clsLoadingPopupBk";
	}
	document.getElementById(contentDiv).className = cssName;
	// centering
	var popupHeight = $(contentDivId).height();
	var popupWidth = $(contentDivId).width();
	var topPosition = topOfBk + (windowHeight - popupHeight) / 2;
	// centering
	$(contentDivId).css({
		"position" : "absolute",
		"top" : topPosition,
		"left" : (windowWidth - popupWidth) / 2
	});
}

function setBackgroundPopup(contentDiv)
{
	var screenHeight = document.getElementById(contentDiv).scrollHeight;
	$("#backgroundPopup").css({
		"height" : screenHeight
	});
}

function loadPopupWithMessage(messageDiv, message)
{
    var contentDiv = "loadingPopupWithMessage";
    var bkDiv = "backgroundPopup";
    messageDiv = '#' + messageDiv;
    if(!message)
    {
        message = "";
    }

    $(messageDiv).html(message);
    loadPopup(contentDiv, bkDiv);
}


function disablePopupWithMessage()
{
    var contentDiv = "loadingPopupWithMessage";
    var bkDiv = "backgroundPopup";
    disablePopup(contentDiv, bkDiv);
}

//
// assumption that there is div/css included as part of your html page
//
// #popupTitle:   title of the popup. optional. if not present, then title is not shown
// #popupMessage: main message shown for the popup.
// #oneButtonDiv: when there is only 1 button to show
// #twoButtonDiv: when there are 2 buttons to show
//
// pjson has following attributes:
//
// title: title for the popup
// message: message to show in the popup
// firstButtonText, secondButtonText: text to show in first and second button respectively
// firstButtonAction, secondButtonAction: action to take for first and second button respectively
//
function showPopupBox(pjson)
{
	var title      = pjson && pjson.title;
	var msg        = pjson && pjson.message;
	var fbText     = pjson && pjson.firstButtonText;
	var fbAction   = pjson && pjson.firstButtonAction;
	var sbText     = pjson && pjson.secondButtonText;
	var sbAction   = pjson && pjson.secondButtonAction;
	
	if(title)
    {
        $('#popupTitle').html(title);
        $('#popupTitle').show();
    }
    else
    {
        $('#popupTitle').hide();
    }

    $('#popupMessage').html(msg);

    if(sbText)
    {
       $('#twoButtonDiv').show();
       $('#oneButtonDiv').hide();
       $('#firstButtonDiv').html(fbText);
       $('#firstButtonDiv').click(fbAction);
       $('#secondButtonDiv').html(sbText);
       $('#secondButtonDiv').click(sbAction);
    }
    else
    {
       $('#twoButtonDiv').hide();
       $('#oneButtonDiv').show();
       $('#onlyButtonDiv').html(fbText);
       $('#onlyButtonDiv').click(fbAction);
    }

    loadPopup('generalPopup', 'backgroundPopup');
}

function hidePopupBox()
{
    disablePopup('generalPopup', 'backgroundPopup');
}

