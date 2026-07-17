Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE818C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529246B00B3; Fri, 17 Jul 2026 13:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2B76B00B6; Fri, 17 Jul 2026 13:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1E66B00B9; Fri, 17 Jul 2026 13:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0745C6B00B3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:01:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80D83A01F2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:14 +0000 (UTC)
X-FDA: 84998884068.27.064E37C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf27.hostedemail.com (Postfix) with ESMTP id C32FA40006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=hAb8GG6E;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784307672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GQ/a45iHJe+eGlcDu+MtolxLl+gQEuczftUqOKtsqg=;
	b=iIpYa+iEgBY4QHSEz2/A37GBRrDj8s9iEmuoHcYVXqOxo47PvJ4lBzv21hpSa8HS096o57
	oCTrE//weKpNf1NGnXsM3GHNtVxvhwjhsE2ANLmev/r7QRi3SlkELSr61/xpweySUFKdH5
	2Up1CKEFU/SUAV0Bmir51733dds/AM4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=hAb8GG6E;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784307672;
	b=pFJS2kMH7+hkGKjbxHO7hI3EYGYQyhD51QhCfYMlxqufuHLnPVYI1/BYgVXRsynzojylUX
	iRRaNV6fF3lnMUNK77/u5DiIMYgrTsuMY6ZkA/coPo4D0B3aS0YbC8wlbrE1FidKIfclrm
	SpyUxBf2mFa4cQqMVVgFesPZ9HYSK7w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4GQ/a45iHJe+eGlcDu+MtolxLl+gQEuczftUqOKtsqg=; b=hAb8GG6EUPuf1XWmTm9cAkqQu9
	X5CadICnb4A3VTOe2X06cw3bWQnTHQwW+g+5aPr1HG0H+bxMWICo3rU4nqgsd0JpB58wwHjwadM8/
	EKeLjqeXmqPgst/ZHjYnFFR9ea5lqk/o+5DqleoEFgvQI7vFGq2j6vIVl/Z6yGtQ9tfAVUsHM+WoV
	9n3xG8FnmW8OVw+C0dYp8e17TGsqdiXHvXuJcVyBdExlL8/TXkWF6C+2L0NWP49XKvqVZm8QknprV
	ufCP5QsJCN4/DEYPQ2HG4newdY5oLWRjb3Bizi9EwPLIMOQk7+PUF52hxk1lucwvpRrfI9QVCKSWl
	5xpd1sdA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wklvS-000000001w4-0ddJ;
	Fri, 17 Jul 2026 13:00:38 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH RFC v3 5/6] mm: use per-VMA lock in __access_remote_vm() for single-VMA accesses
