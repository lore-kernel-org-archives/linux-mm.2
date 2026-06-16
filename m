Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1602ACD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB41B6B008C; Tue, 16 Jun 2026 17:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A650E6B009B; Tue, 16 Jun 2026 17:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9538E6B00DD; Tue, 16 Jun 2026 17:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7D16B008C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:42:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B841AC163C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:34 +0000 (UTC)
X-FDA: 84887100228.19.34EBEAF
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69645A0006
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=S7J+2dI9;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781646153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oy+StK/tmm2k6fM6wzqUIrhow8bK9owfFAz1d2BFhno=;
	b=2nDwopWJ8EPdAP9eEnU18Fms5dY4l4qpfaQSiCFyuK1uE1MU/ZPPhOtB36iYEo/pKZtZEZ
	l7iknpH5Q1Xp8wHH/hYNZD/X8E6FUo7o18VNUC3eUyzay6rzQQnm/X5ph8NyY3ropI7H8i
	zYSZZLRUdnVtCOKVqvd0KE7bD6RRnSE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=S7J+2dI9;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781646153;
	b=11L4aUdkILbYGDxycou0n55fO286/vycouTKohS3jqaOJo/zbOH9UUhtR+BK4nPyckzy3R
	WsGV19V8MBQeomBIe2nljov53/dHV683S285CJBGzUOiUdXZ84fbVPoeFL7oC2k1sUiSmc
	Kp7kFpXjrJdML0xxo47laWThOhdui0o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oy+StK/tmm2k6fM6wzqUIrhow8bK9owfFAz1d2BFhno=; b=S7J+2dI9DI3zzbhbjHhXoml5pg
	RzmwAW8PaLbfyWKZjvIJT+ZtEAwF/hLQzdv9OdSPMCytkvgWX1ToFQVQFljXBYO4LJdz5cL52NHE8
	r2jYxXRVAgjJs/21JHWon1tj2dx552HSChtsbTXODYo1wBgPaIC+jP7gtgkRXHQXPLevu3MtWC/wp
	3FZ5dL6w8Bet47ApdJBAgtOKUjoThddnb7Q3MEV+34FoDE0INqKfgfA9TDRASOPLC+QUpbwc00y6u
	MA1H7VZqeJ7khCZnBLGYm0kis80KF7IttoZIsaxS6r0+jcZr81GR2doKWufLQO/dhEPz9FigOUS4X
	NJPj3FbQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wZZ4T-000000005GL-3EFO;
	Tue, 16 Jun 2026 15:03:37 -0400
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
	"Suren Baghdasaryan" <surenb@google.com>
Subject: [PATCH 3/3] mm: read remote memory without the mmap lock where possible
Date: Tue, 16 Jun 2026 15:03:00 -0400
Message-ID: <20260616190300.1509639-4-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616190300.1509639-1-riel@surriel.com>
References: <20260616190300.1509639-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: k6jxj5ecb6hr7dnfxp5yug3qeo31aezc
X-Rspamd-Queue-Id: 69645A0006
X-HE-Tag: 1781646151-894150
X-HE-Meta: U2FsdGVkX19ah32DPkv25I9GoAtcZbV2ay72+NfKxtsdpSJIk1P1J4HtBTm8N2qagUctqpbMx6pyxUbTGH+3WyWVMJn74rmlIoHfHcFaCw+X+/XGi94J2hj5If14R75+PM4uA5dUAuAcShFMEwOwi6jBYAH6JkU27kMwZVaXhzOrcQTseD0vpn2H1WblT44CxOjSVJ5q0GsiC/720qqJrt9m5uo4f87WmrVfTkSwcR+DQz2FOAjjlplxgdAUnDzxsKUw3JkMQYdnhkivEdLSYJpGEOqkA+qgbJDkbwR/WZL7ZE4B+XYYCwQCS6J/ip6D3ON2gGmRTlMnzFzfYAvPIiIgSvJMjsO2IxhrCyolNqTwlzpXI3xTPRXka6wNRVQBUKFveosBMdNAl+wRQlmidVFy23crqzzaJCvom2+HJeBcnJuvq4qIWJ6f2F2J74ZPwRT5rOzcaESWwwG5Ucw3gEgFgGVDfzJkLeCnIFXAUNjS9EEuhiINZg2KP5BgK5BGMJb2tjbhRypQMYSArvTGudqRv1yrwjCkWbfVI+pMUNIbs/q8JQzCDBrQXXT4YdQ+2ZSx91KW5kCZo3vugGUTQplzico0UBBtQgx/Iqr8j12Jq/tjEIvKqMYZZy8ikmCn6heSHxdQcIZoBz9chSzP85q7kxxKwNNX+47x64MKPYhA7ilpCBCXwhnzjuqbUPgMEHsnWYhrhdWiA/LsqSIw15J4B+bg2aEaJKwZo7VUL5Ouscnei2r0Nr/wFDVFqdlMxjm7j7oNWbrj8+9NrARIg330whUVa9lejBKoW6PxY76s1PfKsrsQb3iHBhzhLdKSSShzoTXpJ7ALPtSNZgIcOPwTFtM8GwVdHHE2ZaG39ZIJ+9bDTlZpCVSr0N80ZMMtYIcWfqSfUA5d4o2/7guBD3WZ5d/kHf1ZZGxVcEBvVEeQEBRvRPVV51H/tE+Txj3kp6DTYCESidMuzXWNG/J
 K6Nfpxsz
 WMnKZMsDkiB7TtMtXNdYaX1A8bhWq6lkEtcuTL4Hq0pHkf9IEsKU59++HVspgyF7oxzgTbcKs/RoQN/XYQRZGwetkI20/B90SM8zDcOpwhJaIBl2IhxWvFR1Fzv0va5prcewf+eU9Ore9WRd7cFmRxaPpjXU1fB06uhsJwGbYJ5Wpy+1NNmfxYZ2HrcEHs8CQQmcbMNb/2om9TfDaqgsM+44hdSilPKhyyqIc7kxrtPH8fbPdFZ96LKiIg42eWkg1jhKn6fdCnIW6pnebjSZkV3SRfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() takes mmap_read_lock() for the entire transfer and
uses get_user_pages_remote(), which faults pages in.  For the common
case of reading memory that is already resident -- /proc/PID/cmdline,
/proc/PID/environ, ptrace PEEK of resident pages -- the mmap lock is
unnecessary and is badly contended on large machines.

Add an opportunistic, read-only fast path that transfers what it can
without the mmap lock.  For each address it takes the per-VMA lock with
lock_vma_under_rcu(), re-checks the read-side VMA permissions, and uses
folio_walk_start(..., FW_VMA_LOCKED) to grab a short-lived reference to
a present page before copying it out.  Anything non-trivial -- a not-
present page (needs faulting), a hugetlb or VM_IO/VM_PFNMAP mapping, or
a race with a VMA writer -- falls back to the existing mmap_lock path
for the remainder.

untagged_addr_remote() asserts the mmap lock, so add an unlocked variant
for the fast path; the untag mask is a stable per-mm value.

Only reads are handled here; writes keep using the slow path.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/include/asm/uaccess_64.h |  12 +++
 include/linux/uaccess.h           |  11 ++
 mm/memory.c                       | 166 +++++++++++++++++++++++++++++-
 3 files changed, 188 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 4a52497ba6a1..c6fac900a747 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -51,6 +51,18 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,
 	(__force __typeof__(addr))__untagged_addr_remote(mm, __addr);	\
 })
 
+/* Same as __untagged_addr_remote(), but usable without the mmap lock held. */
+static inline unsigned long __untagged_addr_remote_unlocked(struct mm_struct *mm,
+							    unsigned long addr)
+{
+	return addr & READ_ONCE((mm)->context.untag_mask);
+}
+
+#define untagged_addr_remote_unlocked(mm, addr)	({			\
+	unsigned long __addr = (__force unsigned long)(addr);		\
+	(__force __typeof__(addr))__untagged_addr_remote_unlocked(mm, __addr); \
+})
+
 #endif
 
 #define valid_user_address(x) \
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
index 86a973119bd4..0b23b82eaa18 100644
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
@@ -7062,6 +7064,153 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 EXPORT_SYMBOL_GPL(generic_access_phys);
 #endif
 
