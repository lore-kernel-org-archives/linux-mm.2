Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B460DC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6176B00A0; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960D36B00A3; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A486B00A2; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE276B00A0
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEBE6801CB
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:20 +0000 (UTC)
X-FDA: 85025115000.09.6029D46
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf28.hostedemail.com (Postfix) with ESMTP id E8CCBC0006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=lkmV8VVh;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tct12KgmC1tTE0HVtqWbI1n/3fyI3GSxYNmtgTnfJDk=;
	b=EGrA2QcKJpRwh9WYXT9qftkaBYIk+1bpao4WDHAU8pujqmcWxA/JCZS+kxy/mQyCBmt7s/
	5pAsjcAlAUpVWt5zg7P/viFJuCPcttJjUNvmMVjuoVm4FnH949wA+NSC0G/3ENKPeY2pCh
	qKPcEaUzctpOj+N80rsi6ocge6c2h/s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=lkmV8VVh;
	spf=pass (imf28.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932219;
	b=NTcMn2dP48vNcAFZnUEEwjvOFwZEepQNJ4vhF62Y3gmAjWaESJzsz0gbWiQdPm7uMQxHu2
	SKZIBn1AvdO/u+NQIQsyL0E2B5WqreJEVuIqLvrkvOzYjtlwY3fCkcVvxtBCxvpZWWZOWu
	6/IlwXw9AKuguQnIVdpN4JLdVm7QjRw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Tct12KgmC1tTE0HVtqWbI1n/3fyI3GSxYNmtgTnfJDk=; b=lkmV8VVhvXXhz16hhgrH1uM+hK
	m9gans4bdPiCtqRwGtEHzzakQj33b1jxIc1sgMTOh6GxwBEbcQvteFKDJnDO3kSjLmM2Y4ph29dJc
	CkkwlJ6R7CW/PI10sREsZTlcJAU9XtRnzIG2zjJokgGLxQ6Gz++cvE2ddG/KoMdAUaO7g6Fg61Wis
	lD3I0sz+fbwO2qEdzKrt6GB6xow76++/KDaeeqvu74hR1/Ews4GPvMtHp0tneWwB9qCmDn3x25S5K
	GwyWHaNLgwrmCSWvo2afptja5wHYgnuZvYbATAHo9xEnXiebgXMgpSDekFbsHVIzdrcCTC/LiMqAq
	aFVsrEPg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-1X40;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH RFC v4 06/12] mm: use per-VMA lock in __access_remote_vm() for single-VMA accesses
