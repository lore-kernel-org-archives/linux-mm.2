Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FA7ACD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 01:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FC46B04EB; Mon,  1 Jun 2026 21:01:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028636B04ED; Mon,  1 Jun 2026 21:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F376B04EE; Mon,  1 Jun 2026 21:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D73BF6B04EB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 21:01:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DAD21C0123
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:01:49 +0000 (UTC)
X-FDA: 84833170338.07.73074A8
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id AC01714000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:01:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Er+P8U3R;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780362107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrsXZdY1nVR5uNW3w94+wDeXUMKPrhC2a6FwxCjw8mM=;
	b=PDXk73XB5XW1yMlqj/L7qrHmVajmP6GtdgR3wMdiXe0T0QkP+GMXo0CkYSq5whGNVPpOSF
	9+Cq6C7i6H0nOBTgy4puRzKdwQdVLW92Z/Kz00DMAZx0TC6627Vx0SSC/0RmftuzfUC0AW
	Q/eE3cbPgD01Uq7lv3UoI6cgO4ABU6Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Er+P8U3R;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780362107;
	b=MGgX1AyAOkmahPWB+1LOMtiC5t24UtU0F/SwqM1raVq7VEYmcCV4KR/waxoKxEn/I/9Tgn
	bB0b+lINNQDoKqAk2YCKsxbaTKblIk/U/BqTXBqh8OapYxhcgaI9SyfgzV/zWLhXykxDXB
	uTv73xfY1VClAs4wucn9Gt1UtNmH+Nk=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c0c2c7e0c5so13489615ad.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 18:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780362106; x=1780966906; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JrsXZdY1nVR5uNW3w94+wDeXUMKPrhC2a6FwxCjw8mM=;
        b=Er+P8U3RUqhAPBISefAPlqKqq3Y29jsofAugMviy1X3FV8c5DyViAgsWqvfx9yibBQ
         43wRFB7u6DBdlfr4xCJ63B4QK+7EjIMkx0wi1PJyfEHFfQ6vScRVtUbuC+PNMjCcLdMx
         boQFAGIVpFuoADMSyBDXvgypXTVzZ+Wn8A+Inzo/hIws4Kn1rWey9uLHhS2mrFmKph6T
         NT3tkTWGjQrLIdqcyeDIsflfjmA8TOd6KwHDYLYeqPO6M9cWeY30jw65x/ofQ9zt0DE+
         vRVVZHlBhgCVihFKwXhk7wo53+GbyjnMcNmUkrBBk9DfAMdNaQx8uGwT1risIGqNASpg
         vWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780362106; x=1780966906;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JrsXZdY1nVR5uNW3w94+wDeXUMKPrhC2a6FwxCjw8mM=;
        b=OWbJF5j0eaN4SpwB5bl7Md2oam6nWcnvY1+HCo/ijst390/7a2TLap3FNz7e3snaB8
         yzgI098ReVP5z7ciKRzuhtgpaIsTBwovhI2tQkSKn4RiXE31S1JulCO4MlJ9w24yNIUB
         2o4cGO0qdX4lHmryG4Nf1ZvV3VNSQY/MWm3evXbQZcZkHgiYKqI4qJ1Gx+c1sL9L5a4U
         2XfM5q1kKhXQE8D6OsmxCa/SRxOrpBuuvPzcfVoZ60LDh9xWEwV1O1uhpMgJV9YSxm3D
         1bqKImVGQz5cfCa7Z74hqO8sTq4GpGukwRkP6ArDqy310nOSGhx8Kx6XT1/iY13YUtC4
         Xw+g==
X-Gm-Message-State: AOJu0Yy70Cu7YR68WRMtO438oxqKXeXIqKmG/J7Xpzj7u5kPQJNTBRbu
	hYdO5Ugv6pLgxbWxnur25tTkTntiukuWNAnHTMxtor2fJGuWcg75o+HV
