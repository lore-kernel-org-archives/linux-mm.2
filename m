Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67991CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24138E0102; Tue, 12 Aug 2025 04:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4298E00F5; Tue, 12 Aug 2025 04:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74D38E0102; Tue, 12 Aug 2025 04:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEA638E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8305D140236
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:32 +0000 (UTC)
X-FDA: 83767426344.20.3713543
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 65185180005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=JXGmGpfp
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987250; a=rsa-sha256;
	cv=none;
	b=Dn0lVoHWG4ZPDqXWNeHTqODcTom3rCIiv6cfB8l4buh1qG+fBVT4XjbMtLswlvcXJk9mEk
	JMlGmLUDF15X+T8ry8ui8rAMFMEjlUv6efJy5kz2woLyjreVJtls0tHr0WuK0Nma9MGD5c
	3Hj1dFW/wmWw11Qheqc7f8BANgs+ssw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=JXGmGpfp;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.41) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNkdBhL4SofepKXOMLPV0ruEBSHstnzYJRcPgI9HdoA=;
	b=7LwIRUSrt3/uxAizKbjNJe6Uc4VwFfKZ+A/kO+YaxPS0fBjdRfuQKRY/m0PQHOv7Ubzobg
	JY6ogzHDRvs4YkBvBgi5qg3eFj+EnQUtY42T0yM2PeKSeqVHg0zFwUVeS8zZPLalypBAMC
	pybzGBeTFfFtZJrZxiprV64v+Tw9Pu8=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-459ddf9019cso16905765e9.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987249; x=1755592049; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qNkdBhL4SofepKXOMLPV0ruEBSHstnzYJRcPgI9HdoA=;
        b=JXGmGpfpBQo2NPKPw4OSWchT1E16GyA3tpe/sy7DEnTa5IHXhryNl5UPQgGsUFpZ+v
         Llqe5Sg/zy1LSkAhuOdqf9w0hA2pIJS4EiO7pda3gsGu6ZhouhHjn/hn/51wmjHhBUxB
         S4IG3z/rYnayh+EUFt7X0iG0aDb4OQPY0PCN7qDOFNYxcSwUr7YS9wIypK5u7MAGMmn2
         rVV7pUu23mmGG4JQp401peEPLtVMbX3NK1EKUPsslk4cDJVXm6o2OEJxPh6DX59FFy6w
         ow6EnHY4CS1S6bBexJ+ivM+/hK9+gBLRf3kfpWCD1Pt3MsAs1OY1l4zQ+llIm2jatyQZ
         UfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987249; x=1755592049;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qNkdBhL4SofepKXOMLPV0ruEBSHstnzYJRcPgI9HdoA=;
        b=jzaOfUGgJ0hEGppMdJcgP4oy+4KLkjun8UAuDgqfXadc72RmvPH6MzW4yL3G0w3Q55
         38Q+sdq5kCkMBIg7KWss87Ku0d8R1Hm+HvYdYkp/7Q9StvddwGknA6N0Ix9ttoNROeT8
         tfEO5oQEgZAHoO2E0mwA8qklvmklr1m8+rNkZW+FQmatAxurhGTwTTc5syF9yQZYwHjg
         ldFX7fgDNCCbHawfrYUKwnHASDJRnsyevYFSTooNlj4+g82Uu9rWyK3Ezp3D8zRNCcCJ
         DiWdrcM+DPB6q3tJfl1ILrE7ZnRZErtmYmmCMg6v7PsSnVlFpqbKabh2InYcjzaBOkEq
         908w==
X-Forwarded-Encrypted: i=1; AJvYcCVVlOMTiOyxvFIADFRkJZicLd+SRSrjjEwkSCLdK2gvtgK3MPH/85NvBX6vkTA8PVTcYhn7mM942Q==@kvack.org
X-Gm-Message-State: AOJu0YxoWPFA788+SgT6o0QY8GVvjXg/juq8Qxw+1NPeogD/4ngWzntF
	JKGSncK9eisvf/4Ff9XssGc7C33GQa5orsfSwc9M26Yw0KbKk0SdsZVTCoKYuPBKFzk=
