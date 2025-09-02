Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17BA5CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A858E0021; Tue,  2 Sep 2025 07:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B138C8E0001; Tue,  2 Sep 2025 07:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD418E0021; Tue,  2 Sep 2025 07:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87A8E8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56ED9BDFD7
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:46 +0000 (UTC)
X-FDA: 83844165972.07.C30C5D3
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A5602000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=NitRUkZX
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814384; a=rsa-sha256;
	cv=none;
	b=WJTz+mXQlJ3Ukz9n4o/Gmw94WN/4Wp2WLsclv38MLicAFPyAkbTo02pnPLiuzVkH+GPmFn
	39tz2ACcpBBqMljxbmIshOyrKmIAiBaRbDxn7+rHqN0DzBqiznzG8JFVlBw6iVwIDSE61H
	OHze44QPRpPeJr30dZVkgVhTWt5n2E8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=NitRUkZX;
	dmarc=none;
	spf=none (imf03.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.53) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZoRwAWe6yFgH80j8Guyt3bkXloByFSMSyop0nIDEao=;
	b=BSJdZh2CGMm4mZH+isD4Whs2wiZS7tMAIpUA+k3IOlgebkevXQC6i1tX7ac/L37kLHy/1i
	SZM/1Hw8RLcHX5x6ODbio0oggzxKNGa/QzSwxW2dfo5YsVROLprJ46yKAjwPuJ4UazgIil
	BetNfBaSa1nnmZtl6ON3QdZz40J1+mI=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3d3ff4a4d6fso1763999f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756814383; x=1757419183; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bZoRwAWe6yFgH80j8Guyt3bkXloByFSMSyop0nIDEao=;
        b=NitRUkZXRzCmsuuL96EpVH7cSFC6crofW1QT824636RzTUEGAPPFOtLYTW2xBC8EI6
         zuhwvrcfJ6Yf/nCUNu60mkn0is6wP4lIzRx7gZ0U9/hYtcffKr4K6SU5ZxuyAVSagi+1
         AM6ZYS5KgqF+at7UDpTung5iDN4ZFRGOvld/cEqlNdEP9gN8gQ7aL5QoMTRK24r8HTMm
         YOJvOXEQAvV9AWriVt9nlBgGiECxfi+9XDWeo4sSI+/duTM4nWgsV17qhaDs+mCZDNg3
         JpX9W1rljfckilQcjm7ntoCqiHieevUY6slDEL916C9KNWlpY5jbHCEUr/xGyaPbfpcL
         xmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814383; x=1757419183;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bZoRwAWe6yFgH80j8Guyt3bkXloByFSMSyop0nIDEao=;
        b=vK40KnNQuanNCgG2OcLVJgrmTdxjtr8vGGK+tJnfXlyEFVQv3zw/2HrIZzU+4wwnXE
         KRucvaoYDfdQOYYhzAp6atU8Gx9awTtKUz0TVnm7ALJvaBE16gONHRbYAvLgvCBiXC+x
         xt0dGoYVG4dnXECYJn5hMpfgmawEpgRmFOKSMxIGAO+5QTk+8EwwWpnRlE5xY4OXa3D2
         Dy/PvgaU8wWnGyP0CmwwTWl3KIn0MWAttwOwU0mVCTlYIKqSh0gjFOYhTgs6HtosVx3o
         TgL7aTLVo8tVzyCPli2amOnXShZArB5YLoGvMREVT6P/9lEMolRPuldaACrA6TKPzNrb
         FzrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8FcMPBb9/TerilbK+7dbpgvuIXvWdtIz0BZcfsWI3r2FlBwL3BlLlvJkUp8R41iSb3QqDtk324g==@kvack.org
X-Gm-Message-State: AOJu0YwVG2keGpJ3wxK/ORtnaCq2pRcmQ1Kuy1Z53+ElQWU9bOaCaFc2
	XRDRbkzLln6WDPOYDdws9W4TGkivhVmfy1qUcHfEHdMTvdnDvvtYYH+Mgy8RgGgl32c=