X-Gm-Gg: Acq92OG7AWRqA/ci6lAVu183wlCI4AwM2GCL92jbXBggTq8pxy/xCllP3YKaBEGV4nm
	JltaBs0tRRpdPEVCJ5yT8+gY8qL580yWbiT+nFXJWDXL2OvId4VrLTaY8rH5ij9ljbIJaSkskF4
	zaFYY6saMstA+P5jFDHO9YVjMNfKxTcLdPVNLRS82eKB8qCnrKe0nCMG7TP1DcJJMcoycZ+qQDM
	fkI7FVOmuJ6zb+U0dYlhAd4NBhllzJRqvjQvNyenE/hH4C4H0UNdsKJ9UJWsNouQheclHOmfTo9
	kRCq2ZcfNWt4j/K3sQ3SxmhmH34XyaYja+0cT2f7v5oyiMjf0CLIC707jdlsumjhglWmpdgDMvT
	wywuBFu+Z5y4PvKplQY7LI8e72e7sYRZD6QgmzAiSZtvTCkFTaIqpc6UA+1UuQWIAYTwaN3LUso
	933fuj7hzYRTPoADdZYaFRK3WdwGk7oitL/zYW2CkmiofTNVOudH75dw7svFwTj4VdEX3n8Ff+c
	2MHKlaOw8i/1wew+WAUsDQDhN8+n8lM
X-Received: by 2002:a17:903:1905:b0:2bd:9061:d544 with SMTP id d9443c01a7336-2bf368619d0mr156032525ad.34.1780362106396;
        Mon, 01 Jun 2026 18:01:46 -0700 (PDT)
