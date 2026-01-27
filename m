Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D050D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FAF76B0005; Tue, 27 Jan 2026 14:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF666B00A4; Tue, 27 Jan 2026 14:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E69A6B00A6; Tue, 27 Jan 2026 14:30:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A32C6B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E1161A0349
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:53 +0000 (UTC)
X-FDA: 84378736386.30.3ADCC3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 586914000F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UoCRp3/P";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbMBo/6zfiDtrCQ8dYp2EhgGJn0NAeWZtFciM7wAOHY=;
	b=OSXyqMUFsEzVf+vyBeO+xNrJ9Z5nMBM3JeQrmQD5dhJkD+MGbEacd4ajFr3NaIGYkllICg
	GG9/B1HL+zPYP1WxGM/Pd6ZesOmuDoBAlsTf/277inoXiOghMHEtX3tgvekNchLWKfMJTc
	saO6ottSe3C/jgu8rjYLG5Y6L6//VI8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UoCRp3/P";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542251; a=rsa-sha256;
	cv=none;
	b=2VSsbJUbbb7/eX4XMGGEyqttg2tcppxRp1Pq011jiTbJ5d3d6FJNXmtBehCdVcx/59+fvG
	fyjszpBoRbtieaDFG6TaYA4JdEN5edeV4iV5MPbotx1nrq2NUUS2FSPflt1V+aW5V4++Sc
	jnwJxY1BMxx2Yk232BsV+B+mZJQac9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 522E342DAC;
	Tue, 27 Jan 2026 19:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748E7C116C6;
	Tue, 27 Jan 2026 19:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542250;
	bh=Xb+xc8R1aRP1DZaVc1IOpEFUHCEmFeum4D1XaFDWybk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoCRp3/PvJtRL9uUKUMuSaU/ZNr6oeqV3RCuFhVjCgZd8x//VhYNUnnt5pcYsGuKT
	 5qhIL46SNavcTIZ8Jv5URb9fDi6KJcGK9SM+fLlgGQCVyP4ZUEm0hHP0yEw1xcLLRi
	 FcQrnaLlXYSfgBnto6Nb3+N/k6lj4BlgUx8X1kyO8nCKkT/KSEvHP0lJrhaxo+VOUL
	 MM5TwAybb4vkrOM3IqIcB1vfW1m4aUzGawv7JLMAGE+mYsZRdB3e5m7zH1ea6x6jcB
	 116+gB1VNxLP3DssltYW0BK53oQFU3I9kY0f6dGqyZ+NUzMS5G82qArY4QCT5jaT/K
	 G2p6bpe8uuD6Q==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 10/17] shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
Date: Tue, 27 Jan 2026 21:29:29 +0200
Message-ID: <20260127192936.1250096-11-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 586914000F
X-Stat-Signature: 5f8ztws8cc1ydzyn4kma9oqmyhf9ttuz
X-Rspam-User: 
X-HE-Tag: 1769542251-479
X-HE-Meta: U2FsdGVkX18/80B/BGKglPfnfJVgERLijEfToIC8Fhu0rL3Ino+o2RshYGa790HXauZ+E+iuQxdYk0LayS5h/oW/6R4eMsuAwkaXpOqO2wBr2oe4QfCALQLP1bu/swNgAiKDd/yEcDMOn5vgyG4gl4ASb+oPfswRdH/e7/ZldP5eEYikyZuKs/F+2D/cIvcJlygOD1HGOp1Lt182wgvYeRLAsU8/Cp6MjOFimXzS/WmiDj1qrRALtVLOk5KFzklGdZEr+VP+e554dKh4czRyvKR1v2b0D7PF5s68k9XJ5Y4Pki5XlAXzZbwDACvL2+QWjF2zgDWwymdaO/UBgZF1MKEoY0TK89W6B4dVpTex2HbnGGRSURl30QwY52WB78ExgCxL0dvdX0sCcJcZ4th6BAdahDAzwXdl+GeqyhPuHfc2T17dBLftdNbVfiV8XYmjEcpdefv0XJcm0Fv/dEjYAi5787qYtRVua6qPU8FR+yVYov/HOkExm3x4EdV0VT0Kta6HTKm+kXBcTbM4tQfMwLCUeed1XRdE6XLQn2d3kD/hu7H3/OEsW5riGTiGJ+TmD+JCKNZl2dWQ8Kx9uDvsQFZmSd0mgkeQDajYhhY7hlESaxYt8z1TYgxMD/bm/r7rrOC+FQPY9321lsG1H/G6QDpu142iRBfxHvNTxmMrHPqfgODZWKb5qSjuHNhvU/uhnKZJNLtzzypmW/qqRe2xbmD04Kf2MnCRQreFIjnM9Y9ALwEQiOQP1feWs0reaNfp/q7wj8VU1XabWBu9FE/w8pwixfgIukSIM496zH8H/kPFU3IG6rmLIUzp6t69lLQLpw1PXfBdjSnaKwg3I69kvPgwhJ0byDdZ8iw6Y+EEBsbd7JF42fRB1mQ8dh/tb3OFwcTA4S8DwWFpbh+04uVaJudyTBDi/eGKgbK3zdCTTs6YBeN8AFHXqAvGZVs+7cTORzW2AFo/O65f4GAsN/0
 DQX9HU7c
 /IEcAbpVakyd57grF4HZCalogp2IQlV9p+ANLLpD0iTN4tzIu5AnBN3YkChuYLrsnCObYfd8o1yHYDKSH3zwtK7i7sL14ZdgUTezFYr5e0HXm9muKouoyNBObUpGPfc/VB1WxiCuunblZlOOFFYntkwxucp+hqFQWMLErxnyy+VxK9gKF0Yp31sl8zFCOglVGTL0vWsW+rTqKAqb8eW3/zP2hCueKSeRNuu2PscKtVMJRkfXdNzy0pK5bo1YmU5CEfLecXMv8HvT0jioZFMk1YhfGOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

