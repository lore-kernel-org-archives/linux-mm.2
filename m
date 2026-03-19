Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DECD109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83216B055B; Thu, 19 Mar 2026 14:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5146B0560; Thu, 19 Mar 2026 14:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8380E6B0561; Thu, 19 Mar 2026 14:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1506B055B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:23:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 431741B84D2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:23:51 +0000 (UTC)
X-FDA: 84563636262.17.16D6A54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id AB572C0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:23:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jyvu3tt/";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zR/ocG3Yh2JrZXxsTeeJrsT0241llHKKxY+UXiobfZY=;
	b=wR2IK+eDGmOqwdTu/fVhvwyCKbT0MPYcdRJnJoFrTF6wLoYkuUr+XhQ1gBPWK3HZALeElt
	/uUwdXjbf+Dg5XGJFbzXEsDVc9JyDn3xq0/QIDAEIQ0Cw7LKmRrMFOKpGIo9IbgRbrFvNM
	QE7yi0KApZZwEIQNA+GbC3WubN1jku4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944629; a=rsa-sha256;
	cv=none;
	b=iI6W0MrTm1Y/tFqr/NZMl/B5Eg0degeYGEPEOKNeDGqkCaFx9Zj7fw8uF4PiWI1XySutGp
	+ogn5ZXe3LiX70sD4v2q7TWwigIcvoS2bZfGT3geVu/6e5ITweaEbCC5edojR9ghtBTEZs
	G8/R5ws8vw+1JMXevB2457cpDpmAurs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jyvu3tt/";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0311960097;
	Thu, 19 Mar 2026 18:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EFDC19424;
	Thu, 19 Mar 2026 18:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944628;
	bh=zT3cNLZK8LNPqhtQCsC5NrcMioFLWSD7PUVEnxZ3a9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jyvu3tt/6CLbppCQ0d81Vbi5H1RRIhnu2jt6r9T3TwKkkxzjhG0RGvSpa0f1UCDOo
	 JS+cwzZ7hp/j+KMfs7s0raHk+tD/xh4c3oyXE+FxpKNPUW7CtfkhMdx0Chmff9vyzq
	 Q50Fi74oyMCEuJYqCiFNCn4r2aO5EO2VJ9d6h8+KtucVrUuSp8Pz3Q2GZGoVOQWC7a
	 VhiVYh4ShHWWvwX+0IaTqBcghkT+4aJZmVnyek9cyU68Q/Q4dygS5hQ4CN1/+Vy1Yg
	 0xxcf28m92ximfrSSl3sJ0One81PQRQa/I2tQOUy3VtaijgsgWIaIOSsrdEWq6rj9j
	 nw1HrdKyJjaqg==
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
Subject: [PATCH v3 01/16] mm: various small mmap_prepare cleanups
Date: Thu, 19 Mar 2026 18:23:25 +0000
Message-ID: <498a579bfbcbb8b0e4a9c39243b4454347f03a46.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB572C0004
X-Stat-Signature: uexgr7sewxjni5489n1md6qiiqkfiqna
X-HE-Tag: 1773944629-837354
X-HE-Meta: U2FsdGVkX1/HTrRmfrjfAdhacz0Q3mTshtvJ+JPrBeqxumi0OAFV3dgap6hqNqDyMB8nZCJ8MVSQwQVN8Q9OG/XWXdILWoa/9q8a7Jr2UuThXTuU0yil5AiVsxceSZ/MrB9dJCZlluNNchRyQcpfdJQ4ZS4MGYoutDCnAy1EaPm/N1+hR444vT0YrPa7i3jQd5ajVCFOaH/+01XN1vcc7H95gcjnsDGDzaE+u3kYtedr4dJEIudDgUu65QXCIZcTlqO9NbFkCff9Im8vxHrzL59TOtTd4hiAXpMRwPDjCQqxv3ggkO1XcSgMQ95NO77LLvVti8z/dwBwS2Fyt7cB9c+sRN2LHQxqljtp+WWErzUiLrHz0ZR1eAhikC6r0rseTXodbQE//yWnkEQ5WKWgx6cxhy677Ylvz/H2rfDmuZ/ANscoycz2X8f8P2+E439rUFDmOSMKBOPpwzTTyYao7wh6bg0LdbYNFvpeK42Ssr4jlitiAvXucEHCZGXinzzwcxICAZauWRMXAL1CwVDd9uA1MvwtTVEJf73Ca/8YCOajRqzv2/NRH8rpyeJdzRigtU/nbOJh8kqX8GFSC6VLIuFXaO48/YDcjGpv66+tFFQC4UJyq6ATEgBiMxZ/kbcYDUn40odtsbUUb1ROwIy5u5YFs7I30SbSsgd29kVTS2YsWUxjDdM4scBwe3PEnNb6M9lJ2d4js4Dynusv9tKVoQbTgrfR3+jXVql1Q2z2pncYL6qC6CzKWxUmR6x0/UhlS18e5qui/CIcnoQXquH6jhWL5Ugoqqu0eqwLBRAWD6J+xZ3rYHFU4YVQbUUd2erFX1wVibAxTP+wwPF7YzhzmMKoSv7N40EuM/nz2vZ4zHdj/0RMcMM6FHaLqzEAQ3EZYHi9ozuno/30wy4dWHzzDUb6Uv+04CzIOmDreqZJzQFM3JIpe7rsHn0pMbA778AT4lbIVDft+1KSDOXIZmS
 OvrhPrpV
 RbfPltoVQJby3IsK64OUC3cUyP3uVbBqmg/Jhp2gwnNQJBg7JRrAgQpHMNUXsQErJuUROhUKCAlvIUMWLQXx5oi9/pEld3X6pEY5hdeNShxcuihhlpEuLxZOJe0WC98XaW+V7wopE/zS9l4gV/xtufW2vwuTsTC+veMBjf0pqDPo0UYDDz3shDjr7NIP5WyecFqWYIOE+6uyhh6pYcwEOpV3LyhkfKxC2ZRgzNYi/xq+lmprnmaihOQFSNj+3q01r7ygJ/YsCYmLf4TW7ABI2n2M44vUj0YqUHS2rWfYjLjebDVchIPk1T8FijqMc5Y8EbVKYvgS6iSrg2LcPk4eZYmsiY4eXAlG+IYaGxhLf11Asrxi0422prfjX7qlqswx6+bDM
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


