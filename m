Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA52CCA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD238E001B; Tue,  2 Sep 2025 07:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88898E0001; Tue,  2 Sep 2025 07:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51598E001B; Tue,  2 Sep 2025 07:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1BF8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51CF8140C26
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:36 +0000 (UTC)
X-FDA: 83844165552.17.35E5C5E
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 346A81C0015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=BBn73Wx8
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814374; a=rsa-sha256;
	cv=none;
	b=k+EjQq0OphndGw1H1Ag0pAKH10Z6BcTqkCUbyOrl/WzrdjSX+Z72DBIKeBBlQsYJAtmDqE
	EglDo0eHGrwphEcewJPly79Xj5WNBoGAxqk4yum9hWQBUEHuZC78ySPZ3492zaQDFVe4yb
	dFqUs9KRuA/oIiX9dx8+iPQACY6fgMk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=BBn73Wx8;
	spf=none (imf21.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.44) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3eeGmPeTtaROvFQiYnK7dZg5f0Y1UOsb0zEkFq0B7A=;
	b=VhZIH7/Uvn4pf1AjLXQtmSQPw8YvEUaSgww1icDPylxmLRRV+cknKovF6Ffz+/pOg1JLvo
	mQ7kDfvYVonpvX8sbZw+fAD//mgaWN+IIqw3N/1Rm71M/gqryZHzztseXPxbyWF7IWdFDq
	ncALnWzGFRWiTjBwZyPtgbw1U8rJMA0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45b79ec2fbeso35721275e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814373; x=1757419173; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G3eeGmPeTtaROvFQiYnK7dZg5f0Y1UOsb0zEkFq0B7A=;
        b=BBn73Wx8wUDYnc/irk3Knl4GxM+YDUywlGSl+fLJUZl/0HC/5oL92G/oopWjMhmYxE
         hteMaZ2Zx+zueN3I+FbMzocJb81qx79K6vzoAnzW8ye6RrVDjx2uvx7W318kzv5XBiYy
         aZxoIZmgac5hWU2X2YN4EvQk12cayL/HHc2MEanXE3HeCJy79KWWpg0sxwGxp4m7WBVa
         IIZfAoB2CdvmuSfeq9OnRC0rgTe9dcRWqV1ADc+ruchY6DfeBsDMnYlnBDPj4GhcG7Up
         hcuI319brF/1PaXSVLH8BKKlRbpeC0cI0Vg4Gbwkzlj0HTAyovfx+VHQf0FI2TJK71dx
         OrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814373; x=1757419173;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G3eeGmPeTtaROvFQiYnK7dZg5f0Y1UOsb0zEkFq0B7A=;
        b=wp/f1G8bBFb3VvTp8rSooyGlVQ3PbIaZephWEN2fGGb/8x7uMfIgd5L0773ucjpqKa
         D/IwwPNbs/m5scJnjLqk1WBHSI1IH0da45w1mEcqpzHqTrafnhdD72Jo6ZanvyyYJajh
         +6zMVe+iHdmFT9Oq2Ic2tQxe5sKqQbOLiUivdcVuMJwKfZHsOgSXRfStdaapaIQvfZIE
         mN1OvfuBRLwyq/n7G2+gGBmJTnF3vQ+BnBcrfc8KrK1FuPKX1JseObDX7aqjTCN1yV9k
         ZFO4hqXMtyY9/CFwJpoL9FmtybjXKw8hVsLmMdsUV1v23mYOXAy78oeC8/ivqf/ZxPME
         48HA==
X-Forwarded-Encrypted: i=1; AJvYcCV+nbK1dOOO/rWV9zwiRA+mNcCVQSu8NvG14DRTojWTPPjGnzSIFktwK3CEmZtpcytjMVndI9fJIA==@kvack.org
X-Gm-Message-State: AOJu0YyXmzH/GrE5EkBejNw/FBfSe1ri7nPyJS8hfCUsNLGU4N8H8ABg
	/axy+/se1Yq84czcno1H9yPKhggbjp4gRwAx97XjgToG25BdzDecmlGnnt4wpVvtGSQ=
X-Gm-Gg: ASbGncscJPWYBSa7V5GiG4/NNtvjYervSwMATIc67IsOLAp/HQk1UyPPFyas924ntQf
	mMcGIk8/aZgoq4BsiNwYLcE6nBaWtrwBgQi+10imoo9CsAwdF45BdxO1gugCLW/eGZSy9MFv6vR
	OYu6DNMUtZ3Cgw+oaudTI2SYdj7Rv8W685AWo/FvUMa5OXTIHi1j1wmcccFLvh7r585QzuA2FV9
	mYOiugCh2igG4HkoYiDD/HFgP1PuKjdpcPmJfOEstKOpyaMeN0PtZ0giA2AxUYnrLwnBZIL9Nv/
	VmAQl5MW8gjWeVimQcDu+8tUoOpO5ZT7V6Yc2MdKC5YRQ0qKunLdxYkZlLfwMl12wUZWpK6mJ5Z
	Y0UiwkxI1ZTxU4YZnzlEYqrcgSpA=
