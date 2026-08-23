Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D34C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 12:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232C46B00A7; Sun, 23 Aug 2026 08:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2BF6B00A9; Sun, 23 Aug 2026 08:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F99A6B00AA; Sun, 23 Aug 2026 08:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D16C46B00A7
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:18:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68241A312E
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:18:40 +0000 (UTC)
X-FDA: 85132437600.20.EF3C31A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C95FC40010
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:18:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jEeO1asY;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787487518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyND48Jk/AUcTHnSp2xhU1NTg8Gmmq5Xfa7qwMCpYtA=;
	b=LhqkUOEHRZO62SQc7fQ3uHVe4dLuNTh2Pwn4tm2Ck2+7oiwLziNXMINVxInIU3LcQ4hKjd
	RIzs0cbmpCO0pwU1d7ZDBqObKI+aRK4gZRUzm0IsMni73tdJEvtE3QiVWzTonqrvB4OZ4y
	5K1hc0fGh3mBMCyOUWvWX3q2zK4kjQY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jEeO1asY;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787487518;
	b=j9TZAYrQE6/SpgRtyLGkotorgBDO1S1r+nupQ7Ux88m53KOsZ56EJYg6Dz6Pj/ys6u5iQw
	d53ay3sTa1/6itxhow48aZb63HIiN2fcRSZvPPHn6bvOoVBGFbERsY7K9XW9Z6lqujTiRT
	jYNno5CSE0Kn9JukdsaFor9LEYfkAn0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C3E5600CB;
	Sun, 23 Aug 2026 12:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565101F000E9;
	Sun, 23 Aug 2026 12:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787487517;
	bh=yyND48Jk/AUcTHnSp2xhU1NTg8Gmmq5Xfa7qwMCpYtA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jEeO1asYSvT4efCXf5aTF5QggakbkAutPEVTUqQzVGJXJ6VwooIUl5pYIXTZEaRgV
	 JtzYsUh0p9QMqn12iE2iNDuQQlUgHdGRVHhMS4dUp9MOu3tahjKh4O3tL5VxTUCyg2
	 cC0+L+Dxb97bPTcYzx5Xv81nN6qexeQxoSyq+mE0fuThXZqbIEfxyzGxjCP/GdB3eL
	 U5BgpdqAULVLCgsT0HRAw95qytPIR+uqnVtRolrZY02TnS3hNxdEKwhOhJam9+UlcB
	 9Cx9aQelCSgfIoliHwJaroDkH1yxVqTcI4GGjKY9yAk1WCeiiWHFv1EH1zh+ny1/iS
	 KzSLfzWU5769Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 15:17:43 +0300
Subject: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C95FC40010
X-Stat-Signature: ykjbpa5tdk36nsfnpfgywbt1ymaugeef
X-Rspam-User: 
X-HE-Tag: 1787487518-862850
X-HE-Meta: U2FsdGVkX19Fq/wC1ySOpo5rOHLDNzG94q7kvktC7tNho6AenwBXM4hUR4I7prD2libd1GtXtJFOYqExdArZ1BhUl9Akzhor+FyuPTPphODeJ4SnuGXeHCabKbO4vSn/1bbNEmwD6FRLhBgFqsHZbfBQs/oYqsGSXVFzjPPQb5c1rUactluvBXK8wJavdXf2KSCEe8mdtsmEMLZI4FzW+DAe2HFIcaacsTuYXi05orIRxej0V402gOemaXdgQ6NrjA4PCZDPVyyQimttVrLCv6Bf4d2nDy+CskPtVaBLH0NuI0eOrf3UHNQPgAKeWRU4eZlQ9dssFtv+vxHe84xsmrMikoy79NJQhpM1Q4uBVqZNFcOWrXuGW7rcZ1RTKFIP+e/cckBdq2uBmh12zE/06R4ju9Sel8ZPyGGyN+bINEBkCH3/v4U/OmVbvdb6ySYil38v66X1CXVCpwfFBZjcwh1wBG3QvYAkO5tuEw6ANljEb5fe5ygr5nIG1sfbG4qi05KW5Qy6dLBnZtUas1IgWfr3pgF/abB5jv0m3ssxcjnkIBiV29BqGiGAOTWnqtiTXERkSKyL2JQPtSMOvt0DU5jm7Ozuy2JJUxY6heNOPVlmZPjTvysXNQ9zexG4XS6/vewwzjNC8YsDN9Jow4N1h1zodo95fnSaSCiygoqrPiB6H/bFUF73i3zy2kwviDN2zwRFd5+Bj+UQWp6uf3oe/rGRNtx+wAFw/SIaVFu0aUDNQgEyU38shMNLJlqhFh2Vm+FPaKvujuTNbZSamHUM9Ia874Is+SbAVodeEq6GCcQYn5CuwAqmas8SXfH8btn3G2cLpbLT2KupZGpiZYdFZzyaqsfOlxW0S+Z5kf+uk8ehvc+zWiCG/1XWSv/Qojq7ed9Nulx7n1ihkjOo75pd4qDpC2gNGsuaB/SKgBrZmuCIJ9LP9CewC9yWdutXx0PNSso6bDRYowoUqEFAv/E
 TMGl07ux
 raEbWC4iLtT095ljBwI2/ixGuD5v6JtEGAZHhlsAqwtNZQwQRIplcDDQA0UVNAFGEsIW/zT+suvT6iTIf1EeK7BgKs2k3rDYWV4HeRVi5BS5mF9M8kdV6nPCYGZjJyV6WKJbzLJmfGQu1axV61C7+AXCDCUAcXK/zGxC05A8it3nc9nohEy6MtlMHne9/K0SrrfpfBCsZqNYPWSDhSkDyO0AjWfiqGzN8AKYo3s76gQr5MuHWgSgO65RP/c96rzaakkpK/ORaqueTYE5y/NLWsYTBfGeztN9HHZKCSEvh7U4zjp1cJEqJM7X+/XYwAV2ks2iW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add 'mode' field to struct vm_uffd_state and define UFFD_MODE_ flags.