fixup

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/shmem_fs.h      |  14 ----
 include/linux/userfaultfd_k.h |  20 +++--
 mm/shmem.c                    | 148 ++++++++++++----------------------
 mm/userfaultfd.c              |  79 +++++++++---------
 4 files changed, 106 insertions(+), 155 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e2069b3179c4..754f17e5b53c 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -223,20 +223,6 @@ static inline pgoff_t shmem_fallocend(struct inode *inode, pgoff_t eof)
 
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
index 4d8b879eed91..75d5b09f2560 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -97,6 +97,21 @@ struct vm_uffd_ops {
 	 */
 	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
 				     unsigned long addr);
+	/*
+	 * Called during resolution of UFFDIO_COPY request.
+	 * Should lock the folio and add it to VMA's page cache.
+	 * Returns 0 on success, error code on failre.
+	 */
+	int (*filemap_add)(struct folio *folio, struct vm_area_struct *vma,
+			 unsigned long addr);
+	/*
+	 * Called during resolution of UFFDIO_COPY request on the error
+	 * handling path.
+	 * Should revert the operation of ->filemap_add().
+	 * The folio should be unlocked, but the reference to it should not be
+	 * dropped.
+	 */
+	void (*filemap_remove)(struct folio *folio, struct vm_area_struct *vma);
 };
 
 /* A combined operation mode + behavior flags. */
@@ -130,11 +145,6 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
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
index 87cd8d2fdb97..6f0485f76cb8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3169,118 +3169,73 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
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
 #endif /* CONFIG_USERFAULTFD */
 
@@ -5317,6 +5272,9 @@ static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
 static const struct vm_uffd_ops shmem_uffd_ops = {
 	.can_userfault		= shmem_can_userfault,
 	.get_folio_noalloc	= shmem_get_folio_noalloc,
+	.alloc_folio		= shmem_mfill_folio_alloc,
+	.filemap_add		= shmem_mfill_filemap_add,
+	.filemap_remove		= shmem_mfill_filemap_remove,
 };
 #endif
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index b3c12630769c..54aa195237ba 100644
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
@@ -337,10 +336,10 @@ static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
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
@@ -384,9 +383,6 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 		goto out_unlock;
 
 	if (page_in_cache) {
-		/* Usually, cache pages are already added to LRU */
-		if (newly_allocated)
-			folio_add_lru(folio);
 		folio_add_file_rmap_pte(folio, page, dst_vma);
 	} else {
 		folio_add_new_anon_rmap(folio, dst_vma, dst_addr, RMAP_EXCLUSIVE);
@@ -401,6 +397,9 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
+	if (page_in_cache)
+		folio_unlock(folio);
+
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 	ret = 0;
@@ -507,13 +506,22 @@ static int __mfill_atomic_pte(struct mfill_state *state,
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
@@ -526,6 +534,18 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
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
 
@@ -545,7 +565,8 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 	spinlock_t *ptl;
 	int ret;
 
-	if (mm_forbids_zeropage(dst_vma->vm_mm))
+	if (mm_forbids_zeropage(dst_vma->vm_mm) ||
+	    (dst_vma->vm_flags & VM_SHARED))
 		return mfill_atomic_pte_zeroed_folio(state);
 
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
@@ -600,11 +621,10 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
 	}
 
 	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
-				       page, false, flags);
+				       page, flags);
 	if (ret)
 		goto out_release;
 
-	folio_unlock(folio);
 	return 0;
 
 out_release:
@@ -827,41 +847,18 @@ extern ssize_t mfill_atomic_hugetlb(struct userfaultfd_ctx *ctx,
 
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


