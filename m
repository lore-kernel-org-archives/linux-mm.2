Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8FDE87843
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 16:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725356B0098; Tue,  3 Feb 2026 11:00:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4C06B00A2; Tue,  3 Feb 2026 11:00:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2A36B00A4; Tue,  3 Feb 2026 11:00:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0FF6B0098
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:00:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1F65593C6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 15:59:59 +0000 (UTC)
X-FDA: 84403606518.08.F7CCBEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1DA3414000B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 15:59:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=EsVGlu9X;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770134398; a=rsa-sha256;
	cv=none;
	b=NUljcguDKNczACXc/t5a25aLnUXrlYH4yQ5XCSoxY9Pm7BkurFHFUdAkDI0rCtR8NwXfvz
	kOoff8we5axfiLEkFoTDtPlJjYalcE3gm5qyW1zaVDvDeBOx8GaqeDBuEjeRkY2DR7XMK1
	iq8Hw9++EXQcRk1r/V2ehVdyD3SewDM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=EsVGlu9X;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770134398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=YXeHjSiEvVcf53Wnft+MNxRo1UbL7P6nVDtesVFy8UU=;
	b=PnMIqaY9VxYZJnPPoAkKPLoFc2YHNRX1G7pmb2moZXMsJNRmCvOvBPGP1CKCoF//14XWnL
	tVsqbYNOvaubbcnZruNl8d9gVQLoq+AY+OF9cxYhPNlAidkLTEy3sJTX7rXbgzvuf3V/1D
	p9TqQn4ErDaWVf0FUdl5YSIHQt1OIn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6086C60144;
	Tue,  3 Feb 2026 15:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD0CC116D0;
	Tue,  3 Feb 2026 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770134397;
	bh=HYHjtaPvzbIb/wtXUUmIVpY8sOrq4uboL39HdupMVDs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=EsVGlu9XVVYEeDI0ndyE25KQWlPG9+ISVNAgNaCJKauNbC39Pn54Z7EqL3BidATGo
	 ogWkpn0I9OU15rP6uh3fDFYW5yvZWNuNvmLTVA3Fm8L2czyum9d8JeyNZBw+1/nPwR
	 ilWFLssltL+4W1RVxyhJJvNW2SjtHYlJ226oacOE=
