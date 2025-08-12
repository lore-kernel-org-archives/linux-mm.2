Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43623CA0EDA
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831418E0103; Tue, 12 Aug 2025 04:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8F68E00F5; Tue, 12 Aug 2025 04:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598318E0103; Tue, 12 Aug 2025 04:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 415BD8E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:27:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E46E1D7463
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:34 +0000 (UTC)
X-FDA: 83767426428.08.3D27D0D
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 024A5C0010
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:27:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=2syqJsDL
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JThKrLTPuFVwzCwJhKd4fJmIEtCxHnGrNzSYzGU4KrU=;
	b=A0/vm1Hf3/04SS541djC6xOjhc971efprchtG57Or0A+Vxa1/Q/yt6uuSIOaO/lW0FyNm/
	Td62oSOp4GmMAFrga93UGiWqdfl6D9dul4dtC0EewXd/0X6QKM3GjpvYmCYkI3XlyRWB64
	Lwe40Eka1LFt9lcCSPZb/6Cpr98clIY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=2syqJsDL;
	spf=none (imf28.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.221.46) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987252; a=rsa-sha256;
	cv=none;
	b=J3IWoOGUucRqva2nHDKN9ePp8ITWhp/HvrZ8+br2pHbIh9XmyOrm3BToQe1FpLasOcMEAV
	zXbye7E0zEmYb9X9DZp/eOdjROrb87dDp4z4u/cYBLrF9WKWRT0bcfCKbQsqClas2BS/co
	XbFeORFsalYI9sVmwwTdSYIxsy+ExDg=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b8d0f1fb49so3071774f8f.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1754987250; x=1755592050; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JThKrLTPuFVwzCwJhKd4fJmIEtCxHnGrNzSYzGU4KrU=;
        b=2syqJsDLXL+FOdoO5dwg1bO/X7LIrOkbDQUSaxOWgcf7zr8NBrxJJkBZofzIXFCFfV
         O1Rnljbi/DzH3zri+5MawftCVkKsh3cdGdnPV0ZWVYUtKPWXDqS00bzrR+D/TcJfhuop
         hUJZSN6pDesgJhnfY9tzcXkrLv1VKGDZLJVIUkTVIKLLz7j29q0mA8MH+zO9FBAqwHUN
         2dUIL1X+YaZqFCgiBjzBv7ocib/QD+6Hg36vop2x2VTG6GEqo4DVOjjKvZaGf1vzi72r
         ES2sfqTbfoezLMWFK7tnvvEnwWTuvlt6M5NNzh47Q16LsDZrJ0N2GeAYmCpFfDUoFrb1
         9w7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754987250; x=1755592050;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JThKrLTPuFVwzCwJhKd4fJmIEtCxHnGrNzSYzGU4KrU=;
        b=Fi9hRJkKYI7n1pLnqbGED3HqdRG7aks9r09Ia7FFnXeJiMl7Y5r0GnPLs0gwYP7Yog
         LCRwuFTxWNoSV3HHFqYCdeE1AqpQfMa0OXqPpKP4iniOK8VTNHiGCkpT2Qkv172TLVzZ
         xCa8HPhyC/DtQb04svSwuqQ9/u2c7d7L1Q57shw/BBlDMOplAJcKuQER+UWaLxTqCPca
         WFL5djdiugxLvGfTochWyNIlOedKHgihq+IQB685ohLORTrfclz3dRfbpBzRF4lO4VlV
         0+vD7cSvljjLolp/68yqw8fsYydLUVs7mxR4QbS712VBmryC8WldzPiTEd3BUgmFOaVj
         akjw==
X-Forwarded-Encrypted: i=1; AJvYcCVuOGxyPw9J5wkHLZheEjPzdfNncZ5PkEEiDztrs7CF/r0uug03ixkB5OKQCBoJYSw9UAr6JPinsw==@kvack.org
X-Gm-Message-State: AOJu0YymanCr7zVeWSiYoP0+zqzazBP1LnhXp+oNqrTg+ISyvjcZMawY
	BrtnD11hrC1ieOswIBtMNqTimGDZvOtFnKFUBLcKYyIX6ceUtWmrBGeO+2SzcPaz3Lw=
