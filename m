Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D0D4C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EEDA6B0099; Mon, 24 Aug 2026 03:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C72A6B009B; Mon, 24 Aug 2026 03:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7051D6B009D; Mon, 24 Aug 2026 03:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DEF56B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:38:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD04C8045C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:48 +0000 (UTC)
X-FDA: 85135361136.07.F0EAC1E
Received: from mta0.migadu.com (out-101.mta0.migadu.com [91.218.175.101])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD68B180005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557127;
	b=CVKLGC6VRaY+88XLdZPZmNisouzlGAxIhafxUziKfOq6vYwVHGZz6iSyoQ0bEERq1sQv6p
	UzIMIviIPMCTcmRn2Ds5+EJWlXIPp0Ux/Il0bRYyq+D3yCHAAkxQuu0RPCo6XhHbQGKBJu
	1TD2U+ybhTTDQdQpPMsAvssWMW5XfbQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+s98wNo9Gh1SxlxEXAaPbYO7lHe/hmcLulbzhxUVnwA=;
	b=C2RPmFxws/NVeQvv9wUT8Dq8nWKOgZuy0M1hQ3x0GOjat/0EGiXZdGD1zJN/Z8WqafQ18n
	1ZOvsrhZZJX30ynCpkjTGWuMtuBlw6xPFyKq6tPrT6h9Uq9d0/zb6ek0QczuDCx7OXkw4f
	BL0JMABVxwY8y0flg9D1t1wtbDPgOec=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id 62eadba41bb83b49;
	Mon, 24 Aug 2026 07:38:45 +0000
X-Mizu-Trace-ID: 62eadba41bb83b49
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 4/9] mm/mglru: invalidate empty-walk skip on page fault and migration
Date: Mon, 24 Aug 2026 15:38:01 +0800
Message-ID: <20260824073806.629593-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DD68B180005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kk5p33qramsc8h6fuyp7k8du3e3uhexw
X-HE-Tag: 1787557126-964845
X-HE-Meta: U2FsdGVkX1+DbWjkJquqfJKXz2nUCIDbJdMApSRUekIixGU3vqm4Ywxa2o/9fIPr3w4U18+9OgM4ijx5vONhfXop2M3CdjAoJ/c20CrRCZ0X89Hsms2OfvLILNadDpoEg8i6NZ4CO42HqwTFD0K+YQCZh4/OZpvuOFjOn5+PabOk/eA1w4lPOX2wKuxuTDM/Z34awYR64/nQfXnq86U8EUA/wwdavCqGT7fphHGneKugVQSmV6aPLYX9YUQ76S1YU7CrNndkoqOfswywvWN319BYNSLTPcq4RXTZPcNj+zbu2NQbrmIU5MpMTXhWjlbLqhOm2beS1LO1sAbOFF7tCKKvGLtOeSEZdVCQE92M2P/zPMcviOhJNWFYoU3adMKHHrERN8IT2hqyYpyYJ2rUKybmxSNcHCHhcnNxwTU8GDHIOyE77j3g6RjBuoEz7War/h6gKiiaA6aJ9j6/aJ/ERkptqqJ3BGbJsZDTq3zRNLPImPkG9Z2WLdTQ4nh4KwUBnZfxo+MYqOwNopN19/59qIJ8GQ3yZ/xmXTt8vTW7rwkHELhzKMWJeUb+XBoq4OzWtFZkIOFxEXA+RiB/yKAf2FDVrwOpeoKZS4fWFYrUqFUGHCEle97mKJGu/UjRQsfS2fI7bG39c4ax8Hinpfu0S94rGrL4xU6PMbtztLhColLmh3ATxD753LnwoLD1qmeqRgejHt7bWFuhZgEZhZGxpebHKaU/TtTxH4Vj3P91Cay0qNFqgGNj5R70yDWl9552RLi9IrdhjbG8hz1n+fMEmXbWWwhFkZqvfA4zzKxP5Ty4qtgMyqsVFCdl1P7v41rIXbwAR9kptHh+BzldrSpOtmN6D0vmpS1el8kzWHY5L2MPdea6NtXNOtsvg+SfkJhGyN+5GbNNOX4WJhLswSE+f2z2FF9oeB8JgirDcbSNu1opTICuIOWPoOH0Tlxaw+ogQkRZlJVhk28h8aI9IXF
 F4CeoHYe
 20gxE5VoaBPwZQlPIeHItk3fSP3UOOGoZE5h9jetZ5O+E7ADNeeDCBgaDm4SKvjG3plKPwKQWOgDAznfZEzXgmAPGZ+IkM8VSEeRIO5zxNI5DWzujkwbvxNeQ3TyqKvfVo/FwT4ZIq/B4bI+yvOkiioQpLBhM3esgmd2QcOQ5ISTndHpooc3gjehrLWhqCoJw4FPIKJiKQfL0lo4CFZK93XotponOPgxYphtlrmgiOjb9L47SlVqSlPrlCt28l9E/eTGtZNK57awhCDaB/+4wle6M3ylRWzO2Ytd58Lni1GrE5q3dtNANF3rMbvuP2RwKeRpjbWDzLkd4ILB3FC6b04qiKGcaHZe37y1otX5lhN7CdaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

