Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFAABC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1F26B00C1; Fri,  3 Jul 2026 08:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CAEB6B00C2; Fri,  3 Jul 2026 08:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D2A6B00C5; Fri,  3 Jul 2026 08:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C78D06B00C1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CA011C385B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:31 +0000 (UTC)
X-FDA: 84947403702.13.7066F75
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id A3F6E40007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yc6vfPOL;
	spf=pass (imf04.hostedemail.com: domain of 326tHaggKCKoTKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=326tHaggKCKoTKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081949;
	b=4vWbTRNcd5uPnozxwUa8UM1S4OSUIpKVfe6CfV38Kv1Whv91I2qrtYtHJu1eb/eWMKsMK4
	NQgbbIvoWlFZEEpI3JDkZC4QBD1HwtA2OHtWoW6UZty4vWycgUopZmrXdZaC+sZDYDIjIU
	aSXAR10QbP80XT8nGJCu51FowHpYDLA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjqMpiMEIhi+v1xNPECWvli3AP0POG8k3VRaLZYrcmk=;
	b=53tU6R9jvhygxdgREY1cmXulFIm6EG5+faS99m67vNsAs9xA2lVhxMntZC/4c7saFfdila
	Dn3+v0xHlSzV80tA//C8ZEyktTCblOybfDQRrLKNmeE7YoGnK4xsc7XQKl6Ztx1wLhyVmj
	uJ7j4hTqA1UGErReRxH4ckRdIvN2670=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yc6vfPOL;
	spf=pass (imf04.hostedemail.com: domain of 326tHaggKCKoTKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=326tHaggKCKoTKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c1280d28bf5so59236266b.0
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081948; x=1783686748; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kjqMpiMEIhi+v1xNPECWvli3AP0POG8k3VRaLZYrcmk=;
        b=Yc6vfPOLc2ed6HLuxQCxFyd9dXOv9x8w1KFapBPZP6qSiiiqFS/v71x4t/QI2a09y2
         Rp6zdDH9bL9MZccZpWKNj1bh0+Aurkjsm9eaqbDV+W1ithOMZmg+7IiO/fWKyIQ5QE/Z
         kZDzMyAqakV3nX0KEMqcrMZXfp0DryoX98QluNqkO1ymi/H1c/6fvYhS+GhAQ8F28V6p
         KttRM1c43DVGK2YvMDz4Hnn0vNCRej5VF4ZroLc5AGB/9EuCJHtWfD7G77ekPpDUjwBV
         EwYo0BHbSPmhmm2B2RJflZvIc4L3Mj7G9rp+mfs/rXZEW9WEazhEDqHrqz1FZC+sTAwi
         YoWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081948; x=1783686748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kjqMpiMEIhi+v1xNPECWvli3AP0POG8k3VRaLZYrcmk=;
        b=galxKE51k9uQJQo0Jwo0zplc2jeth0OMPdXUFo8JqMxJkhk75XOw3k6msKMyMCZ8+t
         qrWdjkrKaI+l1dcvFGHmhgklk0fKnUzcuUWaY8R9C7KBcZIzYLlvLzj3UZkZRBa0jPu0
         WQA6GDN+lsf7Q4fWISWgCHPVWXF7vDVWAaoiCaDrcJ0lLHe3wxtFVauzEpV/tG1YeFEL
         J7puz4eMYhMm7Ma98nRWymiGZITdp5Y2Jgp/socuVRCDD3RvlAWJPKPLdznFBAGTMcu0
         BgtxJehHXxUuF2uX5ww3RujGVrSKR7YqrUyHdSP1OdzCUj111UF3uj/lrwzGjQW0Di3M
         ChjQ==
X-Forwarded-Encrypted: i=1; AHgh+RrpJve2E49pyLq5l1rLcbvkr9xZJItQCE4ISlu8bRtkbH4+cjrsqIQk4eMN3K0LyGwDqlIB7guxMw==@kvack.org
X-Gm-Message-State: AOJu0YxoKi13GNgAs0AMEEd2ce8AxRvEEs5bEGj3gkvQ/ARQ9ZK07rQk
	NSiqE1ss0Lyzv9HUDIY8UnJy0agCs+oR5OuEaHXKHcVZJ+ETyZ+8hYaomYYrq6Pychu42xl36ML
	RAUnJbwXBdGJH/w==
X-Received: from ejdj17.prod.google.com ([2002:a17:906:951:b0:c12:8a76:87bc])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:261a:b0:c11:f4d6:48fc with SMTP id a640c23a62f3a-c12aa336682mr327263566b.45.1783081947831;
 Fri, 03 Jul 2026 05:32:27 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:47 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-7-c87b714e19d3@google.com>
Subject: [PATCH v5 07/18] mm: move some stuff to mm/page_alloc.h
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
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A3F6E40007
X-Stat-Signature: t34njhf1hgjaeyxffeu4xxp4g7nck173
X-HE-Tag: 1783081949-433557
X-HE-Meta: U2FsdGVkX1/j78g8yrlgh/X7XjEGhOy3NdS9VEGyQgHJF5zAy9F9dD1ZiUbIzc/z6B3pGJuciFdra1QOt1XRnjwrzqz1uc9Qn76HTSnyh52PTBgilvK/BlxYONA3vDVvIY4EEBkFwYUfijLViHF7KPkcO7IMvyGCANObqnL3BRiP9uM1206NNDM3f1o4kqBncxWCDqHDcieB7tzezSP6dIxZhNQsJBJhh5nqvmy9321ULjOtcjYiKMz87idjL85c0T8ZoGsMb4HcUyNuuatxmm2WCNwNZ/ShiB8/GTyesQrj+ylnm+SgaMT7R0Y0xUeyTbKNXrzX9Du+CL9U66hlnVGrfQR3kiXJ3ovWfciGAN6ihTWmNmh8gZljBORQQmBcEVFyvVtRQXtqv1thzgJtcWYAE4JteTNXEFtkCuxJMoONwsB+sBKk1LNoY77SXPIjAZLW7Ld1XWxa83plBdRNmCC0sn+Q4gJ8liYBA34T8pT2dg8Mc/nDyMGcMLEBt/AaxiYAiO1uB77n1/dOWFTZQ8VugUsKPrEyxGHqUxlX5qvSN4NmOm10LuQgUSKY1ZB9W6lW3v9gPSN0KxweJrT56BqkInu6DcK8igCVUnnBLunseRtvV3d/UneFzvzn75BkeKPbCFNVyZ0W5kw7Dj8juzF7UIXUyTCT2ebviehVikKmZYELIwX1/4wQzn/ITcwEHkOS0zGA6ZnGv6+NAv8aRKYy5eGYWqUCuPLSJQtssAPXILMnELBR/vF3/vFiGTSMpQO12WP1glGiSCC42j3YkErwyHKx17fcrMa5pRdAp/AIrYr0+0E+KlYfWFnxRz6sByK6vtOxUY4hJIrI4UBrMzUTbIAUCvBlPxtdb+biqgHpCfEJ0a5SoFDTo3qbYZtIClNytOUj2mcOmhsHPjrZtMNGsgQMORpIi/Duc5Tu9HGtPyG/YBWgJkK+rOkWdYHYMjm1Jf/wXlEFGmrdGTQ
 xvvn5QD3
 hWX3q3A9FepZj9xJvyte9VTrf1H4oQsHa3yizW1gEfTsCOTRj9DwjZqoW0MCipO3t1B/gjtjYXicbtBYHj100M/QRhvK6cYYZM2RugMY/bJtxz7aP/VbvqJ4Aj0cDVLPuZfhUM+YMcoKs08XQzl9y0V0CaHvMCCpCmceZ9MpdqNSRL9fB/dP5VyFQX9NIvM4JT9QOci3lGizc4wd/tK+ixiRE0PO4RYAiXcJRIPGFtNn6IjHn0akZogMU0xxzPtrX+O0ywV0X66DoGjCB2I0dCmjhN0R2xNhHM0bIdfxeTOGITbmFQzaHil8zq1NYI1+/nLjnedZlfkbMhCOqhiT6nSZNiCQcdxLNQi+of/4gZCITrnBdu8kVu/WeplILB6MDXXce6npRQ51ut+fvKLqPLWbOQlbYAEzQXpOJS6M6Vmp+A3H+Vx+6Rjb0SRQUmeThZH2P3SyUhNDarsNX0f+cIHEwU8BPfPveTd1wMwQ/7Qf6nOWp1ygz+xXZEvz/k3y9TGU+U4xok/q5XuSLp0ogbruwywiIhX4L2EBaeamCYPRuhb4D7QlzEOXMMciG/GV4zeOcW/r9BbJIEB9j5dAcdqkuGi4mpRkBhSARr5Hj28uKSKV9Gi4WnCbQCcALcN1MFyjcqxQnwuxRa6CCQWMS10KdtsYetW3BUQ+joPiMHtQvb3qS23iO0jTE+SMJh5HQiaeIog06lHzUIHM=
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

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h | 26 --------------------------
 mm/page_alloc.h     | 27 +++++++++++++++++++++++++++
 mm/vmstat.c         |  1 +
 3 files changed, 28 insertions(+), 26 deletions(-)

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
index a4f4b325381ad..2d60551b4453f 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -266,6 +266,33 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
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


