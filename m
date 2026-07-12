Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05A53C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 01:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09286B0092; Sat, 11 Jul 2026 21:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA106B0093; Sat, 11 Jul 2026 21:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0DC6B0095; Sat, 11 Jul 2026 21:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AEB66B0092
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:14:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08A8491B92
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 01:14:30 +0000 (UTC)
X-FDA: 84978354300.18.A0DA0F1
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 07242A0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 01:14:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hEVOCcC5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783818868;
	b=XvdB+SDkiWF5QlZJyhLqgTa6AXiGpT0xhD/fSpoHqImEvsgEb9+tbThTE7SxF+Yga9WUGF
	VYg8CyoA0jZY2TF13hp3fIhr2w5pegrazXvk139SZKTXiQfQp2SOPee7+kwaRciTd2NQr8
	4M4ar/hx7/QSR1ZL9ag5qpQ2FHYzZ2U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hEVOCcC5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783818868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAdjGXolE8bZ9ddc0fiq07hvqt0bNR4iJP1GyPcJcxw=;
	b=W45pA6WMqI62Y7e9HrBcnIG9U7owhP0dU31TqQaqzCHXiOBQdUiUmSDmtAnkMzs38eCG6h
	NqG8MtcLyONVUQbmlf4BQqWHH0dVXLMaWKPQDqADJa6xxFoklPN7QQx5F7qbkh/SRaMRK3
	pMN3LkctJT9wQpP+etmNyD0a4NTWFos=
Message-ID: <88169a4d-157a-4307-8e21-554b122fb411@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783818865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xAdjGXolE8bZ9ddc0fiq07hvqt0bNR4iJP1GyPcJcxw=;
	b=hEVOCcC5p/m7fKRTTlL+957hsqizSlFDzP0U7kz0kjxO2y6Vkr1espBueyl+xR6rd4ZKxj
	+G+rnXvSaRl0IeWXg76dM1iONq3w5TwjRVeMLSUjwEHWkfdKRTtdg2fm7qT4opDapYquP0
	V2jHXAvWyeqWQKdWd18SQtEK3qW/QOU=
Date: Sun, 12 Jul 2026 09:14:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for
 PMD holes
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, usama.anjum@collabora.com, peterx@redhat.com,
 liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, david@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, stable@vger.kernel.org, kernel-team@meta.com
References: <20260709121629.205562-1-kirill@shutemov.name>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260709121629.205562-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 07242A0005
X-Rspam-User: 
X-Stat-Signature: cqusawdn5hoiaggzw3unqfhdn3p3cf4c
X-Rspamd-Server: rspam03
X-HE-Tag: 1783818867-921478
X-HE-Meta: U2FsdGVkX19BSo77xZC7UVt7ChG6WgWGr1QoBK2FtQMZYQSFMqnZewbxxfVA62oOLtRqQJF+RLPJW7J8PwD8Zb/ldYYFHSX3h49wdBFzEDBG72LW2iWMK6qt/43J0b9HkJp02SflAJpmX756PauFAFI53SiNzbybmGJ9rhnok4M/9TKsxwSUsnp6Irr8VKUI5CBVxPuX+GuXz+MOYn7sHKJc3hQP3BD0vyT4DMUy2KWTfHm4qT9C8LSY7TpzgKIG8zxdCDxZH+llO4DFv2txFB5TTId8M1lpjZCuFYeYj01DTd3MTT44XdR5qTCHVlUwTa0zD+75GDrocR6NXBwQcvDBEbsnM8M2fgxE8eHAEm6E3nqxI0gn2SIap66wDUh99pYaLD0aTKKBGsDYqL6LtGh/1LOnRyUl4KoayNiXcg3uwLWjk9sARiP4RlazEXM9gm83ExwSZmGL6+3jjgE7/oBKrJ8uQ6e5wO0oR8AZBrrgmy1ClpZpKC3GnQQ6snkzeJs/A5j+Jdx3u9YnOOdOuD6/dVA4ogK/vP02aFC/OgCV2y2bRvdDlxkpWQgy2FwgOrZMZ5agjLmpWG5zTfZMl/6bndoUyDEg341Rd/nKNorboKt4iiljfeVrMZ+eeW3S4WfHbgvqQgpRQj1F5b/ODgz2PPHbQ/97Z8bzAEOCwhAbeceDDu+fIwKjGSkF1l4Ok/sHJoUPWvuPOiXxenlsDvB5R9aOl0Qec3yQ+7syCtzGUJW/wU8Qrn7R2wcr6ggtolT+ISkxHmW5+jp4S5IInnuzf+pmLTcKQDzUPlmZKd6BwTCGqjNnJaYSEoTx6PNuCC9MpOt7p2z1cXLZR99IQOVd7/svLISHzTUpJdyBBQFZczOOwTJSC2djojjGBBIG+LU+Oh4747hDgtMfLbZuSdaIVYO6qHXSzef5Fgom9Cp7Iivk4ivd5R/qs+DJg1C0ocmMDfD2OBqHbYJ1CZT
 t2h1oYkF
 RrVA8Be703YqvkkRK5N3Fq7JcyrPy9zXJUpW2CUBJQmMDMGSz3pyqcw1LYnaa3o/ujoLE+JqHf4yW33BQWSfQc9pSMY2uI9cFNjhvanQrWV4Ge2UHWeoiwH1btdHn7hu8mPROKZwF13SEs8BPy2KE1T9KoEk1q7/z+VmhN+2N4JSIfirK9bxfI3V+dPfa5AKDh6lancfqA6uPai/nArZSHNphSd5xDFk8X9fDlYOGa8qJeRdN22lySZE+dkZwrZmKYZ47JRXMRuFjp6IaT2GffQNq46X7zO52i/4cFL9MVp2TO9WFY6m6aRaey6bdvlo5yVTZcyU37i3z65KHgzQII8FVvLDdgAbY6ZJPnCpv0cMgLNS0y4Bnvy/nxQh4eBG/h320SpUfWeGncJFX7eivy/9kSXD22TSaVlmRRbpSwZZNCac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl,

