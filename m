Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D441077610
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AA06B030C; Wed, 18 Mar 2026 16:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202F56B030E; Wed, 18 Mar 2026 16:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CCA6B030F; Wed, 18 Mar 2026 16:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4C056B030C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:04:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB1291391A1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:16 +0000 (UTC)
X-FDA: 84560260512.25.547D363
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id C8D3F1C0016
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VnnY2pn6;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773864254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQl84LX5jU/faihyz88LAxgFR4VTOd8RY4OIYdmlbLQ=;
	b=ywRF7eEBjKiSB20gXSxnZ3rN3vq35Ve+kSU9SvsGK00Z+LChWNZV0ei1M8R1HGnfopIZeJ
	kKfualhH6pmbcoQWtqYQWP2qL4NIu74xGt9ubJtzeL0aZAmTgQ0+RQhUg6fF2YMamn55Nj
	Bj3BEmJe1mRpcPuiDVtR3605UKrPpy4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VnnY2pn6;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773864254; a=rsa-sha256;
	cv=none;
	b=JAk8NqH5mr57RvAQqCkunuSaNNTuPRoPaRWUqpgWc5w7TYXdBEvJXbXVqmBW+X49Bn8GvR
	bbFPy185xPz0FwQCDmqvWKuIXvRt4drozV+uJlfGa3VFrNiSuFpIeUKN9vj0WAWwxI9Djt
	rhxFaOO+jBF3uOma4+i28HJm8oxPO8M=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50917417efbso2017221cf.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773864254; x=1774469054; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQl84LX5jU/faihyz88LAxgFR4VTOd8RY4OIYdmlbLQ=;
        b=VnnY2pn65g3Q2vQ9UHNXUxEDeuKn9f+/YVX0yRTqwoqbBJYhnyBRpW8mx6QBd57zzQ
         jSq4DrapP/ChdcUJUnI6WzcEuauW3H4Pi6MKRvN2Bwn0NIbO5PtRcT3+pnFCYNNCkWEn
         9N8w2TBg6tZHFBLk+Eiv3REODGUFfvX41usVrY4XlK+7qBul0MuUIJz+M7fzlrbAyiAY
         8JNXsjgRI9AKh7XLY7McoDLotlIA3M9mZaHzn2sTi1/Rfd6o1cXzU+FU7Lwqfy3rWOkb
         mgNImFUsqmtjjlHImPzCW60EkWne4TU7a/4w5SmkbI9xg8snM4upSk2UWSSXBjzipzv2
         UL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773864254; x=1774469054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UQl84LX5jU/faihyz88LAxgFR4VTOd8RY4OIYdmlbLQ=;
        b=Gs1iW0QL/i0qpqjjNFXBGm8iEZPcwENQZiOeZi+g6M8Nl9BonRpO9OsETofW2b2sNU
         fdhkGXQUlTg6qAmypLo0GItmHpGYCd7xciEY+9RiggDzIK4YNFwcxGkRVytzVE43M1I6
         92hTyAcukoRcKBivB1aOc/GRIiOmp6GLld/TOZfBwJob4E/DB3KgBrlWQgpLu5TsxF8m
         j7hGaV6mh4cAO+xFGWdY2nOWzr3wnYBLV/2RjoG4+thEmWdOf30F9ZXl7JhYfm7sQWEK
         LxIg+xu7m/yZug1YGzVhIYXjuWwz3AbicpFz1LVq6NQqOEmPaui46/VOCJ+7etjufBRw
         Z+og==
X-Forwarded-Encrypted: i=1; AJvYcCW+6iHCG02otrzyEGGCpnGWyULeuCHf5uWb1zUZpcGb+TCa2UFsbBBF9tK8wqiRE94DUe1NAeNvaQ==@kvack.org
X-Gm-Message-State: AOJu0YzvudD/tyKjjXxIaDAJdBSlKXMdNz4O6mGgBhbjIhQXNg29cxoY
	29vriARq+Y4/lPspPB2TP1b3i0WMNWcFDqbYsv2H+Hp3S1WPCYADDMClQxGCWFYtyyk=
X-Gm-Gg: ATEYQzwRmuEDydpeoAQptodMCOs2SM3sgfvKfx4hrBS8edfsAD7QFDvpjrGizLs5Z14
	fydRYMNZ7OZz84fyMqw1AwPyK6lqGw9LCUj8qREeWY/ES3bgu7TXSoZZTM/gu/SPmKYreFhYE3A
	wmBa5X29u3dyuyxpnG/LzdrEUoAOfQLqqney2Dq3k/b/CC6NDy67NErOHMO8Wu0ST/suPKiaIYO
	yRRl13hPHQzxC54rCA8bHcW077pUhIpiJk33ZLpn2ak49Pv4QkQ//IQkOIFDPlI4AYPvjkbv6Y9
	9SJRRoYpaZwDoiGTgCCaoGtwuNuYf6opwXAbhHa99iM0Ri08w7Gt6aJFNe/BtG0lpsGaqjoIfgN
	+A3CpuroeGpuPzLEHmLotA3XhsjGEP4oUuQ+i4BIBpxVoygAetOXyzPSLnmpK16mMsooXZRVR2R
	u33B6JFfWwKGhoTcTBe+4BIQ==