Use this field to differentiate VMA registration with userfaultfd
instead of relying on VM_UFFD_* flags.

A VMA registered with userfaultfd will have a single VM_UFFD flag set
and its registration mode (MISSING, MINOR, WP, RWP) is determined by
vm_uffd_state.mode.

This frees three vm_flags bits (12, 41, 43).

Update the relevant code to use UFFD_MODE_* instead of VM_UFFD_* flags.

Remove VM_UFFD_WP and VM_UFFD_RWP from VM_COPY_ON_FORK, adding an
explicit userfaultfd_protected() check in vma_needs_copy() instead.

/proc/pid/smaps representation of VmFlags is slightly changed:
- any VMA registered with UFFD shows 'uf'
- the existing userfault markers ('um', 'uw', 'ui', 'ur') are shown after
  VmFlags rather than in the middle

Assisted-by: copilot:claude-opus-4.6
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/proc/task_mmu.c              |  18 +++---
 include/linux/mm.h              |  67 +++++-----------------
 include/linux/mm_types.h        |   1 +
 include/linux/pgtable.h         |   4 +-
 include/linux/userfaultfd_k.h   |  37 +++++++-----
 include/trace/events/mmflags.h  |  17 +-----
 mm/gup.c                        |   5 +-
 mm/hugetlb.c                    |   2 +-
 mm/khugepaged.c                 |   2 +-
 mm/memory.c                     |   6 +-
 mm/mprotect.c                   |   2 +-
 mm/shmem.c                      |   2 +-
 mm/userfaultfd.c                | 123 +++++++++++++++++++++-------------------
 tools/testing/vma/include/dup.h |  18 ++----
 14 files changed, 134 insertions(+), 170 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5c54aebe2118..8d344c6ee14e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -23,6 +23,7 @@
 #include <linux/minmax.h>
 #include <linux/overflow.h>
 #include <linux/buildid.h>
+#include <linux/userfaultfd_k.h>
 
 #include <asm/elf.h>
 #include <asm/tlb.h>
@@ -1216,8 +1217,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_HUGEPAGE)]	= "hg",
 		[ilog2(VM_NOHUGEPAGE)]	= "nh",
 		[ilog2(VM_MERGEABLE)]	= "mg",
-		[ilog2(VM_UFFD_MISSING)]= "um",
-		[ilog2(VM_UFFD_WP)]	= "uw",
+		[ilog2(VM_UFFD)]	= "uf",
 #ifdef CONFIG_ARM64_MTE
 		[ilog2(VM_MTE)]		= "mt",
 		[ilog2(VM_MTE_ALLOWED)]	= "",
@@ -1234,12 +1234,6 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_PKEY_BIT4)]	= "",
 #endif
 #endif /* CONFIG_ARCH_HAS_PKEYS */
-#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-		[ilog2(VM_UFFD_MINOR)]	= "ui",
-#endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
-#ifdef CONFIG_USERFAULTFD_RWP
-		[ilog2(VM_UFFD_RWP)]	= "ur",
-#endif
 #ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
 		[ilog2(VM_SHADOW_STACK)] = "ss",
 #endif
@@ -1259,6 +1253,14 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		if (vma->vm_flags & (1UL << i))
 			seq_printf(m, "%s ", mnemonics[i]);
 	}
