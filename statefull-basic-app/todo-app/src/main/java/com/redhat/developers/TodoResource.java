package com.redhat.developers;

import java.util.List;


import javax.transaction.Transactional;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/todo")
public class TodoResource {

    @ConfigProperty(name = "destination")
    public String destination;

    @GET
    @Path("/{id}")
    public Todo getTodoById(@PathParam("id") Long id) {
        return Todo.findById(id);
    }

    @GET
    @Path("/destination")
    @Produces(MediaType.TEXT_PLAIN)
    public String getDestination() {
        return destination;
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Todo> todos(@QueryParam("name") String name) {
        if (name != null) {
            return Todo.findByName(name);
        }
        return Todo.listAll();
    }

    @Transactional
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response newTodo(Todo todo) {
        todo.id = null;
        todo.persist();
        return Response.status(Status.CREATED).entity(todo).build();
    }

    @Transactional
    @DELETE
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteTask(@PathParam("id") Long id) {
      Todo todo = Todo.findById(id);
      if (todo == null) {
        return Response.status(Status.NOT_FOUND).build();
      }
      todo.delete();
      return Response.status(Status.NO_CONTENT).build();
    }
    


}