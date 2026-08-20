Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031CAC5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 23:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFBC46B0095; Thu, 20 Aug 2026 19:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD44B6B009B; Thu, 20 Aug 2026 19:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C112F6B009D; Thu, 20 Aug 2026 19:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0E846B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:49:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21708402C1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:49:13 +0000 (UTC)
X-FDA: 85123291386.25.09C71D1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id DDC2B100005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:49:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q4KjKSBF;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787269751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JNcQ7MTTHeYZ14ekxPsixkY7zdJ/5z/UcNltJT4vVg=;
	b=kGZdN0qM1E8rUONhjdx1Wxj37GFy+CDYjYI620yk/wyBVqKXzEy8IB/V5otD7Muz9zPtVj
	dalZ38rr9UNTMkxgWzxHMnlfkO+YKy5XT4azBb0UXPC1bzm2gAETBHfNYoEeR2uSbt9IpD
	58uyjcwJtDVLnOsu7xIvSUOG0HcwuFY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q4KjKSBF;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787269751;
	b=IKyV6M8XLW7bm+i8Ya0e2GP8tpqSAHx46L1iF15CWuTXKmq2U+id3Rg24nTcRkX8FbHbSg
	4uzu8zG3yDLa+6K8+UvMHGEVsxcMMDq8wsAZybiRBPwx+qlbb2nXcNG3kYtyi3z001ihUd
	AwxcpveQ6JlxzKbDFLSueqxJA0hFgIc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C61D1202C;
	Thu, 20 Aug 2026 16:49:05 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 005DF3F763;
	Thu, 20 Aug 2026 16:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787269749; bh=qRI+KTKFQ4F8nehuAlZqfDb3EpCIwGZwo7/Rl09nujA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q4KjKSBFI8/NvyN+EsqqfoB4bmp9e0hugRMo48Ct5x+oB+AJmMKIH9jvl8Qb8zVms
	 LuflxOTPVM1TCbdscKm+hO676Kjr7oOUHpSXPOEbod6HS+4vev58Ae0mDSckzQPyp6
	 lFwlfW46IFReFS1xtA4EM791DCM5BiNl8XL8Xm5s=
Date: Fri, 21 Aug 2026 00:49:04 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [PATCH 2/2] kselftest: mm: replace usage of /proc/self/smaps for
 check_huge_xxx() helper
