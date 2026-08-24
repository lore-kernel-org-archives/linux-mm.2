Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F0CC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2880C6B0096; Mon, 24 Aug 2026 05:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25FF96B009D; Mon, 24 Aug 2026 05:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175D66B00A2; Mon, 24 Aug 2026 05:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEB926B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:35:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69308A3637
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:35:39 +0000 (UTC)
X-FDA: 85135655598.26.3F25A94
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4D58F40002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:35:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b9R0KcV8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787564137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B91vgqPvJUP9EKpafa3IzwRpqEmNeNlJJoAtQQAsWcg=;
	b=KRmVbqSlmwlPHdkQm+QgjjYGCNrHvNknEAMHyzGcs+HwVzsls+K8ncx/+xOVZiAYhV8Jev
	dxz/dyHwlggKGpDtvEvX9cwaWhJU7zKHxbWJ9+Lxf5XeB1ER7nVX2O17Iqpw1ajCGU1qSi
	4B5E0lijJZcPUfkO5iteJztmCXgP1zo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b9R0KcV8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787564137;
	b=jpLxfnC6yFSkbJB4USDkwCkUniwUn3LCh5rIvErf2jpcK2bU686gHjFfZAVYS0RDqqdNPX
	1TAa+O/3de3DfKUcvJOXHPwalekixWVXCjg2VZxpAuGNY5OI9e1OnoTaOlA92mxc9oB/VW
	24ddz7wdKzDPLH6cUeMa71u5ewT+YdI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 658D0169C;
	Mon, 24 Aug 2026 02:35:32 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B2643F66F;
	Mon, 24 Aug 2026 02:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787564136; bh=x2XWodpi7c705kOimdSZSK/CELysuaMs/Fe2Jg8/SV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b9R0KcV88ObXNWwaJXvJ/+E1cxsVdf4Lu/wt6+byMfBPZhmfFY5c5ZZdvlbH5ttCT
	 4ERMCTbHqz69qFn/6tyOkOgkah5oPEScb19gJ5oh0FqhIrRgCwumeJSBFxDPORc7Yn
	 cfgERelErZMX6ZRyeobV404gDFiNbhZGO8GRoDZI=
Date: Mon, 24 Aug 2026 10:35:31 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kselftest: mm: replace usage of /proc/self/smaps for
 check_huge_xxx() helper
Message-ID: <aowQY3M1sNYwja7k@e129823.arm.com>
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
 <fcf8ad92-0617-4bf5-a94b-ba06c20581c3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fcf8ad92-0617-4bf5-a94b-ba06c20581c3@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D58F40002
