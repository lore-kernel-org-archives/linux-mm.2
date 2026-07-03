Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0CFDC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10E36B00BE; Fri,  3 Jul 2026 08:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74826B00C0; Fri,  3 Jul 2026 08:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C036B00C1; Fri,  3 Jul 2026 08:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7C2B6B00BE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25A43A0528
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:28 +0000 (UTC)
X-FDA: 84947403576.15.16EDC65
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6C749100007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qVWpNx4k;
	spf=pass (imf14.hostedemail.com: domain of 32KtHaggKCKcQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32KtHaggKCKcQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081946;
	b=VzT5Eep7r16pWHcvD3tT7ze6H71K4w7grhBndeLIOmTJ/g7jSNhjPRjCDHOAExbiNGXwQK
	iwyU3D45WcnIhK72zwquX5jkJ5PVYRdKaEMT0fiMDPHnjt5DtXs6VvsMR6mSwBvNhxJPjU
	oX+VYNxD4ZfRhRjMuhV+hXxYMHYZQE4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fFT7yOWF2CbdWvEH0AItHvLZIORghfIPNsaQMCfWNs=;
	b=wknDmBAnX5xwd5j5qOcSWUrzE+jEx7pp2C4N81YYGQIgaY7M+6B4CWu3vmwYWQ/Zfc/UMU
	KIF/bORSlMqvZrssB4b8BKU2tA8KqTodS5/s5A5YE9P99a/el7E6RQS5N4Jk0gaywp1za8
	eIasqPWN1Ayig8ynPh8iKFi7GOmFrKI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qVWpNx4k;
	spf=pass (imf14.hostedemail.com: domain of 32KtHaggKCKcQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32KtHaggKCKcQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-472a798fc7cso337037f8f.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081945; x=1783686745; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5fFT7yOWF2CbdWvEH0AItHvLZIORghfIPNsaQMCfWNs=;
        b=qVWpNx4kqMOULb6rYKlq3L78O7F4qGBzXMyaWovbMLQLAPUYtPPnfAgdwvtP3SFDrf
         /Zopi9bGlbdh7ECpVKxx09wkIH7bDtr7S/Y9ixTb5FCWS1xRY0K9OZLJDjZoO9j5vvS4
         jFvl8NAZZZ9xY679dctrzYSM36BsDmp/x+RHncP3Oa8HN6wDDZZ2K7sGyYTlFR74fg04
         ZDEbUte+anYQvwVZGVxxxMCpF+SqpSTQsI09KW0e+zBqheVs0NJWm/cJwoO4tOlK+gLD
         9hMogJZlPSQu8Zz+a7wa5/pOPK8txgqTjmKbEX0czOOdbRwKa15jlrdh6m/LAWAe2n+h
         xYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081945; x=1783686745;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5fFT7yOWF2CbdWvEH0AItHvLZIORghfIPNsaQMCfWNs=;
        b=kgtNdfMCOELk2gJOTuRJVVXDeI+gvcMrqsXvdVGQSQY0AzncRDe/A63rg5JVVoKoKR
         fjVYRZXqWx8khii85jHlsZ18lbQBgLoMjg8iFMdOzJUgdF0kHh+bZwjkRRSIXU240gjO
         xvZDiDU/bXevB0o9ta3R3FYOIw+H0lY+mBMjlXcRPti/g+44Rzhi5oX0b+w80cCbAnQq
         WU+prjXXB34QnyBK0YTE3xR2ieVFHSTZKfc5HWGXQFtPbR97LKA99v4jbnJIMsdr33o8
         MZQUXhGlPuKJWUGH7u+rI2VLRkWCU77AV7Yc2XdrIFvCCbHHuauy4YpHqVOVJqD/NSib
         iWzA==
X-Forwarded-Encrypted: i=1; AHgh+Ro5D3yaa53Lg52E7GhXcagC9XaBWL6t0n10cedIIPPNn5qec+lBcfeJ3o+NWPFL1A14VQqFrklnGA==@kvack.org
X-Gm-Message-State: AOJu0YwafyAQkmYJ5jTWIdo7H5qb0bXjZ3jSypjg53kgNB1oTFZbw+p7
	rPa55/NyLDxAMQEH2EP5h3nZu0zCV1hRXSoECFpqd+jJgwaK3aTIMoeDH4ZnPWAyeuiR0FGH4gu
	T/yA38OwYvMPfrA==
X-Received: from wrnb1.prod.google.com ([2002:adf:e641:0:b0:46d:f7ac:193c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:ec49:0:b0:475:f0f0:9ecb with SMTP id ffacd0b85a97d-477b5d37949mr10697165f8f.54.1783081944763;
 Fri, 03 Jul 2026 05:32:24 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:45 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-5-c87b714e19d3@google.com>
Subject: [PATCH v5 05/18] mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: u1u7b6mcnor7fbrtko94uxk1wkn5q6b1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6C749100007
X-HE-Tag: 1783081946-448635
X-HE-Meta: U2FsdGVkX1/MMU9+0+ZuGlbdjpDSluUdCqFFpMyUP1sEH0H+/+LROvn/Ple5NoyicLmkt8ekZKXTwWnARiZVkLaZWm+h4aJgoDGfKBxdT1lSsHNHh0BaXhQ7hYhef0yFS3EBWdlbJpSy1AFm/YW7F8htZHIpFZWHr5A8Ob3KtpQgdXYjNM/K7fI3dxrM72s+U+oHsqHKFK5txX3drwdiyzOpCTeIQmxYOV6cpu3l4Cbs6hsDFZ1a2M5GLYsKLtKns/FDDTZUVg/cESA/xnlRTaUcGkzQ6epB0YvG2P2V7xaOd20LrpTifV4lC8xgSqNH7rQo79CJF5nvsRycRiIrK0I6AP3+NL6iBypKqfdfkMlcPbxFqzcn5QlXiqrabGVyaHSsumK5KEFt0GCm/ccfOUvpSNoWKYEtvO2Kb7LHRihLbr+GvEhfuRGN8tzr65H5AH0e583XXyDHo+BxfPfHTdu23XNkoXGtNYGyU8MjLGRdiWL+ypFiKORZD4TFN70Yo2Z6ps2ed1P8SQmByJmbAXINIZfxekDmzNNz/h8k+7bOjAF0Tazne4oBGMTVIKBQr2apt9IsLJ9bh8rBnz9wjVbhPH9o4vS2bmwz2OXQWc0R3O/pJlCMBpXQHMV0AzP/MX8FH0RcT87M7XTR+CbyIdd4XZw8Up6yB5+H7f1OuDc0Nq2d/3yeAgVscr24uf95t8kJaTWnm3mUFaN0XbyLZ+3MKnhmcdQS8WPXVfRTy9TqcYIFN+KXV5KOVnX+alhahZr5FFDB0xffEjaUeZd3dOyFOj9CYs42l8JL/HfxMhOHSbGT4+OlNoJr3MmiyEmf+Br5KfB4vnoIFWU1eoqvnTl6TyvXDcOkY4PpiNpdAP/5MdRoeOoOfpMW1GCbwpWrCMNpM5pl5Nj22CSSNxiA/asouWV9YtGjXHjToOstMOy5smhhWFLwABYz1tHbb+LtHZwmiggykn6xIQsXmEj
 eH1VnDEs
 V0pJHneTbBPhx6QF9nHfiRp4wm/rVOOZrIbpn8cYcaBPksxnwQJHQJ/qwy+rK1uBZDyfogiidMEfjIkxA5O3F7g4SAcDkNC0ELNfKOoeMVZ57Qgn9Ns497/0KBuuVBBbvSeoBc4Anm1Aj+0r0PNvwqQ9o2k5js/mTI65Bd0E9bL+X0oMGJvtM/85Pqfmv5McRqRVwpdxp/O+xigw8wiAad6y/Ln9+PGY9wVk0HD0KpvJLAU5+CEbNbJM6rA0Q2MnKtck4nlWAz1OBFasja1+XGXEqwyxruuqVNMCTCX1OItOvlNyWGS/9b3TtRfiu40DKYTtHhDszcZrMo/LL5UNzafVX9RAnwDtGD9pj39idl9gPZfnEl9F18a03jDTXA6QiVgtBaUwTzreSQPQ+hqLNZH398fv/TOGvm+bVoxl7g5LQ2V1iwImNK6fOf2WWzr35znzl488QkxjPFlmoKbFhGL1HN2FKSSyz1v7HrZrpEoRxRZkTbQKDZ7pZ7wHTND9Gqv3DeMkqmZTjqwrpDwp/jFRHTVgh1QDlSAagaL5fAqfEGzG6T9Zbsu7sG3EDM5xw7tA7Yy0SaVagoQESeGsfKOMaqGEkjHgNYZt+n1TpRdigLsMrSBoFAqMRCwpjJZ1hIl/XDI60jUkRnvWcSmU6UbBAcyH9h+MlihOD5k7oqU7bdkwImZxLD4jbTNLO8jGFPaoHtLwp3Xbqtt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
main entry point function is significantly different from the normal
__alloc_frozen_pages_nolock(), this is tiring when reading the code.

Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
exposed to mm/) and then turn the nolock variant into a thin wrapper
that just sets that flag (as well as handling NUMA_NO_NODE, similar to
how some of the wrappers in gfp.h do).

For consistency, set ALLOC_WMARK_MIN explicitly in fastpath_alloc_flags
for the new ALLOC_NOLOCK path. This was already "done" silently in
__alloc_frozen_pages_nolock_noprof(): ALLOC_WMARK_MIN is 0.

Rationale that this doesn't change anything:

1. Simple bits: A bunch of the nolock-specific handling is just moved to
   the new alloc_order_allowed(), alloc_nolock_allowed() and
   gfp_nolock.

2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
   previously in the nolock variant:

   a. Application of gfp_allowed_mask; this only affects early boot,
      only flags that affect the slowpath get changed here, and the
      nolock allocation path isn't allowed to the GFP_BOOT_MASK flags.

   b. Application of current_gfp_context() - also only affects the
      slowpath

3. The slowpath itself: this is now just explicitly skipped under
   !ALLOC_TRYLOCK.

Ulterior motive: adding an alloc_flags arg to the allocator's
mm-internal entrypoint can later be used to do more allocation
customisation without needing to create new GFP flags.

No functional change intended.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/hugetlb.c    |   3 +-
 mm/mempolicy.c  |  10 +--
 mm/page_alloc.c | 192 +++++++++++++++++++++++++++++---------------------------
 mm/page_alloc.h |   6 +-
 mm/slub.c       |   6 +-
 5 files changed, 117 insertions(+), 100 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0f51b36773f59..48471503984c1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1790,7 +1790,8 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask,
+						     ALLOC_DEFAULT);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 948264407dee3..914f81863db5a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2417,9 +2417,11 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	 */
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask,
+					   ALLOC_DEFAULT);
 	if (!page)
-		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
+		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL,
+						   ALLOC_DEFAULT);
 
 	return page;
 }
