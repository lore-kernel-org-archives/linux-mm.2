Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C9B8106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61386B009D; Thu, 12 Mar 2026 16:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C116B009F; Thu, 12 Mar 2026 16:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24EB6B00A0; Thu, 12 Mar 2026 16:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 930DC6B009D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DB5D1A0301
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:01 +0000 (UTC)
X-FDA: 84538547562.22.2DED95A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 71A4740007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:27:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BsOJySgJ;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIaMaNgCfDyQJE+FIfchtv1QkfEeqWbwBM9VxcCwfaA=;
	b=Krsjfq06QGXa58irkhjtquiL6LZwmG7BwG71/4YGx+BV8uSRLHECDFWjRcSFRZ14x0aI6u
	ny49qtxCzV9Bb1c12LlYv9Y+RaKKp1kOrk1Q7BK5rzyC1ICWhM44Q2256TRvMNDwNchr/V
	7+V29CYoLgc6X942lc3eXQMjfAWvD20=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BsOJySgJ;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347279; a=rsa-sha256;
	cv=none;
	b=HS4PjG+mQ4Yc+qfqjFeJSgeD7EuLVkw0P8Qrs0JkC8TUzvU3aRkz2AcF/4iVer+EpjTsB5
	bMBco7ejouDUJw+sAqd7/E7t3ftuBTpACStrl4SMErCFsumQt5Or4lqgfOnXGhZC4B7Nc6
	+m40qvWK0z7rDXWNg5Z4Xad2OTkQ0Gg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 53EAE44534;
	Thu, 12 Mar 2026 20:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B4BC4CEF7;
	Thu, 12 Mar 2026 20:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347278;
	bh=vkoqq4BGmKZfZLnB4k2X4hpmh3QcGuv8hoao4ZOuMm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsOJySgJXKa9C+yQVRlEVk2cg2U7Hl2Pptu5a8uJZJJv68mBsXqaTdEfzZbN60tkC
	 CN7bRjHTEwz9mMGJeiBmpFrvyE00w/Cc2iq6msBJaMW5FdVkwwQXSyyHT9jP8GyhnB
	 AtdnwQefv72PzyOq+8DzX+8/BJC0DrxTB6rody+Z+A5Gtn5d4WvB+WBuHtMUJr1dhV
	 eLLRdwlQjW35nYLyL5kOKuNvBdbgzYyEGRGaSNWASgXUZANWBMRjRUtMY8bhfxBuK7
	 pstrnL7SQeBle1XfjwBBSKai62qEcYc8+w77CSXmm1DBQOtzKuaAAtg4MazQu/Nqbx
	 WCHNpGjkfg4rQ==
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
Subject: [PATCH 04/15] mm: add vm_ops->mapped hook
Date: Thu, 12 Mar 2026 20:27:19 +0000
Message-ID: <0e0fe47852e6009f662b1fa42f836447b8d1283a.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71A4740007
X-Stat-Signature: w3xc43ms9qr6b4xapdt4c3ghtbt4gf6q
X-Rspam-User: 
X-HE-Tag: 1773347279-985400
X-HE-Meta: U2FsdGVkX184gIafbeeKeW7wskX+k1kdPFTLfmvk1jnyvpGKk8vNiVecadKVIbmyV56uiPtd6OPC0HDJsmvqNtx72fWqt0E3nudwW5Th6Ce85QJep/MsgaNJb8TK3uI2nob4XEIOoI/nXkx3UGN/eKiDLjDOSWHt1s7poQ/Ma84f13L6aMkeVG+3BszsqpLiK0pXL3oooyPccIA5XjBnG6WqrRv3Oxd9F1uuJJUiQIvVHWnXgB7Sz9qpAGbn/kvN2Qq5iSJarzgGSUqxx95xp+H/msuRu7kjL3K3AbMFWNXAN0/oQe4XcOHdt4p/61MIVcgoNygf6PwjZn6pMMvesJET9r1Slyu0IcDWYHIbpYmNTffUQtKZQQ7f4fLzaTMFKSvmEi+4N99cVyy8SPrgFw9LbUIi5GVI+u8LKhhbaPDgrvHCa15uZKRlJxPt9CMq6m0c29zWEZwIYpweOEACGzkkEviX0RkfWK/HtCc+p0pUOUcRCdiXQiih1QKpcp0cER3OHBydmeyIx9g0lBWecDKI0znpD8+0L+oNmSZ0xCnK4gcw33dGmZllajOynFQHJt3zoC6r044UIRhtYq5JLKYCLWA2UHwzhxy3uqMetH4UrqhygXScQH8d35P4s+/wix/KWDCj8BeD7jSHqWWclJ7TyqsB4gaXI0Ssh+1r9VlDeDEPKHohNIL3PAucr6hSVe3e/CGfHyzNavzkt9igp4DOpolt+jyCXbGFH8PpcFFV5JPMBC1a8SH+YCFpxRfRJSyB8L5fZ0ZRQ8iR9yVCbFcYpcvEQrnM0OrPOim3oEX6FtkjtRicZyq7IFr/DLczl/7Or8ykbpgyw1Nn0DkzB/N/B5w3bMcwagUuXncWsMoyer6nAD0MdjDJAkI36tWKhrT+LNxHlpbBeq66PmpLeITQqTrJKf+ugPfxvOlbf3jfmwdTYM+1leuMEaMRdc70swTT7IgbUQTMileafOr
 Czl9DWV0
 txRKmW0nz34t0GFJJWMcb5L6fwzFpYkSg2q+d2kXz5g8syJm8s4HYAtWRquRKrx8CRCsd36fBvxucHd47NTvkVUXzjTMQcV772tXlBufSEP8Zr9zGMIOkicI+/eKRSA6fhX77ZOqNItIsW/pEvKZU3bb8hIii4YK4oIIBvBGze1NqibFtTtkXYQypauDiT2+bt++uRqv7StUaLpLXirY0zeSj80Npc4jGQGgPxLt4zUOmytGggxYrprEDoV8+JTS2yC65byIVOlbxqWrfzx2sWd6CqI4NUArscobtnSRLm+H2wUfWK/Un4rZKa+4KTvqv1+Npb+3afW4qCrQ27KvtIkf/9aAWk6ioecZd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, when a driver needed to do something like establish a reference
count, it could do so in the mmap hook in the knowledge that the mapping
would succeed.

With the introduction of f_op->mmap_prepare this is no longer the case, as
it is invoked prior to actually establishing the mapping.

To take this into account, introduce a new vm_ops->mapped callback which is
invoked when the VMA is first mapped (though notably - not when it is
merged - which is correct and mirrors existing mmap/open/close behaviour).

We do better that vm_ops->open() here, as this callback can return an
error, at which point the VMA will be unmapped.

Note that vm_ops->mapped() is invoked after any mmap action is
complete (such as I/O remapping).

We intentionally do not expose the VMA at this point, exposing only the
fields that could be used, and an output parameter in case the operation
needs to update the vma->vm_private_data field.

In order to deal with stacked filesystems which invoke inner filesystem's
mmap() invocations, add __compat_vma_mapped() and invoke it on
vfs_mmap() (via compat_vma_mmap()) to ensure that the mapped callback is
handled when an mmap() caller invokes a nested filesystem's mmap_prepare()
callback.

We can now also remove call_action_complete() and invoke
mmap_action_complete() directly, as we separate out the rmap lock logic to
be called in __mmap_region() instead via maybe_drop_file_rmap_lock().

We also abstract unmapping of a VMA on mmap action completion into its own
helper function, unmap_vma_locked().

