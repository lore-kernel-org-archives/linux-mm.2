Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C7FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181966B00CA; Tue, 30 Jun 2026 12:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131856B00CC; Tue, 30 Jun 2026 12:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6316B00CD; Tue, 30 Jun 2026 12:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACC916B00CA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:28:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1654116787C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:28:13 +0000 (UTC)
X-FDA: 84937111266.11.67C237A
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 30813180006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:28:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=maVmGEaY;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836891;
	b=ZE0/k8jF1QrAjy1xtnurjqoeDyCDEOc5gHU+IpNhdkGyg8LdFn6Zsnqs0gLrcxYopzpP1A
	F3mkyLj5IhZiCKAjj0F+5uKoKH7NpDxm/96GgVvVXzu9o9RfNViONz6rMZSY12OxHPfvIe
	9+czaiowpBnCh7lN50ZxWn5WvM2tnrc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLyMnEKrEL8CEzg90HHddtIh/3xfPpGptax6HcLpH/g=;
	b=B8NHoETgfBrWZtzsKbzRVrN6HskM2cOPdntqOQkHA3/ieSkCNaYKdWq1DWX15/ZrXb4zDr
	TzqgD8D1Y2sCdZsL7VVX29E3J+OtGNdDxrdZ2bGWVu/SBWz/1fv/yLvAlVgvMtDztTIDiC
	OeU19ByZGQPVvWsHXazjMjlUcXfkcJI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=maVmGEaY;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c9b1edf2bdso18784015ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782836890; x=1783441690; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VLyMnEKrEL8CEzg90HHddtIh/3xfPpGptax6HcLpH/g=;
        b=maVmGEaYdcQ+X3DAzZnxj7aQ89DEzF3A16OSa8Xl2U+T5AKWEdgjSYEcFH5zDts1QJ
         LW+1rwzX+U7yUPQ54A0tpJClXGIBMOqhHpH6u4QGGOwR8NIbYwCYtkfS3qo50CMuyP1Q
         VfIhfXaUUqgJ2IfJLWT7HN7w11gSPvOiesb5pkAxFn6MfFb0jiJGMP6JlXysPvwbtgyC
         WNQZkjUviXDxA/KCCqs2s0Y0MN/yRAU060LmegzKNiRqTHPs0KC5+AHz0tuaVG7icQxu
         fOKmXGr1hoB+i/BKvAMPd7/5yXOY5BAdss7TUOCyTeGekYmevKfwguodHusDQ65r3CYe
         F8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782836890; x=1783441690;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VLyMnEKrEL8CEzg90HHddtIh/3xfPpGptax6HcLpH/g=;
        b=dCYh7Yfocp8P6ZvWJrB1DzKQQsJ5t/LM/ShdSopPWMhtZ+4yKmhQpvtK5UozcL46My
         Gf4Bz9ijSgGlx9e91uCJbwVHi56K7ScmlqKIsethT+vJyTKXRYxzIk0D0Ragc9lCBVid
         ggma9yMvQOk7UCDKiKyTTkVdsqQCg0F711VbUXJ6Hgxmn9fuFAQrbdbyWxkWBH7kXg4z
         1XWwDwJsrEawSrIvp1A+xRpOcnhZ4J7zn5anAdbHJACVTeZJiz4n00nGTSozw792S88z
         a/qtKaJTaWSWfDFiAH9rQfGkjBNN1JdhAUu9CVVH7TFwsZ5YgNllsqeanwT2trf3WgQ3
         n20Q==
X-Gm-Message-State: AOJu0YyUza3t2B6nDYz3wGVvyt0/mnksBGtfOD2UgguDIIgS38f7p7RZ
	wc+GIAsBI6hah/cmr7eKnXuWnbjFv3Qkg1AggQBJ9Ek+sd7Vr6pMZP9w
X-Gm-Gg: AfdE7cmzGWTy2OZrYdU8ZxW5pexBYNA4zmkBgzKQf09BUj6HuMHb+8Mj6qMEQ2VuysY
	KdDFvQ7LvSQ7MUyILBX/Z8zxtf4wmy3csRk2V/OpE6R1K7JGZJ4KbxZfMhBGkm5Lh6igTzZD2tq
	i4/cAPVpZz/v70E95Hq/9fUmeWTobYCjijrl/CJwV6QHY2YjzZxnqKJd12YygSQAA5Pix4TzUp2
	JO+R5Z6byx8X2d2YfxAnhm+/9ta0Mcf2p7fj8jV16bdMRjy46/7Qev0tQIM29OtyVzMSv8KDdpd
	TktBDDUqsO7lucYTplpv1ytPd1XtAElRMh2TnD84nnDZU5XLA/n7Zabwp5RS7rwBx8RJVj4uzKt
	DunrM8J5KBA6uUvANx+ZKONsoi/NYTN0AxmceGo8MUFumkeyZQzx8WDXihhvx/abcwriP9Lio3+
	kMZk1LEEuNU78ro6ixmOQOMl8PNwTVAjvHR/1CFR4gme0ptxecn7euMgZAhot7zGQoLOQWlzFA
X-Received: by 2002:a17:902:c941:b0:2c6:a772:7e43 with SMTP id d9443c01a7336-2ca2e333005mr31821535ad.18.1782836890006;
        Tue, 30 Jun 2026 09:28:10 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c87bcesm17829375ad.29.2026.06.30.09.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 09:28:09 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 01 Jul 2026 00:27:34 +0800
