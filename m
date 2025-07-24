Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E143C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890068E0066; Thu, 24 Jul 2025 05:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868C78E0051; Thu, 24 Jul 2025 05:25:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D6D8E0066; Thu, 24 Jul 2025 05:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 651238E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:25:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4397A1D9F50
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:25:03 +0000 (UTC)
X-FDA: 83698624086.03.CFA4AF3
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4520F10000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:25:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=TrJ369Wb
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4qKUQTrFUgO06PuEy2CFUi9trDjc/5HjRv1X5gVEhM=;
	b=6RUnQCUq8C1AJ4cXwjrbtYFjaVtOghcyEssZAfz4frQBdbwPvPhjc/lu4R6ajiZMYgp53j
	txqVswlGF25pl5FSpFHedZsKUD/4k1oSDCzwxe3HVFBnVhDm+omTR2NSBo0wYE5xN5Gg/J
	Y7ROuCkM+E3C+f14+gE5urldzZP3++U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349101; a=rsa-sha256;
	cv=none;
	b=lLGplzQEZgKV4kcX9eUhOi+XJbtz9aE306ug9n2NHOgTwKKkkQgzja9Lo2HnOnc4cYnPP0
	YF7f+gAaLMDaMXA6DaRtcZEyPhcfE7DfxTKQFsNWFvbJs97EjvjBH8mOVeEevRPsCf388W
	3vD1QV3+Jti5fiwS7tfw2gSskrBhiHs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=TrJ369Wb;
	spf=none (imf14.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.43) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a4fb9c2436so384764f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349100; x=1753953900; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p4qKUQTrFUgO06PuEy2CFUi9trDjc/5HjRv1X5gVEhM=;
        b=TrJ369WbhsCf3TgHNOfKybu4NgECYR3eIeUxsWqOwdguhvLFIRpg5TOAKmFlLXG8oQ
         49kIIE85kifqzI9mI4cUpzLW+I/IIlrCqs3DuOYm0EaIPOCPH7aITNyq/8DdR9C0rQD7
         4PDQXXiQvloskaerLJYImxnBBPaArf/363cg/a9mXLMlrnHuTy10uZFRMB05J+yDTX5L
         BBgDD9C+JWQ9+KUV82Fj/oELTqe24+BswkUGqQ0gR43zBudES/j+8gY2puB2UICm8BEn
         0KGRxqLGF9jL22VNP5lDn9w1FViPg3VjFpp1fHvWiIIgD5iQE/Nfyol0LNpP0DSD8VCk
         DD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349100; x=1753953900;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4qKUQTrFUgO06PuEy2CFUi9trDjc/5HjRv1X5gVEhM=;
        b=TwqmwPoth9FT2vxx6tD+lL4JZ4X6SwfG4NtKy1n5o2JmrKEaYlmV+PW7QNpT9Nu3Me
         aXh2xXs3AnjCOugfkxAaTpt5XlcVy6bq9hgPpUNX1MAlFfaY6fPIJbMRQxxQx4QslTji
         HO378PedVaGy4WmRiEtPm9QBvpdRILIQA4yZFszZnhcCa2GKEDwjnzqCORoKxTdxF+vY
         mwnLjQc9DAjqKfcSCMMj59xYpLU9IagXpAqUsfkobwsKTdgPALxd+xMg2BqKeFbVr7vA
         dwiPvjuPZPjtzF1XwoObjcyOnz83QZJhZdEXH3qKjATUurhM+alvGvzW+YsvsBVdufIF
         wl5w==
X-Forwarded-Encrypted: i=1; AJvYcCVo23Rwz7OvzPBWd8XO5rAPW8i17zn6iPRCoIfD7/AOKNUHaAQl/QeCePPJGfo8NKXrZwWC/Ctk7Q==@kvack.org
X-Gm-Message-State: AOJu0Yzv0CssKKfClOTVguBLDK/90DCjJ3Rx3sLKTjW4Lcv5dQy/h8rj
	WguEaBhFmwbl92xA/Sm+QT8Us3wCT5UR8NalWDY++HwlKDqTmPw0+v4iyX9MLYJAa/U=
