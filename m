Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9F7D3CCA0
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0E16B0088; Wed, 14 Jan 2026 22:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F676B0089; Wed, 14 Jan 2026 22:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37436B008A; Wed, 14 Jan 2026 22:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A084E6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:10:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFB741601BC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:10:49 +0000 (UTC)
X-FDA: 84332721018.29.ED2B049
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3BEB520005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:10:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XalqSikw;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768446647; a=rsa-sha256;
	cv=none;
	b=HlICRfPFIiOiDdxyNB6EqN+ZJ82YFykyJEQ/sNjSmh365l5g48py4dKkJARPkvmOaX5UTR
	UeQuVSspZEb2732lepysyqPMetIAdZVxdl4+PsyFMJ3iMMkGb8US5wedRciIcHI9Q2RPAX
	VjNPahY6BUWjFqE3OMiO8s5psC03V94=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XalqSikw;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768446647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lsnx8/DDCRGL4BEgtWC1Pon4SOFupiOVWnP7I0pNyLc=;
	b=bvxDn0znICXvEdjZXxmPkEnAbyO9G+27f0BwxvZaKMJYoH9dYLQ5dcZ6FulYWDK1rk1QFN
	2L/TuBPMuAjJHRviA4jw5gphpsGnUeQfaHQZ2fYA3P87jtozslm9aGhylD+5FCw7ApOJjy
	Qk8snZG2dmj1ThV749aVSxn/gkKu1IY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Lsnx8/DDCRGL4BEgtWC1Pon4SOFupiOVWnP7I0pNyLc=;
	b=XalqSikwBozzdrW/q8cJ2pFYDioJif4hmrNPtelzMmzGEnG/hpqZCsIGFvW/J+A9IS8dKWImb
	YshdKG7uqYeD/3p1ChatDI91aTneC0BuEEOKxV4F2NJzPEw/2xkw+4f5Q1JgbByL14mjXcxW4fz
	Jb3LwarthazvHltkds38pQw=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ds7FQ59TRzKmB1;
	Thu, 15 Jan 2026 11:07:22 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 6DC6040562;
	Thu, 15 Jan 2026 11:10:43 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 11:10:43 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 11:10:41 +0800
Subject: Re: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Harry Yoo <harry.yoo@oracle.com>, Jiaqi Yan <jiaqiyan@google.com>
CC: <jackmanb@google.com>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
	<willy@infradead.org>, <nao.horiguchi@gmail.com>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <william.roche@oracle.com>,
	<tony.luck@intel.com>, <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <osalvador@suse.de>, <muchun.song@linux.dev>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>
References: <20260112004923.888429-1-jiaqiyan@google.com>
 <20260112004923.888429-3-jiaqiyan@google.com> <aWXaiWI3v_PJOKDL@hyeyoo>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6615c6e7-720a-2223-00a5-a66b77a612ab@huawei.com>
Date: Thu, 15 Jan 2026 11:10:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aWXaiWI3v_PJOKDL@hyeyoo>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: imfpbzq6xtpizyczfw7obi8xyndom4o9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3BEB520005
X-Rspam-User: 
X-HE-Tag: 1768446646-900414
X-HE-Meta: U2FsdGVkX1/dXLAfrrgiy/7wmDZ9YA7MS4xf6hvjeNRihAC6KTMu1uFB4SDmmMwD4Jj9eP+gEW0r7NwDCq4jZr2UMLA6z6P3ZSaa1rm8A64YQqpA6L5gzOtPc1qS+shd/QtGWb3S1Vd4T8ikG0VrEGFqBvqmKK5Gdgfrkvy6DU+BTAeen7B7GE2eG37gdTI3osvNpVqou/eIsNUiYia9kQfcdgmIIYuv5QJ7cU26/8KInl2mTwO/ePt4Dts84eUWnUF5Oeru4z5b3UKhXq+ZMGLuXewzvm13vE8cEE/u5WnrL5v+Wd7sxEBenUzJEOrrOo62atrGyyoWUj66ilNaiWC1DgNuTYMBOya2CZab56D6uEXaXlOJ3xR7p3i8BSDgSVi1bPu5NEF6rOI577a0aLh5d8R5difqyM1jarfHOaRyskjFCDGR+DuVYKU1IA2ZZOBmRedwSb0sjVdsEubAAwNzvo9bs5b0gmtH9VK/ahmFapYPEIbWVbu5mGAEpBmhMOYtnG+BKdvICZy03MC5s/sI9Tu/JXaybsLsjNSChgrMeWU/3Xkl440gfSm7jHyhQsjKSIHWXIippr8ufM1M9jpOA0q6MmHpA4nnp+B9IcpYmSbUAEMvHs9I7lXWf/ZHqe9Hm/qXUYoNR26eBYDbHKODogRoXtg31MiOwl35uvcZzHigvw8QW6Nvs3HO79ewUhBIwNIj/Pk8VHns0Dnaz0FecplNy9XVmt/QWB9iRAwKbWvXO9NROBGhDOX3eNeAHwHoO/pUFbgODJKPVFjNJKNgBF4FPI10MA8MfiB5OWVWh4zg2S6CrW5rpqORoE9Mip2TGfvSPAmRcSX1kS9MmgrWDXKOd92bi1k1H6WjroEgAq5M7A9zGMGvLeTWQJfntOM7pAa3k2r2WwarVYzKQ46rAFQVINGduvoeJvDQwFGoPwZK+bPzxfMKCrTM3OWv8iqhWzebneSnEGCuE9x
 I1Mpnykq
 SzJJFkAgRjgwXP7Pp/3CCMXtKyle1sf0JGDKTZhQPOuHiHs+4UeqnPQ1RnHtgKIzGIXdULATevjtoygxXnSBGfZGqrHVTfzN3XWMdZjvX881ayPjV5rkRLi3oo0Y73ZxDvta1hkO6kRaqeulvcxjW5He1qniNaaNHN2kB9+1Uy5+gnc+c0Ms40U0yvNYm6nRmbEmgfPx31lGQBdn20Il0eBxUBfkHYaw1PhsIQidZ2YWFnVtx96gVGqSf/zpDpKshkFLKwyTWf0pxo76X4wmj7VHFB+gYymfzeXQbr+cJeKFl1xyknE4yMqcvT4hPPsSS04QlNzIT2rtypWxliPEEV4iW9rv9pXMtdo7GkH956/5Ge1/aIAoiktBdNm6Pc+pzFFc/tOMfdJCAQ+IuijuGlASQ8CzK3lAZKWuoubRISIEjV6N1Ubw/A96LvNcko07AyKUoJ6ksboDCcBKKRX6I91I6GOUWmWqtRmf9aqJcCEe5fM5q2GG80xBkiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/13 13:39, Harry Yoo wrote:
> On Mon, Jan 12, 2026 at 12:49:22AM +0000, Jiaqi Yan wrote:
>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
>> becomes non-HugeTLB, and it is released to buddy allocator
>> as a high-order folio, e.g. a folio that contains 262144 pages
>> if the folio was a 1G HugeTLB hugepage.
>>
>> This is problematic if the HugeTLB hugepage contained HWPoison
>> subpages. In that case, since buddy allocator does not check
>> HWPoison for non-zero-order folio, the raw HWPoison page can
>> be given out with its buddy page and be re-used by either
>> kernel or userspace.
>>
>> Memory failure recovery (MFR) in kernel does attempt to take
>> raw HWPoison page off buddy allocator after
>> dissolve_free_hugetlb_folio(). However, there is always a time
>> window between dissolve_free_hugetlb_folio() frees a HWPoison
>> high-order folio to buddy allocator and MFR takes HWPoison
>> raw page off buddy allocator.
> 
> I wonder if this is something we want to backport to -stable.
> 
>> One obvious way to avoid this problem is to add page sanity
>> checks in page allocate or free path. However, it is against
>> the past efforts to reduce sanity check overhead [1,2,3].
>>
>> Introduce free_has_hwpoisoned() to only free the healthy pages
>> and to exclude the HWPoison ones in the high-order folio.
>> The idea is to iterate through the sub-pages of the folio to
>> identify contiguous ranges of healthy pages. Instead of freeing
>> pages one by one, decompose healthy ranges into the largest
>> possible blocks having different orders. Every block meets the
>> requirements to be freed via __free_one_page().
>>
>> free_has_hwpoisoned() has linear time complexity wrt the number
>> of pages in the folio. While the power-of-two decomposition
>> ensures that the number of calls to the buddy allocator is
>> logarithmic for each contiguous healthy range, the mandatory
>> linear scan of pages to identify PageHWPoison() defines the
>> overall time complexity. For a 1G hugepage having several
>> HWPoison pages, free_has_hwpoisoned() takes around 2ms on
>> average.
>>
>> Since free_has_hwpoisoned() has nontrivial overhead, it is
>> wrapped inside free_pages_prepare_has_hwpoisoned() and done
>> only PG_has_hwpoisoned indicates HWPoison page exists and
>> after free_pages_prepare() succeeded.
>>
>> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
>> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
>> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>>
>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>>
>> ---
>>  mm/page_alloc.c | 157 +++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 154 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 822e05f1a9646..9393589118604 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -2923,6 +2928,152 @@ static bool free_frozen_page_commit(struct zone *zone,
>>  	return ret;
>>  }
> 
>>From correctness point of view I think it looks good to me.
> Let's see what the page allocator folks say.
> 
> A few nits below.
> 
>> +static bool compound_has_hwpoisoned(struct page *page, unsigned int order)
>> +{
>> +	if (order == 0 || !PageCompound(page))
>> +		return false;
> 
> nit: since order-0 compound page is not a thing,
> !PageCompound(page) check should cover order == 0 case.
> 
>> +	return folio_test_has_hwpoisoned(page_folio(page));
>> +}
>> +
>> +/*
>> + * Do free_has_hwpoisoned() when needed after free_pages_prepare().
>> + * Returns
>> + * - true: free_pages_prepare() is good and caller can proceed freeing.
>> + * - false: caller should not free pages for one of the two reasons:
>> + *   1. free_pages_prepare() failed so it is not safe to proceed freeing.
>> + *   2. this is a compound page having some HWPoison pages, and healthy
>> + *      pages are already safely freed.
>> + */
>> +static bool free_pages_prepare_has_hwpoisoned(struct page *page,
>> +					      unsigned int order,
>> +					      fpi_t fpi_flags)
> 
> nit: Hope we'll come up with a better name than
> free_pages_prepare_has_poisoned(), but I don't have any better
> suggestion... :)

What about something like free_healthy_pages_prepare?

Thanks both.
.

