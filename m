Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36CEBCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F12F6B00A4; Tue, 12 May 2026 12:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C92B6B00A6; Tue, 12 May 2026 12:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806D76B00A7; Tue, 12 May 2026 12:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7396B00A4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:06:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32AA3120361
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:06:53 +0000 (UTC)
X-FDA: 84759246306.08.A6DFD9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2ABD4A001A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:06:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uD/efJvw";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778602011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3ruRZQPpE0Zw0b68iiS2i+U+XDJSc44MQ1mYlbWQk+k=;
	b=42llw4aS9IYxuMntS1iUwnb+28S9Fdwbdo3h8xSEnoFQAQidvVK3om9rFB2Uu3dYww3RJx
	BIQ1fvfOzjsdII+94Nqi72dIdJ1mqYHdVWUaNl1hb9O+xCKqMvNLK6FXQU7s7ay8yPbMKu
	O0Uq1ZZFxh5l6KxETcunoMz/CyMnnGc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uD/efJvw";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778602011; a=rsa-sha256;
	cv=none;
	b=HqqfpJ53oLUH/iB94Oflg8kooX34DJsEw9HR2cs8WgpWGI39LwzSN7XH3kWDB/u0GQS4hL
	jiiRjbRNjBbWiBifm/kScFVNhRIzAnM04EgDjaOAdyvh/oFpgHXjXOiTF0E1tdF7JIHHrt
	fIrr3OAzgZfXW95ougPqSwiDE/csEcQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1DB54413B;
	Tue, 12 May 2026 16:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3537BC2BCB0;
	Tue, 12 May 2026 16:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778602009;
	bh=shjWw649vN3qm+7u01mQh2NpJxA06HBZO6kLu9v3Se8=;
	h=From:To:Cc:Subject:Date:From;
	b=uD/efJvwMBPItmy5P6nOJBHlB5Kq+2AqPTZxwt5lB/8dW9o7BYbcHiE9oRMtsSKBi
	 KV0oOj9dfw9xohCUVVjDxYfwr3SSzdeMxgTINzgk15pvcwJ1MFC1obicerEE9AUfcd
	 XE4FKqoLTbzRy9k2aiFA939Rn48uYhbasqZib2HrdXRy7KLuhByOFsGPxdyji+p5cO
	 8vt1bgoqWKpTNFXUDRLsUvUOwOr/xU0VASylDy+UfQcAkV2B5dIzHN1s5g4zY766W0
	 rJQXFHjhLxVL/RWwdeQGRwwWWR+Ccb08Q8QObh09AbjCBf2EJ7ZVtoi/YSGa2as7Px
	 0yQyvfisTyaHg==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "mm/hugetlbfs: update hugetlbfs to use mmap_prepare"
