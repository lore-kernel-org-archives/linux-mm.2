Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F24BCA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3FA8E0020; Tue,  2 Sep 2025 07:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28A728E0001; Tue,  2 Sep 2025 07:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F498E0020; Tue,  2 Sep 2025 07:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2DAB8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEB6F1DF47A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:44 +0000 (UTC)
X-FDA: 83844165888.27.28D9538
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9D5C220008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="Lj/iG8ef"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/xhHenXAsMplf3u6s5pmBuHZgaTHex9nceZrFvuNAk=;
	b=zmU3w19WjxXbs80JZxZXq4GgxF8l7KIpBpkqkGUpEUTFBLHBYNx0ueipcm0oDlopx3iDhE
	R8EopJU6O+6UgPwM8GbRgbO4M1+ClgdzLnpEMDFsdsNUSiQBZyyOnw3XWyL0xlW+yvFXa2
	amw3mhCaLXIyZJhkcbrRzjYHdVXJVBE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="Lj/iG8ef";
	spf=none (imf13.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.51) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814382; a=rsa-sha256;
	cv=none;
	b=vicm9uKouDyz/FZbmqjNTzY/fwAzcolhx6z4rUHI1r+NV/ktBwfk00Y9Bv0rBdIorhdc9S
	iqx9o6EiRAINs4VMbkZ2nFF44MaML26VE9s1D1Z+AECz9oeVGu5T8Ik2lZ4l7HR/7lTTIu
	gprD16RRZG6WWa6ljZVn0SO+MqGJs/Q=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45a1b065d59so36398445e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814381; x=1757419181; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d/xhHenXAsMplf3u6s5pmBuHZgaTHex9nceZrFvuNAk=;
        b=Lj/iG8ef4ANAIgevgIQgiYKZencopl2+L8UtLhk+gw33/V14oso3d26/jX4rPmHzVk
         L0vZGilCixrmXBukDQhJ+gwttp6N+xT2NClb2U1VSEJ3ZHrtHMVXNVx1mTfxtH5GAvci
         u1k8muSbBWGwsmUE/hkGJFUtDgbQK9jZ2dUI/dXc//MRxU0B7GPlI9FKWVTiWoTr7t6r
         Cu1Qckw4c/o638mNV9/W8ZZcDElj0hNHldrgVnxsBQSGKz+IapliLQgpTM2OmzurJUIC
         ORL+gzxeLUScCRxgepYO8qtjtudWMgnsl9zOoyHBR/GA+dSE2m/Oti6ltOqd77Sp581h
         RneQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814381; x=1757419181;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d/xhHenXAsMplf3u6s5pmBuHZgaTHex9nceZrFvuNAk=;
        b=FGFHL8FJWEawOzqLYJMTYeb4yI50/IYUudK43+53WNMsmzap/1sFIAQM3vOC73jzjV
         AJf68ut+hF+PjECHzyhkCWd+f6lOwBp/BGURAqel3K/ks8Ewzm1AOs74hKjuuMp0ACwI
         HXvIJOW6EdvqOcnFowsZkVBz8EuVZIOqZU5KLhVrVLHlQgYdz/JvEcOAKuOqs3G0SELc
         lrmgsRuxtax5Ogtw5cwU/Ozsvluo2jrZQX5jwG/gmiuoeJDwbiqDy8RrcVy5jgjF0t0l
         JWZw1fCGcZXSPgyVIHfgpCMIHl/CzNzyaxkQjvBdq64KzwWWUM+lwuRBEq6runceMKxX
         KPwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXir4XTjHau4eiqU65DxkI3dqr+1jCIMCgObasu1/znnOzfQpaBMCRsAthaeODUusMo+1SnRHBQiA==@kvack.org
X-Gm-Message-State: AOJu0YzCVirFmjzJDg6jw0ovlXsQjf+RE9XlVGuTlD8/oFSMttJN3tMP
	7/VckmUfCU2PN7lV8jJN6AUOeZ2N1wfw8h3qxV6u5LLyYB9Y2h/M4Zv+pUJOANF/I/Q=
