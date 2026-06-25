Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D7ECDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B143E6B0093; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9DC06B0096; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805E16B009B; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5B16B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C234C1C30EF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:21 +0000 (UTC)
X-FDA: 84916757562.22.E0AD2E6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id 26C2C20002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ahLac+V8;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782352280;
	b=ynAJw/GadFkbXU+ZOb6C6FzQ8G8GWzE9tCHcU49FLxeWtk84OxO7vYshRWwd5lJ9+AxmHU
	huWj6uT1fqlg2qEuAJI+9O4CljkK0934q2I6VDT5S2y68jNMlXnIb9uibJPPW77RlZnEZV
	YqaQiCFJdSJSbY6nXATucJRGPcqJDqA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXS4MVR6IIxLHAdj8ar4mv6JKBFf8O5m7u8yjKkKPr8=;
	b=ZimIfP8XztBWS/bNthVN9oiAMTMXt9Hbw/1uzA6hQGqNyTrx9P797gnukbMh46dodYIgBv
	kA93/cn9Fog37FlmNPCRT1bj2YtLoFA9Q9OmVrC3DevezfOacLR9tWmMtqxTFG6zkmyljZ
	86ocsJBq7N/fPAI+el6rqBBlA5SJyP0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ahLac+V8;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XXS4MVR6IIxLHAdj8ar4mv6JKBFf8O5m7u8yjKkKPr8=; b=ahLac+V8ywmER+byYB06ahi2gL
	L2vNfShRNLw0mbCNuvqyIJU/S1c0SVsLy41KCel7oRegkrY5wQ3tCeiobAVxuF1rkM+ZGubMboAVr
	Gs29315k1McyA7V7FWtb45uZGS2N1+Yiu5zgPafZ1vF2JAF7l9BPctoYnC+BvC1JCd7iG9juBANaZ
	kGT8rtpXlaEHLGuw/dupGhcdoVWoHp/eA6epkh5nyDOhc5YEIngZRrnOVgsm/kYbYmy+EF1FlAKTU
	JGoSYBmv6ByPQHIw3MvoAuvTkHlgVZRD3DwDwn9VGBL5NbW84w6gYj40Fg1mGyUeilpm4AVrxX+T6
	SO61XeyQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wcZF7-0000000043x-49AV;
	Wed, 24 Jun 2026 21:51:01 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Dmitry Ilvokhin" <d@ilvokhin.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	kernel-team@meta.com
Subject: [PATCH 3/3] mm: read remote memory without the mmap lock where possible
Date: Wed, 24 Jun 2026 21:50:53 -0400
Message-ID: <20260625015053.2445008-4-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625015053.2445008-1-riel@surriel.com>
References: <20260625015053.2445008-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26C2C20002
X-Rspam-User: 
X-Stat-Signature: w77xziq3adqcpgesy1n5pwgnwrzy3u5i
X-HE-Tag: 1782352280-908494
X-HE-Meta: U2FsdGVkX18+kLNhiCDE0Ik38Wdwid2zLAP1XK8ILdDtwXh91ZtfbbAn0/1O9//MeWs1/SngH+Zi5fnVPkfDyK8E2GD40KIxGqGJ02fg5ahR+WxXDK0jD/BIqh06flLM1aBDvqgevnl1aNq8NpmaYr0S/M00JnY4cVRVCxmIKrnbZDsbmbFPRmizxGLKAVFnaG0d9V56FmFBz0lV6ny2kPx+u/SFErlFiB+dZp0QodBkTRZEywO0iSNIgA92xNJJvQOhDh4GlEDSfXrG4xkM0zJDfZpL36CHZO8xOYzrdF0yvKYy/iX1n9oDguPImrKdIzn7GUf61Be8q9PLXbDbU991COonvfAoZEp3IQ9In6+aHSUF6XySQPQeKh8obinZJ0w3DFKZ7WSuxb/KZ46NsWNw0WixEydzn4FX45qP5yuBGYbCGAkHa84U0AA317TRHGE/0J09nVVvlI8dB6JgEnJ2NCsVsIDmXg3Dvlno9OhpsxTkczRUEV7S98Bdz+mzFxp46AgAJS5HXZTbU2V8Sn7TloSD9IIGJdi2zFZ0LQSCbaks0/bP/BdsqlC5DMAFuKByxyDOD6za3vN8xOt1L4vgofpvF8CDQlSZioTG4NpxUvMhLbGE9TtzSr/LcOw4QYpEFBTAFbNee6KFGRA+fEIhSUXmCpL49KohecyJjZUyZd9iTduH9nesuUdn40G/jJ+nAxzGILJulsh15JPQlls6J7NwNbL2WeX7deMk3GL4bmVpjP9swKYslhqS5tznl5eCIhvmk3kYvZqiha0EcxVHqkbgOkZBwt647FXuuq842PC13DhikgCxvd7xPOlxPbp8tsavG5VQZM7lP8Uy1WdK5dfelu2nnCYy7gdLYEBVhsDY04fSsDWW8sq3RHCWjV4ejfRguZvhxdESK3RrOhr4LKQlLFu0piKme1enlKGQlx8GZilCguG68J9fotc6ediJUF6CVMcniNrcqHS
 nhyGFaID
 ZxSou9lOaAiQu+GQXvwSLYVsqW6U/agwfM5SdzOpjoL+lvCBhiIOuIeWD3Mwn1kfRoNlAli2132l5WH5nJdcplcDZl0AgXNhD8QzoY3OiE8aYTi3Q5Pr/YpzKmhuip0QLzWlFlBRtlNLZGI86aE3zJksWOnJfCN75ZYmjoxl4PdvA99Xs4l9pVGufglqE7gYNkB9rSnZwX7Kw9zSdA5QVWWc07KOs10LyVvQoj1fysIMBN3ryi+LOoZ48Iyr6EYf/njeheEgsAXd20gaQy078x2Fm5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() takes mmap_read_lock() for the entire transfer and