X-Gm-Gg: ASbGnctwlRNN8pQHtiEktBSEGfgX84G+0Y8eilMtZ2qheO/Cc/HA5Kv7Y8fSp0DHvIX
	3UvIkpANQYBWicnuDdS4lXnW4Py3Yd2wihnRCmfwbIGaezZd6lL2wAdSGYDrzYtykySfJpXY6Cn
	0Gk8GqR8PHinmZcUvyNvui7VzU5AROQznqndtZmiJy9H1x/ZzXfc+kmUXCG9zAN4xZj1z1n5XiO
	NcvmJcdcgNWM5+2qgILQmTAiK12x5Wo0moAy5TEz1WRewAK7mm6yodZ+nKHsKu7GnaWY0hXvbIG
	DFNV8zHxYB3yomLUqC3T7zNhjt3txMi3eeC/VO6Ihj+T8RWEbbjPC/jN/hnwZMWRGu10OOXh3FF
	QbspluHYYx5ud9So=
X-Google-Smtp-Source: AGHT+IF1aOctmbWm54Tz9TzOo9LheJ0g+HtTHoUDuTShXnMfH1+OQDhTbVjjMEL+NvcX3+PUPhfyHA==
X-Received: by 2002:a05:6000:24c3:b0:3b6:d95:a3a4 with SMTP id ffacd0b85a97d-3b910fd0076mr2224430f8f.4.1754987248840;
        Tue, 12 Aug 2025 01:27:28 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:28 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:11 +0200
