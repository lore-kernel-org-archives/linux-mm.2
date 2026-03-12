Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37180106ACED
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532936B00AE; Thu, 12 Mar 2026 16:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6496B00B1; Thu, 12 Mar 2026 16:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E426B00B2; Thu, 12 Mar 2026 16:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24D586B00AE
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:53:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2FF21403CB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:45 +0000 (UTC)
X-FDA: 84538612410.22.39B1E12
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id EC46B4000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JX44SdrS;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=meNuwYi96fVzujigXO/A5TlsI0kRYb25p0jCYCvGzAg=;
	b=CS1eCY9xvYoA1a8JJLVygBGgnY3is50BeV0G9XNziEN619/wRJWrQ+4kZDL42fM2KJAnOj
	R+8a/5hhsCRQJ6jBYwfHc1E84i3bZyKe8wyJMB7ofP8cDjLMA7Z2NhPX+7tEsR4TKcSfmo
	uLCUnX10BKLIca2dmBEkr2AQ/rSvDPc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348824; a=rsa-sha256;
	cv=none;
	b=MxM3pDrsDpnEnptszUp5ShgxEkTKFBAwclXOvsqRcVrvP5t+MY4YqBE4Dj+5anz1GN7wVb
	dzcxrFpy+vMF91XGQjVosvDHmLhJQ4BThvxVVQUnAxVzqGJE+mtTvy3XEhu8izZgv/5YIZ
	ot3sOSim4aj0giAJvXRTdWN3GZ+1Y6w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JX44SdrS;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cd8576a512so272866385a.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773348823; x=1773953623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=meNuwYi96fVzujigXO/A5TlsI0kRYb25p0jCYCvGzAg=;
        b=JX44SdrS2dDXT9+aG6D7WF2QsW2mTXWAsfYUKBVxpRfbj3fRGEMceFCxXC1uGeP6wY
         8NTVzSPRN0kzQt26O8I16EUx/bnbWlrbQ92eGGjACMdLQkNsX7Zk2FcoHbncAlcYVYKS
         gqPDpZBgmKRZX6l0rLlcvPhQSFs6unphcPp20R1Ild91fc7fCzPXtzqX8wosDbsysR8v
         OdMEUykcXHeqNBowHV9iIGjSM/+CAtL6rWSq+xRZzFRHVgFofNFNUgxpB43DjYnviJE8
         JCyR27wfCJaZQCu6zlnfmAvAk5vZ/Vj+/NLpHrNkvytRr+RzEnqjMGJcyuIpOw2/MJc7
         WkLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348823; x=1773953623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=meNuwYi96fVzujigXO/A5TlsI0kRYb25p0jCYCvGzAg=;
        b=r6UKZNXi3EIxedvkYeQiVi5ybdm8BbX7FrpQjmNK5zKkib2m/WN/s6Yy/W5GaS9d8o
         ARkSFjhUlelJ93bPzrLYlOgZxSUKnVqMiQ/PysWZTq25RvsrbGaCjhHTtz27m2LN/8PA
         qVke+zD2tNKS8KE02coTmPA/eHOV75rdzsC5k6rkobojoIWUQFjfAVUcjHXxaAeW5kSU
         lJfQDRrFfzn/AyufEdZM1S6ht5GeqigXU/LcmD6SstswNGGmmHMYwQttnaBFLihhtSxZ
         9VYwbYXU8lArjZnIp0vXgo/aqh68g2c1iveiSWK2yy8Vo++FeN9aVJJDQft9ToPy5Zu7
         ZEBg==
X-Forwarded-Encrypted: i=1; AJvYcCXIt60P+AXtXgotPxS2jDjVeRNVSB6IgKBMRfjArlWlMu8JkWKTQyLd3HX3bGgnVK8Z3uSRU9AtnQ==@kvack.org
X-Gm-Message-State: AOJu0YxEKBbeTXTTG0gItquWVPaekisFPLjpdA+esTczsI4HkijB1qzx
	cEz4aEYK/f6nrK9vbWa2OHssrsj7NX+Vn4RGf0Ukc1a9PhG2+J6IIz0j0MHvJLFnZNU=
