Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10AB3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 034806B00B6; Tue, 30 Jun 2026 05:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F273F6B00B7; Tue, 30 Jun 2026 05:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65B16B00B8; Tue, 30 Jun 2026 05:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB9196B00B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:57:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AE041C6E3F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:57:23 +0000 (UTC)
X-FDA: 84936126366.23.CC7DD16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8487B4000F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:57:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ADB7zKnZ;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782813441;
	b=uSydxkxCFkOBxnaMqBR+D8+BhZ5CJjaixEmWiv5kEEyuPB1ISmwJD/p1TyMrHHYiDdcVv9
	Ud1r3u4JelaN27+jZf2CF/jkym4nfIYwsOqu+GiRZi+XzuJKlLS2p8mpu1LlTIluQWSJxl
	CV0N4gncFxp76hMge02BppkLQYFvb3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782813441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uswHKiiboqANt8oiY8a09HzTyTmoJjrXo6oo4QGSw9M=;
	b=yMGguKFNpHw6pimdhsBSOPapZSESUdeWdU1n9jD1EiKVWBMJrHNK+/iy0iYahQfDGXo+bt
	71H4yWjBF785AXrliS+nZpg1agDnD4Y4UxRvEgGlQ6x+3LDaeGDQhBf7Vv5Ae2O+hUU8Cn
	lqGd7M00At9SRFI5QIbuVLTMocOPGro=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ADB7zKnZ;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B562D402D6;
	Tue, 30 Jun 2026 09:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF7A1F000E9;
	Tue, 30 Jun 2026 09:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782813440;
	bh=uswHKiiboqANt8oiY8a09HzTyTmoJjrXo6oo4QGSw9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ADB7zKnZGmNXADJ3tRtD7hXSgF5hL/kkBTFtpzCPUvF3XbQcGrg3n7rtqvwwR6OwX
	 XBrXKMYMidEbp89jDOiawcrj7PKb9s00KRDW5uEtpgXXyOBJNrMW/Frb8imnz0cueA
	 QxAXTJ2HEIJ9Ct/mGjniTh/vbFojk09inOK+nv3ai21XnTBU0zgIrCAPLJAssboAQw
	 BgmTSC/FZGVVsouKJsO+nyUwkFVz0ZF9zpZ/b1TbI1/K9ASBajsaclG8gKNFWT3FkV
	 TibgAv/SKZ4zDlwqbFH27HXMPAvw0g0l8B6poyEvj7vfbbUU95s+VDiJ2T+iJQ+xNW
	 4oX4m+Xcr0Cog==
Date: Tue, 30 Jun 2026 10:57:11 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: sarthak.sharma@arm.com, akpm@linux-foundation.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory: refactor finish_fault
Message-ID: <akOS23WSqp_6oXpW@lucifer>
References: <20260624102047.144543-1-sarthak.sharma@arm.com>
 <20260630075153.78201-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630075153.78201-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Stat-Signature: nnep9rq8nwj6onoypjhki19bgx1nfhyd
