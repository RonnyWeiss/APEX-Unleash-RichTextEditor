var unleashRTE = (function () {
    "use strict";
    var scriptVersion = "2.0.2";
    var util = {
        version: "1.2.5",
        isAPEX: function () {
            if (typeof (apex) !== 'undefined') {
                return true;
            } else {
                return false;
            }
        },
        debug: {
            info: function (str) {
                if (util.isAPEX()) {
                    apex.debug.info(str);
                }
            },
            error: function (str) {
                if (util.isAPEX()) {
                    apex.debug.error(str);
                } else {
                    console.error(str);
                }
            }
        },
        escapeHTML: function (str) {
            if (str === null) {
                return null;
            }
            if (typeof str === "undefined") {
                return;
            }
            if (typeof str === "object") {
                try {
                    str = JSON.stringify(str);
                } catch (e) {
                    /*do nothing */
                }
            }
            if (util.isAPEX()) {
                return apex.util.escapeHTML(String(str));
            } else {
                str = String(str);
                return str
                    .replace(/&/g, "&amp;")
                    .replace(/</g, "&lt;")
                    .replace(/>/g, "&gt;")
                    .replace(/"/g, "&quot;")
                    .replace(/'/g, "&#x27;")
                    .replace(/\//g, "&#x2F;");
            }
        },
        unEscapeHTML: function (str) {
            if (str === null) {
                return null;
            }
            if (typeof str === "undefined") {
                return;
            }
            if (typeof str === "object") {
                try {
                    str = JSON.stringify(str);
                } catch (e) {
                    /*do nothing */
                }
            }
            str = String(str);
            return str
                .replace(/&amp;/g, "&")
                .replace(/&lt;/g, ">")
                .replace(/&gt;/g, ">")
                .replace(/&quot;/g, "\"")
                .replace(/#x27;/g, "'")
                .replace(/&#x2F;/g, "\\");
        },
        loader: {
            start: function (id) {
                if (util.isAPEX()) {
                    apex.util.showSpinner($(id));
                } else {
                    /* define loader */
                    var faLoader = $("<span></span>");
                    faLoader.attr("id", "loader" + id);
                    faLoader.addClass("ct-loader");

                    /* define refresh icon with animation */
                    var faRefresh = $("<i></i>");
                    faRefresh.addClass("fa fa-refresh fa-2x fa-anim-spin");
                    faRefresh.css("background", "rgba(121,121,121,0.6)");
                    faRefresh.css("border-radius", "100%");
                    faRefresh.css("padding", "15px");
                    faRefresh.css("color", "white");

                    /* append loader */
                    faLoader.append(faRefresh);
                    $(id).append(faLoader);
                }
            },
            stop: function (id) {
                $(id + " > .u-Processing").remove();
                $(id + " > .ct-loader").remove();
            }
        },
        jsonSaveExtend: function (srcConfig, targetConfig) {
            var finalConfig = {};
            var tmpJSON = {};
            /* try to parse config json when string or just set */
            if (typeof targetConfig === 'string') {
                try {
                    tmpJSON = JSON.parse(targetConfig);
                } catch (e) {
                    console.error("Error while try to parse targetConfig. Please check your Config JSON. Standard Config will be used.");
                    console.error(e);
                    console.error(targetConfig);
                }
            } else {
                tmpJSON = targetConfig;
            }
            /* try to merge with standard if any attribute is missing */
            try {
                finalConfig = $.extend(true, srcConfig, tmpJSON);
            } catch (e) {
                console.error('Error while try to merge 2 JSONs into standard JSON if any attribute is missing. Please check your Config JSON. Standard Config will be used.');
                console.error(e);
                finalConfig = srcConfig;
                console.error(finalConfig);
            }
            return finalConfig;
        },
        splitString2Array: function (pString) {
            if (util.isAPEX() && apex.server && apex.server.chunk) {
                return apex.server.chunk(pString);
            } else {
                /* apex.server.chunk only avail on APEX 18.2+ */
                var splitSize = 8000;
                var tmpSplit;
                var retArr = [];
                if (pString.length > splitSize) {
                    for (retArr = [], tmpSplit = 0; tmpSplit < pString.length;) retArr.push(pString.substr(tmpSplit, splitSize)), tmpSplit += splitSize;
                    return retArr
                }
                retArr.push(pString);
                return retArr;
            }
        }
    };

    /***********************************************************************
     **
     ** Used to cleanup image src before rte is saved
     **
     ***********************************************************************/
    function cleanUpImageSrc(pEditor, pOpts) {
        try {
            var div = $("<div></div>");
            div[0].innerHTML = pEditor.getData();
            div.find('img[alt*="aih#"]').attr("src", "aih");
            return div[0].innerHTML;
        } catch (e) {
            util.debug.error("Error while try to cleanup image source in dynamic added images in richtexteditor.");
            util.debug.error(e);
        }
    }

    /***********************************************************************
     **
     ** Used to cleanup image src before rte is saved
     **
     ***********************************************************************/
    function updateUpImageSrc(pEditor, pOpts, pCon) {
        var div = $("<div></div>");
        var items2SubmitImgDown = pOpts.items2SubmitImgDown;

        try {
            div.html(pCon);
            var imgItems = div.find('img[alt*="aih#"]');
            $.each(imgItems, function (idx, imgItem) {
                if (imgItem.title) {
                    var pk = imgItem.title;
                    var imgSRC = apex.server.pluginUrl(pOpts.ajaxID, {
                        x01: "PRINT_IMAGE",
                        x02: pk,
                        pageItems: items2SubmitImgDown
                    });
                    imgItem.src = imgSRC;
                } else {
                    util.debug.error("img in richtexteditor has no title. Title is used a primary key to get image from db.")
                }
            });

            /* force sub elements not to break out of the region*/
            div
                .find("img")
                .css("max-width", "100%")
                .css("object-fit", "contain")
                .css("object-position", "50% 0%");

            if (div[0].innerHTML) {
                util.debug.info({
                    "final_editor_html_on_load": div[0].innerHTML
                });
                pEditor.insertHtml(div[0].innerHTML, 'unfiltered_html');
                util.debug.info({
                    "final_editor_on_load": pEditor
                });

            }
            addEventHandler(pEditor, pOpts);
        } catch (e) {
            util.debug.error("Error while try to load images when loading rich text editor.");
            util.debug.error(e);
        }
    }

    /***********************************************************************
     **
     ** Used to add new image with download uri to rte
     **
     ***********************************************************************/
    function addImage(pFileName, pPK, pOpts, pImageSettings) {
        try {
            if (pPK) {
                var items2SubmitImgDown = pOpts.items2SubmitImgDown;
                var figured = $("<figure></figure>");
                figured.css("text-align", "center");
                figured.addClass("image")

                var img = $("<img>");
                img.attr("alt", "aih#" + pFileName);
                img.attr("title", pPK);

                try {
                    if (pImageSettings.ratio < 1) {
                        if (pImageSettings.height < pOpts.imgWidth) {
                            img.attr("width", pImageSettings.width);
                            img.attr("height", pImageSettings.height);
                        } else {
                            img.attr("height", Math.floor(pOpts.imgWidth));
                            img.attr("width", Math.floor(pOpts.imgWidth * pImageSettings.ratio));
                        }
                    } else {
                        if (pImageSettings.width < pOpts.imgWidth) {
                            img.attr("width", pImageSettings.width);
                            img.attr("height", pImageSettings.height);
                        } else {
                            img.attr("width", Math.floor(pOpts.imgWidth));
                            img.attr("height", Math.floor(pOpts.imgWidth / pImageSettings.ratio));
                        }
                    }
                } catch (e) {
                    util.debug.error("Error while try to calculate image width and height.");
                    util.debug.error(e);
                }

                var imgSRC = apex.server.pluginUrl(pOpts.ajaxID, {
                    x01: "PRINT_IMAGE",
                    x02: pPK,
                    pageItems: items2SubmitImgDown
                });

                img.attr("src", imgSRC);
                figured.append(img);

                var figCaption = $("<figcaption></figcaption>");
                figCaption.text(pFileName);
                figured.append(figCaption);

                return figured;

            } else {
                util.debug.error("No primary key set for images please, so image could not be added to RTE. Please check PL/SQL Block if out parameter is set.");
            }
        } catch (e) {
            util.debug.error("Error while try to add images into richtexteditor with binary sources.");
            util.debug.error(e);
        }
    }


    /***********************************************************************
     **
     ** Used to upload a new image 
     **
     ***********************************************************************/
    function uploadFiles(pFiles, pEditor, pOpts) {
        var items2SubmitImgUp = pOpts.items2SubmitImgUp;

        if (!pFiles || pFiles.length === 0) return;

        if (pOpts.showLoader) {
            util.loader.start(pOpts.affElementDIV);
        }

        try {
            var fileIDX = 1;
            var div = $("<div></div>");

            for (var i = 0; i < pFiles.length; i++) {
                if (pFiles[i].type.indexOf("image") !== -1) {
                    var file = pFiles[i];
                    util.debug.info(file);
                    var reader = new FileReader();

                    reader.onloadend = (function (pFile) {
                        return function (pEvent) {
                            var base64Str = btoa(pEvent.target.result);
                            var base64Arr = util.splitString2Array(base64Str);

                            var image = new Image();
                            image.src = "data:" + file.type + ";base64," + base64Str;

                            image.onload = function () {
                                var imageSettings = {};
                                imageSettings.ratio = this.width / this.height;
                                imageSettings.width = this.width;
                                imageSettings.height = this.height;

                                util.debug.info("Start upload of " + pFile.name + " (" + pFile.type + ")");
                                apex.server.plugin(pOpts.ajaxID, {
                                    x01: "UPLOAD_IMAGE",
                                    x02: pFile.name,
                                    x03: pFile.type,
                                    f01: base64Arr,
                                    pageItems: items2SubmitImgUp
                                }, {
                                    success: function (pData) {
                                        util.debug.info("Upload of " + pFile.name + " successful.");

                                        div.append("< p > & nbsp; < /p>");
                                        div.append(addImage(pFile.name, pData.pk, pOpts, imageSettings));
                                        if (fileIDX == pFiles.length) {
                                            div.append("<p>&nbsp;</p>");
                                            pEditor.insertHtml(div.html());
                                            util.loader.stop(pOpts.affElementDIV);
                                        }
                                        fileIDX++;
                                        apex.event.trigger(pOpts.affElementID, 'imageuploadifnished');
                                    },
                                    error: function (jqXHR, textStatus, errorThrown) {
                                        util.debug.info("Upload error.");
                                        util.debug.error(jqXHR);
                                        util.debug.error(textStatus);
                                        util.debug.error(errorThrown);
                                        util.loader.stop(pOpts.affElementDIV);
                                        apex.event.trigger(pOpts.affElementID, 'imageuploaderror');
                                    }
                                });
                            };
                        }

                    })(file);
                    reader.readAsBinaryString(file);

                } else if (fileIDX == pFiles.length) {
                    util.loader.stop(pOpts.affElementDIV);
                    fileIDX++;
                }
            }
        } catch (e) {
            util.debug.error("Error while try to add images to to db after drop or paste image");
            util.debug.error(e);
        }
    }

    /***********************************************************************
     **
     ** Used to add event handler for drag and paste
     **
     ***********************************************************************/
    function addEventHandler(pEditor, pOpts) {
        try {
            /* on drop image */
            pEditor.document.on('drop', function (e) {
                e.data.preventDefault(true);
                e.cancel();
                e.stop();
                util.debug.info({
                    "file_droped": e
                });
                var dt = e.data.$.dataTransfer;
                uploadFiles(dt.files, pEditor, pOpts);
            });

            /* on pate image e.g. Screenshot */
            pEditor.on("paste", function (e) {
                if (e.data.dataTransfer._.files && e.data.dataTransfer._.files.length > 0) {
                    util.debug.info({
                        "file_pasted": e
                    });

                    var files = [];
                    files.push(e.data.dataTransfer._.files[0]);
                    e.stop();
                    e.cancel();
                    uploadFiles(files, pEditor, pOpts);
                }
            });
        } catch (e) {
            util.debug.error("Error while try to paste drop or pasted content in RTE");
            util.debug.error(e);
        }
    }

    /***********************************************************************
     **
     ** Used to sanitize HTML
     **
     ***********************************************************************/
    function sanitizeCLOB(pCLOB, pOpts) {
        return DOMPurify.sanitize(pCLOB, pOpts.sanitizeOptions);
    }

    /***********************************************************************
     **
     ** Used to print the clob value to the elements that are in data json
     **
     ***********************************************************************/
    function printClob(pThis, pData, pOpts) {
        try {
            var str;

            if (pData && pData.row && pData.row[0] && pData.row[0].CLOB_VALUE) {
                str = pData.row[0].CLOB_VALUE;
            }

            if (!pOpts.sanitize) {
                str = str;
            } else {
                str = sanitizeCLOB(str, pOpts);
            }

            if (pOpts.escapeHTML) {
                str = util.escapeHTML(str);
            }
            var affCKE = CKEDITOR.instances[pOpts.affElement];
            util.debug.info({
                "editor": affCKE
            });

            function startIt() {
                updateUpImageSrc(affCKE, pOpts, str);
                util.loader.stop(pOpts.affElementDIV);
                apex.event.trigger(pOpts.affElementID, 'clobloadfinished');
                apex.da.resume(pThis.resumeCallback, false);
                affCKE.on('contentDom', function () {
                    addEventHandler(affCKE, pOpts);
                });
            }

            if (affCKE.instanceReady === true) {
                startIt();
                util.debug.info("start instance was ready");
            } else {
                affCKE.on('instanceReady', function () {
                    startIt();
                    util.debug.info("start on instance ready");
                });
            }

        } catch (e) {
            util.debug.error("Error while render CLOB");
            util.debug.error(e);
            apex.event.trigger(pOpts.affElementID, 'clobloaderror');
            apex.da.resume(pThis.resumeCallback, true);
        }
    }

    /***********************************************************************
     **
     ** Used to upload the clob value from an item to database
     **
     ***********************************************************************/
    function uploadClob(pThis, pOpts) {
        var clob = cleanUpImageSrc(CKEDITOR.instances[pOpts.affElement], pOpts);

        if (pOpts.unEscapeHTML) {
            clob = util.unEscapeHTML(clob);
        }

        if (pOpts.sanitize) {
            clob = sanitizeCLOB(clob, pOpts);
        }

        var chunkArr = util.splitString2Array(clob);

        var items2Submit = pOpts.items2Submit;
        apex.server.plugin(pOpts.ajaxID, {
            x01: "UPLOAD_CLOB",
            f01: chunkArr,
            pageItems: items2Submit
        }, {
            dataType: "text",
            success: function (pData) {
                util.loader.stop(pOpts.affElementDIV);
                util.debug.info("Upload successful.");
                apex.event.trigger(pOpts.affElementID, 'clobsavefinished');
                apex.da.resume(pThis.resumeCallback, false);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                util.loader.stop(pOpts.affElementDIV);
                util.debug.info("Upload error.");
                util.debug.error(jqXHR);
                util.debug.error(textStatus);
                util.debug.error(errorThrown);
                apex.event.trigger(pOpts.affElementID, 'clobsaveerror');
                apex.da.resume(pThis.resumeCallback, true);
            }
        });
    }

    /***********************************************************************
     **
     ** Init
     **
     ***********************************************************************/
    return {
        initialize: function (pThis, pOpts) {

            util.debug.info(pOpts);

            var opts = pOpts;

            var defaultSanitizeOptions = {
                "ALLOWED_ATTR": ["accesskey", "align", "alt", "always", "autocomplete", "autoplay", "border", "cellpadding", "cellspacing", "charset", "class", "dir", "height", "href", "id", "lang", "name", "rel", "required", "src", "style", "summary", "tabindex", "target", "title", "type", "value", "width"],
                "ALLOWED_TAGS": ["a", "address", "b", "blockquote", "br", "caption", "code", "dd", "div", "dl", "dt", "em", "figcaption", "figure", "h1", "h2", "h3", "h4", "h5", "h6", "hr", "i", "img", "label", "li", "nl", "ol", "p", "pre", "s", "span", "strike", "strong", "sub", "sup", "table", "tbody", "td", "th", "thead", "tr", "u", "ul"]
            };

            opts.imgWidth = opts.imgWidth || 700;

            /* merge user defined sanitize options */
            opts.sanitizeOptions = util.jsonSaveExtend(defaultSanitizeOptions, pOpts.sanitizeOptions);

            /* Transfrom Yes/No Select List to Boolean */
            if (opts.sanitize == "N") {
                opts.sanitize = false;
            } else {
                opts.sanitize = true;
            }

            if (opts.escapeHTML == "N") {
                opts.escapeHTML = false;

            } else {
                opts.escapeHTML = true;
            }

            if (opts.unEscapeHTML == "N") {
                opts.unEscapeHTML = false;

            } else {
                opts.unEscapeHTML = true;
            }

            if (opts.showLoader == 'Y') {
                opts.showLoader = true;
            } else {
                opts.showLoader = false;
            }

            if (opts.useImageUploader == 'Y') {
                opts.useImageUploader = true;
            } else {
                opts.useImageUploader = false;
            }

            if (pThis.affectedElements[0]) {
                opts.affElement = $(pThis.affectedElements[0]).attr("id");
                opts.affElementDIV = "#" + $(pThis.affectedElements[0]).attr("id") + "_CONTAINER";
                opts.affElementID = "#" + $(pThis.affectedElements[0]).attr("id");

                /* show loader when set */
                if (opts.showLoader) {
                    util.loader.start(opts.affElementDIV)
                }

                /***********************************************************************
                 **
                 ** Used to get clob data when in print mode
                 **
                 ***********************************************************************/
                if (opts.functionType == 'RENDER') {
                    var items2Submit = opts.items2Submit;
                    apex.server.plugin(
                        opts.ajaxID, {
                            x01: "PRINT_CLOB",
                            pageItems: items2Submit
                        }, {
                            success: function (pData) {
                                printClob(pThis, pData, opts);
                            },
                            error: function (d) {
                                util.debug.error(d.responseText);
                            },
                            dataType: "json"
                        });
                } else {
                    uploadClob(pThis, opts);
                }
            }
        }
    }
})();
