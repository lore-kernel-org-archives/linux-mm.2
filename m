Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C17606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGa4Al6r
Received: by kanga.kvack.org (Postfix)
	id 883C86B05B1; Mon, 16 Nov 2026 10:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B2C6B05BA; Mon, 16 Nov 2026 10:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774576B05BB; Mon, 16 Nov 2026 10:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 553A06B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:17:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF5B41A0133
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:17:35 +0000 (UTC)
X-FDA: 85441336470.12.8439D3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E4F50100012
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:17:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hGa4Al6r;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794842254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=n9lrlaSdhvhL38uf8xQFpVcxqD8vUh189IN2micZK5Y=;
	b=NB1/1MiTvch0wqlORbSJ+jrE6/Nl6/IR00eo7di3DIX4Wx0a2phqrsuKlvM+elxqWq5t7d
	bOvftkmBt9QexeprQ12PxcNF3c09PCMvBsYolxLs10lon7A3qBhE+RX5w+MtSDhc9o/pL6
	GEoM7HPQ+K53U0IjJKu5Yk1+e0vngYk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hGa4Al6r;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794842254;
	b=tir8ohHiTX91hkhtaxcmGn6rW1hm3xQ0oCZW8tjxdFxJ8YvwfmIvVxDBQDo0lyQdiG6HWV
	AunKIjze9NXRt2hYWFxvH+TlvOtwUGdymcPVM0YD69B+xk3cDHIvPYVoCiRLU2zNmGS5Df
	o2ccHpqZSo2cdQplj19FjagFbHHqm4A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 214BD4115D;
	Mon, 16 Nov 2026 15:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7CA1F000C6;
	Mon, 16 Nov 2026 15:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794842253;
	bh=n9lrlaSdhvhL38uf8xQFpVcxqD8vUh189IN2micZK5Y=;
	h=From:Date:Subject:To:Cc;
	b=hGa4Al6rGbLpMlldEUixusvwwVPshVphAOXEnlnJ5MKalW5+TWrYtxzmn+Yi24ey4
	 8Dz3zsayhbf2a0vzNhMwJjG8NxaSNoTRJqVSAOxhEvzXphV60tX80yc7IV2mtZIdrN
	 tI5TwGD0A0/M51WSmI7vmqEDQCJQ+wPopWibw+tIyHyA2fG/E6bYp2OLhsPBKpX/3q
	 GPOtURtjhYp5LIUeoS8fjmV3wfwz8z6yaoNi3C7sUMy0A9IIbd44jikUaenISeQZDQ
	 Y4wa/V+AcEjbqK3ReomfJBA2Er4fRgpT/Ak636ckeFcnDApw0qAMNrVQ6062mst+vk
	 wxSZsvj+kgmOw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 16:17:17 +0100
Subject: [PATCH v2] mm/userfaultfd: prevent poison marker loss
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-b4-uffd_marker_loss-v2-1-0fe9c5d1b43a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/22NQQ6CMBAAv9LsmZp2g0U5+Q9DCJQtVJSaLRAN4
 e8GjDePk0xmFojEniLkYgGm2UcfBsgFJgJsVw0tSd9ALgAVGq2VkXUqJ+ea8lFxT1zeQ4zSKXc
 0ZDVaMpAIeDI5/9qr1+LLcapvZMcttRmdj2Pg976d9eb9Dtnfw6ylkic8o6kRM5XaS0880P0Qu
 IViXdcPWof7RckAAAA=
X-Change-ID: 20261106-b4-uffd_marker_loss-f0f56ec12ce6
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=15682; i=david@kernel.org;
 h=from:subject:message-id; bh=WMgXG86TzqcOBZ0cUHPlZRGi1PCjTwE7FP8JlDcH8+c=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+yzUe2H16+ePzKx9uLcqu4+ifyKcWtHPp681TH/3cq
 CsssoFxe0cpC4MYB4OsmCJLUPB9g5cv19VWu/Exw8xhZQIZwsDFKQAT6edhZHhoyb6m/8bGaVsu
 FwvMvbEj/W8jt+ucowyrb2TMP1FT1v+K4b9n4KLoIiXLOTa7P3p4ssQ9CEk+Lu0ddv54xQ6Dxa5
 lR5gA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wurqumirjo8q11zc6j7ngbzhmi1kzsb6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E4F50100012