Date: Tue, 12 May 2026 17:06:43 +0100
Message-ID: <20260512160643.266960-1-ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wfejrsm848izszwfyzz3hioft8fpcegy
X-Rspamd-Queue-Id: 2ABD4A001A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778602010-766513
X-HE-Meta: U2FsdGVkX19/LToldidEU08tGhKFjy+TMY5C0DCq8TSv25WbCigiRNGRs/ICvzgWm7FXlJqynpe95mIQRxj20luKwe8x/h1+EyIA4mbuB189+czncFSXQXLsaKazf9DV4YYhV5nHeVPEP3fuYcaZIaKs4HJW3+qrtbEQuU1yCO53nC5ZDiBgeMqF7JDokilyX0F1zQsWA8c6DzJcudArboam1JmFYlAfxjUVfAHKjfmgFp8UbvJGRG11ojUgjFOJ/8+q/OOEuJqjrwsBA9PATztL6liCfTrHvAz8UFqs0EJt98B34NJAtPcKqF6vF0segDa8M3Q2CopRr5SoqC5KnSq4ivSFztlL6t3k9qfcqQ0yfCHBJoEJOv0fmGGJXzJHSDDJd6Ec8jmM0Ny2cTc9BpDyD265s18MHn1eyG6Qn1QgJ9aCY5wDiZzNXcpw+Pf4MSA8SD4ouDnTsGyyjXbeCmhaZQuLiGNKBMdHQZgQQevYlq4vhJxRK3xfh13E7CQq9P1oFLa2ugl5HdD6zT3zWJUj7E9nQALwQPT1mrrdoW2lVDtmN1Hf1ANCpmTtIPhy+Id52MUnW+MLbI/TvB8xCepbsIt+P/gIJzDJ0Qk3rMHjg/5R9sUFKeaiVSBFaPht9rehjsjiRotpkSVexynXxRJxxpMhX1AcHbeRK1vapq+govDpOtCYrmTBOs2/vMBm459TZVnsFJrs8SElaqYVtp0DJFh1uFENvXLvRD9UOYkICxwtV+pZeLMxzWOzqQw/3Ab0RwZkpKj67gr/PBJnol6FfcjaZ4wq/UjrLGf4mdp+gFKBPITlx7pV0346Q0nh8NK0ajsb4i/D7Dt4Q4FBakYOfbXxPewXFgbn6N0ze+gtiKgZp3io4C+TZlJZCAtU3+3Cp8NYdRNS0xd3m+amC6hOJ+CicNiyCZf6hUB0EltnMaRgEK6VgCHgw8kAGsvLh/3FTR30Ov6uZRhv2BF
 1Bq/0tgR
 7Mfx3KN9tIlk4ReYcGiCG4AdursxuNSXLBcTE/gA9l82euPbMSTipXLAarNhnUMm6jaNMF5cgLjnc0pL2f1dzXGpkGWAqDo+T9vHS9p6+vkqjSucOa8vuuAIok/O+AHViuTDqsaprLMNNA3a6ufPX8o43GisG/YSXGRV6kFlBLVnYnXPg1wZ1DsYfaoR/ORk6wXOk7VTymbp6l8NkhGk1E+TTCsrqVtVwUfmGDuJjLG7W/RSmEEeegsKLAjipXKFB8P32+ymw7kUzdEDPmAVblZx0lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit ea52cb24cd3f ("mm/hugetlbfs: update hugetlbfs to use
mmap_prepare") with conflict resolution to account for changes in commit
ea52cb24cd3f ("mm/hugetlbfs: update hugetlbfs to use mmap_prepare").

The patch incorrectly handled hugetlb VMA lock allocation at the
mmap_prepare stage, where a failed allocation occurring after mmap_prepare
is called might result in the lock leaking.

There is no risk of a merge causing a similar issues, as VMA_DONTEXPAND_BIT
is set for hugetlb mappings.

As a first step in addressing this issue, simply revert the change so we
can rework how we do this having corrected the underlying issues.

We maintain the VMA flags changes as best we can, accounting for the fact
that we were working with a VMA descriptor previously and propagating
like-for-like changes for this.

Note that we invoke vma_set_flags() and do not call vma_start_write() as
vm_flags_set() does. This is OK as it's being done in an .mmap hook where
the VMA is not yet linked into the tree so nobody else can be accessing it.

Fixes: ea52cb24cd3f ("mm/hugetlbfs: update hugetlbfs to use mmap_prepare")
Reported-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Closes: https://lore.kernel.org/linux-mm/20260425070700.562229-1-25181214217@stu.xidian.edu.cn/
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 fs/hugetlbfs/inode.c           | 46 +++++++---------------
 include/linux/hugetlb.h        |  8 +---
 include/linux/hugetlb_inline.h | 14 +------
 mm/hugetlb.c                   | 71 ++++++++++++++--------------------
 4 files changed, 45 insertions(+), 94 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8b05bec08e04..78d61bf2bd9b 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -96,15 +96,8 @@ static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
 #define PGOFF_LOFFT_MAX \
 	(((1UL << (PAGE_SHIFT + 1)) - 1) <<  (BITS_PER_LONG - (PAGE_SHIFT + 1)))
 
-static int hugetlb_file_mmap_prepare_success(const struct vm_area_struct *vma)
+static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	/* Unfortunate we have to reassign vma->vm_private_data. */
-	return hugetlb_vma_lock_alloc((struct vm_area_struct *)vma);
-}
-
-static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
-{
-	struct file *file = desc->file;
 	struct inode *inode = file_inode(file);
 	loff_t len, vma_len;
 	int ret;
@@ -119,8 +112,8 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
 	 * way when do_mmap unwinds (may be important on powerpc
 	 * and ia64).
 	 */
-	vma_desc_set_flags(desc, VMA_HUGETLB_BIT, VMA_DONTEXPAND_BIT);
-	desc->vm_ops = &hugetlb_vm_ops;
+	vma_set_flags(vma, VMA_HUGETLB_BIT, VMA_DONTEXPAND_BIT);
+	vma->vm_ops = &hugetlb_vm_ops;
 
 	/*
 	 * page based offset in vm_pgoff could be sufficiently large to
@@ -129,16 +122,16 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
 	 * sizeof(unsigned long).  So, only check in those instances.
 	 */
 	if (sizeof(unsigned long) == sizeof(loff_t)) {
-		if (desc->pgoff & PGOFF_LOFFT_MAX)
+		if (vma->vm_pgoff & PGOFF_LOFFT_MAX)
 			return -EINVAL;
 	}
 
 	/* must be huge page aligned */
-	if (desc->pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
+	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
 		return -EINVAL;
 
-	vma_len = (loff_t)vma_desc_size(desc);
-	len = vma_len + ((loff_t)desc->pgoff << PAGE_SHIFT);
+	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
+	len = vma_len + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 	/* check for overflow */
 	if (len < vma_len)
 		return -EINVAL;
@@ -148,7 +141,7 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
 
 	ret = -ENOMEM;
 
-	vma_flags = desc->vma_flags;
+	vma_flags = vma->flags;
 	/*
 	 * for SHM_HUGETLB, the pages are reserved in the shmget() call so skip
 	 * reserving here. Note: only for SHM hugetlbfs file, the inode
@@ -158,30 +151,17 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
 		vma_flags_set(&vma_flags, VMA_NORESERVE_BIT);
 
 	if (hugetlb_reserve_pages(inode,
-			desc->pgoff >> huge_page_order(h),
-			len >> huge_page_shift(h), desc,
-			vma_flags) < 0)
+				vma->vm_pgoff >> huge_page_order(h),
+				len >> huge_page_shift(h), vma,
+				vma_flags) < 0)
 		goto out;
 
 	ret = 0;
-	if (vma_desc_test(desc, VMA_WRITE_BIT) && inode->i_size < len)
+	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len)
 		i_size_write(inode, len);
 out:
 	inode_unlock(inode);
 
-	if (!ret) {
-		/* Allocate the VMA lock after we set it up. */
-		desc->action.success_hook = hugetlb_file_mmap_prepare_success;
-		/*
-		 * We cannot permit the rmap finding this VMA in the time
-		 * between the VMA being inserted into the VMA tree and the
-		 * completion/success hook being invoked.
-		 *
-		 * This is because we establish a per-VMA hugetlb lock which can
-		 * be raced by rmap.
-		 */
-		desc->action.hide_from_rmap_until_complete = true;
-	}
 	return ret;
 }
 
