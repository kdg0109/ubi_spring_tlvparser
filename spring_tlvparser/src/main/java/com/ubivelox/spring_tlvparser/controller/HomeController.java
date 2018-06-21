package com.ubivelox.spring_tlvparser.controller;

import java.util.ArrayList;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.ubivelox.gaia.GaiaException;
import com.ubivelox.gaia.util.GaiaUtils;

import exception.UbiveloxException;
import tlvparser.TLVObject;
import tlvparser.TLVParser;
import tlvparser.TLVParserWithArrayList;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController
{

    private static final Logger logger = LoggerFactory.getLogger(HomeController.class);





    @RequestMapping(method = RequestMethod.POST,
                    value = "/convert")
    public String input(final HttpServletRequest request, final ModelMap modelMap) throws UbiveloxException, GaiaException
    {
        GaiaUtils.checkHexaString(request.getParameter("HexaString"));
        modelMap.addAttribute("HexaString", request.getParameter("HexaString"));
        modelMap.addAttribute("Result", TLVParser.parse(request.getParameter("HexaString")));

        return "input_view";
    }





    @RequestMapping(method = RequestMethod.POST,
                    value = "/convert2")
    public String input2(final HttpServletRequest request, final ModelMap modelMap) throws UbiveloxException, GaiaException
    {
        GaiaUtils.checkHexaString(request.getParameter("HexaString"));

        String hexString = request.getParameter("HexaString");

        byte[] byteArray = GaiaUtils.convertHexaStringToByteArray(hexString);

        ArrayList<TLVObject> tlvList = TLVParserWithArrayList.parse1(hexString, byteArray, 0, -1);

        modelMap.addAttribute("TlvList", tlvList);
        modelMap.addAttribute("HexaString", request.getParameter("HexaString"));

        return "input_view2";
    }





    /**
     * Simply selects the home view to render by returning its name.
     */
    @RequestMapping(value = "/",
                    method = RequestMethod.GET)
    public String home(final Locale locale, final Model model)
    {
        logger.info("Input View {}.", locale);

        return "input_view";
    }

}
