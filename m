Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0581C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905FC6B02D8; Thu, 24 Jul 2025 09:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869016B02DA; Thu, 24 Jul 2025 09:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757DF8E007C; Thu, 24 Jul 2025 09:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 604BE6B02D8
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33BF716033C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:36 +0000 (UTC)
X-FDA: 83699308392.26.0F880E0
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4A74B40004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=oTBF+wW1;
	spf=pass (imf07.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.46 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3t+kxQ7dPGtocO2eml/1QU47n2YVx1Ic6Vfv+oiY3pc=;
	b=OKxEzrtulcSQgg0mwfqsxS0J8mEZDwxMoJ4kuJeMgUR/UjY4y2NQj9/BzQqJH+uGpxKPph
	g2MamFOrozaMMue5lb5t4iSVphjQ4ZwuKC7Hr2rGWI+tFLirKGFlP/VjtPc33so0Jv5y3k
	Anmp1WgZhFLr5j3IxF5m1aXBn7PmsRw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=oTBF+wW1;
	spf=pass (imf07.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.46 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365394; a=rsa-sha256;
	cv=none;
	b=rQ/Vat4VAXc3igkFaChEKTdIlIF/jgTDgY946oNtkBBoNUso0UqAQNDIxWpZIfX4xPoK6T
	jBZbgjAaxm/60QF6S7HNhObJTmLuuGw8dhg21EEIG2VcEKUot7lCse9A5lIDm8RN3Xe8vR
	3JQuWiT0QR6TckAdguplKOxpNX9ruuA=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so10698475e9.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365393; x=1753970193; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3t+kxQ7dPGtocO2eml/1QU47n2YVx1Ic6Vfv+oiY3pc=;
        b=oTBF+wW11luaCsKpPpBQk2uEJ3HiUwY9XUxBpN689iW7fPKefrKwss/plLJcECih1q
         HiMX3ZHcjAiH1LWze7WApYaByuVqRWP4CmMV4rZkcsKCreO/iOgUuMgEq55n3eixVkzW
         hhGOXkGEdiKKvJaxM+Ne2tNzHx5UyeECf5CY/EWPhohLgxxz0mH5aH90B9GGDbn9EtYp
         jxPJmN4wM8Wsq9vDpl5QQNKPObdNbLtujtysq2NNuFs63ui87DpP+tZtAiiR6k3//DPP
         n/A9LxCWMV3KbNmrnMfkZaS9cJmVbexPtOAeMoVpvHAp+69vFh0Scb8HyLN7drjLE40b
         7Xxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365393; x=1753970193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3t+kxQ7dPGtocO2eml/1QU47n2YVx1Ic6Vfv+oiY3pc=;
        b=alU3KoUar09Vt/W60os2TFnxjVL6bPcT8lE1Wkn+dxrcWz5Zeh64Ix59kxyx7rVwa7
         v+21Z3kkjcp5CUr052ZW9DhTlgzHfyYDPyeIdigcWzBVegOJv1I6D32K+FBcNaCw1y8Z
         TWBZgEvtRnQthUnCZO/U8kqm5D72hrjYQapy529iexlqRw7ZnIxKMAbSUx7qkbCTJRKG
         IBDAp+H6jRi2ojbR/CEm0ldJ+4XGhkpBWaD/0K0qkiipdcKE58Pc+cQGJaucFBJTl0t2
         zt8+1V65o7zlRtcENv3U0sqZP3WdJwS3MfBE4sOpKL4DyJ7GNQTLqSwpc8X6WMRO6EiV
         9X/w==
X-Forwarded-Encrypted: i=1; AJvYcCWtSR3nVyV4Qj9y2bE7wQL1VMyDzgAxiDL3rsqqZS+XV8VvHx9I8XHYr34HPWcxmwAkCXX7ek9fVg==@kvack.org
X-Gm-Message-State: AOJu0YzGoJp5dBM7jFj17s7RZ0p0rmp8Q+BM4sQPJ/DRNQC8fL6G3WX3
	QzT/PYmTKPX4AOx1tl+zlPXeLgvktFhnEPzBw0rNtTZSw9AwPk5y5WDKzGSXOu+k1KI=
X-Gm-Gg: ASbGnctlSggKVjD3l/cYYh0pi5VRW7NXtRlsRTH26Q5TMxchLiDim1ovVQXMmfNLOAC
	jCkK5UQ/AHuBF/hptiprHiVGi8a2zUx0lEW2leyCQmxJfQ15Cqkt4kQz816Lp5vzhv/wCtOvHxd
	ZtHSyNE4N4ksut6VuLBs9Jw+okAy73hgzxZLNsUpe7ekI43i4su2hirDLnjvxCEbrpYbvOEPrhN
	anFvDKfIo1qoJhTuuT0JfOxUPowFvMh89lWsWNLGw5App1UIg9UXPJ1AhH9xKdgm7NRySTB2rRa
	nupYf2Wv8VNJdqH10d7zlbBTzs65spAhr7xVmnh4DBVwI0ybPxY72QVCVGKywseJYXO7jnXT0KS
	Ha1JTEHkzLCgRirCTfzGIkKJAtwG1SR7hDVjfFrmc/s3WPYdZDDM1NSolkAL7XnWIUzCD7Wt4Hu
	BDzsXKibev1bNARJ1tZb6p4qM=
X-Google-Smtp-Source: AGHT+IFgnp7J9pcZF45aCSKJ4GVrrhV0572AUoK1dVlyY1LCSR/mU9Z7mKYUQBRdiPhCDw14ZigOTA==
X-Received: by 2002:a05:600c:a0c:b0:456:19be:5cc with SMTP id 5b1f17b1804b1-45868ca72d1mr74457525e9.14.1753365392991;
        Thu, 24 Jul 2025 06:56:32 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:32 -0700 (PDT)
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
Subject: [RFC][PATCH v2 12/29] timers: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:55 +0300
Message-ID: <20250724135512.518487-13-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p4twwiqdox83h8g4c4d6mwn7x4ts3nb9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4A74B40004
X-Rspam-User: 
X-HE-Tag: 1753365394-158065
X-HE-Meta: U2FsdGVkX19N6TJhITFkEI3SzRvALnyMvqWvIDRJ92Dpf1mX296JX2KqSuSt+9b7tIPSgG3NRKYfcYrjpKnV/o3fXuxA9g3LjJMF0SRNJK0dMhxTOmKbxS57lznfdV0wYN0xmL68HJaH9+PGXiyiBf1ltBTQbEQ+cIGwMo2BOc5PwyZ57RN54tedDJBI1sZLZL/7oHw5gjsF1e/uZ3oxpEzFKKXi0rY5eHTW/HfjzwJbmDAQUa/1n1ZfCGA9lFYJ4tt1QDo7b9KZDj4yS9B2Twv6u0C/kaKrE2253KvRJ7Q+1ti4S0OJnxEN/LBs+lfbUmeqf9EGhgWBRq1yVOb6SiyM613BwhgAhGAuxyZY6DZzpe3zHl/vNrLy3Dmyze4jPGsyVEPas8RqhY14eeRLKusbH8h6XntSL5zNwvJMwLTU0RVmvlHfPLF+UWmUsrLMIn9aWB3MZyPPc7llXD9WHVx8AvPLqoTxNpcAaFHfuNKJtL+yTq0vtqullj9jejEbpumCOXP9k/O0AIGRJBzBYjHYbhlOjJ9UCUe32Bt6Ob/avbFpR7IM4Qv4xP7aMrIrgRpX1rLi9Aq6KUjE2Gk8wi9AhIzcsoz+LxDUnqWRs4rgsgn1jDtTwptlpb1iCulqzGo5ofjRFICSCgneRa0cmTA5ifGZXjRQLNUx0sAr5XzEM9KgwUpk95GbL6BlXggF3foST3u2QoCR4gpHAsaaCPaUrr4J942xft21yjmhTXBVU89dqBtQkOiIo4E05pOCu8zA2pKzCjrfyGG6ZFTb4P66URftGuFLbVt6rmF3ruxC3PkwI0I68LtXfqrtO6zEBiEmDV8SlRt8mqmq9R13wPlHTUjd1iU4+0YoqoA1vplbwlxhs/I3RjH9tddeL0JB7pzIlKrGBOfQzqZvX30xB4pHPKbHEl5WPqTABQpo5T72cDqloohktJvVAp/3ujxPGUhEAO+rV5G6OGfX+8P
 46Izh8P7
 rJ3mP+qYr/tBn8Z+KaE8j+/7Dy6ma9yEX3E1jgHxpHRJTRZDocHEN2GzINoFzYSYMfQX/UJ//0H5UA9WKDIvT3xD6UuuLKCX0jdBIomIVZzZkpMhCcWA6pHGrwxu4OKBOMQUBeBoeNX0vgkujsXvnc3YbKy71wZ+eTiALzMlGqKDdmhLZcs666tazNtjocTcQikwXAU7smo0H8pXMQOsvtbE+Bg9DzHkaQCg1h09/tvHJV8KNddZMGDX/yx7wahkyvc7m6uczkDwBQsj81l6KgLl1aO44ySnN+SRbGmFwsYldw1Xy6OKYj1UHT3Wf7mU0evP4yPCtBNbN1eB6e0DsGfm19+mxVCiguwMciDh76TLCyiypRLEh/R7MaBkZObFAxV8kCqnEHwkQAeYMhWBOCL6izA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - jiffies_64

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/time/timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 553fa469d7cc..a5698e3ace2d 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/kmemdump.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -60,7 +61,7 @@
 __visible u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
-
+KMEMDUMP_VAR_CORE(jiffies_64, sizeof(jiffies_64));
 /*
  * The timer wheel has LVL_DEPTH array levels. Each level provides an array of
  * LVL_SIZE buckets. Each level is driven by its own clock and therefore each
-- 
2.43.0