@@ -2467,7 +2469,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				nid, NULL, ALLOC_DEFAULT);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2479,7 +2481,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, ALLOC_DEFAULT);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 85cee8a0031f2..f47a848555077 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5222,7 +5222,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0);
+		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -5271,24 +5271,99 @@ void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
 	}
 }
 
-/*
- * This is the 'heart' of the zoned buddy allocator.
- */
-struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
-		int preferred_nid, nodemask_t *nodemask)
+static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
+				       unsigned int alloc_flags)
 {
-	struct page *page;
-	unsigned int fastpath_alloc_flags = ALLOC_WMARK_LOW;
-	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
-	struct alloc_context ac = { };
+	if (alloc_flags & ALLOC_NOLOCK)
+		return pcp_allowed_order(order);
 
 	/*
 	 * There are several places where we assume that the order value is sane
 	 * so bail out early if the request is out of bound.
 	 */
-	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
+	return !(WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp));
+}
+
+static inline bool alloc_nolock_allowed(void)
+{
+	/*
+	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
+	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
+	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
+	 * mark the task as the owner of another rt_spin_lock which will
+	 * confuse PI logic, so return immediately if called from hard IRQ or
+	 * NMI.
+	 *
+	 * Note, irqs_disabled() case is ok. This function can be called
+	 * from raw_spin_lock_irqsave region.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
+		return false;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return false;
+
+	/* Bailout, since _deferred_grow_zone() needs to take a lock */
+	if (deferred_pages_enabled())
+		return false;
+
+	return true;
+}
+
+/*
+ * GFP flags to set for ALLOC_NOLOCK i.e. alloc_pages_nolock().
+ *
+ * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
+ * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
+ * is not safe in arbitrary context.
+ *
+ * These two are the conditions for gfpflags_allow_spinning() being true.
+ *
+ * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
+ * to warn. Also warn would trigger printk() which is unsafe from
+ * various contexts. We cannot use printk_deferred_enter() to mitigate,
+ * since the running context is unknown.
+ *
+ * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
+ * is safe in any context. Also zeroing the page is mandatory for
+ * BPF use cases.
+ *
+ * Though __GFP_NOMEMALLOC is not checked in the code path below,
+ * specify it here to highlight that alloc_pages_nolock()
+ * doesn't want to deplete reserves.
+ */
+static const gfp_t gfp_nolock = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC |
+				__GFP_COMP;
+
+/*
+ * This is the 'heart' of the zoned buddy allocator.
+ */
+struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
+{
+	struct page *page;
+	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
+	struct alloc_context ac = { };
+	unsigned int fastpath_alloc_flags = alloc_flags;
+
+	/* Other flags could be supported later if needed. */
+	if (WARN_ON(alloc_flags & ~ALLOC_NOLOCK))
 		return NULL;
 
+	if (!alloc_order_allowed(gfp, order, alloc_flags))
+		return NULL;
+
+	if (alloc_flags & ALLOC_NOLOCK) {
+		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
+		if (!alloc_nolock_allowed())
+			return NULL;
+		gfp |= gfp_nolock;
+		fastpath_alloc_flags |= ALLOC_WMARK_MIN;
+	} else {
+		fastpath_alloc_flags |= ALLOC_WMARK_LOW;
+	}
+
 	gfp &= gfp_allowed_mask;
 	/*
 	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
@@ -5303,16 +5378,19 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 			&alloc_gfp, &fastpath_alloc_flags))
 		return NULL;
 
-	/*
-	 * Forbid the first pass from falling back to types that fragment
-	 * memory until all local zones are considered.
-	 */
-	fastpath_alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
+	if (!(alloc_flags & ALLOC_NOLOCK)) {
+		/*
+		 * Forbid the first pass from falling back to types that
+		 * fragment memory until all local zones are considered.
+		 */
+		fastpath_alloc_flags |= alloc_flags_nofragment(
+			zonelist_zone(ac.preferred_zoneref), gfp);
+	}
 	fastpath_alloc_flags |= alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
 
-	/* First allocation attempt */
+	/* First allocation attempt (or, for nolock, only attempt) */
 	page = get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags, &ac);
