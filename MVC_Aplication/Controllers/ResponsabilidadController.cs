using MVC_Aplication.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MVC_Aplication.Controllers
{
    public class ResponsabilidadController : Controller
    {
        RVDESAEntities rv = new RVDESAEntities();
        // GET: Responsabilidad
        public ActionResult Index()
        {
            return View();
        }

        // GET: Responsabilidad/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: Responsabilidad/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Responsabilidad/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Responsabilidad/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Responsabilidad/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Responsabilidad/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Responsabilidad/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
