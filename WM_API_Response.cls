public class WM_API_Response {

	public Meta meta;
	public Response response;

	public class Resource_send_results {
		public List<String> COMPANY_LOCKED;
		public List<String> SUCCESSFUL;
		public List<String> INSUFFICIENT_FUNDS;
		public List<String> FAILED;
	}

	public class Response {
		public Boolean successful;
		public String id;
		public Resource_send_results resource_send_results;
		public Integer number_of_resources_sent;
		public String access_token;
	}

	public class Meta {
		public List<Errors> errors;
		public Integer status_code;
		public Integer version;
		public Double execution_time;
		public Integer timestamp;
	}

	public class Errors {
		public String message;
		public String code;
	}

	public static WM_API_Response parse(String json) {
		return (WM_API_Response) System.JSON.deserialize(json, WM_API_Response.class);
	}
}
