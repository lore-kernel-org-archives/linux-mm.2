Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7958EF3ED79
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 06:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3213E6B0089; Mon, 13 Apr 2026 02:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B916B0096; Mon, 13 Apr 2026 02:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43466B008A; Mon, 13 Apr 2026 02:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB1D26B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 02:21:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EDD75CBCC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:21:31 +0000 (UTC)
X-FDA: 84652535982.26.1C62351
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf22.hostedemail.com (Postfix) with ESMTP id C4D3CC000C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:21:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776061289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YkfiEaet8zdbCTmvrhuAhNocrBChiw3XTYlqUi2NN5s=;
	b=3+MAfpbnuNY+32ASAVamZ80r94zEDH0GNkCafU0nlsXBnyUpenQP/EUgmeMfMqZEuvLoLo
	Im73FZ2qV3VDaUCKA7xHvQ7pcARyASVoCivj1pwU4EV64xdHotC2w0EtDu+jmcCd761DqC
	ng8h4QYfK5o8YhQq5alXKuJiN2Zwy3E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776061289; a=rsa-sha256;
	cv=none;
	b=aPJRvYghRd1J7DhPDMm6RHhme5IFMt3ExdeF5RmmzUChh/XokLYxBCnVE/l3tvp0CrE/Tg
	NoiHZs3n4nRIpqJl59zgbSi3rkUfJ/byFGmuBtJe65kAV5dga9RuuQlz4WkaYV6PKBP5Bn
	m9KdwTFffmcEJPwNyyJCjMD/G5frbkc=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4fvHNd43CYzg1cT;
	Mon, 13 Apr 2026 14:21:21 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4fvHNb0jGXzg1cT;
	Mon, 13 Apr 2026 14:21:19 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 0CFF730004D3;
	Mon, 13 Apr 2026 14:19:26 +0800 (CST)
Received: from SH-HV00110.Hygon.cn (172.19.26.208) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 13 Apr
 2026 14:21:17 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>,
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH 2/3] mm: use get_i_mmap_root to access the file's i_mmap
Date: Mon, 13 Apr 2026 14:20:41 +0800
Message-ID: <20260413062042.804-3-huangsj@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413062042.804-1-huangsj@hygon.cn>
References: <20260413062042.804-1-huangsj@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.26.208]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Stat-Signature: pz49b7gsi9y5et5sx9akk6r9yqs6nruy
X-Rspamd-Queue-Id: C4D3CC000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1776061286-735140
X-HE-Meta: U2FsdGVkX18J5i7MtfSKqC6YPWy7HME+BLG4BieFVbEZ0fygetEmXPmHDMyrD51SP5PR8QFTVLAiopbto5LFwqm3LYiOY0NdxIJus0NWyDkVFQO4oNXnrbuGGPoQwoBL4Qp7NX5t8iaanX4YAVdILZ4BjCTOVpj8Rb1i7Hbj7pqYyn6iqtskCY9Rke1AKpju2QW+DJjdwrOowOd62ydL+n65CTZYi2i89psJYqwb24nv7lqcGdRa+KLoG8VRqCOSTVWVp0md8kQ5XX9oSLsVoKXu01y/9k02N7t4Srt/GkygEhsxR92ls8lks28BA/+12iMfJvRDH8LC6VIQbgGhsxZHhFq9kLG2ttQBKpPe9S+qSaT4qdP+/VoJwmKuZG54Pnx6PnvHSR+1OD4JZvvoTALAnjQUq0s1uYMiIGY/CgYQIrDpratuF9cmKOPHukrCR4HGRsqb249DfYt8Gi//OxrJhMOJJS6wf/95ODmMw14fX1Bao7Mqiy8UU5eY7JUT5Bxvruzrbd7tg7Racg8Kb95tXuAK3fSplZcpBQwmtRgUeKvSV3j/vO6uSUjfF+Y/f5sND0t2zoR8NSyaUy2IbUIclkl917z8S2wx0kFeVD/bBJd4iQnOgrxBUPkeHanZvUQO7N8+L+0+qBZBk708djLrTR4FrDc1VGF+ZYkKffj1Aiv1l/eQ2v6fIwPQkpmc47scNQyBddjW8drmM5cPtB9MDyTmnFlPCeQ0lRp6/UwFj9WUKnF03o7XJB2pv0GGo3RsMg0AaOuibB3+IMOUJFPxV5S2/VvmoFfjAYdecBSMa9B2H/kzEG9chlrDuM3ar2iy7NG4z8HnWl561M0Ed/BmMJo5Ld9QldZaZ0wJ53Ysaq+e5XNfYp+xn85Xt1hVsDlvW5A9pxguORWp2q4TUD8Ck81KWlArHJYzB5QAuAjxVTI9XsfYFAB1/oC1DXsiUbpYEdPipwyb95dRLW4
 B+BRgUmR
 kEZybWfWyjRatCx1xmPcJpLQWdBZ8fqFlop5i6pcc2CpIKMjhZ4Zpt7Q7AsDi2RP5F34IJ3wHCdjqSeZR238fxlqfMW+YJ8wmtKOsqPBBrZdaT1y/0E1LP4DSsRWCCaT6/O+FE9UVFEnT/0FsqRUcHzWC/mS5Wq570L21WaxE8DbQlcojxEkuMVUZYJu45Tx3PzKafLp9D52b8kJDP6inYi9wIgHBqWinfW3KkTt5wsxn9VM6gqZaqTt7tMM55hA4cTAILIiMgVGfpiSCrRVxTqJnDfSnzB3x6f5o6LC9LJfnDv+6p5qxrnh+691mpJLv6gAIzpSvv6IwlU90Sxtgy8AUzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not access the file's i_mmap directly, use get_i_mmap_root()
