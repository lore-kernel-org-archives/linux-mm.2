Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AFE6C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9576B00BE; Thu, 28 Aug 2025 12:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34EF6B00BF; Thu, 28 Aug 2025 12:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB976B00C0; Thu, 28 Aug 2025 12:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 64CAD6B00BE
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 214A9B7C85
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:45 +0000 (UTC)
X-FDA: 83826629250.24.1A36448
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id F133640020
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=gOc4HGoA
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JThKrLTPuFVwzCwJhKd4fJmIEtCxHnGrNzSYzGU4KrU=;
	b=7blTA9emGCz7g4+qjn0t1uxk8Z+U345vonPXp1Fv/lys0rtS6RalG6908070dz05nJfoNI
	xw2t2XjZVPhLZFw1Qco1X4IVg8vAzA41blLl1k4zcc6oKkRfWQLTrilU3C5RzhL9WC3jcq
	1YWzXvou1gk8pbMtIVoNjznoemBRRJs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=gOc4HGoA;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.128.48) smtp.mailfrom=brgl@bgdev.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396843; a=rsa-sha256;
	cv=none;
	b=ztLf99JlM+9tl7JbMElUnGwhKWTmr8yWeTTQDud7xQnAd0HQBZJ9n5WdQuUK7PAAxr3gTA
	0fv/0emgysUKGfpZ5yJavsT0AnTcWl/YfmcSg+/pNXsctD6L+KLD5OvcPMOe5QyXVPvrs2
	fbLWA7B0rO8f0opSfqwbvmQyACyO5E4=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b4d892175so7383785e9.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756396841; x=1757001641; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JThKrLTPuFVwzCwJhKd4fJmIEtCxHnGrNzSYzGU4KrU=;
        b=gOc4HGoA2dacdwV+j6NoV5vB1LeTSG7iIcSu3329beG2Ev78dX8TD/BZyw131gnlwt
         Hz1LC0gnKl1vwdUoRTYgD7j4L/78R4aj939tmsc3CaHAsHmdyJ+1223I4TQfRxENGep0
         cc/IVjcbx3Y5Kx0tcu9wOeehiOXWBmD4uKv5eh61YmDFCxnOT8kg5cgZ2CNVhX3VAms5
         iCyIZI/wZMf22+xq2BI9m080inwoQhm5FMHlmkv5do1xWGDucXbfTdWJOLcgFMIo/W9Q
         FMrNp3zMsJnP7DHht0OHYigkENK8YPyxyXCFNGghyuslSKfHt1cYnH1/tmpF/SMUqBwR
         LvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756396841; x=1757001641;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JThKrLTPuFVwzCwJhKd4fJmIEtCxHnGrNzSYzGU4KrU=;
        b=kdHESUJnb7ROx9C61IGxoUQxPGONJRwNalgjYP5iEwA44D36gnjRdACCieN+VvfGKP
         FGJtU4YcxVRT2XHv/fizAK09f9jCB8VqxTRvgvOqr30MwMpoK6vGJKM/CteDmVdtpCmX
         VqViXZgZQ+2oGTtzkCe2ZH1hPdZMKFk/hmQyeqsU/95B0O/n3qyS1u10XuUCiyMKD7im
         DcI6/oFh5Xb3oqouFrsGfCLzEnKMwXZyvvuTWTJSh2EwGKxJ4zJVxINVAhzROFEV9mQg
         K04mH3+w7yceght11jeJoXitTXo3+VrESlXw1wr6fjR2WOkU4JzungKYfpqrmcggNnQ0
         e7ew==
X-Forwarded-Encrypted: i=1; AJvYcCUNucUdfLIN+K2Gr+p8pAUz22VaSCL5ku+rcMKAiYjhHksiXhD0zPKMN9k5l9nVpwUPuIsAxY021g==@kvack.org
X-Gm-Message-State: AOJu0YwxX40eVEe0a4yf2vJBlMiwSLaj/wNgt1NMTpCdjl/gV2wG1qeJ
	WAY/EuETsleaTBGi9R0YLeNMxjJiK1r519p7Xk4tI6V+YKi6ygKCDFsRH4VwOuJ/9ls=
