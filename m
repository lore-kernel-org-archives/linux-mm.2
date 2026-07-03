Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2DCC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79866B00BD; Fri,  3 Jul 2026 08:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB476B00BE; Fri,  3 Jul 2026 08:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7CDF6B00C0; Fri,  3 Jul 2026 08:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6547D6B00BD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC7E34050F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:26 +0000 (UTC)
X-FDA: 84947403492.25.5126422
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3307940005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hi1IPVgQ;
	spf=pass (imf17.hostedemail.com: domain of 316tHaggKCKYPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=316tHaggKCKYPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081945;
	b=cEW16VWrI6jITarFGEXH/Yo7aafJXJPrn8VFxDkY/8ODcp6tqFNjPYN2ebmzIC84bNpmXi
	wBHHVCbokQ4NAWCI4jH7KBFQ9PEvLdcoRdzMzuujf6PUPgKFWhHs4EQVDk1uTGz6/jc9hU
	Se8ZWARaqEylOtcElwwLn3l8DLAgskg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUnNpUukuymSTFvRpUcQ35zNWEHRqSZxeqi3bACGffs=;
	b=fEtrvAWyAz9kqDrzGg3zHfz3B4CInR0mwD4rjuJtd8zlWWkLbphtWcI0+FzaTxRY7irEqx
	C8Zc78dS7G12QQl7hhkFhFaF5BGVh0bhsf8BbZw9kvrdwPap8EUqRixERuPnVhGasOQEbV
	3vlNOeISWfc9EyejBphnG6+a6hcW9SU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hi1IPVgQ;
	spf=pass (imf17.hostedemail.com: domain of 316tHaggKCKYPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=316tHaggKCKYPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493c619bb52so3719825e9.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081944; x=1783686744; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lUnNpUukuymSTFvRpUcQ35zNWEHRqSZxeqi3bACGffs=;
        b=Hi1IPVgQM8QV/RCQQnpiYxglLKJMuqmlS73zlOEosSPQHue4es2gXl8OKJAXYKnZmh
         JDLxtstit132euIgPQzojn5pMFoUp9BxyTLrWVK4dwMoAh2nBq3MwbpPflV6wsj1Ae08
         WSaf3MQLUYHo3JuJJE2njTZvjGIWmI8Y+JfrTY9Fyd4zd7R1Bgw40T8AI1efLskgJrxp
         O24cRoRRGGU/TFXzbsNbnyKq66CQsWh6sUXrQ7E15eYJ4OFiETOe6b33/XDMsFVWWUJb
         ABNWrr3jf8iUubt96ea59X+I9gKHZe3PED6IqffdeTlTNG/c8rAZwetj/QIZsbuUMI9f
         GEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081944; x=1783686744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lUnNpUukuymSTFvRpUcQ35zNWEHRqSZxeqi3bACGffs=;
        b=gGC2AZ0nnlULhdPOfZctPh592Rj3ZAm9884nchXTuDOHtQreEv3hufNqo/2oanWZY8
         qfPpEcbIa35HJnpVEBWzLoUx3kaPmVHtS83QWBeQA80lRkbRt4AiypKJJCbNUpTfjgnu
         Omo7278p720dIeBA7kHm2LAvNgtClC4rXjGthE8uv/iDYBeh+Bl0RbezGmHalJnE5MZW
         SX63hgwhaL9BvB6z7q/LtsiGkeytMMQPVXl5MMJz5I5XyWqRmhGDu8tRWCUpGUcNnEp5
         44WDD0zkYEaZNpP/YVjv8ko+fUHYXtU55bfKZ2WZb+g4cUfz/mbcYHzKekNpucgzMg4g
         QpIw==
X-Forwarded-Encrypted: i=1; AFNElJ8+ksfQnwe9oWYJZLIJLxYdUhUHGBwo0sdCExQcsSIscxmk3KBzcCoH5LJv6lmLZO33u/Hp3MDw4A==@kvack.org
X-Gm-Message-State: AOJu0YxnesWm5Lun4rWZOnDViEbv7ZLEnxS98OWuK3t7z4+23m4+H+qw
	ffl8V9VUCmJSp0A0wAvZFxJGn5ll5JultpewV+nb74hT7iAGAysP3EbFHztk4YDjBvQqB83EWXO
	ddH8mxlXk1GK72A==
X-Received: from wmfv21.prod.google.com ([2002:a05:600c:15d5:b0:493:b734:b4b0])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b16:b0:490:d354:bcf4 with SMTP id 5b1f17b1804b1-493c2b97350mr137126425e9.27.1783081943389;
 Fri, 03 Jul 2026 05:32:23 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:44 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-4-c87b714e19d3@google.com>
Subject: [PATCH v5 04/18] mm: Split out internal page_alloc.h
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
X-Stat-Signature: 5mwd1k8uzumkfnhq1ofzyg1w8unz3jif
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3307940005
X-HE-Tag: 1783081945-730578
X-HE-Meta: U2FsdGVkX18XdqZ/5BzkI7OPoVOsQywV2gIyO/BrC3LHJcT9lIPnJDXL9u9OCPSuvln1QWI+n9wRoTNZFo9D5hSm/ghnYobyz04c6RvKT2MN8nu2ucFYRRSFc5wlG//kuIv8Ev8JCi4XrCdjuy7KUxUG+ZxP0VSFeD3rpZOVoLAf50gWP/G2DAYqGykcyuvko8EhhQFGxeq52Q9rVKdCSqG2iBHPRHSC0f90eJ6zKZ/Ki2cyfOwGSnAUbGOigxhXtu3XqIpk4odt159evjEb745EWNtRHHBxby46FbqOQEtZbNSeGioucbDTYYKwowcqhagFer5rnp7ApVVMRhwJ4v/dIaJ1tKftTgME9dHKm4sRf/AStlYHE/k88eniDiV4eICfQNEQYOzkMva9t9kuU5autJJ39nVvXy4mBHuBR/k58vE8jzuoDuu/cTHx3hcqiWyT6zkee6jdxuPDiPdyfR4Nc0ZNmMrjJXwKJIGyXzOoH2OQQpPAH5Y2Mh0KJJ6+B8z42VK5LTMMp1LfS5YN9izS7d79ZjaxOX3ipgSvm2I7tK+EeGS24I/1xuwgJTYazqf1SoUrzlzLJnoKqJ3gAbQ/HYI62joLJmbz9FOR5Un0rhjjscOkTNYhl7NZ1BiEWlnjC0OC8J04SOXNzOYVspbkBsyfmCWd+Ke2uWk35S5OzhhOaDJdss4rl7x/jQDViOhZbDJS1XgTqQMlb3Qn8c37+aIiBUteefKgfOfOekZLd4xa94sw/usHesjquHho0XZ3d3YigUrdqHQ6cKpYUwSdsysa9LWsG2yNoWTDyCFXz8rzKnSXpoCq5TXNuc2+tLygrnkHoeSXkvMY5xv71iqrpalGeOYH5CE7uUT1nlL5BkfS+l2NEXlMHv56iUyRMc4Sf1Z/ABcsNbPCA+1cG7i3BeEROwtfN7lKFLsnq01ZvU4Tx6eHA9WZs6aaxbKggTddD3zdExCV+7BbcmU
 xCnj4e6w
 XhNmd73+qtDvxbDPtvReSYl8LD+PLKvt6ZtN1ThX3Bc+pezELPlc0zgI0Nee+UEJ4Ps8JgAeYis1SVMUU1UQc9jBYgU3YNUIvyUWukgiAvG1N5BbgBXWexmFemYaMBRwLCh00GmcRH1huDkop+1YSpWWpsSqllluyJohOzuAGEtnO9rrr4L5Ebzyb8obRlnTXoXnskJ0o56PKC7d7sxP5pVz4CS4JxHxI6c2k/fg2cJv8lD3UbQ1n7WbOfREvRqoG4BV82sLubP8F0rLyyhNzPPQ655mFBRqmJuwCqh4tqDjRJ1iu/QNJXxmhC7PmKID6sp4vErjDsfZEioMpPEtnusX61dQg0BDkxRFWZ4yl6pLwf7AypSphv48Fwr4m3vQEkh6gSgrQAVUPF+GZfBPVxj1oOYQVvcV6UX2rBk8hK92h2NYTcL64nK9HE+3dqWbEYWuTkOMbR63RcNrNUHcNBKSrzskDrKsY2FE9b/BT9InHEY1z73O7zol3GDnBeTapVWXH+PdrDslYs7wudj/8sT8TkQR6Ap4OZn8Ah5RiUe9uqIS7quK8q6dU17Hle6Aw3v3t9kvInBWfOOGbwVg48ofUWQRMr6Bl+B2JxP0X8kHIb6pwyvraAq+6liPURhXVRpKiB4/4RmYprjOKalh0HnYOmylDcWKi3oGPJ/c0x/7tDK9lXnHMBxrDX/M2u1u+O9T/mW3LFh0skkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

internal.h is a bit bloated, seems like time for a page_alloc.h.

Where it wasn't obvious, the heuristic for deciding what goes into this
new header was "does it support/correspond to a definition in
mm/page_alloc.c?"

Only need to include it from ~20 .c files out of ~150 so this does seem
like a genuine reduction in scopes, which is nice. And there's no
circular internal.h<->page_alloc.h dependency, so it seems worthwhile to
split this up before that inevitably emerges!

Suggested-by: "David Hildenbrand (Arm)" <david@kernel.org>
Link: https://lore.kernel.org/all/41e92bab-6882-401a-8de9-154adbdcfb36@kernel.org/
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 MAINTAINERS          |   1 +
 mm/compaction.c      |   1 +
 mm/hugetlb.c         |   1 +
 mm/internal.h        | 252 -----------------------------------------------
 mm/khugepaged.c      |   1 +
 mm/kmsan/init.c      |   2 +-
 mm/memory-failure.c  |   1 +
 mm/memory_hotplug.c  |   1 +
 mm/mempolicy.c       |   1 +
 mm/migrate.c         |   1 +
 mm/mm_init.c         |   1 +
 mm/page_alloc.c      |   1 +
 mm/page_alloc.h      | 269 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/page_frag_cache.c |   2 +-
 mm/page_isolation.c  |   1 +
 mm/page_owner.c      |   2 +-
 mm/page_reporting.c  |   1 +
 mm/show_mem.c        |   1 +
 mm/shuffle.c         |   1 +
 mm/slub.c            |   1 +
 mm/swap.c            |   1 +
 mm/vmscan.c          |   1 +
 22 files changed, 289 insertions(+), 255 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29c302e9c17ba..b359ff4e0a1a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17171,6 +17171,7 @@ F:	mm/debug_page_alloc.c
 F:	mm/debug_page_ref.c
 F:	mm/fail_page_alloc.c
 F:	mm/page_alloc.c
+F:	mm/page_alloc.h
 F:	mm/page_ext.c
 F:	mm/page_frag_cache.c
 F:	mm/page_isolation.c
diff --git a/mm/compaction.c b/mm/compaction.c
index f08765ade014c..7d80735502d9a 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,6 +24,7 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include <linux/cpuset.h>
+#include "page_alloc.h"
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 391739ca7f711..0f51b36773f59 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -47,6 +47,7 @@
 #include <linux/node.h>
 #include <linux/page_owner.h>
 #include "internal.h"
+#include "page_alloc.h"
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
diff --git a/mm/internal.h b/mm/internal.h
index 1e252678bbc91..7e3b2386e274b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -658,165 +658,6 @@ extern int defrag_mode;
 void setup_per_zone_wmarks(void);
 void calculate_min_free_kbytes(void);
 int __meminit init_per_zone_wmark_min(void);
-void page_alloc_sysctl_init(void);
-
-/*
- * Structure for holding the mostly immutable allocation parameters passed
- * between functions involved in allocations, including the alloc_pages*
- * family of functions.
- *
- * nodemask, migratetype and highest_zoneidx are initialized only once in
- * __alloc_pages() and then never change.
- *
- * zonelist, preferred_zone and highest_zoneidx are set first in
- * __alloc_pages() for the fast path, and might be later changed
- * in __alloc_pages_slowpath(). All other functions pass the whole structure
- * by a const pointer.
- */
-struct alloc_context {
-	struct zonelist *zonelist;
-	const nodemask_t *nodemask;
-	struct zoneref *preferred_zoneref;
-	int migratetype;
-
-	/*
-	 * highest_zoneidx represents highest usable zone index of
-	 * the allocation request. Due to the nature of the zone,
-	 * memory on lower zone than the highest_zoneidx will be
-	 * protected by lowmem_reserve[highest_zoneidx].
-	 *
-	 * highest_zoneidx is also used by reclaim/compaction to limit
-	 * the target zone since higher zone than this index cannot be
-	 * usable for this allocation request.
-	 */
-	enum zone_type highest_zoneidx;
-	bool spread_dirty_pages;
-};
-
-/*
- * This function returns the order of a free page in the buddy system. In
- * general, page_zone(page)->lock must be held by the caller to prevent the
- * page from being allocated in parallel and returning garbage as the order.
- * If a caller does not hold page_zone(page)->lock, it must guarantee that the
- * page cannot be allocated or merged in parallel. Alternatively, it must
- * handle invalid values gracefully, and use buddy_order_unsafe() below.
- */
-static inline unsigned int buddy_order(struct page *page)
-{
-	/* PageBuddy() must be checked by the caller */
-	return page_private(page);
-}
-
-/*
- * Like buddy_order(), but for callers who cannot afford to hold the zone lock.
- * PageBuddy() should be checked first by the caller to minimize race window,
- * and invalid values must be handled gracefully.
- *
- * READ_ONCE is used so that if the caller assigns the result into a local
- * variable and e.g. tests it for valid range before using, the compiler cannot
- * decide to remove the variable and inline the page_private(page) multiple
- * times, potentially observing different values in the tests and the actual
- * use of the result.
- */
-#define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
-
-/*
- * This function checks whether a page is free && is the buddy
- * we can coalesce a page and its buddy if
- * (a) the buddy is not in a hole (check before calling!) &&
- * (b) the buddy is in the buddy system &&
- * (c) a page and its buddy have the same order &&
- * (d) a page and its buddy are in the same zone.
- *
- * For recording whether a page is in the buddy system, we set PageBuddy.
- * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
- *
- * For recording page's order, we use page_private(page).
- */
-static inline bool page_is_buddy(struct page *page, struct page *buddy,
-				 unsigned int order)
-{
-	if (!page_is_guard(buddy) && !PageBuddy(buddy))
-		return false;
-
-	if (buddy_order(buddy) != order)
-		return false;
-
-	/*
-	 * zone check is done late to avoid uselessly calculating
-	 * zone/node ids for pages that could never merge.
-	 */
-	if (page_zone_id(page) != page_zone_id(buddy))
-		return false;
-
-	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
-
-	return true;
-}
-
-/*
- * Locate the struct page for both the matching buddy in our
- * pair (buddy1) and the combined O(n+1) page they form (page).
- *
- * 1) Any buddy B1 will have an order O twin B2 which satisfies
- * the following equation:
- *     B2 = B1 ^ (1 << O)
- * For example, if the starting buddy (buddy2) is #8 its order
- * 1 buddy is #10:
- *     B2 = 8 ^ (1 << 1) = 8 ^ 2 = 10
- *
- * 2) Any buddy B will have an order O+1 parent P which
- * satisfies the following equation:
- *     P = B & ~(1 << O)
- *
- * Assumption: *_mem_map is contiguous at least up to MAX_PAGE_ORDER
- */
-static inline unsigned long
-__find_buddy_pfn(unsigned long page_pfn, unsigned int order)
-{
-	return page_pfn ^ (1 << order);
-}
-
-/*
- * Find the buddy of @page and validate it.
- * @page: The input page
- * @pfn: The pfn of the page, it saves a call to page_to_pfn() when the
- *       function is used in the performance-critical __free_one_page().
- * @order: The order of the page
- * @buddy_pfn: The output pointer to the buddy pfn, it also saves a call to
- *             page_to_pfn().
- *
- * The found buddy can be a non PageBuddy, out of @page's zone, or its order is
- * not the same as @page. The validation is necessary before use it.
- *
- * Return: the found buddy page or NULL if not found.
- */
-static inline struct page *find_buddy_page_pfn(struct page *page,
-			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
-{
-	unsigned long __buddy_pfn = __find_buddy_pfn(pfn, order);
-	struct page *buddy;
-
-	buddy = page + (__buddy_pfn - pfn);
-	if (buddy_pfn)
-		*buddy_pfn = __buddy_pfn;
-
-	if (page_is_buddy(page, buddy, order))
-		return buddy;
-	return NULL;
-}
-
-extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
-				unsigned long end_pfn, struct zone *zone);
-
-static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
-				unsigned long end_pfn, struct zone *zone)
-{
-	if (zone->contiguous)
-		return pfn_to_page(start_pfn);
-
-	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
-}
 
 void set_zone_contiguous(struct zone *zone);
 bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
@@ -831,8 +672,6 @@ extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
 extern void memblock_free_pages(unsigned long pfn, unsigned int order);
-extern void __free_pages_core(struct page *page, unsigned int order,
-		enum meminit_context context);
 
 /*
  * This will have no effect, other than possibly generating a warning, if the
@@ -914,40 +753,6 @@ static inline void init_compound_tail(struct page *tail,
 	prep_compound_tail(tail, head, order);
 }
 
-void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
-extern bool free_pages_prepare(struct page *page, unsigned int order);
-
-extern int user_min_free_kbytes;
-
-struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
-		nodemask_t *nodemask);
-#define __alloc_frozen_pages(...) \
-	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
-void free_frozen_pages(struct page *page, unsigned int order);
-void free_unref_folios(struct folio_batch *fbatch);
-
-#ifdef CONFIG_NUMA
-struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
-#else
-static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
-{
-	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
-}
-#endif
-
-#define alloc_frozen_pages(...) \
-	alloc_hooks(alloc_frozen_pages_noprof(__VA_ARGS__))
-
-struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order);
-#define alloc_frozen_pages_nolock(...) \
-	alloc_hooks(alloc_frozen_pages_nolock_noprof(__VA_ARGS__))
-void free_frozen_pages_nolock(struct page *page, unsigned int order);
-
-extern void zone_pcp_reset(struct zone *zone);
-extern void zone_pcp_disable(struct zone *zone);
-extern void zone_pcp_enable(struct zone *zone);
-extern void zone_pcp_init(struct zone *zone);
-
 extern void *memmap_alloc(phys_addr_t size, phys_addr_t align,
 			  phys_addr_t min_addr,
 			  int nid, bool exact_nid);
@@ -1101,23 +906,6 @@ static inline void init_cma_pageblock(struct page *page)
 }
 #endif
 
-enum fallback_result {
-	/* Found suitable migratetype, *mt_out is valid. */
-	FALLBACK_FOUND,
-	/* No fallback found in requested order. */
-	FALLBACK_EMPTY,
-	/* Passed @claimable, but claiming whole block is a bad idea. */
-	FALLBACK_NOCLAIM,
-};
-enum fallback_result
-find_suitable_fallback(struct free_area *area, unsigned int order,
-		       int migratetype, bool claimable, int *mt_out);
-
-static inline bool free_area_empty(struct free_area *area, int migratetype)
-{
-	return list_empty(&area->free_list[migratetype]);
-}
-
 /* mm/util.c */
 struct anon_vma *folio_anon_vma(const struct folio *folio);
 
