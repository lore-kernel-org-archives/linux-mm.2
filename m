Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F72ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5BD6B009F; Wed, 27 May 2026 16:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64D06B00A0; Wed, 27 May 2026 16:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE7A6B00A1; Wed, 27 May 2026 16:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA3D66B009F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:48:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B9A9914B1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:25 +0000 (UTC)
X-FDA: 84814387770.04.12218D2
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 92B2740017
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="VwA4YU/E";
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914903; a=rsa-sha256;
	cv=none;
	b=MBc0iTgiruavppQmt43dd0eFB/16FOJdMjuRTPPgVrZxjAUlWWSGGw91LM0seCAXg3wkIk
	zCefQJfGMb3W56rP8Lk4p/t/JpEw/3K4O8QXJBcTJ7h4wdwAi8lmrWAHaQrDpY5nI8EjgF
	dfyEfF5WXTdC1By8F7Euw6QUc+aVNco=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="VwA4YU/E";
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WV+GIG3sgQzlSKpDlDd5qT1ioFws4ENdSbDD6GcE1k=;
	b=0BF+EbY4c+75v4aOeSLIsPR6iJhNZySaI4zblSu/HCm0cphBhDaY7HHyJUp3o5soD+GzpD
	viT+I+2idnCB/WMHJjMyDc46CKIy0qZE/+61RDxUSFFxMFMcsX+5g900GU+4vo2r7o9giW
	IAvVtwkyM9tGkjmy3+tvtsYTXz9VrxA=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8cc715824a0so49589686d6.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779914903; x=1780519703; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WV+GIG3sgQzlSKpDlDd5qT1ioFws4ENdSbDD6GcE1k=;
        b=VwA4YU/EXiX1YuBhs9F/BpkgqlOyKGApzhBJdlxAKw0MMyMlX9qM/SxDQlwZ2ULFWP
         ACjWFfyahl4RkYiKTgS/c8yKhQFSL1V8MM34TGGl75ZIAbGCuQ+9XuFFW18KVRACzOSX
         VAPHfci7HExFAHt7UzFEBVrc26o8pF4/EifdvWkvL3U9rRLtvS2ieD6Qvz/21Mvg/XM2
         JmdFDDLmXKvKcHSna1WfxGGfYY21b5rBPEYwOUaFeE6SNlsg4X7S/XXySVE2GrMCiCh/
         JLM8wW5S+CcrkpyrCFljeJoOnbvinXPhnG6l0FVPaAwESJffN7YMSwfxOKYKcRcP60DG
         W4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914903; x=1780519703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6WV+GIG3sgQzlSKpDlDd5qT1ioFws4ENdSbDD6GcE1k=;
        b=tZuuU0hH4RhAcLNqh8Qr2DzpmHTFzZSVmiza+bH2W97xV3J15DtOG97K6uNIPCSEu4
         JOU1YmWkHCF0DcRQehw+R71biriX4FxS0jjkNUwY6vEKKN5ApVLOP/5F5YuL2spwtqCN
         gO7vjBYCHO3kB1WJ29Dxdv5Lgp2ktFNTtCBZxYioqThMP0qsjO30f0NOlgHhye294Nsy
         XBf3Hec/MXXxhptX8AADBlJwHK0Hp1tIOl7SWq3WqmlgRQ3NR4VTdVipZ5Pz8RjvEzho
         QemKft6bO2A+veX/i7V+uoLHLLsYZSdvaZpprr/sH3EXvkjr7Xb/1DvR8s+d07MG0CFV
         tK6A==
X-Forwarded-Encrypted: i=1; AFNElJ9m9A/0AzxrA+ZG/Y/OuTuiWBPbAhwKd/wHEAZf4e3so+2ssHBKTbWYNUkLMXXe92Og2qptnD1ZcQ==@kvack.org
X-Gm-Message-State: AOJu0YxF2pgjbUB6BGNbs3HxOekhREgmMmUd5lxXDZ4GPvVfH5kLRfU1
	+hj/ahtQAYi5TLX4rR1cwDYZMpgf4fzROqtUASQlSTiZgLG/fWmYZuIJKQEr5TvK9HU=
