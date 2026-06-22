Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E5ACDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03AEF6B0092; Mon, 22 Jun 2026 06:01:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012EB6B0095; Mon, 22 Jun 2026 06:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59276B0096; Mon, 22 Jun 2026 06:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEF66B0092
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9700A1C3219
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:48 +0000 (UTC)
X-FDA: 84907107096.14.5715096
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9F1481C000E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NL63VFF1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3CAg5aggKCFU6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3CAg5aggKCFU6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acHa8qzGpYOuvZT+OpZqGrTA/yeCpJyZkBIOAz883N8=;
	b=y7AQKFUVG851SpvFBACJDsKP+XifI26c3n9IN1MUtl9u4HqPI/igdh9NZ2HpwlxCljaEqE
	+4LC683ZUb4hT73+neZvIG2Rog0DMCEtBjNDYChee8xTjdt13Oo5v/cyzoZIFMtiSntBp8
	ze+EJ3r6Uo3j5GOzxP1xTRk2bQ5E6yg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122506;
	b=4tDbjEXejTMUgx4sx13Op3RF1AzBIOqEnSa3cnVj0NMdfS1KDDR9nvtvrdQs6L9sEn9qIz
	YIIINm8pTQbYC9zwfNavu6qrISSoD04XATrGqeNX5Kj89csPHrUj+a+lauYslf6i6sQt9X
	Z7OD1uwI9icPsh08y/bUAMHH4joEgWA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NL63VFF1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3CAg5aggKCFU6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3CAg5aggKCFU6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490ace40f13so16605105e9.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122505; x=1782727305; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=acHa8qzGpYOuvZT+OpZqGrTA/yeCpJyZkBIOAz883N8=;
        b=NL63VFF1Xpp2Y/hReJRw/YytOzApauV2ZmVrvaV/J9FeDRCHZ/l91o4z2/f0SsVgP+
         hO0pC452q8blIrQ0pB3O2akyq1TZ2FjT8/mMAFRHPPOsJ5byUpXh/VRGSqljxBzmOgAL
         fOIbKRdc6udS9zORDbgG/0vMQYWyiCBA1brV4VFkLzL0BZ90bpqH+FTE2WOUpGjbmi+B
         ani5towFnl+bz8DvEQnq/tPa5bcgyW2h6uF732LkxCJ+iEIYv1uV3fDdjWmlwBMw3kTG
         6a3ZN8jhl6bBaaouIIgk5RORQ7t6xKsm8qEOWbXcLC17VEFi5y8t4fw3jveWfPG3HA9U
         E14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122505; x=1782727305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=acHa8qzGpYOuvZT+OpZqGrTA/yeCpJyZkBIOAz883N8=;
        b=H67Y6knekxuYUry+RDon+dpOjgtLk6zJSdVDPiXjDnfhHxEK8jXehoAEOXG/Rzr+hs
         fhwKjbJA91ppz51PGqjmofV023br4Yms9xu9hgsWaIc0KFo8AUWh/TMVUfHmnkIk6Tii
         rGR0HQDAmgY/8r0dTsgycrYJzuBXxz78M01tut2TicyVrBLOYgPxv3te/eskmhBhIgr9
         tMLCBXVVk5hJzsW6ePS5EEYjcVxha7tzuOE7eBUiTsGmSzRnLSlP5nsTzNkFZRrL8X0z
         aosdX1Zs86TnbKqtItbYEkMK8Ue/SkXD/FIKbQ1/UlcxT8T5ww1cXEQsoTfVdWQHzYQT
         pbYA==
X-Forwarded-Encrypted: i=1; AFNElJ9IC0J7cmgmbgD49/FonJl+C0z/ubvWsPpuG4hW1yrp8WDkHKsWSCiKx/Atp4znaiYzI0ElV8A4yw==@kvack.org
X-Gm-Message-State: AOJu0Yx1e+2lYwVA2WKqBB91sKk1tH8vQZ/p0kgfoG5IGqSey91kurOv
	rPtNZSVzYfxo2AAsE3W0CoLudTIPl5WwVRiRFWc2beR7IW3pdwvumMnGaPy3bbrWSqXlpv/ez+/
	A4tAhm3HxRVf6Jw==
X-Received: from wmbgx8.prod.google.com ([2002:a05:600c:8588:b0:490:b195:62b3])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c088:b0:492:2f3c:d0ed with SMTP id 5b1f17b1804b1-4923f594511mr211459175e9.30.1782122504907;
 Mon, 22 Jun 2026 03:01:44 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:30 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-3-31f31367d420@google.com>
