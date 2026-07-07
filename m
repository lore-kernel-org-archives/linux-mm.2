Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0803DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD066B00A5; Tue,  7 Jul 2026 04:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84BE6B00A6; Tue,  7 Jul 2026 04:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A6C6B00A7; Tue,  7 Jul 2026 04:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A594C6B00A5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:00:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36B301A0382
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:00:25 +0000 (UTC)
X-FDA: 84961233210.21.1F3201B
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf13.hostedemail.com (Postfix) with ESMTP id C4BE920005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:00:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RHSZIw9m;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783411223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZErXVYILA0JyhLzPx7dstgdMd/mXyDNDy7Kbtxxfik=;
	b=jez2bJtvI4XzMaE2WvV7gUEA8wozPhoVmCzTbIF+1iPhOYESuu0IVruh5+yaoM0DRayyOr
	KxR0jqN6A2mO9pnD1uWxZcfWeP4n/Kz2h3weD9XVjB0KEtESI4m2yyjJU3B2wVqQj2wtSs
	8Cam+yKLTPN6BZac/1skhjitEYegfik=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RHSZIw9m;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783411223;
	b=2cDD6SVHwTTNw1ySD/nmcuYhiNWMBEkVByxAPhaemQ3OiCIi+dwMS3GhDsHt3nw4s9KAoM
	HASq2Aby2Rd1ZfWfdqKCtrqcgnPMSy2VjUppwPctZ5cmPnoxK+SKXOHaBP5fxf2retOgBl
	erCrB65jNEBZsUMlnVanWKSHY0FaK4g=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NZErXVYILA0JyhLzPx7dstgdMd/mXyDNDy7Kbtxxfik=;
	b=RHSZIw9mmbJK5Kipoz8hsc5y9s6m8u3SedHlYkMk9WqM2NSigbmffoBH62AyaclG/tNyatFop
	eRDu0tMOb4OftQBNwW9XpD7Q4Z3PSmLHi7XHMa4CyRnZbdfqeWJqApWCnW/YKFtjpiq8C3xNVG5
	rbopkJ0ag+xvJrHWAtJYrcU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gvYLr3tCxz1prL6;
	Tue,  7 Jul 2026 15:51:00 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id DD5B94057D;
	Tue,  7 Jul 2026 16:00:15 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Jul 2026 16:00:14 +0800
Message-ID: <61cebac3-936b-4366-b1fc-35db70a2f1d0@huawei.com>
Date: Tue, 7 Jul 2026 16:00:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, <linux-mm@kvack.org>
References: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
 <20260706110113.920498961e5b29b212c7a199@linux-foundation.org>
 <DJRYJCAKQVT8.1U855ME5LF6EF@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <DJRYJCAKQVT8.1U855ME5LF6EF@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: onjai418a93pkoyco8umnxitm6uu9sab
