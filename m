Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E04ACAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0598E0011; Wed, 24 Sep 2025 11:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179AF8E000F; Wed, 24 Sep 2025 11:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090368E0011; Wed, 24 Sep 2025 11:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EBE668E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC93013BD70
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:14 +0000 (UTC)
X-FDA: 83924454348.22.B56C71F
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id C722540009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X0bwWUUu;
	spf=pass (imf17.hostedemail.com: domain of 3ewfUaAgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3ewfUaAgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lMKL0dag2cTvl5zrGDAXdNMfc9wzwq11ZbZ3BSylYk=;
	b=ifjoC7KoyjcG5TW9dBVrHNa4vqN2mY+x+93eD4ROR7XsygRIwbmJIWvadGptIS3FXwWrGm
	0QyVsfhcWVVkWsfq8Bz75benLrBdzlNmwKHQn9rD2ltQyOGDCCXuzLMhf2ZXIQhXF7Njk3
	ljZrWbfMY1CpQeiudoYOZ+jnYpmc3uo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X0bwWUUu;
	spf=pass (imf17.hostedemail.com: domain of 3ewfUaAgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3ewfUaAgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726012; a=rsa-sha256;
	cv=none;
	b=Iu49Xc5StE3tLMjWH3QeDjlu2DEnJE7ePdqmjUPCUl0g8ntCbRuwXrbViRRQ7XTdkE/KWQ
	sGfgigz4pF2VzBKAggw609U91S7qTBgW3MpH/mHB2wminePD4rKzN/q597ZL7OzjYnCwc4
	T2QFXHWTZaGI7/bHnspjLcj95QZoKRY=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-62fce1f3fa8so4716648a12.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726011; x=1759330811; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4lMKL0dag2cTvl5zrGDAXdNMfc9wzwq11ZbZ3BSylYk=;
        b=X0bwWUUu0Yn5hTR6gb1RH7Iigj4lwTKlRJ46HDaO3xwshBNkmtEFYwVoG24kz1uIVc
         Isbuo0dKA4YnewJzXQW+UGLTNuc4Vsa5EAErDsgPDK6HNRi+94J8SWEZdwoufiRNac36
         UCCS4I9Q88ZYMIv1NiKDDQu2qVz9chZ/GqcyHT1P2KEWSEYxZQGA8GmGki3pcqPu1k3G
         q4x25ADNIUDBLwVxkHVoiF+LArkpPRIgfuAziqI35AqsbVQ1Yv/pAiW0lgWe+5bdS/lR
         Ba6vLtruECo6SVHbbkLqN6Ov73pHf7OV88wpOhvdc0qjy4NJUFN5gvzS6cKbLE/uY22W
         L+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726011; x=1759330811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4lMKL0dag2cTvl5zrGDAXdNMfc9wzwq11ZbZ3BSylYk=;
        b=tcLWTmwIYnwW2pMH44PZHx8E5mmLOR9u6SIQLtsCi59hdAZf4tywlRhrCSimETcMHD
         rL6rYw+p1BQbvNBfJvDEaUETF4qVAiweIKmAEpznxU84CNtvBym8geCvsAa3sp6JqDgc
         ybGn6sB9sMuqkgSm/2BHUAaUoIiH2+Q0w/CoknkYOZSLlmkFPCUbGvUSVlRaVTEicQBm
         kX2rgd6y/mA23VZ9Yco2RlFR8QkX4uoVJbmG/3NchMgB8geuJ5DJN+4wF6OkvjSZHbKR
         XWdG96UhgksEUqHTDCOaLYGgvZsL2WZfdCjrrY2XXyvNo0Rc99VIcylO3yURWrdxmMGy
         1gUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYiFMKQzWhM6V/VPblBQNOG41gWAID+Xhqn/xDpufaLxAJ4M2u5+sYHp3OhAuFU8nkQ53xyZ+n/g==@kvack.org
X-Gm-Message-State: AOJu0YwwYOJhnmngyU0foo6xDjU+H/tKH+O3ZeudPTh78AEDMz7FyU3/
	Z9DdOWK+bVYO7QklqaaESSbVV9clsRuo51oOooedXSa4NsP/eFTMEU2HMjEgEl4jESf9FVJ1KgB
	fbQ+YQrYe+9e1KQ==
X-Google-Smtp-Source: AGHT+IFVSQFxUV/mTSePnmrlINV4I944f6eUP8KCpi3pssIRknrIWSkYfW/GfKVJFIh3a3hgc0TE+MDy6SWe2w==
X-Received: from edbm26.prod.google.com ([2002:a50:999a:0:b0:634:9b3d:9588])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1d24:b0:634:5722:cc3f with SMTP id 4fb4d7f45d1cf-6346779876dmr4825674a12.16.1758726011350;
 Wed, 24 Sep 2025 08:00:11 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:39 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-4-2d861768041f@google.com>
Subject: [PATCH 04/21] x86/mm/asi: set up asi_nonsensitive_pgd
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: C722540009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: oi3s54a61etr5bwo551axhieapc3gp4i
X-HE-Tag: 1758726012-536767
X-HE-Meta: U2FsdGVkX19eUE9uV4HU2VwNG8hx4FwF09K3Y4w9GAsg+gRGQh8ZPGn3S4qnTxTTthzPiu62Wd3CRXD+NyalBubnFApGqSkZrupiRPM2GETsbNsEQX5/8bF6uI96QYY0SEtwPYRhpJmzG2R1CNCYhanQOp/mn+kf30OQvQM4VM0yuJnIeYQ039qmhoCfHB/mZ4OJdwhPCFdbrdw/UNJJW9jeS7QOmXqtfBiif5kHs3jUCg3ibT1TdPFwSHD+XfS/QQvkEx3VLBqYdsdTsw0Oc9IEDkzgy8kU3L9voy6xPCXSvMXscZi0ceaBg3YjiHAe7QtMG27fRxcwSUvv0aQayas2PUwjhhmI6Xkhy9ciQ3/rl8KeS2zQtlugim2bXY2RNRVKtHUi7zsueSfDGrA4nHAU8xj8jcfV4ZmfGypViiDwuZOKiFx+4AZyOWtN6ymz0tpbDm4O0J6H4LRO1N7zRCanrop/lsisMfWM7ypgLvNuVJyUGmYPu/tmGATmYV9NnwPq6THJTd9sCF58p0leIZ0d3y0atmR2S3wRRRfcWM21q3gY32Ctgnf+/XuMDXYyJ5/CDXbVELJKyyRuPGYnNeSVK1ytqrnw85d4h3KUsoWkh+AWLUdnSK0GMsku87/uzb3t6B8AkVvffYJMPAfn5LeeX9jMffwb59vWVcQWho/h0ZijH88JlvNhq/hL4NNt2OUOuNHfrBHWueaxzXJzbZOzmcfmvCfAcNKf9Zz4xu6GMHi215tcRND+F5S+A2EpPd8u2y7OD873V7oAzKnB9U539G/vF9i6iugNbtIR9O9dfieY37v10qjp34gDqBIRQ/r6QnFLtIWeoG5UTN+DtCi4SxEpeCRibzWPCUQoY4s7mICSh+KtJpzMJZww4k6ToV73kyBNA3puy8imS3zxeSJN3jT+xN51m23eiGTjVrLHo1xSWX6TXv6ENGzxlGP7BODoo2kbxdCV978pVAY
 RXQ6UNRZ
 OB83/5d6J1jQPHFMzC27TB2ph7Iy1ZKmdXWpTe1Ijx9/ofIkGrVNu8rRNJPL9ZqwAYsFjIO9GMeuyQInu5W9XbM+EhD8ZHUcBMc2SLssLsG8Q/qx4ipT3y97SkmclDJ5c0pk6bn5fILdWRSj9sBd1jbcRx7hwALsY4LP5x6BuklwkxdEzttADUHmfqYTzC0S4qfs47xRGvhHsOkUnK8oupUWmNPIHvx2tJP7Vm4RhuXovW4JC4BTJWCeuvyKDROHI71iS0+R7A6GbtqO1E19Knl/tgCNT4ACiFlRXNRRoCsLnJpQv3qGynYi5AEIcRvPFTUXH8xniK9mNv0GUBDcDdLvXffmD6eQAJZq6s3JwTheLum1ny4v4EGxqVHUNMHCs+KxSBgSQsWQiii1ggoQHJY437TwDXSctkNvUXkd8PuxBowR9Mx6mhFDlEjTDEuWZpHoEsxNx0gCSWtqN3Z3ewFai0APqncc3MpYPEE2G7DoBKID3mELOkm3RLb5OMvKYNWxd6yeDxPfuKTp7dFRTgY+F+G2dKphxLM3g1P/rVX+M5Er+GbaaEFiXYEcn541cDJfTzESc4IsD3GUtxIWknBc+gJqi0aGzRwdD9qq00/EO7vwHJv5HIH63wqhXIKVP71S3u9eib4s7M30=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create the initial shared pagetable to hold all the mappings that will
be shared among ASI domains.

Mirror the physmap into the ASI pagetables, but with a maximum
granularity that's guaranteed to allow changing pageblock sensitivity
without having to allocate pagetables, and with everything as
non-present.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/asi.h |  4 ++++
 arch/x86/mm/asi.c          | 19 +++++++++++++++++++
 arch/x86/mm/init.c         |  2 ++
 arch/x86/mm/init_64.c      | 25 +++++++++++++++++++++++--
 include/linux/asi.h        |  4 ++++
 init/main.c                |  1 +
 6 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 32a4c04c4be0f6f425c7cbcff4c58f1827a4b4c4..85062f2a23e127c736a92bb0d49e54f6fdcc2a5b 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -12,4 +12,8 @@ static inline bool asi_enabled_static(void)
 	return cpu_feature_enabled(X86_FEATURE_ASI);
 }
 
+void asi_init(void);
+
+extern pgd_t *asi_nonsensitive_pgd;
+
 #endif /* _ASM_X86_ASI_H */
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 8c907f3c84f43f66e412ecbfa99e67390d31a66f..7225f6aec936eedf98cd263d791dd62263d62575 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -1,11 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/asi.h>
 #include <linux/init.h>
+#include <linux/memblock.h>
 #include <linux/string.h>
 
 #include <asm/cmdline.h>
 #include <asm/cpufeature.h>
 
+#include "mm_internal.h"
+
+/*
+ * This is a bit like init_mm.pgd, it holds mappings shared among all ASI
+ * domains.
+ */
+pgd_t *asi_nonsensitive_pgd;
+
 void __init asi_check_boottime_disable(void)
 {
 	bool enabled = false;
@@ -26,3 +35,13 @@ void __init asi_check_boottime_disable(void)
 	if (enabled)
 		setup_force_cpu_cap(X86_FEATURE_ASI);
 }
+
+void __init asi_init(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_ASI))
+		return;
+
+	asi_nonsensitive_pgd = alloc_low_page();
+	if (WARN_ON(!asi_nonsensitive_pgd))
+		setup_clear_cpu_cap(X86_FEATURE_ASI);
+}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index b877a41fc291284eb271ebe764a52730d51da3fc..8fd34475af7ccd49d0124e13a87342d3bfef3e05 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -773,6 +773,8 @@ void __init init_mem_mapping(void)
 	end = max_low_pfn << PAGE_SHIFT;
 #endif
 
+	asi_init();
+
 	/* the ISA range is always mapped regardless of memory holes */
 	init_memory_mapping(0, ISA_END_ADDRESS, PAGE_KERNEL);
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e98e85cf15f42db669696ba8195d8fc633351b26..7e0471d46767c63ceade479ae0d1bf738f14904a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -7,6 +7,7 @@
  *  Copyright (C) 2002,2003 Andi Kleen <ak@suse.de>
  */
 
+#include <linux/asi.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
@@ -746,7 +747,8 @@ phys_pgd_init(pgd_t *pgd_page, unsigned long paddr_start, unsigned long paddr_en
 {
 	unsigned long vaddr, vaddr_start, vaddr_end, vaddr_next, paddr_last;
 
-	*pgd_changed = false;
+	if (pgd_changed)
+		*pgd_changed = false;
 
 	paddr_last = paddr_end;
 	vaddr = (unsigned long)__va(paddr_start);
@@ -780,7 +782,8 @@ phys_pgd_init(pgd_t *pgd_page, unsigned long paddr_start, unsigned long paddr_en
 					  (pud_t *) p4d, init);
 
 		spin_unlock(&init_mm.page_table_lock);
-		*pgd_changed = true;
+		if (pgd_changed)
+			*pgd_changed = true;
 	}
 
 	return paddr_last;
@@ -797,6 +800,24 @@ __kernel_physical_mapping_init(unsigned long paddr_start,
 
 	paddr_last = phys_pgd_init(init_mm.pgd, paddr_start, paddr_end, page_size_mask,
 				   prot, init, &pgd_changed);
+
+	/*
+	 * Set up ASI's unrestricted physmap. This needs to mapped at minimum 2M
+	 * size so that regions can be mapped and unmapped at pageblock
+	 * granularity without requiring allocations.
+	 */
+	if (asi_nonsensitive_pgd) {
+		/*
+		 * Since most memory is expected to end up sensitive, start with
+		 * everything unmapped in this pagetable.
+		 */
+		pgprot_t prot_np = __pgprot(pgprot_val(prot) & ~_PAGE_PRESENT);
+
+		VM_BUG_ON((PAGE_SHIFT + pageblock_order) < page_level_shift(PG_LEVEL_2M));
+		phys_pgd_init(asi_nonsensitive_pgd, paddr_start, paddr_end, 1 << PG_LEVEL_2M,
+			      prot_np, init, NULL);
+	}
+
 	if (pgd_changed)
 		sync_global_pgds((unsigned long)__va(paddr_start),
 				 (unsigned long)__va(paddr_end) - 1);
diff --git a/include/linux/asi.h b/include/linux/asi.h
index 1832feb1b14d63f05bbfa3f87dd07753338ed70b..cc4bc957274dbf92ce5bf6185a418d0a8d1b7748 100644
--- a/include/linux/asi.h
+++ b/include/linux/asi.h
@@ -11,5 +11,9 @@
 static inline void asi_check_boottime_disable(void) { }
 static inline bool asi_enabled_static(void) { return false; }
 
+#define asi_nonsensitive_pgd NULL
+
+static inline void asi_init(void) { };
+
 #endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
 #endif /* _INCLUDE_ASI_H */
diff --git a/init/main.c b/init/main.c
index 07a3116811c5d72cbab48410493b3d0f89d1f1b2..0ec230ba123613c89c4dfbede27e0441207b2f88 100644
--- a/init/main.c
+++ b/init/main.c
@@ -12,6 +12,7 @@
 
 #define DEBUG		/* Enable initcall_debug */
 
+#include <linux/asi.h>
 #include <linux/types.h>
 #include <linux/export.h>
 #include <linux/extable.h>

-- 
2.50.1