X-Rspamd-Queue-Id: 8487B4000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1782813441-313583
X-HE-Meta: U2FsdGVkX1+g0Aiwd6Ke0h07GIHONmATAphukQOkNoOJaF//6ycuIz++QGocUYrFlrASDswzudMtnYGrgz//7M6sUo+xVzKaguCPLUp8cRoMPC9eNTaNJxrkh5EsPeruLlIZdiR97osxbxNtOMUL48hVxorage5oZVmVv2nFz/Z0obBMTOBY9qJgGmNLthjTZGofI9WV16CA1hP8KiSQzrMzc/msxf+MWRJdq0x/n9oXlqP/roe+i7CYekPFpcuEE7AOI0uqgDbYhhUZ++5Gs2kSLnsuOaEFo3FrLVNHcKf7Emx60MJGOhVte2P9EqvZ4j4E4TvXg01qvhmQGtVzPLwwa7V9Jk1nflAh+pcEZYQBgc2qdeGc+HjmbqkIqhe/lxH53inOJQCFZdGG7vYkRxfbJLNpwzlO2HeO8LkYWU2COt2unHb/elcsuZZyXbhasBhGoCAHjqf+c5KnAkmSDin6xbi0VhpWqI715mSXeXtMOMsm+QE67+JvcNQ83FZ225OFPKNLEaZxt6WClQhIGAstvBsN9pvF+UW6didDreyEENdmwzJDA5MFc4yOlXXs9aTVzV0sMCC+cpl73m6lleRNCvvAn00BG1owySXp5t31PICKJN4J5Kzx9uUdDxhHktxPGwhGdd9tU+K4ndMXeggSVtwvyAJEpSS6sBbtEOvrX/ULP6z9uZoGyUNRLYet+DRuVY8O6x+I5kFjjYMo1YWAQG8KpTUOikIzyZf+lL87JOT5XKzeF5MEeidc/Hk9p/NlYydxVgttliJ7Smx4+O76mSxwkvEV3GlCKeV0jTfDq9zYT4gJ5q0MUr7mmEHV7p4fIhuOOziNyufsOTx+Aw7ztVD27BS5YqzsrYHgxTqbBcE/UKRI/uAKLp22m0M26oHG0NeOIt71yepa2pvJzBdFm5U6MxAiuI22HmYfFfbNrhSQyyTR9Lo8ZPl8xWSAImw0KQNOCGdDBv2rdTL
 ZRRC7NXt
 trO6NmgTdjd8cObQ4f83gLISYdf3k/VEo7t6NeV+EmqkRW9KXwgUVKaq/HSvjhP/5hLRqoMps4tLTOFvMfM1MA/MPVdeRlowWOvZZLe6RQ2QsgF9RtdmSEhzTtbeRePJ8lTmq81orvXn5b4m0QXcE8gPtiNexfCa1PI09vJ2l0Rg1lDidntIF3OY9KzNh+jsoK4Itf5aYQrPBbItjBntGD6A5QO2ERveNYCVYIlhUtUHgYYEmveYq7k1o9lvBTCIdq1v3fJ7KOm+yHurLquux2TFVWMzbVFwxKGK/qOrY+h1TkZPTrUrc2IgWxkupo+cujzCwWvGh3EL0B1XXl/+HDtz+Djvg8QFOWq7U1sgXKrWDOGE9Cdbj+rCZWoolGeADysPV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 03:51:53PM +0800, Lance Yang wrote:
