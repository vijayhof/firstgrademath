var CM_TABLE_OF = "tableOf";
var CM_OPERATOR_TYPE = "operatorType";

function getTableOf()
{
	if (localStorage.getItem(CM_TABLE_OF))
	{
			return parseInt(localStorage.getItem(CM_TABLE_OF));
	}

	return DEFAULT_TABLE_OF;
}

function setTableOf(tableOf)
{
	localStorage.setItem(CM_TABLE_OF, tableOf);
}

function getOperatorType()
{
	if (localStorage.getItem(CM_TABLE_OF))
	{
		return localStorage.getItem(CM_OPERATOR_TYPE);		
	}
	
	return DEFAULT_OPERATOR_TYPE;
}

function setOperatorType(operatorType)
{
	localStorage.setItem(CM_OPERATOR_TYPE, operatorType);
}
