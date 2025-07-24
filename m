Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AC9C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB198E0065; Thu, 24 Jul 2025 05:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A758E0051; Thu, 24 Jul 2025 05:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B698E0065; Thu, 24 Jul 2025 05:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F012C8E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:25:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF25AB7A32
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:25:01 +0000 (UTC)
X-FDA: 83698624002.18.B768E48
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id B39C320015
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:24:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=uRs2NgYt
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349099; a=rsa-sha256;
	cv=none;
	b=LvCnSQ+PAIoj98EodI+Ld3850vqAMKNAeeS82hO2g1WdIdVGlK7NUCq9yk/O9MfXScfPle
	kPVXYjc8V8TVOZDNAD5HdfhqUbZ5F0s9tzLC1tmKM9UP+jmUwAjvKEvuWaqRnF8Giv8syT
	GV9XOg0Fu6BfHkHaaSRrSFKIsnE8ckc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=uRs2NgYt;
	dmarc=none;
	spf=none (imf13.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.52) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5Et21tlNKz8QCzLOQeaVbz2wkUry/HGWm7xpHNYV/E=;
	b=zhvEw7m8s1JFo4J7TtGHvdlyAaJ42d9INhgf0gedfgiGL0lwp/UXpuzu4IW/RdJzA+Gu6k
	1SkxcJ/FDcKjDs4gAHrRxWZ1pj15bgd34IzSXGJLrZoMoPj9s3ObId5TcJTQuNj/GWoU+z
	gJBNMxYV9wgRq4nRvOK/zXPNoqBO6qI=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a6cdc27438so660326f8f.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349098; x=1753953898; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q5Et21tlNKz8QCzLOQeaVbz2wkUry/HGWm7xpHNYV/E=;
        b=uRs2NgYt2AnhGhmobBOcZoJxOm+Rrt3d61IVyhdrAj/xzbeNVXdvGqtahZtJgwYdgZ
         dUxTaNRR2IGN7Rl/L8kC0QpbeINSy6izXWH/8UeUgM23CqKrx6JgMbi3qo3um0+Tyboy
         FCCnXRrsmzsylOqsfIwciHbZy8rvNIHMVOdEH32022lNrI/i9At8Cdl4xRqxI33kbxpO
         NTimhHd0aoepkK+vTFH53X39CqFPG29tIDeNgYfmTT1cNUeUj8D+dlFxn08dX1UjOwRt
         66EsgYdxl1zRqgB82QrjAcD6ybF/D8Zt+q6L6cD+5dYOxVmt2yq/Fz87bPgXhD3s58RR
         j7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349098; x=1753953898;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5Et21tlNKz8QCzLOQeaVbz2wkUry/HGWm7xpHNYV/E=;
        b=jNTSDKNzDEFcCXGIX+Oimc83WC8H4AP8rWyaFQZFyfyGjXNvi71WuX0rQeCeB39FpE
         vhi7acD20vUlXXJltbjauPtukBoa4mgQf5zGkSM9CpLfpKbxaAOAkTwsLdUFNSDelk53
         nu2voENF0p317ND8lXLV25Yx6Xii4MZ0i1mT15QzZyd8GMf7iLEaJaRvuO68G/SnnJkF
         u6llMa9MW3xfIsESXIE3I7rf52r/ic8zYd/C/Q6JMZKN3ov7+RIrBerRCyog6IaF7bTl
         VGOpVEaL8OYiJjx8y6O01juvQur2tMSLXWINMvVKGH2C4CNOR+InbfJfNSdpUOVdxAU6
         lpjA==
X-Forwarded-Encrypted: i=1; AJvYcCXcyklj7lGNLWKdNudCk3vDtXWq2Tr2sHNx58qb9s0BVrrRBLiHdPHi10qJHYyfkAJiNJ2llWj4gA==@kvack.org
X-Gm-Message-State: AOJu0YyQaWpsdDIWC4mJ2CruYrpshmBfbz5TjEn0rrz3YU5zspFWUYHb
	FsZDR6XCY8hJrbI9A2zdcaK9Req49t10McM7DbLPqTG0jJmkqBLJzjVVZa/YaNnZcmE=
