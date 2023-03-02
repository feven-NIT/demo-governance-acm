package com.redhat.developers;

import java.util.List;

import javax.ws.rs.Produces;
import javax.persistence.Entity;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.MediaType;

import org.eclipse.microprofile.config.inject.ConfigProperty;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

@Entity
public class Todo extends PanacheEntity {
    
    public String name;

    public String task;

    public static List<Todo> findByName(String name) {
        return find("name", name).list();
    }


}