On 7/9/26 8:16 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written, but
> a range with no page table at all -- a PMD hole -- is skipped:
> pagemap_scan_pte_hole() tests p->cur_vma_category, which never carries
> PAGE_IS_WRITTEN, so the hole is neither reported nor (under
> PM_SCAN_WP_MATCHING) armed.
> 
> MADV_DONTNEED has fill-with-zeros semantics: it changes the contents of
> the range to zeroes (a subsequent read maps the zero page), which write
> tracking must report as written. An anonymous THP is write-protected in
> place as a huge PMD, so a full-PMD MADV_DONTNEED clears it to pmd_none --
> a hole -- and the zeroing goes unreported. A write-tracking
> checkpoint/migration tool (e.g. CRIU) then treats the range as unchanged
> and keeps its previous contents, so after restore or live migration the
> process reads stale data instead of zeroes -- data corruption.
> 
> Report a hole in a non-hugetlb uffd-wp VMA as written, matching the
> pte_none handling in pagemap_page_category(); the existing
> PM_SCAN_WP_MATCHING path then arms it via uffd_wp_range().
> 
> hugetlb is excluded: pagemap_hugetlb_category() reports an empty hugetlb
> entry (huge_pte_none) as not-written, unlike pagemap_page_category(),
> which reports pte_none as written. pagemap_scan_pte_hole() fires for a
> hugetlb slot only when it has no page table; keeping that not-written
> matches how an allocated-but-empty hugetlb entry reads, so the hole and
> the empty-entry cases agree within the VMA.
> 
> Add a pagemap_ioctl selftest covering the anon-THP PMD-hole case.
> 
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260707151349.92143-1-kirill@shutemov.name
> Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
> Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-fable-5
> ---
> 
> Changes since v2 [1], addressing Andrew's review:
>   - Describe the user-visible effect: MADV_DONTNEED has fill-with-zeros
>     semantics, so the range must be reported written; otherwise a
>     checkpoint/migration tool (CRIU) keeps stale data and the process
>     reads corrupted contents after restore. Add Reported-by/Closes.
>   - Reword the hugetlb carve-out to rest on the category functions:
>     pagemap_hugetlb_category() reads an empty hugetlb entry as
>     not-written, unlike pagemap_page_category().
>   - Drop the redundant MADV_COLLAPSE fallback #define; it is in
>     <asm-generic/mman-common.h> and used directly by other mm selftests.

I hit the following compilation error on mm-new:

[root@localhost mm]# make
  CC       pagemap_ioctl
pagemap_ioctl.c: In function 'unpopulated_thp_hole_test':
pagemap_ioctl.c:1130:31: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
 1130 |  if (madvise(mem, hpage_size, MADV_COLLAPSE) ||
      |                               ^~~~~~~~~~~~~
      |                               MADV_COLD
pagemap_ioctl.c:1130:31: note: each undeclared identifier is reported only once for each function it appears in
make: *** [../lib.mk:225: /root/code/mm/tools/testing/selftests/mm/pagemap_ioctl] Error 1

Could you consider addressing it like fd5295afae91 ("selftests/mm:
hmm-tests: include linux/mman.h to access MADV_COLLAPSE")?

Thanks,
Zenghui