>
> On Wed, Jun 24, 2026 at 03:50:47PM +0530, Sarthak Sharma wrote:
> >finish_fault() currently has a goto fallback implementation
> >where we try to map a large folio with PTEs. If that cannot be
> >installed, we goto fallback and go through the fallback mapping
> >path again. This looks weird and is tough to comprehend.
> >
> >Remove the goto fallback implementation and try to map the
> >whole folio if allowed. If the whole folio cannot be mapped,
> >fall back to single page mapping without repeating the whole
> >function.
> >
> >The cleanup of finish_fault() was suggested by David in [1].
> >
> >[1] https://lore.kernel.org/all/3684c55a-6581-4731-b94a-19526f455a1e@kernel.org/
> >
> >Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> >Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> >---
> >Tested this patch by running mm selftests on baseline and patched 7.1
> >kernels. No regressions were observed.
> >
> > mm/memory.c | 78 ++++++++++++++++++++++++++++-------------------------
> > 1 file changed, 41 insertions(+), 37 deletions(-)
> >
> >diff --git a/mm/memory.c b/mm/memory.c
> >index 86a973119bd4..f883b3f3850e 100644
> >--- a/mm/memory.c
> >+++ b/mm/memory.c
> >@@ -5666,18 +5666,16 @@ static bool vmf_pte_changed(struct vm_fault *vmf)
> > vm_fault_t finish_fault(struct vm_fault *vmf)
> > {
> > 	struct vm_area_struct *vma = vmf->vma;
> >-	struct page *page;
> >+	struct page *page, *map_page;
> > 	struct folio *folio;
> > 	vm_fault_t ret;
> > 	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
> > 		      !(vma->vm_flags & VM_SHARED);
> >-	int type, nr_pages;
> >-	unsigned long addr;
> >+	pte_t *fault_pte, *start_pte;
> >+	int type, nr_pages, nr_ptes;
> >+	unsigned long start_addr;
> > 	bool needs_fallback = false;
> >
> >-fallback:
> >-	addr = vmf->address;
> >-
> > 	/* Did we COW the page? */
> > 	if (is_cow)
> > 		page = vmf->cow_page;
> >@@ -5695,7 +5693,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
> > 			return ret;
> > 	}
> >
> >-	if (!needs_fallback && vma->vm_file) {
> >+	if (vma->vm_file) {
> > 		struct address_space *mapping = vma->vm_file->f_mapping;
> > 		pgoff_t file_end;
> >
> >@@ -5727,56 +5725,62 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
> >
> > 	nr_pages = folio_nr_pages(folio);
> >
> >+	/* Initialize for single page mapping */
> >+	map_page = page;
> >+	start_addr = vmf->address;
> >+	nr_ptes = 1;
> >+
> > 	/* Using per-page fault to maintain the uffd semantics */
> >-	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
> >-		nr_pages = 1;
> >-	} else if (nr_pages > 1) {
> >-		pgoff_t idx = folio_page_idx(folio, page);
> >-		/* The page offset of vmf->address within the VMA. */
> >-		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
> >+	if (nr_pages > 1 && likely(!needs_fallback) && likely(!userfaultfd_armed(vma))) {
> >+		unsigned long fault_page_idx = folio_page_idx(folio, page);
> >+		unsigned long pages_to_folio_end = nr_pages - fault_page_idx;
> >+
> >+		bool fits_vma = folio_within_vma(folio, vma);
> >+
> > 		/* The index of the entry in the pagetable for fault page. */
> > 		pgoff_t pte_off = pte_index(vmf->address);
> >
> >-		/*
> >-		 * Fallback to per-page fault in case the folio size in page
> >-		 * cache beyond the VMA limits and PMD pagetable limits.
> >-		 */
> >-		if (unlikely(vma_off < idx ||
> >-			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
> >-			    pte_off < idx ||
> >-			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
> >-			nr_pages = 1;
>
> TL;DR: nothing looks broken to me here. Just wanted to spelling out what
> this relies on :)
>
> Old code above had four range checks before installing multiple PTEs:
>
>   1) vma_off < idx
>   2) vma_off + (nr_pages - idx) > vma_pages(vma)
>   3) pte_off < idx
>   4) pte_off + (nr_pages - idx) > PTRS_PER_PTE
>
> PTE-table part looks equivalent after refactor. 3) and 4) become:
>
>   3) pte_off >= fault_page_idx
>   4) pte_off + pages_to_folio_end <= PTRS_PER_PTE
>
> where fault_page_idx is old idx, and pages_to_folio_end is old
> nr_pages - idx.
>
> Only VMA part looks different to me. Old code checked same range, based
> on fault address, that it later installed:
>
>   [vma_off - idx, vma_off + (nr_pages - idx))
>
> After refactor, folio_within_vma() checks folio range:
>
>   [folio->index, folio->index + folio_nr_pages(folio))
>
> while installed range is still based on fault address:
>
>   [vmf->pgoff - fault_page_idx, vmf->pgoff - fault_page_idx + nr_pages)
>
> So these line up when:
>
>   vmf->pgoff == folio->index + fault_page_idx
>
> Looks fine for page-cache users, since vmf->page comes from
> folio_file_page(folio, vmf->pgoff).

This to me all strongly suggests a comment might be helpful here :)

>
> [...]
>
> Cheers, Lance

Cheers, Lorenzo

