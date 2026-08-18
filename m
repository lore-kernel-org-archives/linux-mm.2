Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69FABC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 05:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBDE6B014B; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C146B014D; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1216B014C; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65C286B014D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECEA21A0B0B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:27 +0000 (UTC)
X-FDA: 85113285054.12.2C6D45E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E6A23C0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CDhDxJ/+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787031506;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGj/XqG/b/XcsBA2VshjHVHLwi0OD+UmE/F5wn+ivCE=;
	b=3+6oabseW7JKlp6+S50ff7TR/U2+y/7HBAgiecnQvtqTMUUZ9u6NSh89mPpH6xSD6yKBps
	xDt1TvAfKPsQJSm4LXb0qqQ7OY1iPw/+7NM6YVZX79fJEfJXwNQCKcd0oWzYiU6ieFRFki
	81edTBDzaxGFCtd2HCMLQWiHJIMnzGQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CDhDxJ/+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787031506;
	b=SSfot87wXSyU2MflehrL3shNddhwwqH68N41LZQdrTCfOYLUjosntCpJ6MCv409Nw91eKS
	Nib2JNj3MYeZXkgaHgC+nzBHmIGnh8TJKXY9C1uWXAmqRhNZbQSfaTEFZ8IIRhzMML3NrM
	XcziEOa9OzY9YkAMe0IjsEs8KYa0h0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A67074402A;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54B7EC32786;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787031504;
	bh=OAEYAHvRDn/KTY3S+lBibMczmqVpBxMms7NDi/kgmjY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CDhDxJ/+TQh30FoHM+NxivNH1JG2DRH7QhmDrXC7BbvEHeEYqm1kd5bkAtfmZUOlp
	 pVKjvVKLQ8TFB3gq9QUN8rW5NpwPX1sfImb5wvZS0WMvF7pPMUyRUWC9RSPHXypCHZ
	 /3EhppiEwOKBJERmLnPf/0sOYpLgHf9THs10LlFtm4BKbMittHzwA52pkI3rIPzZHx
	 A12xUaMLDV2/jYO9/FHyJ4QM+XVS90Xsl1w5x+0eYdlX3zMvzoAKNhWZnFURADtSjO
	 drVDEP5RpM0xqykVEhCQENQmrJnvnURtCcZWtS44I7eOErJmtSQa+FA8jeb77KeioM
	 m98o1MqooY7Ng==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0C3C5DF70;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 18 Aug 2026 13:38:06 +0800
