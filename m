Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A15B1125842
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 15:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5B86B0005; Wed, 11 Mar 2026 11:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472D06B0089; Wed, 11 Mar 2026 11:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34AD16B008A; Wed, 11 Mar 2026 11:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02BEE6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:44:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9295D8ABF9
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:44:07 +0000 (UTC)
X-FDA: 84534203334.18.5363DA2
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 76F6E4000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:44:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="uECBLh/L";
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773243845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C+i9Nph/UjpDK3DCezo2A7qGK2UP3u7YyeXIpaB6Z5Q=;
	b=Om6o1MzmK2u1QPPqLe2gH9U+XP2ei7mO0Cn2LBydtdyLyTROcmwd42bjsUKAwM/h1A+Rtx
	Plyoj9xu1sJ3CcArx9/YPMKId07GOP0RB2Lf1xbh3D00TxQ5rbej+9aUIDHmyhAT5akPxZ
	HALpV6FTKS2jgeHvEfilYIEiF6efsbw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="uECBLh/L";
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773243845; a=rsa-sha256;
	cv=none;
	b=UL7iFUldKn939rHTdqGNvTu7sovHvFph492drJ2LIA6LsxulQpE5VLVNYSbJ0BRg8DJvFK
	G/xELYkhjaAHVEgGRQSuvyfMhYZGKmlYvn02zmd/O2n+fG8kO3d/TXqt5AXpgz8jzBIqgS
	cy1fO2siQh758HkRhQu6Jmf4K0BLasI=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506aa68065eso122260421cf.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773243844; x=1773848644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C+i9Nph/UjpDK3DCezo2A7qGK2UP3u7YyeXIpaB6Z5Q=;
        b=uECBLh/LktiiwFA171XyR17pyDFK5EzPQR3GgffmqaRE7U5qs07yIHqudmpSP8y8Vq
         V4cDL8zLDe+6Nlbz5MvIQdGwXyl/AjIXuukqECxDQsXdqTsJizImRBzAt2RReOEXuiDh
         gq3wUWSLp373tRbqdIQ+T0p4wD2vxS19qA9gJY4vA5lGAA1uNsRpAaAPdoK7wyNbcKI+
         t5GacVc0Agdcl8j3pjdYkmSZSRf+xnWb3+2MiVFBX9XA7YqkwYK2K7sXdgLGmPW6IsFa
         lJLFoXTiHegWQiKG4wjMKQ3DoKOaJWvbauwR39yyhiBVNwsqfTXoD1pw5zneJFE6KidN
         me4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773243844; x=1773848644;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+i9Nph/UjpDK3DCezo2A7qGK2UP3u7YyeXIpaB6Z5Q=;
        b=tpjCpOYkQQr+TPpmCSoYSrn2mvs+H0Z4kjWKZD6EuXsMPLKxRLjCA41BR0HR1/5Fby
         M5U7AyrGLKlv+35fcok0ylB+yO5xsAr5XY04Rb5yajazySoS/VF3QsLehAwxF6YmesFp
         CIYZc7c+1eK0yNKMTGS+GiatP+n1CcxFAFf2lVamboedqr1QAV1Dk6RJNJUBgEZWehjA
         Fu7BlPLwY9Y820fcRwSOErylL7iXr9XPTQC/XwXijE4lE8kqd4jXK6GEdpmu6D9Dsuha
         E8VIv5WJJD0eDagynevb6mCrwKA3G55pv4une8WhTgK3FHd6VL4TCk7z+ecC9/RtlsK2
         6G2g==
X-Forwarded-Encrypted: i=1; AJvYcCUg1DhiD3AVpeTf89vIqHJ9oXGD5Z/eZ04yJYLfSX9xZWpU3IFeNUUjfolL5wDzrFqu6uuIwfrhLw==@kvack.org
X-Gm-Message-State: AOJu0YybKANd0/+wi6MNBYCPFxEZ2qFAe94yJqh9X8a63F+v7a6Z2D27
	VHIt6xxTGtITMtEMtuBhsz7jIe17TPbIqCzICEWrj/5xfF4R/R3aphgfG8yLZ6mp+1A=
