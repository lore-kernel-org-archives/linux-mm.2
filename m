Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DF2ACD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652C56B008A; Wed, 20 May 2026 10:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603CA6B008C; Wed, 20 May 2026 10:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519E16B0092; Wed, 20 May 2026 10:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 407EF6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:09:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0550A8CD3D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:09:31 +0000 (UTC)
X-FDA: 84787980942.10.2EBA981
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1B1AE2000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:09:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eAoIjPDp;
	spf=pass (imf13.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779286169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2P1kNg4b1RcRkebULzAbgfr7kwFAXtEaP6bPGhO1Ac=;
	b=1C036Zk9zRLyZMNtwI6Pg848XMU4zVhF6Tnm3nt7l1WsLwcFiZcGovbSjMAiFzSa0CbS3O
	OuY9CCBttX9aJVBg9VwzXKtAoglvImpNGJqubYssDFpUL2eKoC6u6JwRDduNseK8l1tncE
	c4X+56d+zjo4Tm6dZ788CUsuHdMTLJM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eAoIjPDp;
	spf=pass (imf13.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779286169; a=rsa-sha256;
	cv=none;
	b=TUGC54qHVWub/PP95P4VXo+ckjpZk8VlSGBcgLbZrapBcf4XQq/QD0s82evplhZ7PFlcJn
	Fu82Vm2TfeKeHn5gWkgGe8ZOkkWqC+/r49Wqh/jbvbb/y0bLoxTUR71i1K9DjeMVctv89Q
	ThO3GSrtGl5PUf0vyC5catpWIhQTh9U=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82fbdd60b64so4023105b3a.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779286168; x=1779890968; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N2P1kNg4b1RcRkebULzAbgfr7kwFAXtEaP6bPGhO1Ac=;
        b=eAoIjPDplaPVtR7ldFLUTYWB5EUE4wzf7FWxmXZTIRFf6yEDa8H+giJHT200gXYJLp
         xEsGf3s+g3alokVxz1+zsblSh4JiSDIlbiFN5WrYudvpkeIre8bC1fjRznEejYuIy+uo
         rTfrvuv5L7J5s0vWzqRulKH+3NE1vCWSVWLiJomhc8nNmM/4Uq4SZYH/EGWsYkbn1DWK
         XGTJuK0ikIq0EqCkwH4chJxfzyARQymlejx0jqtCHXJS/WdgEU65NJjlod4PGAvE5EE6
         eOE2p9639Vp00Z8yy1lZkVisLtzIls3PRYq7mB3N+6FG6WrtoiL6Ns9scSWmVN8JVAtZ
         oIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779286168; x=1779890968;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N2P1kNg4b1RcRkebULzAbgfr7kwFAXtEaP6bPGhO1Ac=;
        b=RJlQlZP87I/XUHaNrON5ccp2WIiIBIuldS5FgWUGJA4m6K0qw7aMY7SK5k2Caq/eSm
         G2S74ADvDOsX2M+vpz032HBtt8GMVbBLySwJNbnYoC9/n5Vlb2PVuwGsWQIrEyG7KGDS
         P+R1nlLUSUWjWRFSWEx1uFr4XMc/1UVNProHFFP5Brdp/j4f6NCa/0oxtb9l1pbhuIs3
         p5NxYcGKw00HUKarun542vzpat37RYnSqCU92q77tMNy3bvD1ab/gKsmdqoSHChOhWeC
         HuViIn/CTWbZAv00oFkbQq83xxqbhIEp5yx1Vyd5aYzPwpzj4YHUKUcqN8GUvP8W8x+S
         ghEg==
X-Forwarded-Encrypted: i=1; AFNElJ8Oj27e+1nkX3HLlGwqozlO1+g26x0K+lTbqNxstth8LRFw5ISCQ55Ttal2LWXFuBMURvZUcI4/tA==@kvack.org
X-Gm-Message-State: AOJu0Yx5q6RWi7X4mmHF9OoKFYLcWcBAynlQDL1Fgtd9l7tM2Q7K408P
	nTYDFtUpF+q7tP3aTOVsMuNV/j5NfFhzMGkorv5oi6GwAGU2X2k6reAn
X-Gm-Gg: Acq92OEKkXYZjOOXOigGiQu+lRFDCeUkUl1jQMQLXkF4QtodCy45jqO1XR2flHQ2QNm
	ayckF/3TXitjeJigAGBFQj+0lJFjD7rsmoJ9MoIzhZOijEEnNj80yTs1dygeh3X3ciWuciVkJAQ
	o50SPN1lNkCHs8v86kGVTB8eZ+6vbOgxVpiW9I7sNaoCKWzAPynLjRMCay5/Y+O4xGjSNHccFz1
	gIcn/B7izwQmpj4s2czpZqLT8PssQButPwV8Sqm1m5+JLznosNei8rpccBr3vjbTklw4Vbuw+PR
	c9Y+jFwlgr/JnIUFlGn9sbcRZPgBWn/UO1z7c5YKXqgqOOTq12ZaOfojiqfDLttx2L+dgiLg3xG
	Vk5z4KuYCYaL5rkuZv7wR8IbNykDUsZg8D/imS+rpB68Z1NUNISWgi7eA2MnXvUNBj5xcw/OZUP
	drnHzBuF7eLV3qbtVRf2+nAjEED3+7aidn+Lzn1VEUueZrv9X/66FhfXJniy15bKfKuRYCKQ==
X-Received: by 2002:a05:6a00:4b95:b0:83f:a040:a3d3 with SMTP id d2e1a72fcca58-83fa040a6d7mr4960299b3a.43.1779286167683;
        Wed, 20 May 2026 07:09:27 -0700 (PDT)
Received: from [192.168.0.159] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c5b296sm19756231b3a.32.2026.05.20.07.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 07:09:27 -0700 (PDT)
Subject: [PATCH v3 1/3] mm/hmm: move page fault handling out of walk callbacks
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Wed, 20 May 2026 07:09:26 -0700
Message-ID: <177928616608.589431.16936852852611203381.stgit@skinsburskii>
In-Reply-To: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
References: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jx3eoiyxebin6sukd7rfrbetezb3jydb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1B1AE2000A
X-Rspam-User: 
X-HE-Tag: 1779286168-238961
X-HE-Meta: U2FsdGVkX1/MWi/u31jvxWApk0PIK5IU+gyIIwDxnTg+1i5+9IahFJQCTt4m7g2/lhAB6zwEP0ZjQABPKlMtUdKQe5cvFIMfryxIrgy34bdNP74fJJbcWD1pGUGhZ4ZHj3LXjWgTD+DNr8J5Kh9Zju1ld3JyQIuAVrDBYGo0wGFt37iyaooOA6LQJNplYdWWMYn4sIDMKRN05EnVKXxlJNTJ81Rt7RpgCqGbO5MeQ+lfGmkkQFXSqOiFODmzRmdiShEDN2Den/D+AaiwWSvNylIS6BRu9B2WISItjKq2p75BSKN2jRTS9QHawLjJKShQqCDYKah2tFKImCR08ZowueOFGWGIbs9al+apWevWmbdX/4gqh+nhc0lBf0d77QxkZ1Uw/5X5YKO7KUf0u6j0ALnkbYcE9wfy0BYmotHPB39P4DCeCBPfjyDjjGnmF8ExZZt6lmASj6pkKD4t9iT4taYWqnvJcrOv1cH1N6Nk3LoEilxcgLMK0hkyP+T7DM1qi/f0g5qDCF5ePdQa9p+JoHDGV6VYxKBIP9aVWEMRBHoEKiOlFf4Kl3ei3vmW3iZAAFn6lt6pOOzLtPAmlaNqy2DSdebkEEObeDlxnOD+RUsyaOi3hK3TIEjRIvLimgMF9adbBwxqbshHPboYJ4AssdlpEjHQMo3yRmyrpjT6jInJXZToO0xo7XLK+CfnjQoLQ/RTybDBFHwI89Nu1eysc+u2Q/nKouhJaWryhrjJ2jzSsFzTW3hdjvc5Sj11SMIbivF1hN0Pth8qmu78D/fisA6QO3T2Z9XKRwYU7kispiTt73yU284gqWTgzMccyau3U3vpPVPiWC4J6yt8QcOnY+Ru9tyb0ytAepn3dhf/ukSHrIxOzNXkXWslvEtsua8lIpc2/JAKdzM6XOjVEdSxRqzM4Z0D/sljTxPVmgd3jXpli5/RkgQvUnPAq3LL9AZKpCILbgvpeOHZI+Oc1y2
 2erh9aW+
 JoLJK5z56igxZPrOcr6eynODzzBINH5kjM7c1Yeb1qQlYVaHiHrfODDOytBTAKAzSvrYa1vCSosAs+fky3nHklmHsL0mmE99/ndy7dGs5KVBVWB6JTkgUNZw9lqc/WiV7RN3RMnWda0hWcI6t17i5Y+0YvFuiI1Q+0WKK+cceo5byTNm1nCjc+gJY/1a4FuqgEIi05YitoTmYIKx7bPbZg8yXcPBK2DJSILlRIbWIUx2ZnydnKAC1naD1usJomVS0A+fib9qjeVuSZCZbfpAKKYoorskMmIsT4PhdO5JcUOsA9o86pvz3FIMzSFTd4Yjz+nzTngDKLJEIjlTDfVWpxCqgyBrBB0KsGm63CEqNrrQK9AOi0R7luIEFUznU0m912xAj2eU84sUYx+z/j39iIODnlass9s1fbO+YcZpfBVULJYCLvGwMOT9DIEetMDiY4ZKmPzlfUQcC9/s7ON1xQ7BLgjsCnKXOHndNiquPZ5H6GAJGERwVLwh+Kij8S+dadzWo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

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
index c72c9ddfdb2f..446dd0c39b3a 100644
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



