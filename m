Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA9FCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E5D8E0110; Tue, 12 Aug 2025 08:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF568E00E5; Tue, 12 Aug 2025 08:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05398E0110; Tue, 12 Aug 2025 08:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91ADD8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:12:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 173B01602F4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:12:06 +0000 (UTC)
X-FDA: 83767992252.20.FBD8AFD
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id 61AD514000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:12:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755000724; a=rsa-sha256;
	cv=none;
	b=UXjqVDlfPstIC/UD2MHG04fuEagA8GXLHWZ42qfp+J3rkuVooWvLU4nyOjHrxZOBPfEiQn
	XByGG2BzZqvSj66k48VZCWtoFLvCtQJ+okleOSJ8uJLi/6B32y9a9qbD2BkcZQsHYOHJzj
	ii7I4ykj3srJxHDti8RI7MLshzdsce4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755000723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oo8E25LR2ViAoMUk0XzU0PPBMQhuK7axS1zc0jgyjhQ=;
	b=MbDOy/HSSwWEnLfs/BzwKigP/V1wn2eL0g2tyxOUrBDeEoP/Oq9A0/ykHfjUobfKJPNVYW
	uAVWGQ8cNg0jmW/lgLhYX3C0xSzfLd9xMZiZLg4aGUXd8Ut+8U4+MV/JYLgUcV5u5nGNj0
	R7em6h0UB2W0i8ylkLwZCBYvYr5w6u0=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c1Vcp2dnlzdc7h;
	Tue, 12 Aug 2025 20:07:38 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id CDA451402EB;
	Tue, 12 Aug 2025 20:11:57 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 Aug 2025 20:11:57 +0800
Message-ID: <f9f81026-a29f-4dd6-bfe7-0319d09ed2b2@huawei.com>
Date: Tue, 12 Aug 2025 20:11:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: <jane.chu@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Muchun
 Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-8-wangkefeng.wang@huawei.com>
 <0d416f66-6444-4f1d-8e94-9e0a1ed315c7@oracle.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <0d416f66-6444-4f1d-8e94-9e0a1ed315c7@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: etpg61dipoddk96q8p3f8qhof3befsiw
X-Rspam-User: 
X-Rspamd-Queue-Id: 61AD514000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1755000721-203459
X-HE-Meta: U2FsdGVkX19XElu6h7pWTCtGaS8gDof6uAwFqVeFa7CifB1Bfz5hc4/YpU7ghOp2snHnfhRC0Y9hj7U88lnH1znw8P3k+zy1MxbCQY6n9L8FM4xDhm8fgNDA2CC4cbz9PMYwIU1S5aPcP7C0ZUhoDFcOMYJJNUrWS4b6GftRyLxNnqyoNOaQJ20VWyOZ5x8Y/3xjTlv/yWFKUtlPDDC/0EjmCdP8Ldy+bxGp737SJvBF1Rd+H1+s7u2vUR87HNIM4lcJ7y+GsHVhp0VWdTFDdEysk/+eWbRrzTMbyZ41T82CsW18zUMNY4AkaXELlBNiezVlI2Nb1rZ992MS0xyyGU04RBOK0NwEXTVjjN2+ImJ54rzPvu7NUdZSBrqK6GSypvNTujpSCkrQQpd2YMH6AS1CUVd5sxAnnTJbUEn9iIJV0k+QGFNl+DdVJ7bsgVz4Jvtx133h3QdFVsT+UHpzSDihshpeQk6NlV7/lCqu2nu1hJ7B3+3dW2FvhUmL+qmLupPPpXTeOT8m6zPehYE60Omy83bK0KipbHYzhJ/3Up6jz5L5bzQmJ07nmEA26WuPxof50JECiMSl4nE6j7z/8XcMKQFTR4wLPdBFS/2O9dKcP021ZqQgvjbRJYNYptVmxiKPROSMSFFB7pjqhmXZMobpv0a2ESDM+tq/FoOagnA3D7wfwTnYmGCML1k/RB/UX2ByEkHnXQvCiQrxErtTPNv5OrbQA0h+abVDp4PNmfRZcg22XECR5rDvcQNQFDcSJMZeE6X6wdcWHNx9RrmBUKEmB/U5N4YYw0Pi0SNi2SNPkjXc9g0jQQZO1fXpRD24NqoPlhvulw6/03KQtVdPpZsVhCmM68VvvkLuHRdAJfPjt3Lrg5xraNUiFcASBWu5lGPcjKss21Up0rF/JsDh9FSyw5eREGOzNcM8RL8mDX3IaMcGHT+YLXIWA1GoWh6PeV6BPARh1Jk+p0sqQFE
 OEJIspLX
 9kYslVnuWxNncKkrerWUJrYGyj1bPuHSDHucG32KPh/nOnFMEFztDvv67a2BrtIuYuqGnZxq2YWqNGCEExWrMxNYANr57968xBdUOQ/peso6XPI7Gg7grH4vpDi63Tz4kj1mRTdQX//whbr6bA8ec+ai9AKI11xPN1Q669n1xkIOPvy2nFAWjz1eybp1Uln2p1/HWITLRNWODLKhGYix29OmxvsDVUp/1SWtTNWFp6UH3gEcXuvpyTDZltDEtGJa60LZd8+28C93z9komjFLI9MHqEyZ5yfknP3iOozBG/fzOOvpwIvQD9xeDSul2maHH04qleYNoAFPcoIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/7 9:22, jane.chu@oracle.com wrote:
> 
> On 8/2/2025 12:31 AM, Kefeng Wang wrote:
>> The alloc_gigantic_folio() will allocate a folio by alloc_contig_range()
>> with refcount increated and then freeze it, convert to allocate a frozen
>> folio directly to remove the atomic operation about folio refcount and
>> cleanup alloc_gigantic_folio() a bit.
>>
>> Also move folio_alloc_frozen_gigantic(), cma_alloc/free_frozen_folio() 
>> and
>> cma_validate_zones() into mm/internal.h since only hugetlb use it.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/cma.h | 20 --------------------
>>   include/linux/gfp.h | 23 -----------------------
>>   mm/cma.c            |  4 ++--
>>   mm/hugetlb.c        | 43 +++++++++++--------------------------------
>>   mm/hugetlb_cma.c    | 12 ++++++------
>>   mm/hugetlb_cma.h    | 10 +++++-----
>>   mm/internal.h       | 37 +++++++++++++++++++++++++++++++++++++
>>   mm/page_alloc.c     |  8 +++++---
>>   8 files changed, 66 insertions(+), 91 deletions(-)
>>

...

>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d1d037f97c5f..c542ababb8dc 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6822,6 +6822,8 @@ static int __alloc_contig_verify_gfp_mask(gfp_t 
>> gfp_mask, gfp_t *gfp_cc_mask)
>>    * @gfp_mask:    GFP mask. Node/zone/placement hints are ignored; 
>> only some
>>    *        action and reclaim modifiers are supported. Reclaim modifiers
>>    *        control allocation behavior during compaction/migration/ 
>> reclaim.
>> + *        If gfp_mask contains __GFP_COMP, the refcount of compound page
>> + *        will be not increased.
>>    *
>>    * The PFN range does not have to be pageblock aligned. The PFN 
>> range must
>>    * belong to a single zone.
>> @@ -6955,7 +6957,6 @@ int alloc_contig_range_noprof(unsigned long 
>> start, unsigned long end,
>>           check_new_pages(head, order);
>>           prep_new_page(head, order, gfp_mask, 0);
>> -        set_page_refcounted(head);
>>       } else {
>>           ret = -EINVAL;
>>           WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, 
>> %lu)\n",
>> @@ -7074,10 +7075,11 @@ void free_contig_range(unsigned long pfn, 
>> unsigned long nr_pages)
>>       struct folio *folio = pfn_folio(pfn);
>>       if (folio_test_large(folio)) {
>> -        int expected = folio_nr_pages(folio);
>> +        int order = folio_order(folio);
>> +        int expected = 1 << order;
>>           if (nr_pages == expected)
>> -            folio_put(folio);
>> +            free_frozen_pages(&folio->page, order);
>>           else
>>               WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
>>                    pfn, nr_pages, expected);
> 
> Is this patch solely for the purpose of saving a few back-and-forth 
> setting refcount calls?
> 
> It seems to me that altering the behavior of alloc_contig_range_noprof() 
> to the contrary of its comtemporaries, such as __alloc_pages_noprof(), 
> alloc_pages_bulk_noprof() in mm/page_alloc.c, might be a source of 
> confusion to unaware callers.  E.g.virtio_mem_fake_offline() calls 
> alloc_contig_range(), for now, without setting __GFP_COMP, but if it 
> does in future, it could be tripped.

OK, we may optimize some driver by adding __GFP_COMP.
> 
> I guess it's helpful to keep the existing convention such that, these 
> alloc_()s from page_alloc.c behave the similar way, in that, head page 
> is returned refcounted.

Will try to keep the original behave for the alloc_contig_* in next 
verison, thanks for the suggestion.

> 
> thanks,
> -jane
> 
> 