X-Gm-Gg: ATEYQzygFFk2HMuGgU9cdizr79xnyYUTseig3EFY8WUsLUSezeCUBkp/MHHkZOnt85y
	an5IjFs6kfg+eurLMkkqOb+tOEIN8up6WlwR8x9inVm82wL4veEbDtRNq6RFD/nW1Ny61yqRF6h
	znkE4nyxPIqitEyrCLsKStcg/wpbK6wR0QPxsuiQb2ep22p/t635uk5B1BmlgW4z/RiV+WydL2B
	4SU4xM7IJNFUxvJDWkfc3/2givUa/tlB11WcNm43qDtATG5j6qJPOr+AGaAzeHHHRU0B2dBkxsn
	38qulCnZCs0FcrkbdvK/IlpAI74ooBMl4cDZ0M+/E0FwEg2Vr5BzhOmeOAWH/87bfdh1Bo9UDa7
	z6Vew0KfS0XRoh/t0HNRX5GIWFVOFoZnOovP3izeeumzFVw0k3lCLSTmnNe5XYQiuHTL/De8HyH
	lJ/O3Y3FLTVMVumnU9ghr3gw==
X-Received: by 2002:a05:622a:303:b0:509:2ef7:7047 with SMTP id d75a77b69052e-5093a1c26fdmr31987641cf.71.1773243844112;
        Wed, 11 Mar 2026 08:44:04 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093a116d86sm14495251cf.23.2026.03.11.08.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 08:44:03 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: switch deferred split shrinker to list_lru
Date: Wed, 11 Mar 2026 11:43:58 -0400
Message-ID: <20260311154358.150977-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 76F6E4000D
X-Rspamd-Server: rspam07
X-Stat-Signature: gsi6qgakah9xf8wh7nu6k3up16d4ca1t
X-Rspam-User: 
X-HE-Tag: 1773243845-326876
X-HE-Meta: U2FsdGVkX18swPU72d/5FSX8hOeHLRIuxuNDUgC9nEtDMkedClNb50NtoGTD4wzWpbeGcvVgicGSVW33/NXdSjGneevYIdk7OnkWnYx/bqf0QXj1aJ99lJH4bK2yrI0DeNpIAsFHoLlmaPzH+dnKYePKtSxyltbrqwzTqBzNfke9sSwrFjYneFwBMkbjpGoT41Gut0VytXrTqFbQyA1j+UsxF5opKN5SNuRq3smDRV2pYblsA2PpeeWJk/Ng3k6zF7TAN8Tum8sW5k7lz0eggN2xyaFaqSbNhR9uU8cMmHCipou+dponsqFQ5QtJBfIY5mulLwGqVjuRjd/CZjPxMM1XhKFz6Fsmy461pcFvGDCx+QoLn56v4J8v9KCDAf/+8K2h1taTF398MvDPgesHdYe0ABZMI5Ce9tKJfTJ7McqQ9JGf3mOgqSUyWiQlZPyKrF3lTdgkn+Yo0qiVA4+2VmucmE98UxbHvMGUyNCxgVyqpnIWdOA30B7NPsKGCFGdYs2O4Sy23uGKcNkgPSbKE19MhaNpGh6aq1/BG5FPuh9ke2x1sdNjOQJPdy4iUoQIpGoKQ5N+09zfR2ITb7qZPVpyJiANfqycZIwFCNSaXH3jh33NaTCSKxTtisW02qaiMWW8qp0Oxs6yRP/6R8fGoZGgPx5Zhkrpr/cuLBp6ilxft8OpHcI6gzPlgLzMaP/Gk0pXfvmqDuVpdunu+S3yNXx7WtUHSOjzbSl/JzVrERN/T9GBxqMZwAv1MsSMH2R8cKaJlIkf0GvCFTBqHeTcc/M50BS8L7B78flLSStc1A/X1h/KJJTkjGVzddaaxgP54NyXphAKo7qHdLbLxAwRyFkB+EGZdTdVAlVlmGkCxvMbE3PjtWK4QA13DUHJElZwk6lw6gidRclfgJuKh+kq/BQg5kzeS6R4fqqXJ+fWpyu5msKsa80lQOmNbcXIXpv86UM5NWBIX935uf/1mO+
 8kW8ldWP
 WmF1sLY9IzZLM7pUXwrXcAdgtp4EMwDFP/YaQSpCLGOSUMmpqO3h/IGu5hjIeGTqNr6rxq023OuAoOdsIhAnT7y8/eQ9bDy7jYHNg4Ho0gZ86RLsBtPm2s1wGhcErby4iAfvSienl17W0GEgKdFIzSSBfDZ6UTNpOIPAAN7peGgr13CT0i/Qqkrw+t7vagnW80FL3YLqLI413QPp1TNx/3d5lshKJUZ5M1nue8jEQP2CL8DmS5MXMCyq2TANQBcoUuNBvDmE4dudm4FwOvqbSdEBzGD1XWLkI6O/eSMY8XY+IZzzVkzVtrpgz8XACSD/RQSFVMUXrXkrwHIspnNY5OA9tZlTcJnf6nY9LA9HuQnAD6Kfmm1NDmuiblvbMCtKbnwbXxQsVsWj/AGg=
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
memcg_list_lru_alloc(). Add calls to where splittable pages are
created: anon faults, swapin faults, khugepaged collapse.