X-Received: by 2002:a05:622a:1394:b0:509:205:230f with SMTP id d75a77b69052e-50b245e8c17mr13724351cf.4.1773864253286;
        Wed, 18 Mar 2026 13:04:13 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b1348ae9dsm37621861cf.6.2026.03.18.13.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 13:04:12 -0700 (PDT)
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
Subject: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
Date: Wed, 18 Mar 2026 15:53:25 -0400
Message-ID: <20260318200352.1039011-8-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318200352.1039011-1-hannes@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C8D3F1C0016
X-Stat-Signature: 53z8716x38kk3euqo8jt8w1esom1w8xq
X-Rspam-User: 
X-HE-Tag: 1773864254-103862
X-HE-Meta: U2FsdGVkX19ch5OmgbRHGvrR5ANq2MrTb7fA8KLoPRKgu7qsklWJqydYAnW16WlfP2c3sj8FF65DBPZ6uXuulABR+6XULmirw4ZH9SEaNSKnhTUZ9+9b6gDuu05TMXQl0IqQv+7SAzLjb+qc2tNUWS6eECQpzK6x4nDOM7J3+BhqcNluTvs0m6u4SfpNdBX0ZCXOZ+RHq3CPBoLDQT77Yq8LT2cUxLhdAOf76NBqYTGE0X0fTUUqzd9QPjiOohhDYA9GqJZh++mLM+EfpX6UMVhlW4Y2Po1DL6wHUgc6DDNtr9WkP0NMTBq8AR7uGpVQKVWj/pPE5qr8/0UXHhXQ9hrEhCg6//lOInkgfa/A0gKcxjyLE2+bt0g1dNLw8j/PaCLwqUA1mvZLAzM8E50trDnNSvOeWSl6UZ283zgHyGIJS3aqPonYZaEjS2T0lDei9dQeGRwnhrSs4XApgTCbqB+j+pKhMSAoC3dRcMLc0H8oDX4WfbefMCtuKgfG2zIMKHQKia65Yc8T4V6nnnvLz+XEXbX7kB+Pq1I+YR/XHcH8AAIflLl69x38f/ytjh4zsnR7p+iEkFncQhU+9arlB4AFetlhf/FfywBjxNoeglJC8rGbUuxHDrJ4VWov/Xh8Q9sPz+ng6cHXU77j7Ok8M0CpYuZ0WP/Q+ufrcxOnAvnoPvEw/9el775mZDflYktQgCnUUiZhq73yk/3rWTGUydROSecJGjWXqQKWBJ7JRzW1pYItcQc9votqUBbgTsE/n+BMib7BZSsos4NT7GfmTBUu00+BftlSotQpvvo7FXUnGNKfsgVk9tlj9AAhM1cNzt89/fDc7cFWDtINoCxHY5Tk7bdBm/AQaM5uEXixHoHv8oBuFhOIeKa3RI9tY+yFTSZiFgjzWzJlm2yEVxnODN+7tiu7zR1Z13jQX8SBiJgyzoysA+SUDS8j4V/ARcKVll2YkX17kc9qvNqf1WY
 7/Sf5N73
 SsGF8yGa8XuU3f4oaCrdeWRz8SS2a1H/hMUlLwUhjKEJxN1Gq7jwf24STWbFOj7PciiqyXcA3n62ouWPpiTUYSms4+Qx51/YNKSbG6osM/4XMQa0zd/IJZ/omfhVwvQB8taA2iERfG1W2LKZjQFsh30Tl3Zh8BGF3Dtsh0FO9bpOUO5knftxSTLwLt2WxJ3/sCybT8mAVYciMG3d34oi+NY7qMQYkB55N7Gye8eOl+mo35B/WIuQA8d3Yy/KkSHS5cBStQW913YSmTUlBKraP43+RRPzA1wYQGmGvm/dUOAvE49OTHRKcYdO7zxGV2Nwe87teVLIBOHz+mPDCsZYCfH0Ejrl47orAL7b36y1+ercRZ1z1eAY4O3S8dJdJ+T+tVInR85Vg75/o9esFWZIT41m3NkcTuiIvrIy9gS8wt8QJCV3fqJG5vCqzt5XhMQc0iQIgp1CgfRUwYC4NBDFlUwevpg==
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
folio_memcg_list_lru_alloc(). Add calls to where splittable pages are
created: anon faults, swapin faults, khugepaged collapse.

