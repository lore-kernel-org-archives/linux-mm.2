Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A97FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410D26B0005; Tue,  5 May 2026 11:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1A46B0088; Tue,  5 May 2026 11:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7266B00D6; Tue,  5 May 2026 11:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2E36B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:42:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF47D1C0DE2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:42:42 +0000 (UTC)
X-FDA: 84733783764.14.E8E62C2
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1C3752000F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:42:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=mtlznHjO;
	spf=pass (imf13.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nbNV5fmwMB7R0HMX6HeRrH6CLRcdx02slZvxqPQSRg=;
	b=NMBkT/BUR7YBC2gxt3iMd1SxjJX/D7Y3B6wZ2rXFhs8t2NyG7qcOex0ZXZ2KE3xbSp3+Vh
	ONaItitLZQ57nfvFDArlKb/ilNaoGhikmFNVVgsrObWHwQLuYPbMvXTse/v/KWpH766cbi
	i1WkwkMTGTWVp69ENVrxbZI6Jiq8pTI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=mtlznHjO;
	spf=pass (imf13.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777995761; a=rsa-sha256;
	cv=pass;
	b=4IwgEBmqpf2UI7D+G6hayPTd1/qO7vJMDRMBM2yt0RKEZKSo0e5k1uM7DAFz3csqUBKgu6
	1pa9623NEIL9kL6Y15zloiGHYwlFCWT5GqNyFKOhmzQVZjwLDLKeHmDGXExGB9UqhBiYj5
	nyHEwqJZqrZgebok4Z8ufYsQO/AzLQg=
ARC-Seal: i=1; a=rsa-sha256; t=1777995740; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=bhlOvqYrlZECnWgXdMQEbH1hIouPMTWpvwntAca9gF3QmyDkVgUd7AMHwxmbKaXDtK78N+oMAiIM8JBjHNL8eRTdNmUwmdQveMuw5A971zUB0Qlt6Wmk8P/SjkQZNIoKHTATI7d6dcT8qngfjxZnTqNF9haXq+COsCUxe7XV6+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1777995740; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4nbNV5fmwMB7R0HMX6HeRrH6CLRcdx02slZvxqPQSRg=; 
	b=MmhG4dGMV75HRJis2y+PCPrCaapt0N28+gN11fOEfRCEe4trCVDanOLQXBR5QBhtf6o+OjB0MTht9uqGfd0jUmT/5p9+8eWkkS41+MlbnniAjS3RWjuR6Qhm2Zd30vfs6IUZHmvxJUHnqFEnXAPLs9ZPcgs2yYKpKLo6Dv4P76s=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1777995740;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=4nbNV5fmwMB7R0HMX6HeRrH6CLRcdx02slZvxqPQSRg=;
	b=mtlznHjOEjnMpRNRq+Z/KyCP8ix9avh5ShiGuSwSK316r2ppkP0TJ0HsZGdq9Pd6
	sZ6haRXxRBtqrXVY9Gjfb8MNlr1lhgI7A9EN3JqUoM6kWSWkbhM1l1ZzlOuuRSvRzaS
	X9ClPXbCIgMPYv5x9gGsNiv/7JrYlCyYwX0aa3tU=
Received: by mx.zoho.in with SMTPS id 1777995738662117.73405299188585;
	Tue, 5 May 2026 21:12:18 +0530 (IST)
Message-ID: <67c914cc-be1d-4aa2-a6d6-dc26e0d53316@zohomail.in>
Date: Tue, 5 May 2026 21:12:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 0/5] mm/vmalloc: free unused pages on vrealloc()
 shrink
To: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Stat-Signature: z5sdzte3w5fqakz4pj3urakqbxr7am1e
X-Rspamd-Queue-Id: 1C3752000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777995759-931744
X-HE-Meta: U2FsdGVkX18PATdhNOQEfFPbTtcVIKLnVItsFbw+ODsFkaM2W6ezF9pXqGkHtYmz9HtyfJ/a3cdCdQgsgYZ7Usymw4jI7Khp2EyMT66MHXX46697GufLePpsXqvR93WgM3eor59IJfvsnBbogNhM/V/R9qecyowqU4Wxi44k9LMmb3kexuQyc/qUcFDoc0GsrBb/6A5zWD4/0uFlXXmpvuU8neYqndiog9Z7eTk0viMs5G16hadvzQvHepugjs+c7hRH8c9c8f60YwQPsVwqeQQV6krBJZco54I9wt2dADIqZjgrbbd+IEOLgyrEgJ77S4tAn2PBKEXniXDb7v6b4+8eK+w5GvZTQf8U1GJQTAnluZQ+K/TQmU/4F3H2g7rsB6QsbCiR3G3zHrEAMUa0rbg+Sonk4QT+Ah0wgU6QcTetf64u3Ot7s9CboGQfp+CAdexzOzaOJg2IZtJFNWen8+Qb65ZZPyXygjhCS9eBU7yBhkgdAK7o4G9zxx1o7pEENHAMM69OWZb+CeQnk0Qns4SM+A1JtLVBpX/4IGhVwOrBas7tdJROo+dfQgNb4q/6MmcxEbrVi670lNZn1xSd8X3ylRKUbb3DGxRAtFeKtFoUWBoFlFpka5HUZKhTu4TkZuTwGwVqxucWJ+iDptrje5EOF1LpOvESI/R1+GkXY1dZuwnxnkyevJn+2nE4Vqj8LxJ3VXaDUPvY0DvdD3pMpuFQ0bVUdfLws3Hi/dcbQEznKz0adSS67QTnk1wUFdCtZ2TYi+6elQh8srGwKi+EEY+L3RnrAfxQZ7wpkxB/XcD7SC8H5ILrj9js7XRCRsdEyT3XYqm7PQT1OIlekjlZj8vOPC0rd8tjYPPUkdYd+ub425eLbhlTf1SmOEyF37zytqJ35yhfPci1e0GebW90KX/j3zlGK2suuyqLjkSj+hvsBkn51ieSGx2z0jlFVMAF7pyzXtjMSy7OtxzUIXc
 dkas0w8U
 IAP5PThhHCLan7FG8C2IYN1QXvrs0HimohDV59sSaoPsTH9725IvAMNS37pjgQJlGxCw5qceoQCRnGnNFQQEDUhRTQ/AgeZ55TdCJC7jduBCeAGFOY2jxg3bzE/zTkXXvNFVrIrsobZH/CZ5zFry0IfrKsMSWHAGfao5d9i9PsPKV9A8jhDe0TPUvPMMAhPUFwToZm087Ar39JGMskCAOcd2u8ORuUK23HG8OjBQqpySJARGgoRQ0ZoXAwZ8J3gcIJfjXbT1CtlByJ9wIgepi9bahMZotiIk9A0KG+cByN2ykUXmtoSqqsVKDgoX0QyfsAam/TmFymZKVk64f+1sO5p5tohQ9JfA1cGN4KupfmLKaXzw7jt0KX5w6vDBmEzsIQcq8cws3nx2b46FK9vZ0JKvqFtW2F5ywxa5VY8Qm8aqaoS3X7Hkb6arpt2Ep8RdyndRX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28/04/26 01:54, Shivam Kalra via B4 Relay wrote:
> This series implements the TODO in vrealloc() to unmap and free unused
> pages when shrinking across a page boundary.
> 
> Problem:
> When vrealloc() shrinks an allocation, it updates bookkeeping
> (requested_size, KASAN shadow) but does not free the underlying physical
> pages. This wastes memory for the lifetime of the allocation.
> 
> Solution:
> - Patch 1: Extracts a vm_area_free_pages(vm, start_idx, end_idx) helper
>    from vfree() that frees a range of pages with memcg and nr_vmalloc_pages
>    accounting. Freed page pointers are set to NULL to prevent stale
>    references.
> - Patch 2: Update the grow-in-place check in vrealloc() to compare the
>    requested size against the actual physical page count (vm->nr_pages)
>    rather than the virtual area sizes. This is a prerequisite for shrinking.
> - Patch 3: Update vread_iter() to derive the vm area size from
>    vm->nr_pages rather than get_vm_area_size(), which would overestimate
>    the mapped range after a shrink.
> - Patch 4: Uses the helper to free tail pages when vrealloc() shrinks
>    across a page boundary.
> - Patch 5: Adds a vrealloc test case to lib/test_vmalloc that exercises
>    grow-realloc, shrink-across-boundary, shrink-within-page, and
>    grow-in-place paths.
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
> Suggested-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
> Changes in v12:
> - Rewrite vm_area_free_pages() to use free_pages_bulk()
>    following the upstream vfree() refactoring.(Andrew)
> - Drop Reviewed-by tags from Patch 1 due to the rewrite
> - Rebase to latest mm-new
> - Link to v11: https://lore.kernel.org/r/20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in
> 
> Changes in v11:
> - Prepare vread_iter() to use vm->nr_pages instead of
>    get_vm_area_size() (Uladzislau Rezki, Sashiko)
> - Drop (size_t) cast from nr_pages << PAGE_SHIFT (Uladzislau Rezki)
> - Link to v10: https://lore.kernel.org/r/20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in
> 
> Changes in v10:
> - Reorder vm->nr_pages to the beginning (Alice Ryhl)
> - Link to v9: https://lore.kernel.org/r/20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in
> 
> Changes in v9:
> - Remove READ_ONCE, WRITE_ONCE and drop commit
>    about show_numa_info. (Uladzislau Rezki)
> - Update the commit message in Patch 2. (Alice Ryhl)
> - Remove zero newly exposed memory commit.
> - Link to v8: https://lore.kernel.org/r/20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in
> 
> Changes in v8:
> - Strip the KASAN tag from the pointer before addr_to_node()
>    to avoid acquiring the wrong node lock (Sashiko).
> - Rebase to latest mm-new.
> - Link to v7: https://lore.kernel.org/r/20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in
> 
> Changes in v7:
> - Fix NULL pointer dereference in shrink path (Sashiko)
> - Acquire vn->busy.lock when updating vm->nr_pages to synchronize
>    with concurrent readers (Uladzislau Rezki)
> - Use READ_ONCE in vmalloc_dump_obj (Sashiko)
> - Skip shrink path on GFP_NIO or GFP_NOFS. (Sashiko)
> - Fix Overflow issue for large allocations. (Sashiko)
> - Use vrealloc instead of vmalloc in vrealloc test.
> - Link to v6: https://lore.kernel.org/r/20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in
> 
> Changes in v6:
> - Fix VM_USERMAP crash by explicitly bypassing early in the shrink path if the flag is set.(Sashiko)
> - Fix Kmemleak scanner panic by calling kmemleak_free_part() to update tracking on shrink.(Sashiko)
> - Fix /proc/vmallocinfo race condition by protecting vm->nr_pages access with
>    READ_ONCE()/WRITE_ONCE() for concurrent readers.(Sashiko)
> - Fix stale data leak on grow-after-shrink by enforcing mandatory zeroing of the newly exposed memory.(Sashiko)
> - Fix memory leaks in vrealloc_test() by using a temporary pointer to preserve and
>    free the original allocation upon failure.(Sashiko)
> - Rename vmalloc_free_pages parameters from start/end to start_idx/end_idx for better clarity.(Uladzislau Rezki)
> - Link to v5: https://lore.kernel.org/r/20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in
> - Link to Sashiko: https://sashiko.dev/#/patchset/20260317-vmalloc-shrink-v5-0-bbfbf54c5265%40zohomail.in
> 
> Changes in v5:
> - Skip vrealloc shrink for VM_FLUSH_RESET_PERMS (Uladzislau Rezki)
> - Link to v4: https://lore.kernel.org/r/20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in
> 
> Changes in v4:
> - Rename vmalloc_free_pages() to vm_area_free_pages() to align with
>    vm_area_alloc_pages() (Uladzislau Rezki)
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
> Shivam Kalra (5):
>        mm/vmalloc: extract vm_area_free_pages() helper from vfree()
>        mm/vmalloc: use physical page count for vrealloc() grow-in-place check
>        mm/vmalloc: use physical page count in vread_iter()
>        mm/vmalloc: free unused pages on vrealloc() shrink
>        lib/test_vmalloc: add vrealloc test case
> 
>   lib/test_vmalloc.c |  62 +++++++++++++++++++++++++++++++
>   mm/vmalloc.c       | 107 ++++++++++++++++++++++++++++++++++++++++++++++-------
>   2 files changed, 156 insertions(+), 13 deletions(-)
> ---
> base-commit: 4f7b2cc1ad8719d55a8de9675a0aca65cb17c364
> change-id: 20260302-vmalloc-shrink-04b2fa688a14
> 
> Best regards,
Gentle thread bump. Let me know if you have any feedback.