X-Rspamd-Queue-Id: C4BE920005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783411221-392737
X-HE-Meta: U2FsdGVkX1+226SznJPRF3WOfrBB3lVjxAN2XdwP0fw+DGPXXAMcmQqtKlx0C2g9j3wcICfZuCcOfIASiVK5tkm08xYUfN6ZZj/aqXgtFdBkhHIao0AOXT+kA/aNPqFcfzJAp3ugW937ZZoCf7LeVTihEb0CJf2ney3O21MOijiZnehm+wB5KKBmrMDh6ZkhKaKXqsZlSR10pZ3DnLYIkprh3If2woXPD9PsjI1frmtcsexA+boiDSRj98tKEi0GMCE6uRZQBGBLZedQ+h62nXObI4LGrGELTayGo5AdCnV7xs0awj4qlWM5+ZQw3lA2yhoSqdWxAmT71QKl/qj7i3ChJFzedEou4vtCNRrtBWhJqhmrdAqGFAMcXKc8RvRL5/5RE9jNoBD6l8QAtnStRw5uWZq2P7F9PsjjXOPsgTQbaWFMqQjVqusXnhRwXmkrRTvK+LsrW6PKz7cDahI2D2S6tR4lS9zmUOjBmhsQoQq4icPh9ErzH4nMQrlBvu2PaoYPTuMnDGAjDYUhDCpwGndRQGKN1qhcAXN/eUqh7uJf+sjQ3ruVVAygUxuyJpJkENuziijl9faMb66YaP8D3zerlolKCse6BCbM0n6hdvsFQzb29G52LD58BrtM25KTZ4LxcKbpzt0xfM4+yd1oV8jm+Z4jZLU9Om6Hvc8dq/He0sb0pzA8PHnxseGXDH5H6/2WCcVyZEFAi3/3RRBMNjYzUg9ZluD9ZanOP1B5MfWHSIwtnz6AfDNT89WCn7bH9p9r/OijpTxSXpAcZhijBhFPDUfe2k6RtNKdMJOkHsS1SgQuhaOM8z/q/mAV2AlEvP6+4xI0rjzrqlndNMrv5hblrkakVEUlC6v+E1z8tGajqt5XmG9cLmfyyHThpIqHiZdsQBzrbivaP8WVHvGF38z27mL2uzR5UZWPz15A6HlF3A5iS2gURdELeidGtMteilkTXXFiDY0pTC9kGzj
 RXyvfnHS
 nza+eLozSxRJG+wdcxHYKWAOydOBvMAdYwVa1hhqodZZPfoOP7vAoKShOhNWrS2593A3OywGhQvPZaamTypAJ4ILXoYdefDYxtNe+uhzLPxOpsK7RXg2UMFirSzHbTWZxn0vshCuPN+YuV5raotEb09v1FaKN1QnmHYYl1LgsXO8L9xqNZfB9NWrTYxteU+YNQ0OVZAiG13jlcrGJ+kXHx/YI0qZtMZpph7xy3Ohmo5Je48E7aE5lsBvIgNsAzVINje16Cdzdf7gZpRYy1bMdZ7FDGTSTRsbn6yN7qJZuyUgrzlGOy8i71HDuiREG3uRk5FvFlac51CjcEn+PXTnZOI1nb8msd5/9M+fK6XPr2v7ckIgiMdrOvYaIxaPdeSQJoHWzAp3/56hfDDaotLHRpR66hVeE6NmBWKZBszrIokfiAmhEubKCSlXKWJ0FysVWoozQu6+20Ia5LjLx/YCpG7D1+kdXouy7WoUObobCtZQaKI785f+5sCCmK0jsxUpYddXXFGXXIS84ZsDUmk1RjYy+ZT8gxLAHp+Ib6OfwuzYyNTSz3+1BsRwDyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/2026 9:45 AM, Zi Yan wrote:
> On Mon Jul 6, 2026 at 2:01 PM EDT, Andrew Morton wrote:
>> On Mon, 6 Jul 2026 19:19:58 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>
>>> pte_pfn() and pte_dirty() have undefined behaviour when called on a
>>> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
>>> invoked on non-present entries (e.g., swap PTEs), leading to potential
>>> crashes from pte_pfn() or incorrect dirty folio accounting from
>>> pte_dirty(). Fix both by guarding with pte_present() checks.
>>>
>>> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
>>> Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page()")
>>
>> Should we cc:stable?

Yes.


>>
>> Sashiko might have found a pre-existing issue:
>> 	https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefeng.wang@huawei.com
> 
> I looked into the issue and came up with a fix below. It looks ugly, so
> feel free to make a better one out of it.
> 
>  From 7fa06512638a0febb79a00dba63f12818a85788b Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Mon, 6 Jul 2026 21:25:29 -0400
> Subject: [PATCH] mm/migrate_device: avoid scanning/collecting PFNs within a
>   PMD
> 
> migrate_vma_collect_pmd() can drop pte lock to split a large folio and
> restart. But the code does not handle restart properly and can cause
> collecting inconsistent PFNs and overflowing migrate->dst and migrate->src
> arrays. Fix it by:
> 1. avoiding migrate_vma_collect_huge_pmd() if collection is in progress,
> 2. skipping the rest of the range if pmd no longer points to a pte page.
> 
> Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone device pages")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefeng.wang@huawei.com
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Zi Yan <ziy@nvidia.com>


Thank you for your fix, it looks good, there is some repetition (3
times) regarding flush+skip in migrate_vma_collect_pmd(), but for bug
fixes, keep it minimal is better. I don't have new ideas to improve it.

> ---
>   mm/migrate_device.c | 18 ++++++++++++++++--
>   1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 052167f9ad547..d86b3989d0c59 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -257,7 +257,11 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>   	pte_t *ptep;
>   
>   again:
> -	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> +	/*
> +	 * Only check pmd when addr is at start, namely no pte is scanned or
> +	 * collected, to avoid collecting inconsistent PFNs.
> +	 */
> +	if (addr == start && (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp))) {
>   		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
>   
>   		if (ret == -EAGAIN)
> @@ -267,8 +271,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>   	}
>   
>   	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
> -	if (!ptep)
> +	if (!ptep) {
> +		/*
> +		 * Skip the rest if pmd becomes huge or cleared. Flush if any
> +		 * pte is modified
> +		 */
> +		if (addr != start) {
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, end);
> +			return migrate_vma_collect_skip(addr, end, walk);
> +		}
>   		goto again;
> +	}
>   	lazy_mmu_mode_enable();
>   	ptep += (addr - start) / PAGE_SIZE;
>   