X-Gm-Gg: Acq92OFh6Q2vLZ+pk23cWtHj9kX6rOLrWOnx3G7bohxNHzFLtoZdZZUVxTtFO6+2A8k
	i84x5BiN5elvT9K3ALwfqUwshnCoIIapMnjarbOUxWFuGnoJMLZtMp4kutlranamBB6aVueT+UK
	pgvPLUBJ/+AixuetnooljSBHS9YfQ8bUru/pASPzE2HWWSvbK4gt7rWwKFbnN9alPGeN9kf8ZWo
	W+gWbD8t8AOshIyOyGdfQxkGkAXy5OG270cT0xlQ2qVIDXghY1SNG7R2x1GHaTr33bSjSmCxk2n
	mvFV8NldpLB/rkj2CaJHANzfBq7kgXyy8G51gGltWJCBjjCTalLHf1+d/z81gvjL/yz4marThKZ
	EfdaokijmeIlzXQUFRH4DRrSHqcgkUU9Nwnf6LQ5rR6YrH1svhW4I39ZGCzUtxjIMT0DxGVo2ZR
	LtwUHZ5iMT93erocgzO6c07iTiF8lPMgQT
X-Received: by 2002:a05:6214:2f85:b0:8ca:57f:d444 with SMTP id 6a1803df08f44-8cc7b5a7f4emr119188776d6.28.1779914902483;
        Wed, 27 May 2026 13:48:22 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc812df29esm179594216d6.29.2026.05.27.13.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 13:48:21 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Date: Wed, 27 May 2026 16:45:16 -0400
Message-ID: <20260527204757.2544958-10-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 92B2740017
X-Stat-Signature: cbtto978q1f17brnju3u34jicqty87yy
X-HE-Tag: 1779914903-134058
X-HE-Meta: U2FsdGVkX18UGXswELRLHJmGIyOP+FnVy9p+EwU6LzqAKDcNFmZjyMCI4vEIEdW8kc2Bw1v9/8YZosFwHHbq3NGTi9AUawUfxroIFLYXeJatnu6WGRtYaVb42ZRNdh8RD8gGoWikx08tGq2QnzbrobX/jhLr8jXI7mgZdD7GA5f4jikVoZqApnGmEr1f3GwCko7n99zW8j7z7cXtzqH6hZ5SdY6OVPBpW+yngOa4VLT4SF5BTNygLnc1/WegrIq98LizQtdr0JYgvQ6IP8tkWeMXx1BW5wHmg7m9kERdNFbQoctGw8mG31LklJzC8GaphhiCR88JyFgXYXV/CVWKvOxIsB9l6I4sq+fLd8zj1kYL7EYkyxNBz6aIiNVDeN92lKnvnM8hEQss/ZRA+pLnOoOMXv2lC1V3YOhOcZsVMyW+brv3O+ldSDZVJGxgEy99erc0qGIg+ERnAouQbdHWHgWJjAiFoSYG71YXC0MZhPMXnvucd0TSvOnx88l3wXMZFLKGoGZbLumDUw4NArfYetJUQTE/ujek5C35JuEy5/LiRAF2LFIWyA7FOC05naJhqZUcv68dYBSWiR/CveRYGhpgMflY5Djhxm4W2daYszVMtqEJQDu35n4sosfa6mtoPfr/czuc7n+XoNaGvtn7GXxAl3WvCdE8fncZ+Dod5lwspNJzmVVf+oveALQ9zSswyLFJOoCo2TPInxO117WNyj7X6dK06kQb0FEAYChDRLq078WQZ1+yTJUtOv/ZTP1cj5TJDVPM/rjCur/bjhT6QBW+T0HknQa2KRm/RSbAAEgnacsP1zucHoPKsfZk/ZSi/BMr7VJ5DFPcFZz7JhRToBV+CoRcOlLpfyhWzthGYW3wrWqjq4lSUvZ1jNl2LWHAFz/zKTzUnANg79em4ha0ht6VEp6tvvMST2uuUT53uF4fBzw+/VvsEKpEpn1iepXHiFK6+bXHwhL488eZ+J5
 3/u+QkZX
 rjUxuGWL3YalgQ1LeWfQr9sOYqi+y5k3xG7E7mc7RuXb9YgtTm9JQEdRPpkrNxMODoE0fe9iFf1ctCnWZHwkowIhHKN31febnGqOrL+67GOWP3fGT6uP67DYkqncgFxqrsDysf0jYZ49wU8uS6laWWys4/ub4wt79PuWWCaAJmX+zdMDhZgPOtwjcTkeUwxxPQqNikbZ4VLO3Ad1EBW6X+UqChpGUtdXHeYQ3nSE+ewcJFOuvqIIG2FfUc3V4pN1fqYWLMZPCJoTx08U+K25tYVWdpipzLghFneV/ZXD9WvKFHgtz3SGk/TrrMNc4W9L/JCgPiBjNZcRKa4xQEm/XrZbI276DsM/es68TFyQW8Hn8PSBVPSnH7BB1hZCykBlgixqZyuUPjjhcd3gXpKuhjPfQ03LkeBVlJxMPvYEs+7ocoYmTGzhgPrY+67FBCgQh/fiKv1SV9S1Rxdjan8aFRbUqLg+1w4iO8Guk80H3E5dpgF4aEkTA+HX8eRTGd+4pCiS2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The deferred split queue handles cgroups in a suboptimal fashion. The
queue is per-NUMA node or per-cgroup, not the intersection. That means
on a cgrouped system, a node-restricted allocation entering reclaim
can end up splitting large pages on other nodes:

        alloc/unmap
          deferred_split_folio()
            list_add_tail(memcg->split_queue)
            set_shrinker_bit(memcg, node, deferred_shrinker_id)

        for_each_zone_zonelist_nodemask(restricted_nodes)
          mem_cgroup_iter()
            shrink_slab(node, memcg)
              shrink_slab_memcg(node, memcg)
                if test_shrinker_bit(memcg, node, deferred_shrinker_id)
                  deferred_split_scan()
                    walks memcg->split_queue

The shrinker bit adds an imperfect guard rail. As soon as the cgroup
has a single large page on the node of interest, all large pages owned
by that memcg, including those on other nodes, will be split.

list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
streamlines a lot of the list operations and reclaim walks. It's used
widely by other major shrinkers already. Convert the deferred split
queue as well.

The list_lru per-memcg heads are instantiated on demand when the first
object of interest is allocated for a cgroup, by calling
folio_memcg_alloc_deferred(). Add calls to where splittable pages are
created: anon faults, swapin faults, khugepaged collapse.

These calls create all possible node heads for the cgroup at once, so
the migration code (between nodes) doesn't need any special care.

