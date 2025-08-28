Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B510DCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61CA6B00B5; Thu, 28 Aug 2025 12:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6156B00B6; Thu, 28 Aug 2025 12:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D7C6B00B7; Thu, 28 Aug 2025 12:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D25E6B00B5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E9EF13979B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:27 +0000 (UTC)
X-FDA: 83826628494.04.66BBA3A
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id DB3C7A0015
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=KZpWv7YA
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ojzj3QqHYKTtweaj0hMdOf0hJWBOPE6yGgnAHCkCHqs=;
	b=x+HrL1LXlOkOcxSIZZgNcpiQZMVYWRqn9e1nNUix1tol6uah1LYMFYg7KIptyOshcg5e8c
	0F88SeW60osnHxGz8j6amVDuH0d02dRsZye3Kx95W72kJ4lH+Gt4RFODRECyfC+eQlsPY7
	lfn+cJ6WEg+vjgt10K78RGZ+Ojn+B5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396825; a=rsa-sha256;
	cv=none;
	b=R01EJIPeNhxiG0S9wlKU1tioKB0v0els0E/r6zykPeGSXwtE/i29+F8lqJuYQRD3AaFL1b
	7JJAweixY4ElFxaO8MWFCISm0MvsKhknuSlKYY6zrUfsQ3sUlx72Ls7d7YnV/V1LUnc8iJ
	sXs0aI/YUdUb7qdYkeyUW2QHydXQ96s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=KZpWv7YA;
	spf=none (imf25.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.51) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45a1b05a59fso8223975e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396823; x=1757001623; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ojzj3QqHYKTtweaj0hMdOf0hJWBOPE6yGgnAHCkCHqs=;
        b=KZpWv7YA36kPOAGpbhnzeyEZrHoEuhyuYeI0ssaCxtQZMljY5j7tdBxuUI2X7x5rHQ
         jQH11jZvwmsNIeEa5zOn86FeDxs+DCXgcVOmUTB3F90mnD5VMzvIgtYKh2e0CPtel9up
         W0AuJfTrOZBRI+fipb7pR/tAj2r2Eo33KYZCBc9oSJZu1Ou52pYSlrK1QNGOmSrE2/k3
         /UpIg4UZ8w+K7Y32G7O1dy6f4Ss72DT4L91Q55mlV7Da/a8rwBei5VvJZczDQWNjwZwY
         reJ0SiCBGjRLTRjeR2mM5nFWEi+MN/WbWt2+3gneDAAoJCy4ilyHzkkxadMBKUdUp1/y
         2wtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396823; x=1757001623;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ojzj3QqHYKTtweaj0hMdOf0hJWBOPE6yGgnAHCkCHqs=;
        b=X7HQi3Epg4m9Ma/TZNU4bnGOv3IEY6/K4XpsDUxnfgGUUAFDU+beNJ9bPfNkYNxHwS
         t/O8Mv3QwOsb1yCInDKwRdh+Dmj7tr6HUk1wWZsEfCOEbo1Y89UMTGlIzScK8wyg3R67
         YnyqorjBQv/2fGHpZIErDS25+JDgnjaGZ4+O0+Hdu8KdXg59O0nirEQrwYan8rw+s0Kf
         Q45cW03RpB32U5MhKe4jhD33daq+XUzSpfN4xoUMLIyHYVm/jGUGEW7sRlokCiufoxeg
         HhliP1m8BccgjjkYYBeS5nkhOUzFupLZdzY/2qsBlKQEm5N6Ma7QCUz4eKDHYwOZNsTM
         +MZg==
X-Forwarded-Encrypted: i=1; AJvYcCXwMrvNEsZpK4lYkKWu4VEI+lKSwaX+EUoUK8SxVOzsGPwMkNntd8a39jtjZl4cHOZaUIMXOI6rvA==@kvack.org
X-Gm-Message-State: AOJu0Yz5YiQnsM2wgYSc1carTCRv3UADlLv6S4C/6a2XfNi4iPoQ2BT2
	NB70evYjR3cDfNwZDFUvbtoqo+HsHJTETBF5msaEmUcoxKTh05u/FR1wV+s5KxCdPVI=
X-Gm-Gg: ASbGncunJJNCaPMX6dP6y7a4qt57EcDmCYvLCJD6rJuOrbfSdtR+b4VPvO66inGPb9u
	vD6+FgopZyU0pQS2rcvTwIR5V+j6BbXBjSkHYpUH8NqnbNBJc7rYuZzjlAEEgCnF1KfZwQ6CYp4
	j8CZkGwMfs3G625pJJ6uR+nmZsvE6KlwsyXYGSiGLS/MO7NW1yiV/CRbMeldpAqMgfy66z7GjmJ
	zZDPNiZ8Mg+mwjJaZRPcXj+ZK4ZjNU6JKHetDfNe5ijxvMkgaeEwrYBr3BjvLaY3H7rSoJ6kNEZ
	uSQQmgcDKpRLXnXPXqnmmO2Ti7CqTsJXHfFNeimA2EvNygAbte8DbVLeKEvisQy/+5wRnmWrI4z
	5GPdhl2U0iSXVT9e1Fg==
X-Google-Smtp-Source: AGHT+IER87jaQoeShvQsyVmSj0aSvRTPhiF3pGP4th0wCUHmIaEcNjSjK3S9hh6ajKAZPWgkTqzJEw==
X-Received: by 2002:a05:600c:3baa:b0:45b:7699:fe6d with SMTP id 5b1f17b1804b1-45b7699ff37mr39397625e9.17.1756396823201;
        Thu, 28 Aug 2025 09:00:23 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:22 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:11 +0200
Subject: [PATCH v6 03/15] pinctrl: airoha: replace struct function_desc
 with struct pinfunction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-3-c9abb6bdb689@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2038;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=Q2YZTvBFgTu9mhuvELDYkYIT0089SG8/1kg34izHMkM=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0NV9d/sWbKuAEo7ou0UURrmodfCJaO+QJj+
 5MPwqZx43yJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DQAKCRARpy6gFHHX
 ctzoEADbwEMqx2TH4E23rUTlqfPLcS3fHDWD+epEgWLvTddWUX8zN0lfF4FdFwiys7ELKxR/XwG
 QQO9szL6/l5nLBeTUoJNYd+5mk/+O8TNscJuBmxuWHrkFdS502g9bhW1ECKt6zIdhveGlnOpm6G
 uWluWMTXPYbpEuB7ezYm2R757utNZGn9oMoJOpgFXPoJpfivFPV/oumKI4k9Iy7QThSAon5HZt2
 k0tpgOUW/dRXd3NjVgKI2HKa5db6VTmGO8HljSZgVCiftk7ncKE2Mm9a9iq2oYrDJ1Z2Ht+o+IW
 Rd4fsCsXHoTWenwwIarjTfN8fSBhFWsfQzLZ9eGffhMOkn4HvMkKuthX9hXJN9441LES8oK0K5K
 yeDSnZWt+aqfrHK1oiGHZn3GJaKmOFDdvceLg/lUpV8R2Dc4DUY4yA2lX8NRgTXEawWajpJWElG
 +V2pCZfQmQvH/AixL165s4kQj9MSQUgT7j4g+0QiP9H27ht7qfkRBvNOcSb7LEA+D69MtA9t5wQ
 wQCWYtmFXFIyEttClIKmrjfl0UkXbMWiXX0OdeYgNoIkDG2wJb4jxQFXh9Ck7T9zC7KQrWhrnNX
 IXfuwfBD4wDRjDnT6qJc2SAi7vZcnjaZE1OR00slPWK0bn9dRYLmlRGy3EYl/+YjsktwDYpm1wB
 0XpX32OnfZ6PasQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB3C7A0015
