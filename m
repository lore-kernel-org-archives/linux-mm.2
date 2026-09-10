Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B442C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DCE46B009B; Thu, 10 Sep 2026 06:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576376B009D; Thu, 10 Sep 2026 06:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C116B009E; Thu, 10 Sep 2026 06:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24E456B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:21:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BD6914048E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:21:06 +0000 (UTC)
X-FDA: 85197459732.24.09E9C1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA971140007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:21:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiLgP0iU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789035664;
	b=xaC8lMhUIfR2pzjcV1TtlFn/zzxAjRhfDtiqXDkBrtERR08RXguhJmBXSKAAGABwdBPMfG
	BGz6ThbjO2d5jF9cYY8zOCgOmTZBzZv90b/ee+SpgVRND2mz473ZLmj8VmvMrL1t97ZEsQ
	UTmst7LhGMvZTbVW4bOTjFNU25G9+Cc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiLgP0iU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789035664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNqAmjn7vwuecUWun/yj3LWAkYuAP3u7AHtle9TvBmY=;
	b=Owfps+qH6yHtgBUdNLq0lkO28SWtLhaULyZVL1DWegFGKLBrpYoHoioPLulq0IIGzioqNx
	3eH5jA9UbiDI0kZSpIS79q556ryF57bsPF1CmOzHzgBFK2VTAT0j0Pdfc4GP95X8+1I6oM
	M2yALZFCYaA2XzwTvo/yEekclx/mJ6s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B4444023B;
	Thu, 10 Sep 2026 10:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81CA1F00898;
	Thu, 10 Sep 2026 10:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789035663;
	bh=VNqAmjn7vwuecUWun/yj3LWAkYuAP3u7AHtle9TvBmY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XiLgP0iUsnOLzVKKvCt33C/duL0ZjMqv/RyWaXpMwHO+aUoP3TNxa2utHfFlAODHu
	 DmOlmNl6rKZvn1EaUHf0D/ouerBwA1AdWaUok4+mrCeLEf88PbMTDWr6sOzQBi4D17
	 ngQpqWiIp0cCiHPiLsMNKo3NHa7W4e31E+X3Y7yfbi+83u3xxqYBxmJZW39jnuODZj
	 kmCw6xTWUioYw3/CbjSkxdML86R6nAwyJ0EX4DvV718lQTaCFTgAArINxrA4iMPYxp
	 EqUFHNB3AN/f4jNsnaH6S3ZILEK6UbH0GvZrJH86wy7xS7dVO/bDSKQiYRK1Wr4XU0
	 VRoAiXqnr9tEA==
Message-ID: <956df69d-8c0a-420f-889e-7df2842605dc@kernel.org>
Date: Thu, 10 Sep 2026 12:20:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-2-822b810458bc@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-fix_split-v5-2-822b810458bc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA971140007
X-Stat-Signature: hpajyoyt31retg33aqjc8g957yrh457f
X-Rspam-User: 
X-HE-Tag: 1789035664-921660
X-HE-Meta: U2FsdGVkX18QIdCFMD87VsFU3M9CNjwOkm00ZVK/Q4Wa1LhC6jjGhAW573PwLfTrps+GAQMpVFXQAU7/vFXgWExWRyXZHKhC+qYXQMnAC5bkQY9rD+BdckNG6lJI63FPO4DExriVx4eYJXoXyAlSmv9eMSykGSV89RAWwIXKRUoEFTdyAOLvqPo/t9OlmnJd+hYVKv/oiNy+9XnsqA4l3J3v7r5OErg2TdWUTjIwqxIWpHfrtdyUKDL9wNxDrbvwAjbN1qyGyWiiVUNd+O/AUF6AePvi2Jw9ajFzSo3BzfPsdgmjMU7uZg8u/kX4ajBLDMOprF31trLjLxA7jiC63ZeazDtYrBzLeUUZ5eVzhEo3GYRNWA2ng29hWK3jyPQiefnD30IAFer2/jP4XX8JYXzNjp7VKN+Wi+rLjfIxZEejsWwk2Xwza6H3GI9bRDiGiKzAwohogGmLPz+DewdpUM1BGanweoi+FIExvtx9iM6UbASK1lgW8FB6PTHSI8N0g/CZgEP1RHWyeL0C+oRYs8dR3GJsRyMeeWIdH+63OAnbJuhme03B6nU7s9ek9mf+19O/P0gXDGOdH/oYlNPqCdaokWsBMdQsg+spj3g4PTO3Hw6bDAiU+MF8TYFO/qCJ47Wvar6RyLS3gdUMld65CuwzOCbnKjCOUPULv8dOoIKe6B3ksFucY5+KnhNMV9e7ZHzoNAFzzPhq0C2kc/2JsHQ6cBZ9NxwbDfaKyv5qhb21z4qd5a3M8Gw8AGtKZS3wJYeta8hjbKOptst334lpDD0ZC5bgEZtjP7D37p9x2C745wyJZdgrSpx7GS1piWccLD8gnmi9vexfdTR0J0XlWGyh/rFeQ35fK6aRorzZbLWSo4PVzmwzf5jFewbhF7TTzfJGqYmYXu9GIWQuu1iMefNSijlq5YAYWufgwmy7D9XFdDjW5o6pq5YSJ0V31qA+G06FhiQjIcXabKEwBGc
 FQlFnaBv
 oQBknAWfqzLrOWhNkMzrT4Ovg1h3pvMlRH8tfOkMcDWu4Oyhc5NMOZpP2NwyoTwRrwmaN+Hs2S2voeC1yxJ83US7uvbCxw7GD4l1N/0zdCy3wQiL+r2MznvNOK5zcmFzQpmP0ELpDGyYy4ekC1DH3ibFLrOoQE/J12+mwsboVBHcHtTf8Ch4srBqo0/jC8rXy8Ia6/UUHtoeuVVl0pRv7pbOSTqkIfjQ7Yj/fzDkWtC2Z6Ql60REkkRDLiV6qyccZY3G4VtTw97RneQV07SgWIYmyfmyI1VkYtV/JfN5LOOLPYPlDeZ9WxzybJuXJnFGMhGKb3LCRtRfqOiUfO8y/43sMbgY2q0xEY1fHHHdycpmmALT+R9NVBM0aiHXJzd+Sf7v70Srcr0X81VyHIwlawgPrOwocFY+TWF5kpQJsD0KMOceK2UzNKsqK1zq7yBNrGJPmjJuKNyWO3R0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 10:19, Yeoreum Yun wrote:
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
> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> /proc/kpageflags to detect huge-page mappings and large folios:
> 
>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
>      using check_large_folios(), since only the mapping type matters.
>      This identifies PMD-mapped huge pages.
>   2. Otherwise, use check_large_folios() to detect large folios. This
>      covers mTHP cases.
>   3. Check the folio flags according to the type of huge page.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------------
>  tools/testing/selftests/mm/vm_util.h |   1 +
>  2 files changed, 92 insertions(+), 54 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 4821a3563036..dc62ce84e143 100644

