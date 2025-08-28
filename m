Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5119C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9B86B0095; Thu, 28 Aug 2025 12:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159D46B00BA; Thu, 28 Aug 2025 12:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6D56B00BC; Thu, 28 Aug 2025 12:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCA7B6B00BA
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6739614029C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:34 +0000 (UTC)
X-FDA: 83826628788.24.CA408E5
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1A2C0A0025
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=SdOSxuGf
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcnhHIb6eNEwdjxZYrigpF4SQxNgYqLi3t6s+DqhmIc=;
	b=Dx08UzdLM4nQ9ozeF07lfHGnY1Rtjdx2xXPBSbL//zX/igzRAVnWVuPkHVxIdWb+Lnlbqd
	2fTuXPqHX3fOduAQD/wUW9ELTDrY3A0/VcGylu+ruNHEydXoBEhryPOe8bKQr7eIssPM5S
	8dBsup37RHxmkB2AQA7rF5tdBKd5/zw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=SdOSxuGf;
	spf=none (imf25.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.42) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396832; a=rsa-sha256;
	cv=none;
	b=agwR5w8rAmJWT/fnqBUdTD1qIG/8S3C1FAaatxUUiDWCxw0e9uT13QzdXzpx/J8x7HJSV9
	0VRdv4vAYhjm0yxkgdV1e2k3gORCpamf+b3+DhupZfX3PmmzHXi5+jxhQMTpBBAzTr6jrj
	0k/a2T09KARswpn/wIYb37wt2r11jwI=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45a1b05fe23so7081325e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396831; x=1757001631; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rcnhHIb6eNEwdjxZYrigpF4SQxNgYqLi3t6s+DqhmIc=;
        b=SdOSxuGfr6+y2T/WQjGXNt2GaYqszc5UDKxi/NIBWQF1KMHOx1+zGwMjz81oanwfCo
         8lZL47ZhD3yadJMVTWdRj6ufidz+B6tekAVDvW4Q2qk+Y3tEV6OzNTLmdPDhYUWj+pBo
         sg9f6NcyIdhKUpe8x1v1Mc8Oa5mh4V84IF5z8Dk8jLPzeP82ESoy8wa62uEqx1E6CDWJ
         IJL4Xmqe3s1YGs+gS576sdAxhOPhTuBfpcmLnPr98tweydNMW0LZwWCuWG3oqzgFaV2q
         Yn5gw5e0ysqEvy6scxWZTeo8aoWezoj+POlsNyJoDBuxyTXUiWZ038gsN1z21LX0euzI
         H9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396831; x=1757001631;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rcnhHIb6eNEwdjxZYrigpF4SQxNgYqLi3t6s+DqhmIc=;
        b=Gxtn6ppFd4M7z8sDeaKiuKSgeCChCJzQnysswX9oYW127mAoDF1yyk1dv1L6O8If+p
         TFsOVbbCS9hduq9jlhtKJbelb43ZM9+kuT8P0mFlVVVP3dqKdT0fCtSXUgdaqv6VmwC7
         qmpSzXtbk1vGyMzto0bp60Om50jihKpeuIr2tj+akHzdpPytNCdPTKqL1AynJbjBK/Jv
         dicLQ0hin+rYu+NihyI6FiEPBKoN2Os6wmL/1KtrYTnP5l5uwSgfVLOfCqR8sHM305GU
         GO+nPVZYdoiH+mppQBW9PwifgB/T+7JxNs8nlmyjK5nMDXyjnPDqUgmtPhT/VNxQ7/vI
         HfAA==
X-Forwarded-Encrypted: i=1; AJvYcCUSWvhNpjn3FfymeUTYhvwlhoGytAJji7to3AGxR3HbH1C6/pxO1iXu6RRXMKumGDtN93Nq/r7b6A==@kvack.org
X-Gm-Message-State: AOJu0YyV9elqkis7IiJj7gQDIa9pMxsttIusFmu4Bq98UjqQI9dWARo4
	rUK2gMzE2x9Mmz/kTXeBS70RS52YTlsMh1kXf4OWDaaHIEwZ/FBLTjdatpdJBSH2miA=
X-Gm-Gg: ASbGncsrwo9SMaNZp3ZiHguJh1IyJjJ/JMRZZ0+1nz/yaxFTNaE07GckrBz30L6GvCx
	ANLipiN+LVE33lkg05v6j2dtwRCUu4etkUhikkFPlSpiaB/FrbbjunTspMntpI2bhRI5cowG7a3
	I2Nz8qlTcakHD4GaFoi7x4j/1clC1uZGIRThNfklokN95NfQcoBQnnV8bx9k2572SLgDFYrz4bN
	oXGzW42CsPSivBxiKDcYNnJpu+6trJCnqUf5zmkKXDDmYs0Ezelkokxe+l39u3A/ays8Kg7wzcq
	1tgO4g9EwkL4KeNj0fM62KZQfC5AtyXgWU97OakRgq/1EEc0DEppkVHctrY5yCLc7JbVyPWRpLT
	zLQYZfLmtfM2NDeYOeg==
X-Google-Smtp-Source: AGHT+IFFepUYI+bxIRTxDUeMnPHpoc8pmGJqVENaUjjXrMHXXy2WRVR0FTskPq39jX17KmytYEjexA==
X-Received: by 2002:a05:600c:3b04:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-45b517e9d34mr225147805e9.30.1756396830367;
        Thu, 28 Aug 2025 09:00:30 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:29 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:15 +0200