X-Gm-Gg: ATEYQzz3hkebPntmY9i1765ejUfxr0Q2yUXtiLTVgtOb2Gb/FRT42ZRxQ14BbZ2EGNH
	dXBmi3cuckH4UeKExn+CbP8RsbGDi7cd3e6rFfH//nBJ93uUw114fRurPUn7aWjt/tPJj4pN2+W
	tlweRDGGmOJYAvMDScxr/0i32UFVZrr46+LAB6KaNozwSUgXK+71F4XlMnTFOloF97jEOFmnmu5
	IDNw+ipAKr5IVwlViXGSH2xs8E2WMYqrQ3Rq3AWd1Vmjrfzx1FyttLPArA5VKNDfHs2xhpYR9me
	+EGznoC0iOkXoIhU4mbTSxJDVd9iiecnK26jt0dRflEGW3v5I/naSRsihX8QTMKG02shIenPapQ
	DOM3CbquJlOjTvfBY0ME+GIHbGLvyljSWQd2JFNY9FM37wOBSjgFBXmc7zCU2zoLrabpCpc0C/i
	Y/b4WBd5gWEg30uVpYecyYxA==
X-Received: by 2002:a05:620a:4694:b0:8cd:8987:41b3 with SMTP id af79cd13be357-8cdaa7a33c8mr614912485a.11.1773348822904;
        Thu, 12 Mar 2026 13:53:42 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda21100b8sm417782085a.29.2026.03.12.13.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 13:53:42 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] mm: switch deferred split shrinker to list_lru
Date: Thu, 12 Mar 2026 16:51:55 -0400
Message-ID: <20260312205321.638053-8-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312205321.638053-1-hannes@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bznxw7ndyp8u5u734if6pz7ce7k316yg
X-Rspamd-Queue-Id: EC46B4000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773348823-550796
X-HE-Meta: U2FsdGVkX18Tx8TZ+uN1y5/U9h+x4NRvd1tPtPLjRl4euKr/fjgCn3VsKud9T5438NhwG8dBjfy4Mz1dXEQkh0N0lRGBARPymV9yaMDTZDleOD18gfRr2h/hmQeOPuz7ew8/nltzM7bewLFU3oEuaK1IEbb0/2dVB4vLnEEWCOF9gHdqh1DowoM63gBjKBpO77WIscNijSSLWFQTkA5ySx/7zsk2WSoQ5bR6e1+v0Sefk+freomcGA1HUPkexSO0EM5aXjIDaj4Wjn/RhFOTyTai/nmfZhFvGbQZ5/K6kwx5sEXYCY/w71iqhB3e0AI5O6ADBvvzHtoHG+Eo6qrQqkheNQC8Ex5HTNzKESCZoncjwqon6PyURbRS+1wapF+43Cy+LQjkQoHHJ0qJU2YKMh6i/BNfFqQbJfSOrQwpRMKs+EOxJR649u2Q4KiMa8Io1ymMfdZJm7dWHyCJsc1ciskHon/7LGheSRSTmF9XWnIq8sljn0fJzfQRpjj389wKO7W/UR6/C4YYMrMT48sRycClFFiAGl1z55zJjzTWC5eLXVcWpWcxiEG37YNPS2X9JtKBsEszmgIUwuaaiQ4SOVRmQsoOUwemwUapBvncfDFGWB9/ks79OiFT1aqOyUvDdK3Me+TwYq9dlt6WtMKfaVk7bFpWf0gGnANm2FaVl9q8OlA46bO4k1QjrZOdsrpEDoDYyX11lNYfg+Qkg0sdhK15223A+0Te5k4+ImxzxXy/fLgMCiUTVkHSxMCPwbSz+uJa+sSgCOo4wC08L5lded6aRZY1NTRdJcHlXGhOS8IJgxlqrjjwNMUQ9HZL6jefigjX3Vd9zCNDVwZmefTQ4aYzvfYAT/QTbTzTX+qCDK6dqilEzpYcmel5FHwI171QP8JvsNS1xiWblYdsDSm0I7E87VlbwJNB+b//KRmJmVmDfPg8vnHuqcRajBLCZZzwFMGVGcKVKYmoD5DM9mq
 B9R5deOJ
 rbNkGFz+zyCP9EOOKt3pVs2V6VMdnWqrr70WkTOQaVZ2MzbiU4aMaxt/VqVmKEJV01US4zvRR2URQFSN4rQdbYlHHkFSb+83D7quR0jhmZFvyenGNGT26XkhB/I9zVMRi5nssux3Q6fVN0/BB/ou0b+7IijdpjlWKc0LIloTymZXjyUJCVjckKrJ2d0uRxAA+etpxp4UGsy74o1WVbLZnFkWvpdsp/OZNsPjj1whbKhqdJW8A2+S8RvSAiAQRAtnIUYVwnqbJBTOVz8HFaDlHdfCOVYLgLNUqT0y8wvzDKTbT0/xzWnbEaBvQHBKR9scD6TPkUUEFFFEEVZ5ZIimsDG1Hfu6YnFo1+mdcFmw9zRMLtjbs5hFXcWYhdpAKLIVY/lxseJoA01g+SMKO/5KINVWXI+0p3Nn8AHsA5Ha3AeWkK2/lzuAM+xvrdu7Vh/aUu+rZFZBCzfvFzcv24ULHeXDmBg==
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
memcg_list_lru_alloc_folio(). Add calls to where splittable pages are
created: anon faults, swapin faults, khugepaged collapse.