empty_map skips an mm on a node for up to K generations after an empty walk.
Notify MGLRU when a page of the mm appears: set the node's bitmap
bit and clear its empty_map bit, so the next aging pass walks it again.

Major paths that map a page into the mm:
- mm/memory.c: do_anonymous_page()/finish_fault() (anon and file/COW faults),
  wp_page_copy() (anon COW), do_swap_page() (swap-in).
- mm/huge_memory.c: __do_huge_pmd_anonymous_page() (THP anon faults).
- mm/migrate.c: remove_migration_pte() (folio destination node, incl.
  NUMA-balancing migration).

The transitions are rare (the bitmap bit is usually already set and the
empty-marking bit usually clear), so each is guarded by test_bit() to avoid a
locked RMW bouncing the mm cache line on every fault; the periodic re-scan
covers any path not listed here.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mm_types.h | 19 +++++++++++++++++++
 mm/huge_memory.c         |  3 +++
 mm/memory.c              | 15 +++++++++++++++
 mm/migrate.c             |  4 ++++
 4 files changed, 41 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3738e8877b73..94c1d1fedc9c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1521,6 +1521,21 @@ static inline void lru_gen_use_mm(struct mm_struct *mm)
 	WRITE_ONCE(mm->lru_gen.bitmap, -1);
 }
 
+/*
+ * A page of this mm appeared on node @nid (fault or migration): set the
+ * node's bitmap bit and clear the empty-walk skip. Probe first - the
+ * transitions are rare and unconditional locked RMWs would bounce the
+ * mm cache line.
+ */
+static inline void lru_gen_mm_accessed(struct mm_struct *mm, int nid)
+{
+	unsigned long key = nid % BITS_PER_TYPE(mm->lru_gen.bitmap);
+
+	if (!test_bit(key, &mm->lru_gen.bitmap))
+		set_bit(key, &mm->lru_gen.bitmap);
+	if (test_bit(key, &mm->lru_gen.empty_map))
+		clear_bit(key, &mm->lru_gen.empty_map);
+}
 #else /* !CONFIG_LRU_GEN_WALKS_MMU */
 
 static inline void lru_gen_add_mm(struct mm_struct *mm)
@@ -1543,6 +1558,10 @@ static inline void lru_gen_use_mm(struct mm_struct *mm)
 {
 }
 
+static inline void lru_gen_mm_accessed(struct mm_struct *mm, int nid)
+{
+}
+
 #endif /* CONFIG_LRU_GEN_WALKS_MMU */
 
 struct vma_iterator {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afbb5974bd22..23ae4626a980 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1418,6 +1418,9 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
+		/* a new THP of this mm lands on this node */
+		if (lru_gen_enabled())
+			lru_gen_mm_accessed(vma->vm_mm, folio_nid(folio));
 	}
 
 	return 0;
diff --git a/mm/memory.c b/mm/memory.c
index c54943302553..1d7ec0110ef2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4076,6 +4076,9 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		BUG_ON(unshare && pte_write(entry));
 		set_pte_at(mm, vmf->address, vmf->pte, entry);
 		update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+		/* COW mapped a fresh folio of this mm on this node */
+		if (lru_gen_enabled())
+			lru_gen_mm_accessed(vma->vm_mm, folio_nid(new_folio));
 		if (old_folio) {
 			/*
 			 * Only after switching the pte to the new page may
@@ -5224,6 +5227,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	set_ptes(vma->vm_mm, address, ptep, pte, nr_pages);
 	arch_do_swap_page_nr(vma->vm_mm, vma, address,
 			pte, pte, nr_pages);
+	/* a swapped-in page of this mm lands on this node */
+	if (lru_gen_enabled())
+		lru_gen_mm_accessed(vma->vm_mm, folio_nid(folio));
 
 	/*
 	 * Remove the swap entry and conditionally try to free up the swapcache.
@@ -5516,6 +5522,10 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 		folio_put(folio);
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
+	/* a new page of this mm lands on this node: invalidate any empty skip */
+	if (lru_gen_enabled())
+		lru_gen_mm_accessed(vma->vm_mm, folio_nid(folio));
+
 	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
 			      vmf_orig_pte_uffd_wp(vmf));
 unlock:
@@ -5776,6 +5786,11 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 		page = vmf->page;
 
 	folio = page_folio(page);
+
+	/* mapping a page of this mm on this node: invalidate any empty skip */
+	if (lru_gen_enabled())
+		lru_gen_mm_accessed(vma->vm_mm, folio_nid(folio));
+
 	/*
 	 * check even for read faults because we might have lost our CoWed
 	 * page
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..26b8b34988d2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -354,6 +354,10 @@ static bool remove_migration_pte(struct folio *folio,
 	struct rmap_walk_arg *rmap_walk_arg = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
 
+	/* the folio ends up on folio_nid(): notify MGLRU for this mm */
+	if (lru_gen_enabled())
+		lru_gen_mm_accessed(vma->vm_mm, folio_nid(folio));
+
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
 		unsigned long idx = 0;
-- 
2.54.0


