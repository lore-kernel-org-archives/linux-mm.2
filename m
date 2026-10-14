Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97063CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 21:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15FC76B0088; Wed, 14 Oct 2026 17:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136676B008A; Wed, 14 Oct 2026 17:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075216B008C; Wed, 14 Oct 2026 17:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C10186B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:16:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B60940792
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:16:21 +0000 (UTC)
X-FDA: 85322490162.22.A4A3803
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3E460100006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:16:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wHPwfnc1;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792012579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLczMfcbTDkoBgkV9qbzR8bM6PnzlWrtoAMW7ghjW5M=;
	b=qJSsxWCLWuRSnNW4FEzCdsu2mRWfGNK22e8ZlGzajSTzw9wxQK+fexwumE2HCGnU1Fvj0A
	4FV/AKXAEB0gj1ZCKiTGUfLCU0is0NfLxrFTAYy5qUmNOArByziEpS2bF8j1UllA3PbI1W
	tan7QpAxP/eyCfzAPYATO48UYZAbZ7I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wHPwfnc1;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792012579;
	b=zDly6cIODRuTOY4X1vRfpV6AOxt6sWsPylOE0bG8Lb1eMaUfLXlQazeX/jJqooL5uuQHe6
	UpicA1pYb7X7GXXsDsdAErZU4h9RLeaAODXGw4ElYTSZn4Dmay3dyLUyvOQ6gOUVIV3QAO
	223s/wrkZQ0p32i4SSQ0IE1cHwn4g74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B3E043312;
	Wed, 14 Oct 2026 21:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D4F1F000C4;
	Wed, 14 Oct 2026 21:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792012577;
	bh=sLczMfcbTDkoBgkV9qbzR8bM6PnzlWrtoAMW7ghjW5M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wHPwfnc1aFL4h4B6Qqbfm4Y79W4TejKdqJENP2t9KGj9HqeNOt0t6saaPuCgfAEDp
	 UM7Y8SlJbflypjFzTvtRGWyJNVEmfsB39HN87On8jUXMzEwQgXoxWDn5ryAtefQuJr
	 06N2C0Lh9LDRvG4fDD4vDLG2py7+ULucIVj2OVNw=
Date: Wed, 14 Oct 2026 14:16:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>
Subject: Re: [PATCH v5 0/9] mm/collapse: separate a collapse from its
 callers
Message-Id: <20261014141616.6d79df8fc8c6ef7d41df5afc@linux-foundation.org>
In-Reply-To: <20261014171145.3292736-1-kas@kernel.org>
References: <20261014171145.3292736-1-kas@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3E460100006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: p9emoo556gf6b9xgxt7aquim6gd45dx1
X-HE-Tag: 1792012579-921283
X-HE-Meta: U2FsdGVkX185CF3o046939oxdCK6Ys6ek8c2AEsozNNeINBoH9AgaFx/87aXc5KdfZXVGqtdgl3WbgzmFomBKPmArnCnWi5XMdJBSRnpphOwrSgcsmgmfyyI7TZMQ7TchVv/QheJLxyCKNmZfuEaaPYk2z0Uw3DRmS++/yuKxtmH7KkR7c2e6PzGAVevGWSLaqzR+/Fxq3NIDWh6zkg0eof/cUnt0jNAbXmhxpNq9XBsK329980uA0WF7rl4uhpiX1yVMHeLuMSIatcYynjaYM73+L6HUFl4DBRia4ldMH+0gMJxsFobYSw38wlHILWR5CgLceVsOjtD9K/knYQN7elvsU8W5zRVZqdUp96DpBeUNqSOigSPJsu01WwABTVLQrFroV+OH8EFcUzk3gYV40bQrlFCfAaTbj4Wcnn3XdU/PQUM6+aSyFAmRWhawX+Ib7z0c0CGkDC4GWL8z+iZW57sF5xQlxJOGxe/0BblswJmECFO4wsC2nkx1TUoh1I0oNUpZO4uqCodi3OFzNA7uY/ryu8AC3wLYTsFgZWcuxEBAz0Vvk8KqkVwjjlankYlnBwLSEd9bhvKnlipCmqPfeJITU8dqczMCEIcjt8NqWo1UY0AfqB7EEk+0ifu+0pdAUB6FlbCyY09XKAcTd0bwngAkIvTH0neNNTVUYRnjFQIXgxwJjwqXGC80iKnInzzMdsEzkukjQXSSkdjZ9Nh6Dp8STRzJ6WNbDVXeecGDKpDhsbE8sOllGMZj6JYnMRRd7+FN2u5O0VGh3VyxJ2heLTfwi8KNJBB892f/NO21XyJ1K1X7rdW5ZR1GYUM/1TtHS5KJKOJfQ6QJRMzTI5LoSZ34xNSR9zyLXuxGJTQu0OM6yOG5SzBvX9q0b1yzKvBADApKt2iAqdqsfn3rVNhfjWq9MtuCzbBUYDvhnW4sOkGo1RbAvV9SXwaDQiHQCp9E60c85PQiRa16ovDSIE
 M+btcx/v
 +/+z6nLRxUc5dpeIcYBhQOGcl2qoWyCXcKYZ1tu3zCrwtm4KB6a1ncS/HwJAsbV/E6ZlLqDqqrQ63f4YKCizT3ZK/HpIO16PyjebOKFyD0sEuF5FgsvdQ5EExsgtGzJ5lVf2QKNkAwBu5qqJls05I7u7u/1MyTdJ/6qKbjysaSln2EhbXKijXI68SQxxvf0bE/3b2Wn5XLwO1CloIayCk6L78srPdNa0zs5iSwm3ODZG1djTIOkInl8JJtMuwx0Pz4EC+gxlPXM4HwVp/0WvGZqn9Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 18:11:33 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> There is no line between the collapse engine and the callers that ask for