+	if (userfaultfd_missing(vma))
+		seq_puts(m, "um ");
+	if (userfaultfd_wp(vma))
+		seq_puts(m, "uw ");
+	if (userfaultfd_minor(vma))
+		seq_puts(m, "ui ");
+	if (userfaultfd_rwp(vma))
+		seq_puts(m, "ur ");
 	seq_putc(m, '\n');
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4daf9cd6ae8e..416de7663951 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -303,7 +303,7 @@ enum {
 	DECLARE_VMA_BIT(MAYSHARE, 7),
 	DECLARE_VMA_BIT(GROWSDOWN, 8),	/* general info on the segment */
 #ifdef CONFIG_MMU
-	DECLARE_VMA_BIT(UFFD_MISSING, 9),/* missing pages tracking */
+	DECLARE_VMA_BIT(UFFD, 9),	/* userfaultfd registered */
 #else
 	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
 	DECLARE_VMA_BIT(MAYOVERLAY, 9),
@@ -311,7 +311,7 @@ enum {
 	/* Page-ranges managed without "struct page", just pure PFN */
 	DECLARE_VMA_BIT(PFNMAP, 10),
 	DECLARE_VMA_BIT(MAYBE_GUARD, 11),
-	DECLARE_VMA_BIT(UFFD_WP, 12),	/* wrprotect pages tracking */
+	/* Bit 12 is free */
 	DECLARE_VMA_BIT(LOCKED, 13),
 	DECLARE_VMA_BIT(IO, 14),	/* Memory mapped I/O or similar */
 	DECLARE_VMA_BIT(SEQ_READ, 15),	/* App will access data sequentially */
@@ -352,9 +352,8 @@ enum {
 #elif defined(CONFIG_64BIT)
 	DECLARE_VMA_BIT(DROPPABLE, 40),
 #endif
-	DECLARE_VMA_BIT(UFFD_MINOR, 41),
+	/* Bits 41 and 43 are free */
 	DECLARE_VMA_BIT(SEALED, 42),
-	DECLARE_VMA_BIT(UFFD_RWP, 43),
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -408,14 +407,14 @@ enum {
 #define VM_MAYSHARE	INIT_VM_FLAG(MAYSHARE)
 #define VM_GROWSDOWN	INIT_VM_FLAG(GROWSDOWN)
 #ifdef CONFIG_MMU
-#define VM_UFFD_MISSING	INIT_VM_FLAG(UFFD_MISSING)
+#define VM_UFFD		INIT_VM_FLAG(UFFD)
+#define VMA_UFFD	mk_vma_flags(VMA_UFFD_BIT)
 #else
-#define VM_UFFD_MISSING	VM_NONE
+#define VM_UFFD		VM_NONE
 #define VM_MAYOVERLAY	INIT_VM_FLAG(MAYOVERLAY)
 #endif
 #define VM_PFNMAP	INIT_VM_FLAG(PFNMAP)
 #define VM_MAYBE_GUARD	INIT_VM_FLAG(MAYBE_GUARD)
-#define VM_UFFD_WP	INIT_VM_FLAG(UFFD_WP)
 #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
 #define VM_IO		INIT_VM_FLAG(IO)
 #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
@@ -499,36 +498,6 @@ enum {
 #define VM_MTE		VM_NONE
 #define VM_MTE_ALLOWED	VM_NONE
 #endif
-#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-#define VM_UFFD_MINOR	INIT_VM_FLAG(UFFD_MINOR)
-#else
-#define VM_UFFD_MINOR	VM_NONE
-#endif
-#ifdef CONFIG_USERFAULTFD_RWP
-#define VM_UFFD_RWP		INIT_VM_FLAG(UFFD_RWP)
-#else
-#define VM_UFFD_RWP		VM_NONE
-#endif
-
-/*
- * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
- * gated on the same configs as their VM_* flags above -- both of which imply
- * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
- * whose bitmap cannot hold it.
- */
-#define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
-#define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
-#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-#define VMA_UFFD_MINOR		mk_vma_flags(VMA_UFFD_MINOR_BIT)
-#else
-#define VMA_UFFD_MINOR		EMPTY_VMA_FLAGS
-#endif
-#ifdef CONFIG_USERFAULTFD_RWP
-#define VMA_UFFD_RWP		mk_vma_flags(VMA_UFFD_RWP_BIT)
-#else
-#define VMA_UFFD_RWP		EMPTY_VMA_FLAGS
-#endif
-
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
 #define VM_SEALED		INIT_VM_FLAG(SEALED)
@@ -668,32 +637,26 @@ enum {
  * reconsistuted upon page fault, so necessitate page table copying upon fork.
  *
  * Note that these flags should be compared with the DESTINATION VMA not the
- * source: VM_UFFD_WP and VM_UFFD_RWP may be cleared on the destination
+ * source: uffd WP/RWP mode may be cleared on the destination
  * (dup_userfaultfd() -> userfaultfd_reset_ctx() when the parent context did
  * not negotiate UFFD_FEATURE_EVENT_FORK), while all other flags propagate.
  *
  * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
  *                           reasonably reconstructed on page fault.
  *
- *              VM_UFFD_WP - Encodes metadata about an installed uffd
- *              VM_UFFD_RWP  write- or read-write-protect handler, which
- *                           cannot be reconstructed on page fault.
- *
- *                           We always copy pgtables when dst_vma has the
- *                           uffd PTE bit in use even if it's file-backed
- *                           (e.g. shmem). Because when the uffd bit is
- *                           in use, the pgtable contains the protection
- *                           information, that's something we can't
- *                           retrieve from page cache, and skip copying
- *                           will lose those info.
- *
  *          VM_MAYBE_GUARD - Could contain page guard region markers which
  *                           by design are a property of the page tables
  *                           only and thus cannot be reconstructed on page
  *                           fault.
+ *
+ *       uffd WP/RWP modes - Encode metadata about an installed uffd
+ *                           write- or read-write-protect handler, which
+ *                           cannot be reconstructed on page fault.
+ *                           This is checked separately via
+ *                           userfaultfd_protected() in vma_needs_copy().
+ *
  */
-#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
-			 VM_MAYBE_GUARD)
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_MAYBE_GUARD)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d6deb655d82e..8354d1c18b29 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -723,6 +723,7 @@ struct vm_region {
 #define NULL_VM_UFFD_STATE ((struct vm_uffd_state) { NULL, })
 struct vm_uffd_state {
 	struct userfaultfd_ctx *ctx;
+	unsigned int mode;
 };
 #else /* CONFIG_USERFAULTFD */
 #define NULL_VM_UFFD_STATE ((struct vm_uffd_state) {})
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..4b74c298cc14 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2119,8 +2119,8 @@ static inline int pud_trans_unstable(pud_t *pud)
  * In an accessible VMA, pte_protnone() reliably indicates a present
  * PROT_NONE page protection. Today the kernel uses such PTEs for two
  * purposes: NUMA hinting faults, and userfaultfd RWP tracking on
- * VM_UFFD_RWP VMAs. The two are distinguished by the uffd PTE bit and
- * the VMA flag; see include/linux/userfaultfd_k.h.
+ * uffd-RWP VMAs. The two are distinguished by the uffd PTE bit and
+ * the VMA uffd state; see include/linux/userfaultfd_k.h.
  *
  * So, to reliably identify PROT_NONE PTEs that require kernel handling,
  * looking at the VMA accessibility (and the uffd bit on RWP VMAs) is
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index f401623f315d..b4261038d10a 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -32,12 +32,13 @@ enum uf_reason {
 #include <asm-generic/pgtable_uffd.h>
 #include <linux/hugetlb_inline.h>
 
-/* The set of all possible UFFD-related VM flags. */
-#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
-			 VM_UFFD_WP | VM_UFFD_RWP)
-
-#define __VMA_UFFD_FLAGS mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP, \
-						 VMA_UFFD_MINOR, VMA_UFFD_RWP)
+/* Per-VMA uffd modes */
+#define UFFD_MODE_MISSING	BIT(0)
+#define UFFD_MODE_MINOR		BIT(1)
+#define UFFD_MODE_RWP		BIT(2)
+#define UFFD_MODE_WP		BIT(3)
+#define UFFD_MODE_ALL		(UFFD_MODE_MISSING | UFFD_MODE_MINOR | \
+				 UFFD_MODE_RWP | UFFD_MODE_WP)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -99,7 +100,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, enum uf_reason reason);
 /* VMA userfaultfd operations */
 struct vm_uffd_ops {
 	/* Checks if a VMA can support userfaultfd */
-	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
+	bool (*can_userfault)(struct vm_area_struct *vma, unsigned int mode);
 	/*
 	 * Called to resolve UFFDIO_CONTINUE request.
 	 * Should return the folio found at pgoff in the VMA's pagecache if it
@@ -174,25 +175,34 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 			unsigned long dst_addr, unsigned long src_addr);
 
 /* mm helpers */
+static inline unsigned int uffd_mode(const struct vm_area_struct *vma)
+{
+	return vma->vm_uffd_state.mode;
+}
+
 static inline bool is_mergeable_vm_uffd_state(struct vm_area_struct *vma,
 					struct vm_uffd_state vm_ctx)
 {
-	return vma->vm_uffd_state.ctx == vm_ctx.ctx;
+	return vma->vm_uffd_state.ctx == vm_ctx.ctx &&
+	       uffd_mode(vma) == vm_ctx.mode;
 }
 
 static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
+	return vma_test(vma, VMA_UFFD_BIT) &&
+	       (uffd_mode(vma) & UFFD_MODE_MISSING);
 }
 
 static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma, VMA_UFFD_WP);
+	return vma_test(vma, VMA_UFFD_BIT) &&
+	       (uffd_mode(vma) & UFFD_MODE_WP);
 }
 
 static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
