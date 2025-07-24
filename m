Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01A6C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0016B00B9; Thu, 24 Jul 2025 05:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E9D6B00BC; Thu, 24 Jul 2025 05:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26436B00BD; Thu, 24 Jul 2025 05:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9AEB86B00B9
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:25:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 787B016032A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:25:06 +0000 (UTC)
X-FDA: 83698624212.15.3DBFB76
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 942E010000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:25:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=hE6W5BJw
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4a+gzu7f3EwTZaPbk859mLIqTYIGZRRwraHyXMWvss=;
	b=reYSRRNzfEDxv6x6vkKo6E20s95K5NiPjJka19jRspQlQkHagpYKextO0fey7R6cSYrzu1
	8uXxr35OhpCOCg4jxGsDZeiZFJuaVDT3p3PPRZRaio2aDhULP+Jicym2Tyqza9m57KxTH+
	xC3iNuQOmyF8Q/y2CvyZQ5lp1rnsu4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753349104; a=rsa-sha256;
	cv=none;
	b=CYnQmSq+St6DqfA0HiiGZmOS8X532uT1b3y7qgMNb8b7Sa9lMspWYPLdK5bYXRxJ3MVDTi
	1bcwbMaWhwgJNoc3Vot65yFnhjGtQuSjpHuQ8oii3b8xS8fsO+Ob3kcDdfn1dLUrG7o4Et
	JdjxfM9Q/bhCNzk3esNANmLe/aUPT1g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=hE6W5BJw;
	spf=none (imf05.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.50) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a57ae5cb17so368322f8f.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753349103; x=1753953903; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4a+gzu7f3EwTZaPbk859mLIqTYIGZRRwraHyXMWvss=;
        b=hE6W5BJwuXxaMTq9WF0iWSkEmHT3DZue/9NDdPHVlX4hXT9bc/TgOcg7iBFrY43ZRU
         ZSclpCSpogpgoTYpj+HeVy0U+nqCBe2CIFjWIi9p6kxECQ3K6L9P6HmtFIvR8Cp1qSYt
         afAbO0lZ7yICaxagCM2lLCjqFvRVy44gXL+XPNHcn8iPvzwT+WDKMX7VFh3y/EE+26eY
         GGi1AJIiX5A0QyIpBbRYCOtgyWwj4oxpeVjczywzx93CLUaucoH6alMA76Mq/1wZyAgg
         gXBwi91O80hPOmvaKVSzyORAY7C13p7k8C89SmO3XRyHMQEoPNfellZhCoNqcoTX11io
         Qz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349103; x=1753953903;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4a+gzu7f3EwTZaPbk859mLIqTYIGZRRwraHyXMWvss=;
        b=faFnli+GSUX4iNUlQlfb3hzJ9ZNZZgv/G3+0I86RSnXlG2r2sE35ipdGKjF+mwPQho
         EFBHCtAXlks1I+7kM7FR9xNJs1YMxYmF1gLu+348hELNWt7HCEBHiEPt7tUnvNx6KW7t
         spG6lE45Jm8pMtUjOEDoW4uewdnSiJT/P+gjUL7B72Ek9ubBZjZjSMaMXBDqKHpNmAg4
         /m7sSn6FzSbjjggQv4nRkiNDylhjnR4Xx1olKEtwIba5VrDU+B60lSoNJW4NPYwt9x0V
         TX5SPhoaD8VxSL24V6eOMu4/WOi2Bwk7MYpE2zhwUNXJDAloqkAcBA/cqtPbkJ4cgB4x
         VMSw==
X-Forwarded-Encrypted: i=1; AJvYcCUy64fMR9Q3V5cgZmtdf3NIqrU0lN2a+u6icP8lUlVYshJxvDUawT6tAjwkliAxficfe13dq0XYDQ==@kvack.org
X-Gm-Message-State: AOJu0YwEF9qWTnYPhvNUzRL2OKVZElnSJd9zsO5RNIqf6NSO7Fge6vO8
	z+7YFihKXFGlkvP3e5Vd0Sxtkyt+qGaYLlsIbifydpsFKLkYBIHN9CC7yXQljvRqXEg=
X-Gm-Gg: ASbGnctrFnG8j+EbXe6j6Wt9h8cuPwZGmYYFeVOOVv67BE9GySbxcNFwA4uSBoE0TzZ
	sJSrwOm2asYRXNLZan6vbs2LISoz5gjy+p/AuxEwDzRkY0RGpz5pCfI8fDn7wChwN2uASWWhyNO
	LKDbnKlDlmhMvTg0yGUlM3cUURYzGfrnn0tsnbVzDSe2H+5fVA85WlIDMRGU4yIAiqO9n/10KRW
	Wo/8vhhFtchXoy3/usbNg3y5EnUUhhM6qSFclMxH8klAp24FfQNCnd2SOEgKTIFVjY/llwhwYWq
	GUqWQrRoi9IxbVd72T0HLDIkD8pGZJWSR+Wkn0spEBjFbp2WfA9//ltALkKJ2uMl6zHzYnj1ZIe
	0g0Z07Izk7+CMVgqH