+/*
+ * The fast path uses folio_walk_start(FW_VMA_LOCKED), which needs the per-VMA
+ * lock and RCU-freed page tables to walk page tables without the mmap lock.
+ */
+#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_MMU_GATHER_RCU_TABLE_FREE)
+/*
+ * Opportunistic lockless fast path for __access_remote_vm() reads.
+ *
+ * Memory already resident in @mm can be read without taking the heavily
+ * contended mmap_lock: a per-VMA lock stabilizes the VMA, and folio_walk_start()
+ * with FW_VMA_LOCKED grabs a short-lived reference to a present page via an
+ * RCU/PTL protected page table walk (relying on MMU_GATHER_RCU_TABLE_FREE).
+ *
+ * Anything that would require faulting a page in, touching a hugetlb or
+ * VM_IO/VM_PFNMAP mapping, or that races a VMA writer is left to the mmap_lock
+ * path in __access_remote_vm().  Only reads are handled here.
+ *
+ * Returns the number of bytes transferred via the fast path.
+ */
+static int access_remote_vm_fast(struct mm_struct *mm, unsigned long addr,
+				 void *buf, int len, unsigned int gup_flags)
+{
+	void *old_buf = buf;
+
+	addr = untagged_addr_remote_unlocked(mm, addr);
+
+	while (len) {
+		struct vm_area_struct *vma;
+		vm_flags_t vm_flags;
+
+		vma = lock_vma_under_rcu(mm, addr);
+		if (!vma)
+			break;
+
+		/*
+		 * Mirror the read-side permission checks of check_vma_flags(),
+		 * and exclude what FW_VMA_LOCKED cannot handle (hugetlb) or what
+		 * needs the ->access() handler (VM_IO/VM_PFNMAP).  Checked once
+		 * per VMA; anything not positively allowed falls back to the
+		 * slow path, which re-validates everything.
+		 */
+		vm_flags = vma->vm_flags;
+		if ((vm_flags & (VM_IO | VM_PFNMAP)) ||
+		    is_vm_hugetlb_page(vma) || vma_is_secretmem(vma) ||
+		    (!(vm_flags & VM_READ) &&
+		     (!(gup_flags & FOLL_FORCE) || !(vm_flags & VM_MAYREAD)))) {
+			vma_end_read(vma);
+			break;
+		}
+
+		/*
+		 * Copy as much of this VMA as we can without re-acquiring the
+		 * per-VMA lock; re-lock only when @addr leaves the VMA.
+		 */
+		while (len && addr < vma->vm_end) {
+			struct folio_walk fw;
+			struct folio *folio;
+			struct page *page;
+			unsigned long entry_size, entry_left, folio_left, span;
+			unsigned long copied, idx0;
+			int offset;
+
+			folio = folio_walk_start(&fw, vma, addr, FW_VMA_LOCKED);
+			if (!folio) {
+				vma_end_read(vma);
+				goto out;
+			}
+			page = fw.page;
+			if (!page) {
+				folio_walk_end(&fw, vma);
+				vma_end_read(vma);
+				goto out;
+			}
+			/* Pin the folio so it stays valid after the PTL is dropped. */
+			folio_get(folio);
+			folio_walk_end(&fw, vma);
+
+			/*
+			 * folio_walk_start() validated exactly one mapping entry,
+			 * which covers a contiguous, present run of this folio:
+			 * PAGE_SIZE for a pte, PMD_SIZE for a pmd leaf, PUD_SIZE
+			 * for a pud leaf.  Copy up to the end of that entry,
+			 * bounded by the folio, the VMA and len, so a huge mapping
+			 * is handled in one walk instead of per page.
+			 */
+			offset = offset_in_page(addr);
+			switch (fw.level) {
+			case FW_LEVEL_PUD:
+				entry_size = PUD_SIZE;
+				break;
+			case FW_LEVEL_PMD:
+				entry_size = PMD_SIZE;
+				break;
+			default:
+				entry_size = PAGE_SIZE;
+				break;
+			}
+			entry_left = entry_size - (addr & (entry_size - 1));
+			idx0 = folio_page_idx(folio, page);
+			folio_left = ((folio_nr_pages(folio) - idx0) << PAGE_SHIFT) -
+				     offset;
+			span = min3((unsigned long)len, entry_left, folio_left);
+			span = min(span, vma->vm_end - addr);
+
+			/*
+			 * Copy the span page-by-page: kmap_local_folio() maps one
+			 * page on HIGHMEM and copy_from_user_page() flushes per
+			 * page on aliasing caches, but the page tables are not
+			 * re-walked.  The span borrows the single folio reference
+			 * taken above, so each mapping is dropped with
+			 * kunmap_local() (not folio_release_kmap(), which would
+			 * also drop a folio reference per page).
+			 */
+			for (copied = 0; copied < span; ) {
+				unsigned long foff = offset + copied;
+				unsigned long pidx = idx0 + (foff >> PAGE_SHIFT);
+				int poff = foff & ~PAGE_MASK;
+				int chunk = min_t(unsigned long, span - copied,
+						  PAGE_SIZE - poff);
+				void *maddr = kmap_local_folio(folio,
+						pidx << PAGE_SHIFT);
+
+				copy_from_user_page(vma, folio_page(folio, pidx),
+						    addr + copied, buf + copied,
+						    maddr + poff, chunk);
+				kunmap_local(maddr);
+				copied += chunk;
+			}
+
+			folio_put(folio);
+			len -= span;
+			buf += span;
+			addr += span;
+		}
+		vma_end_read(vma);
+	}
+out:
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
@@ -7071,8 +7220,23 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
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
-- 
2.53.0-Meta