+	return vma_test(vma, VMA_UFFD_BIT) &&
+	       (uffd_mode(vma) & UFFD_MODE_MINOR);
 }
 
 static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
@@ -203,7 +213,8 @@ static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
 	 */
 	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return false;
-	return vma_test_single_mask(vma, VMA_UFFD_RWP);
+	return vma_test(vma, VMA_UFFD_BIT) &&
+	       (uffd_mode(vma) & UFFD_MODE_RWP);
 }
 
 static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
@@ -271,7 +282,7 @@ static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
 
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
+	return vma_test(vma, VMA_UFFD_BIT);
 }
 
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 935893e5ea53..aacdd90e0a64 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -180,18 +180,6 @@ IF_HAVE_PG_ARCH_3(arch_3)
 #define IF_HAVE_VM_SOFTDIRTY(flag,name)
 #endif
 
-#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-# define IF_HAVE_UFFD_MINOR(flag, name) {flag, name},
-#else
-# define IF_HAVE_UFFD_MINOR(flag, name)
-#endif
-
-#ifdef CONFIG_USERFAULTFD_RWP
-# define IF_HAVE_UFFD_RWP(flag, name) {flag, name},
-#else
-# define IF_HAVE_UFFD_RWP(flag, name)
-#endif
-
 #if defined(CONFIG_64BIT) || defined(CONFIG_PPC32)
 # define IF_HAVE_VM_DROPPABLE(flag, name) {flag, name},
 #else
@@ -208,12 +196,9 @@ IF_HAVE_PG_ARCH_3(arch_3)
 	{VM_MAYEXEC,			"mayexec"	},		\
 	{VM_MAYSHARE,			"mayshare"	},		\
 	{VM_GROWSDOWN,			"growsdown"	},		\
