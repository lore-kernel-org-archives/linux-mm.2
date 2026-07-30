Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F37C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89AF6B009D; Thu, 30 Jul 2026 09:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3AD16B009E; Thu, 30 Jul 2026 09:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50EC6B009F; Thu, 30 Jul 2026 09:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3E36B009D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:14:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03C3316013F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:14:41 +0000 (UTC)
X-FDA: 85045487604.15.5A67A05
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7577818000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:14:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VxdpRI4E;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785417280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CsmgVl9DxU9xLZ0DpO6hQSdRrbiTeSiiU7I5XzEhKCs=;
	b=hzs6Ykq6pBj+xhqrT+uREDFGLAafFsuO4aaVrx/ij53PImqd7SbK8NavZSPCg++ej5ahmk
	MkuVOTXxkcH1Tp8ugGbScv7R6tVhJltfuI9YTo9Y90JB+zVJoYkgu9w45yAi94igv5e3oI
	p59IOu5RRL4+Lm8IKIoVp065cTo9WI0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VxdpRI4E;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785417280;
	b=2KnSoQ/2NMUJgW2cNz+S8E2tRTMHCzhTkaZW/145MzpcY1KZYXTDM69pK6uUMLM1GCdw3r
	vgglj5faGNozzMuGnXPO0ezm8UuGLIsMGzNXQFgGeHxUjMsz7l7mPvBXOSAFmgDn6IZHea
	tRWfPslBN5Bb3d1tOkvu54HfURBTaak=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CsmgVl9DxU9xLZ0DpO6hQSdRrbiTeSiiU7I5XzEhKCs=; b=VxdpRI4En3pj1IsFpUPTiDGG7a
	6HljXzmZ1NE58QIFAuR+6XRAHR0ZNLrvHKJaH+V/UByJSrUPGEg2DjEJaAUOP9g80OuRC2nIWKQ+8
	izb+T9muo17o+VnvDxhAkfxt+hPGzxKdnFlJ6HJ5jCPljGijvwV6q+Q0VRtgzww3KK8Kp7ym6uE5p
	vcXLTnmuS/v2L8Jpze6N584olbLyqah0q9cY8MOEUT/d/rlI2P9ss9gGh5ubPnHPX/v4KpJRakJs/
	gapf2E68nXM5K8OaJg9y5gtskqysr9IQhB0CSGr8FVrVFhj8bqLajz2i8Rk35UPE07hoki2Eb9DKD
	YbfOcuOg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpQam-0000000FA3H-28qw;
	Thu, 30 Jul 2026 13:14:32 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH] hugetlb: Use invalidate_lock instead of fault_mutex
