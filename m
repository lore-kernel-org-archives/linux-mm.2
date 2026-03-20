Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB8C21099B4B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155AB6B0116; Fri, 20 Mar 2026 18:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107316B0119; Fri, 20 Mar 2026 18:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F378C6B011A; Fri, 20 Mar 2026 18:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4B2B6B0116
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D6771A040A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:11 +0000 (UTC)
X-FDA: 84567911022.06.C216233
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1582E180002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jDB8yu+3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FHWD92WJU5UbKir9hx5xfx25mo9vyZdMUalfq2RK9w=;
	b=oQ5LnbgXKnt9veeP1kwKM+3st4pB3GRW+uHxEqxHzQV/yDdztZhYZaw+JVI83bRaojSo9y
	GC6EnoixYWcp8TqaV26fL6mYEvs9p+7KujEUdAdUcXqPgWRN6ddFYSXssUMJGE9CM1RHtk
	LheOuZgRiizbEGEZIM0XPvbypLKOiQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046410; a=rsa-sha256;
	cv=none;
	b=fR9hcI/UMfo+LEK2ZJz1Q9NjVB2lGE85s1/yv4/KnnxicjORheOdIGRBZ0TQ1pZ6GzCnOK
	VQyJnLJeVnBx7Lf2qiKSYN5GInXvlRjq+YF7qAxOOYVdmQ2bC8wLLAornkfFjjSzcIYEi1
	LNTCDd2Q8RZIph4J7nfFjQOWdzFwzRs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jDB8yu+3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93B9B60128;
	Fri, 20 Mar 2026 22:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D149C4CEF7;
	Fri, 20 Mar 2026 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046409;
	bh=/eFcILNrrDL/FJ/GXYtQOFiMhhVt3ls4GxXx41zEl5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDB8yu+35VLB8nyurcTNRGGilntgo6oVbhQafoq0MRcauH/fOPjyWJ/9/zVdfGmBN
	 vuRST5X0S+sViZmfOc9I7wAbOuIMN4lR2b2d3Tm7X73EFp6Xy00nxti3OFIt76r1eP
	 J4Ynw6B3Ljyno4dxdxTsulEiUf55ckUOTPrkvmK8E2mCH/wyKm8FKpDkrY6mEP9n0u
	 AhDhC1TUUNHul6hnVWr/4UUSnbAGBke2pU6R6xwdBwFTXK0vnEQYoGhAYe9qjn/09f
	 lxyO96oKQvZG47vM2xw7C/0T7NKSfRGrAh5Hc2DuJ9i1RMGy/rbe2VCQ3Syx97ceMU
	 GByQXcqolO1zg==
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
Subject: [PATCH v4 01/21] mm: various small mmap_prepare cleanups
Date: Fri, 20 Mar 2026 22:39:27 +0000
Message-ID: <99f408e4694f44ab12bdc55fe0bd9685d3bd1117.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1582E180002
X-Stat-Signature: p6wab71xy3qpoedzm68g3fezjrwe3qn9
X-Rspam-User: 
X-HE-Tag: 1774046409-755465
X-HE-Meta: U2FsdGVkX18oME5S382RK0l0ovdlknH7OISfiQjrH9dr8citn2JAfNQtSGJjZwOvBhrk7HKQXBpXA7Jfmfmq6FealdAZRVpZsSCNNOqQyzELKJSVu04AIZ2nBR29CPp3xtthi/RvIAXTSTiI8dHHYXjx2GfjQwZsV69SwSYGz4eEAvhzdPamHxMZ3jdXSogJpCEvShsIrsKXj04FVY8A6Ih915a75VjnyL29mMHpuddDXhHFNNtzfMFd3J5yJrVkgccJ+kGxTwnzDl2WJNGnjUimrCTehNte6N/zDvLtZTzl6pSf8dWdI1ihA3StKJOmUjI4o5ox5JNsoXjlJ/qZ6YdQniJ+jcAoeW9yd1UpH+n5YBJjnQhTV0w33/AsOvUnB9XeFfvNZl8kbGvpxDgbR+y/hZnhT/i9WPrVwncCzD6ThL5c2CoJAAg0w4hGwvkQTExMfKx74iercnmsV0fFPqm6RDomtDA5COXbtcKwMxG3cnTvFNVVRDtfjOVKUvofFqs5nhiWK7vfvCJFAfuKM5WrDxMFjpT4hOFZHyZDOgoTlSQPmjBr46Zns60rXXXlxff3VD90ntCRKFrbvEBk6xlIr7SyjGO4kSGBv1WeHlibBAj0IV4+/ZCbXdGsYkwgjgDr6VbphiNHhkV7nbtifmbmaBIp30Wkeds2+HS3erXqUfIPEOY2dk54rWlULUwD+NedEBWmxQZbk55tyhOki3tQIMN/Fbra276AVkwKf5edjrJtBYwKAZ158gYU8hGxvnPvU6jxvchCrZiC9pvD9XPeh28eS6ipbyOKVJqpKIyaflO4w0ZO6MHQEBJmQlWFLTpcVyYZ4g30SUKpZuESrL+lgeUSewI/7wDlDNo3NZErWwNdLeZBU4m9A7N8zEvmsASEtu7BOJL6A1bGAxltcklcdDIhJEkNmV/3LuRuTToL3v9TevXD0fGrvJd9xeIZF1iCX+yPC/IlnpVk+Nq
 qwpDkWiv
 rN9j6GIwe1DI3Uad2n8EF3IRT+xdkwFEGJZoQWH8nlporm5/rN/Obq/Ryo2l79ryzcCKPMnfFtFB/e0feuW7mK8ki/jc31KvFQ43ZHp4cjtWAMpDbCK7NH1/1L2ECxjjKEVLdrNbcExhyVmBuvhmH7B3nIFZDyzX4QIY2zPMarbzrfFQYTlISHxIYp3WjNKasGSN/6Wn2l90TWJmP4SrSXFA/z086ALIHJTHNP1WOaidGlHvEXKnLDo43sIMqXQVtMPzJahWIDQvgpX28If+/tUTg1EeeYJH/j22mOerBP+bNw73twKvSq4Bc54pefh3+eip8RmAvSSxHnJAa220x2CGU69ZPdPhRe3m/36gWFApkm3QU7Aeuk0KjJlZRRNbP/Ul8
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