X-Gm-Gg: ASbGncsu2QB3VPaM0T0heKsmXxyUWwWv39Y33jrapje/ChI3ouq9S7GLhCjh+Q1O+JU
	4Wdzo2OGUXA0q1Y3fNgSh8DzJFieNBktnp115GMNJwAWp3EtGXkx+yVNcLRJ86NcxXn/b2Nixav
	XuoYhDCc1v/0veVHh3H9vZfKIYY6s+KWGPRm5PW13F6jsD7uP9YMtZ2+AeEA9UJbjzBkCeHvd8N
	g0GvYD6q5VNIoJJRmqhNknM9lxlBzhMIYVtkef+MwRPR8HgxMwCqnJAw3olmYgcJSlY04zhaBnr
	QgKyja74EAkmuT0fxh9Up9YAS1IumlMH3PNPYaXY8SFvRpO1Y+7Ke0+dKHbk6OWeaAnk9DOoT7d
	lrGm+6vY8ikzgFfXn
X-Google-Smtp-Source: AGHT+IFiU8ntOuIrsg7EJjoE+jgfBOjilWpCicMTZfx/w/wMWv+Cz6kJc3kzsI0KnGWbRP7+RQsGJQ==
X-Received: by 2002:a05:6000:2501:b0:3a4:dc42:a0c3 with SMTP id ffacd0b85a97d-3b768f2e43bmr4915869f8f.56.1753349099696;
        Thu, 24 Jul 2025 02:24:59 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:24:59 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:41 +0200
Subject: [PATCH v3 13/15] pinctrl: qcom: add infrastructure for marking pin
 functions as GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-13-af4db9302de4@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=V65C7Z+Y1YiPq0OHKNuy9LXqO2UhBPC3XEUxRkkrR4k=;
 b=kA0DAAoBEacuoBRx13IByyZiAGiB+9ShUR1OAFnIEDQG3sNgilmhY7Ygh6t/KE+2iWaFhFUfQ
 4kCMwQAAQoAHRYhBBad62wLw8RgE9LHnxGnLqAUcddyBQJogfvUAAoJEBGnLqAUcddyCt4P/19R
 usVp59cB9gmeC6caTopbcbPlDN95WhxRPi8vVSM0eahgEj4xziYJs019xI4Vc/dhRXH9v/sv4w5
 5V/98wav2sHArJ6Fwyy4TwBH2Fi70PGrZodDBC+XRwDmAFxjjdb5ZC70EkBefPFgqgWBJLHFbYK
 ERwWpuTdOjV3bR68Y+BCsI8vh9Of0hQhF4gyJj6bIdvXvlKGmd/OXIrHJqeatSdBYMWebikfG2h
 Ow7xy/+iqq+i6p4tWOubxuQ+yrYyiPvnsRIQt7j74iJO9N8kHSdgg/wuwIOdNANPFp3EsoYL0kK
 qa1Qg1hHn2GdMMp3oOXDTybNepcTiMtdkbI4jPFrei5Wi/pAZRaEfYoCaBoD1AkhZwRaNOHQQH0
 ljr1wEhPIjnp+8blcIaYZq8yVYvpNFc2j8IExWEsIXNTWECihGJxSYq27Kekunrv/FpYmZEsi+E
 grHegZHLUs5t0APfof6gAM5Dk+slyYb/GNzK8F6racQqxoEnZy+zBj52YU4q+yNxNcwylSh1b3V
 i3FtgIvC0j4c004+Y+yGAVzok9hidlMxP6cap3zpbStLEDVEte286WULSaZ0EbdfNkU66NC+ACK
 G3w6qEcvTn8zHUugxupweSvuC6MxhTVRA8uH4BAoi3nN2mf0gl1xU6dJWdB8ZlrrKBCQUuVoGsp
 K1qEy
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4520F10000B
X-Stat-Signature: 918kgcue9mejfhyzzq778ubu8ht43trb
X-Rspam-User: 
X-HE-Tag: 1753349101-524121
X-HE-Meta: U2FsdGVkX199ApelPjyT/LKXamb0Uy+Ysh4TnDm4KK5vg69km3RSYOIGtxO/4sSzJl/wJxvtXn++JjG9C6K9DjnqeoMKDjpd3x5yZnfz+d4TjpG4bum4R7IpZ+Xlwdu1CR+B3mb19A2YvXtMY3RfCga/iIRruM+H1+q/QCKd6Hi/gxGs6Vhu21H4SSJb1IAHxGwmnoOxRfJc4327vHzXydogCxZcawtKggAWsaS+3n84DxF3QFZHWoH96Nv5fakmb1OMCiADRVJIDhKSnfUFARjDGpAajaaGrUeQ11fKukvwGo0TCMyWY04V4V1DFo0Tt+nDlw2ur8ykURIW9esYtjcG2wFCEJzRqrhs1KRmcPlG9VwvfVWrP8iX6GHAdUBVMr8eExP3FLZcEaHTiShf/BV6OmC5USv821Q7hDsOjf1Ufs4vePPUPrmYC6SOXyafLnz7qZY7uByfDvY4pcYWwSDTNTZ1BQjcTUmyPNxt7iKT1jYSObJHSsSc5oIJ57hxswEGtUIBNKTriiVZYYOz67Vdqc0l27lu5tc4LW+ZoHvzC3s49G+GPdqJ0t8o47vj2f8bvI0Vor8lGlvrYz3+ugxIW6llg4noVhkXTkko+YIc4hWngh4JeSjiz+YJiBBn/DveFVLrTBMJ1XG4NoZhqYlUbOJn8gpIpLO6DBjDwdcYV23JXepOu5YXTwTdiQAQP/qchK424DzOamRj8jdp6XQFwOfm61LJvSuWxDZ6xw5IAoXchwheAhoD9AHh61kUPEyi6iwvB/LT48vLP84B9m1SmJO0pQ9+Z3/c+c2D5zivd6MSzYflaB5+kYflF+Fd1H2vHKjRFibEYjnFbFAvTta7GLEEYfADypoM0WcPYHm/UOjHqal11wpiRHsFOkWVLQoVW96AM3Bc7xuFAwxGQCe0nZo0eKVlSejD7J6PnsPDdf1pstaa7JiFLSGNe0kngQjXOhwax9EYf3TuRxQ
 M2voCtxY
 NTKKVeTA5+nnunhNE14CyhiXhsUIVLzRjVjQakhYVAHQrQOKZgBbzC83iqMJRCVtTShJXu1rYRrbjljILsruv0ayTcflloMPQUCsLo3xzmTDgIvRCHjDncQup0XCacr5a1stZv+poUUrON6l3oyB3MOs6Gs3kMkSnAxY3hbJbv9nD8BL434+yEZJDZPTFERdZkSNOBqVLW4JJ6zdJtppQoQOR3x8Eafand/eujGbg+qGQ0YXMfspLRDwI/LcIjZ2rR8xhm2RU/ko4jXYdB9SBWt0s/wWeCqYgfFqumMeze4fyup7SEpc9x12L8ZubfvGyE/fxVEmu5PEpw0Mwpcx+jWccH3A0MLvc63eXlTtPKu5sHlSsyJbbDKBGrKL/+kjQBSiPr3cZ+ONt4OTFqdAEkBKL2F1SmXnZS2y/0fcA2vInY2Eg/KKyHR+HdlZ/2+dFeo7JglcyDUygQIWQa7ZWYjUWWH6Q/ArrO49RXN8qGMGi2yT/dj/vHJTXcUGUN/lv2MuCh1bvak6VP9sGfVXmbdnOaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add a helper macro that wraps PINCTRL_GPIO_PINFUNCTION() for pinctrl-msm
