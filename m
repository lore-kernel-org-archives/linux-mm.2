Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 613B5FB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8C4E6B00A8; Mon, 30 Mar 2026 06:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C1F6B00AA; Mon, 30 Mar 2026 06:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2AD66B00AB; Mon, 30 Mar 2026 06:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4486B00A8
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:12:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CDF0BB529
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:36 +0000 (UTC)
X-FDA: 84602315112.08.8FD5065
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 100BE40011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:12:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ThkjaJTu;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6CKQ6MXeDzF+v50qAZK8cx6Dqqtai/nIXvn7ojsrLw=;
	b=dr2DHVShCUFWzpbwfEWoY9YJwE/uyrEZ9e3qmfdwMZcK7smQ9Xq58Ug1/gOrkBrXQz9bw+
	Aty79OBSMEsGbjEMHTmFWqlqkkn6jgNWi3T+aJyYi5saViQXy0/YP9dsK0NrprPxwzMJEk
	enjaA3H6M/nCtE2nbDVG8BLT9g8C9OY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ThkjaJTu;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865555; a=rsa-sha256;
	cv=none;
	b=W61uGZSFXO3QAugaS9PaLNuAU4vnvrNdZ23osa9OoMW+hbTyU2HTPUb7zpEF8fqgd/o1DS
	3PgMguI4Iw/FChDhaYDgzN9EPPvowh/+ncfdrFG+rlEIW8+zRzF0p2DTmImStztvl5Gu9U
	Y/s+KyJIzq1IJ5N8Ggl61ysATN6jVVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F3596011F;
	Mon, 30 Mar 2026 10:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCEAC4CEF7;
	Mon, 30 Mar 2026 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865554;
	bh=nhN0tYK94rMrBIfGb6UL4j3n8or99nhslnrvimSOhI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThkjaJTuFem6TuFExjQ/bRSrQvEN2ShwvsnLDFnskpwC+As2zc2+W1xCpBk8pUpHe
	 PSkZEKwVL9BRSLtckD5qwYsPGCTJz3rruSCPddPvkhFEzHVhyUSQerdp2uF9Pc8Rgh
	 jaSk7yG5dGkbhHsyrIUTP7GPncYPmYq73Z06Sms87TQu58qBdeUdK4xYDO0/TYCzD8
	 YZ8SwkXd8vBH247GXfmvhdGVROZruLkmWL9q8LYhlWlHf3jNvrlwU0nWLVFgbj/Nii
	 sh3TsYg7Qg/vKYuCmYez5HrlFwI3Zr2FYTAbuDjfgO6pu3ivJsi9kzYyCAeDeg5u8Z
	 vHXdduKanK9lQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 10/15] shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