X-Gm-Gg: ASbGncvTXLRorYIhwmKSYBXzFMS/6byIEZm6tMMNNkWXsBqKrDvGvaUEEJWYXM06BpA
	MuHuWmk+fZG7SB+ofGl7JzbdH6Nw4a3XOZGzX/pXnaMuCqg23Cb2bkaa8J2EfgfJ4CEG+a7rBpV
	uj4J6NlW292T9XBcT1Qc5pocdoY8ir0l4kHWBzQDiWGvc6ZiuQJ31GkEJTxWxAF2YwmLDTO0TA/
	Jmhw7KeNeDR1Fj2JR7CCxLxooA+KiMHFHj8/aLw0WnQK+DS+yNlNgRvWgyZsAIbbXN4sQ4X85Fi
	sVMe3xow96eNet/Ni4P9u3Fb6XrALJVrnaTQgE+uczzr0X9WfWhj8wfHLZ7h1GnL5+aq0vhnG19
	rIrOfdalA3h+OlLeBWLgc1ZBDlSs=
X-Google-Smtp-Source: AGHT+IHK9ym35s7NHF150oDopl7CdxsijIcKei5Gs6AFRhmReJ4MEWnZ4kKTub7TlD3dR6aW1McU3g==
X-Received: by 2002:a5d:5f83:0:b0:3b7:649a:6a7b with SMTP id ffacd0b85a97d-3b768f27067mr5266406f8f.49.1753349098181;
        Thu, 24 Jul 2025 02:24:58 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:57 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:40 +0200
