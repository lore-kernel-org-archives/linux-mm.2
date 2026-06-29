Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D11C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D39C6B00E6; Mon, 29 Jun 2026 09:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35AAF6B00EA; Mon, 29 Jun 2026 09:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1612C6B00EB; Mon, 29 Jun 2026 09:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB3B66B00E6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59277120604
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:25 +0000 (UTC)
X-FDA: 84932989050.28.372D33D
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf31.hostedemail.com (Postfix) with ESMTP id 99ADA2000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XnoeMEq1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3NW9CaggKCHYdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3NW9CaggKCHYdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738743;
	b=gsCT+mSZBYLWeYMpqjd71dmkeCZ+4+9Q8FnI8gloRUSiDacuMmA9rCl7RFc3OgdCkRwIh0
	OhcuoZ0oZEwbIEBsr1ezaYbv1vhkdLGuPYiCnL3rulEEznjVL69ZVMhOe1y2ShCikbLnMM
	nhI8Yl8j2FhHygafa17mfvJhUd2vdbg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIyyEE2lAI9VvoNzqea6TYQBQkOeDXxoyRlWFyDdV/0=;
	b=DPOcScbMsR7rVUDTDVfh3Klc5lfL3uQuA4k/OJHsvAgRObHt85I0aQiwzdCF1FJ4wI9630
	v3yEszWkWp7QzABd2UFEq896FJPZhhi0sdzQHEtcrCZX79mi/H7hmFhrcEt+8wdA9sEY2c
	Jp/vD1d5XajdDnykWC563VdZf0Yevi0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XnoeMEq1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3NW9CaggKCHYdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3NW9CaggKCHYdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c1237547c18so227628566b.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738742; x=1783343542; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TIyyEE2lAI9VvoNzqea6TYQBQkOeDXxoyRlWFyDdV/0=;
        b=XnoeMEq1rxH1rBGzI1TW2bOcU3hiI02e4kQAmJ3bLPat2iLrm0Pd1g1zyr8I72YuoA
         adU6iPisHFQtW8s9wHT3hMXIFaftvsgbAaiyl6aTRkTx1KtfNV+zidhT7zlBh8ELZlK9
         D1kfUVYK3bTnuKFG/y62ay34tyjhkyBHkjt4Osg/zBafgE8hKQr0NuFo7aJNUO2x9xZb
         L8NqfJOEaV78zV9aNU8MLmse5wG88G29ZCwc0HELKf7hINL6+M/fc8N2pbit62OZcsAB
         vlAjX3Oqfn3rtBwZ/1zdNgtwe5J1rvYw6Pnd+umVE8ZBOwd/KgRGKjr2bhrdrKFvNs5f
         fLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738742; x=1783343542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TIyyEE2lAI9VvoNzqea6TYQBQkOeDXxoyRlWFyDdV/0=;
        b=QWLtdepDRVPpsKWr2JGAD7Eg0vaXCYa+1+Cm3mGvDXNwMX9G52sHISb7KFgRHpKKGq
         msk62ImiqvD+jeZtr95ajB25GvTyEe02imXr5XwojLRSLqz7QkVHcwyuXb1OdfRrJ5IE
         r8W5KwdJmLenY4dwDWNYs5WcTDrAoS5l6mrkJz6VXSDBbjKm8zo05b90plOgVwF/G5JD
         NXMeEliK4Z4GsBVBJHkY1TTq/2OXeUpz+mEHBH58wdY7jrbADithtHjrGqY5a4ELRAIc
         KHkLgauPlpDeAw3x01zdseVqWkTfpfPIUXHoZ3jddZ0xameoaNvuCYjB85PdXzp9rHxU
         pLDg==
X-Forwarded-Encrypted: i=1; AHgh+RrJMTYPVdK7cLmI2FDVqNsAgsCATbTydL2Hk/6z6G9JVNCSeZUvlGqoG4ikmG5EzlOJ3BxUsINAzw==@kvack.org
X-Gm-Message-State: AOJu0YzLRlVK2m38rbOBS+wClY+oLJpJd1o9OGcydkj3oa2zTFhaoDKJ
	z1enEgTNX5YmNcNzndg5Xs9eb85SXS0UQCpJYRt1hTl0CI9Cp7A+jyev3HoKAQiUMuydqHqFZho
	BTiWaGBjw0pa1sw==