Message-ID: <aoeScKGG1SPcwLgb@e129823.arm.com>
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDC2B100005
X-Stat-Signature: 5ouf4rt6mezndretub3ce9eaqo9coboa
X-Rspam-User: 
X-HE-Tag: 1787269750-268983
X-HE-Meta: U2FsdGVkX19/smhGyKb0Kt4zFURWDZtdWyOEFJVF5tyuuDzeOwnw8FF0BmejcV5zyQt8wNmzZ9KA8kbpz1D6HohedeeBUyWBsSiODTjGE1JkddEXkHZTPA0gxqVmNxrlryxANj9AT6Qu3gvhbgv375DgM+2fgcYppihlJ+t26u6QB8CEDuWHMRf2GMkQJffwWySMUXDi7b+EACGzb/9v+sCViyIze2sjAqYYaRjGz6h79t1yuGpf2gDSEclZ3teCvkKd81l/SztjvG8tYJS2NxRdVijfzGL9eYGgpryNiPpDNtH0qt9q+/E6Q/hTZb1DvOr1rbCf3jHFjBB599z9rFHVE+P3i15MK1BX4CZQp14uiELWd6xGGh/DtppigKv2FARDZWyAzHObwTFZ6OsrPEwVKU5Pez8N3VWsahDRTlC0xBf6CXLAquWJVKUX2OSU8kFgv2gx7Facx6WDRIIa5wx2U148AtmVS/uQ3n7QdrJj7Hixx0KM+k7xFL58vFTmbVmboE7OcLinhfhpby93SKtR/G5upyF/15zJ4ToPQBKVGVVZtGfL7DqMjJiepyC0sCf4Shhv1BHZIGYbuVD+fX1dceJPZY+BYrNkwf+9oXj30fTE0UMl71xfQCdxwBZHmiVHkrv6wYql+mWds8QvMO3JKnTQ2YHyL4YzCugeOc8AeacpQvxVQu/DB4j/mSjGXLeE7igw2lsJgJqObn4+SibV1lSWfoBpRmObU7Msbp/bkJv0CAyulkwC3fltPs7fx1F1nYtGe7bG/nrAtkbbQZoHazvkjXFc8N49CPzHc4z/4YlHb1CVGfVuFyUJUcyQv+AabfATNQ/cm8bWf2dsTZMM3wQ5D1bR4Y0znoCnpUD1yNNubrysikPV4LT/v1EjX+1HsPr5FYWf+3KlNi6b7pE8PNQNO1vlvlQ/dP/tSt/P0h1vfgYuWDRj59RgNDxU+yvAHgLadLNyjOBFMzS
 cQ6yKsUt
 kB539W05ew2zekJg+FA0GDV/c9hjwsEobVAvFrGHCIwnKGVB/ueAepxqpD4eWWc1ObQ4dEG+GB55bu1qpg6J9ij26MChBxW9XK6z8+VvtGF+D4rBuuDaH/VR1CGZha27korCa8SzTqhz8n90ROO0uR1bA3IOQWqzjArAYqTOHwQJpYskTYhaMCotzCxTXo6iC2pfnrBorY3N3kAzq4LVgrXGvAk5MUdmVXD8XGFtXOr1quuUvj1U/Q9q4oMMHQPR1er4YQvCyRyt9tnGWGjERj2sMdlTtBAwhnBmUN9J4Z6lLj1pWpw49d2OdQbAdOdU56dSh8cA92BWTLMIHUSstIMAWdCj7c+uwXKoHWEUrGZfnzUOTRd7v7zcftQmjPFevibaXbD1W8dHkZ9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 08:40:16PM +0100, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
