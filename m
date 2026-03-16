Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29352F53D9B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CFCA6B037E; Mon, 16 Mar 2026 17:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879E56B0380; Mon, 16 Mar 2026 17:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749176B0381; Mon, 16 Mar 2026 17:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DBA56B037E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:13:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1A4D1A060A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:40 +0000 (UTC)
X-FDA: 84553177800.11.D799854
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 792491C0011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E5RSz38K;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DrvTOdmgSIaCHLU5U4Rrw7jhmcSXokuq94ZE2dMDC5Y=;
	b=bJBiwREixszJZeGFZs7rvllLOYV4qW4aOhqnoqT7kx2cLtxU9etpjUSI2EZHl9KnIrCr5a
	CcHvnMoOLg4PhKP+glBH7HAN3cAYwoXHszPvtXjhH6fqs8q4fv64LEmZiPP0Nb5sUbF8oU
	sxGEfqqD2W8NfXZsLJsAnsSzX6mY7CY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695619; a=rsa-sha256;
	cv=none;
	b=eEgVFeWI+KBse6TtkGLUpknNBD7mrWwTKpjlOZVKBJgvJy0WCPKhZ/uTwVUGMPFzg5E7Hk
	iewIIRxvbei7vk8jSsgb/81rF2/+XBNrxfyDOCqOnKflbB+JRv4ehDNyDqe9/k+jKrq+bE
	EfLXi44bQLDrFpIgRaO4zXjOY93UqO4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E5RSz38K;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE7BE6132F;
	Mon, 16 Mar 2026 21:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF407C19421;
	Mon, 16 Mar 2026 21:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695618;
	bh=M9YPgPgzQgiaaTvzgsN1EFl4Gjd+CTrI/r/+UwMOL+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5RSz38KL9XNm+3bO5ISatwvJY95G7ZyUEx3WfEkMi1yAKRGZ9MpGsMVQlU7p8RUz
	 gp4539TwI17ToFGdGNhBtjM2Y9GOj/Vp5OqMMfp45j3mPM9NlsI6bmavmzZw6rG4zt
	 IWTFsJ55Zr6eeqmqyTxdNFo9p4QE/hrlSxBgyUUFDdutnHYyEFsc35NQ6LcI3w6JNh
	 oMkh5zMO4SmrL+3+ugCjizWpvase53kG+wKU0Moz4HbPvvxeZFVcgybaU3Jd4AkcGv
	 TnkunB+lhTT8P39srAKo/Kqsk+xLRHzuAPywpo8SGWn1KkTxxp3a89Ui6Z4C6aG0T4
	 QgCbUUR1ddsSQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v2 01/16] mm: various small mmap_prepare cleanups
Date: Mon, 16 Mar 2026 21:11:57 +0000
Message-ID: <afcb42b88acac93c6437b0dbbc71bba0b0e7429e.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: er3mqmefubbz3jdabhqzskqmfcgg9ysk
X-Rspam-User: 
X-Rspamd-Queue-Id: 792491C0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1773695619-871741
X-HE-Meta: U2FsdGVkX1/fzHLGXw8NQB61NLHVyImbJjGxHZa4fE4e8mpaHQiAvcQGwxQxVazcgtdSYva73fUwBVoO7CjHd2NkuznwGVVMx3EWoO//tkHbHOTy2R03yGyyiLTJ0eBDFEAggCAsNhjfp8X9/tylJ0lR2M5T0H6qprdBbswu/hyLgMGQ3oWaxFQD8FMxf6rLr+bDcS0MaFb+GMdrwXFH73cgV7KW9xb9Ly2QW+yIADlyVaSptoV+oa4dd3RUpNJyyEXaoBjDgWsreR/aPiodKSjFOZI5EljlGwUVmnd4J/yPwz0tTndnkCOyziSUlZoSoLRswmL/Y2rMoN6wI/rKwXVZyABjIDu2l6Ax9tgMr4WwvBJG6UgHPReJZ0BnzdBKDPyDxqHftC7x2xlNGaKazyUezk0GRjEb0rYNL7sf1h8UvG6HyqnVOzs+1agSwIMXcPo1yVAWo4V4HCIoTi8+KfgJ+N2E7xja6jtMPyw8QpFswRCqmz16sFucrRhxT/ii9ggHoTKJGWwDZaz4Jni/XTyiUIdg/sDvzmHEiF048rpeqmaQtSk3pdrWexHU3hlBz04xBys3DKC+9mLaT7F7LT1gfpusGULUbN8nHzWmjaO3T8YFqv/zgLnwceXJSeF8R6BduDQuljHSbNoVnFONehN4tLVJKEWRd2BBdROli9E2OnKkbgbZ5xA5C6W5jPVlpJeRuuvG0lP2evbu289PSfhMt33UpLih+bqf2tcyELIbpmbmQM5yNKJS8ABZGKEQRNfLCcRbGWJ5u55XW6Q6hldQ9R8lfKR47l2iAofAf5jqx2dGudn5Uu3BO7ElmswpcGmbU01Tx5mYNabuc7GjESRk/+Tn1OwfkV7dVwBcIdLAQywM6MlJu72zeni2V5kjhsSjjoWdikKpbHe1y1401xNcKv21NVyHsN1Axht9GW+y9+ZUJVruTkzxC8nbNYH7CBLUoZ5TT0eNQzeOGYH
 WY1pA419
 seBqeDaFp5MfywUNX/1Dw0E8+SvDXpDwtu1ikrcq27CiOchD32W/SPZdG4dkjpqjZmbJ4HeYljYmpMFOzo0vt9NTVhTDmTp4RBaJoqaglU2RbHW6aZvT887XaLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than passing arbitrary fields, pass a vm_area_desc pointer to mmap