@@ -1445,46 +1233,6 @@ extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
-/* The ALLOC_WMARK bits are used as an index to zone->watermark */
-#define ALLOC_WMARK_MIN		WMARK_MIN
-#define ALLOC_WMARK_LOW		WMARK_LOW
-#define ALLOC_WMARK_HIGH	WMARK_HIGH
-#define ALLOC_NO_WATERMARKS	0x04 /* don't check watermarks at all */
-
-/* Mask to get the watermark bits */
-#define ALLOC_WMARK_MASK	(ALLOC_NO_WATERMARKS-1)
-
-/*
- * Only MMU archs have async oom victim reclaim - aka oom_reaper so we
- * cannot assume a reduced access to memory reserves is sufficient for
- * !MMU
- */
-#ifdef CONFIG_MMU
-#define ALLOC_OOM		0x08
-#else
-#define ALLOC_OOM		ALLOC_NO_WATERMARKS
-#endif
-
-#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
-				       * to 25% of the min watermark or
-				       * 62.5% if __GFP_HIGH is set.
-				       */
-#define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
-				       * of the min watermark.
-				       */
-#define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
-#define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
-#ifdef CONFIG_ZONE_DMA32
-#define ALLOC_NOFRAGMENT	0x100 /* avoid mixing pageblock types */
-#else
-#define ALLOC_NOFRAGMENT	  0x0
-#endif
-#define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
-#define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
-#define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
-
-/* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49b..58e14d1543ecb 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -26,6 +26,7 @@
 
 #include <asm/tlb.h>
 #include "internal.h"
+#include "page_alloc.h"
 #include "mm_slot.h"
 
 enum scan_result {
diff --git a/mm/kmsan/init.c b/mm/kmsan/init.c
index b14ce3417e65e..4983b6e9f7c99 100644
--- a/mm/kmsan/init.c
+++ b/mm/kmsan/init.c
@@ -13,7 +13,7 @@
 #include <linux/mm.h>
 #include <linux/memblock.h>
 
-#include "../internal.h"
+#include "../page_alloc.h"
 
 #define NUM_FUTURE_RANGES 128
 struct start_end_pair {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4916ab1453257..bf717ec595087 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -66,6 +66,7 @@
 #include <trace/events/memory-failure.h>
 
 #include "swap.h"
+#include "page_alloc.h"
 #include "internal.h"
 
 static int sysctl_memory_failure_early_kill __read_mostly;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8b137328dcf01..11ab2f7bc7f3b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -40,6 +40,7 @@
 #include <asm/tlbflush.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 #include "shuffle.h"
 
 enum {
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index bba65898aee17..948264407dee3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -119,6 +119,7 @@
 #include <linux/memory.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 
 /* Internal flags */
 #define MPOL_MF_DISCONTIG_OK (MPOL_MF_INTERNAL << 0)	/* Skip checks for continuous vmas */