These calls create all possible node heads for the cgroup at once, so
the migration code (between nodes) doesn't need any special care.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/huge_mm.h    |   6 +-
 include/linux/memcontrol.h |   4 -
 include/linux/mmzone.h     |  12 --
 mm/huge_memory.c           | 342 ++++++++++++-------------------------
 mm/internal.h              |   2 +-
 mm/khugepaged.c            |   7 +
 mm/memcontrol.c            |  12 +-
 mm/memory.c                |  52 +++---
 mm/mm_init.c               |  15 --
 9 files changed, 151 insertions(+), 301 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bd7f0e1d8094..8d801ed378db 100644
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
index 3fc02913b63e..e90d08db219d 100644
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
+struct list_lru deferred_split_lru;
 static struct shrinker *deferred_split_shrinker;
 static unsigned long deferred_split_count(struct shrinker *shrink,
 					  struct shrink_control *sc);
@@ -919,6 +922,13 @@ static int __init thp_shrinker_init(void)
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
@@ -939,6 +949,7 @@ static int __init thp_shrinker_init(void)
 
 	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
 	if (!huge_zero_folio_shrinker) {
+		list_lru_destroy(&deferred_split_lru);
 		shrinker_free(deferred_split_shrinker);
 		return -ENOMEM;
 	}
@@ -953,6 +964,7 @@ static int __init thp_shrinker_init(void)
 static void __init thp_shrinker_exit(void)
 {
 	shrinker_free(huge_zero_folio_shrinker);
+	list_lru_destroy(&deferred_split_lru);
 	shrinker_free(deferred_split_shrinker);
 }
 
@@ -1133,119 +1145,6 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
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
@@ -1346,6 +1245,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 		return NULL;
 	}
+
+	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
+		folio_put(folio);
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
+		return NULL;
+	}
+
 	folio_throttle_swaprate(folio, gfp);
 
        /*
@@ -3854,34 +3761,34 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
+	struct list_lru_one *l;
+	bool dequeue_deferred;
 	int ret = 0;
-	struct deferred_split *ds_queue;
 
 	VM_WARN_ON_ONCE(!mapping && end);
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	ds_queue = folio_split_queue_lock(folio);
+	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
+	if (dequeue_deferred) {
+		rcu_read_lock();
+		l = list_lru_lock(&deferred_split_lru,
+				  folio_nid(folio), folio_memcg(folio));
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
+			__list_lru_del(&deferred_split_lru, l,
+				       &folio->_deferred_list, folio_nid(folio));
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(old_order,
 					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
+			list_lru_unlock(l);
+			rcu_read_unlock();
 		}
-		split_queue_unlock(ds_queue);
+
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
@@ -3982,7 +3889,10 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		split_queue_unlock(ds_queue);
+		if (dequeue_deferred) {
+			list_lru_unlock(l);
+			rcu_read_unlock();
+		}
 		return -EAGAIN;
 	}
 
@@ -4349,33 +4259,35 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
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
@@ -4383,7 +4295,9 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
-	struct deferred_split *ds_queue;
+	struct list_lru_one *l;
+	int nid;
+	struct mem_cgroup *memcg;
 	unsigned long flags;
 
 	/*
@@ -4406,7 +4320,11 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
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
@@ -4414,36 +4332,20 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
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
@@ -4473,45 +4375,47 @@ static bool thp_underused(struct folio *folio)
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
@@ -4534,64 +4438,32 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
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
index f98f4746ac41..d8c737338df5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -863,7 +863,7 @@ static inline bool folio_unqueue_deferred_split(struct folio *folio)
 	/*
 	 * At this point, there is no one trying to add the folio to
 	 * deferred_list. If folio is not in deferred_list, it's safe
-	 * to check without acquiring the split_queue_lock.
+	 * to check without acquiring the list_lru lock.
 	 */
 	if (data_race(list_empty(&folio->_deferred_list)))
 		return false;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4b0e59c7c0e6..b2ac28ddd480 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1081,6 +1081,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	}
 
 	count_vm_event(THP_COLLAPSE_ALLOC);
+
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*foliop = NULL;
@@ -1089,6 +1090,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 
 	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
 
+	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
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
index 219b9bf6cae0..e68ceb4aa624 100644
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
+		if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
+			folio_put(folio);
+			goto fallback;
+		}
+		return folio;
+next:
 		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
 		order = next_order(&orders, order);
 	}
@@ -5169,24 +5175,28 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
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
+		if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfp)) {
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