to access it. This patch makes preparations for later patches.

Signed-off-by: Huang Shijie <huangsj@hygon.cn>
---
 arch/arm/mm/fault-armv.c   |  3 ++-
 arch/arm/mm/flush.c        |  3 ++-
 arch/nios2/mm/cacheflush.c |  3 ++-
 arch/parisc/kernel/cache.c |  4 +++-
 fs/dax.c                   |  3 ++-
 fs/hugetlbfs/inode.c       |  6 +++---
 include/linux/fs.h         |  5 +++++
 include/linux/mm.h         |  1 +
 kernel/events/uprobes.c    |  3 ++-
 mm/hugetlb.c               |  7 +++++--
 mm/khugepaged.c            |  6 ++++--
 mm/memory-failure.c        |  8 +++++---
 mm/memory.c                |  4 ++--
 mm/mmap.c                  |  2 +-
 mm/nommu.c                 |  9 +++++----
 mm/pagewalk.c              |  2 +-
 mm/rmap.c                  |  2 +-
 mm/vma.c                   | 14 ++++++++------
 18 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mm/fault-armv.c b/arch/arm/mm/fault-armv.c
index 91e488767783..1b5fe151e805 100644
--- a/arch/arm/mm/fault-armv.c
+++ b/arch/arm/mm/fault-armv.c
@@ -126,6 +126,7 @@ make_coherent(struct address_space *mapping, struct vm_area_struct *vma,
 {
 	const unsigned long pmd_start_addr = ALIGN_DOWN(addr, PMD_SIZE);
 	const unsigned long pmd_end_addr = pmd_start_addr + PMD_SIZE;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *mpnt;
 	unsigned long offset;
@@ -140,7 +141,7 @@ make_coherent(struct address_space *mapping, struct vm_area_struct *vma,
 	 * cache coherency.
 	 */
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(mpnt, root, pgoff, pgoff) {
 		/*
 		 * If we are using split PTE locks, then we need to take the pte
 		 * lock. Otherwise we are using shared mm->page_table_lock which
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 19470d938b23..b9641901f206 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -238,6 +238,7 @@ void __flush_dcache_folio(struct address_space *mapping, struct folio *folio)
 static void __flush_dcache_aliases(struct address_space *mapping, struct folio *folio)
 {
 	struct mm_struct *mm = current->active_mm;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	struct vm_area_struct *vma;
 	pgoff_t pgoff, pgoff_end;
 
@@ -251,7 +252,7 @@ static void __flush_dcache_aliases(struct address_space *mapping, struct folio *
 	pgoff_end = pgoff + folio_nr_pages(folio) - 1;
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff_end) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff_end) {
 		unsigned long start, offset, pfn;
 		unsigned int nr;
 
diff --git a/arch/nios2/mm/cacheflush.c b/arch/nios2/mm/cacheflush.c
index 8321182eb927..ab6e064fabe2 100644
--- a/arch/nios2/mm/cacheflush.c
+++ b/arch/nios2/mm/cacheflush.c
@@ -78,11 +78,12 @@ static void flush_aliases(struct address_space *mapping, struct folio *folio)
 	unsigned long flags;
 	pgoff_t pgoff;
 	unsigned long nr = folio_nr_pages(folio);
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 
 	pgoff = folio->index;
 
 	flush_dcache_mmap_lock_irqsave(mapping, flags);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff + nr - 1) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff + nr - 1) {
 		unsigned long start;
 
 		if (vma->vm_mm != mm)
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 4c5240d3a3c7..920adacaaac2 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -473,6 +473,7 @@ static inline unsigned long get_upa(struct mm_struct *mm, unsigned long addr)
 void flush_dcache_folio(struct folio *folio)
 {
 	struct address_space *mapping = folio_flush_mapping(folio);
+	struct rb_root_cached *root;
 	struct vm_area_struct *vma;
 	unsigned long addr, old_addr = 0;
 	void *kaddr;
@@ -494,6 +495,7 @@ void flush_dcache_folio(struct folio *folio)
 		return;
 
 	pgoff = folio->index;
+	root = get_i_mmap_root(mapping);
 
 	/*
 	 * We have carefully arranged in arch_get_unmapped_area() that
@@ -503,7 +505,7 @@ void flush_dcache_folio(struct folio *folio)
 	 * on machines that support equivalent aliasing
 	 */
 	flush_dcache_mmap_lock_irqsave(mapping, flags);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff + nr - 1) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff + nr - 1) {
 		unsigned long offset = pgoff - vma->vm_pgoff;
 		unsigned long pfn = folio_pfn(folio);
 
diff --git a/fs/dax.c b/fs/dax.c
index 289e6254aa30..00fe5481accc 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1101,6 +1101,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		struct address_space *mapping, void *entry)
 {
 	unsigned long pfn, index, count, end;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	long ret = 0;
 	struct vm_area_struct *vma;
 
@@ -1164,7 +1165,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 
 	/* Walk all mappings of a given index of a file and writeprotect them */
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, end) {
+	vma_interval_tree_foreach(vma, root, index, end) {
 		pfn_mkclean_range(pfn, count, index, vma);
 		cond_resched();
 	}
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index ab5ac092d8a6..9cf82fba6eb6 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -400,7 +400,7 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 					struct address_space *mapping,
 					struct folio *folio, pgoff_t index)
 {
-	struct rb_root_cached *root = &mapping->i_mmap;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	struct hugetlb_vma_lock *vma_lock;
 	unsigned long pfn = folio_pfn(folio);
 	struct vm_area_struct *vma;
@@ -647,7 +647,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
 	if (mapping_mapped(mapping))
-		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
+		hugetlb_vmdelete_list(get_i_mmap_root(mapping), pgoff, 0,
 				      ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
@@ -708,7 +708,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
 		if (mapping_mapped(mapping))
-			hugetlb_vmdelete_list(&mapping->i_mmap,
+			hugetlb_vmdelete_list(get_i_mmap_root(mapping),
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25e..a6a99e044265 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -555,6 +555,11 @@ static inline int mapping_mapped(const struct address_space *mapping)
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
 
+static inline struct rb_root_cached *get_i_mmap_root(struct address_space *mapping)
+{
+	return &mapping->i_mmap;
+}
+
 /*
  * Might pages of this file have been modified in userspace?
  * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
diff --git a/include/linux/mm.h b/include/linux/mm.h
index abb4963c1f06..15cb1da43eb2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3797,6 +3797,7 @@ struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root_cached *root,
 struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
 				unsigned long start, unsigned long last);
 
+/* Please use get_i_mmap_root() to get the @root */
 #define vma_interval_tree_foreach(vma, root, start, last)		\
 	for (vma = vma_interval_tree_iter_first(root, start, last);	\
 	     vma; vma = vma_interval_tree_iter_next(vma, start, last))
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 923b24b321cc..420035b0cc7b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1201,6 +1201,7 @@ static inline struct map_info *free_map_info(struct map_info *info)
 static struct map_info *
 build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 {
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	unsigned long pgoff = offset >> PAGE_SHIFT;
 	struct vm_area_struct *vma;
 	struct map_info *curr = NULL;
@@ -1210,7 +1211,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 
  again:
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff) {
 		if (!valid_vma(vma, is_register))
 			continue;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..8d27f1b8abb5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5396,6 +5396,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
 	struct address_space *mapping;
+	struct rb_root_cached *root;
 	pgoff_t pgoff;
 
 	/*
@@ -5406,6 +5407,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) +
 			vma->vm_pgoff;
 	mapping = vma->vm_file->f_mapping;
+	root = get_i_mmap_root(mapping);
 
 	/*
 	 * Take the mapping lock for the duration of the table walk. As
@@ -5413,7 +5415,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
 	i_mmap_lock_write(mapping);
-	vma_interval_tree_foreach(iter_vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(iter_vma, root, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
 			continue;
@@ -6879,6 +6881,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	pgoff_t idx = ((addr - vma->vm_start) >> PAGE_SHIFT) +
 			vma->vm_pgoff;
 	struct vm_area_struct *svma;
@@ -6887,7 +6890,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	pte_t *pte;
 
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
+	vma_interval_tree_foreach(svma, root, idx, idx) {
 		if (svma == vma)
 			continue;
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1dd3cfca610d..3a4e81474fe3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1740,10 +1740,11 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
+	struct rb_root_cached *root = get_i_mmap_root(mapping);
 	struct vm_area_struct *vma;
 
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, root, pgoff, pgoff) {
 		struct mmu_notifier_range range;
 		struct mm_struct *mm;
 		unsigned long addr;
@@ -2163,7 +2164,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * not be able to observe any missing pages due to the
 		 * previously inserted retry entries.
 		 */
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, start, end) {
+		vma_interval_tree_foreach(vma, get_i_mmap_root(mapping),
+					start, end) {
 			if (userfaultfd_missing(vma)) {
 				result = SCAN_EXCEED_NONE_PTE;
 				goto immap_locked;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..85196d9bb26c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -598,7 +598,7 @@ static void collect_procs_file(const struct folio *folio,
 
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
+		vma_interval_tree_foreach(vma, get_i_mmap_root(mapping), pgoff,
 				      pgoff) {
 			/*
 			 * Send early kill signal to tasks where a vma covers
@@ -650,7 +650,8 @@ static void collect_procs_fsdax(const struct page *page,
 			t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+		vma_interval_tree_foreach(vma, get_i_mmap_root(mapping), pgoff,
+					pgoff) {
 			if (vma->vm_mm == t->mm)
 				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
 		}
@@ -2251,7 +2252,8 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 		t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
+		vma_interval_tree_foreach(vma, get_i_mmap_root(mapping),
+					0, ULONG_MAX) {
 			pgoff_t pgoff;
 
 			if (vma->vm_mm == t->mm &&
diff --git a/mm/memory.c b/mm/memory.c
index 366054435773..1ddd6b55fe7e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4298,7 +4298,7 @@ void unmap_mapping_folio(struct folio *folio)
 
 	i_mmap_lock_read(mapping);
 	if (unlikely(mapping_mapped(mapping)))
-		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
+		unmap_mapping_range_tree(get_i_mmap_root(mapping), first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
 }
@@ -4328,7 +4328,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 
 	i_mmap_lock_read(mapping);
 	if (unlikely(mapping_mapped(mapping)))
-		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
+		unmap_mapping_range_tree(get_i_mmap_root(mapping), first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 843160946aa5..5b0671dff019 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1832,7 +1832,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
 			vma_interval_tree_insert_after(tmp, mpnt,
-					&mapping->i_mmap);
+					get_i_mmap_root(mapping));
 			flush_dcache_mmap_unlock(mapping);
 			i_mmap_unlock_write(mapping);
 		}
diff --git a/mm/nommu.c b/mm/nommu.c
index c3a23b082adb..2e64b6c4c539 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -569,7 +569,7 @@ static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_insert(vma, &mapping->i_mmap);
+		vma_interval_tree_insert(vma, get_i_mmap_root(mapping));
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
@@ -585,7 +585,7 @@ static void cleanup_vma_from_mm(struct vm_area_struct *vma)
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_remove(vma, &mapping->i_mmap);
+		vma_interval_tree_remove(vma, get_i_mmap_root(mapping));
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
@@ -1804,6 +1804,7 @@ EXPORT_SYMBOL_GPL(copy_remote_vm_str);
 int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 				size_t newsize)
 {
+	struct rb_root_cached *root = get_i_mmap_root(&inode->mapping);
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	pgoff_t low, high;
@@ -1816,7 +1817,7 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	i_mmap_lock_read(inode->i_mapping);
 
 	/* search for VMAs that fall within the dead zone */
-	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, low, high) {
+	vma_interval_tree_foreach(vma, root, low, high) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
@@ -1832,7 +1833,7 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	 * we don't check for any regions that start beyond the EOF as there
 	 * shouldn't be any
 	 */
-	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, 0, ULONG_MAX) {
+	vma_interval_tree_foreach(vma, root, 0, ULONG_MAX) {
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab2cf..c6c1c45df575 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -792,7 +792,7 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
 		return -EINVAL;
 
 	lockdep_assert_held(&mapping->i_mmap_rwsem);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, first_index,
+	vma_interval_tree_foreach(vma, get_i_mmap_root(mapping), first_index,
 				  first_index + nr - 1) {
 		/* Clip to the vma */
 		vba = vma->vm_pgoff;
diff --git a/mm/rmap.c b/mm/rmap.c
index 391337282e3f..52288d39d8a2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -3036,7 +3036,7 @@ static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
 		i_mmap_lock_read(mapping);
 	}
 lookup:
-	vma_interval_tree_foreach(vma, &mapping->i_mmap,
+	vma_interval_tree_foreach(vma, get_i_mmap_root(mapping),
 			pgoff_start, pgoff_end) {
 		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
 
diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..1768e4355a13 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -231,7 +231,7 @@ static void __vma_link_file(struct vm_area_struct *vma,
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_insert(vma, &mapping->i_mmap);
+	vma_interval_tree_insert(vma, get_i_mmap_root(mapping));
 	flush_dcache_mmap_unlock(mapping);
 }
 
@@ -245,7 +245,7 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_remove(vma, &mapping->i_mmap);
+	vma_interval_tree_remove(vma, get_i_mmap_root(mapping));
 	flush_dcache_mmap_unlock(mapping);
 }
 
@@ -316,10 +316,11 @@ static void vma_prepare(struct vma_prepare *vp)
 
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
-		vma_interval_tree_remove(vp->vma, &vp->mapping->i_mmap);
+		vma_interval_tree_remove(vp->vma,
+					get_i_mmap_root(vp->mapping));
 		if (vp->adj_next)
 			vma_interval_tree_remove(vp->adj_next,
-						 &vp->mapping->i_mmap);
+					get_i_mmap_root(vp->mapping));
 	}
 
 }
@@ -338,8 +339,9 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 	if (vp->file) {
 		if (vp->adj_next)
 			vma_interval_tree_insert(vp->adj_next,
-						 &vp->mapping->i_mmap);
-		vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);
+					get_i_mmap_root(vp->mapping));
+		vma_interval_tree_insert(vp->vma,
+					get_i_mmap_root(vp->mapping));
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
-- 
2.43.0



