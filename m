Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C281C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529546B008C; Wed,  8 Jul 2026 23:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D98D6B0092; Wed,  8 Jul 2026 23:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418776B0093; Wed,  8 Jul 2026 23:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6706B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:08:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54654C1D97
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:08:48 +0000 (UTC)
X-FDA: 84967755936.08.F03890F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7BDE5C0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:08:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vnxP+MdO;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783566526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0C50gLb1Rx6vC8vebMbmFW9FfipWim9v9MXHOz8ZbLA=;
	b=G1wQH8opI1M+1rAYhD58ykdY6egjGCtcRMv21AZFa0i2c7coQnhQKq1GG+9nfFPDLGFfe4
	UMjDNcf0y8zek+4ikIUXkna2XBb+9PpzGtXJrylST9r0KuIhZMl0dXi5j25YZQ91YjM+fy
	Ayse+6h1/Qu9jECOx1rZiBhuh/4Fbdk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783566526;
	b=GLJEZ9lWEVlWVjjdusglynTabN7FMgaxxSsDnXeBlSWRxNxrWCb2iiSzv1ZgjzmBdnvVm9
	TF91DaeFjlcSDgopMh8YnFMdIj52SUTtnM0/F1KqHu6cewVfuefJv1h2JMSJAjnDPUFQtv
	nJZOCT5dNEjwsfuQ+5r0dzySB67Olbk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vnxP+MdO;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76A6F42B0E;
	Thu,  9 Jul 2026 03:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ADE1F000E9;
	Thu,  9 Jul 2026 03:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783566525;
	bh=0C50gLb1Rx6vC8vebMbmFW9FfipWim9v9MXHOz8ZbLA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vnxP+MdOVlsjmHdBRs/H3ZPG+GDpJbCcjRF7ezT70sAgYv93ijEZxuZWrm8S0+ANX
	 FbaMuA0+VH2nxPVMoyyzfLg/UhgWU/OdctHjIpZ8t33pWjwEQCCd/zM6pj/e7oilT3
	 ZKTtxEKk3Nem7wh4ixtq6Uc8ZA7wIn8oc7jimZo8=
Date: Wed, 8 Jul 2026 20:08:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: usama.anjum@collabora.com, peterx@redhat.com, liam@infradead.org,
 ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 david@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for
 PMD holes
Message-Id: <20260708200844.09b42937d19bf733849d2886@linux-foundation.org>
In-Reply-To: <20260708103429.150655-1-kirill@shutemov.name>
References: <20260708103429.150655-1-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7BDE5C0003
X-Stat-Signature: mbewbrkyqccgyzbpbc8q3wru9h1z5omc
X-HE-Tag: 1783566526-646371
X-HE-Meta: U2FsdGVkX1/srdsrx1czYdXIhTLYjQZDjAFNfmDeGBU+lOQvficzXfmalCAtiAdkY6kSM6k8PWsK6ol5yRFVFN0SYLwKx+JeLyvwAo3d+iDUJTWKfJ2vV8Z9Y00Nc/wlirdhTmUN3dbXvR1DfYjEU2cO9Tgk3r2l64OJtXFDaL3nBDY8A7bOFCekYXyqXpqub7rx8jOLrs7SmyXj6q0zgvhfh5XbgSCzY7JNAiemhfjp+kzc/uSfXHUJV2ZUwFqfvR0bMNxdTaxpvFSTVMVBYQfp32YtcJEwOVwvL5btmXB/zAnH/FQphOrcFCe9qqSZ0CV8oSsjgcs+sJdjrqomKGWp9DYeYaWNsI9lL+PVW0IR+Yroa2AIyzKOpmTt1+5NdNUZcL7TXnfQbJ5AiCurjSRY1H9CHjNHW7e3n+j3F3OcmNMvUfL+a8GiZA3j1qiAtSdousgAoergiclGChKA/GJCKY9DC+PGCwCiAlWbFd20usW5bQ2rfHhj2UJWpTyWAHh/eFTeTRbLFQdM9gVHGYhKBtrtHq7/JMwQl7TrHc0OJTmbFnH+JXB6VcNbsT3+hPnrmtx0WKNnGRqQe5or7jxwTOHhnoT3URe0tFcC7yBQiOsxlkoKG8rbAq+9ERUbXBCZnSjC38rV3schCnq7q5WUTGoS653Mml4sF9FdokXXrq2jQr8ou1OU5ThtAZCS28aRuOiKRs5Q1ptv7r4mWflHa4qKC/xJ/J0y1P5J6V9BYVCcTUI0tyio4W29yXeuiy75vlK1v4T5AWXPxW16EloxmyE5loZE1zj69OI4yNt5qBy2grC16W1BTYvUz1BW/PZpAiyx1CD55Se0ERoFWDj3B5kMwam/jFVsqVXTTsHyiKm9DtF7Hlj2qt3hvjsj++X6iTtdKEmkHnoaQJpvzjTHlKgSL5vl4/8VVkkSptZixRzfIcJ3wridd2pZC5sqEzb0Va3LKAmL+08DQd9
 F4V2Mt6P
 vY9wcZ+9VIwcrFVylSIEoqNEIlMTuGM4pCBaTq9sJqbqQj2relJFMWGRl4AnLLxnZ8oULeIt8qcAe1CU/MKHOui7en1xZRpuFCuHmXJe1dQ85fQed9RjP/X52VIAEs4qm8HbHhL8Uv7mo13I42XTTZLKOYsQ9QntyBAyBu2KIz5IddfXB0tx5ULyXBd57sDaGeX3en9rAb9N9k/oOjgv9RdsI4/ZTAprOD+ptTOFMmW3iF7e21lqG8Tmmlb+Eo9pg7AMoSQxcMt0pbBIK85VuZeaLwU+gz+pdXUOJvZFcwRI8Z7OjlWeCGI0JkNvG7giIkVnL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 11:34:29 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written