Subject: [PATCH v6 07/15] pinctrl: keembay: release allocated memory in
 detach path
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-7-c9abb6bdb689@linaro.org>
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
In-Reply-To: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1867;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=qPaUa8oAewMMgl8vCYU8JU6h4WrDoK89nonD2PTBKh4=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0OrC02A7A3w/syOmHWmFD75kiKFWOGyfOfU
 IkOZw9hCMKJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DgAKCRARpy6gFHHX
 cog4EACpRHc2z4CEO5/+sWycbTJ/Lv36XdsRhCdryTDmJugI9ckFKoQSZSCDj/EPSYTLap4IRcK
 v9nSbe3GHgyhCBsI4oPZRLALF/GxIpu/uT6Km1hMYNz0BKb73ON/KkKX2YjD6FDJmZxw+Vu6UVN
 WM9eKdip1jecx1xnrqabz4R4N+ToGOw8uBEpUBFz+GxzItCcchdLGaDiVu5sSr+vQqBIRi02YVw
 nMlphUxtITQbANQYECx1Nv1wP0FC3z/NrADiA7uTJmmpoQ9/oGlBIxsk3oaFapoPnuJGo3SJHgW
 mmck7aZcXXhlAVZIiw9AIJJh/pgBI9uk7x1EcsNXWmikxyDmqd6lCXPMdIoknKVfyRqWnkCSgQ9
 TXbSuYZKBlETf4DXch3J0+3Gzk048a+TZ3AGds07+/KPC1otJhyxKQk9l33053cVyeXhjYOH12w
 NmL9X+K1QkmH632UgY1mZUockXDkxaq77pVHpq7LhuGkPXIO7OQ4Z9s6joU6MzhxlIPSvHywpkm
 eO/vZTvIhUNoYQh3fEW1qBuMVuvoh9jDfivIMlZC5aDXleNbJrQTlT9uKils+YyNyOsXfM9sejY
 tdyEgsTDn1lfM8sKVtJe8RRgFOBmDbxsHb04CG5Olf9wBaVFRC3YBSJ5c5ro5ldHl3e+V93Ildw
 o6i4ZvyV6pa1cVg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: 1d85r1xcerawb6zidow3t5xzgutekfdk
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A2C0A0025
X-Rspamd-Server: rspam05
X-HE-Tag: 1756396831-531
X-HE-Meta: U2FsdGVkX1/KPIqSSSl0LOqShYfRH/2c6U4D2fLTmUro/XOftl7nvqYlzE+utpQZHUD3DzVhtW19s172okL2QV+4FCX12c8XcknpePmtKak4iiYbHS6Sy1MWVgJPJ8/8X4GNoLKqGQHFHIcr4GSj5pOIxZK3HdwkTC8GM5JGzSpQtOalzm4AlajbhfjBvSJXWqeV/Y6AWWKZ4mDEQSd8YoZkirz0bZRrja0cPVkRzNsUvFFNxytMqAKjtAZlesiLegxvWEcpJfb2sU6bklvZZVFvF6/bH9DxuW3zGgoWj2Y8QCDcboz6U1Epw/fIaHSP3AhDhFEFhAErJ2EY5SoshgcMedn2IZYFgcHeqygB/YedCi/Yhq2vXXfTLa+Tz7SUBV6rU/cSmQQcAu/FKUOEwLru5hGH4QPs8V4iCHIGSonuT96paM+1U76Za6I36EBzkmEsb0cgM5MPAvTicMp7XJ8awUQ1rbC4poK3WneYVRu6cccibOQIxkFBlAPfZLobfGWFo/7Wo7LHVa3xG2qp+y97poNkdPMgefiwIZN4fnMqcXj0ZzXk8+7e3/QiwyM4ioI7OmMBO15VjjUUCTnJ55lHbIYjEHUVFw0xvYy7tK2TxumULrHGrs0IScOoTp/6S3+hd9S6ZMu1T5aB9PsCzXf/R3VZQYFcT7f5KPmaXqDPTcGPou5YCDbjcI8EXe/eogozLgKzJmRSys3VS32zaZsU85Est02qvDuygeQ4S/R6SHWSWApD1NGF0C+DrunkoOZCoXprk0noAeWrzmhL8jpCn0nsr3WldiAMYBj89j2mUpRGzTv1EA9GQ+dzVvCNbwlXKiYd4QV7M7OxziAfsoFR72kF1bHWnUd2vM/9BsDrx32w4eacY2DPGk2mcyddSsoyeDSg52paUZ7tVwxpdH7IadWo45kkFH1l+LjfYJsasCdMRJa28CawLovORsciHbXD9cteC9kxMIBiErw
 AjEepuTA
 tl+7IPw8qTRfAjWqJIsrB7eClqwrMNVgd0dyyQ7zJgjASCjCmmtM62SZJ+1mUE7/AsFr4btFcaaN3DKZbSozBQe9a2RF7rKsxnDUWbGXrT3lSO17I5HQhLVA4GtC8H9PxmAd9e088KgA+A+1syuPcVooVGL16rqiw2HzLpjof/Wk7Iur2ebPSTK9muPNiS4yay/T3I6Nwc69JtYugu37L2zBKXCxzdQDq7wmRoSlcmDeL9ro1G93Z3TWiE+K0ZD0HvWRQcx30ymSotpvpfrePK06JFfTAE6UqI6edpiSNp0bhEml3NFjLrMlBDgV/MyZBDpcgR8vIt/lb1CuiYxfl1Zy3dBDPbGNqnBJMy91xXfxv2JvDTBL36DJoYvd6ZjHZhAFohB8xDZegXtgjBWFpLY297FMiNkSU63kRlp0rH+K4twMydAAzzYXUSdpblt2tVPopimy7QwFrq6I6V+s5KiHHGQNwpKznB4yQs0cnNVXLEqnU0CWRv6VtY4Fn7x35Ao51
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


