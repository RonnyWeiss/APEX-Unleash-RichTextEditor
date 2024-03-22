const unleashTinyMCE = function (apex, $, domPurify) {
    "use strict";
    const util = {
        featureDetails: {
            name: "APEX Unleash RichTextEditor (TinyMCE)",
            scriptVersion: "24.03.22",
            utilVersion: "22.11.28",
            url: "https://github.com/RonnyWeiss",
            license: "MIT"
        },
        loader: {
            start: function (id, setMinHeight) {
                if (setMinHeight) {
                    $(id).css("min-height", "100px");
                }
                apex.util.showSpinner($(id));
            },
            stop: function (id, removeMinHeight) {
                if (removeMinHeight) {
                    $(id).css("min-height", "");
                }
                $(id + " > .u-Processing").remove();
                $(id + " > .ct-loader").remove();
            }
        },
        jsonSaveExtend: function (srcConfig, targetConfig) {
            let finalConfig = {};
            let tmpJSON = {};
            /* try to parse config json when string or just set */
            if (typeof targetConfig === "string") {
                try {
                    tmpJSON = JSON.parse(targetConfig);
                } catch (e) {
                    apex.debug.error({
                        "module": "util.js",
                        "msg": "Error while try to parse targetConfig. Please check your Config JSON. Standard Config will be used.",
                        "err": e,
                        "targetConfig": targetConfig
                    });
                }
            } else {
                tmpJSON = $.extend(true, {}, targetConfig);
            }
            /* try to merge with standard if any attribute is missing */
            try {
                finalConfig = $.extend(true, {}, srcConfig, tmpJSON);
            } catch (e) {
                finalConfig = $.extend(true, {}, srcConfig);
                apex.debug.error({
                    "module": "util.js",
                    "msg": "Error while try to merge 2 JSONs into standard JSON if any attribute is missing. Please check your Config JSON. Standard Config will be used.",
                    "err": e,
                    "finalConfig": finalConfig
                });
            }
            return finalConfig;
        },
    };

    const IMG_AIH_SEL = `img[alt*="aih#"]`,
        AIH_KEY = "aih##";

    // Used to cleanup image src before rte is saved
    function getStillExistingImages(pOpts) {
        let pkArr = [],
            div = $("<div>");

        div[0].innerHTML = pOpts.rteInstance.getContent();
        $.each(div.find(IMG_AIH_SEL), function (i, imgItem) {
            let pk = imgItem.title;
            if (!pk) {
                pk = imgItem.alt.split(AIH_KEY)[1];
            }
            pkArr.push(pk);
        });
        return pkArr;
    }

    // Used to cleanup image src before rte is saved
    function cleanUpImageSrc(pEditor) {
        let div = $("<div>");
        div.html(pEditor.getContent());
        div.find(IMG_AIH_SEL).attr("src", "aih");
        return div[0].innerHTML;
    }

    // Used to cleanup image src before rte is saved
    function updateUpImageSrc(pOpts, pCon) {
        let div = $("<div>"),
            imgItems;

        div.html(pCon);
        try {
            imgItems = div.find(IMG_AIH_SEL);
            $.each(imgItems, function (idx, imgItem) {
                let pk = imgItem.title;
                if (!pk) {
                    pk = imgItem.alt.split(AIH_KEY)[1];
                }
                if (pk) {
                    imgItem.src = apex.server.pluginUrl(pOpts.ajaxID, {
                        x01: "PRINT_IMAGE",
                        x02: pk,
                        pageItems: pOpts.items2SubmitImgDown
                    });
                } else {
                    apex.debug.error({
                        "fct": `${util.featureDetails.name} - updateUpImageSrc`,
                        "msg": `Primary key of ${AIH_KEY} is missing`,
                        "featureDetails": util.featureDetails
                    });
                }
            });

            if (div[0].innerHTML) {
                pOpts.rteItem.setValue(div[0].innerHTML, null, pOpts.suppressChangeEvent);
            }
        } catch (e) {
            apex.debug.error({
                "fct": `${util.featureDetails.name} - updateUpImageSrc`,
                "msg": "Error while try to load images when loading rich text editor.",
                "err": e,
                "featureDetails": util.featureDetails
            });
        }
    }

    // Used to upload a new image 
    function uploadFiles(pOpts) {
        try {
            pOpts.rteInstance.editorUpload.scanForImages().then(
                function (response) {
                    if (response?.length > 0) {
                        if (pOpts.showLoader) {
                            util.loader.start(pOpts.rteContainerSel);
                        }
                        response.forEach(function (element, index) {
                            const blobInfo = element.blobInfo,
                                fileName = blobInfo.filename(),
                                mimeType = blobInfo.blob().type,
                                base64File = "data:" + blobInfo.blob().type + ";base64," + blobInfo.base64();

                            apex.debug.info({
                                "fct": `${util.featureDetails.name} - uploadFiles`,
                                "fileName": fileName,
                                "mimeType": mimeType,
                                "base64File": base64File,
                                "featureDetails": util.featureDetails
                            });

                            apex.server.plugin(pOpts.ajaxID, {
                                x01: "UPLOAD_IMAGE",
                                x02: fileName,
                                x03: mimeType,
                                x04: index,
                                p_clob_01: blobInfo.base64(),
                                pageItems: pOpts.items2SubmitImgUp
                            }, {
                                success: function (pData) {
                                    const blobInfoSend = response[pData.index].blobInfo;
                                    const src = "data:" + blobInfoSend.blob().type + ";base64," + blobInfoSend.base64();

                                    let divTemp = $("<div>");
                                    divTemp.html(pOpts.rteInstance.getContent());
                                    divTemp.find(`img[src="${src}"]`).each(function (i, element) {
                                        $(element).attr("src", apex.server.pluginUrl(pOpts.ajaxID, {
                                            x01: "PRINT_IMAGE",
                                            x02: pData.pk,
                                            pageItems: pOpts.items2SubmitImgDown
                                        }));
                                        $(element).css("max-width", pOpts.maxImageWidth);
                                        $(element).attr("alt", AIH_KEY + pData.pk);
                                        pOpts.rteInstance.editorUpload.destroy();
                                        if (divTemp[0].innerHTML) {
                                            pOpts.rteItem.setValue(divTemp[0].innerHTML, null, pOpts.suppressChangeEvent);
                                        }
                                    });
                                    if ((pData.index + 1) === response.length) {
                                        apex.event.trigger(pOpts.rteSel, "imageuploadifnished");
                                        if (pOpts.showLoader) {
                                            util.loader.stop(pOpts.rteContainerSel);
                                        }
                                    }
                                },
                                error: function (jqXHR, textStatus, errorThrown) {
                                    apex.debug.error({
                                        "fct": `${util.featureDetails.name} - uploadFiles`,
                                        "msg": "Image Upload error",
                                        "jqXHR": jqXHR,
                                        "textStatus": textStatus,
                                        "errorThrown": errorThrown,
                                        "featureDetails": util.featureDetails
                                    });
                                    if (pOpts.showLoader) {
                                        util.loader.stop(pOpts.rteContainerSel);
                                    }
                                    apex.event.trigger(pOpts.rteSel, "imageuploaderror");
                                }
                            });
                        });
                    }
                });
        } catch (e) {
            apex.debug.error({
                "fct": `${util.featureDetails.name} - uploadFiles`,
                "msg": "Error while try to add images to to db after drop or paste image",
                "err": e,
                "featureDetails": util.featureDetails
            });
        }
    }

    // Used to sanitize HTML
    function sanitizeCLOB(pCLOB, pOpts) {
        return domPurify.sanitize(pCLOB, pOpts.sanitizeOptions);
    }

    // Used to print the clob value to the elements that are in data json
    function printClob(pThis, pData, pOpts) {
        try {
            let str;

            if (pData && pData.row && pData.row[0] && pData.row[0].CLOB_VALUE) {
                str = "" + pData.row[0].CLOB_VALUE;
            }
            if (pOpts.sanitize) {
                str = sanitizeCLOB(str, pOpts);
            }

            updateUpImageSrc(pOpts, str);
            // debounce is needed to prevent multiple events executed when multiple files are dropped into the editor
            pOpts.rteInstance.on("change", apex.util.debounce(function (e, data) {
                uploadFiles(pOpts);
            }, 50));
            util.loader.stop(pOpts.rteContainerSel);
            apex.event.trigger(pOpts.rteSel, "clobloadfinished");
            apex.da.resume(pThis.resumeCallback, false);
        } catch (e) {
            apex.debug.error({
                "fct": `${util.featureDetails.name} - printClob`,
                "msg": "Error while render CLOB",
                "err": e,
                "featureDetails": util.featureDetails
            });
            apex.event.trigger(pOpts.rteSel, "clobloaderror");
            apex.da.resume(pThis.resumeCallback, true);
        }
    }

    // Used to upload the clob value from an item to database
    function uploadClob(pThis, pOpts) {
        let clob = cleanUpImageSrc(pOpts.rteInstance),
            remainingImages = getStillExistingImages(pOpts);

        if (pOpts.sanitize) {
            clob = sanitizeCLOB(clob, pOpts);
        }

        apex.server.plugin(pOpts.ajaxID, {
            x01: "UPLOAD_CLOB",
            p_clob_01: clob,
            pageItems: pOpts.items2Submit
        }, {
            dataType: "text",
            success: function () {
                util.loader.stop(pOpts.rteContainerSel);
                apex.event.trigger(pOpts.rteSel, "clobsavefinished", remainingImages.join(":"));
                apex.da.resume(pThis.resumeCallback, false);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                util.loader.stop(pOpts.rteContainerSel);
                apex.debug.error({
                    "fct": util.featureDetails.name + " - " + "uploadClob",
                    "msg": "Clob Upload error",
                    "jqXHR": jqXHR,
                    "textStatus": textStatus,
                    "errorThrown": errorThrown,
                    "featureDetails": util.featureDetails
                });
                apex.event.trigger(pOpts.rteSel, "clobsaveerror", remainingImages.join(":"));
                apex.da.resume(pThis.resumeCallback, true);
            }
        });
    }

    function showInstanceError(pOpts) {
        apex.message.showErrors([{
            type: "error",
            location: ["page", "inline"],
            pageItem: pOpts.rteId,
            message: `${util.featureDetails.name} supports only TincyMCE based Rich Text Editor with Format set to "HTML"!`,
            unsafe: false
        }]);
    }

    // init
    return {
        initialize: function (pThis, pOpts) {
            apex.debug.info({
                "fct": `${util.featureDetails.name} - initialize`,
                "arguments": {
                    "pThis": pThis,
                    "pOpts": pOpts
                },
                "featureDetails": util.featureDetails
            });

            let opts = pOpts,
                defaultSanitizeOptions = {
                    "ALLOWED_ATTR": ["accesskey", "align", "alt", "always", "autocomplete", "autoplay", "border", "cellpadding", "cellspacing", "charset", "class", "colspan", "dir", "height", "href", "id", "lang", "name", "rel", "required", "rowspan", "src", "style", "summary", "tabindex", "target", "title", "type", "value", "width"],
                    "ALLOWED_TAGS": ["a", "address", "b", "blockquote", "br", "caption", "code", "dd", "div", "dl", "dt", "em", "figcaption", "figure", "h1", "h2", "h3", "h4", "h5", "h6", "hr", "i", "img", "label", "li", "nl", "ol", "p", "pre", "s", "span", "strike", "strong", "sub", "sup", "table", "tbody", "td", "th", "thead", "tr", "u", "ul"]
                };

            // merge user defined sanitize options
            opts.sanitizeOptions = util.jsonSaveExtend(defaultSanitizeOptions, pOpts.sanitizeOptions);

            if (pThis.affectedElements[0]) {
                opts.rte$ = $(pThis.affectedElements[0]);
                opts.rteId = opts.rte$.attr("id");
                opts.rteItem = apex.item(opts.rteId);
                opts.rteSel = `#${opts.rteId}`;
                opts.rteContainerSel = `${opts.rteSel}_CONTAINER`;


                if (opts.rteItem && typeof opts.rteItem.getEditor === "function") {
                    pOpts.rteInstance = opts.rteItem.getEditor();
                } else {
                    showInstanceError(opts);
                    apex.da.resume(pThis.resumeCallback, true);
                    return false;
                }

                if (!pOpts.rteInstance || pOpts.rte$.attr("mode") !== "html") {
                    showInstanceError(opts);
                    apex.da.resume(pThis.resumeCallback, true);
                    return false;
                }
                // show loader when set
                if (opts.showLoader) {
                    util.loader.start(opts.rteContainerSel);
                }
                // download clob
                if (opts.functionType === "RENDER") {
                    apex.server.plugin(
                        opts.ajaxID, {
                        x01: "PRINT_CLOB",
                        pageItems: opts.items2Submit
                    }, {
                        success: function (pData) {
                            printClob(pThis, pData, opts);
                        },
                        error: function (d) {
                            apex.debug.error({
                                "fct": `${util.featureDetails.name} - initialize`,
                                "msg": "AJAX data error",
                                "response": d,
                                "featureDetails": util.featureDetails
                            });
                        },
                        dataType: "json"
                    });
                } else {
                    uploadClob(pThis, opts);
                }
            }
        }
    };
};