-	{VM_UFFD_MISSING,		"uffd_missing"	},		\
-IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
+	{VM_UFFD,			"uffd"		},		\
 	{VM_PFNMAP,			"pfnmap"	},		\
 	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
-	{VM_UFFD_WP,			"uffd_wp"	},		\
-IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
 	{VM_SEQ_READ,			"seqread"	},		\
diff --git a/mm/gup.c b/mm/gup.c
index 500e2aa99e48..9243c41a0c0e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -12,6 +12,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/secretmem.h>
+#include <linux/userfaultfd_k.h>
 
 #include <linux/sched/signal.h>
 #include <linux/rwsem.h>
@@ -641,7 +642,7 @@ static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
 					   unsigned int flags)
 {
 	/*
-	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
+	 * uffd-RWP uses protnone as an access-tracking marker, not for
 	 * NUMA hinting. GUP must always take a fault so the access is
 	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
 	 *
@@ -651,7 +652,7 @@ static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
 	 * no progress on protnone in an inaccessible VMA, and the access is
 	 * denied regardless of RWP anyway.
 	 */
-	if (vma_test_single_mask(vma, VMA_UFFD_RWP) && vma_is_accessible(vma))
+	if (userfaultfd_rwp(vma) && vma_is_accessible(vma))
 		return false;
 
 	/*
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5e2ed80c1938..a15c443474d5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4808,7 +4808,7 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
 
 #ifdef CONFIG_USERFAULTFD
 static bool hugetlb_can_userfault(struct vm_area_struct *vma,
-				  vm_flags_t vm_flags)
+				  unsigned int mode)
 {
 	return true;
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 79effd3f3da4..7f590a1d3ca3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2112,7 +2112,7 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 	/*
 	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
 	 * the page table because there may be pte markers installed.
-	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
+	 * uffd-RWP ranges similarly rely on per-PTE uffd state
 	 * and cannot be recycled to a shared PMD. Other vmas can still
 	 * have the same file mapped hugely, but skip this one: it will
 	 * always be mapped in small page size for these registrations.
diff --git a/mm/memory.c b/mm/memory.c
index 1a9b41704b0c..c12ec979199c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1565,10 +1565,12 @@ vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	/*
 	 * We check against dst_vma as while sane VMA flags will have been
-	 * copied, VM_UFFD_WP may be set only on dst_vma.
+	 * copied, userfaultfd WP/RWP mode may be set only on dst_vma.
 	 */
 	if (dst_vma->vm_flags & VM_COPY_ON_FORK)
 		return true;
+	if (userfaultfd_protected(dst_vma))
+		return true;
 	/*
 	 * The presence of an anon_vma indicates an anonymous VMA has page
 	 * tables which naturally cannot be reconstituted on page fault.
@@ -6563,7 +6565,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma)) {
 		/*
 		 * RWP-protected PTEs are protnone plus the uffd bit. On a
-		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
+		 * uffd-RWP VMA, a protnone PTE without the uffd bit is
 		 * NUMA hinting and must still fall through to do_numa_page().
 		 */
 		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..b98d4372677b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -297,7 +297,7 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 		ptent = pte_clear_uffd(ptent);
 
 	/*
-	 * The uffd bit on a VM_UFFD_RWP VMA carries PROT_NONE
+	 * The uffd bit on a uffd-RWP VMA carries PROT_NONE
 	 * semantics. If mprotect() or NUMA hinting changed the
 	 * base protection, restore PAGE_NONE so the PTE still
 	 * traps on any access. pte_modify() preserves
diff --git a/mm/shmem.c b/mm/shmem.c
index 2138a4e6b549..c8db9f93dde1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3220,7 +3220,7 @@ static struct folio *shmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
 	return folio;
 }
 
-static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+static bool shmem_can_userfault(struct vm_area_struct *vma, unsigned int mode)
 {
 	return true;
 }
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 83587d34b189..193f6e65d875 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -50,10 +50,10 @@ struct mfill_state {
 	pmd_t *pmd;
 };
 
-static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
+static bool anon_can_userfault(struct vm_area_struct *vma, unsigned int mode)
 {
 	/* anonymous memory does not support MINOR mode */
-	if (vm_flags & VM_UFFD_MINOR)
+	if (mode & UFFD_MODE_MINOR)
 		return false;
 	return true;
 }
@@ -462,7 +462,7 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 }
 
 #define MFILL_RETRY_STATE_VMA_FLAGS \
-	append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
+	append_vma_flags(VMA_UFFD, VMA_SHARED_BIT)
 
 /*
  * VMA state saved before dropping the locks in mfill_copy_folio_retry().
@@ -2194,7 +2194,7 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	return moved ? moved : err;
 }
 
-static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+static bool vma_can_userfault(struct vm_area_struct *vma, unsigned int mode,
 		       bool wp_async)
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
@@ -2205,13 +2205,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
 		return false;
 
-	vm_flags &= __VM_UFFD_FLAGS;
-
 	/*
 	 * If WP is the only mode enabled and context is wp async, allow any
 	 * memory type.
 	 */
-	if (wp_async && (vm_flags == VM_UFFD_WP))
+	if (wp_async && (mode == UFFD_MODE_WP))
 		return true;
 
 	/* For any other mode reject VMAs that don't implement vm_uffd_ops */
