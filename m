Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 967B3CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098BC6B008C; Tue, 12 May 2026 22:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048EB6B0092; Tue, 12 May 2026 22:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8C36B0093; Tue, 12 May 2026 22:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA3416B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:40:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C2FF1607F9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:40:20 +0000 (UTC)
X-FDA: 84760842600.13.F8AF508
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1B2E140002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:40:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=A2FuXQvI;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778640018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxa1zwc8/cm+mLiEckIR305d3umVzPSTNl6hAaKDQzQ=;
	b=zoEwH02d8eIz6WeYhFuvnPFl2o1a4fH7AK+Ershp3oMPkJMhqJkH/UcXKRp5iagggWDpKi
	jX6Oe2cCCFLAQ7606M0X5PZ1K++wT9/HTum3Zym0Ls6DXLmGpOPJuq/tYX/z8GlVYELBRo
	WmXxgaQVJ5Qb2zwwkbkcu5cPpmYBalY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778640018; a=rsa-sha256;
	cv=none;
	b=tjRULqleT9yB9k5HU7y7Xksp6khOTy06TsRgc/I6GzyykQhXOSR/N7v4dQD+Xah73dS/hX
	KMNU4Ies0394WOp9ssJbyTVAtNf83kIJGJvlxayMiD4c/yDCEo/2aBWcTykXEvpYh5VZvt
	E7Mo95lK6rZ/J4hE9HEwq0QeOj/pZ6k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=A2FuXQvI;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com
Received: from skinsburskii-cloud-desktop.internal.cloudapp.net (unknown [4.155.116.186])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4844020B7166;
	Tue, 12 May 2026 19:40:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4844020B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1778640014;
	bh=yxa1zwc8/cm+mLiEckIR305d3umVzPSTNl6hAaKDQzQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=A2FuXQvInwyVieeW+B+eFYLjE3R/qeTacd9KUAE6c8TItvAAC4MWAX0z8CKEZNsH+
	 XJS72RrfwFjPnF6fOuaz/4aAgAD3p/wuT9yASIU8RoZnvoKGOYWDkrknBtFencctVr
	 Z6+bBG0aXEMbqhUqfha9fPiRqbfhNSONdP4YoFLw=
Subject: [PATCH v2 1/3] mm/hmm: move page fault handling out of walk callbacks
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Wed, 13 May 2026 02:40:16 +0000
Message-ID: 
 <177864001656.82528.9115031342002471809.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
In-Reply-To: 
 <177863991557.82528.15288076059759579141.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
References: 
 <177863991557.82528.15288076059759579141.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A1B2E140002
X-Stat-Signature: 8umnfiopejd1h941nf9dcisyye1un8co
X-Rspam-User: 
X-HE-Tag: 1778640018-648655
X-HE-Meta: U2FsdGVkX19KtYVZW1/HPOz0+rgl89yHuLiTSPEESzBC5k090KkwJqHv0sXkj9HYiTOlu8N/m40Ob4p3n82oCl53qGxbynaQsPPNneX8AFUVDZZ3rnu8hDp+sDrHYuMvnYrWyhtppisQT38Mkv4RtS2NAqcuUkyqWV4Na1KOVecDW0Yca+lIzFoJNcdXBGNTt4orOls7R44RrirlRABGspHWU9kHjVRsau+LphIv8QoSxs2rcpEfuQq0srLeGCro+ymG/0YWEMTqRejOcSk2tZjgIphd3B8aTNO1xEcZ4/RemjQp3xFpXN1R/zfk7IBfRoUL0CVeL4TCSLz7JJ+vPXQ28KUPOomebdZzwjLWLz676DieAdTIGx1JSm31iwm+3nCsxX1M9t6m9qbBmTpUx+Gt7hkWHIayZihJRl2NTB0duMswDjAw61oug70kdFoMG8tvxDors1P7ydpI8yH/Ri/Qwrxc/KeuPgxa+3UAFxVnbQse8XJ5M4dzHR4MSILtOB8e03VfJh1/O0QNa6sQCBfuDGFZygz9ZdbI2Ci4D8KAZArxuizajF61gDxUdFDC3j7lDQ7mqh/Dwu430Q9gJ6VhCiLEE+LzX78N5DZKQdmxxS18weUUfXu+q2JGd7vhqIKCruFKghxlDh2sLP6GimTRQs06teXwf9AixgiEMhKnPiKg8q45Mci9jkXlixLyd51cP/0il4f4PW5Z+lmoF/i8vZQuHYRVkQjHPN9DAJ/pfIk1Iih9Yd08zYTWw8uWQLyXtVXPHYeL5GM8aOVH6sObKemcFKWyHAZ5njyR+6gdM/7ft6OwMagz2Mt/cxGQMPYyo5D928JMc3dQS+BiA+nd1nMrdQ+/0QlJcFVREbNg3WzsbDKyUDAcpZ8I7mAbVbFJkfyTI0cghRjEz3kbH0aI/1DYwqQaiGYCukJfqnctY2BpV/naGObHNt6qCMgB7hejNLp0JsOCVYT2CmR
 OY+Ltj2k
 Sp5NQ87E6VqCgpDfX9382oFSscAZQoNcPbsNUKQweHm6vVPMlGpW0PQ20BkhLqiOA8Y51rFekdwWx1+fdYiNX/+E6fvuMdCaZHJ4eVGelgXcZj+6PAW13jFMRI4TzKlkaNFwrhdgBePkvtLZXtyM1Q705HeICZX4Fb5LWkD9F8rIjswSZ9Jdo/ua2NS+A0Gm8brnCULXx/umbSq1/IY35AcLo/DowyjycmdKTUqhWh/tHXaPUHLm+oZnSjI7OC+8KNtFr0GHm2wAV/YS+ruo023+tSQgZfV6bg8Xtjd4eyVE2u2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hmm_range_fault() currently triggers page faults from inside the page-table