@@ -1227,7 +1207,7 @@ static void init_once(void *foo)
 
 static const struct file_operations hugetlbfs_file_operations = {
 	.read_iter		= hugetlbfs_read_iter,
-	.mmap_prepare		= hugetlbfs_file_mmap_prepare,
+	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= noop_fsync,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
 	.llseek			= default_llseek,
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 93418625d3c5..5957bc25efa8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -148,7 +148,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			     struct folio **foliop);
 #endif /* CONFIG_USERFAULTFD */
 long hugetlb_reserve_pages(struct inode *inode, long from, long to,
-			   struct vm_area_desc *desc, vma_flags_t vma_flags);
+			   struct vm_area_struct *vma, vma_flags_t vma_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
@@ -276,7 +276,6 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
 void fixup_hugetlb_reservations(struct vm_area_struct *vma);
 void hugetlb_split(struct vm_area_struct *vma, unsigned long addr);
-int hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 
 unsigned int arch_hugetlb_cma_order(void);
 
@@ -469,11 +468,6 @@ static inline void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 
 static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr) {}
 
-static inline int hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
-{
-	return 0;
-}
-
 #endif /* !CONFIG_HUGETLB_PAGE */
 
 #ifndef pgd_write
diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
index 565b473fd135..5c29cd3223a1 100644
--- a/include/linux/hugetlb_inline.h
+++ b/include/linux/hugetlb_inline.h
@@ -6,23 +6,13 @@
 
 #ifdef CONFIG_HUGETLB_PAGE
 