Date: Fri, 24 Jul 2026 18:29:28 -0400
Message-ID: <20260724222934.1463812-7-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8CCBC0006
X-Stat-Signature: a4ctftmr5fmb1ydpizbw4uqmakinek76
X-HE-Tag: 1784932218-517990
X-HE-Meta: U2FsdGVkX19jtWIRvSxjXTlbC+Kz69tTJXIgQBA1fRPhemKoZMQAfOzLkfZ8GTbdv7+NX+yWeHsa7DdQxW1yt74skWFRN+WE1vfTulr9VwE+D+bhB1/uPe+TDO9Z1ocTQ149iHzFYaVrf2iyH+WK1SdLQK+K5eQRl3R2SJe3xsrtNYOD6Xz4VNKET93wnrBkkZBJaT4bN4dbx8gbOos4uAApTShpXIcuhmTevSx8Bm1jYZs+DhETrjne2d0UGBElywWe86dw7YHfS0rGwZRVoiosR/HoLGuqBzFgBjnZSmGiXeb9rEZZNtAsKTcbepZiNyvddOZbvbp6l85ImsYRCg2tpwV5dkXU3LWO5ZQl+JS05vMJO78x/sfJz51afDUCu8n/jROPHgBe27o0c1nZB9iBFCqizyxc3JcLJv+wFjjq7ltHZSey9kMw01jNVfD1YPp7d0Kd6nYhV2vptE+eNIXFBZY++IhIN/F3MFnky3pygFHCrUttpGAh0nGHUSBsaAGON5zJKsPPYnLa/1O09/zTjhnVIevGpILTaGBkqjblU8niY3RSsqgGy/zuCjoAdzFpFM8w9X9X6XbSi4VnSl+MgT+fW8bAXXWETQf7tBejjTfwHRkRjwf6BsbRGTxvl59AgG4J93MJ+TMvFJVEn/b127ZoKneKW160BMpV23JqpTwKg8kNg4mYAgn4uWhk1yRIDeml15ziqDp4A33TUhVg7+B0S82p4zVU/RJkctBL8k1dL3YmNgwlGf58WFifQG5iP6SintPMFQL9Nor9Fmjpgei/oHVUyCqMPycMIoFRljSNQObrp7FvREpVPJBQwHQnofjRXwW5rkuH52Eq3N3qGtmGEkU4mscmaZBr7kOhIsN2KmV+XxHv72rSj/hK+1xORav2d4NmBdffVXhBqYrBeAUt8e7jo9yvIfRlWmxQzT8FCJKO4KDbRyG/N8PnfV6bVzzm5xu5CJxnoPM
 t7Res2ga
 f4rj3YRx72c+DkHmNfMw5/WGcR+Ka18v+LSoREuQu8onaLRgWtKN2320G4sAUq/9j6A/+OG7HxlF084DMdjwUvjTe3yiX/RF63vaqohT10jr3f3GcmEQp/bIM0X2Seawi3DRFtTaUyTzPrsi5KfFQpNDcYvGMkGZwfybCWfFBuQXTxvvzizmZpc3yoh+vsVvQgVknFmGLePJayygF23AcpAESVPi8LYkWMQ/p8DK8sDc7fGiYYrtYzw8n4j3L4dz6OLdZ18d1bqmOwXfJcfDiCJC2YCve0WTm3wX4QUfarek1o9cMmo3CYDshgfN/Pjj9yzfiT4PJPqkDLPZWXpySrlz2Yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() holds mmap_read_lock() for the whole transfer. On
large machines running big multi-threaded applications, that lock is
contended between readers and writers: an mmap() or munmap() stalls readers
like /proc/PID/cmdline, /proc/PID/environ, or /proc/PID/mem, even though the
memory they read is almost always resident.

Use the per-VMA lock to access a remote process's memory when the access
fits in one VMA. Fall back to the mmap_lock if the access crosses VMA
boundaries, or when get_user_page_vma() cannot finish the access under the
per-VMA lock.

Factor the walk into remote_vm_walk(): it selects the lock, faults in each
page with get_user_page_vma(), and hands the page to a per-page action.
__access_remote_vm() passes access_vm_page(), which copies it; a later
patch shares the walk for the remote string reader.

remote_access_lock() and remote_access_unlock() keep the lock selection out
of the walk. remote_access_lock() takes the per-VMA lock when the range
fits one VMA whose flags permit the access, and the mmap lock otherwise,
returning an ERR_PTR() when the mmap lock cannot be taken.

Looking up the VMA first untags the remote address with
untagged_addr_remote_unlocked(), added earlier in this series, so the untag
needs no mmap lock.

Walking the page tables under only the per-VMA lock is safe against both
page table freeing and THP collapse.

munmap() frees a VMA's page tables through free_pgtables(), which uses
neither the page table lock nor RCU. But it runs only after the VMA is
detached under the VMA write lock, which our per-VMA read lock excludes, so
no page table of this VMA is torn down under the walk.

THP collapse instead needs neither lock: file-backed collapse retracts a
page table under i_mmap_lock and the page table lock alone. It frees the
retracted PTE page by RCU, and pte_offset_map() holds the RCU read lock, so
the page stays valid for the walk.

follow_page_pte() takes that same page table lock through
pte_offset_map_lock() and rechecks the pmd, so it either walks an intact
table or sees the collapsed pmd and faults the THP in.