-	if (likely(page))
+	if (likely(page) || (alloc_flags & ALLOC_NOLOCK))
 		goto out;
 
 	alloc_gfp = gfp;
@@ -5329,7 +5407,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
-		free_frozen_pages(page, order);
+		__free_frozen_pages(page, order,
+				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
 		page = NULL;
 	}
 
@@ -5345,7 +5424,8 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 {
 	struct page *page;
 
-	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask,
+					   ALLOC_DEFAULT);
 	if (page)
 		set_page_refcounted(page);
 	return page;
@@ -7875,80 +7955,10 @@ static bool __free_unaccepted(struct page *page)
 
 struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order)
 {
-	/*
-	 * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
-	 * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
-	 * is not safe in arbitrary context.
-	 *
-	 * These two are the conditions for gfpflags_allow_spinning() being true.
-	 *
-	 * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
-	 * to warn. Also warn would trigger printk() which is unsafe from
-	 * various contexts. We cannot use printk_deferred_enter() to mitigate,
-	 * since the running context is unknown.
-	 *
-	 * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
-	 * is safe in any context. Also zeroing the page is mandatory for
-	 * BPF use cases.
-	 *
-	 * Though __GFP_NOMEMALLOC is not checked in the code path below,
-	 * specify it here to highlight that alloc_pages_nolock()
-	 * doesn't want to deplete reserves.
-	 */
-	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
-			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_NOLOCK;
-	struct alloc_context ac = { };
-	struct page *page;
-
-	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
-	/*
-	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
-	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
-	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
-	 * mark the task as the owner of another rt_spin_lock which will
-	 * confuse PI logic, so return immediately if called from hard IRQ or
-	 * NMI.
-	 *
-	 * Note, irqs_disabled() case is ok. This function can be called
-	 * from raw_spin_lock_irqsave region.
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
-		return NULL;
-
-	/* On UP, spin_trylock() always succeeds even when it is locked */
-	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
-		return NULL;
-
-	if (!pcp_allowed_order(order))
-		return NULL;
-
-	/* Bailout, since _deferred_grow_zone() needs to take a lock */
-	if (deferred_pages_enabled())
-		return NULL;
-
 	if (nid == NUMA_NO_NODE)
 		nid = numa_node_id();
 
-	prepare_alloc_pages(alloc_gfp, order, nid, NULL, &ac,
-			    &alloc_gfp, &alloc_flags);
-
-	/*
-	 * Best effort allocation from percpu free list.
-	 * If it's empty attempt to spin_trylock zone->lock.
-	 */
-	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
-
-	/* Unlike regular alloc_pages() there is no __alloc_pages_slowpath(). */
-
-	if (memcg_kmem_online() && page && (gfp_flags & __GFP_ACCOUNT) &&
-	    unlikely(__memcg_kmem_charge_page(page, alloc_gfp, order) != 0)) {
-		__free_frozen_pages(page, order, FPI_TRYLOCK);
-		page = NULL;
-	}
-	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
-	kmsan_alloc_page(page, order, alloc_gfp);
-	return page;
+	return __alloc_frozen_pages_noprof(gfp_flags, order, nid, NULL, ALLOC_NOLOCK);
 }
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 3250d44f96457..a4f4b325381ad 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -11,6 +11,7 @@
 #include <linux/nodemask.h>
 #include <linux/types.h>
 
+#define ALLOC_DEFAULT		0
 /* The ALLOC_WMARK bits are used as an index to zone->watermark */
 #define ALLOC_WMARK_MIN		WMARK_MIN
 #define ALLOC_WMARK_LOW		WMARK_LOW
@@ -219,7 +220,7 @@ extern bool free_pages_prepare(struct page *page, unsigned int order);
 extern int user_min_free_kbytes;
 
 struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
-		nodemask_t *nodemask);
+		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
@@ -230,7 +231,8 @@ struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
 #else
 static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
 {
-	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
+	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL,
+					   ALLOC_DEFAULT);
 }
 #endif
 
diff --git a/mm/slub.c b/mm/slub.c
index 877021e69cc41..3989b4758ae0a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3292,7 +3292,8 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
-		page = __alloc_frozen_pages(flags, order, node, NULL);
+		page = __alloc_frozen_pages(flags, order, node, NULL,
+					    ALLOC_DEFAULT);
 
 	if (!page)
 		return NULL;
@@ -5302,7 +5303,8 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL,
+						   ALLOC_DEFAULT);
 
 	if (page) {
 		ptr = page_address(page);

-- 
2.54.0


