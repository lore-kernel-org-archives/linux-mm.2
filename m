Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08BF3C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27E56B00DD; Tue, 30 Jun 2026 03:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD87B6B00DE; Tue, 30 Jun 2026 03:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF396B00DF; Tue, 30 Jun 2026 03:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 988196B00DD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:52:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11795167C5D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:52:20 +0000 (UTC)
X-FDA: 84935811240.21.80B98B2
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F5E7100004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:52:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=co63CCcd;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782805938;
	b=hJtH6pnwEmJYzTD21xjtx0xlfSIPXUBdu0ayygqPzv/bzmfpGdbIYKhVerB1jUkeabZLCZ
	FvPCBr2hZEEOiBwp9niydqs5mhciS+7/VEWvFWei9u5FMZWtIQDf1FPb3C4XrBv0cZqQNv
	eilW75iYEpkkp9PSHoncPbcxmQ8M28A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782805938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjV7MUM0fTW0l2bLsP56lxGOgmMniewaSqOOi/jChAI=;
	b=wasNrGbxKYOG9QxnrcnTp8cnhovtb7ydPtWFERp9R5KzQf1aNCBuDo3fXBlp8/nWMjFzEf
	h1VBMTCQg7ldLB80XjhDsOJiKLSYh6AAgPkue6j+fGSj3xOweL3bso3G0Urj7Sx1KoGS4h
	UGVD0+przKzx+ZETCQsZmfTtQwMymTc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=co63CCcd;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782805935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjV7MUM0fTW0l2bLsP56lxGOgmMniewaSqOOi/jChAI=;
	b=co63CCcdteWmQ39aIJfmwuv/Vfh6Ko3VzwQKXa/xqAC/FI35TrMiiQtsmbS1RdHREqEjuH
	1EikgbTwEQ8Jkmv1Zbu1YKJ8BlHzM5S3eWL841cha6+Yo1QtuS1SU7qYZVB2c8Suq8cdha
	PwX/onpf3ZAtPtkuLmPRZ0Z/AHBh3Mc=
From: Lance Yang <lance.yang@linux.dev>
To: sarthak.sharma@arm.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dev.jain@arm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/memory: refactor finish_fault
Date: Tue, 30 Jun 2026 15:51:53 +0800
Message-Id: <20260630075153.78201-1-lance.yang@linux.dev>
In-Reply-To: <20260624102047.144543-1-sarthak.sharma@arm.com>
References: <20260624102047.144543-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0F5E7100004
X-Stat-Signature: ocj1xfu67tf8gdkdmk1e3tyk1rd4gwt3
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782805937-672234
X-HE-Meta: U2FsdGVkX1+ZcBM/o9OBlkBeYq16wDyHRWUV9c46JmWU7PjQee86sQQDL0BPi3Sp6CzLV+h89cfYzjTdrJdkXA2ju5v/ksmPAEjKCY933yNIEuB1ux/yY6QIeq9Qus6+rn2bvnpfI9TWsi0fTuirdsntEQniWmD9LX6aSTBvSHr2AlZ4NQvWnmb6fkx4LlTtDmMaqo5O3i8Z0kJpO8VVd+9R1JN8Qiew5A523APNV7YzcFrhipHoFWXqsj4JMluIElXevsOtD+kO3pDmal7t3lNw2WmlwwPn/dZnvfhQDoXjTR6zO0ezXS11p8VDm4ysDSzt93tYQXWTUAyOPWcZwjfCDNc7ikqIfkfisdQeE3HTW7dSd+zibfsdXoFmSUfCfecMhtP5A7KT+s2vn7+d53zQkcGa5UlIwq6CUdgTfjrkhLXiRonQqvEQdlXvM5ofcO93Z5e2m/vXlIKJTwngfLXbTum3AodK1bBelWh2X55SSWosCzCZCOfoHxQaiXDZib/Jq9FO9gThe0wJEsO0FSKK6VehySxD3JWmGxZXVFtua6iDiUGHtDy6AfnyHZ/QpW8peHjCiZiiMuam6C6C9SVoApaWmwjbKAMAEe4EjUUaMsYsbLMr+RFui8NsDiLGpjXQZnRqsvQge6/JuSySNTwMaCF7y5x4NmU9uZ/91Hnsc0BmEE5dInsEuMn4MKTb1GD/qU/Bks2dIAd3GSBcRfKNjpdbOr67xP9Sv0Xt02cnjm4KwQgWxv9ZbR+6SUw9FdooGMAlKGnxIjLl82BnDwGb77KrSGnjpHA3tIwlBVhWJpHPGGz9K9tZKs8dtRJgCciyGt8XSL2XbMXPZRr3weOd/13/OkeD3EOtYighrl9wwJfpcZTz8qLKv9sNmA63ufjDhkap6yR/Gab2Dja7gcf+vtFWsycsxwNJK7fSde6Uh+8uohTmnk+bi3rTlEuGbOPhwEiPXxNohvJk7IC
 cT4IqF8L
 1ul2mc1KEfwLJgtNCf6GtgfFpT2A1xcenyTyx3uyPwODKKx2J46tIIRARc1bgCaqeXyW82Kit94sCrXH2AtKqyOzdBT+IjfoeTUIhwKwZ18AoqN74axE5QSmOm9bFqZb9X5BDK5KMrMsPlCmr4cHUsxoV62cGuqCdwyoSJz+oKkYiIHjEMeqDp0jwgGClDn8SCM/tJ6uIpHqR/kUptMdEBKWsJ836j+AB6jPfrxR69Hx4cOVefpCdHzKUGlTMa09FiUe+wKprAO4evKROJg3ey8pP4183OlISmP5YYX/iPJoFdqqFyf8s58qkR7Wfq8KBF99rbf6OWOcJ8ZXan4XohT326Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 24, 2026 at 03:50:47PM +0530, Sarthak Sharma wrote:
>finish_fault() currently has a goto fallback implementation
>where we try to map a large folio with PTEs. If that cannot be
>installed, we goto fallback and go through the fallback mapping
>path again. This looks weird and is tough to comprehend.
>
>Remove the goto fallback implementation and try to map the
>whole folio if allowed. If the whole folio cannot be mapped,
>fall back to single page mapping without repeating the whole
>function.
>
>The cleanup of finish_fault() was suggested by David in [1].
>
>[1] https://lore.kernel.org/all/3684c55a-6581-4731-b94a-19526f455a1e@kernel.org/
>
>Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>---
>Tested this patch by running mm selftests on baseline and patched 7.1
>kernels. No regressions were observed.
>
> mm/memory.c | 78 ++++++++++++++++++++++++++++-------------------------
> 1 file changed, 41 insertions(+), 37 deletions(-)
>
>diff --git a/mm/memory.c b/mm/memory.c
>index 86a973119bd4..f883b3f3850e 100644
>--- a/mm/memory.c
>+++ b/mm/memory.c
>@@ -5666,18 +5666,16 @@ static bool vmf_pte_changed(struct vm_fault *vmf)
> vm_fault_t finish_fault(struct vm_fault *vmf)
> {
> 	struct vm_area_struct *vma = vmf->vma;
>-	struct page *page;
>+	struct page *page, *map_page;
> 	struct folio *folio;
> 	vm_fault_t ret;
> 	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
> 		      !(vma->vm_flags & VM_SHARED);
>-	int type, nr_pages;
>-	unsigned long addr;
>+	pte_t *fault_pte, *start_pte;
>+	int type, nr_pages, nr_ptes;
>+	unsigned long start_addr;
> 	bool needs_fallback = false;
> 
>-fallback:
>-	addr = vmf->address;
>-
> 	/* Did we COW the page? */
> 	if (is_cow)
> 		page = vmf->cow_page;
>@@ -5695,7 +5693,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
> 			return ret;
> 	}
> 
>-	if (!needs_fallback && vma->vm_file) {
>+	if (vma->vm_file) {
> 		struct address_space *mapping = vma->vm_file->f_mapping;
> 		pgoff_t file_end;
> 
>@@ -5727,56 +5725,62 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
> 
> 	nr_pages = folio_nr_pages(folio);
> 
>+	/* Initialize for single page mapping */
>+	map_page = page;
>+	start_addr = vmf->address;
>+	nr_ptes = 1;
>+
> 	/* Using per-page fault to maintain the uffd semantics */
>-	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
>-		nr_pages = 1;
>-	} else if (nr_pages > 1) {
>-		pgoff_t idx = folio_page_idx(folio, page);
>-		/* The page offset of vmf->address within the VMA. */
>-		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
>+	if (nr_pages > 1 && likely(!needs_fallback) && likely(!userfaultfd_armed(vma))) {
>+		unsigned long fault_page_idx = folio_page_idx(folio, page);
>+		unsigned long pages_to_folio_end = nr_pages - fault_page_idx;
>+
>+		bool fits_vma = folio_within_vma(folio, vma);
>+
> 		/* The index of the entry in the pagetable for fault page. */
> 		pgoff_t pte_off = pte_index(vmf->address);
> 
>-		/*
>-		 * Fallback to per-page fault in case the folio size in page
>-		 * cache beyond the VMA limits and PMD pagetable limits.
>-		 */
>-		if (unlikely(vma_off < idx ||
>-			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
>-			    pte_off < idx ||
>-			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
>-			nr_pages = 1;

TL;DR: nothing looks broken to me here. Just wanted to spelling out what
this relies on :)

Old code above had four range checks before installing multiple PTEs:

  1) vma_off < idx
  2) vma_off + (nr_pages - idx) > vma_pages(vma)
  3) pte_off < idx
  4) pte_off + (nr_pages - idx) > PTRS_PER_PTE

PTE-table part looks equivalent after refactor. 3) and 4) become:

  3) pte_off >= fault_page_idx
  4) pte_off + pages_to_folio_end <= PTRS_PER_PTE

where fault_page_idx is old idx, and pages_to_folio_end is old
nr_pages - idx.

Only VMA part looks different to me. Old code checked same range, based
on fault address, that it later installed:

  [vma_off - idx, vma_off + (nr_pages - idx))

After refactor, folio_within_vma() checks folio range:

  [folio->index, folio->index + folio_nr_pages(folio))

while installed range is still based on fault address:

  [vmf->pgoff - fault_page_idx, vmf->pgoff - fault_page_idx + nr_pages)

So these line up when:

  vmf->pgoff == folio->index + fault_page_idx

Looks fine for page-cache users, since vmf->page comes from
folio_file_page(folio, vmf->pgoff).

[...]

Cheers, Lance