X-Google-Smtp-Source: AGHT+IEYts8jM0hPDNk3lR54JtI9fXY+q3XD1cCncBSU1T/7vcK/5dU1iwGu8Rzh1q6sfcr++Z7kQg==
X-Received: by 2002:a05:600c:138c:b0:45b:75f0:2d66 with SMTP id 5b1f17b1804b1-45b8553da82mr85384005e9.4.1756814372615;
        Tue, 02 Sep 2025 04:59:32 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:32 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:17 +0200
Subject: [PATCH v7 08/16] pinctrl: keembay: release allocated memory in
 detach path
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-8-bb091daedc52@linaro.org>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Alexey Klimov <alexey.klimov@linaro.org>, 
 Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>, 
 Andy Shevchenko <andy@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>, 
 Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 NXP S32 Linux Team <s32@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>, 
 Tony Lindgren <tony@atomide.com>, 
 Haojian Zhuang <haojian.zhuang@linaro.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1922;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=ybe6mZ39mB+QhhV+IKLIazviltUgUh6yCI8QoqBhqhA=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwTMr8wKhS9jqc/gyJqLYlDuhik2dzTYA2mT
 1itmg9TI66JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcEwAKCRARpy6gFHHX
 cjI6D/47zG6CNa/8DApAwhxFDdmwXkTD9kK50B7xrkEpT1/JM58uqZdt8oD+hS1swsxXhRof0r4
 2n2Ji8TbCs8P2yCD2PbLf15A8uHM5PHZenScMw/EEAYyqe71x1+dtfd/0WPRmc70ZooKL2QWiAi
 WmY3xrhUzFT/mTiHSJ+Sl6fEv9P+P0aF1MaWbgDZ4jowuRSP9MOSc95l5y5xr0kfP1E16kxoCnq
 4ZHO+I9jSj8nAOC4p7vv2C8xPjIX4qljGd6Fxei7GyLJCsWCO1bVOuiBPOeuAHr5xFaE4ZRovYb
 F9lyE8LGGsGKHyJ/L69Bodanim6+VN85c4fQ2AcR89293cvQpDixNSz8mrBUiT+HmVE0IzxSLNy
 Sgp2dWrAe3TRtptr7mqR4lPuk61imcA5RCUU0I3oaXxd9hP+JLUTmSlMfA6LoTNWbSYRVC+4xDw
 Qo5pgteE310JQKtU6rQnNHGW+2O3jcyFn9mbGQuTqMr+vKyahvM7UyhEDX8ZW74zY27DSaD749J
 rGlm9BHlu4j2jQqztmo2Nn3sGXWBkw3q97eaE04xHGEZGWDzNSCFZD5lsOKMyFl1RzjaBRQfm3w
 5Vg4CQMYP/j/60BEEqNgzTd4ZzduOt28Z44HTEo2+ZFoduSKvvGzmVen+sRIF7N6c4O1baavetE
 suzeoiwgo1tLJVA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 346A81C0015
