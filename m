Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5D5FCC048
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83DA6B00B7; Fri,  6 Mar 2026 12:19:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30616B00BA; Fri,  6 Mar 2026 12:19:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FAB6B00BC; Fri,  6 Mar 2026 12:19:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7870B6B00B7
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:19:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 411F11B841B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:31 +0000 (UTC)
X-FDA: 84516299742.20.3CC7C3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6A9EE180010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OOIsInpM;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnvV4R7hkc8vmlGULGDKsY1zKU9uCpRxo40r/eUYm2A=;
	b=hkMZQFlJxvvOIK4JxAhYBr58gtHLVmDm0oL9C+GsptoeWzPFobdwY+XF1ZUvwdGMD0w+bg
	EACszsXMo6Gf4Z8bQq9DVgdmdue6cRAlqjGRYLgqoCyYouIL87AHywhETIN+RPYulTrqVv
	QZA8wXM5uuKR2+v1jTwGdf3Cqxurrkg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OOIsInpM;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817569; a=rsa-sha256;
	cv=none;
	b=GLK+waGcig1pBM05fV4XZo2bBkFUpU0+vqxbaD1gmOd7qsA09Au6O1OmKsDT2YYDOVbQ3k
	PkpYg2KllUHMJ/WTn2uvjSL3a1oxJNk7d3Lk6How2p0WsL33domZLqGlGxCoZtVdEcM+5c
	9Scs3kfCwwv8TFBOFFGwPNj41o3ZiAo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 855A14399B;
	Fri,  6 Mar 2026 17:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE03CC4CEF7;
	Fri,  6 Mar 2026 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817568;
	bh=Yw4D+/1fCurRlZ1OehdGpOfaYnZr4j87kF8uPGr9MdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOIsInpM53tHfARK9/OsmmAkYqqMvg1P5gi0oa4Uskn3kZmMY7h8qF2pnsqQ5NBdx
	 +9ofjRS3lA89zmcxhXMn09Jx08Wj0fAW4GdRmhhDm1edFlRNJvFQtGb/g0dyxZZNst
	 NrcgLM6mN0swuQlMGLF8uF/kRmE2Copw2JPWTG39PsCkoYSGQ6kA0/wUcHebfHkogl
	 ADQrm6Ul05U5z1d6MRhmGZ3BGlt6CRJQvaB/T9B+cGtK0xnlrVlgqIygemtPIqkh2+
	 qOHvIgjIexcJDiVLbD4Kzp62XELKwp6s9JjRY6P3RPw17sbB0+MmbV5MG1z9rRZbMV
	 D6QBfiVfC414A==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 10/15] shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
Date: Fri,  6 Mar 2026 19:18:10 +0200
Message-ID: <20260306171815.3160826-11-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A9EE180010
X-Stat-Signature: 8d1rk5o14m3e9ierzz517qzo7nw8d5by
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772817569-813232
X-HE-Meta: U2FsdGVkX19fCgAxSKYod5LT54JbNJJF4u5vZ1Ni/uGvXVKVwOfDqqIgBNdDidH5IXZonTD1jRf0xq2CIm62QdtudETECEVjGnKdCqPGZ63L27ZxEhsM3hFL6/CjyONdQA+cFxIRt9zEVBA+a9Ism+CHzGYzV9JRERVWIA+dKfr4WT70qZKSp1Q5QfgeHA7erpcACuTSZAHfwUVzuy/iPwl8Cft2deB+bkjcnYSD5rgySXeDQWUyy288d4W139ersDbcMl7SumdyqB+Nj9ScbmpzyF3HJx6/xpe3tGTWz5Jow/1meyUaklwTrsooRrJlfAByE98nfOrITIZYFXokZ3k8SdphKszl/RL+YYtiR/tzrdSOvzh5teDbvfnaqgAm9ywdgaVq+U3CPSjxKTM95UPx/w7z3vk4Igyef0jzRww3dSGXcZ+lVYtKjGUxlisFxYDXsFoOB71hZlXLBVyUQaZ/AxHvtEJIPvl64KGmixvNVMnyjbrqVVJX0IC0jFGQqky6dtNrKSNQz2znF7W/2EiTrzBRgJm3PaNCt54Fe3mlqkmNLgNrUQb5pBMXj8W/AE6gjJuX2NNL3dm7fZzSiu9LxKzq7wmqsMYlm166Lxc1S0efkBgsNPjobbRL6f71FNwAkaZuBUm/GWVRWyBaat5BJT8J5pDFzbOhiQqc4O1ifIt6Sv4EpIq76qlAYcR0sbyZkgiCeUXksXFksLoNNxVO/+Y/E3Vv32Is90algTXgADNQgzcR/QdmKUEtylgx0dped8oYbQauPwiDhUudDR1v0TGKXoroUs0EBTMeXi3gLSGGRINa1lSwgROh1nDk6xQS/Ui2BKK3Z0HCMFZK5hTwtshbR1al31liXFxS567qZiUssjEqku0CvwBhihwtUahoJvFz88Dux/bdwwdeuwbyT8z6Zo8t9Z13RTxjLDh/h/8sAiAb25uuXSh8wEd+7HBfc4ax8+jBFA7w0NV
 zA9D0/NE
 U8iSfrE3Wsva9mOhZ6gVnsE+0BbyhmWmHA07BPHWDMzQb0L7vuF69nTIukO/ZljTGIBpWwoBbxi/hEGqQPNq1UDmGQ1cPGKbWGPYTMXbFh3BnfyKjS6k770iKtLtcNmMwBDWaqC8M/UE7rxQxIFesJOnUSCaLq3hhBQLJC4wdhhqVUS4aHohomXE45b3XdlXs4asJuAH8b8bgmwavTXcA6Ny5PC1G+3eDecuc7zlaOOpjufr87S3HWX7MpnKgVhjthBnhUTxHTftJ8CAo5Ep1UuN6M4PpWMPQSRL3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Add filemap_add() and filemap_remove() methods to vm_uffd_ops and use
them in __mfill_atomic_pte() to add shmem folios to page cache and
remove them in case of error.

Implement these methods in shmem along with vm_uffd_ops->alloc_folio()
and drop shmem_mfill_atomic_pte().

Since userfaultfd now does not reference any functions from shmem, drop
include if linux/shmem_fs.h from mm/userfaultfd.c

mfill_atomic_install_pte() is not used anywhere outside of
mm/userfaultfd, make it static.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/shmem_fs.h      |  14 ----
 include/linux/userfaultfd_k.h |  21 +++--
 mm/shmem.c                    | 148 ++++++++++++----------------------
 mm/userfaultfd.c              |  79 +++++++++---------
 4 files changed, 106 insertions(+), 156 deletions(-)

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
index 4d8b879eed91..bf4e595ac914 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -93,10 +93,24 @@ struct vm_uffd_ops {
 	struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
 	/*
 	 * Called during resolution of UFFDIO_COPY request.
-	 * Should return allocate a and return folio or NULL if allocation fails.
+	 * Should allocate and return a folio or NULL if allocation
+	 * fails.
 	 */
 	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
 				     unsigned long addr);
+	/*
+	 * Called during resolution of UFFDIO_COPY request.
+	 * Should lock the folio and add it to VMA's page cache.
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
index 31f3ab6a73e2..a0f8e67006d6 100644
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
@@ -340,10 +339,10 @@ static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
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
@@ -387,9 +386,6 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 		goto out_unlock;
 
 	if (page_in_cache) {
-		/* Usually, cache pages are already added to LRU */
-		if (newly_allocated)
-			folio_add_lru(folio);
 		folio_add_file_rmap_pte(folio, page, dst_vma);
 	} else {
 		folio_add_new_anon_rmap(folio, dst_vma, dst_addr, RMAP_EXCLUSIVE);
@@ -404,6 +400,9 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
+	if (page_in_cache)
+		folio_unlock(folio);
+
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 	ret = 0;
@@ -516,13 +515,22 @@ static int __mfill_atomic_pte(struct mfill_state *state,
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
@@ -535,6 +543,18 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
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
 
@@ -554,7 +574,8 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
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
@@ -836,41 +856,18 @@ extern ssize_t mfill_atomic_hugetlb(struct userfaultfd_ctx *ctx,
 
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
+	return -EOPNOTSUPP;
 }
 
 static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
-- 
2.51.0