Subject: [PATCH v3 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-12-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6779;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=xKvZSJeqL1YS+RHLa6ZJ9ocJVsZVH7/NUKTdgRxyg9w=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvUEkzW0EQIuejJliJGAXd3b4hhn0Y90AKiK
 aMxE033XniJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH71AAKCRARpy6gFHHX
 ctZcD/9/win0ZTkZvv3o5OiADBgTXuQ9ZWagTSXWjrtJX4ta/fmW0osfTxhRQh8DQUeD40zNykY
 ZlumO0Lhv4nMQ5KVmmjzNYUHlhhmaZAslGLbjXMr57XHuqjwh1bzDimxv/YcU+CqFz/EUxDJDBT
 OWT1O88kRCz3ozoMKIiXSfkrtky+GT4VOOK4vasxtmqzfjVoVR2SgJUNZszPdM0wJaYtrY/iX5o
 zpbRdv7eUBksHcBgJS8pS6pIVPkhTVnCYo15H0Ed1VojOsGENvvstFyBNCp01nqZNxnB6w0bsbQ
 W+4cVp6T0bCpksTxYPu3J7hfyFYQ56QQ76Ezatfv4Azt+x/1x7PEZ5I7gRXvFpJYw+YGV+e3LAs
 JZzjN7zQXWD1NhFDFInObmVDoraBCp/ya0qXNqH3qrlm2HbobuvQAFFYt8cCP5aIZXKgBX+MQN/
 t4dR5V7zTs4YukzUhSXpYxR9B+sD4Ui3aQ/GrXLm+r3u0Zu9KamRs64j/7VHFbD5MDMeB2m+q24
 TRG9TOQ5nydi4Yajwig9MqOEPQ8ss4zaUfOm1ObHbWSRIVTQVlrzKIBoVGyLzQA2c4GwDd02eTd
 E13s+/MXe+gZmBCllLp3OCEpGtPQlsgrWqYuTFY4QYPRiq7jYWdxF60a/QnO9caJyCVH8nsniom
 GbDpdUV96wJsDTw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B39C320015
X-Stat-Signature: 51dztkkf4rj8btieheprcr5xyk74r5yi
X-Rspam-User: 
X-HE-Tag: 1753349099-59026
X-HE-Meta: U2FsdGVkX19ONwmd47W/l0DzLfX82WteCp3xbuPncVp2NADX5AXRCupjDKDiUxtTuXEQjC8IaddtQjKIuXdm1dC37xZ4o9H1Zxj+LrSCXHZkrbO+UOOL/S9hQ8DxffVFF04ddBd9lmygUuf4xjP3rw6H2Sda0Jm2roplkt3avhxlYvdbAI9A7hi8Q9PSOvU2W1ZDnkEPl9jL/yYUbpyDhnTeQJW64dGCdyazRddgY8oyqAtJEQ3cUd5TllcFOLTlFY7XGOJgxBXGcW3ZJErij14uJZbYnXyHvrE5lnoDNwrV0HgmHIN+4uumcPPb2LglnHmnChAeGdiddfJf1ZhH1UGh+254HvxqhOa6WATrPSIFUVD8rlN+djzv/GzA4m4tcuzGoYwzqGAlwMDyzaTN2Z4MrBno+gWAj0BZ0sOU+KKzzhJAuaEpcSBfU8kpz98meNEHY42DwQgtRfqMzuv+5X4Udu1QVQiPRS3wVyJTpsQQLdSPaGHIwSFGswXnNqko6dInBGU92KnYHa1BwZARg3lCv5kQcub/yYGUTjRUIdCYAPKgvQIFIoCQmm81A9HKwUg/rdQdbbOkkH/fOkr0iQ3iENlNzlMah9EO5t2/AJXKHQvYpKPlrVE/1B0oLaNsTSp5leS6q4OQkWI+n1VGJ4s0sTSq70PTxXkhg53eQQ3RNXXm7pDgOqFS7Paboew6rfyBADsF3ikaA9kLPBKwY5VRVRraBL0v1DPvVoXEZD+0HZDjqXB6U0CwAeB4AQrJgRwaSoRiG+TQjLzoXL251+k0uWShJ9ZtaMy0boCsNkj/dToDAxO8ifuAndUeX+6eIqeBmN/gmkWtispHPJWyRPHwv0PhUSVi7ipWwxmWBQulFVJUcTKAHikdHPPezBir2vGMtxUbFKQsQFIHtLn9cicCADvKLJrAB3zfB+Q1lR/ETg2pgwKqgqAEJ3H3IDfcxQPplXM01wjq809vHGU
 Z79sSakP
 3IydRLO7Y0HR3A2f1dhNd9q29GIo5ON1sJhwx7B0Hq3hvtbR/a+73KUZxQv3/O/6ULyNbnb3Nnzqdy2z+CLqaTK+7/QP/FaUPU7Gm8MQbfKjM/B8m4kdax3WFcFvyk1Ob3KPMoHGTP7RmksSjUccNdSFLgZMH97rulgjq/8dDhaj0PGmkTu+i/QteEqI79xXiKLkYNusjUAHUQgH5J0abLgT6p3ASmqjA9NQamw3z5lJR75NeRdaxhe6uJdVhpPaw2Ta2Zy2vg6qypfLfobQyXf0G44lXGcHXP4wurM5GQN/zL1PldUr7JCR0seZGVkqltJPLl/SEWXaAhJs0yHfpcOD7ENQXKkf2Zdxzjczf6Qtl9TraQQQT53qHbDRjN4QuUhRnCCPgzu0yVre5zjbkRwbJwNuh9cchWEMqnwka5+cHzcje47YUk1VWozmGlUt8y8k7zOlCVBTyUt1v4hSfC/vo8pdUailpuQJ0uFOPrNzvwBQBqfc3uJksrmE1uuVZPg3yZVdzgIGmutVnm12j2bVnWpS/LZS+GiSi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

The name of the pin function has no real meaning to pinctrl core and is
there only for human readability of device properties. Some pins are
muxed as GPIOs but for "strict" pinmuxers it's impossible to request
them as GPIOs if they're bound to a devide - even if their function name
explicitly says "gpio". Add a new field to struct pinfunction that
allows to pass additional flags to pinctrl core. While we could go with
a boolean "is_gpio" field, a flags field is more future-proof.

If the PINFUNCTION_FLAG_GPIO is set for a given function, the pin muxed
to it can be requested as GPIO even on strict pin controllers. Add a new
callback to struct pinmux_ops - function_is_gpio() - that allows pinmux
core to inspect a function and see if it's a GPIO one. Provide a generic
implementation of this callback.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinmux.c        | 36 ++++++++++++++++++++++++++++++++++--
 drivers/pinctrl/pinmux.h        |  3 +++
 include/linux/pinctrl/pinctrl.h | 14 ++++++++++++++
 include/linux/pinctrl/pinmux.h  |  2 ++
 4 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 504dbb3e97cf334e39b49121137c6768081fcd40..52623b47cc87b49b649610eabfa547d7543292dd 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -89,13 +89,19 @@ bool pinmux_can_be_used_for_gpio(struct pinctrl_dev *pctldev, unsigned int pin)
 {
 	struct pin_desc *desc = pin_desc_get(pctldev, pin);
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	const struct pinctrl_setting_mux *mux_setting = desc->mux_setting;
+	bool func_is_gpio = false;
 
 	/* Can't inspect pin, assume it can be used */
 	if (!desc || !ops)
 		return true;
 
 	guard(mutex)(&desc->mux_lock);
-	if (ops->strict && desc->mux_usecount)
+	if (ops->function_is_gpio && mux_setting)
+		func_is_gpio = ops->function_is_gpio(pctldev,
+						     mux_setting->func);
+
+	if (ops->strict && desc->mux_usecount && !func_is_gpio)
 		return false;
 
 	return !(ops->strict && !!desc->gpio_owner);
@@ -116,7 +122,9 @@ static int pin_request(struct pinctrl_dev *pctldev,
 {
 	struct pin_desc *desc;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	const struct pinctrl_setting_mux *mux_setting;
 	int status = -EINVAL;
+	bool func_is_gpio = false;
 
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
@@ -126,11 +134,16 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 
+	mux_setting = desc->mux_setting;
+
 	dev_dbg(pctldev->dev, "request pin %d (%s) for %s\n",
 		pin, desc->name, owner);
 
 	scoped_guard(mutex, &desc->mux_lock) {
-		if ((!gpio_range || ops->strict) &&
+		if (ops->function_is_gpio && mux_setting)
+			func_is_gpio = ops->function_is_gpio(pctldev,
+							     mux_setting->func);
+		if ((!gpio_range || ops->strict) && !func_is_gpio &&
 		    desc->mux_usecount && strcmp(desc->mux_owner, owner)) {
 			dev_err(pctldev->dev,
 				"pin %s already requested by %s; cannot claim for %s\n",
@@ -861,6 +874,25 @@ pinmux_generic_get_function(struct pinctrl_dev *pctldev, unsigned int selector)
 }
 EXPORT_SYMBOL_GPL(pinmux_generic_get_function);
 
+/**
+ * pinmux_generic_function_is_gpio() - returns true if given function is a GPIO
+ * @pctldev: pin controller device
+ * @selector: function number
+ */
+bool pinmux_generic_function_is_gpio(struct pinctrl_dev *pctldev,
+				     unsigned int selector)
+{
+	struct function_desc *function;
+
+	function = radix_tree_lookup(&pctldev->pin_function_tree,
+				     selector);
+	if (!function)
+		return false;
+
+	return function->func->flags & PINFUNCTION_FLAG_GPIO;
+}
+EXPORT_SYMBOL_GPL(pinmux_generic_function_is_gpio);
+
 /**
  * pinmux_generic_add_function() - adds a function group
  * @pctldev: pin controller device
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index 653684290666d78fd725febb5f8bc987b66a1afb..4e826c1a5246cf8b1ac814c8c0df24c4e036edd2 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -169,6 +169,9 @@ int pinmux_generic_remove_function(struct pinctrl_dev *pctldev,
 
 void pinmux_generic_free_functions(struct pinctrl_dev *pctldev);
 
+bool pinmux_generic_function_is_gpio(struct pinctrl_dev *pctldev,
+				     unsigned int selector);
+
 #else
 
 static inline void pinmux_generic_free_functions(struct pinctrl_dev *pctldev)
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index d138e18156452e008f24ca06358fcab45135632f..1a8084e2940537f8f0862761d3e47c56c8783193 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -11,6 +11,7 @@
 #ifndef __LINUX_PINCTRL_PINCTRL_H
 #define __LINUX_PINCTRL_PINCTRL_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 
 struct device;
@@ -206,16 +207,20 @@ extern int pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
 				  const char *pin_group, const unsigned int **pins,
 				  unsigned int *num_pins);
 
+#define PINFUNCTION_FLAG_GPIO	BIT(0)
+
 /**
  * struct pinfunction - Description about a function
  * @name: Name of the function
  * @groups: An array of groups for this function
  * @ngroups: Number of groups in @groups
+ * @flags: Additional pin function flags
  */
 struct pinfunction {
 	const char *name;
 	const char * const *groups;
 	size_t ngroups;
+	unsigned long flags;
 };
 
 /* Convenience macro to define a single named pinfunction */
@@ -226,6 +231,15 @@ struct pinfunction {
 		.ngroups = (_ngroups),			\
 	}
 
+/* Same as PINCTRL_PINFUNCTION() but for the GPIO category of functions */
+#define PINCTRL_GPIO_PINFUNCTION(_name, _groups, _ngroups)	\
+(struct pinfunction) {						\
+		.name = (_name),				\
+		.groups = (_groups),				\
+		.ngroups = (_ngroups),				\
+		.flags = PINFUNCTION_FLAG_GPIO,			\
+	}
+
 #if IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_PINCTRL)
 extern struct pinctrl_dev *of_pinctrl_get(struct device_node *np);
 #else
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
index d6f7b58d6ad0cce421aad80463529c9ccc65d68e..6db6c3e1ccc2249d4b4204e6fc19bf7b4397cc81 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -66,6 +66,8 @@ struct pinmux_ops {
 				    unsigned int selector,
 				    const char * const **groups,
 				    unsigned int *num_groups);
+	bool (*function_is_gpio) (struct pinctrl_dev *pctldev,
+				  unsigned int selector);
 	int (*set_mux) (struct pinctrl_dev *pctldev, unsigned int func_selector,
 			unsigned int group_selector);
 	int (*gpio_request_enable) (struct pinctrl_dev *pctldev,

-- 
2.48.1


