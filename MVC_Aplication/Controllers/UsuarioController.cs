using MVC_Aplication.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MVC_Aplication.Controllers
{
    public class UsuarioController : Controller
    {
        RVDESAEntities db = new RVDESAEntities();
        // GET: Usuario
        public ActionResult Index()
        {
            return View(db.SYS_USUARIO.ToList<SYS_USUARIO>());
        }

        // GET: Usuario/Details/5
        public ActionResult Details(int id)
        {
            var query = (from A in db.SYS_USUARIO where A.PK_ID_SYS_USUARIO == id select A).Single();

            return View((SYS_USUARIO)query);
        }

        // GET: Usuario/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Usuario/Create
        [HttpPost]
        public ActionResult Create([Bind(Exclude = "PK_ID_SYS_USUARIO")] SYS_USUARIO ObjUsuario)
        {
            try
            {
                if (ModelState.IsValid) {
                    return View();
                }
                db.Entry(ObjUsuario).State = EntityState.Added;

                db.SaveChanges();
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Usuario/Edit/5
        public ActionResult Edit(int id)
        {
            var query = (from A in db.SYS_USUARIO where A.PK_ID_SYS_USUARIO == id select A).Single();

            return View((SYS_USUARIO)query);
        }

        // POST: Usuario/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, SYS_USUARIO ObjUsuario)
        {
            try
            {
                // TODO: Add update logic here
                if (!ModelState.IsValid) {
                    return View();
                }
                db.Entry(ObjUsuario).State = EntityState.Modified;
                db.SaveChanges();

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Usuario/Delete/5
        public ActionResult Delete(int id)
        {
            var query = (from A in db.SYS_USUARIO where A.PK_ID_SYS_USUARIO == id select A).Single();

            return View((SYS_USUARIO)query);
        }

        // POST: Usuario/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, SYS_USUARIO objUsuario)
        {
            try
            {
                var query = (from A in db.SYS_USUARIO where A.PK_ID_SYS_USUARIO == id select A).Single();
                // TODO: Add delete logic here
                objUsuario = (SYS_USUARIO)query;
                db.Entry(objUsuario).State = EntityState.Deleted;
                db.SaveChanges();

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
