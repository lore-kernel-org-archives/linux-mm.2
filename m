Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14868606A337
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XHqjXr+Q
Received: by kanga.kvack.org (Postfix)
	id 3CC566B05BF; Fri,  6 Nov 2026 05:06:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3786B05C0; Fri,  6 Nov 2026 05:06:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2938E6B05C1; Fri,  6 Nov 2026 05:06:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0258D6B05BF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:06:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94BBD140C72
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:24 +0000 (UTC)
X-FDA: 85404264288.28.502422A
Received: from mta0.migadu.com (out-135.mta0.migadu.com [91.218.175.135])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8C9D120009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XHqjXr+Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.135 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9BnZCc3AyeXmUrPueWNphtKIjBY7I8CwK6A+9WhDPY=;
	b=l7rh9MBVHeWtAGGUgHTltuCX3Nbi5xYQoyybNM4tv9sUYZkJYSwPy++wuitjDy0iN5YWyF
	OTnQmwc1axlk/Kd/hntzh1WeAVVkGgxL/siWgttZpBLN2jW7TgiTH0iP8D68ysD5VvSHEI
	GU19ddsaVSSaUqL87ho7zyk9Tq6Mrzs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XHqjXr+Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.135 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959582;
	b=z9wdlE8lg8hiVEKyvuwzj4uGbCRSuy29gzYV/LHKit55goFOiWa33DpBijHCyIaFhRhynt
	yjikwl6SW3mZkiFh48hQaLyQMRFXndzfdIThDQ42VFsKD670ViqSD9K4ZuyUaov2tWlAgl
	6EC8WbOs8zf9WfMsaYIDWg2sxtedZjE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cz8qa6DzkcisB34BFCPw3QEyfCK3GSBqxBmS2t4VIu4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959581; v=1; x=1794564381;
 b=XHqjXr+QHtEpiO2gAWd7JpqDjzsiNAXBluTaL59ZvfPvBL9bfhTMbQn/uEWvVr6RhNb9vCg+
 YoFapqP2M2Vjk9Y6q8a9w4cK415laXIAZom2hEVlMjqeG9U3/xlMhZH5Fdc4CMXsGvPbnZO0Nkp
 3U8gzbdDcF4QG+0uKMvkQTIM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0b034621e7146dc7;
	Fri, 06 Nov 2026 10:06:21 +0000
X-Mizu-Trace-ID: 0b034621e7146dc7
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 4/4] mm/hugetlb: Account NR_HUGETLB at folio state transitions
Date: Fri,  6 Nov 2026 18:05:21 +0800
Message-ID: <20261106100521.30099-5-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261106100521.30099-1-kaitao.cheng@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A8C9D120009
X-Stat-Signature: x7bmh1g3o8rejmcaczhbe5o8gzz815p3
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793959582-935182
X-HE-Meta: U2FsdGVkX1+4po9BQJ/NerMWoL8Mx1reZpp+m4VaHZdij+BM7peGrV/q7l41i56JoWB+i3bZYUuOnlInImtk0S/PVUCk9O6jhfsOqKNwqD6Jpj9WdIIZcUP7+xW86Eiixl+6XNW6f1A7f47PchVhp829zhos+yifzSGW/BzVukAOiRV1dnhHqmBjEhVFNZNlOHfUhJfU5pRAIxKhIKkHyD0NuAyQ3a3HvN5wJVopQQh6EazjwaKB3DTwcPL5yDaM58LHIKJw8LjG3BOyvK+JtgR7EZD2V7ndQRRDSD7ee4bAe4YKZfdSnoijn1arleDFPxGEN2RvhDh/e+zTTc/76Ad297bb3NAxz+l8tUKOSocr3fW8V3nS3jLkSbAXoxeA0XzCAR44fBI+BDUmR5Gkyb4yZhOpsdE0mi4RwiX4bfLZclYJ6hoiGo0zTM/oqwVDxw5cL/zG7ML/EBF6JsjH4i4VwhT4tFu+y7hfhFXnxIQDbciobdIQNUKmQykqunulDyLTYiBNuGIk2VaOJnq69mJQbOl/s4sEk3bvhEoMscnA5sj1AtozXA71p/7kEsvyy3CP6WZdjt7MeJyouul0vjxoUQIQpgYrOpd1npaXyWW3735N7Nb6yEAUvEOVAokFUf++F3nLEVzdn7tvZ0yaUzHb9eX5ePZGD6BP4IpwpgQl1AwQLM/fHnwON/XwLzWOzscS/vq6cJ95nL3LppnpisDbiKrbLDTFGDCSXGO4INIErnTsKoh9KH2WPj3C9shpGtFL0dX1FGrimKLlR/ooAlgka1BvHPSiPBFLLDAM0usWwbU6DunThAiHnwdE1uZTS0TB6US8HHo6n/8HDQtHYVcI8HKwJ/PIyVBkMLpWzdbm1SDMBvvtXim9maYxWQ4B4ALOOcviEbHFaERjF8uZ2Fc7CVVgtEdgvJSqZci5rCQc/LquDHYqt7yLJwEQKqvCUwzH1rCUbG6Og/CJmBi
 q+dphfnQ
 4i8H+VchkUGWfTh4ekHW75LvtxAGhsqYmZDa7CwZ8/EudXUNpL5ol1NUimLElVx+baK5FixJnV2QNW7w+OFFE3lAaJNLmddsqYMb3lbwfUav2sYECzPtZFl50T7o199HGtdp6+5K03IwpNi6uOcAYO5RBcZbcQOQq7Duds3lKHm5zJOKKzGkT4DHEulCzqzICCYLjef9MO7esl8+lEkXROVIu40NXQJk+zezyCJQn/t6HxADBEConufN4YeGi+OH6H0/1d8Ea06v5iYw5lAmbyWNlgR18qKiwfXnbYCJrQLlj2nFrSTi8wIoVlyey9q8llPC/eGYAv406ylWeFRjFSz03JKbNZRZhlWN3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

