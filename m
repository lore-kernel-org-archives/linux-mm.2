Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DB3DCAC5B1
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F928E001C; Wed, 24 Sep 2025 11:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17958E0012; Wed, 24 Sep 2025 11:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF558E001C; Wed, 24 Sep 2025 11:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6128E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 622521608CA
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:27 +0000 (UTC)
X-FDA: 83924454894.03.7AA9077
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E7B818000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kVBl24VI;
	spf=pass (imf16.hostedemail.com: domain of 3hwfUaAgKCDQZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3hwfUaAgKCDQZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41pQw++XrTQuPmXHdjyzKZvwkMfko68cyk5qRol2Kg0=;
	b=LHzuuZvPkKVnTOk92DKq2vlwMT0AMgNA/qr+bjK+a7Ix+J5wMYtwbQel7VKULt3ezzuZ9R
	6ZdqzSzit1Frjc8bNtDEFexJ45NeQI2R1csRvxtp0ElU7vIsQq4UaHioNovyUdF1KjdTme
	Gsfr8zIAT8FfBMMfKqD5yngXBEnKZY8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726025; a=rsa-sha256;
	cv=none;
	b=GVkj94+ae+hj7iTmEMrnhpJpaJVlufGQO99/0S4Df9FF3sgQ3NS9RIadJ6xEWzwyt7WjNA
	gkJwEHzAvuUxyQHpFWSQbXN273Sije9tYe7AUaLIkcSoBtRql3d8jURmrJkdYoYEYGvv37
	ETxHodmmeYW4t4BIl42wz9r1ZYGlZ3s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kVBl24VI;
	spf=pass (imf16.hostedemail.com: domain of 3hwfUaAgKCDQZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3hwfUaAgKCDQZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-40657e09e85so826671f8f.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726024; x=1759330824; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=41pQw++XrTQuPmXHdjyzKZvwkMfko68cyk5qRol2Kg0=;
        b=kVBl24VIjAEK7b1cdp7aJPTb8WcZspb7UoM02JtuBSuHsbornMPHFVlQWBuxFWf6OW
         MDPaFUcgJAsptUC5CGstnoeCDNUYs7ddqp/4h1AGCwlua+Ys5z02aYNgvtCWtb1F9dJ1
         oXkmn5c4fHIn3gc0iAirHlV1FnlGvtHoO/QFZlloFPKo+vcoaGVSKywiu7mZI1uHYuIZ
         1ljzySWyrnk2UlMs8GpEpARSQSn1FeeZCVsSZB+h9d5NdWIr3cEZXxD5j+x7C+gjJSX0
         g8gotfTrMlZiyz1Qgj7UWdeDuKbdLaSpjabgPIfER1qLb54UosWNw7PcFAqU124pZUcv
         2R/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726024; x=1759330824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=41pQw++XrTQuPmXHdjyzKZvwkMfko68cyk5qRol2Kg0=;
        b=vwC9gbd7UlG24R9UOSeJYreAnHSHNF8Oc7xLlV/zyOPeLxugD4t51cdC/nKEgmdk/s
         IRb8UNLuOc7UF9+zbjqEdmlTtbpT1dQErBVffcftfQf56CpIGzenXpwIZ/H2BIFfsF5b
         Q0fwQ7gscsHyA85LEjDBG5LtEtGIidzfm8yXN30Y+p53LXigc4fiJEcxhVlWruxv6TFm
         exh8ceoSAyxPv+MGOs0nTsHfcbOCYcHa7dWlNUclJkICx/u89ggL9Kkry9WEJOLHwB5p
         DeRqMh2t51AG+2Uekau1qr4UMJ2vTvBCZ8LHF6A951+/izCZ8OIVfw8PNWNUCC6rC5sQ
         EKmw==
X-Forwarded-Encrypted: i=1; AJvYcCUUC9n0ceBGhitU2VrszXzosyZpwfU6lrjg7whGB9giNbqOJbsNfLYUxiwX94uU/k5uc7lZiu5YYw==@kvack.org
X-Gm-Message-State: AOJu0YwmtSdaMRUx8ktDAUpQW0/JZaQZr1nTWVpQxiGIWYqgFEvUYwdN
	Nfh0wXLsVHXm5xa7Vi3yh4/3v19h4R0pQH4LazyE+K5mVUIDN5sAXfZPAhoHsy/1eunlz45ouLT
	Hd3+SwJ/CMW3GwA==
X-Google-Smtp-Source: AGHT+IHkwdtdIH8CI6uyF/rnsDuP+ou/4VjkKWWzkjAqCtb5L9y32bbpEud8KTzQ+39EVfVnPp60ULCATUlEug==
X-Received: from wrbl12.prod.google.com ([2002:adf:a38c:0:b0:3ec:a590:990])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4210:b0:3e4:5717:368e with SMTP id ffacd0b85a97d-40e498b7705mr228614f8f.2.1758726023909;
 Wed, 24 Sep 2025 08:00:23 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:51 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-16-2d861768041f@google.com>
Subject: [PATCH 16/21] mm/page_alloc: introduce ALLOC_NOBLOCK
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
X-Stat-Signature: tiatpegjzjau7777rhnbyo95b7u6rxwb
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E7B818000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758726025-450414
X-HE-Meta: U2FsdGVkX19yNOeXf/x0DtOUgW/asza1rKSCTc651eMgzdgg9ti/EaqUs1N4fh1dIkRgwnaoCf/f0yGhxIZJONp6MXdedvroTPTqriIToq/Iyq/CV66je6rds8DH8BDYPOGiRE7jwxOtd4OE0MUgtiT5+dHjRzv5NDdedPnUec13MNsT/3UOCYDK9WlQS7NSXsXONBqAMARWmqcz4K1Ud3xBBwzLVZjtslkb32tfqmuIK84XvCs/AUwqYssGs/bD8rsf5tilGzYB4tZDgrutPNRXeRCKunYl2G4hl8OVtjATcSGDzWWNwVPF62dfnthyMXopksCjNEb+1NwbVStt+4Vu+8WxJI/vmiLXZMXKRdgpOVRcx5Ztx3fpWW3GHr9uuf1TYjuMYr8mKE0ZBZLfBaa4vczHbL6tUKq2xP46zqRfJectIlccF4cQKOlMzpXeucz4NMrDEXgpcEmClxl7d59QmhnUiVR4Vyq9Fq7roLXhhu1eHHE0NYLiA/4hDYyy1f/GydqtnAfg1mYgYKfZ690tv6OjK0BbXFG9RWMsI/dHlLTDwGhfm9XM1Xngo+y6PbHr4HvrnAuR8zwDeWx6N3sSH+DYa0w8eWiTSGjb1E4IfY7IHgq2fUAy8YUkTa7ksAag/IMel6EREjvSDdGCF5u+5UUVEV08biMcjezRGmKYFyqHsqupCnMX8cVtdCJ4XAKLovoOrKydZe6ybIh61I9pVU4Q5AaI6NuTzBYqa2AKya7XoSAEMcLNmlgkar8c3Fq54R73INkewUJmb2Qo1g4awCqq0XJVfNfmcWKh5mpooNVdy1OboaYSu68QKRlQbmBlQNbEaHl9Nqj/PcsDWI4x8oWuH72I3quzxKokZysOehHJbRn48gwfEUXc9i1bsVE2muVi+VuY/RSavpQ9OwnBJ20ktA1oo4Cf8kLPor0wkJNNF/usY8m3kXhNpGaOJo41a0l9GrPW4sFzbrq
 31R1wkU0
 hx1O7b4FsRjDeaHd8RtGdfppEdfGJlT6jugsgGOX0jWZQLL689jsLVVNo2KWloT5TOYR9rpr4vs3h3xWIwcstCOP/o6ZN2HCyLxpy3DYLLHrYrZyhCH3MiJRfXx54rMDGC3kFVM/u3scMKZBn+BdjfySgX6BLSsUwR/1sBZbRx4u17qgymMzJ3hz2BjqlT14J2FAy50ZnbQooxy0qiCeWKxtWNZCTCIAGJgHMDxUj11XhraUmTdIQltpW61gXelUbABXhhO7T6rz1UqepT87owl6IAkcQmseni8/QoRImWNbas2zNxU7IuviWSLW7jHT1GrVJNMhbOzAB9GVUzdhCZg9fRpb1tw1IEofxlJo+LXIGPU9BOmnWQvyAkt8hCMBptln6V3ezmQAxo/9J2gvqEOlu/GxRCHxdRiWTsDRYjskUioJLomCTxW6dwhuFy9A3TMNbTM4kMhbKfoRBuOnmFqtp226ry77xKcmD8ZlDUW0RanB08c/pcCcq4VX0+WngX2SQHkeUxLDecEFcUfuZbbjQ8x/5NjBdN+OCfqnkI8E3gjbYM91atBkIHWr2FJVX8CqqXVvdoTi4rRy5WGOMNfqweEEOMc1Ignq82c72m0IPwCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
that it is not influenced by gfp_allowed_mask.

Call it ALLOC_NOBLOCK in order to try and mitigate confusion vs the
recently-removed ALLOC_NON_BLOCK, which meant something different.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   |  1 +
 mm/page_alloc.c | 29 ++++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 513aba6c00bed813c9e38464aec5a15e65edaa58..c697ed35a8ca3376445d1e4249e9ce03097f15b8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1315,6 +1315,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+#define ALLOC_NOBLOCK	       0x1000 /* Caller may be atomic */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cd47cfaae820ce696d2e6e0c47436e00d3feef60..b0aeb97baa13af038fff0edae33affbbf49e825c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4552,6 +4552,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
 
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
+		alloc_flags |= ALLOC_NOBLOCK;
+
 		/*
 		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
 		 * if it can't schedule.
@@ -4745,14 +4747,13 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
-						struct alloc_context *ac)
+		       struct alloc_context *ac, unsigned int alloc_flags)
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
 	bool can_compact = gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
-	unsigned int alloc_flags;
 	unsigned long did_some_progress;
 	enum compact_priority compact_priority;
 	enum compact_result compact_result;
@@ -4795,7 +4796,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
 	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
+	alloc_flags |= gfp_to_alloc_flags(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
@@ -5045,6 +5046,19 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+static inline unsigned int init_alloc_flags(gfp_t gfp_mask, unsigned int flags)
+{
+	/*
+	 * If the caller allowed __GFP_DIRECT_RECLAIM, they can't be atomic.
+	 * Note this is a separate determination from whether direct
+	 * reclaim is actually allowed, it must happen before applying
+	 * gfp_allowed_mask.
+	 */
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
+		flags |= ALLOC_NOBLOCK;
+	return flags;
+}
+
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
 		struct alloc_context *ac, gfp_t *alloc_gfp,
@@ -5121,7 +5135,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct list_head *pcp_list;
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int alloc_flags = init_alloc_flags(gfp, ALLOC_WMARK_LOW);
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5267,7 +5281,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask)
 {
 	struct page *page;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int alloc_flags = init_alloc_flags(gfp, ALLOC_WMARK_LOW);
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
@@ -5319,7 +5333,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 */
 	ac.nodemask = nodemask;
 
-	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
+	page = __alloc_pages_slowpath(alloc_gfp, order, &ac, alloc_flags);
 
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
@@ -7684,10 +7698,11 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_TRYLOCK;
+	unsigned int alloc_flags = init_alloc_flags(gfp_flags, ALLOC_TRYLOCK);
 	struct alloc_context ac = { };
 	struct page *page;
 
+	VM_WARN_ON_ONCE(!(alloc_flags & ALLOC_NOBLOCK));
 	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
 	/*
 	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is

-- 
2.50.1


