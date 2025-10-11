Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47FDCCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 09:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15768E0040; Sat, 11 Oct 2025 05:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC66E8E0005; Sat, 11 Oct 2025 05:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5218E0040; Sat, 11 Oct 2025 05:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C62708E0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:31:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6339F11A7BF
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:31:13 +0000 (UTC)
X-FDA: 83985314826.22.6DBABA2
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B203140003
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:31:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bd4uCyCw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760175072; a=rsa-sha256;
	cv=none;
	b=L4PPiyTmh7NvmHoxsLsCTWBto6fDwL4pQ30ecBI+Fj8JMkkcbJ4jrgaZZ5m25XNV3yMP6i
	LYC4zHU6KK2gF61eopeMPr5GPRFA2z/xlPCeBAbksWk4QDvDyhvGZeocFQ4m+BEPBnaL5L
	utFUj+NTx3wGYxr9YDdMs8FMDyh2UGI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bd4uCyCw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760175071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Nr+neWNm+4FZTAQ9R51lMpwjHUnZyOCAgPyY3NYPzno=;
	b=7cpGjmguwaela0M6xTWaOlWq47klrAaYEz8YO8cFEBy5jHAPurczIqftJtiYYGNjNr+9oh
	nZ4NNxIGduy58GZNRDEJSGV+I/k4OqdVR/aW430X26Zjr8bXc+nfE8aZ9KqHpygqbENEVK
	UUQvzy6XlMY3xIPPCaIqBHem70cKGcE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760175069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Nr+neWNm+4FZTAQ9R51lMpwjHUnZyOCAgPyY3NYPzno=;
	b=bd4uCyCw4bg6Q8+3xSykD61fCwxXlV7Bn8caDxTcotR032/dQ0JZFXZipGQO8pO9apU0F5
	Hb8uq94dKuQMI145sH9dCpj/Ykxc5kmv326o6dUqddgZeU70pXJ4fYlc1vqG/Ofq7Nf/jf
	KobtAs+2lQoFJP8NhvmuDxFBS5+I4Do=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC RFC PATCH] mm: convert VM flags from macros to enum
Date: Sat, 11 Oct 2025 17:30:52 +0800
Message-ID: <20251011093054.886460-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B203140003
X-Stat-Signature: hfeof1b97gnu81iqoixsmhgdnaydz6hy
X-HE-Tag: 1760175071-404633
X-HE-Meta: U2FsdGVkX1/G8rhP7Xm1zrKavP/t1C4xsTyKIv1ed1kxn31aBs1IYkms0wJQ3AnteldStcFNQ+XtgQ/pzhHouLmVStwgbjUykyx7wNoe1LHq9FO9ayrpIjUoZNkCGxRmZI/drF5MIL3SLSST/xi702bK5s8O3ujlwirW21XhRCPxWI63i1uomdVXRPlquLFl/ZmdxhbDhoonfaGxHXN8zVKsjrdbaWnQe0zRhw3arPnqAbp5IfteXSekKinsMDFd658STpthw8Nw3gfd89J7M2fQmSMwK+Yg/vpKrM4mPDw+erqjY6Et9FKxqJWN6m6eJxvIWyaakmbQApdDr89w2bWTSRI2RglINvvjaBTMSgfsd+p9y+Z8ZECVqb7DzXN+wxl/NaW04OeaVLQ3acTd7pX3MCulyl/tBH1RI2fDtrGoTGdDU24T3Ho5SUIWO59RuD8acZB3QffbF/kXrFCk1D1qJGf7nNmNJiVuj0sz7QsugoNonQGkila0uiIAYwNPh8B1kcGu4v4X83ybAU23nKjhLj+cGqR7LF8gAMI3S95Rc0Hh+yJHqTATqTi8tB/h1r0eZXrDy0tjy8y4DFCusxOrC1FE4AIC3ebHpAcWuJ+oRtXgYkdZUS597CGeNKxzjZ/bXZyVklAzusKFQjoBBV1YIo5wt5jclMF0mjrQOdTJAuOja3N0NUAiXFl7R2Ak3VG/dL/qPEdIwxCh9PcIuU1RVk0we64+vCLqs+d5N3iLxeFGSWzRu0K9+cTGi1bpLXuRkUBeaDFNKkRiNKE8rNYW5xGfiHEiZLS88dGU8EHRRAQa4wAqIsjNatQp6qOdKXr8I3I276XFO2ZZq1uKagXe9eWvMrXe9fLv3ePxWLyTICsua5XdEhTFl+E6BZw6paDhDjOS6F88/mKAwN0ty+NPpcg+gCJgoDQ+nUyjcggAQGLtdLopFiAOK/WjF1NNftenwsX/3q6pPx/efHV
 rmXXqdWH
 c2l7rp+s5T+dMQnIAlghOYPb5nD/TnM40+Zg1EQNL62n0gXJWoTpBHFeUYshScckGOFoTwN6uB+60ucFl5ILSOD1So2W+ifY/injszpTS2IfTYy/dGf0SQbNYLab9An/5nGnMUMw6IEqIXaGUJD+1W3n/IXGOeKoxBZz6fmCU33oXi0F0yNyquMiAIfUsXtXU/9Ds
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Hello MM maintainers and drgn community,

