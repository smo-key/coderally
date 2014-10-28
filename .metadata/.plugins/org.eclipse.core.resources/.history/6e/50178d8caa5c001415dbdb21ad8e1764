package com.ibm.coderally.agent;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ibm.coderally.api.agent.AbstractCarListenerAgentAI;
import com.ibm.coderally.autonomous.AutonomousRequestHandler;

/**
 * AgentLauncher Servlet - Handles requests from the Eclipse Workbench and instructs the agent to enter a race 
 * 
 * Do not modify this file. 
 * To regenerate it, delete this file and restart the workbench. 
 * 
 */
@WebServlet("/AgentLauncher")
public class AgentLauncher extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AgentLauncher() {
        super();
    }    

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		final String action = request.getParameter("action");		

//		System.out.println("--------------------------------------------------------------");
//		System.out.println("agentClass:"+agentClass);
//		System.out.println("uuid:"+uuid);
//		System.out.println("target uri:"+uri);		
		
		try {
			if(action.equalsIgnoreCase("autonomousAgentRequest")) {
				
				String result = AutonomousRequestHandler.getInstance().handleRequest(request.getParameter("json"));
				if(result != null) {
					// Some requests return JSON responses
					response.setContentType("application/json");
					response.getWriter().write(result);
				}
				
				return;
				
			} 

			final String uri = request.getParameter("uri");
			final String uuid = request.getParameter("uuid");
			final String agentClass = request.getParameter("agent_class"); 

			final URI remoteUri = new URI(uri+"/WSAgentEndpoint");
			final Class<?> clazz = Class.forName(agentClass);
			final AbstractCarListenerAgentAI agent = (AbstractCarListenerAgentAI)clazz.newInstance();
			

			
			if(action.equalsIgnoreCase("runRace")) {
				Thread t = new Thread() {
					@Override
					public void run() {
						Racer.registerAndRunRace(remoteUri, agent, uuid);
					}
				};
				
				t.start();
			} else if(action.equalsIgnoreCase("updateCheck")) {
				Racer.updateExistingAgent(remoteUri, agent, uuid);
				
			} else if(action.equalsIgnoreCase("status")) {
				response.getOutputStream().write("OK".getBytes());
			}
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.flush();
		
	}

}
