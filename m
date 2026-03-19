Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F2F109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8127F6B0562; Thu, 19 Mar 2026 14:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C21A6B0563; Thu, 19 Mar 2026 14:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663D56B0564; Thu, 19 Mar 2026 14:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5101D6B0562
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E095C1F3D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:00 +0000 (UTC)
X-FDA: 84563636640.02.7BEB821
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A08120004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:23:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gpw3BgDX;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Lc0WKw3d6bVwUmA06wSPk68Ed0+3DwJd8+cbWV105k=;
	b=eGp1NlBF3PkgGmVVmlRu/utayDMMo2FOE0MADwEzGuJkYCH7ey273BaIUWIDdwe+qUxQe0
	HQo6xD67yg/nwb+xp15pjC4UXvRNJQITV5IqEvyhDXfRmoEWh99wVkEOrE9cgUbNnFimYN
	f/V+TTNydzEqL/ZI9LXpuWLZn5wvLiw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gpw3BgDX;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944638; a=rsa-sha256;
	cv=none;
	b=hJr7i4sqndNXXugnr+h9jmW9ghDZ5L+oWfrWDvFwxf8O2fBaHW0+oUqJf8I9HgYi281lUE
	WnJ/TDclw5xDLNFrOZtigmnkgHNzoeKsfesPmv1lPJgEHMSkf1vQOxX2c1UdIrbQ+NZ0HS
	UPs/gYY6QSYHywFItlf1B3crbtLwMAA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A5C144522;
	Thu, 19 Mar 2026 18:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9381EC19425;
	Thu, 19 Mar 2026 18:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944637;
	bh=yOkRVsddg4Rw0V72nVj1xm5Tn2c+X/Jv21oVKleQTi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpw3BgDXA1PK7Z/6OE+zLKxrEMFWf3KndELouDA4P1+MEXJMwWNT7GvjohrKsNV+m
	 HfV9lk+LoWJvwphUwCXU2JxIGbgWuGf5n/4mSlLfYaHMjpSPJglmVBW+aidU6qf80p
	 O20tg3idJ90IG30CuczbXv0Sn2fF2aDAQXg35wQuSnZl/4Ezkt+iT3VcZQfgtPRoYV
	 MzdZHzBFnymWbX24oPxl4Akb+UhJ0iHm2Kt13knFydj0x215vjlO5pPm/Y4sdFJKGb
	 u+NM3pbW0J9ZgynQiVqDyQDOh8cul8NNp5CiTrrhDPoOXndn/UhPxnoLTz0Td2q1Nd
	 3jncx5oL/W6ag==
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
Subject: [PATCH v3 04/16] mm: add vm_ops->mapped hook
Date: Thu, 19 Mar 2026 18:23:28 +0000
Message-ID: <a97366fa6f22a0ca1340cfd2b0d4df87c80ac80a.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A08120004
X-Stat-Signature: ytf7ko998egkumrx9kkjutbumnjp94c6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773944638-240824
X-HE-Meta: U2FsdGVkX19vRAucF88Hhv3dStB2FyNbwTYhq/XABb+qapwu94eQNlKiYQ5XS/qYFYa2UIRWbx/IDpP1uem44sctNSHzGitbAZYsH9gQfhJASwT8azxwswdGC+xhY5nvSp4osC9RZe51Vzmjd4Yi5+sHOqtSKgdfTBb36L2G/rQRQssC6zwfHQSSMiOmLU1w4oCXgf++QV5ij03kCW+lTnHhGYtYi2gK4HqxVpypcR+ARJ6cpuOALdFi3s5lFoU4fLECcqK43ToGgk863qZcT1LXy1aayMFF+1DMakULCzD8AmKEFY3mWScij9H6wZCxZN1VhBfbXji3pbYRrPVPonQqftcrPDpaFQWTAwZRy2mIEODWxXT9vcw23wxbp6P2uRPMCii4C86hX8K6cx0KFMLbzbm6rytc3M2otgbNZpiRTKj30DtzMcX5qyW+6JQhBYqH8tF+pcgy9AluKozkF1M2b9+EzT7m9vrEiEkv7eIMMYJp3XibNzbo5N8jvC0jMew7DfjpUl70SXxQStUYtUOpUhaiRKl50ZzD17mzz66KcCuOL26+b8qbLNUgm1OCSmcpyXpE3kr2PI1ehU2I6vjah9ex+SL9zQYu0YgSsrZ81Hz/KMgKYqdiJRD7eooJL0kgVbBDOYpMvycEl0DovsfO8472+E7LyrJiDfScP5mTLMKgCAGv2KoAJwQXAt9kUFpuh32aGgQ2nkMNk3AaWBO1gX09MkhwXjI6vJ5dnfSkFWXXZVnlX+tYtLu+a1p360fO1wyrBTEpGPcJvsRIQTt9CbtiBH4Qx4AFg7cbptXxmjjZrE0GY375KUoUP5jtV2LdyRgbolBqlJyCSl6RVQYxIJvlr59/dbDf19a0XHKdwBx1cfQ0wbLyZt+rnVXaBgIONiRP/3y6rkXBn72yTiPRwfRkbvmVG0T738OJ7203mxF+Jts/d46c5r2NTXZjIKQbL45PHRhEqzonD37
 wiLZgpzx
 3eefnZMs6MouFMEBbJkm0kOe4lEfd79LANdhSq1JkXZgPRb76BhaFVElYZlTeidCtM/xwmYQoonoKFe3PKx9J0WIGyxBdra45ShOC0knNbcZcESh8FFWiLsTPiPqm6JOb4WPLweMHCVWDLUyd324hSTbRz1AsFuluQRIAs28O5KB/Gop3urFOMIDTvTxlDyzmuUEK5mCyngvADDRWHQwEeDSMxnuTU5TQxOf0jxLeB42iuj0cgmd1LGOuzsCHNbZ+Yd8sLioRpo/hFY7BgHGN4576OSCvULDyCSy5i4uP3y7cJ9FHsr4iRVI/D97yTlNAnPLjoVlDjNoNtSfEPB3bIMD7NWIrcEk2k0MT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, when a driver needed to do something like establish a
reference count, it could do so in the mmap hook in the knowledge that the
mapping would succeed.

With the introduction of f_op->mmap_prepare this is no longer the case, as
it is invoked prior to actually establishing the mapping.

mmap_prepare is not appropriate for this kind of thing as it is called
before any merge might take place, and after which an error might occur
meaning resources could be leaked.

To take this into account, introduce a new vm_ops->mapped callback which
is invoked when the VMA is first mapped (though notably - not when it is
merged - which is correct and mirrors existing mmap/open/close behaviour).

We do better that vm_ops->open() here, as this callback can return an
error, at which point the VMA will be unmapped.

Note that vm_ops->mapped() is invoked after any mmap action is complete
(such as I/O remapping).

We intentionally do not expose the VMA at this point, exposing only the
fields that could be used, and an output parameter in case the operation
needs to update the vma->vm_private_data field.

In order to deal with stacked filesystems which invoke inner filesystem's
mmap() invocations, add __compat_vma_mapped() and invoke it on vfs_mmap()
(via compat_vma_mmap()) to ensure that the mapped callback is handled when
an mmap() caller invokes a nested filesystem's mmap_prepare() callback.

We can now also remove call_action_complete() and invoke
mmap_action_complete() directly, as we separate out the rmap lock logic.

The rmap lock logic, which was added in order to keep hugetlb working (!)
to allow for the rmap lock to be held longer, needs to be propagated to the
error paths on mmap complete and mapped hook error paths.

This is because do_munmap() might otherwise deadlock with the rmap being
held, so instead we unlock at the point of unmap.

This is fine as any reliance on the rmap being held is irrelevant on error.

While we're here, refactor mmap_action_finish() to avoid a big if (err)
branch.

We also abstract unmapping of a VMA on mmap action completion into its own
helper function, unmap_vma_locked().

Update the mmap_prepare documentation to describe the mapped hook and make
it clear what its intended use is.

Additionally, update VMA userland test headers to reflect the change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst |  15 +++
 include/linux/fs.h                         |   9 +-
 include/linux/mm.h                         |  20 +++-
 mm/internal.h                              |   8 ++
 mm/util.c                                  | 129 ++++++++++++++-------
 mm/vma.c                                   |  35 +++---
 tools/testing/vma/include/dup.h            |  27 ++++-
 tools/testing/vma/include/stubs.h          |   3 +-
 8 files changed, 186 insertions(+), 60 deletions(-)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index 65a1f094e469..20db474915da 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -25,6 +25,21 @@ That is - no resources should be allocated nor state updated to reflect that a
 mapping has been established, as the mapping may either be merged, or fail to be
 mapped after the callback is complete.
 
+Mapped callback
+---------------
+
+If resources need to be allocated per-mapping, or state such as a reference
+count needs to be manipulated, this should be done using the ``vm_ops->mapped``
+hook, which itself should be set by the >mmap_prepare hook.
+
+This callback is only invoked if a new mapping has been established and was not
+merged with any other, and is invoked at a point where no error may occur before
+the mapping is established.
+
+You may return an error to the callback itself, which will cause the mapping to
+become unmapped and an error returned to the mmap() caller. This is useful if
+resources need to be allocated, and that allocation might fail.
+
 How To Use
 ==========
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a2628a12bd2b..c390f5c667e3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2059,13 +2059,20 @@ static inline bool can_mmap_file(struct file *file)
 }
 
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
+int __vma_check_mmap_hook(struct vm_area_struct *vma);
 
 static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	int err;
+
 	if (file->f_op->mmap_prepare)
 		return compat_vma_mmap(file, vma);
 
-	return file->f_op->mmap(file, vma);
+	err = file->f_op->mmap(file, vma);
+	if (err)
+		return err;
+
+	return __vma_check_mmap_hook(vma);
 }
 
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index da94edb287cd..68dee1101313 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -777,6 +777,23 @@ struct vm_operations_struct {
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.
 	 */
 	void (*close)(struct vm_area_struct *vma);
+	/**
+	 * @mapped: Called when the VMA is first mapped in the MM. Not called if
+	 * the new VMA is merged with an adjacent VMA.
+	 *
+	 * The @vm_private_data field is an output field allowing the user to
+	 * modify vma->vm_private_data as necessary.
+	 *
+	 * ONLY valid if set from f_op->mmap_prepare. Will result in an error if
+	 * set from f_op->mmap.
+	 *
+	 * Returns %0 on success, or an error otherwise. On error, the VMA will
+	 * be unmapped.
+	 *
+	 * Context: User context.  May sleep.  Caller holds mmap_lock.
+	 */
+	int (*mapped)(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data);
 	/* Called any time before splitting to check if it's allowed */
 	int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
 	int (*mremap)(struct vm_area_struct *vma);
@@ -4327,7 +4344,8 @@ static inline void mmap_action_ioremap_full(struct vm_area_desc *desc,
 
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action);
+			 struct mmap_action *action,
+			 bool rmap_lock_held);
 
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
diff --git a/mm/internal.h b/mm/internal.h
index 0256ca44115a..e0f554178143 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -202,6 +202,14 @@ static inline void vma_close(struct vm_area_struct *vma)
 /* unmap_vmas is in mm/memory.c */
 void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
 
+static inline void unmap_vma_locked(struct vm_area_struct *vma)
+{
+	const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+	mmap_assert_write_locked(vma->vm_mm);
+	do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
+}
+
 #ifdef CONFIG_MMU
 
 static inline void get_anon_vma(struct anon_vma *anon_vma)
diff --git a/mm/util.c b/mm/util.c
index 73c97a748d8e..fc1bd8a8f3ea 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1163,6 +1163,54 @@ void flush_dcache_folio(struct folio *folio)
 EXPORT_SYMBOL(flush_dcache_folio);
 #endif
 