X-Received: from edrs17.prod.google.com ([2002:aa7:c551:0:b0:695:bb1f:d917])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:25c6:b0:bec:6c5c:ccee with SMTP id a640c23a62f3a-c1205eef6famr993371566b.27.1782738741491;
 Mon, 29 Jun 2026 06:12:21 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:54 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-5-57bef0eadbc2@google.com>
Subject: [PATCH v3 05/16] mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
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
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 99ADA2000A
X-Stat-Signature: jgsadsdxhfyeekhwxknjh5ps6qd9nhnd
X-HE-Tag: 1782738743-372626
X-HE-Meta: U2FsdGVkX19aPtqdxR4v4rmKv8SHqUs8YQKv3jXpAP3DWk/b6Mg4KsTL4FyPsu2uAdd0HCb3Uzt28PI0Z/uzBIXp4Uc+h4gWEYV6XVXpu1jFGDKQD4czbdBHq89HTW7nvcg7QWuzThHydTIHwNhGLIvUcO/DscFxTF9P7tWQ+JNLoZ+FASKC5+CetSCcCBuV3eWpwOjWMC1x6fyZ3/GpozUaj7YgAP8Qeg1Z4Sqa88zy7IFC8HAgvTzpLCMkDaKWiBCBV5j7q1OYybC6V02AFA4sHFewORqQkGcPqH1ltFXElaYBxD6XfWPbhkIj8PUKgvP3pKuule0gbaEJvAArZuR/Dq4XIEzj+YYBz5w1hHkZjUE8pJa5ApuyEb6sxqnD7OwkdZsyUeYnAe+Lmqugy8T7CRYaiJVsDvPYV/MmCKEcP1qMlG8dKuHbgau3W43xp60J2YMU10ObJQ8LFwCBi/MBwgA3HiCoEz64p+z5S6Hfz9Z56HqvXUzKGmGGX25Ik+FuqaFCDJz2e+Mf4FanjZJCPBAK+/GZWAjiZIW3iNtM6viv7u02Z1SdGqM6ZyetJP44+mj7WgMaPimEFcjZs2Uo8BGNSFy5v7kuxNzXzJUstBTrN1JnyPh1TE1cjiX1Hg0Am9ms0hgxaU7W1bgYNDIqkEekNw9FB+uztdrqLudT443njPnDFY3fSZoeNsw+KpjgQhWUBLkvzYk5tYrbhoImbIw4Z952eMF2lwdOtdwDUbT9ovdXpYNJv6pfx6VLjNPTOjMSlJOz5NU370aiuNr4UjeATIQmQgM9Hc/2SnNPilh4TbQzhseYbQhNSDmH9BrQho8r7g+YS1f345B8teHm9Qxi+JmW/T7blqLHrgKiAArfniCB4SFuns7TIWT+uXMjCkNaNTYIGlAgSSnekyZFp+rSbm2UOSt91VfW76AjJZESFnAYeoeVrRAukABdIbVxOGGyahwIUujLhQ9
 RVWL/jSp
 tkbGRqpWqRsowb/WqVU/5lfSZkyfoizR5zrj5aH7G6pk/soKLC783jc5hinA+BRd0nlxxAe2ZkIFGNwLLgRrrFdi2Zm0fV+Nbk2tIp9yZHCbgNZ4cI8q/3Pl7NUc7GX4GTi/PA2LpyJ2tzt4IV+fBC8bUJYyxJiJmazPNHNaTBljcX4TIrlAqFp4xxtGKtb84nNa33bv3gxxZldiPkrDgIShvg64pWUKbpoRIJFG4UfD+h0x15sOZJKjoZkjEgQIGkaJ8prQ3dR06Bd3bkUtwyMFChWVOmi87T512LX8MLQ1WtGoJmVT7HNQEF9aj1fgaAbfGYb8BwdytdjJo8/08rZeluzHTle31ayn9bB9Tsr8kwPlESf1RBGq5PC3jnGXZwYpWk4+zG88UPypjqoLhizvBjJu6TnMWzlii12/VXDaNVYARG4mUg03MYDy3wIp+t0/OpSWswBg5Svo311oP3xjfssjdABd1feWRnZKWZ7TKHmgvcpvgQzQpKEkv+zUgDNEjyZC+xmG/lOkdzma909eDV9aR95wJQSe3hw5vd/PGp9meuncYajeOX/PteTEdMHCK4WrFYw1AoCy0Xe14rJp5uEmhapaStfbefQdOEp/sW0bcD44yjlPTC7q65648q+7CsSso4bVH4J+dmJ60iFs32IcL7cI+LIAiRLCw/MP1c8rZvXrlM6eVLQ==
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

