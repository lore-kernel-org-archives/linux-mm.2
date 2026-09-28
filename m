Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D72CA5FA4
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E466B00A2; Mon, 28 Sep 2026 06:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7E76B00A4; Mon, 28 Sep 2026 06:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE0D6B00A5; Mon, 28 Sep 2026 06:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA716B00A2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1FD6C0162
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:55 +0000 (UTC)
X-FDA: 85262742390.27.99C97B3
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf03.hostedemail.com (Postfix) with ESMTP id C029420009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="A mWKCuI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MsmQriMp;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWKPNIKfY0rqdjZgSUWg4womJUTPnzMTQIwidhHr41E=;
	b=2CFHz3i6g/xgInHFluLlV1OV5lvEsNDUiZP2Zalw1OBOJtY8nsohzbN0qCLeVjFW+sQiU6
	wDKVadg077YF6sseqoW4Hy9NFi3uIhk+4MOmZR/13qsmcliArHPE13pCpO4LYti/Unsrlu
	X0HagmXIxcAbiJNJhfzOkfNnI595QRc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="A mWKCuI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MsmQriMp;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590013;
	b=knpDiFmp5tYvXRGGoaEoApM5lXhbiS+HNXcm4nxDY3x1ZYRFAnDDTcZFBmFyOC9bqWFucK
	nrSTOXc3SNjCLisIIKn2W8ixqqbYvOVdzZMjYKrajGKIB9RFBnoklQxjHCg0ZmDCztTeiX
	eyJ6f17JTacPcWVpDDIXZY41devN0vY=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 4FD9AEC010F;
	Mon, 28 Sep 2026 06:06:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 06:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590013; x=
	1790676413; bh=oWKPNIKfY0rqdjZgSUWg4womJUTPnzMTQIwidhHr41E=; b=A
	mWKCuIDUAgQiCrVitkzMxEVbXR56mm7opJabbh6Dcc75IKbQHSlEvDo4ry8GYrLY
	E+FM7mXfo5o5TwnUXM/PDbRmwYHSd2spOpE/baR7oGqZE6hQ5wruFn1VIqfc61Df
	3SAlGexcUJc6jSoiOwVZ//KClODtiEY4CWg0EsYt7fnRElU+RQOu8ZtDXhGxrJaz
	dx3zyuBRwM1ReZlm8jvo7JTBLqelwZMhMxIwQE+o9HvvjNfI1Q5X1exh/kug3SEq
	XFoV4XWP9YCbvix5aX/xbGbXft/NbHtA85rS2ysJ/O3vj5xlyQdOuzDunbYaA/Bd
	lpgNr0mUkwKh4mxDX1U4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590013; x=1790676413; bh=o
	WKPNIKfY0rqdjZgSUWg4womJUTPnzMTQIwidhHr41E=; b=MsmQriMp6PYwXl+J9
	kKdvVVlPHcpxXe6HVYwD11kMimxqlVMvvEIXjP5XFZJf2ySkBUqiMLaauV2wY9I7
	q+TfBG5dFTXi6O94PzO+cxWH4w/C+ik8wExyC/b072CnxPoFjtztzo+N70yWff6W
	E0qgJbEQv4xvfabmFnFEfhKKlC7F4JbHtn+m60kjZqDd/WMjh5eVx5cHcWINIbLb
	D3ZyeNiQKmMraQwDtXvgIQlrUmNHoRNjgGT+/WV+f2uL9wwSGI1HGidInwI0huqi
	O/8s36QgczDKmWRW7AV2hF1cZPR0vTHzZ0yZ9jrj3MTUh8kKRrOrxkh5EACNkD2f
	Qs1mQ==
X-ME-Sender: <xms:PTy6aonFefb7MpihKUN0UjEZKeWNQ6oB5evOea8NmYvWU862Ir3yaw>
    <xme:PTy6ajzw4op_0YTjMTGLZMsj02IJlgEASuavj8CoW06M-AbaYrKKFi48RH6esnJPN
    Sg5DHkmjpq6YVk-9dJQTPJSxdbNCHFb-cELo2vlubNNDWzl2htLoHeN>