> (pagemap_page_category() and the PAGE_IS_WRITTEN fast path), but a range
> with no page table at all -- a PMD hole -- is skipped.
> pagemap_scan_pte_hole() evaluates the hole against p->cur_vma_category,
> which pagemap_scan_test_walk() builds from only PAGE_IS_WPALLOWED and
> PAGE_IS_SOFT_DIRTY, so PAGE_IS_WRITTEN is never set: the hole is neither
> reported nor, under PM_SCAN_WP_MATCHING, armed.
> 
> This is reachable. An anonymous THP is write-protected in place as a huge
> PMD (change_huge_pmd(), anon is not split), and a full-PMD MADV_DONTNEED
> clears it to pmd_none. A WP-async consumer such as CRIU then misses the
> 2MB drop -- the range is not reported written and the next incremental
> dump keeps stale data. (A file/shmem THP is split on write-protect, so a
> later DONTNEED leaves a populated page table of pte_none entries, which
> are already reported; only anon THP reaches the hole path.)
> 
> Add PAGE_IS_WRITTEN to the categories evaluated for a hole in a
> non-hugetlb uffd-wp VMA, matching the pte_none handling in
> pagemap_page_category(). The existing PM_SCAN_WP_MATCHING path then also
> arms the range: uffd_wp_range() allocates the page table and installs
> markers under WP_UNPOPULATED, so the next scan sees it clean until
> re-written.
> 
> hugetlb is excluded on purpose: an allocated-but-empty huge entry reads
> as not-written via pagemap_hugetlb_category(), so reporting an
> unallocated hugetlb hole (which also reaches this path) as written would
> be inconsistent within the same VMA. hugetlb hole handling is left as-is.
> 
> Add a pagemap_ioctl selftest that forms an anon THP, drops it with
> MADV_DONTNEED and checks the resulting PMD hole is reported written.

hoo boy, that was heavy going.

> Assisted-by: Claude:claude-fable-5

OK ;)

But what do our users see?  afaict the result of the bug is "the next
incremental CRIU dump keeps stale data".  Why is this a problem?  How
would operators look at a user bug report and figure out that this
patch will address it?  Is there some Reported-by/Closes?

In other words, (please train Claude to) always describe the userspace
visible effects of a bug when fixing it.

>
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -25,6 +25,10 @@
>  #include "kselftest.h"
>  #include "hugepage_settings.h"
>  
> +#ifndef MADV_COLLAPSE
> +#define MADV_COLLAPSE 25
> +#endif

Why would this be undefined?  It's right there in mman-common.h?

> +/*
> + * A 2MB anon THP dropped with MADV_DONTNEED leaves a pmd_none hole with no
> + * page table, which pagemap_page_category() never sees. PAGEMAP_SCAN must
> + * still report it as written on a uffd-wp VMA, via pagemap_scan_pte_hole().
> + */
> +static void unpopulated_thp_hole_test(void)
> +{
> +	long npages, written = 0, ret, i;
> +	struct page_region regions[16];
> +	char *area, *mem;
> +
> +	if (!hpage_size) {
> +		ksft_test_result_skip("%s THP not supported\n", __func__);
> +		return;
> +	}
> +	npages = hpage_size / page_size;
> +
> +	/* Get a PMD-aligned range so the range can be a single THP. */
> +	area = mmap(NULL, 2 * hpage_size, PROT_READ | PROT_WRITE,
> +		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (area == MAP_FAILED)
> +		ksft_exit_fail_msg("%s mmap failed\n", __func__);
> +	mem = (char *)(((unsigned long)area + hpage_size - 1) & ~(hpage_size - 1));

Do selftests not have ALIGN and friends?  Seems not, given how many of
them have own implementations.

> +
> +	memset(mem, 1, hpage_size);
> +	if (madvise(mem, hpage_size, MADV_COLLAPSE) ||
> +	    !check_huge_anon(mem, 1, hpage_size)) {
> +		ksft_test_result_skip("%s could not form a THP\n", __func__);
> +		munmap(area, 2 * hpage_size);
> +		return;
> +	}
>
> ...
>