uses get_user_pages_remote(), which faults pages in.  For the common case
of reading memory that is already resident -- /proc/PID/cmdline,
/proc/PID/environ, ptrace PEEK of resident pages -- the mmap lock is
unnecessary and is badly contended on large machines.

Add an opportunistic, read-only fast path.  It takes the per-VMA lock with
lock_vma_under_rcu() and, only when the whole request lies within that one
VMA, copies the resident pages out using folio_walk_start(FW_VMA_LOCKED)
to grab a short-lived page reference from a page table walk run with
interrupts disabled.  Interrupts are disabled only across the walk (until
the folio is pinned): page table freeing -- a concurrent munmap() or THP
collapse of an adjacent region -- serializes against lockless walkers via
tlb_remove_table_sync_one(), which IPIs and waits for every CPU to enable
interrupts, the same contract gup_fast relies on.  The copy then runs with
interrupts on, holding only the folio reference.

A request that spans more than one VMA is left entirely to the mmap_lock
path: relocking per VMA could observe a structurally inconsistent address
space (a neighbouring VMA unmapped and a different one mapped in its place
between locks), whereas the mmap_lock path sees a stable VMA tree for the
whole transfer.

The per-VMA permission check mirrors the read side of check_vma_flags(),
including the FOLL_ANON restriction that /proc/PID/{cmdline,environ} rely
on (CVE-2018-1120).  Anything not positively allowed -- a not-present
page, a hugetlb or VM_IO/VM_PFNMAP or secretmem mapping, or a race with a
VMA writer -- falls back to the mmap_lock path for the remainder, which
re-validates everything.  Pages read on the fast path are marked accessed,
matching the FOLL_TOUCH behaviour of the get_user_pages_remote() slow
path.

untagged_addr_remote() asserts the mmap lock, so add an unlocked variant
for the fast path; the untag mask is a stable per-mm value.

Only reads are handled here; writes keep using the slow path.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/include/asm/uaccess_64.h |  14 ++-
 include/linux/uaccess.h           |  11 ++
 mm/memory.c                       | 195 +++++++++++++++++++++++++++++-
 3 files changed, 217 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 4a52497ba6a1..933b0b8b4d60 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -39,11 +39,23 @@ static inline unsigned long __untagged_addr(unsigned long addr)
 	(__force __typeof__(addr))__untagged_addr(__addr);		\
 })
 
+/* Strip the tag bits from a remote mm's address; usable without the mmap lock. */
+static inline unsigned long __untagged_addr_remote_unlocked(struct mm_struct *mm,
+							    unsigned long addr)
+{
+	return addr & READ_ONCE(mm->context.untag_mask);
+}
+
+#define untagged_addr_remote_unlocked(mm, addr)	({			\
+	unsigned long __addr = (__force unsigned long)(addr);		\
+	(__force __typeof__(addr))__untagged_addr_remote_unlocked(mm, __addr); \
+})
+
 static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,
 						   unsigned long addr)
 {
 	mmap_assert_locked(mm);
-	return addr & READ_ONCE((mm)->context.untag_mask);
+	return __untagged_addr_remote_unlocked(mm, addr);
 }
 
 #define untagged_addr_remote(mm, addr)	({				\
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 8a264662b242..c8c83372c9d8 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -34,6 +34,17 @@
 })
 #endif
 