diff --git a/mm/migrate.c b/mm/migrate.c
index a786549551e3d..db50e7b66fbf8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -49,6 +49,7 @@
 #include <trace/events/migrate.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 #include "swap.h"
 
 static const struct movable_operations *offline_movable_ops;
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 07a8c74cf7ade..537664974ab1c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -33,6 +33,7 @@
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
 #include "internal.h"
+#include "page_alloc.h"
 #include "slab.h"
 #include "shuffle.h"
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index df1345cde301f..85cee8a0031f2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -56,6 +56,7 @@
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
 #include "internal.h"
+#include "page_alloc.h"
 #include "shuffle.h"
 #include "page_reporting.h"
 
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
new file mode 100644
index 0000000000000..3250d44f96457
--- /dev/null
+++ b/mm/page_alloc.h
@@ -0,0 +1,269 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * mm-internal API for the page (buddy) allocator. Public API lives in
+ * include/linux/gfp.h.
+ */
+#ifndef __MM_PAGE_ALLOC_H
+#define __MM_PAGE_ALLOC_H
+
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/nodemask.h>
+#include <linux/types.h>
+
+/* The ALLOC_WMARK bits are used as an index to zone->watermark */
+#define ALLOC_WMARK_MIN		WMARK_MIN
+#define ALLOC_WMARK_LOW		WMARK_LOW
+#define ALLOC_WMARK_HIGH	WMARK_HIGH
+#define ALLOC_NO_WATERMARKS	0x04 /* don't check watermarks at all */
+
+/* Mask to get the watermark bits */
+#define ALLOC_WMARK_MASK	(ALLOC_NO_WATERMARKS-1)
+
+/*
+ * Only MMU archs have async oom victim reclaim - aka oom_reaper so we
+ * cannot assume a reduced access to memory reserves is sufficient for
+ * !MMU
+ */
+#ifdef CONFIG_MMU
+#define ALLOC_OOM		0x08
+#else
+#define ALLOC_OOM		ALLOC_NO_WATERMARKS
+#endif
+
+#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
+				       * to 25% of the min watermark or
+				       * 62.5% if __GFP_HIGH is set.
+				       */
+#define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
+				       * of the min watermark.
+				       */
+#define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
+#define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
+#ifdef CONFIG_ZONE_DMA32
+#define ALLOC_NOFRAGMENT	0x100 /* avoid mixing pageblock types */
+#else
+#define ALLOC_NOFRAGMENT	  0x0
+#endif
+#define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
+#define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
+#define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+
+/* Flags that allow allocations below the min watermark. */
+#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+
+/*
+ * Structure for holding the mostly immutable allocation parameters passed
+ * between functions involved in allocations, including the alloc_pages*
+ * family of functions.
+ *
+ * nodemask, migratetype and highest_zoneidx are initialized only once in
+ * __alloc_pages() and then never change.
+ *
+ * zonelist, preferred_zone and highest_zoneidx are set first in
+ * __alloc_pages() for the fast path, and might be later changed
+ * in __alloc_pages_slowpath(). All other functions pass the whole structure
+ * by a const pointer.
+ */
+struct alloc_context {
+	struct zonelist *zonelist;
+	const nodemask_t *nodemask;
+	struct zoneref *preferred_zoneref;
+	int migratetype;
+
+	/*
+	 * highest_zoneidx represents highest usable zone index of
+	 * the allocation request. Due to the nature of the zone,
+	 * memory on lower zone than the highest_zoneidx will be
+	 * protected by lowmem_reserve[highest_zoneidx].
+	 *
+	 * highest_zoneidx is also used by reclaim/compaction to limit
+	 * the target zone since higher zone than this index cannot be
+	 * usable for this allocation request.
+	 */
+	enum zone_type highest_zoneidx;
+	bool spread_dirty_pages;
+};
+
+/*
+ * This function returns the order of a free page in the buddy system. In
+ * general, page_zone(page)->lock must be held by the caller to prevent the
+ * page from being allocated in parallel and returning garbage as the order.
+ * If a caller does not hold page_zone(page)->lock, it must guarantee that the
+ * page cannot be allocated or merged in parallel. Alternatively, it must
+ * handle invalid values gracefully, and use buddy_order_unsafe() below.
+ */
+static inline unsigned int buddy_order(struct page *page)
+{
+	/* PageBuddy() must be checked by the caller */
+	return page_private(page);
+}
+
+/*
+ * Like buddy_order(), but for callers who cannot afford to hold the zone lock.
+ * PageBuddy() should be checked first by the caller to minimize race window,
+ * and invalid values must be handled gracefully.
+ *
+ * READ_ONCE is used so that if the caller assigns the result into a local
+ * variable and e.g. tests it for valid range before using, the compiler cannot
+ * decide to remove the variable and inline the page_private(page) multiple
+ * times, potentially observing different values in the tests and the actual
+ * use of the result.
+ */
+#define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
+
+/*
+ * This function checks whether a page is free && is the buddy
+ * we can coalesce a page and its buddy if
+ * (a) the buddy is not in a hole (check before calling!) &&
+ * (b) the buddy is in the buddy system &&
+ * (c) a page and its buddy have the same order &&
+ * (d) a page and its buddy are in the same zone.
+ *
+ * For recording whether a page is in the buddy system, we set PageBuddy.
+ * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
+ *
+ * For recording page's order, we use page_private(page).
+ */
+static inline bool page_is_buddy(struct page *page, struct page *buddy,
+				 unsigned int order)
+{
+	if (!page_is_guard(buddy) && !PageBuddy(buddy))
+		return false;
+
+	if (buddy_order(buddy) != order)
+		return false;
+
+	/*
+	 * zone check is done late to avoid uselessly calculating
+	 * zone/node ids for pages that could never merge.
+	 */
+	if (page_zone_id(page) != page_zone_id(buddy))
+		return false;
+
+	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
+	return true;
+}
+
+/*
+ * Locate the struct page for both the matching buddy in our
+ * pair (buddy1) and the combined O(n+1) page they form (page).
+ *
+ * 1) Any buddy B1 will have an order O twin B2 which satisfies
+ * the following equation:
+ *     B2 = B1 ^ (1 << O)
+ * For example, if the starting buddy (buddy2) is #8 its order
+ * 1 buddy is #10:
+ *     B2 = 8 ^ (1 << 1) = 8 ^ 2 = 10
+ *
+ * 2) Any buddy B will have an order O+1 parent P which
+ * satisfies the following equation:
+ *     P = B & ~(1 << O)
+ *
+ * Assumption: *_mem_map is contiguous at least up to MAX_PAGE_ORDER
+ */
+static inline unsigned long
+__find_buddy_pfn(unsigned long page_pfn, unsigned int order)
+{
+	return page_pfn ^ (1 << order);
+}
+
+/*
+ * Find the buddy of @page and validate it.
+ * @page: The input page
+ * @pfn: The pfn of the page, it saves a call to page_to_pfn() when the
+ *       function is used in the performance-critical __free_one_page().
+ * @order: The order of the page
+ * @buddy_pfn: The output pointer to the buddy pfn, it also saves a call to
+ *             page_to_pfn().
+ *
+ * The found buddy can be a non PageBuddy, out of @page's zone, or its order is
+ * not the same as @page. The validation is necessary before use it.
+ *
+ * Return: the found buddy page or NULL if not found.
+ */
+static inline struct page *find_buddy_page_pfn(struct page *page,
+			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
+{
+	unsigned long __buddy_pfn = __find_buddy_pfn(pfn, order);
+	struct page *buddy;
+
+	buddy = page + (__buddy_pfn - pfn);
+	if (buddy_pfn)
+		*buddy_pfn = __buddy_pfn;
+
+	if (page_is_buddy(page, buddy, order))
+		return buddy;
+	return NULL;
+}
+
+extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
+				unsigned long end_pfn, struct zone *zone);
+
+static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
+				unsigned long end_pfn, struct zone *zone)
+{
+	if (zone->contiguous)
+		return pfn_to_page(start_pfn);
+
+	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
+}
+
+extern void __free_pages_core(struct page *page, unsigned int order,
+		enum meminit_context context);
+
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
+extern bool free_pages_prepare(struct page *page, unsigned int order);
+
+extern int user_min_free_kbytes;
+
+struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
+		nodemask_t *nodemask);
+#define __alloc_frozen_pages(...) \
+	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
+void free_frozen_pages(struct page *page, unsigned int order);
+void free_unref_folios(struct folio_batch *fbatch);
+
+#ifdef CONFIG_NUMA
+struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
+#else
+static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
+{
+	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
+}
+#endif
+
+#define alloc_frozen_pages(...) \
+	alloc_hooks(alloc_frozen_pages_noprof(__VA_ARGS__))
+
+struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order);
+#define alloc_frozen_pages_nolock(...) \
+	alloc_hooks(alloc_frozen_pages_nolock_noprof(__VA_ARGS__))
+void free_frozen_pages_nolock(struct page *page, unsigned int order);
+
+extern void zone_pcp_reset(struct zone *zone);
+extern void zone_pcp_disable(struct zone *zone);
+extern void zone_pcp_enable(struct zone *zone);
+extern void zone_pcp_init(struct zone *zone);
+
+enum fallback_result {
+	/* Found suitable migratetype, *mt_out is valid. */
+	FALLBACK_FOUND,
+	/* No fallback found in requested order. */
+	FALLBACK_EMPTY,
+	/* Passed @claimable, but claiming whole block is a bad idea. */
+	FALLBACK_NOCLAIM,
+};
+enum fallback_result
+find_suitable_fallback(struct free_area *area, unsigned int order,
+		       int migratetype, bool claimable, int *mt_out);
+
+static inline bool free_area_empty(struct free_area *area, int migratetype)
+{
+	return list_empty(&area->free_list[migratetype]);
+}
+
+void page_alloc_sysctl_init(void);
+
+#endif /* __MM_PAGE_ALLOC_H */
diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index d2423f30577e4..a1077cef3a791 100644
--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -18,7 +18,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/page_frag_cache.h>
-#include "internal.h"
+#include "page_alloc.h"
 
 static unsigned long encoded_page_create(struct page *page, unsigned int order,
 					 bool pfmemalloc)
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 32ce8a7d9df35..e5dfc7bf49446 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -11,6 +11,7 @@
 #include <linux/page_owner.h>
 #include <linux/migrate.h>
 #include "internal.h"