X-Gm-Gg: ASbGncs2jG+BsqVW5IdZ/Eibo7jYnrhbBYv6EB5qvcI867el+BtvpdqT9NMtgw/M0hC
	K4sPaXhIycE53rQUe1A6xcacYHOcpbTS3qK4Qvi35rvytGYCdJ4HF1P5s4sZmvLfSYP8oKCHzjM
	l3wnNUvY5FXCnqnPYF/r9GfCYGKVbwM1M4VWfki4n9o79PI9G7rKJyyIRbgq58EO/kHkN6P65HU
	4x7/MsRrU1SVKGHEeB1XeuH4JlSybbTyw4TsD6dxnvVr8bBCxqWfDLyXzGbwyWXfufjUxdQMGzn
	AynJbkqjDQqNoIC3wuAEoz2lpVylFxr1mf1M4eEY3wZfIhvEIWL4zECwVlJjk0fMuF2WWewn23u
	XIZJBH06AX1vQmqQ9buh4KPxU8Tg=
X-Google-Smtp-Source: AGHT+IHihsnMuL05+vqbU1MvgQT0F+2Pejjix+ounk5ux1VyL7KdAqS4iEwvv3M3i/aDvS1YgEbYFw==
X-Received: by 2002:a05:6000:1acd:b0:3cb:46fc:8eaa with SMTP id ffacd0b85a97d-3d1de5b087dmr9071418f8f.31.1756814382749;
        Tue, 02 Sep 2025 04:59:42 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:3327:447f:34e9:44f7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm10224195e9.16.2025.09.02.04.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:59:42 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 02 Sep 2025 13:59:23 +0200
Subject: [PATCH v7 14/16] pinctrl: qcom: add infrastructure for marking pin
 functions as GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250902-pinctrl-gpio-pinfuncs-v7-14-bb091daedc52@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1810;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=YcrXV+Vw/YHr5QitFviEgvwH6L2clCkUiJkOzNHp++Q=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBottwUt1OLXwkEzKoyV51MgdE+jkRh1wSFrqCYt
 Vx/Yn7dwPyJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaLbcFAAKCRARpy6gFHHX
 cv6rD/4/T+Qmd60Ccvmhx/iayQBqYuiWX2dIgsN6ptYMZPxH3lMhAjcyUTDe0eLlcA5KhOrzexH
 jqtqCqq/9JjES+aB5QllNPZSkMWARLzm8TbUEJfWBiCUfzW6G3IKJyzPlNTTYqVeIvhsSKfgCmv
 QWdcag5NzqCY6gKbKw7yFlbwX1vSpzMPvHZfThPRU/b7acMqdTixRbX4p82v8yfWBomrf2YPAxF
 HNHiaWoxArt0IuU41K9SrV0bWr7NhN6d8T1lRHbElpUuREWjXUkVZuAmO10agrMYGFKWLa9txPi
 4TASGnIkv6iU+7pbKOnQx93qTnkOyybTQ36jPlfCdSM96g33OctlRbaHJMWgwT9LQcGCeU/SvP+
 XO1yDDk72nuvYW06zU6f56KjqYxpGwPbs6rcWWs5hDDCyZaRsW2hjmhSl74EBy8tFnQZIwWsaF1
 8qNVhRbJpHrHr9QbM7CG9SQ9y8zVRVG0oV4jPqUV0Udf9sLgMaj0lH7n4v8HPpGeTbFSQNy8haB
 FVxnGiavvme6IkSRNMKQYiRTqKVegC/zsQSeUCdMvnPW+GMvQFj4kC+gc21akybe/N7SOsiQ5pB
 /rLl0+WSQVyHKvouXSW9LJKrXGy0cPRzk1A+pSR0ba5zneegrMyjCFbeB+P97W8RfuwxF3Vw69I
 1xsWVkKRbjBpFeA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Rspamd-Queue-Id: 4A5602000E