+/*
+ * Like untagged_addr_remote(), but for callers that stabilize @mm by other
+ * means (e.g. a per-VMA lock) and must not assert the mmap lock.
+ */
+#ifndef untagged_addr_remote_unlocked
+#define untagged_addr_remote_unlocked(mm, addr)	({	\
+	(void)(mm);					\
+	untagged_addr(addr);				\
+})
+#endif
+
 #ifdef masked_user_access_begin
  #define can_do_masked_user_access() 1
 # ifndef masked_user_write_access_begin
diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..d2b2f0014a0c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -42,6 +42,8 @@
 #include <linux/kernel_stat.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
+#include <linux/secretmem.h>
+#include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/numa_balancing.h>
 #include <linux/sched/task.h>
@@ -7062,6 +7064,180 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 EXPORT_SYMBOL_GPL(generic_access_phys);
 #endif
 
+/*
+ * The fast path uses folio_walk_start(FW_VMA_LOCKED), which needs the per-VMA
+ * lock and RCU-freed page tables to walk page tables without the mmap lock.
+ */
+#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_MMU_GATHER_RCU_TABLE_FREE)
+/*
+ * Read-side VMA checks for the lockless fast path, mirroring the read side of
+ * check_vma_flags(): reject what FW_VMA_LOCKED cannot handle (hugetlb), what
+ * needs the ->access() handler (VM_IO/VM_PFNMAP), or what has no struct page to
+ * copy (secretmem); enforce the FOLL_ANON restriction that
+ * /proc/PID/{cmdline,environ} rely on (CVE-2018-1120); and require read access
+ * (honoring FOLL_FORCE).  Anything not positively allowed falls back to the slow
+ * path, which re-validates everything.
+ */
+static bool vma_permits_fast_access(struct vm_area_struct *vma,
+				    unsigned int gup_flags)
+{
+	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		return false;
+	if (is_vm_hugetlb_page(vma) || vma_is_secretmem(vma))
+		return false;
+	if ((gup_flags & FOLL_ANON) && !vma_is_anonymous(vma))
+		return false;
+	if (!(vma->vm_flags & VM_READ) &&
+	    (!(gup_flags & FOLL_FORCE) || !(vma->vm_flags & VM_MAYREAD)))
+		return false;
+	return true;
+}
+
+/* Size of the single mapping entry folio_walk_start() landed on. */
+static unsigned long fw_entry_size(enum folio_walk_level level)
+{
+	switch (level) {
+	case FW_LEVEL_PUD:
+		return PUD_SIZE;
+	case FW_LEVEL_PMD:
+		return PMD_SIZE;
+	default:
+		return PAGE_SIZE;
+	}
+}
+
+/*
+ * Copy @len bytes of the pinned @folio out to @buf, starting at byte offset
+ * @folio_off within the folio (the position of @addr).  Maps and copies one
+ * page at a time -- kmap_local_folio() for HIGHMEM, copy_from_user_page() for
+ * the per-page flush on aliasing caches -- without re-walking page tables.
+ * Each page borrows the caller's single folio reference, so the mapping is
+ * dropped with kunmap_local() rather than folio_release_kmap().
+ */
+static void copy_folio_pages(struct vm_area_struct *vma, struct folio *folio,
+			     unsigned long folio_off, unsigned long addr,
+			     void *buf, unsigned long len)
+{
+	unsigned long done = 0;
+
+	while (done < len) {
+		unsigned long pos = folio_off + done;
+		unsigned long page_idx = pos >> PAGE_SHIFT;
+		unsigned int page_off = pos & ~PAGE_MASK;
+		unsigned int chunk = min_t(unsigned long, len - done,
+					   PAGE_SIZE - page_off);
+		void *kaddr = kmap_local_folio(folio, page_idx << PAGE_SHIFT);
+
+		copy_from_user_page(vma, folio_page(folio, page_idx),
+				    addr + done, buf + done, kaddr + page_off,
+				    chunk);
+		kunmap_local(kaddr);
+		done += chunk;
+	}
+}
+
+/*
+ * Opportunistic lockless fast path for __access_remote_vm() reads.
+ *
+ * Memory already resident in @mm can be read without taking the frequently
+ * contended mmap_lock: a per-VMA lock stabilizes the VMA, and folio_walk_start()
+ * with FW_VMA_LOCKED grabs a short-lived reference to a present page from a page
+ * table walk run with interrupts disabled, which serializes against concurrent
+ * page table freeing the same way gup_fast does (relying on
+ * MMU_GATHER_RCU_TABLE_FREE).
+ *
+ * Only a request that lies entirely within a single VMA is handled here,
+ * which should not be an issue in practice since every caller has a
+ * buffer of PAGE_SIZE or smaller. Loop iteration inside this function
+ * should be rare, too.
+ *
+ * Returns the number of bytes transferred via the fast path.
+ */
+static int access_remote_vm_fast(struct mm_struct *mm, unsigned long addr,
+				 void *buf, int len, unsigned int gup_flags)
+{
+	void *old_buf = buf;
+	struct vm_area_struct *vma;
+
+	addr = untagged_addr_remote_unlocked(mm, addr);
+
+	vma = lock_vma_under_rcu(mm, addr);
+	if (!vma)
+		return 0;
+
+	/* Only handle a request contained entirely within this one VMA. */
+	if (len > vma->vm_end - addr)
+		goto out_unlock;
+
+	if (!vma_permits_fast_access(vma, gup_flags))
+		goto out_unlock;
+
+	while (len) {
+		struct folio_walk fw;
+		struct folio *folio;
+		struct page *page;
+		unsigned long entry_size, folio_off, span, irq_flags;
+
+		/*
+		 * The lockless page table walk must run with interrupts
+		 * disabled: page table freeing (munmap or THP collapse, which
+		 * IPI via tlb_remove_table_sync_one() and wait) then cannot free
+		 * a table mid-walk -- the same contract gup_fast relies on.  IRQs
+		 * are restored once the folio is pinned; the copy below holds only
+		 * the folio reference.
+		 */
+		local_irq_save(irq_flags);
+		folio = folio_walk_start(&fw, vma, addr, FW_VMA_LOCKED);
+		if (!folio) {
+			local_irq_restore(irq_flags);
+			goto out_unlock;	/* not present: let the slow path fault it in */
+		}
+		page = fw.page;
+		if (!page) {
+			/* No struct page to copy (e.g. a special PTE). */
+			folio_walk_end(&fw, vma);
+			local_irq_restore(irq_flags);
+			goto out_unlock;
+		}
+		entry_size = fw_entry_size(fw.level);
+		folio_get(folio);
+		folio_walk_end(&fw, vma);
+		local_irq_restore(irq_flags);
+
+		/*
+		 * folio_walk_start() validated one present mapping entry
+		 * (PAGE/PMD/PUD_SIZE).  Copy to the end of that entry, bounded by
+		 * the folio and the remaining length (already within the VMA), so
+		 * a huge mapping is handled in a single walk.
+		 */
+		folio_off = (folio_page_idx(folio, page) << PAGE_SHIFT) +
+			    offset_in_page(addr);
+		span = min3((unsigned long)len,
+			    entry_size - (addr & (entry_size - 1)),
+			    (folio_nr_pages(folio) << PAGE_SHIFT) - folio_off);
+
+		copy_folio_pages(vma, folio, folio_off, addr, buf, span);
+
+		/* Match the FOLL_TOUCH behaviour of the slow (GUP) path. */
+		folio_mark_accessed(folio);
+		folio_put(folio);
+		len -= span;
+		buf += span;
+		addr += span;
+	}
+
+out_unlock:
+	vma_end_read(vma);
+	return buf - old_buf;
+}
+#else
+static int access_remote_vm_fast(struct mm_struct *mm, unsigned long addr,
+				 void *buf, int len, unsigned int gup_flags)
+{
+	return 0;
+}
+#endif /* CONFIG_PER_VMA_LOCK && CONFIG_MMU_GATHER_RCU_TABLE_FREE */
+
 /*
  * Access another process' address space as given in mm.
  */
@@ -7071,15 +7247,30 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 	void *old_buf = buf;
 	int write = gup_flags & FOLL_WRITE;
 
+	/*
+	 * Try the lockless fast path for reads first; it transfers what it can
+	 * from resident memory without taking mmap_lock, and leaves the
+	 * remainder (if any) to the slow path below.
+	 */
+	if (!write) {
+		int done = access_remote_vm_fast(mm, addr, buf, len, gup_flags);
+
+		addr += done;
+		buf += done;
+		len -= done;
+		if (!len)
+			return buf - old_buf;
+	}
+
 	if (mmap_read_lock_killable(mm))
-		return 0;
+		return buf - old_buf;
 
 	/* Untag the address before looking up the VMA */
 	addr = untagged_addr_remote(mm, addr);
 
 	/* Avoid triggering the temporary warning in __get_user_pages */
 	if (!vma_lookup(mm, addr) && !expand_stack(mm, addr))
-		return 0;
+		return buf - old_buf;
 
 	/* ignore errors, just check how much was successfully transferred */
 	while (len) {
-- 
2.53.0-Meta


