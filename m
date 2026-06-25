Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A7EFCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D516B010D; Thu, 25 Jun 2026 07:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D9D6B010E; Thu, 25 Jun 2026 07:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD6F6B0110; Thu, 25 Jun 2026 07:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 327A16B010D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B78F41C348C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:14 +0000 (UTC)
X-FDA: 84918218868.06.AD56C1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E6AAE40009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=0EcgZI48;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387073;
	b=rz0q/73uScwfGtnDfP7UO8E2bDsTSiM1y+SlTcb32joX0VMAQ/cciPVWS90JN/m+hT9OTl
	TQ/U9ZzUmur3sc15Hpcr/xB0WVLKWHNtotw/HZ93AIEa3/6c+nvc+wiQol9y/tXCzssTWW
	HnUq0bHsOp58GAqDugsogTJW4m9z1J8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=dGgPmhE3F5bcH7RhyE1yCwo8vTNCjZIB5GbpE4CA2Hk=;
	b=G7RI5EqJ4bU04GL6RDFdG0MFarRXstAy5L8VFlmSnTfcv/rV6DZpLYeHPzJrFyGvIrNjwz
	0x3g0F/7lFNh3MhhxdIoise7wYwE+/fOxcaf2bjgUeBd0NC1Nk2jmcg88PVldyUgUXgeRm
	kpR42vGwpElMoy4UJRteel6slunOrN8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=0EcgZI48;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA426405AB;
	Thu, 25 Jun 2026 11:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65021F000E9;
	Thu, 25 Jun 2026 11:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782387071;
	bh=dGgPmhE3F5bcH7RhyE1yCwo8vTNCjZIB5GbpE4CA2Hk=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=0EcgZI48psVdBeyHHj8GbC8A3sGE4QwBROqr5DmzzLB9kIgvK0T/deWLbWKOQsaOQ
	 nQbfR79+Oy1eT3hYSQiwpCWRRJ+gQq7dH0caQngRiXLPoX5pvubLSgSm2QeJVAKNlN
	 SESjR3hFaO+5NnkVWyXEc16bdzR/jw+N3QNuRhyc=
