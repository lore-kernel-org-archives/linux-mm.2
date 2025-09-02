Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C6FECA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39B5C8E0023; Tue,  2 Sep 2025 07:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FCC18E0001; Tue,  2 Sep 2025 07:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19FB68E0023; Tue,  2 Sep 2025 07:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0176C8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBAF6866BF
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:49 +0000 (UTC)
X-FDA: 83844166098.21.041B8D7
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id AA8D4C0008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=HjMEY1nm
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1JFPtEwOFWxLJ4pevnsYlgpYZW/QvB5ELLnfLsEVFI=;
	b=MOEWELzZteTE1GYAs9N4gwALOtAGVH4IknJmnK0UQw5v2VWtSzxpdYOMIOMX2UTXhMINgS
	Jl8KVj77aLzcL87lfn1i2HVQGq3LQAzdA0ViM91b4Mdnn/SnDlgTZRXXeU2pGz0u+ZvxfK
	wwks+NIHIoWIuEQ1hIJhTkUf0qmAfUU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=HjMEY1nm;
	spf=none (imf22.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.48) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814387; a=rsa-sha256;
	cv=none;
	b=6Eup+1JC5OkDxp7kLnYoS6R6WcTdYlTNu0Dffv+YOnoJZCWga8V1ZgeAXDk1nuQTB9inti
	HFb5I4P+6Gep/7D+ouHiv51ZTh2PsuJ4ks397Kt8PyqPxY8vCf/W1gSuSqgbHORjcsyWI6
	INYCbeUgbImkA4KfW2opspqbi/+1nz0=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b7722ea37so19094575e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814386; x=1757419186; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P1JFPtEwOFWxLJ4pevnsYlgpYZW/QvB5ELLnfLsEVFI=;
        b=HjMEY1nmlll1cXWyMuvT/78iRUUzLklViRDKnP4QvH1eANavBZ0qHFEQPYKPZW+ZdH
         0akFIniAV8l+uaez5iURMz8TSjHFGfalJqWACSuQAq/BT4aT8I/kg6p1GlD0OupS9zW3
         WZJkostc/XIB2fRT3NotPpinD0akk5UPUUdMC1EY558Yr7XI6dnGP0SDo8wsG1US9Jka
         DWXL+7vU2g0LTttc0IlhVGTpq1AUThyoK49ORFoaos4RdFLUY6nyU+ovCn+BIvOGdhoF
         zNvzrU1VaDXE8UJV/Fl6FadpYAsMi4JJUba5w8NWqsMPASWylcZjwM6JPf357DsuaCr+
         venQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814386; x=1757419186;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1JFPtEwOFWxLJ4pevnsYlgpYZW/QvB5ELLnfLsEVFI=;
        b=Cyb1f+VWWw9rMEoazCS3+XpttvAe7/UeaAyJzWE5BU/KaXM2d/504h3JOkik2qmBHz
         M7vsT44ly0EnhFYA8PwrLjyTeMTRJ45LOX7EzvJYvQXQpYeHTj5lRxYikeNdepZpdSPx
         XCriciMcDNvxKeH6fvs7oBOstT9k7tBbFpAhxIWeHQ5S0k5LCX1t1fr3LRb/dc0xNmiy
         DV3N+fxf16xOOZ7e7e70zAXZSzZwmRVfTmnDuEjvrEncpWq+DtPOzHk18+szCP2tvUjI
         tZxnGeSQ1kgmlgAufLy8MzyK59cOqI8N15+LNrwXxl4J5qG8ya92WGlMw5asOQxCTehN
         8B3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHowX6kBAx8mYdPcF8TqHgUpCdXY0dDcjAcn6W/HulFH+OEjo5ynwOqlPGygzo5PKQ/9btvfTLQg==@kvack.org
X-Gm-Message-State: AOJu0Yxdd2vIiEkI5IVENn+fFzi08/iLIEommwbsr6mN7YYBdBy2RHJg
	mIEvLF+wPmbJkJAeXpkbL1Q+BUcGvkXlQLBvalBijmxn3Z4Sn2cylPBLOcUReHgSouE=
