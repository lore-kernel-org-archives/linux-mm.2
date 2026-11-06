Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC26606A32F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 23:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hR6TU7bz
Received: by kanga.kvack.org (Postfix)
	id 8B5B16B05B2; Fri,  6 Nov 2026 18:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B6E6B05B3; Fri,  6 Nov 2026 18:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A08A6B05B4; Fri,  6 Nov 2026 18:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 525046B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:51:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFF2B1A01B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:51:30 +0000 (UTC)
X-FDA: 85406343540.19.BE648AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1BE2320002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:51:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hR6TU7bz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794009089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rSAlH+rpdY7d5l8sFyMgLRb6S9qO/Wommr86WZPpIc=;
	b=U07+Si862+RjMUWmIjJig7Zp1jmd4wu+pVpGMiNSVSuA6rZ7Ilz/CUOoYgRdGi7ioRjv6K
	ZWY6JlkuuBYvDrbQBrFOypL6tHihjEWq0wVwePV0PH3sDzy+spGtX9BaFFu+ZUV6dryn0H
	y1NSFzMSRUkZsu7Gsg2/KqYg0qZ6R9s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794009089;
	b=3VWZuuG+xijJATegMA+Ksi6VR0u5rELnsyhpH0CG9j5WJyoCzciREyBGA58GlCva2rLtGd
	L/8oCyYRoshKFm7AItIohjOAdEkwG1vDLH732uOq5+Wy8hcTQQMAACwmK639IphFGHN1pn
	pUbAf7Yzt50JAcZmPIOgu+9PjSNY2c4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hR6TU7bz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8672260E03;
	Fri,  6 Nov 2026 23:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F7B1F008A1;
	Fri,  6 Nov 2026 23:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794009088;
	bh=2rSAlH+rpdY7d5l8sFyMgLRb6S9qO/Wommr86WZPpIc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hR6TU7bzhNPz5wQS6L9T7RqlsAUzbuit+RV0MGyGOKk5U2zxbL8MyslEEqhNON24G
	 Lr5BLvN0TQnKNnlWEhY2aq+wHSg+Zw82T4aTzwEq1TZl/H7PZtdlAz8CPm6upDXZuQ
	 wmYrHy4+qw4t3IV5ZWjxD1qqY5lB1Zj/9fQFPrQZnAOCtkU2ocIbkkT/gVRPmKMbIf
	 gIIjQSnTQYr0d9mt7wRb9KUYJdIS3uyyD5aMjY+Rc3HjGd0PO2EIJDbmKgCjc4RtAY
	 /A2qESedaLLG5wF20woSvAKayhIHib60oF9Q0pjE/CJ8pwcGOaXRMjEkk3ZT9Gbnsb
	 3JCmNCKIxOlbw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 07 Nov 2026 00:51:05 +0100
Subject: [PATCH 1/2] mm/userfaultfd: prevent poison marker loss
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
In-Reply-To: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Peter Xu <peterx@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14533; i=david@kernel.org;
 h=from:subject:message-id; bh=tyamf4jNtSQa/bunIVCUe+WjTQ1ELhQ4Fr28PhlBeCM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLepb81iYt6N19AWPZh8oK7h5M8l3x61uF/vPTtlW9LJ
 zzYGaH3r6OUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJxGgx/NOeWXKCe9t9S8cv
 D3cxTK1tfhn9jGPL83vPjdZ9iRPOvraOkWHmXuMrDqmzbB90Pyt8pzrn+v69iyIePW+4GP75XYv
 O0SImAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: 3iwrbfz6ouxycmafkw7btwuoxqf4ffta
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BE2320002
X-HE-Tag: 1794009088-539312
X-HE-Meta: U2FsdGVkX19KbUCNBGUx5yohpw/Ke+ieBG0yM+VUwwirAF2wpa3QTzWPgKMPeAIQoDkcPNa6EFeLMYmA7spaO5v2CiKkAA/+hwqfwLIabgom9muBxSo/w4geEmzLCQYlCtEP20Vc5AtaX01Ywo3yn7jDUXvfpwHvS8al4Q4sdqTa3Y+ZXnshfET0vTdhDDZ4e7GTl2Wi9HSGmCdCscemigC40OkIwQzDNUyh6AxDJRxx7b9KArVQdKmYyx+bShAQzzfHJmXWI42VxTigSNgtDToMa+Be4r0lArvCQAKi1/ACl2tuLTLq7AysybdH7MnxT1jM68LLZyqTPtmbU77JW5ScS0qsQkiu6XQSzy5A6T+MvmZadtBPi40O7qvN5fnETWMaprutR5FVK1vD3jSPyvEiqDY6ZhYW8Q+HxrKzcO2sct5xA24CjLRWNFEeFBD+0FhAgGqwnIb0yhwPIISva/mMEfCMnnnicJSB3Cs4FpO4pU1Ufm5CsSDhwjptsTbsdHMFvcvbZeV0MYdCvqh9Hxy1SY/u+kLxdqbXCUWq1HBhQqyLYfvfFos42tc0GfZ6tgK3e2kCSDHhwfq15HsI1zHTJyHm+Bh/ufBOWWW+2T9NkrHyjJ150NT9ODisYmLRGWRlv7QF0iIYnON1Bp9fTuP7IlT9mLetqsJKghkux5J1O4qZPqkFu2St68Bf6p5FepUhWvDNp/+npoZb9bvWmlelPaH6tnVbsCG6s7U6jjigMjPw3vq09LSvDcUO8Y8BwpWJRVjMil0fG0VG3x3fw/htqHodupSqe7lCxJdPO/bHjyktyRbd1M6lyVuKrJ39B47CXnJo1hrubmMA0zlVGuic3celNKfptig/jIcKNA6vWYsmkb/V9f/V24T+kDrZ11VyGa6Dvps+vNMv9n8Kzf+7zoLszq4ZI6eXFZTrxufu0TcjJro/Zn0tavfZTk05Zumja+m5db4jAaQPP7c
 Ipad3Uwj
 glsCAac+2m/dAG9FTRBWekWHGm7UQDn4UsZSJlQbSgwkOKkezf34DIEaHzuug73OYXSq6eX0L1GnaZ25q9iyZyblyYsMOsaeJhgYus7qR3z8v22q7cx94D5c9GzZwtZ5oqrutDMR+zXJKNalXZcvw2K6stUfzlabZkohz/XCDhj2okF3sgzY7yorFuQTv24v/dhpDAgMFw2NyvCDUxBDxctJl/wMPyE3COlMyJLsAPgofL/PPj9Bc/a+CYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unregistering userfaultfd leaves poison markers in the page tables.
However, once unregistered, hugetlb PMD tables can be shared again.

Further, shmem page-table retraction can discard poison markers even
while registered in missing mode, and fork() can skip copying page
tables containing poison markers.

To fix it, add VM_MAYBE_UFFD_POISON and set it before installing poison
markers. Preserve it across unregistration, splits, merges and fork(),
just like we do with guard markers.

Use the new atomic VMA flag to disable PMD sharing and page-table
retraction, and to force page-table copying during fork().

Move VM_UFFD_WP to bit 44 and make HAVE_ARCH_USERFAULTFD_WP depend on
64BIT, freeing bit 12 for the new flag on both 32-bit and 64-bit systems.
Expose the flag as "up" in smaps.

Losing poison markers, while unpleasant, is not really fatal, and the
use case is rather a niche thing. In addition, we rely on the atomic
VMA flags infrastructure ... so let's not CC stable.

Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/filesystems/proc.rst |  1 +
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/mm.h                 | 45 ++++++++++++++++++++++++--------------
 include/linux/userfaultfd_k.h      |  7 ++++--
 include/trace/events/mmflags.h     |  9 +++++++-
 mm/Kconfig                         |  1 +
 mm/khugepaged.c                    |  9 ++++----
 mm/userfaultfd.c                   |  3 +++
 tools/testing/vma/include/dup.h    | 20 ++++++++++++-----
 9 files changed, 70 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index fa7a468e8edf2..bcbcb41814d96 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -614,6 +614,7 @@ encoded manner. The codes are the following:
     lf    lock on fault pages
     dp    always lazily freeable mapping
     gu    maybe contains guard regions (if not set, definitely doesn't)
+    up    maybe contains poison markers installed by userfaultfd
     ==    =============================================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e3d894ed2b913..d7f9934d0e499 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1106,6 +1106,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_GROWSDOWN)]	= "gd",
 		[ilog2(VM_PFNMAP)]	= "pf",
 		[ilog2(VM_MAYBE_GUARD)]	= "gu",
