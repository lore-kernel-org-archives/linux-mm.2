Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F677D6ACFE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B586B0088; Thu, 18 Dec 2025 07:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8B56B0089; Thu, 18 Dec 2025 07:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C81E6B008A; Thu, 18 Dec 2025 07:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0D76B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:57:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 237D3137F88
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:57:05 +0000 (UTC)
X-FDA: 84232592010.28.B411647
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id DD8594000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:57:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766062622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0g/CPyx9PGQ3YJ3OOZuoYxdAO57Z0LinTiuhhj5V6Y=;
	b=fuHFdUIjpu4+zZ/Fm09Wqj8ftJY1lpeuvNcVSqgFrMJdTU00ig8tZwyuKO018D4UfDGZLH
	6fCHGlJnpbcGZ2Z2lLZ3VHg/ubornJovYuaKluR4aOFY/4kjkF3CmLodeJSt+rsDHAFKHi
	JwhANJGWm/uPh6q8OlOz7qvMKMeKQVI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766062622; a=rsa-sha256;
	cv=pass;
	b=yjON+IQPAgryd+ZMGvpdqpTN5VheKhk2XUQcEbDQe2zVDlnQv4jNPB1DWyQm5N27yQKFY9
	gyPtrUnWqNOQpondGSPl/AmhNXM4C2vX1tDoUmfY+Y4m8A9r7ytdrOi5mHKUi1SfoM27mJ
	BQo8nunqC98Wfeh+XqhC0yaK/1TJclY=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BC5E133BA8
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:57:02 +0000 (UTC)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 443F414012F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:57:02 +0000 (UTC)
X-FDA: 84232591884.01.73F1170
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf16.hostedemail.com (Postfix) with ESMTP id AFBA1180004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:56:59 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766062620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0g/CPyx9PGQ3YJ3OOZuoYxdAO57Z0LinTiuhhj5V6Y=;
	b=8CzRS+pKnQb5wEpe818cIT1TcRXnsYSJ4bW0yhDfSdcNsCbrvhsldoih6r0CBfxf8/5DAh
	TlmnQt1v5p39e6PtOimE1AOqufXhYSgi3DUX3Y18QclOlxQUz0/I/PjRH6XmsMiQVT6M2n
	M5uem2S/6Zhtiuu2mrBkJE252qRWnQs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=u4GrI3aU;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766062620; a=rsa-sha256;
	cv=none;
	b=An5oixAat1ihOfWn5gxTU/IXLX3NWGyeppf4Uz7gNtxurbf27xY47EuQ4d9w6S01OPggv/
	4E7mKSN0WnJxVyQzb3GkxVxdJC1YUMDcgaoRkzstF34qa9tm0PnjpsuE+qkn/WbY/xvr36
	yDeAvi5meqAfjJRjnegIH4ujAFqPEZ0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=W0g/CPyx9PGQ3YJ3OOZuoYxdAO57Z0LinTiuhhj5V6Y=;
	b=u4GrI3aUuAmsFa/mxaAHVMhiKzn/qDsErvukCB5OcBKQ58Iaa6mkAwO4uennQhy7ImfEYvQLS
	VSSNKPm6Oys4NpA72OO4oidrsUstuf9GfFmT8Xgl5Ks0f2seo+jb+efkbNxUvJJwnyJFLOlYcuZ
	62bAq4T32GmuAp4jEh6+WYk=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dX9bM3C3zzpT06;
	Thu, 18 Dec 2025 20:54:07 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 97026140133;
	Thu, 18 Dec 2025 20:56:53 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 20:56:52 +0800
Message-ID: <63f1eb69-17b7-43ec-8cef-40e40c0e17f4@huawei.com>
Date: Thu, 18 Dec 2025 20:56:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-7-wangkefeng.wang@huawei.com>
 <EA31F2A7-D0BF-4A49-8F05-C2E7B73A3556@nvidia.com>
 <de2e93ca-830a-4bc0-841a-1ed70ab1a61f@huawei.com>
 <2A3E14BF-22D2-484E-AAF3-29D8D918BA73@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <2A3E14BF-22D2-484E-AAF3-29D8D918BA73@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-HE-Meta: U2FsdGVkX19xjn3EflNLPPyhhVZpSa9wer30meM9f3HJuwyrqO11Hj+iyOg5MakqP60fzRveVD1+pOPMfWELPHJXXcS8gV/vqVMTy/Z7dJUpusffzCeBsfY/136ve2UwgzP/lpIUHquLuu6jQr2b2A9Rrm7DDkb733opEExQoqfEdokbTfINucjDmRg6w4ibAd4LVCid5oimrTXw/N1HgKHtgCeWPc4bBgPEwYmXwuRXhuk3UdsmGRz8yA6VZxHc4cB7fgPE9v1rESBx/ezmqP1CDlaqVbTp0mqJ4rTnUx2+IUEQeUfMUu8htiq0luaB30nhdcxUKyn5+FZSip8Zdm8krv7Csv01ix0tDxQZYJ9QZnjWhiT0Snf30VgCgoG9wkhniIk0QEuTfvKTxY0GtEAM5uAd+4atUtRAKcMYDjwhP0+FJiWsa7Gg7MaLiv5oE7nIaRFeeOlRSO7yEEXjF5+mmxLkaCJp2WBUB4HkBzUqZ3LHtgjHbRX11NbKx+A2/m9Yw6IUbqMnBpWEiegQUjDXaspCAfENQvjnKYVcmNMB59fiPCmC1Az8N6UNguZLsKk1ZJKZjBXD7cH0bqz1LLB5jjS+nnErVxs8GM+aMysZbzot9b4RJ/BrObI59fOC3bf8tWGWf2KtyliVDu/9+/oz7aWbsZQd7RX8S3rwZNzusQVxX4EDFFthsLZx4zdIcgORaJkp0gsDhzmcF+mP7jtMlbbZU3qCz4IhHbcn1HvGEphYlTInSHaBJt9BJmUPxmQHUyasizwwSfVsehJpyNv2bScnRBSHg59414aY5BAcJRK99mYAyigtGCIt/V9Sl/IrEm+zhsYZyV5r+ZMtXkIW07wDLV+jO68IyF+PMZ2G9nr5u88y7EwekW8/8jmeyI9mC6/QSczwqRNdkULlmMnnEz1CyoRG3PO4Flhwz3rS1uFcM7Zx6bxbbvgNwuU/Kmf6wYy0syMOXKhs7wj
 yd+Zhea7
 Co1TETCqLAdqnGrYEVdgcbxjeuNBV6GfgzoepUATrHA+GbmTsuBulZpnEbrXjg8dZ7LHuyScQ6MBgswk8Lx2oXX+UZfFOG0Liu/j3CLSW0f8AW+bkkJKjU0JnL3/cOzNYTi9wp51LhndcAZs+FK6rdhtQq2BKv/bN+Z/N+aThNM9QfZHTYsQB1Gty+24S+iGx0NvRlsB6jXHGoQ+5lynxcoMWzm4d96Fv9DU6TMdpBUjAlexfCHiJ8EgzKY1fAGgxFmjBE906STK8wUknXQzau4nhTUCfiWoMmIh0kjJXZtmkftXN/16N/DaCs+dmZ3H+TvxplfktooJ+V7t6TacZzx46vVEZE44AWG/BVaBYIFKG/5cOGmeQoKWKm93xXoS+Lpoy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD8594000A
X-Stat-Signature: g7isusih87uma83qcxu5biyusg7qxyqa
X-HE-Tag-Orig: 1766062619-919561
X-HE-Tag: 1766062622-982338
X-HE-Meta: U2FsdGVkX183BwYRP1kQzy/8/0uRewf77dpej3EbCe91Zc1tXhOwMmXAivtpN28eK/NuyqfYHU+Io0FEwrWluGpTkwXcMf5kI9KkxC3VIOwMYuwNmwDcL8eEUMPacypPChhAAyzo2pcuDv3nSMtnseRweMKLe+OXGv1ab2vA0C7dIZzSzDDwwwYkJEyPf2SiAitjhphsnGoYCzFZEP0HA5BQWNe2KvoZyTfO+IW90VkT/Qs1cj48WfvXVwsIeY0DS3Ad7rVoSL+SeuervM7A0uzLgRFcv3iKzwkl1ds4sWwAfMUsebgjqVDkGmZUb0EP4WpgJWxBBO25FvkiCJBf5q0uiTy8YzfPZ+KWbebiOEjMRHXRkL7RH5z1KsutvNLE7W81mP/TI84WFFSY10bIa8/c6Me82KdtPYvjswSzhYToeakc5z32/c5n/BgTZwzAQ6WI6bKPuBrafR1up9smgyn/nooaPO06Lqd+D97aUNy4YACD+jQZRy2yaGXSLgZ3koxEVlZ78Hho3wWIM4jw1j+Tn4CaAdXlnhxFA+i3cnc6F1gdlPCTUJY+Hzj1UnfhRvBr4v2VU2DuTT02oFNLuM5PsQleL0dzb1oIsp4UbKZ9xUawBOjnGdX8aVhhZJkK9Uxc6RaOf6X5f2AmTPGfjjeY0aZVYBjc9Z4S8JVbNP3gyVNgYxCzcNvD6USxSYLYA7oJTqXOL+oJV6AmEFm+ksRXvGT+WJwQT9R6IhDgqYOiADCsIHo/rNqR9n4KPzeRrCzTqatWSkMjDlZwRqNWILnp3yXsX4BxkT/XNuvesru9eUtDIS9ziujPNwmTqCd93JAspuDga5XtHnXPhtjxUZOGphSWh/4xDMa82VlUC2MU9NfJZSRWVH/0QuwEUC9Pe3ksntOYGP3yf/8AAqMwU0lEzTQLc+lYqcMpPtgRnz55qLtH6oRcLGu+NeTELhiKRaKIsFT2zaOYl1q+Z2W
 qZZk25Wv
 0aHODuJNucNSSslOBZghOaWr3IJ3fGSsQmJ4maFFIc94nlkcitl4aCBWb1LnqKGOYDXqHnvttGZdAIWYM8e8GnBJW5YGkEXMgBZ9zVqIuRgnYxY+18iMSWCsb3GoqBlw4LA7zPNxh0kZ4romT795d9T39TRBkC8IZVO59kTOWVXdGpxxmsXFi4GOCRHOjj+LeBpS5aRGf14aZ4BRQ/KMls+DW4XV5CzP+tcXreuxpl7SBkPOQdnBdIMEAF4biL0hBIxp6Fkf4FdZu0WOhVpxj4VG4nHLC5oyFJXs+6/LrdfFU0nnjqr4d/XZjVRG14umqaZLmc23eGiTJlyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 3:40, Zi Yan wrote:
> On 17 Dec 2025, at 3:09, Kefeng Wang wrote:
> 
>> On 2025/12/17 2:44, Zi Yan wrote:
>>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
>>>
>>>> The alloc_gigantic_folio() allocates a folio with refcount increated
>>>> and then freeze it, convert to allocate a frozen folio to remove the
>>>> atomic operation about folio refcount, and saving atomic operation
>>>> during __update_and_free_hugetlb_folio() too.
>>>>
>>>> Besides, rename hugetlb_cma_{alloc,free}_folio() with frozen which
>>>> make them more self-explanatory.
>>>>
>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>> ---
>>>>    mm/hugetlb.c     | 63 +++++++++++-------------------------------------
>>>>    mm/hugetlb_cma.c |  9 +++----
>>>>    mm/hugetlb_cma.h | 10 ++++----
>>>>    3 files changed, 22 insertions(+), 60 deletions(-)
>>>>
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index ed185bbca419..7779ec838da0 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -121,16 +121,6 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
>>>>    		unsigned long start, unsigned long end, bool take_locks);
>>>>    static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
>>>>
>>>> -static void hugetlb_free_folio(struct folio *folio)
>>>> -{
>>>> -	if (folio_test_hugetlb_cma(folio)) {
>>>> -		hugetlb_cma_free_folio(folio);
>>>> -		return;
>>>> -	}
>>>> -
>>>> -	folio_put(folio);
>>>> -}
>>>> -
>>>>    static inline bool subpool_is_free(struct hugepage_subpool *spool)
>>>>    {
>>>>    	if (spool->count)
>>>> @@ -1417,51 +1407,24 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
>>>>    	return NULL;
>>>>    }
>>>>
>>>> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>>> -#ifdef CONFIG_CONTIG_ALLOC
>>>> +#if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
>>>>    static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>>>>    		int nid, nodemask_t *nodemask)
>>>>    {
>>>>    	struct folio *folio;
>>>> -	bool retried = false;
>>>>
>>>> -retry:
>>>> -	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>>>> -	if (!folio) {
>>>> -		struct page *page;
>>>> -
>>>> -		if (hugetlb_cma_exclusive_alloc())
>>>> -			return NULL;
>>>> -
>>>> -		page = alloc_contig_frozen_pages(1 << order, gfp_mask, nid, nodemask);
>>>> -		if (!page)
>>>> -			return NULL;
>>>> -
>>>> -		set_page_refcounted(page);
>>>> -		folio = page_folio(page);
>>>> -	}
>>>> -
>>>> -	if (folio_ref_freeze(folio, 1))
>>>> +	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
>>>> +	if (folio)
>>>>    		return folio;
>>>
>>> alloc_gigantic_folio() actually returns a frozen folio. Should it be renamed
>>> to alloc_frozen_gigantic_folio()?
>>
>> I don't change it as alloc_buddy_hugetlb_folio is not with frozen, we could change both of them if you prefer with frozen :)
> 
> Better to change both for clearer function names. Thanks.

Sure, I will change both alloc_buddy_hugetlb_folio and alloc_gigantic_folio.

> 
> Best Regards,
> Yan, Zi
> 