X-Gm-Gg: ASbGncuS5nJ1UZu09XCdJlk7lxUnPinKD+q3Xj+1tR1CaWIVPbug/WPxewNNzJlFPEj
	SKnjd1E9ggn4MgvsJFrx+VhX+GgE0WDDPgnkEH73a5gbh6NOEeg0hLpp0dthF9ypk3PdNOmc/tl
	kxOWq/7zPwEEbQtWlKuyWzt0lZef8oBLoXFfnhfoyZNCMK+X5J3WXlrM/l/9mKF+L2ijSnPn2RQ
	W7B/5a1uS76X5knbi7nY3hp2fMEzzuLpZ3B7CyfWZ16Sb0B0K8Mv8JBhnRPzhgeJZUBfj14d9+/
	FHEQ0FrQ7KxGqgQanv44/xE4+shR//yZby/ej2r5XfrkhEmHDeXoSc8Xjt67RoSlQ14QfVwJNP3
	QZgbRx/ugzl0Wpw/2
X-Google-Smtp-Source: AGHT+IERkhZoQX1HV3fDYiEzCgaqV6JXpD5DtzyBRIwQQg9LLBsXxUh/GkJb42UUw5J8EFKuniHI6w==
X-Received: by 2002:a05:600c:4f83:b0:45b:7deb:3f0f with SMTP id 5b1f17b1804b1-45b84c2256bmr102158145e9.2.1756814386175;
        Tue, 02 Sep 2025 04:59:46 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:45 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:25 +0200
Subject: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1197;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=bNcWH7RYmKxieWZj+11TmEo7Y2F52BicXtYvQjacVVo=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwVYBNAIqxX+GTdprLN1KmCRP+T0cr4zPnb7
 WAB05uVr4mJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcFQAKCRARpy6gFHHX
 cm3gD/4gfdNCgi/L1crd3spjH2BfsVhCz8jK0iuHKflwRrBglJW+yuaaNcsIES0+sEg4mbRdkvB
 1Ww04kOvSuLFZauF0IjgNjcsXM9Y4+a0omjT6JjzrxF4wH11ZUipW6gaRbg5cWC5eo3rgddQEsn
 kwbd/DgAjJie0IMEsgOrpRxSoSPgtiB28j56D9mQlqkaav0Un0XGqHAf52wzHJKASG5FIcLEqk3
 qIM2zlotBfSbMMrimUgMUuracaiWXAgUZEUnTEvPcEqzGxwmGN7aUT3In4gU+ZIAMIA66uGPNE+
 irYNdb4rfWdNdq7+XjiId4yoaKduyzu5Qc/jnjzOGWFHMO2C/qillgL5/et3jIT1GjeUzbUIINn
 CxvwKST8T1S2cPmHe4pwcwmXVDVTneQtdl42O5qh3vP+1L2/R2k4qf2Nl2kX0gqEEV3lZZo9eki
 Ft8oIUThEPJqYpsD0+9gXrBi9I1lYZsOnzBK7tbaaPfJb/rpibcVpT+BJ76HUywsb2N5YPPscbC
 s7dzSCMl03nWf/7ur92d3WElyVXj0DwD7mA0bhE7Qm+yF5en8ldGU3WMcg9FbVS9+hCDk4xtc+s
 aMN2oTM1Lo+DyGbfSI+GpIAarry7nR5402siiOB0KaRWE+zrsWXHk9HH0n2Vu1wv5iSFoFplf5q
 nx4+sTuoQi8FoEg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA8D4C0008