@@ -2222,19 +2220,31 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	 * If user requested uffd-wp but not enabled pte markers for
 	 * uffd-wp, then only anonymous memory is supported
 	 */
-	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
+	if (!uffd_supports_wp_marker() && (mode & UFFD_MODE_WP) &&
 	    !vma_is_anonymous(vma))
 		return false;
 
-	return ops->can_userfault(vma, vm_flags);
+	return ops->can_userfault(vma, mode);
 }
 
-static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
-				     vm_flags_t vm_flags)
+static void userfaultfd_set_ctx(struct vm_area_struct *vma,
+				struct userfaultfd_ctx *ctx,
+				unsigned int mode)
 {
-	const bool uffd_wp_changed = (vma->vm_flags ^ vm_flags) & VM_UFFD_WP;
+	const bool uffd_wp_changed = (uffd_mode(vma) ^ mode) & UFFD_MODE_WP;
+
+	vma_start_write(vma);
+
+	vma->vm_uffd_state = (struct vm_uffd_state){
+		.ctx = ctx,
+		.mode = mode,
+	};
+
+	if (mode)
+		vma_set_flags(vma, VMA_UFFD_BIT);
+	else
+		vma_clear_flags(vma, VMA_UFFD_BIT);
 
-	vm_flags_reset(vma, vm_flags);
 	/*
 	 * For shared mappings, we want to enable writenotify while
 	 * userfaultfd-wp is enabled (see vma_wants_writenotify()). We'll simply
@@ -2244,16 +2254,6 @@ static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
 		vma_set_page_prot(vma);
 }
 
-static void userfaultfd_set_ctx(struct vm_area_struct *vma,
-				struct userfaultfd_ctx *ctx,
-				vm_flags_t vm_flags)
-{
-	vma_start_write(vma);
-	vma->vm_uffd_state = (struct vm_uffd_state){ctx};
-	userfaultfd_set_vm_flags(vma,
-				 (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags);
-}
-
 static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
 {
 	userfaultfd_set_ctx(vma, NULL, 0);
@@ -2269,7 +2269,7 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 	bool give_up_on_oom = false;
 	vma_flags_t new_vma_flags = vma->flags;
 
-	vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
+	vma_flags_clear_mask(&new_vma_flags, VMA_UFFD);
 
 	/*
 	 * If we are modifying only and not splitting, just give up on the merge
@@ -2313,11 +2313,10 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 /* Assumes mmap write lock taken, and mm_struct pinned. */
 static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 			       struct vm_area_struct *vma,
-			       vm_flags_t vm_flags,
+			       unsigned int mode,
 			       unsigned long start, unsigned long end,
 			       bool wp_async)
 {
-	vma_flags_t vma_flags = legacy_to_vma_flags(vm_flags);
 	VMA_ITERATOR(vmi, ctx->mm, start);
 	struct vm_area_struct *prev = vma_prev(&vmi);
 	unsigned long vma_end;
@@ -2329,7 +2328,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 	for_each_vma_range(vmi, vma, end) {
 		cond_resched();
 
-		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
+		VM_WARN_ON_ONCE(!vma_can_userfault(vma, mode, wp_async));
 		VM_WARN_ON_ONCE(vma->vm_uffd_state.ctx &&
 				vma->vm_uffd_state.ctx != ctx);
 		VM_WARN_ON_ONCE(!vma_test(vma, VMA_MAYWRITE_BIT));
@@ -2339,28 +2338,31 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_uffd_state.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    (uffd_mode(vma) & mode) == mode)
 			goto skip;
 
 		/*
 		 * Pre-scan in userfaultfd_register() already rejected mode
-		 * switches that would drop VM_UFFD_WP or VM_UFFD_RWP, so a
-		 * stray bit here is a bug.
+		 * switches that would drop WP or RWP, so a stray bit here
+		 * is a bug.
 		 */
 		VM_WARN_ON_ONCE(vma->vm_uffd_state.ctx == ctx &&
-				vma->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags);
+				uffd_mode(vma) &
+				(UFFD_MODE_WP | UFFD_MODE_RWP) & ~mode);
 
 		if (vma->vm_start > start)
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
 		new_vma_flags = vma->flags;
-		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
-		vma_flags_set_mask(&new_vma_flags, vma_flags);
+		vma_flags_set_mask(&new_vma_flags, VMA_UFFD);
 
 		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
 					    &new_vma_flags,
-					    (struct vm_uffd_state){ctx},
+					    (struct vm_uffd_state){
+						.ctx = ctx,
+						.mode = mode,
+					    },
 					    /* give_up_on_oom = */false);
 		if (IS_ERR(vma))
 			return PTR_ERR(vma);
@@ -2370,7 +2372,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * the next vma was merged into the current one and
 		 * the current one has not been updated yet.
 		 */
-		userfaultfd_set_ctx(vma, ctx, vm_flags);
+		userfaultfd_set_ctx(vma, ctx, mode);
 
 		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
 			hugetlb_unshare_all_pmds(vma);