prepare functions to mmap prepare, and an action and vma pointer to mmap
complete in order to put all the action-specific logic in the function
actually doing the work.

Additionally, allow mmap prepare functions to return an error so we can
error out as soon as possible if there is something logically incorrect in
the input.

Update remap_pfn_range_prepare() to properly check the input range for the
CoW case.

While we're here, make remap_pfn_range_prepare_vma() a little neater, and
pass mmap_action directly to call_action_complete().

Then, update compat_vma_mmap() to perform its logic directly, as
__compat_vma_map() is not used by anything so we don't need to export it.

Also update compat_vma_mmap() to use vfs_mmap_prepare() rather than
calling the mmap_prepare op directly.

Finally, update the VMA userland tests to reflect the changes.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/fs.h                |   2 -
 include/linux/mm.h                |   7 +-
 mm/internal.h                     |  27 ++++---
 mm/memory.c                       |  45 +++++++----
 mm/util.c                         | 119 +++++++++++++-----------------
 mm/vma.c                          |  24 +++---
 tools/testing/vma/include/dup.h   |   7 +-
 tools/testing/vma/include/stubs.h |   8 +-
 8 files changed, 123 insertions(+), 116 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25e..a2628a12bd2b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2058,8 +2058,6 @@ static inline bool can_mmap_file(struct file *file)
 	return true;
 }
 
-int __compat_vma_mmap(const struct file_operations *f_op,
-		struct file *file, struct vm_area_struct *vma);
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
 
 static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 42cc40aa63d9..1e63b3a44a47 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4320,10 +4320,9 @@ static inline void mmap_action_ioremap_full(struct vm_area_desc *desc,
 	mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(desc));
 }
 
-void mmap_action_prepare(struct mmap_action *action,
-			 struct vm_area_desc *desc);
-int mmap_action_complete(struct mmap_action *action,
-			 struct vm_area_struct *vma);
+int mmap_action_prepare(struct vm_area_desc *desc);
+int mmap_action_complete(struct vm_area_struct *vma,
+			 struct mmap_action *action);
 
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
diff --git a/mm/internal.h b/mm/internal.h
index 708d240b4198..9e42a57e8a12 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1793,26 +1793,31 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
 int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 
-void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
-int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn, unsigned long size, pgprot_t pgprot);
+int remap_pfn_range_prepare(struct vm_area_desc *desc);
+int remap_pfn_range_complete(struct vm_area_struct *vma,
+			     struct mmap_action *action);
 
-static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc,
-		unsigned long orig_pfn, unsigned long size)
+static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
+	struct mmap_action *action = &desc->action;
+	const unsigned long orig_pfn = action->remap.start_pfn;
+	const unsigned long size = action->remap.size;
 	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
 