+		[ilog2(VM_MAYBE_UFFD_POISON)]	= "up",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
@@ -1131,7 +1132,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_NOHUGEPAGE)]	= "nh",
 		[ilog2(VM_MERGEABLE)]	= "mg",
 		[ilog2(VM_UFFD_MISSING)]= "um",
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 		[ilog2(VM_UFFD_WP)]	= "uw",
+#endif
 #ifdef CONFIG_ARM64_MTE
 		[ilog2(VM_MTE)]		= "mt",
 		[ilog2(VM_MTE_ALLOWED)]	= "",
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6a34dd3800f56..6cd9d86f7adac 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -302,7 +302,7 @@ enum {
 	/* Page-ranges managed without "struct page", just pure PFN */
 	DECLARE_VMA_BIT(PFNMAP, 10),
 	DECLARE_VMA_BIT(MAYBE_GUARD, 11),
-	DECLARE_VMA_BIT(UFFD_WP, 12),	/* wrprotect pages tracking */
+	DECLARE_VMA_BIT(MAYBE_UFFD_POISON, 12),
 	DECLARE_VMA_BIT(LOCKED, 13),
 	DECLARE_VMA_BIT(IO, 14),	/* Memory mapped I/O or similar */
 	DECLARE_VMA_BIT(SEQ_READ, 15),	/* App will access data sequentially */
@@ -346,6 +346,7 @@ enum {
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
 	DECLARE_VMA_BIT(UFFD_RWP, 43),
+	DECLARE_VMA_BIT(UFFD_WP, 44),	/* wrprotect pages tracking */
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -406,7 +407,12 @@ enum {
 #endif
 #define VM_PFNMAP	INIT_VM_FLAG(PFNMAP)
 #define VM_MAYBE_GUARD	INIT_VM_FLAG(MAYBE_GUARD)
+#define VM_MAYBE_UFFD_POISON	INIT_VM_FLAG(MAYBE_UFFD_POISON)
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 #define VM_UFFD_WP	INIT_VM_FLAG(UFFD_WP)
+#else
+#define VM_UFFD_WP	VM_NONE
+#endif
 #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
 #define VM_IO		INIT_VM_FLAG(IO)
 #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
@@ -502,13 +508,17 @@ enum {
 #endif
 
 /*
- * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
- * gated on the same configs as their VM_* flags above -- both of which imply
+ * vma_flags_t masks for the userfaultfd VMA flags. The three high-bit modes are
+ * gated on the same configs as their VM_* flags above -- all of which imply
  * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
  * whose bitmap cannot hold it.
  */
 #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 #define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
+#else
+#define VMA_UFFD_WP		EMPTY_VMA_FLAGS
+#endif
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 #define VMA_UFFD_MINOR		mk_vma_flags(VMA_UFFD_MINOR_BIT)
 #else
@@ -602,7 +612,8 @@ enum {
 #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
 
 /* These flags can be updated atomically via VMA/mmap read lock. */
-#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
+					    VMA_MAYBE_UFFD_POISON_BIT)
 
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
@@ -620,16 +631,16 @@ enum {
  *                       merged VMA should be considered soft-dirty also as it
  *                       operates at a VMA granularity.
  *
- * VMA_MAYBE_GUARD_BIT - If a VMA may have guard regions in place it implies
- *                       that mapped page tables may contain metadata not
- *                       described by the VMA and thus any merged VMA may also
- *                       contain this metadata, and thus we must make this flag
- *                       sticky.
+ * VMA_MAYBE_GUARD_BIT / VMA_MAYBE_UFFD_POISON_BIT - Page tables may contain guard
+ *                       or poison markers not described by the VMA. Any
+ *                       merged VMA may also contain this metadata, so these
+ *                       flags must be sticky.
  */
 #ifdef CONFIG_MEM_SOFT_DIRTY
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT, \
+				     VMA_MAYBE_UFFD_POISON_BIT)
 #else
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT, VMA_MAYBE_UFFD_POISON_BIT)
 #endif
 
 /*
@@ -667,13 +678,15 @@ enum {
  *                           retrieve from page cache, and skip copying
  *                           will lose those info.
  *
- *          VM_MAYBE_GUARD - Could contain page guard region markers which
- *                           by design are a property of the page tables
- *                           only and thus cannot be reconstructed on page
- *                           fault.
+ *          VM_MAYBE_GUARD - Could contain guard markers which cannot be
+ *                           reconstructed on page fault.
+ *
+ *   VM_MAYBE_UFFD_POISON - Could contain poison markers which cannot be
+ *                           reconstructed on page fault, including after
+ *                           userfaultfd unregister.
  */
 #define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
-			 VM_MAYBE_GUARD)
+			 VM_MAYBE_GUARD | VM_MAYBE_UFFD_POISON)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index dff9a5c9a0dfa..b8b7cc2f00388 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -167,11 +167,14 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 
 /*
  * Never enable huge pmd sharing on userfaultfd registered VMAs, because
- * userfaultfd state can be tracked per VMA or per page table entry.
+ * userfaultfd state can be tracked per VMA or per page table entry. Similarly,
+ * handle poison markers that stick around even after userfaultfd was
+ * unregistered.
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma->vm_userfaultfd_ctx.ctx;
+	return vma->vm_userfaultfd_ctx.ctx ||
+	       vma_test_atomic_flag(vma, VMA_MAYBE_UFFD_POISON_BIT);
 }
 
 /*
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 3c153b3ad8450..942746e4de15b 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -184,6 +184,12 @@ IF_HAVE_PG_ARCH_3(arch_3)
 #define IF_HAVE_VM_SOFTDIRTY(flag,name)
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+# define IF_HAVE_UFFD_WP(flag, name) {flag, name},
+#else
+# define IF_HAVE_UFFD_WP(flag, name)
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 # define IF_HAVE_UFFD_MINOR(flag, name) {flag, name},
 #else
@@ -247,7 +253,8 @@ IF_HAVE_PG_ARCH_3(arch_3)
 IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
 	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
-	{VM_UFFD_WP,			"uffd_wp"	},		\
+	{VM_MAYBE_UFFD_POISON,		"maybe_uffd_poison"	},		\
+IF_HAVE_UFFD_WP(VM_UFFD_WP,		"uffd_wp")			\
 IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b5438..ad9236933aab3 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1357,6 +1357,7 @@ config ANON_VMA_NAME
 
 config HAVE_ARCH_USERFAULTFD_WP
 	bool
+	depends on 64BIT
 	help
 	  Arch has userfaultfd write protection support
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 42d9eb26d5fab..2a5ee8fc42335 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2107,16 +2107,17 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 		return false;
 
 	/*
-	 * If the VMA contains guard regions then we can't collapse it.
+	 * Preserve guard and poison markers when retracting page tables.
 	 *
-	 * This is set atomically on guard marker installation under mmap/VMA
+	 * These flags are set atomically on marker installation under mmap/VMA
 	 * read lock, and here we may not hold any VMA or mmap lock at all.
 	 *
 	 * This is therefore serialised on the PTE page table lock, which is
-	 * obtained on guard region installation after the flag is set, so this
+	 * obtained on marker installation after the flag is set, so this
 	 * check being performed under this lock excludes races.
 	 */
-	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT))
+	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT) ||
+	    vma_test_atomic_flag(vma, VMA_MAYBE_UFFD_POISON_BIT))
 		return false;
 
 	return true;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 169f681f9849b..bb6069320b347 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -963,6 +963,9 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	if (err)
 		goto out;
 
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
+		vma_set_atomic_flag(state.vma, VMA_MAYBE_UFFD_POISON_BIT);
+
 	/*
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index dc4927d26296c..f9bafe4e20158 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -117,7 +117,7 @@ enum {
 	/* Page-ranges managed without "struct page", just pure PFN */
 	DECLARE_VMA_BIT(PFNMAP, 10),
 	DECLARE_VMA_BIT(MAYBE_GUARD, 11),