> a collapse.  khugepaged.c holds both, and they reach into each other.
> 
>  - Sixteen tests through the collapse path read cc->is_khugepaged to work
>    out what they are allowed to do, when every one of those decisions was
>    made by the caller before it asked.
> 
>  - collapse_single_pmd() does both halves of a collapse behind one call.
>    Where it gives up mmap_lock between them is buried in the anonymous
>    scan on one side and ahead of the file scan on the other.
> 
> Start drawing the line.  The caller states what it allows in a policy,
> and the collapse code reads the policy instead of asking who called.  The
> scan of a PTE table and the collapse that follows get a function each,
> with the mmap_lock drop between them in one place.

Thanks, updated.

> Changes since v4
> ================
> 
>   https://lore.kernel.org/all/20260928100630.21870-1-kirill@shutemov.name/
> 
>  - Patches 10-13 dropped.
> 
>  - Patch 7: the changelog no longer mentions a release for the control,
>    which v4 dropped.
> 
>  - Patch 9: collapse_scan_anon(), collapse_pmd() and collapse_anon()
>    replace collapse_scan_anon_pmd(), collapse_run_pmd() and
>    mthp_collapse() (David).  The scan_* fields in collapse_control are
>    commented as anonymous-only and file-only (Zi).  Comments that named
>    collapse_scan_pmd() for the anonymous scan follow the rename.
> 
>  - Acked-by from David Hildenbrand on 5 and 8; Reviewed-by from Zi Yan on
>    5 and 8 and from Baolin Wang on 5; Tested-by from Baolin Wang on 5;
>    Acked-by from Zi Yan on 9.

Here are the v3->v4 changes for the nine remaining patches:


 mm/collapse.h   |   16 ++++++++++------
 mm/khugepaged.c |   28 ++++++++++++++--------------
 2 files changed, 24 insertions(+), 20 deletions(-)

--- a/mm/collapse.h~b
+++ a/mm/collapse.h
@@ -100,16 +100,20 @@ struct collapse_control {
 	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
 
 	/*
-	 * What a scan found and the run after it needs.  Live only between the
-	 * two, and read by nobody else.
-	 *
-	 * The file side takes a reference while it still has the VMA, since a
-	 * file collapse works on the page cache and never sees one; the run is
-	 * what gives it back.
+	 * What a scan found and the collapse after it needs.  Live only between
+	 * the two, and read by nobody else.
 	 */
+
+	/* Anonymous only: orders to try, referenced and swap PTE counts */
 	unsigned long scan_orders;
 	int scan_referenced;
 	int scan_unmapped;
+
+	/*
+	 * File only.  A file collapse works on the page cache and never sees a
+	 * VMA, so the scan takes a reference to the file while it still has
+	 * one, and the collapse gives it back.
+	 */
 	struct file *scan_file;
 	pgoff_t scan_pgoff;
 };
--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -646,7 +646,7 @@ static enum scan_result __collapse_huge_
 			goto out;
 		}
 
-		/* See collapse_scan_pmd(). */
+		/* See collapse_scan_anon(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			/*
 			 * TODO: Support shared pages without leading to further
@@ -1099,7 +1099,7 @@ static enum scan_result check_pmd_still_
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if collapse_scan_pmd() believes it is worthwhile.
+ * Only done if collapse_scan_anon() believes it is worthwhile.
  *
  * For mTHP orders the function bails on the first swap entry, because
  * faulting pages back in during collapse could re-populate PTEs that
@@ -1460,8 +1460,8 @@ static unsigned int max_order_from_offse
 }
 
 /*
- * mthp_collapse() consumes the bitmap that is generated during
- * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
+ * collapse_anon() consumes the bitmap that is generated during
+ * collapse_scan_anon() to determine what regions and mTHP orders fit best.
  *
  * Each bit in cc->eligible_ptes marks a PTE the scan accepted as a collapse
  * source. We start at the PMD order and check if it is eligible for collapse;
@@ -1476,8 +1476,8 @@ static unsigned int max_order_from_offse
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
  */
-static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long address,
-		struct collapse_control *cc)
+static enum scan_result collapse_anon(struct mm_struct *mm,
+		unsigned long address, struct collapse_control *cc)
 {
 	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
@@ -1576,7 +1576,7 @@ done:
 	return last_result;
 }
 
-static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+static enum scan_result collapse_scan_anon(struct vm_area_struct *vma,
 		unsigned long start_addr, struct collapse_control *cc)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
@@ -1612,7 +1612,7 @@ static enum scan_result collapse_scan_an
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
 	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
-	 * is then checked again in mthp_collapse() for each attempted order.
+	 * is then checked again in collapse_anon() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
 		max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
@@ -2785,20 +2785,20 @@ static enum scan_result collapse_scan_pm
 	pgoff_t pgoff;
 
 	mmap_assert_locked(vma->vm_mm);
-	/* Whatever the last scan found has to have been run by now */
+	/* A scan that found work has to have been followed by collapse_pmd() */
 	if (WARN_ON_ONCE(cc->scan_file)) {
 		fput(cc->scan_file);
 		cc->scan_file = NULL;
 	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_anon_pmd(vma, addr, cc);
+		return collapse_scan_anon(vma, addr, cc);
 
 	pgoff = linear_page_index(vma, addr);
 	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
 	/*
 	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
-	 * the PMD folio, and retracting the PTE table is the run's job.
+	 * the PMD folio, and collapse_pmd() still has to retract the PTE table.
 	 */
 	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
 		return result;
@@ -2812,7 +2812,7 @@ static enum scan_result collapse_scan_pm
 	return result;
 }
 
-static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+static enum scan_result collapse_pmd(struct mm_struct *mm,
 		unsigned long addr, enum scan_result result,
 		struct collapse_control *cc)
 {
@@ -2821,7 +2821,7 @@ static enum scan_result collapse_run_pmd
 	pgoff_t pgoff;
 
 	if (!file)
-		return mthp_collapse(mm, addr, cc);
+		return collapse_anon(mm, addr, cc);
 
 	cc->scan_file = NULL;
 	pgoff = cc->scan_pgoff;
@@ -2882,7 +2882,7 @@ static enum scan_result collapse_single_
 	mmap_read_unlock(mm);
 	*lock_dropped = true;
 
-	return collapse_run_pmd(mm, addr, result, cc);
+	return collapse_pmd(mm, addr, result, cc);
 }
 
 static void collapse_scan_mm_slot(unsigned int progress_max,
_


