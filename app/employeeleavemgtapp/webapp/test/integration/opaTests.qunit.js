sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'employeeleavemgtapp/test/integration/FirstJourney',
		'employeeleavemgtapp/test/integration/pages/EmployeesList',
		'employeeleavemgtapp/test/integration/pages/EmployeesObjectPage'
    ],
    function(JourneyRunner, opaJourney, EmployeesList, EmployeesObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('employeeleavemgtapp') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheEmployeesList: EmployeesList,
					onTheEmployeesObjectPage: EmployeesObjectPage
                }
            },
            opaJourney.run
        );
    }
);