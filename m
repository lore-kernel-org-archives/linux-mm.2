Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC42ACDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784886B00A2; Thu, 25 Jun 2026 07:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C176B00FD; Thu, 25 Jun 2026 07:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671696B010D; Thu, 25 Jun 2026 07:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 319E66B00A2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B54FCA0615
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:10 +0000 (UTC)
X-FDA: 84918218700.10.2411D2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0992B40005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=AD0tpk2Y;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387069;
	b=2gG3hycyE3Xr/Njs4nyhDE4/uRanxB80YloA7w0Cu/4LcrygoKP8BCcDJUluZfLDS9BSZL
	u+znwlkcq/+MGmKLQdDYwkb+5d4h8TnWS8TqrjbbiOP8gyMxNReLqymInN4V2NsIGwPdcN
	asDhuo0VCPtfopSIwNfB1J5zB/QQCTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=J8zGE6vhMIdiOYpUeFjL4QjBRkO2+prBeARLGT6x38c=;
	b=ESPT1twnULQN8YLcrbB/WMs7AOsDlOPpdXR0DL4m3VIAZmaMiMwgldKrx0gSDyQlun6AiS
	l6a0Mm8VePcFKU6jS3QgHl2qvrpQcAW5ibtyhi9yP0LGc49yvsyV2JSXeEcZx/pMJSzcN+
	KSQctj23xqzd81q8PyjGYNZ+CerL52c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=AD0tpk2Y;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D1CD60018;
	Thu, 25 Jun 2026 11:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D411F000E9;
	Thu, 25 Jun 2026 11:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782387068;
	bh=J8zGE6vhMIdiOYpUeFjL4QjBRkO2+prBeARLGT6x38c=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=AD0tpk2YQyRS/PV6tv2eRek9LHMQilCufzo421N1O78gRffbeVSzmWdaYhZX9LJxR
	 cGIpeRiwy7XOST5h7L2SSmEAIevuuq44V+dYiGxThFF2eHBq0TS+tM4isYqt4GZEfP
	 e300NZ+wbi15m+eF1kgvTkAoRQH6FiqohOBtBqnk=