X-Stat-Signature: yqca1bxg9hqd7utpss7nxzbah5jurghq
X-Rspam-User: 
X-HE-Tag: 1756814387-975035
X-HE-Meta: U2FsdGVkX184Wwln5iCZCGwc2RAoLG7MI3Ibp+Hdx9GREIG64/tjfnLWjvI440oxTxc0wN+stqBdi0zrD7p4+fMNsKxl0l5Pkns+IJ+Z9XfhyQdJhMF4yRXlMI2Xcz8HbeB8KQBwR0skqferD3FklUBhm9DKRcnpUqVv3ZpDoIURcMSUdct6zz5g7XHautFc5i8SSu9RemcaHJlUydmNZFko8sBGKUnsk9exHUx3uMbgmDC/n4JBOfEIbmDaOWRldlNaBi1o8avkt2g2O4iiQDszL6rqqI+pOQXSuhOCjVefC0IJGgT9vk1vmc+mmobyTYR68DRe+QlOrTr3f3mPAHt3OdfWCOutK39V4hsB+lTFazpfB8Kh0RdToTQvfNjPpRnNR5aSqSPt5uMjrlb8i/HmHzJHCyGdN4976Mgx8eoUtlb3DwtlaJblQnaYwS5qfGaOMyIjxP18IhHN0SXkh4gZGDDdkNmOFUfJA6TC/7rf3gt72aRoAOxSrr3sHN72N3XpqvKHIHlcuckAHD12cY/QhIVCKR0HNJhXhfbHjgCrVH3//INsdMa4rAS/3XJLLNm0jAmc9I4xWPQRAvBeGPhaOpz+9k3ImUB5h6dsk+2uTbKkUl3yJaKL0dVTDieUctnCkyoMB4ZPuBXkfb9a044JJJZlypL21dRmwulvYlFnThmmXHITwIrTtoZzGYqFNAkDKWm2MCypgmbbi7j7L/giiIE+mPTVVeut5dMU88T7WZTNhkQfnPxmmpGgqW5phuVYceUVhviH9Qgqo+DeqplR/3V8R4ZExwQY49se790cHFNpqNUwh/CluB6/p3DnoR0rlYlaL2SBORaVwDVVocsPDP5OK7/66Hn0KyEQD6OPLLUTVC/bcVLl0dniPnwNO2kGxwTGa3iWn8SMLsIsihcJFwSkKAWgK7ZYEMMpW3CLWqebKkVczokglhiDrtb8KfgkjTpVjopkxkyIlHS
 Z6Z1r/Yx
 ApkVgEIXOlLISjkrKMnu9FVA4pXXpgtL7fF2ouKRP32qJZmYSPGtiXuzrodgugFLDZnxtT20ADxKLAWaEunJVFRUYG9SjHVVLp5OD1pzZ+g1banXKLP2S5IXj4xlpBta/PcJi+xSuF4xS6u7TmeQAoxdzSxtjMTg0OztgyTB7K6Z1siEwkmVXgSKMZBx+HL5YTsMVfr76Ir2GVXPbEKQeLwSa3bJUqNDN3YrdFij2QXUa64V0uCl9G+5sbNQjypoDBjnv4A48trJaCrdg91WNA2aU/rELQiZomwaiWTVumKusi0Qn6+++rDbvuaGlJ/qSiQ4RILR9Wf9NQR8G+P/GDmIIGc7TsFBkdhCeA+GwLfWHZcXzA3z05yZpfq1fgozEvVofli22LFpR9LgwhhFhG97s+z8KW08CIBiJ3GYgEBLVAnFaHpX5BW3csT8fQqkYNgvHolCB8WIuW7Xh4KqQhn6yhdvIpVRABZxB/KVps3Zf9GSxRVKpY1LZOV1m2QarJ0371/r1aCNOyS3FN4Ryuvkfrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

The strict flag in struct pinmux_ops disallows the usage of the same pin
as a GPIO and for another function. Without it, a rouge user-space
process with enough privileges (or even a buggy driver) can request a
used pin as GPIO and drive it, potentially confusing devices or even
crashing the system. Set it globally for all pinctrl-msm users.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index a5f69464827119dfe2a7781b558094b283fca215..1751d838ce95d6138c824b90098f74891dec7656 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -268,6 +268,7 @@ static const struct pinmux_ops msm_pinmux_ops = {
 	.function_is_gpio	= pinmux_generic_function_is_gpio,
 	.gpio_request_enable	= msm_pinmux_request_gpio,
 	.set_mux		= msm_pinmux_set_mux,
+	.strict			= true,
 };
 
 static int msm_config_reg(struct msm_pinctrl *pctrl,

-- 
2.48.1