Rationale that this doesn't change anything:

1. Simple bits: A bunch of the nolock-specific handling is just moved to
   the new alloc_order_allowed(), alloc_trylock_allowed() and
   gfp_trylock.

2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
   previously in the nolock variant:

   a. Application of gfp_allowed_mask; this only affects early boot, and
      only flags that affect the slowpath get changed here.

   b. Application of current_gfp_context() - also only affects the
      slowpath

3. The slowpath itself: this is now just explicitly skipped under
   !ALLOC_TRYLOCK.

Ulterior motive: adding an alloc_flags arg to the allocator's
mm-internal entrypoint can later be used to do more allocation
customisation without needing to create new GFP flags.

While adding this flag to a bunch of places, create ALLOC_DEFAULT to
avoid a mysterious literal 0 in most places. alloc_frozen_pages_noprof()
is defined above the alloc flags so just leave that as a slightly messy
exception instead of trying to fully reorder mm/internal.h for that one
case.

No functional change intended.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/hugetlb.c    |   3 +-
 mm/mempolicy.c  |  10 ++--
 mm/page_alloc.c | 178 +++++++++++++++++++++++++++++---------------------------
 mm/page_alloc.h |   6 +-
 mm/slub.c       |   6 +-
 5 files changed, 108 insertions(+), 95 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f7925624c4d2e..dfcfcfa4715bf 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1806,7 +1806,8 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask,
+						     ALLOC_DEFAULT);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9c740324f9160..41d630f0ea821 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2426,9 +2426,11 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
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
@@ -2476,7 +2478,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				nid, NULL, ALLOC_DEFAULT);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2488,7 +2490,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, ALLOC_DEFAULT);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a3ba63c7f9199..8d409d075e3e9 100644
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
@@ -5271,24 +5271,98 @@ void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
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
+static inline bool alloc_trylock_allowed(void)
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
+		if (!alloc_trylock_allowed())
+			return NULL;
+		gfp |= gfp_nolock;
+	} else {
+		fastpath_alloc_flags |= ALLOC_WMARK_LOW;
+	}
+
 	gfp &= gfp_allowed_mask;
 	/*
 	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
@@ -5310,9 +5384,9 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	fastpath_alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
 	fastpath_alloc_flags |= alloc_flags_nonblocking(gfp, order) & ALLOC_HIGHATOMIC;
 
-	/* First allocation attempt */
+	/* First allocation attempt (or, for nolock, only attempt) */
 	page = get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags, &ac);
-	if (likely(page))
+	if (likely(page) || (alloc_flags & ALLOC_NOLOCK))
 		goto out;
 
 	alloc_gfp = gfp;
@@ -5329,7 +5403,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
-		free_frozen_pages(page, order);
+		__free_frozen_pages(page, order,
+				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
 		page = NULL;
 	}
 
@@ -5345,7 +5420,8 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 {
 	struct page *page;
 
-	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask,
+					   ALLOC_DEFAULT);
 	if (page)
 		set_page_refcounted(page);
 	return page;
@@ -7875,80 +7951,10 @@ static bool __free_unaccepted(struct page *page)
 
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
index 3250d44f96457..e16f905f859a7 100644
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
+					   0 /* ALLOC_DEFAULT */);
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


