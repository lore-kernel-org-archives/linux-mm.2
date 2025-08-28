Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA341CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336C46B00BA; Thu, 28 Aug 2025 12:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFEC6B00BB; Thu, 28 Aug 2025 12:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1330F6B00BC; Thu, 28 Aug 2025 12:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDE4F6B00BA
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A241A1397CC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:35 +0000 (UTC)
X-FDA: 83826628830.09.8211E7B
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id B26AE160018
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=VMGsRC0s
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sg6yGo5rWgbm4nmbYQkhIExx2oT2rNxy+gO58coC/aU=;
	b=6hZGt1IOC32VHhzgzLWD9vfjkRhLHTRHs3gTMKccFdv9I7C1XgsZ4a8L3P8lzcqVzbDabj
	eCqzVH3fJIoC3UxbwtlEf67F3fO4JlI+avJao6sU++AkDDlBjL9a7SbrXPFWjVdmpXZeCs
	Oi6VTiw5ibzFKGmTl6YKjzkaQT7dXfM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=VMGsRC0s;
	spf=none (imf08.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.50) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396833; a=rsa-sha256;
	cv=none;
	b=v0ODz4d7Lr5eIeIg0fNxFWwmA5mPPfNErGy6JfT6EY8m5QRLL6HUgvjEfHXqCjqNflyIp6
	4Up3idKxr8TYo9rwLRUxjl2RkwmatVMePwCCoi7QUPMXFYTyx6uqxfXQ5/ReyB/4hJR7JM
	zV9O2O9z4hlTdSiISgBC9EjWa+dsc2w=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45a1b05fe23so7081635e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396832; x=1757001632; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sg6yGo5rWgbm4nmbYQkhIExx2oT2rNxy+gO58coC/aU=;
        b=VMGsRC0sKmY7/RiFDllr8XxGBvWzCPxAr6c/QfSSRmAalXvQFTRI9vJjKO+b9je5IO
         Z+7En1xDZ5zJk/Z9JuSbYW/JR8wqOftKeQDnXhtaysNOkIraqsMtXBItiGh/yCMdigTd
         wjua9IvjYwOT1mugH5uDIvXDBjRI0Dy3o2Z8AtNtOEECp+ovk3lIZQDXxgR5BG4ezMTh
         eiJJH8v/yz9+YFsUIJjM4Wl08UEKPujijS0S9OGsrDnJOc/XUBPzYJM3W+HZ9CY1kvPc
         soIVgckR9B/MdJb2p4cTF9nI9si0XQLiLFgR0StRbdvK7K3l95Mei9zStfxHFF4evRrp
         WnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396832; x=1757001632;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sg6yGo5rWgbm4nmbYQkhIExx2oT2rNxy+gO58coC/aU=;
        b=tBfhC/hvqMtr3s+L1o+Omy2NS4DBCN6CyhKhnUgl1DCOmzeI8uQyqKgVKk1pr7ZGnS
         O+3wJF3nD0NE7J633bBORCz3BCm2UbaEa0zQ0wB0TW0CqwYDqGHOKXLb+gU0PxNAYoMc
         ZOjgv+kFGDta+A0coYaosQDfFb7lCdYh1GplnYaeXqoc9Qjfp1l1PbzjTW34rsOKKt2j
         7fclE8O6PzP7X8jKrHveonPh9Jthp9kPfV+nplWFqXk/KMDztqC3vYszko80PMbiTz72
         mlIxb/fksy0Rb/QoQSC8WOrQAS0mDOfqTXJn7XTIKAl64yNZ7geYZQrZtVkwPlyMgzm9
         O/og==
X-Forwarded-Encrypted: i=1; AJvYcCXGvPpIokKTSiFTM3jk09hV/n8sIAdRvBDXq3KsTmIBGDMsu47oFEaD46L/vWIeT7klalinJr2KjQ==@kvack.org
X-Gm-Message-State: AOJu0YyvsZDadw2tjoZqCZg3NAFUXfbb6y4pGXe5T1/0iSEkF9Hpzntb
	jzPUlR3XE8Rh+SBAeyxxkHYB5YYb6sxe6PV4N+m7N/DkBddorR5Y4BeLmHOjf4fCmBg=
X-Gm-Gg: ASbGncunme/QkNI12yt1Q7spfB9YvFt+UWWOu8S6F+ltt5wwz0z/4LgA7fOl2wOr+4H
	VrqeIT3m9sRGxozl6EJu34EqQMo2c02GTz1xGgtmH66g58SxIqVn7dt8wFfy6NnjZMp89iZTcjO
	atKdOMlI6pr0MR3dy24G0LKTyXFmNiMGh131NgiL1GvgtXKvtP4Poylz4CIyctgRdQ/3fcz1jFy
	3/Eo3dUl19BY/i7oakPJGjKqI0+nu2527zlyAGN5kMKQT6n8ujGKgUNQol7o5ZT1hv15nE8toIy
	EXPc65fD048gqsBEujzzIUI9lU/KWuk0XdCtwo6DYbIMX5ImZjrRlbEWZ825DLeAHwsQh6PMwuO
	JOTVVAcrIWk96+RQGIlJiWY6YdA+AXaiuoQZiSYk=
X-Google-Smtp-Source: AGHT+IHLEb+XALx3SQT5OlVRvtOHeQcEx93SoK5JAJJrN3hgR1oVUvTEfB3KUoR77aDoDBkXnhfeRQ==
X-Received: by 2002:a05:600c:45c8:b0:45b:627a:60c7 with SMTP id 5b1f17b1804b1-45b627a62e6mr140635195e9.6.1756396832146;
        Thu, 28 Aug 2025 09:00:32 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:31 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:16 +0200
Subject: [PATCH v6 08/15] pinctrl: keembay: use a dedicated structure for
 the pinfunction description
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-8-c9abb6bdb689@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2974;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=HD9TOJpRmpG6enieox3SLEnzfmanpdaE65mOB6T5MYc=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0OqeB42/YsplOuPBdejGDZ/d5WKJRcg95WZ
 LR104xQjUaJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DgAKCRARpy6gFHHX
 ct8cD/0ZuQK3BRMs5wFLGQuOWZuN0q36r1G7AhQcVy4P7PCRDLcyiRs/WAoNUAxuaMt/WwFIkRO
 hROoXg0+TORn04NnzEVYQhTRbqJnwFISsG27ucFDhABh7y5SOZAAEGAgDlmr87Wj7BXyliVSG4F
 pveiULJuhiooGFP3u3dmVo4/fksZ2iNxe1F6Shfa02B1qtZrPp80GW8KrPmkyWiXmvnBdpr6jft
 smrDNxHL4z1e1B4Q4Vm11l1dWwpD09tf229YOZsHkOJHC+PLAI54oiNWw/e3RbsyJ9xoXCKZL4b
 3UAlirH9CoqoulHfkqYeck+FpiINai8UDbl757HTSOvr5y/NC1SKghf5Sqs1Ltlko+1rCexnQy6
 d3sz1GFWgtO1sMkKdFszISAXPg1mPITBS0afAMVUs+Ubz8zwNQEQHc6Fr1/RryMhvKlD4Ic3qds
 DStKOup5b4+KcfB+dmW2pXus3SYVlmgIVpnuwfPi8aNU6bFwKc08EPXn9LYBDNrVpAl8PKyaXFs
 hMuv74QQ0Rb/0y/urOvaoYVoZZjlzgU5L3OYCWXSaoHyHqC1lFGH3PA3jpMY8wKOJdDOr+Ugx+d
 jppbIfhciMtsHe9+7bBfnwJ2MhpzRZXMsMGY8dnba+fJOj7cYEgnMUFWpcChK9su76J4X0jsLs1
 +9KYwX3UDLTLIwg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: B26AE160018
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 56h119qe9nu3h9eyeqzx5wgxwww8tw1i
X-HE-Tag: 1756396833-488628
X-HE-Meta: U2FsdGVkX19+ksW2+aJ96gld9/GHCF7KY3Aw5xGc/89G/rIG9U3VPn4XIo4OP/9LFQ8v8SsK1QB33kZzNxZMI1VbilNyBtmGCUcatpLOy1OTdsPFNPjChbikJUfWkJ7bJFNHqVGlWUQpFyhMQRWhg14hKtzQbMSyT3kyLAGYaELJNW5gs7SfDyE7OiEkXh8IkvJWon7LHigPfr3elTZ/l0fWRRtebJ1/6w4yq6W2bpwMBVBAK4z9jcMi1Pdm09ylYZd1jBx1m62hneraL84/z4D+Tzq+3BDkrXAWjJwtYvfXjG7ZWC+eEGriQLmxvKeVO89IfTwuDM8TZqdjGvPXvjNVJcAm3MF5vfkpWcrxapK8I4ybrmwXoKMPfpxLq71jWa01v3EDmaAa6qUswR/rCGCuk0GFUjFiX9XquPclozrdK7kuWzzgbCkggFLPNCv+/KUaDoe/oHnsW8DpotSol7vbb9ddjK/M8xfTWBLq//Q7FF0OZXgBWaQLfuJ+kY461OnjH78HLYNl0OkG9Dd6navr3ARB2svPI+GynsfzvxWrOV9cIbF7rNRZXWEpSt/yWSIKnq0A7uxO/Vx66l+vSyYWDPlwm6tWDQlJVHv5JizvdAtQQt4jyWPD0Rq8ZwtTbLyWITEdw5UnPJLDEAFlSxWbPDfxcVmhcS1Tn+aLo+VBRm7mWGSfBeqcpmi+ldNDZOsEE+cknd/y4jogekScN7QvD7rpSIB64BEHyeMvqIOGP3+m7CPCceUzJGCDdjp7N1tEKmMBOQm+x9j2WZO47njPu5yVfuMA9aS8PpEyrKvL5PuwBY/Smv2lyhQNdOQ+dV5ZDIKz3rCohPpKeoTZirJJviRH/VlcfPMwbpgzG5YD1D4pvIXkwj0KIx+oAsknaPNRyDU3+DggfHWAYV7BmzJ21I1lVCLJSUMg+JqXvrCJOvR26OccSSvvvGCcFKgyrF04SudoO144TxgBSYt
 f6JYjnP8
 mu4FvH0URvhwQ6LPOKjITrDBQjwHztAJYQ5da
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