> 
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
> 
> This causes split_huge_page_test to fail because the check_huge_xxx()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.
> 
> Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> /proc/self/smaps to detect huge pages and change the meaning of
> check_huge_xxx()'s nr_hpages argument:
> 
>   - nr_hpages > 0: check all of pages in the range are huge page.
>   - nr_hpages < 0: check all of pages in the range are not huge page.
>   - nr_hpages == 0: invalid.
> 
> Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c           |  26 ++---
>  tools/testing/selftests/mm/split_huge_page_test.c |   6 +-
>  tools/testing/selftests/mm/vm_util.c              | 135 ++++++++++++++++++----
>  tools/testing/selftests/mm/vm_util.h              |   1 +
>  4 files changed, 131 insertions(+), 37 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 10e8dedcb087d..2e4665e6d5852 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -533,7 +533,7 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>  	ret = madvise_collapse_retry(p, nr_hpages * hpage_pmd_size);
>  	if (((bool)ret) == expect)
>  		fail("Fail: Bad return value");
> -	else if (!ops->check_huge(p, expect ? nr_hpages : 0))
> +	else if (!ops->check_huge(p, expect ? nr_hpages : -nr_hpages))
>  		fail("Fail: check_huge()");
>  	else
>  		success("OK");
> @@ -545,7 +545,7 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
>  			     struct mem_ops *ops, bool expect)
>  {
>  	/* Sanity check */
> -	if (!ops->check_huge(p, 0))
> +	if (!ops->check_huge(p, -nr_hpages))
>  		ksft_exit_fail_msg("Unexpected huge page\n");
>  	__madvise_collapse(msg, p, nr_hpages, ops, expect);
>  }
> @@ -558,7 +558,7 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
>  	int timeout = 6; /* 3 seconds */
>  
>  	/* Sanity check */
> -	if (!ops->check_huge(p, 0))
> +	if (!ops->check_huge(p, -nr_hpages))
>  		ksft_exit_fail_msg("Unexpected huge page\n");
>  
>  	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
> @@ -605,7 +605,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
>  	if (ops != &__anon_ops)
>  		ops->fault(p, 0, nr_hpages * hpage_pmd_size);
>  
> -	if (ops->check_huge(p, expect ? nr_hpages : 0))
> +	if (ops->check_huge(p, expect ? nr_hpages : -nr_hpages))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -643,7 +643,7 @@ static void alloc_at_fault(void)
>  
>  	madvise(p, page_size, MADV_DONTNEED);
>  	ksft_print_msg("Split huge PMD on MADV_DONTNEED...");
> -	if (check_huge_anon(p, 0, hpage_pmd_size))
> +	if (check_huge_anon(p, -1, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -815,7 +815,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
>  	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
>  	ksft_print_msg("Split huge page leaving single PTE mapping compound page...");
>  	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
> -	if (ops->check_huge(p, 0))
> +	if (ops->check_huge(p, -1))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -836,7 +836,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
>  	ksft_print_msg("Split huge page leaving single PTE page table full of compound pages...");
>  	madvise(p, page_size, MADV_NOHUGEPAGE);
>  	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
> -	if (ops->check_huge(p, 0))
> +	if (ops->check_huge(p, -1))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -903,7 +903,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
>  
>  	ksft_print_msg("Allocate small page...");
>  	ops->fault(p, 0, page_size);
> -	if (ops->check_huge(p, 0))
> +	if (ops->check_huge(p, -1))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -911,7 +911,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
>  	ksft_print_msg("Share small page over fork()...");
>  	if (!fork()) {
>  		/* Do not touch settings on child exit */
> -		if (ops->check_huge(p, 0))
> +		if (ops->check_huge(p, -1))
>  			success("OK");
>  		else
>  			fail("Fail");
> @@ -929,7 +929,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
>  	exit_status = WEXITSTATUS(wstatus);
>  
>  	ksft_print_msg("Check if parent still has small page...");
> -	if (ops->check_huge(p, 0))
> +	if (ops->check_huge(p, -1))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -955,7 +955,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
>  		ksft_print_msg("Split huge page PMD in child process...");
>  		madvise(p, page_size, MADV_NOHUGEPAGE);
>  		madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
> -		if (ops->check_huge(p, 0))
> +		if (ops->check_huge(p, -1))
>  			success("OK");
>  		else
>  			fail("Fail");
> @@ -1003,7 +1003,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  		ksft_print_msg("Trigger CoW on page %d of %d...",
>  				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
>  		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
> -		if (ops->check_huge(p, 0))
> +		if (ops->check_huge(p, -1))
>  			success("OK");
>  		else
>  			fail("Fail");
> @@ -1016,7 +1016,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
>  			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
>  				    page_size);
> -			if (ops->check_huge(p, 0))
> +			if (ops->check_huge(p, -1))
>  				success("OK");
>  			else
>  				fail("Fail");
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 99b45e5518199..4fcd330cf0726 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -314,7 +314,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>  		if (one_page[i] != (char)0)
>  			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>  
> -	if (!check_huge_anon(one_page, 0, pmd_pagesize))
> +	if (!check_huge_anon(one_page, -nr_hpages, pmd_pagesize))
>  		ksft_exit_fail_msg("Still AnonHugePages not split\n");
>  
>  	rss_anon_after = rss_anon();
> @@ -372,7 +372,7 @@ static void split_pmd_thp_to_order(int order)
>  					   (pmd_order + 1)))
>  		ksft_exit_fail_msg("Unexpected THP split\n");
>  
> -	if (!check_huge_anon(one_page, 0, pmd_pagesize))
> +	if (!check_huge_anon(one_page, -4, pmd_pagesize))
>  		ksft_exit_fail_msg("Still AnonHugePages not split\n");
>  
>  	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
> @@ -746,7 +746,7 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
>  		goto out;
>  	}
>  
> -	if (!check_huge_file(addr, 0, pmd_pagesize)) {
> +	if (!check_huge_file(addr, -(fd_size / pmd_pagesize), pmd_pagesize)) {
>  		ksft_print_msg("Still FilePmdMapped not split\n");
>  		err = EXIT_FAILURE;
>  		goto out;
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 311fc5b4513eb..166d5d79289f3 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -14,6 +14,8 @@
>  #define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
>  #define SMAP_FILE_PATH "/proc/self/smaps"
>  #define STATUS_FILE_PATH "/proc/self/status"
> +#define PAGEMAP_FILE_PATH "/proc/self/pagemap"
> +#define KPAGEFLAGS_FILE_PATH "/proc/kpageflags"
>  #define MAX_LINE_LENGTH 500
>  
>  unsigned int __page_size;
> @@ -229,37 +231,128 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
>  	return entry;
>  }
>  
> -bool __check_huge(void *addr, char *pattern, int nr_hpages,
> -		  uint64_t hpage_size)
> -{
> -	char buffer[MAX_LINE_LENGTH];
> -	uint64_t thp = -1;
> -	char *entry;
> -
> -	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
> -	if (!entry)
> -		goto err_out;
> -
> -	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
> -		ksft_exit_fail_msg("Reading smap error\n");
> -
> -err_out:
> -	return thp == (nr_hpages * (hpage_size >> 10));
> -}
> -
>  bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size)
>  {
> -	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> +	int i, pagemap_fd, nr = 0;
> +	uint64_t categories;
> +	bool expect_huge;
> +
> +	if (nr_hpages == 0 || hpage_size == 0)
> +		return false;
> +
> +	if (nr_hpages < 0) {
> +		nr_hpages = -nr_hpages;
> +		expect_huge = false;
> +	} else
> +		expect_huge = true;
> +
> +	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_msg("open pagemap: %s\n", strerror(errno));
> +
> +	for (i = 0; i < nr_hpages; i++, addr += hpage_size) {
> +		categories = pagemap_scan_get_categories(pagemap_fd, addr);
> +		if (!(categories & PAGE_IS_HUGE))
> +			continue;
> +		if (categories & PAGE_IS_FILE)
> +			continue;
> +		nr++;
> +	}
> +
> +	close(pagemap_fd);
> +	return expect_huge ? nr == nr_hpages : nr == 0;
>  }
>  
>  bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size)
>  {
> -	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
> +	int i, pagemap_fd, kpf_fd, nr = 0;
> +	unsigned long pfn;
> +	uint64_t categories, kpf;
> +	bool expect_huge;
> +
> +	if (nr_hpages == 0 || hpage_size == 0)
> +		return false;
> +
> +	if (nr_hpages < 0) {
> +		nr_hpages = -nr_hpages;
> +		expect_huge = false;
> +	} else
> +		expect_huge = true;
> +
> +	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_msg("open pagemap: %s\n", strerror(errno));
> +
> +	kpf_fd = open(KPAGEFLAGS_FILE_PATH, O_RDONLY);
> +	if (kpf_fd < 0)
> +		ksft_exit_fail_msg("open kpageflags: %s\n", strerror(errno));
> +
> +	for (i = 0; i < nr_hpages; i++, addr += hpage_size) {
> +		categories = pagemap_scan_get_categories(pagemap_fd, addr);
> +		pfn = pagemap_get_pfn(pagemap_fd, addr);
> +		if (pfn == -1UL)
> +			continue;
> +		if (pageflags_get(pfn, kpf_fd, &kpf))
> +			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> +		if (!(categories & PAGE_IS_HUGE))
> +			continue;
> +		if (!(categories & PAGE_IS_FILE))
> +			continue;
> +		if (kpf & KPF_SWAPBACKED)
> +			continue;
> +		nr++;
> +	}
> +
> +	close(pagemap_fd);
> +	close(kpf_fd);
> +
> +	return expect_huge ? nr == nr_hpages : nr == 0;
>  }
>  
>  bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
>  {
> -	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
> +	int i, pagemap_fd, kpf_fd, nr = 0;
> +	unsigned long pfn;
> +	uint64_t categories, kpf;
> +	bool expect_huge;
> +
> +	if (nr_hpages == 0 || hpage_size == 0)
> +		return false;
> +
> +	if (nr_hpages < 0) {
> +		nr_hpages = -nr_hpages;
> +		expect_huge = true;
> +	} else
> +		expect_huge = false;
> +

Oops... this part has mistaked compared with other function...
I'll fix later...

-- 
Sincerely,
Yeoreum Yun