@@ -2420,7 +2422,7 @@ static void userfaultfd_release_all(struct mm_struct *mm,
 	for_each_vma(vmi, vma) {
 		cond_resched();
 		VM_WARN_ON_ONCE(!!vma->vm_uffd_state.ctx ^
-				!!(vma->vm_flags & __VM_UFFD_FLAGS));
+				vma_test(vma, VMA_UFFD_BIT));
 		if (vma->vm_uffd_state.ctx != ctx) {
 			prev = vma;
 			continue;
@@ -2876,9 +2878,9 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, enum uf_reason reason)
 	 * NOTE: it should become possible to return VM_FAULT_RETRY
 	 * even if FAULT_FLAG_TRIED is set without leading to gup()
 	 * -EBUSY failures, if the userfaultfd is to be extended for
-	 * VM_UFFD_WP tracking and we intend to arm the userfault
+	 * WP tracking and we intend to arm the userfault
 	 * without first stopping userland access to the memory. For
-	 * VM_UFFD_MISSING userfaults this is enough for now.
+	 * MISSING userfaults this is enough for now.
 	 */
 	if (unlikely(!(vmf->flags & FAULT_FLAG_ALLOW_RETRY))) {
 		/*
@@ -3723,7 +3725,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	int ret;
 	struct uffdio_register uffdio_register;
 	struct uffdio_register __user *user_uffdio_register;
-	vm_flags_t vm_flags;
+	unsigned int mode;
 	bool found;
 	bool basic_ioctls;
 	unsigned long start, end;
@@ -3742,21 +3744,22 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		goto out;
 	if (uffdio_register.mode & ~UFFD_API_REGISTER_MODES)
 		goto out;
-	vm_flags = 0;
+	mode = 0;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
-		vm_flags |= VM_UFFD_MISSING;
+		mode |= UFFD_MODE_MISSING;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP) {
 		if (!pgtable_supports_uffd())
 			goto out;
 
-		vm_flags |= VM_UFFD_WP;
+		mode |= UFFD_MODE_WP;
 	}
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP) {
-		if (!pgtable_supports_uffd() || VM_UFFD_RWP == VM_NONE)
+		if (!pgtable_supports_uffd() ||
+		    !IS_ENABLED(CONFIG_USERFAULTFD_RWP))
 			goto out;
 		if (!(userfaultfd_features(ctx) & UFFD_FEATURE_RWP))
 			goto out;
-		vm_flags |= VM_UFFD_RWP;
+		mode |= UFFD_MODE_RWP;
 	}
 
 	/*
@@ -3764,14 +3767,14 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	 * cannot coexist in the same VMA — the bit would carry ambiguous
 	 * semantics. Reject the combination up front.
 	 */
-	if ((vm_flags & VM_UFFD_WP) && (vm_flags & VM_UFFD_RWP))
+	if ((mode & UFFD_MODE_WP) && (mode & UFFD_MODE_RWP))
 		goto out;
 
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR) {
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 		goto out;
 #endif
-		vm_flags |= VM_UFFD_MINOR;
+		mode |= UFFD_MODE_MINOR;
 	}
 
 	ret = validate_range(mm, uffdio_register.range.start,
@@ -3814,11 +3817,11 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		cond_resched();
 
 		VM_WARN_ON_ONCE(!!cur->vm_uffd_state.ctx ^
-				!!(cur->vm_flags & __VM_UFFD_FLAGS));
+				vma_test(cur, VMA_UFFD_BIT));
 
 		/* check not compatible vmas */
 		ret = -EINVAL;
-		if (!vma_can_userfault(cur, vm_flags, wp_async))
+		if (!vma_can_userfault(cur, mode, wp_async))
 			goto out_unlock;
 
 		/*
@@ -3829,7 +3832,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 * mprotect() must still be unregisterable, so this is not
 		 * part of vma_can_userfault().
 		 */
-		if ((vm_flags & VM_UFFD_RWP) && !vma_is_accessible(cur))
+		if ((mode & UFFD_MODE_RWP) && !vma_is_accessible(cur))
 			goto out_unlock;
 
 		/*
@@ -3857,7 +3860,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 			if (end & (vma_hpagesize - 1))
 				goto out_unlock;
 		}
-		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
+		if ((mode & UFFD_MODE_WP) &&
+		    !vma_test(cur, VMA_MAYWRITE_BIT))
 			goto out_unlock;
 
 		/*
@@ -3872,13 +3876,13 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 			goto out_unlock;
 
 		/*
-		 * Mode switches that drop VM_UFFD_WP or VM_UFFD_RWP would
-		 * leave PTE markers without the flag that describes them;
+		 * Mode switches that drop WP or RWP would leave PTE markers
+		 * without the mode that describes them;
 		 * subsequent mprotect() would then promote stale markers
 		 * into the other mode. Require an unregister first.
 		 */
 		if (cur->vm_uffd_state.ctx == ctx &&
-		    cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags)
+		    uffd_mode(cur) & (UFFD_MODE_WP | UFFD_MODE_RWP) & ~mode)
 			goto out_unlock;
 
 		/*
@@ -3891,7 +3895,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	} for_each_vma_range(vmi, cur, end);
 	VM_WARN_ON_ONCE(!found);
 
-	ret = userfaultfd_register_range(ctx, vma, vm_flags, start, end,
+	ret = userfaultfd_register_range(ctx, vma, mode, start, end,
 					 wp_async);
 
 out_unlock:
@@ -3986,7 +3990,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		cond_resched();
 
 		VM_WARN_ON_ONCE(!!cur->vm_uffd_state.ctx ^
-				!!(cur->vm_flags & __VM_UFFD_FLAGS));
+				vma_test(cur, VMA_UFFD_BIT));
 
 		/*
 		 * Prevent unregistering through a different userfaultfd than
@@ -4003,7 +4007,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		 * provides for more strict behavior to notice
 		 * unregistration errors.
 		 */