-	return remap_pfn_range_prepare(desc, pfn);
+	action->remap.start_pfn = pfn;
+	return remap_pfn_range_prepare(desc);
 }
 
 static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long orig_pfn, unsigned long size,
-		pgprot_t orig_prot)
+					      struct mmap_action *action)
 {
-	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
-	const pgprot_t prot = pgprot_decrypted(orig_prot);
+	const unsigned long size = action->remap.size;
+	const unsigned long orig_pfn = action->remap.start_pfn;
+	const pgprot_t orig_prot = vma->vm_page_prot;
 
-	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
+	action->remap.pgprot = pgprot_decrypted(orig_prot);
+	action->remap.start_pfn  = io_remap_pfn_range_pfn(orig_pfn, size);
+	return remap_pfn_range_complete(vma, action);
 }
 
 #ifdef CONFIG_MMU_NOTIFIER
diff --git a/mm/memory.c b/mm/memory.c
index 219b9bf6cae0..9dec67a18116 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3099,26 +3099,34 @@ static int do_remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 }
 #endif
 
-void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn)
+int remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
-	/*
-	 * We set addr=VMA start, end=VMA end here, so this won't fail, but we
-	 * check it again on complete and will fail there if specified addr is
-	 * invalid.
-	 */
-	get_remap_pgoff(vma_desc_is_cow_mapping(desc), desc->start, desc->end,
-			desc->start, desc->end, pfn, &desc->pgoff);
+	const struct mmap_action *action = &desc->action;
+	const unsigned long start = action->remap.start;
+	const unsigned long end = start + action->remap.size;
+	const unsigned long pfn = action->remap.start_pfn;
+	const bool is_cow = vma_desc_is_cow_mapping(desc);
+	int err;
+
+	err = get_remap_pgoff(is_cow, start, end, desc->start, desc->end, pfn,
+			      &desc->pgoff);
+	if (err)
+		return err;
+
 	vma_desc_set_flags_mask(desc, VMA_REMAP_FLAGS);
+	return 0;
 }
 
-static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn, unsigned long size)
+static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma,
+				       unsigned long addr, unsigned long pfn,
+				       unsigned long size)
 {
-	unsigned long end = addr + PAGE_ALIGN(size);
+	const unsigned long end = addr + PAGE_ALIGN(size);
+	const bool is_cow = is_cow_mapping(vma->vm_flags);
 	int err;
 
-	err = get_remap_pgoff(is_cow_mapping(vma->vm_flags), addr, end,
-			      vma->vm_start, vma->vm_end, pfn, &vma->vm_pgoff);
+	err = get_remap_pgoff(is_cow, addr, end, vma->vm_start, vma->vm_end,
+			      pfn, &vma->vm_pgoff);
 	if (err)
 		return err;
 
@@ -3151,10 +3159,15 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(remap_pfn_range);
 
-int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn, unsigned long size, pgprot_t prot)
+int remap_pfn_range_complete(struct vm_area_struct *vma,
+			     struct mmap_action *action)
 {
-	return do_remap_pfn_range(vma, addr, pfn, size, prot);
+	const unsigned long start = action->remap.start;
+	const unsigned long pfn = action->remap.start_pfn;
+	const unsigned long size = action->remap.size;
+	const pgprot_t prot = action->remap.pgprot;
+
+	return do_remap_pfn_range(vma, start, pfn, size, prot);
 }
 
 /**
diff --git a/mm/util.c b/mm/util.c
index ce7ae80047cf..ac9dd6490523 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1163,43 +1163,6 @@ void flush_dcache_folio(struct folio *folio)
 EXPORT_SYMBOL(flush_dcache_folio);
 #endif
 
-/**
- * __compat_vma_mmap() - See description for compat_vma_mmap()
- * for details. This is the same operation, only with a specific file operations
- * struct which may or may not be the same as vma->vm_file->f_op.
- * @f_op: The file operations whose .mmap_prepare() hook is specified.
- * @file: The file which backs or will back the mapping.
- * @vma: The VMA to apply the .mmap_prepare() hook to.
- * Returns: 0 on success or error.
- */
-int __compat_vma_mmap(const struct file_operations *f_op,
-		struct file *file, struct vm_area_struct *vma)
-{
-	struct vm_area_desc desc = {
-		.mm = vma->vm_mm,
-		.file = file,
-		.start = vma->vm_start,
-		.end = vma->vm_end,
-
-		.pgoff = vma->vm_pgoff,
-		.vm_file = vma->vm_file,
-		.vma_flags = vma->flags,
-		.page_prot = vma->vm_page_prot,
-
-		.action.type = MMAP_NOTHING, /* Default */
-	};
-	int err;
-
-	err = f_op->mmap_prepare(&desc);
-	if (err)
-		return err;
-
-	mmap_action_prepare(&desc.action, &desc);
-	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(&desc.action, vma);
-}
-EXPORT_SYMBOL(__compat_vma_mmap);
-
 /**
  * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
  * existing VMA and execute any requested actions.
@@ -1228,7 +1191,31 @@ EXPORT_SYMBOL(__compat_vma_mmap);
  */
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return __compat_vma_mmap(file->f_op, file, vma);
+	struct vm_area_desc desc = {
+		.mm = vma->vm_mm,
+		.file = file,
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+
+		.pgoff = vma->vm_pgoff,
+		.vm_file = vma->vm_file,
+		.vma_flags = vma->flags,
+		.page_prot = vma->vm_page_prot,
+
+		.action.type = MMAP_NOTHING, /* Default */
+	};
+	int err;
+
+	err = vfs_mmap_prepare(file, &desc);
+	if (err)
+		return err;
+
+	err = mmap_action_prepare(&desc);
+	if (err)
+		return err;
+
+	set_vma_from_desc(vma, &desc);
+	return mmap_action_complete(vma, &desc.action);
 }
 EXPORT_SYMBOL(compat_vma_mmap);
 
