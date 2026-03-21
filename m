Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4F51094461
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 08:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819706B008C; Sat, 21 Mar 2026 04:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAD76B0092; Sat, 21 Mar 2026 04:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4436B0093; Sat, 21 Mar 2026 04:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CEA76B008C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:15:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 008AC1B80F1
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:15:56 +0000 (UTC)
X-FDA: 84569361912.27.DA3E1B7
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9BE0B180005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:15:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=J5mJTTZT;
	spf=pass (imf16.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774080955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6DpjH6acNo29j+ySJO1Svjw5XBa6hniIpAnnMRD1ik=;
	b=DqGuzd7Di0L1kLamxZ2cUEcMb5cz7DEE0ZV+Cc11kSoF+59KXTxJmUE5HLvf5yeNh2WYGW
	AUPTkQPK3iS6T+n9K48pZi9P7n00Xzlao9z+qhbx164Fiq32sfk9y/SvSCipJAJyKD3tSA
	a8OuBmvGY3J/npRGdLyxh67XfWHon90=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774080955; a=rsa-sha256;
	cv=pass;
	b=n4FGcrkur4pwYg12dt9Ld2gaK9h4tT1xNsmdno2C9/9AQ5XzerElAutyvJYg6FeKyD0d56
	s6WYRByHygLCAHVFeYJjooXN+ffs2eC1En7iiB3R+13c1s7YL6hIN7LFi7pMxwxCxKAJJW
	iVhpOPoVu0wo92dPohiZkXP7WpOtNHM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=J5mJTTZT;
	spf=pass (imf16.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=1; a=rsa-sha256; t=1774080937; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Q9KtmBC/J3xxuGq1FTxEM6yHzpiHSWOIkLuJmasEVPmhqYFV+vqJvoavCAyaeCgvSP3Max4kfDtIn7bVgYsLPRb+dm4SKOIpgUrMqzhjl55Smngjz7n3Fr1FrbJ/9PGVy88VZRVt1HmMnT+NVzImcKVmdCokaqXLXjJ7ueLfERc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1774080937; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Z6DpjH6acNo29j+ySJO1Svjw5XBa6hniIpAnnMRD1ik=; 
	b=SLgvhysBsWoQpQLAnYvo1r1fDZaNFETczRbSr9WmalprBVSN+fF+CDY0CQDd0gAsbQR9YBdpRbmvOLvKK60rvd9fm4Ezhbx4l6uFSYBsZmE3rPJYNpNgTD6VXUId5vR3MsjhFaJ6J66t1Eo+TR+sckdfjg6WKo81+J6gze98o/o=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774080937;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Z6DpjH6acNo29j+ySJO1Svjw5XBa6hniIpAnnMRD1ik=;
	b=J5mJTTZTFlJElqh0JgaiyZMgCv1458ssNOLYWrfsLBWZcAzq1RMjLV0+7+ioGZgd
	aFJ4v2jQIQULeVc6PH2iMMBkmQB4YiRgDKv+zqVX4QOT+S7ryyFIiBTdKyS3F3QsEP9
	6ngNGJKt96UB86KsZuTB1Ppt4gc5HjlnLLHou550=
Received: by mx.zoho.in with SMTPS id 1774080935884169.48197276995222;
	Sat, 21 Mar 2026 13:45:35 +0530 (IST)
Message-ID: <03262674-2df0-40d8-b411-4735c6f43770@zohomail.in>
Date: Sat, 21 Mar 2026 13:45:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] mm/vmalloc: free unused pages on vrealloc() shrink
To: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9BE0B180005
X-Stat-Signature: 3fx6mnoygaeboww9rp7uqfid4kbaer3q
X-Rspam-User: 
X-HE-Tag: 1774080954-634819
X-HE-Meta: U2FsdGVkX19MLNDrVsH4ooc7b3a2ergctagQBHMqvT8r0g3RoYPlRrp2cgGYxFurdqM7v3K5v7Qi6NdGvEGwwQrKHJAyoENKUcOL/mdYWyRXewQ2VrQzQNBKuWYuxcnYDjruH//DMLrSo2Clnd+blqjfGo4tJDCJwpMAEJGUT/TuVpqvpYT0Mb7vBR58UkE0wdNsbExTAV+hmgppTONPVgvhBQ+CV2DVdtO0sNfCjvc0+TT40P/frzVM/HtjSdz1XsX5p/aoWPLPRC86GOltsqHlYrOkEWRRIqTPnaqrRWgnovUAClrVexVLKvNrx99rNTvS6JdqR6eXTbDvBzZip1n6xJozlu/FF8fDpE8T6PONrkIeD0oIUxlKnKZ/G75UUIYH2MeksgCMnuqspyoVZErRsH71rIzn8LRdjITiBRJyRFx31VIWzfqKt1fVe2NcluPyP8k726HMhAI9o3M3AyI/yUxKaZv8MbseyQkpfruKzFhxu0xqSffEnh4hJ7AU1/LDW6tlx+jr/zsP2l1PbUu+nuTeNOaX3xc1TItiD9nWYgPKb3FPn84nDz07dmkEJKzifW/Hi+bpWQ/8VcjQOq+kSZeFm8tTWgsui4xy38I+Kza3CYrJ6JCKGep1Mx+2ZUJGgQoi0ZEcq8MyInBDuAIF6Bvk8EBi1sZTtSCFRkt0DiRw1G2V+V12VQKobDQJY8KqPt/wkJjWYe9YHauJyJVDKq/LfZIB0cDceJQ/8P2WfvjbjGkrLX0voWqyEEYADIV0XOI/9X7URLjiboD+zRTn4unbnJIASi3ZXIsXe2sPnlLJqjCYOM60PGQsdElhDZEMNdD9C1svPXy52VidwX7qJaLm2Kjti33chAIiNKQLz12pM9ntzEU6SbZa6lYSR0Rex8IgW6zaWOUFAP9x5mcRAJXt4VFEjYDCGIL1GODQpO5goMcqcQJT65TSrcc546P4FSgGxe43+UGza5k
 +aIWsyKw
 T2MORRRTi+KJCveUyJj4yWEsI/b3C1Q/wrvrqPpo1t6tOtcWrxejtw2Ubngo3IU2+wqZJ+FH0OebQiEs1OVZ/T/4eCratAr9WiPKNutnxnlEsvaYXY7SfwbpDsuXbXu6lwE/x/2OpQ+Hi0E5nXk/Bfx2vxbY/g54HHSQskhTZm5Z31c63PHWlMoh47r099SOjBYNC7GKmrfOPiCTWBLWxwMVSGO7fijryAqQkmkRzGe1i1/4D0/54J2pFynjxfs3YCjXn0bJpjOBAdmEzGzJWnrXBzzcIMG1hOZZ+n90H/ghhVirqqIbt7WjLoKWirXzC8enR6VAG0nKwtcpVs1a1e9qs9YgeSCf2h+f3e16DidT3YnkcNn7ABewJralH/TZNB3IU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/03/26 13:47, Shivam Kalra via B4 Relay wrote:
> This series implements the TODO in vrealloc() to unmap and free unused
> pages when shrinking across a page boundary.
> 
> Problem:
> When vrealloc() shrinks an allocation, it updates bookkeeping
> (requested_size, KASAN shadow) but does not free the underlying physical
> pages. This wastes memory for the lifetime of the allocation.
> 
> Solution:
> - Patch 1: Extracts a vm_area_free_pages(vm, start, end) helper from
>   vfree() that frees a range of pages with memcg and nr_vmalloc_pages
>   accounting. Freed page pointers are set to NULL to prevent stale
>   references.
> - Patch 2: Uses the helper to free tail pages when vrealloc() shrinks
>   across a page boundary. Skips huge page allocations (page_order > 0)
>   since compound pages cannot be partially freed. Allocations with 
>   VM_FLUSH_RESET_PERMS are also skipped. Also fixes the grow-in-place
>   path to check vm->nr_pages instead of get_vm_area_size(), which 
>   reflects the virtual reservation and does not change on shrink.
> - Patch 3: Adds a vrealloc test case to lib/test_vmalloc that exercises
>   grow-realloc, shrink-across-boundary, shrink-within-page, and
>   grow-in-place paths with data integrity validation.
> 
> The virtual address reservation is kept intact to preserve the range
> for potential future grow-in-place support.
> A concrete user is the Rust binder driver's KVVec::shrink_to [1], which
> performs explicit vrealloc() shrinks for memory reclamation.
> 
> Tested:
> - KASAN KUnit (vmalloc_oob passes)
> - lib/test_vmalloc stress tests (3/3, 1M iterations each)
> - checkpatch, sparse, W=1, allmodconfig, coccicheck clean
> 
> [1] https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
> Changes in v5:
> - Skip vrealloc shrink for VM_FLUSH_RESET_PERMS (Uladzislau Rezki)
> - Link to v4: https://lore.kernel.org/r/20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in
> 
> Changes in v4:
> - Rename vmalloc_free_pages() to vm_area_free_pages() to align with
>   vm_area_alloc_pages() (Uladzislau Rezki)
> - NULL out freed vm->pages[] entries to prevent stale pointers (Alice Ryhl)
> - Remove redundant if (vm->nr_pages) guard in vfree() (Uladzislau Rezki)
> - Add vrealloc test case to lib/test_vmalloc (new patch 3/3)
> - Link to v3: https://lore.kernel.org/r/20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in
> 
> Changes in v3:
> - Restore the comment.
> - Rebase to the latest mm-new 
> - Link to v2: https://lore.kernel.org/r/20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in
> 
> Changes in v2:
> - Updated the base-commit to mm-new
> - Fix conflicts after rebase
> - Ran `clang-format` on the changes made
> - Use a single `kasan_vrealloc` (Alice Ryhl)
> - Link to v1: https://lore.kernel.org/r/20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in
> 
> ---
> Shivam Kalra (3):
>       mm/vmalloc: extract vm_area_free_pages() helper from vfree()
>       mm/vmalloc: free unused pages on vrealloc() shrink
>       lib/test_vmalloc: add vrealloc test case
> 
>  lib/test_vmalloc.c | 52 ++++++++++++++++++++++++++++++++++++++++++
>  mm/vmalloc.c       | 67 ++++++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 100 insertions(+), 19 deletions(-)
> ---
> base-commit: 7d47a508dfdc335c107fb00b4d9ef46488281a52
> change-id: 20260302-vmalloc-shrink-04b2fa688a14
> 
> Best regards,
Hi everyone,

Following up on the concerns raised regarding `get_vm_area_size()` versus
`vm->nr_pages << PAGE_SHIFT`, Andrew kindly ran the patchset through an
AI review which flagged several concrete issues.

I've used those results to audit the code and figure out exactly what
breaks when we shrink allocations while preserving the virtual area size.
Based on that research, here is what I am planning to include in the v6
series to address these edge cases:

1. Fixing the VM_USERMAP crash
Alice correctly pointed out that `remap_vmalloc_range_partial()` relies
on `get_vm_area_size()` to validate the mapping size. If we free tail
pages but keep `vm->size` unchanged, mapping the full original size
would cause a NULL pointer dereference in `vm_insert_page()`.
Plan: I'll update the shrink path to explicitly bail out if `VM_USERMAP`
is set, ensuring safety for these mappings.

2. Fixing the Kmemleak scanner panic
Kmemleak tracks the original allocation size and scans it periodically.
If we unmap and free tail pages without notifying kmemleak, its scanner
will fault on the unmapped virtual addresses.
Plan: I'll add a call to `kmemleak_free_part()` during the shrink to
keep its tracked object size updated.

3. Fixing a /proc/vmallocinfo race condition
`show_numa_info()` iterates over `v->nr_pages`. During a shrink,
modifying `nr_pages` and NULL-ing out the page pointers concurrently
could cause a reader to dereference a NULL page pointer.
Plan: I'll update the reader to use `READ_ONCE(v->nr_pages)`, and have
the shrink path do a `WRITE_ONCE(vm->nr_pages, new_nr_pages)` before
freeing the pages. This guarantees that concurrent readers either see
the old count with valid pages or the new, smaller count.

4. Fixing a stale data leak on grow
A vrealloc grow with `__GFP_ZERO` could leak previously discarded data
if an intermediate shrink happened without `__GFP_ZERO` (which skips
zeroing the freed region).
Plan: I will add mandatory zeroing in the grow-in-place path for
`want_init_on_alloc()` to clear any newly exposed bytes.

Thanks again to Alice and Danilo for prompting the closer look, and to
Andrew for providing the review. I should have v6 ready for review soon.

Best regards,
Shivam

