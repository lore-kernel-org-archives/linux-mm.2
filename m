Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96FCDCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624D06B0088; Wed, 17 Jun 2026 11:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6C06B008C; Wed, 17 Jun 2026 11:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5C26B0092; Wed, 17 Jun 2026 11:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 175D96B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:29:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 948831C27C8
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:29:51 +0000 (UTC)
X-FDA: 84889789782.28.DCEE3DF
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 631BC1C000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:29:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DKx80smN;
	spf=pass (imf21.hostedemail.com: domain of 3a70yaggKCAotkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3a70yaggKCAotkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781710189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Khja+sb+mPgskrmGQ7X77sIX1T917JjgVFb5aBSLAJU=;
	b=LhexDWkNUZ9h5+FwDMhxsTq6gvmGvmJAlz3vOQZ0cKs5wpC1EwTXGgJ/Z6q/+hh3tBWAPq
	Lr7ldR5KEZKS2Xsjmgepef1yMQsMmkzgnNhnkXr7KtEEnkI4XkasArBiUR+kXnqywNacK/
	aEKOLwp2SF6oESzWVNi96dtlv/hzwEA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DKx80smN;
	spf=pass (imf21.hostedemail.com: domain of 3a70yaggKCAotkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3a70yaggKCAotkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781710189;
	b=Ei4OUbr7MV1VuHHeU36z3Vq6lMLDpipXHKH6k/5s0rqV5LPqkTlZyi0ZqxLwwKgrl8SQ0c
	fuvz84G2xTh6V4HuYbI4Hf/+o9Q/yDGoT4Oph33Rn3YKn2FDrPYo0M5BaYUlEWn+12CFpp
	WHKu7hJsOilY/cEQeoxlfj6y97i7pwQ=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45ef0af9517so5428771f8f.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781710187; x=1782314987; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Khja+sb+mPgskrmGQ7X77sIX1T917JjgVFb5aBSLAJU=;
        b=DKx80smNZfRPsL+rgLmYJL/Z8P509zkQwe+Jy8QtARBNr5eo21wyBPfGdoDeXS3WHL
         F2LCq/hlskDEWDjsjL7Lpp85vUKyQpdh34hVEdN92irpfcQh1SPXOhCCtlahhWszfWkO
         C6K8VpkYnKcDuW94truQBTZM0xsEHoTsPQa9r1ENhu/4SYK1nIk/ZngEix1TwfCdomy4
         KZMWDyX70ZLxjVKxWVI12U+9ayaHni4d7dIgGJMAwD9qKYQR/dyVs46R+jcKzN8MuQGB
         eVxnMf4TPq6OTL0KCdTOjQ2B5+7k2R+IO9vAM2ziEWtYOabKTW4kEwGqCRFjueORLpdK
         5ZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781710187; x=1782314987;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Khja+sb+mPgskrmGQ7X77sIX1T917JjgVFb5aBSLAJU=;
        b=LZGz5JZl3O9VFyHLbtCK31uNBagzJ0yGXu9BkSV5NOEp3Ishrik4pLzI9OiVFCVusH
         v4zxHEpwjwcg0OyyS1RvtF2UwL1VqD2Hbsg5EYR9l/SE/1IlD94uaMeYXMf6jvryV3tV
         Vqjh0M3+f/PyTp97cMOScrnKzvuYrKgZhpaoHWa1t6rnSW97bErMCLNiPxYVhaQ1lvoo
         LN9rMpy+yWaVDFxbNJxIe7F9XaSLDDA+9tT/oRHW/GNVlWMAboQrFJVIjhvOn9M5yU4/
         a2/Yqfy6qZbdytA571RhqIIcXJZyHa3TiIJOs0hVNdTSnwPbu2V0CFl6e8qQTst39qeh
         O+fA==
X-Forwarded-Encrypted: i=1; AFNElJ9CBPszwn0013WAr2LuEiHqVPZDW2HB+Lq2vbJ3Ha5ZUs+20QWWH6L2PZu6XaEmMJcRYe+HTuo7iA==@kvack.org
X-Gm-Message-State: AOJu0YxOb/Tf+MbuXLwQzNyTVCWxNKY1He+WyUmzFW9E0T1u8zwYkRX/
	w/ubPtFBRiGBZQHE1DvH4k6UbQBfUqjNQ6MLJ9P8Pn09H5t9d3EERuSuQknCMX6y7zXtjzqa3h/
	Xniwh+QIoHt6aZQ==
X-Received: from wmok21.prod.google.com ([2002:a05:600c:4795:b0:490:bae0:2975])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a30c:b0:490:c024:2eba with SMTP id 5b1f17b1804b1-492333e2829mr68327805e9.22.1781710187354;
 Wed, 17 Jun 2026 08:29:47 -0700 (PDT)
Date: Wed, 17 Jun 2026 15:29:42 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAGW9MmoC/yXMQQ5AMBCF4avIrDVpVTRxFbGodjA0SIsQcXfF6
 uVbvP+CgJ4wQJlc4HGnQPMUIdIETK+nDhnZaMh4VvBCKKadmw1b/RlnZCLXViqrGykVxM/isaX j61X177A1A5r1jcB9P6+TR9lxAAAA
X-Change-Id: 20260617-alloc-trylock-14ad37dab337
X-Mailer: b4 0.15.2
Message-ID: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
Subject: [PATCH] mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
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
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 631BC1C000B
X-Stat-Signature: c3ref78ejyqzqpynxkemqnjyxizaoota
X-Rspam-User: 
X-HE-Tag: 1781710189-683215
X-HE-Meta: U2FsdGVkX1+hVvRCVNikBKDftmNthLgAIIF2xOJ2LVIgQs6uGZm6QwixK3A/A4wP1VDE28kDeLqY9XpE4KORkS8SIUSFHcvxDrCoquiekmB9eGyhWQzMYqaIQrMbUhUYje2q7kitVzEaYzWqUuspvVpeYSuJzht0hWnVQd2emQdLYOi3R9FVpsTzg3OfBTkUSmc2mcWI06C2w4Fd3gMMS6LXoXzA7+ujOBvGAs12M6mwRiKAUg79y6a5ONWg3eQVqfScxeivdqBNC2ymwmI+6bUte8T8y8Pjz3P8fqOagotdghjgcXxN24DpJo8ZJ0qTPp9jMOiSxSk7WU/iI8xqC+QwvoBzPr2z4Q+xJO8Jq4T3lgrYRX2yqwxRRXrFU/VS6j6yFEn61v5JN2wGnQYfFsVrLbexiG+tc+RiNkebYBrJFzc882S+PBhAmifDmzetUYGpl0aY+DeX8x9cw3hEtzM19vvGe83n3hJm9hXsMeWTUrdazKHoZtdJ5hbcAbNTRU96GgVJn5age2l3c/izLNRAfBXmgBWL8ik7n+ZNkJh+I3Q3imWoeKiVnEa+G3pSEorF5WlRx3QZhqXAQvBFwV7wb57FfZFmbpI//aAhOl+Ern8G7zTgS+H2vXAw9ph2Z2wjld0eJpzRMLCZSo2G9pvBZXt+0d1auneKeUA6EWsBe+52pTrchMpguuVT12WqL7JKMgHCwXPwEe9z1J3BKRB2HQ0de5r6PjrS1/MygPHVk4ZNDcr657WPN9+8Oa8wBxKscJA+Y7uDW78vYYQlUw3lF7KSc9SBeHlfMzATuz+qmaLBg/e8ThYTcU1DaFo8RlE9xkN2SuSh2AvxdHGtyWkTtiBGy10Ee6wcg+wh+W/rXcAY6pDueIgXJiDma9PhwiACOsWqjc1zDEoNG8PfwDA5N1uTZw1OoJu882Lnacp5Ac+3cUAfFhh0oDE3VVUb7BPpakql9U4C6q4rzsM
 Z/AKfT5j
 WYHIfNBZreZKoTmDs82cxasGLcBG2SxrzXIx1R012J9L99bjoIUkizY8kbg443l8KBZE+2570Dt7xlsuV2sTelZfI5PnfHI1xB0f1eunXF0Y3GFdMGU4KH2XFO36aAFmmRWusNAjB3vQuvPtmUZWsvh5ithW343jNDWQiHYiIuWy1y7dV4sGhI1s+IaVraXUwjUAWyaOHiTaApvT7EZ88vM0A5Vb8AJmgR6VPDnwSNHREr4PzInYrQdWo20PX14v+fj7MvAJRtIq4WgtSuruio5tdEvTwwZZEKNKNWaNXqnmJt1tDccCPMGFMtrnGvytcS/x/KKUT/sGb9ptvd1ssZyKbUuUmb4PpKY1s9li33YB04KBlHSNsThs2MxGvy3P8wTwM9H6qzm89xb2gHz9naxW7Bq506jZWN6EEsO8GarRLUAK0c/acKKQvrmdho/vT6oQV3qCkeWFh+2Hjeff5iU0fX6zS7YNPg1p2EnqM8jDaie4+ETxeZ2rv2K5MZJqETC344ye5K4QH+MM6e/Twd7Kkssekv08QKyxSC1rsbw1IurS67SbMCr/iIzPBTcuFJYhH0mBXfJrGhWRpTqaWraUvN55gUnlfqxD+rg+MbB7f6GojSo9eW0b8pIcXa61WXtOBWIEc+8eP5lDmDiIHB7s1FPckpgpHzVwQXaTJDbd8+ouIiWZ3qH1ejQ==
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

No functional change intended.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/hugetlb.c    |   2 +-
 mm/internal.h   |   4 +-
 mm/mempolicy.c  |   8 +--
 mm/page_alloc.c | 175 +++++++++++++++++++++++++++++---------------------------
 mm/slub.c       |   4 +-
 5 files changed, 99 insertions(+), 94 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835e..619f6307dc98d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1806,7 +1806,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask, 0);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a20..1043eb833836c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -913,7 +913,7 @@ extern bool free_pages_prepare(struct page *page, unsigned int order);
 extern int user_min_free_kbytes;
 
 struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
-		nodemask_t *);
+		nodemask_t *, unsigned int alloc_flags);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
@@ -924,7 +924,7 @@ struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
 #else
 static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
 {
-	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
+	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL, 0);
 }
 #endif
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 36699fabd3c22..dccff90682035 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2425,9 +2425,9 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	 */
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask, 0);
 	if (!page)
