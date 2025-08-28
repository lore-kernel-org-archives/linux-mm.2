Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D07CAC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0C7F6B00BD; Thu, 28 Aug 2025 12:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A056B00BE; Thu, 28 Aug 2025 12:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91486B00BF; Thu, 28 Aug 2025 12:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 974F76B00BD
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 650AB583AC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:43 +0000 (UTC)
X-FDA: 83826629166.07.4E8BF26
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 394BC40020
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=NqyVPF55
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cgLuuNEHZ/uYnDNb6dxgb48v4u6axzoTiam4WWN7C4=;
	b=trZkTojlfUmmF/Vwp9JA25uxzUTMb54CFV+v12noxBYIKx8Pd99DMJUyOwoWkYchTz3qC4
	9ASVKBwev0wz6kUqCbbv/tozp80UbAq+gO1HL3m+tGvkYI6YeGdEhD0UiFqYgSbmTAq03Z
	cwHRcT2f4ZhcoqEv626nWrIVywQbniQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=NqyVPF55;
	spf=none (imf04.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.43) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396841; a=rsa-sha256;
	cv=none;
	b=Uiuj8bFbrZUs1ysMRraWsieY+wJKbH+uzDEDOKLdATvuE6+MXPSG9RaQ454RTE5AQyZTTp
	3UTnQuXZN9DXXH9qU/tUu2WtqZEkUqmgNoz850Xh2WOfwfQfh5AAlOmIp53YpKepvcUy5f
	0lK2aD1kedWmGfM59kY64Ul1NkiEk0Q=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45b618e067eso15724885e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396840; x=1757001640; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5cgLuuNEHZ/uYnDNb6dxgb48v4u6axzoTiam4WWN7C4=;
        b=NqyVPF55NiRWctUVKGZPFNnqtskzgY5sJsy8CW3+AegBUt8qTo2YR+j0YUizffy2LP
         WZZE4jv1qoV1EvwuIy8a5FDdNRzmdpULn8zarotkKUA+8sAlCr4URQQZZM0sKtDJbjPb
         m0OumGhxSpAYVTyU5ke/kyc6qBbDTDPIr63LNvkwsmPlE8rsqbX3Y1glLOVi+1XYZriz
         v33bwI0OKA7sQSBwSdyGfoRyU/HvXIjURibKWIcy//1nDogqiSW8ClroNJ+S8UBpVdOK
         ltM9T1P+0TYxCzpNkB2VOBJAFDzUPge97dtbi9r2ZcBOKA+3y4bKU06GTq3eNE8bzFYE
         IcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396840; x=1757001640;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5cgLuuNEHZ/uYnDNb6dxgb48v4u6axzoTiam4WWN7C4=;
        b=AMUa6pfLx2IHSeso5w39HH+FyrTvVdRG3liykacVL4X2eVgtEqCX5q2NbQU3EkNt6/
         9oRTYcc6q7mibxyAKYSgkNahFKWWooesDMLC3q3wZ3/eFheP1hUciutOqEwFMREvx+FL
         bul45cKz0GS7TbxsIjgQh5HI6vR3mpG2TE90kiaEY+3inKsBfR2+GsJ0YaHn0M+Yur+a
         kd+jj3LKZZCaleXtDs0Rzyk/jg7mxA6dO4FltIyZduN5ntHLWpUEXJQyN2g7AtW24cbd
         XiOcoptNu/kiaMstzT/cI5vFJtLqFpfKF+ZuF1sdhbE2eG9xNZ9Q7V9GiKLxVYgTYR6r
         Nc7g==
X-Forwarded-Encrypted: i=1; AJvYcCUn2YcrKviPJYKPl48rjRLno1ojoPhtfKFgCzh2vU81KOsIzvn8ZuDZknrDYdN/04PBodhjJa99CQ==@kvack.org
X-Gm-Message-State: AOJu0YwVAKcW/TxbNynKEHrD4lbpkA0dMkxw3f5eXWE19HNdbp4pr37B
	1TrA4Qcrei6B2zSCyOf7zMX+DdyzPc6AfmkSuw/IssZPRSbCceKzePan1vWksjX0aF0=
X-Gm-Gg: ASbGnctJowhW8GF9vHxPiNFW+QGk3K4qzI2rgYz2Taw1eX26qyAIRrC4Mor5SAenx2c
	ONujd/OnV4Vr2yk/h5QIRoTr0oAoXPOoG2hsKdcsfF9Cu+3sU/rmeQ7dykDZbwhIvs3CJPzNJ1W
	uuE9cedB7WnSoT/Ot/L/6BLtLyAnNGBXB5CJpWd5zHROg4ceiQNLvoz4Bayf/F+orrkp+JDQAve
	+2s6/mgOnpYryfFb9mgJk0anWSeDZ9KPAgS3DM6hsAyAVlbl6rYDogvPST6tjU/je3EkL1bsrdH
	vWOhLSwYtsFORD7Z0z8AgYiJVe1xv8gpp1pe4pYh+ACspHIlNAZlBBKx5pBEdNV5wyK3Dm0IeHd
	phm23V3QapEQPrneo8PdgXgk1Wb3H