-static inline bool is_vm_hugetlb_flags(vm_flags_t vm_flags)
-{
-	return !!(vm_flags & VM_HUGETLB);
-}
-
 static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
 {
-	return vma_flags_test_any(flags, VMA_HUGETLB_BIT);
+	return vma_flags_test(flags, VMA_HUGETLB_BIT);
 }
 
 #else
 
-static inline bool is_vm_hugetlb_flags(vm_flags_t vm_flags)
-{
-	return false;
-}
-
 static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
 {
 	return false;
@@ -32,7 +22,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
 
 static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
 {
-	return is_vm_hugetlb_flags(vma->vm_flags);
+	return is_vma_hugetlb_flags(&vma->flags);
 }
 
 #endif
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 31b34ca0f402..9f60fe0c1c72 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -116,6 +116,7 @@ struct mutex *hugetlb_fault_mutex_table __ro_after_init;
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
+static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
@@ -413,21 +414,17 @@ static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
 	}
 }
 
-/*
- * vma specific semaphore used for pmd sharing and fault/truncation
- * synchronization
- */
-int hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
+static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
 {
 	struct hugetlb_vma_lock *vma_lock;
 
 	/* Only establish in (flags) sharable vmas */
 	if (!vma || !(vma->vm_flags & VM_MAYSHARE))
-		return 0;
+		return;
 
 	/* Should never get here with non-NULL vm_private_data */
 	if (vma->vm_private_data)
-		return -EINVAL;
+		return;
 
 	vma_lock = kmalloc_obj(*vma_lock);
 	if (!vma_lock) {
@@ -442,15 +439,13 @@ int hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
 		 * allocation failure.
 		 */
 		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
-		return -EINVAL;
+		return;
 	}
 
 	kref_init(&vma_lock->refs);
 	init_rwsem(&vma_lock->rw_sema);
 	vma_lock->vma = vma;
 	vma->vm_private_data = vma_lock;
-
-	return 0;
 }
 
 /* Helper that removes a struct file_region from the resv_map cache and returns
@@ -1147,28 +1142,20 @@ static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
 	}
 }
 
-static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long flags)
+static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
 {
 	VM_WARN_ON_ONCE_VMA(!is_vm_hugetlb_page(vma), vma);
-	VM_WARN_ON_ONCE_VMA(vma->vm_flags & VM_MAYSHARE, vma);
+	VM_WARN_ON_ONCE_VMA(vma_test(vma, VMA_MAYSHARE_BIT), vma);
 
-	set_vma_private_data(vma, get_vma_private_data(vma) | flags);
+	set_vma_private_data(vma, (unsigned long)map);
 }
 
-static void set_vma_desc_resv_map(struct vm_area_desc *desc, struct resv_map *map)
-{
-	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
-	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_MAYSHARE_BIT));
-
-	desc->private_data = map;
-}
-
-static void set_vma_desc_resv_flags(struct vm_area_desc *desc, unsigned long flags)
+static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long flags)
 {
-	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
-	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_MAYSHARE_BIT));
+	VM_WARN_ON_ONCE_VMA(!is_vm_hugetlb_page(vma), vma);
+	VM_WARN_ON_ONCE_VMA(vma_test(vma, VMA_MAYSHARE_BIT), vma);
 
-	desc->private_data = (void *)((unsigned long)desc->private_data | flags);
+	set_vma_private_data(vma, get_vma_private_data(vma) | flags);
 }
 
 static int is_vma_resv_set(struct vm_area_struct *vma, unsigned long flag)
@@ -1178,13 +1165,6 @@ static int is_vma_resv_set(struct vm_area_struct *vma, unsigned long flag)
 	return (get_vma_private_data(vma) & flag) != 0;
 }
 
-static bool is_vma_desc_resv_set(struct vm_area_desc *desc, unsigned long flag)
-{
-	VM_WARN_ON_ONCE(!is_vma_hugetlb_flags(&desc->vma_flags));
-
-	return ((unsigned long)desc->private_data) & flag;
-}
-
 bool __vma_private_lock(struct vm_area_struct *vma)
 {
 	return !(vma->vm_flags & VM_MAYSHARE) &&
@@ -6555,7 +6535,7 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 
 long hugetlb_reserve_pages(struct inode *inode,
 		long from, long to,
-		struct vm_area_desc *desc,
+		struct vm_area_struct *vma,
 		vma_flags_t vma_flags)
 {
 	long chg = -1, add = -1, spool_resv, gbl_resv;
@@ -6572,6 +6552,12 @@ long hugetlb_reserve_pages(struct inode *inode,
 		return -EINVAL;
 	}
 
+	/*
+	 * vma specific semaphore used for pmd sharing and fault/truncation
+	 * synchronization
+	 */
+	hugetlb_vma_lock_alloc(vma);
+
 	/*
 	 * Only apply hugepage reservation if asked. At fault time, an
 	 * attempt will be made for VM_NORESERVE to allocate a page
@@ -6584,9 +6570,9 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * Shared mappings base their reservation on the number of pages that
 	 * are already allocated on behalf of the file. Private mappings need
 	 * to reserve the full area even if read-only as mprotect() may be
-	 * called to make the mapping read-write. Assume !desc is a shm mapping
+	 * called to make the mapping read-write. Assume !vma is a shm mapping
 	 */
