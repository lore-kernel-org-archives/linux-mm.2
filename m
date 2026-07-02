Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123E2C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3C4C6B00F2; Thu,  2 Jul 2026 20:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D137C6B00F4; Thu,  2 Jul 2026 20:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDBF46B00F3; Thu,  2 Jul 2026 20:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 664D66B00F1
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 923D3A0219
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:32:47 +0000 (UTC)
X-FDA: 84944531574.06.46FD925
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 98C3A180006
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:32:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3iRJc++;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783013565;
	b=BI31LnBD478i9vZsVEzvOMAoTg/ywh5T/PuFc0FZgXyJjR0+McdGhr4p1F358aH1wIUDJl
	Sx94eICSuwKRxNwG+xxT/iuuFomdMvAGbFHYET9MV4SYFUJvgPHM0COBD+Zk7tINeaI+OY
	YYF5IGZZfjoBx/OeU413txO9WRxlGnM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3/ULYVgYqkVHGifQ6W/LaJ1GCCnz0joJzGF3nrJAIs=;
	b=K4JXgu0dAnvgHgdlOGwGoyLjtzwSrw+oSoiKSO+za9DAFlXlF5zC7J9EqP1yLqolZ+xILe
	o0ClaXr+TNT2HausMlf2a/EKDudTxE7BBCAcNFvGlTV/I+lJrYeXL5KQxYXro6tlPlgxne
	A788SjZSIzmFLZUFUMzbqiRE/LS5AIE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3iRJc++;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-845c92bc464so1707427b3a.2
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 10:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783013564; x=1783618364; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=A3/ULYVgYqkVHGifQ6W/LaJ1GCCnz0joJzGF3nrJAIs=;
        b=E3iRJc++ctYG4QRRuSFYZO18wwV7w5EnFHxaj/cA/4EVqJC77bJK+YIJEVRHIlbfVs
         pUj4B3IUFLNtjcO7itiQJDnnAoRwvigEi9VV0coz/WgC+/rgQae8ey9xYaliLRmESs+o
         yS1mZoOxop8v/9M+V+m2Awku0kq4v49UDi4Hf2lCCF6EA+yZVggbKPmzVMBafOf9DR/h
         jsvDNvPcmDQM+kOxpexd2dqAnmHtBssix0H+EeawYJkJulTm3new7bdbMT8t9CdqnZB6
         R7gqALDQwcaTsPWHABmkEIfG5ptpPNWyfSGslsT6nFD83jUVA9ZYDuKasGnin4ITifaZ
         TSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783013564; x=1783618364;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A3/ULYVgYqkVHGifQ6W/LaJ1GCCnz0joJzGF3nrJAIs=;
        b=G4BDunQrHRnChOUkcrwwZfoKYteDBxYAHSl4QHmlhZfDWt1XQDJu1KZrkYQANpo0i3
         ob/PGylKLVXcG5PHEml6bfD8JWhtoy1pEH2xmQgbLQ4kGvYWiDqH/dsqr6g3Q2fc0AiZ
         bqHsqOU9krK1f+KiV7SOen2RWA3pl4+qXYZkNJ23aFP6MT6k0Uj2baiTx82h3Xkf8qXX
         HEMcqgJZw3y3RN6ET8Np46r2TsKaXRV3mhXzr25vTGPyoP+Tmi0HGGTj6DXozLM4CrAw
         1N4QZ8myi2YGcg11ArPU4aHDcpJfLYZ3TwyYmxdBPWaAT4mrE/e3kON1mdeDTsPLguow
         I/iQ==
X-Forwarded-Encrypted: i=1; AHgh+RokX0gjKrR2AAmZATHDlf5niJ0onDpwdxZ9Glaw9AnZcunfgAYvxAQ6HF1RmqSbRb1BVjPWM1sz4g==@kvack.org
X-Gm-Message-State: AOJu0Yx//uu0PKGRH9TO54It88hCK/F0OOWmZbtG+CA0f1acxcqkXbFg
	fp0OJvPdH7D0kgozqRVPR9VlTEiPtubfaLOH/tPXdWfuhvN97iSZJiJC
X-Gm-Gg: AfdE7ck4XV9B9VwyJyLMRzfaJffHGFo8NujhD1Cur31FAS4qAKVpRMVQnn8Qb6fsAqM
	1DMymYHdkC7VH7ATWXoOInS3guAztEdKMWoSsbqM0COneLKGABerXwelG11dnVAc56W8FzKsY4Y
	vdvEX4d1C1HI5fMJIxvUOybX24zHV5k9xNIfBi48OHzbx5cUOq7SQuRrwWJksAm7EjIgUBtOSvr
	rQQQ7UjT4Y+lu0qkl6mRSdD+nE+j5MnXsOR3n9tWxw1zYGRTAn+vBIMpJMLhTiBfttF5+5rc+wj
	r/NjzlN/jp7xYZNXv1ulC9bQtr30Eb5OO1pL+xwjnZ2AOq4uw6Mc02KGEuv8gOVi4i42WNqAYpa
	yRca5gYXPTVWyMbznE6P+j1WIUfaXgDfZUYZ6sVVCDItOBl272aN2uFvE5I4X/yiDq/1EmrDbN5
	BBeGNu1jTt+299Zk8Fi/XrTzREypOfysZNVcqa0ze1iBNNKhgD709aY6QcThE=
