Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9877EFC6160
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 08:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05AFB6B0096; Sat,  3 Jan 2026 03:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E166B0098; Sat,  3 Jan 2026 03:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D626B0099; Sat,  3 Jan 2026 03:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA2E56B0096
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 03:48:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 775191401BE
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:48:05 +0000 (UTC)
X-FDA: 84290025330.02.2EAA22C
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id B87B540002
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:48:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fRMXaRD4;
	spf=pass (imf12.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767430083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvs9mu39u8pUKEaoauSfWHl5WiFJwmaNAiuKq3SpZKw=;
	b=VbnBsodqr0CgvxEX1S35Z8ez5xH3xDfPmflMUYWVkYTVxaF7pU/vt3uFvKqXtDe+sZjBWO
	OiJg9KYlSPWrau1I6SEjab/6uQXEERqspRYanU3b3tU7LBI9RmjIwssMQyFVktEO64A3ib
	KyVpaWAW8ii9mi6ykApV5l22foPa1sk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fRMXaRD4;
	spf=pass (imf12.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767430083; a=rsa-sha256;
	cv=none;
	b=E5nJ2GTbFieIPWuGXTJ9JgbSiqFlFyt35LfO0+pNKLCuArYTF9hi5P/DBjHvFgsPErw8nr
	t/bv4GvlpKVx8QBn7WfiUHn4g5wpIf85nOrI9gRazJJE4cnwNb8xh4MB6aHyze94ZSO3JD
	8E9I0n6R3ewO4gKWDypPYYhuN+80uZI=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b89c1ce9easo14103513b3a.2
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 00:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767430082; x=1768034882; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvs9mu39u8pUKEaoauSfWHl5WiFJwmaNAiuKq3SpZKw=;
        b=fRMXaRD4Bj6+xHgWJ9IxjqjFvncYlxa4ujtwc19cWN19LPwmlnXYQFWbeH0GmOxeEH
         z68LBbUWb2uIRgxstYnUowJw2osQbsxFlBA+fG+kvvWVvHcfY3qJ/hIgTwPNI8Lw+HHs
         ciFQEy2psvwjuTju813W3TwBR7UI9oaUDHPr+7GO8jBDffnxUYk+dxqKK6mvr2x24Zad
         GG1DONPMJlLbXzFK6xDudWXOvJAQRj1t83BCTqmyy+bow1HrHl5fYxwLDvGtAFG5b7n/
         OXI+r56TBcmqJkutl8rQZ2WcbObhXtNFL79SrDMIBBN4zzAhVkrb+Ry79hyjtvCPgRkT
         eIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767430082; x=1768034882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bvs9mu39u8pUKEaoauSfWHl5WiFJwmaNAiuKq3SpZKw=;
        b=H0BjUZsddWd1f0RdlXOru92G+YIa4dcF56Bs9XvW/GN4UzG+C/A+SXfki1kpNA+8TA
         tvL5OSECzuEU91oq8Wdb5Z8kNYU6CY1ZC7RFq3SPIX8U6klOc1oFEurXEjw1FyFk6JHX
         DRR9rGVig2sKCfdYZm2MVkbxeleWmPw8ie5/ZSzn/PS5dylIRGACFObfTPrp4s9G2EFY
         gbNx1AyYWtIJpwfOb6bbxke4D7/foZbm2cmKtBlBsjqddYRSX8RGSbrjo79JGH7RU4st
         PaHjrV5kSnkoQ+XeZwqLusu5giIID5i5KlM6f4YaP4+OCL/cOZFm2GbsAQYMeXkAjjtS
         4NUg==
X-Forwarded-Encrypted: i=1; AJvYcCUzN4iz5yvDGbBiurJVH/VrobUNm7D6Y3L1z1BYrZyGmuujMIbUjDhCDW00W9n4AU2WPURvcxxojQ==@kvack.org
X-Gm-Message-State: AOJu0YzzwN+2QMMarGYxm/kxMpbgnpUSkfsDaSSnse6KXlL7brJt1wdS
	sqMkX02I8dd5M/+FWZlipwfv5i5grxJ6dOvZhmZjh2PHOaAYTPaOha7K
X-Gm-Gg: AY/fxX4lQCr8faWp5v2RifMcWwxdwyOnbbSUSessXf+8tEUKaMYjPj2iBFl7zJYZW+T
	fi3/VqQFKm/W5UqpOiWH+WFfvAqJMMg+/2lU6qgD5CEl8JKWbtbJHXw8fMDRvlXc1X1WxKpPIE2
	Tyv5udU+YLi9/0wfdDSx0xWqAYcG5LayuWeg+CIY7LVCgQzePPHPGRuZSiWBfo1zHyqAjTC5Vyu
	b4jNQqd/WrhCZMghASn7NfO3ZI0a1AmzRSZ4V9iElB5c21PvFbnnArjphGy2UcD46t3xFPMKg0x
	kO3tkrTKhnYsuTmM1qxqHKy63kLc2WK3/jzqj8sunRQ/octV3FOgOin9ZFN6JMAfqqW+VUUU8MI
	3nBSoBTiwAAqoxMofva6k1gbJ5VleOj1Fehfh6VTgTG/qE1DS2XMZ//HmhvZo9NWdw6auA0CSQT
	g+PEET/NxUGslGgnrpWi6c+29OmQkjHaANCv8=
X-Google-Smtp-Source: AGHT+IFtMJvjrpfUuqAmA+OpACtkefUVF2XH5YredFgsYPdy6OhoXIwbDm8pMiudZkIWzurpixeN8w==
X-Received: by 2002:a05:6a00:338f:b0:7a2:7792:a477 with SMTP id d2e1a72fcca58-7ff65d7e81amr37223258b3a.27.1767430082432;
        Sat, 03 Jan 2026 00:48:02 -0800 (PST)
Received: from jvle-ThinkPad-X1-Carbon-Gen-8.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e197983sm42704939b3a.33.2026.01.03.00.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 00:48:02 -0800 (PST)
From: Keke Ming <ming.jvle@gmail.com>
To: mhiramat@kernel.org,
	oleg@redhat.com,
	peterz@infradead.org
Cc: linux@armlinux.org.uk,
	catalin.marinas@arm.com,
	will@kernel.org,
	tsbogend@alpha.franken.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Keke Ming <ming.jvle@gmail.com>
Subject: [PATCH 3/5] mips/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
Date: Sat,  3 Jan 2026 16:42:41 +0800
Message-ID: <20260103084243.195125-4-ming.jvle@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260103084243.195125-1-ming.jvle@gmail.com>
References: <20260103084243.195125-1-ming.jvle@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: r7aghqtqdjs3i9hoinngxp9oiwrp8zj1
X-Rspam-User: 
X-Rspamd-Queue-Id: B87B540002
X-HE-Tag: 1767430083-384855
X-HE-Meta: U2FsdGVkX1+HOVtl8B8abnyko75oQA4IHBhk5ldvjs6wh7EzfAjpiPatW/Pc9O5U4Ufs8jpEqAqs4B/QujC9gW+860PArqfm80QQniQi9deer2eW4J+foJRtngVFrySJ7kotZeeGk9Ijf/kQ5ENZzYClxFhcVDsU8J8vh+C4VK2DISt9+cngHr8YVMbemempSSHqOmxNIlloIxrMquyMqFhT8lXXARZSkHCrPOm+tpz63PiE+Z5vGL99s1GpO671KK4ooOnsiB/lJ+gLlgX85GzmeOzPjeeqbVLPmwLBFSjPbGcsQyjqRPiclgus0ivXIZ7mRwr1vHi54OuCFAuKiAyDGLhGHmQJXTSwMb/UwQIvkE/b2d7Lf2aGgnsLaXxNIEKlMQH7WRHBx3SgzBRbtnFiSChw/PgKjv1r/Q1M4qCzuVkt6PR50cSlN2yZ8PqHgQHO/ZoEISiNrf1PBvROX2vCf51oE0x/EevgXHGQWPLEp0mLeEyMkY8tyIRneKR8lRWJkp4eXmOg8+2KcNUxpEVKJ3z2/CQPQ3PUUVR/L+8bHqjvfhs7DUZMfTboyTJE6MMKN3nJqRXJxIoNqXsKVltGS8YlOYEWphVwfdZJe1RDbIrwULMJ//yn1gtiRoMZAdL/x84iT3WlmUQSORoYs7jbrmz26aek9EMZBd3Z18gwWwEf0XQPovlJCpAVET0Q6CKNE48T3fnfyQ5s+nWmPS0CPTLGA8M4db1GIgYcpJdP1KhSxbROECfr7Mirw8bz+l0Jjc7nR1HHEotczQCXm4KxP4yBLOpSoCLxlj0lGjq8NO87QoOICGkyOVijAWIqTdi//BxE/8nAAa2xGsKoHxmkAd8hsadAGj2RMx2C5eCzs2D7mP1GRPAy9NSxgg23EJ090rl8aM2LbEtRxa/op+3jYGn0GZmxPJ8nRj8RHFEJJxBXNinTHqREO33RU0CYtz+qBQ6DZkozfavND59
 nk6y0KIC
 wxSBRqYIGQ7JOV/WiQe1f+BFvIipNl7hkXSytz5MHwoCLOocxrGhPLXzzS7L1Vb15579Bqz0l5xD7Sjt8G6kyKlQck44bzt+c/NlrXdl4LBxLR3eV0m8Tl4wyze8eYGjF6owUxWHnYBe0IlijvrytzoyguMHpQMw7Um/f3q2Dma55I+YcZ6+ktdbbG4EObLf41dFE3R0EHIUgZt2ZDosP8AL4Ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace deprecated kmap_atomic() with kmap_local_page().

Signed-off-by: Keke Ming <ming.jvle@gmail.com>
---
 arch/mips/kernel/uprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/uprobes.c b/arch/mips/kernel/uprobes.c
index 401b148f8917..05cfc320992b 100644
--- a/arch/mips/kernel/uprobes.c
+++ b/arch/mips/kernel/uprobes.c
@@ -214,11 +214,11 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 	unsigned long kaddr, kstart;
 
 	/* Initialize the slot */
-	kaddr = (unsigned long)kmap_atomic(page);
+	kaddr = (unsigned long)kmap_local_page(page);
 	kstart = kaddr + (vaddr & ~PAGE_MASK);
 	memcpy((void *)kstart, src, len);
 	flush_icache_range(kstart, kstart + len);
-	kunmap_atomic((void *)kaddr);
+	kunmap_local((void *)kaddr);
 }
 
 /**
-- 
2.43.0


