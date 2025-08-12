Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7371C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BA48E00F9; Tue, 12 Aug 2025 04:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BCEC8E00F5; Tue, 12 Aug 2025 04:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484D48E00F9; Tue, 12 Aug 2025 04:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 309718E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 004C71363B9
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:16 +0000 (UTC)
X-FDA: 83767425672.07.FB2517F
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id EAD18180007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=DHkR9YIP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLMz5dhvl1HJGifQ8hfDJvvXhldeSDOtxBP6N+/lIpI=;
	b=m6VyWCyvQ/1JPFnudbQla0gIINE/Dl2zljJCE2irALmakI99IWVwF2VS3AxeGdAxeVrJYw
	5oOqF48kkEzUOKuDd7vgFS2PlMA/ySK6SphjX0d4YKm//57h1pj28j8vw/VPlrYpdMt92d
	03rNqjpThTLNHcbUPLXN844bdBq3s1w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=DHkR9YIP;
	spf=none (imf24.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987235; a=rsa-sha256;
	cv=none;
	b=iWA0jBHHroEpcm9c5+MgiYNB2PG8eh1Pj5nHjVU8LuXvbFnRH7NLcPIvsVcbC4g6jPhYCA
	62k3niXxwIYjT7CKYQgrU8rC6tJ2YZ1qYnMPMqAnJvGTC9J8lkwVEsW1QceeQVh8xBjWCH
	Wpe6fNa+rQuxhuQ3RlW+TBBqwaHDY6g=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b91325d79fso150480f8f.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987233; x=1755592033; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DLMz5dhvl1HJGifQ8hfDJvvXhldeSDOtxBP6N+/lIpI=;
        b=DHkR9YIPrxBp6BlOVkVmV3OSE3oabfbIb+xbBy8LWNvyQ2er0b1SrwEdLscLh+0Ise
         79jY17QF/LYR/yuN0s6C/PwFzwiNF5lRC00mhxUe8CO+8vki7vRUh6T5PKdO3foMuKQ6
         Tbliu166BR8RgVc7QxG9ZgpQezhwwVHhme6U69RvfhYCHmqhKTE4Cj96k1Z+oNigaZV3
         +V/Mv7jMZ6RJwXPnLJbWaVuAH/dTjjWldKhRk6LnHOUQOLoowATW7sF7gb7SR0uZd8uO
         gGrvs5jqgt8cNhOe1PE+3v6YXerErRatLbf8Bil3VmdzmCZYY61DZAusHqgHvxZOtETa
         t5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987233; x=1755592033;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DLMz5dhvl1HJGifQ8hfDJvvXhldeSDOtxBP6N+/lIpI=;
        b=oitg6WbEwQld+xfjW3ZLHlkOmhUNL9hrmYRfL6ffgKmY1J6Jt6JIFymzf//hqdGLKJ
         TfNFriTWJ5+1FQlF5bw8gDacAAiEaTQgOICSRxE7WmH7owUmLla8ZZHeaXDWzSxcAykC
         48Ufl8Dtk+zUMZ7oPLW9xRc3n4bT7G1/ykGt/LSkq53h47vlLMi+1kuEkhpHdxR2UtyP
         xpcOKrtWpJkB2alO6UFTMTuF0LUqCh6JxGHelJnlP+grL97Je6u5Bh5rCg6Kp+9RFtj0
         /TJdLEJ0mJa7eesEq+1yLrgCgnkipT7xkitdsnNAFvqzohCCKCOJORumMQ28pFJ0ZuJX
         BS+g==
X-Forwarded-Encrypted: i=1; AJvYcCVVWwqMY7lTbNmoD/QUwzhm/6oMhJgsONd5on5P3a/HKbs1wFeohnwbJC2nYSWYVZJNpMFZvwepUg==@kvack.org
X-Gm-Message-State: AOJu0Yx7omRmh0p8Wc1WKNCPJXCXW75DAzDSZrZspX6qBGiDfTwjfvuA
	Cy7ASQAiOJ8oUNO02EBc9V5b6Ktd2Du/D+w1XS/xufCox/+7l1Pd9ihiqmgijKlr59s=
X-Gm-Gg: ASbGncu/tnToQ3j4J8N29s8+b5ukHQkdLxVj14jtD1ZboYrPIIcK16V3PJ2PTtww3Hi
	MLB5lJbZIn7zUiop/avi7O3so7dr0cTPGS9ceekb3xybGlioD5+2PwtaKCZBQii6VJwql5Bz/63
	kBEV3h3u/u9GPTVQlcASroMIwUGvtT4oqGn3YiwV1mV38q2dVVu2WNyxyP2ZP2eMk79iFkZHTk8
	DLqQz8aBqM8F3CGh65hyEWjZtWsSrCkrsgSQdLqyktI8f6ZQWuc7SDTPr0s5fRD9a4VmqTmrW1u
	xA16WsL+FItMPcQRUnxpRS7LU/A8yqdLJtZNm6C/GzOk9+CRkr3SsQM9t9l/MZJiuZ5E16sEb2f
	rv+7gULMyNfRjyYU=
X-Google-Smtp-Source: AGHT+IHxf1Gheje5mkFJXNbYPspDezEy1ZvwMcDlFzSmLC9pvu7f4uHAGhCZoZHeWbKRH8nD1ty+QA==
X-Received: by 2002:a05:6000:22c2:b0:3b8:d893:5230 with SMTP id ffacd0b85a97d-3b91100ef7amr2091026f8f.47.1754987233320;
        Tue, 12 Aug 2025 01:27:13 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:12 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:02 +0200
Subject: [PATCH v4 03/15] pinctrl: airoha: replace struct function_desc
 with struct pinfunction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-3-bb3906c55e64@linaro.org>
References: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org>
In-Reply-To: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org>
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
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2037;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=8m+uO2wFoz45np2OTah2daZeJ2sZYqJ85l0WVEHKDas=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrX9RRoKDbA/ltwtuJ4EyG2WO60DQb8Pb1vS
 coNAXS4U0iJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr61wAKCRARpy6gFHHX
 cg6XEAC8rNYcNrLRmViE7ypL62cxemJNiwcylZUk/EbB2LmSFdtxh5OdHOiPKfnWYC2WoqdsLeE
 dH7HsjwJepgfYk1itBu8siO7U3geQZasJ159uTbiAa9YW6PHmUFNLgxnltfj37gLl6FVIOgFscW
 mUASI9HQ5leJNQixSLwfniGqS39RegE+Z7Bf85pFZsDV6WOJINocubMK3rhzQecaeIKy+/YhWa6
 VuPszRdtOp16D8969UfaKprxgn5khsdU635KHvTI+cvzk9e+6La7xoXXGoRhTc0TBKf+Ig+hm07
 GPeEeW9mi+drhU3gfbjLHSY0SmdXerDgW9+3wPuV/BgVkVxDtYFYA2jznaWzg/wpFE/WUB8XKi4
 G2aLL8E+K2i512j9KQKBZU6YA6neVMBqab2iwlDJAK+IxaTqeDUx6e+X1cVnsbHv3rrnRLaWCwq
 eLi0qlNEU72l4DXrBAj+KdwVRQlEJ6WOTi+9VzcGlzb1VXu9bSzPS3A9H8hLGs9CZ9dDFjroEPF
 yOavvyND8j+CsN0tdDP9o0bTzuzZFXnJRJJgGXE7W27j9qIsrdDcyec13EvXbDNpFueJ6ERKv40
 g6XWI9ymS8TjdvJf5M6VlxYn8IqVcpF7TYMtLPDn5GPcl+DJqqJAcSFzv6pevX+qiAnP94PLErN
 ARW881PRppyAVwg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: 816bkyrypz6315m5a835h3rd7yiy641p
X-Rspam-User: 
X-Rspamd-Queue-Id: EAD18180007
X-Rspamd-Server: rspam05
X-HE-Tag: 1754987234-621865
X-HE-Meta: U2FsdGVkX19BFSodAdUF8yJMh/mtyCPIOOcpr+nYP57crolPG1pos7LwqQGEszOVhpDxCJaYuUP7LSx3JFg8/rGhz0g7C+7JjLb6oKUK6iLVCSK+dMQd9kWJ4xTHjW31V1jh7mCH8gmiy0vn3lyvl/Lc2v/UP7TD+ccDKUDOnDQt7zOTvYRMn9HZItzwyODm6018I984ZfCvIgzbPWsAWMwaR1EgRVJ2rurgRBX+4bbyVJC5xW8dUSK5lYqvtmK9zN5KFVEZdSSAwstz3SrfdFJoPiymdPn4pTZPChaxIGJrH/LLifXfZabWXGMYtx1QRV86QYXFdwOoh7Knw9mWU4ugyOUzxo4B8kEdnn2ZPQW77eNnFOP8BL997H0HW8BXM8FHina5lUskL3b6tPGiQaR9BoubPNgsUWgGoOJvX5ztfp6ON3XGSkAgQ6zmVzyICl75xpgsgltfahHSeUIg/0Y8vEdNHLAqD3LlCTi8jOa2VHnXx4a4AVASRBoo60DC6V58OBOwHOYG9RqaY01VLK5aZYES67BIk5uCXuaU+YyhLoSByQ1VxtsQzk88/a6rnA3YHPFYwNUCs8mzTkUWvN7DMHRd9zxMvrlh+BDbY42q8K5Wn+6dZf68VbBiIoO69uOqR7iNDP4GEaEI8LQDDPD+fdgTs+DiLdtt7c5jhQsMplsKI2RLpAod6r8l+E8B9rnA7SiMOhJnmrb/wFzzTCmkv1HjbpMp8iimqlShIodMqoUygvucpKMMKU6geiWLXpp1x4A30jzq+7u6T5zvS/E9KFDbpl1pCfJ/2U2s2eq/c8p9PQE5O4Xg8SkkMnJbHoh2ZtEvXvFC4Vr4fLvaK+YnQjYpIQX6cVijsknlI6h83TC7yzRKGHIGpwQL1/ZM8tOX/uLUoHipUsPscH6yCdCceypm4O76mClrdveCmQxAx2k2XlSqiKvm14hG1Avyw6DVxBb6ILQ/6UcAmoN
 DdbL0CQl
 e7RBVLdjMvlUpCbmMpOH/Ez/B8d3INAChDd0Dh7TAS052fgPNpGk//3UmfnsJ0n4tB1RT63o4+uLup3lKJhHJOjuHfq4Mch5xXwE6xcIoIDIkopJ8+YUqLLcdAd7BRZxjqeFh/pwQnPPjOdPgbRlaPUcVQjBTfsG8e41AR3TQRzGLfWvrSp6joQ8V6/NVI0V+sTRYfxkJTTzZVLGeeI7/q9zlPohBAkUwS+fgfZZ2QVOrr0NxxrOF3wGZ4zDQ7rKtLKSMM43udQ15GpHbJblOEVPMflhJ9L0VE+9Fqk4HAdNr5LtFD8JkCPBeiEs4LsDzYxGFP9yH4DnGvYJc2JMz1Y7I+8v7GzmoRUhBd0JtVe2QuOX9VSvg5fSJnhhMq6dcdGGC7d+S4gI38u+QEaUNmlGDQhdE106BS/9uun2fGmUs/K585S44ok44v/COQ2R9lXlbltnC8A/8HjYFxQPF5VTxgNC3rJkQB1olg1cusY8ue71MFfnxBEnIzjsBdd8h8NYiA9n5AjlmYdLIjfpsYq1eYHShOhWDkoxVJ1zQf/RNRMBM1BMYJjBv3vF47foaIuapWq7gXb9vXPk=
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
index 5f1ec9e0de213d587b68f41d3458cf504ee1b21f..51cd0cdc2f5170d024fe984ce8882ed9b3ce6563 100644
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