X-Stat-Signature: uryuk8t8xizidfzrz493mg54acombfw6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756814384-840082
X-HE-Meta: U2FsdGVkX19g0o5GpCwWBZDFjMkVVyFlVYUFT26GiTMxWu3pwzS23R6k226uI8arWl1C3elzoKSgtZf2Tuzz6CmPlT4h2OJ3km1bJPtwdMdpxt6kLeNKoryScWvtqEkNvi86p2A6VomBNJ0BX5kx62U8ytDDm1FetPzTLL0v7gHoiyOkeanH+xrqJI9P0jcM2IzuVHbmItKoOJWGVb+Tg4Z7zoXhFy7A7uv/DQoAaGT4fvAK5MjNKVmXkVplIUPC5Aah9awPk2F/Npno0s3kUJpf4ikajjevIavIEMf5zSxRegNHH8UeywKzRPhtL2fsSWHgbUxmSyFnt/m6PlR9WeAjuA5HwIiueKTG5VqZC7A38GG6wkUerjCNYc+mdgMhW5pUzk3UyJd+XTDeuuOtaJjFHhUTLzqgg5sryB1LESegXmhD/iUs8gsgA4L9An41DpHaem4HfzIlldnSdneurDsI1vSHkzXZ9ZAvwvcU2ghrL8+yOZnB3ckcxNQDicA0gLx7Hfc1fe2rnZ8Fk3mRGzsD3q4jDzwxjJgYhpUB+XmccGxqiBXB6NPYCBeGGQwiDDFyVYECflU4pnOj0plhIKDQ8+LY0E2ah/Sv03czDmfB62Ymlg2D0C2EHy5z1mbe1cqmveZhsDoWRKLk9PBjW+4tVMeg86ine5VoUTiD8/Ymmj1ZZm01tGFKuAklyYnn0sEF0cIGcV2LSfLnmL85rQlSq272zAbtO0XW0ptmqOelW4KbJnqIF41iFVQDGy1qTyvK/z1KQBtR7ZNAB2dEUqy5dYd1qc8YYNYiN+080UHvPIHX+rXj1yV2UYnuDuM42z84M5/693+Bs4I3L9ytZirC4WJ5QS2gX8C0sYRgfvnLg9GhBFeJeN+WyJb2/P7jwWbtF3HinLv1/exxYi4IvAxdhl0I847I26Erbw6GGNwQVItpV/408YNMGMPOBORYC9NS2ZI5IUzWpRo1fw4
 uOJGmOXv
 wTdnGzxDVYhD2FMKgj0x/sgKp4i/3ERKPUtMAFmW+r2fxAtiHbx5TLhIr2SPqhyY6k0E0+B5gFqoQ6RLb/g5eX+8nmwzJQLc0FAbm2/9CC9Jm+vG1Tq5su7b2YzfzUzfjUu5vCpW8PKJ1o7fwEpB1iZSqvJo4K22vTxYcOf4BWjtXCR5PCFpyxYGwoA1d5guJ3PWWTTnkK/GjyhhsH9hnySJ8jEnhNHRoWt1fPI94ocKwHkkpeu6qV61VWWuwy0p8I9XOgGny/riZjkgiTfJi12w11Xew94Okxku0bE78I3StdUx5MeWowb3dJs3fZpoPgA0vNEWbD30xV8ygy/tGLstwwNVBLTGzISghasfZGiiGnGut7bE05VbKDndrb0O0NnmFFlr6Ef1h0yIKp0yrZBsAnqcpgv+Q7WYfS0grNhSDHxU7umd4M1CnjZA7ZkyIbVX0QGO9PaL1sT+cBIrs5lVSA0MP6rJ2Rah+iFRslV0wHqNibkz0xnWEv5sLicoUxskwoGDm9/8kvlOmzZ/OOpX7ZQ==
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
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
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


