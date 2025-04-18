// До: прямий виклик методу

public class RemoteControl {
    private Light light;

    public RemoteControl(Light light) {
        this.light = light;
    }

    public void pressButton() {
        light.on();  // Пряма залежність
    }
}

// Після: використання патерна Command

public class LightOnCommand implements Command {
    private Light light;
    public LightOnCommand(Light light) { this.light = light; }
    public void execute() { light.on(); }
}

public class RemoteControl {
    private Command command;
    public RemoteControl(Command command) {
        this.command = command;
    }
    public void pressButton() {
        command.execute();  // Гнучкість
    }
}

// До: пряма взаємодія

public class ShutdownManager {
    private Computer computer;

    public ShutdownManager(Computer computer) {
        this.computer = computer;
    }

    public void shutdown() {
        computer.turnOff();  // Жорстке зв’язування
    }
}

// Після: інкапсульована команда
public class ShutdownCommand implements Command {
    private Computer computer;
    public ShutdownCommand(Computer computer) { this.computer = computer; }
    public void execute() { computer.turnOff(); }
}

public class ShutdownManager {
    private Command command;
    public ShutdownManager(Command command) {
        this.command = command;
    }
    public void shutdown() {
        command.execute();  // Гнучкість і масштабованість
    }
}

// Приклад коду (наприклад Java)

public interface Command {
    void execute();
}

public class LightOnCommand implements Command {
    private Light light;
    public LightOnCommand(Light light) { this.light = light; }
    public void execute() { light.on(); }
}

