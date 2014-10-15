public class WM_Helpers {

  public static String getFormattedStartTime (Assignment__c assignment) {
    DateTime t = assignment.Start_Time_Site_Local__c;
    if (t != null) {
      return t.format('yyyy/MM/dd hh:mm a');
    }
    return null;
  }

  public static String getFormattedEndTime (Assignment__c assignment) {
    DateTime t = assignment.End_Time_Site_Local__c;
    if (t != null) {
      return t.format('yyyy/MM/dd hh:mm a');
    }
    return null;
  }

  public static Map<String, String> addPricingParams(Assignment__c assignment, Map<String, String> params) {
    if (assignment.Pricing_Type__c.equalsIgnoreCase('Flat Rate')) {
      params.put('pricing_type', 'flat');
      params.put('pricing_flat_price', String.valueOf(assignment.Rate__c));
    } else if (assignment.Pricing_Type__c.equalsIgnoreCase('Hourly')) {
      params.put('pricing_type', 'per_hour');
      params.put('pricing_per_hour_price', String.valueOf(assignment.Rate__c));
      params.put('pricing_max_number_of_hours', String.valueOf(assignment.Max_Hours_Units__c));
    } else if (assignment.Pricing_Type__c.equalsIgnoreCase('Dual Rate Hourly')) {
      params.put('pricing_type', 'blended_per_hour');
      params.put('pricing_initial_per_hour_price', String.valueOf(assignment.Rate__c));
      params.put('pricing_additional_per_hour_price', String.valueOf(assignment.Secondary_Rate__c));
      params.put('pricing_initial_number_of_hours', String.valueOf(assignment.Max_Hours_Units__c));
      params.put('pricing_max_blended_number_of_hours', String.valueOf(assignment.Max_Hours_Secondary_Rate__c));
    } else if (assignment.Pricing_Type__c.equalsIgnoreCase('Per Unit')) {
      params.put('pricing_type', 'per_unit');
      params.put('pricing_per_unit_price', String.valueOf(assignment.Rate__c));
      params.put('pricing_max_number_of_units', String.valueOf(assignment.Max_Hours_Units__c));
    }

    return params;
  }

  public static Map<String, String> addLocationParams(Assignment__c assignment, Map<String, String> params) {
    params.put('location_address1', assignment.Address_1__c);
    params.put('location_address2', assignment.Address_2__c);
    params.put('location_city', assignment.City__c);
    params.put('location_state', assignment.State_Province_Region__c);
    params.put('location_zip', assignment.Postal_Code__c);
    params.put('location_country', assignment.Country__c);

    return params;
  }
}