This RFC proposes to convert VM_* flags from #define macros to enum
vm_flags. The motivation comes from recent drgn development where we
encountered difficulties in implementing VM flag parsing due to the
current macro-based approach.

Problem:
- Debugging tools like drgn must hard-code VM flag values
- No type information available for external tools
- Maintenance burden when flags change in kernel
- Error-prone flag interpretation

Solution:
Convert to enum while preserving all existing values and semantics.

Benefits:
1. Better type safety for kernel code
2. Enabled dynamic VM flag parsing in debugging tools
3. Improved debugger experience (meaningful symbol names)
4. Easier maintenance and extensibility
5. No functional changes or ABI impact

This change would particularly help with implementing the 'vm -f' option
in drgn's crash mode, allowing proper VM flag filtering and display
without hard-coded values.

I'm seeking feedback on:
- Overall approach acceptability
- Any concerns about enum usage in this context
- Potential impacts on other subsystems
- Suggestions for alternative solutions
- Whether this should include trace events update

Looking forward to your comments.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 include/linux/mm.h   | 90 +++++++++++++++++++++++---------------------
 include/linux/mman.h |  7 ++--
 2 files changed, 50 insertions(+), 47 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..7030108c3759 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -268,62 +268,66 @@ extern struct rw_semaphore nommu_region_sem;
 
 extern unsigned int kobjsize(const void *objp);
 #endif
-
 /*
  * vm_flags in vm_area_struct, see mm_types.h.
  * When changing, update also include/trace/events/mmflags.h
  */