Subject: Patch "mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one" has been added to the 6.18-stable tree
To: akpm@linux-foundation.org,avagin@gmail.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,corbet@lwn.net,david@kernel.org,dev.jain@arm.com,elaidya225@gmail.com,gregkh@linuxfoundation.org,jannh@google.com,lance.yang@linux.dev,liam.howlett@oracle.com,linux-mm@kvack.org,ljs@kernel.org,lorenzo.stoakes@oracle.com,mathieu.desnoyers@efficios.com,mhiramat@kernel.org,mhocko@suse.com,npache@redhat.com,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,ryan.roberts@arm.com,surenb@google.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 25 Jun 2026 12:29:48 +0100
In-Reply-To: <20260515124218.151966-7-elaidya225@gmail.com>
Message-ID: <2026062548-dining-quail-c025@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0992B40005
X-Stat-Signature: zjowx5yfu9fyzjbr6ho68aesjfjiyhyc
X-HE-Tag: 1782387068-619488
X-HE-Meta: U2FsdGVkX19znuF3aJQzVkZ+wEUfvImC1tDv++3FTTdHkhmKU/FeXY4mq4c36GqbxT1JKl8wBsosr7eagKTzS5wLtPCrpLQjzeFzVoyoPvASTXgIe0xnIrrpUKRF0UthdjCuhOEfpPAchTuoywnnY0QnCJ2OTo4ZoOERK1g/HAQwfiJCq83j3o0j5jDTMeDxJ8lDukN4RQ7c+EzaKYL7p+2znIqMxfy2HSQsGLPTS8Qt0mJ0tLnfA2T7fraYrywMxVqoSPveswaCM1BHFXl1ESCNMUfY03Ov3NVdK9XBAuFWJL+ZIWWkBo72kAPgyWHo2usw3DMr2jOsVJiR03BlWZiDlBEag10eCK8LnEbrii7P7LoMe3+Jb3VhANe+mqwnY+jhgg7xavJ5x4xGXsOdbLcS9VoG3ncZFyNmfNov5IbWKXwOs7HplbWUR9iOlzDP8zzZmIyHrISn8H3ATz74/Ck+H7GBtBErjHzp6RohpeAQMDRVvUfyx32P/tUbRmf/os9pZHvN/yEXERS0zaAEJWl5220sDEbD/gegubuDSGVe6cqbYcLqzEkcFUeYd25C3XB3he0eY51Bs6gPIekP4paPMR1vPWYU/yFwtMPvt+5QttnTcMF2ANbSlmyfByAQXpZFJJTWw0AZDxDdoDP3dQIuwgxLa9m1ZzGDPo5PPwumYk5Z5Eg1mRn71/ynuoMpvTuT+hsfIuXMnq4BH4Tvc/i5C5YS7To0f6NlrKV+1gJ0eJDOv0h/lPg9mnM2T9wQXVZdevl4qAuSod7umVvVT0Q4fcd0kGyjOBHNNCeE69TGzCv5LZ9MBLodOy/yWuckoNBwmvgqd8HYRs5/XU5xbLcumOZ+y3q/aAmUJbVFLiVbxPRkQT1A9fN5T3kWipOLQ1mDvnKnzzYbRWfqKFFtMGeHeaZdQp1GanM7P9TGQbZMK06cZaWtEXr7HJMXJKHRHCKj/ZtJbXu12GCoCgU
 eeK7HcDz
 jQn/rhJ8IwRw7JngivbIgM4EA+h68JsSac9zOz02IgiIQalf441bvINx6MfxTYfIG5La9gUyO7/6XOutWXz3klZi2qYVKGnQznggDE097qoB+bRmRk5/XykntIkimOo5Cr9FkMzkQp8ZLjRoRp6HtoOPJUfVU3mYG8qR38TC4Dfiu58b439ZXq89yy2unNv4nykFouXAxZ9gQN84ta88KCkvyCZBQkwxvtky2nIGHSBKoRH6RvOc1E3fdmtciWUQcHXswZBxgoxwAroF2CTTzoxW+sUffBsLSMQGGkwjfOZ+RAJYpt3fZqME9opC4IIzWGniOkWSJY2ehV6b7GvU1bG09Tr6JAlHNtV2XraCSfmoL9B2AhXW2Wv0Vn8kKNXMoyDLQVmciGfnieJSNuN72hE7C+7qQ8ReVTmoEiKJvj+P90Q15yiclvRKXyH5gQmTRJt/i52Tv+WxK5ywIklsV4XzxhLyibjRUwasMPZvazmAiXmlvuv3NU+l0nLzLeccoTqCMZrxC8XaHZoknq+6boz6C0Gy1V9KbbaS+oUSfuRDhKGULH1i5JjKDAdLqBvZYx7CTN7HUJV76a1ZNP2RSdgM4E5QE0Pyi96hx0xObr3LTK6RuBTej0iEcDuSS7Cwpyjv4lIUYN2GX5jbv6iGr/+O7dLg8qMBITCKBPxRf9QCMJJRsl6NulMWcxGrPaLv8slidQzIpXs/thhn/axYDkrm1z7vuTYwibm8TEL89v/ynLuejyfuXkc1Jen1+7qd/DSdXzl6BJEohAZ2rS3Qgiy9HkfbCSXbi3F5gWtNLfHH4rYWombgEsQ3LvSL6DZLXjRtCOAuUQHIgWCP8toJyrMeT7YHr8/4/gJ69hZRU0zgwByIwJQRSpLv85OibeDBcVXpkbltvVp46H1bDp03MIKGPZmZ2NHOC4qlpaVnyMa8y4rTGaaSwDtCEiaXYQmri5Rwl1LyTq9dFbp9XcmrWaZzmwtWZ
 qsiqanQm
 /Up4zAy7A0UMNfOeB1xHI8EQnhJdr3XTmin1liYVplP5rDyV0eyeOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-247752-greg=kroah.com@vger.kernel.org Fri May 15 14:05:45 2026
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Fri, 15 May 2026 15:42:15 +0300
Subject: mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, avagin@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>, "David Hildenbrand (Red Hat)" <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, Liam Howlett <liam.howlett@oracle.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, Ahmed Elaidy <elaidya225@gmail.com>
Message-ID: <20260515124218.151966-7-elaidya225@gmail.com>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit ab04b530e7e8bd5cf9fb0c1ad20e0deee8f569ec upstream.

Gather all the VMA flags whose presence implies that page tables must be
copied on fork into a single bitmap - VM_COPY_ON_FORK - and use this
rather than specifying individual flags in vma_needs_copy().

We also add VM_MAYBE_GUARD to this list, as it being set on a VMA implies
that there may be metadata contained in the page tables (that is - guard
markers) which would will not and cannot be propagated upon fork.

This was already being done manually previously in vma_needs_copy(), but
this makes it very explicit, alongside VM_PFNMAP, VM_MIXEDMAP and
VM_UFFD_WP all of which imply the same.

