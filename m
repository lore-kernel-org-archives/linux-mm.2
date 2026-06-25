Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27D3CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5DB6B0119; Thu, 25 Jun 2026 07:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49ED56B011A; Thu, 25 Jun 2026 07:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3657B6B011B; Thu, 25 Jun 2026 07:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1F3C6B0119
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F03590316
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:30 +0000 (UTC)
X-FDA: 84918219540.23.0A6AD3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C0021140007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ri5aynSB;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387088;
	b=FwB4Gy+sOppu6wMIPIcNJGj+KR1oSH8kHDKROW5oXmPAsf8gH/vZwwRx4Q2yHF03RVaH+K
	aAubbTNvN1+Whnala4YCVi+URwvJrhlYDTEZ2s9CgbujBzzJVxPl1DFRQlJYMlcclJOukM
	JOF2/s8Zg8CQzVbN9T2mTfp1KHSAiP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=EhBpiGSX1LXqyPFYPmQ3BJWNsmw8yxeEmlGtMujskQ4=;
	b=fuguS+5wh6Zlg43u0esgun9DOGwEmNz9x/yeI97Yzb8g85KCcCuvvMabr00koHST1Dglyg
	s8DIsOgSBnIjOfd7iQGe9xaouYIryx7FgIB8O+BNNaX/Su+zoveBNMr5CAADAQI0wYrPl2
	ELjHpaczU/7ihHFaKQ7mk23Qxg94bGU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ri5aynSB;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 364E7600FC;
	Thu, 25 Jun 2026 11:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E3A1F000E9;
	Thu, 25 Jun 2026 11:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782387087;
	bh=EhBpiGSX1LXqyPFYPmQ3BJWNsmw8yxeEmlGtMujskQ4=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=ri5aynSB1cLC4BBOOZ545cH9ziy1aRekWA24HGLmxINLtMpenX/agbwKHefGyEHs9
	 8ecvjSD2dLWTfpXbfCAeIInTabWs+LrWyEG6M1Xr2HcUz2W9x9iCcbSKju/nfwQp47
	 sLBm5jv5jLEXOY2ygkstb0NewqfusSm8pdFNAIlQ=