Additionally, update VMA userland test headers to reflect the change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/fs.h              |  9 +++-
 include/linux/mm.h              | 17 +++++++
 mm/internal.h                   | 10 ++++
 mm/util.c                       | 86 ++++++++++++++++++++++++---------
 mm/vma.c                        | 41 +++++++++++-----
 tools/testing/vma/include/dup.h | 34 ++++++++++++-
 6 files changed, 158 insertions(+), 39 deletions(-)

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
index 12a0b4c63736..7333d5db1221 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -759,6 +759,23 @@ struct vm_operations_struct {
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
diff --git a/mm/internal.h b/mm/internal.h
index 7bfa85b5e78b..f0f2cf1caa36 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -158,6 +158,8 @@ static inline void *folio_raw_mapping(const struct folio *folio)
  * mmap hook and safely handle error conditions. On error, VMA hooks will be
  * mutated.
  *
+ * IMPORTANT: f_op->mmap() is deprecated, prefer f_op->mmap_prepare().
+ *
  * @file: File which backs the mapping.
  * @vma:  VMA which we are mapping.
  *
@@ -201,6 +203,14 @@ static inline void vma_close(struct vm_area_struct *vma)
 /* unmap_vmas is in mm/memory.c */
 void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
 
+static inline void unmap_vma_locked(struct vm_area_struct *vma)
+{
+	const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+	mmap_assert_locked(vma->vm_mm);
+	do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
+}
+
 #ifdef CONFIG_MMU
 
 static inline void get_anon_vma(struct anon_vma *anon_vma)
diff --git a/mm/util.c b/mm/util.c
index dba1191725b6..2b0ed54008d6 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1163,6 +1163,55 @@ void flush_dcache_folio(struct folio *folio)
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
+	err = mmap_action_prepare(&desc, &desc.action);
+	if (err)
+		return err;
+
+	set_vma_from_desc(vma, &desc);
+	return mmap_action_complete(vma, &desc.action);
+}
+
+static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
+{
+	const struct vm_operations_struct *vm_ops = vma->vm_ops;
+	void *vm_private_data = vma->vm_private_data;
+	int err;
+
+	if (!vm_ops->mapped)
+		return 0;
+
+	err = vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff, file,
+			     &vm_private_data);
+	if (err)
+		unmap_vma_locked(vma);
+	/* Update private data if changed. */
+	if (vm_private_data != vma->vm_private_data)
+		vma->vm_private_data = vm_private_data;
+
+	return err;
+}
+
 /**
  * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
  * existing VMA and execute any requested actions.
@@ -1191,34 +1240,26 @@ EXPORT_SYMBOL(flush_dcache_folio);
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
-	if (err)
-		return err;
-
-	err = mmap_action_prepare(&desc, &desc.action);
+	err = __compat_vma_mmap(file, vma);
 	if (err)
 		return err;
 
-	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action);
+	return __compat_vma_mapped(file, vma);
 }
 EXPORT_SYMBOL(compat_vma_mmap);
 
+int __vma_check_mmap_hook(struct vm_area_struct *vma)
+{
+	/* vm_ops->mapped is not valid if mmap() is specified. */
+	if (WARN_ON_ONCE(vma->vm_ops->mapped))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(__vma_check_mmap_hook);
+
 static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
 			 const struct page *page)
 {
@@ -1316,10 +1357,7 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 	 * invoked if we do NOT merge, so we only clean up the VMA we created.
 	 */
 	if (err) {
-		const size_t len = vma_pages(vma) << PAGE_SHIFT;
-
-		do_munmap(current->mm, vma->vm_start, len, NULL);
-
+		unmap_vma_locked(vma);
 		if (action->error_hook) {
 			/* We may want to filter the error. */
 			err = action->error_hook(err);
diff --git a/mm/vma.c b/mm/vma.c
index 054cf1d262fb..ef9f5a5365d1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2705,21 +2705,35 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 	return false;
 }
 
-static int call_action_complete(struct mmap_state *map,
-				struct mmap_action *action,
-				struct vm_area_struct *vma)
+static int call_mapped_hook(struct vm_area_struct *vma)
 {
-	int ret;
+	const struct vm_operations_struct *vm_ops = vma->vm_ops;
+	void *vm_private_data = vma->vm_private_data;
+	int err;
 
-	ret = mmap_action_complete(vma, action);
+	if (!vm_ops || !vm_ops->mapped)
+		return 0;
+	err = vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff,
+			     vma->vm_file, &vm_private_data);
+	if (err) {
+		unmap_vma_locked(vma);
+		return err;
+	}
+	/* Update private data if changed. */
+	if (vm_private_data != vma->vm_private_data)
+		vma->vm_private_data = vm_private_data;
+	return 0;
+}
 
-	/* If we held the file rmap we need to release it. */
-	if (map->hold_file_rmap_lock) {
-		struct file *file = vma->vm_file;
+static void maybe_drop_file_rmap_lock(struct mmap_state *map,
+				      struct vm_area_struct *vma)
+{
+	struct file *file;
 
-		i_mmap_unlock_write(file->f_mapping);
-	}
-	return ret;
+	if (!map->hold_file_rmap_lock)
+		return;
+	file = vma->vm_file;
+	i_mmap_unlock_write(file->f_mapping);
 }
 
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
@@ -2773,8 +2787,11 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	__mmap_complete(&map, vma);
 
 	if (have_mmap_prepare && allocated_new) {
-		error = call_action_complete(&map, &desc.action, vma);
+		error = mmap_action_complete(vma, &desc.action);
+		if (!error)
+			error = call_mapped_hook(vma);
 
+		maybe_drop_file_rmap_lock(&map, vma);
 		if (error)
 			return error;
 	}
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 908beb263307..47d8db809f31 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -606,12 +606,34 @@ struct vm_area_struct {
 } __randomize_layout;
 
 struct vm_operations_struct {
-	void (*open)(struct vm_area_struct * area);
+	/**
+	 * @open: Called when a VMA is remapped or split. Not called upon first
+	 * mapping a VMA.
+	 * Context: User context.  May sleep.  Caller holds mmap_lock.
+	 */
+	void (*open)(struct vm_area_struct *vma);
 	/**
 	 * @close: Called when the VMA is being removed from the MM.
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.
 	 */
-	void (*close)(struct vm_area_struct * area);
+	void (*close)(struct vm_area_struct *vma);
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
 	int (*may_split)(struct vm_area_struct *area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct *area);
@@ -1345,3 +1367,11 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
 	swap(vma->vm_file, file);
 	fput(file);
 }
+
+static inline void unmap_vma_locked(struct vm_area_struct *vma)
+{
+	const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+	mmap_assert_locked(vma->vm_mm);
+	do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
+}
-- 
2.53.0