+static int __compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
+{
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
+	return mmap_action_complete(vma, &desc.action, /*rmap_lock_held=*/false);
+}
+
+static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
+{
+	const struct vm_operations_struct *vm_ops = vma->vm_ops;
+	void *vm_private_data = vma->vm_private_data;
+	int err;
+
+	if (!vm_ops || !vm_ops->mapped)
+		return 0;
+
+	err = vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff, file,
+			     &vm_private_data);
+	if (err)
+		unmap_vma_locked(vma);
+	else if (vm_private_data != vma->vm_private_data)
+		vma->vm_private_data = vm_private_data;
+
+	return err;
+}
+
 /**
  * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
  * existing VMA and execute any requested actions.
@@ -1191,34 +1239,26 @@ EXPORT_SYMBOL(flush_dcache_folio);
  */
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 {
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
 	int err;
 
-	err = vfs_mmap_prepare(file, &desc);
+	err = __compat_vma_mmap(file, vma);
 	if (err)
 		return err;
 
-	err = mmap_action_prepare(&desc);
-	if (err)
-		return err;
-
-	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action);
+	return __compat_vma_mapped(file, vma);
 }
 EXPORT_SYMBOL(compat_vma_mmap);
 
+int __vma_check_mmap_hook(struct vm_area_struct *vma)
+{
+	/* vm_ops->mapped is not valid if mmap() is specified. */
+	if (vma->vm_ops && WARN_ON_ONCE(vma->vm_ops->mapped))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(__vma_check_mmap_hook);
+
 static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
 			 const struct page *page)
 {
@@ -1308,32 +1348,31 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 }
 
 static int mmap_action_finish(struct vm_area_struct *vma,
-			      struct mmap_action *action, int err)
+			      struct mmap_action *action, int err,
+			      bool rmap_lock_held)
 {
+	if (rmap_lock_held)
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+
+	if (!err) {
+		if (action->success_hook)
+			return action->success_hook(vma);
+		return 0;
+	}
+
 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
 	 * only clear the newly allocated VMA, since this function is only
 	 * invoked if we do NOT merge, so we only clean up the VMA we created.
 	 */
-	if (err) {
-		const size_t len = vma_pages(vma) << PAGE_SHIFT;
-
-		do_munmap(current->mm, vma->vm_start, len, NULL);
-
-		if (action->error_hook) {
-			/* We may want to filter the error. */
-			err = action->error_hook(err);
-
-			/* The caller should not clear the error. */
-			VM_WARN_ON_ONCE(!err);
-		}
-		return err;
+	unmap_vma_locked(vma);
+	if (action->error_hook) {
+		/* We may want to filter the error. */
+		err = action->error_hook(err);
+		/* The caller should not clear the error. */
+		VM_WARN_ON_ONCE(!err);
 	}
-
-	if (action->success_hook)
-		return action->success_hook(vma);
-
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_MMU
@@ -1364,13 +1403,15 @@ EXPORT_SYMBOL(mmap_action_prepare);
  * mmap_action_complete - Execute VMA descriptor action.
  * @vma: The VMA to perform the action upon.
  * @action: The action to perform.
+ * @rmap_lock_held: Is the file rmap lock held?
  *
  * Similar to mmap_action_prepare().
  *
  * Return: 0 on success, or error, at which point the VMA will be unmapped.
  */
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action)
+			 struct mmap_action *action,
+			 bool rmap_lock_held)
 
 {
 	int err = 0;
@@ -1388,7 +1429,8 @@ int mmap_action_complete(struct vm_area_struct *vma,
 		break;
 	}
 
-	return mmap_action_finish(vma, action, err);
+	return mmap_action_finish(vma, action, err,
+				  rmap_lock_held);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #else
@@ -1408,7 +1450,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 EXPORT_SYMBOL(mmap_action_prepare);
 
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action)
+			 struct mmap_action *action,
+			 bool rmap_lock_held)
 {
 	int err = 0;
 
@@ -1423,7 +1466,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 		break;
 	}
 