Date: Mon, 30 Mar 2026 13:11:11 +0300
Message-ID: <20260330101116.1117699-11-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bb6pyyb8j43thh5kyrhcx6m7f6h8ex5e
X-Rspamd-Queue-Id: 100BE40011
X-Rspamd-Server: rspam09
X-HE-Tag: 1774865554-94704
X-HE-Meta: U2FsdGVkX19QTh4Hxpub7V6Id6Fi6Pwc+7bNSXdvZH3kR1nF16qkOfCkZX0837Sm9hl998hgySCuyzBcTxw3Rm+Lz+xg3LKmepdLgRr8TpNLnnxF4GbmMpI6caQmED6da+3SURqtX4PmO472Rcw0JvTCEvWsVQJa1g92TDrJJUnmw5mOz3cNlSj3lRaAGFeeah2E51A9AmdnZjSF8FxXyDGDkHsGllWIMtOamkDHGcnxRLhAjd42CPYdGQWfAbKdv7cvt0uRPTwnqs/P4BKmCPCS8fyO90PU7cFl56D5N+csZ14GzQt0S2LBLp1uNPQONOUIsq5Lu874BphXsSlLNRnhZM7qdjQo++sVruGUhplTtHITmBryltP5uAA6VnSTnPmjzUkzne3U12+CqP2NVhVbBTwfzf+3jU+e3MWpC+ueatMwapolsZbyQNp0o8SpPSHBiNvyzKFqZLosr3Yk9brL5SBqO+p+QKOaN+uKlAgwGL1dkRceK57B7vFCpHMxwtuPLTW+Llg1iBBgvF/Ooxrdjox3SY/VjWqPVZy6Se1YZVokwdlf5/tmjnrlK8aKBwyt383dshI8EAWn/UfaI3a/W4ExQE7ZI5LrtqPVJvnNZbwWA+f1Xp4X1mXBLZjj8j7GBfM9X89hcmlMzuKhO1SOELS+q3HmgnyByfduENpDalB5BLaRg5mGOFZW7H/BDNyiRQsZXSoizB5nsgHs/g16RKm2wsAwoMcZav7wYtfuHVrSPB6eLvJjm8mv9uFxABhsfint7e995iu63R1UbDUaT3k3p6coJc46fOAHuH/LgLrHjHfFHzf1UoDHRMLlCpChkAtwUlxe0GoI9DH7kypXliAuFPnk/kKqUi70afAG0bOj4F/z29QOTeGI5I5N+dt8X9CWyhsAEYGtl4FPT2Og298jbcFfGeU7mZVsuLln44n+9GObr2IZ1NNS7UGqllhVjkQCL6jgWHtHGxf
 TWMpl9Vs
 2htGM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Add filemap_add() and filemap_remove() methods to vm_uffd_ops and use them
in __mfill_atomic_pte() to add shmem folios to page cache and remove them
in case of error.

Implement these methods in shmem along with vm_uffd_ops->alloc_folio() and
drop shmem_mfill_atomic_pte().

Since userfaultfd now does not reference any functions from shmem, drop
include if linux/shmem_fs.h from mm/userfaultfd.c

mfill_atomic_install_pte() is not used anywhere outside of mm/userfaultfd,
make it static.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: James Houghton <jthoughton@google.com>
---
 include/linux/shmem_fs.h      |  14 ----
 include/linux/userfaultfd_k.h |  19 +++--
 mm/shmem.c                    | 148 ++++++++++++----------------------
 mm/userfaultfd.c              |  80 +++++++++---------
 4 files changed, 106 insertions(+), 155 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index a8273b32e041..1a345142af7d 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -221,20 +221,6 @@ static inline pgoff_t shmem_fallocend(struct inode *inode, pgoff_t eof)
 
 extern bool shmem_charge(struct inode *inode, long pages);
 
-#ifdef CONFIG_USERFAULTFD
-#ifdef CONFIG_SHMEM
-extern int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
-				  struct vm_area_struct *dst_vma,
-				  unsigned long dst_addr,
-				  unsigned long src_addr,
-				  uffd_flags_t flags,
-				  struct folio **foliop);
-#else /* !CONFIG_SHMEM */
-#define shmem_mfill_atomic_pte(dst_pmd, dst_vma, dst_addr, \
-			       src_addr, flags, foliop) ({ BUG(); 0; })
-#endif /* CONFIG_SHMEM */
-#endif /* CONFIG_USERFAULTFD */
-
 /*
  * Used space is stored as unsigned 64-bit value in bytes but
  * quota core supports only signed 64-bit values so use that
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 55a67421de0a..6f33307c2780 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -97,6 +97,20 @@ struct vm_uffd_ops {
 	 */
 	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
 				     unsigned long addr);
+	/*
+	 * Called during resolution of UFFDIO_COPY request.
+	 * Should only be called with a folio returned by alloc_folio() above.
+	 * The folio will be set to locked.
+	 * Returns 0 on success, error code on failure.
+	 */
+	int (*filemap_add)(struct folio *folio, struct vm_area_struct *vma,
+			 unsigned long addr);
+	/*
+	 * Called during resolution of UFFDIO_COPY request on the error
+	 * handling path.
+	 * Should revert the operation of ->filemap_add().
+	 */
+	void (*filemap_remove)(struct folio *folio, struct vm_area_struct *vma);
 };
 
 /* A combined operation mode + behavior flags. */