X-Stat-Signature: tjkouueu3h3u874fydpqngf9u5x1boau
X-Rspam-User: 
X-HE-Tag: 1756814373-281087
X-HE-Meta: U2FsdGVkX19z6Zl/htN+6O5gHAMpD9SPSvLNGNheu2ummvXuPeoy4HKBToKTX2UPwDMJOa6GUTYqxct8gMafPBbv26n9/sUucNRTn5XTKjnkAhOcvUk1+nLa1SHFFf6dVQ0Rp2K3FuMB0BcQEjtgY26zfKU69MQuPd+JppbFsIQkn4KCJnRU+V5i1o2w7fG8b5k+BkePIhEE5agRDfDOlA6k1nmKXExAxnQfaJML0nxafq9C+CGdMkgvzLTK/6+eMclsVblFJt4v9wxRu7zGedIWlwOz1qbuTBC4vA0NriKdXCMGKE/tQvd/d3MZ+rR5hn8HOhKkiVpeWkKg1pTXffwSLqKKMcztSMS25lEEhE62gpBM0DEhndm33VqqbQiiduG5Cyzn/qNeBYQcKoEE2EmD7skUF1hlUZIozeA9XbFql0ub3cWUTVKb7oOKTkb7JSGRaV5AQ/9VP3DDQ2sYT0q2pAAO/jw7k9LZT0iknKOzBx85un8f6JhsOotCo0ZR6soFMs2yyuKc8FBmzocMV2SI3p4dbxzoQsnSV+6r+g7WvIPKhXG9Uodi/d3DwcjrdEHYcgAJ/1HIrW9BzCBFCRjVQzJUcYAQah6hdM5ig7gv5frF+4GP7qNroODSd/wdLwpm9+E03R3Fv+2iDB2EqBHxEXeSl2vB1+mh/qexPdAAJ87LMr571rBkKOpJnTWEPqslPr3ew7s7lueI/gM94xJFVSpsli1ciScauM2Whck5COzp2TsGUv7aJv9+suREquhdF+lolp15owY9ea7AQih40QBSaaQKnbe2galZ5MM/1ug1GLWKZDM3eR9eliDq+/VKFUivSdREvhBuT2/KXoRqp69spgy7doCYIxyO8HaBSv+ClTW5lt7AdOBeuQ/T73IqZY7L8SZHOT/vdHJDgvhsy7q81vG5aQ46n95uQXbfnznCvSCRVxOTqDrS3GMBSZ2iQGiBhYDycFXWce/
 uADwZiO2
 91RC9a+KURRxoQ4X5XzTYhxzzcQMEUoMWNvIfn/k25mKZm0bhZHANCMAg9Vj0fvy+NcBWL/42USde7+Gk7TcRwSlKlghxOMKr0R3ankMVvbCQyO6z7tGRwm1H/uagx/IjmG2TJk2haU877ggtdfS5Jq+UwvEjdNw/4EMzfPayhoLnGZIUYqQ36GDcoPOFDuMduzG41r2kI2qpUExzMNMtcn7DnU//iEX7ZaH3PTrE99GzYvuNiU/RUpvo49pZ1LZH3MqjIuu1DsL9qdtCCs5OQD2dcNB4OwjXdURseYDQvObexHK9H83uiEjUuK05BPD4zK0efF7/4tkFcmDTqenwDIRdhO/4mTbOjA1b58vWnub3dYjiYwT9ZWiEDMrNcUe+aIPll7u2D6V5HNPpj7sb69XieizFOvu0xUqibDdTtdAduIJONS1N4OI8+GxVwfSUyYrimsuBW8nvEk4JcJRYMUKmrcvrjUyGe7Vrbf7uWpvPQYA+83OSfraykMVsrF5I6elIBcCKSERXp9S5hD/D5JS8D2ESh2yiuwWj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Unlike all the other allocations in this driver, the memory for storing
the pin function descriptions allocated with kcalloc() and later resized
with krealloc() is never freed. Use devres like elsewhere to handle
that. While at it - replace krealloc() with more suitable
devm_krealloc_array().

Note: the logic in this module is pretty convoluted and could probably
use some revisiting, we should probably be able to calculate the exact
amount of memory needed in advance or even skip the allocation
altogether and just add each function to the radix tree separately.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinctrl-keembay.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-keembay.c b/drivers/pinctrl/pinctrl-keembay.c
index 60cf017498b32a9f36a1f8608e372951c2b8f12a..6aefcbc31309995ec1e235416b40aab3e4a073a9 100644
--- a/drivers/pinctrl/pinctrl-keembay.c
+++ b/drivers/pinctrl/pinctrl-keembay.c
@@ -1603,7 +1603,8 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 	 * being part of 8 (hw maximum) globally unique muxes.
 	 */
 	kpc->nfuncs = 0;
-	keembay_funcs = kcalloc(kpc->npins * 8, sizeof(*keembay_funcs), GFP_KERNEL);
+	keembay_funcs = devm_kcalloc(kpc->dev, kpc->npins * 8,
+				     sizeof(*keembay_funcs), GFP_KERNEL);
 	if (!keembay_funcs)
 		return -ENOMEM;
 
@@ -1634,7 +1635,9 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 	}
 
 	/* Reallocate memory based on actual number of functions */
-	new_funcs = krealloc(keembay_funcs, kpc->nfuncs * sizeof(*new_funcs), GFP_KERNEL);
+	new_funcs = devm_krealloc_array(kpc->dev, keembay_funcs,
+					kpc->nfuncs, sizeof(*new_funcs),
+					GFP_KERNEL);
 	if (!new_funcs) {
 		kfree(keembay_funcs);
 		return -ENOMEM;

-- 
2.48.1