-	return mmap_action_finish(vma, action, err);
+	return mmap_action_finish(vma, action, err, rmap_lock_held);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #endif
diff --git a/mm/vma.c b/mm/vma.c
index 2a86c7575000..a27d1278ea6d 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2731,21 +2731,28 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 	return false;
 }
 
-static int call_action_complete(struct mmap_state *map,
-				struct mmap_action *action,
-				struct vm_area_struct *vma)
+static int call_mapped_hook(struct mmap_state *map,
+			    struct vm_area_struct *vma)
 {
-	int ret;
-
-	ret = mmap_action_complete(vma, action);
+	const struct vm_operations_struct *vm_ops = vma->vm_ops;
+	void *vm_private_data = vma->vm_private_data;
+	int err;
 
-	/* If we held the file rmap we need to release it. */
-	if (map->hold_file_rmap_lock) {
-		struct file *file = vma->vm_file;
+	if (!vm_ops || !vm_ops->mapped)
+		return 0;
+	err = vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff,
+			     vma->vm_file, &vm_private_data);
+	if (err) {
+		if (map->hold_file_rmap_lock)
+			i_mmap_unlock_write(vma->vm_file->f_mapping);
 
-		i_mmap_unlock_write(file->f_mapping);
+		unmap_vma_locked(vma);
+		return err;
 	}
-	return ret;
+	/* Update private data if changed. */
+	if (vm_private_data != vma->vm_private_data)
+		vma->vm_private_data = vm_private_data;
+	return 0;
 }
 
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
@@ -2799,8 +2806,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	__mmap_complete(&map, vma);
 
 	if (have_mmap_prepare && allocated_new) {
-		error = call_action_complete(&map, &desc.action, vma);
-
+		error = mmap_action_complete(vma, &desc.action,
+					     map.hold_file_rmap_lock);
+		if (!error)
+			error = call_mapped_hook(&map, vma);
 		if (error)
 			return error;
 	}
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 8ae525ed1738..aa34966cbc62 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -643,6 +643,23 @@ struct vm_operations_struct {
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.
 	 */
 	void (*close)(struct vm_area_struct *vma);
+	/**
+	 * @mapped: Called when the VMA is first mapped in the MM. Not called if
+	 * the new VMA is merged with an adjacent VMA.
+	 *
+	 * The @vm_private_data field is an output field allowing the user to
+	 * modify vma->vm_private_data as necessary.
+	 *
+	 * ONLY valid if set from f_op->mmap_prepare. Will result in an error if
+	 * set from f_op->mmap.
+	 *
+	 * Returns %0 on success, or an error otherwise. On error, the VMA will
+	 * be unmapped.
+	 *
+	 * Context: User context.  May sleep.  Caller holds mmap_lock.
+	 */
+	int (*mapped)(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data);
 	/* Called any time before splitting to check if it's allowed */
 	int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
 	int (*mremap)(struct vm_area_struct *vma);
@@ -1281,7 +1298,7 @@ static inline int __compat_vma_mmap(const struct file_operations *f_op,
 		return err;
 
 	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action);
+	return mmap_action_complete(vma, &desc.action, /*rmap_lock_held=*/false);
 }
 
 static inline int compat_vma_mmap(struct file *file,
@@ -1500,3 +1517,11 @@ static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
 
 	return vm_get_page_prot(vm_flags);
 }
+
+static inline void unmap_vma_locked(struct vm_area_struct *vma)
+{
+	const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+	mmap_assert_write_locked(vma->vm_mm);
+	do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
+}
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index a30b8bc84955..d1c3d4ddb5e9 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -87,7 +87,8 @@ static inline int mmap_action_prepare(struct vm_area_desc *desc)
 }
 
 static inline int mmap_action_complete(struct vm_area_struct *vma,
-				       struct mmap_action *action)
+				       struct mmap_action *action,
+				       bool rmap_lock_held)
 {
 	return 0;
 }
-- 
2.53.0