walk callbacks: hmm_vma_walk_pmd(), hmm_vma_walk_pud(),
hmm_vma_walk_hugetlb_entry() and the pte-level helper all call
hmm_vma_fault(), which in turn calls handle_mm_fault() while the walker
still holds nested locks.  The pte spinlock is dropped explicitly by each
caller, and the hugetlb path manually drops and retakes
hugetlb_vma_lock_read around the fault to dodge a deadlock against the walk
framework's unconditional unlock.

This layering does not extend cleanly to fault handlers that may release
mmap_lock (VM_FAULT_RETRY, VM_FAULT_COMPLETED). If the lock is dropped
while walk_page_range() is mid-traversal, the VMA can be freed before the
walk framework's matching hugetlb_vma_unlock_read(), turning that unlock
into a use-after-free.

Split the responsibilities the way get_user_pages() does. Walk callbacks
become inspect-only: when they detect a range that needs to be faulted in,
they record it in struct hmm_vma_walk and return a private sentinel
(HMM_FAULT_PENDING). The outer loop in hmm_range_fault() then drops out of
walk_page_range(), invokes a new helper hmm_do_fault() that calls
handle_mm_fault() with only mmap_lock held, and restarts the walk so the
now-present entries are collected into hmm_pfns.

No functional change for existing callers. As a side effect the hugetlb
callback no longer needs the hugetlb_vma_{un}lock_read dance, and every
fault-path exit from the callbacks now releases the pte spinlock on a
single, common path. This refactor is also a precursor for adding an
unlockable variant of hmm_range_fault() in a follow-up patch.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
---
 mm/hmm.c |  118 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 75 insertions(+), 43 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 5955f2f0c83db..2b157fcbc2928 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -33,8 +33,17 @@
 struct hmm_vma_walk {
 	struct hmm_range	*range;
 	unsigned long		last;
+	unsigned long		end;
+	unsigned int		required_fault;
 };
 
+/*
+ * Internal sentinel returned by walk callbacks when they need a page fault.
+ * The callback stores end/required_fault in hmm_vma_walk; the outer loop
+ * consumes the sentinel and never propagates it to the caller.
+ */
+#define HMM_FAULT_PENDING	-EAGAIN
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -60,37 +69,25 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 }
 
 /*
- * hmm_vma_fault() - fault in a range lacking valid pmd or pte(s)
- * @addr: range virtual start address (inclusive)
- * @end: range virtual end address (exclusive)
- * @required_fault: HMM_NEED_* flags
- * @walk: mm_walk structure
- * Return: -EBUSY after page fault, or page fault error
+ * hmm_record_fault() - record a range that needs to be faulted in
  *
- * This function will be called whenever pmd_none() or pte_none() returns true,
- * or whenever there is no page directory covering the virtual address range.
+ * Called by the walk callbacks when they discover that part of the range
+ * needs a page fault.  The callback records what to fault and returns
+ * HMM_FAULT_PENDING; the outer loop in hmm_range_fault() drops back out of
+ * walk_page_range() and invokes handle_mm_fault() from a context where no
+ * page-table or hugetlb_vma_lock is held.
  */
-static int hmm_vma_fault(unsigned long addr, unsigned long end,
-			 unsigned int required_fault, struct mm_walk *walk)
+static int hmm_record_fault(unsigned long addr, unsigned long end,
+			    unsigned int required_fault,
+			    struct mm_walk *walk)
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 
 	WARN_ON_ONCE(!required_fault);
 	hmm_vma_walk->last = addr;
-
-	if (required_fault & HMM_NEED_WRITE_FAULT) {
-		if (!(vma->vm_flags & VM_WRITE))
-			return -EPERM;
-		fault_flags |= FAULT_FLAG_WRITE;
-	}
-
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
-			return -EFAULT;
-	return -EBUSY;
+	hmm_vma_walk->end = end;
+	hmm_vma_walk->required_fault = required_fault;
+	return HMM_FAULT_PENDING;
 }
 
 static unsigned int hmm_pte_need_fault(const struct hmm_vma_walk *hmm_vma_walk,
@@ -174,7 +171,7 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
 	}
 	if (required_fault)
-		return hmm_vma_fault(addr, end, required_fault, walk);
+		return hmm_record_fault(addr, end, required_fault, walk);
 	return hmm_pfns_fill(addr, end, range, 0);
 }
 
@@ -209,7 +206,7 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 	required_fault =
 		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
 	if (required_fault)
-		return hmm_vma_fault(addr, end, required_fault, walk);
+		return hmm_record_fault(addr, end, required_fault, walk);
 
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
@@ -328,7 +325,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 fault:
 	pte_unmap(ptep);
 	/* Fault any virtual address we were asked to fault */
-	return hmm_vma_fault(addr, end, required_fault, walk);
+	return hmm_record_fault(addr, end, required_fault, walk);
 }
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
@@ -371,7 +368,7 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 					      npages, 0);
 	if (required_fault) {
 		if (softleaf_is_device_private(entry))
-			return hmm_vma_fault(addr, end, required_fault, walk);
+			return hmm_record_fault(addr, end, required_fault, walk);
 		else
 			return -EFAULT;
 	}
@@ -517,7 +514,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
 						      npages, cpu_flags);
 		if (required_fault) {
 			spin_unlock(ptl);
-			return hmm_vma_fault(addr, end, required_fault, walk);
+			return hmm_record_fault(addr, end, required_fault, walk);
 		}
 
 		pfn = pud_pfn(pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
@@ -564,21 +561,8 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	required_fault =
 		hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, cpu_flags);
 	if (required_fault) {
-		int ret;
-
 		spin_unlock(ptl);
-		hugetlb_vma_unlock_read(vma);
-		/*
-		 * Avoid deadlock: drop the vma lock before calling
-		 * hmm_vma_fault(), which will itself potentially take and
-		 * drop the vma lock. This is also correct from a
-		 * protection point of view, because there is no further
-		 * use here of either pte or ptl after dropping the vma
-		 * lock.
-		 */
-		ret = hmm_vma_fault(addr, end, required_fault, walk);
-		hugetlb_vma_lock_read(vma);
-		return ret;
+		return hmm_record_fault(addr, end, required_fault, walk);
 	}
 
 	pfn = pte_pfn(entry) + ((start & ~hmask) >> PAGE_SHIFT);
@@ -637,6 +621,44 @@ static const struct mm_walk_ops hmm_walk_ops = {
 	.walk_lock	= PGWALK_RDLOCK,
 };
 
+/*
+ * hmm_do_fault - fault in a range recorded by a walk callback
+ *
+ * Called from the outer loop in hmm_range_fault() after a callback
+ * returned HMM_FAULT_PENDING.  At this point we hold only mmap_lock;
+ * the page-table spinlock and any hugetlb_vma_lock acquired by the walk
+ * framework have already been released by the unwind.
+ *
+ * Returns -EBUSY on success (all pages faulted, caller should re-walk).
+ * Returns a negative errno on failure.
+ */
+static int hmm_do_fault(struct mm_struct *mm,
+			struct hmm_vma_walk *hmm_vma_walk)
+{
+	unsigned long addr = hmm_vma_walk->last;
+	unsigned long end = hmm_vma_walk->end;
+	unsigned int required_fault = hmm_vma_walk->required_fault;
+	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+	struct vm_area_struct *vma;
+
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		return -EFAULT;
+
+	if (required_fault & HMM_NEED_WRITE_FAULT) {
+		if (!(vma->vm_flags & VM_WRITE))
+			return -EPERM;
+		fault_flags |= FAULT_FLAG_WRITE;
+	}
+
+	for (; addr < end; addr += PAGE_SIZE)
+		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
+		    VM_FAULT_ERROR)
+			return -EFAULT;
+
+	return -EBUSY;
+}
+
 /**
  * hmm_range_fault - try to fault some address in a virtual address range
  * @range:	argument structure
@@ -674,6 +696,16 @@ int hmm_range_fault(struct hmm_range *range)
 			return -EBUSY;
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
+		/*
+		 * When HMM_FAULT_PENDING is returned a walk callback
+		 * recorded a range that needs handle_mm_fault();
+		 * hmm_do_fault() runs the fault outside walk_page_range()
+		 * (so no page-table or hugetlb_vma_lock is held) and
+		 * returns -EBUSY so the loop re-walks and picks up the
+		 * now-present entries.
+		 */
+		if (ret == HMM_FAULT_PENDING)
+			ret = hmm_do_fault(mm, &hmm_vma_walk);
 		/*
 		 * When -EBUSY is returned the loop restarts with
 		 * hmm_vma_walk.last set to an address that has not been stored



