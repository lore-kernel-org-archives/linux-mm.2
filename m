Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D78606EE97
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jouev5Qt
Received: by kanga.kvack.org (Postfix)
	id 314A26B00EF; Mon,  2 Nov 2026 16:39:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C57A6B05B1; Mon,  2 Nov 2026 16:39:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5DC6B05B2; Mon,  2 Nov 2026 16:39:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E08CF6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:39:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5841140222
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:39:28 +0000 (UTC)
X-FDA: 85391495616.12.F430AF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A2BB940004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:39:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jouev5Qt;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793655566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4k4497sTbbDvYeqvxlbwbiiYz6zh1ROyOPLpxYM4Y3U=;
	b=xrVdacybgmYs2RF4rtFesKSAiP1eBnBcCuUsXtW2yt8470wSfA7xImqctMXH7b/SLuUMK5
	fdZxea2cHPNTMYnAH29GUVs/GZAYoASxzRBvxLCxRhGnxY2Wcc4UA5wfqLHdif5TSklmxS
	Ovwjs7J5LvjoSffDhZDU4ydL9hgWMCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793655566;
	b=jDnSFIIUFbeDZAsUk7bIqq8EppMYGujR2ou2M1cdIYA0S4L6L4MEqRitPS/ySKfra6Kghm
	I9OzRQFO1C7ot2u0GNsCHa6UsGMl2ykoqXoruiXMplU6WOt1/u1+BwbuIzNkiFmfMcynCL
	YNJJsZ0tf1/8LwDebuT3nxLHGiM8Izo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jouev5Qt;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E049540B28;
	Mon,  2 Nov 2026 21:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA5A1F00A16;
	Mon,  2 Nov 2026 21:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793655565;
	bh=4k4497sTbbDvYeqvxlbwbiiYz6zh1ROyOPLpxYM4Y3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jouev5Qt+8GltlW45V5pTUQV7gF9lqCjSzgOdMtlplRDu8wkW1tS8zUxZkwrLfNoS
	 Go7Xnm7RHkpOao988ciNLcvGMB+qTzrRvSAyDHr9HGiB26HoveciMqfozQeA/1FkgC
	 dMXstNtWJirqYHBZE93b0O8LsKzBKM9XVaQA0k3yIbmMdKGp2xVmAzmwofgm3GJ8JZ
	 fCzy01U7ZfgO9h7xH6sDPIqN6Mg4KhnFm7LG+Taef7bp80Piy+npF+2+SoXjuo4cwk
	 9ezM+djl2yFupw3dIdMFU/nsKfQvTrP6uNmI8JlZOvatS8SgR7g1MLQ6lGmNTTbvMB
	 AMxMIaS5/5sLA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: devnull+kasong.tencent.com@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	cgroups@vger.kernel.org,
	chenridong@xiaomi.com,
	chrisl@kernel.org,
	damon@lists.linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	ehab.ababneh@intel.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	ljs@kernel.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	nico.pache@linux.dev,
	nphamcs@gmail.com,
	qi.zheng@linux.dev,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	ryan.roberts@arm.com,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	sj@kernel.org,
	surenb@google.com,
	tz2294@columbia.edu,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	vernon2gm@gmail.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	youngjun.park@lge.com,
	yuanchu@google.com,
	yuzhao@google.com,
	zhaozhengzhuo@uniontech.com,
	ziy@nvidia.com
