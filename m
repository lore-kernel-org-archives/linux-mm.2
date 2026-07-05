Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70774C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 14:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A4D6B00A5; Sun,  5 Jul 2026 10:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB046B00A6; Sun,  5 Jul 2026 10:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D18B6B00A9; Sun,  5 Jul 2026 10:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00AFE6B00A5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 10:13:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CBA91C5037
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:13:32 +0000 (UTC)
X-FDA: 84954915864.30.4006520
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9101B40002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:13:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MielkzYa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783260810;
	b=YiHYfv5LMgFVXD2o63lwSVb+A8xQ/gU5/BdsSC7y5m2p8byC1TbnAMG22A1tmjB83c9jRZ
	w8hyiOrX+sSeZHwq0Kd5rEfyjg+SS5bSkcAypIe28CdO3NePlvbTf/RpZbbQdPz33KMunG
	oxNFKQflpY0AagceSuU8I4720KUkzQQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MielkzYa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783260810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KD3puzdO3zNM++MosBOhLaFI4GrSRdgd8q2304qSZeU=;
	b=3KKvXymjRiRkk8YxRzhr5m9NLVHHWNvQsMkIbAcrvu0y1v7+gKjxjdZTP4Sih+wfgKX8wl
	cXsSxnVMwPgGQGhI2e45RECd1zKveaYWItOq0qyPyHs8ogom2VBeBBEObUy6bn0A/0aSRJ
	pOcZj61thZGHLaguKFC5vVvsataGWtE=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ca1479dfe0so24596585ad.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 07:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783260809; x=1783865609; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KD3puzdO3zNM++MosBOhLaFI4GrSRdgd8q2304qSZeU=;
        b=MielkzYa4KB0nkWrbtPHVEmV+Rs/sV2jh7Yc0LJRs4JB+R66fDUc1YityOasQsCgdD
         D6kQiT0MQ4jbMEVOnu+Pmh/DCRkVttozxmMdeHJL5aOxeaIC7n/XBY+ofIatIc1qQkDB
         a2crhsDEtKw0Jg1OSOdRoTxBUp4atKav21TyCOcJOoz5ua13/qcxw+A4hzG9HGH2KMQL
         G0bBuILpP19OujMGVZwsj94w8ijREYW410CyFlFKHbmEAjMdUon7mZ7vLxyv6+J2SD9i
         +hWg55nWnk0T6PfUGkthwMFTVhP0yirLCn4yMMI2YgqmjZYQSl+w9iUME20McnAPUSPI
         B9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783260809; x=1783865609;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KD3puzdO3zNM++MosBOhLaFI4GrSRdgd8q2304qSZeU=;
        b=g3rIrSVUhuyIptbE3UMYJqpfK/b8/OP6cDJwRlISJS+pj/KHpQ6AbxJ62Enj1KzZGW
         t4TMZLoZ5et8Sro7qoeEkjmRde1oTqtdDpNt4nRhfcnIFLiOaedQqaXNC1m4er6kP9vc
         qF7eJJSWGa8cFvKGwxEoWTSsm06rQxZgyMNMckPliKJ8rGJymd2ipgq2J2ZU18yubPCO
         0Etq1I2dExEIoq485+mn2MLTf6c3heRlcY6RNFbTw2UPb8H+tIBlVfC0WDKfnN3S37Uz
         bwTaoL4TPq9ixda21SALp9xpC3PtzovfR45KsoOLamRC2CLmVMCQN7SEKTxUEpVmmX55
         b/fg==
X-Gm-Message-State: AOJu0YzLlHTW81cIBWVw0UKmwVoFRix6iqXubD7DW1+0N2PwTScZVKfl
	FiCgkz5AXDJ5IAm8umLSo6NCDT+80CnUUNdCz5R1KVXsSlwOJxLgE8II
X-Gm-Gg: AfdE7cmqyVMXZfEW34tO03Wn8zCHm8G2bktKkKuIcXxGjqWUhLWLhTwl15Tphqqaowf
	GK/j/1kWV3nDpyku+S6XNI4r4CrCf+l/AArRmQA9X6bOA7g96F7R6p1yp7DOD6/R+9ZSELNXg3S
	YwXsL2N/+ZglrA5n6HtMCR65OH9nBBDTCRCLqH44zWiMfE8bmVzcQ8BG4zlw0vbCBmlbyrPDFPS
	0NZLyPutqpUWSN8b2wBBaZX7urd1neX8Cjr7fY0S22OYuCzQNP5FfMSp2dUA5NNvqMNeTIcZjhZ
	sMiz+3ZGhwIdOBtpv5TU9+/xFG75FjI+cRRTNjy162ld1+xh8KYaHnceRO1K1s7TMb68Yj2ERcR
	UvB2iLFpwIqVy4IcLzZY69vpx6SeYXtz8beETGVpUHt1nIVgy5CIsTbkI2WIzgT21PepNlsQTRM
	6yxUraVM4f+QboFNtznQne6zf9RrfgHNAI48i9hlorJIpej/i1SvJ/ewqBq2KKbyc=