X-Gm-Gg: ASbGncsJTvUbNhOQqdLdFKX+p+i043dqo8PzzKyeCXwmmnlUvjhK9aRO5TXr73tLxtU
	wdLlowVkgVOEx9/PsrN2C3hFlARPZbbynrq99LsKKR5AMdSpMUysDyhfbJyc4jwIwxC4XPaITSr
	yuP0mDf6yNTr3t2nQkVPcl6qo7T/fAW4pqVoKabf0mA46lXM+6MsUYyLURqLeeriC26LCFmyPtY
	OsktkYmuzd9qzt5rrCwogQWEE0EswXACXosPEmpkL3unRD2aV++EY/Y7CGLI6i3Vv8lX13Q3eyz
	qMFz6WX32tH/aNr+F9VJ4ALJ/sone3GeICuyAt9/5C2N4B2qeHZQC8kDhXlXQgSJDDJm18n511d
	5LCSPOjwQbmtF6g2kzQ==
X-Google-Smtp-Source: AGHT+IGBclbNO8WGRtJ0uIJ0ka2pGvDxULNrTlJVFv33q7V9H1vL8p1aMqaTfJLA+km5WeyuNutw9Q==
X-Received: by 2002:a05:600c:548d:b0:45b:6f48:9deb with SMTP id 5b1f17b1804b1-45b75858134mr40479305e9.28.1756396841346;
        Thu, 28 Aug 2025 09:00:41 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:4933:4d7c:cf69:9502])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm80211675e9.5.2025.08.28.09.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:00:40 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 18:00:21 +0200
Subject: [PATCH v6 13/15] pinctrl: qcom: add infrastructure for marking pin
 functions as GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-pinctrl-gpio-pinfuncs-v6-13-c9abb6bdb689@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=1TtCXH0c1SnNyHC+v6gZsytFHMfkLN/q6H3Fm9nBNlI=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBosH0PIg19tb8c/EzOw0dn2/vV0Q2+khf5QKTgm
 oMVFo9hzQuJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLB9DwAKCRARpy6gFHHX
 cmqpEACqff+3ib93FI87PuYM4exeofWP28ytmolqFv/JNDSfQlXfjFmYnRfKPTFyBA76ttfOjLm
 ASMPBrH6jm+gDbBK71pqHYmPLR2F3+VbGeBrBP4P+U4KIOoMivjWw3M4zYZw2pqshTxIuzIk8hp
 p7MU2ac3Y9n23iveKbzSAK+EoAmSxL2lQ15yc/7o8ph4+/jCy3aXmdAepBlD2zhWYVn/xEtcAcp
 XMTxIoIzyILFd7r5Z0RbiaGuyI1mT29BWNgpFIRDw954gCvFOYWUrbn2o/Lkg+Qctpz2A4FUeXI
 Diiu3zoutBbFXtO89+FSOyzdmqfSLbrt7rVfKtvvSp1/OoGcglsdJ9T5oWoGjckBb4Zc0Sbj1+U
 /4oXbRes08VCGwU5d0qXt2c2lxgrVlVnKODYUiEPU9qJkPSIX7Q9PAUOzdF6wmMNQBs3xWUDxDv
 PydivI+3iUC103HTAmcWHpervRU6SelZmt3njPpmXzohKb9EzGDwrif+F+FXALOTHaZUARsDhtf
 HPf1uVDdCvVnnIPhwwMrx5l+4F1B21FUAmCe4o6k2r6BZp5mZGL2FBpb+ZIiABfcTzIwxLGjOvn
 04jBAAR9bb5jV1pFoCEljbH/f0c2ullfdb+vvcTGt2JrOg45VcIDDclxo+6Iw2aCGRgUNKNCbPg
 KlIxSfNF/oUQW7Q==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F133640020