Date: Fri, 17 Jul 2026 13:00:35 -0400
Message-ID: <20260717170036.743149-6-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260717170036.743149-1-riel@surriel.com>
References: <20260717170036.743149-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C32FA40006
X-Stat-Signature: a5ehgyt3yud1qwy87c44i3sdtzc8i11p
X-HE-Tag: 1784307672-564209
X-HE-Meta: U2FsdGVkX18VTrwHkHbgHRMtt1r+8UMmHwfJrvHAoFUj2HQ2lZUavigZ9z5n9evqKqzZxKdx9ZL1Dowk/Sf56/6QLIIpuWLwC0KsQB4Yof/SvuQRiZOIZNRHqPkHoeVXgjhRDNPSJByvD/q2Ru4NtxrY3jrwShtAFI+n9aAHfzUBDBkeDlnf1ikk5YcwjU0RjdDaVtNB9V0+RM8S2nHrtex+9btQnSaI4n7uHSaBDU1D4sCNGS1sM2kZGUPfKgAQC3kjkMMFJJeTM9zD+x87cR6hwPOgKPhMDrd5B3OHsFsA4xMBEZ8lo255ZMvMnbTiFlzNAhnFw4/O5jQMD3CzlcIgRcvj4d7au3gwFyQnWwXh9+/rqawBDGAA/OMeMlL9IE2iyeMulL/rbQtdUm+zCv6OmqvM61x6V/MZ8+87VHej6hosxZNcGB/Dq2twP7O4qavTmQ1LusVDbNa3qh5Rv00+fyweSkCUHOmh/CjZx8Mceb7Iba3AyIgs4R3ArnW2FvlPDVZF+0mn22P2EVPheYKd1PmpaiQVb7cGKFgC/9q6XCGW8g1vKWHiwrLrcB9qJHbhWPaf4bZhUyhJ1yJs+eEexBt7Fb1eqAkG456vkKg8Ov9K8qW3ecZL1AMoFFRz1tR03vfhWGJBnA6Op04YrtelhgQ4WFPh/Y4io/0/zNzZqFhPwDdNJocTpxwdJ5MS1Wqvgcyqyg4fQXNh+h67MbwLIFBiBk2yRYB+yvOX7g28GDg0ZTx5XCb1TYP1OvIUCZjotXdtt50MDhWUG1Nuy5yA+8g5qQlRQnGAwirksYeIppAfLy5iMIZ6r833L9lqwAMVgdcBtQ1LUrow7z6T35p/ry3yCua0H/RiBRAuU0LvevDTMpiGX36aOGfwUsVWLmNwrr3wSSmnV5pzEu+9nqAV9554BSfDcNDzBv55KzXrIclGug3OsbMc6Xrl3sQNSC+kJXmCvG/YpEB+0j5
 hwhwJ2F+
 DwYRzv7QcerjzVIk5bg7hverKyYwQHNbPF92uF958/Z61tmu99/WeOUEWzOAi6WIyJ2SkE0Mvlgc3DH5mIOP6XtHMcXhlGHEJReQeen2IQqTXJE6ljl6G7vEw2g8u6LlMULZYrASpMs9jKHbHaN3Ab0G0GUFNBE7VetLF9ZjP/hO9es4ZiCCxLmx3fHBMKvDC/QolBTRwvnTbLgHoGz+8TOMrLjvWkQQgXZlH2xy0ULz1ZILAN7NuwapcYh528gkQ4BBMTFzOh4wiySuw86PcJ7L3wbvZihuZmqeVTiEi3m+htqkPyBzvJGuzIcYvWUdJrSWT5Lt+yo6zoqe1r3CzA5aoPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() holds mmap_read_lock() for the whole transfer. On
large machines that lock is contended by tasks reading /proc/PID/cmdline,
/proc/PID/environ, or /proc/PID/mem, even though the memory they read is
almost always resident.

Use the per-VMA lock to access a remote process's memory, provided that
access is entirely within one VMA. Fall back to the mmap_lock if the access
crosses VMA boundaries, or when get_user_page_vma() cannot finish the
access under the per-VMA lock.

Walking the page tables under only the per-VMA lock is safe when page table
pages are freed via RCU.

pte_offset_map() takes the RCU read lock, so a PTE page freed by a
concurrent THP collapse stays valid for the walk; mid-collapse it returns
NULL and the page is faulted in.

Higher level page tables cannot be freed under us, since munmap() and
collapse take the VMA write lock that our read lock excludes.

get_user_page_vma() returns -EFAULT for memory with no struct page: the raw
PFNs of a VM_IO/VM_PFNMAP VMA, ioremapped device memory reached through
ptrace and /proc/PID/mem.

Handle that in the IS_ERR(page) branch by reaching it through
vma->vm_ops->access(), under the mmap lock, via a new
access_remote_vma_ops() helper -- as get_user_pages_remote() and the old
->access() fallback did before.

A COWed page in such a VMA has a struct page and is now returned normally
by get_user_page_vma(). Previously it was routed to ->access() and could
not be read, since generic_access_phys() ioremaps the PFN and ioremap of
RAM is rejected.

Assisted-by: Claude:claude-opus-4.8
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c      |   2 +-
 mm/internal.h |   1 +
 mm/memory.c   | 169 ++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 126 insertions(+), 46 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 69b834a71708..8ffcc1bbb545 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1311,7 +1311,7 @@ static bool writable_file_mapping_allowed(struct vm_area_struct *vma,
 	return !vma_needs_dirty_tracking(vma);
 }
 
