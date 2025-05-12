01 // До: прямий виклик методу
02 public class RemoteControl {
03     private Light light;
04 
05     public RemoteControl(Light light) {
06         this.light = light;
07     }
08 
09     public void pressButton() {
10         light.on();  // Пряма залежність
11     }
12 }
13 
14 // Після: використання патерна Command
15 public class LightOnCommand implements Command {
16     private Light light;
17     public LightOnCommand(Light light) { this.light = light; }
18     public void execute() { light.on(); }
19 }
20 
21 public class RemoteControl {
22     private Command command;
23     public RemoteControl(Command command) {
24         this.command = command;
25     }
26     public void pressButton() {
27         command.execute();  // Гнучкість
28     }
29 }
30 
31 // До: пряма взаємодія
32 public class ShutdownManager {
33     private Computer computer;
34 
35     public ShutdownManager(Computer computer) {
36         this.computer = computer;
37     }
38 
39     public void shutdown() {
40         computer.turnOff();  // Жорстке зв’язування
41     }
42 }
43 
44 // Після: інкапсульована команда
45 public class ShutdownCommand implements Command {
46     private Computer computer;
47     public ShutdownCommand(Computer computer) { this.computer = computer; }
48     public void execute() { computer.turnOff(); }
49 }
50 
51 public class ShutdownManager {
52     private Command command;
53     public ShutdownManager(Command command) {
54         this.command = command;
55     }
56     public void shutdown() {
57         command.execute();  // Гнучкість і масштабованість
58     }
59 }
60 
61 // Приклад інтерфейсу команди
62 public interface Command {
63     void execute();
64 }
65 
66 public class LightOnCommand implements Command {
67     private Light light;
68     public LightOnCommand(Light light) { this.light = light; }
69     public void execute() { light.on(); }
70 }
