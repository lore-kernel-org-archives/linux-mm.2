Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23891CA0EE8
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA56790023C; Fri, 15 Aug 2025 05:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27618E0002; Fri, 15 Aug 2025 05:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA1E90023C; Fri, 15 Aug 2025 05:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA3C78E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 837DCC0922
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:41 +0000 (UTC)
X-FDA: 83778418962.14.979AF7F
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 769C5100007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=nA8L3iAv
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JThKrLTPuFVwzCwJhKd4fJmIEtCxHnGrNzSYzGU4KrU=;
	b=jh+3bvqjlzZ443JxcA42IgAtKBS4j6HS35ajiCwDqCppTuoylEhwL14sMz0O28Gs5WvVEn
	VNVRycRVKQXNmYLDI25O/UaTDHbxOecnZsMkwd0Zey8EuI+EFt3LwqSJgwrddp3s84S3rO
	tsbog+ZjGlWFhO3L7LRA18adNv7C2LU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=nA8L3iAv;
	spf=none (imf05.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.41) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248979; a=rsa-sha256;
	cv=none;
	b=R0xLb4bLchcgYwmpmLGj/NS1VmRIZoRCQWsDT71izg1oSwNasapBHz2rxmNPC+7vp5Tk1q
	ecQo9wcWa7teu9JDMnExa5Juc0qZV+n60K2ZxCRcTC3fsbTSUoBeqv+1d149YsMfRG8eaX
	ASFC5IruY1v0TdUWC8YgPts9M7ZQ384=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b9ba300cb9so1199939f8f.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248978; x=1755853778; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JThKrLTPuFVwzCwJhKd4fJmIEtCxHnGrNzSYzGU4KrU=;
        b=nA8L3iAviX9TutoH7rLF9h7YOQVPUoCyayWup003z+hPapQPL9VC1UjGJeGB3Dhhfa
         6M7ZHYMulRqjtt2aT+NXC722ViOEt8TlCkUsm/Hfr/wsDGvjwCvINiTXPHpgVVzbhPm4
         re7IJqeTBWd+h/a6cHIPWhvMLwD609QRwG7OuDxawKG/BxNmHWYU5b5qBcWhN4lIX27T
         DyYsDvXMRHZ3KrcEPUTbWPdwRqsXFHgQLA5iVkFRwLgxzM1LjmeQyW0r7/lt2aUHdtuF
         z4NVFGH1YkmQawHTi2nZtlvJmjPaDEGJxDL6WLVcIzE2j+MpMuGH2N8zm1Qglip9cKu7
         tWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248978; x=1755853778;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JThKrLTPuFVwzCwJhKd4fJmIEtCxHnGrNzSYzGU4KrU=;
        b=gdddvoMJjQisqsDJd2JfS6gDNbt97aZ4CQ4KxO675I1ZQCf9gjAKBbPdhey3AXjJHe
         ous6SnQ+SFN8S8xJjGsadA9iezwurNw2unrUmaFwnaEkKGHb7sRFO/Q591ezVXACXbOs
         BF9n6jBLpfd2lul/kB8crQwqo4SsdE0HqG7IkXwdbGyuNMkjGYWt3hZFhF7XjK437bFY
         3Nmr99wWeYLzwfD56EhIoXGsCH9KWJf/WRRxmpPyVHG/XIROHGi9DCFjQdZ20l1wduJn
         liQcQX8CcAiSJYBBK627HG78SjNVrf/bmsh93JMaiLn9jvyXqVFgCr0T2vxZ3nadEY+u
         Wbjg==
X-Forwarded-Encrypted: i=1; AJvYcCUHTxvPV+l9YzU8mER0rXq3udBwH7dbQc7LhzqzdA56cVaEkkFCozdtQXjjHrEu1MPa40uKs2njBw==@kvack.org
X-Gm-Message-State: AOJu0YwmJ3AGIVNrjvSX04QcxnwVQD1PEvS4TbLA8tBjl6ATHnqKYP8i
	nVuW9vgypzx5Lp0NtprSJXXX+nlupV7I8QiYEH14X3K2kCC9InMA/mjY3dJ3JRLmL2s=
X-Gm-Gg: ASbGncupiQMy9BOdgtW0uCwVHQek8mIQQkTcgijBRW7QUW0dj2qZQpMccVfhznTQAlm
	Udk1g2uAIy27WTP3oxqNFhzQeICPsc2o/MPUKQIqRIRuSuiRtsfMW1MrQynyv2QVJgGOfH1UE1U
	bmgMmrKrNe7B9l8J5rnT2L+6/EmMNUZ7WQLcYGYoblB+WovgZdGL3JW2NFlz4KBppsGVfjx4ZDD
	0YwsNN6z5umaFxCRzt+o2uxg4h606SC/31FAenD6UP5hOgG2vkGWS8nFlz9RNUQT8kg1YUpkFDi
	rQ93nEPuNXSY6ZYCLUZo/qTr53s1ZnaY74HLb7mUFMOlHq8K0W049lM4l/q58aN55M+dc926z9H
	+Lx8GLjayw2amhoGcOQ==
X-Google-Smtp-Source: AGHT+IG6tpzUVovgoQkKFLGI9UZEr33h0FppCamYKXGjED9LEMcOygc6BNR53lxBsyNw3EXRvTetsA==
X-Received: by 2002:a05:6000:4007:b0:3b7:8071:f902 with SMTP id ffacd0b85a97d-3bb4c5b80bcmr1159773f8f.13.1755248978027;
        Fri, 15 Aug 2025 02:09:38 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:37 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:15 +0200