Received: from NV-J4GCB44.localdomain (nat-hk.nvidia.com. [203.18.50.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239fd85dsm111693355ad.25.2026.06.01.18.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 18:01:45 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 02 Jun 2026 09:01:17 +0800
Subject: [PATCH v3 3/3] mm: move reclaim-internal declarations out of
 swap.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-3-5bbb567f8c99@gmail.com>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
In-Reply-To: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1780362076; l=7896;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=HBWYDSW+z+YUZNoqTlNlyOKkpwZU04CFgpqaQLuU830=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNImkGWXtB4IvSwlLDXHHY3V38iky72Z9z+v39G1qYnonJ/fDxAH7dPVJD9O+rVK2NdsAbZ2oD3
 wxdGFfz2m/g0=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AC01714000C
X-Stat-Signature: jega61np95kg5ah9nxrdjco5z659sm4d
X-Rspam-User: 
X-HE-Tag: 1780362107-881936
X-HE-Meta: U2FsdGVkX1/fyfBEx4ctlJkBooZmYWQEs1iQsCnMP/kWbkG+fZtqthS+k+YNujOPOicJ9uBMgFbbfWWqsTFCbUCX3Sa3A8WrqhhZXZzpTTUmLbUxXn0a2SSoTdtQ6U5cx4wZEfSUgh0iQN1Yjz/8RqAlW2mljGZ6rRzGtWR1cJAht9b7jD4Ug5kLZrwgHJ94v6nVCG4Ltzr6UoFFcoVtr4su4edQDZwTnp3y74j+BSw9+a1oCr6bS5gcrAVCWsvFeVhuWveM3uP7L4VczCs769PJPH4t6PDmQEt6Jr3Uk7zSx5zLw6C9PHU67AwMH+z77f4tWbX/GuP6ra8oaLcekDfd5U2Q/OBkdY3rfq0yRBwyghkrzGywj5SliEDJjg9tZ/X9sjzRarj8kKlzgK4/Jy4WWeDgJyoiD17aPGuec+cY0i8977jFt704WGhniQIsuYLt8QEzcVa1bAqUA+g60Hi35zCjqM5dNnxuuOOrobY9k99jPvtauo6x03pVMGtomL3fWfPp1K7rKam2/2JXF99xcoiIMRJKr9ntNAIr81I1WkQ6bjQ+9Z5LykW4UaLAOlPRqcg/iZSi0zM6CK4UIIrAbkigUtB5q5ydT7nKpOhRAlbeq+fsO08NfbPNIuCrz6r4B5CmnBQwk6vKrossxQsYbwSTPeESkg2/XAW4Bnj+NuObWFv45jLJ5SlRqwV5lEq5d/i0c9qBJC926hmM78NmV3J4jvynsoTDiV5Z6ts2N6fTV/e3K3A8HLMgqqAOHJcaxt/s5GVnxRrndBNumpOwilz7Aou2Hxge+OU8INv+YdPHR/AA0QQ2KQk5lXv+zGR+aS8/C7iwKH3KOS2cdRd9cgIGF7BXSCBVDzKngaubcWecOO0MPvspfAv7u9H83e0z+al4yjxt4lm8/FZ7f5N/reto7IXFEgUS18zZeI/CBGZudLlR9xjJRMJNj3g7vloiImFV2K+v4fAKmDl
 BHmd7Q6R
 Jrb+eEHEfIC6M0/hqDZzKibbKBM3TBuVVY2zmyva0xLqECiem9oZQ4SXtO9sj9EctdWT5WNSF0nxgIHg5pgzqGBWoaXs7AgqV72I88pi471Dq78TEeVtRMI530ADe1LMlLp4g5/8UvB9T1qtYcO1Y/+x5JErKBlk9TeWsJvd+8ByOYoxK2/vRh1Xu0S5pgPXwk1PongdqsSeAQyixZsDerQzeiexq59z/x2WglSdOzY9HM0IWaTL9MANU7xyNVOQfFWAdeHkYpwGevM0ibLD8HQCumy0lXXMrMXmrgfe6zyMC/LekcuYKdfvJJOFUCjG4b6SckmeyIBlJYAETHM8ocAfLI55eOmHwUUHTmcUPW0+/EKFvD+F+iLUcWRRaw1+JPbLibk5PgLmhyu7Hael/9v2Z2Cc5L60biQStO2MJennE+0x5GR1TYk3tPf+rSgRweLpgrmLkRDNRN6Zhek4lNNzUI0CDJS7taYKwjG+2U2KH2QdIRjTsjsjuZujtxqFnhOdyoYWkieTCsFZ53Xiv2Uw4Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Keep include/linux/swap.h focused on swap-facing interfaces by moving
MM-internal reclaim and workingset declarations into mm/internal.h.

Leave the small set of LRU helper declarations that are used outside mm/
in swap.h so this cleanup does not need a new public header under
include/linux/.

Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h | 74 +++++-----------------------------------------------
 mm/internal.h        | 65 +++++++++++++++++++++++++++++++++++++++++++++
 mm/memfd.c           |  1 +
 3 files changed, 72 insertions(+), 68 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5bd6f1d5984a..1ef6ae7b2db7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -292,39 +292,17 @@ static inline swp_entry_t page_swap_entry(struct page *page)
 	return entry;
 }
 
-/* linux/mm/workingset.c */
-bool workingset_test_recent(void *shadow, bool file, bool *workingset,
-				bool flush);
-void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
-void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg);
-void workingset_refault(struct folio *folio, void *shadow);
-void workingset_activation(struct folio *folio);
-
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
 
 /* Definition of global_zone_page_state not available yet */
 #define nr_free_pages() global_zone_page_state(NR_FREE_PAGES)
 
-
-/* linux/mm/swap.c */
-void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
-		unsigned int nr_io, unsigned int nr_rotated);
-void lru_note_cost_refault(struct folio *);
-void folio_add_lru(struct folio *);
-void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
-void mark_page_accessed(struct page *);
-void folio_mark_accessed(struct folio *);
-
-static inline bool folio_may_be_lru_cached(struct folio *folio)
-{
-	/*
-	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
-	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
-	 * will be sensible, but nobody has implemented and tested that yet.
-	 */
-	return !folio_test_large(folio);
-}
+/* Generic folio LRU helpers used outside mm/. */
+void folio_add_lru(struct folio *folio);
+void mark_page_accessed(struct page *page);
+void folio_mark_accessed(struct folio *folio);
+void lru_add_drain_all(void);
 
 extern atomic_t lru_disable_count;
 
@@ -333,42 +311,7 @@ static inline bool lru_cache_disabled(void)
 	return atomic_read(&lru_disable_count);
 }
 
-static inline void lru_cache_enable(void)
-{
-	atomic_dec(&lru_disable_count);
-}
-
-extern void lru_cache_disable(void);
-extern void lru_add_drain(void);
-extern void lru_add_drain_cpu(int cpu);
-extern void lru_add_drain_cpu_zone(struct zone *zone);
-extern void lru_add_drain_all(void);
-void folio_deactivate(struct folio *folio);
-void folio_mark_lazyfree(struct folio *folio);
-
 /* linux/mm/vmscan.c */
