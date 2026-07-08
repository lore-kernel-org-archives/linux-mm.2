Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35362C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271E06B00AD; Wed,  8 Jul 2026 07:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C1A6B00AF; Wed,  8 Jul 2026 07:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1606A6B00B0; Wed,  8 Jul 2026 07:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D957A6B00AD
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:37:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C5A6120795
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:37:36 +0000 (UTC)
X-FDA: 84965409312.20.6D7D860
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 739104000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:37:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Dx/KMfO6";
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783510654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsX4tsng9Yri+W6keCRu8OvEuZNjSh1FDIcrUyUmTN0=;
	b=kvrLLcwK0mlbMk0YvvRSWnr+02476PV16XtevQgF7Hjzc0BHY889MbcVeDUy18Leou2LVw
	+hEJueT5usbBIpJyBLsVJfA3kbLvasLR1+yHtCmGnVAZwAVUHFiJ2PMdPoQTBwjk9D351C
	4o0uXCwvEns4sXrZBAeU9qkn3eiFHYs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Dx/KMfO6";
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783510654;
	b=M2m9QIaPeL83nhSFjQnIis8jIFHYEePnyAhT+8dAvDT9mB2gxaoI/t0ig+ls9bzQsZyYUN
	VttUxzXuh4dq2cf7U29zWPoQ7dl7aFUIdnS8sfGo5JiM/uOfXUzk0+pY086ScRISPeXLb4
	qLbSffOWT77EyJEP45WLgRYoFLx0oLM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc73e322dbso5293375ad.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 04:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783510653; x=1784115453; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wsX4tsng9Yri+W6keCRu8OvEuZNjSh1FDIcrUyUmTN0=;
        b=Dx/KMfO6Si8oR81em/Aq55VB4pA3m5Myb5NF8l87juBhmL9hzr3QRu24in6lzQtqbM
         b0hYhS0T0C0EtmcYgqQ99De9Vj7JF6MgKzLP7pLZ7zBsQylGlrF3L82VDk1K9wDMUJEg
         I6ALNVjMuupG78MU+BdfhQwl6doK7X+eoTa2nEajf4vubRDEtXBDyC9bZhLrmbm7QCXG
         yNXZHL3aBmk6Ld0JsavJpC0/5bsgs+YQqDhY28bViR+FNTygu7T1vqQurGpEqqirXanG
         F0Yy18DlugmaGUBm9JWd6I+hCR17QlN4IztKUuiAt7WGlwk09A0+4jXQd5r2O4UwY2Op
         xYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783510653; x=1784115453;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wsX4tsng9Yri+W6keCRu8OvEuZNjSh1FDIcrUyUmTN0=;
        b=NeOfN3QiqzFF7Hr//1J152wGEx1snK98ObpMCiz6GpyBGLELs3twz/CEvx1mQbgD49
         pOlCwtPFhH1Q2XKz7q0HYL18NhLZhLhx0wh6JTr3DGZEThiRYD1DlzNWZ36N11Qxk7fs
         Mn2Eu8f7/hY3vwtRc/TdbFQbiqxh0FqPgF7FJV/LVpI9L2ttjbOkTGkcy72CQ37/IDTk
         dmy4J1RFN10tzT5iUfUCHFw+dnmXAcOrejBd+llWxFoTEHUcOz291G0zp4LT0pIRlIjy
         qhfsHFcB7YN6wgEvjYy0B6lFEsCMx5pVIyUqVsz5fVSeAKHxtrrF0P3zYJjW+ml1X124
         DZyw==
X-Gm-Message-State: AOJu0Yz/3NeHgrjRy+4oHH7uKd0QE/xiyJtJ+8VGkob5g2wNrlJLHzT4
	G0OCPXNo0UkqUFhaPO2GNhSxIi1vl8kMPmnF9AuLAWH9P0rCBtDZzc33
X-Gm-Gg: AfdE7cniqm4L7PxSZTP3QvkGbsiGe+R75XNth0R/ZXcdhuHVJtya9hRpuEGnADz372R
	c2UV+VcJt/X+TOmxCIWHLnIQgZ9RQmducgVyF44rY+TGhjeHFvyFWThEuW3Q/C55XNWz6fishBD
	iwA2GExKHMBfosmDxMxiodxro20W1lpmFrK7iuajeEYC+aiBQQ9YGoZhqS2sJrZyQJ3iWKrfkJV
	ndEO5NDp2eQ080QIMrS6z3erEQ3reFMJzfOYMmh3utX52iW8/XaqwjjBioEwVce5G2mL9XzjwqZ
	lksXn0hijRoKorbQInXTBWLnPzl8+a2BTNCwWo7ZHsANt1ZnfpCM5/p2FHg3SytsVCS/0TD/l4J
	e4SgHD8XpCsKYogYNOVOs2tujGcGwSxkaSmzJD76NjxoRNINbhyu5oZQu6UbrMov1ScdzrsdR/w
	/pSVrhb73HiE5EI6cqHlgBguIgmmV4uY8IrRFvDJ8R34bloVBxeYi9l5cSTqmbtMVLVDjkOw==
X-Received: by 2002:a05:6a20:729d:b0:3bf:a624:deb8 with SMTP id adf61e73a8af0-3c0bcebc735mr2712680637.21.1783510653330;
        Wed, 08 Jul 2026 04:37:33 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([203.18.50.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3a2e42bsm2260788a12.30.2026.07.08.04.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:37:32 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 08 Jul 2026 19:35:45 +0800
Subject: [PATCH v9 3/3] mm: move reclaim-internal declarations out of
 swap.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-3-2bc72b4f8730@gmail.com>
References: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com>
In-Reply-To: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1783510625; l=8023;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=HQQ72dgmVbZC77bcr0zDY6sZbYi1+DHjLIVBbJrZdNQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QEuGbA+DZLkkohK/zesu09/MuV6UgGfHV17MbknS2mkwZ4rvjzNcmdidybuTBUDWmbQFvYaMunm
 38OtymxRx1wQ=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 739104000A
X-Stat-Signature: 6fdjbmbkdsgnsyn97ribpkzt3ejap7ch
X-HE-Tag: 1783510654-385449
X-HE-Meta: U2FsdGVkX1+qFZcrrsfGvzmO4oM9o2PLGJ57RGgWt+o5j64qvnxMJg3nbuIaRhaghXbJ1llgTOD6AB0fu5Z2vXqNi2AZ0+gFqlkVdR9xNlopARcwtWqGi9inRD0Id4jtRSP9SetKgFMB2Dl7JryZH4lfNASUW6YKkIVymobRMMbsVleIphvV9sHp2DODx1zVKz5Pus5jCVYpjCCA0rnfVV/Oo5qECL3iKj3vbx4IzXRr+im36Eoxdd0S5u9PHccjb9wLXXLgfy3UN58UQmTzxZLHkSLgZM8eh6l+txrk9mdUT1ojwQYC3Y7sfbd9abXsNlDdeRIOQ4+BbhJMl1eVFa9yerVegq2rxB5jH54Q9cjKEs1+2X9KVb7kFOKuZ0vpchMQWxWxWFkhWKA73v7FZse/JNJ7Ut3iFi6jcWln+m8NuiaTsnOL4kWzf89oAhlTV3zMlbvNUgAAe/cI1jhnpn/PAiv1U2gN+TQkc4hupGQnhA0IxjKIoNH9/9vyFFA3kMLOc4EkqxjYcwwynyebpnhfeUXXSU69LZtfDOKkdc6ZXptfu3JOMdD3ZapxibD+eoaoSa+8Lvb5UfGdHSHWdDAUF0M/FsTF5EpKMPSoNV0QPZZtyE66ashp1eN9nPf5O3G/5gMUV0tN9EMe2nZiB83ZK4b5nC1ES4Byp+/I0Ag2M8AWBM0x3HemWKZl7EUG+m3AhQcurskUIQxfjCGmnuGkSq3U8tl5pgLPzkLzI5vFV+7ucdOIdNagncxzR7hMJMd0agWdKIxRUh8Fs9FiFk4BXd2fQFODzITRfB2IBOV9JiFz00ket2J39ZWxbD/Q+U2SoL28OHASMrxEtUaaSyfslkrGcI2SuHtybmpHMaoEJ3rlNO7jqp5kDviLEvvTz/s5FQ7NgisZjYJzw1Rj6iF/G2woh1zoabPc6AV9KMgY9azKGP0YSx/5/34gl39pjauck4veMnJb9vpjnzj
 6lbl1tau
 tLHJnmJOqxTU38dzaHhF3FjTLGGINKsF99ovJMmElInY76moHVLYeAW5Sf/uvRQVFwYg2723B0FbyYFhrncoqJfMUJ1bPS5JoUuC37vbIX1WwhThEDhkSEHV/vTtcnTiy4SzGWNjyPnvRXf9Zn1DPS7P7WTF6yl4FosawC3kdQCGtw4QQ9T7SSx2y7a9vmLi68QWYeVXPSeAo83mcjRaoO+gybTzcTkeN0J1aiT3SOhZRsiPP9pznZ8ItCUHDJO2PrcP/qTlaL12unpME1vNWMu7rDA11koAGv9rh6OK45xeMO49kg3H+xzSzFPwlUaIV6U2cwQF6KeCyH4S7+shxhS8oShnQSaSlNbtRSku7p982Ari6/1gHIUfuwvqCJ70K7/iYuoZPw2lVgwWxFfDLJNhHAz1zbrm6zThi+ymmM1asijoyBjsNw4Rg/yBPG/zmsaxjbPpUgSnGzruygTNPcIaiAhnu6PQvTxdsLYqqElm8J1c4GOoZHyddTeSt4BNXfBR5gvqd/92LVu+MWcB5+LtgZE2bzCD2oUIilm+iGTpkIvpNDRs65t3y3g==
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


