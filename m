Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC83C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761796B00AC; Sun, 26 Jul 2026 18:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712166B00AD; Sun, 26 Jul 2026 18:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DAA86B00AE; Sun, 26 Jul 2026 18:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 211CA6B00AC
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87529805B6
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:54 +0000 (UTC)
X-FDA: 85032356388.25.2A2D730
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf24.hostedemail.com (Postfix) with ESMTP id E555C180006
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Di/c7mSb";
	spf=pass (imf24.hostedemail.com: domain of 394hmaggKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=394hmaggKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwoLB2iOFwVZoH8Cy33gw5t1pZIEJdBAZWDo2kjEDd0=;
	b=DaNScV0qMySK15Q+eO0oUyQ9YvcsNAQ7yNwFN2ymj7ecGHl/0By8ydQ9pKMDlicYTWGRq2
	c02kKzfp823Xg9nsS829W6vpj3BLuE8ApQP9McgN6JnMhdFdnzago/8zI+sU8ldNvPmuEt
	m/DvWOCE0ddS4ehBZCsnm21NqBg0i2g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104632;
	b=qR5AwxoqAXc1wkj8f+6DNUBW5A81RxHeYMHKNSngpRT/yg0HXiaLhibL/668cvXjxo5Hkm
	BOnhCx1eLOrd8nQbIjQEXEbow3k3teymRTSZ0TwiFFIZCHOrqdccLwJ+SnGyM32ZhXAXMx
	dW6OkGC9zEL1jarTugIsensBTatAWdo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Di/c7mSb";
	spf=pass (imf24.hostedemail.com: domain of 394hmaggKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=394hmaggKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a767b782so15251935e9.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104632; x=1785709432; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cwoLB2iOFwVZoH8Cy33gw5t1pZIEJdBAZWDo2kjEDd0=;
        b=Di/c7mSbbQu2GPS+nnHM3DenaWDzWEPmiVgqkKOtqCEKPlZrR4jHIP56RFiUIoZPry
         SsYLY516hzd22YdAVMjeKWmby/t/SYisCdMvozTC2bgsuyXWf/Nz0yWnMGCScYYX3ybY
         4lUUMMyPQFl3rmFQ/kD4TZc6BnPT5C4Urpu9cYPA/Ws9Z731LtlC7Nksem/O18SkApdm
         c8tFYU2+PFOMWqEaxsPLZQFxatxwvFkw5NC5fuffFnb5K2Q/U7fTwhOFA28PhX2lV8kW
         ERGNeNba3OCC40fvVBwdLF6vzS+nriYTrQ4vEGuTU825vuK4K0KsoP6GXUeaLaOTSuR5
         Bjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104632; x=1785709432;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cwoLB2iOFwVZoH8Cy33gw5t1pZIEJdBAZWDo2kjEDd0=;
        b=LGiYvkh1RGRixsfRXTtGrtxgxmLMJTQuykQ7ze79wLh3MsDzpe3ULarXVSBSkC3A6k
         i11hHxxL/8dqBjoA21hK1nZMzjXAIrFlDkDbyK9fCYrNDM70H3T/a4+j2csohmJqzet+
         sjyDH6GaRG9MXSz9EHxyRYMkSt02VJpP/YRN7XwSU5ovu6QssstbYUcTii0UhXLjcsmG
         csGzWW7Bet0pmzNQDoLVBHws5QgM2Wr8PNMTM1hXLcv34gpUhLYsWdbjTLyF7Rftn2Yp
         HFE9LyBFBOVqPQosQscc2L4hFJQucI5tKUOE+0gjIT9mqR7Ng+OflinR3iqYGhsYBSha
         jaLQ==
X-Gm-Message-State: AOJu0YyHHwqX4zFwLAcqux9ik+QzZXyqiJieXb3preL+UWz3SzE0vk7t
	7Buz/PionJnafG1pQNGbeoycxDs39F8PaRE8yAskquqsXU8Hs1gTQqsdjakTKESNNZ2TYYp8tVO
	ZqFqlrGpZVG0C4w==
X-Received: from wmox16.prod.google.com ([2002:a05:600c:1790:b0:495:4d5f:df26])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6986:b0:495:4dea:f7f5 with SMTP id 5b1f17b1804b1-496b5726cccmr92611625e9.29.1785104631662;
 Sun, 26 Jul 2026 15:23:51 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:53 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-20-6f5729aa9832@google.com>
Subject: [PATCH v3 20/26] mm/page_alloc: introduce ALLOC_NOBLOCK
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E555C180006
X-Stat-Signature: k5jn4ubsmw7536igpfok63c7qyjynyg5
X-Rspam-User: 
X-HE-Tag: 1785104632-311139
X-HE-Meta: U2FsdGVkX1/fI86YILP4zx/T4m5Fc3igCk9Lv0d60f8oz4EpCnwweuu8r3v9+QUVy9j0pN4Sv253kxiejkJiX/CBT33QB6mstILHCcBWoiSdfgZn8dHywSuERzumNjq6F58BczGaLiz198osi0tDdl1dGEfpZkBd81CDgKZt/Dk0t+T8gX56WyVnciwZuzlUmHEwGMFjCFqOSRtxqLl3AuDnuK7AL0LJKhJezbrkdSpErFaBDC16njrfeh2xKxrSlS7YQyMDPENbpHUBjxN7wRCxgRCzKzyauHQcPUj3k5JL7ktN4kyVXXxqRZMIFQ38OjHvUifiQoqoB9aNsE9N9Vr/uMDjBnnN9K5OfOoOdjqCtwYQRuICVzdL235Uxb2nCedlX7gijxbD8UgDV1dmiiogtcy5TASXzTk4/PhCZbjDasd6Ob+E3t5kkl3/NuHR0HSbwTmiLBu3OvDEOJ7Z/WbEDMSd99OGJnEM+pqqKmt5u+L6J5CEF0Ua0y37Uy7zdQhlN8ie8hYvS0k8fm26hbRISgCCB6MAlRkIXUraBcP5vaadPxwPuEPs+g7HwZEtg/6ZtGxp/TpbxlaOEZ7paNM2oSD65fzDzBZk9hmx1iQbz1KyUKvmE3psfX7Fe/tRR/jNX1xOROYFBw3KCCIh7FPMZvFdPdMFuLJ+yGWyU6iWDiAPnsdTL0wrHJfUCT+P4FqPkw5CEQ2gsoDWRG0Al+tMZWjUJC1XObg2jl8wfwZjhJQBHdME4AeXUY+tDzQEEE/Z/Gl42ytQQbXqug7uJCVFEOqX1k7wswAsfaxmOTqhMUOqc1Op8toLAhCYBkf/4iP8G9rjstPnIxG8/ofXEc5G/qcndRM5JGaQkpXSwKRBRakqMU2K1Vtjx76hBOCrzHSAalzrvCIhqy80YAma3egYUnnhY5z2vtn2osCANuXDniQHVIurNL6vZNmcxD9tpImMfGEMnr/EP7HtdvF
 96S9VFF5
 7fx+FU065zV5royRAcUbONy6sd1zCD1cBDxEz/NDsaMf0A5t4sayzJDOCvsfijzdiRvlav0GDi63qkjnKqPIaACb11JP1hUWv77AqhfpqIzT9Et3Ql3z5CoxON2M/BT6OmT/6KS7ryzSB0NndG/a3UfJFuXq/9zZ38Son6AzRNZ7LcaqRUOxo6pI0PXZPTA/2G3vkGKzKnfuDrI0gNdXJ2zab8W+e4I+4dtZPffTkRT9ybxxijdnHjmr3DPur1/OtYTN9tX6m9C+iS3ZIN9VjkZRszNybw0NoxklNZe7GzA825FlNVJA1iaAc0CptUoWzaRphOc44rL+HGDkzVoxdyTeTxCJOVSx39r2+tX+UrWi6ViOW9d7yvz1NO4+4gSjJXsnhPQ0/TvuUIwAT+RQroocA6+vHcxaYV8ygcScobGXgbyRnwZ5iyf9EP+dzsl84zXup0fQ6Uyfm+VddplywjtkrbHYrzLZZLDKXbX5BC5GISiRYWx7JjVOCLsdCGYqm9sreTFgllSvpoVIQPtaews1WMysYtCRnzz9KUwjc7meYy74oT3h/5Pe8ccf6hgCDdiTsxw8qOGlvYR30XGncEikXqPp4S9hqJY+ukbMtQoLK3c4bkLBuQQd/pjY0t74aqOfeoUvFhbWPh4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This flag is set unless we can be sure the caller isn't in an atomic
context.

The allocator will soon start needing to call set_direct_map_* APIs
which cannot be called with IRQs off. It will need to do this even
before direct reclaim is possible.

Despite the fact that, in principle, ALLOC_NOBLOCK is distinct from
__GFP_DIRECT_RECLAIM, in order to avoid introducing a GFP flag, just
infer the former based on whether the caller set the latter. This means
that, in practice, ALLOC_NOBLOCK is just !__GFP_DIRECT_RECLAIM, except
that it is not influenced by gfp_allowed_mask. This requires some rather
ugly plumbing to get it into the slowpath without clobbering it.

Call it ALLOC_NOBLOCK in order to try and mitigate confusion vs the
recently-removed ALLOC_NON_BLOCK, which meant something different.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 23 +++++++++++++++++++----
 mm/page_alloc.h |  1 +
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fb522a09f2e60..ecdd3780192e8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5286,6 +5286,19 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+/* Set alloc flags before applying gfp_allowed_mask. */
+static inline unsigned int init_alloc_flags(gfp_t gfp_mask, unsigned int alloc_flags)
+{
+	/*
+	 * If the caller allowed __GFP_DIRECT_RECLAIM, they can't be atomic.
+	 * Note this is a separate determination from whether direct reclaim is
+	 * actually allowed, it must happen before applying gfp_allowed_mask.
+	 */
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
+		alloc_flags |= ALLOC_NOBLOCK;
+	return alloc_flags;
+}
+
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
 		struct alloc_context *ac, gfp_t *alloc_gfp,
@@ -5364,8 +5377,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
-	struct alloc_context ac;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	struct alloc_context ac = {
+		.alloc_flags = init_alloc_flags(gfp, ALLOC_DEFAULT),
+	};
+	unsigned int alloc_flags = ac.alloc_flags | ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5584,9 +5599,9 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	struct page *page;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = {
-		.alloc_flags = alloc_flags,
+		.alloc_flags = init_alloc_flags(gfp, alloc_flags),
 	};
-	unsigned int fastpath_alloc_flags = alloc_flags;
+	unsigned int fastpath_alloc_flags = ac.alloc_flags;
 
 	/* Other flags could be supported later if needed. */
 	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 2307b173a459f..02db12c9a1dc2 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -75,6 +75,7 @@
  */
 #define ALLOC_UNMAPPED	       0x2000
 #endif
+#define ALLOC_NOBLOCK	       0x4000 /* Caller may be atomic */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)

-- 
2.54.0


