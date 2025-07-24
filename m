Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F16BC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423E76B02D0; Thu, 24 Jul 2025 09:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD3B6B02D2; Thu, 24 Jul 2025 09:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3196B02D3; Thu, 24 Jul 2025 09:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 193BF6B02D0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1CE1C03CA
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:32 +0000 (UTC)
X-FDA: 83699308224.21.B347659
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE2B22000E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=oIyN+Oj+;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365390; a=rsa-sha256;
	cv=none;
	b=G8vw2ELpP98E6gUXDLe089zMaRG2i9JqWc40ZcwGNxIsIiIyIDnIkkrME/5Mm9I29FIrwC
	/BWgsxxjOPq66uXED4QSzEn9JwbmzSwzZ+TkMSiWTfcCi3OS1ga97Z5YXi6fTXI/qKgRkQ
	8Gjjl8zzRVewdF2NlfrjY9gx4Al9b6Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=oIyN+Oj+;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=754ZhLeV6aTccnAi72YeZAlKqe4sOON/R6H0mwMKOfI=;
	b=TFJVpwrACf3M44e/4PZcebzlfap6XoF89k4dOaLkCSftJXEX8cpBCb2QisazeU4ToSyp8w
	Ie+xa18EmkpRQGusXWeX93mBXF4iI6rhkAy6UHq+ABG8uNeO3lKjnQuo2FB5hAiann29iu
	HytZUV6G6JtQMet7jPIo0GEahgG3W+Q=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a57ae5cb17so520836f8f.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365389; x=1753970189; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=754ZhLeV6aTccnAi72YeZAlKqe4sOON/R6H0mwMKOfI=;
        b=oIyN+Oj+3xSghcC69VRw84LGFxUeRG4FJvuoMv0L3srpJ3Fp8gvMF2GsigbOimBMcP
         Wa17/uXBbPbfeG/tR2CeEn02prIOf7w9hCEcky/1QzcckgQ85NPs022wbdKiCHSZUvGD
         ldEKRyieVbbGdB+hTIQrQNaN22ueQY4Sh277dDkDIOkc49HuuxCCuaWsqR8YbMOE+kSX
         T9sYT8/fzqDwRZpfM+5S30pm9dR4ZTb2i+Kv65P5RHGYzA1ArouaN7Y0SGpUBRs18uL8
         U8lYqxUCNpelT20RoCDR3+TPbsXdKhowjgX8JFNZ0/I/nRxaUko8L6iW+jDz3WktWmRn
         5pcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365389; x=1753970189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=754ZhLeV6aTccnAi72YeZAlKqe4sOON/R6H0mwMKOfI=;
        b=mCnA5OVQpPzACbkoklUAt6wJr0T83+qmT09v47Y1OzWTensDCYz/10VJDWd8Gp8sUu
         S0RkdGbmBNN2Ld4HydD0Ir1cOxWb/ORZnLQP8wQnuekTq5EbPQSvEUZ5AAFYzfP6DAjw
         Df7OBmyChAUiywRU/wam+gTiO3zDZ5lfvIsKhg5bTg44ytmZYaRn1WntPiAIVjTrm/Da
         autXuizjUz8JggGQXJsUtuHf86/RwysIbDEmIxFd5zpaS7ww2bmFrSkCdTmnlhg1jA6d
         B066rpr9BIbH6QnMGGUqrKS81f70ltony3gmX8JzPtFXhO2DOmsZI7Vaa39oWZETivVm
         z2zA==
X-Forwarded-Encrypted: i=1; AJvYcCUT+07JSsvgs/BvFwuhn2GLAgFfl4QgZIYOY14IzwQjFDPNPpMWf9S5QpYu3FHgJ8zQrsEUzN8r8g==@kvack.org
X-Gm-Message-State: AOJu0Yx3xtIILflx9jFrG232htelalMvPXE2+3veGjQQObxAuRrRmXah
	Gd5GgQm8d4ouL0LKIySSvnU3BOb4LFYimmHJLHijCUhHvp/UopBYXMJoa7M1jDa1UpE=
X-Gm-Gg: ASbGncsnMwK+HIt3B+wp/D/v7N96SkT/+PPQOXgAZmAcstSVncoJtpDPsgW4zlqSj2i
	lcNCT5A9vtIPEfqiSM5cao3Ij4X/by0pxkitVhYv880wzWu9VKJJ+hc7Hif5/rPAbX8a6+vsGIP
	uaZsN3+rmuPIQY+4r/dKIjeyk8a+Lxosl27IEWujnG9Z+YvMjiI9Y872yKWMDD03UpZggZTksia
	AQieCDx1D8pjHtm2KcmYVNu/pxA9SRPRpje/Q4YxNlC6nqAMm0qb5lG9hiq/IhPLXCadl0pDAdM
	5Ahyli7a/MZxOKrj62YpBR1IRJ5sKm0kQxi6CEWn0So71v9d3OK5DMQu2szdZeuiykiALuS5p73
	ywFyBwmVN7XWSB8VLEELtcqZccCCU+HiSXO6HCqMO3Ped8IDcyRv2Pr1e+5BXwMIY+ImmvxwaUG
	KaGbKh+bQkLVO4K8uDty45yis=