get_user_page_vma() returns -EFAULT for memory with no struct page: the raw
PFNs of a VM_IO/VM_PFNMAP VMA, ioremapped device memory reached through
ptrace and /proc/PID/mem.

access_vm_page() reaches that memory under the mmap lock through
vma->vm_ops->access(), via a new access_remote_vma_ops() helper, as
get_user_pages_remote() and the old ->access() fallback did before.

A COWed page in such a VMA now reads normally through get_user_page_vma();
previously it was routed to ->access(), whose generic_access_phys() rejects
the ioremap of a RAM page.

A single-threaded microbenchmark reading a remote process's memory through
/proc/PID/mem shows the per-VMA path costs less than the old
mmap_read_lock() plus get_user_pages_remote() route. The gain grows with
the read size as the per-page VMA re-lookup drops away. Median of three
pinned repetitions in a VM:

	read size   baseline    per-VMA     throughput
	8 B          201.7 ns    170.6 ns    ~15% faster
	4 KB         495 ns      442 ns      +12% (8266 -> 9265 MB/s)
	64 KB       4115 ns     3355 ns      +23% (15927 -> 19536 MB/s)
	1 MB       75902 ns    63641 ns      +19% (13815 -> 16477 MB/s)

This does not measure the multi-threaded reader-versus-writer contention
that motivates the per-VMA lock; that case remains to be quantified.

Assisted-by: Claude:claude-opus-4.8
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/memory.c | 268 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 213 insertions(+), 55 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3b86eeaf084f..273dfe12bc6d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7015,86 +7015,244 @@ EXPORT_SYMBOL_GPL(generic_access_phys);
 #endif
 
 /*
- * Access another process' address space as given in mm.
+ * VM_IO / VM_PFNMAP memory, such as an ioremapped device mapping, maps
+ * PFNs that have no struct page, so get_user_page_vma() cannot fetch it
+ * even though the page tables are populated. It can still be reached
+ * through vma->vm_ops->access().
+ *
+ * Returns the number of bytes transferred, or <= 0 if @vma cannot be
+ * accessed this way.
  */
