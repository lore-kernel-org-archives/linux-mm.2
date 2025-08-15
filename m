Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA6BCA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D72A90023B; Fri, 15 Aug 2025 05:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FCF8E0002; Fri, 15 Aug 2025 05:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5009390023B; Fri, 15 Aug 2025 05:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32A948E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0ADD15BB73
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:40 +0000 (UTC)
X-FDA: 83778418920.02.6067F45
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id F109240002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zjkFrdei
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2WJcuXshs43B8tgQ0eqFMBEBoYTyTVQjjLj/OzbqHU=;
	b=1BIzF+yHwO08sQTIvGYWQITkpatXfttXXJjX7EpxH4LweVB1CCoqpstrcLNwZ9t5quLruB
	daOIp2dSLCleDO6ROJg9/nDOR13HaRXxnInNM5W7EyTUU5dnGOJqKHLUxzFg2arNj7g6OQ
	mE/ggbyrK44AP3msV+mOauwE4MiRyZQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zjkFrdei;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.48) smtp.mailfrom=brgl@bgdev.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248978; a=rsa-sha256;
	cv=none;
	b=YRI4+W+FJ6Je0Zh+i023IVSYzE1qM2Qr6y/T3X7HGhsqMe2ur4oQrw+B3evePVazpLCQds
	BQgRAVo/lJvQGpHjD/E8UW4acPzkWPgIoNHEBw/2T/knbP3Euc3nDvogrpdyUA4reQSx92
	AwJex9WYlntBKdFrLYxEMCkJpjaxkCw=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a1b0bde14so9000585e9.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248976; x=1755853776; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+2WJcuXshs43B8tgQ0eqFMBEBoYTyTVQjjLj/OzbqHU=;
        b=zjkFrdeiS0WvtU+BHUi7O735rWdzJN3sb6xK/IWgvnVZUseQHIs7zxMHVNB2Ri8mRE
         qlsrJSDhrLzhzBeg0IPORspsbnvTrsAPHIDzjpAJTdXfFeAK+KciP+D3iCd2R/RJyouH
         +vK1lms9A7pZfDS0GzWjIVH98jgpIFUBpURSfmTNSkmSC9riOX0xMkNY2jJ7mcTxY8mU
         nQZtEUb/YSHtxrlmRbJDcYuiPqFevAAV/uBDKLUldtDiCMQ+Cb7/QQ3y+Xx8WVb8GZy5
         1OFIGa3di9quNxQnLnXStiwoBNl1mmRK00wmslyAdDMCtHIw0z3OEunLrAkDCR7lRTJp
         6gOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248976; x=1755853776;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+2WJcuXshs43B8tgQ0eqFMBEBoYTyTVQjjLj/OzbqHU=;
        b=G6SfZbp1ck2FLhgMSv3xy0uPTrsh53yCt1PTl1eak1YARVPwtnfFzb+Zw6NoMRRUoP
         iJ7HQbdRDJ/0ar6X4PjCkJB0k6zVH0lWNmQgJC5u7Rj71jJFlzENNDC0eVausjc6P5zQ
         xzv+huF35S9sWicN4Q95PV0pbDr9P9jg7oF/KaWIIuzpUniqS+84NhvToLleFCN7ljk7
         IPC+NnJaLfuynkUtAiRWLuT96qKzxfOhPj8/bgJlMYsFvcFu0Pz3NU2irzqDiNfAtC+f
         M+y882dUIUQOYvjRDItx6SApaiIQLpoTse/N1QwpFvBueJRnPIyo7tFxOr1FbeW1jKzh
         /+Iw==
X-Forwarded-Encrypted: i=1; AJvYcCV53pLI5rkvmxen4brjdymOrtFDdnj/621tD2iIdpEc8ts9WT4Tmoj63Uyh611Fo7UNHkD8tHZYIg==@kvack.org
X-Gm-Message-State: AOJu0Yzm07wbJKTMRg5FD+23Y1GCkYhfJvlUtj7ltzyQze96tvXX+o18
	80m1q8P9VgZY5P0rPN7Nb4qEeH49k2HE0i3wCPR85t9ffhoVGQxu/xRs+M4X9HLsgMA=