X-ME-Received: <xmr:PTy6aszNp0jeyLfSYB7B2QXD1WZzRyJMkyH9c9ri2WjoOqxhXMviToJCK-8>
X-ME-Proxy-Cause: dmFkZTG4PJbO3UAUv73kvgZEv1qLl5z3Oxsi3Ojn/Cc1gjyQPAY4pttCRQI27MH3dZhDE1
    QOPy+mv452PPCSDsPFoXsadZBBemUC7OEPjfBcMnl1HRY+YTKUqrnPjkqBcWGUry80H8PC
    /K6WQA/dTtmOEop/aiwEwk7y/N5mXgzmzQwcpgiHqOtfdhP6k3WxKdxsMyJsyB6Hvye7b7
    y8KqhRd53u+yghVVISP0UmiTClCERv2XAI4oMribMzYWNytre02a5omAhHuTKchvkb64ds
    QZyxNlGi6Daf2p9KIHOOPKsvpCSjo6Or9ZEQkSNGQE8W6NOQ2qvEeUYlVLLdnIfc4NbbF7
    6+92MXsEBFk/lKdQvQJWcRCdIaKUVaupqBI/8KQYqfoV0zOqd8Lt3lOs6hspZ6QQ5bg0U5
    9U4fj1CaDjrXK7HCfVVEH1NRPCsS3hnwglNtIpDOXv8QVPh6weUaH0igOisJ7WB/m5YKSG
    BzQUmCLb9h1C/6/F00/owax1adrxXWjA9rYs/S+cODsSb7rmGH7N+quBmHtbbZ4/h3jD04
    I5kRvTZgBDaNZztX18cu5J2GZFzsMceemtIkjAHDe/KEW25m5Be+t2nu/IFZjZ/0JvDP2E
    nzmOssHESkWNiFUPGGFkpODXQaxQLrFcY30dYSZIQRN9rrflD7wmrMhtSIUg
X-ME-Proxy: <xmx:PTy6aq_ADXV3XwR9M323mAmZ6VgUo3SXCqaZ0A9LDlteBRQFOz-CVg>
    <xmx:PTy6ak_3C6JBUi2pHzQVlqTwXIJfNQAZ5e7ROKU_cyDPjNrQ0OyPOw>
    <xmx:PTy6alfiRdsjhHIw7SAIglbz2TlmmD8bebKA1BkW8ClD52e5AuP4Dw>
    <xmx:PTy6aouo7opHGrp9Sy3dmK4bCSxpbGlMveIbPPdK0k5LjGCcQ65P9w>
    <xmx:PTy6atHe6jd37Fqgixvxd_UMkvt4LDckZbT0q8yzSakPtrOX0aZb5PX2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:52 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v4 10/13] mm/collapse: open-code collapse_single_pmd() in its two callers
Date: Mon, 28 Sep 2026 11:06:24 +0100
Message-ID: <20260928100630.21870-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 81uk1j6dgj3hksgaqj89zwpc8q6bhk11
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C029420009
X-HE-Tag: 1790590013-423700
X-HE-Meta: U2FsdGVkX1+qJBCifJfNWdfA537Yzxof1n9ewC2YQ6LnPqIX7ZJqapD56je4b2yFz+GSiQnz0BNBUgWPgKmQyQk69qi2FAajOS8vYxOpkg+8KrxWd8aUM3V24eYvnZheow8191IOWO9OhR1f4X2uQ5x56+hTsFruV6uYIbh3lP2qNlozsbXLU6L0zx8d+Ooeaf8RYjEaPNmyOEcBdwRiAb1fTRK98EHwTbZSRe2KKa7md2Qv7pgMB43pDYmjDmdOflKU90Wx3TMCpxA8JXTRdkvx605Aj9DneVEIZoSNvlVJAw7hSeIx4FsyoSgx8wJ01VVDbgi+5Z2bkfNB63UMCKfxWZcnjJV/m5YpsKyFAzJXw72xvwoPqdbYHnsFUomM/XCOk9Dla9XMHjyRRM7hZjnfw+VadDua1IWDeuRg23iD1yFPuQSF3cYYWnM40Ko6VsMVPwLWx1Yld00IDYFiNCqu68zWzieEPqoqwpd+2Xr/d+S415Q7gGKfvzOGzhoWcv17sgvx9QrRFCh3qp2az9CkQqlH46Y5nCcAgR+ME0oo0YOZWwV4fPAYi+9KuolJ1XwEJ2sNA764yFJKhYEXXtOmnR8REOki7pdavWGiUYeFrr9Nl5CVcyH6AaqG8VxBOX4MJEeOyKYgnf+J6d258Yb1PmyYH6huEcccu+c5OCHjJxGxvBEt+R+eDTJ3JPM5HzFDAtXm7llNqPAgUyl3SyXQjQolCsBCaeefI4WX+zyp3QSTpzxU2DgG0zjWt2ERbjoSWQI1MdQj034FadvcKeg2N+AnJOqVnSCwd/Mei3Uprmh0IJUECerH1UOZ8JFzexJDOha8ikYXWnjJEnsRAZI6IxgTxBOAbey6wzX8yTLCWfQw2slQp+cWrZMYzsggZEn/OvhzvoCY38o/bhaPvOCcfbhWOHIejodfhbE4x24Bz3Sk2aBABLMlkX1hSXje+riVKZCqpSwf2x/Hb2M
 dqlSx1uM
 dZ1l8uNHknMRh8Y8uCh6GW2QpYHh/JjK7GDTUH7/AHzupBOWjZBi31HwtaFlbcMuehmQB/O7bLLING31WwR93rw7G6p8VbUrMGoqoqojYNewYDhHAyaoJ2GTm4wAhAu9WV0yaGM5v2AG1ZVXdTLTXQrxydVcHKHo1rwlUGHCYtCK1EziVUh6ciMFdaoIqNF+dO9ZQ3dAwTeSxMBYAmEYCEZlaQHqG0R3uPZIGmas6K6nJjBdMWAHanKIT+3020TU5juwuQeqpzJYuae5+TcqWbaaAHJXJUnutVJ42rO7JuY/BZk6R03TreOofKZ2buUzhT5CLk1rDyoU83ANgRfMvPTQ3uwyTsm0+WDJksmYBrci7iRZGxt7Iw3Ax0LdWK67cQ7BWE65pgAe7C6u6YuxS4ls/zP3CaqrwWZ7PlwopJXOM38COsph4MiUn7wqqVP8Epf8f632hoYYBtWvFafaBAcH7BD5wz0vDChJlo+xMgi8LHPFKvR8h0dZXUxRanrCK3AFrIhaP8xwQSqhvUr7+ZkBDoNYvfcwcmB+D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A scan and a collapse want different things from mmap_lock.  The scan
reads one PTE table under the lock the caller holds, refuses most of the
time, and the caller moves on to the next table without letting go.  The
collapse allocates, may sleep in writeback and takes the lock for write
itself, so the lock it is handed is of no use to it.

collapse_single_pmd() kept that boundary inside itself.  It dropped the
lock on some paths and not others, and reported which by way of a bool
its callers had to carry along and then act on.  Both callers already
act on a drop, khugepaged by ending its walk and madvise_collapse() by
looking its VMA up again.  The code that has to know is not the code
that does it.

Open-code it in the two callers.  Each scans under the lock it already
holds and, when the scan found work, gives the lock up before running
the collapse.  The scan then has one rule, called locked and returning
locked, and the run another, called unlocked.  Nothing is left to
report, so khugepaged's lock_dropped and madvise_collapse()'s
mmap_unlocked both go.  The engine never touches a lock it did not
take, and how a caller locks its scan is the caller's business alone.

khugepaged's walk carries on to the next table while the scan keeps
refusing, and ends once a collapse has taken the lock from under it.
madvise_collapse() re-finds its VMA after a collapse, which it did
before, and now uses a NULL vma to say that it has to.  It still reports
the drop to its own caller, from the line that does it.

Preparation for moving madvise_collapse() out of khugepaged.c: what it
needs from the engine is then two calls with one lock rule each.

The lock is given up and taken again at the same points as before.  No
functional change.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 103 +++++++++++++++++++++++-------------------------
 1 file changed, 50 insertions(+), 53 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2b044e63d8c9..be8a26e1de49 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2833,28 +2833,6 @@ static enum scan_result collapse_run_pmd(struct mm_struct *mm,
 	return result;
 }
 
-/*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
- */
-static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	enum scan_result result;
-
-	result = collapse_scan_pmd(vma, addr, cc);
-	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
-		return result;
-
-	/* The collapse takes its own locks, so give this up */
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
-
-	return collapse_run_pmd(mm, addr, result, cc);
-}
-
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2917,7 +2895,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
 
 		while (khugepaged_scan.address < hend) {
-			bool lock_dropped = false;
+			unsigned long addr;
 
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
@@ -2927,23 +2905,30 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
 
-			*result = collapse_single_pmd(khugepaged_scan.address,
-						      vma, &lock_dropped, cc);
-			if (*result == SCAN_SUCCEED)
-				khugepaged_pages_collapsed++;
+			addr = khugepaged_scan.address;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			if (lock_dropped)
-				/*
-				 * We released mmap_lock so break loop.  Note
-				 * that we drop mmap_lock before all hugepage
-				 * allocations, so if allocation fails, we are
-				 * guaranteed to break here and report the
-				 * correct result back to caller.
-				 */
-				goto breakouterloop_mmap_lock;
-			if (cc->progress >= progress_max)
-				goto breakouterloop;
+
+			*result = collapse_scan_pmd(vma, addr, cc);
+			/* Nothing to do here, and the lock is still ours */
+			if (*result != SCAN_SUCCEED &&
+			    *result != SCAN_PTE_MAPPED_HUGEPAGE) {
+				if (cc->progress >= progress_max)
+					goto breakouterloop;
+				continue;
+			}
+
+			/*
+			 * A collapse takes its own locks and is slow enough
+			 * that a writer should not wait behind it, so give the
+			 * lock up.  That ends this walk: vma and the mm are
+			 * whatever the collapse leaves them.
+			 */
+			mmap_read_unlock(mm);
+			*result = collapse_run_pmd(mm, addr, *result, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
+			goto breakouterloop_mmap_lock;
 		}
 	}
 breakouterloop:
@@ -3209,7 +3194,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
-	bool mmap_unlocked = false;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -3232,25 +3216,40 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		enum scan_result result = SCAN_FAIL;
+		struct vm_area_struct *found;
+		enum scan_result result;
 
-		if (mmap_unlocked) {
+		/*
+		 * A collapse gives the lock up, so the VMA has to be found
+		 * again after one: it can shrink while nothing is held.  A scan
+		 * that finds nothing to collapse leaves the lock alone, so a
+		 * range that is already collapsed walks on without relocking.
+		 */
+		if (!vma) {
 			cond_resched();
 			mmap_read_lock(mm);
-			mmap_unlocked = false;
-			*lock_dropped = true;
-			result = hugepage_vma_revalidate(mm, addr, false, &vma,
+			result = hugepage_vma_revalidate(mm, addr, false, &found,
 							 cc, HPAGE_PMD_ORDER);
 			if (result != SCAN_SUCCEED) {
 				last_fail = result;
-				goto out_nolock;
+				goto out_locked;
 			}
-
+			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 
-		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
+		result = collapse_scan_pmd(vma, addr, cc);
+		/* Nothing to do here, and the lock is still ours */
+		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+			goto tally;
 
+		/* The collapse takes its own locks, so give this up */
+		mmap_read_unlock(mm);
+		*lock_dropped = true;
+		vma = NULL;
+
+		result = collapse_run_pmd(mm, addr, result, cc);
+tally:
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
@@ -3272,17 +3271,15 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		default:
 			last_fail = result;
 			/* Other error, exit */
-			goto out_maybelock;
+			goto out;
 		}
 	}
 
-out_maybelock:
+out:
 	/* Caller expects us to hold mmap_lock on return */
-	if (mmap_unlocked) {
-		*lock_dropped = true;
+	if (!vma)
 		mmap_read_lock(mm);
-	}
-out_nolock:
+out_locked:
 	mmap_assert_locked(mm);
 	kfree(cc);
 
-- 
2.54.0


