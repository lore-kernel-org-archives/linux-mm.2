Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D72CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90DA6B0098; Thu, 28 Aug 2025 12:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCBE96B00C0; Thu, 28 Aug 2025 12:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93686B00C1; Thu, 28 Aug 2025 12:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E71B6B0098
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BD8458359
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:49 +0000 (UTC)
X-FDA: 83826629418.05.E898A0F
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0310D40022
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=w4GivAsg
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396847; a=rsa-sha256;
	cv=none;
	b=1Cso76wMMy1TnwegcdPwzS0H7WA0N6u5K9NcnrmgAj+HE7N27d7rMgqbl7z9q0a+UPW8tS
	dif1JTmMconOq9zkrEjfntcCTV30lxRO0CFQkH/cpz6QM0hblq1IMW5zloSRwYzipC4Atv
	XE+4Zu+EYBd/iLUh/HxQVuDSIATdHgo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=w4GivAsg;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.42) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAO2WeXDFkbtwkjKyd1xrqU98u0EGyjojmTyXcAuE7w=;
	b=MBy3v7MURfbQbGUKesBCqQPUNDroihz53BxdlKfXn5T1bEfzzRK9CiTlahCeBCkQGnhnsk
	78KWUqzK40ZeKoOO/1kYCSM/8mhjEsc4gYgwsBGtEFfgdrB2OsB+G3HGR1lLhOmBuVJvym
	UeVZf2597C1F3Z8kuCTY4uDSK6+HyfI=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b627ea685so9069915e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396845; x=1757001645; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAO2WeXDFkbtwkjKyd1xrqU98u0EGyjojmTyXcAuE7w=;
        b=w4GivAsgOtle6duUwrmIdALitRtGFJph6KxSAHh8qxiVb5OBxjt+8SPFJsfRQ5JGko
         ykXy5XD6AvFlCU8hxt+Xjw1B2PNHgtv4MOIIoOw877s62gCAdIy5v8nV9wyqyETrXXb/
         JflXNewlJXWIrxAbqh+R7QpK5sdcNUt+U6x+rrkeIRQe5uCdDdQSEye7KFmlVO/KR7lm
         CDIOsM4bxrn8auHoDZjZ3Kear9J9NPtyOZBWQZv7C3UjEgFegT6nAe98TYs27qoSPKJX
         LuL6Ux0fJpNsBbmMWi8zohre5T4JXxKj18HC/Lx9H7cNvXO4dPUdxomxZF8nT6WhgQY3
         m0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396845; x=1757001645;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jAO2WeXDFkbtwkjKyd1xrqU98u0EGyjojmTyXcAuE7w=;
        b=USoyUqizkgrAmKK/DFDvzyQ/dYxtzZnw7sk6ku+pYQ4fVj7aD/oZ3r2fHoXODYdzk5
         QWkwmFTmi1xGFD8L41G1I04FFLuBuzESHKGXGqVSWCFtY74N/rnGkVp2AxkL8/ZmJFiu
         vVepEuNJsIODgQNKjXUK3OZYzyX44SBdcPnf3r71BMG/ccKysiPokhq/0AJCvcBBcVS2
         qXGiHle4bWIIuvvfb9k/TxR3EIADdy4MOJgoW69mbsv5UQx6CkHgsEnkdYYwLb3WVd7T
         OzVSzTE5+sWlC9/VpuQ++jshycadlVbJkPeny5oLypWiJ+459SKYY++fIbYNnyfjMeib
         +p/w==
X-Forwarded-Encrypted: i=1; AJvYcCUGxCUM1ehl8EyD6Z0y58YzrtSC8HBjuoz7L+N7FZR+qNf3j79fFk3k3G9YwLH2BUDpLlu5sR0mrQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/33qaGKoisL7L6ldUQAPHjqSQ3mJJjmBCG00dw4joFrPcgX97
	5iK/6GyWpXgsGLDPafcYqROwsM7NJQt7v5IVl5GFhXqyI2sVsJeZwpv0nMcsNsS5hNA=
X-Gm-Gg: ASbGncsi13QThWE95bUfPFJa7tT66Cz46sQFypa87H137+uKFw28tQGDx3Cb0Dtl5jq
	hhAPQdPgFCwMRL6LDQ6z5zKsVf9BnMTT4iBef8W1u/Ofra1cPRyD0ep12vrYT1/G1dFUbPOJJlA
	o0dIsfX8ESroOh8NMJfyh1mzfE4aua0GcB/fH8NUVp6rdqj72eJmDoia38jZ3C0vcWi9Ya67vdj
	u6h0JEpgCgjew8nVNntRYkBK4uOPVjMbgg0TfZ2tsXX1wvLMGg7zBKM+gqYpToHt58e3sWACboF
	60JHj+c2TrYAe/rOHW9bzdKC110aZSSRENVq8odmvgVR8JU4nZV7J8rKe61UlSw6r5y5zRTNz0D
	v2CfWWzRsVjxOtzV7Dg==
X-Google-Smtp-Source: AGHT+IH9eqAsu0mBkmZO1sLp4iQB82doTTOSGeYtxhUeFPIbPn5xY/WnY8KAWmQi9Jdt7MPymPYo1A==
X-Received: by 2002:a05:600c:4f05:b0:45b:5f5e:f1e4 with SMTP id 5b1f17b1804b1-45b648111dfmr100878215e9.27.1756396845191;
        Thu, 28 Aug 2025 09:00:45 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:44 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:23 +0200