X-Rspam-User: 
X-HE-Tag: 1794842253-937281
X-HE-Meta: U2FsdGVkX1+MFFgd2IcXX1lVXdS+PLEFw8fFnSum8o3+84AQKeDohWGa1DeZBodiN9dycEfWG+kOjFrEVCPexJO978EJmnpVk4d42mk7+R7nTRUNV/hbLrdcs7HT7pIoeXQ9oMVOi7YAAciIhzQZ01TNP51eW0sMIeG1zJU/Muo6FQ8gP2px66wUrUMPUv7WOYDjZ/S5l5N7N37BnkD4VkbMVcmza2dvXPWuvB1LmEIA2/dYfvB/RbpbF02CNWjr4v8m9KUM6PR6ciwxu1B0k4gsbdvXBRozsG4jIxjFASzbrISqGsVPXTKxxdNd87z6XQmMBNKiwJWShCmLHdiI/BRmuHNURTY7YZrNbOL96VRecC02B2lx/x9MhnseVzz2kLiNmwT+9aY5p+QkV8p03KIFXKSwmygGYQ9SF64MtHSFcDmyyQnPujJIqk38S0EA4i33kUPKYTX1JT41UrDrs6OG2g2/1ZuN/qvcl/q+NLLA3Lq6ri+DHNrqaA8DzCp61ZGKcMUCwpQel7Kofo9lPg7Elh+v5Q+nRNQtFvg7Tl8gePhFMx/6h5TDtjwwIvDs9sy5MN+8kSt+1D6vQi+RKqGKson5l+JlgjpDH9DNp4Y8bGp4DBh+royIIP26TVjyAGeEIHM5Ofs7RgQCxO/hFEQrp5WBiKRQpJLUPVwVrJ/D4Zz7/wOUdrVu7nuCaVcfa9/9oIj6kbyiUCJbfWEQU4aRZB2qjOJ/mjv9ajRA2XpdJ7cEu3sbi0TxqF3K2Gbe0bfPCfkEDXnI3sMdQnlbGo7ClA9IJag/dPxycWpj+YH8Hz8qk6LxI6bSZMA1IR0JWv2ImUkJp2+XkxnpF3/rTZRq0dILcZOPAN2Rt/utUxZX8+8hq2zZWJHGTQeXWABLtwVJ9ddd1YR6wYysAaO1c6Fx5hbkLdK6aJPqQWLPx1NlBF9GXXV4zfs+TGTQcFcOp4Lj9XVWBSlGiIRdBah
 pxMShGaq
 45dSKanVNMFeFMW4EBSaX6DfAyheTOeWiaJzUfCSb0lqJ+SABlLZnk+8Ygyql6/mDQ3GTz/JqWuQIMJhr0VUKbDYSqWSXYsiVyAiv+n2dSIB++SiIRsJkdckAIqVz+KRW8R4S1AdiqeiW9doGVuZCqD0RSRV3h+XhEqk5/iQIBifutE6OvAXuhtdJpWxOXIZGvGik+MCWEL0J8/yqUD0fk0pAjYemc6U+rM4sLXMwquhT4SyfMCGdrT0jKt1U0gWeOHLtBDlVhvloBJrIUQgnwdr/LzdqwZvPFSG9hmlSe6dfJPnrrQMq+hJeG/xq0F8fIvbA8XCoLdqXvN0=
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
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Now that Lorenzo's atomic vma flag fixes are in, we can also use it
for userfaultfd POISON markers.

We use a new VM_MAYBE_UFFD_POISON to remember that we had POISON markers
installed by uffd. We then use that to fix marker handling during fork(),
during hugetlb PMD table sharing, and during retract_page_tables().

Once review finished, I will take this through core.git, where it
depends on a related try_collapse_pte_mapped_thp() cleanup/fix.

This is not urgent, just something that should be fixed properly.

[1] https://lore.kernel.org/linux-mm/20261031-fixes_core-v3-18-d6437171ecc3@kernel.org/
---
Changes in v2:
- Picked up Ack/RB
- Dropped second cleanup patch for now
- Use vma_test_single_mask() in userfaultfd_wp()
- Reshuffle VM_MAYBE_UFFD_POISON, VMA_UFFD_WP etc definitions
- Link to v1: https://patch.msgid.link/20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org
---
 Documentation/filesystems/proc.rst |  1 +
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/mm.h                 | 40 ++++++++++++++++++++++++--------------
 include/linux/userfaultfd_k.h      |  9 ++++++---
 include/trace/events/mmflags.h     |  9 ++++++++-
 mm/Kconfig                         |  1 +
 mm/khugepaged.c                    |  9 +++++----
 mm/userfaultfd.c                   |  3 +++
 tools/testing/vma/include/dup.h    | 20 ++++++++++++++-----
 9 files changed, 67 insertions(+), 28 deletions(-)

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
index 6a34dd3800f56..fa56d9e9f3ebd 100644
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
@@ -406,7 +407,14 @@ enum {
 #endif
 #define VM_PFNMAP	INIT_VM_FLAG(PFNMAP)
 #define VM_MAYBE_GUARD	INIT_VM_FLAG(MAYBE_GUARD)
+#define VM_MAYBE_UFFD_POISON	INIT_VM_FLAG(MAYBE_UFFD_POISON)
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 #define VM_UFFD_WP	INIT_VM_FLAG(UFFD_WP)
+#define VMA_UFFD_WP	mk_vma_flags(VMA_UFFD_WP_BIT)
+#else
+#define VM_UFFD_WP	VM_NONE
+#define VMA_UFFD_WP	EMPTY_VMA_FLAGS
+#endif
 #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
 #define VM_IO		INIT_VM_FLAG(IO)
 #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
@@ -508,7 +516,6 @@ enum {
  * whose bitmap cannot hold it.
  */
 #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
-#define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 #define VMA_UFFD_MINOR		mk_vma_flags(VMA_UFFD_MINOR_BIT)
 #else
@@ -602,7 +609,8 @@ enum {
 #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
 
 /* These flags can be updated atomically via VMA/mmap read lock. */
-#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
+					    VMA_MAYBE_UFFD_POISON_BIT)
 
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
@@ -620,16 +628,16 @@ enum {
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
@@ -667,13 +675,15 @@ enum {
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
index dff9a5c9a0dfa..75c3e9270b62a 100644
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
@@ -198,7 +201,7 @@ static inline bool userfaultfd_missing(struct vm_area_struct *vma)
 
 static inline bool userfaultfd_wp(struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma, VMA_UFFD_WP);
+	return vma_test_single_mask(vma, VMA_UFFD_WP);
 }
 
 static inline bool userfaultfd_minor(struct vm_area_struct *vma)
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

---
base-commit: df3c65887715e66e2cba69116924020c37996cd8
change-id: 20261106-b4-uffd_marker_loss-f0f56ec12ce6

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