Subject: Patch "Revert "mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()"" has been added to the 6.1-stable tree
To: Liam.Howlett@oracle.com,akpm@linux-foundation.org,david@kernel.org,gregkh@linuxfoundation.org,harry.yoo@oracle.com,hughd@google.com,jannh@google.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,pfalcato@suse.de,vbabka@suse.cz
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 16:59:09 +0100
In-Reply-To: <20260116033838.20253-1-harry.yoo@oracle.com>
Message-ID: <2026020309-precision-uncork-1d24@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1DA3414000B
X-Stat-Signature: 8ebqg5cm4tz9ixjdw649uwrcp1c4dcz7
X-HE-Tag: 1770134397-48454
X-HE-Meta: U2FsdGVkX19m2b5Z8ltYBpv98CRs3LS5TpCdzarAkzic9zQHHTzg2gFHkG73FwudNnMyeoCVmchF2Jozmax1l7HLk5pTKtYWMRJ3X1UXrel4eVV7h5y2UVoY/3YYAKtxDAaqHA3WvuCleK2X0qyA2tZZalhFRFov6Ws3lxXU9r4dU6eqdUtOHc3Ua5l/MNlE0GcKI/StFaBols+bhRoASA3Us7PKWG9LxKnzuEKESsOjRj7el9OMUOrtVpzif/pjVmN8GgWdVsC3xPtNpmSUS3NwPPE4tZFn/1xKIgKkvaPzMrv8KLuqvk00E4Qvo5OqGVuf3j2SADwGPDH3plX8NDX3kfRJV5oCZmwlL9QU7tV2XmSeLLuUinWDsmctZfYx7ClLdE3okmcprloep/Jv781lHLMnJDVDz+VpBPbXaW5ff8HFNSrXHBN6jaHFHOK4JFpP6tH2tPzhAH1UFN05VfsYXvQzf12FlP/VrPNsC4baAU3iwSQo12opxNHAL0+jfUIuTKSGsOwMD1MunPX1qYnx5xYl3AI0LCFTy7JJt/7SmtiRk6rkNkCw1/w2yP9Rtr5OzECAZro8S82A+Co+5e0D0frpmogLuEYuFubsJ4lDqdNRcITUI+VWVfnkjcf8M8A+zGrKnPuHwfcndPl3TKCeu4Qav4ipMAtJVf9NIeQsZaXGxyl82fyb9ar1z/n9gFJRaIlMgrilW0yygBKDpPvTl0/iJK81yJhwgEQOjcRlLeyir/xQM8Az6zGuosmxf1ohyVBe2guQTNEqQVPE6vJa8G9uFrorrjDOuBLls5aeSy8iSzrPeUZBzQhNqWG+LXNi/u5ePJdJ8h3MSi5KOrcl32sVVe0gqQ9ynMzvXQRUHx1i0DyoHEBYiWbfcBW9PJhMXOz9IX0SiXTFF0aRy7BaF24C+mHnoJPikArWCU9uCMOfrQ3EdF0tcDA7zAREUC12S+G/OE5YD+tX9K/
 o3ogUH1J
 IYmGAKhkkTNxV/ycbojVwNTxCS5F6FqC47JyudgWjbICRMGblPB+GgjTSAgliL20PYS/NN7QwF0xiClTyXgRrcQIOI5/H//cHTGbZnz3pAi9UUsZoexFyKvLZqbIOBskUy4Jq5OyrULWy5zjJAcxbe85tuZSua+O8bsgw1/mblubjlvGz/IgY2hZP0bjKAk4xR5Mj1UaHutUQHQF9iBh2ja3TfC7CE08oxsS0M1KP8yHxhHKLPM57kT8A2N5GONDBIx4OdoVX0+SOQWGVWdH2XVc45FcEFlxNGgPuo0Tnl/hzlVvsvwMUtg3oxNn/Z494v0SBJ2+Rh2zeGaZMRSAGnwmMs2O+2SJ7LSrtt271rnoh5gEkInOOjlCHSjEiYmyeFA4WG/cVuSQ/kxl4oBqjpzEWsn/0bJT8X2z9bsxmef5magofgZ+g3M7glb8UD3rwpkHo1GqUUzxBZieZgotobo3tu5FAPO6WMqtWt6dDtTSdU0cFkwH7g1cSOuJIm6oQj2qyFVDNfTeUihIc/TxIibZ9Q5/4ADaWFmkrVW4g5J5o0C+k1zcR2yBVeKdaMQ8OZcimYXImPMwYAkRJMmeJ3wQBj7zl4nxdsQO+nTdr5KKgbbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    Revert "mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()"

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     revert-mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-209984-greg=kroah.com@vger.kernel.org Fri Jan 16 04:40:33 2026
From: Harry Yoo <harry.yoo@oracle.com>
Date: Fri, 16 Jan 2026 12:38:38 +0900
Subject: Revert "mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, hughd@google.com, jannh@google.com, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, pfalcato@suse.de, vbabka@suse.cz, Harry Yoo <harry.yoo@oracle.com>
Message-ID: <20260116033838.20253-1-harry.yoo@oracle.com>

From: Harry Yoo <harry.yoo@oracle.com>

This reverts commit 91750c8a4be42d73b6810a1c35d73c8a3cd0b481 which is
commit 670ddd8cdcbd1d07a4571266ae3517f821728c3a upstream.

While the commit fixes a race condition between NUMA balancing and THP
migration, it causes a NULL-pointer-deref when the pmd temporarily
transitions from pmd_trans_huge() to pmd_none(). Verifying whether the
pmd value has changed under page table lock does not prevent the crash,
as it occurs when acquiring the lock.

Since the original issue addressed by the commit is quite rare and
non-fatal, revert the commit. A better backport solution that more
closely matches the upstream semantics will be provided as a follow-up.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mprotect.c |  101 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 58 insertions(+), 43 deletions(-)

--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -73,12 +73,10 @@ static inline bool can_change_pte_writab
 }
 
 static long change_pte_range(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, pmd_t *pmd, pmd_t pmd_old,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		unsigned long cp_flags)
+		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
+		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
-	pmd_t _pmd;
 	spinlock_t *ptl;
 	long pages = 0;
 	int target_node = NUMA_NO_NODE;
@@ -88,15 +86,21 @@ static long change_pte_range(struct mmu_
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
 
+	/*
+	 * Can be called with only the mmap_lock for reading by
+	 * prot_numa so we must check the pmd isn't constantly
+	 * changing from under us from pmd_none to pmd_trans_huge
+	 * and/or the other way around.
+	 */
+	if (pmd_trans_unstable(pmd))
+		return 0;
+
+	/*
+	 * The pmd points to a regular pte so the pmd can't change
+	 * from under us even if the mmap_lock is only hold for
+	 * reading.
+	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	/* Make sure pmd didn't change after acquiring ptl */
-	_pmd = pmd_read_atomic(pmd);
-	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
-	barrier();
-	if (!pmd_same(pmd_old, _pmd)) {
-		pte_unmap_unlock(pte, ptl);
-		return -EAGAIN;
-	}
 
 	/* Get target node for single threaded private VMAs */
 	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
@@ -284,6 +288,31 @@ static long change_pte_range(struct mmu_
 	return pages;
 }
 
+/*
+ * Used when setting automatic NUMA hinting protection where it is
+ * critical that a numa hinting PMD is not confused with a bad PMD.
+ */
+static inline int pmd_none_or_clear_bad_unless_trans_huge(pmd_t *pmd)
+{
+	pmd_t pmdval = pmd_read_atomic(pmd);
+
+	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	barrier();
+#endif
+
+	if (pmd_none(pmdval))
+		return 1;
+	if (pmd_trans_huge(pmdval))
+		return 0;
+	if (unlikely(pmd_bad(pmdval))) {
+		pmd_clear_bad(pmd);
+		return 1;
+	}
+
+	return 0;
+}
+
 /* Return true if we're uffd wr-protecting file-backed memory, or false */
 static inline bool
 uffd_wp_protect_file(struct vm_area_struct *vma, unsigned long cp_flags)
@@ -331,34 +360,22 @@ static inline long change_pmd_range(stru
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		long ret;
-		pmd_t _pmd;
-again:
+		long this_pages;
+
 		next = pmd_addr_end(addr, end);
-		_pmd = pmd_read_atomic(pmd);
-		/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		barrier();
-#endif
 
 		change_pmd_prepare(vma, pmd, cp_flags);
 		/*
 		 * Automatic NUMA balancing walks the tables with mmap_lock
 		 * held for read. It's possible a parallel update to occur
-		 * between pmd_trans_huge(), is_swap_pmd(), and
-		 * a pmd_none_or_clear_bad() check leading to a false positive
-		 * and clearing. Hence, it's necessary to atomically read
-		 * the PMD value for all the checks.
+		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
+		 * check leading to a false positive and clearing.
+		 * Hence, it's necessary to atomically read the PMD value
+		 * for all the checks.
 		 */
-		if (!is_swap_pmd(_pmd) && !pmd_devmap(_pmd) && !pmd_trans_huge(_pmd)) {
-			if (pmd_none(_pmd))
-				goto next;
-
-			if (pmd_bad(_pmd)) {
-				pmd_clear_bad(pmd);
-				goto next;
-			}
-		}
+		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
+		     pmd_none_or_clear_bad_unless_trans_huge(pmd))
+			goto next;
 
 		/* invoke the mmu notifier if the pmd is populated */
 		if (!range.start) {
@@ -368,7 +385,7 @@ again:
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
-		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
+		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    uffd_wp_protect_file(vma, cp_flags)) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
@@ -383,11 +400,11 @@ again:
 				 * change_huge_pmd() does not defer TLB flushes,
 				 * so no need to propagate the tlb argument.
 				 */
-				ret = change_huge_pmd(tlb, vma, pmd,
-						      addr, newprot, cp_flags);
+				int nr_ptes = change_huge_pmd(tlb, vma, pmd,
+						addr, newprot, cp_flags);
 
-				if (ret) {
-					if (ret == HPAGE_PMD_NR) {
+				if (nr_ptes) {
+					if (nr_ptes == HPAGE_PMD_NR) {
 						pages += HPAGE_PMD_NR;
 						nr_huge_updates++;
 					}
@@ -398,11 +415,9 @@ again:
 			}
 			/* fall through, the trans huge pmd just split */
 		}
-		ret = change_pte_range(tlb, vma, pmd, _pmd, addr, next,
-				       newprot, cp_flags);
-		if (ret < 0)
-			goto again;
-		pages += ret;
+		this_pages = change_pte_range(tlb, vma, pmd, addr, next,
+					      newprot, cp_flags);
+		pages += this_pages;
 next:
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);


Patches currently in stable-queue which might be from harry.yoo@oracle.com are

queue-6.1/revert-mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
queue-6.1/mm-kfence-describe-slab-parameter-in-__kfence_obj_in.patch
queue-6.1/mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch

