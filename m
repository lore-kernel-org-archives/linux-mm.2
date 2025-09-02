Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA56CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3DF8E0017; Tue,  2 Sep 2025 07:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84048E0001; Tue,  2 Sep 2025 07:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5758E0017; Tue,  2 Sep 2025 07:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98BCF8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67BB51609A7
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:29 +0000 (UTC)
X-FDA: 83844165258.02.BA48052
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 53C4F10000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=lBH1GH47
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bswhw1GYJgLkiQcdAy82i30rP02s8V3NVyufQL1WnW0=;
	b=hUDffJmsr1Z8p8B7WLFXqcuzz98hHqoKvzdMEnOPf1v+B8nQes+F3kHn6VuBr65D1hD0er
	cyk4CxeLJO9ne+wCrxAen3WPqjGwwiiGM/ZoiLUY1O4pbiTMDBezLLKZtABlPSadb9+QjM
	2O+7+HA02r2tmIRlxGlH19EeFnFyBr4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=lBH1GH47;
	spf=none (imf14.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.44) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814367; a=rsa-sha256;
	cv=none;
	b=DyF+VPXN7jxt9cfEfQ7W2ShEQNVjLG83bXwUUPRR5umi6TJMSQ56yn+z3mPnkiBu+q37kT
	kv6xAFTFZxjOcf2Q7dQngaFt9sf0bgfWwSdzsT4VY5St67+OD/NLxoqGUZeEUm2VJ/tNNP
	ogEQ8SHKdrtU56EigsD9d2vkyK8OpHo=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a1b065d59so36395985e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814366; x=1757419166; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bswhw1GYJgLkiQcdAy82i30rP02s8V3NVyufQL1WnW0=;
        b=lBH1GH47EO/BIjSGN75r6VR69/nHneapORyfpT7px2Z80QL63BEulprjn0UhHQLTLt
         3AClSgaSeHCogH+l88d+2ZdV2TaRmyUOa9PWUP7wL/0KRLIDTYt0AYSZq1YlkA39jN/J
         fnWczgEnefRw35rrxHPojR70Z46cSShq8EdA7eLuRKxK2SiHdRf/hn/WMP1jVDv/s4+t
         ooaOBTES6+g+IaZXbF6/Mkkkr8vTg+OTzxP8sHbGEZyf5NIATbu8uL6QvOFW6Z05OYHi
         c5Tw+R+qlHxRnwisIB9hMy7BcqEtARWOxndNVPBeIjXdkncCDSOJ7DyXb2u2AXQs7ITv
         yeqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814366; x=1757419166;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bswhw1GYJgLkiQcdAy82i30rP02s8V3NVyufQL1WnW0=;
        b=ohCvZP2SyIAAJVHjAA3TyX+v79jDHp5dXv275b3ouaxk0rf9FU0DYc0FUNawnNMbDI
         I79PDT9AgbsYviAxAh9SW7BM0G7nCGOXvt2zFlxC6KMMtfkhuSMDQi0L1jC9/+rYAP52
         d9QHnrVCxx9499wzM5MI+8Y6VLx5OgFQEs0M9anZs12WgD3VmvVidAQrSD5N+n0384OW
         rj39tXg5yTTZqgficeVCPVB9jIB13E/VOpwsvScLPLq5Yi1uZpJhmmV/NPUhXEKKrjgD
         icbW0VmkW5pFCjaDLmDJWq48M3oB9AqVMOyoHeeUhy2e31XuTHsStWTRN5+JLdWzpoMo
         pqig==
X-Forwarded-Encrypted: i=1; AJvYcCU90e6qBGSOcGHkbLn9V8Yr9NR721ZNrYLp9zGqIr7JOzimVJ5Q4uuBfOeHS7cfLw/j/pg902FDBA==@kvack.org
X-Gm-Message-State: AOJu0YztkveO06817paoKu4EtT0sk7ldHRNJnXvwSV1iNolHO2eKEiYh
	5fTXMpqZeOuzcgdV1JMb3fkPP0vuesZj7sknkNph2X9JeR4qwq8or6zMwcObF+F2uR4=