X-Gm-Gg: ASbGncuBESoRTgnqhTNfA04cX+s2xbJ/g72sM/ttyXW9+WbiwmctUEmXCE4pQ3mDVWt
	NUcHPXyuPAVpU2UFTlCQwjwk6GnSMBLVtSvnJFdZOEsxxSVtd1byzmHE7X3rS4DlhoxvLtKzZRn
	Rl30nwGQRP+ZMFYSuQHN6D+tnJ3ZqNyrOc0Oaz8xPKATdGxjYFilX8vMKhYG+dEHf+YtL26zcQn
	7bYKmrZHvP31fWiLS9H+ceYihYAyoNGXNj4j4+s72nze126Uw1jtYXMqtob6KMBE+4H3oDoHtrM
	2trk6YEAIl15OI9e6miwlIDW7PQGgFbt5tWOlsCLoahdgV92UiGhqT/fUpoEZqbhUTWldm5610e
	+OrJdTaB+dFzL7w/Z
X-Google-Smtp-Source: AGHT+IFFcOpY3Utnvjf65Nu64vvFfevq/JcfMRRsoKc8OiO51qRcKypbCk0ggH7PazTdXylK2/FTOg==
X-Received: by 2002:a05:600c:138c:b0:45b:75f0:2d66 with SMTP id 5b1f17b1804b1-45b8553da82mr85386745e9.4.1756814380994;
        Tue, 02 Sep 2025 04:59:40 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:40 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:22 +0200