pin functions and assign the .function_is_gpio() callback in pinmux_ops.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 1 +
 drivers/pinctrl/qcom/pinctrl-msm.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 965f0cceac56697bc4cdb851c8201db7508c042e..7010be8d1ace062fcf7743e539d2065d4aed856b 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -265,6 +265,7 @@ static const struct pinmux_ops msm_pinmux_ops = {
 	.get_functions_count	= pinmux_generic_get_function_count,
 	.get_function_name	= pinmux_generic_get_function_name,
 	.get_function_groups	= pinmux_generic_get_function_groups,
+	.function_is_gpio	= pinmux_generic_function_is_gpio,
 	.gpio_request_enable	= msm_pinmux_request_gpio,
 	.set_mux		= msm_pinmux_set_mux,
 };
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.h b/drivers/pinctrl/qcom/pinctrl-msm.h
index d7dc0947bb161868c8f433dc2536719b8afc8bd8..4625fa5320a95a4d24e3a0c98a249e4f163dd4c7 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.h
+++ b/drivers/pinctrl/qcom/pinctrl-msm.h
@@ -29,6 +29,11 @@ struct pinctrl_pin_desc;
 					fname##_groups,		\
 					ARRAY_SIZE(fname##_groups))
 
+#define MSM_GPIO_PIN_FUNCTION(fname)				\
+	[msm_mux_##fname] = PINCTRL_GPIO_PINFUNCTION(#fname,	\
+					fname##_groups,		\
+					ARRAY_SIZE(fname##_groups))
+
 #define QCA_PIN_FUNCTION(fname)					\
 	[qca_mux_##fname] = PINCTRL_PINFUNCTION(#fname,		\
 					fname##_groups,		\

-- 
2.48.1