Also remove io_remap_pfn_range_complete(), as we can simply set up the
fields correctly in io_remap_pfn_range_prepare() and use
remap_pfn_range_complete() for this.

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
 mm/internal.h                     |  32 ++++----
 mm/memory.c                       |  45 +++++++----
 mm/util.c                         | 121 +++++++++++++-----------------
 mm/vma.c                          |  24 +++---
 tools/testing/vma/include/dup.h   |   7 +-
 tools/testing/vma/include/stubs.h |   8 +-
 8 files changed, 126 insertions(+), 120 deletions(-)

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
index 708d240b4198..0256ca44115a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1793,26 +1793,28 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
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
+	const pgprot_t orig_pgprot = action->remap.pgprot;
+	const unsigned long size = action->remap.size;
 	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
+	int err;
 
-	return remap_pfn_range_prepare(desc, pfn);
-}
+	action->remap.start_pfn = pfn;
+	action->remap.pgprot = pgprot_decrypted(orig_pgprot);
+	err = remap_pfn_range_prepare(desc);
+	if (err)
+		return err;
 
-static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long orig_pfn, unsigned long size,
-		pgprot_t orig_prot)
-{
-	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
-	const pgprot_t prot = pgprot_decrypted(orig_prot);
-
-	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
+	/* Remap does the actual work. */
+	action->type = MMAP_REMAP_PFN;
+	return 0;
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
index ce7ae80047cf..73c97a748d8e 100644
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
 
@@ -1391,25 +1379,22 @@ int mmap_action_complete(struct mmap_action *action,
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
+		/* Should have been delegated. */
+		WARN_ON_ONCE(1);
+		err = -EINVAL;
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
@@ -1417,11 +1402,13 @@ void mmap_action_prepare(struct mmap_action *action,
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
 
@@ -1436,7 +1423,7 @@ int mmap_action_complete(struct mmap_action *action,
 		break;
 	}
 
-	return mmap_action_finish(action, vma, err);
+	return mmap_action_finish(vma, action, err);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #endif
diff --git a/mm/vma.c b/mm/vma.c
index 8cccaeb8ccbb..ee91f2b76acf 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2641,15 +2641,18 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
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
@@ -2673,7 +2676,9 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
-	call_action_prepare(map, desc);
+	err = call_action_prepare(map, desc);
+	if (err)
+		return err;
 
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
@@ -2728,13 +2733,12 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
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
@@ -2796,7 +2800,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	__mmap_complete(&map, vma);
 
 	if (have_mmap_prepare && allocated_new) {
-		error = call_action_complete(&map, &desc, vma);
+		error = call_action_complete(&map, &desc.action, vma);
 
 		if (error)
 			return error;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index b69eefba4cf7..477a5be65dd2 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1273,9 +1273,12 @@ static inline int __compat_vma_mmap(const struct file_operations *f_op,
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