@@ -130,11 +144,6 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
 /* Flags controlling behavior. These behavior changes are mode-independent. */
 #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
 
-extern int mfill_atomic_install_pte(pmd_t *dst_pmd,
-				    struct vm_area_struct *dst_vma,
-				    unsigned long dst_addr, struct page *page,
-				    bool newly_allocated, uffd_flags_t flags);
-
 extern ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 				 unsigned long src_start, unsigned long len,
 				 uffd_flags_t flags);
diff --git a/mm/shmem.c b/mm/shmem.c
index 7bd887b64f62..68620caaf75f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3181,118 +3181,73 @@ static struct inode *shmem_get_inode(struct mnt_idmap *idmap,
 #endif /* CONFIG_TMPFS_QUOTA */
 
 #ifdef CONFIG_USERFAULTFD
-int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
-			   struct vm_area_struct *dst_vma,
-			   unsigned long dst_addr,
-			   unsigned long src_addr,
-			   uffd_flags_t flags,
-			   struct folio **foliop)
-{
-	struct inode *inode = file_inode(dst_vma->vm_file);
-	struct shmem_inode_info *info = SHMEM_I(inode);
+static struct folio *shmem_mfill_folio_alloc(struct vm_area_struct *vma,
+					     unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
 	struct address_space *mapping = inode->i_mapping;
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	pgoff_t pgoff = linear_page_index(vma, addr);
 	gfp_t gfp = mapping_gfp_mask(mapping);
-	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
-	void *page_kaddr;
 	struct folio *folio;
-	int ret;
-	pgoff_t max_off;
-
-	if (shmem_inode_acct_blocks(inode, 1)) {
-		/*
-		 * We may have got a page, returned -ENOENT triggering a retry,
-		 * and now we find ourselves with -ENOMEM. Release the page, to
-		 * avoid a BUG_ON in our caller.
-		 */
-		if (unlikely(*foliop)) {
-			folio_put(*foliop);
-			*foliop = NULL;
-		}
-		return -ENOMEM;
-	}
 
-	if (!*foliop) {
-		ret = -ENOMEM;
-		folio = shmem_alloc_folio(gfp, 0, info, pgoff);
-		if (!folio)
-			goto out_unacct_blocks;
+	if (unlikely(pgoff >= DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE)))
+		return NULL;
 
-		if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY)) {
-			page_kaddr = kmap_local_folio(folio, 0);
-			/*
-			 * The read mmap_lock is held here.  Despite the
-			 * mmap_lock being read recursive a deadlock is still
-			 * possible if a writer has taken a lock.  For example:
-			 *
-			 * process A thread 1 takes read lock on own mmap_lock
-			 * process A thread 2 calls mmap, blocks taking write lock
-			 * process B thread 1 takes page fault, read lock on own mmap lock
-			 * process B thread 2 calls mmap, blocks taking write lock
-			 * process A thread 1 blocks taking read lock on process B
-			 * process B thread 1 blocks taking read lock on process A
-			 *
-			 * Disable page faults to prevent potential deadlock
-			 * and retry the copy outside the mmap_lock.
-			 */
-			pagefault_disable();
-			ret = copy_from_user(page_kaddr,
-					     (const void __user *)src_addr,
-					     PAGE_SIZE);
-			pagefault_enable();
-			kunmap_local(page_kaddr);
-
-			/* fallback to copy_from_user outside mmap_lock */
-			if (unlikely(ret)) {
-				*foliop = folio;
-				ret = -ENOENT;
-				/* don't free the page */
-				goto out_unacct_blocks;
-			}
+	folio = shmem_alloc_folio(gfp, 0, info, pgoff);
+	if (!folio)
+		return NULL;
 
-			flush_dcache_folio(folio);
-		} else {		/* ZEROPAGE */
-			clear_user_highpage(&folio->page, dst_addr);
-		}
-	} else {
-		folio = *foliop;
-		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
-		*foliop = NULL;
+	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL)) {
+		folio_put(folio);
+		return NULL;
 	}
 