X-Gm-Gg: ASbGncs7/EtONL9TP+V6c0Pc9LT5IuSNO0giGd6ArgkFUn7oAiPF7jpizzdKWj26n9A
	mr+2SnWDQK3e+nvOr8jbUXssPkz8iBVU+5tQLDQDry6ngiS3OSPDc69WM260x7yrAJdS1TNvHki
	zgY1wuEfE6/oTqre9tm3nsYDX23BsSiQvdFn4YjQNhJmEam5rX1qUzW+IPKmCl24mU4cEtAs0yE
	ZUiSwfMwrum69MKv5NpxDnLVOBgkI7UdW04RACStFJshVeSTGgMD5/cVDNPs2VITyJbTHTDkDZr
	R3QhXpjNTyN99GpYAauPLqrFzrGhwI8lsNjDIZAI2gICCA876VtkbEUbcNkyZVtb2PQ0/DlNO8s
	qRCJrqpBYxr2+KQGoN0Zv0HcLcTAl
X-Google-Smtp-Source: AGHT+IGtFuboeVNKDciYaG+Wue0vo4F6BgRJxWOmOLF1DSz5Cu3XHJ3qRVrOSZqH3ZFOO5JCnPO6Rw==
X-Received: by 2002:a05:600c:b90:b0:459:eeaf:d6c7 with SMTP id 5b1f17b1804b1-45a218578fbmr11412825e9.26.1755248976374;
        Fri, 15 Aug 2025 02:09:36 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:35 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:14 +0200