-		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
+		if (!vma_can_userfault(cur, uffd_mode(cur), wp_async))
 			goto out_unlock;
 
 		found = true;
@@ -4024,7 +4028,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 			goto skip;
 
 		VM_WARN_ON_ONCE(vma->vm_uffd_state.ctx != ctx);
-		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vma->vm_flags, wp_async));
+		VM_WARN_ON_ONCE(!vma_can_userfault(vma, uffd_mode(vma),
+						   wp_async));
 		VM_WARN_ON_ONCE(!(vma->vm_flags & VM_MAYWRITE));
 
 		if (vma->vm_start > start)
@@ -4329,12 +4334,12 @@ static __u64 uffd_api_available_features(void)
 		       UFFD_FEATURE_WP_ASYNC);
 	/*
 	 * RWP needs both PROT_NONE support and the uffd PTE bit. The
-	 * VM_UFFD_RWP check covers compile-time unavailability; the
+	 * IS_ENABLED check covers compile-time unavailability; the
 	 * pgtable_supports_uffd() check covers runtime (e.g. riscv
 	 * without the SVRSW60T59B extension) where the PTE bit is declared
 	 * but not actually usable.
 	 */
-	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
+	if (!IS_ENABLED(CONFIG_USERFAULTFD_RWP) || !pgtable_supports_uffd())
 		f &= ~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
 	return f;
 }
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 1a01c3529d22..05a39c14eab2 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -109,7 +109,7 @@ enum {
 	DECLARE_VMA_BIT(MAYSHARE, 7),
 	DECLARE_VMA_BIT(GROWSDOWN, 8),	/* general info on the segment */
 #ifdef CONFIG_MMU
-	DECLARE_VMA_BIT(UFFD_MISSING, 9),/* missing pages tracking */
+	DECLARE_VMA_BIT(UFFD, 9),	/* userfaultfd registered */
 #else
 	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
 	DECLARE_VMA_BIT(MAYOVERLAY, 9),
@@ -117,7 +117,7 @@ enum {
 	/* Page-ranges managed without "struct page", just pure PFN */
 	DECLARE_VMA_BIT(PFNMAP, 10),
 	DECLARE_VMA_BIT(MAYBE_GUARD, 11),
-	DECLARE_VMA_BIT(UFFD_WP, 12),	/* wrprotect pages tracking */
+	/* Bit 12 is free */
 	DECLARE_VMA_BIT(LOCKED, 13),
 	DECLARE_VMA_BIT(IO, 14),	/* Memory mapped I/O or similar */
 	DECLARE_VMA_BIT(SEQ_READ, 15),	/* App will access data sequentially */
@@ -158,7 +158,7 @@ enum {
 #else
 	DECLARE_VMA_BIT(DROPPABLE, 40),
 #endif
-	DECLARE_VMA_BIT(UFFD_MINOR, 41),
+	/* Bit 41 is free */
 	DECLARE_VMA_BIT(SEALED, 42),
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
@@ -211,14 +211,13 @@ enum {
 #define VM_MAYSHARE	INIT_VM_FLAG(MAYSHARE)
 #define VM_GROWSDOWN	INIT_VM_FLAG(GROWSDOWN)
 #ifdef CONFIG_MMU
-#define VM_UFFD_MISSING	INIT_VM_FLAG(UFFD_MISSING)
+#define VM_UFFD		INIT_VM_FLAG(UFFD)
 #else
-#define VM_UFFD_MISSING	VM_NONE
+#define VM_UFFD		VM_NONE
 #define VM_MAYOVERLAY	INIT_VM_FLAG(MAYOVERLAY)
 #endif
 #define VM_PFNMAP	INIT_VM_FLAG(PFNMAP)
 #define VM_MAYBE_GUARD	INIT_VM_FLAG(MAYBE_GUARD)
-#define VM_UFFD_WP	INIT_VM_FLAG(UFFD_WP)
 #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
 #define VM_IO		INIT_VM_FLAG(IO)
 #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
@@ -297,11 +296,6 @@ enum {
 #define VM_MTE		VM_NONE
 #define VM_MTE_ALLOWED	VM_NONE
 #endif
-#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-#define VM_UFFD_MINOR	INIT_VM_FLAG(UFFD_MINOR)
-#else
-#define VM_UFFD_MINOR	VM_NONE
-#endif
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
 #define VM_SEALED		INIT_VM_FLAG(SEALED)
@@ -387,7 +381,7 @@ enum {
 
 #define VMA_IGNORE_MERGE_FLAGS VMA_STICKY_FLAGS
 
-#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_MAYBE_GUARD)
 
 #define pgprot_val(x)		((x).pgprot)
 #define __pgprot(x)		((pgprot_t) { (x) } )

-- 
2.53.0


