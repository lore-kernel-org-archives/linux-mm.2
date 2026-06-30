Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC319C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817EB6B00BA; Mon, 29 Jun 2026 21:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF316B00BD; Mon, 29 Jun 2026 21:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE856B00BE; Mon, 29 Jun 2026 21:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3991D6B00BA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:08:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB127402BB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:08:50 +0000 (UTC)
X-FDA: 84934794420.26.BB9930C
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id C0F1E40008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:08:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i4jLU6Zs;
	spf=pass (imf12.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782781728;
	b=pMqKvPts9LXC6j8rj/xjGKX1/ZLjxCdwRNVUnc/Ja6UbMKuhyRSxNnHRrgVat+j29PTVDB
	Ho7sH2Yd9dVJfZkM1gtPmSapJo/5EmVajjycAHveppnSdyD/f3UCq9MAAfJ03/8i9qSGRR
	zbkK/RiaDOUqhRgVBZLWonxLQKoHcVc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782781728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wsC4ibU+bFhqJ2SO7dxDXLRm5lYVtP1esDuPTrSveg=;
	b=fE3H8xCaiTHE+8+yZP5qX9YiEJu98xWxOOwFVHTANg3mskoRePhtOUZYxphYG2XLbqqvrn
	Gq2fbggrHGqXjOSbeXlpTwpY/U6pqs6vc4zc8BiLslsP/4fmYEdTZYudi11OQcpTojeC95
	lcs90sZBaTrVJs4YOP05uUDR4Di8iss=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i4jLU6Zs;
	spf=pass (imf12.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-842358aaf36so1706235b3a.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782781728; x=1783386528; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0wsC4ibU+bFhqJ2SO7dxDXLRm5lYVtP1esDuPTrSveg=;
        b=i4jLU6ZsGfCDqY4XfxCgCLMuz2mLPi1UkUQIM0vlhq3NGkaI5MXogEbR18ZIqbMGuY
         QhYj2zUnaK1LW58pcCW0MUKETO/06NBpfvB6mf1H+Rm2zTHPKrFg+T4JZMPOg/llUXja
         gAmN7rIYz+CrC8OTmVDczEjAznhXrlTPiDILdggAMlTjXwf1wEdgXNbJ6cdCgPupL7k5
         aD6S3zhdvq+1Vs3gvBkmo5yGQOZbKpVRaFbkbXd92J7HRNQPEoUTSasxzUOtWoJWEeKm
         U6pipMlYssMkXw4EV4Gz92/ety67ZCFLpcn0YjA5o8UchsLKetntVg9NMwkYPI6n2DW3
         KAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782781728; x=1783386528;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0wsC4ibU+bFhqJ2SO7dxDXLRm5lYVtP1esDuPTrSveg=;
        b=G/X4n5HMzvahM8ofYCQ3mJI/KbckHAv8qKfiyN32s4O0I5mfnHmzf6q/tkmUM519U/
         gFPFvZvbHZlVwZ4Uy+OEkdf6IK1Wd5AWMhzWVU5lgRkA2ETDdMTxbYIKxXN1edKgcMhn
         3sWVLLoIkTnAWGz+5tJVQxWpeEzjeRRT8dLfrweVU4RsmXNtn0XroPSzi1mnyfvxHEif
         U5HFdpVRkGjwgWFnX+Cem2oj8YoZYGkfMRbvUddHjg+3vmqgG7CBWD8c21nxOqbb9ZnX
         mpM6EoL40NisBN4rPcCmVJK8MFSynfUqL85Nvv46ZjAqWLnAjZOpyTOnd5qQouDN3Sr1
         NxNA==
X-Gm-Message-State: AOJu0Yz6arEV5SdgZpcllxrYq2GRc+ctztYB10kLy3ztACqVv+j6pZ7r
	4TKoQB0OE6f4crQvcLWjQFfv49giNd3kIBa0Iqh0pfSsbGaLnxnEIzpx
X-Gm-Gg: AfdE7cnvv0xjsrk97RckZ+YssSclkM8+LRnk00kCqdPQOjFiC5K9JUMXeDLE3C7ftQE
	qSf+uVPpMr/VAd7Mftbh3KO8bi5SpTTDq1exwm3Gig4OweEjoWI2KAEbiWAZNx8VNRHpbl7FuJi
	4SSO6IZr1HocvnO3jti9NFfYrIG3srikHFrMcoWI3v9WyVELb7lumnytbAed0fg3zE/DX5kwUgB
	XGZrtyqX55v6HhWXBs1WF53ELUq2Am61SAHLTmbbe4qHaXQfHqFPVJLw2JofR5vXwMZQbEB3r6c
	7q0SNS3O4KxXEivBvDzWjWuQ1S9hC/bFqERiwGL52kBFTiL83fUbVc56ObBqaLj7lX2QonaxfoB
	jUFUqd4XPD+h7CVILUNBlyY0Saa+Yg4EgLDGorWAk+t+erS442rUOVajF+TkDZe1rUeIRunC2ci
	HF7v5/k7oXjnmzXtpQGTX0gmp2pMOwcWjn3Qp1jpKJTIUgz4CemQxrJRBLIF4=
X-Received: by 2002:a05:6a00:9a1:b0:845:df39:b15c with SMTP id d2e1a72fcca58-8479f2b625cmr1188935b3a.37.1782781727680;
        Mon, 29 Jun 2026 18:08:47 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([203.18.50.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a005afbfsm653310b3a.27.2026.06.29.18.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 18:08:47 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 30 Jun 2026 09:08:19 +0800
Subject: [PATCH v5 3/3] mm: move reclaim-internal declarations out of
 swap.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-3-4627aba8ed1e@gmail.com>
References: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com>
In-Reply-To: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1782781697; l=7989;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=lEoc6fmBIVcyCGMOTJnDQjj7lHqRFs6S3s68NobX/6o=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QFtgwlI9SmhWEjrAscbsQSiwexpKAiAE41BXNZkzWt8lb39d2sD5zrVmy3VvIS57HZS3bYuDkSv
 Yftv1piUUQQ8=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Stat-Signature: 5hgthqurqgeraa4p14i4uwcnq8bdpgt9
X-Rspam-User: 
X-Rspamd-Queue-Id: C0F1E40008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782781728-568297
X-HE-Meta: U2FsdGVkX1/CVZSMSqfu57bShsol1YY3D4ZNsvj8cfWG2kNN+xtpVAPC+HLu4YwzdkJvpt36HkqzwH78AuKoClQVn47YhtCQzjF5D3lYqOY8O8BWh+UCbU923dz7l+DyfRl9HjyXLKYwLOdX8R/TzVxivQ+8Buh8Vx1FHp9AtyRLBHQw/ap30JCE3nddoJEaCohUznVW32Ug3h56HGxkn1Gho0ZTQiGjjQgYLOOyRWu9zzi3d0P1rfXfk4JLt4Pqe19KGJmTvwXo5c6mtSFmgdrmRykcnzEQFg6gpSZtspFwvGvXuTfyE5Cl1kHnL6ZCX/FUNF+CfnPzDkvMh1liad1tkyxXylPs5+HUTb5uHcueycRB1Or63R7QLtlbalN5sYZXr3v4YLQd1XBMQN4NeWmEKe3wzn5MG06zHywesvIg4nlW7Utp30f3sZUhdumFpw8v0Q7dli30c8/THBnvbHimE69Lg/uF6RZcEI6RDXZCy/JQ2ftuCVNm1tbvr61rL2xNVYH9iUfCm3KH0kkZu+51VpeiILZLhCEb36nqNwLLcV28/Vvl3pzdWjOV8EeETT6ZgEXh7eOJ3ak1PzqEIqpx37pvWL52d2h5J5SbRjh9B/X/uhVhSSig0TNs/rxevQngcQ4FXX4gjehElFg1nzMQPfb2YxcLCxFz8TkSRoJoShXDXgcinrd1RrqMQoN8ZGbzoPDOWod0mGW4H76HzbDfbtyz7vLGhFUIBpHYJtNP99atXYkSauUQkGkQSF9NAPnqmmLe10HCO/jPtaujsc54M3rMlOUrsNTlQYA5nmZjTkb3ND7xSn8CnG9vAAVSiIuyjCS2S2UXyFeOPETfLt+9i2BB9XdU3u+gNYTY2YxaUOYqtj4+5Dntky2zpTnqPKAq21LgxNks2YfkTK/BonB/T93O2D+XaYUdDakGwChRM1s5h+TRDCPmvrvsgjHX1fAXEv+LyhSCXBrw+lA
 RlbpP6/k
 2LNHwgFTHJOJlPYTb4D1MXSuJOa0UraaaUIAfc1pI49Fb0nARhH4BhANa+kCAelhvpVU1YJD7veQ/cubkYJzIRMyTh1aXdKR6whkq1YrNFVnPm426W8rfRCVJETYSFBht5hRBVl8IYaqJRikNjjJBwVxBrTQ6yR4u5hJ5mcNiBRL2W+mDAaam3ln4evQpeic8JRI5PQSYSaKISuhyt/g8q/AoRolXtBOh71uelVBv90ENqqMhiMyhm1OEnHKxjz7W4+Ib9pOvsQM0Hudp05qzgd7c4CM85YAaoq2UXJRB5xTI28roTooThUAFc+6+R9kwRR7ueLyDWBeX2YuBBtRxjodXeZQrgn5x35PDQrtgUBVGAjnGpRPB8MzwAQwL2wl5Enz6kOzi+ZPeVJjZgZh8TyBJzQp35z4gzD9bJmJt2wq8f3MzxTE98eF7P5Xg03xoFdrosEEeWDM1Utc2ZWZ4Ol0+zOVvNVKUMtv5dBE1TC+AvrZaJFhkpHrl7KyQ0LEVjUZBQA/phTwsIuIRb4rT6jNAONgmFItRVwj1J/t7jz1ZX4I=
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
index 48cbcbe534bd..62482464c671 100644
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
 
+/* linux/mm/folio_lru.c */
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
index 181e79f1d6a2..0c2ee47d8936 100644
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
+/* mm/folio_lru.c */
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