-static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
+int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
 	int write = (gup_flags & FOLL_WRITE);
diff --git a/mm/internal.h b/mm/internal.h
index 0899a37907c1..3c750f2f0332 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1595,6 +1595,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
  */
 int __must_check try_grab_folio(struct folio *folio, int refs,
 				unsigned int flags);
+int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags);
 struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
 			       unsigned int gup_flags);
 
diff --git a/mm/memory.c b/mm/memory.c
index 3b86eeaf084f..b166b18844e9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7014,83 +7014,162 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 EXPORT_SYMBOL_GPL(generic_access_phys);
 #endif
 
+/*
+ * VM_IO / VM_PFNMAP memory, such as an ioremapped device mapping, maps
+ * PFNs that have no struct page, so get_user_page_vma() cannot fetch it
+ * even though the page tables are populated. It can still be reached
+ * through vma->vm_ops->access().
+ *
+ * Returns the number of bytes transferred, or <= 0 if @vma cannot be
+ * accessed this way.
+ */
+static int access_remote_vma_ops(struct vm_area_struct *vma, unsigned long addr,
+				 void *buf, int len, int write)
+{
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+	if (vma->vm_ops && vma->vm_ops->access)
+		return vma->vm_ops->access(vma, addr, buf, len, write);
+#endif
+	return 0;
+}
+
 /*
  * Access another process' address space as given in mm.
+ *
+ * Use the per-VMA lock when the access fits in a single VMA, and fall back
+ * to the mmap lock for multi-VMA accesses, stack expansion, or when the
+ * VMA lock cannot be taken.
+ *
+ * Both paths fetch each page with get_user_page_vma(), which faults it in
+ * under whichever lock is held. The per-VMA path hands an access it cannot
+ * complete (a fault that dropped the lock, or a userfaultfd VMA) back to
+ * the mmap lock path.
  */
 static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 			      void *buf, int len, unsigned int gup_flags)
 {
 	void *old_buf = buf;
 	int write = gup_flags & FOLL_WRITE;
+	bool have_mmap_lock = false;
+	struct vm_area_struct *vma = NULL;
 
-	if (mmap_read_lock_killable(mm))
-		return 0;
+	/*
+	 * Set FOLL_REMOTE so check_vma_flags() applies the same protection key
+	 * rules as get_user_pages_remote() did: the current PKRU is not checked
+	 * against a VMA reached on @mm's behalf.
+	 */
+	gup_flags |= FOLL_REMOTE;
 
-	/* Untag the address before looking up the VMA */
-	addr = untagged_addr_remote(mm, addr);
+	addr = untagged_addr_remote_unlocked(mm, addr);
 
-	/* Avoid triggering the temporary warning in __get_user_pages */
-	if (!vma_lookup(mm, addr) && !expand_stack(mm, addr))
-		return 0;
+	/*
+	 * The RCU freed page tables prevent page table memory from being
+	 * re-used and filled with unexpected contents. Ensure the access
+	 * is entirely within a single VMA.
+	 */
+#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_MMU_GATHER_RCU_TABLE_FREE)
+	vma = lock_vma_under_rcu(mm, addr);
+	if (vma) {
+		if (addr + len > vma->vm_end || check_vma_flags(vma, gup_flags)) {
+			vma_end_read(vma);
+			vma = NULL;
+		}
+	}
+#endif
+
+	if (!vma) {
+		if (mmap_read_lock_killable(mm))
+			return 0;
+		have_mmap_lock = true;
+	}
 
-	/* ignore errors, just check how much was successfully transferred */
 	while (len) {
+		unsigned int foll_flags = gup_flags;
+		struct page *page;
+		struct folio *folio;
 		int bytes, offset;
 		void *maddr;
-		struct folio *folio;
-		struct vm_area_struct *vma = NULL;
-		struct page *page = get_user_page_lookup_vma(mm, addr,
-							     gup_flags, &vma);
+		unsigned long idx;
 
-		if (IS_ERR(page)) {
-			/* We might need to expand the stack to access it */
+		if (!vma || addr >= vma->vm_end) {
+			/*
+			 * The per-VMA path never re-looks-up (its access fits
+			 * one VMA), so any lookup here holds the mmap lock.
+			 */
+			VM_BUG_ON(!have_mmap_lock);
 			vma = vma_lookup(mm, addr);
 			if (!vma) {
+				/* expand_stack() drops the mmap lock if it fails */
 				vma = expand_stack(mm, addr);
+				if (!vma) {
+					have_mmap_lock = false;
+					break;
+				}
+			}
+		}
 
-				/* mmap_lock was dropped on failure */
-				if (!vma)
-					return buf - old_buf;
-
-				/* Try again if stack expansion worked */
+		/*
+		 * FOLL_UNLOCKABLE lets the per-VMA fault retry, dropping the
+		 * lock, so the access can fall back to the mmap lock.
+		 */
+		if (!have_mmap_lock)
+			foll_flags |= FOLL_VMA_LOCK | FOLL_UNLOCKABLE;
+		page = get_user_page_vma(vma, addr, foll_flags);
+		if (IS_ERR(page)) {
+			/*
+			 * get_user_page_vma() returns -EAGAIN, with the per-VMA
+			 * lock released, for anything it could not finish under
+			 * it; retake the mmap lock and retry. A different error
+			 * therefore only arrives under the mmap lock, where
+			 * ->access() can run.
+			 */
+			if (PTR_ERR(page) == -EAGAIN) {
+				vma = NULL;
+				if (mmap_read_lock_killable(mm))
+					break;
+				have_mmap_lock = true;
 				continue;
 			}
-
+			if (WARN_ON_ONCE(!have_mmap_lock))
+				break;
 			/*
-			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
-			 * we can access using slightly different code.
+			 * Memory with no struct page: VM_IO / VM_PFNMAP reached
+			 * through vma->vm_ops->access(); anything else stops.
 			 */
-			bytes = 0;
-#ifdef CONFIG_HAVE_IOREMAP_PROT
-			if (vma->vm_ops && vma->vm_ops->access)
-				bytes = vma->vm_ops->access(vma, addr, buf,
-							    len, write);
-#endif
+			bytes = access_remote_vma_ops(vma, addr, buf, len, write);
 			if (bytes <= 0)
 				break;
+			goto advance;
+		}
+
+		folio = page_folio(page);
+		bytes = len;
+		offset = addr & (PAGE_SIZE - 1);
+		if (bytes > PAGE_SIZE - offset)
+			bytes = PAGE_SIZE - offset;
+
+		idx = folio_page_idx(folio, page);
+		maddr = kmap_local_folio(folio, idx * PAGE_SIZE);
+		if (write) {
+			copy_to_user_page(vma, page, addr,
+					  maddr + offset, buf, bytes);
+			folio_mark_dirty_lock(folio);
 		} else {
-			folio = page_folio(page);
-			bytes = len;
-			offset = addr & (PAGE_SIZE-1);
-			if (bytes > PAGE_SIZE-offset)
-				bytes = PAGE_SIZE-offset;
-
-			maddr = kmap_local_folio(folio, folio_page_idx(folio, page) * PAGE_SIZE);
-			if (write) {
-				copy_to_user_page(vma, page, addr,
-						  maddr + offset, buf, bytes);
-				folio_mark_dirty_lock(folio);
-			} else {
-				copy_from_user_page(vma, page, addr,
-						    buf, maddr + offset, bytes);
-			}
-			folio_release_kmap(folio, maddr);
+			copy_from_user_page(vma, page, addr,
+					    buf, maddr + offset, bytes);
 		}
+		folio_release_kmap(folio, maddr);
+
+advance:
 		len -= bytes;
 		buf += bytes;
 		addr += bytes;
 	}
-	mmap_read_unlock(mm);
+
+	if (have_mmap_lock)
+		mmap_read_unlock(mm);
+	else if (vma)
+		vma_end_read(vma);
 
 	return buf - old_buf;
 }
-- 
2.53.0-Meta