-#define VM_NONE		0x00000000
+enum vm_flags {
+	VM_NONE         = 0x00000000,
+
+	VM_READ         = BIT(0), /* currently active flags */
+	VM_WRITE        = BIT(1),
+	VM_EXEC         = BIT(2),
+	VM_SHARED       = BIT(3),
 
-#define VM_READ		0x00000001	/* currently active flags */
-#define VM_WRITE	0x00000002
-#define VM_EXEC		0x00000004
-#define VM_SHARED	0x00000008
+	/* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
+	VM_MAYREAD      = BIT(4), /* limits for mprotect() etc */
+	VM_MAYWRITE     = BIT(5),
+	VM_MAYEXEC      = BIT(6),
+	VM_MAYSHARE     = BIT(7),
 
-/* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
-#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
-#define VM_MAYWRITE	0x00000020
-#define VM_MAYEXEC	0x00000040
-#define VM_MAYSHARE	0x00000080
+	VM_GROWSDOWN    = BIT(8), /* general info on the segment */
 
-#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
 #ifdef CONFIG_MMU
-#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
-#else /* CONFIG_MMU */
-#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
-#define VM_UFFD_MISSING	0
-#endif /* CONFIG_MMU */
-#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
-#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
-
-#define VM_LOCKED	0x00002000
-#define VM_IO           0x00004000	/* Memory mapped I/O or similar */
-
-					/* Used by sys_madvise() */
-#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
-#define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
-
-#define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
-#define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
-#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are faulted in */
-#define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
-#define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
-#define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
-#define VM_SYNC		0x00800000	/* Synchronous page faults */
-#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
-#define VM_WIPEONFORK	0x02000000	/* Wipe VMA contents in child. */
-#define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
+	VM_UFFD_MISSING = BIT(9),  /* missing pages tracking */
+#else
+	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
+	VM_MAYOVERLAY   = BIT(9),
+	VM_UFFD_MISSING = 0,
+#endif
+
+	VM_PFNMAP       = BIT(10), /* Page-ranges managed without "struct page", just pure PFN */
+	VM_UFFD_WP      = BIT(12), /* wrprotect pages tracking */
+
+	VM_LOCKED       = BIT(13),
+	VM_IO           = BIT(14), /* Memory mapped I/O or similar */
+
+	/* Used by sys_madvise() */
+	VM_SEQ_READ     = BIT(15), /* App will access data sequentially */
+	VM_RAND_READ    = BIT(16), /* App will not benefit from clustered reads */
+
+	VM_DONTCOPY     = BIT(17), /* Do not copy this vma on fork */
+	VM_DONTEXPAND   = BIT(18), /* Cannot expand with mremap() */
+	VM_LOCKONFAULT  = BIT(19), /* Lock the pages covered when they are faulted in */
+	VM_ACCOUNT      = BIT(20), /* Is a VM accounted object */
+	VM_NORESERVE    = BIT(21), /* should the VM suppress accounting */
+	VM_HUGETLB      = BIT(22), /* Huge TLB Page VM */
+	VM_SYNC         = BIT(23), /* Synchronous page faults */
+	VM_ARCH_1       = BIT(24), /* Architecture-specific flag */
+	VM_WIPEONFORK   = BIT(25), /* Wipe VMA contents in child. */
+	VM_DONTDUMP     = BIT(26), /* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-# define VM_SOFTDIRTY	0x08000000	/* Not soft dirty clean area */
+	VM_SOFTDIRTY    = BIT(27), /* Not soft dirty clean area */
 #else
-# define VM_SOFTDIRTY	0
+	VM_SOFTDIRTY    = 0,
 #endif
 
-#define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
-#define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
-#define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
-#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
+	VM_MIXEDMAP     = BIT(28), /* Can contain "struct page" and pure PFN pages */
+	VM_HUGEPAGE     = BIT(29), /* MADV_HUGEPAGE marked this vma */
+	VM_NOHUGEPAGE   = BIT(30), /* MADV_NOHUGEPAGE marked this vma */
+	VM_MERGEABLE    = BIT(31), /* KSM may merge identical pages */
+};
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
diff --git a/include/linux/mman.h b/include/linux/mman.h
index 0ba8a7e8b90a..4a0adbdeccdd 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -130,10 +130,9 @@ static inline bool arch_validate_flags(unsigned long flags)
  * ("bit1" and "bit2" must be single bits)
  */
 #define _calc_vm_trans(x, bit1, bit2) \
-  ((!(bit1) || !(bit2)) ? 0 : \
-  ((bit1) <= (bit2) ? ((x) & (bit1)) * ((bit2) / (bit1)) \
-   : ((x) & (bit1)) / ((bit1) / (bit2))))
-
+	(((bit1) == 0 || (bit2) == 0) ? 0 : \
+	 ((bit1) <= (bit2) ? ((x) & (bit1)) * ((bit2) / (bit1)) \
+	  : ((x) & (bit1)) / ((bit1) / (bit2))))
 /*
  * Combine the mmap "prot" argument into "vm_flags" used internally.
  */
-- 
2.43.0