Subject: [PATCH v4 01/17] mm/memcontrol: allow update of LRU statistic without holding LRU lock
Date: Tue,  3 Nov 2026 05:39:15 +0800
Message-Id: <20261102213915.57805-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261016-mglru-fg-v4-1-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-1-2106750c0bfa@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A2BB940004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3sp7cjirht4j5rob6kyfmn11natpceuz
X-Rspam-User: 
X-HE-Tag: 1793655566-940424
X-HE-Meta: U2FsdGVkX1+j3Y5i9abqc8x9RlqiroZxAcO2xqeO9PVgFitnXrcuCo8H2n4ppKudL7orYl8NwIMpLFBtSCi9Sg1D8eVL98AScICol1CAEwvKW0sLOX2q7q0aizSunGAt0KzK8P/XLudh8WbrTOmGrk+QNulAgV5vBxF68y8CAV5OmbnXbfUREHZ9XWnAtaz255yLJcQdI0ege8aYHdyw8TaN7maxrBJDU4fCzNxmoo+zK74+kPPwK7ClnCE9sSOEXLgoimprbemKEcwWh3CkCP9pVaYgqtr6K4FFV536wp9/opgoMeQH7VnQJdxW1U37IMZVpCQ4ONmga1gODViU1lmu+EXhuz8gnmj7ryG3/yhi7/iGgmJjyCysw6gqzhFk4LXjtzOxDMMxNxsoqNIY0Th2qUa7RW20KDMqXbgfe2DYiv48atXGB7VgCJ1uIZpDIGcKM/WMkJiJ4sVyXLd+C35O3qyM+qHWSxcSYjqBpRzrUM1+WboMS+t3Z1p5Xddqq5w/HEjrfhHSFsvUKahA72fxFylo+uvg2qQLqmZwpEI4Qbieyknd2siSXvlQ5PwH4LFAi5v4eTa6yJF6WUXKcPGcCR53CH+RgxLeXmmFApAr0vx1oiMaxb22WjqIXJF027CjUS/oxGHyoebvYj99Ul+6ksfRsdkliuKrkRYZCZyfB2x5ivU7oXLasgOCzmhTRdlqRW56/LRT0C8Wi83LESwraizz+aDfSfZyIC3KdAKmiRwu2kIAauLxJmJU1Tudl01T38+sKNru3GxfoQuP3C+UW1IINQxObTXYSwjR4pjw1u1r29QpPUNJPV+CgdpdtXhv8c1mwpOzyBAd8vwm3GSeY8N+RZNvWJ2oxhbzOcra45fN0zhGrBoGmHM0yBw2WN/eNl1R0pHDRX8GS3twsw5azNs7rvj16lP9jK+nZUGMZSObwmDuOvROrlo7KBkjImhALHBveBm2/ZpETpk
 Cg4okFcQ
 +bZQZJTgL13Dks6d7az+C7kI3JUZHt0d3laKfmF6L8Kc7Np5v60jc4U/dzDQvgGJqfgdaGfqfyouWj61blPy21SngK1BLD9yhzH6+JMfqlv4+OBIsSCgEdaPXwnxKVU4q7aL2+a7qetwEZCfeJHtbieNmvsE1VBknZedN6LVigxscMxAtOrpfi3MypYUyiZYjbCIR75cn3i84JMlygbtjnUIJXtQvE3V0GqdhCUOg0iz9/SD/DLT/r/hzXbs9a24e57mmCtYopsjqef3K4sD2mVI80dHln6btTsLsZxM24u6BRsCeIARqxOrSl4AMgXYYs3JkAEWqvyDEf2yv7Kqz4IbWGEyQ0JLD3ZMK8jmU27uFHCx/Y/6g570fsZUJpZ4NAkqvc23P7Wbzrwc7Ts+5YLrFGcc5s3+ERHDhLivXJpCo1no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 2:15 AM Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> we still follow final consistency of the counter, and it only serves as
> a estimated metrics, a little inaccuracy has no visible effect.

This might be a good idea. Updating the LRU size without
holding lru_lock could open up possibilities for further
optimizations.

Recently, I've been thinking about something in the aging
path. For example, suppose a folio belongs to the root
memcg and is heavily shared by some of its descendant
memcgs, which also access it.

Currently, aging in those descendant memcgs will simply
skip this folio. Eventually, we'll have to rely on the
rmap of the root memcg to determine whether the folio is
hot or cold within the root memcg.

Since the shared folio may have a very large mapcount,
walking its rmap could be quite expensive.

So I've been thinking about this and put together some
very PoC code. It doesn't really work; it's just meant to
illustrate what I have in mind:


diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7ddef3b488b3..31b02478269b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3618,7 +3618,7 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 		return NULL;
 
 	rcu_read_lock();
-	if (folio_memcg(folio) != memcg)
+	if (!mem_cgroup_is_descendant(memcg, folio_memcg(folio)))
 		folio = NULL;
 	rcu_read_unlock();
 
@@ -3723,7 +3723,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
+			walk_update_folio(walk, args->vma, folio_lruvec(last), last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3736,7 +3736,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
+	walk_update_folio(walk, args->vma, folio_lruvec(last), last, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3812,7 +3812,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
+			walk_update_folio(walk, vma, folio_lruvec(last), last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3826,7 +3826,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
+	walk_update_folio(walk, vma, folio_lruvec(last), last, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4499,7 +4499,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, lruvec, last, dirty);
+			walk_update_folio(walk, vma, folio_lruvec(last), last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4511,7 +4511,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 		young += nr;
 	}
 
-	walk_update_folio(walk, vma, lruvec, last, dirty);
+	walk_update_folio(walk, vma, folio_lruvec(last), last, dirty);
 
 	lazy_mmu_mode_disable();
 

We may want to explore this after mglru-fg. What are your
thoughts on this?

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..597f013c8e04 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -47,11 +47,10 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
>  {
>         struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>
> -       lockdep_assert_held(&lruvec->lru_lock);
>         WARN_ON_ONCE(nr_pages != (int)nr_pages);
>
>         mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> -       __mod_zone_page_state(&pgdat->node_zones[zid],
> +       mod_zone_page_state(&pgdat->node_zones[zid],
>                                 NR_ZONE_LRU_BASE + lru, nr_pages);
>  }
>
>
> --
> 2.56.0
>
>

Best,
Barry