These calls create all possible node heads for the cgroup at once, so
the migration code (between nodes) doesn't need any special care.

The folio_test_partially_mapped() state is currently protected and
serialized wrt LRU state by the deferred split queue lock. To
facilitate the transition, add helpers to the list_lru API to allow
caller-side locking.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/huge_mm.h    |   6 +-
 include/linux/list_lru.h   |  48 ++++++
 include/linux/memcontrol.h |   4 -
 include/linux/mmzone.h     |  12 --
 mm/huge_memory.c           | 326 +++++++++++--------------------------
 mm/internal.h              |   2 +-
 mm/khugepaged.c            |   7 +
 mm/list_lru.c              | 197 ++++++++++++++--------
 mm/memcontrol.c            |  12 +-
 mm/memory.c                |  52 +++---
 mm/mm_init.c               |  14 --
 11 files changed, 310 insertions(+), 370 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..2d0d0c797dd8 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -414,10 +414,9 @@ static inline int split_huge_page(struct page *page)
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
+
+extern struct list_lru deferred_split_lru;
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
-#ifdef CONFIG_MEMCG
-void reparent_deferred_split_queue(struct mem_cgroup *memcg);
-#endif
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
@@ -650,7 +649,6 @@ static inline int try_folio_split_to_order(struct folio *folio,
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
-static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index fe739d35a864..d75f25778ba1 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -81,8 +81,56 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
 
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
+
+#ifdef CONFIG_MEMCG
+int memcg_list_lru_alloc_folio(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp);
+#else
+static inline int memcg_list_lru_alloc_folio(struct folio *folio,
+					     struct list_lru *lru, gfp_t gfp)
+{
+	return 0;
+}
+#endif
+
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
+/**
+ * list_lru_lock: lock the sublist for the given node and memcg
+ * @lru: the lru pointer
+ * @nid: the node id of the sublist to lock.
+ * @memcg: the cgroup of the sublist to lock.
+ *
+ * Returns the locked list_lru_one sublist. The caller must call
+ * list_lru_unlock() when done.
+ *
+ * You must ensure that the memcg is not freed during this call (e.g., with
+ * rcu or by taking a css refcnt).
+ *
+ * Return: the locked list_lru_one, or NULL on failure
+ */
+struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
+				   struct mem_cgroup *memcg);
+
+/**
+ * list_lru_unlock: unlock a sublist locked by list_lru_lock()
+ * @l: the list_lru_one to unlock
+ */
+void list_lru_unlock(struct list_lru_one *l);
+
+struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
+					   struct mem_cgroup *memcg,
+					   unsigned long *irq_flags);
+void list_lru_unlock_irqrestore(struct list_lru_one *l,
+				unsigned long *irq_flags);
+
+/* Caller-locked variants, see list_lru_add() etc for documentation */
+bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
+		    struct list_head *item, int nid,
+		    struct mem_cgroup *memcg);
+bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
+		    struct list_head *item, int nid);
+
 /**
  * list_lru_add: add an element to the lru list's tail
  * @lru: the lru pointer
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 086158969529..0782c72a1997 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -277,10 +277,6 @@ struct mem_cgroup {
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
index 7bd0134c241c..232b7a71fd69 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1429,14 +1429,6 @@ struct zonelist {
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
@@ -1562,10 +1554,6 @@ typedef struct pglist_data {
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
index 7d0a64033b18..f43051eaf089 100644
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
@@ -67,6 +68,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
 
+struct list_lru deferred_split_lru;
 static struct shrinker *deferred_split_shrinker;
 static unsigned long deferred_split_count(struct shrinker *shrink,
 					  struct shrink_control *sc);
@@ -866,6 +868,11 @@ static int __init thp_shrinker_init(void)
 	if (!deferred_split_shrinker)
 		return -ENOMEM;
 
+	if (list_lru_init_memcg(&deferred_split_lru, deferred_split_shrinker)) {
+		shrinker_free(deferred_split_shrinker);
+		return -ENOMEM;
+	}
+
 	deferred_split_shrinker->count_objects = deferred_split_count;
 	deferred_split_shrinker->scan_objects = deferred_split_scan;
 	shrinker_register(deferred_split_shrinker);
@@ -886,6 +893,7 @@ static int __init thp_shrinker_init(void)
 
 	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
 	if (!huge_zero_folio_shrinker) {
+		list_lru_destroy(&deferred_split_lru);
 		shrinker_free(deferred_split_shrinker);
 		return -ENOMEM;
 	}
@@ -900,6 +908,7 @@ static int __init thp_shrinker_init(void)
 static void __init thp_shrinker_exit(void)
 {
 	shrinker_free(huge_zero_folio_shrinker);
+	list_lru_destroy(&deferred_split_lru);
 	shrinker_free(deferred_split_shrinker);
 }
 
@@ -1080,119 +1089,6 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
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
@@ -1293,6 +1189,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 		return NULL;
 	}
+
+	if (memcg_list_lru_alloc_folio(folio, &deferred_split_lru, gfp)) {
+		folio_put(folio);
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
+		return NULL;
+	}
+
 	folio_throttle_swaprate(folio, gfp);
 
        /*
@@ -3802,33 +3706,25 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
 	int ret = 0;
-	struct deferred_split *ds_queue;
+	struct list_lru_one *l;
 
 	VM_WARN_ON_ONCE(!mapping && end);
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	ds_queue = folio_split_queue_lock(folio);
+	l = list_lru_lock(&deferred_split_lru, folio_nid(folio), folio_memcg(folio));
 	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
 
 		if (old_order > 1) {
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
+			__list_lru_del(&deferred_split_lru, l,
+				       &folio->_deferred_list, folio_nid(folio));
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(old_order,
 					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
 		}
-		split_queue_unlock(ds_queue);
+		list_lru_unlock(l);
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
@@ -3929,7 +3825,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		split_queue_unlock(ds_queue);
+		list_lru_unlock(l);
 		return -EAGAIN;
 	}
 
@@ -4296,33 +4192,35 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
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
+	struct list_lru_one *l;
+	int nid = folio_nid(folio);
 	unsigned long flags;
 	bool unqueued = false;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
-	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
-	if (!list_empty(&folio->_deferred_list)) {
-		ds_queue->split_queue_len--;
+	rcu_read_lock();
+	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
+	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {
 		if (folio_test_partially_mapped(folio)) {
 			folio_clear_partially_mapped(folio);
 			mod_mthp_stat(folio_order(folio),
 				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
-		list_del_init(&folio->_deferred_list);
 		unqueued = true;
 	}
-	split_queue_unlock_irqrestore(ds_queue, flags);
+	list_lru_unlock_irqrestore(l, &flags);
+	rcu_read_unlock();
 
 	return unqueued;	/* useful for debug warnings */
 }