Subject: [PATCH 4/7] mm/mglru: move max_seq read into walk_update_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787031500; l=5056;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=xJliWtARqDMjztdZd0y51LBdqAE6bS5BXiS6nqiKTh0=;
 b=kE0rlnG7UORkiVh+WKvTvRn6/woWdPxys4/uv7e6m4BR0rOIriUl/7Jmyu83XFDkyjHEt/8J9
 jJA7X49biR3Byh4lQigV51i9AyJdJFqg1Wh0jt7fQA0jhva1/yKtx9D
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: E6A23C0004
X-Stat-Signature: szrjegn3qxhzueufdbaehbbtrh8hqiep
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787031505-593050
X-HE-Meta: U2FsdGVkX18AoJGtxxowED5NE+P/kBELXUIQfYJsqzngs3f4DeKvLxEeiWEKiC33F+rC0U+UTeeBkwj3cDb6eNWYkaDZLWOgMOjdDOaoHjmXe4MNTKvOxYX38kZm91C9Q9pw1OedkCFbbWOOgnv2vYDt1FS6hUXmAg9FmmDzdFoyU/qQXewJ3NEvdyAeMccxrZqw/T7CAHYKaiv74gXjs9BMoMgSSMoHSx9QZOU9ieB2KCMUOt9lALAyc40HYBB4/NZQJ1P2/RQ6ongKkdh6JE7g0/07TV+fgHDJ464LzI19zsLAwo0KuTDqkfWthBebYr3VJpBKOYSpcAHi1pW/SLABrIS7r0RPPX1VwNvLhHAntl/ubu0sLHwR4BEu8yIMnUfR1C+fAGKxxe2xsn5IdrAk0jx4LOoDTG3rkR3BR/mXQBw22rlnNQHLRxaglVzBquAykza6VRnuLN5no1iGstPOi3BUKiJo3tBlcU0pAscxzEfeoaXGZkxuLNvdBqyckHsxptNNjqrtvjmLTFznr1pSo5cigimDWyxTtgxqPWijtLSJ7GttC52V/zm1+UGJoUXrNRI2N/Yf6c4R+jbhY+W+n6nzCrNARkISPL21klNb7fCseEANAZ1RYL7iFBaduqPMV1Ad6OT3UV+S5oxezWuVjiYh6aLRf6As83puyuM6oeEf2wRwZ3yTS6IlgFJpKxDzU3ouHwDd8T+djl6tbu4yvoz5y7+tIKErDNAQkgZHl/6DBHCHYZG36syI9hiJHT/Zjfo+m9o9YkGNmUhhpUS82EP2+eCyIy4R8XYlyV9OICWgkp5LpG2UQAJvGTzg0kzCBkQ5V6N0sjrXowuWo1ff2dMS1B6xSktF25qOxuSoyPNTWjq1ZgRgN6R6Tx8A60MArhcL/4hvoGIjzhElVQmNvF5lajKAN7wEVL0udWyQ61Dmpgn9sWWtfFBThg0mxcmuMXHcSSL+WiMVmzP
 9ShYlwb3
 VCkDrKnLyIGcCCEtuvmfixBHZqPq3dkFyWOgyVsPubD2TzrdYvM3552eLx6M5b1bggyixsPDDd8JjZLMqY/OiS5gdVS9KfhsXxFXd8hfl0b2tAmLsZM9YXP7T3LJROft2JyCpoH6K0tqnrdNl3caprXw2s0JlYVRaHtKyYoGPPgfvn67We6bY9n82quuPcCVF1JD+fpGOh9Osh1dle0tDnWJ5eiIgMGv3MFrqURKZ9pyRUdUwiC6472F9HcwV1TSVV14tmcCPPJRDQ3/jK2QoCzsdsYlLJ7q5mKhf4TTtQZ0oFqrk4zuLTcSCdwwH4fjS/Y+xF/11EoodcmmezFzRYIc8coYDK001Lih4ayb5R4us/H/6O3/slGWqoy9dEShET66nh60TvKIAg8xUQW/L4sOqK6O8hwrUu8SMUbYB12Rp4qN3Lt3Gskd5XURyGO6kNAHCxbJv6DuseMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
each read lrugen->max_seq to compute the target generation used by
walk_update_folio(), then pass it as a parameter. Move the read into
walk_update_folio() itself so the callers no longer need to compute
or pass the value.

The max_seq read now happens once per folio update rather than once
per walk range, so folios always get promoted to the current youngest
generation.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/vmscan.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 080132997d87..a819be6b7ae9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3517,13 +3517,15 @@ static bool suitable_to_scan(int total, int young)
 }
 
 static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
-		struct folio *folio, int new_gen, bool dirty)
+			      struct lruvec *lruvec, struct folio *folio, bool dirty)
 {
-	int old_gen;
+	int new_gen, old_gen;
 
 	if (!folio)
 		return;
 
+	new_gen = lru_gen_from_seq(READ_ONCE(lruvec->lrugen.max_seq));
+
 	if (dirty && !folio_test_dirty(folio) &&
 	    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 	      !folio_test_swapcache(folio)))
@@ -3554,8 +3556,6 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 	unsigned int nr;
 	pmd_t pmdval;
 
@@ -3606,7 +3606,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, args->vma, last, gen, dirty);
+			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3619,7 +3619,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, args->vma, last, gen, dirty);
+	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3642,8 +3642,6 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3697,7 +3695,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3711,7 +3709,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, vma, last, gen, dirty);
+	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4275,8 +4273,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec;
 	struct lru_gen_mm_state *mm_state;
-	unsigned long max_seq;
-	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4313,8 +4309,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	memcg = get_mem_cgroup_from_folio(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
-	gen = lru_gen_from_seq(max_seq);
 	mm_state = get_mm_state(lruvec);
 
 	lazy_mmu_mode_enable();
@@ -4346,7 +4340,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4358,13 +4352,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 		young += nr;
 	}
 
-	walk_update_folio(walk, vma, last, gen, dirty);
+	walk_update_folio(walk, vma, lruvec, last, dirty);
 
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
+				    pvmw->pmd);
 
 	mem_cgroup_put(memcg);
 

-- 
2.55.0



