import com.ibm.coderally.api.AIUtils;
import com.ibm.coderally.api.DefaultCarAI;
import com.ibm.coderally.entity.cars.Car;
import com.ibm.coderally.entity.obstacle.Obstacle;
import com.ibm.coderally.geo.CheckPoint;

public class Iondefault extends DefaultCarAI {

	public Iondefault() {
	}
	
	@Override
	public void onRaceStart() {
		// Provide custom logic or remove method for default implementation.		

		getCar().setBrakePercent(0);
		getCar().setTarget(AIUtils.getClosestLane(getCar().getCheckpoint(), getCar().getPosition()));
		getCar().setAccelerationPercent(100);
	}

	@Override
	public void onCheckpointUpdated(CheckPoint oldCheckpoint) {
		// Provide custom logic or remove method for default implementation.		
		
		getCar().setTarget(AIUtils.getClosestLane(getCar().getCheckpoint(), getCar().getPosition()));
		getCar().setBrakePercent(0);
		getCar().setAccelerationPercent(100);
	}
	
	@Override
	public void onOffTrack() {
		// Provide custom logic or remove method for default implementation.		

	}

	@Override
	public void onCarCollision(Car other) {
		// Provide custom logic or remove method for default implementation.		

	}

	@Override
	public void onOpponentInProximity(Car car) {
		// Provide custom logic or remove method for default implementation.		

	}


	@Override
	public void onObstacleInProximity(Obstacle obstacle) {
		// Provide custom logic or remove method for default implementation.		

	}

	
	@Override
	public void onTimeStep() {
		// Provide custom logic or remove method for default implementation.		

		getCar().setBrakePercent(0);
		getCar().setAccelerationPercent(100);
	}
	
}