Subject: Patch "mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps" has been added to the 6.18-stable tree
To: akpm@linux-foundation.org,avagin@gmail.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,corbet@lwn.net,david@kernel.org,dev.jain@arm.com,elaidya225@gmail.com,gregkh@linuxfoundation.org,jannh@google.com,lance.yang@linux.dev,liam.howlett@oracle.com,linux-mm@kvack.org,ljs@kernel.org,lorenzo.stoakes@oracle.com,mathieu.desnoyers@efficios.com,mhiramat@kernel.org,mhocko@suse.com,npache@redhat.com,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,ryan.roberts@arm.com,surenb@google.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 25 Jun 2026 12:29:48 +0100
In-Reply-To: <20260515124218.151966-3-elaidya225@gmail.com>
Message-ID: <2026062548-candle-monthly-7655@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E6AAE40009
X-Stat-Signature: 9ppdzahwmekumbkmi1stxdhaamyqhz97
X-HE-Tag: 1782387072-302056
X-HE-Meta: U2FsdGVkX1/OmJJhTZmr8unQCtVebqp0joPs1vsgAGFMHMwgPHrMJzAKoGsAXy7xt6kYB48s8xh/UqFqae9gi/f8Z8AEsoDMW84D4vOP5e2PYjtQEG2Guv+DI9Gsd4BlFlt2TEpy+CukGo5KvFVA30nDCy3WW8p0KCJn/xAzXzG9l9knDIOFzsSp0B9xSg3rWI6o8c4C5ZGrmvxtdu2/D4c2WXHlKsg0HVsr0ckQnD4FKf72Xv4yKYdVYHzE/V4aDQjyDPxSGzggQoaAE3MMuZhn0taGRISSfjvuP9OHT8RUzDs7xmi/3c/LeDXpohsMUcACOfyIXSy6XWGhIZ3/GZqR4wzJ6sXPP49pi8fiSnVBJM2JNn/59jmJTlVVU7+QJmY052eqGYJut3t7MZMcZHeKnJ0w9hV8fTfzcm0876jwBtgWlDhtPXtppWi6ambEV9BEXx9mjiTY5DnVUCmA88SevH0DkfO74xsLxZlImFlA37LVawjPiGZtfX6V23eXTlYTSly9zXKJJmFiXGasL6GUBWedimkqSYna2gOoPSnxt+CsUA8fmpvS70+n1ArcvzUm0LSu6aeGDvJlSI7zYxAwQFvVuo0RzOziX1s9PJhi0nMuME+bTdqsGRV0+lDaXTm9TEMTAe7IldOIjgd9m8yU2fEB/82VP3ZEpEsSg0cna6M+W/yvTy+J0TowM4fh6rJJ8pj0/+W1cp8aAOEWo/dXi3DSqgikfl2R4NE5jZz0Ub2yyQJqzYUWXA6uO5YcEGPYvb/eHX2c/grjQvntzcX7470j1WDYeI4q1fZ6gVPda0MhjbCimHSy+lbtZzLG5A7zds8wcS1eLMEwFhTQ7w4hODMsfG3Wqn28BogSK2LsYA9CjwVaXVT+4a/7PgZ7ZFXhr+tb7lnoN+ai9SjmdQdRRnJ6t2jCB9XMNWAp00RXZ7CINegWhurszTTBO2mZ1rjsp6dCvkVVlvO0/5U
 m0F0WS1I
 IG5lC3UJVYWKUM41k8nEp82J3CLg5TE6UO9ZkPfDUUzjwurhxq8EJ5RmdupDPPxk3FSnhtzd5aPs3AA8X3jV9GOzYZKPnVPiIBcTcwllGwVcZbDohD4nyTX1ye7WvAPMJaWUEb4Vw2CrB/bbHZouF+yJsQ5fmuY+0qM1HVxODwa1hClZs49JkRMLoS4FcwrMXNRA4EPjjRHHzHzi/xjSsLcy9+4vEz12sRbXTl1ky2GueMCMPsAml4ZhByvOzff/xfoUgKHiXGKqHBLWwq2nPZefarGU4TPGlxcmf1jZsimRbAXGeuWvxL4pdzMIUIoBta28AMMn8zec7V11nLgrWPXl4LT66eYTLuG7UzO7/JI3Pq5hsLYQao28wAXE+kBO0VL3f+Ajtb57i4ioKTxDty45Tvs81HDbm6+f05ugPlCifV6Y5OWw1AVHigiHD6e96U0RTg5bnZWDvDO4EJ1iWxmImOgb9FLp/mWnKj62VpmXoN5s7X4xFdrsKR324eHUNyOynI+fhTqMwDzdDZ3tlaaPfrQGC7UDyDmWVGLar3qesiI+5x2pYe/il1pf9O0Up6USSjhUdB7tH2i1FodrkckfUZV5zOhXJ/iNiWrgnhpxUKnlM3x/LV2a4B45uU7mpBi7HrpPAypnEwa1C10Hg81io6qowxB+Us0+zTBEaYR7jr3lUTxmFE8FvypoQk6TagekoODxfH8qC/vpWYQRe25JPBN6E1ygbZANOVvPZ2AHFqa6/gHXKHeskhLqP6utI0qkGeuXb9kO0c3hoq9gamrSJUrOcfkEU12RZBzdD4Crivor2G+bxxwRDV8mk38yQ/9B0puB/9/zIGG3caLUOFxRHFyxcNbmRQUfGfW9O8PkdQbwkUqDH/ftYx6yHeXOqanzpPQY1OSyPRU4Gbhma2j+XAolyKiCuzUmb+rlT15GKDSxhmPz7jC3g8oWeBUegrUpTBeqmk5+i95Qvy195+vFyw/UH
 wq9xmXkk
 1iCLax37rJVUew8xn8sF3UV1AgLyXm74tVyg0BlfBGiQ6UpwB6ivIOkJSZegXnPx7MCcHsrBhcp+bLepjpQDqi0s2QPpL+O1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-247748-greg=kroah.com@vger.kernel.org Fri May 15 14:05:27 2026
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Fri, 15 May 2026 15:42:11 +0300
Subject: mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, avagin@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>, "David Hildenbrand (Red Hat)" <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Liam Howlett <liam.howlett@oracle.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, Ahmed Elaidy <elaidya225@gmail.com>
Message-ID: <20260515124218.151966-3-elaidya225@gmail.com>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 5dba5cc2e0ffa76f2f6c8922a04469dc9602c396 upstream.