@@ -4330,7 +4228,9 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
-	struct deferred_split *ds_queue;
+	struct list_lru_one *l;
+	int nid;
+	struct mem_cgroup *memcg;
 	unsigned long flags;
 
 	/*
@@ -4353,7 +4253,11 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_test_swapcache(folio))
 		return;
 
-	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
+	nid = folio_nid(folio);
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	l = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
 			folio_set_partially_mapped(folio);
@@ -4361,36 +4265,20 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
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
+	__list_lru_add(&deferred_split_lru, l, &folio->_deferred_list, nid, memcg);
+	list_lru_unlock_irqrestore(l, &flags);
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
@@ -4420,45 +4308,47 @@ static bool thp_underused(struct folio *folio)
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
+	/* We lost race with folio_put() */
+	list_lru_isolate(lru, item);
+	if (folio_test_partially_mapped(folio)) {
+		folio_clear_partially_mapped(folio);
+		mod_mthp_stat(folio_order(folio),
+			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+	}
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
+	int split = 0;
+	unsigned long isolated;
 
-	folio_batch_init(&fbatch);
+	isolated = list_lru_shrink_walk_irq(&deferred_split_lru, sc,
+					    deferred_split_isolate, &dispose);
 
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
-
-	for (i = 0; i < folio_batch_count(&fbatch); i++) {
+	list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
 		bool did_split = false;
 		bool underused = false;
-		struct deferred_split *fqueue;
+		struct list_lru_one *l;
+		unsigned long flags;
+
+		list_del_init(&folio->_deferred_list);
 
-		folio = fbatch.folios[i];
 		if (!folio_test_partially_mapped(folio)) {
 			/*
 			 * See try_to_map_unused_to_zeropage(): we cannot
@@ -4481,64 +4371,32 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		}
 		folio_unlock(folio);
 next:
-		if (did_split || !folio_test_partially_mapped(folio))
-			continue;
 		/*
 		 * Only add back to the queue if folio is partially mapped.
 		 * If thp_underused returns false, or if split_folio fails
 		 * in the case it was underused, then consider it used and
 		 * don't add it back to split_queue.
 		 */
-		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
-		if (list_empty(&folio->_deferred_list)) {
-			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
-			fqueue->split_queue_len++;
+		if (!did_split && folio_test_partially_mapped(folio)) {
+			rcu_read_lock();
+			l = list_lru_lock_irqsave(&deferred_split_lru,
+						  folio_nid(folio),
+						  folio_memcg(folio),
+						  &flags);
+			__list_lru_add(&deferred_split_lru, l,
+				       &folio->_deferred_list,
+				       folio_nid(folio), folio_memcg(folio));
+			list_lru_unlock_irqrestore(l, &flags);
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
index 95b583e7e4f7..71d2605f8040 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -857,7 +857,7 @@ static inline bool folio_unqueue_deferred_split(struct folio *folio)
 	/*
 	 * At this point, there is no one trying to add the folio to
 	 * deferred_list. If folio is not in deferred_list, it's safe
-	 * to check without acquiring the split_queue_lock.
+	 * to check without acquiring the list_lru lock.
 	 */
 	if (data_race(list_empty(&folio->_deferred_list)))
 		return false;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b7b4680d27ab..01fd3d5933c5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1076,6 +1076,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	}
 
 	count_vm_event(THP_COLLAPSE_ALLOC);
+
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*foliop = NULL;
@@ -1084,6 +1085,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 
 	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
 
+	if (memcg_list_lru_alloc_folio(folio, &deferred_split_lru, gfp)) {
+		folio_put(folio);
+		*foliop = NULL;
+		return SCAN_CGROUP_CHARGE_FAIL;
+	}
+
 	*foliop = folio;
 	return SCAN_SUCCEED;
 }
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 26463ae29c64..84482dbc673b 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -15,6 +15,28 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void lock_list_lru(struct list_lru_one *l, bool irq,
+				 unsigned long *irq_flags)
+{
+	if (irq_flags)
+		spin_lock_irqsave(&l->lock, *irq_flags);
+	else if (irq)
+		spin_lock_irq(&l->lock);
+	else
+		spin_lock(&l->lock);
+}
+
+static inline void unlock_list_lru(struct list_lru_one *l, bool irq,
+				   unsigned long *irq_flags)
+{
+	if (irq_flags)
+		spin_unlock_irqrestore(&l->lock, *irq_flags);
+	else if (irq)
+		spin_unlock_irq(&l->lock);
+	else
+		spin_unlock(&l->lock);
+}
+
 #ifdef CONFIG_MEMCG
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
@@ -60,34 +82,22 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 	return &lru->node[nid].lru;
 }
 
-static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
-{
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
-	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		if (irq)
-			spin_unlock_irq(&l->lock);
-		else
-			spin_unlock(&l->lock);
-		return false;
-	}
-	return true;
-}
-
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+		       bool irq, unsigned long *irq_flags, bool skip_empty)
 {
 	struct list_lru_one *l;
 
 	rcu_read_lock();
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-	if (likely(l) && lock_list_lru(l, irq)) {
-		rcu_read_unlock();
-		return l;
+	if (likely(l)) {
+		lock_list_lru(l, irq, irq_flags);
+		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
+			rcu_read_unlock();
+			return l;
+		}
+		unlock_list_lru(l, irq, irq_flags);
 	}
 	/*
 	 * Caller may simply bail out if raced with reparenting or
@@ -101,14 +111,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	memcg = parent_mem_cgroup(memcg);
 	goto again;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -136,48 +138,77 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+		       bool irq, unsigned long *irq_flags, bool skip_empty)
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
-
+	lock_list_lru(l, irq, irq_flags);
 	return l;
 }
+#endif /* CONFIG_MEMCG */
 
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
+struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
+				   struct mem_cgroup *memcg)
 {
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
+	return lock_list_lru_of_memcg(lru, nid, memcg, false, NULL, false);
+}
+
+void list_lru_unlock(struct list_lru_one *l)
+{
+	unlock_list_lru(l, false, NULL);
+}
+
+struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
+					   struct mem_cgroup *memcg,
+					   unsigned long *irq_flags)
+{
+	return lock_list_lru_of_memcg(lru, nid, memcg, true, irq_flags, false);
+}
+
+void list_lru_unlock_irqrestore(struct list_lru_one *l,
+				unsigned long *irq_flags)
+{
+	unlock_list_lru(l, true, irq_flags);
+}
+
+bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
+		    struct list_head *item, int nid,
+		    struct mem_cgroup *memcg)
+{
+	if (!list_empty(item))
+		return false;
+	list_add_tail(item, &l->list);
+	/* Set shrinker bit if the first element was added */
+	if (!l->nr_items++)
+		set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
+	atomic_long_inc(&lru->node[nid].nr_items);
+	return true;
+}
+
+bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
+		    struct list_head *item, int nid)
+{
+	if (list_empty(item))
+		return false;
+	list_del_init(item);
+	l->nr_items--;
+	atomic_long_dec(&lru->node[nid].nr_items);
+	return true;
 }