X-Received: by 2002:a17:903:1208:b0:2ca:d820:b9a6 with SMTP id d9443c01a7336-2cbb9ee4f7amr66159395ad.23.1783260809457;
        Sun, 05 Jul 2026 07:13:29 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad6f260basm34169155ad.16.2026.07.05.07.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 07:13:28 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 05 Jul 2026 22:12:33 +0800
Subject: [PATCH v7 3/3] mm: move reclaim-internal declarations out of
 swap.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-3-a028e8b5fc3d@gmail.com>
References: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
In-Reply-To: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1783260776; l=8023;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=c2aWehUldFJ6gV1953fK06n/cKp0RWFXMqpIh7GrrCQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QB6JcfTN+mE2CHPBEqR+/87U1NvqNZUiG5beZpyUtBxMWLwnIn9JVPq6J2+mxbjcT42cmMpNDBw
 kLjThLFtHXAg=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Queue-Id: 9101B40002
X-Rspam-User: 
X-Stat-Signature: 6oyscwb54xnwofje8cep1pdomjxuuf64
X-Rspamd-Server: rspam03
X-HE-Tag: 1783260810-708566
X-HE-Meta: U2FsdGVkX1/BE7j5Yk8OBwrsYTE3yISHGh1hOSD0hhXn+Y526xGULkvr7tqDhjkSXRv96Yz3hRSGGmH5v7Bc8z2JT/Re1mAQtOKXHNDZAI+Tc/Li9VBx38nvuTrrFRqNpIKE1OF7ccXM+mHub1uqDzXx1ROkzzCZRPISBQNUqWQjIXRQFX6K79+0qG8txT/qZfZuGxJIwXY9g4hL9RRpv0ocjYhiqZV5Nm7NWj54iMj1vJ4URBGCIsRlDZ86CLtW6T2hKYYauDAlnGVhAAAgBnwo/nxnjY9ZWdbpvYGrSsnPa0jJgTA72EEgUon2aKWUbSzWW3C7aiFbQncd0zfqK4/vXf5jQ3qMUTTH8NWWFvRLLqlOLRgzXGtlM0rxc99Iv9FK7Gb6ayFXg6BcrXC6g/nqmU51afXb57l3vf/oQMhdrDsB1v4/esnqGO70Z/TumU1RG971rn6wEPngxVG1UhI1/9eGrE5BCLd3/DCM6OO8hd9Dl1oIVF3nInVjdgxJysRUjVM29sRe6kSxaC6mPHXwsMUg2UeooAYv/8mFNCETyMzQ+RsWEXUmerNo4YB0f2QYMLFnFLVSCbjNMxRGPmMz4y7wyU43OKGszOuVts9DhJQQkzJFL6cGp4w5l3dLe40rofJx5bP5PWi6xLeYrMX2nF5R11t9L1FyQWAq1wqOOdS8saPy+vkmvZr6LX8zYdz46zr+Eb2YfMbp97onL4Yiu3oZJ/ZoA3cqpnMu4ItsBkrxWHONr4ymqFI1yaEMO7sx2ilAUzyxXFj9TlyCYjKpmezana4rNjFJRmF5vvZO+MCcCjbY6F5mh33LO5eXS7QgHmDLNgN7AP2w3CrT5mGMvxKyX6ks7YZndray0MA/FizRkIXTK2dKuypQ0vCTBuZzL+bZas8qlA+fKgFVex/HDFf8+VXEEj8ICZa1cVvJniplPYB6drlJA11hUIY4TfqAgbCdY4RMJBU8gjA
 FcixD/WK
 3LNGymSIrN4bXsRgjCGuiyTM2znq3EHwy8rNJsAMmsRtyR/WZaoQm1+UxrsTJvtI8Rq9pHJ3E/zMldlLgpgb05iFSMWDb5epmvY+gvKEMIqHgEQFAYXBAq71IVtGpqBrmnCAW8QoHUb/8KAiZVIn1ZoyequsF4zuGnX2rOw1vuVhy7RjeE3vt5yGNwjBVDGEPCKps/RjY0Bfmqu6YeTpigFEcRrUCOEWdBd3plFhIBc1ATKbNz/6cVlgW3oRdiVOtSIqmvNE6jJHaQYbQx8Tp8R3RkZ0fk8hBwZKQxktiH11YN1WOhDlfy/o27+dDqbelziPdEwns/w0eefj6q8Rdynqn67n+7L7vVYvrN7DrjWUPEVKmZDPbvo1d1Vs9O1ch+GOZPk/dAkS1YsIuDHTTH1WJ9t6V0jt9q3FdLAPO5d0Bz4esgFBbMyfV/0TSQlSP2d4uQgXHZq564PJCeoRdhyUwAn+ZskHJruO13PRGXxViukU2dOq8krdIReFXBTCHs0ytel59nkZV+tJL5flykwbt0oSGVa6JZjASBki50sHtitk=
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
index fa4fb69444ec..771bd3581fc7 100644
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