@@ -1320,8 +1307,8 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 	}
 }
 
-static int mmap_action_finish(struct mmap_action *action,
-		const struct vm_area_struct *vma, int err)
+static int mmap_action_finish(struct vm_area_struct *vma,
+			      struct mmap_action *action, int err)
 {
 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
@@ -1353,37 +1340,38 @@ static int mmap_action_finish(struct mmap_action *action,
 /**
  * mmap_action_prepare - Perform preparatory setup for an VMA descriptor
  * action which need to be performed.
- * @desc: The VMA descriptor to prepare for @action.
- * @action: The action to perform.
+ * @desc: The VMA descriptor to prepare for its @desc->action.
+ *
+ * Returns: %0 on success, otherwise error.
  */
-void mmap_action_prepare(struct mmap_action *action,
-			 struct vm_area_desc *desc)
+int mmap_action_prepare(struct vm_area_desc *desc)
 {
-	switch (action->type) {
+	switch (desc->action.type) {
 	case MMAP_NOTHING:
-		break;
+		return 0;
 	case MMAP_REMAP_PFN:
-		remap_pfn_range_prepare(desc, action->remap.start_pfn);
-		break;
+		return remap_pfn_range_prepare(desc);
 	case MMAP_IO_REMAP_PFN:
-		io_remap_pfn_range_prepare(desc, action->remap.start_pfn,
-					   action->remap.size);
-		break;
+		return io_remap_pfn_range_prepare(desc);
 	}
+
+	WARN_ON_ONCE(1);
+	return -EINVAL;
 }
 EXPORT_SYMBOL(mmap_action_prepare);
 
 /**
  * mmap_action_complete - Execute VMA descriptor action.
- * @action: The action to perform.
  * @vma: The VMA to perform the action upon.
+ * @action: The action to perform.
  *
  * Similar to mmap_action_prepare().
  *
  * Return: 0 on success, or error, at which point the VMA will be unmapped.
  */
-int mmap_action_complete(struct mmap_action *action,
-			 struct vm_area_struct *vma)
+int mmap_action_complete(struct vm_area_struct *vma,
+			 struct mmap_action *action)
+
 {
 	int err = 0;
 
@@ -1391,25 +1379,20 @@ int mmap_action_complete(struct mmap_action *action,
 	case MMAP_NOTHING:
 		break;
 	case MMAP_REMAP_PFN:
-		err = remap_pfn_range_complete(vma, action->remap.start,
-				action->remap.start_pfn, action->remap.size,
-				action->remap.pgprot);
+		err = remap_pfn_range_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
-		err = io_remap_pfn_range_complete(vma, action->remap.start,
-				action->remap.start_pfn, action->remap.size,
-				action->remap.pgprot);
+		err = io_remap_pfn_range_complete(vma, action);
 		break;
 	}
 
-	return mmap_action_finish(action, vma, err);
+	return mmap_action_finish(vma, action, err);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #else
-void mmap_action_prepare(struct mmap_action *action,
-			struct vm_area_desc *desc)
+int mmap_action_prepare(struct vm_area_desc *desc)
 {
-	switch (action->type) {
+	switch (desc->action.type) {
 	case MMAP_NOTHING:
 		break;
 	case MMAP_REMAP_PFN:
@@ -1417,11 +1400,13 @@ void mmap_action_prepare(struct mmap_action *action,
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL(mmap_action_prepare);
 
-int mmap_action_complete(struct mmap_action *action,
-			struct vm_area_struct *vma)
+int mmap_action_complete(struct vm_area_struct *vma,
+			 struct mmap_action *action)
 {
 	int err = 0;
 
@@ -1436,7 +1421,7 @@ int mmap_action_complete(struct mmap_action *action,
 		break;
 	}
 
-	return mmap_action_finish(action, vma, err);
+	return mmap_action_finish(vma, action, err);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #endif
diff --git a/mm/vma.c b/mm/vma.c
index c1f183235756..2a86c7575000 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2640,15 +2640,18 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 	vma_set_page_prot(vma);
 }
 
-static void call_action_prepare(struct mmap_state *map,
-				struct vm_area_desc *desc)
+static int call_action_prepare(struct mmap_state *map,
+			       struct vm_area_desc *desc)
 {
-	struct mmap_action *action = &desc->action;
+	int err;
 
-	mmap_action_prepare(action, desc);
+	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
 
-	if (action->hide_from_rmap_until_complete)
+	if (desc->action.hide_from_rmap_until_complete)
 		map->hold_file_rmap_lock = true;
+	return 0;
 }
 
 /*
@@ -2672,7 +2675,9 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
-	call_action_prepare(map, desc);
+	err = call_action_prepare(map, desc);
+	if (err)
+		return err;
 
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
@@ -2727,13 +2732,12 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 }
 
 static int call_action_complete(struct mmap_state *map,
-				struct vm_area_desc *desc,
+				struct mmap_action *action,
 				struct vm_area_struct *vma)
 {
-	struct mmap_action *action = &desc->action;
 	int ret;
 
-	ret = mmap_action_complete(action, vma);
+	ret = mmap_action_complete(vma, action);
 
 	/* If we held the file rmap we need to release it. */
 	if (map->hold_file_rmap_lock) {
@@ -2795,7 +2799,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	__mmap_complete(&map, vma);
 
 	if (have_mmap_prepare && allocated_new) {
-		error = call_action_complete(&map, &desc, vma);
+		error = call_action_complete(&map, &desc.action, vma);
 
 		if (error)
 			return error;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 999357e18eb0..9eada1e0949c 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1271,9 +1271,12 @@ static inline int __compat_vma_mmap(const struct file_operations *f_op,
 	if (err)
 		return err;
 
-	mmap_action_prepare(&desc.action, &desc);
+	err = mmap_action_prepare(&desc);
+	if (err)
+		return err;
+
 	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(&desc.action, vma);
+	return mmap_action_complete(vma, &desc.action);
 }
 
 static inline int compat_vma_mmap(struct file *file,
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 5afb0afe2d48..a30b8bc84955 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -81,13 +81,13 @@ static inline void free_anon_vma_name(struct vm_area_struct *vma)
 {
 }
 
-static inline void mmap_action_prepare(struct mmap_action *action,
-					   struct vm_area_desc *desc)
+static inline int mmap_action_prepare(struct vm_area_desc *desc)
 {
+	return 0;
 }
 
-static inline int mmap_action_complete(struct mmap_action *action,
-					   struct vm_area_struct *vma)
+static inline int mmap_action_complete(struct vm_area_struct *vma,
+				       struct mmap_action *action)
 {
 	return 0;
 }
-- 
2.53.0