Subject: [PATCH v4 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-12-bb3906c55e64@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6831;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=O5vQZ4MKE8bL3a5x2rEAk2QUL7J9Hk6iGEI+vVX0jVg=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrZe3Gk6A7K6BuZ6C7ogxwBSW/5+axg5EzCc
 cPcQp7eSOWJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr62QAKCRARpy6gFHHX
 cr5pEADQKhyLMmGAMuIfT6I9nesZoE3YTWBvYFEsHrpHOXW7IcwofY+k/j4lTrHXWiFSH2aSHiH
 h09HksFuzIbVBj3KRssbgyxg1qec25nBDbuq+SG327Y8lzA/ElXT7l06ZMgLIhC6WbM+MwKsbmZ
 fK1xMMKfxJ/FbO2+CMtw2ZK1JEcpsOWRLy48UNMqhQvWhg47T3lFxxjxqJQK75Ga5zNGJif47oG
 SL4wNsfpGlfU1Ol5kRE1A6Bzp8ET/WvJ0S4SHCf9XLEdnkRFfckWCxKnsm3J7OlXIzUQl8D5ahM
 YhgYiQcXC3QYeQ26JOOa4soGndCYmSj48a5PTH+zGR7YM25kOINjlq/okZ0YsGLdZnNDudPbi4d
 ZxpU62lK0QknRASPsHd0k34j6edoSRowVsIJ/81b2ZyduahX2oGqZVO5b4nmaXxWQb14txOwfYf
 LB1eEbstCLY3GEBhgjPb0rvctBDxQxC1W/EPi2AVS0tNMSEte35/6dBiOunvTpLifOS7kV6UJ2C
 0SSFrUGBZGIudW/RB4Giyakl25Mz771OvscKs1Z6m7ebofkxHrHIoQRkKGeEVhs3DrKbP3VQcdk
 +XtwiXOJbfTT8I/2s/LLdvqGESE5IYGwSFp01drsYWOUm79oxdipIdgQjqexu/b1xGghJkJhzXt
 0MEwMGHjLVNQrqg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: nsngmcnb9574tzd6sd9gpm1p8rtp9wwk
X-Rspam-User: 
X-Rspamd-Queue-Id: 65185180005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754987250-663253
X-HE-Meta: U2FsdGVkX1/iE+B1xt6LPJKJxWyCkveHhvO/aDADhGqCgjxSreyP8eHpGvxxFGuYeN19XmsZxkWU/OBJroY4I92WDrCZln2r3qRB8KIgdncViFmcTY3uswN7+eHHzsUNkyfVwiN3h4nUlpPpGdrpup0KLty7rIPgwNgs/VHuJHylOAuwe9uW2hH/PSuQ/KtnyCEOFTvO0SQe0cioeIi+OwinzNd/3FoI0WEikMHBv7K40Sk4rCW6Zed53U7EV9jrK7j69b/w8exVCPR22m46wCyXW5CVrVkDc1jH+yodrbz2/77jZi7x+XHwbmhNjvaFa4BQzmb7k60Bj8sDqI4OsDpb3x05dwQukSOCzr9DpbHWHVMNrcHab4lRDppM8/sc2UrusQiElfTBgTRM21I5N9ew8GXUesMUviMs6u9hpDTXEP60FfXKTgektE2DkQ0m7MHeq0MYAGl6azk2ThsWofV9sqPTE7avaQQU1cl6U4h4BnUJvj06QyEjJmzk5FmG0Kol7xlAsJ5RGzKp3IyVUb+uNRWN4li5+OePWv7JbsYU6K5cc8v7WvO7jGi/lCY0n8hxX2QMZiJa7GxGhnmqL2T+EFb56demsAc7FyYhXuTgxGDld4tCNHLxIPUkwwEbn7pOFGfTghi6s/SOxVsf5nncL0amSR/sXu8ap/89B1d6xrkgseY7p55RJHqBcKeqFo2RNWHINHCmk7dL9hn/W1Mpy7qijOo+tJcqIRzRTFGWn0eypJuvJ0+z9JGe2L4zFsFz60R+gaaN3CpUK6ZhtW5M1cuD4PGEe8J3RN4uLW9xus/EMTSjXJIDBw4TWjviTh4xioEiOTeO9k4QZetddde8iF6upOzyGnjWDSNh3KQKdgLJ7oBmrsCVbSj60VKFhfOd5KCks3EBIo9EaH+A2RKnkUX/sYTlcPg35/n6IMvOp32nZyd7iMwHyrBdey2c1B/Ozfts4r/zwOCbR4z
 qDVCOz2K
 UJGQD4TlKbwwXVfWrdeD+Ce9sWEw+0PAf7wdsFgqYrBLqOOBnBykrhgm4/lyHZyz7nZ7/Vv70/6okyL9yUZaLl5lH2QI/D7mRaVtv6uU6/kOyjgm7szUQJw4fCD/CnQ2emtg6V3l4EUANrwWFWCw5qWloFBnQ3/eblxCOYbKPU0J11sUe8bBpr0Y94TB8WQekxcyWs4/mv7hzy5Z+btyYqwOWeZK/7Dw+nqFJ+NDbR8BuMGISsETSWY2CuT9LD83+2NJqxm4Hte2HFl4RNiXyvg7KxXbIvV1Eye60Ch8yAGUsBSwqlACnWeGvkMS6cxBqZBWjmT11HB1BqY+OaH/o07LQAa8FaNA2E7PjDk7k0zk53oVplJT4nJYAI+4yxaL+UeqJ1aP3RPBBfDzw0nLlX2WD2YYlTfxHwrtE1gKPc63/DDAfZKd5GWeG3/eC3jkLfdtqMmFWopf8stpsDmTqFeKDoQ==
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
 drivers/pinctrl/pinmux.c        | 37 +++++++++++++++++++++++++++++++++++--
 drivers/pinctrl/pinmux.h        |  3 +++
 include/linux/pinctrl/pinctrl.h | 14 ++++++++++++++
 include/linux/pinctrl/pinmux.h  |  2 ++
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 6f5e3ede972bbfa78e279790df359632e2d63485..1f99547deebe085e907a6fc5d66b01deb55cb41c 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -89,13 +89,18 @@ bool pinmux_can_be_used_for_gpio(struct pinctrl_dev *pctldev, unsigned int pin)
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
+	if (mux_setting && ops->function_is_gpio)
+		func_is_gpio = ops->function_is_gpio(pctldev, mux_setting->func);
+
+	if (ops->strict && desc->mux_usecount && !func_is_gpio)
 		return false;
 
 	return !(ops->strict && !!desc->gpio_owner);
@@ -116,7 +121,9 @@ static int pin_request(struct pinctrl_dev *pctldev,
 {
 	struct pin_desc *desc;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	const struct pinctrl_setting_mux *mux_setting;
 	int status = -EINVAL;
+	bool func_is_gpio = false;
 
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
@@ -126,11 +133,16 @@ static int pin_request(struct pinctrl_dev *pctldev,
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
@@ -861,6 +873,27 @@ pinmux_generic_get_function(struct pinctrl_dev *pctldev, unsigned int selector)
 }
 EXPORT_SYMBOL_GPL(pinmux_generic_get_function);
 
+/**
+ * pinmux_generic_function_is_gpio() - returns true if given function is a GPIO
+ * @pctldev: pin controller device
+ * @selector: function number
+ *
+ * Returns:
+ * True if given function is a GPIO, false otherwise.
+ */
+bool pinmux_generic_function_is_gpio(struct pinctrl_dev *pctldev,
+				     unsigned int selector)
+{
+	struct function_desc *function;
+
+	function = radix_tree_lookup(&pctldev->pin_function_tree, selector);
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