-#endif /* CONFIG_MEMCG */
 
 /* The caller must ensure the memcg lifetime. */
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 		  struct mem_cgroup *memcg)
 {
-	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
+	bool ret;
 
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
+	l = list_lru_lock(lru, nid, memcg);
 	if (!l)
 		return false;
-	if (list_empty(item)) {
-		list_add_tail(item, &l->list);
-		/* Set shrinker bit if the first element was added */
-		if (!l->nr_items++)
-			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
-		unlock_list_lru(l, false);
-		atomic_long_inc(&nlru->nr_items);
-		return true;
-	}
-	unlock_list_lru(l, false);
-	return false;
+	ret = __list_lru_add(lru, l, item, nid, memcg);
+	list_lru_unlock(l);
+	return ret;
 }
 
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
@@ -201,20 +232,15 @@ EXPORT_SYMBOL_GPL(list_lru_add_obj);
 bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 		  struct mem_cgroup *memcg)
 {
-	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
+	bool ret;
+
+	l = list_lru_lock(lru, nid, memcg);
 	if (!l)
 		return false;
-	if (!list_empty(item)) {
-		list_del_init(item);
-		l->nr_items--;
-		unlock_list_lru(l, false);
-		atomic_long_dec(&nlru->nr_items);
-		return true;
-	}
-	unlock_list_lru(l, false);
-	return false;
+	ret = __list_lru_del(lru, l, item, nid);
+	list_lru_unlock(l);
+	return ret;
 }
 
 bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