X-Stat-Signature: ii7nh44tawutyqjpbj8or37kemr8rqbz
X-Rspam-User: 
X-HE-Tag: 1756396842-691367
X-HE-Meta: U2FsdGVkX18cgqqTmXFp/3KRmFgegptZQS3jlwJn+J8A5SvPjJrnsUT1aWfF/TpNU6lZgFupyL/o53V5pYA5O/2jD0bHDEIQZvp1D4O//WY97JbTUU5h/razb/oSS8hXQ+GOEbzBG58FPqsPcDCLDttOmKBMeSlMs2BWaDw54WKkLRYDM/ySQOA+DpImVukCa7ndP5TsNqDro4SW/UZGh8XeIPkPXO1asbmcb0TXhHHRaWvZyUKA9ZTMqrJ124O2tiU2SC5xp/82w/Sd9Ew0X7ctBDKUOYEAXxxXGMdKG4LIrTGWhZBHURNUFjZGdZI/i8Uu/RSiz77na83+LjbXrzJoLimQ6TcH5VGW9HXf3LjQh+yUU9jvpf9EWS9h2vqrdcXhV5ynh9yJFiOdhH2Agzwxt5UEvYsM137HOYD/LRnGcPXcRDBW7OS+cgJhi90CpOL1lQJmSYJg8KbOCp1VhhCI9msk80D4u8uVbNzW64w0NWjKlzfazJyjM+Dgk8MVbahJf7DUnz41Ai9LHQqzmTE//TtB9WBLa0wGbPvAArl7wthxlp8IRPFHLEQLomdr4ho48WaIo7g+SqNQvQSv2njYodt8KieQW33DGfnnAJ0qCHciaCZYjBB9vl06P5zVOJTAGVDLIFcL870boipbT2Mv+wvO8RtIeAgOfPL3bI1ipn7JT6khHzTFB+C7wUU6p7+/jnJsOlyVcLOzbjq2bU3kHHeaZE7a/xZUDNoIEQxS+m2Cte0uNK6m3HEKyDbCwx+g+RqXMNBS1c6v/mFHxZoJDOsKEevObZ8YY+2d9C/Ew39Iom539/2QMjZSsQqhYQk5Eikbl1HFN2s5uDmHWtm/rPQc/BWMOmM8KrqUnoNdz8lxprOWUOqDdTKM33FpTz8/FFDkv8YTilzSfK1neh+EyHgzBJaHycIaTz0ZmHV2dFQRMh4nQouloOoLZVYgx0iH3zpAFfYdY7vsNJt
 r1brBRFn
 YBbZ1MlnbXM3+SXM1fqCBF1/qxOEHlkVgI+2ki+NPWLI/UvkVB+liZgg+qlgMDUdLjBXu4hBAhMQKH9JPCmT4fa3JfqeGSZQ/hd8drL1i4aqa/bv560466Yw8ZifQebLrZqkwMVgCMZhckjlZRAZ8E+DB0WewfRoWcu8v90rQgiO8UEQVNhfxjSh4QxiANjs+zQZV1nPFtdBTC8KamwzfSMUvQpxYwEvfUVY1GDC7BfwaOgboaNakEZjeTi83z+jAoA1PRDgG3bLcBVtK898jlhoiss1W7CZQyqd/1910nwoH52QHIZ4pkMS4ZeKtDqNYcoqI2hE5dGInGoywzn39TOco/eXO8FvLnosxGGIKTD1uw9/hRa+pIlYuOBcSYRtSrymloSpNh1C3Y+90snQW+xQKwmN4XrK3uy4tbt3KLw4Se4GvGI1uc53B+6/a3hKZ4zLdKVLNg+PsqboLR7rDUWjylyXv6BRzeICfqb5IHFhPYua4crJRFOzVemYWO7vkmp4ZYwsDdfUQVChv6YdHXP6Bkg==
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
index 96e40c2342bdedb8857629e503897f171a80e579..a5f69464827119dfe2a7781b558094b283fca215 100644
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