X-Gm-Gg: ASbGncsEDCSc6zoTN4fnf/GzVHkJvmORZ41Jwm9IbCjcE//ro4JxyCfw/fZqi0dQyHg
	JoMZ1pbLovQvrZBpchg+1yO+pspHesdEXiYsHbnvUAs5AJD1FlAvviXvgy3thbewGmkV4Y2l9Tb
	ojChLcV9zNQwl581oT7TXpG3fhio/fRSYS778f5WDxrsk8OuT4Ia9SnrrA2vKBUTcm1jIMlR4Or
	sWWv5YP0KD/OwJMeX1xCU4HqkgYOsv8gJ4tYXPurFklIcr5PVFqz7qSXPkG5seyS5rgsI+WB11W
	Un55ew7zRyKDBosKUpHo7bMXQEXI+GVj191kzsMdkoIuE46pKlaVJDHriOS2Y/IEF7WDL6DGKc+
	WTmzbJcTX7qI6p3U=
X-Google-Smtp-Source: AGHT+IFshlOvFK729Q2HiNSttBuhYGO5t1MHAK8R1Tl8WnDbe/OVg6KL0Aon7hXzH1skJVAbXFREsA==
X-Received: by 2002:a5d:64ce:0:b0:3b7:8473:31bd with SMTP id ffacd0b85a97d-3b910f9ab5emr2145237f8f.0.1754987250520;
        Tue, 12 Aug 2025 01:27:30 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:16c8:50:27fe:4d94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm43549423f8f.18.2025.08.12.01.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 01:27:30 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 12 Aug 2025 10:27:12 +0200
Subject: [PATCH v4 13/15] pinctrl: qcom: add infrastructure for marking pin
 functions as GPIOs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-pinctrl-gpio-pinfuncs-v4-13-bb3906c55e64@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=1TtCXH0c1SnNyHC+v6gZsytFHMfkLN/q6H3Fm9nBNlI=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBomvrZ/VR1c42/G4TctgjID2K26TyPL0+Vrg6x4
 9ryMo61KYWJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaJr62QAKCRARpy6gFHHX
 cvCLEACYvBW59+M3gJi5bBpvwd53LIDA7Fi09bh7cf6sZQwrhnc+q7Z7XDWdo3gOU7A4yZx8nrE
 lf5eZ6c3y4GemvfNQDbmd0gu0FBsb/49YwP4k87d87Cdt8fNQd/08Gh/u32vbVpO16l2Je9VuY8
 3WZS7KC5/KJQPKXbmxUpP5C2z8mULdzAb4PKQT3dZ3s7f2T+hMUUwinrZx5u1klaFQrlOXkNTTE
 ba1l7tJFuZ8cxCTDfvpt3YSkOLMkDNM5HWjtfxL/gfiQ11OM42MAVw/QrrA0hu0Ez37gjOlTBx8
 ZfQwmRq7Gx7f8H5yXUyG7PrHQL+qjkqv673/8cqJFGcqwAse7K8jlSiu5yAKyPafqYT3neO/k4u
 APj8e2LBEwVjTBl0IhJdS6/+3AlWncZFxd6E60ROpK0huq9Ds5Fv1bIjzPvmGW2GKpF9MFCbdd/
 LX+uj8t8HrERHsIxj8Mov/RLEFgf1ECdyKINeMXsW0lLsbYkkDL62TYt2+/nXHkr6BSKZ1JX3gQ
 HmqI5/Ni9xR1d9/yvtzD91OFmakZA9BucAoum0WdD/tWCaF24vSjO/wdUntMJqmkxYWMM4CY0ro
 B/bQkovAcHO+am85u11GmUCv0se9FwLnggtnVe9u5hXKsKp22bC+38tNUX6xqHYV+hSPyXCLYu8
 hN8vLrtlGpDakqA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Stat-Signature: 8nc3ktx4srxsqgdwc74iq4c1aiiemruk