-extern unsigned long zone_reclaimable_pages(struct zone *zone);
-extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-					gfp_t gfp_mask, nodemask_t *mask);
-unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
-
-#define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
-#define MEMCG_RECLAIM_PROACTIVE (1 << 2)
-#define MIN_SWAPPINESS 0
-#define MAX_SWAPPINESS 200
-
-/* Just reclaim from anon folios in proactive memory reclaim */
-#define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
-
-extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
-						  unsigned long nr_pages,
-						  gfp_t gfp_mask,
-						  unsigned int reclaim_options,
-						  int *swappiness);
-extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
-						gfp_t gfp_mask, bool noswap,
-						pg_data_t *pgdat,
-						unsigned long *nr_scanned);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
@@ -389,11 +332,6 @@ static inline void reclaim_unregister_node(struct node *node)
 }
 #endif /* CONFIG_SYSFS && CONFIG_NUMA */
 
-#ifdef CONFIG_NUMA
-extern int sysctl_min_unmapped_ratio;
-extern int sysctl_min_slab_ratio;
-#endif
-
 void check_move_unevictable_folios(struct folio_batch *fbatch);
 
 extern void __meminit kswapd_run(int nid);
@@ -553,7 +491,7 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
 #else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	return READ_ONCE(vm_swappiness);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 5602393054f3..22c0c5c666ed 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,6 +24,71 @@
 
 struct folio_batch;
 
+bool workingset_test_recent(void *shadow, bool file, bool *workingset,
+			    bool flush);
+void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
+void *workingset_eviction(struct folio *folio,
+			  struct mem_cgroup *target_memcg);
+void workingset_refault(struct folio *folio, void *shadow);
+void workingset_activation(struct folio *folio);
+
+void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
+		unsigned int nr_io, unsigned int nr_rotated)
+		__releases(lruvec->lru_lock);
+void lru_note_cost_refault(struct folio *folio);
+void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma);
+
+static inline bool folio_may_be_lru_cached(struct folio *folio)
+{
+	/*
+	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
+	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
+	 * will be sensible, but nobody has implemented and tested that yet.
+	 */
+	return !folio_test_large(folio);
+}
+
+static inline void lru_cache_enable(void)
+{
+	atomic_dec(&lru_disable_count);
+}
+
+void lru_cache_disable(void);
+void lru_add_drain(void);
+void lru_add_drain_cpu(int cpu);
+void lru_add_drain_cpu_zone(struct zone *zone);
+void folio_deactivate(struct folio *folio);
+void folio_mark_lazyfree(struct folio *folio);
+
+unsigned long zone_reclaimable_pages(struct zone *zone);
+unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
+				gfp_t gfp_mask, nodemask_t *mask);
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
+			      int zone_idx);
+
+#define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
+#define MEMCG_RECLAIM_PROACTIVE (1 << 2)
+#define MIN_SWAPPINESS 0
+#define MAX_SWAPPINESS 200
+
+/* Just reclaim from anon folios in proactive memory reclaim */
+#define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
+
+unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+					   unsigned long nr_pages,
+					   gfp_t gfp_mask,
+					   unsigned int reclaim_options,
+					   int *swappiness);
+unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
+				     gfp_t gfp_mask, bool noswap,
+				     pg_data_t *pgdat,
+				     unsigned long *nr_scanned);
+
+#ifdef CONFIG_NUMA
+extern int sysctl_min_unmapped_ratio;
+extern int sysctl_min_slab_ratio;
+#endif
+
 /*
  * Maintains state across a page table move. The operation assumes both source
  * and destination VMAs already exist and are specified by the user.
diff --git a/mm/memfd.c b/mm/memfd.c
index abe13b291ddc..6c72fe6caef7 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -19,6 +19,7 @@
 #include <linux/memfd.h>
 #include <linux/pid_namespace.h>
 #include <uapi/linux/memfd.h>
+#include "internal.h"
 #include "swap.h"
 
 /*

-- 
2.43.0