Patch series "introduce VM_MAYBE_GUARD and make it sticky", v4.

Currently, guard regions are not visible to users except through
/proc/$pid/pagemap, with no explicit visibility at the VMA level.

This makes the feature less useful, as it isn't entirely apparent which
VMAs may have these entries present, especially when performing actions
which walk through memory regions such as those performed by CRIU.

This series addresses this issue by introducing the VM_MAYBE_GUARD flag
which fulfils this role, updating the smaps logic to display an entry for
these.

The semantics of this flag are that a guard region MAY be present if set
(we cannot be sure, as we can't efficiently track whether an
MADV_GUARD_REMOVE finally removes all the guard regions in a VMA) - but if
not set the VMA definitely does NOT have any guard regions present.

It's problematic to establish this flag without further action, because
that means that VMAs with guard regions in them become non-mergeable with
adjacent VMAs for no especially good reason.

To work around this, this series also introduces the concept of 'sticky'
VMA flags - that is flags which:

a. if set in one VMA and not in another still permit those VMAs to be
   merged (if otherwise compatible).

b. When they are merged, the resultant VMA must have the flag set.

The VMA logic is updated to propagate these flags correctly.

Additionally, VM_MAYBE_GUARD being an explicit VMA flag allows us to solve
an issue with file-backed guard regions - previously these established an
anon_vma object for file-backed mappings solely to have vma_needs_copy()
correctly propagate guard region mappings to child processes.

We introduce a new flag alias VM_COPY_ON_FORK (which currently only
specifies VM_MAYBE_GUARD) and update vma_needs_copy() to check explicitly
for this flag and to copy page tables if it is present, which resolves
this issue.

Additionally, we add the ability for allow-listed VMA flags to be
atomically writable with only mmap/VMA read locks held.

The only flag we allow so far is VM_MAYBE_GUARD, which we carefully ensure
does not cause any races by being allowed to do so.

This allows us to maintain guard region installation as a read-locked
operation and not endure the overhead of obtaining a write lock here.

Finally we introduce extensive VMA userland tests to assert that the
sticky VMA logic behaves correctly as well as guard region self tests to
assert that smaps visibility is correctly implemented.

This patch (of 9):

Currently, if a user needs to determine if guard regions are present in a
range, they have to scan all VMAs (or have knowledge of which ones might
have guard regions).

Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
pagemap") and the related commit a516403787e0 ("fs/proc: extend the
PAGEMAP_SCAN ioctl to report guard regions"), users can use either
/proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
operation at a virtual address level.

This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
that guard regions exist in ranges.

This patch remedies the situation by establishing a new VMA flag,
VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
uncertain because we cannot reasonably determine whether a
MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
additionally VMAs may change across merge/split).

We utilise 0x800 for this flag which makes it available to 32-bit
architectures also, a flag that was previously used by VM_DENYWRITE, which
was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
bee reused yet.

We also update the smaps logic and documentation to identify these VMAs.

Another major use of this functionality is that we can use it to identify
that we ought to copy page tables on fork.