+#include "page_alloc.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/page_isolation.h>
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 26d6ab6530ce0..e399ebed27234 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -13,7 +13,7 @@
 #include <linux/memcontrol.h>
 #include <linux/sched/clock.h>
 
-#include "internal.h"
+#include "page_alloc.h"
 
 /*
  * TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stack)
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 7418f2e500bb4..c7325704c3202 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -8,6 +8,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 
+#include "page_alloc.h"
 #include "page_reporting.h"
 #include "internal.h"
 
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 1b721a8ade67d..d1288b4c2b640 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -16,6 +16,7 @@
 #include <linux/vmstat.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 #include "swap.h"
 
 atomic_long_t _totalram_pages __read_mostly;
diff --git a/mm/shuffle.c b/mm/shuffle.c
index fb1393b8b3a9d..82a2c7725a08a 100644
--- a/mm/shuffle.c
+++ b/mm/shuffle.c
@@ -7,6 +7,7 @@
 #include <linux/random.h>
 #include <linux/moduleparam.h>
 #include "internal.h"
+#include "page_alloc.h"
 #include "shuffle.h"
 
 DEFINE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
diff --git a/mm/slub.c b/mm/slub.c
index 9ec774dc70096..877021e69cc41 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -53,6 +53,7 @@
 #include <trace/events/kmem.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 
 /*
  * Lock order:
diff --git a/mm/swap.c b/mm/swap.c
index 58e4eff698cc4..d25131305c94c 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -39,6 +39,7 @@
 #include <linux/buffer_head.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/pagemap.h>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 56fe5393f30f8..1474a7234ea16 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -66,6 +66,7 @@
 #include <linux/sched/sysctl.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 #include "swap.h"
 
 #define CREATE_TRACE_POINTS

-- 
2.54.0


