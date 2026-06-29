Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16595C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB376B00EC; Mon, 29 Jun 2026 09:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73F96B00EE; Mon, 29 Jun 2026 09:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE0D6B00EF; Mon, 29 Jun 2026 09:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6432D6B00EC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D66541C37C7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:28 +0000 (UTC)
X-FDA: 84932989176.13.9E8DAD0
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 266E54000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="N/mMNLl8";
	spf=pass (imf01.hostedemail.com: domain of 3N29CaggKCHgfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3N29CaggKCHgfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738747;
	b=qA4gxzo8hTBxv/ae73B2py1ehSnGqOnSTJH+qdjnNBXTdkORKhrsrYBkmSTTeg0CBmWLfA
	ctFblOv32YbIY8h8ajK+bHcpQF10QXbb7LR8xCWA6URBpNAhYgXDB8spQ2IRhpm3W6ybyL
	BLlq875430/jvYHv5NSoXGoMh9ptQcM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2Xbl3DpTg332+B3HXNH9gd21p1cWVBDgn76IACGTuM=;
	b=J2Nh5aAVu3oOsBRhrfMuP4xrDcsAJcjlIeThhEkW0N1BCopxM0vySZmskVdMl2AEFJjnm+
	5qOyzdSP30lOY7fiax8R/si7mWdIcRXCRwlGNuUPC/eOMtTNVHMNW8RMJrdAfXXDcgGfvl
	DVBqvu+O9N+UaEihR2cFqhx/qSocMkY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="N/mMNLl8";
	spf=pass (imf01.hostedemail.com: domain of 3N29CaggKCHgfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3N29CaggKCHgfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c1263968a24so78939966b.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738746; x=1783343546; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e2Xbl3DpTg332+B3HXNH9gd21p1cWVBDgn76IACGTuM=;
        b=N/mMNLl8hI6B/w8sDkyKDCf+P3wyiyFiXGI5gr4fU2eqiwEPf6n9sXv1NqiD5AXZIE
         hUpy4cHQpUypdagOl0gKN1vEJwa6bZ60O7ViySyMd7a31QJKM2h1lNl+lcnuKacDhRoQ
         Q0auAkDEddTBWiML/rRGgtZLjybaUaAs51Tl5J/58XNq2x/F2UEYadSKlj/y7uv5iM5B
         INStMq6xf2J59LGpIfOEld6VvPGMpD7sgWjDziDV+/qCqtrhsIHu5F9ox83OZAXc/F/m
         7pKKhV4+500J5dGmz05b6v9eG4Y8GLRw6I4Sde409yyDXxvdvhGu5DI9LeJehNLIN+0L
         4cyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738746; x=1783343546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e2Xbl3DpTg332+B3HXNH9gd21p1cWVBDgn76IACGTuM=;
        b=fLH+bqq9q5FEh12nA3WJUAqTguewu/Oa2zhsskZz/wrRuiBWZkOgMuAUMZ+zzRanUY
         IMXvMvEA+b4+Ded0hXWtrQW4oRxZQ2lvnQ3MLChIKwyoz0JsMNFcTLiG8MVDbiV9N02J
         YlJq7u9LKUW0PpA2FDiX/D8ArXNSrSZdyTAUBAnabKPGsoe9vC1IuA7XmySEH+bj7XQk
         DlnjiZ551DercgznL9cH7iz86NotD1bYmp+y4UUtFaaUlimOw3hbN3k+tLZ6dm6grQcH
         gLVBnk4Jkftt7uOUA4jQpP9L5DVwcNvr2N9Qj1R0BI8j4PNYc2KWvPgdaSSMgH3dS1RH
         UjAQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrl7u64yq1HqnUGYPcPYYMkAgWIzWju+Y8t4ahex1pwGRyvj4qdQ0erd+qfCnKl18vWlTmcn1+XJw==@kvack.org
X-Gm-Message-State: AOJu0YwzSUUDTRgElI0T7bp5p/p5wu2j2/8xJha3skc677R9lCTbnPus
	CjY/dVNo8vi/fYesS07n6Uq8YT1rDjOxaqk8fM1gU4MnMHCZqi+Dj39mLj3ep7gYFsZ9kkPpnhl
	MnU7uC7hg4ISD1w==
X-Received: from edge12-n2.prod.google.com ([2002:a05:6402:a54c:20b0:698:6fd7:ef0c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:9f8a:b0:bee:f541:1dca with SMTP id a640c23a62f3a-c1205eb8582mr908967466b.28.1782738743913;
 Mon, 29 Jun 2026 06:12:23 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:56 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-7-57bef0eadbc2@google.com>
Subject: [PATCH v3 07/16] mm: move some stuff to mm/page_alloc.h
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
X-Stat-Signature: 4i7eipyow6j43wa5d8sso94hs8whauzx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 266E54000B
X-HE-Tag: 1782738746-484533
X-HE-Meta: U2FsdGVkX1+0aCBkZPhzIZaC4aorsQGgmUSyJ+tWf2Jz5d1uqiRyXSIUOi9WLmHIYaeC/GfeirsGyWs6LrOE5qTqEdp07ujoGpz5j1kAyeMKz+2T7E1nNDZXzfgcPIvffcsqPLpwokDT0fiDNQ+cW0WS+WSwigeAZPaA/f4UawJMuNdG8KEkgA/Js1CUntYylfbM5sedXOEaNAWKQOaWm4plPk4Rz6M5oC2/uwp1YN42O1vRtkmhPcptX1Q3VcV4Il2w/CE2kVLn+bf9+TQ+qI+MTJVD7OBFShsgHLo3vzwM3aLJ1ti9tMWTSTisxA0HwJSjd+a/6S9zyBOopAcUuCSVugnol4fG5CIzWKGlBQACel8J0a/SpDRTQhIdx9mw5Vx/hUG0LpqEOcpKRrvQvlBexh6w8hGOa+8sq1n+akSg7dUM4j6R7fweQRBCnXC30Hhk17xv5RIruu5kdimtnNYG2SA69NVQoThITqmXhi/VepfWf3Yh5pw5mk5gtDkHnrXbIUDJYFzr7M95WwMnT9Cz147w8S52wps9dhjJKLgErUFmYlBuQqHDb4X9Bn5p3Knvqmsrw/IC70UQ/zVe1O/TxuFNAivE3ugxVNNzBb+cyvZfUyozEHRFbCS1x5TeIJ4VVK/M2feOwwOPuRc+JjiOEynTuKxiiAQUOgqjN2B4fiOql14byEMucPZA8LtRmyb0rI64mpNy9c0l04HFiw+g1kl71ZAhMaiwTpcvRRUzA6olc0OJWxoyXQMuPxKHNTDRcrOR66fbpEaaKFOgIvlZwbwUnu4fwJwNg99xMHBHkVCDPHjfWFkiR/BDV1QeEFBk2Y2G8QOTVDwUvM4Tsbt/5NjuxknHGEaHMjr9A5NAvD3UVA+9lMZAeuNFlBD9Ic2dZpNJnaKjcXJkjmg/AYmrlYsieBwrDmeyAZG+C43PGEVUSUjDYSw24DzVwIU7JhyVaNcgprj8sZwhODP
 rTDW9ghF
 QkvGlH4vRqEG5ggJQM982Ol98AQBWBlH1f++fYSRfngfSSykbbWfG4PoBObcncLUsuSjxanvu/5irkgHIkGFneEPZV7d3sSz+aQrbJQ1vGCrHnxUGt2q9mCysCjqPrKIT2x90v/6xnUiTPlcM9vRsevLiS0UxImeUX5csgAAtrZCHqENTHXtil2Z0rQ20rWRjhZ4pgs4VeLjop2sm3P+snck9WyCFYcuWgkYbDzVkx+Vd6QFBekZUKJpkadiXrhjy/XaWVTdKXqqlr+jeXeBRzZ3nhUEcf0GlQdhHMo1B56ve1kkH7LdD0AwYpnhJ3RASmREww3J0+VUPsHCoR771hcOIXmUkatxcGs8RedYRIe4jEDsLl/dc6f4yeeiYX/34z9DN2jhMXaLQoCRayiqFhS3LD+PVgTpyFN3smEJoEkwx9hS+Ro05xBVMJbKXikKs46zH4s1f/O/OlL+kHlpKfiZ0g3zwBDzV5Be1OdwXSy+nE5uT+X/aUa/sUSUzEk5jJSgX2xTrxNoEX5j86EoaiEmktfpHfIrKU3w+/iAVoGQKARXLAPOKt+aXMLHUgqRWW2qLWn28zP1xaD94pkJBCRNlGVFmu3KhXt/1uh0nCdWu5+ROXCjdX8gM+9aPduWFvSirXFVZmXyDqycaeXCByl4AC7QQT8nZyqZM/KI0qtisyrtkJrL7RRFj+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some of this stuff in the public header is only used internally so
shrink the scope to avoid silently growing new users.

drain_local_pages() is still used from kernel/power/snapshot.c so that
needs to stay behind.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h | 26 --------------------------
 mm/page_alloc.h     | 28 ++++++++++++++++++++++++++++
 mm/vmstat.c         |  1 +
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index cdf95a9f0b87c..01d6d2591f49e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -17,28 +17,6 @@ struct mempolicy;
 #define __default_gfp(a,b,...) b
 #define default_gfp(...) __default_gfp(,##__VA_ARGS__,GFP_KERNEL)
 
-/* Convert GFP flags to their corresponding migrate type */
-#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
-#define GFP_MOVABLE_SHIFT 3
-
-static inline int gfp_migratetype(const gfp_t gfp_flags)
-{
-	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
-	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
-	BUILD_BUG_ON((___GFP_MOVABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_MOVABLE);
-	BUILD_BUG_ON((___GFP_RECLAIMABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_RECLAIMABLE);
-	BUILD_BUG_ON(((___GFP_MOVABLE | ___GFP_RECLAIMABLE) >>
-		      GFP_MOVABLE_SHIFT) != MIGRATE_HIGHATOMIC);
-
-	if (unlikely(page_group_by_mobility_disabled))
-		return MIGRATE_UNMOVABLE;
-
-	/* Group based on mobility */
-	return (__force unsigned long)(gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
-}
-#undef GFP_MOVABLE_MASK
-#undef GFP_MOVABLE_SHIFT
-
 static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 {
 	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
@@ -395,10 +373,6 @@ extern void free_pages(unsigned long addr, unsigned int order);
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
 
-void page_alloc_init_cpuhp(void);
-bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
-void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
-void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
 
 void page_alloc_init_late(void);
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index e16f905f859a7..af83764788b96 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -266,6 +266,34 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
 	return list_empty(&area->free_list[migratetype]);
 }
 
+/* Convert GFP flags to their corresponding migrate type */
+#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
+#define GFP_MOVABLE_SHIFT 3
+
+static inline int gfp_migratetype(const gfp_t gfp_flags)
+{
+	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
+	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
+	BUILD_BUG_ON((___GFP_MOVABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_MOVABLE);
+	BUILD_BUG_ON((___GFP_RECLAIMABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_RECLAIMABLE);
+	BUILD_BUG_ON(((___GFP_MOVABLE | ___GFP_RECLAIMABLE) >>
+		      GFP_MOVABLE_SHIFT) != MIGRATE_HIGHATOMIC);
+
+	if (unlikely(page_group_by_mobility_disabled))
+		return MIGRATE_UNMOVABLE;
+
+	/* Group based on mobility */
+	return (__force unsigned long)(gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
+}
+#undef GFP_MOVABLE_MASK
+#undef GFP_MOVABLE_SHIFT
+
+bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
+void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
+void drain_all_pages(struct zone *zone);
+void drain_local_pages(struct zone *zone);
+
+void page_alloc_init_cpuhp(void);
 void page_alloc_sysctl_init(void);
 
 #endif /* __MM_PAGE_ALLOC_H */
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 7b93fbf9af092..3b5cb1031f720 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -30,6 +30,7 @@
 #include <linux/sched/isolation.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 
 #ifdef CONFIG_PROC_FS
 #ifdef CONFIG_NUMA

-- 
2.54.0


