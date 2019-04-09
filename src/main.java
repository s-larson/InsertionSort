import java.util.Random;

public class main {

	public static void main(String arg[]) {
		int[] data = new int[100];
		for(int i = 0; i < 100; i++) {
			Random r = new Random();
			data[i] = r.nextInt(100);
		}
		print(data);
		sort(data);
		print(data);
	}
	public static void sort(int[] array) {
		System.out.println("......Sorting.......");
		for(int i = 1; i < array.length; i++) {
			int x = array[i];
			int j =i-1;
			while(j >= 0 && array[j] > x) {
				array[j+1] = array[j];
				j = j-1;
			}
			array[j+1] = x;
		}
	}
	public static void print(int[] array) {
		System.out.println("......Printing.......");
		for(int i = 0; i < array.length; i ++) {
			System.out.println("Pos: "+i+" :"+array[i]);
		}
	}
}