struct function_desc is a wrapper around struct pinfunction with an
additional void *data pointer. We're working towards reducing the usage
of struct function_desc in pinctrl drivers - they should only be created
by pinmux core and accessed by drivers using
pinmux_generic_get_function(). This driver uses the data pointer so in
order to stop using struct function_desc, we need to provide an
alternative that also wraps the mux mode which is passed to pinctrl core
as user data.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinctrl-keembay.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-keembay.c b/drivers/pinctrl/pinctrl-keembay.c
index 6aefcbc31309995ec1e235416b40aab3e4a073a9..e78c8b3ec245aad56e3e74a26d27c41ba4a98281 100644
--- a/drivers/pinctrl/pinctrl-keembay.c
+++ b/drivers/pinctrl/pinctrl-keembay.c
@@ -135,6 +135,11 @@ struct keembay_pin_soc {
 	const struct pinctrl_pin_desc *pins;
 };
 
+struct keembay_pinfunction {
+	struct pinfunction func;
+	u8 mux_mode;
+};
+
 static const struct pinctrl_pin_desc keembay_pins[] = {
 	KEEMBAY_PIN_DESC(0, "GPIO0",
 			 KEEMBAY_MUX(0x0, "I2S0_M0"),
@@ -1556,13 +1561,13 @@ static int keembay_pinctrl_reg(struct keembay_pinctrl *kpc,  struct device *dev)
 }
 
 static int keembay_add_functions(struct keembay_pinctrl *kpc,
-				 struct function_desc *functions)
+				 struct keembay_pinfunction *functions)
 {
 	unsigned int i;
 
 	/* Assign the groups for each function */
 	for (i = 0; i < kpc->nfuncs; i++) {
-		struct function_desc *func = &functions[i];
+		struct keembay_pinfunction *func = &functions[i];
 		const char **group_names;
 		unsigned int grp_idx = 0;
 		int j;
@@ -1588,14 +1593,14 @@ static int keembay_add_functions(struct keembay_pinctrl *kpc,
 	/* Add all functions */
 	for (i = 0; i < kpc->nfuncs; i++)
 		pinmux_generic_add_pinfunction(kpc->pctrl, &functions[i].func,
-					       functions[i].data);
+					       &functions[i].mux_mode);
 
 	return 0;
 }
 
 static int keembay_build_functions(struct keembay_pinctrl *kpc)
 {
-	struct function_desc *keembay_funcs, *new_funcs;
+	struct keembay_pinfunction *keembay_funcs, *new_funcs;
 	int i;
 
 	/*
@@ -1614,7 +1619,7 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 		struct keembay_mux_desc *mux;
 
 		for (mux = pdesc->drv_data; mux->name; mux++) {
-			struct function_desc *fdesc;
+			struct keembay_pinfunction *fdesc;
 
 			/* Check if we already have function for this mux */
 			for (fdesc = keembay_funcs; fdesc->func.name; fdesc++) {
@@ -1628,7 +1633,7 @@ static int keembay_build_functions(struct keembay_pinctrl *kpc)
 			if (!fdesc->func.name) {
 				fdesc->func.name = mux->name;
 				fdesc->func.ngroups = 1;
-				fdesc->data = &mux->mode;
+				fdesc->mux_mode = mux->mode;
 				kpc->nfuncs++;
 			}
 		}

-- 
2.48.1


