Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D63F4C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C8C6B009F; Tue,  7 Jul 2026 12:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04066B00A3; Tue,  7 Jul 2026 12:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A4D6B00A4; Tue,  7 Jul 2026 12:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64F7B6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:12:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD24A1A04B9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:12:13 +0000 (UTC)
X-FDA: 84962472546.05.791080B
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF36C1C0007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:12:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mnJlHdI5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783440731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsX4tsng9Yri+W6keCRu8OvEuZNjSh1FDIcrUyUmTN0=;
	b=nVvFzNVaBL15cvs5DOmdU/UcC9tV4FcrcR8WXBQTMQXlXhv/2YLUXE4bYUZfOQWBbC80Ra
	A4q2lu7fRkfUplkLVkzKwciU5pV0csvAWGEkdngpnYvtE1WlopaDpFggYR+FiMo3Co6Euz
	/xq4isrdpXoO8v7miaIuH5NLqDAaeRM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mnJlHdI5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783440731;
	b=d54cANJ7bkA3yrqFGYb+5KitNbh9DIpJB4zmT3A/Nym92uMmBQy6owVIN+3ztSv9LpwAOD
	1SPiprDX/R0tJrZA5OHLqzscwwHIi0ByNJ+GivhkSnHXr82+k7vD0dg8l0EpaZnS04LLOj
	5Tlm2+CrYh1hyqaJ4J1vw6AwnI+tfFc=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cace7da66eso42364625ad.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 09:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783440731; x=1784045531; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wsX4tsng9Yri+W6keCRu8OvEuZNjSh1FDIcrUyUmTN0=;
        b=mnJlHdI5st/4/4Q9YXvkU+/bR+scAHqhGdaZTvsV3rS5FLKNxoQ9PggNKpBkvn9q3M
         BU4BYfmfDg6v/JzXUCiErRY05Cw4zhOW4EmkHDBe7xtGMWORFUTdsrN+SPGSCvYWsRAh
         ZJQSaVS7zq/7c19VR6FJpCgvnMyX+jf8TrMqwPguajoj126UCjrfAwaFg9N7E1SdgjZJ
         fnbbTqsRlUHAmSwFriKGnJ3HcQWBv5LG8Aq5sQ2OaM6Wp5pqFPJEpTd3lf6bHRi6yE28
         hVQ6F9ViDMcS8cgKWnTeyVfphEGpy02OUXE4QEjQqBglb2G/2mc5bk5ZN7l38/r0osAH
         aOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783440731; x=1784045531;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wsX4tsng9Yri+W6keCRu8OvEuZNjSh1FDIcrUyUmTN0=;
        b=U1K5p23SkdxvJrffVYRbHoHzjUEeWEJ9r21Svngoakh/wuOiTxmoTaKG2jSqEWIKV/
         MiraghhU0m1WZAlvtUlqaHo0BqDyoVDiInKqORyVee4Kzi0m+ZkEtypN1WMtp49qJpC/
         JouU9I79uK+/xRoj6QCUZJxveLjxzy9RM9BsCAG9AAifcW9+FulppcwNKzehIFh6zIwC
         NRNxzDhHSgw1DLMn/CXFnn4yAdhe3wwUbtUCel+QuBGuoqxWdN9AEYMkthJlQcF5/dWY
         NCuhaKmzcZMzj9AYQYgnHQkHRJCyo/GCvEHKpzZnmzBrruvLGB1NNmqegJpSjb2DlgEg
         y/xQ==
X-Gm-Message-State: AOJu0Yz6IRf5zYn1xRVXVGIhLJhF6VA3kCAc/alxoMT9jAbbRL2bRvsh
	7HU4BIPgus97CIyQQDIz85r+VfUnyMuObE063+S8DYGsKYfaVUOkjjxP
X-Gm-Gg: AfdE7clgh8INixJeP7qRlZw26IDs443HsQIGXFXmnED65QomjGXzbC4IUtVaJbg1P5f
	frS1Ca4B9e3wEwtmcTu1DwQw9+MOQf6ahgkLK7Vvna5Bx6LyXHfxVgcsnslssXan3X3gjcGYqaP
	jDa090pz+e3l+UUABtWo0w69TczRJ2asJ63qUfGoQNOomu8y/wWVnyumUQHUwph6RnxprC7QV1A
	vNcnAnrcXFJx22y6Itqfg5xuAimdGnfcQvun2S29FWTFBSv1kUF73Ii6VYDms1mM8KwBY4MqEA1
	cO0SORNVYhSridOYzaH/TZt2m5ssiITiCzqtm2od7a9ECz6oPaQzz8GxvW981rjlUzLJjRZiSE2
	WyfIiFPS5o7gQVv6qXCR6U8KZaSvXwNdUOcG/qpLS68BNsYV1v2k2g8h1842jn8YvbwwLfQH6nt
	vDwQbFI9R42zW3lVzu0FbMrqIlFYqyV+PI7pBUBkRAnpSTKCKOTlYi6cbx0vYKzgyiTvtXaCno5
	JOUz6tRDqI4r1dzdLE0TaA9ka/X/g==
X-Received: by 2002:a17:902:cf0b:b0:2c1:f262:4962 with SMTP id d9443c01a7336-2ccbe7297fbmr54305675ad.20.1783440730695;
        Tue, 07 Jul 2026 09:12:10 -0700 (PDT)
Received: from [127.0.1.1] (ec2-18-162-112-89.ap-east-1.compute.amazonaws.com. [18.162.112.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bfd443sm14712115ad.30.2026.07.07.09.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:12:10 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 08 Jul 2026 00:11:29 +0800
Subject: [PATCH v8 3/3] mm: move reclaim-internal declarations out of
 swap.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-3-e816812698a8@gmail.com>
References: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com>
In-Reply-To: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Baoquan He <baoquan.he@linux.dev>, Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783440691; l=8023;
 i=wujianyue000@gmail.com; s=linux; h=from:subject:message-id;
 bh=HQQ72dgmVbZC77bcr0zDY6sZbYi1+DHjLIVBbJrZdNQ=;
 b=0jVFtpQEPgTsXXe5ds9owsTq+WvvydPjod9VWp04TA+Fkf2lUvZJ5S3Q0/HwyIkJmL37ta0OD
 a0g631yeow0DmZgzjEJrODwbmd/Cg0ax/FTzRtf3/yDQic5nxJHu/v8
X-Developer-Key: i=wujianyue000@gmail.com; a=ed25519;
 pk=49tqjvkqDVX1TtHEyTCiJGlKLg6SQ4BmgzG+HoHQW6E=
X-Rspamd-Queue-Id: EF36C1C0007
X-Stat-Signature: humjmye6inq3ay5frc1xt1e7mjcgaz3a
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783440731-492648
X-HE-Meta: U2FsdGVkX1/QormKhResooFgFgfbfKONC9UC+0aEtzGC1zYsk4xCJhwHwHRzgQMyTw/4sWwStuDmL8Wnw6b8JVBofHW4oXl9hr1jdMPgC95ceMeGXAygbp7aNyX9XXu3prxgIA1wMm9WOR1rKbEgRTnDTEWCxFBZUJsOHqWtG0keaIo4CqId/HIHB3tVCgMa8gXEb1fsTz2bN7JIMop+2c1eVuv89oPSWv7xtiZwU+5y98IroMVEMvsz0mYO9l3OAPLPI5qufEbHE6mJr3Uv9/7LvSKSGXV0XaG8h3z4/xwDBg66F3D1oqmQ2BaTZ5Zrqhwq+hYpyXN2zcnYnbREzhYGt6HjkzVtT1LJUAACTnXVQGh6PBXggzSHCvtNrQ0LAiaYwMsMo7Uxw+pO30ZMLWolF+tIxxjlya3csMRqP8+gwaidf5sjpr5QPNPqBhsCQP3XiqeGNLRgQx+Rxi+tMYxxslDovDwgD98Y3Ik59Xzz+vK9ayiJUFVTuJ+5xxDu7WiYGOiHq0/dicMvlWTHK7zYonW8hUgAi6eYf3boA9rkD5zY5Xe4ipo8IcE/ru0KOnAhZT0XFI7EKZqgPh1QOy9oDWnHyJDrHs3OkGWDJqFsxvC0pqSXljJdvyR2WnuRJigSQl2ifcwXqLhkrpYAAMhsPPzjmggo+F3+R7eQ7H3pluTdn5K6/4jysiD2WH7lxo+i8F3APV6lCj/56dut3Yp0ICmCHh1WeY3G9fI2GC9lgIvozH9kCKOjWDGa+RpDkjxVC+LB2LpZ3pHFtzu0Z1aNtAm5aHIZM9R9IZOeX3sf9ono8b0VuYULds/1CiDsziBmuaajXvetFlEwsommxRAMvx7KBwCEM5Caa/xv2OykMHA5lZcCA1nAmk7xNamULWispyDIv4CKelj33hm/7CjhUVQnGJ7qEfkDivijApp+BfQEUOZ2PqF1H8g79fTeZWJEfj+0ny+ufOE8CgM
 8lauqgKc
 dfh33zJnGK5hxg7JRcx6Ngqa5LYJG8DzrbD9bNGpc0WZMScCO8i+/vEtfMUKE7J2mepPuCPnq+V+hzqx/bOtm7RiSsLN6VjlMXI+cOK4RscVrOXbAShcqQ+A1qHhupDR1Zlq60BlvqIZdPcUga8hdn7Ngz84J+vpOxqOs8pX/l9jtlvuLuYtGG2Yzej/MTNSSdMM1PkW3aZtCDOeQrC3bBWi/ZzIHPVNi6iZwj3yR5WzKdIhJlD4QBRL7q4Pe4TMXM9fJkGIUOOeW25U8K3r3ippfnp066sWFcjgDsWd/Iwx2E0OxqK9itHnwNF4XYrdrPB9UzgBxQP7OY8CDMFeI+X0hwvuQHFscPUrNzu5Gw03/rQySMyEP9Qr/osGzhAiFbvLwSa4jEdtVEjJqK/ECYwfq05yoZmQ0iK7Vdvco23VidY39MBUrCOReOjiCinvoMgiq1ht+PVW0+HaMEfz3uLFza85g89RXWE1qXLDQecYj9uHZNJD4m4Xm163jt1+JveTTHByaNo1CLGUUn5mcp299Cz0QBM47m4vYS3NkNPLQ3COYT1cdQQqdk/+lpTuY5sYnFYxzR/p2w4AeV3/C7FAhjGt/BYovmLMakycbaepYNcwWZWfO3cCcVb2Qr1NYJyvYMqwM+fw+XYI=
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h | 75 +++++-----------------------------------------------
 mm/internal.h        | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/memfd.c           |  1 +
 3 files changed, 75 insertions(+), 68 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 45656ca9792d..696ed01709c2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -287,39 +287,19 @@ static inline swp_entry_t page_swap_entry(struct page *page)
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
 
+/* linux/mm/folio.c */
+void folio_add_lru(struct folio *folio);
+void folio_mark_accessed(struct folio *folio);
+void lru_add_drain_all(void);
 
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
+/* linux/mm/folio-compat.c */
+void mark_page_accessed(struct page *page);
 
 extern atomic_t lru_disable_count;
 
@@ -328,42 +308,6 @@ static inline bool lru_cache_disabled(void)
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
-/* linux/mm/vmscan.c */
-extern unsigned long zone_reclaimable_pages(struct zone *zone);
-extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-					gfp_t gfp_mask, const nodemask_t *mask);
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
@@ -384,11 +328,6 @@ static inline void reclaim_unregister_node(struct node *node)
 }
 #endif /* CONFIG_SYSFS && CONFIG_NUMA */
 
-#ifdef CONFIG_NUMA
-extern int sysctl_min_unmapped_ratio;
-extern int sysctl_min_slab_ratio;
-#endif
-
 void check_move_unevictable_folios(struct folio_batch *fbatch);
 
 extern void __meminit kswapd_run(int nid);
@@ -544,7 +483,7 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
 #else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	return READ_ONCE(vm_swappiness);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 841c27611627..6afbe6b7252d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -31,6 +31,73 @@ struct huge_bootmem_page {
 	unsigned long flags;
 };
 
+/* mm/workingset.c */
+bool workingset_test_recent(void *shadow, bool file, bool *workingset,
+			    bool flush);
+void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
+void *workingset_eviction(struct folio *folio,
+			  struct mem_cgroup *target_memcg);
+void workingset_refault(struct folio *folio, void *shadow);
+void workingset_activation(struct folio *folio);
+
+/* mm/folio.c */
+void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
+		unsigned int nr_io, unsigned int nr_rotated);
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
+/* mm/vmscan.c */
+unsigned long zone_reclaimable_pages(struct zone *zone);
+unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
+				gfp_t gfp_mask, const nodemask_t *mask);
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