-	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
+	if (!vma || vma_test(vma, VMA_MAYSHARE_BIT)) {
 		/*
 		 * resv_map can not be NULL as hugetlb_reserve_pages is only
 		 * called for inodes for which resv_maps were created (see
@@ -6605,8 +6591,8 @@ long hugetlb_reserve_pages(struct inode *inode,
 
 		chg = to - from;
 
-		set_vma_desc_resv_map(desc, resv_map);
-		set_vma_desc_resv_flags(desc, HPAGE_RESV_OWNER);
+		set_vma_resv_map(vma, resv_map);
+		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
 
 	if (chg < 0) {
@@ -6620,7 +6606,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	if (err < 0)
 		goto out_err;
 
-	if (desc && !vma_desc_test(desc, VMA_MAYSHARE_BIT) && h_cg) {
+	if (vma && !vma_test(vma, VMA_MAYSHARE_BIT) && h_cg) {
 		/* For private mappings, the hugetlb_cgroup uncharge info hangs
 		 * of the resv_map.
 		 */
@@ -6657,7 +6643,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * consumed reservations are stored in the map. Hence, nothing
 	 * else has to be done for private mappings here
 	 */
-	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
+	if (!vma || vma_test(vma, VMA_MAYSHARE_BIT)) {
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
@@ -6721,15 +6707,16 @@ long hugetlb_reserve_pages(struct inode *inode,
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
 out_err:
-	if (!desc || vma_desc_test(desc, VMA_MAYSHARE_BIT))
+	hugetlb_vma_lock_free(vma);
+	if (!vma || vma_test(vma, VMA_MAYSHARE_BIT))
 		/* Only call region_abort if the region_chg succeeded but the
 		 * region_add failed or didn't run.
 		 */
 		if (chg >= 0 && add < 0)
 			region_abort(resv_map, from, to, regions_needed);
-	if (desc && is_vma_desc_resv_set(desc, HPAGE_RESV_OWNER)) {
+	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		kref_put(&resv_map->refs, resv_map_release);
-		set_vma_desc_resv_map(desc, NULL);
+		set_vma_resv_map(vma, NULL);
 	}
 	return err;
 }
-- 
2.54.0