X-Google-Smtp-Source: AGHT+IHY93xJicIhLfSdUidEzVpKHtPobrQXprg+Ck+5hE5qf9qNEqu57kxQutrcB+RtoXUB4WrEqA==
X-Received: by 2002:a05:600c:5246:b0:458:6f13:aa4a with SMTP id 5b1f17b1804b1-45b68b79262mr97078985e9.6.1756396839658;
        Thu, 28 Aug 2025 09:00:39 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:39 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:20 +0200
Subject: [PATCH v6 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-12-c9abb6bdb689@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7248;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=cNbq67lYy5x2lWhqKySAtFll26hPMdSh5sE8Ox6iL2Q=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0PNGB6avixd0d4STpVF8wM5h87O2Lo5z2Kz
 bDbg4b/QXaJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DwAKCRARpy6gFHHX
 cqwYEACp9WcPOcy4gcfDh/LJJl3cXfpEoQwSAP1WBDPryd/nzyb+k1ROOY9B4LpM+IlXz7zoD5m
 4enSFZkdcYJf5OO80aWnvZN+c3oWCigs7WrMSdDoZ2wdPT/iHo8o0otbFvuk0WUlO9iOZPsZ430
 zWyy8AjRs5AxBwxee/C+MI/MsHcTmJxftuxqn/QZSUzjO4HdsYvSRORiDo9LG0IR+XKDC7rIAW6
 Hy2KsGziEum8j+RtK8udciPRz8b4Jrh/d3Ln1xTmqrCL4QhxGKjNiQG9vDHM2ufPi6ZHlWEtGuu
 w0fiUIG8vrnfMwAVz37LYjiYiVuaz3LTNKFy22jcPW/4msoW66y3NBn23pMqkuHVhIqf5BtCPeg
 n6zXZEFx7QbhvYIM7xhxgGciQAlKz2E9WONdxT4V/40OMzQzSHOjnJ0lVi4777IFfOoL2nE2KEL
 W48IdClDet9yldUS/sDS5N/LMmy9SpHdIH25+Q1gdX60QAQCN+NY5yvPMCrzzeaiBRcQGS7ufoK
 3ldEFyHY8UA6PKuNdsK4Ikns5jS/8E+37Jw0lYI+RsahMEx0txavgZA46S6nxj/8gMaD5IK4I3w
 ax66JFhNeIfXBqRZnEfpOh68bNIdhR6i+nG9FUJv4YXhIKoXfbtkJDBO71lKwsBsDHe6v9ZGXct
 OzAWs5aoyt5lRYg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 394BC40020
X-Stat-Signature: cg6x86g6iyns6zactm1mwok8hmkqdwfj
X-Rspam-User: 
X-HE-Tag: 1756396840-171254
X-HE-Meta: U2FsdGVkX1//aYcVWE5W0tub6AbbKvbPNz7wjW15xDEqLpFl3mhHQPfRT5Q11QP1JfkZN1OnZ/x3wrEe5sa2hx0ZZaeBPBtWlIBtHdkO2ohaZI5AuY5gztyFXRUKm8m6x/m/0q2iS7s5KCv+XT2TMt/B4zb/kSeB/By4PcsMsnjveyP/dmeWR0K59SkFJuxbuB56MXBK1Ca5AyAR2YrrUeiomS+odjxoZeU85xcfXCmuf4tuffuEn9iHFu86zS3XkS0KHgK+nZiupw30QRRUlKQjIelv8PzaQpFzZEcrAByEqtDY9kdADuUOo1ojM9VNWqWwwEonY0neg4wcrjJZKOCWVQbgIScV/nHW3WcI6CGUwYLd57Z0ZrccqZsQSuFcwk7vnm3nFeu4pHOqAuq3+5E0kiMFmO0l14BLU0kS4IgMHYIg1djTes0glexLQW7Wo1d2gOJPR1j9hJ+V0BSqKyl2wKj+BA8MsKrtLAsyxrUKMUh8pUQBk2gH4y5OuxRAULiJ7H3JR/hZ4mgSr+I+qCLpaDloHdnaMT5JWHWIz+gmM89XYhs5ATRbPZw+Z5zkiJvLxP9pHJcjDoyozoLgG695ZUekX2pCx0qCLXLLwPZIPd/pY+TtsM5F3bLyA2lLGcHcf1rzORCzqyqVb+pizJ8Vo0PFE6C6CiyK8kJ9o1jNC8r4T/NUHENBeOQ9bWZhzUFsd/X5LQm+Pkl7lbaYSldHawTxwZKekVm3MNbFSVePwjORKyzFUlnz1plu0iG1FKDTCo8mUjh+V+9A6CPPSlBRop5XZF/1oNIFQF1OnYWfBWrCkQRHYCntKVKPbHGFGVShT1jHP6sOdeyCvYlVgz3eC5sXTkR/gi108IebZlHpY4mkIy9EiqEsUbHDZKgOG/3iR8r660DTpoO8VRkoN90PQhgJnQRFwVE908VnyfyrOwVEMUgoAT+VFNULI9CXwytC9AaHKrLNdxdcFfZ
 Cog+r18C
 RB43dQLJQf7RXczk946BiWKn7dEuFTjLZ6GisEiYMjmQ8trf4AuW/4wxB0enEJ+2Pl6uMoZyrpMhloC34DBDFf7AQZ7W1UZsezLqAgvZto9NJCQB89yqyza0xe9dl3aQdHi/Y+o12l1yGbru7Dwdm0KOKn3W5ov8xIZS/0604hSFzvQycffGAserVcb2An4fR4LqQ+KikWNMIRmGraF9U9EtJmdjiBL5QQUetpNF/bNEcTqKX8cGJ7BzA/zq5YFLyeaiZe5x8WO6NeBQ1Hn0fLCyli5D+NiJLWARhVzz2i1Yz3mJ4KMSi6LsMLbhYpZOGzJcSqskEe4mQHXji+G1QVo0vGFzdt6R0nwK19T0rbaINepEJG7lOJUBN3VmGPqd0cQLK/UY4KbnWcz0rwm4s3qCu56XfDjwOwyXWLB2kw9GUEmfxHL6F0qpo8LHw4SNd2ivS93gz7nYi9+w0KFHj9tF7tWNDtda8rR6bzAtPVkXlUb9AqJ8qJB960ZQ9LRPPgns/
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
 drivers/pinctrl/pinmux.c        | 46 ++++++++++++++++++++++++++++++++++++++---
 drivers/pinctrl/pinmux.h        |  3 +++
 include/linux/pinctrl/pinctrl.h | 14 +++++++++++++
 include/linux/pinctrl/pinmux.h  |  2 ++
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 6f5e3ede972bbfa78e279790df359632e2d63485..c01814b5b7cb43acd748153e08ce65f5ca7a7b9a 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -89,13 +89,20 @@ bool pinmux_can_be_used_for_gpio(struct pinctrl_dev *pctldev, unsigned int pin)
 {
 	struct pin_desc *desc = pin_desc_get(pctldev, pin);
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	const struct pinctrl_setting_mux *mux_setting;
+	bool func_is_gpio = false;
 
 	/* Can't inspect pin, assume it can be used */
 	if (!desc || !ops)
 		return true;
 
+	mux_setting = desc->mux_setting;
+
 	guard(mutex)(&desc->mux_lock);
-	if (ops->strict && desc->mux_usecount)
+	if (mux_setting && ops->function_is_gpio)
+		func_is_gpio = ops->function_is_gpio(pctldev, mux_setting->func);
+
+	if (ops->strict && desc->mux_usecount && !func_is_gpio)
 		return false;
 
 	return !(ops->strict && !!desc->gpio_owner);
@@ -116,7 +123,9 @@ static int pin_request(struct pinctrl_dev *pctldev,
 {
 	struct pin_desc *desc;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	const struct pinctrl_setting_mux *mux_setting;
 	int status = -EINVAL;
+	bool gpio_ok = false;
 
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
@@ -126,11 +135,21 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		goto out;
 	}
 
+	mux_setting = desc->mux_setting;
+
 	dev_dbg(pctldev->dev, "request pin %d (%s) for %s\n",
 		pin, desc->name, owner);
 
 	scoped_guard(mutex, &desc->mux_lock) {
-		if ((!gpio_range || ops->strict) &&
+		if (mux_setting) {
+			if (ops->function_is_gpio)
+				gpio_ok = ops->function_is_gpio(pctldev,
+								mux_setting->func);
+		} else {
+			gpio_ok = true;
+		}
+
+		if ((!gpio_range || ops->strict) && !gpio_ok &&
 		    desc->mux_usecount && strcmp(desc->mux_owner, owner)) {
 			dev_err(pctldev->dev,
 				"pin %s already requested by %s; cannot claim for %s\n",
@@ -138,7 +157,7 @@ static int pin_request(struct pinctrl_dev *pctldev,
 			goto out;
 		}
 
-		if ((gpio_range || ops->strict) && desc->gpio_owner) {
+		if ((gpio_range || ops->strict) && !gpio_ok && desc->gpio_owner) {
 			dev_err(pctldev->dev,
 				"pin %s already requested by %s; cannot claim for %s\n",
 				desc->name, desc->gpio_owner, owner);
@@ -861,6 +880,27 @@ pinmux_generic_get_function(struct pinctrl_dev *pctldev, unsigned int selector)
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