[...]

>  
> -	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> +static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
> +			    enum check_huge_type type)
> +{
> +	const bool file = categories & PAGE_IS_FILE;
> +	const bool swapbacked = kpageflags & KPF_SWAPBACKED;
> +
> +	switch (type) {
> +	case CHECK_HUGE_ANON:
> +		return !file;
> +	case CHECK_HUGE_FILE:
> +		return file && !swapbacked;
> +	case CHECK_HUGE_SHMEM:
> +		return file & swapbacked;
> +	}

Why do we even need CHECK_HUGE_SHMEM?

That's really just a legacy thing for using smaps to identify huge pages.

It's sufficient to identify CHECK_HUGE_FILE if you know that you have shmem mapping.

You will not arbitrarily have non-shmem folios in a shmem mapping :)

>  
> -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> +	return false;
>  }
>  
> -bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> +			 uint64_t hpage_size, enum check_huge_type type)
>  {
> -	uint64_t pmd_pagesize = read_pmd_pagesize();
> +	bool ret = false;
> +	int pagemap_fd, kpageflags_fd;
> +	int nr_pmd_mappings = 0;
> +	uint64_t pmd_pagesize, scan_mapping_size;
> +	uint64_t categories, kpf;
> +	unsigned long pfn;
> +	bool check_pmd_mapping, allow_nonpresent;
> +	char *start = addr;
> +	char *end = start + len;
>  
> +	pmd_pagesize = read_pmd_pagesize();
>  	if (!pmd_pagesize)
>  		ksft_exit_fail_msg("reading PMD pagesize failed\n");
>  
> -	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
> +	check_pmd_mapping = (hpage_size == pmd_pagesize);
> +	scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
> +	/* Some mTHP tests check a partially populated PMD-sized range. */
> +	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
>  
> -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_msg("open pagemap fail\n");
> +
> +	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> +	if (kpageflags_fd < 0) {
> +		close(pagemap_fd);

No need to cleanup when exiting.

> +		ksft_exit_fail_msg("open kpageflags fail\n");
> +	}
> +
> +	if (!check_pmd_mapping &&
> +	    !check_large_folios(pagemap_fd, kpageflags_fd,
> +				addr, len, nr_hpages, hpage_size))
> +		goto out;
> +
> +	for (; start < end; start += scan_mapping_size) {
> +		categories = pagemap_scan_get_categories(pagemap_fd, start);
> +		pfn = pagemap_get_pfn(pagemap_fd, start);
> +		if (pfn == -1UL) {
> +			if (!allow_nonpresent)
> +				goto out;
> +			else
> +				continue;
> +		}
> +		if (pageflags_get(pfn, kpageflags_fd, &kpf))
> +			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> +		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
> +			nr_pmd_mappings++;
> +		if (kpf & KPF_COMPOUND_TAIL)
> +			continue;
> +		if (!check_huge_type(categories, kpf, type))
> +			goto out;
> +	}
> +
> +	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
> +		goto out;
> +	ret = true;
> +
> +out:
> +	close(pagemap_fd);
> +	close(kpageflags_fd);
> +	return ret;
>  }



-- 
Cheers,

David

