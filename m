Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81770C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9FF8E0082; Thu, 24 Jul 2025 09:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8434F8E007C; Thu, 24 Jul 2025 09:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732898E0082; Thu, 24 Jul 2025 09:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 502D28E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 126F2C0348
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:47 +0000 (UTC)
X-FDA: 83699308854.21.613D944
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 209E5180004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=FLRK0Lrc;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf24.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=io4h5WAIvfQT3VZkI4AOHF3Wp3PwROfn1AQPtlUH1DA=;
	b=CeOSTCYss2HaIkW3+4qwn5DzNRF7yOTwkopByNdAqYksSV1pyTjVc91Ep4fZHz4ncwRH73
	uCzhcPCIpBQBh+y/Vw0WGv4m2d3+ZINJb2FBkuh0wTlJKmQRyl0lhRHu1fuNBkxklF0TwO
	jpQyk62eaxQIQlSWo/fnPPz9lYA6ctk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365405; a=rsa-sha256;
	cv=none;
	b=hlLQcs3hlmi7t6stGKErUi7OvD2FH+eLCbz2B36b2qH7JsQqUMAvWPRRIWBchMs/TRlAR6
	gOBs1pJ5kaqcV/VN+UB6fywAcTUgx/QFL2SDTXhp9vdg7Pj9TjGKa2BhaR+t90xUusFdI3
	jon+s4Mt4dsQ8grmsBx8M4oWCpHsKJg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=FLRK0Lrc;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf24.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45600581226so10583775e9.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365404; x=1753970204; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=io4h5WAIvfQT3VZkI4AOHF3Wp3PwROfn1AQPtlUH1DA=;
        b=FLRK0LrcvQ86pvndVqL9h3u80CjXPIkosdYDF6M1YTV2Cz2ctZf0L28f2uo5elqXTE
         D3xG3e512iktWlQ4rIVhNsfj8hj2Op3zhSquvw30vu8EuMRTX0GhzTddYzUuGcu9tZ+n
         y7FAhqMIQfbXtYYGabqYHx+IgjtFfW5NyNOpcNENSB26el3Kcxnbd6E6VnzxSjcYLm0/
         nuUtAsxzbPM0Khe8eojZKyAOGGvnyUiFN0eE5TJEB/CfmdACC//tvLXgFescgRxdPf1f
         MAojnvQTUiTA6nPP30oEUtBTR2HcTJbE6V1CtsEZEdeDfU34qd0IBCDR6MnfwpOXc0K1
         3v1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365404; x=1753970204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=io4h5WAIvfQT3VZkI4AOHF3Wp3PwROfn1AQPtlUH1DA=;
        b=gSAuaYLO6x8H2cst1Gfy8CabWktETYTE0KIlhVpqQ5bpjiDnWhWgl3kfsboGfqXh49
         Bvw6/jht/mzlumYEX7ROt/n09L8mtfU9xJy0bO1mYZSZXvlqkIu88xZ7V17t2thM/5DN
         loEr5Q6HwuIuLyA1sDoFLdlIH2IgPs4MtcM6zARWUm8G8wGOboGNYiAmbubrklFtAGt3
         BKeCfusmf6mh+DkY0gGUyE0D4jY0/1aTE54PLxhBKEpaz9ek6jpC+Qaz5y4Na2ganSUf
         9RLb/JwKcmBJkzpFB6sCdUYMipFrMqR/PQUO32/jj44J4rJXH0lSpDdAHRwb0im5Xcid
         m3QQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgEIc08GXm+RW6eL6Lqk7ZPeAU34yhHXp8ISXsrjGfOVtcgP9kYUXZylbul4XtBk5MyTsg9xHhWg==@kvack.org
X-Gm-Message-State: AOJu0YyYRpqLrd1s+We2qaEtnWyVgBPgw5Xl12zUOIREgWSs8OKqq0Gk
	HdMR7iejQ62by5hM8pQSw9P+qxIyz1/VzJaRFcEWkjsEC1qTTHRZebSJ+RZ1IWO3tUQ=
X-Gm-Gg: ASbGncu9dGUuswrZ6WKKxQ2kzh9nfbCNDsy+Pn371Ibj1CduimOuR3e4j0yj1UhwbMl
	z/76v1P5z9Wem3SMGztqbGlChY0iOte7oCyZzPpyteM9OeOc2lVvIoiu7/PP0r6cZUAx/eC13QF
	R918x7tdyQHomYz8KU+jufz8wKreLL8bMMiTNbfGdAjAfoqOAz/ucGF3cqd5RNq3oj2xMAVlec0
	quBBISdvxes/K1mxHHgkFRa+Z6QGuekiFOenRgq5UbzneqhjgQQTZJV6kgsuO7sV7Nl9Ol3EBnA
	6Gf1u23dvCyEGXsLTxwnsyUhhXzcSECx2t+f+ijHauL6k9l5Fi7akraCB0ciigHoGj4yXUdaxOm
	gkoyeX3a483XfXFXMSOa47k2f8+Q9U+6yGaWQPeB6UVsSAFvQQQZJzzUF5azDf1UICqmePirVcJ
	URqOY0w/3k0eb8