Subject: [PATCH v2 03/13] mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
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
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9F1481C000E
X-Rspam-User: 
X-Stat-Signature: wji7et94jaqhduk9cipixuy3k8usbum9
X-HE-Tag: 1782122506-953805
X-HE-Meta: U2FsdGVkX1+w+V6V6Xu6Vi1FKrwKYg6+wgnLqpYm+tPk96sAeZOGHMpYt/jZonBkjKDtacf8yrei0faWAxSutljnpFAXqqhJyT0xcla/V/TRPdWjZBMEQyij3RYlG5EQFZsuYNClcR7bFVPBXMmqsehbtwEHtAjD6o/8jj8YFpPo88lqRjTyh5CmTTeB3QM+bgb2eZMRwRdkRa0vrKS3l8OfMI7HUlLmb1yXbIW4pBFJ1AZ+v4uHPhlcqbNzO7bMMhwVcaWUULmKFpzM3kAlvxaJ43p0nOvjeGdtu11GL4MgmmLT0Bz2l8GNgKp9wYSTT60ZCb3BuQVIOiLU+HoG0eB5jIXVs7RQdFiwE0RbhgKNKCVnsRyspAIdk1GlANzjx6o1Apb9GXgDb8SXkOyDHoXpHqokzKlBAKq/e6ZCLN7IhXHJ97noU6X1FwUIgT8uMtsC1pk4uznk5yLt9O6bPSnoERoHPRmfhaKn4gczVNnzTfM4Jp/zrzi65MoBdTN2I7Oe+dZmzqkL5tbkqn2jTvANKbc02bGoWWIBZO7TgDeYfOPtiyfNrVu3lkqPbUfmP59pr5SsEMJVBx2Y+eOszQGM/0j/YS1+HLNcc/3soH+RTI9mpL0NVQuD0zYLX8flkjnsuyiU0ws1LxaNSs8Gt/8AAbdTUaH3cCJEmNwCwSZN5DN0Ug5AQAAPFqJt96Jdl9t/Qz7iWSxoLzx3+K1S8+CDju79ZWpZrdo8393oZjNWszEt9BeuBJlkEQzZU20+n9hP3LEC1x38wKqbfjwv+zGV5QIvG37kDL08b74+w3CetMRx1Qy75PCPuP7ASUFOjaGeMj5VjiinHpXXeqz95R0ZOnUgMFgZnriG4VD1hGjqIvGTFINqVhvSfinzJYFxzfbph6dS78DVVzA5e5lrxpyy7J/0xu7GRbrzBIc/v0swIENPkdiPMJ3qdrJWnmSnwo6R71JsvixwUTdtJcF
 2kxFXjCW
 5J9VmP5Z9NIh0kupgJUC/QRwmSLsqs6bwJtGsJoPu4P1duwTvhgM1+Ekr1H73JXLiq37Swx/f9upxCvF+6oH+WXpXam6KUoAeP1KsKb/17YiIHj2n8RmMgtbiY8EPA4uiSmTXH2/ioDmhAoN266vV1cfEG6c2rXwVSKAVrGuPJDgLZWVggDFx1HdJunSmSCFHkSo3/jSP5I4OHWTy9iC+d1BEv5Yzo0TJWhgp+tJTIeQMxMoXYVGHb6HffT4/31pNstE/murqGJmnYn2DiOXWVS3HDZYD0I0IU5bVtfFhkWtXsHdcCJ+m96RCyN0EIDZVsVZ2U5QroEH4AM54rWSylgfGT7aRIe/ohx9SDXPK4n7fUx46+H7VxGQ+tm8XD6X9e5o6e/HkxhoP0A48ydQ65kyaFDG5qEQC4u5Ol0pzXipVgYSqnoeNpH7dR1rkqkutHbK+nF/BSgMJ2tYWMSGHQuwVdTyoJKYJlOQOyi7tQ0SH0zBkqVLBz9qWuoIo1tATebT9eRJv6RjqA6QnOClLFL+T4sSk0mHrtD2hcbrwBghWd/U+NNlc3edWFcyNvvabJLm+oySzkP5i/K6/02YsvxN+0Svwyl1Q9OOVLbs/V7ujYrRTQckh53Gh99w8pWim3TsrSDwd58Ubt3ujuoy2Wgzl/VAAEJDhpcHXhm3RCXDS9QUiJJMLhmbHDw==
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
 mm/internal.h   |   8 ++-
 mm/mempolicy.c  |  10 ++--
 mm/page_alloc.c | 178 +++++++++++++++++++++++++++++---------------------------
 mm/slub.c       |   6 +-
 5 files changed, 110 insertions(+), 95 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835e..2ce6169ca0dfd 100644
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
diff --git a/mm/internal.h b/mm/internal.h
index 1483a4fcdfce1..6bc89ec62e527 100644
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
@@ -924,7 +924,8 @@ struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
 #else
 static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
 {
-	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
+	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL,
+					   0 /* ALLOC_DEFAULT */);
 }
 #endif
 
@@ -1440,6 +1441,9 @@ extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
+
+
+#define ALLOC_DEFAULT		0
 /* The ALLOC_WMARK bits are used as an index to zone->watermark */
 #define ALLOC_WMARK_MIN		WMARK_MIN
 #define ALLOC_WMARK_LOW		WMARK_LOW
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 36699fabd3c22..40bbea614aced 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2425,9 +2425,11 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
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
@@ -2475,7 +2477,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				nid, NULL, ALLOC_DEFAULT);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2487,7 +2489,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, ALLOC_DEFAULT);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bc05d75a41627..e31babe2181a1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5204,7 +5204,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0);
+		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
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
@@ -5291,9 +5365,9 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 */
 	fastpath_alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
 
-	/* First allocation attempt */
+	/* First allocation attempt (or, for nolock, only attempt) */
 	page = get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags, &ac);
-	if (likely(page))
+	if (likely(page) || (alloc_flags & ALLOC_NOLOCK))
 		goto out;
 
 	alloc_gfp = gfp;
@@ -5310,7 +5384,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
-		free_frozen_pages(page, order);
+		__free_frozen_pages(page, order,
+				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
 		page = NULL;
 	}
 
@@ -5326,7 +5401,8 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 {
 	struct page *page;
 
-	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask,
+					   ALLOC_DEFAULT);
 	if (page)
 		set_page_refcounted(page);
 	return page;
@@ -7856,80 +7932,10 @@ static bool __free_unaccepted(struct page *page)
 
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
diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d0..b9c1284844a0a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3275,7 +3275,8 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
-		page = __alloc_frozen_pages(flags, order, node, NULL);
+		page = __alloc_frozen_pages(flags, order, node, NULL,
+					    ALLOC_DEFAULT);
 
 	if (!page)
 		return NULL;
@@ -5236,7 +5237,8 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
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