-		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
+		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL, 0);
 
 	return page;
 }
@@ -2475,7 +2475,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				nid, NULL, 0);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2487,7 +2487,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, 0);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0111cdbdb5321..fc4d07bbf44b5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5253,24 +5253,98 @@ void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
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
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
-	struct alloc_context ac = { };
+
+	if (alloc_flags & ALLOC_TRYLOCK)
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
+ * GFP flags to set for ALLOC_TRYLOCK i.e. alloc_pages_nolock().
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
+static const gfp_t gfp_trylock = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC |
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
+
+	/* Other flags could be supported later if needed. */
+	if (WARN_ON(alloc_flags & ~ALLOC_TRYLOCK))
 		return NULL;
 
+	if (!alloc_order_allowed(gfp, order, alloc_flags))
+		return NULL;
+
+	if (alloc_flags & ALLOC_TRYLOCK) {
+		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
+		if (!alloc_trylock_allowed())
+			return NULL;
+		gfp |= gfp_trylock;
+	} else {
+		alloc_flags |= ALLOC_WMARK_LOW;
+	}
+
 	gfp &= gfp_allowed_mask;
 	/*
 	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
@@ -5291,9 +5365,9 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 */
 	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
 
-	/* First allocation attempt */
+	/* First allocation attempt (or, for trylock, only attempt) */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
-	if (likely(page))
+	if (likely(page) || (alloc_flags & ALLOC_TRYLOCK))
 		goto out;
 
 	alloc_gfp = gfp;