These calls create all possible node heads for the cgroup at once, so
the migration code (between nodes) doesn't need any special care.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/huge_mm.h    |   6 +-
 include/linux/memcontrol.h |   4 -
 include/linux/mmzone.h     |  12 --
 mm/huge_memory.c           | 330 +++++++++++--------------------------
 mm/internal.h              |   2 +-
 mm/khugepaged.c            |   7 +
 mm/memcontrol.c            |  12 +-
 mm/memory.c                |  52 +++---
 mm/mm_init.c               |  15 --
 9 files changed, 140 insertions(+), 300 deletions(-)

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
index 7d0a64033b18..ed9b98e2e166 100644
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
@@ -3802,33 +3706,28 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
 	int ret = 0;
-	struct deferred_split *ds_queue;
+	struct list_lru_one *l;
 
 	VM_WARN_ON_ONCE(!mapping && end);
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	ds_queue = folio_split_queue_lock(folio);
+	rcu_read_lock();
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
+		rcu_read_unlock();
+
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
@@ -3929,7 +3828,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		split_queue_unlock(ds_queue);
+		list_lru_unlock(l);
+		rcu_read_unlock();
 		return -EAGAIN;
 	}
 
@@ -4296,33 +4196,35 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
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
@@ -4330,7 +4232,9 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
-	struct deferred_split *ds_queue;
+	struct list_lru_one *l;
+	int nid;
+	struct mem_cgroup *memcg;
 	unsigned long flags;
 
 	/*
@@ -4353,7 +4257,11 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
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
@@ -4361,36 +4269,20 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
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
@@ -4420,45 +4312,47 @@ static bool thp_underused(struct folio *folio)
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
+		struct list_lru_one *l;
+		unsigned long flags;
+
+		list_del_init(&folio->_deferred_list);
 
-		folio = fbatch.folios[i];
 		if (!folio_test_partially_mapped(folio)) {
 			/*
 			 * See try_to_map_unused_to_zeropage(): we cannot
@@ -4481,64 +4375,32 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
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
index cec7bb758bdd..f293a62e652a 100644
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
@@ -1416,8 +1403,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 
 	pgdat_resize_init(pgdat);
 	pgdat_kswapd_lock_init(pgdat);
-
-	pgdat_init_split_queue(pgdat);
 	pgdat_init_kcompactd(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
-- 
2.53.0