X-Received: by 2002:a05:6a00:a93:b0:847:8921:9bd1 with SMTP id d2e1a72fcca58-847c51ac62cmr5958872b3a.53.1783013564356;
        Thu, 02 Jul 2026 10:32:44 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e921d28d9sm1493533a12.24.2026.07.02.10.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 10:32:43 -0700 (PDT)
Subject: [PATCH v5 1/3] mm/hmm: move page fault handling out of walk callbacks
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Date: Thu, 02 Jul 2026 10:32:42 -0700
Message-ID: <178301356294.373695.7368238076921004035.stgit@skinsburskii>
In-Reply-To: <178301344866.373695.16044452017467686329.stgit@skinsburskii>
References: <178301344866.373695.16044452017467686329.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 98C3A180006
X-Stat-Signature: ia1jsdwsdpo4tzck9i9efm8q53uum1ro
X-Rspam-User: 
X-HE-Tag: 1783013565-990286
X-HE-Meta: U2FsdGVkX18HsokBSgNlQ1r8cgr+roepab+pMa3OSzZHloU+q1M+Q5ZEwUXh6DoCH4EoOmJaHhtHBOhUUHO0JlM9vL5fMnu3hPWI7Jy0NAodi/at82J3pk6NHmpMVHG4X5rK856iGt2MvHwf6e5uKyEbazMd8EwmXKqf35CS4owvZMUIgbR69tyxzqkjEKED+xgI8K9TJ/qtj8fqxkifCA74IT/v/YtXzLsBV/+xpfAHOzc5VLZar2Vj+SMjOufs2fEqkkAkTw1tPtUx0B2rDwQjxE+t0IeeXPhzWNPidjOkGMDhxC78dd0WTURDxuqoYuxcqv/YqzE4kTmO4uCCME1+QX7Yd1c5tdGCfvxuqLdTVFPTOVvOSJQh4s7U379kH1AoDUc7WQQPg7Bypu/reINHYO+bjTwAIQ+hE6sOMVbQIdl6tPcXAaELpJZ7W2r8jDvbAiBHHQgDZXae7Owq3NyvokB/+kPD/YVtDr9Ls9CUItLAKMfRiSo3+jMbiHPauBiLBGBIA6MwlTNCJbsHdX7XZYXTmFuaG6h4TJEMutVkwPR3cxrRqsPbE8cNlunczQnQ2GKsjxwXv64cXOkaMfbhqSCYeDqkAjR4A74uzZhTfmrjpHk1SGQ8xYM09IaOSWAoTJWPuR+bSnJMP+CQs0YXSON/eKA2dlVjJvw5V7+X7x9MOMIqP3vFCUWW2UrywiN4wTbIiK8bzJOdKmDJ6ZLMFd4AWpKAAeSqIejlfref2h30ykrwJgHQWV0gRmcidqRznCcyl5MGNUtlw7RfNT5rsitwAw8X0SeA6pQbGF0/ovr/UCACGbE4835Vi4cjFc7Ib0hFtNQrh7BX4Wxtuncl9nS+7rkIuxodeTFVgkgaCMVYfLIjfA3WOZ4L+GJrwCNMU6Hx9jbhnv1fT4o06qbyNSgYJZiy/BN+i691Ndth2IdceMidBq5g3/wMT6eRLc/MizC2AwsbpIXSRk8
 UseLjbsd
 1xNWudRCICSXfsVTWG5MAvE6TUUgI2wV614sQRFzACP/0cCMBNToyztDV58l/dqYXjyGtV4aWjiq7HDO1LmD/dWzxdjMC+F4FAS7NnU7bMmv9yj6zWF7JiIDDa917JQqjZdHNQYlqYyJAFm2y+/G5K3zl4k/E59nEHUHMrRDldohsnOgIrFCyyTObLABSwcyZ3wqcmn4r/Ce0zpfEk64bqcJlEpEVE/Vfc9BF/4sjVOKOaj7kx/DFAZ7RjfFV5wxJsQMoGABct6a+rtZLVLNjSD2yObK9yflzdH84Q+B9tcp5NRBlZ97zp69P8IFzJVfBwwyIhOmaToRDwptZcXQzkFUr993H6DGoCIMIAvywi+byFM/ZNJ/eX8uE+kAJnU6aeymzCFt1pTmMB5ok0bXUItVD5y4kCduTvfJWHMwxr+tREkwrascJIkMZK8sAhrJmKHfodgCyQCuV2OlJ0oyYVJpnqZS8YrnDuGIn6CFyH6gEvfndMvh/Ume/KHKh4Mgh1Cu8
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

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 mm/hmm.c |  118 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 75 insertions(+), 43 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 4f3f627d2b47..2129b1ee4c35 100644
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
 
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
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



