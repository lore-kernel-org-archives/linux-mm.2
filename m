Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C754EFD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27186B00D6; Wed, 25 Feb 2026 11:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FDF6B00D7; Wed, 25 Feb 2026 11:35:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60556B00D8; Wed, 25 Feb 2026 11:35:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6E86B00D6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:35:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A95014065B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:35:01 +0000 (UTC)
X-FDA: 84483528402.11.FEF0256
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 72E1980023
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hSl8g27E;
	spf=pass (imf30.hostedemail.com: domain of 3sSSfaQgKCMozqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3sSSfaQgKCMozqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/X71c0eq0chbAJtrestek7XlSR8mXWIyGEkHLGooRRo=;
	b=59DR5WKM50EAyjP1LKgkJAPg+TVrdqfvhENmWtQan7FVPMjU4ZGtNJVkwx4ISfBVGYIS9M
	nN6kqU05I4l2FTn33cqGCp3ZZAQN72eaowQ3RxLcutt9wKFvgpFSFtry/P2IJlmrgfetGp
	GbriwXyuhDZfBxfGqCYsxvnw/kETTZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037299; a=rsa-sha256;
	cv=none;
	b=KVy1NS6xB5KB0oCeE6fSXAAMdloHne1Q6UdN8dH6jmcNRA/TokpXRjvmlL0Q9wfihylG5o
	zHMq+yRw6YK804189KL9tTZi8qQZLrGmAxjnRag3iBd9CN241MbrKEINAmjnW53y74HyrL
	/eTayRrC3HYk+/OqWMsl2yUxyO1o9Cc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hSl8g27E;
	spf=pass (imf30.hostedemail.com: domain of 3sSSfaQgKCMozqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3sSSfaQgKCMozqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-65a507bcbe4so3450326a12.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037298; x=1772642098; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/X71c0eq0chbAJtrestek7XlSR8mXWIyGEkHLGooRRo=;
        b=hSl8g27EQkrDSdL4h2/1uJcnVlrjpjtWygXY4n5EqHx3GBMOHiQv5SEv5n0G+3pAFe
         ncdyEDNcYhk8IxpCtGVVPqVQVSWVbRDC9VqHCj+UKMKUpiNFqtH63AcQvdD1UdVJ2Xb1
         km04pfwSJnC+xfdSV1GUIeBojN0gR6k3g/G28L9Fz+H9gxJ4hyBHdT16W0a/p2BbqJrT
         B/ekSfy4j7VjCtwd03bTjicvlty3HyKbCu75vahPn0X4aczIeopce/JNcMyHNJzi9wLH
         pzcYPBYPY4g+E/CvwgmaIFjWIm8x2iET4cjk52a4CuHWlCnPulkkfDy22ftUVmygi7c+
         1eLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037298; x=1772642098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/X71c0eq0chbAJtrestek7XlSR8mXWIyGEkHLGooRRo=;
        b=DITY2TmSGIQW4EF1/4NkKafI7nuF+TBHoPxpg8KZaKx9FOKeiwrt9UweqvJSdTEsmO
         6D6UhKeRK48UUshiFbbTAFprQjrq0hk/Eb5WWnXVVmyI4zVcIEDKIyu//+XeZEn7zxml
         gm8bkfnJ/Ui3WWaYcgU2tJ2XCsSy4u4j94/E0gKiUpEZOUMip6ooU5y5ASmCIEzm9g+M
         Fr+BdJUrfWwm4ImhrM1/YW6pgfm8j5mLbd0cS3p1lCyPrGlKEOJdVdVNP1yeWZdzcdrA
         IReoXFS9DIcYebz+W8mzFUo1T737kvz/VMdRRs/ND/YOUN9dNiDFt5O2Z+tiLYYP3TyI
         nIYg==
X-Gm-Message-State: AOJu0YyMWM8C1MkSH/fdpBqLbuKbiFdWzOLy/PxH0zAY4Y2YUVS+0LDO
	UPcJDHS8o4A280kF16sk9ny4P5bHXql9LRrOqSOZAG38tUuOt0SxompVTbCoRh8xmOG0dpp47Km
	6FmtI0Xh7ZnoNsw==
X-Received: from edyr17.prod.google.com ([2002:aa7:cfd1:0:b0:654:503e:5179])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1e8a:b0:65c:3684:3294 with SMTP id 4fb4d7f45d1cf-65ea4ee919emr10937951a12.11.1772037297847;
 Wed, 25 Feb 2026 08:34:57 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:41 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-16-e8808a03cd66@google.com>
Subject: [PATCH RFC 16/19] mm/page_alloc: introduce ALLOC_NOBLOCK
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam09
X-Stat-Signature: is4haoat3ean5g43tner1utoymcx8nec
X-Rspamd-Queue-Id: 72E1980023
X-Rspam-User: 
X-HE-Tag: 1772037299-143961
X-HE-Meta: U2FsdGVkX19O5Ol689VCpVl/LEWD3kiiJJAOzFjni1VzCj/OXedcUNKEZrRULAXg93xa++jAsodL3bN+Cul8sZwkK0IZO4TLMsy8ryLlI0Rtwpz7JASB8kmIzZBzRhjLmBJOOtvR+9KQhzh3PpcUXSkWC258UeOl6GgOdTCbpLeP0hyPSVgLuK3hsXOrfrKD2OD3N7v1b9bqIh0ai6b7qUlzLOdZS05qxk9fBFTjiJ21GC/4MUe+NCnQXwYR34zI5I2w1ZikJhWh2p8QHbZMwiaSV41U2gbK4W6iqJbqX2oRn9lSFAYYlq0LknhrEH9SZDRq/1MOGyWtT7C/PnbIg+lwct+2a34jfAm2uMFcgs7tQiD8cVGJzv0Bff0cd0LQANvexxFe3+feg/Q6BKKJTLstSROFUejisfdZuqI6WRa6DGDSAZ9DxZrpNsMMfQS8CltBIXWpUhAu6gmNkHMDeRsuD39dg7uxjugSern630h3xdT8UmT3Tbq/8HY1wzdrB41IKmqSzNLyvgNXhWu8In2CVkhTkCJEpDKYpl7AEIxYHDqjtoH1L7j4eg6VGDvpEgS9uFYcZ1p1/cC35hrdbq10+eGlLpGzeKQhpc0D7UGdRX0JRH9rP6wjHomedBletrJZk6LTuR1/H9DLn5UJrfxBH9ZEE2f+3+Ud0/JUnulC5lSgG12Pc5cVxzjWgiP83gkG4jGhaQkf2JTS64Zqx2FsTtpeRDReGtKhc/Xl7oDlh111DoOOsLQ9K5qLpN3b6HUMg2sAUUgMsXQaSBBi9xRAMCY9xmo6Kkq61VWat844ftHtEN92gu6UfPwrfIkt2Bn726rY0k7BLNiDQzTgpLGyZrrovbhAC7ygzgiNRHH8N29VChmDlKBZnOFBTQaWrqI1elfpYGDwwM2mooUXd80ZxzqKtxkpmU0V2RONXcRSreEOcTamkjSDJeJAMIdoStQ7gVd3J1Mfl4su6RG
 S4r0du9C
 sR0Fo9+U1XcsOKbcvdjZrfJmqVwomuzhbaz/qfTqsgt9ejoV1IeE51XdGPUVqFUYyrAU8x2hq6O0OR+Ue8DsnW8pWImJZ9NfbeDx0ja4E5b6tB2HHlQ0adD6yPo3qA1fCFDTw+1jXFZFJVGRhMz/fQTj0AsHvh1DF8d/FZo8aWf4QxntQBSLYANJMTxhODJVHodbxCNtisLOXKHPBCls+k3ghzLfvTm9FLRaultfAVonjtdHtCJhuPyKempIMwQlyr+XaPuV8ccbN67WmUkyP3q9F5mab0noP4VJ761vjdrG1VlMLmATud1unGXu6bR5hcBp9Xr1aO8PQqwDFYpv2k0UIm7lORBPRe4oAIUp//qAu+L8ASpGtazBz672rloMHhwDHl+FF9q4UQAn0GUZ3a6GvOIM2NCf3kEF/LR/NF7cYVwWrBhHomgSj4kPCMJio0VQdjpkzepEslku7FeMP+NVVAlFd7IGFj2ff/2WXRpEdoztYaFc+/Ih0KGzD3AKANbF/+PYeZ8D8NN+Ef8dkYpNYzgzoWOozPHLwHmuKVc51wlK4k3TEFcQYb31zZeiLuIrD8HZed5qOxC9PJeKF7GHSpEYiFZAhixQMBj1WqtBrWb1VtCNl1vrt+wq1qpXFCZpTsBSzSg9MihJn13UAXdsXlLON+J2jWOpI2yHPNi8OlYdTUJ68NBxZNIcc8QH374oL
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
that it is not influenced by gfp_allowed_mask. This could change later,
though.

Call it ALLOC_NOBLOCK in order to try and mitigate confusion vs the
recently-removed ALLOC_NON_BLOCK, which meant something different.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   |  1 +
 mm/page_alloc.c | 29 ++++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 5be53d25c89b7..6f2eacf3d8f2c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1390,6 +1390,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+#define ALLOC_NOBLOCK	       0x1000 /* Caller may be atomic */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 42b807faca5fe..5576bd6a26b7b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4646,6 +4646,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
 
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
+		alloc_flags |= ALLOC_NOBLOCK;
+
 		/*
 		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
 		 * if it can't schedule.
@@ -4839,14 +4841,13 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
-						struct alloc_context *ac)
+		       struct alloc_context *ac, unsigned int alloc_flags)
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
 	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
-	unsigned int alloc_flags;
 	unsigned long did_some_progress;
 	enum compact_priority compact_priority;
 	enum compact_result compact_result;
@@ -4898,7 +4899,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
 	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
+	alloc_flags |= gfp_to_alloc_flags(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
@@ -5124,6 +5125,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+static inline unsigned int init_alloc_flags(gfp_t gfp_mask, unsigned int flags)
+{
+	/*
+	 * If the caller allowed __GFP_DIRECT_RECLAIM, they can't be atomic.
+	 * Note this is a separate determination from whether direct reclaim is
+	 * actually allowed, it must happen before applying gfp_allowed_mask.
+	 */
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
+		flags |= ALLOC_NOBLOCK;
+	return flags;
+}
+
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
 		struct alloc_context *ac, gfp_t *alloc_gfp,
@@ -5205,7 +5218,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct list_head *pcp_list;
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int alloc_flags = init_alloc_flags(gfp, ALLOC_WMARK_LOW);
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5346,7 +5359,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask)
 {
 	struct page *page;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int alloc_flags = init_alloc_flags(gfp, ALLOC_WMARK_LOW);
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
@@ -5391,7 +5404,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 */
 	ac.nodemask = nodemask;
 
-	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
+	page = __alloc_pages_slowpath(alloc_gfp, order, &ac, alloc_flags);
 
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
@@ -7911,11 +7924,13 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_TRYLOCK;
+	unsigned int alloc_flags = init_alloc_flags(alloc_gfp, ALLOC_TRYLOCK);
 	struct alloc_context ac = { };
 	struct page *page;
 
 	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
+	VM_WARN_ON_ONCE(!(alloc_flags & ALLOC_NOBLOCK));
+
 	/*
 	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
 	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current

-- 
2.51.2