X-Rspamd-Server: rspam07
X-Stat-Signature: hr69o1w94a5z7aztrbk6n6nbdt8gai8m
X-HE-Tag: 1787564137-803525
X-HE-Meta: U2FsdGVkX195hlOQAQO/gO1AI5eXl6VhaLwh9CFrFdZjKtEfa8F5OkXu0sMgCUa/C180ca7whTMVY3XqbMPgrxPT7hzVq+NshfsxybP5+JHePatbz8B2jne6ruRZ1dfSx2TPAHxat7seEsAModlH8Sh1Kw0I3DWrJ3EOjuiLpucv4z8EiZFDniUEz5T0M7ffBA70HUeWVrb5BD/DVluxcysgVd11wPyhETpuyFXIG88ZCCGgmNAJup2iEkxWvKVP6blbAsLHGAPr98sbEEolAy+JDKmiCl3yMnuSbEj4UKwcCzSh/iqWIWMdHdRsdRvLXjcg2sXK7o0fFQ9r9kXrdN5RAXscbmvIFYzb1dn6wPaFIUvowGdU+kgMVzi5d17ceK6SlKRxpgdr+lBgmlesW2huEXg5UVD/Dv+KwfC6cGAKOoj28jBr7uV5TbLIiFHis2divmoLjXGagIeb1n8uswGWgeN77IjSXd8/DFcnX8aw6ksTfmLG3kXOd6A+KwUz2r2+ctoN9/LB5N24dzyrKn0TgCwzGQDNyXkE9HmeNKHaGG5gyRi7wLtI6rajjE8QQp8R3h+FSrfDcIQbGcNj9PB3eD2X+uaEGxKM/YSJkSFzQ0IeRjLn7ODXfS8qHSOLoOfNGyj8LCQjQF1MHrX1WeL6VtrnrF6e2Ta3vZ91RHn8/9L+aWrxInOiDBpmt57LxUxrSAD7h1FuhWgg0aUuXs6KZ2Odi6g7ZvoaiSIAvvSZ74KSQEg+97O4sGjdd++kFJBA9MGSJPvTm9Xsn8sIE8TurUNiQLyF/Ks80iF9KsilIBOXkJ2P4T8FwrnWbwETY/YZuc5PyZRyb3giBqKsZdwYjEemtXubajbp6EUDeDFS6XramvY+DfXJAgBmLlRvfvgMgWY7NO7BDr22oOYhLxlsGfVJl/U+qd7fcYkeZwL8xYO1qBA57aCf9kFtcp7nM5W1OZJMG/YukdyEdSa
 aoNioX7R
 8aQe0fweP904oTyYJXINKqRdBkQrLw0hhmZHop774FaW43YXrFPDTfdMQp1vT0qjoXMNcXBk7qheMSecPG+9S7etJUuvxRM8QPKVCLws0B+IrPrwLM94gqJKsB+HxbT4hO8bpbw5Jqme26hrl7Te6xZZDPYvHKlqZsqmiN7XjMXz0/7LJtBuD6U+KO2IVtzJc6Pd5xTzmXLWzUcVhgd/3gOLgRqcWbZixYuzxAVu2TXutgVniVZiNLGcOQFAfeelyu9VSMkxX9idZLXXGERyQG6PfSzAvgvFodl4ZV/Hb0/0pWzFiCxygX4rTwtmCRgvi8Pz7F+TefGDqK9NeMnwIWoUGBDK0GMP+aymg7q58B6T4EjFSbEfwhOQUwIaN/oYi9t/Swbz3Jf8i4X0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> 
> On 21/08/26 1:10 am, Yeoreum Yun wrote:
> > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > made by memalign().
> > 
> > The underlying VMA may start at a different address from the aligned
> > address returned by memalign(). Furthermore, a subsequent
> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > already set.
> 
> Replying to this because I saw my malloc commit pop up :)
> 
> So IIUC the test is dependent on VMA boundaries. Therefore we shouldn't
> rely on a glibc function like memalign() which can do anything internally.
>
> I think in this case memalign is using one of the heaps, which reuses
> VMAs. Because I would expect mmap() to internally align the VMA start
> to 2M, as we handle this as a special case in kernel mmap code.