-	DECLARE_VMA_BIT(UFFD_WP, 12),	/* wrprotect pages tracking */
+	DECLARE_VMA_BIT(MAYBE_UFFD_POISON, 12),
 	DECLARE_VMA_BIT(LOCKED, 13),
 	DECLARE_VMA_BIT(IO, 14),	/* Memory mapped I/O or similar */
 	DECLARE_VMA_BIT(SEQ_READ, 15),	/* App will access data sequentially */
@@ -160,6 +160,7 @@ enum {
 #endif
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
+	DECLARE_VMA_BIT(UFFD_WP, 44),	/* wrprotect pages tracking */
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -218,7 +219,12 @@ enum {
 #endif
 #define VM_PFNMAP	INIT_VM_FLAG(PFNMAP)
 #define VM_MAYBE_GUARD	INIT_VM_FLAG(MAYBE_GUARD)
+#define VM_MAYBE_UFFD_POISON	INIT_VM_FLAG(MAYBE_UFFD_POISON)
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 #define VM_UFFD_WP	INIT_VM_FLAG(UFFD_WP)
+#else
+#define VM_UFFD_WP	VM_NONE
+#endif
 #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
 #define VM_IO		INIT_VM_FLAG(IO)
 #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
@@ -367,7 +373,8 @@ enum {
 #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
 
 /* These flags can be updated atomically via VMA/mmap read lock. */
-#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
+					    VMA_MAYBE_UFFD_POISON_BIT)
 
 #define RLIMIT_STACK		3	/* max stack size */
 #define RLIMIT_MEMLOCK		8	/* max locked-in-memory address space */
@@ -375,14 +382,17 @@ enum {
 #define CAP_IPC_LOCK         14
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT, \
+				      VMA_MAYBE_UFFD_POISON_BIT)
 #else
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
+				      VMA_MAYBE_UFFD_POISON_BIT)
 #endif
 
 #define VMA_IGNORE_MERGE_FLAGS VMA_STICKY_FLAGS
 
-#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | \
+			 VM_MAYBE_GUARD | VM_MAYBE_UFFD_POISON)
 
 #define pgprot_val(x)		((x).pgprot)
 #define __pgprot(x)		((pgprot_t) { (x) } )

-- 
2.43.0