@@ -5310,7 +5384,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
-		free_frozen_pages(page, order);
+		__free_frozen_pages(page, order,
+				    alloc_flags & ALLOC_TRYLOCK ? FPI_TRYLOCK : 0);
 		page = NULL;
 	}
 
@@ -5326,7 +5401,7 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 {
 	struct page *page;
 
-	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask, 0);
 	if (page)
 		set_page_refcounted(page);
 	return page;
@@ -7856,80 +7931,10 @@ static bool __free_unaccepted(struct page *page)
 
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
-	unsigned int alloc_flags = ALLOC_TRYLOCK;
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
+	return __alloc_frozen_pages_noprof(gfp_flags, order, nid, NULL, ALLOC_TRYLOCK);
 }
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d0..b9fb66071bd07 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3275,7 +3275,7 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
-		page = __alloc_frozen_pages(flags, order, node, NULL);
+		page = __alloc_frozen_pages(flags, order, node, NULL, 0);
 
 	if (!page)
 		return NULL;
@@ -5236,7 +5236,7 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL, 0);
 
 	if (page) {
 		ptr = page_address(page);

---
base-commit: 1111012ec6508a38a39f8d20c213c8c9cf3c96c0
change-id: 20260617-alloc-trylock-14ad37dab337

Best regards,
--  
Brendan Jackman <jackmanb@google.com>