-	VM_BUG_ON(folio_test_locked(folio));
-	VM_BUG_ON(folio_test_swapbacked(folio));
+	return folio;
+}
+
+static int shmem_mfill_filemap_add(struct folio *folio,
+				   struct vm_area_struct *vma,
+				   unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t pgoff = linear_page_index(vma, addr);
+	gfp_t gfp = mapping_gfp_mask(mapping);
+	int err;
+
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
-	__folio_mark_uptodate(folio);
-
-	ret = -EFAULT;
-	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-	if (unlikely(pgoff >= max_off))
-		goto out_release;
 
-	ret = mem_cgroup_charge(folio, dst_vma->vm_mm, gfp);
-	if (ret)
-		goto out_release;
-	ret = shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp);
-	if (ret)
-		goto out_release;
+	err = shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp);
+	if (err)
+		goto err_unlock;
 
-	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
-				       &folio->page, true, flags);
-	if (ret)
-		goto out_delete_from_cache;
+	if (shmem_inode_acct_blocks(inode, 1)) {
+		err = -ENOMEM;
+		goto err_delete_from_cache;
+	}
 
+	folio_add_lru(folio);
 	shmem_recalc_inode(inode, 1, 0);
-	folio_unlock(folio);
+
 	return 0;
-out_delete_from_cache:
+
+err_delete_from_cache:
 	filemap_remove_folio(folio);
-out_release:
+err_unlock:
+	folio_unlock(folio);
+	return err;
+}
+
+static void shmem_mfill_filemap_remove(struct folio *folio,
+				       struct vm_area_struct *vma)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+
+	filemap_remove_folio(folio);
+	shmem_recalc_inode(inode, 0, 0);
 	folio_unlock(folio);
-	folio_put(folio);
-out_unacct_blocks:
-	shmem_inode_unacct_blocks(inode, 1);
-	return ret;
 }
 
 static struct folio *shmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
@@ -3315,6 +3270,9 @@ static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 static const struct vm_uffd_ops shmem_uffd_ops = {
 	.can_userfault		= shmem_can_userfault,
 	.get_folio_noalloc	= shmem_get_folio_noalloc,
+	.alloc_folio		= shmem_mfill_folio_alloc,
+	.filemap_add		= shmem_mfill_filemap_add,
+	.filemap_remove		= shmem_mfill_filemap_remove,
 };
 #endif /* CONFIG_USERFAULTFD */
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 771a1e607c4c..e672a9e45d0c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -14,7 +14,6 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
-#include <linux/shmem_fs.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include "internal.h"
@@ -338,10 +337,10 @@ static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
  * This function handles both MCOPY_ATOMIC_NORMAL and _CONTINUE for both shmem
  * and anon, and for both shared and private VMAs.
  */
-int mfill_atomic_install_pte(pmd_t *dst_pmd,
-			     struct vm_area_struct *dst_vma,
-			     unsigned long dst_addr, struct page *page,
-			     bool newly_allocated, uffd_flags_t flags)
+static int mfill_atomic_install_pte(pmd_t *dst_pmd,
+				    struct vm_area_struct *dst_vma,
+				    unsigned long dst_addr, struct page *page,
+				    uffd_flags_t flags)
 {
 	int ret;
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
@@ -385,9 +384,6 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 		goto out_unlock;
 
 	if (page_in_cache) {
-		/* Usually, cache pages are already added to LRU */
-		if (newly_allocated)
-			folio_add_lru(folio);
 		folio_add_file_rmap_pte(folio, page, dst_vma);
 	} else {
 		folio_add_new_anon_rmap(folio, dst_vma, dst_addr, RMAP_EXCLUSIVE);
@@ -402,6 +398,9 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
+	if (page_in_cache)
+		folio_unlock(folio);
+
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 	ret = 0;
@@ -514,13 +513,22 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 	 */
 	__folio_mark_uptodate(folio);
 
+	if (ops->filemap_add) {
+		ret = ops->filemap_add(folio, state->vma, state->dst_addr);
+		if (ret)
+			goto err_folio_put;
+	}
+
 	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
-				       &folio->page, true, flags);
+				       &folio->page, flags);
 	if (ret)
