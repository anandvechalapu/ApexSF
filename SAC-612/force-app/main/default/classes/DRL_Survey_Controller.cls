public with sharing class DRL_Survey_Controller {
    public String domain { get; set; }
    public String title { get; set; }
    public String description { get; set; }
    public Integer delayTime { get; set; }
    public String status { get; set; }
    public String surveyState { get; set; }
    public String pageName { get; set; }
    public Date startDate { get; set; }
    public Date endDate { get; set; }
    public String targetUsers { get; set; }
    public String criteria { get; set; }
    public String specialty { get; set; }
    public String preferences { get; set; }
    public String country { get; set; }
    public String region { get; set; }
    public String city { get; set; }
    public List<User> selectedUsers { get; set; }
    public List<DRL_Question__c> questions { get; set; }
    public List<DRL_Question_Response__c> responses { get; set; }
    public List<DRL_User_Response__c> userResponses { get; set; }
    public List<User> responseUsers { get; set; }
    
    public DRL_Survey_Controller(){
        questions = new List<DRL_Question__c>();
        responses = new List<DRL_Question_Response__c>();
        userResponses = new List<DRL_User_Response__c>();
        responseUsers = new List<User>();
    }
    
    // Method to create a survey
    public void createSurvey(){
        DRL_Survey__c survey = new DRL_Survey__c();
        survey.Domain__c = domain;
        survey.Title__c = title;
        survey.Description__c = description;
        survey.Delay_Time__c = delayTime;
        survey.Status__c = status;
        survey.Survey_State__c = surveyState;
        survey.Page_Name__c = pageName;
        survey.Start_Date__c = startDate;
        survey.End_Date__c = endDate;
        survey.Target_Users__c = targetUsers;
        survey.Criteria__c = criteria;
        survey.Specialty__c = specialty;
        survey.Preferences__c = preferences;
        survey.Country__c = country;
        survey.Region__c = region;
        survey.City__c = city;
        insert survey;
        // Add questions to survey
        for(DRL_Question__c q: questions){
            q.DRL_Survey__c = survey.Id;
            insert q;
        }
        // Add user responses to survey
        if(targetUsers == 'Exclude Users'){
            List<User> users = [SELECT Id FROM User WHERE Id IN:selectedUsers];
            for(User u: users){
                DRL_User_Response__c userResponse = new DRL_User_Response__c();
                userResponse.DRL_Survey__c = survey.Id;
                userResponse.User__c = u.Id;
                insert userResponse;
            }
        }
    }
    
    // Method to get survey report
    public void getSurveyReport(){
        DRL_Survey__c survey = [SELECT Id FROM DRL_Survey__c WHERE Id = :survey.Id];
        // Get responses for each question
        List<DRL_Question_Response__c> questionResponses = [SELECT Id, DRL_Question__c, Answer_Value__c FROM DRL_Question_Response__c WHERE DRL_Survey__c = :survey.Id];
        // Get user responses
        List<DRL_User_Response__c> userResponses = [SELECT Id, User__c, DRL_Survey__c FROM DRL_User_Response__c WHERE DRL_Survey__c = :survey.Id];
        // Get user details
        List<User> userDetails = [SELECT Id, Name, Email, Phone, Speciality, IP_Address__c FROM User WHERE Id IN:userResponses];
        
        // Loop through each question
        for(DRL_Question__c q : questions){
            // Get answers for this question
            List<DRL_Question_Response__c