Date: Thu, 30 Jul 2026 14:14:27 +0100
Message-ID: <20260730131431.3613545-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7577818000D
X-Stat-Signature: 5tuww73eqbj99gpz5bepmofpeqjutnf1
X-HE-Tag: 1785417279-412464
X-HE-Meta: U2FsdGVkX1+WqGRcRGVydPwoIWduCX3x0ehN9n0iGOCGzmM8XGA8D/NvIg0TSyUFvWQOMLd7NAEKpi5XP1KsaFGPg2RYL56OgWSz4nPuzetGQQeUTj554fejrWImA9lnbgw8ejt9TptOGAfGvJ+W3CcLyiWZ8cyzuRknTVwzXSwOuF2YGozDDSZxUtBQ4Ou5PDV36PiQi+qixpUJ37/pFU3tj4F1pnz8Zw14IZU1F0jZGKRUJBItV1Q5UQF0CkRatzk+mJ3uiQuWXd5unPqZF0WTAvN6wUPE6Px9nQoGmrKK/PMc1yb0E3EQhKgsq27CHyaSob5SI7v4Qgi9t0X3b3EFV/rVodiyUjDtAfqx3B98Dzl4wevtG3XF/MPO6fxmEw1tIiuLAbQtz+/Crq5h1c/bAAsgPlPd0ENFGDRDKuka3cLyf8TnU4VYNTeUC1tkVLTEJ8SKPks9pVBB0I9PaZpE7uVS00+9n3fTQyBnOv7DP1fqf09nyfYoPCFn3hRPPc4XrVwG4Zu+YDdS3oDV2pBrJfZzh2V6/KPJ1YZfBfsLko+gVJwAEfSkETrNmo66A+Tp/9648eY3aWar9sewjPsnCQVZosCPv5iBovz0T+9+J3nDSWdci7bXeSeqhRlPbDHInzrJV8qZ3dhvlTf/w0+s/1ia3zWZO5acQCLnyvktfcA/vsrxjFsfDI3RqBLgM7PgasYGPqu6IrvDDH5XyW+J5q3WN1mVx8CPkdBI0PzGpPhVi23MXGew6vNunMUG+Y0TDbd8oR+npxLIbOPHUpp8IiPviSIC1qhvQ/VT0F5enjkFxAd1ydwNNGAjlWjU1swVS0W5wykwbg2SH1JbIArUT3UXdLbH8kiKgPOnUNLyV/WzEH7gn7oEX1Q0Kp7xNzHCAybiIq7z1MVeyvERoBFlezyDNU6W7xVXFNAKTpbg9SvbmGKSmvzD6ArcrLjZvPbvLOYcn0txht1j2GW
 etOLKTTb
 lVxEptWOUXjh23k05BVWTp7fGbq76ntVO7TZA3WASldOmQKJzXCQb18BFFVFQJV/z3lZ6kn7ZzwTlxYZ7VYhcaG5ixDJUSb9fgrftrx1NnyOa+2Xw/MgjSzHqTTi02IrsV6I/2XDBNi+8XV7JcUV4gXrVBeI6nLh59aRHw1No9zouMc6CvLfe8jBuB2tHfuUHybsoOUDvFkMhF6k3ZU7XHMH6zj7aN8zy9WHlABhP4WklKTtIjy7maeDQ9YgpnVR2tXEgqdfp2A1IEEs2urG6WtXDXJkgZHE0HuvuqqWOiqBQILg8a97TEwROgxUSGaGECXr7/A/NELZxfWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 730633f0b7f9 in 2021, we've had a per-mapping
invalidate_lock which is used in much the same way as the hugetlb
fault_mutex.  This is a fairly naive conversion; all acquisitions
are in exclusive mode.  It may be possible to relax some of these
uses to shared mode, but I shall leave that for a future patch.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
I've run the libhugetlb test suite against this, and it includes
a test called fallocate_stress.sh, so I hope this works correctly.

 fs/hugetlbfs/inode.c    | 27 ++++++-------------
 include/linux/hugetlb.h |  2 --
 mm/hugetlb.c            | 57 ++++++++---------------------------------
 mm/memfd.c              |  9 ++-----
 mm/userfaultfd.c        | 10 +++-----
 5 files changed, 25 insertions(+), 80 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cef7e61b827d..991142eb034c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -454,27 +454,22 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 
 	folio_batch_init(&fbatch);
 	next = lstart >> PAGE_SHIFT;
+	filemap_invalidate_lock(mapping);
 	while (filemap_get_folios(mapping, &next, end - 1, &fbatch)) {
 		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
 			struct folio *folio = fbatch.folios[i];
-			u32 hash = 0;
 
 			index = folio->index >> huge_page_order(h);
-			hash = hugetlb_fault_mutex_hash(mapping, index);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
-			/*
-			 * Remove folio that was part of folio_batch.
-			 */
 			remove_inode_single_folio(h, inode, mapping, folio,
 						  index, truncate_op);
 			freed++;
-
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
+		filemap_invalidate_unlock(mapping);
 		folio_batch_release(&fbatch);
 		cond_resched();
+		filemap_invalidate_lock(mapping);
 	}
