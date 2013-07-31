function kb_stopEventProgress()
{
    return false;	
}
 
function getRandomCounterArray(numCount)
{
    var origArray = [];
    for(i=0; i<numCount; i++)
    {
    	origArray.push("-1");
    }
    
    var newArray = new Array();

    for(i=0; i<origArray.length; i++)
    {
        var randNum = Math.round(numCount*Math.random());

        if(randNum == numCount) randNum = (numCount - 1); // as we have index form 0 to numCount - 1 

        if(origArray[randNum] == "-1")
        {
            newArray.push(randNum+1);
            origArray[randNum] = "0";
        }
        else
        {
            for(j=0; j<origArray.length; j++)
            {
                if(origArray[j] == "-1")
                {
                    newArray.push(j+1);
                    origArray[j] = "0";
                    break;
                }
            }
        }
    }

    // do manual jumble
    var retArray = new Array();
    while(newArray.length > 0)
    {
        retArray.push(newArray.pop());
        retArray.push(newArray.shift());
    }

    return retArray;
}

function kb_getScreenWidth()
{
	return document.documentElement.clientWidth;
}

function kb_getScreenHeight()
{
	return document.documentElement.clientHeight;	
}

function highlightItem(element)
{
	if (element == null)
	{
		return;
	}
	
	element.style.backgroundImage = "-webkit-gradient(linear, left top, left bottom,from(rgb(72,181,204)),color-stop(0.55, rgb(0,137,225)) ,to(rgb(22,156,235)))";
	element.style.color = "white";
}

function disHighlightItem(element)
{
	if (element == null)
	{
		return;
	}
	
	if (element.nodeName == "INPUT" || element.nodeName == "BUTTON"
			|| element.nodeName == "TR")
	{
		element.style.backgroundImage = "-webkit-gradient(linear, left top, left bottom,from(rgb(255,255,255)),color-stop(0.5, rgb(221,221,221)),to(rgb(255,255,255)))";

		element.style.color = "#333333";
		return;
	}
	else if (element.nodeName == "DIV" || element.nodeName == "TD"
			|| element.nodeName == "TABLE")
	{
		element.style.backgroundImage = "-webkit-gradient(linear, left top, left bottom, from(rgb(255,255,255)),color-stop(0.49, rgb(233,233,233)),color-stop(0.5, rgb(221,221,221)), to(rgb(243,243,243)))";
		element.style.color = "#333333";
	}
	else if (element.nodeName == "A")
	{
		element.style.backgroundImage = "-webkit-gradient(linear, left top, left bottom,from(rgb(255,255,255)), to(rgb(255,255,255)))";
		element.style.color = "blue";
	}
	else if (element.id == "validSchedule")
	{
		element.style.backgroundImage = "";
	}
}