Subject: [PATCH v5 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-12-955de9fd91db@linaro.org>
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
In-Reply-To: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6852;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=WMZHoUXGJzQjV7RXxreXxMNKpdMVHjmxzsHXmgnkdQ4=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk5bgkY5AXm9FPgfoovthCOalkecv+3yu+Ic
 3T3XjvXPjqJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75OQAKCRARpy6gFHHX
 coJOD/4tMSbksBGkrhvSda2Cd3mhG3iDPTFzcr/DoZYk3If/6C4nByO6VnEq/0I0YP9wPf9KHgq
 Bwy5IGngCFqV4uov0W3dhUrQQuX7lBXzklakhg4DkwhyrQMiOPTf5wkfU8hHdYD9DgIoN7bpWg6
 ZN5X6ZOCsfRhMpnJaecsr/eHvdG6DfTknJ6uMp9uH7/zQ8dcIZarHD3m9ACV9y0tq+Q+hr9xkWs
 1AkVphL5gdR/HstzkuztJDlEnK74CtoCYvnxhPvb5XuLQaf3gtdiTCdAFWjKe4SLJVus/1fXdw6
 B0ODk7/3X+Zfvv/fAe2aRZl7a+glcMhswDoHmtaeJMQiKzO06Xwv0AzfEcx4mJO52khpixxxauS
 XKNNrjuHOeZyifJi9z6kmjbHp3zIEGXILQRqhhRK9T3JaCydQN3L6wIIwVbm16oo53i/w05bSBT
 iOLB6+laIvJGNGQeXDyL5me90VUhmVAKflPgknGK5ZQvlaVsojfdrW6QFT9M1Pk/+yQmZXH2xMD
 8LC/7eFAOzLR77etZjxow/DW6YGXP+u7RiF7Oqe+FonXjipug6doGLhu2t2pQkG4EKr8QjX5CPo
 /vbX8C0DRcZ1v+bRLvxw1aUfyPyto0eROYdnui3xAqZt7ky8XvlnT1WEOMVMOVIhvvZL2QZCKuA
 1gbeKaA6NUwwdvg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F109240002
X-Stat-Signature: 5fogrq5t5z97bt1axeo8b797j5r6bngq
X-Rspam-User: 
X-HE-Tag: 1755248977-707883
X-HE-Meta: U2FsdGVkX19rHvNH3mIDh6ba+TFbHgcKF6hLbguBYFzgManIymO5hxORwCPMrtvXYKz7FmwD0elsvCKhBly6OIKj1DbDrthA1qbIu8+cRqIYIZzjW7Q+YsiRf+XCqKxjilu693eSjzrsiP9BScVGnnwn3+QVS58btU5JzP/QBpIwxE4kJIS81NBtDvzHNtSmhMxvIkkoLaWcta/8CYeKh6Ci3VR0EyvhLZBrbPUkmO+IrAnMAotS6zEbAqtXrJgc4o4MaUPUkUjLTj+zcH19ffTzOoYIFBNh+5YxWZGHdFkCXoE5Z/ooiKtImmowbQ1mBpPlVSWLxMCAkGrAsl9Mm4I4D+Yf4I5d25wUUhbdEAknZgVAJfUkt8NKkafNA1igpwXlAYd30jkSbBHd+13mKSbM5QqlwB20ht3d9OrUQZiOi/ZfdQtv9b057pi3sXliv9mYBtRT2AO8VGzLYYnGRlS3qznEgxJn0WcfAfSo1JbULeA2j4BTpaTNElYT7qZ+CMJaMzsTReShHCmr0Nd5R+FnSCNcL8hD+FXLZsAjrC03djG0MIDYfcQzhWPPHmcEqPqaVtMBDOr79KKzGY9r9+J5sr823BzFRvXY2YpqY41P9V1zyGeXzMoZKIDFJ2mZA9MC8MIcDH7is8EQV9qM1yH6Fj8CoCGF9r+qN0MOU/Rp02CByEhXlx/Ixq6t2JIrlrsc0AEkM4LG0CwQ1v+RVHJuZzXYMrKLYs+VtIaYiYbsVOEhjVr3zMnkt7Gr2v8FHwDmhMrOShnP4F8cm0R8Yzpk7NHXrlgc3DQtKsEVfAMkejU/Dq4cyaP4Yavx2EcpxGK6+3x4M0i/L1S7FM0Gzlv8HHylvOl1yKxbXflGwhkuVG+EYF35/3fuktRIm2U3BSEb0krCS8dUZWMOSq+oo9jsfE/jh4LXfdY2Ox15qhAFwtps4mYdVwvHdUj4RJwXw2jIjaaxKhDcS8MKqbI
 bD92azeQ
 W/fIJgETsj3ppZpboltoiEMH4g3ESuPLNMd6vi0WyMQJAjkGeJcCYFu8kQocnLIprIbnyQruMSXd589wc81KpYmS6CUUQqiFB4FbwX/XtkkmNPVz1lp0LN4D2qpabjSLipUYutkGHQy7uTHb0LFVCAEU3kKD1w1dp5BPAbv3YHRXHh7mwIiFUT0/22euVuMugHQeDOWXjp8qd4KDWA80MpMJezgTJhq+2X1KoyYsel3JY43o7GONV5tfEiwDXkrRcWpRIuzwlE0/77AlM8EiEIgZ3hpR6Ipkp6Mezq3i91M0ppLe3YQd0I/tPY+BtxKXzzrk808fdZXtgmKtREo12sx2tFJRzfNVf1jaJHBrgNTt6W9/pHvEBJD5F1WwL7qg/uPvFR8pPu526DtDBAHiKiJy+YOe4qDhP+phdeISX+WFzbEbDCx2wNNZEMtPDscDpWPVHAe1ZwQIRORVuBYcDmjDMU8j2hRTGNgNh8l6APYxrYk1sKECE6jtxo8nsqHasi+zK
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
 drivers/pinctrl/pinmux.c        | 39 +++++++++++++++++++++++++++++++++++++--
 drivers/pinctrl/pinmux.h        |  3 +++
 include/linux/pinctrl/pinctrl.h | 14 ++++++++++++++
 include/linux/pinctrl/pinmux.h  |  2 ++
 4 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 6f5e3ede972bbfa78e279790df359632e2d63485..730108467bcc226622185b53a1590c683ff19afc 100644
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
+	bool func_is_gpio = false;
 
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
@@ -126,11 +135,16 @@ static int pin_request(struct pinctrl_dev *pctldev,
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
@@ -861,6 +875,27 @@ pinmux_generic_get_function(struct pinctrl_dev *pctldev, unsigned int selector)
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