-static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
-			      void *buf, int len, unsigned int gup_flags)
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
+/*
+ * Lock @mm to reach the remote range [@addr, @addr + @len).
+ *
+ * Take the per-VMA lock when the whole range fits in a single VMA whose
+ * flags permit the access. The RCU freed page tables then keep page table
+ * memory from being reused with unexpected contents while the lock is held.
+ * Otherwise fall back to the mmap lock, which also covers multi-VMA ranges,
+ * stack expansion, and ->access() memory.
+ *
+ * Return whether the mmap lock is held. The per-VMA locked VMA, when one is
+ * taken, is stored in *@vmap; it is NULL on the mmap lock path. *@vmap is
+ * set to an ERR_PTR() when the mmap lock could not be taken, so callers must
+ * check IS_ERR(*@vmap) before using either result.
+ */
+static bool remote_access_lock(struct mm_struct *mm, unsigned long addr,
+			       int len, unsigned int gup_flags,
+			       struct vm_area_struct **vmap)
+{
+	struct vm_area_struct *vma = NULL;
+
+#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_MMU_GATHER_RCU_TABLE_FREE)
+	vma = lock_vma_under_rcu(mm, addr);
+	if (vma) {
+		/* addr + len must not wrap, and must fit within the one VMA. */
+		if (addr + len < addr || addr + len > vma->vm_end ||
+		    check_vma_flags(vma, gup_flags, 0)) {
+			vma_end_read(vma);
+			vma = NULL;
+		}
+	}
+#endif
+
+	if (!vma) {
+		if (mmap_read_lock_killable(mm)) {
+			*vmap = ERR_PTR(-EINTR);
+			return false;
+		}
+		*vmap = NULL;
+		return true;
+	}
+
+	*vmap = vma;
+	return false;
+}
+
+/* Release the lock taken by remote_access_lock(). */
+static void remote_access_unlock(struct mm_struct *mm,
+				 struct vm_area_struct *vma, bool have_mmap_lock)
+{
+	if (have_mmap_lock)
+		mmap_read_unlock(mm);
+	else if (vma)
+		vma_end_read(vma);
+}
+
+/*
+ * Per-page action for a remote VM walk. Handle up to @len bytes at @addr on
+ * @page, advancing *@buf past the bytes read from or written to it. @page is
+ * NULL for struct-page-less memory (VM_IO / VM_PFNMAP) reached under the mmap
+ * lock.
+ *
+ * Return the number of source bytes handled at @addr, 0 to end the walk (a
+ * string reached its NUL, or ->access() memory could not be reached), or a
+ * negative errno to abort.
+ */
+typedef int (*remote_vm_action)(struct vm_area_struct *vma, struct page *page,
+				unsigned long addr, void **buf, int len,
+				int write);
+
+/*
+ * Walk the remote range [@addr, @addr + @len) of @mm, handing each page to
+ * @action. Use the per-VMA lock when the range fits one VMA, and fall back to
+ * the mmap lock for multi-VMA ranges, stack expansion (when @can_expand_stack
+ * is set), or when the per-VMA lock cannot finish a fault.
+ *
+ * Each page is faulted in with get_user_page_vma() under whichever lock is
+ * held. Return the number of bytes @action consumed; *@err is a negative
+ * errno when the walk aborted, else 0.
+ */
+static int remote_vm_walk(struct mm_struct *mm, unsigned long addr, void *buf,
+			  int len, unsigned int gup_flags, bool can_expand_stack,
+			  remote_vm_action action, int *err)
 {
 	void *old_buf = buf;
 	int write = gup_flags & FOLL_WRITE;
+	bool have_mmap_lock;
+	struct vm_area_struct *vma;
 
-	if (mmap_read_lock_killable(mm))
-		return 0;
+	*err = 0;
 
-	/* Untag the address before looking up the VMA */
-	addr = untagged_addr_remote(mm, addr);
+	/*
+	 * Set FOLL_REMOTE so check_vma_flags() applies the same protection key
+	 * rules as get_user_pages_remote() did: the current PKRU is not checked
+	 * against a VMA reached on @mm's behalf.
+	 */
+	gup_flags |= FOLL_REMOTE;
 
-	/* Avoid triggering the temporary warning in __get_user_pages */
-	if (!vma_lookup(mm, addr) && !expand_stack(mm, addr))
+	addr = untagged_addr_remote_unlocked(mm, addr);
+
+	have_mmap_lock = remote_access_lock(mm, addr, len, gup_flags, &vma);
+	if (IS_ERR(vma)) {
+		*err = -EFAULT;
 		return 0;
+	}
 
-	/* ignore errors, just check how much was successfully transferred */
 	while (len) {
-		int bytes, offset;
-		void *maddr;
-		struct folio *folio;
-		struct vm_area_struct *vma = NULL;
-		struct page *page = get_user_page_lookup_vma(mm, addr,
-							     gup_flags, &vma);
+		unsigned int foll_flags = gup_flags;
+		struct page *page;
+		int ret;
 
-		if (IS_ERR(page)) {
-			/* We might need to expand the stack to access it */
+		if (!vma || addr >= vma->vm_end) {
+			/* Any lookup here holds the mmap lock. */
+			VM_BUG_ON(!have_mmap_lock);
 			vma = vma_lookup(mm, addr);
-			if (!vma) {
+			if (!vma && can_expand_stack) {
+				/* expand_stack() drops the mmap lock if it fails */
 				vma = expand_stack(mm, addr);
-
-				/* mmap_lock was dropped on failure */
 				if (!vma)
-					return buf - old_buf;
-
-				/* Try again if stack expansion worked */
-				continue;
+					have_mmap_lock = false;
 			}
+			if (!vma) {
+				*err = -EFAULT;
+				break;
+			}
+		}
 
+		/*
+		 * FOLL_UNLOCKABLE lets the per-VMA fault retry, dropping the
+		 * lock, so the walk can fall back to the mmap lock.
+		 */
+		if (!have_mmap_lock)
+			foll_flags |= FOLL_VMA_LOCK | FOLL_UNLOCKABLE;
+
+		page = get_user_page_vma(vma, addr, foll_flags);
+		if (IS_ERR(page)) {
 			/*
-			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
-			 * we can access using slightly different code.
+			 * get_user_page_vma() returns -EAGAIN, with the per-VMA
+			 * lock released, for anything it could not finish under
+			 * it; retake the mmap lock and retry. A different error
+			 * therefore only arrives under the mmap lock, where
+			 * struct-page-less memory can be reached via ->access().
 			 */
-			bytes = 0;
-#ifdef CONFIG_HAVE_IOREMAP_PROT
-			if (vma->vm_ops && vma->vm_ops->access)
-				bytes = vma->vm_ops->access(vma, addr, buf,
-							    len, write);
-#endif
-			if (bytes <= 0)
-				break;
-		} else {
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
+			if (PTR_ERR(page) == -EAGAIN) {
+				vma = NULL;
+				if (mmap_read_lock_killable(mm)) {
+					*err = -EFAULT;
+					break;
+				}
+				have_mmap_lock = true;
+				continue;
 			}
-			folio_release_kmap(folio, maddr);
+			if (WARN_ON_ONCE(!have_mmap_lock))
+				break;
+			page = NULL;
 		}
-		len -= bytes;
-		buf += bytes;
-		addr += bytes;
+
+		ret = action(vma, page, addr, &buf, len, write);
+		if (ret <= 0) {
+			if (ret < 0)
+				*err = ret;
+			break;
+		}
+		addr += ret;
+		len -= ret;
 	}
-	mmap_read_unlock(mm);
+
+	remote_access_unlock(mm, vma, have_mmap_lock);
 
 	return buf - old_buf;
 }
 
+/*
+ * Copy one page's worth of [@addr, @addr + @len) to or from *@buf. Reaches
+ * struct-page-less VM_IO / VM_PFNMAP memory through vma->vm_ops->access().
+ */
+static int access_vm_page(struct vm_area_struct *vma, struct page *page,
+			  unsigned long addr, void **buf, int len, int write)
+{
+	struct folio *folio;
+	int bytes, offset;
+	void *maddr;
+
+	if (!page) {
+		bytes = access_remote_vma_ops(vma, addr, *buf, len, write);
+		if (bytes > 0)
+			*buf += bytes;
+		return bytes;
+	}
+
+	bytes = len;
+	offset = addr & (PAGE_SIZE - 1);
+	if (bytes > PAGE_SIZE - offset)
+		bytes = PAGE_SIZE - offset;
+
+	folio = page_folio(page);
+	maddr = kmap_local_folio(folio, folio_page_idx(folio, page) * PAGE_SIZE);
+	if (write) {
+		copy_to_user_page(vma, page, addr, maddr + offset, *buf, bytes);
+		folio_mark_dirty_lock(folio);
+	} else {
+		copy_from_user_page(vma, page, addr, *buf, maddr + offset, bytes);
+	}
+	folio_release_kmap(folio, maddr);
+
+	*buf += bytes;
+	return bytes;
+}
+
+/*
+ * Access another process' address space as given in mm.
+ */
+static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
+			      void *buf, int len, unsigned int gup_flags)
+{
+	int err;
+
+	return remote_vm_walk(mm, addr, buf, len, gup_flags, true,
+			      access_vm_page, &err);
+}
+
 /**
  * access_remote_vm - access another process' address space
  * @mm:		the mm_struct of the target address space
-- 
2.53.0-Meta