Subject: [PATCH v6 3/3] mm: move reclaim-internal declarations out of
 swap.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-3-d4f648963382@gmail.com>
References: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
In-Reply-To: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
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
 Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1782836860; l=7981;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=XRhxz5NWmGckudR2wVBYwj+A9z2FfL4uflUcGrBVXU0=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDVAm9iAhamWZlnpY66chIWu58g1gHeC2XJg0VBOBZksKBGjlgDxkS3D7Ip8kDTzesWnsNGTS3Q
 odVh3ODZnIwM=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 30813180006
X-Stat-Signature: jqeuy4hc8c7r5334qdy6zienph6h3x8j
X-HE-Tag: 1782836891-10479
X-HE-Meta: U2FsdGVkX1+TJ80Ygqi4uE5QB+qw+v9mu54ZlK9iigKXydW3hXf/xHy4Z2TyEojoIkaA+mAaoI6rqw/km7Kp0X35njM58bmiP6CrvJG/beAZ/UoCCAgnajIE1/5OKckHWxGhupGRhW0XKJuxE4mmVGWIJ25VVHunt9fZXhN0d3uUeCyxT5Jb95REpXxpQ0dS0jdpyB6ELsAifAKHMNRpQV6XD7T/z9LHFIMc57qX5lSGCVqvLazVz6RaLESgOWbEi2ajpcnuxw6CPdJLi0blAvq4HEs0KdMCyd9xy+f9ATdbGzD0kzxni9yjw00jJk4PoKoLIF3TgMRwMrx0XgWgSQNw2woV8rM1JiUiEAeBnpUoH6j+QcBD+a0PLnOysGsAtVm7t+7deySjcjrp+GVUYSce6w+d+4/P6M0L8ftbQkD5ZGW8E/jbjK3FphEPyVS/xixrmzHIh1w1KcP7Os988rRqxrWx69cplo8fGbQXFdKRsEVPVifr1902gsH66DgJH3Vw/DyJ7uCldPiCt15FLo4z0Nj0xZvPA5eD8Lw0H4Sn2fZfbPE9ZheWyRXWbvU8hwfmUJCDC55/pa9ebLVfTq+AnjXY1mCSAJjxm23uAEkw9ADeCyWVSjRC/j5B4/ynlRFLhKze+ieR0eRcILnBSmcb1U92yoS7M3FzzvFllVbUFFX8PRHe7Pd/E8IfCMZ0gHAM3yaBgao0hkaJA0P1VtGsaBfJHNM1eYLTSIuFGPROkKm5jHYcFgwOIKRPK4l0usDrvv1y+J3PB81fyUIExDLKRjivk7OBGG1s8NsTnKYBfxYvWNb6hG94gGIYvtsuTgxttRJDgh2xg6o9OncWfdMvptfIA2JKpVp1sKIYfcoJVwX2hEW1o3Lw4xTWaOZw1H00wE/u54douSVGwa4Ca+Wn3ZcvlJccRoVHwFtgBDh7ZJV0cmeQIrxE0Azhhmu3v/IXb7gFI0+g5iJs8FX
 i1yYI4EM
 4BJ9F0cIjgn+2pHa3/1rhYZySiJrLkVwXSpByaktvl1vZBHRT4+Cq19ytTJubMsQV6OjJ47/XfvxHS3AdDoKoVbGmcq4XWXVNZWwhPpOaoDzeIHQfPkJaw9LcghpnNywt1CJjvikYxXSvurkB4cK9LY2934NOQvEiuwMhlyLh1gBBBLPqfEVh/wgWWwI3sM3/in/A1fEOF+XTvMdyGdG79g4kEeM8YmLei6MHeS1euWyKJh672bRnexPrUo9fvVnIby23u+HqoMRHe2ghh9ttZu5K19gyDQidr8/c+uotWsBDS2h+97pwmXtKHsrvxtMapGpaoayXd/9+IRuFPePMDIpSpWtcqH14y21dopODV3CMBbzUc/LaeQE5UgKz0EQbjPH2CBqMVgDfz8MGuKNuCmZgZ//V/pfkw/aGiK8C/Hh9l3TxzujqXFQElrxJpmCTPDlcSzZmcedEdn8h04QQLaIwaJGP+bMhr0ABAOS+TtOJ8+2T00SyhPPIX6caOfywtDjNgG2bblJDBwjeo7m6OJDYB9vaeAD6B6HVjSxpKao5wDAtiZi2WwQv+Q==
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
 include/linux/swap.h | 74 +++++-----------------------------------------------
 mm/internal.h        | 67 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/memfd.c           |  1 +
 3 files changed, 75 insertions(+), 67 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 48cbcbe534bd..ea5c6860c539 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -293,39 +293,19 @@ static inline swp_entry_t page_swap_entry(struct page *page)
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
 
@@ -334,42 +314,7 @@ static inline bool lru_cache_disabled(void)
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
@@ -390,11 +335,6 @@ static inline void reclaim_unregister_node(struct node *node)
 }
 #endif /* CONFIG_SYSFS && CONFIG_NUMA */
 
-#ifdef CONFIG_NUMA
-extern int sysctl_min_unmapped_ratio;
-extern int sysctl_min_slab_ratio;
-#endif
-
 void check_move_unevictable_folios(struct folio_batch *fbatch);
 
 extern void __meminit kswapd_run(int nid);
@@ -551,7 +491,7 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
 #else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	return READ_ONCE(vm_swappiness);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..6843b4a2917e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,6 +24,73 @@
 
 struct folio_batch;
 
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


