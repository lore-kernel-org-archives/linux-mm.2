Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA25606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XhwWY2h6
Received: by kanga.kvack.org (Postfix)
	id 33E726B05B4; Sun,  1 Nov 2026 21:50:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7FE6B05B5; Sun,  1 Nov 2026 21:50:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DE126B05B6; Sun,  1 Nov 2026 21:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8E086B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:50:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6889B80B53
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:50:06 +0000 (UTC)
X-FDA: 85388649612.14.A8B18B4
Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6CDB620002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:50:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XhwWY2h6;
	spf=pass (imf31.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793587804;
	b=LcV8/eLIRUqDqg7ysdCO0Dz0yrZS12FELRKymPGZoOrfLQW3gKm5NqcQjUivoLDLHt3W3W
	u+hGIe0IWYVS63tdEKzRvB3H2cExQY7+1sNnmRhsMN7yvJ2Fyhx/Jx9GhQVobX8YyZD0Ad
	T9dDWEcSGXpCkn7n7aBArMALNf4WTE4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XhwWY2h6;
	spf=pass (imf31.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793587804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PapBgzOyZnAsoQCK2k5mMlWe3Tctg64lj1GVjzYd0Q8=;
	b=0cAoKAAjPANf2+vBC7TSN2ISRXynStJwdaxBeYfuZmZ+7q74xIqYJYJswQoY5Lgo858vYQ
	ENZ+tA/8wUSR+G5McD6yumj2Li6tp7n2bokaRzOAd/POnQOdGYHdkO7LJnOFUXP4r+t/0j
	xy7gFg3nle4vIRZP8FvIK+pzCtoRtuM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Z9acv076wT5xIN3whZ7kKd6coXEQxd0rgX0Tu8Z5SNw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793587803; v=1; x=1794192603;
 b=XhwWY2h6EZh069tDtWt7fl7IYIunrs2S2GMV7s4ubhw/3U8GgOAijA9w1qv7v19pWgXUHh+2
 pG3+KMyGyGpUPBM1N1hl1aK6luXgs3J4ItlwalmsR5X9iDc8/d+BPqjMvcjzW9eNb+va0FsZWNz
 aMzZ2zARxgazGciUyCRBr71A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id df44cd3dce38ba1a;
	Mon, 02 Nov 2026 02:50:01 +0000
X-Mizu-Trace-ID: df44cd3dce38ba1a
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
Subject: [PATCH v2 3/3] mm/hugetlb: Fix NR_HUGETLB accounting for surplus folios
Date: Mon,  2 Nov 2026 10:49:10 +0800
Message-ID: <20261102024910.31486-4-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102024910.31486-1-kaitao.cheng@linux.dev>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CDB620002
X-Stat-Signature: qbo7ihqjzxqott1y5kc39n4rrntrs1gz
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793587805-754162
X-HE-Meta: U2FsdGVkX18XCp58NVBLcd4Fa6EHRMA0VBjdw8wvdn0S5HPHNh66TbB8BCvH+cAxxQzTcVxoo7+vrDo0E1Qeu0LtK7a82GRJ0kpCXkRVC3d39Z/vCuxat/0zry/ZsUfDqJtqqx2ZyO3zaFf3eU92yiYRPQStaktQma7t6AuFY8vf6btC9OYHZ5Ks2uOGRsqg+JNp5r2PXlryjtxtsu8SHk/D6IN97D05XYLvY9OwNcgHi61NCgiM/aNYCzHXgZX5y/zCRF/5Gygwultqq99HYM+1IOh1xuCakfdxYXGTFgdQz3/Tc84nyzM9wqL+VsVKONOtSyxBzE7irz7WOrM25ViyFkrZ00ERpMagHaINEpiGDjTmX3jY0iRC2oTS/INNzx56Io1GhvZWNUaYm9hIRGzlvs9AdfT+3ENqjgUibJNbvgNdhWoECkVygXdbaMKAm1T1BFKKYksdRwMss4Fnvw8ekqLT9mc0MdUxSg5bwr7xw0UlxcDokrsykfJBVrFNKuOVSFSSQJ5XrULacVO0Z4dwPlF/+vyqFF10snl12BJq5tPtTiff2zEYuX3pF9pj/zW/RpEK3qfN8p8PjKnv0Ry7cD95x15At3gPDoOXAxJE2RHqXmIC8iI6yFyuYnNsd1lv9w1rPZo7aBT8KPUswG2ejqjPDJGzwtcRQz3hWosAGsFe5HxcW/2VHZBKuLsZPcov1mig+iXGTXv+EIvqjNw/k90bbIQpjduFbDlYqZUJpwrpHpHE0JKqgGOMneFeaqy014P7uY+qCkKVOj9+Ie0bI6AWTmfX3SClfgrhyDcuE0hjemEfatZLIJLQqogktSWgVdOcREiZxxPSdBpJf9Dcla+mZ/41hpXWdeppUQDxSrgohk8elUETDge1z6QybxqzSB5Dtu8Vv0TjjeWlk3c67qlcuMSefxicC0ioGucRLuedckNdyMtY9mvTgFGFv2pXK3kUrT5AY+RHBOL
 HrZl18zV
 zZPuMu77SXhsSIgBuNrizT2GQ1knslPMJJd4RIn6xTgGu9+APussRbzVG8rn4YMfBUO6EoTDAEHF2eWXDnun18PGslRrWu2jumrvjvBrn+r4wGsa3VYJMXXEeWdlYq8X8q/eklhRf85Rm7sWbCGnCEdToOr7huiyHC0YtvHiyJVvX7tEgw1IZ7iYCg6ApRiW4x/ayoizVBw0any6ThSa9BvOtGxPSruJdLci/crssNQA3OMqv1h/hXXb6evWIeNeiOGjPAbVi7Vuaort7+f6OxvSN71lk39TjwCYR6lORaM+FvgrQsjqI3riQCEHlH1nWuKgObUCHlWgikGav3d7uriLMUFlzttzgncYeKPv5rghRyLV9YJkY4qL+edsQ0jt1avxMst7n1m5aHnOZNriA01vq1Scm8FYjigrx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

NR_HUGETLB is incremented in the allocation entry points, but decremented
unconditionally in free_huge_folio(). Surplus folios allocated while
gathering reservations can be freed without passing through those entry
points, leaving an unmatched decrement in the per-node counter.

This happens when reservation gathering fails or allocates more folios
than needed, or when the overcommit recheck rejects a newly allocated
surplus folio. These paths cause nr_hugetlb in /proc/vmstat to underreport
usage.

Move node accounting to the underlying folio state transitions. Increment
NR_HUGETLB when dequeuing a free folio or allocating a fresh surplus or
migration folio, and decrement it when returning the folio to the pool or
removing it from active use. Balance the temporary increment when surplus
folios gathered for reservations are added to the free pool.

Separate memcg statistics from node accounting, updating them after a
successful charge and before uncharging. This keeps node accounting
balanced independently of whether the folio is charged to a memcg.

Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Closes: https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c    | 42 +++++++++++++++++++++++++++---------------
 mm/memcontrol.c |  6 +-----
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 931ca3a30773..d1d7e14858d3 100644
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
 
@@ -1416,6 +1418,9 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 	}
 	if (adjust_surplus) {
 		h->surplus_huge_pages--;
@@ -1693,6 +1698,17 @@ struct hstate *size_to_hstate(unsigned long size)
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
@@ -1740,7 +1756,7 @@ void free_huge_folio(struct folio *folio)
 				     pages_per_huge_page(h), folio);
 	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					  pages_per_huge_page(h), folio);
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, -pages_per_huge_page(h));
+	mod_hugetlb_memcg_state(folio, -pages_per_huge_page(h));
 	mem_cgroup_uncharge(folio);
 	if (restore_reserve)
 		h->resv_huge_pages++;
@@ -1756,6 +1772,8 @@ void free_huge_folio(struct folio *folio)
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2123,6 +2141,9 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	 */
 	account_new_hugetlb_folio(h, folio);
 
+	/* The overcommit recheck below can free this folio. */
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
+
 	/*
 	 * We could have raced with the pool size change.
 	 * Double check that and simply deallocate the new page
@@ -2160,6 +2181,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 
 	spin_lock_irq(&hugetlb_lock);
 	account_new_hugetlb_folio(h, folio);
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2218,10 +2240,6 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB,
-				      folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2249,9 +2267,6 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 						    nmask);
 	}
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2369,6 +2384,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		if ((--needed) < 0)
 			break;
 		/* Add the page to the hugetlb allocator */
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		enqueue_hugetlb_folio(h, folio);
 	}
 free:
@@ -2944,13 +2961,6 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 
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
@@ -2965,6 +2975,8 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 		return ERR_PTR(-ENOSPC);
 	}
 
+	mod_hugetlb_memcg_state(folio, nr_pages);
+
 	return folio;
 
  err_uncharge_hugetlb_cgroup:
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..3bfe4b108170 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5417,11 +5417,7 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
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
2.54.0 (Apple Git-157)


