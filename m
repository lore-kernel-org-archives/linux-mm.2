Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 681DAC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ADA56B0092; Wed,  2 Sep 2026 05:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FC86B009B; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF2566B0099; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5E0E6B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30BA614014C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:03 +0000 (UTC)
X-FDA: 85168353606.05.DAEA14E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F67740003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BBCLszTC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788342661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2dQXb1lz4llCnXkv0VrZk8Ylh5V6MRgLDxHaAuTA6A=;
	b=otTuMz5f4NuHBcJbfyMj9shVRwg/VeTVwNX+1Pmdi4TK8d9J1ED8475otJrVCzqCZwrKBz
	drh2uMTh7ZcbcDVHReOumkYbkn+aQDPcodG4U9FNF9xt2QZqBP+4IPePTXawLvZ9c6Mz00
	VAXzNU2zFlmVDeMdQrDEo/JUjHLkjlo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BBCLszTC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788342661;
	b=fteoI0nMC/hZ5RjVi0Qa9QYEwi9YtWhY5i0SI7rJ/raITiM05a28zw5IWeldgmrvKeyjUw
	6IQmpv99k68bhhxxb6EVVqjPX4C29VTnP4YgM1ajZ+LzH1BsNQaCdeMU/M4hYYKsTVg/bl
	zzvE8iMdin78v0CqoonPVokN7mMRsds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F36B41B58;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12D3EC2BCFD;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788342660;
	bh=ZExROXpyOer/1fjEOvr29buFXezjDIdWZE9Wtr6aFBc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BBCLszTCCb4aBxUWh0XikYYuXsfONFOW35ddWeGLMCsnqyTT+bqF6dpU4ywybiZKI
	 817oNndFREKS6RjS1azEkxO5b4Ci/k5d1j8qwIzXecsp6OBdTGJInWTufn4NtelLDg
	 l5E7h0gmAJEXrLBJ9O6iKaVj19g6jC19ET+d9NfQGehU1NE+5LnnyPp+H+nbc/rdfD
	 k6XsKXU7LAMs8CBHxaCoR2+HrLbyfgPczAN+w730FIEIGZCTGyVE1IS8z4PUbtSo0I
	 RzTyJjHdQYKXOK9y8PnejBkV3QaZbqU3H2d2cLTBMATQqObWcvH5dLxLxQBAuavsbb
	 8mq5nHsRDiYZg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05DEC624D0;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 02 Sep 2026 17:50:57 +0800
Subject: [PATCH v5 4/6] mm/mglru: move max_seq read into walk_update_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-mglru-flags-cleanup-v5-4-9db761d779ef@tencent.com>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
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
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788342657; l=5248;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7TChCfTyyaJ0Q3bIhLSmtfbdyXgREQ74noYCwDfeHq0=;
 b=jV8xURSe/w44tQhocpoNNDiokQnNheOfpgai7WIEzKSb+pCCY7rv38ODeBRFIPti58LC4eKoX
 kOO35SR86TCB95HpmWSlqs7HriHb7Tk++yQeqwE7ASe5wFBSJMEDvp8
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: hubrjoxkdc1t3xsgoq1arsrhmpoznmar
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2F67740003
X-Rspam-User: 
X-HE-Tag: 1788342661-655740
X-HE-Meta: U2FsdGVkX19sRewbGWHcbQKtWtr6dSJBRcLIduaJ7g+I9vWyKQQCcwcrOF0YcW0xfDXkA+hvB+7Cw0bYr01vozvzRexr8Nmima42LddgBSYk27ZmcWxBmBPO2J2PLEI/gNbuO9KTEAV1c8+i3l6Pks8hc7ZhJGulOOU7djdqUPn0f8F/wcfhFyxjEdBJ1dyYPoI+3J2obJC/JQPKJUQm78D+m03Dle5kYV6E0KucwbTFI17tN+EckVABXDvikknzRD8Xno/SnBiwAb7JpCkC+lVl8In5l8gGt7PPvPHtyctqGpk4180m/PT2TrX0MZoANrvkWH9t9VWA+zEo5PQ2oiNpOAYTvFKYkg4+LkakA3Fb0a2QkMEk8ENAtab0QX3G3NjBXKMa5OeRFM8zkqXrc5nRlPZDnIZebL4wIVYrfwYkiSqtlPCEp5HiXHWabYHGD1OpHCNnFtZWiOlkHQXXUPT9jYtZ0d6CwyVnLHNkOS/Yw5fZFVl9xg+CQA0HgaDdEgYuax3A47xy1RmckrotYAFhnCMip22zA3xEUKnhCJeLOPoDshL/nF1XubHwCAdmTu/ztc4dD9pb0jVVbtC8q+ysu0tFdZdFO/Gkl+koHlyjuV+Z2c1PWUu0JSdDrvlRtjICnFk91+LI8pajOlaexfuRPNnv4f3RvyEOtzRkxuJEBOMnsd2/U7OvQDKvEa8mvK5i3wr4oGAysnngPqE6R5ErSHfZzKrGJNwzvyok6KvaNtfAdENVFCcLhFY9GjaAm0AyvR5sddFeyrT4Jw48oA5OHZ+iKKz3cutJmcXTxskVUqL0HLSn5Cnt+2waYnDWyFF/xn1ktXykxFdIxagkRfbOZHBS3Rr/BY50FZ/gz4Gzsben2wffQjuiQKoT72o1A3QJ0fqRKm0CcH6YjSRVFQOdcilkWghgQZL2yGKCPiBnYcjQUbi2lo6JeJTPSfCedWw2IVQ6SF1iRDTJNvJ
 MDCanMfb
 qQR5DI7A2YCT7zlQaysliU67VALzdDeKWW3d/L5alQKj3iC5yfg1i04ZfaXdU3s6oY+FCwXpDTsGAn7piaeYFZKtvdUrdr5XJywJxMJik/05/914sNybuYRNYA46xC/ZWhcTKsGSUPOQ9/2v1HsgmjhbTYLVbGJpj+d09AngESXGnmJE5rFIuChrP4VVOlbRaobJwxlXSl78himL82lqusVMc3ZTSCjW7ZMpI0KjjV+RXtwoevDlN7Q5E3u9DnMhzedH6MmruPJ0xuz8bqF3sRv4SenZdGlwgacF1qiXDrGO2hOv/XhK5THglcjH2ToN/hC2CM/DJ9rRhjADJGlwqbNd6MBvTcWj6SBFoMqqhHop2wp+n/JSyQwyvQ4OUaQaSRDxdWi8hxJO6EBW81LcAKOdMWIOc6AmMsE3n3svs1KvfdI9k2kHnU1GvnOHdN/BgA3B0/eH+m74kQVingF/jZ4ckuYq30NtK7Gf9r2/UtVVZDIqvM58y+YU0OHARJE62/RluT4Rz9+xeffntb6AxuY/jB4seJ2rZt6rlNjgBeSDKLQ0RwSmVJ95DeA==
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

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 24d09711e820..96fdfc14f615 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3517,13 +3517,15 @@ static bool suitable_to_scan(int total, int young)
 }
 
 static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
-		struct folio *folio, int new_gen, bool dirty)
+		struct lruvec *lruvec, struct folio *folio, bool dirty)
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