X-Google-Smtp-Source: AGHT+IGKgu4NRvfPslcwd+sSrmwQP//isSIOnofkVKYWLLSsjM6dUJOy4a8soeLJ5d7o54vF2kp7ew==
X-Received: by 2002:a05:600c:1c22:b0:442:f97f:8174 with SMTP id 5b1f17b1804b1-45868d31a2bmr69596125e9.18.1753365403699;
        Thu, 24 Jul 2025 06:56:43 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:43 -0700 (PDT)
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
Subject: [RFC][PATCH v2 24/29] kernel/vmcore_info: Register dynamic information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:07 +0300
Message-ID: <20250724135512.518487-25-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 209E5180004
X-Stat-Signature: k39zzdy58tiemyuwzg5cch51w8n57te4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753365404-124338
X-HE-Meta: U2FsdGVkX19454rgfV5OEUkGunR7FfUoRg16Kw9CSwyIyxVu+Fkxv9CZRwv2UXRrGiGMj73Zp/0CX4lH/iqL7Ar8hULF3kDZyebUjcUM9zLBq4H/HmPIZ6vCqWJ3YF58bzfz3hyZ3bYPnyhTCR+UmrmXU5WGAD7s+Mg76G8sZSEEZdPJU1kMzZr+nwupPC0qgOXOg7Ny4SC5tWq50Zkr/i9XB/OrThXqVXufx1GNGJoqa6nL6rap7PWpXorcQ37YGMILVW6TarlwsggShowg6V3/3Hj6INTG1togYJ2HWWBsni6UmVsUVm66f/vO6sNCB2yS6M7jZjFLsB5UPx4wCXnLrudfBtnIHqiXPRHRf34/sD3E74q2lWDxWfy0ziaUdPHa2m5K06ZS9Pl47whhYNmOvNUbGCjIQMKZyMnTDrMQ17iEvlAJBdPhDpXs8Nk96PkzboYqaeXEFP7IyB//TD3rP08TN3x0YN0KOY7bA6WgvgWibR5oi84VGhY0rF5WxyjTl8u+9xvgm4HEPXoKCHBTWdGZtVvelegxNt9LflNUes3TDR5lkFAs0ypNRZSYThpew7e0asZtAN2oAY83nbdVkbLKMpcEZmMpOElDO20tdmgak+VbE2ef94nqSmmW6lfgOnvQv+ytubDgAH1NP1lazRzyXRLuuq5rajn8qZ3eBhz/eQVkvHuL3fOjxyIYcLxSwqhA+rYM3ogJsmt6AFPhPSfPkWmjP/EmXP4fe9d5s8G0WgUESduMYv+shylrXpxftkf0DwVTPIoom6zVWpeK4syOrJBixzxMgXi1zkgc6NvUoUOhfz0fWgIs4/fQx5vBS8nrEK+B3LYBXp8P59OI/fjydRgvBdsci0IUkdw+FiQZTJJy3x+ElYxipVZ90Jd6aCct34nlk5qXM++3RoTL0+UX4LdDHpjTGNama4uEqqfozQulrLjf3Pgjzc3gJMRwBNIsP5HbUffYot0
 bhbIqcVe
 FhJ6cLmUsoDgSYwb2ZigoXXXzGeSOyIvUjer42e9M5ygaRcwu+ctjHYszBWspCtbHQyobpMFhMKwo2BUfi+dUgliRbIiNveN+J531t3oO2DEIRByFwiuhjEAFW2vOwPENcezHDD+erbs5XUwaf+PifNkfLmyfOGAMGHHfTXGv2+yHQHNGIy1cMRM7aXtwmxed7SgY5F9Dk5sOqPBQaP6iD1q0ZqmW6m+D0CmpHVCfcUs3WzP0Bjp3F5Al4NDrfKYBUtLKPZ472YSXB3ntIqfDbIl3+D6QB2EQKYAhpIz6EI+Vdp72hgUyV3JyNCKO59362f619un1YaHaYsoh9MYgkzqMxabbixUrJffqZaAvnWdvQ5kFFOv01nYioSMXpj1+xrPqnIDUQuh0AB2eHeU24BlE1dgU8hb96jE8NpLhmO0VGwxIenJ69H+eoZelCpDR4tEd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register vmcoreinfo information into kmemdump.
Because the size of the info is computed after all entries are being
added, there is no point in registering the whole page, rather, call
the kmemdump registration once everything is in place with the right size.
A second reason is that the vmcoreinfo is added as a region inside
the ELF coreimage note, there is no point in having blank space at the end.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/vmcore_info.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index e066d31d08f8..d808c5e67f35 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -14,6 +14,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
+#include <linux/kmemdump.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -227,6 +228,8 @@ static int __init crash_save_vmcoreinfo_init(void)
 	arch_crash_save_vmcoreinfo();
 	update_vmcoreinfo_note();
 
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_VMCOREINFO,
+			     (void *)vmcoreinfo_data, vmcoreinfo_size);
 	return 0;
 }
 
-- 
2.43.0