@@ -287,7 +313,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, true);
+	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, NULL, true);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
@@ -328,7 +354,7 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 			BUG();
 		}
 	}
-	unlock_list_lru(l, irq_off);
+	unlock_list_lru(l, irq_off, NULL);
 out:
 	return isolated;
 }
@@ -510,17 +536,14 @@ static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 	return idx < 0 || xa_load(&lru->xa, idx);
 }
 
-int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
-			 gfp_t gfp)
+static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
+				  struct list_lru *lru, gfp_t gfp)
 {
 	unsigned long flags;
 	struct list_lru_memcg *mlru = NULL;
 	struct mem_cgroup *pos, *parent;
 	XA_STATE(xas, &lru->xa, 0);
 
-	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
-		return 0;
-
 	gfp &= GFP_RECLAIM_MASK;
 	/*
 	 * Because the list_lru can be reparented to the parent cgroup's
@@ -561,6 +584,38 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 
 	return xas_error(&xas);
 }
+
+int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
+			 gfp_t gfp)
+{
+	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
+		return 0;
+
+	return __memcg_list_lru_alloc(memcg, lru, gfp);
+}
+
+int memcg_list_lru_alloc_folio(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp)
+{
+	struct mem_cgroup *memcg;
+	int res;
+
+	if (!list_lru_memcg_aware(lru))
+		return 0;
+
+	/* Fast path when list_lru heads already exist */
+	rcu_read_lock();
+	res = memcg_list_lru_allocated(folio_memcg(folio), lru);
+	rcu_read_unlock();
+	if (likely(res))
+		return 0;
+
+	/* Need to allocate, pin the memcg */
+	memcg = get_mem_cgroup_from_folio(folio);
+	res = __memcg_list_lru_alloc(memcg, lru, gfp);
+	mem_cgroup_put(memcg);
+	return res;
+}
 #else
 static inline void memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..f381cb6bdff1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4015,11 +4015,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
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
@@ -4167,11 +4162,10 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
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
index 38062f8e1165..4dad1a7890aa 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4651,13 +4651,19 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr);
-		if (folio) {
-			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
-							    gfp, entry))
-				return folio;
+		if (!folio)
+			goto next;
+		if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm, gfp, entry)) {
 			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
 			folio_put(folio);
+			goto next;
 		}