X-Rspam-User: 
X-Rspamd-Queue-Id: 024A5C0010
X-Rspamd-Server: rspam01
X-HE-Tag: 1754987251-107342
X-HE-Meta: U2FsdGVkX18TEjAE5VE6TjWPvWP7SYdhhrjvKnjaTfZwPipe2sHxyPXENF1Bqv9BlJhZY4vsH0Y4rUXHpKBolIwpdKeQSgfxiHt2AlWkjKr9zydKkV5jAH/jetbGGTve6nAuVSwAvargdERJQFrRMbIbBm2mXEUpigGLeU7aGwLW1y0BILijEZBT6vrgM65bQ1YxGFupXCiSXQNb5iLW6/zQddcoP4P3C3WDTwmE63j1Np8FnVA/9ShZ82rXHJAfL1YFMfKGbTHsyA0FTjnDuuVwybs6HpiCEAcamZ0LVufzpXuZD8+1BSeknt/JL2jdcotVGqyzpOoUKUp3aLqsAJuRT56DVjdqSGSpCeV2U3+0VwOhrSAksQGaLMqBgsyw2ABIxE0QUyRfBBJGlW11NvwVxb9kHDNfL9gXcPvV/udr8qeussUJ/iXwK8CUxCxyxZluJW3fSoY5Tr+RGmzsd6UdnNqHJhOxLu1ed9klN+Z2TqPXSHdzws1rmPzwMxwkD1QPHWY13pCyNZTt1aCljii5i4+OkzqrWVIPEl6wckE2EbDHGEYMKyKraDDRjWuoFQvWjVOG5MJTgKtefGKmoxm5QtNl63vVSEMSJlyT7fu7KxyoBI1NyUuErY63ZbSDdzeaj10XzehVN0cB222OtrrIue+Di0lhTsJHDe+mr2tzY1GRnyFG4VmKZZ9nAso4EZPBj6sFY23XYvimUAJsNptJUVvTwRXgxzfC6OVzScUuPlF3CgDlsdgng9N5IPp76aPJBWI7PcxwZxI+8cV4CXCbEcxvvnVPXNZvzm4vYprGr6v1Ob4xBG3RnTvjJyIKLFx4Gjbcx7PcEpDttDuVyYbAXGjGP4hjG4uIqyeZsirTswRID2QlPadw/PeFE1kDy0gqcdwqYtQp9tXCgay6qy1tfUbj/ms6QRMIh1mVJGepISc8ej/7jpUWNje9QRIQGqPhvmUkfi7IYQuPqNh
 s+gekbm3
 QKJPMFRXx2qQMicE/c0BDrq3RolG5OSVbmT4cR2y3l3g+F1Q8TiZh6KlHXVT5+4Nh2i3GZpbppKpmDIlAH4K4UnksQlQ4ThviIZ+O8nwVSaBsNEXw8ZXCGpTZddJEij2vUQzFzzXEuc5GeGgkBcow06hN7h/AONxBKJq2SeWJxuD0DOvezIdcmy4h46Jm5h3Pw/1tIG6hfQRhsFYyaFqC6IylcW4n+SpMTH3++CH9fecjndfVf7SgbXV1jDkLX7dguqNus4UIpuGZrIPaR/AW5gf9rUrWFUwBP8z8jSSWFlCSdJgHfuB56FjIcr2TcC+E6Gq55EecDIOuZThVpEH65RwHgGzC59BJZ/dUguhhMvpkbcrk8aCkUEX6YZnzRgMNCfQ61q8FVQK9QVbKgX8/Cg+75f1BV5LVpqiNuZdU3QImMG0jW+D1AO4CV2X7WEKiyxCTGc3jD4VheGlmhXt68f3sHsUiksxugZYHceeDU/U4MjJqE7hMnDxqV7PtvBD7unk0NeWr6wp7u6qkOwFYqXjCjw==
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


