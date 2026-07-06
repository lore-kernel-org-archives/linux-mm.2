Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A51FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5476B00B5; Mon,  6 Jul 2026 13:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47CC86B00B8; Mon,  6 Jul 2026 13:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B436B00B9; Mon,  6 Jul 2026 13:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F044B6B00B5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:55:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68E75120198
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:55:05 +0000 (UTC)
X-FDA: 84959102970.29.38F00E3
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77E2D40003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:55:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wa84SCXm;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3/ULYVgYqkVHGifQ6W/LaJ1GCCnz0joJzGF3nrJAIs=;
	b=hQO0rYmLZW1O+xaMn5gDoqG9xyllSuAwOpGKyIya2p+kLhaC71V+MAi1RfhElqamqZiX6a
	s+DEDY2Xo/GeXnHowikcLJKErRRcAnPGU5d1lEBsi9dv1LV+TLbNNgLE4QDFJdjnEEtVbp
	aAaUsv/W3ZKgyn30Xg0GYEzaEerAu8I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wa84SCXm;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360503;
	b=2o8/gBU/Hh2cwquv+o1Miy+o+62h/7VvKPt0jbBm6tOFwlD5sp53ECEE/3Gp/QO0iuhaZg
	ysFEqSOBpk0dNfbnn5QnQmYrOCoWJeZpBbQOhCKPM18chAWNKDUD95KGhK7w/a/s6OjqrY
	5myHnn/hs+r4DRKT8/0e3oZONXHOWOA=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-847a483e344so102651b3a.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783360502; x=1783965302; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A3/ULYVgYqkVHGifQ6W/LaJ1GCCnz0joJzGF3nrJAIs=;
        b=Wa84SCXmM+U4MV5aqjzlOy/2Zj+Z/nkRDr9CGus/M2OkYIwh8Fra4Pze5ThSIDMKD8
         JL6glY8pzTqs74Hq9houA66rIfnd9dBplFe8fphA2gacEudAp0Latq0da3TlKlV8fTjV
         C7FZsw9nyua83r5OZ9tlETJFBkII0FlJ52bUljPT0FRZroc7yYCTa6q3VzvXqlTN98y1
         +wCZZhbtINw6wxIh9ItSUjStiAF2cEqiVisIE6kh5OlHMkirjSY1uL+iqtLJbv6Zatvy
         munOSi4omHIEWX0j04rFXYBo26cfWxecYPSaUW12jhpk0m+GoUZf8RgbD098+UbHrMr2
         POPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360502; x=1783965302;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3/ULYVgYqkVHGifQ6W/LaJ1GCCnz0joJzGF3nrJAIs=;
        b=BvGTeHkCBf0cGkbqhRkL3IjZcAd6M5Lv8BgR0cxKFLKdHtH7drqcrGQ0fW432VR4v3
         mSaexIPA6/AbIAWlwgJgunzt6Qls7cXz7dihzrjBa0PkIAm/3stNmRtwt77Sw41rjJeg
         bIejfxuaKM4kLVnWAdMG2FP2KvnKfJiBcxIL4xXWKm23EHuV0jfeyQYVrSq9ajdDD+K4
         6iLsYLf49iPLhetpEhFvCZC92JgX8c3n5kKshNLMGbcm198wJd4EfItxYuy4koJr/629
         6olRRXmEbelfB2BNAUKm6/8cwgAOroCpVRNGwTLJ9d3KdrzFJBbDZhEGo9qFkzp0ma7Q
         vA8A==
X-Forwarded-Encrypted: i=1; AHgh+RqO8m6SXKYXGoJ3lodBDWxixfSZW1s3EN1cgwsGBS4DopNn4qHSrVz0eRF0HHmwLXuyWf1su5kM9A==@kvack.org
X-Gm-Message-State: AOJu0YzbPjClox2rheN/cFpvp20Ls4ZpeuUq/Q90o2OzP3qTsBJnQZh1
	w9YM952bht7rgarvv2ku/YhHy9bwlgUp2hUIIhWwfl+XJkmD+INNjhOZ
X-Gm-Gg: AfdE7cnXgeUft68ow4jHx7ouFayvZLX23dDriDb4bqkLR09lqe/SaYQ2r/3z06qvJdh
	qsjjA57MgVJj672NGVJRYwmjMWWt3NaWkA67nfoc7gvLFQd98zPNyfXPP0D6k/R7i4C83+JmVn0
	6QPBFZaEcp1Dh0t08MlN+W4E/ugML3dJpKol+N4ZyHPmf4RCSa0hBR60cgj6/UnDnyar7NTfOWd
	g1noPj21ttVfu7MgZuxyBh7APVLIzL3dPQapTPiocp92IS6RUb1sdznIIdB3rvzlWT2NZqGRs72
	7xeK0fzPIfyp5dEs8yfWSsk/YRXok1GqarTuUviAXhBySyiBLhKmD90/ynvp7+zTXEuMW0oBBiR
	/vYJ6uxlu5xHJ1G2eokeQ8P/jx+AYPA0vOOgALPMfSyibQboyRFRdlVE17PiWmIJwN8He3BSn5J
	2h6HjYLxr2lc4ZqPRRnnbcfZzAuhY0dOyxHlfve4YXWzvbbcXQhH1bNqF+8Us=
X-Received: by 2002:a05:6a00:2343:b0:837:f111:b70 with SMTP id d2e1a72fcca58-847e17361a6mr13746908b3a.4.1783360502202;
        Mon, 06 Jul 2026 10:55:02 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b609b8sm4245376b3a.5.2026.07.06.10.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 10:55:01 -0700 (PDT)
Subject: [PATCH v6 1/4] mm/hmm: move page fault handling out of walk callbacks
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, skinsburskii@gmail.com, kys@microsoft.com,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 longli@microsoft.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-hyperv@vger.kernel.org
Date: Mon, 06 Jul 2026 10:55:00 -0700
Message-ID: <178336050066.504354.12327789842078522108.stgit@skinsburskii>
In-Reply-To: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
References: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5mtnofdke6uiwosu31txu7kz3wky8o6q
X-Rspamd-Queue-Id: 77E2D40003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783360503-975277
X-HE-Meta: U2FsdGVkX19P3uO/FpXDTVwPmga+qQdAcNOd2X18fTGLs7BosTunIZpznkshcgBUPQAfXS54qI5xTOsHNgOVv4ozEVUd9J7ITzqNRcf+rFCVdNNDHeiidRrP9tTlx7/LUJA4rt8WNVCr63JwTd6FwKfl6Aky16OBeCgfXmLZPoDZQuc2Ip7ISXgAYlOYIExBxMsXCTMANU2x7s0igOVPUUWU5627CDs/5lWcreJwlrve6u4N8RrArakACTW9aSj+KzGbW9yWUGJ8eUd5f/XVe0mJtu3DHBesyHib2f7xniRKOd7eqn+RQQNpPXtDSDvAhvmehoxnwClFS8oc1QqkP3eEX/WC4ajuGiAI106ISkj1A7yduSRiRqNdhHd3oN/uhRsYlIVztdBkAjd2oTbMb6nF7p0D6uGpa3vOwSYOzTiYt+5Km1CigAaNzbQuZXqkpR+jAc0+evkXj7NAklQZ946CCFokMlVim0JwmBi2hUtrOKxr8wlIReAEJ3+jQ/YoGkuH6nkX+EpVUexaY941aYcAJepq4/avn2A9xk2UW1VRmFvoxCBkHlylTrVebqcCaXz5+D9Ui14KsZ0hWRoVtuGqzM3LVpneqIMjbIwotuFq2HcHiLQeHTjEG4OdVAbGQwdiV/bVrmIeRQqlweGpS120aHaqaD0BXCUlrJW7i/GgsTvT4BpjwH/gslJ95UKfYGW5Oe5NBHqrArn3ssCLc9SPtR1cGc5gXYpl+CClPORN/H1LzMqzGidGY7r/PPQXEZHGeqda5777dXDshp7hLxsAjyJkqVZ4qD3GhWdxabe7wGAnybf+ALV33igEWNX2ryPyPrZ6seB2rQJ5O/3ITKigoHnWSfzlpy/pkEkrq9LP0Us9PQ5Avcx1EUC9daIsj4iMn/jm1yZFsd1vBvvS6FdQYXVn8Blt1TK33uestcjJqKn9vcb7MEK9aJsgGy5ihh3V1ySvIn83VNUXMwd
 15QSJYgM
 2KxECH+iqiA+gKo9YnONm4TljkM5wlN+WT07T2rty7zhnl9tn7rbnMokOykYuzacbp9qiJUL64XJDN5MzhhCZdV8mSbwgaadeSXGPRqAJ1ODT+QMCUPBge7TML48ZDhrmyD2HTKlZzTkJT99C3ishrsPwR9xiBerBt5GQle9gpcx5BGvf28wSv3sgbaFwlvNzd+noa0v5pT/8lLs56CMwQQTb63DYKY7IDePiOcrVX10YZTBqD0gg6rIAjTXWCyklsaPVRRh7IjYE5HVOSR2D1gZOqEEi+CL9jgPln9HVaYUoGFvQl5ivA3o95H/w8W2BBEnhbUC4AdRPAjft8FqZZ2tdO6/sJ9OF0agAoq7keKIAH3/Hm5RnKkOqJCcK9iuMOAbsDyMuuZjUPY3BsluHDsZuVvA7Ilx24sAoFA9cZCRDXx6qiHvnyXpEyXPusH99ecw1iVyiZEHgQbNSYziDcOw/Hnv2M9tQxWrRaQ0vzjTfMv9VOw7oAU8wGnBiaf0TM91bT9GGVw9VDdUpEYTKIXOIsXuDYVrP+ZHXYJjrY5ziRH4=
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



