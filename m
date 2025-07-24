Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E194FC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6628E005C; Thu, 24 Jul 2025 05:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25F68E0051; Thu, 24 Jul 2025 05:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A488E005C; Thu, 24 Jul 2025 05:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 81B2E8E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:24:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33CB2B85F2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:47 +0000 (UTC)
X-FDA: 83698623414.12.7448151
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 265F140002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=I1rxuHaM
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6taTiAJxmvKWwV7MRUnViIWdyftorILSzVZsNGCp2D4=;
	b=h1zutG0kqzoPGSZa6tV1T8WLPgsuYk1lH0SfyqhpS3hs/MhT3YfbKVMj+OG0sWgoHYbVxI
	deJyExipYEbDIfamplGiPBWnTCN4n3731puMEWss/du1e+c2+3fJywO6VXpAuS2QTM9fSJ
	SnHPrPoh7dhU0/nRs/RAMo46OzN5wik=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=I1rxuHaM;
	spf=none (imf01.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.43) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349085; a=rsa-sha256;
	cv=none;
	b=X3gJE1ZOqY7TOaFHDBXSnAzL47T8yo8VQF94iG1xUq3gUqAps71tQ7yxOrwGqBGK8YqhYr
	DRqlevMLSZnmXCW7t9mVevby15xRzDDMDIc+Z+nkxaTrbINgQVmVMVGUXvZKJHyqq5je/s
	/y+sNUkBEKJxiFT51COAg52ygb4WrTA=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4537edf2c3cso7578855e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349084; x=1753953884; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6taTiAJxmvKWwV7MRUnViIWdyftorILSzVZsNGCp2D4=;
        b=I1rxuHaMLEmRAoQWFchmM7f952Muu7E616pnD5byTI/HhRs79fNMCb2xs94icOLdWL
         AwaHsZ2D6BHXxUoYEi064PO0eTkjVlnkL23G/Tpa+ZYvHnXWpFG3SR4ZDZC1OJfUEwwT
         Ds5o0Zw90D4+482ac6OYXe+T9erwkmuJD3y0DKJ44BSJTuohD1Mw09gbYfSEOXY6OpKj
         sDvTbFYC1Dq4Zs2xpESmF2WAoloRcymR4KmQXvCdAdaEkd/O2Pcsu1QzGtIJr7/FsPS9
         OtuxSB6zi3N1wSP7gHdCiI2JLVQ8WtmBLLqXDeRjIbUGa1wCyR01XCHF6pnLgFU8gDaI
         frhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349084; x=1753953884;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6taTiAJxmvKWwV7MRUnViIWdyftorILSzVZsNGCp2D4=;
        b=TmKKZNe5yXY1qaw4uAGReKhqI3+B68LhIEV5gcv6xfm9iiavDYZhWwSQmsMtHSyMHE
         ltH3vSCY3bmypEMH9CUFE8F0IKRPbumVK/Z2GfUslK3a9NitbKyk83cy4NOA4XWKfPrG
         ncjllw9hfjYUoDjsrYQCUfROYmVJyX76yQjGpYqEpsFFOU35ImuzVG+yThQ8E++O4x+K
         TAvV3Sgrs9wkCwlP8MWVt4+VrQFBJV4NdKfdRvDuh7OehLYOFHdpHiArcjhKkEGP9zmJ
         ff3mSIF1DQFivBJ8L/WObZ7UPmgOuHPk3oQvyMnylB7rT25yroknuy6YpRbI1iRuTTKJ
         FtzQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3aG+oh1So96Ct9TjXK6C1endxj/BYBGg2gDHPMlWW/PVNMS5DNB6ERHq+HIjbQeZkQdF0OHlqYQ==@kvack.org
X-Gm-Message-State: AOJu0YxZJIsTggqFlS6X8+NyYPgPVmURJbvcowSKNsms0pOlHBXHDit1
	NdjXulfF2bIC5Ry4ugqCCRFE52uRC7uHAwTsDGoBU2Iy/tzSoHOz1W9wiU1Fj82rLqk=
X-Gm-Gg: ASbGncuBnRoHiBl8c/WFIky7vE3lNPz9uOlWesm0Ty2ttOiczLuZfqu3FlPmi9xTdWd
	El7rhsmWRX/RRaO2QMx1ZErLirVG6tPDE/w6CtoXPcMCN1Tywl9Y4+iV+hw4qIKASkqjOpExt6n
	yeroUSL7rsSHBEj6JLGt2uEn6fxNQbWZ+2MNsUTa8hqwUooAOs6TZ0ng9w89D/YsoWiHpeCFwun
	J6OOGA5TFcTO/aAdFw0fHiM9mi3ETcP0p49qAVouW8QDW4lPvEPfVNpRPi2eY2d5D+QeHuL4LOi
	sQRIxmy/p2RwIL22ZW8ECNXQkd1mxxgq1R1WKAEFN4zC/288jMzgSc5xaoaPwt4tW2OAiFGp2Fk
	7JeWptAsfMs4fksJdohE0SIF/o0E=
X-Google-Smtp-Source: AGHT+IHK0dYi3xsnoZaYbdsoppyUow3KIWIi5jwOyXEKrEo3jgO5fkBiWGVoSb9P3rLxzjmZh7JVig==
X-Received: by 2002:a05:600c:1e26:b0:456:25e7:bed with SMTP id 5b1f17b1804b1-45868c97accmr58794135e9.14.1753349083444;
        Thu, 24 Jul 2025 02:24:43 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:42 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:31 +0200
Subject: [PATCH v3 03/15] pinctrl: airoha: replace struct function_desc
 with struct pinfunction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-3-af4db9302de4@linaro.org>
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
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
 Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2037;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=9XGd4dmoHWG203pSJBEuuDLVpVNcYHStbs3CKo1ub7I=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvRgqw0m/InntV11HHUCE+MGVQkjCMalwIfS
 KMoPh5ezd+JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH70QAKCRARpy6gFHHX
 chrwD/oCtF7meIzX7ZXpLEsgWK2HnP775ycIOrhIwy5EPDMyiNJBCALS6V0nGhCUw2Z9MV0vPMu
 cMvZp0ZAetbm9VKmdQDWRldx4ebo8/xAdFA7QNSl2v9Py+AuX1OymRUpeGqWEgxZdMIMGLePvDD
 J41mLtcuKXxdpZzxVQkJ6eqotgtxLicQ3Kd5nyfAGpPv58pRiSOk8ShfVzgvbDt4Cm+4ZmI1b/g
 6ADxlGARBw7Iv6e0y3aarJZY40cDArbMpSeMsthPxd2ckA3YzpqfFpPoYaqZLzPJLzS9qs+JS9m
 FTPjtr7zEsks8DyXoqQmEomYi7djHBa34IM/+cSpTShC+uUPWxn5WIh+e841X0NjZvqiYltThhF
 TwrnuYapLpqUE4A51spxZbKr86qfYwSaIvQX3GQGjYh7PEcsD8bupfDFxuoNPxI3VJG7QGRDOQv
 WZ3Vmi7GS8vyhYTBQS8uXK9ltMPRVoPNgmGHSR/k0ZSAN6h8loFb6wWYuxhqSgvLEbwtaWqGgH1
 zm84NgtIT/M6kXtus0iI/i4ig4d4UjPmMI/Jhq9pjP9RBSMZu/EKa21utlbG/Go5IGqI/n2vHDS
 SwCRIsWrcI2So3cc+c6i7Sawc/UqzfwIcEMaOpwtlssOTUANHxZLwMt12cdVdexmaqY5wPjLhmX
 qFbRaYrqSoXO3MQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: dg6ihjsc497d5wqeyjpncq3h8neyzb14
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 265F140002
X-Rspam-User: 
X-HE-Tag: 1753349084-661868
X-HE-Meta: U2FsdGVkX19wAQKbBP3ApoZR24Rwq5iZxRgBv/dKtZoRggisXyzKPoo0MC+EWrhhbKyK0ECg+IXBPWs9mgef3+qE105CDkQd/AoUcsjxJGfC9cgcZkR5t7/GqBAPRz2pZM4m5UHCFDyiFqsvVposE9ydUT2PerrRmTywD81ONL7LWqmqqW6QmE1QfXWOe8cXO/X/hKSE9N6F9iWt4BSySGFiYx5WhTfJQ7TQam1Ol6NHAiLNCXYFA+s+QDwlcaV1F8jcCTBNmADwBvzBJJn2DnxkhmoR9esPoZJ/4S+IKOP9KN8cWfeMc5yxHXY3AoQaJ4nJ1uBP2Gz1c8I01/Jy90+8oKUJJGXOhbWuZAPNVqJygJ5K8herjstMNaJrYeyZTNLZOzA1nl3TUy5YdEonqJy4h2MTacCJAlAnBkid1xJ6BKRY2kr6UYph+IOcjeOGds1+zrqR/wxrj8kg0svj1KYSYczvGCMjoJ7tUyqje81BN2FyHHhgJjJzvcVRgAjuvgvfrfK2YiGyn0T0FOSKRi82hK9/dATXK8YTN9SHjMLgxQYWboZF8KegQGBH/2x3K4CuhEE9GLAEECDqd88h7XnubVfXUDrjl8zWvm/pRjYq6nVBjROnpPyqu6FYbhLcr4skue1YBytRaPIurCyWskAK6z1J7DoaTN/bhXSQwem99i58ZBRb0gEBho6yavlmNLLlhm/3CWdURmJGwfw92NGvtuXfvmfAYWFTHi/gSha3bHyazKr6cD5oVSiGv0+i1nqdCN+JlrD+bq7gk4d75H7r5m6wxO03ttfh+1mLhWXjYDUofNgOcSvbfo9sLRPG+KG8fRVAuZzu+xA5UdqMWe3dllrSaK5ZexYM9W6P1SNNkQkYpOyfZz4dTtEn1aDCMTD1Ud73hTktYDFzj5rjQzDY/ElnrLnud4QI8wMyNx4Gu47G2HGkEA3PPWo4mMI46m6MWZbikbFH1dYzqRw
 JpCw9OE3
 zgXsNzupM8d2Vk2ZPS4qBwoTGUST3MxZzem81MscZSvsxTePPfRvwZX+l6p8ykgJw+Co9HjEk7pXLy9T0aEnw9fNi6Hwhtk1Vi3c7IQ0ctnRqnpzEHDsdAU6ARXKmd60fJMYPNhvLHuDD0QTGL6ztyQ8ielJDGvHg7Cs9OSiizeKRswNXuJGR/3YpAGF/3FRdqezWy3Ios+0pvLCEuWdhEJMh6LwiKBTENbA6lpvQW5jYSmtLwN4kDBKC71QEwlJKUklTN5iV+sr4kKaeM9lz3MxVkaK0RdBD16uM3aCVkGXZD5bCu4GvjR82rZ5VyO6V/3pWxCpiDVPAU/P0JOyf8JusvtAu9QVEFwZdUGdExPtIGua7hWhp/pe0jW5Ht3aLsxYNyOWBcl0p+5uiV4pWi0RN0CY7uzQQKCeAaR0nUHtFn6pcT5GcoXKiPQjyX9nET498V7VhL/aYNEQqaT105ZFNikdG63z+FnVtMMa9H5RnT9eT5jy7mGUApi8a7Qb/H8Nr/fG3/zhBd9fX3qpDCIZbVCEn4igHuBQ1CdjE5HYO9M1KNrtl3i1YA6ANTwBoLwt2WzD2H/kvHkE=
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
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 1737b88530c385644a360e8abe583416bd6d3fe9..aa71e02b661c992c117418af910ae157c4f75fff 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -36,11 +36,9 @@
 #define PINCTRL_FUNC_DESC(id)						\
 	{								\
 		.desc = {						\
-			.func = {					\
-				.name = #id,				\
-				.groups = id##_groups,			\
-				.ngroups = ARRAY_SIZE(id##_groups),	\
-			}						\
+			.name = #id,					\
+			.groups = id##_groups,				\
+			.ngroups = ARRAY_SIZE(id##_groups),		\
 		},							\
 		.groups = id##_func_group,				\
 		.group_size = ARRAY_SIZE(id##_func_group),		\
@@ -334,7 +332,7 @@ struct airoha_pinctrl_func_group {
 };
 
 struct airoha_pinctrl_func {
-	const struct function_desc desc;
+	const struct pinfunction desc;
 	const struct airoha_pinctrl_func_group *groups;
 	u8 group_size;
 };
@@ -2908,11 +2906,11 @@ static int airoha_pinctrl_probe(struct platform_device *pdev)
 
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


