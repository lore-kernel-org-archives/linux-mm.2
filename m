Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098A0ED7B8B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647E56B0095; Tue, 14 Apr 2026 04:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8766B00A1; Tue, 14 Apr 2026 04:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5358E6B00A2; Tue, 14 Apr 2026 04:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 42F0C6B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:39:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFE9EC1C40
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:39:39 +0000 (UTC)
X-FDA: 84656512878.07.A4DDF04
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8093514000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:39:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=L705jrEW;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf09.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776155978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5Rk012L2dJ7+1gZeAFkL3vTlTgiu+pPlPclC75IzbI=;
	b=wll6gKizPrggOnj6knfNgAKPk+NNfmDdkmwpMe+m2Amv3JqGg9NRZXxTly4LbDzL+KOFs8
	zBlQ+lz7Mu3ccyXIYLDYtiMToFbKfYm5FclQs8Tckvm6pDvNw2zeimgALIFSa+WdzmWMb3
	2uFXzlbMFHr55/ioCkijrcenRDHWfDg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776155978; a=rsa-sha256;
	cv=pass;
	b=srvj8dolbJuvKzO4/i7m4OS1pYrfXHYtko+nip4Pee3yK3RRYsU/V2hITK+l8pCtJUAYtT
	dE3DpV/MzAfS3aJr9MuDT/8XFP4CcoCq0v+4j0Gz1mbSE/vYyW1haT3AsD0YPbOc+6CpdA
	J6ruRIIsa+EUb0r1uoGj0eHNqAqPlK8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=L705jrEW;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf09.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=1; a=rsa-sha256; t=1776155953; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=eP9HHrFYaHd8mlRyx3OsjOFPf80zhGlzfm6f19u52wh8qc6SzuzaHjBNxpWSCgXlC+1pJ3vWTEX7/EyeoL6DgZvGuM2Fy3v6kEOhoMMd7z/pjfwlg4XpDkBXVqJMcx8eD75CvO/NtWISKi5G2awsB29zdvoKYBJaI11weykl34w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1776155953; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=X5Rk012L2dJ7+1gZeAFkL3vTlTgiu+pPlPclC75IzbI=; 
	b=N+IuFQJr0Qo4EvIAfBnROvvnkULzF6MfFmCYlYxIbZNX1ZSit0m9VYeBnYJC0uaPrLMXrphCcIU7IlYLVznk8nLGAg1cl6kZt03EajTPYRr0OECNiCp88JnDl90P3S4LxPqV/r8QtInQjOq1/tw7/lffJOa9g2CLHuD71gtb3Ss=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776155953;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=X5Rk012L2dJ7+1gZeAFkL3vTlTgiu+pPlPclC75IzbI=;
	b=L705jrEWWni6TQiIaxh4mTz7H9XR422Zj6Z1OOOjDGfNHsighabp15gPdqktWY/C
	bMtsgAA+4WAHdqpRZa3F4BCyLDOuX7wK7fxEyEkGVbJmxfgDB34Iw47tLMdcoULOePb
	cL8Z6mG5uaifzhK0vAwip46LthPo0xlwxYT9br9U=
Received: by mx.zoho.in with SMTPS id 1776155949879169.65385142536059;
	Tue, 14 Apr 2026 14:09:09 +0530 (IST)
Message-ID: <7d16f260-ffd0-4e45-b66e-9e7f71332466@zohomail.in>
Date: Tue, 14 Apr 2026 14:09:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/4] mm/vmalloc: free unused pages on vrealloc()
 shrink
