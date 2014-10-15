public class WM_API_Client {

  /*
   * Get a WM access token, to be included with any WM API request
   */
  public static String getAccessToken(String ownerEmail) {

    String accessToken;
    WM_API_Response apiResponse = null;
    Http http = new Http();
    HttpRequest authTokenReq = new HttpRequest();
    HttpResponse authTokenRes;
    authTokenReq.setEndpoint(Label.WM_API_URL + '/authorization/request');
    authTokenReq.setMethod('POST');
    authTokenReq.setBody('token=' + Label.WM_API_Token + '&secret=' + Label.WM_API_Secret);

    // Get token
    try {
      authTokenRes = http.send(authTokenReq);
      String response = authTokenRes.getBody();
      System.debug(response);
      apiResponse = WM_API_Response.parse(response);
    } catch (System.CalloutException e) {
      System.debug('Callout error: ' + e + ' response: ' + authTokenRes.toString());
    }

    if (apiResponse.meta.errors != null) {
      System.debug(apiResponse.meta.errors);
      return null;
    }

    return apiResponse.response.access_token;
  }

  @future(callout = true)
  public static void createAssignment(Map < String, String > params, String sfAssignmentName) {

    String accessToken = getAccessToken(params.get('owner_email'));
    String workMarketId = null;
    String create_url = Label.WM_API_URL + '/assignments/create';
    WM_API_Response apiResponse = null;
    String paramsStr = 'access_token=' + accessToken;

    for (String fieldName: params.keySet()) {
      if (params.get(fieldName) != null) {
        paramsStr += '&' + fieldName + '=' + EncodingUtil.urlEncode(params.get(fieldName), 'UTF-8');
      } else {
        System.debug('NULL FOR FIELD in params: ' + fieldName);
      }
    }

    System.debug('Create call parameters: ' + paramsStr);

    // Creating assignment
    Http http = new Http();
    HttpRequest createAssignmentReq = new HttpRequest();
    HttpResponse createAssignmentRes;

    try {
      createAssignmentReq.setEndpoint(create_url);
      createAssignmentReq.setMethod('POST');
      createAssignmentReq.setBody(paramsStr);
      createAssignmentRes = http.send(createAssignmentReq);
      String response = createAssignmentRes.getBody();
      System.debug(response);
      apiResponse = WM_API_Response.parse(response);
    } catch (System.CalloutException e) {
      System.debug('Callout exception: ' + e + ' response: ' + createAssignmentRes.getBody());
    }

    // Adding workmarket id to the SF object
    // NOTE we will do it only if that SF object previously didn't not have id assigned
    if (apiResponse.response.id != null) {
      Assignment__c assignment = [SELECT Name, Assignment_ID__c FROM Assignment__c where Name = :sfAssignmentName];

      if (assignment != null && assignment.Assignment_ID__c == null && assignment.Name == sfAssignmentName) {
        System.debug('Updating assignment: ' + sfAssignmentName + ' setting WM ID to: ' + apiResponse.response.id);
        assignment.Assignment_ID__c = apiResponse.response.id;

        try {
          update assignment;
        } catch (DmlException e) {

          for (Integer i = 0; i < e.getNumDml(); i++) {
            // Process exception here
            System.debug(e.getDmlMessage(i));
          }
        }
      } else {
        System.debug('Can not set workMarketId: ' + apiResponse.response.id + ' for assignment with name: ' + sfAssignmentName);
      }
    } else {
      System.debug(apiResponse.meta.errors);
    }
  }

  public static void sendErrorEmail(String ownerEmail, String subject, String body) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String[] toAddresses = new String[] { Label.WM_API_Error_Email };
    mail.setToAddresses(toAddresses);

    mail.setSubject(subject);
    mail.setHtmlBody(body);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
  }
}