X-Google-Smtp-Source: AGHT+IH0iAkuA6GzMHME9lyvaFVrb9WaSOmQdANpljoKy1DeZvDX7IaJl8X91dcX7f0LjUclpn3P5A==
X-Received: by 2002:a05:6000:1447:b0:3a5:2b75:56cc with SMTP id ffacd0b85a97d-3b768cb3ac1mr4981697f8f.23.1753349103057;
        Thu, 24 Jul 2025 02:25:03 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f44c:20db:7ada:b556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc72548sm1600833f8f.30.2025.07.24.02.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 02:25:02 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 24 Jul 2025 11:24:43 +0200
Subject: [PATCH v3 15/15] pinctrl: qcom: make the pinmuxing strict
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-pinctrl-gpio-pinfuncs-v3-15-af4db9302de4@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1142;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=M36QPREHYk2Y1Ol3wL/sT7z2U9JVD+MimNp7WJSOHU0=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBogfvUuNqnvhBaTQ7E02dLbZ93XPdMix/+wojXR
 G62efWlN2eJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaIH71AAKCRARpy6gFHHX
 csIEEACcYzcalCunEHwwLc8fC351P1QZ0/EviGqXfAPEAKDWr3P+rwFdN2Ta12zzVjBkLzjyQ91
 Zv3Pyd8ByzwdIUsKqqnTCqQXU561HpvlpivEPwqQfk2Fv1/z8zXTLdhqLYeWc2DtYwXVL47+ep1
 hvPNS0sKjxZZSbhD2Cv0so7lDbU9TIvO8FfROCo+OUmJ+fNRIHwJdm3DZ3UCBbKrfqj0JKqwStC
 SmdBFpZg+RC6pqBdqVp2puRBkrX4kkPXma3WhGUgbQa/jdRrzeKTzhOecZSN78aF+JYuAOuEWas
 9ZYmbC12bDFImUccK4LcZfdm6UKPE66KoyCTfbJSdLsUaafuNUop1v3HMU+T1Qr/Xjdxcfc1d72
 xDxNII3sKlNkkl6WGjDNi7bqM437VkY4D3MqKo2PdUpL8pWVacs90dpKk/TeHcMZqMlSPpWf6Ir
 w0BoC8kdAtDjE9Xmx8h4NgBJrMuqyRB+w2H/MkSVj85rAH3A8nrxlRd/vqL77bGkehXfVeY7coP
 hWnYxxxDdbXZTNWgEpW4pWcbFrtw2pyKmva81FwQzEbINBVc2nQJQb2Qpd68J7/3170a6GFWyeN
 MElcFiUfHMZhzI5U6MPEUSceL4b9e10SrngoFXdrORgydvHqnRID4/lq5Qv8dryavy2pK7C0AN1
 RovE1kMQsSfBwRA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: 942E010000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: j91hzdsjx9wjpz1onc3nofurboqgxwus
X-HE-Tag: 1753349104-749101
X-HE-Meta: U2FsdGVkX19lerH4r4LraezK23TrrT9j2WY+QqVnn9nvqK7e99T3sEMowhvko42kn9Sw3rxq/L0ihQmfemOYJebSnIqDVjwlVKBEm9zN4U4e0tdLcAMsiwWekXwSZTrUieJIzM2zOExKpcDP26FVN0zdX6DOvPpTz4AdnVUBFFH4pZUxoANqxx4N3VV8Lq90x8CgKLPV5DwqXGcTmHqIqvsIl7yw3zPIhmi5UWWo7I4+XTGWE/MCqyfaP1G/PaHbWkVi1jM5tSzXVuSXpHR8TSp40KjBx/LcNjgkSqImZzMYJqCTOH2N6u1nbph2EJLtMo3Rt733RrXVQeYMWT2SzQWrM6MTqeiuQamZcclM6fRQGawmqnj+ijTdPHpTndCecLZXk9pSKoDSGKkaYteClOk/doRT+cVMlL50QSIJqiHXSlXrEs4urXZcqRwWKXvNSBuTdf4x1eo8MGoF6zOAocZNgmGs7RzS3eOnfH5waIHYymGUFB2V/lctlD8cYWoc940qk6Ch4HyBBjdXFfFn5SgI2RUniYNrCqBsHRNPjE68u1MPypfL52wX/SdUBG3F59aNOqB6SIcRhdfEEKS0NFGyVEp0hlAQNpjyg+X3U4tyYKrCI64UbGL/4hc4ghpDA8rtNMnwZ0cWcCDyA81fzeeUmLvN0nQgnF7Qte51EIoQF3ZXpDQoeUEewKdZTThsXZkXpc+y8l84tQk3U031r4w6EVaCjUcl3LXSobgVqbKyE3LqYxX355dr81oXBba1JS5RaiYvRhR9vhulddWfsi4qWW3GU2GaqGNRSVvmnkAhEjCRb19P2aXlDX6tonMqTw5WmUSyZlJtBrj3TBpTFAYGkfSmbLfmKB7PcYh+cz99qGEEC6iFqZSi+U/VmpQUGj9uc4sTy703iYsg0i7sue3YHKfNWuY7Pq//pK3I9Ilsx8MxEuUOI672xsVGbCSrv2qM7ABSOomFJQVQMaI
 XmvMQan0
 A6TQiirnmGqBxtzLgFfbT3oO3zb57DXEUznr+
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
index 7010be8d1ace062fcf7743e539d2065d4aed856b..ad572c923e2ab8caed134207ec02c4107d4dc2bd 100644
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