Subject: [PATCH v7 13/16] pinctrl: allow to mark pin functions as
 requestable GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-13-bb091daedc52@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7303;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=Ad/7ZtxydbTdpBCeQAT3xe1dzmeABB/N+TQC4QQw00Q=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwUnI9ibVpJgIM2CXH34HKUqefNgJQqX111f
 6azmjUqEayJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcFAAKCRARpy6gFHHX
 crI8EACxskT9dEpW5d6LUzgdawqMjxZwRmZyQMOCyV0IKvpVcaQ2Vv3Wr5Hht023kdnijctKCXS
 Ido3+4GIv8wSJdTZQ56I4KxofnDG2vyYeZPNpDoyiWLkH+yc6UQndbBmcs9JBrl+IY9DsH9KGE/
 I4eJI4ZEh7eJ8j56ofq+2BznQPdh9ksHXna1EzYROBLe+wzox6SnIpbHRCCYjjI4DqrN2w0Lsv4
 4LBel3uvwjLe/5Ye+Ku/OgrfFEs6SAN+1X51mLsUeCYW+41xXi4lXCOEUoxR5tWmdb7AswqeTan
 nZ/IaxxY4w2AiOPIGeq4RWgY0Ge5XCUYgxwKgj5SrSjWQ4cmuxOJtznbOquptEloM+cdwFGPrhl
 +hPVaXlKG7ES6gnoBDPkNzXJkRV5YOKTrNa4YXr623pJEa9WEywx9eeg19elGZ/gMFu0SZhm9ur
 8s6tHh7+0t1aqqLPm1w4pdFaLTigqMH3LYRExCoJs5YdGheFHXQ93HqhY2XswD7fr8MfhKExZ97
 /3cj20QdCk2vkJvJlzaItZ2Dy6RNKHd70azroEtYTGiKkMQZ5RX8H+I8Y8YuHHiVkMKHWEncfSu
 V22BPreBipqjNwOdGxc/fGEFSh+Dt9CpW55mvqzwcer+/Fo2Asl9/9tEusw0oLjMWt9BXfiibGC
 QB1qcz+eP8lWwfQ==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: 8zfxumnkxes4uehw7afwj5fo5ze8kqdw
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D5C220008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756814382-261250
X-HE-Meta: U2FsdGVkX1+NWK9Nnd9MmgvuGd19xELI/jX/KntzWsitnhsoW0Z3BZ/YfWKyhDxBvk/wIjb8icBDPbZPz8v2UrsMcmCOsS7V7E/3V7QEDc1DdrewqyBKLqE0R6G/kSFFme/ia4uA89wqyZNbDqvhTvjGLvHcjtsTeobhJ164SLRl84Gt9faHMMo219s8Q22nsMdtbeAWukjZ5gifNI6YZFbLuy+wA7ppp3zarWJHiRVoShGqPsA4QFHcnU1Gdpg1yK/M1YUk7YVztZp6rvjoytV5tKHGdWeefp+PYOk4VHj5CCbrYCqxSrL/Hvj0AOSxuC9SB/n6oUBxkGu7Knn2yRWo3JLyCUQrQgdVNwMi/7CdoJ3Q+p87YNcGnWc+/WQh9vQTqw6lZefBGJstO04QxEq5ocUX3J1sz20OB+QcZK5euneTRMyFeUI+9DzPD4nCYrP7Dudmk19LZFVjChUEjgY4OHNT0ZCOpHZZqSrq3DoeUCGvZBZd4xbqDF8iHPaPOlvpWCBr4I4mL9wh/yO+HW6TV5i56GhCSfNMdgRPsnwG/wDHIlP+QJC/46QI1BTo2Mhe1VyAh+4iLEEREmcBmuzDJYizrj305m6jS7Q3Iu3AMSkFtEKYtlSyx4DNbGOxRmncp/uV5XSJiRaDj6opYi2LlNrtgjxKOpWBRhCfMwadtpuLqbWCS+pk0FZPR0YeiMe+jH39LLOOTdJ9USm13nzch6KA92/1FyXxXE6CxTfoYpxqH996aBXlR6CaHrFTvfoY79Sa143Uii6Atx97Xgz+Odid2YhnCANvEItszCEyn+eKDC2QejBno/fcDh1IXKxrJ3rLzhizfDNdJqbYETbX2gX5oQJaTlHcZD1UInKfP8mtkjXrf3U+kGIhGj53+2KyAO7VLwxeMEwmrWk0+9VT3QYgQQ3yeJ0Su2mUNXWviwA02AEvNuUIltKfuzhKqh4ZtMSwQ03D+d/HbP9
 rgw93l7s
 4w1ealYz2aAwHQNYK8OKESyyF+ZCk1OXb8MndeJKx8Mp+A7SSEot6qzwLv5Ng20OpL2QM5M5RiwPviv7B+GBlj1ocbKA5v9ZXUjFR9d58G868nfY/OAXHEE7iifeM97tBi57akHZaonBTNgswXEyLFXjOEYpV7wZUlyfvpkZFkl7VL4hA5Pyao58NxN3cWam+t2n6qfbIiw4eByoMB5nC14aDmmC5T6+i4mrQJM8etRqr1HKp7AqWi/g90xi9W7syMi/ICNuJDYdE7LSvKlxkWSBjsgGQnHUqg6zEOGLi8AGyHQ15uD71UJ/DOSJHoxNvxh1PBMpEDcu2zzJkR0aZRV1YtXCzFNBDctZEm+R9e3Ye4l158uuX9xyQ/Wm4f51TxVZfF3ZZKYj/qZ4WHk0KAellv8PkqgDRtM7Jg/SVVuqlh84Ckg62O/UJArqifZvmKOF2jGBTAakTA4R5zSgJdtG9KxRrePXaL+OhFun44FWrmg4DddJzB5nIdVPwMIOd7WsW
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

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/pinmux.c        | 46 ++++++++++++++++++++++++++++++++++++++---
 drivers/pinctrl/pinmux.h        |  3 +++
 include/linux/pinctrl/pinctrl.h | 14 +++++++++++++
 include/linux/pinctrl/pinmux.h  |  2 ++
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 07ec93f09334f8ba8f8cbde4c54fd6a894025ae6..3a8dd184ba3d670e01a890427e19af59b65eb813 100644
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