I'm not aware of memalign() behavior detail, but It doesn't seems
to resue the VMA area:

 - whlie memalign() (request 8MB):
    mmap(NULL, 10489856, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xed1b4557f000
    madvise(0xed1b4557f000, 10489856, MADV_HUGEPAGE) = 0

 - at split_huge_page_test after memalign() while making THP:
    madvise(0xed1b45600000, 8388608, MADV_HUGEPAGE) = 0

It seems memalign() adds a front padding internally and calls
madvise() with MADV_HUGEPAGE then return aldigned address inside of
memalign() not depends on mmap() behavior.

> 
> > 
> > This causes split_huge_page_test to fail because the check_huge_xxx()
> > helpers incorrectly require the address returned by memalign() to
> > match the VMA start address reported in /proc/self/smaps.
> > 
> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > /proc/self/smaps to detect huge pages and change the meaning of
> > check_huge_xxx()'s nr_hpages argument:
> > 
> >   - nr_hpages > 0: check all of pages in the range are huge page.
> >   - nr_hpages < 0: check all of pages in the range are not huge page.
> >   - nr_hpages == 0: invalid.
> > 
> > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/khugepaged.c           |  26 ++---
> >  tools/testing/selftests/mm/split_huge_page_test.c |   6 +-
> >  tools/testing/selftests/mm/vm_util.c              | 135 ++++++++++++++++++----
> >  tools/testing/selftests/mm/vm_util.h              |   1 +
> >  4 files changed, 131 insertions(+), 37 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> > index 10e8dedcb087d..2e4665e6d5852 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -533,7 +533,7 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
> >  	ret = madvise_collapse_retry(p, nr_hpages * hpage_pmd_size);
> >  	if (((bool)ret) == expect)
> >  		fail("Fail: Bad return value");
> > -	else if (!ops->check_huge(p, expect ? nr_hpages : 0))
> > +	else if (!ops->check_huge(p, expect ? nr_hpages : -nr_hpages))
> >  		fail("Fail: check_huge()");
> >  	else
> >  		success("OK");
> > @@ -545,7 +545,7 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
> >  			     struct mem_ops *ops, bool expect)
> >  {
> >  	/* Sanity check */
> > -	if (!ops->check_huge(p, 0))
> > +	if (!ops->check_huge(p, -nr_hpages))
> >  		ksft_exit_fail_msg("Unexpected huge page\n");
> >  	__madvise_collapse(msg, p, nr_hpages, ops, expect);
> >  }
> > @@ -558,7 +558,7 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
> >  	int timeout = 6; /* 3 seconds */
> >  
> >  	/* Sanity check */
> > -	if (!ops->check_huge(p, 0))
> > +	if (!ops->check_huge(p, -nr_hpages))
> >  		ksft_exit_fail_msg("Unexpected huge page\n");
> >  
> >  	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
> > @@ -605,7 +605,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
> >  	if (ops != &__anon_ops)
> >  		ops->fault(p, 0, nr_hpages * hpage_pmd_size);
> >  
> > -	if (ops->check_huge(p, expect ? nr_hpages : 0))
> > +	if (ops->check_huge(p, expect ? nr_hpages : -nr_hpages))
> >  		success("OK");
> >  	else
> >  		fail("Fail");
> > @@ -643,7 +643,7 @@ static void alloc_at_fault(void)
> >  
> >  	madvise(p, page_size, MADV_DONTNEED);
> >  	ksft_print_msg("Split huge PMD on MADV_DONTNEED...");
> > -	if (check_huge_anon(p, 0, hpage_pmd_size))
> > +	if (check_huge_anon(p, -1, hpage_pmd_size))
> >  		success("OK");
> >  	else
> >  		fail("Fail");
> > @@ -815,7 +815,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
> >  	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
> >  	ksft_print_msg("Split huge page leaving single PTE mapping compound page...");
> >  	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
> > -	if (ops->check_huge(p, 0))
> > +	if (ops->check_huge(p, -1))
> >  		success("OK");
> >  	else
> >  		fail("Fail");
> > @@ -836,7 +836,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
> >  	ksft_print_msg("Split huge page leaving single PTE page table full of compound pages...");
> >  	madvise(p, page_size, MADV_NOHUGEPAGE);
> >  	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
> > -	if (ops->check_huge(p, 0))
> > +	if (ops->check_huge(p, -1))
> >  		success("OK");
> >  	else
> >  		fail("Fail");
> > @@ -903,7 +903,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
> >  
> >  	ksft_print_msg("Allocate small page...");
> >  	ops->fault(p, 0, page_size);
> > -	if (ops->check_huge(p, 0))
> > +	if (ops->check_huge(p, -1))
> >  		success("OK");
> >  	else
> >  		fail("Fail");
> > @@ -911,7 +911,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
> >  	ksft_print_msg("Share small page over fork()...");
> >  	if (!fork()) {
> >  		/* Do not touch settings on child exit */
> > -		if (ops->check_huge(p, 0))
> > +		if (ops->check_huge(p, -1))
> >  			success("OK");
> >  		else
> >  			fail("Fail");
> > @@ -929,7 +929,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
> >  	exit_status = WEXITSTATUS(wstatus);
> >  
> >  	ksft_print_msg("Check if parent still has small page...");
> > -	if (ops->check_huge(p, 0))
> > +	if (ops->check_huge(p, -1))
> >  		success("OK");
> >  	else
> >  		fail("Fail");
> > @@ -955,7 +955,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
> >  		ksft_print_msg("Split huge page PMD in child process...");
> >  		madvise(p, page_size, MADV_NOHUGEPAGE);
> >  		madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
> > -		if (ops->check_huge(p, 0))
> > +		if (ops->check_huge(p, -1))
> >  			success("OK");
> >  		else
> >  			fail("Fail");
> > @@ -1003,7 +1003,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
> >  		ksft_print_msg("Trigger CoW on page %d of %d...",
> >  				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
> >  		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
> > -		if (ops->check_huge(p, 0))
> > +		if (ops->check_huge(p, -1))
> >  			success("OK");
> >  		else
> >  			fail("Fail");
> > @@ -1016,7 +1016,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
> >  			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
> >  			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
> >  				    page_size);
> > -			if (ops->check_huge(p, 0))
> > +			if (ops->check_huge(p, -1))
> >  				success("OK");
> >  			else
> >  				fail("Fail");
> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> > index 99b45e5518199..4fcd330cf0726 100644
> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > @@ -314,7 +314,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
> >  		if (one_page[i] != (char)0)
> >  			ksft_exit_fail_msg("%ld byte corrupted\n", i);
> >  
> > -	if (!check_huge_anon(one_page, 0, pmd_pagesize))
> > +	if (!check_huge_anon(one_page, -nr_hpages, pmd_pagesize))
> >  		ksft_exit_fail_msg("Still AnonHugePages not split\n");
> >  
> >  	rss_anon_after = rss_anon();
> > @@ -372,7 +372,7 @@ static void split_pmd_thp_to_order(int order)
> >  					   (pmd_order + 1)))
> >  		ksft_exit_fail_msg("Unexpected THP split\n");
> >  
> > -	if (!check_huge_anon(one_page, 0, pmd_pagesize))
> > +	if (!check_huge_anon(one_page, -4, pmd_pagesize))
> >  		ksft_exit_fail_msg("Still AnonHugePages not split\n");
> >  
> >  	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
> > @@ -746,7 +746,7 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
> >  		goto out;
> >  	}
> >  
> > -	if (!check_huge_file(addr, 0, pmd_pagesize)) {
> > +	if (!check_huge_file(addr, -(fd_size / pmd_pagesize), pmd_pagesize)) {
> >  		ksft_print_msg("Still FilePmdMapped not split\n");
> >  		err = EXIT_FAILURE;
> >  		goto out;
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index 311fc5b4513eb..166d5d79289f3 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -14,6 +14,8 @@
> >  #define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
> >  #define SMAP_FILE_PATH "/proc/self/smaps"
> >  #define STATUS_FILE_PATH "/proc/self/status"
> > +#define PAGEMAP_FILE_PATH "/proc/self/pagemap"
> > +#define KPAGEFLAGS_FILE_PATH "/proc/kpageflags"
> >  #define MAX_LINE_LENGTH 500
> >  
> >  unsigned int __page_size;
> > @@ -229,37 +231,128 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
> >  	return entry;
> >  }
> >  
> > -bool __check_huge(void *addr, char *pattern, int nr_hpages,
> > -		  uint64_t hpage_size)
> > -{
> > -	char buffer[MAX_LINE_LENGTH];
> > -	uint64_t thp = -1;
> > -	char *entry;
> > -
> > -	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
> > -	if (!entry)
> > -		goto err_out;
> > -
> > -	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
> > -		ksft_exit_fail_msg("Reading smap error\n");
> > -
> > -err_out:
> > -	return thp == (nr_hpages * (hpage_size >> 10));
> > -}
> > -
> >  bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size)
> >  {
> > -	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> > +	int i, pagemap_fd, nr = 0;
> > +	uint64_t categories;
> > +	bool expect_huge;
> > +
> > +	if (nr_hpages == 0 || hpage_size == 0)
> > +		return false;
> > +
> > +	if (nr_hpages < 0) {
> > +		nr_hpages = -nr_hpages;
> > +		expect_huge = false;
> > +	} else
> > +		expect_huge = true;
> > +
> > +	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
> > +	if (pagemap_fd < 0)
> > +		ksft_exit_fail_msg("open pagemap: %s\n", strerror(errno));
> > +
> > +	for (i = 0; i < nr_hpages; i++, addr += hpage_size) {
> > +		categories = pagemap_scan_get_categories(pagemap_fd, addr);
> > +		if (!(categories & PAGE_IS_HUGE))
> > +			continue;
> > +		if (categories & PAGE_IS_FILE)
> > +			continue;
> > +		nr++;
> > +	}
> > +
> > +	close(pagemap_fd);
> > +	return expect_huge ? nr == nr_hpages : nr == 0;
> >  }
> >  
> >  bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size)
> >  {
> > -	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
> > +	int i, pagemap_fd, kpf_fd, nr = 0;
> > +	unsigned long pfn;
> > +	uint64_t categories, kpf;
> > +	bool expect_huge;
> > +
> > +	if (nr_hpages == 0 || hpage_size == 0)
> > +		return false;
> > +
> > +	if (nr_hpages < 0) {
> > +		nr_hpages = -nr_hpages;
> > +		expect_huge = false;
> > +	} else
> > +		expect_huge = true;
> > +
> > +	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
> > +	if (pagemap_fd < 0)
> > +		ksft_exit_fail_msg("open pagemap: %s\n", strerror(errno));
> > +
> > +	kpf_fd = open(KPAGEFLAGS_FILE_PATH, O_RDONLY);
> > +	if (kpf_fd < 0)
> > +		ksft_exit_fail_msg("open kpageflags: %s\n", strerror(errno));
> > +
> > +	for (i = 0; i < nr_hpages; i++, addr += hpage_size) {
> > +		categories = pagemap_scan_get_categories(pagemap_fd, addr);
> > +		pfn = pagemap_get_pfn(pagemap_fd, addr);
> > +		if (pfn == -1UL)
> > +			continue;
> > +		if (pageflags_get(pfn, kpf_fd, &kpf))
> > +			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> > +		if (!(categories & PAGE_IS_HUGE))
> > +			continue;
> > +		if (!(categories & PAGE_IS_FILE))
> > +			continue;
> > +		if (kpf & KPF_SWAPBACKED)
> > +			continue;
> > +		nr++;
> > +	}
> > +
> > +	close(pagemap_fd);
> > +	close(kpf_fd);
> > +
> > +	return expect_huge ? nr == nr_hpages : nr == 0;
> >  }
> >  
> >  bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
> >  {
> > -	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
> > +	int i, pagemap_fd, kpf_fd, nr = 0;
> > +	unsigned long pfn;
> > +	uint64_t categories, kpf;
> > +	bool expect_huge;
> > +
> > +	if (nr_hpages == 0 || hpage_size == 0)
> > +		return false;
> > +
> > +	if (nr_hpages < 0) {
> > +		nr_hpages = -nr_hpages;
> > +		expect_huge = true;
> > +	} else
> > +		expect_huge = false;
> > +
> > +	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
> > +	if (pagemap_fd < 0)
> > +		ksft_exit_fail_msg("open pagemap: %s\n", strerror(errno));
> > +
> > +	kpf_fd = open(KPAGEFLAGS_FILE_PATH, O_RDONLY);
> > +	if (kpf_fd < 0)
> > +		ksft_exit_fail_msg("open kpageflags: %s\n", strerror(errno));
> > +
> > +	for (i = 0; i < nr_hpages; i++, addr += hpage_size) {
> > +		categories = pagemap_scan_get_categories(pagemap_fd, addr);
> > +		pfn = pagemap_get_pfn(pagemap_fd, addr);
> > +		if (pfn == -1UL)
> > +			continue;
> > +		if (pageflags_get(pfn, kpf_fd, &kpf))
> > +			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> > +		if (!(categories & PAGE_IS_HUGE))
> > +			continue;
> > +		if (!(categories & PAGE_IS_FILE))
> > +			continue;
> > +		if (!(kpf & KPF_SWAPBACKED))
> > +			continue;
> > +		nr++;
> > +	}
> > +
> > +	close(pagemap_fd);
> > +	close(kpf_fd);
> > +
> > +	return expect_huge ? nr == nr_hpages : nr == 0;
> >  }
> >  
> >  int64_t allocate_transhuge(void *ptr, int pagemap_fd)
> > diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> > index ea8fc8fdf0eb0..0a1627f36efc3 100644
> > --- a/tools/testing/selftests/mm/vm_util.h
> > +++ b/tools/testing/selftests/mm/vm_util.h
> > @@ -18,6 +18,7 @@
> >  #define PM_SWAP                       BIT_ULL(62)
> >  #define PM_PRESENT                    BIT_ULL(63)
> >  
> > +#define KPF_SWAPBACKED                BIT_ULL(14)
> >  #define KPF_COMPOUND_HEAD             BIT_ULL(15)
> >  #define KPF_COMPOUND_TAIL             BIT_ULL(16)
> >  #define KPF_HWPOISON                  BIT_ULL(19)
> > 
> 

-- 
Sincerely,
Yeoreum Yun