Subject: Patch "mm: implement sticky VMA flags" has been added to the 6.18-stable tree
To: akpm@linux-foundation.org,avagin@gmail.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,corbet@lwn.net,david@kernel.org,dev.jain@arm.com,elaidya225@gmail.com,gregkh@linuxfoundation.org,jannh@google.com,lance.yang@linux.dev,liam.howlett@oracle.com,linux-mm@kvack.org,ljs@kernel.org,lorenzo.stoakes@oracle.com,mathieu.desnoyers@efficios.com,mhiramat@kernel.org,mhocko@suse.com,npache@redhat.com,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,ryan.roberts@arm.com,surenb@google.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 25 Jun 2026 12:29:48 +0100
In-Reply-To: <20260515124218.151966-6-elaidya225@gmail.com>
Message-ID: <2026062547-cape-thirteen-b7e2@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0021140007
X-Stat-Signature: wn4xm3o7ezj1admgcw81atzd8awehjd3
X-HE-Tag: 1782387088-406678
X-HE-Meta: U2FsdGVkX1/ljQUVjr6VQNrWNICsS+ImsC07eC8yIdM/tiePxzHopz86O88hTmmy5w4I/GsSO0D2CLLwiCTVDongXcDa09zaFIm78THaUNklU+u9DxRaMq01F9iUzKlsZGE2lGNnUZORKdFGKvVepiqjDaMS97K5BYmx5hCryIIPbBy6lH7EoQgLoweD4wapeDWGQwTnY4JVFf46N3l+iJadRqD7xo1W33xAs2jSZdsFkPiMlCC9M2sWK9h/voZZehL3Crg4uBdcucLlGdHocrZ2fmJgmKYCz95F5IL6vlrzrtuhfLpodBVeXWeqFX5tFxoT1k0fiiBFvjWyRtKPnl+QQGtBSuxFlqd0nqzW4+xXzAuRCzLfAEirOpf3unqQjFHALVMjqWoRrkTzfvKMfyRHFlgSh+47WRsknmSVKyMeZNKVRvHwUIeeKOqbGN7JAjDtkUlTvQxswUYNo53DW+vqPNyYohiMvRm7x/QbEL2M6NIjOA7eVcNB/hRjI2qlR2d5NGqxyt7F9chw6xY39V1pk+tlRTZbKPAXqMwAjxnNK/kfSu8wc25nmhn4eK0oDcyUyvuzqyRW1pkvWFttS37MvilhVH4i31STuMFOIyMvakyFkPK5c+O8R8tA1rX5x5X60gERjLI0DwGMO+gWqk0b6XSIEAT8ejVmPJFzsskILzcNK9roYJR4Xfr+PBx/PnLxN0TmZz0oMewIFURJ39g2wNAtm4VHlLIRH6R/LbD+ym68Vf7xHFgxBRgDVuUwUAbFlIaLZH6lLvfG7mcO93mKWvR2C5cjnXdZrmfLi0ZHG/zzf9QnfOu08T4ZmdC2Da1Ojv8wtjktzX7uuVYJZZvIwfJKY+XjC3s0a9QeLr795TNJArnIsDpwrQj+sQPOKuRpJWrStf7QZJ1Bu9ntut2XDbU5xrXw259L6kLN7pQNVC9GvJO4avUJbXCtLTna6hU9CmwhOx2w6nAgjJv
 6Ul+pcX+
 L4NgI861lV01jKMnxEIh3gzE+bLxFr6vDlcAFT5Hu2+enxtalXPUqlgQe1uUP2nuFFi3fzLY5yZQRvvPUxa33X6aQYxivmhBOAlJ9M1GKNyp2VCnMU1AiKiHBCt1tjT0+DVnElEXZB9oUeMqfiDGApJFrvMJ0ZKt7//9KXwxXen3598l0IfH5L0MK5W6HNQ11WsbZP9mBUAi6xOf75L41/FNV2XowGp+PudmgL/P9RvO65GC9en1RQhQLmIa5QlKe56OIiIaZZxRiHDQFehbFnONuU88+iI7t+Rd0FQIEaeUhWz1ACfBrXElNbbcMmvxFz1DqpVnd96rTM8NtAFn9qC9P7uV53JUdkccWNhfutZ1FSgaR7P4QXc2H39jZMMFPPJpUUSsh1saIp9NAcw295KQYQFXAFphkipGfOB3jZENqa8pIhTe93s30LLahe4LloMWtMGpryaQXrfLDSlH7/JRAOjALfjv+w05U8XSoN8qDK4GBFvZsvK8rMsfS9tONcAXQqKGM1wvGz/ac3Y88bTUiP6DpMmo4U2sJH16fgNLsCS985esrQUJOUUHn9q0dgTk2yv7cT2ulcUDWHyAh3De5jiGuVKg3vN2Tb+fBCekemnxuUPcolI5DGxTAjMFkMFlZX/FLuwrAFl0i0/yehdaktey7FdFln1ZoZvcWW+hS3mW4dbcKG9vT7Ip9Tiz9Qmf8I5pVCSC0s0E5PE1IuWrA9GLhc4hAqIz1kE+h2+3GnFTPXk6gVjAB3UT5hrO07guzXbCiDAdJuEh5BvIMbRSJ+mxPFw584cy7UBQnOVubFzeGmk5XnjNtq7iFSUAv1/MSdxSzl1CMMQYe81Va5Kfg6jI/YX5cU4msj0XuDXAP1VMyUfSNNFkw8CdvDdVWW3i7nyqOHN46RboWjlnm/WBbreoORppXan8VBJnL7oJi01yY1ZEcbGxgFl8Q9FWhiMBPWb4xnXEzOuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: implement sticky VMA flags

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-implement-sticky-vma-flags.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-247751-greg=kroah.com@vger.kernel.org Fri May 15 14:05:45 2026
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Fri, 15 May 2026 15:42:14 +0300
Subject: mm: implement sticky VMA flags
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, avagin@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>, Dev Jain <dev.jain@arm.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, Liam Howlett <liam.howlett@oracle.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, Ahmed Elaidy <elaidya225@gmail.com>
Message-ID: <20260515124218.151966-6-elaidya225@gmail.com>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 64212ba02e66e705cabce188453ba4e61e9d7325 upstream.

It is useful to be able to designate that certain flags are 'sticky', that
is, if two VMAs are merged one with a flag of this nature and one without,
the merged VMA sets this flag.

