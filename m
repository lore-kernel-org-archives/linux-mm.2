Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA09CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12DEF6B012A; Sun, 31 May 2026 05:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106026B012C; Sun, 31 May 2026 05:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C436B012D; Sun, 31 May 2026 05:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E54DF6B012A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:50:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FCC58DF09
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:50:54 +0000 (UTC)
X-FDA: 84827246028.29.AB9DF69
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6F12C0002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:50:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kNEOHjzF;
	spf=pass (imf28.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780221052; a=rsa-sha256;
	cv=none;
	b=Cy7NhwttW2Gf/bC74dRbjEfpKJ7FDILmdmBn9a1SqRKluGQjaSrdnyKSbMWkTWsIcFG9B0
	LeUdnUnqu4v39ocFkRXL8qxkXTo+/TlYXnkeg0YABhuYNsRTzv01q3JWG6ybNPX1zaTq8q
	bS8opp62XNkNrBSMcG7aINp7yQQ3zDA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kNEOHjzF;
	spf=pass (imf28.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780221052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4xPP1QwcL7O0fsqTypMQBaoMq59XzA16L4IQtLI0jM=;
	b=3S4yF44DBJV1QRhxXubm0QegWDDbaxByK+j5iWVlbb5vH6sHP4ctgvqgBIeJbAD9n2JyYC
	pU081oK3+MgEIQFxcmH+uUmkot3miW6THdt9o/zosZ28t9P7jmy1yqU/9nDMDTxq3mZzLD
	7JbbXenzVQH0v6BwBMgolwP26odJm5M=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36d5b11201aso505304a91.2
        for <linux-mm@kvack.org>; Sun, 31 May 2026 02:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780221052; x=1780825852; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A4xPP1QwcL7O0fsqTypMQBaoMq59XzA16L4IQtLI0jM=;
        b=kNEOHjzFbk+9CKzt5hU3znAlmNnKrcKMT5FGm5Ng/KdiELu2lvmDP5HFQzTwhq0ib+
         m4gSeT31Hs1be5HWnEiMZsxNFvs4tZMZzrmRUCyzx4lGPDoZp2C86aYxXnmmGG78zcSd
         N3qUxUxkc7h5OOqDms8xqCOaaNJ2WhANJK571I0p3yVkaYwPawcOeiLqa++2ZGEegTUx
         UPsesKS6ZTPduPmsjRwZchUgIISS1iSsJn8SLABms7nCTrbNHnk45Y7/nYx/SHEy0ZjW
         0PINpwMLSxavdDu154v1tkL+LwcWbps110/AYvTo4RtArYG2QcwEIcGjwYC/k0+ilTr0
         faeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780221052; x=1780825852;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A4xPP1QwcL7O0fsqTypMQBaoMq59XzA16L4IQtLI0jM=;
        b=ph+tGuxe7t3XFIrmHMfAQ0YK3azBDT6ZcaxLagzsW4LDermTitnpMEaYMlGffdV+XG
         rFLabUSpzs6u3aL4EA5nqOQs2GK4BG1JzH89bOn8vbFubOzZHu3MdiG5f33U3HTCa52S
         bunxhiZ7T6NXiMMALrNekquVN6Y12SrCETffqUrocfeTf7oVQ6Qgrlh4tQDclWZP1j2j
         21ynY4luv5m4obPnSc/1Gp9NWRwFxoNB7EPrxG/nclqvvfb9bw/7MGXsflPRBL9WqWqb
         5Zc11gZxBIedcA/WrPs3iPxb/tCHYxzpzzwmaILKCcs1HJRF1C6EYTb95pPj923a/EL7
         Utaw==
X-Gm-Message-State: AOJu0YzgT3prg/l0T+lnWCKCDRQfdkLrTj5RjU5tP0fxtrSRl1dGdykk
	1BB/aQ7u5hTTmC2z5k1libX0hnC06K/umA/pB9Ai6iNtxdplG78DV28C
X-Gm-Gg: Acq92OGrG9ze/IanrJgPu/baEWC2USDtd1dkJSV74UyZuvUwLIEHUDWEmfxEEMiCEgq
	UZsJ/n2yK52v4CYfEAsGGAJ0MGSCVRNj1vGVbD4enQsAobY5hGoHB8TEJixZhAK+BK4iwm73Zpq
	97vxeSTkcWSSQJ+9zeht01heHxNACakEGfvhVzrKZTBp4zbTsY92EIz/ln73kKOkJAIRaM7v8Sc
	PykGPFKcUyoH5JTMv9Kj07pCFTQD84N2bVC5lwurr2FlE3XIaMU9OwqFEs+M91i/ljVha8wuuOV
	hBLZIn4YczHkUfyGWpZJx8gxE2WyVJDCW7s6KA7Gvk88q/Oehyt8y0aA4QlAqo9vZPoerMvlQN4
	Q37cJHCUsw0Mjp2BWVMjfemnMbYvXbQOp6qsy4y35pPkbooqEAmIBUQrs7qBvEX1fioMfn6WNo0
	FG0QHw+xPidUkttE3JRqxm4iWi5O1KM3U4MVGNzflWQcFZYypXbqn0Wo4D9YWi65ZhSREvpQcuH
	kPjNnqmzQ==
X-Received: by 2002:a17:90b:5184:b0:36b:8824:d7cc with SMTP id 98e67ed59e1d1-36c501efef2mr5684731a91.20.1780221051694;
        Sun, 31 May 2026 02:50:51 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bbdb5c91bsm4372219a91.1.2026.05.31.02.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 02:50:49 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 31 May 2026 17:50:15 +0800
Subject: [PATCH v2 3/3] mm: move reclaim-internal declarations out of
 swap.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-3-1b9a4ac255b4@gmail.com>
References: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
In-Reply-To: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: C6F12C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: adzhxxdr9frqw58zoyrawqfbt4hqkmgq
X-HE-Tag: 1780221052-472679
X-HE-Meta: U2FsdGVkX1+oP7fq9l1pgaai65BgfAKDldT3HeeoqD5E/Rqjr2NtK4n7MajQxt857tBRfua4xEJ++gMuOUvr6qst19gjJ71qWjE2yZjkDKtzatOyih9Gua4WhGK71s0kdz2m9ajh6TDhsD+zlm3PMsn3XMY2o/Z3ZSS6a/4L4ALdCvCexgK2a+CwYzCDlg3ifdsCsyPmaP7bY0dSSRKbNjCvrzqT1O/SAlGZRRncDtrvGSCVHV75uryxZuDt79FBx+HVjtrnM/NQx6KL7pjLL0hqpkSMjveSb/3afsBv+1Mniz4VtK/6UaFRK99kVMygj88AJSIouKO5fzzbH/kHDIMNi8g9lFV/Q+kOwVsmopC6ioxF61kSrclfuCwZcDGc2lLjzR0ovkRm2N3+rM41uIw2kUKQGZWlW7M7lfMNipds3TvZBP4kSq6C5pTx55V024g3Ry3uwp3j+As9obK5QufdDv5t8O2oVZGoXamooZQu6wkoUhKOJADCIEeURz98y3JWI1iGHpiS5TEGqRszU/Kqk327CVZFg/gvf+t4FXCFRfHlJaxwqzi8Z+R4sHJIVn1BN7ai294CYRn2Jc7WVjLbX5XauSG3AlgVnA1Zj4E79Idu8nhd++bR6IFHIJttFWqu5vEQyaJiNubKbcyR6dHQO+2FqgBgopVVJJ2RCM+GRld7JawX8UPj0T4NyCHdb9BDV0M4uToQ5MdkIIyEIZX8zxwOIhhd/SSrtAsDpqkQRo9KBlqNkY5cwMXdvaEHI0pVdww6iBHJQhE+QNfm8ApKh7L+5RAWLSwygO82rnCaE5X8AFZBIH0p46oRmxzmGpe+NkaGd+BdBTmeHfjBoczuVShcAZyrP88lRMy8lAer5t8YSq7Ntb4HBskYwd+aagGiK/Lfa22m2i3IDs/+BfnO3JUcR9PA4TygwIs2qh3z5rBUI/x0dltWVBzDUHDLwirm3UYtFHbJOn7gZV/
 Jaoo/S++
 b+CRgUHETvmKaLazX/Ub+p4XrVDpaetk3R/tMvLdmpKgR55UUwCZJCo6vMdnIs6JQAi+NFDCRS1kR0LeHQOM8xxAtUtYbhKg3WRPWcGtqb85IuZmzw5ygdL7zG7g+Fgxbeh42eQRM1sPHSAXb7pxi++mD9YGuPs5QoSGvfjgVECDMTZgChKVG6z4imNAb4C82HZ/8z6SKmQaudnfay/dC55oUhDqEw+X34NEEl6/YTseH6sm3jLklJKVFTGp7KdH+CDgcQ7SiWa6XUlZDhMyyJulUpUw62NT/sCBN2sbnkc1NzSalgtp5JzUX3lsU/TZocgzuoEsI9XWuTYOXiU/ZaBVCRrn4QJBNfNOB6+C8UwtCS9Va3nI1wk4W4FestqQsiNrvF+H4aZFKT30KNZjsp77x0y0o8P62C2/HBTmuJlvp5hHCPeXTXd43NCRb+7FtgPDxcQi7s8I2+XQK+yzZhmhXNDNJOvoAqo+Yu3zdRVPYR2Y=
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

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h | 75 +++++-----------------------------------------------
 mm/internal.h        | 66 +++++++++++++++++++++++++++++++++++++++++++++
 mm/memfd.c           |  1 +
 3 files changed, 73 insertions(+), 69 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index c36f72877e8b..1ef6ae7b2db7 100644
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
 
@@ -333,43 +311,7 @@ static inline bool lru_cache_disabled(void)
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
-extern void swap_readahead_setup(void);
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
@@ -390,11 +332,6 @@ static inline void reclaim_unregister_node(struct node *node)
 }
 #endif /* CONFIG_SYSFS && CONFIG_NUMA */
 
-#ifdef CONFIG_NUMA
-extern int sysctl_min_unmapped_ratio;
-extern int sysctl_min_slab_ratio;
-#endif
-
 void check_move_unevictable_folios(struct folio_batch *fbatch);
 
 extern void __meminit kswapd_run(int nid);
@@ -554,7 +491,7 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
 #else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	return READ_ONCE(vm_swappiness);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 5602393054f3..5475ba38a621 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,6 +24,72 @@
 
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
+void swap_readahead_setup(void);
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