+		if (memcg_list_lru_alloc_folio(folio, &deferred_split_lru, gfp)) {
+			folio_put(folio);
+			goto fallback;
+		}
+		return folio;
+next:
 		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
 		order = next_order(&orders, order);
 	}
@@ -5168,24 +5174,28 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr);
-		if (folio) {
-			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
-				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-				folio_put(folio);
-				goto next;
-			}
-			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
-			return folio;
+		if (!folio)
+			goto next;
+		if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
+			count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+			folio_put(folio);
+			goto next;
 		}
+		if (memcg_list_lru_alloc_folio(folio, &deferred_split_lru, gfp)) {
+			folio_put(folio);
+			goto fallback;
+		}
+		folio_throttle_swaprate(folio, gfp);
+		/*
+		 * When a folio is not zeroed during allocation
+		 * (__GFP_ZERO not used) or user folios require special
+		 * handling, folio_zero_user() is used to make sure
+		 * that the page corresponding to the faulting address
+		 * will be hot in the cache after zeroing.
+		 */
+		if (user_alloc_needs_zeroing())
+			folio_zero_user(folio, vmf->address);
+		return folio;
 next:
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
 		order = next_order(&orders, order);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index cec7bb758bdd..ed357e73b7e9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1388,19 +1388,6 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
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
@@ -1417,7 +1404,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 	pgdat_resize_init(pgdat);
 	pgdat_kswapd_lock_init(pgdat);
 
-	pgdat_init_split_queue(pgdat);
 	pgdat_init_kcompactd(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
-- 
2.53.0