-		goto err_folio_put;
+		goto err_filemap_remove;
 
 	return 0;
 
+err_filemap_remove:
+	if (ops->filemap_remove)
+		ops->filemap_remove(folio, state->vma);
 err_folio_put:
 	folio_put(folio);
 	/* Don't return -ENOENT so that our caller won't retry */
@@ -533,6 +541,18 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 
+	/*
+	 * The normal page fault path for a MAP_PRIVATE mapping in a
+	 * file-backed VMA will invoke the fault, fill the hole in the file and
+	 * COW it right away. The result generates plain anonymous memory.
+	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
+	 * generate anonymous memory directly without actually filling the
+	 * hole. For the MAP_PRIVATE case the robustness check only happens in
+	 * the pagetable (to verify it's still none) and not in the page cache.
+	 */
+	if (!(state->vma->vm_flags & VM_SHARED))
+		ops = &anon_uffd_ops;
+
 	return __mfill_atomic_pte(state, ops);
 }
 
@@ -552,7 +572,8 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 	spinlock_t *ptl;
 	int ret;
 
-	if (mm_forbids_zeropage(dst_vma->vm_mm))
+	if (mm_forbids_zeropage(dst_vma->vm_mm) ||
+	    (dst_vma->vm_flags & VM_SHARED))
 		return mfill_atomic_pte_zeroed_folio(state);
 
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
@@ -609,11 +630,10 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
 	}
 
 	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
-				       page, false, flags);
+				       page, flags);
 	if (ret)
 		goto out_release;
 
-	folio_unlock(folio);
 	return 0;
 
 out_release:
@@ -836,41 +856,19 @@ extern ssize_t mfill_atomic_hugetlb(struct userfaultfd_ctx *ctx,
 
 static __always_inline ssize_t mfill_atomic_pte(struct mfill_state *state)
 {
-	struct vm_area_struct *dst_vma = state->vma;
-	unsigned long src_addr = state->src_addr;
-	unsigned long dst_addr = state->dst_addr;
-	struct folio **foliop = &state->folio;
 	uffd_flags_t flags = state->flags;
-	pmd_t *dst_pmd = state->pmd;
-	ssize_t err;
 
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
 		return mfill_atomic_pte_continue(state);
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
 		return mfill_atomic_pte_poison(state);
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
+		return mfill_atomic_pte_copy(state);
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
+		return mfill_atomic_pte_zeropage(state);
 
-	/*
-	 * The normal page fault path for a shmem will invoke the
-	 * fault, fill the hole in the file and COW it right away. The
-	 * result generates plain anonymous memory. So when we are
-	 * asked to fill an hole in a MAP_PRIVATE shmem mapping, we'll
-	 * generate anonymous memory directly without actually filling
-	 * the hole. For the MAP_PRIVATE case the robustness check
-	 * only happens in the pagetable (to verify it's still none)
-	 * and not in the radix tree.
-	 */
-	if (!(dst_vma->vm_flags & VM_SHARED)) {
-		if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
-			err = mfill_atomic_pte_copy(state);
-		else
-			err = mfill_atomic_pte_zeropage(state);
-	} else {
-		err = shmem_mfill_atomic_pte(dst_pmd, dst_vma,
-					     dst_addr, src_addr,
-					     flags, foliop);
-	}
-
-	return err;
+	VM_WARN_ONCE(1, "Unknown UFFDIO operation, flags: %x", flags);
+	return -EOPNOTSUPP;
 }
 
 static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
-- 
2.53.0


