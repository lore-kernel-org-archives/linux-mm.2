Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC138CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B48B90023E; Fri, 15 Aug 2025 05:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D9D8E0002; Fri, 15 Aug 2025 05:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B76D90023E; Fri, 15 Aug 2025 05:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10CBF8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:09:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7282160896
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:44 +0000 (UTC)
X-FDA: 83778419088.16.2393B63
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id EE7551C0006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:09:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="K/RU5gox"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAO2WeXDFkbtwkjKyd1xrqU98u0EGyjojmTyXcAuE7w=;
	b=0QkaWE8yvNUdfBm1bQetVMSi2lIqFQ/DbUdbntFPtHkBMGAxhw1WZ0IOyVTzPMBC3BT+RB
	C37c0UC3Lq2FlnuT7VS7dA+l7Wp507xaVHAOQzzezPpHqVeVkMdg+duYPaOBAupPxpbnWi
	1jwvex3XAYxTihHBUVjZ0MGqtH7eL2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248983; a=rsa-sha256;
	cv=none;
	b=TMZ4QtW0HKp3onGnvu7PzU1fnGsRUAmL4qI17o+c2tUqv3TIkugEdw2cbbUfaKOOzEJ+c+
	EaEM4DUnayjHl1X66At3EnVNV9iDmiv9b3B5rgZLB2Dr0aJzNh698CTFV9J/xLt93M8JI2
	hm272g69qfOVrIQvauBK+6O93E0AsTU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="K/RU5gox";
	spf=none (imf20.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b9e415a68fso1581127f8f.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755248981; x=1755853781; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAO2WeXDFkbtwkjKyd1xrqU98u0EGyjojmTyXcAuE7w=;
        b=K/RU5goxmCgN+WYIYQHRCBevy8yKjQ0MPCS9IVAEguO5JXA76g3V72QkSieSOK+ffF
         GuGNByb0LFE9C3UffNFBYM4lqy0hxuz8B4ZiSsHArsY8LcMkyOmXftwthbhf6olABXpU
         9TmwwKqWVTmjkllnymA4qojtlTZDiPCRHcnWVCDRRxDNWRRf2JrELtiWVRhzqCOS7wA1
         8GVIhN5jAyHtMX0FA+9ypnQnmFzu6CSUwe4tXXl7uut1lRK0aH5zc0uRQkuIxubvTq34
         6fdRZdWFKsYBuWZQ/nfZTOAcXfYqzlZqzM9NSUcRu0KlafGoaguIPGPYp/Tsr1iwsLFN
         TNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755248981; x=1755853781;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jAO2WeXDFkbtwkjKyd1xrqU98u0EGyjojmTyXcAuE7w=;
        b=eCV1YPRop/QqhJXs8w0yqfpehIPGJPNGl4zm1LxUXQjskGmYrw33POmFtZup4OD1Gm
         ikHVP2QSu8qZwCMHiCCA9okseQ1zi7e6eF/8wSkpwLktchhTQftI61BK2VFtTC6Vh7YQ
         ZI/N0qucNK3eWQhIRtb+hH1LtS3ytyPuV8EGH2zLkVuJBh6MDIv5L2GIAkQrRzQRjRjX
         t49Fz0No6PkSq/t+sSxmiscpAT85dodYT3KjH1YtEpQ60W+VQzeoaHMfRvwY+ETM+ijK
         Nl1tqA1nd61wv6uYfo+O4Sw//LdLyK109372j3rilFGs49QFSwpLzg3bEM7GUQVa6VHr
         thSA==
X-Forwarded-Encrypted: i=1; AJvYcCV0+1olYui0fx2DIr5HIPZyZnL4Hs4k8ID7ybHSDrChukmNhc0/w114fdXC8SM+O+uA3v/lQdB8tw==@kvack.org
X-Gm-Message-State: AOJu0YylgGZ01kJIkYB6mg5H8dRh5S2V1oMpLORVoB59pIgfCkVLhdns
	dF/QyGa0m3Lnq85PCSgrUUxS8e6NlaiFsbf11mNd1ofpBWbkxApQPlP2sVCOaD6/Zwk=
X-Gm-Gg: ASbGnctrTJ8vkou/ze0EGca55UXLqPQ7EfUu+Km/6KDch67/y/YQ5NZCq50iM4Eoi5h
	aPkb5hPkM9JLqF3+eSqNZTfjsXQFyGlWjrPtEIbTFDrxnNsMFChkr40Qi5VkmIXAU/EbkLaBkA1
	4UWOOkHLn9D690Q3aOpwIDVIq7I8NVXw5C1B6leucaFAFeFHUPIrh5rqE0nfA2LB8/KE4k/OFVe
	MpkCb171fOy4bKpbYCiNT8KJOUwwsTwW7hAYaNWop6ca+JYidp46RInaumGeVdy7+N2hDlPUh8B
	RfD3Prkt7uCY+YbE9FSkmlNuLGKD6qe4T+Blm8z3BLQqabSAAkmcyD91Uik1AqrDtPokNC9j1KH
	UaX3HJ4C/tdRUDRlQig==
X-Google-Smtp-Source: AGHT+IH6u9qd88jYtkMUMO7Pk2wdt7IioAAqpR67Wlnaqpb4Xq5KR98LGHT/fAn80hsOAq7ogVV7XQ==
X-Received: by 2002:a05:6000:3108:b0:3b8:d8cc:dcf3 with SMTP id ffacd0b85a97d-3bb68921b21mr916109f8f.29.1755248981350;
        Fri, 15 Aug 2025 02:09:41 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:a125:bd3e:6904:c9f9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a67sm1205210f8f.35.2025.08.15.02.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:09:40 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 15 Aug 2025 11:09:17 +0200
Subject: [PATCH v5 15/15] pinctrl: qcom: make the pinmuxing strict
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250815-pinctrl-gpio-pinfuncs-v5-15-955de9fd91db@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1142;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=M6AAfE1ZYIqFZsBoDZ4O1bJllvK/6bMXFJ6Zryc+i/E=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBonvk6E0B63uoFwvdNfdM6shEMGyPseEvOlsf0/
 xE/Q7RcUMmJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJ75OgAKCRARpy6gFHHX
 cgUiEADKwU+j0rwTCMMo4gp+q9WJ8f3aBc4TC+eTJd7Rb68K/vvR8mQoOObnc5vYp4f1bGS5hjx
 nhb+kFiHt9322cnLeohSt3ZOFPCzHPEj2QRLHCoHJ/Z//LaWVcxvSNu/k5B0wuFON9igEj3HZnu
 cpu9eGKkr2mIAfESMNu2yXlUPQB5vXtiZ9y0GkHRefEdE18uLI39sKYfWLR/ZeMGcUUp86JjYUr
 2BJ39RDdZCMbvLjh8df1T6RwANJSK2q7RbAnM1uvo7hUhvPnQYiTe8yo4a3aELWbv/TVbD9jT8K
 ZXGeUzH85xQKEQ0JTjzReXrxA748Oyq3uLoLuL1GzHqTkRiMnu18+BBTvaCr3u4TB8SVgkbF6Ls
 AUXyGIRAk5hGTn6lf6aeYN+NrvwvlvPtCtdN8ZTpi6p4GT0PfS0o1QOMVO8X0DrcDLo6nilrVyp
 GKZ4vywviTy/wxChO1vznkIdtfA5ylI00rp9tKrccz4rpnda311StQvjVC9o1Py9DeKtv0cGGh9
 SJ4Mcj0suKefpRxOr8UWj05HldOdGpacP8CC7eTEE6LPapXVPDfkem2wLu4/01B+kl8N2cVPOdn
 io4s9PHmIyv1eMTsFNfIOUPPLb+j7PMBFXlGzqUadBKgYD6NcwP8wBOIeXNI5r7bkDQb8eF19oG
 qT+jLfULiytDlBw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE7551C0006
X-Stat-Signature: fygjebgz4pneqnks7qpykb5fwuatcm61
X-Rspam-User: 
X-HE-Tag: 1755248982-489218
X-HE-Meta: U2FsdGVkX198241HCghj468azHoCki25+LxmgynrXqBm7suQITGw9Pk5e3t1fz+SQHYPORPFr9KaVlKHQ2PGfnnDepR3TeoIAWFht1OZAVbFRnfQQlmandHmivSOZR64da8QH93U0WlNQ63i6TsUd24/Ym6ORgrqaUUxs8bwW95kuj/FsatJ607srkd9ITyW309k1VABySfIhNZfMyqsitWegGloC1C/WSqP4Ss8PJzEaqIY96+M9EZf5fk5ThWnsZZnhw3YwyyUm6zdshvoUNUbmKlO7GFM95EpblPov1N5Sa+Ty9sWMkzqfNmOeRz7qoXX9pUSz0u3c8j0ZR5hoOKB4Re0SQUlfkQtpfHmiasydCGpZ9FW+9T9jM1gHFkwfcpPxg2XaIxtSxP3v+c38wZAYfn8OPoQX+ELEBnUj8UDtpnV2Gmx+Gt3xHfaz5HVe7XN78yNQFZwBBN6WEJDF3XOdIMwbACo+graI2MtI5iivTk5CAj3I7TfvV/1H3wS3SJvBUTIDJbLHxt1p2rhzxwLpU3tBzWrVCqey5qVMP58gB5Tcm9olGurdGzK/EdJsZzLmavfLbiF6ojPN/Wa+DMNZSvAvgk1gU/Ba2ylyHRzetZwlRjFHIzNrmge0iYGme+2Cbo0WYaFE+4k1J0cbdEcMXySwLw8+DMXyzJEwqxOsaGq8GoVMpVjY49+62EFanxbLIpt2b0kJFHsyzAhJsRxpF/Xso7bB+lxIsMmiI+7Qh5cr0IArz6X/RKEGgvYFHj1IaphBG6ZuK1oScZE2c4jPvIpSXivlUeB/CBfyy3Z/0pKTDGzUHiQIKmIMOVmNmadmakv4hV4yVPioWIZhxoohZPDej9NvzDg4CKdI4O14Du9EKOhc3d4YJCGvdjXh633oF6/osF67aetWqTHQINIeH4hV9ayBKX0uow+yt+ReDMIdksgYl70N3/D74puUm8HiDbemJ/CWUh5WXz
 T+3TyDcb
 rG1w6QLN6djTU+bEkWnGJdiM0q498q1Ybth4U
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