Subject: [PATCH v5 13/15] pinctrl: qcom: add infrastructure for marking pin
 functions as GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-13-955de9fd91db@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=1TtCXH0c1SnNyHC+v6gZsytFHMfkLN/q6H3Fm9nBNlI=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk5msNNj4Ca68fb7+G6bZ73KBx3fzutVpC0Z
 9VENfY/MhyJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75OQAKCRARpy6gFHHX
 cqCREAC7WpcFRL2Sb/Hk+HNXVI+dbXjLvxVLapxOlsBcpesaDrR/NahYb6p/G62D/kWHKA2KVii
 lU/tMlPBnJHukaRydH6794HwaY5/+/S9wFa5rDdnOyj2dBp6a9S3jbED/+o43IIUf+rOrPuqibD
 NVr66kEWQYaOLX/t81nHetyX+Dd+P/d++xBXan8oWhwtXd9zHLda05S+jw/RrBxcx3fSK6UTtD7
 dNW9MUo9bAY1tlkU51qsjDfW+eRq5dAzdNdeURgAreCH162KFT+bIIAZQtswc6RS1AsC5M1kj6o
 S9cX5AF5K0XMaIorq5coITsfpWq/OxWi4L4P1TMTB6ctqiL01wOF/z3BSefdpr0MjAr5GsnAf/y
 LqKsz5hniCLTvZjgU1Ayvwq8usXkT8xaUY2zb9GfGdgGgmBRJSoleQR4XHmpHYNi5542R1lj46O
 y4qPwttgalxFYhy/FBpTsvlflTrGhicrlq+7hSDpjlvSXR6CYWn1w7gkVRb1cuHFR+Xj0BNYXvG
 A4i7Og4mKksF2x88F+5NOrW5SRklexTs4SBPGNo8Rz5cp+tYslwZmceoum3xCfLAbf0CVyMRym/
 +eQd0GP5pUkNj2Jtjub8fvLlUFd542dMVBls5yK0Vw2zFC/nKbLCz36IRltDZCXJlsYgs5j0tVX
 dAwrcGCy/BjpcWA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: wdycb7n4ztftdb3jhmdjjyrdjkwukibx
X-Rspam-User: 
X-Rspamd-Queue-Id: 769C5100007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755248979-853877
X-HE-Meta: U2FsdGVkX19SOMCxM/nfOcFHwd47S7T6aZ0yCmkMHfmntgFrfKJxhQHv3SjCBSJ3rG3VDT71tLPcja6TMy7O1t7+FBqk28ETNpUVmV1Llm3oM87b6QEw1Syt6tWJZfK6IBLiw2nt1LEwm+pd9e836xddnOqgDWU+H2Dx1Ny+xA1ZAvWL3JstnQKgXZVVlSk9pTwKo+YQ2pswdpFD1/YuEpaZ4UzWNSyzwyYoMiZ1cHZfWpXTT+2aGwGmNFKIConuUcyLNG0LhievkUdupO1kzTBZj/IIUFiTW/jIeRuBCJ/CTqkPNxtu8UnEmrE+hKVn3oHaoCCU4QXz6fRnUQy3UEODeoybeEy0DF7Q/uTNEE9xxekbpBiro5FRpdNtOmtZJQ52XRPzwwNy/ji/yGTViaHThkpe4we3ZDazPBh4ytNNBgXN3MKnwh14qE1pPkgeLotiyolhf1yW7frxim3xnHpngo3GrX3L36/In5JUiQ3E4/X3VOoewERbMsuBZv3jUq2cQttUT66nmdGfQU/P/B+UXr2XY/jNAZdnNbjyEb8DyrwlWc92wot+fLEtqp0528zJQT4gtDj+GYrGa9jA+gX62O/G40Lh8WOTWJCKPTkhqE1a9uSS7eIlqKYCXtTHXBcgA5villTEdgCb0l2Fr+MoqvkJibRgmXdjFB+2fuc0L7ktjHIIyToH7gEyrsI8HprQaAmDubUm5r5b+/O3ivU/lJZhgXluqXysCLNknn+mmVbCH1tHRiWX2GtjG6BVsgyPB3SoKSOuZd99nk36ySWkA6AH4BqUmcdLtYC35dgDsXIBBEaG3AqQ2YAu24mcUGBNsloWpdcGM9mj6DgDxuf6EOaRsL1DFv9+IFVRXLUs6CxcYIGZij62ae5K6j53kmpbPe4fmdvNY/rm5vaXTAW4TbEGrV15euMELbFwf56swsv0UxjBMO0iBM/On2h39RpupSJM+ocjYm/fsF7
 lTXZBusa
 n6QesGKRd1WUdY5TPznMYRY55JGZpePqUBNyzyDCKGJHf1HgQngxOzayB/+HgF3vXRbGAmx7m2qslE7fVSyTlNskR+L925K3KDsCSZgOA50A8I8SWR97sqhNQq1kFYvIceO5x13d7IrbNclvRI3Zxpgn+aRnNI2RrMG7DtM8Ef2Rs+ZYt2rkOUizy6wWOO+Pl7I3W8Al+zIXY50660aWw8Tq2X0aniCkaInI2RF1kVN1zEEMFM4NJd0F/lauyKTQh4DXs0UemwACi2WbHatKy+Y5lCeVFKklNYchCYis4X5uEC7ATF7NqI16qEAmuWKWPID48cNZB5VsCuCZAThG7KjiV9W22ksrqoW3qsSsDDZMndY2yTTVo56nV5HNB22rjCx8IIyL/OVeOuflsWAS1LISqD6JjD+JBFhfAsZ1xLdck9EJ6cW9wM8moVtI2vyo+i29+5F1PSjZMloDkmVuY/Z2fb2n7KghRUDE9qWK5ZTKDp86agNpAZKfE1mtSoVThbhTfmG7TuTum9/3GwujAQnT6fw==
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