Reported-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/huge_mm.h    |   7 +-
 include/linux/memcontrol.h |   4 -
 include/linux/mmzone.h     |  12 --
 mm/huge_memory.c           | 364 +++++++++++++------------------------
 mm/internal.h              |   2 +-
 mm/khugepaged.c            |   5 +
 mm/memcontrol.c            |  12 +-
 mm/memory.c                |   4 +
 mm/mm_init.c               |  15 --
 mm/swap_state.c            |  10 +
 10 files changed, 150 insertions(+), 285 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index edece3e26985..f6c2531a27a3 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -423,10 +423,10 @@ static inline int split_huge_page(struct page *page)
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
+
+int folio_memcg_alloc_deferred(struct folio *folio);
+
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
-#ifdef CONFIG_MEMCG
-void reparent_deferred_split_queue(struct mem_cgroup *memcg);
-#endif
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
@@ -664,7 +664,6 @@ static inline int folio_split(struct folio *folio, unsigned int new_order,
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
-static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bf1a6e131eca..20404e59fb3b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -278,10 +278,6 @@ struct mem_cgroup {
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	struct deferred_split deferred_split_queue;
-#endif
-
 #ifdef CONFIG_LRU_GEN_WALKS_MMU
 	/* per-memcg mm_struct list */
 	struct lru_gen_mm_list mm_list;
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1331a7b93f33..8e449f524f26 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1431,14 +1431,6 @@ struct zonelist {
  */
 extern struct page *mem_map;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-struct deferred_split {
-	spinlock_t split_queue_lock;
-	struct list_head split_queue;
-	unsigned long split_queue_len;
-};
-#endif
-
 #ifdef CONFIG_MEMORY_FAILURE
 /*
  * Per NUMA node memory failure handling statistics.
@@ -1564,10 +1556,6 @@ typedef struct pglist_data {
 	unsigned long first_deferred_pfn;
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	struct deferred_split deferred_split_queue;
-#endif
-
 #ifdef CONFIG_NUMA_BALANCING
 	/* start time in ms of current promote rate limit period */
 	unsigned int nbp_rl_start;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bf9b480bb3b0..72f6caf0fec6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -14,6 +14,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
+#include <linux/list_lru.h>
 #include <linux/shrinker.h>
 #include <linux/mm_inline.h>
 #include <linux/swapops.h>
@@ -67,6 +68,8 @@ unsigned long transparent_hugepage_flags __read_mostly =
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
 
+static struct lock_class_key deferred_split_key;
+static struct list_lru deferred_split_lru;
 static struct shrinker *deferred_split_shrinker;
 static unsigned long deferred_split_count(struct shrinker *shrink,
 					  struct shrink_control *sc);
@@ -943,6 +946,13 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
 }
 #endif /* CONFIG_SYSFS */
 
+int folio_memcg_alloc_deferred(struct folio *folio)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
+}
+
 static int __init thp_shrinker_init(void)
 {
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
@@ -952,6 +962,13 @@ static int __init thp_shrinker_init(void)
 	if (!deferred_split_shrinker)
 		return -ENOMEM;
 
+	if (list_lru_init_memcg_key(&deferred_split_lru,
+				    deferred_split_shrinker,
+				    &deferred_split_key)) {
+		shrinker_free(deferred_split_shrinker);
+		return -ENOMEM;
+	}
+
 	deferred_split_shrinker->count_objects = deferred_split_count;
 	deferred_split_shrinker->scan_objects = deferred_split_scan;
 	shrinker_register(deferred_split_shrinker);
@@ -973,6 +990,7 @@ static int __init thp_shrinker_init(void)
 	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
 	if (!huge_zero_folio_shrinker) {
 		shrinker_free(deferred_split_shrinker);
+		list_lru_destroy(&deferred_split_lru);
 		return -ENOMEM;
 	}
 
@@ -987,6 +1005,7 @@ static void __init thp_shrinker_exit(void)
 {
 	shrinker_free(huge_zero_folio_shrinker);
 	shrinker_free(deferred_split_shrinker);
+	list_lru_destroy(&deferred_split_lru);
 }
 
 static int __init hugepage_init(void)
@@ -1166,119 +1185,6 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 	return pmd;
 }
 
-static struct deferred_split *split_queue_node(int nid)
-{
-	struct pglist_data *pgdata = NODE_DATA(nid);
-
-	return &pgdata->deferred_split_queue;
-}
-
-#ifdef CONFIG_MEMCG
-static inline
-struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
-					   struct deferred_split *queue)
-{
-	if (mem_cgroup_disabled())
-		return NULL;
-	if (split_queue_node(folio_nid(folio)) == queue)
-		return NULL;
-	return container_of(queue, struct mem_cgroup, deferred_split_queue);
-}
-
-static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memcg)
-{
-	return memcg ? &memcg->deferred_split_queue : split_queue_node(nid);
-}
-#else
-static inline
-struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
-					   struct deferred_split *queue)
-{
-	return NULL;
-}
-
-static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memcg)
-{
-	return split_queue_node(nid);
-}
-#endif
-
-static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg)
-{
-	struct deferred_split *queue;
-
-retry:
-	queue = memcg_split_queue(nid, memcg);
-	spin_lock(&queue->split_queue_lock);
-	/*
-	 * There is a period between setting memcg to dying and reparenting
-	 * deferred split queue, and during this period the THPs in the deferred
-	 * split queue will be hidden from the shrinker side.
-	 */
-	if (unlikely(memcg_is_dying(memcg))) {
-		spin_unlock(&queue->split_queue_lock);
-		memcg = parent_mem_cgroup(memcg);
-		goto retry;
-	}
-
-	return queue;
-}
-
-static struct deferred_split *
-split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags)
-{
-	struct deferred_split *queue;
-
-retry:
-	queue = memcg_split_queue(nid, memcg);
-	spin_lock_irqsave(&queue->split_queue_lock, *flags);
-	if (unlikely(memcg_is_dying(memcg))) {
-		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
-		memcg = parent_mem_cgroup(memcg);
-		goto retry;
-	}
-
-	return queue;
-}
-
-static struct deferred_split *folio_split_queue_lock(struct folio *folio)
-{
-	struct deferred_split *queue;
-
-	rcu_read_lock();
-	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
-	/*
-	 * The memcg destruction path is acquiring the split queue lock for
-	 * reparenting. Once you have it locked, it's safe to drop the rcu lock.
-	 */
-	rcu_read_unlock();
-
-	return queue;
-}
-
-static struct deferred_split *
-folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
-{
-	struct deferred_split *queue;
-
-	rcu_read_lock();
-	queue = split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
-	rcu_read_unlock();
-
-	return queue;
-}
-
-static inline void split_queue_unlock(struct deferred_split *queue)
-{
-	spin_unlock(&queue->split_queue_lock);
-}
-
-static inline void split_queue_unlock_irqrestore(struct deferred_split *queue,
-						 unsigned long flags)
-{
-	spin_unlock_irqrestore(&queue->split_queue_lock, flags);
-}
-
 static inline bool is_transparent_hugepage(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
@@ -1379,6 +1285,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 		return NULL;
 	}
+
+	if (folio_memcg_alloc_deferred(folio)) {
+		folio_put(folio);
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
+		return NULL;
+	}
+
 	folio_throttle_swaprate(folio, gfp);
 
        /*
@@ -3890,34 +3804,43 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
+	struct list_lru_one *lru;
+	bool dequeue_deferred;
 	int ret = 0;
-	struct deferred_split *ds_queue;
 
 	VM_WARN_ON_ONCE(!mapping && end);
-	/* Prevent deferred_split_scan() touching ->_refcount */
-	ds_queue = folio_split_queue_lock(folio);
+	/*
+	 * If this folio can be on the deferred split queue, lock out
+	 * the shrinker before freezing the ref. If the shrinker sees
+	 * a 0-ref folio, it assumes it beat folio_put() to the list
+	 * lock and must clean up the LRU state - the same dequeue we
+	 * will do below as part of the split.
+	 */
+	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
+	if (dequeue_deferred) {
+		struct mem_cgroup *memcg;
+
+		rcu_read_lock();
+		memcg = folio_memcg(folio);
+		lru = list_lru_lock(&deferred_split_lru,
+				    folio_nid(folio), &memcg);
+	}
 	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
 
-		if (old_order > 1) {
-			if (!list_empty(&folio->_deferred_list)) {
-				ds_queue->split_queue_len--;
-				/*
-				 * Reinitialize page_deferred_list after removing the
-				 * page from the split_queue, otherwise a subsequent
-				 * split will see list corruption when checking the
-				 * page_deferred_list.
-				 */
-				list_del_init(&folio->_deferred_list);
-			}
+		if (dequeue_deferred) {
+			__list_lru_del(&deferred_split_lru, lru,
+				       &folio->_deferred_list, folio_nid(folio));
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(old_order,
 					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
+			list_lru_unlock(lru);
+			rcu_read_unlock();
 		}
-		split_queue_unlock(ds_queue);
+
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
@@ -4017,7 +3940,10 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		split_queue_unlock(ds_queue);
+		if (dequeue_deferred) {
+			list_lru_unlock(lru);
+			rcu_read_unlock();
+		}
 		return -EAGAIN;
 	}
 
@@ -4383,33 +4309,37 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
  * queueing THP splits, and that list is (racily observed to be) non-empty.
  *
  * It is unsafe to call folio_unqueue_deferred_split() until folio refcount is
- * zero: because even when split_queue_lock is held, a non-empty _deferred_list
- * might be in use on deferred_split_scan()'s unlocked on-stack list.
+ * zero: because even when the list_lru lock is held, a non-empty
+ * _deferred_list might be in use on deferred_split_scan()'s unlocked
+ * on-stack list.
  *
- * If memory cgroups are enabled, split_queue_lock is in the mem_cgroup: it is
- * therefore important to unqueue deferred split before changing folio memcg.
+ * The list_lru sublist is determined by folio's memcg: it is therefore
+ * important to unqueue deferred split before changing folio memcg.
  */
 bool __folio_unqueue_deferred_split(struct folio *folio)
 {
-	struct deferred_split *ds_queue;
+	struct mem_cgroup *memcg;
+	struct list_lru_one *lru;
+	int nid = folio_nid(folio);
 	unsigned long flags;
 	bool unqueued = false;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
-	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
-	if (!list_empty(&folio->_deferred_list)) {
-		ds_queue->split_queue_len--;
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, &memcg, &flags);
+	if (__list_lru_del(&deferred_split_lru, lru, &folio->_deferred_list, nid)) {
 		if (folio_test_partially_mapped(folio)) {
 			folio_clear_partially_mapped(folio);
 			mod_mthp_stat(folio_order(folio),
 				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
-		list_del_init(&folio->_deferred_list);
 		unqueued = true;
 	}
-	split_queue_unlock_irqrestore(ds_queue, flags);
+	list_lru_unlock_irqrestore(lru, &flags);
+	rcu_read_unlock();
 
 	return unqueued;	/* useful for debug warnings */
 }
@@ -4417,7 +4347,9 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
-	struct deferred_split *ds_queue;
+	struct list_lru_one *lru;
+	int nid;
+	struct mem_cgroup *memcg;
 	unsigned long flags;
 
 	/*
@@ -4440,7 +4372,11 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_test_swapcache(folio))
 		return;
 
-	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
+	nid = folio_nid(folio);
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, &memcg, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
 			folio_set_partially_mapped(folio);
@@ -4448,36 +4384,20 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
 			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
-
 		}
 	} else {
 		/* partially mapped folios cannot become non-partially mapped */
 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
-	if (list_empty(&folio->_deferred_list)) {
-		struct mem_cgroup *memcg;
-
-		memcg = folio_split_queue_memcg(folio, ds_queue);
-		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
-		ds_queue->split_queue_len++;
-		if (memcg)
-			set_shrinker_bit(memcg, folio_nid(folio),
-					 shrinker_id(deferred_split_shrinker));
-	}
-	split_queue_unlock_irqrestore(ds_queue, flags);
+	__list_lru_add(&deferred_split_lru, lru, &folio->_deferred_list, nid, memcg);
+	list_lru_unlock_irqrestore(lru, &flags);
+	rcu_read_unlock();
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
 		struct shrink_control *sc)
 {
-	struct pglist_data *pgdata = NODE_DATA(sc->nid);
-	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
-
-#ifdef CONFIG_MEMCG
-	if (sc->memcg)
-		ds_queue = &sc->memcg->deferred_split_queue;
-#endif
-	return READ_ONCE(ds_queue->split_queue_len);
+	return list_lru_shrink_count(&deferred_split_lru, sc);
 }
 
 static bool thp_underused(struct folio *folio)
@@ -4507,45 +4427,49 @@ static bool thp_underused(struct folio *folio)
 	return false;
 }
 
+static enum lru_status deferred_split_isolate(struct list_head *item,
+					      struct list_lru_one *lru,
+					      void *cb_arg)
+{
+	struct folio *folio = container_of(item, struct folio, _deferred_list);
+	struct list_head *freeable = cb_arg;
+
+	if (folio_try_get(folio)) {
+		list_lru_isolate_move(lru, item, freeable);
+		return LRU_REMOVED;
+	}
+
+	/*
+	 * We lost race with folio_put(). Read folio state before the
+	 * isolate: folio_unqueue_deferred_split() checks list_empty()
+	 * locklessly, so once removed the folio can be freed any time.
+	 */
+	if (folio_test_partially_mapped(folio)) {
+		folio_clear_partially_mapped(folio);
+		mod_mthp_stat(folio_order(folio),
+			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+	}
+	list_lru_isolate(lru, item);
+	return LRU_REMOVED;
+}
+
 static unsigned long deferred_split_scan(struct shrinker *shrink,
 		struct shrink_control *sc)
 {
-	struct deferred_split *ds_queue;
-	unsigned long flags;
+	LIST_HEAD(dispose);
 	struct folio *folio, *next;
-	int split = 0, i;
-	struct folio_batch fbatch;
-
-	folio_batch_init(&fbatch);
+	int split = 0;
+	unsigned long isolated;
 
-retry:
-	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
-	/* Take pin on all head pages to avoid freeing them under us */
-	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
-							_deferred_list) {
-		if (folio_try_get(folio)) {
-			folio_batch_add(&fbatch, folio);
-		} else if (folio_test_partially_mapped(folio)) {
-			/* We lost race with folio_put() */
-			folio_clear_partially_mapped(folio);
-			mod_mthp_stat(folio_order(folio),
-				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-		}
-		list_del_init(&folio->_deferred_list);
-		ds_queue->split_queue_len--;
-		if (!--sc->nr_to_scan)
-			break;
-		if (!folio_batch_space(&fbatch))
-			break;
-	}
-	split_queue_unlock_irqrestore(ds_queue, flags);
+	isolated = list_lru_shrink_walk_irq(&deferred_split_lru, sc,
+					    deferred_split_isolate, &dispose);
 
-	for (i = 0; i < folio_batch_count(&fbatch); i++) {
+	list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
 		bool did_split = false;
 		bool underused = false;
-		struct deferred_split *fqueue;
 
-		folio = fbatch.folios[i];
+		list_del_init(&folio->_deferred_list);
+
 		if (!folio_test_partially_mapped(folio)) {
 			/*
 			 * See try_to_map_unused_to_zeropage(): we cannot
@@ -4574,63 +4498,23 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		 * underused, then consider it used and don't add it back to
 		 * split_queue.
 		 */
-		if (did_split || !folio_test_partially_mapped(folio))
-			continue;
+		if (!did_split && folio_test_partially_mapped(folio)) {
 requeue:
-		/*
-		 * Add back partially mapped folios, or underused folios that
-		 * we could not lock this round.
-		 */
-		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
-		if (list_empty(&folio->_deferred_list)) {
-			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
-			fqueue->split_queue_len++;
+			rcu_read_lock();
+			list_lru_add_irq(&deferred_split_lru,
+					 &folio->_deferred_list,
+					 folio_nid(folio),
+					 folio_memcg(folio));
+			rcu_read_unlock();
 		}
-		split_queue_unlock_irqrestore(fqueue, flags);
-	}
-	folios_put(&fbatch);
-
-	if (sc->nr_to_scan && !list_empty(&ds_queue->split_queue)) {
-		cond_resched();
-		goto retry;
+		folio_put(folio);
 	}
 
-	/*
-	 * Stop shrinker if we didn't split any page, but the queue is empty.
-	 * This can happen if pages were freed under us.
-	 */
-	if (!split && list_empty(&ds_queue->split_queue))
+	if (!split && !isolated)
 		return SHRINK_STOP;
 	return split;
 }
 
-#ifdef CONFIG_MEMCG
-void reparent_deferred_split_queue(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
-	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
-	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
-	int nid;
-
-	spin_lock_irq(&ds_queue->split_queue_lock);
-	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
-
-	if (!ds_queue->split_queue_len)
-		goto unlock;
-
-	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
-	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
-	ds_queue->split_queue_len = 0;
-
-	for_each_node(nid)
-		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
-
-unlock:
-	spin_unlock(&parent_ds_queue->split_queue_lock);
-	spin_unlock_irq(&ds_queue->split_queue_lock);
-}
-#endif
-
 #ifdef CONFIG_DEBUG_FS
 static void split_huge_pages_all(void)
 {
diff --git a/mm/internal.h b/mm/internal.h
index 5602393054f3..181e79f1d6a2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -852,7 +852,7 @@ static inline bool folio_unqueue_deferred_split(struct folio *folio)
 	/*
 	 * At this point, there is no one trying to add the folio to
 	 * deferred_list. If folio is not in deferred_list, it's safe
-	 * to check without acquiring the split_queue_lock.
+	 * to check without acquiring the list_lru lock.
 	 */
 	if (data_race(list_empty(&folio->_deferred_list)))
 		return false;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 35a5f8c44c18..8ffb47f1e845 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1306,6 +1306,11 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
+	if (folio_memcg_alloc_deferred(folio)) {
+		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
+		goto out_nolock;
+	}
+
 	mmap_read_lock(mm);
 	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 92269740eef1..d93564af82b5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4035,11 +4035,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
 		memcg->cgwb_frn[i].done =
 			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
-#endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
-	INIT_LIST_HEAD(&memcg->deferred_split_queue.split_queue);
-	memcg->deferred_split_queue.split_queue_len = 0;
 #endif
 	lru_gen_init_memcg(memcg);
 	return memcg;
@@ -4191,11 +4186,10 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	zswap_memcg_offline_cleanup(memcg);
 
 	memcg_offline_kmem(memcg);
-	reparent_deferred_split_queue(memcg);
 	/*
-	 * The reparenting of objcg must be after the reparenting of the
-	 * list_lru and deferred_split_queue above, which ensures that they will
-	 * not mistakenly get the parent list_lru and deferred_split_queue.
+	 * The reparenting of objcg must be after the reparenting of
+	 * the list_lru in memcg_offline_kmem(), which ensures that
+	 * they will not mistakenly get the parent list_lru.
 	 */
 	memcg_reparent_objcgs(memcg);
 	reparent_shrinker_deferred(memcg);
diff --git a/mm/memory.c b/mm/memory.c
index 135f5c0f57bd..f22e61d8c8de 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5222,6 +5222,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 			folio_put(folio);
 			goto next;
 		}
+		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
+			folio_put(folio);
+			goto fallback;
+		}
 		folio_throttle_swaprate(folio, gfp);
 		/*
 		 * When a folio is not zeroed during allocation
diff --git a/mm/mm_init.c b/mm/mm_init.c
index db5568cf36e1..c0a7f1cf6fef 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1373,19 +1373,6 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static void pgdat_init_split_queue(struct pglist_data *pgdat)
-{
-	struct deferred_split *ds_queue = &pgdat->deferred_split_queue;
-
-	spin_lock_init(&ds_queue->split_queue_lock);
-	INIT_LIST_HEAD(&ds_queue->split_queue);
-	ds_queue->split_queue_len = 0;
-}
-#else
-static void pgdat_init_split_queue(struct pglist_data *pgdat) {}
-#endif
-
 #ifdef CONFIG_COMPACTION
 static void pgdat_init_kcompactd(struct pglist_data *pgdat)
 {
@@ -1401,8 +1388,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 
 	pgdat_resize_init(pgdat);
 	pgdat_kswapd_lock_init(pgdat);
-
-	pgdat_init_split_queue(pgdat);
 	pgdat_init_kcompactd(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 04f5ce992401..9c3a5cf99778 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -465,6 +465,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
+		spin_lock(&ci->lock);
+		__swap_cache_do_del_folio(ci, folio, entry, shadow);
+		spin_unlock(&ci->lock);
+		folio_unlock(folio);
+		/* nr_pages refs from swap cache, 1 from allocation */
+		folio_put_refs(folio, nr_pages + 1);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	/* memsw uncharges swap when folio is added to swap cache */
 	memcg1_swapin(folio);
 	if (shadow)
-- 
2.54.0