To: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 8093514000B
X-Stat-Signature: 54mndhicqzm3mmxs3ojyj3xqhq3kkkza
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776155977-521835
X-HE-Meta: U2FsdGVkX19O9zBD5PB5AAtJixrQZjcubwMK1CVy9RsS4tbI5xjKJSEj8pkf0HiFbizqPgy51+Z/kpIS+EqUY9JBbOSQ7UAY2ccOR/D3XM1CpZp1q8VwvFXKtomo8y7QhD6X+FVDbFAs32vM7Zm0VOcAFvF6XYvg1zGzHmpWpkeZ3ne/odYpHx/X1U8Ox6N5WxJGVrjPTdjiBTCg1hGELtuy7xiXFD6dNdO0ha8Ayl9menYHdvhNujM8r76rHW7r+Fyv5CVlLUmEHTz4KIXbcZhP20Jp+tpgwsRDXo+WdJ4+1wfvsJpJ674CxPc+qJrHo0MPP2uussuaUZvKc//TbgXIr9djqZgQ3HlSDIpj8rx8ibIXD3A2mmt2UDZFzQiD/TYqtRtr/IvbmKKy0K7fmx3rw1sTvZ/wJE/Ihbuee3DHd0ZlP+xP8Dd4/ET3T+mfOFd6+ncxzSIn8FEWb8FesxnCf+wFDmk8bunZF2p9S4NhMw5IIzI4llw1icFdvISu8QTTowM4+f2ClFcJVOOIGLA7NtlDyd8OJLwB30Uz+0TGZFFAGS36D1IIfnj32cJlorbxddmdO9BfvvxkVrjrSnLbgWhLf3/oqJdREO5gn6oOQT62Q8RNosqJQ9ladEYsU3VO8pI/Nbk/N9zE3Wriph0YqZA1Wd2CttrOXqEFHsJtvDJ8NUvGfS9rlijHVO9p+qCvupjocrAMUh4juoLxcsv2yBTA1+QStZDEmH+ceHnGxGvPSeDQ02hC7KT/Gb+PD/O/ydUK46tlmYA460t+JeBNr9Ioi4HIb/CmUyFXqmDZ/K5LW+P2IMi4H35SfYpScTsuBMZmDTboYOZHUgPypwD8XBnrRaSOsm9992h/QCpVmsUo+9vW8V1XePfLtehxj/l32zmrWyhJ21sTPgQd8iO0Y/7rJRXKoWokfhgBKseDMt7wNkMPEwXzZOCM2JKBnKgg4frnszzQYw2phuv
 wvDJlLGw
 El2xC3l0xr6Uw4574feaspEcDbS0tKOGyEFCCCoMkCW7eoZyckIVwV1x/su5maWPQ2/lzk3+mFY77HkT1UYb+cjLzddZyBa9Y8B9Nh0FmPl4SHavhtgJmpods1uCILSeOvQGQfdUzoik/8crQlpOQRea1XzPJBO71ylJL5/R7D5Bx9TzB6U2LRpTf6IFEmdq5QQJous8VvaWK+jQ2TRdN8SDIP9ySNOTaPVdHtYofJTS5WyZ72U9NG7ER/VcyEOFJfcIFTmNvIW5Edlwtoh4c1S7rzxAPLpDbz2pJw7wIVJI42/d+RoG+FfKEsiDSserQLF4zH8Skvo9agW/gGtSOAbwrtxz6qck1/gXdpBdS5OL/Afbq9zQT2hLGa3Pg30bYouaJ8kuTt86Sy1lB72s6J+RjTwMooEG9j9o0fdGyMUH9alp0n8HhVUv3EI+lHeaqzOBT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/04/26 14:06, Shivam Kalra via B4 Relay wrote:
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
>   from vfree() that frees a range of pages with memcg and nr_vmalloc_pages
>   accounting. Freed page pointers are set to NULL to prevent stale
>   references.
> - Patch 2: Update the grow-in-place check in vrealloc() to compare the
>   requested size against the actual physical page count (vm->nr_pages) 
>   rather than the virtual area sizes. This is a prerequisite for shrinking.
> - Patch 3: Uses the helper to free tail pages when vrealloc() shrinks
>   across a page boundary. 
> - Patch 4: Adds a vrealloc test case to lib/test_vmalloc that exercises
>   grow-realloc, shrink-across-boundary, shrink-within-page, and
>   grow-in-place paths.
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
> Changes in v10:
> - Reorder vm->nr_pages to the beginning (Alice Ryhl)
> - Link to v9: https://lore.kernel.org/r/20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in
> 
> Changes in v9:
> - Remove READ_ONCE, WRITE_ONCE and drop commit
>   about show_numa_info. (Uladzislau Rezki)
> - Update the commit message in Patch 2. (Alice Ryhl)
> - Remove zero newly exposed memory commit.
> - Link to v8: https://lore.kernel.org/r/20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in
> 
> Changes in v8:
> - Strip the KASAN tag from the pointer before addr_to_node()
>   to avoid acquiring the wrong node lock (Sashiko).
> - Rebase to latest mm-new.
> - Link to v7: https://lore.kernel.org/r/20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in
> 
> Changes in v7:
> - Fix NULL pointer dereference in shrink path (Sashiko)
> - Acquire vn->busy.lock when updating vm->nr_pages to synchronize 
>   with concurrent readers (Uladzislau Rezki)
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
>   READ_ONCE()/WRITE_ONCE() for concurrent readers.(Sashiko)
> - Fix stale data leak on grow-after-shrink by enforcing mandatory zeroing of the newly exposed memory.(Sashiko)
> - Fix memory leaks in vrealloc_test() by using a temporary pointer to preserve and 
>   free the original allocation upon failure.(Sashiko)
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
> Shivam Kalra (4):
>       mm/vmalloc: extract vm_area_free_pages() helper from vfree()
>       mm/vmalloc: use physical page count for vrealloc() grow-in-place check
>       mm/vmalloc: free unused pages on vrealloc() shrink
>       lib/test_vmalloc: add vrealloc test case
> 
>  lib/test_vmalloc.c |  62 ++++++++++++++++++++++++++++++
>  mm/vmalloc.c       | 111 ++++++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 154 insertions(+), 19 deletions(-)
> ---
> base-commit: b47b4fa4c232ee36aae58630e9d6520e35d33f3a
> change-id: 20260302-vmalloc-shrink-04b2fa688a14
> 
> Best regards,
Hey Ulad, Andrew
A gentle thread bump. Will we include this in this merge window?
Let me know if you have any suggestions, I will resolve them
asap.