+	filemap_invalidate_unlock(mapping);
 
 	if (truncate_op)
 		(void)hugetlb_unreserve_pages(inode,
@@ -603,7 +598,6 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 	unsigned long hpage_shift = huge_page_shift(h);
 	pgoff_t start, index, end;
 	int error;
-	u32 hash;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
@@ -641,6 +635,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 	vm_flags_init(&pseudo_vma, VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
 	pseudo_vma.vm_file = file;
 
+	filemap_invalidate_lock(mapping);
 	for (index = start; index < end; index++) {
 		/*
 		 * This is supposed to be the vaddr where the page is being
@@ -663,15 +658,10 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		/* addr is the offset within the file (zero based) */
 		addr = index * hpage_size;
 
-		/* mutex taken here, fault path and hole punch */
-		hash = hugetlb_fault_mutex_hash(mapping, index);
-		mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
 		/* See if already present in mapping to avoid alloc/free */
 		folio = filemap_get_folio(mapping, index << huge_page_order(h));
 		if (!IS_ERR(folio)) {
 			folio_put(folio);
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			continue;
 		}
 
@@ -685,8 +675,8 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		 */
 		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false);
 		if (IS_ERR(folio)) {
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			error = PTR_ERR(folio);
+			filemap_invalidate_unlock(mapping);
 			goto out;
 		}
 		folio_zero_user(folio, addr);
@@ -695,12 +685,10 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
 			folio_put(folio);
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			filemap_invalidate_unlock(mapping);
 			goto out;
 		}
 
-		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-
 		folio_set_hugetlb_migratable(folio);
 		/*
 		 * folio_unlock because locked by hugetlb_add_to_page_cache()
@@ -709,6 +697,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		folio_unlock(folio);
 		folio_put(folio);
 	}
+	filemap_invalidate_unlock(mapping);
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
 		i_size_write(inode, offset + len);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 639c0a772856..95b0d5ebe18f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -167,8 +167,6 @@ int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison
 void folio_putback_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
-extern struct mutex *hugetlb_fault_mutex_table;
-u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
 
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 40ae967b9ecc..37a574bc7807 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -27,7 +27,6 @@
 #include <linux/string_helpers.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
-#include <linux/jhash.h>
 #include <linux/numa.h>
 #include <linux/llist.h>
 #include <linux/cma.h>
@@ -5515,12 +5514,10 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 		 */
 		if (cow_from_owner) {
 			struct address_space *mapping = vma->vm_file->f_mapping;
-			pgoff_t idx;
-			u32 hash;
 
 			folio_put(old_folio);
 			/*
-			 * Drop hugetlb_fault_mutex and vma_lock before
+			 * Release invalidate lock and vma_lock before
 			 * unmapping.  unmapping needs to hold vma_lock
 			 * in write mode.  Dropping vma_lock in read mode
 			 * here is OK as COW mappings do not interact with
@@ -5528,14 +5525,12 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 			 *
 			 * Reacquire both after unmap operation.
 			 */
-			idx = vma_hugecache_offset(h, vma, vmf->address);
-			hash = hugetlb_fault_mutex_hash(mapping, idx);
 			hugetlb_vma_unlock_read(vma);
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			filemap_invalidate_unlock(mapping);
 
 			unmap_ref_private(mm, vma, old_folio, vmf->address);
 
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+			filemap_invalidate_lock(mapping);
 			hugetlb_vma_lock_read(vma);
 			spin_lock(vmf->ptl);
 			vmf->pte = hugetlb_walk(vma, vmf->address,
@@ -5663,16 +5658,13 @@ static inline vm_fault_t hugetlb_handle_userfault(struct vm_fault *vmf,
 						  struct address_space *mapping,
 						  unsigned long reason)
 {
-	u32 hash;
-
 	/*
-	 * vma_lock and hugetlb_fault_mutex must be dropped before handling
+	 * vma_lock and invalidate lock must be dropped before handling
 	 * userfault. Also mmap_lock could be dropped due to handling
 	 * userfault, any vma operation should be careful from here.
 	 */
 	hugetlb_vma_unlock_read(vmf->vma);
-	hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
-	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	filemap_invalidate_unlock(mapping);
 	return handle_userfault(vmf, reason);
 }
 
@@ -5696,7 +5688,6 @@ static bool hugetlb_pte_stable(struct hstate *h, struct mm_struct *mm, unsigned
 static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
-	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
 	bool new_folio, new_anon_folio = false;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
@@ -5904,7 +5895,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	if (unlikely(ret & VM_FAULT_RETRY))
 		vma_end_read(vma);
 
-	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	filemap_invalidate_unlock(mapping);
 	return ret;
 
 backout:
@@ -5919,35 +5910,10 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	goto out;
 }
 
-#ifdef CONFIG_SMP
-u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
-{
-	unsigned long key[2];
-	u32 hash;
-
-	key[0] = (unsigned long) mapping;
-	key[1] = idx;
-
-	hash = jhash2((u32 *)&key, sizeof(key)/(sizeof(u32)), 0);
-
-	return hash & (num_fault_mutexes - 1);
-}
-#else
-/*
- * For uniprocessor systems we always use a single mutex, so just
- * return 0 and avoid the hashing overhead.
- */
-u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
-{
-	return 0;
-}
-#endif
-
 vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags)
 {
 	vm_fault_t ret;
-	u32 hash;
 	struct folio *folio = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
@@ -5973,8 +5939,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * the same page in the page cache.
 	 */
 	mapping = vma->vm_file->f_mapping;
-	hash = hugetlb_fault_mutex_hash(mapping, vmf.pgoff);
-	mutex_lock(&hugetlb_fault_mutex_table[hash]);
+	filemap_invalidate_lock(mapping);
 
 	/*
 	 * Acquire vma lock before calling huge_pte_alloc and hold
@@ -5985,7 +5950,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	vmf.pte = huge_pte_alloc(mm, vma, vmf.address, huge_page_size(h));
 	if (!vmf.pte) {
 		hugetlb_vma_unlock_read(vma);
-		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+		filemap_invalidate_unlock(mapping);
 		return VM_FAULT_OOM;
 	}
 
@@ -6028,7 +5993,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			 * migration_entry_wait_huge(). The vma lock will
 			 * be released there.
 			 */
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			filemap_invalidate_unlock(mapping);
 			migration_entry_wait_huge(vma, vmf.address, vmf.pte);
 			return 0;
 		}
@@ -6068,7 +6033,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (!userfaultfd_wp_async(vma)) {
 			spin_unlock(vmf.ptl);
 			hugetlb_vma_unlock_read(vma);
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			filemap_invalidate_unlock(mapping);
 			return handle_userfault(&vmf, VM_UFFD_WP);
 		}
 
@@ -6116,7 +6081,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (unlikely(ret & VM_FAULT_RETRY))
 		vma_end_read(vma);
 
-	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	filemap_invalidate_unlock(mapping);
 	/*
 	 * hugetlb_wp drops all the locks, but the folio lock, before trying to
 	 * unmap the folio from other processes. During that window, if another
diff --git a/mm/memfd.c b/mm/memfd.c
index abe13b291ddc..0fe6f3b545c1 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -95,8 +95,6 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 						    NULL,
 						    gfp_mask);
 		if (folio) {
-			u32 hash;
-
 			/*
 			 * Zero the folio to prevent information leaks to userspace.
 			 * Use folio_zero_user() which is optimized for huge/gigantic
@@ -116,14 +114,11 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 			 * races with concurrent allocations, as required by all other
 			 * callers of hugetlb_add_to_page_cache().
 			 */
-			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
+			filemap_invalidate_lock(memfd->f_mapping);
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
-
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			filemap_invalidate_unlock(memfd->f_mapping);
 
 			if (err) {
 				folio_put(folio);
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 246af12bf801..be9f83dfa838 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -790,7 +790,6 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 	struct folio *folio;
 	unsigned long vma_hpagesize;
 	pgoff_t idx;
-	u32 hash;
 	struct address_space *mapping;
 
 	/*
@@ -860,15 +859,14 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 		 */
 		idx = hugetlb_linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
-		hash = hugetlb_fault_mutex_hash(mapping, idx);
-		mutex_lock(&hugetlb_fault_mutex_table[hash]);
+		filemap_invalidate_lock(mapping);
 		hugetlb_vma_lock_read(dst_vma);
 
 		err = -ENOMEM;
 		dst_pte = huge_pte_alloc(dst_mm, dst_vma, dst_addr, vma_hpagesize);
 		if (!dst_pte) {
 			hugetlb_vma_unlock_read(dst_vma);
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			filemap_invalidate_unlock(mapping);
 			goto out_unlock;
 		}
 
@@ -878,7 +876,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 			if (!huge_pte_none(ptep) && !pte_is_uffd_marker(ptep)) {
 				err = -EEXIST;
 				hugetlb_vma_unlock_read(dst_vma);
-				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+				filemap_invalidate_unlock(mapping);
 				goto out_unlock;
 			}
 		}
@@ -887,7 +885,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 					       src_addr, flags, &folio);
 
 		hugetlb_vma_unlock_read(dst_vma);
-		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+		filemap_invalidate_unlock(mapping);
 
 		cond_resched();
 
-- 
2.47.3


