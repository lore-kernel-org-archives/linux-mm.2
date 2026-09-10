Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88734C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33F46B0099; Thu, 10 Sep 2026 07:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC146B009B; Thu, 10 Sep 2026 07:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9FC6B009D; Thu, 10 Sep 2026 07:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70E876B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:25:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FEE5A4A42
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:25:14 +0000 (UTC)
X-FDA: 85197621348.01.A7DB222
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4AB5FC0009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:25:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LWpqWq0C;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aro94YnPxJ+a4FHI6r80gKTu9hvWLl2Qt7MutKRF27A=;
	b=lLgjDMcot8OM5oP8ziL3QlTYxsBK/JVIrjPXV2nCjaHDtwTVI8e6GNPsT4hZzBZelQsKMU
	Amdxf0W5QhK2mG/vrPIsZdae1XeSmmBOc6UwN8l4KgSxxU4eXbzu4th5Mr1fNpmFlIC6dp
	QwviEGt+Gjp0rsYwlahsoM1LugJaHmY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039512;
	b=WVag3LvVS1LWYoVxH14ShPyBLH3/JaySJZZHaBeUJreffcL9qIe+vX5xte3gUQMOeH/R4n
	fdd4CE2W96cE5V3M7nH/UvMpYXgAoSl+HsDh+xXmF8GRzZu8IZHcoWMchwUXWqNCdwHWQo
	HXmX7dEvKezdRJK9yonV5AXf1tEqlZQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LWpqWq0C;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3179153B;
	Thu, 10 Sep 2026 04:25:07 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A06E3F528;
	Thu, 10 Sep 2026 04:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789039511; bh=bUjVsfpDZcgmzBY7GROwv4WXzBSIWvoSj7+OppCPLvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LWpqWq0CrMWof9QLnwbGJYPVmUIlhn1D0Yzrc/G5UkATJmpaYm3u0RxDex0YwMmjx
	 Y1KrMDqWG4txvyHTU0XP4Yh22k5k3dLc0VRguF/0dfVMjCKk1y3nFfahfoL8kaPRZt
	 FL6NAADXiEt0r7gFE2bpjJbM+WnaA0Jw+Xv7xQxg=
Date: Thu, 10 Sep 2026 12:25:06 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <aqKTkkK0wnm6cqpX@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-2-822b810458bc@arm.com>
 <956df69d-8c0a-420f-889e-7df2842605dc@kernel.org>
 <aqKMVUDvN8bBpwVS@e129823.arm.com>
 <1968ed37-3836-44df-a266-9a37219c2f6f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1968ed37-3836-44df-a266-9a37219c2f6f@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 95xjpkrrbmb4rh3xs8axfg7n46g8ygqy
X-Rspamd-Queue-Id: 4AB5FC0009
X-HE-Tag: 1789039512-321304
X-HE-Meta: U2FsdGVkX1/i/Nos+asdx65w8WMURmBaYGw8xKRTKvDUmOCsFeL/zYmUf4hFvdIx7yqqxb9TMXhXPoWeEkmFlqzaFKZfBsI5hKgjxH404fY3mPV8DIb1uKULM3A+SPPlJUkDGHgkt68XxVfy6OoWSuh0M7PKvYJUnPiTLudcoditRv05P821zdZFIqyY020oDrcSgIcvwgNQUmEQl/dtiXdjzrFNFYmgKeIpZnLNlsJCOFBc0sDQHGhoVLqgAa9W4DciP7BXGntOlQ6NL+L6un0KrQPvgPzquMIdEZGKQEaW4jqrR0V8cP8/fd0yL/uKZU8CuoS1eioe6bpR3E3T7fgMjro+RVRWnm7Au2KLu5MtvvgrJH9eMk40zT8btayJqRD6BBGGa6joAvCkXPKcduswftdB/g/prmvq96kNOa4/JWyHfZSDsWQX9jL2E8VjiRa/yma9kNf/b9jRH4txpvehAEblORQp47/wa4fCLKpmas4UKbAIR+S8HJbVBiT8Zene9cCWL+bTqBCzsrUOd7fy9OcD2CpThQQGSxqAya6mIQrnFCPsdvY/SfQ0OPrc938Pwzp/LKpH0n2/XNqmIDfe3EgIwYJt+UUYxtYgF+vTBAU67jh1fDoPn3PSdvNEeythdK0omSSvjysK1B/qtWlajGMdvSLn2Pxh3jkh0K7NFbIGSBifnMVrtLFwI4PBLBzrzO9peb/UZgWEuaYYQrrFp0fLUUhWHo7gIfiM3z1N/VVYi3kh3ATld0tL95b1+PtyDuPHqzCA2FA1/CpmWbuHmJpShDiOk0wrUo/EJCOb+pFXpI+VDjhke0dZzLi9e6LdLotOU89CHLzWY7/HJKn6b8WBAku/sZj356ENjvaf8AZfAYFI0Cp1NlH9lZpu2jKWkWYzhtrADhz4VaQ8bGwFglpTGGGzykDjtRlvcSC+dpWbSlweyIv9/EWSEecdf7F5q7mZRJYG5NV1prB
 rbwGdU0D
 VUzYHRseyMO/bRWuQrZZzdi8/3IRXyobVY8LT7Ugak8w1jl34eOIVREAhT7Wa3ZVZFwATtAihVYSUCzUdjtcVxGR29ApdG1jsontxTg+L638dRHVI5a9u3lsSKI4p+EAetw/6BqApwQH5EM9DkK7C0ZT4868l4dZT0AxZIZM9Lh9+BJLf/4891YjeTWyBHBhtTw7HwwofI/fhDTA99Otr9wtCc1cCF04fJQ1jP6X2ONfAXheeUtb99A7Q2xVkvUaiX9EL/l5w6oR/hHwRIDS7Rue8IrxZxxaeMg4ZXxH5iu8ADuRVU3PPq8FrXRun4UWwIjrL8RyZrGP1PAZwREQUnJ2qztxZD4/kS/PAn2umdaihtq2AW0UHmFLqnSqB5WTqDgFFuWoOBdaXrlvdveg2B/YM5Y//MM84mCNKotLHa4PCmQ7BnFRE9gl3nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 9/10/26 12:54, Yeoreum Yun wrote:
> >> On 9/7/26 10:19, Yeoreum Yun wrote:
> >>> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> >>> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> >>> made by memalign().
> >>>
> >>> The underlying VMA may start at a different address from the aligned
> >>> address returned by memalign(). Furthermore, a subsequent
> >>> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> >>> already set.
> >>>
> >>> This causes split_huge_page_test to fail because the check_huge_xxx()
> >>> helpers incorrectly require the address returned by memalign() to
> >>> match the VMA start address reported in /proc/self/smaps.
> >>>
> >>> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> >>> /proc/kpageflags to detect huge-page mappings and large folios:
> >>>
> >>>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
> >>>      using check_large_folios(), since only the mapping type matters.
> >>>      This identifies PMD-mapped huge pages.
> >>>   2. Otherwise, use check_large_folios() to detect large folios. This
> >>>      covers mTHP cases.
> >>>   3. Check the folio flags according to the type of huge page.
> >>>
> >>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> Suggested-by: Zi Yan <ziy@nvidia.com>
> >>> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> >>> ---
> >>>  tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------------
> >>>  tools/testing/selftests/mm/vm_util.h |   1 +
> >>>  2 files changed, 92 insertions(+), 54 deletions(-)
> >>>
> >>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> >>> index 4821a3563036..dc62ce84e143 100644
> >>
> >> [...]
> >>
> >>>  
> >>> -	if (hpage_size == pmd_pagesize)
> >>> -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> >>> +static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
> >>> +			    enum check_huge_type type)
> >>> +{
> >>> +	const bool file = categories & PAGE_IS_FILE;
> >>> +	const bool swapbacked = kpageflags & KPF_SWAPBACKED;
> >>> +
> >>> +	switch (type) {
> >>> +	case CHECK_HUGE_ANON:
> >>> +		return !file;
> >>> +	case CHECK_HUGE_FILE:
> >>> +		return file && !swapbacked;
> >>> +	case CHECK_HUGE_SHMEM:
> >>> +		return file & swapbacked;
> >>> +	}
> >>
> >> Why do we even need CHECK_HUGE_SHMEM?
> >>
> >> That's really just a legacy thing for using smaps to identify huge pages.
> >>
> >> It's sufficient to identify CHECK_HUGE_FILE if you know that you have shmem mapping.
> >>
> >> You will not arbitrarily have non-shmem folios in a shmem mapping :)
> > 
> > Agree. but there seems the case where discern whethr the mapping is
> > with regular file or shmem like tmpfs -- khugepaged test where using
> > __shmem_ops. So I think it would be better to keep this as-is.
> 
> Let's not add or maintain unnecessary complexity.
> 
> hmem_check_huge can really just become check_huge_file.
> 
> Even file_check_huge can just be simplified.
> 
> There must be a pretty good reason why we'd want to keep this.

Okay. then I'll change the check_huge_shmem() to check_huge_file()
with the separate patch.

-- 
Sincerely,
Yeoreum Yun