X-Stat-Signature: oayakdkx3acyg1zqbkatj96s4y7kinnt
X-Rspam-User: 
X-HE-Tag: 1756396824-792568
X-HE-Meta: U2FsdGVkX1/lQ9udEyWPxlfKPx2ffuOP71r9eGLSy/u8SA4np2juWvKfG48VwLDxUoPJZxdkNSwv4hYmDZgcoILCwAJZbVZpzWBim6YSElVHwrEJmDbsNY6ISEbVqon2BUJodfQD3KSKpQuZTV+u8bAfg9l+kyv2JKQ2Y15okJgEIQaOYarZvMKzdKf86/cXRg22ScFVrkKgaycO8TCr1fsXR11D5lABoly75jKJCFW4/0RviUPUUVGR/AZ2gXjAseVvu2bUGNJHsY2RbSLUDI3IMQUN9g4myPHItSrJGycJeBg1GA18r+bH/BeIgM6fT3ap4A8xGkAHxEvfcNz5IfYD3RXq1N9JIRhuJ0i/0CP57mT2SKJ2QcEqdz4RgZhDFXNSkHwgn5tp6vK3GkNMstaF9sS/11aAGb/rEntA4ny3wBbdLX42Tf/bPJgHAAMnDUGd8UgzogVpb4OWJtP9FSu3EjrDh0zcqkX3iIPNlsN2I325OmU0RHF0E9MjaqEw1wcjG2Q1fExLaVUozVL67almJZo0Uy0LU7rV76paTDi0qfIu9wKEPNOV847C3RjDjMXBwFHPWxk+MGyo7fuqa0K9OMrRC5kiHQdUBtcBNqvJl4POlj4HntObo1J9CAIgnWKCpaHm2R37HVnIG6CQgfyAGVEHTonfI5NMXB+fV/M0dqT9n1yoINdu/E05GcEDvDFNQWX5SlmCYSHb1LNDDOQisgY/tAA6DZGiinQyoAFWpf6Ij4hST5MllpWgI6fWho7gKnifbcigxO61PSY6g7L6M4hfAh6uj3lm6KDsiMxGivGS4/jfvi/kYNQ8VM6zm9agcWW9RbleXMiyhw9s7L7HSFcEO5xkqcQ7IYSk5AY4RNp22VFkyL7twCNEUI3YHeAFUpKFg9BXEkvTelTn7t86x2Q5t5QQrXxHYfEwAGG2+YiojdOgi+vqAnPrdf5QXEGw3hCXxXt0nmTo6fL
 oz+dJUCP
 1GjKUYRBd/RkSoQ88oKjWMd1fAeDKD5s12t4Z7o/IgRx1palb1GfG4dANnKeLk2SfdHvasbmXOgwaDU7hhKl9jxWqTwiiRMKWaeMEIKtqTJ1pXwBz5lu51Bftm2qNgZ8H511xZaMIqXR4KkdG47sHGu/z72+ojJ1EZ8ld0GQBNp9pwpAZPPq6PV+8ok546Yyh2fU7dc/Xst9z7K0xaXsqRMQ4VOHNUybz3lNznG2+NeyeVMJ5FxNT/II8aL4Aw/2eI0gH/RUTCGQFGdMl8OZQl/8qYgwPYEdSx90t1ceXurXEssQXdi6TzSAsavQtRfTp25iNw9HI/QAsked/p431SEgdvqsmJvhX3NHzHHazUbkL253WzSg6IUzIQPbob6yi36ER9mEfw4bR+lFdCOnO76Eory9UkFoOpsrgE2aHsHCovGoG+3pCGi2/E6egZsI17yM6uAjOOHyQcx1zx2tOqgIm23eAc49fiyUfT/Ytrrl/H1n45S7F/+ohikM12AvAm8f7WoJ/zZ3hfx778cukS3NQHcyRPU70hqR5D0uFR2cf8wILMbVqjaoI8BcUlfEaQFlOqqi+9xvVsMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

struct function_desc is a wrapper around struct pinfunction with an
additional void *data pointer. This driver doesn't use the data pointer.
We're also working towards reducing the usage of struct function_desc in
pinctrl drivers - they should only be created by pinmux core and
accessed by drivers using pinmux_generic_get_function(). Replace the
struct function_desc objects in this driver with smaller struct
pinfunction instances.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 5f1ec9e0de213d587b68f41d3458cf504ee1b21f..eb6cd27955fbe462f479fbe92c785588caee5ebd 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -35,13 +35,8 @@
 
 #define PINCTRL_FUNC_DESC(id)						\
 	{								\
-		.desc = {						\
-			.func = {					\
-				.name = #id,				\
-				.groups = id##_groups,			\
-				.ngroups = ARRAY_SIZE(id##_groups),	\
-			}						\
-		},							\
+		.desc = PINCTRL_PINFUNCTION(#id, id##_groups,		\
+					    ARRAY_SIZE(id##_groups)),	\
 		.groups = id##_func_group,				\
 		.group_size = ARRAY_SIZE(id##_func_group),		\
 	}
@@ -334,7 +329,7 @@ struct airoha_pinctrl_func_group {
 };
 
 struct airoha_pinctrl_func {
-	const struct function_desc desc;
+	const struct pinfunction desc;
 	const struct airoha_pinctrl_func_group *groups;
 	u8 group_size;
 };
@@ -2908,11 +2903,11 @@ static int airoha_pinctrl_probe(struct platform_device *pdev)
 
 		func = &airoha_pinctrl_funcs[i];
 		err = pinmux_generic_add_pinfunction(pinctrl->ctrl,
-						     &func->desc.func,
+						     &func->desc,
 						     (void *)func);
 		if (err < 0) {
 			dev_err(dev, "Failed to register function %s\n",
-				func->desc.func.name);
+				func->desc.name);
 			return err;
 		}
 	}

-- 
2.48.1


