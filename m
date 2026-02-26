Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB7CFC5915
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAABE6B00A0; Thu, 26 Feb 2026 07:08:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58196B00A5; Thu, 26 Feb 2026 07:08:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39B86B00A7; Thu, 26 Feb 2026 07:08:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0AAF6B00A0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:08:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66FFC13C0A3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:08:28 +0000 (UTC)
X-FDA: 84486485496.27.87E6F05
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id 711591C0006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:08:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rSAom9zp;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772107706; a=rsa-sha256;
	cv=none;
	b=ExhLOntROXUwT0ZzyO5WLPzVEmuOpxI6/jQOcfAclmFrxqIktaU523XbU5m93ILopbj3O3
	Ue9PkI9PehBied9fIEfIzKlhbBfmnnkC03nFvzQu/MC7LB8MAy8hKZtWanp9h4zIfWVyLL
	F9hd/xyE6sIrvqblDK1oE15ikfmAnUI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rSAom9zp;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772107706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYnFbktn5kNvK7+95+tEFEolJ2DXBlH5PAziAB0a7h4=;
	b=Rtteigb+JU43bLKzIyl34fgTr3fgOikSK6TLYsKPEJaLK39DRBb9L5nHcxs504nkv+tUSS
	iByajzsGfQoNJqNcjO9Os/KZ0Z/2J1DdKdPM9f1ATbmYA9co4BdVVOloUWjx53fMlSCXt5
	ivgXAfeKIziyDXExAdV2DN+63O4N5V4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772107704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYnFbktn5kNvK7+95+tEFEolJ2DXBlH5PAziAB0a7h4=;
	b=rSAom9zpFIPzgT4g+6QDfjBAKbiHRow8q9hLT+3YpYpwU94tRD9ZeDe2yIC8WsoYuaMCZe
	amDkTI2ZnfAzGoyVcCiMnZbOZcSkyZa9MFvsOMhsZ8T73+sYtdJTRzOJ1FD5dvWu0veqVS
	fM+kjrf5sdR5z8/t4SEo00EAG+L+7+s=
From: Usama Arif <usama.arif@linux.dev>
To: Andi Kleen <ak@linux.intel.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Date: Thu, 26 Feb 2026 04:08:16 -0800
Message-ID: <20260226120818.408966-1-usama.arif@linux.dev>
In-Reply-To: <20260225232708.87833-1-ak@linux.intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 711591C0006
X-Stat-Signature: qxh55en9hf93s96da3g41cw1a4br6n9i
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772107706-882401
X-HE-Meta: U2FsdGVkX18GUO1wB7euefWQJtOUZgyTVg+l6hxfHVKkrVF1LbBMuSB1MPAck6OLDWvtWL50I9fpK3I4Ta8zeyDOCkJiyT/keo7WOxS6LmuGlMKLcs5i5YcSG4779vDlS4DUR1e/9EtIw/cfY9KDUk6lOi+9wrV8NEe/R2dJyYlUuYia31yRtsDYK8seOnbAlcEfV6a61FDlSuh7GjeZplgnpkbcA/OAMuGdzsIYHCNbPB7P9kD9jD3kYqjwRtYOpT1Nj7lybaQlcgrUqSShRAFe4swlcSJGcqz42Hz2h7QMjFkqHyd+BgwMxvR+wU9Wqe728xyBoznUeJPZID8OtyJ4Cb51aJW28UFyVjFD6P4SCE2XMqlxzoFNVEH2aGbGoPCeaNxnqJ2ZgWXsyGHRknkMk8bWo143uVbQK/jjYJIAFfeGLLUo6mmFNMTS/3d1FrE4v5NkCpk0C1hsKeW1GbFohxVY1SBAyLbHggoCDeOCY7pdFucGyCPzsmq15m3KfvkDxvTjgBYt/+CCsxeDYkvm649EI9WevYejsB8FwEbjqTzaY3ez9z0d8vDx752BzR1aoxa/volyyS9FRnSO62BhxQ9lDbIlXVIf31ywVxoZtrvxZ3TaO0f+f/4wrKfDYy4hkJZUBV39gXNkqalqt9tK3dBbtBUoKv24oQgXUpqsDKgUd67oxjMPncQiToI6WhtTZdkRxJsSLlebW06MinqyOqwO4lxNsBRrxoR8ed9WwplqZKDJKxG4Y/TnIXwjpofqLjbAYI5jC4pSHSrxEpUbOGfbgaZru3LDFDHDXisIuCwbrLe8QXkHRXOb295F6keYFK94y2H/z57s8kea28mrP7/9FJhh4B3RBEWRd0yB7lDQDsV1WEJfrXmBnnRNpp8FK+Zq/zZJJHKgWH+atvTKOOn53BIr9dGLQbGdXbDf9D/h2wHitK8DBkeH/6aaymyufMNSsZqkCG99trm
 ec+W0nwP
 w+4H84IQwbOsvtpuZnzQ+MDJarGXr2qIacPChxLgqm8KBQB2onv0TeV98qx+a2b7KFn563xy7otgmuFFI3yzb64PntKi689tCIQmPbXfxZU7klPk9IYaH3Z4ic5t4qlA+IWpwRG02ty46MaXNR4AEcHC9me057jLvCTY5QlYuHMF8pg5K6ztGAVW8ZdMOVsJKeTCwhCW+oEe2+xLbKm4cLtLEEPjbPrj4s6Cg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 15:27:08 -0800 Andi Kleen <ak@linux.intel.com> wrote:

> The earlier version of this patch kit wasn't that well received,
> with the main objection being non support for mTHP. This variant
> tracks any mTHP sizes in a VMA and reports them with MMUPageSizeN in smaps,
> with increasing N.  The base page size is still reported w/o a
> number postfix to stay compatible.
> 
> The nice thing is that the patch is actually simpler and more
> straight forward than the THP only variant. Also improved the
> documentation.
> 
> Recently I wasted quite some time debugging why THP didn't work, when it
> was just smaps always reporting the base page size. It has separate
> counts for (non m) THP, but using them is not always obvious.
> I left KernelPageSize alone.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/filesystems/proc.rst |  8 ++++++--
>  fs/proc/task_mmu.c                 | 14 +++++++++++++-
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index b0c0d1b45b99..c5102ef7a2eb 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -452,6 +452,7 @@ Memory Area, or VMA) there is a series of lines such as the following::
>      Size:               1084 kB
>      KernelPageSize:        4 kB
>      MMUPageSize:           4 kB
> +    MMUPageSize2:       2048 kB
>      Rss:                 892 kB
>      Pss:                 374 kB
>      Pss_Dirty:             0 kB
> @@ -476,14 +477,17 @@ Memory Area, or VMA) there is a series of lines such as the following::
>      VmFlags: rd ex mr mw me dw
>  
>  The first of these lines shows the same information as is displayed for
> -the mapping in /proc/PID/maps.  Following lines show the size of the
> +the mapping in /proc/PID/maps (except that there might be more page sizes
> +if the mapping has them)
> +Following lines show the size of the
>  mapping (size); the size of each page allocated when backing a VMA
>  (KernelPageSize), which is usually the same as the size in the page table
>  entries; the page size used by the MMU when backing a VMA (in most cases,
>  the same as KernelPageSize); the amount of the mapping that is currently
>  resident in RAM (RSS); the process's proportional share of this mapping
>  (PSS); and the number of clean and dirty shared and private pages in the
> -mapping.
> +mapping. If the mapping has multiple page size there might be a be multiple
> +numbered MMUPageSize entries.
>  
>  The "proportional set size" (PSS) of a process is the count of pages it has
>  in memory, where each page is divided by the number of processes sharing it.
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e091931d7ca1..8bfd8b13c2ed 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -874,6 +874,7 @@ struct mem_size_stats {
>  	unsigned long shared_hugetlb;
>  	unsigned long private_hugetlb;
>  	unsigned long ksm;
> +	unsigned long compound_orders;
>  	u64 pss;
>  	u64 pss_anon;
>  	u64 pss_file;
> @@ -942,6 +943,9 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
>  	if (young || folio_test_young(folio) || folio_test_referenced(folio))
>  		mss->referenced += size;
>  
> +	mss->compound_orders |=
> +		BIT_ULL(compound ? folio_large_order(folio) : 0);
> +
>  	/*
>  	 * Then accumulate quantities that may depend on sharing, or that may
>  	 * differ page-by-page.
> @@ -1371,6 +1375,7 @@ static int show_smap(struct seq_file *m, void *v)
>  {
>  	struct vm_area_struct *vma = v;
>  	struct mem_size_stats mss = {};
> +	int i, cnt = 0;
>  
>  	smap_gather_stats(vma, &mss, 0);
>  
> @@ -1378,7 +1383,14 @@ static int show_smap(struct seq_file *m, void *v)
>  
>  	SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
>  	SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
> -	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
> +
> +	for_each_set_bit(i, &mss.compound_orders, BITS_PER_LONG) {

Hello Andi!

When a VMA has no resident pages (e.g., freshly mmap'd but not yet
faulted), compound_orders will be zero and the for_each_set_bit loop
will not execute at all. This means no MMUPageSize line is emitted
for that VMA.

Previously, vma_mmu_pagesize() was called unconditionally and always
produced the MMUPageSize field. Userspace tools that parse smaps and
expect MMUPageSize to always be present would break on VMAs with no
resident pages. Should we always add it?

Thanks

> +		if (cnt++ == 0)
> +			SEQ_PUT_DEC(" kB\nMMUPageSize:    ", PAGE_SIZE << i);
> +		else
> +			seq_printf(m, " kB\nMMUPageSize%d:   %8u",
> +					cnt, 1 << (PAGE_SHIFT-10+i));
> +	}
>  	seq_puts(m, " kB\n");
>  
>  	__show_smap(m, &mss, false);
> -- 
> 2.53.0
> 
> 
> 

