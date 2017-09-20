<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCUMENT html>
<html>
<head>
    <title>Currency Converter</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://code.angularjs.org/1.5.7/angular.min.js"></script>
    
</head>
<body ng-app="app">
   <div class="cont">
      <div ng-controller="ctrl" class="form-inline designForm design">
          
       <div class="input-group">
 	<span class="input-group-addon">Convert From :</span>
    <select ng-model="currencyIndex"  id="convertFrom" class="form-control col-md-8">
        <option value="PHP">Philippine Peso (PHP)</option>
        <option value="JPY">Japanese Yen (JPY)</option>
        <option value="USD">US Dollar (USD)</option>
        <option value="INR">Indian Rupee (INR)</option>
        <option value="GBP">Pound sterling (GBP)</option>
    </select>
 </div>
 <input type="text" ng-model="amount"  class="form-control" style="width:20% !important"/>
	
   

 <div class="input-group">
 	<span class="input-group-addon">Convert To :</span>
    <select ng-model="currencyIndexTo" id="convertTo" class="form-control col-md-8">
         <option value="PHP">Philippine Peso (PHP)</option>
        <option value="JPY">Japanese Yen (JPY)</option>
        <option value="USD">US Dollar (USD)</option>
        <option value="INR">Indian Rupee (INR)</option>
        <option value="GBP">Pound sterling (GBP)</option>
       
    </select>
 </div>
  <input type="text" value="{{ valueINR | inr }}" class="form-control" id="output" style="width:20% !important" disabled/> 
 	 
 	 </div>
</div>
<script type="javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script>
var app = angular.module("app",[]);

var selectedCurrency = document.getElementById("convertFrom");
var currency = selectedCurrency.options[selectedCurrency.selectedIndex].value;

var selectedCurrencyConversion = document.getElementById("convertTo");
var currency2 = selectedCurrencyConversion.options[selectedCurrencyConversion.selectedIndex].value;

console.log(currency + currency2);

app.controller('ctrl',function($scope,$http){
    $scope.amount = 1;
    $scope.currencyIndex = currency;
    
    $scope.currencyIndexTo = currency2;
    $scope.change = function(){	
        $http.get('http://api.fixer.io/latest?base='+$scope.currencyIndex).then(function(res){
        	var ratess = $scope.currencyIndexTo;
            if($scope.currencyIndex == $scope.currencyIndexTo)
                $scope.valueINR = parseFloat($scope.amount);
            else if($scope.currencyIndexTo == "JPY")
            	$scope.valueINR = parseFloat($scope.amount) * res.data.rates.JPY;
            else if($scope.currencyIndexTo == "USD")
            	$scope.valueINR = parseFloat($scope.amount) * res.data.rates.USD;
            else if($scope.currencyIndexTo == "PHP")
            	$scope.valueINR = parseFloat($scope.amount) * res.data.rates.PHP;
            else if($scope.currencyIndexTo == "INR")
            	$scope.valueINR = parseFloat($scope.amount) * res.data.rates.INR;
            else if($scope.currencyIndexTo == "GBP")
            	$scope.valueINR = parseFloat($scope.amount) * res.data.rates.GBP;
            
            
		
			console.log($scope.valueINR);
            console.log(res);
        });
    }
    $scope.$watch('currencyIndexTo',function(){ $scope.change(); });
    $scope.$watch('amount',function(){ $scope.change(); });
    $scope.$watch('currencyIndex',function(){ $scope.change(); });
});


app.filter('inr',function(){
    return function(val){
    return (val);
    };
});





</script>
</body>
</html>
	
	
	
	
<script type="javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"> </script>
</body>
</html>