Note that VM_STICKY flags ought generally to be marked VM_COPY_ON_FORK too
- because equally a flag being VM_STICKY indicates that the VMA contains
metadat that is not propagated by being faulted in - i.e.  that the VMA
metadata does not fully describe the VMA alone, and thus we must propagate
whatever metadata there is on a fork.

However, for maximum flexibility, we do not make this necessarily the case
here.

Link: https://lkml.kernel.org/r/5d41b24e7bc622cda0af92b6d558d7f4c0d1bc8c.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
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
 include/linux/mm.h               |   26 ++++++++++++++++++++++++++
 mm/memory.c                      |   18 ++++--------------
 tools/testing/vma/vma_internal.h |   26 ++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 14 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -539,6 +539,32 @@ extern unsigned int kobjsize(const void
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
 /*
+ * Flags which should result in page tables being copied on fork. These are
+ * flags which indicate that the VMA maps page tables which cannot be
+ * reconsistuted upon page fault, so necessitate page table copying upon
+ *
+ * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
+ *                           reasonably reconstructed on page fault.
+ *
+ *              VM_UFFD_WP - Encodes metadata about an installed uffd
+ *                           write protect handler, which cannot be
+ *                           reconstructed on page fault.
+ *
+ *                           We always copy pgtables when dst_vma has uffd-wp
+ *                           enabled even if it's file-backed
+ *                           (e.g. shmem). Because when uffd-wp is enabled,
+ *                           pgtable contains uffd-wp protection information,
+ *                           that's something we can't retrieve from page cache,
+ *                           and skip copying will lose those info.
+ *
+ *          VM_MAYBE_GUARD - Could contain page guard region markers which
+ *                           by design are a property of the page tables
+ *                           only and thus cannot be reconstructed on page
+ *                           fault.
+ */
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+
+/*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1479,25 +1479,15 @@ copy_p4d_range(struct vm_area_struct *ds
 static bool
 vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
+	if (src_vma->vm_flags & VM_COPY_ON_FORK)
+		return true;
 	/*
-	 * Always copy pgtables when dst_vma has uffd-wp enabled even if it's
-	 * file-backed (e.g. shmem). Because when uffd-wp is enabled, pgtable
-	 * contains uffd-wp protection information, that's something we can't
-	 * retrieve from page cache, and skip copying will lose those info.
+	 * The presence of an anon_vma indicates an anonymous VMA has page
+	 * tables which naturally cannot be reconstituted on page fault.
 	 */
-	if (userfaultfd_wp(dst_vma))
-		return true;
-
-	if (src_vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
-		return true;
-
 	if (src_vma->anon_vma)
 		return true;
 
-	/* Guard regions have modified page tables that require copying. */
-	if (src_vma->vm_flags & VM_MAYBE_GUARD)
-		return true;
-
 	/*
 	 * Don't copy ptes where a page fault will fill them correctly.  Fork
 	 * becomes much lighter when there are big shared or private readonly
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -145,6 +145,32 @@ extern unsigned long dac_mmap_min_addr;
  */
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
+/*
+ * Flags which should result in page tables being copied on fork. These are
+ * flags which indicate that the VMA maps page tables which cannot be
+ * reconsistuted upon page fault, so necessitate page table copying upon
+ *
+ * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
+ *                           reasonably reconstructed on page fault.
+ *
+ *              VM_UFFD_WP - Encodes metadata about an installed uffd
+ *                           write protect handler, which cannot be
+ *                           reconstructed on page fault.
+ *
+ *                           We always copy pgtables when dst_vma has uffd-wp
+ *                           enabled even if it's file-backed
+ *                           (e.g. shmem). Because when uffd-wp is enabled,
+ *                           pgtable contains uffd-wp protection information,
+ *                           that's something we can't retrieve from page cache,
+ *                           and skip copying will lose those info.
+ *
+ *          VM_MAYBE_GUARD - Could contain page guard region markers which
+ *                           by design are a property of the page tables
+ *                           only and thus cannot be reconstructed on page
+ *                           fault.
+ */
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+
 #define FIRST_USER_ADDRESS	0UL
 #define USER_PGTABLES_CEILING	0UL
 


Patches currently in stable-queue which might be from elaidya225@gmail.com are

queue-6.18/testing-selftests-mm-add-soft-dirty-merge-self-test.patch
queue-6.18/mm-implement-sticky-vma-flags.patch
queue-6.18/mm-update-vma_modify_flags-to-handle-residual-flags-document.patch
queue-6.18/mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
queue-6.18/mm-propagate-vm_softdirty-on-merge.patch
queue-6.18/mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
queue-6.18/mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
queue-6.18/mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch

