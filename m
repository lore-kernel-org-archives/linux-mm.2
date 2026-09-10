Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC7FC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E7E6B009B; Thu, 10 Sep 2026 07:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F216B009D; Thu, 10 Sep 2026 07:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325636B009E; Thu, 10 Sep 2026 07:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CABD6B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACBF1A04E5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:06 +0000 (UTC)
X-FDA: 85197558012.02.A24C8E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2957A000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RBAs3Dyk;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hr7oGdsTn1ApVbMUVv7wZOuEszEEdCdnleGoKRCPC4A=;
	b=DLYhgbdoapfw1vJWHoC4vGGaJPZi4ZZ140FewSaQo/I22rrzHO/g72qMcMjU7+ahjRwg7L
	1cqx1PhsVYlFJcg5JIRSaWFi/XEA9XV752FhU6JtL5zxtKX4YOt/zXjX1KPGNb2iX5ymuY
	aFj4badeBTlv/yUHbEdYO7mkIhilolY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RBAs3Dyk;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038004;
	b=vQ+Ox8UVkPFeP8d0yu/KFwhCM4y08BHPjSzsUmDRiBJlVDcsxeYB0FXJRhZPLLw/K3eL0S
	a7FMbyMReu7I4wKZULAxElKSoqvOa4R+0kyh5AA28YY3HNED1q+qPnw7iKMagPQQqLbQfm
	wcgDh4Xjq8anKYJ2lnIRp/ryPWvjKes=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 004B343FCE;
	Thu, 10 Sep 2026 11:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FF61F00893;
	Thu, 10 Sep 2026 10:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038003;
	bh=Hr7oGdsTn1ApVbMUVv7wZOuEszEEdCdnleGoKRCPC4A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RBAs3DykizAcG6ccbF6gR4FjdvFtoyTxL249sbCZidqesp6sH12kPXM/tt7h3mk5h
	 a7G+BA0Riez4Yz1i+7+NWWHOSDF6NRMPVUmfhaWxQrYwrijylDKKZ6Zf4BHpDXS+dw
	 UAFOcP1gvZZ1LZxxniwWgllm8b2aKj5uFVekfs0QSQt6FbU7GlINbsQgBudFwAKiVn
	 wkMq4PpoloKMGJ0kkVmo7tsy0WVi+I+uWej7sLKehznfsaURRslpTA87qpu/3tBA5G
	 hh4RObF7dmSlftszEMXOL2oEX1bVpvXafwKWXIXWkeIx/IjtR2/P8GyHV4HEWRLA/j
	 2rdKXX6tvmn+Q==
Message-ID: <1968ed37-3836-44df-a266-9a37219c2f6f@kernel.org>
Date: Thu, 10 Sep 2026 12:59:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-2-822b810458bc@arm.com>
 <956df69d-8c0a-420f-889e-7df2842605dc@kernel.org>
 <aqKMVUDvN8bBpwVS@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKMVUDvN8bBpwVS@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D2957A000E
X-Stat-Signature: oxzydijecgr44ido18uwqhsrbqgwtqkf
X-Rspam-User: 
X-HE-Tag: 1789038004-10348
X-HE-Meta: U2FsdGVkX1/A5aBfs65AuGGHb/sEbaMyWkKBhWpKyj+L+id38RiqcciLGt/lNfSB4Nxoa1If04wGFaJc34DFONU/zt6vuy6NmHjJoAfAjBy57otOU6N3bs2fGE6K/9ANf3MMDIZYgTdqocjRSBo4gU/djDFbwbOzQJhJi7fM3IAg0+hnnjC4W8Cd8h7Ak/DbVVcT79VictuvyJS+zjZ4J5x2oNdxLnvIDWY34UewiANZU+ePiQuM527Mh6F1I5CFI1t0K75InrcRDwlaMm+OgCHg8MRvGtzFACB1rndsxyTsgEh9nyV/XVba//vcuONTwwIEOAvDNULu0BgQXJzJqfgnWJo9wjEV/s4qzupU3D8YxAk1SSfS4fUg12S9oUUM1yfcjAzfrVwC0N25o9Bz+8yrmSGLuky05nJ9uv1PzABVaDGyjNf0tbR5TYzmo91udRirBiykYNXJeugjDL37bffmzx68cmN2eAp/oF8Ltl9ObDLUJBxbAzkB5ImHEkaf3ordZMhJti2464cLQoIBjRw7YD9fLTmnSwXSTVtsPiH6nIhBSjJW06PQtN0VX3dcsCumP5B7zaQZ2ytKlsQhgd/y622GP4tcU9gyFbgNRfDgxWHiMWcYUzmxMGrffBc6FNuCyC2MzXruV4NSMFXcUf7HMcErnhFcp3Q2aCw+ZDxYyYMcmyEuRosMqAgIzXDrO5fdUqx3Qb8O6xGSFHG+f/+gPfuGk5QOh1R6AVly+caUpvF7FLvew/HIVTupxdEIXKUBZll0ReubFf1+ptP0MTMrZghMsdvwvj8FdzIy1o3QPeWWxMYdOMgtzH4Gpr1yzyhjc2DoSz/dRSMUFse63woLscEUGOP2BKePqYwfNxHgtSLBsi71UIJNyg/smx8ND4qM+tAxkuYApdaU89uTygwmP7MBgaMyb1H4rGF8G5Hm67fTWNGdvAQ8nsug9q3aU7APYCzk6SsWwnR+zrF
 FBuuF7hO
 Yr29dpSHuSfy9yi/E6ZZVzlxfGLpLXM8ixS52R3ym5j4njz+EYTrZL7FmnGiew/0TakWTSOEVJKhmdOt/CMvWShOdDsTGWivXoyfdfEU+k88HHZzXf91/RtKBJhbu1Zri6TEg1ZLyB24zfXX0jfIamh3n4Vk2GL160VFX9Pc7/3irPGc3WcWPQ+2dYAZbeunROijszyy5aZ9wlBNbOe7IkhOQ1oLz+fOUrMfp92p1kYDNEfg7DxRLosbDBgBXsy+nsMner9Szi3jH1YeX89rHxu8i1W9nSCwWuoLtJp4iYeMGhYVvUHXZPJ8HWiOJxj0qQVWhrcxLyBakcT1/0MhT2YnMM5odhmB9A5pveFf4n8fSFVjvvgJNIwKjq56Im8jj8IcpCyaf6ajSfhe0N12gbYepvwRRr1ci8slpnBAnaV72gMWXfCWZK2XEw92DZUWlTBb5g5y7euUMZi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 12:54, Yeoreum Yun wrote:
>> On 9/7/26 10:19, Yeoreum Yun wrote:
>>> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
>>> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
>>> made by memalign().
>>>
>>> The underlying VMA may start at a different address from the aligned
>>> address returned by memalign(). Furthermore, a subsequent
>>> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
>>> already set.
>>>
>>> This causes split_huge_page_test to fail because the check_huge_xxx()
>>> helpers incorrectly require the address returned by memalign() to
>>> match the VMA start address reported in /proc/self/smaps.
>>>
>>> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
>>> /proc/kpageflags to detect huge-page mappings and large folios:
>>>
>>>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
>>>      using check_large_folios(), since only the mapping type matters.
>>>      This identifies PMD-mapped huge pages.
>>>   2. Otherwise, use check_large_folios() to detect large folios. This
>>>      covers mTHP cases.
>>>   3. Check the folio flags according to the type of huge page.
>>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> ---
>>>  tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------------
>>>  tools/testing/selftests/mm/vm_util.h |   1 +
>>>  2 files changed, 92 insertions(+), 54 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
>>> index 4821a3563036..dc62ce84e143 100644
>>
>> [...]
>>
>>>  
>>> -	if (hpage_size == pmd_pagesize)
>>> -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
>>> +static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
>>> +			    enum check_huge_type type)
>>> +{
>>> +	const bool file = categories & PAGE_IS_FILE;
>>> +	const bool swapbacked = kpageflags & KPF_SWAPBACKED;
>>> +
>>> +	switch (type) {
>>> +	case CHECK_HUGE_ANON:
>>> +		return !file;
>>> +	case CHECK_HUGE_FILE:
>>> +		return file && !swapbacked;
>>> +	case CHECK_HUGE_SHMEM:
>>> +		return file & swapbacked;
>>> +	}
>>
>> Why do we even need CHECK_HUGE_SHMEM?
>>
>> That's really just a legacy thing for using smaps to identify huge pages.
>>
>> It's sufficient to identify CHECK_HUGE_FILE if you know that you have shmem mapping.
>>
>> You will not arbitrarily have non-shmem folios in a shmem mapping :)
> 
> Agree. but there seems the case where discern whethr the mapping is
> with regular file or shmem like tmpfs -- khugepaged test where using
> __shmem_ops. So I think it would be better to keep this as-is.

Let's not add or maintain unnecessary complexity.

hmem_check_huge can really just become check_huge_file.

Even file_check_huge can just be simplified.

There must be a pretty good reason why we'd want to keep this.

-- 
Cheers,

David