X-Google-Smtp-Source: AGHT+IHl6TFfQx8To8y+XEm2d27DSKV0h+MO3rvshokYEfPVyki8zgMiinC0EkzG8gsJheCG6bV65Q==
X-Received: by 2002:a05:6000:188b:b0:3a8:2f65:3745 with SMTP id ffacd0b85a97d-3b768f11dfbmr6433064f8f.51.1753365389405;
        Thu, 24 Jul 2025 06:56:29 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:29 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 08/29] cpu: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:51 +0300
Message-ID: <20250724135512.518487-9-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CE2B22000E
X-Stat-Signature: pbrx5dwofmizocixe1k398mosamsmmff
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753365390-814219
X-HE-Meta: U2FsdGVkX1/gqLMvUuZ42poF2H+yjfBDw6WWCmWS3Gwp7EfpWpaAk1qJiHCvvYM82ADve1e0uQ4TyIxUGQstD0SIhkY01Gt2RSQnfceHJIDCYL3z4822O9LQ9wLKWMjDj3SJ/pYPDjinzWIM+O/wriQM3S3qhZ8iFuu0jKCL9/ECXxLSg0s1HFOiQraepEYjBxIzglvl+z9okGjWjJvhdFFRRnDWcM0EuBhbX1qf4YlUBJ1RzqXgx3GfSQPz6HWZV1Z2Y0jjuAKwDEkEVYliiDCiX/zPqlCDi5r6JhzcQH45RX5rvs/Zik9MaA6Kmfi8wWs0cAzMzQlxmwP/a0B5xgbDPLgplxVS0sr72YHgLpM+vQqlosYpIk582H2gSwKuC2k2H3MfKiQUMGTw14YWlauwLu42Wf/Pld2ectGA5RoCrWY65HeIIDE0CXShw8EQNWRXa3k5inc/S8HhZqazc/Br9YTDf7iT/O9eWHHE98XVpstyEvmoBzxJaknIgPwbSxDBIKYQyogLQ70+/NnUnHq8zgl1AWa57YULxGmCcjt9ae9++7/8+j0s5YdlGatmGDhkRoAoY47ucpmAKo1Mk2Wq3mX49Di9EGuA6frPAMywzTv/+oyY6URIez8pgNhwl86aW/KPgHinaHw4ASveFHI4/un0UxUyVxcJiHnPhIM7cAaI141cxdPSkNAUi6Frojrqc5EHx5zSvTFYVMjtZrTgiknNoMrXmapFydvBoLnp5RMSgyZv5MOHuC1jpteJL8EFaI6fMX75p29jfp+ovpuefjJLZuLD423wqkKNZbs5OIJrbYlA1f448+h1GuyZQcVQP/QetQE8CFsk9bmEQOVIpGo+cCGu3X7dSiSHyV34DWmJ0waS2OM8bF+N4Jt1YjYgcPi648c2P13QebcDYCG6UNYo+qajN4FtBR8VOqPRRT7jkak9CTVBCkjt0pyUZpUyzA/qZfcA/QM6Idd
 IxxDX+KV
 NriC6aE1PKdi3vWNbEz2RhbiayzIbv2HMZITUEdwrXIBe4iRaNw+bhw0T2B3mgqdfiVjI4tQkKMt8VTax4wMcdlz85iDVyHH7Dl8Y1m67bSl2OAYar2EwC9Xou0DMQdsJceslx2r69UV863TF5djHbmcLE4qoPW4LAfx4WULjcRPOZKxLkm967cQhM49Icl849FDXn4vuX7FtOpVl5Gx3+BQeBRxacUo4BQEXbtbg/2nuzMxSX+ahd2AhjXTjivNI4qE7ogrGnmKcP92If3Hs+Op2a/EoGw0w2guye5vqywJhDw8os7C4x1XHQFHu7HPfjw+wI73qvkNOMDdsDqzYqXZif8fCkCELDvNjcjHRW2zIGPiZvqMU1nyC0zLCHMuqPoQvu03x71gSqcQdSIisFhwCZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - __cpu_present_mask
 - __cpu_online_mask
 - __cpu_possible_mask
 - __cpu_active_mask

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/cpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index faf0f23fc5d8..d48e4dd979e9 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -38,6 +38,7 @@
 #include <linux/random.h>
 #include <linux/cc_platform.h>
 #include <linux/parser.h>
+#include <linux/kmemdump.h>
 
 #include <trace/events/power.h>
 #define CREATE_TRACE_POINTS
@@ -3092,18 +3093,22 @@ struct cpumask __cpu_possible_mask __ro_after_init
 struct cpumask __cpu_possible_mask __ro_after_init;
 #endif
 EXPORT_SYMBOL(__cpu_possible_mask);
+KMEMDUMP_VAR_CORE(__cpu_possible_mask, sizeof(__cpu_possible_mask));
 
 struct cpumask __cpu_online_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_online_mask);
+KMEMDUMP_VAR_CORE(__cpu_online_mask, sizeof(__cpu_online_mask));
 
 struct cpumask __cpu_enabled_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_enabled_mask);
 
 struct cpumask __cpu_present_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_present_mask);
+KMEMDUMP_VAR_CORE(__cpu_present_mask, sizeof(__cpu_present_mask));
 
 struct cpumask __cpu_active_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_active_mask);
+KMEMDUMP_VAR_CORE(__cpu_active_mask, sizeof(__cpu_active_mask));
 
 struct cpumask __cpu_dying_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_dying_mask);
-- 
2.43.0