As a result we ignore these flags for the purposes of determining VMA flag
differences between VMAs being considered for merge.

This patch therefore updates the VMA merge logic to perform this action,
with flags possessing this property being described in the VM_STICKY
bitmap.

Those flags which ought to be ignored for the purposes of VMA merge are
described in the VM_IGNORE_MERGE bitmap, which the VMA merge logic is also
updated to use.

As part of this change we place VM_SOFTDIRTY in VM_IGNORE_MERGE as it
already had this behaviour, alongside VM_STICKY as sticky flags by
implication must not disallow merge.

Ultimately it seems that we should make VM_SOFTDIRTY a sticky flag in its
own right, but this change is out of scope for this series.

The only sticky flag designated as such is VM_MAYBE_GUARD, so as a result
of this change, once the VMA flag is set upon guard region installation,
VMAs with guard ranges will now not have their merge behaviour impacted as
a result and can be freely merged with other VMAs without VM_MAYBE_GUARD
set.

Also update the comments for vma_modify_flags() to directly reference
sticky flags now we have established the concept.

We also update the VMA userland tests to account for the changes.

Link: https://lkml.kernel.org/r/22ad5269f7669d62afb42ce0c79bad70b994c58d.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
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
 include/linux/mm.h               |   28 ++++++++++++++++++++++++++++
 mm/vma.c                         |   31 +++++++++++++++++--------------
 mm/vma.h                         |   10 ++++------
 tools/testing/vma/vma_internal.h |   28 ++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 20 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -511,6 +511,34 @@ extern unsigned int kobjsize(const void
 #define VM_FLAGS_CLEAR	(ARCH_VM_PKEY_FLAGS | VM_ARCH_CLEAR)
 
 /*
+ * Flags which should be 'sticky' on merge - that is, flags which, when one VMA
+ * possesses it but the other does not, the merged VMA should nonetheless have
+ * applied to it:
+ *
+ * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
+ *                  mapped page tables may contain metadata not described by the
+ *                  VMA and thus any merged VMA may also contain this metadata,
+ *                  and thus we must make this flag sticky.
+ */
+#define VM_STICKY VM_MAYBE_GUARD
+
+/*
+ * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
+ * of these flags and the other not does not preclude a merge.
+ *
+ * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
+ *                dirty bit -- the caller should mark merged VMA as dirty. If
+ *                dirty bit won't be excluded from comparison, we increase
+ *                pressure on the memory system forcing the kernel to generate
+ *                new VMAs when old one could be extended instead.
+ *
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
+ */
+#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+
+/*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -82,15 +82,7 @@ static inline bool is_mergeable_vma(stru
 
 	if (!mpol_equal(vmg->policy, vma_policy(vma)))
 		return false;
-	/*
-	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
-	 * match the flags but dirty bit -- the caller should mark
-	 * merged VMA as dirty. If dirty bit won't be excluded from
-	 * comparison, we increase pressure on the memory system forcing
-	 * the kernel to generate new VMAs when old one could be
-	 * extended instead.
-	 */
-	if ((vma->vm_flags ^ vmg->vm_flags) & ~VM_SOFTDIRTY)
+	if ((vma->vm_flags ^ vmg->vm_flags) & ~VM_IGNORE_MERGE)
 		return false;
 	if (vma->vm_file != vmg->file)
 		return false;
@@ -810,6 +802,7 @@ static bool can_merge_remove_vma(struct
 static __must_check struct vm_area_struct *vma_merge_existing_range(
 		struct vma_merge_struct *vmg)
 {
+	vm_flags_t sticky_flags = vmg->vm_flags & VM_STICKY;
 	struct vm_area_struct *middle = vmg->middle;
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next;
@@ -904,11 +897,13 @@ static __must_check struct vm_area_struc
 	if (merge_right) {
 		vma_start_write(next);
 		vmg->target = next;
+		sticky_flags |= (next->vm_flags & VM_STICKY);
 	}
 
 	if (merge_left) {
 		vma_start_write(prev);
 		vmg->target = prev;
+		sticky_flags |= (prev->vm_flags & VM_STICKY);
 	}
 
 	if (merge_both) {
@@ -978,6 +973,7 @@ static __must_check struct vm_area_struc
 	if (err || commit_merge(vmg))
 		goto abort;
 
+	vm_flags_set(vmg->target, sticky_flags);
 	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -1156,14 +1152,20 @@ int vma_expand(struct vma_merge_struct *
 	struct vm_area_struct *target = vmg->target;
 	struct vm_area_struct *next = vmg->next;
 	int ret = 0;
+	vm_flags_t sticky_flags;
+
+	sticky_flags = vmg->vm_flags & VM_STICKY;
+	sticky_flags |= target->vm_flags & VM_STICKY;
 
 	VM_WARN_ON_VMG(!target, vmg);
 
 	mmap_assert_write_locked(vmg->mm);
 	vma_start_write(target);
 
-	if (next && target != next && vmg->end == next->vm_end)
+	if (next && target != next && vmg->end == next->vm_end) {
+		sticky_flags |= next->vm_flags & VM_STICKY;
 		remove_next = true;
+	}
 
 	/* We must have a target. */
 	VM_WARN_ON_VMG(!target, vmg);
@@ -1197,6 +1199,7 @@ int vma_expand(struct vma_merge_struct *
 	if (commit_merge(vmg))
 		goto nomem;
 
+	vm_flags_set(target, sticky_flags);
 	return 0;
 
 nomem:
@@ -1692,9 +1695,9 @@ struct vm_area_struct *vma_modify_flags(
 		return ret;
 
 	/*
-	 * For a merge to succeed, the flags must match those requested. For
-	 * flags which do not obey typical merge rules (i.e. do not need to
-	 * match), we must let the caller know about them.
+	 * For a merge to succeed, the flags must match those
+	 * requested. However, sticky flags may have been retained, so propagate
+	 * them to the caller.
 	 */
 	if (vmg.state == VMA_MERGE_SUCCESS)
 		*vm_flags_ptr = ret->vm_flags;
@@ -1959,7 +1962,7 @@ static int anon_vma_compatible(struct vm
 	return a->vm_end == b->vm_start &&
 		mpol_equal(vma_policy(a), vma_policy(b)) &&
 		a->vm_file == b->vm_file &&
-		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_SOFTDIRTY)) &&
+		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_IGNORE_MERGE)) &&
 		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
 }
 
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -276,17 +276,15 @@ void unmap_region(struct ma_state *mas,
  * @start: The start of the range to update. May be offset within @vma.
  * @end: The exclusive end of the range to update, may be offset within @vma.
  * @vm_flags_ptr: A pointer to the VMA flags that the @start to @end range is
- * about to be set to. On merge, this will be updated to include any additional
- * flags which remain in place.
+ * about to be set to. On merge, this will be updated to include sticky flags.
  *
  * IMPORTANT: The actual modification being requested here is NOT applied,
  * rather the VMA is perhaps split, perhaps merged to accommodate the change,
  * and the caller is expected to perform the actual modification.
  *
- * In order to account for VMA flags which may persist (e.g. soft-dirty), the
- * @vm_flags_ptr parameter points to the requested flags which are then updated
- * so the caller, should they overwrite any existing flags, correctly retains
- * these.
+ * In order to account for sticky VMA flags, the @vm_flags_ptr parameter points
+ * to the requested flags which are then updated so the caller, should they
+ * overwrite any existing flags, correctly retains these.
  *
  * Returns: A VMA which contains the range @start to @end ready to have its
  * flags altered to *@vm_flags.
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -117,6 +117,34 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_SEALED	VM_NONE
 #endif
 
+/*
+ * Flags which should be 'sticky' on merge - that is, flags which, when one VMA
+ * possesses it but the other does not, the merged VMA should nonetheless have
+ * applied to it:
+ *
+ * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
+ *                  mapped page tables may contain metadata not described by the
+ *                  VMA and thus any merged VMA may also contain this metadata,
+ *                  and thus we must make this flag sticky.
+ */
+#define VM_STICKY VM_MAYBE_GUARD
+
+/*
+ * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
+ * of these flags and the other not does not preclude a merge.
+ *
+ * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
+ *                dirty bit -- the caller should mark merged VMA as dirty. If
+ *                dirty bit won't be excluded from comparison, we increase
+ *                pressure on the memory system forcing the kernel to generate
+ *                new VMAs when old one could be extended instead.
+ *
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
+ */
+#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
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

