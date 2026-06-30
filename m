Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8CDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDE96B00E7; Tue, 30 Jun 2026 11:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5A66B00E9; Tue, 30 Jun 2026 11:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCBB06B00EA; Tue, 30 Jun 2026 11:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93B856B00E7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:21:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F394F8F06A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:21:33 +0000 (UTC)
X-FDA: 84936943266.17.459A69B
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 023A440011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:21:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YMWfVWE4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782832892;
	b=Mh0TaJptDVRtKkaf2ixOMXQUJmzfS9TNYQ9sPQxlqZRCiT6ZYM3WaAUV1tCYWCliyIHLrV
	/54mGguMcIROWEEbCGygDlofnQtEtgXxiQh1pSjPqFJaQBkjItQ1RyCU7VEFz2IfDsXn7S
	j8PwC5Hlx5mJPJvTiyWoCnIkd08dgUA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782832892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2P1kNg4b1RcRkebULzAbgfr7kwFAXtEaP6bPGhO1Ac=;
	b=AkG9uLXDgTVuMN0lgX5UTDH8THAgKBjGDJ4E48vM4cuz4YsTuh+XLjEzUQHrkzJTcrcAQt
	6ktyeFz8VBgrxQeymyQ50x5wRy7OVAOQcnyDhbaiYWeHbX36fw2p4LOxWGCLZG7yEseJ35
	6IG+ctTGcuCmNeqIol+KSiZ0sm1PxSw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YMWfVWE4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c6b67d5fa1so25446915ad.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782832891; x=1783437691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N2P1kNg4b1RcRkebULzAbgfr7kwFAXtEaP6bPGhO1Ac=;
        b=YMWfVWE43cuclNXTu0oPbX8ifhe6d7eVgIV/4/pr5ICH7D6Sbut1bQqdeeCjbSomQ0
         RAXVn6JMb2jMDFwkFRN1E56flHwFa8zmanMNz7D9ZR3f1zSnePYEWR2s50Qd7r3iBBtu
         LIW0Xna7qKmYynURcMX33dED8mj6jW57lZu/7jSaoTE3ilGbDNcBiWULImyC5AiEb4kS
         LLSmYjjUp0ghc6eIYgNJje3EOw92yCxxl6nRrMkDyazQ4f5Sw8hWMta8POcJzbg/cNlR
         AAv5EAYEeCDjBTgkSr9sc3esV688yAtGCPH9QdI/b8qpF8Y2r2TmDWIL/OBGqspTlwhr
         5Fsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782832891; x=1783437691;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N2P1kNg4b1RcRkebULzAbgfr7kwFAXtEaP6bPGhO1Ac=;
        b=d2vigYaO56XlCcOX2wRyCfqS5BVY1SnPf7FbY4jeRMjBJJsI/+QaxvSgg/pdGjE2DX
         Lmd0MTOx+ka1CGzdf92nmZMnrWu6yYRvdzUYhZxj+TG2UPzG9lzho1Ebl5XeUFTmpZs0
         Kn3r1fANX1sP0ScAQ+qLZNxw4Wdrnn6KUgscz5nHEu7T4HBKq5le56TJ6hJ5Y5DsLTQ7
         AQQfcVYuByEn2ubnbXqoablw2ZAaZlPMXnk30oxgGGMME96X3ObeqPla9vcyr8IJiOQP
         CPQaYUbFSkdhToCUTd2SjbW7Nv2nf+2LLPKkTa6JvO9iA+Z2iKRwfhr9Ie2ZLijMVe1z
         xl9w==
X-Forwarded-Encrypted: i=1; AHgh+Rqz2A/9FxxmLUpdPRYzrZL4JzrZnF7OnVssYylycYweOUqPpgfIqsvcIeaD25EXSfEqCyzvAc9Qcw==@kvack.org
X-Gm-Message-State: AOJu0YxtlQH1u7nmKKkkyW2TgMNk3Hvvu798WBo3ahNA8cIWkIB/4P4b
	TEYlL537pvuo6PcIu9uWB2YcLJytkHzHiZDrl1FCOhEhDlntJEUPh1lO
X-Gm-Gg: AfdE7clQL+H5ycWr5Vg7FDe64qNxRR7wY6JqaQ2oXlRHYmr9D98tmE/pGJ0opJDez2A
	TtltD6k/pEArX+pPEvU5IyI0dxpCAU8wcGLLppe7FA0x3tXfPNLHmDlEoJOmnEkhMlZEuufEjJM
	6Nirh9imadou1FqnhgZ4ySAxx0UNbPO7GKGghxG9ZeeVJoPrgXrBGgazme260TbCSPm1OkEAvSs
	Oh+AnyOLejC/WyJlbMMDX8peov4zCaj/7oU7mlCrvtCxO04UlkXBvHAoDRApPaxxwUfMJq9RsMx
	/WPz3TgbeT/mMfx22uRdFggnBe13ounyl54SMoylVYeSnUkhwnNqWWHnr+HeInVGUg7dmHgKToX
	cZi4xoqBW6D9O8XRg3UmJwsG633Wpw+wkyRTRA1ok+25y64bu3xL08hIwU4AEHdKB8IW8mGmmcG
	pV+znTCUPWFy45C7aRpQrQ4mVWgdXoGzfojUwTzqBdhY1P7islmesKW+esmJA=
X-Received: by 2002:a17:903:40d1:b0:2c9:abe1:c352 with SMTP id d9443c01a7336-2ca2d54633bmr36816585ad.13.1782832890836;
        Tue, 30 Jun 2026 08:21:30 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca380c7dabsm16225705ad.31.2026.06.30.08.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:21:30 -0700 (PDT)
Subject: [PATCH v4 1/3] mm/hmm: move page fault handling out of walk callbacks
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Tue, 30 Jun 2026 08:21:29 -0700
Message-ID: <178283288916.183052.8497885274588121740.stgit@skinsburskii>
In-Reply-To: <178283277041.183052.6873574850714079228.stgit@skinsburskii>
References: <178283277041.183052.6873574850714079228.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 023A440011
X-Rspam-User: 
X-Stat-Signature: gj16aegbdkaney4ythct6pimcor4apao
X-HE-Tag: 1782832891-481169
X-HE-Meta: U2FsdGVkX18ggYBUXk3uv361zoWc8jySN5w5qEV2fikB+gXlZfmGCg1gPAv51ydWgD5f2XehjeM9tqiUiM9gjycH2MkosF/NuqoejcmKVMbg3bWWOYE3VERWr0lwmr/TBLaKHV+WD4dZjWw/zd1xk6DWwHBxdf5Hvam3T4L/BAkftPXcDSo88NcY1tFsgqLAKsNtWuMfYITQYOhG1euPnuxFV8QFuZD6YcSpwrxl6aw9Yl9eEQgcbpJEgLNKXtZnxIDa3YHb/HNFBuJPa0la23U2NNl2wsRK93fafiDGL2onkuFKj8DqEF0rbLTsH1jsmk6tX82+SlHe9YnrsRnYnMJAlXvoOFZ0oCvr097+O7KXw+kIno71FTCpdgtBwC9TEHZZI4ETcYoCI/jx6cH26bAXK0YTcKw9KpWdq5P7LrUeIEjsSXbNkI4/4vi/kEAirvtXA5x1cXBt5+KfMj9gZxrbTPf4dXT9RN2kHuMAQHjUsedWJCbKzQQCDZ0WiL+ouKlSRxbWfWMYfis3EPxqp5reMUEZ4hPyno+rCwqhQpAdKjW8xFjvxMhnlwAqPNzPshGP/5wHcf6QaVwKiNivbHifHej9CKIwV9r0OTmrTSRxtWDpaplHXDdcMf/Xh/lC70j+Y/2M0niZRBnUYIUH/eLEw9isVRfjnw3qCuM2P4JrzU9MynT9/UW3HYU+n6PmSje04a5e/D5IQnmZd+1qLFemuRKMcEI7Q6788Q6tpTs+QsUqNh+u4M+iWc3qjH0ip1qRijFbtaVo25/BC+xQw31kJ2zc0ZnaSIRtdFUKSn1R+28CsoQ/uetPyJpa4AprJ7n+piBO8fAD3/nMN4VGQaPpqIu5IJvu3x7xoZmi3M2EQcEBX3K99m2KksH+lzje1xjra3VAfCdjqrC+erp78TZOgJByKsDu5UOBbU0z56ZwG7gfZgXzgf98aBc9fCXKYPO6c8l+uz7QMcPUJm7
 +jmX1sOz
 hoD4NCKKv5y1OC7UcZOf8HpfXL+PnTkda25Uh6u8iGlwoKPwLFHvEdjG3TkuZmVIUPBCyjuYI7fFuBmnJOrKvjdRErHlBVwyVF2xlpp/olKR6KA7YVMgW4QazxyYBNrXWUHiEyB9O33iO6iIUY1/WsmzCcun8iBzmr848NYJXOyIEH1JKG5Kli5jrJVBr7I05P2c6CJ14TrgOFtYzp9y6RCXV94hHySzvH2gELpTE4dDs5j9UNRv0d8FVRDM/k8/ez9vudWnZqXuIHWRudUgwRgiKNGBp+nE/JgggRtwAbsO/5CwDsKKqKrTTyRJn38B03WBfCCWmZzxNPfa1ecveyKfl7TSk1QLvTQRuEnqdxUY7KI+JhV61HygXAJnuJnfDo5zNJGX9auu8BioMvHfYsvUdrVdHwIuElpe6NwmGLntudtqfTRbPdNqeLoCi3PN5gl2Xy5XVLR/rjA4OTaAnH3uDSiJcG+zXv+CCDhhaVCvL5yGLEg/ugxinP5M40L5/fc7R
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