Subject: [PATCH v6 15/15] pinctrl: qcom: make the pinmuxing strict
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-15-c9abb6bdb689@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1142;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=M6AAfE1ZYIqFZsBoDZ4O1bJllvK/6bMXFJ6Zryc+i/E=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0PX+ObgCFGCgqoUrUjW902keUOxgLE8EUsB
 XcES2lA2qmJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DwAKCRARpy6gFHHX
 ctL5D/9vpjY2JraOKI6xQLDzt9TXljIFuNDozQLvzOHyC9MgvKOWbsLqyOrunHPfrNqqKOFBK3T
 KwmfdS1uCAhkPVJFu9+QIjoLLd5p693JFSuHkObJvgCet04MNbRQLB5JHqL6iuH+bu9MyubXgwJ
 krZwBmRMnrDWPenruj6k4hAA2ihAQlUx9GOdKpiLfvYH8b6RAkHtDQPWjO21WqCLg4XFku4EESO
 5IruyaJkV3MTpbYIobh2C/a6mUW8SqezSSh1LG4Bd1XobET0b8+hWmght65TmOvonC+GLe5r2Wh
 pLFBhM0QRVLHeqtJgYx4uIqUU9M0k9AXIOR9238ttf3Ct3ldZ9ZfTONb3jNBXOp9939T7h4ZLpx
 SUaPlc2TzAFEbRUJNonPEbxaaa0+qbqTjF9ltT5tZC1Mlqr8pyzA1YH8BN9wyrbK4N6qH1ty3MJ
 6emE/yXMZFLsGd8hOSA+egnDYIO5BK1s91hpGWU/ZY/fadrMn6UtPYHf85JlfFzmhIlsS9nHjfY
 oLMcdYawGwDD/MdG1Dt9y2yWY+0T4iNxJoUqYKmpisWrARyHw/iR5VjqJFS50k88+CJMB1H36z0
 letY3JTa4NNIETPLbq0dvyWaZmnqCNmCzEgKPyWyC7sxmk66PTtyQoJj32nMAH62uZVZ+A6DZeE
 zit65McHjdrqSGA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0310D40022
X-Stat-Signature: y3r5oehr8wzkcmcun1gybymwf6fros3d
X-HE-Tag: 1756396846-742679
X-HE-Meta: U2FsdGVkX19o9V02NSi05uuD74byz3z4+l8BK261MfKkYLloNiOHtmqvSZ37HjR22eo2BLXB5vm4zSBnskJf+dYnHiVb4kYhaCejNEvXci9J6XE1wZGS7fro2WV3KoCK8dEQ6B42nqmgstKwjCROs81RGDQkn4+kvnpXjC1+15B02sxbWV5dsAklpRNM1e66br0IDvmAplbjzhEmDb5tP3RNRRvzR/FmGS9ACsFe0n+plM808ceubK7RVHqvFuCWw0leJQTjmEDi9y3QQoPkTDRWhlgOtZ61uvXWnUbLvdh+ZeoXJd8jp5ugU60Rq0LRZoX/IWO4MLtKY47ncn2+Go7JiYiwE3bmluKCR3ZTbAYibEFJ1yZXSEHrcWpMlzsZiZQM7Q4O60LUhClO5KMIkVpx3tNDVxy/CljF8DqgsyY9hQzcv4xxVTXd2YQc+T60ZJNPuytdzihDdDmBWxSGkSeynJKq3g3sYr+P/L/kcDZyR9Ypg53IKvndcUHbTE7bjWQUdh5cqvG/Dgq4UiJjZVMRIy4u7KqDKRVvWuxCY1V9VqzuExQV+oMfN2Ztf0pc4eN55ToZM8QBSHYQwTjbzDfv185/2wxkPEWcoXFFmQgx11hWzPnnl18aI0/cQITL9a1Fx2dN1N6qG9C8LP2BtHMT89FyJh62xCfT0eznvoHIfKUKZ/zX0V/iax6ZIKZkmttWMLALJNw8uRNYn8hjc6AkSPa/7EX6eX5dkSrlYsA33IpUP3lHK1bv2VlJOZQoIAGVgB6xnFxmSMzDbqkA7/rTeZq/43Cbiobi7mfmmLguuUWI0sjjVNfU9b+DncljQ61on3j5ku1bffvjUhKXG/34BglnXeGzcdPTqcZlnU1pNYg/NlqqJ1G0B0SmkCbH/TYyLedbYdPocs8cu4iRhTUv4T8naE5VbbRQJJIBVm/VMibvWAvjwDpjae+iA/MOjbGIWMZ83lE2dEfkTfg
 aY+HAMF0
 aZpDAATjWabrzO2UxKZH7WcDLz+wHHGFaDn8TT2Vxp6qDWGdPH7XqpK8vgzWJzTVM4IpMcF4RMJ8Xvc1ZuiQOJwIgKrsJQ6SADvv0M7NU419czRE0OlePyBlGJxXF2z3BITZ3uGjbe96Kn3HwOJuI5qxXrGc6w7wQaPwagYbhH2c5vz8oKk45J7xsmPgwiyJSLp0N7S2w/BRlIYdFIW6KMnH53i0clR9o2xK+va9ZuPjpLBjYzvf+4HCwvprsOJ9dwPr9nUiXwwgDdotPTRx09TWvcabiSd990WjZMcokUpj1TAdMW8ybFbt4zFz3PXiyJyAZMgN1+LuBXETjXfA1bRi+Grz+rxEnk56iLlRkGgNEm9KXm2FhiZnT/CSNWiJB3jGwtN0Q67JhKTgQdv5KHhbPemltrAMj8T4rA7iIpidhnRlcPp7CLTQ9S43mi/7JJYZMHJtGX2+Ob2LazaEmEBVOes3jarL86+eTF69VOIGR17AVCyboLAqk9ixipjExuDB6EVt23RwpZEfi2Fq0YG8bQg==
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