NR_HUGETLB updates are spread across allocation entry points and
freeing paths, mixing node accounting with memcg statistics. This
makes the accounting harder to follow and requires compensating
updates when freeing unused surplus folios.

Consolidate node accounting around folio state transitions.
Increment NR_HUGETLB when taking a folio from the free pool or
allocating a fresh surplus or migration folio, and decrement it
when returning the folio to the pool or removing it from use.

Separate memcg statistics into mod_hugetlb_memcg_state(), updating
them after a successful charge and before uncharging. This keeps
node accounting independent of memcg charging and removes redundant
updates from the allocation entry points and surplus cleanup paths.

Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c    | 50 +++++++++++++++++++++++++++----------------------
 mm/memcontrol.c |  6 +-----
 2 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 31a92ed4165a..70a2e55b2895 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1288,6 +1288,8 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    pages_per_huge_page(h));
 		return folio;
 	}
 
@@ -1423,6 +1425,9 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 	}
 	if (adjust_surplus) {
 		h->surplus_huge_pages--;
@@ -1700,6 +1705,17 @@ struct hstate *size_to_hstate(unsigned long size)
 	return NULL;
 }
 
+static void mod_hugetlb_memcg_state(struct folio *folio, int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	guard(rcu)();
+	memcg = folio_memcg(folio);
+	if (memcg)
+		mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, folio_pgdat(folio)),
+				       NR_HUGETLB, nr_pages);
+}
+
 void free_huge_folio(struct folio *folio)
 {
 	/*
@@ -1747,7 +1763,7 @@ void free_huge_folio(struct folio *folio)
 				     pages_per_huge_page(h), folio);
 	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					  pages_per_huge_page(h), folio);
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, -pages_per_huge_page(h));
+	mod_hugetlb_memcg_state(folio, -pages_per_huge_page(h));
 	mem_cgroup_uncharge(folio);
 	if (restore_reserve)
 		h->resv_huge_pages++;
@@ -1763,6 +1779,8 @@ void free_huge_folio(struct folio *folio)
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2130,6 +2148,9 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	 */
 	account_new_hugetlb_folio(h, folio);
 
+	/* The overcommit recheck below can free this folio. */
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
+
 	/*
 	 * We could have raced with the pool size change.
 	 * Double check that and simply deallocate the new page
@@ -2140,8 +2161,6 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		folio_set_hugetlb_temporary(folio);
 		spin_unlock_irq(&hugetlb_lock);
-		/* Balance the NR_HUGETLB decrement in free_huge_folio(). */
-		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
 		return NULL;
 	}
@@ -2169,6 +2188,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 
 	spin_lock_irq(&hugetlb_lock);
 	account_new_hugetlb_folio(h, folio);
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2227,10 +2247,6 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB,
-				      folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2258,9 +2274,6 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 						    nmask);
 	}
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2378,6 +2391,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		if ((--needed) < 0)
 			break;
 		/* Add the page to the hugetlb allocator */
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		enqueue_hugetlb_folio(h, folio);
 	}
 free:
@@ -2386,13 +2401,9 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	/*
 	 * Free unnecessary surplus pages to the buddy allocator.
 	 * Pages have no ref count, call free_huge_folio directly.
-	 * These pages were not accounted in NR_HUGETLB, so balance the
-	 * decrement in free_huge_folio().
 	 */
-	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
-		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
 		free_huge_folio(folio);
-	}
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
@@ -2957,13 +2968,6 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 
 	ret = mem_cgroup_charge_hugetlb(folio, mm,
 					gfp | __GFP_RETRY_MAYFAIL);
-	/*
-	 * Unconditionally increment NR_HUGETLB here because if
-	 * mem_cgroup_charge_hugetlb failed, freeing the page will
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
-
 	if (ret == -ENOMEM) {
 		folio_put(folio);
 		/*
@@ -2978,6 +2982,8 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 		return ERR_PTR(-ENOSPC);
 	}
 
+	mod_hugetlb_memcg_state(folio, nr_pages);
+
 	return folio;
 
  err_uncharge_hugetlb_cgroup:
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac6c43ea8c5a..e8af131de67e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5440,11 +5440,7 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
 	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 	int ret = 0;
 
-	/*
-	 * Even memcg does not account for hugetlb, we still want to update
-	 * system-level stats via lruvec_stat_mod_folio. Return 0, and skip
-	 * charging the memcg.
-	 */
+	/* Skip charging unless hugetlb accounting is enabled for cgroup v2. */
 	if (mem_cgroup_disabled() || !memcg_accounts_hugetlb() ||
 		!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		goto out;
-- 
2.53.0