X-Gm-Gg: ASbGncsaRlVNMNkufObWau2rPT9VSjKkDaj77qzS0YK4nSJDkreHchroi1MhKkMT24W
	m8GNGzvTFQhzmrzHMUtn/mmaluyT+j1n/05krezyk1bXbDZRMdBYHD0zpCrae/CBnaovrnz/iJn
	N8v11LWjPheaGcEb/3+bAftE3zPAoNJamGXmQImFyI/K1YHUAQACbDJLI+oBTk/ZBIw7nyvLZwO
	VnyQSUXlqDZE4MUAAq04n+inIRiS2HvUBfY4DocPjhwqe91PUiKxttmI/o5yR8DSU28CLVOffmT
	G4F2jDsJGnwAB/lwY+R/1iEIJYMCObDbczwCuRt76ZiglbzRbgLFRgHiFAwDO9//keFrQLFz5Ar
	pPfMThyH+XaDi53D9
X-Google-Smtp-Source: AGHT+IGIpBaz6r7FFnIRCIEC0+a7WcaTtJlzxcvaE/LJOrX7ntXW3p38zffYBjnK1uGkAz25Buql4Q==
X-Received: by 2002:a05:600c:1c15:b0:458:f70d:ebd7 with SMTP id 5b1f17b1804b1-45b9353e81amr25870145e9.20.1756814365845;
        Tue, 02 Sep 2025 04:59:25 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:25 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:13 +0200
Subject: [PATCH v7 04/16] pinctrl: airoha: replace struct function_desc
 with struct pinfunction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-4-bb091daedc52@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2093;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=/XFuHQ/ODPhn9fKCd0Ju7j35cIiLPr5VI6W7KxiJtqQ=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwSXkG4aY2cOKQ1+2ZlnidJXDf5tdbvHx7xm
 T6spE59tAWJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcEgAKCRARpy6gFHHX
 ctGBD/9MbKPzAcDoovqTMIPxr8BtMxjfGlz3gLMXljCSbdBNiVKbz5YkKncvqSgoWFE8RgJf0lG
 4MXXFZah6ndL7XHk/j0H5Vk77deGulzZJPpYB/vTdKdTEXoqf2UNSvfFdaCO4GrYQCP918QKMbX
 Y3s5IeIFgdIKmHIOPtdTujxu+9GB19fBzWGn3Xn00xS5oq5wWcLacLqgtBNZ3zbqJAzJ/uNfJPs
 qN4Q0Dmp++ZUAAJw6r6umhTypcX6Zg8iMC61jkRLgnU/D+2n4dWGJizXrMxhUBexefXxLOkpp9P
 sBQ4DwOYb30i6GHdcCw9HykSNsNDvjDGgYjg207NXQ1aVGkE/9pE4CMyafvGn3AuGndzULmR7zt
 F/DShfIHttSBvsvdDThKnIT3lHMC0y8RBeoqEkg7NMd2lj5F2IXSblwbWjmfH2haAU16IoU8K63
 BB1ibO9AbrpHX2s/1ZYVXpD2knkhUXnwr29hJowBAuxojdr3z69Zs2oxlj9hUoQmrs4F+XAqsmB
 XcnxELikDisTVpBMve5oB/fjqGZp2rWuGuC6sykJ5jY00e9mdKF21zIYYBAygClSBwbdekEKGWy
 u9jdXOcXRRsC5p59bShjaSz0LjR1fU877tgST2UoQw6XScesIDYv6cUiRWjgnFQkhjQkOqP8/4R
 AWXs/njP4gntjFg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 53C4F10000F
X-Stat-Signature: kzb444daa71j9rdo1usm4j7oyom45ito
X-Rspam-User: 
X-HE-Tag: 1756814367-397564
X-HE-Meta: U2FsdGVkX19imY7HQTzyl1zaJ29hjTSJrRsg4HQpQ6pRStHIi7AD9NNuU9CIrQUlUyoWkcxZ9wipaCVJjsCAPbZjsv5tMWc0BEIw7yx9lG9yyeSbNS2kQA3EqegfyQNjcHXAXUNUp94R8r6EntJ7IBqabIKgXgd8ayV0qB9aJ4SHb4O7YVP8F3SWxt6nRL74pdFQ9SBZ67oNcvxnmxueaSVsPsggSJd2/Yo7na4KE6xXpy69HCs36uJpCt0T5/INc52rRpG5itltZQ4XTskUNp1+jEVzD0LBnknk53KN1PFLTGmcLv9/RZ59ReyDZGH1cnlbcVcrNEUAcTUiaArH3VAUxLWOPLEklNka5vx17hB8MLsFb+O8j9nJ1NyeXhBUSQnXm7R6oI+gG2leGbJeYMGun/tQW1zcxo+0of6K8Ohxxoo4jQVSqSsOXCuEDvZAWGKI1hlb8t93/4uMaLhOHQTn3/+UGjrcJ3re8Jx44vI3N629CCKmUXkpoDlJHjojaldM5yyWDcwqeWebWIlRU50gi61S9PG6WPtANIfsJ5UDzkG+4Ie25FVtmiLUKWV8E7EjaGn9Cw3RGZfvoOmh8OHvKbE9/2SgmmGPCQ0LSpyO+mCc6fV5yrMihkOVqh6dVyFxg1qOs/z0gTaHyoCC7jpCv1S53rJJVJgOrLFGG+O4nDEG+R5JZSRpuDmpG/k43aKAwO8GhYv9A1E8d7gHgNsE0XgHXFjJvwU9FSbCW8eJ8B8WKEDoI8m+QPL4rSnzAaamLU2MnQSfZxFwMqap94YkHgMqP9ofEc52t6wePNR8WT2vnV85qLUhC+t+MDbF8AGQiQ7H9aTKWGnNIBYZ1pAf3+EMm3Fih7raVic7VNhIngxi106VqDYFnsH07VMKRkMZy0TsjegAeTcIi8gFA/HenSy2OqdTsvsjVmg6e+D+HMyZbLhNB3/OEFiszr+v47HmfUUijpOiZWF+jpN
 cXihNZMT
 8k90TJmIQ0DmJYcmX4EI7ZyYZIGKUawFAGkuF7igBH/IN/cmoH0rZPazSN6Zu+CoI78D+m+OHNgLsPqB1w1bO5DGoNfqiDXr2+1KRTo3hzGeTaPKvBcYLFZb5nf16PAuZ9u9Z8w0ClyoMxlymuANEC1WItN5PMU3J23H/ETC/UnCyjwqyi5iKlXJUYXTLc50cM1jYVt51mHa7qyHFueDUfo6fdsQhKCljTnMHm5SWIer8bd4wvX/sns0sTpV8zI3c4YUZYvY/HZ8kq7E+pD3cmt7wiXSZxhVK+fV7tW+X2RFmJ58W5hWxWLUD8xa83rgVDL1xHXC7eQdhqia2/2477D7rdGTvNXa8q+BUqSuqDUMNo2GkYBhG4YPC821JUm9WMckzSrJAnuo5CFrh/ZV1+VynILhR7lNprgsEkqbalgcXX+kDhpheRti8/ab00DHzAO38IujbNljIMJ6AdLV94ERhf/yuL7kPpHnhax8Hs2T8mWKksvARDcPjefb90o7dHiSiJOmT0ywGQsqlfiNIhHBRUpxjxiOGPLfukFErEcxIfoPaS/Tqk0tKK4nZ0sYdyeJ0i36Q5jOe3Os=
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

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 1b2f132d76f0aff78768ed846e8d5980e5b46770..796dc2461ebae167d9daccbb26c4ef6f358851a1 100644
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