We do not actually implement usage of this flag in mm/madvise.c yet as we
need to allow some VMA flags to be applied atomically under mmap/VMA read
lock in order to avoid the need to acquire a write lock for this purpose.

Link: https://lkml.kernel.org/r/cover.1763460113.git.ljs@kernel.org
Link: https://lkml.kernel.org/r/cf8ef821eba29b6c5b5e138fffe95d6dcabdedb9.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/proc.rst |    5 +++--
 fs/proc/task_mmu.c                 |    1 +
 include/linux/mm.h                 |    3 +++
 include/trace/events/mmflags.h     |    1 +
 mm/memory.c                        |    4 ++++
 tools/testing/vma/vma_internal.h   |    1 +
 6 files changed, 13 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -553,7 +553,7 @@ otherwise.
 kernel flags associated with the particular virtual memory area in two letter
 encoded manner. The codes are the following:
 
-    ==    =======================================
+    ==    =============================================================
     rd    readable
     wr    writeable
     ex    executable
@@ -591,7 +591,8 @@ encoded manner. The codes are the follow
     sl    sealed
     lf    lock on fault pages
     dp    always lazily freeable mapping
-    ==    =======================================
+    gu    maybe contains guard regions (if not set, definitely doesn't)
+    ==    =============================================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
 be present in all further kernel releases. Things get changed, the flags may
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1159,6 +1159,7 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_MAYSHARE)]	= "ms",
 		[ilog2(VM_GROWSDOWN)]	= "gd",
 		[ilog2(VM_PFNMAP)]	= "pf",
+		[ilog2(VM_MAYBE_GUARD)]	= "gu",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -269,6 +269,8 @@ extern struct rw_semaphore nommu_region_
 extern unsigned int kobjsize(const void *objp);
 #endif
 
+#define VM_MAYBE_GUARD_BIT 11
+
 /*
  * vm_flags in vm_area_struct, see mm_types.h.
  * When changing, update also include/trace/events/mmflags.h
@@ -294,6 +296,7 @@ extern unsigned int kobjsize(const void
 #define VM_UFFD_MISSING	0
 #endif /* CONFIG_MMU */
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
+#define VM_MAYBE_GUARD	BIT(VM_MAYBE_GUARD_BIT)	/* The VMA maybe contains guard regions. */
 #define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
 
 #define VM_LOCKED	0x00002000
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -213,6 +213,7 @@ IF_HAVE_PG_ARCH_3(arch_3)
 	{VM_UFFD_MISSING,		"uffd_missing"	},		\
 IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
+	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
 	{VM_UFFD_WP,			"uffd_wp"	},		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1494,6 +1494,10 @@ vma_needs_copy(struct vm_area_struct *ds
 	if (src_vma->anon_vma)
 		return true;
 
+	/* Guard regions have modified page tables that require copying. */
+	if (src_vma->vm_flags & VM_MAYBE_GUARD)
+		return true;
+
 	/*
 	 * Don't copy ptes where a page fault will fill them correctly.  Fork
 	 * becomes much lighter when there are big shared or private readonly
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -56,6 +56,7 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_MAYEXEC	0x00000040
 #define VM_GROWSDOWN	0x00000100
 #define VM_PFNMAP	0x00000400
+#define VM_MAYBE_GUARD	0x00000800
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000
 #define VM_SEQ_READ	0x00008000	/* App will access data sequentially */


Patches currently in stable-queue which might be from elaidya225@gmail.com are

queue-6.18/testing-selftests-mm-add-soft-dirty-merge-self-test.patch
queue-6.18/mm-implement-sticky-vma-flags.patch
queue-6.18/mm-update-vma_modify_flags-to-handle-residual-flags-document.patch
queue-6.18/mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
queue-6.18/mm-propagate-vm_softdirty-on-merge.patch
queue-6.18/mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
queue-6.18/mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
queue-6.18/mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch

