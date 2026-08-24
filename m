Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A2EC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEB56B0099; Mon, 24 Aug 2026 05:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6306B009B; Mon, 24 Aug 2026 05:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EBDB6B009D; Mon, 24 Aug 2026 05:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B18F6B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:20:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0949C046D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:20:17 +0000 (UTC)
X-FDA: 85135616874.18.EBC7E88
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id C586E80005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:20:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="e1eo9w/4";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787563216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2rFnSyMAfWtWk91TZ9MJ+BN1HL3zHupITrbUPcftMs=;
	b=TOSzLZlyR1DNc+C0tQgb3hf1d1+kb0wmInhA17D7GaORdCt6GPGxzA51PtD1FBv7cZtFFY
	YDuo6x3rrAxf1pw7h4JrP3MXXoCzO9XiWPchOmZP9ts4utU5wlXbceuOHCX43QpSXRt0IU
	QtZvxDPLvlg/+qQB+egF0BoFfPKtA/g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="e1eo9w/4";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787563216;
	b=ATpLz+rzM1hGxyBvca8XYAKMmH7BLVr15HmEt//UL8VhZhLTx9h1xdZomqOijL2LK6N9fO
	qPSEYoQb3QMtFqBXE0972hEI+7sUtphNWeUzGlqcwivxZaMGZDzjCtkAmB7vQG6BzxoRcl
	hHNN3C5SZbL0qU9kzoyQE642fH5lWe0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B333E1682;
	Mon, 24 Aug 2026 02:20:10 -0700 (PDT)
Received: from [10.164.19.33] (unknown [10.164.19.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48C8B3F66F;
	Mon, 24 Aug 2026 02:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787563214; bh=Rvtrha3WTwJfTW7AGl4KCnnuSmmFePp1BK56VobH9xE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e1eo9w/4F3aeUbP3ylOLqmXreb1gqC5tm96XNjAdlcRRSjG12eqVCqr3IJnEbgJBj
	 zpqIXpj9Frupixb9kRecyrH22PZUEnc5PVqJ3almuz0qWkOKQqxnSuLmKAYYEYVveq
	 fuZWLqK8DRJc3Yn3nCJu/7Cp3uvr/WhmOfajoEPQ=
Message-ID: <fcf8ad92-0617-4bf5-a94b-ba06c20581c3@arm.com>
Date: Mon, 24 Aug 2026 14:50:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] kselftest: mm: replace usage of /proc/self/smaps for
 check_huge_xxx() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C586E80005
X-Stat-Signature: c4mmzh1auanmbs66p85win6ywgqugrd9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787563215-988512
X-HE-Meta: U2FsdGVkX19TTkonbYMrDSbNOcsxtlQp3dm9C8HDsaSSwpS/MbrfmzyefSqbsmY8c24sRXIQweCvrecttttEgR+yT6vnp3UVTYWTzj3bCi6sGT+bJ57Zbk8/q8ryxybh5Ly3CNxKSfV4BgC2D0RHdgOkuXZLUE++NJxtSobnnz6Z1SYoSU/FBjVNUPQZKRqtSOeGoUagVm0FyYYEN8WeBrMVrgdGZXF79ZGYCoaReWJA6fNuQuLpRWC8k13LzV5mIc9WL4LD+727ksIlihibqmOT+dndvCEh0fcAhT69mYQZTPI2s/go94QSWmAifYpeYnLHvOG54qGhNzQPFurpbdK+DMBUyF1py0Zsag1CVb5uTfBLuHZYPqk+VcqaLKn1Bmks9yBKMQD/b6qQRzAlzQ2gB7VhK/gC6EUvM271l5kthwvms52fG5ZRj11mm/2x4cMRonl+4PZ26DgPxp3QHt8tA8A2ETrd/DJH6jD9EM/1acFLcOMAE70qb4zW+G5V65+tR6Q7Z29lPOLXZ/6miwDkAgD5/toIh/kvjWMgAGd9IQrI35cNG/AcNpT2nZI8wQf00fP02+ZaXEVEKODcIR0nHqw1CCoX+jatg3jrOpkwbViFmYDb7mfDZf8DXKanjRV2jQCAFgW9OSFPWpheSlUnUVhp6uYGqtWkwhmAQTf0uamM9U1KWxR5YEOV6lfLnanyzuJIoCz414JvMEySRNWbcxY/tbYlrCVyTHNNztDk8YbgYfqvnVS7uTDxmPcWSD9EbAD6PKn3PypuxHet+UcXBbfUR8V+gHMt4uw7PI4+Av97pYiyC9TX9BBORNb+ZMcOijfFH7gPBJKY5lCUzJHaWj+oVgFd3ZdhBwMcuVz6xozyhSLrV0AdwR3doYh4tIAsiHct3xWFconzfyzKhMxFrn/7g7zsMlk6tT6oCO0kzBTgyH0yKcOiucJy065Sp4C5Y76kp+qiyBKCMB8
 yct0zBzf
 OXt0UGsRhTjKgpa9Exz3S981lrTwdhMDMH01w0AoeeSTPe2me+Rp2GpDNjDM/dL06j3Ik/Wk/70N01nbmWWvLyP9muI5bqTKjmtVOdHt02ZxCvAXdiXKasiMKTfeLOqNNyna/XwSCSJVOWbSDU8zwASa/2s2VY4dwGjt9NwSVXew6FAqrDnpn6l5+3ELXRW4UBBXw9TXORzeidcozNlITBhhAVcAYHcNQrqjZUBZJXdWgzDagZeKxrmX9sOb2glJPXZ9SKLjU+sxo1Yc2MkT1Mi+MeA5qUbhwBFUPV1D5T6I73hbUIUUR+jz3pYpG4hhOIr6MwrDjXLWr9iWZRV92urKGueDpBDdmVzKLivJoePGRuYgBs4jmvelggEL3Sea1UWWXlLcpirQPQn0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/08/26 1:10 am, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
> 
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.

Replying to this because I saw my malloc commit pop up :)

So IIUC the test is dependent on VMA boundaries. Therefore we shouldn't
rely on a glibc function like memalign() which can do anything internally.

I think in this case memalign is using one of the heaps, which reuses
VMAs. Because I would expect mmap() to internally align the VMA start
to 2M, as we handle this as a special case in kernel mmap code.

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
> +		if (!(kpf & KPF_SWAPBACKED))
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
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd)
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index ea8fc8fdf0eb0..0a1627f36efc3 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -18,6 +18,7 @@
>  #define PM_SWAP                       BIT_ULL(62)
>  #define PM_PRESENT                    BIT_ULL(63)
>  
> +#define KPF_SWAPBACKED                BIT_ULL(14)
>  #define KPF_COMPOUND_HEAD             BIT_ULL(15)
>  #define KPF_COMPOUND_TAIL             BIT_ULL(16)
>  #define KPF_HWPOISON                  BIT_ULL(19)
> 


