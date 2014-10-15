public class WM_Custom_Field_Set {
	public class Field {
		public Field(Integer theId, String theValue) {
			id = theId;
			value = theValue;
		}

		public Integer id;
		public String name;
		public Boolean required;
		public String value;
	}

	public WM_Custom_Field_Set(Integer theId, Integer theIndex) {
		id = theId;
		index = theIndex;
		fields = new List<Field>();
	}

	public void addField(Integer theId, String theValue) {
		fields.add(new Field(theId, theValue));
	}

	public Integer id;
	public Integer index;
	public String name;
	public List<Field> fields;

	public static WM_Custom_Field_Set parse(String json) {
		return (WM_Custom_Field_Set) System.JSON.deserialize(json, WM_Custom_Field_Set.class);
	}

	public Map<String, String> addToParamsList(Map<String, String> params) {
		params.put('custom_field_groups[' + index + '][id]', String.valueOf(id));
		Integer i = 0;
		for (Field field : fields) {
			params.put('custom_field_groups[' + index + '][fields][' + i + '][id]', String.valueOf(field.id));
			params.put('custom_field_groups[' + index + '][fields][' + i + '][value]', field.value);
			i++;
		}

		return params;
	}
}
