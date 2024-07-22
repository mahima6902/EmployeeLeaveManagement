using app.emp_leave as el from '../db/elm';


// Table - A  Employee_Details
//@odata.draft.enabled
annotate el.Employees with @(UI: {
    CreateHidden : false,
    DeleteHidden : false,
    UpdateHidden : false,
    HeaderInfo                 : {
        TypeName      : 'Employee',
        TypeNamePlural: 'Employees',
        Title         : {Value: firstname},
        Description   : {Value: lastname}
    },

    SelectionFields            : [
        employeeid,
        firstname,
        lastname,
        department
    ],

    LineItem                   : [
        {
            Value: employeeid,
            Label: 'Employee ID'
        },
        {
            Value: firstname,
            Label: 'First Name'
        },
        {
            Value: lastname,
            Label: 'Last Name'
        },
        {
            Value: email,
            Label: 'Email'
        },
        {
            Value: department,
            Label: 'Department'
        },
        {
            Value: position,
            Label: 'Position'
        },
        {
            Value: joiningdate,
            Label: 'Joining Date'
        }
    ],

    Facets                     : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Employee Details',
            Target: '@UI.FieldGroup#EmployeeDetails'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Leave Balances',
            Target: 'leaveBalances/@UI.LineItem'
        }
    ],

    FieldGroup #EmployeeDetails: {Data: [
        {
            Value: employeeid,
            Label: 'Employee ID'
        },
        {
            Value: firstname,
            Label: 'First Name'
        },
        {
            Value: lastname,
            Label: 'Last Name'
        },
        {
            Value: email,
            Label: 'Email'
        },
        {
            Value: department,
            Label: 'Department'
        },
        {
            Value: position,
            Label: 'Position'
        },
        {
            Value: joiningdate,
            Label: 'Joining Date'
        }
    ]}
});


// Table - B  Leave_Details
//@odata.draft.enabled
annotate el.LeaveTypes with @(UI: {
    CreateHidden : false,
    DeleteHidden : false,
    UpdateHidden : false,
    HeaderInfo                  : {
        TypeName      : 'Leave Type',
        TypeNamePlural: 'Leave Types',
        Title         : {Value: name},
        Description   : {Value: description}
    },

    SelectionFields             : [
        leavetypeid,
        name
    ],

    LineItem                    : [
        {
            Value: leavetypeid,
            Label: 'Leave Type ID'
        },
        {
            Value: name,
            Label: 'Name'
        },
        {
            Value: description,
            Label: 'Description'
        },
        {
            Value: daysallowed,
            Label: 'Days Allowed'
        }
    ],

    Facets                      : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Leave Type Details',
        Target: '@UI.FieldGroup#nameDetails'
    },

    {
        $Type : 'UI.ReferenceFacet',
        Label : 'Leave Type Details',
        Target: '@UI.FieldGroup#LeaveTypeDetails'
    }
    ],

    FieldGroup #nameDetails: {Data: [
        {
            Value: leavetypeid,
            Label: 'Leave Type ID'
        },
        {
            Value: name,
            Label: 'Name'
        },
    ]
    },
    FieldGroup #LeaveTypeDetails: {Data: [
        {
            Value: leavetypeid,
            Label: 'Leave Type ID'
        },
        {
            Value: description,
            Label: 'Description'
        },
        {
            Value: daysallowed,
            Label: 'Days Allowed'
        }
    ]}
});


// Table - C  Balance_Details
annotate el.LeaveBalances with @(UI: {
    CreateHidden : false,
    DeleteHidden : false,
    UpdateHidden : false,
    HeaderInfo                     : {
        TypeName      : 'Leave Balance',
        TypeNamePlural: 'Leave Balances',
        Title         : {Value: leavetype.name},
        Description   : {Value: employee.firstname}
    },

    LineItem                       : [
        {
            Value: employee.employeeid,
            Label: 'Employee ID'
        },
        {
            Value: leavetype.name,
            Label: 'Leave Type'
        },
        {
            Value: totaldays,
            Label: 'Total Days'
        },
        {
            Value: useddays,
            Label: 'Used Days'
        },
        {
            Value: remainingdays,
            Label: 'Remaining Days'
        }
    ],

    Facets                         : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Leave Balance Details',
        Target: '@UI.FieldGroup#LeaveBalanceDetails'
    },

    {
        $Type : 'UI.ReferenceFacet',
        Label : 'Leave Balance Details',
        Target: '@UI.FieldGroup#DaysDetails'
    }
    ],

    FieldGroup #LeaveBalanceDetails: {Data: [
        {
            Value: employee.employeeid,
            Label: 'Employee ID'
        },
        {
            Value: leavetype.name,
            Label: 'Leave Type'
        }
    ]
    },
    FieldGroup #DaysDetails: {Data: [
        {
            Value: totaldays,
            Label: 'Total Days'
        },
        {
            Value: useddays,
            Label: 'Used Days'
        },
        {
            Value: remainingdays,
            Label: 'Remaining Days'
        }
    ]}
});


// Table - D  Request_Details
annotate el.LeaveRequests with @(UI: {
    CreateHidden : false,
    DeleteHidden : false,
    UpdateHidden : false,
    HeaderInfo                     : {
        TypeName      : 'Leave Request',
        TypeNamePlural: 'Leave Requests',
        Title         : {Value: employee.firstname},
        Description   : {Value: leavetype.name}
    },

    SelectionFields                : [
        employee.employeeid,
        leavetype.leavetypeid,
        startdate,
        enddate,
        status
    ],

    LineItem                       : [
        {
            Value: employee.employeeid,
            Label: 'Employee ID'
        },
        {
            Value: leavetype.name,
            Label: 'Leave Type'
        },
        {
            Value: startdate,
            Label: 'Start Date'
        },
        {
            Value: enddate,
            Label: 'End Date'
        },
        {
            Value: status,
            Label: 'Status'
        }
    ],

    Facets                         : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Leave Request Details',
        Target: '@UI.FieldGroup#LeaveRequestDetails'
    },

    {
        $Type : 'UI.ReferenceFacet',
        Label : 'Leave Request Details',
        Target: '@UI.FieldGroup#statusDetails'
    }], 

    FieldGroup #LeaveRequestDetails: {Data: [
        {
            Value: employee.employeeid,
            Label: 'Employee ID'
        },
        {
            Value: leavetype.name,
            Label: 'Leave Type'
        },
        {
            Value: approver.employeeid,
            Label: 'Approver ID'
        }
    ]
    },
    FieldGroup #statusDetails: {Data: [
        {
            Value: startdate,
            Label: 'Start Date'
        },
        {
            Value: enddate,
            Label: 'End Date'
        },
        {
            Value: reason,
            Label: 'Reason'
        },
        {
            Value: status,
            Label: 'Status'
        }
    ]}
});