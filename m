Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30C83CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5528E0006; Fri, 12 Sep 2025 05:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD188E0001; Fri, 12 Sep 2025 05:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2998E0006; Fri, 12 Sep 2025 05:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661CA8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:12:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01C49869E9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:12:37 +0000 (UTC)
X-FDA: 83880032796.23.6E03AE3
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf18.hostedemail.com (Postfix) with ESMTP id A20281C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:12:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=by8Bcw1Z6PTIUo97wQ0lgrgC7/ufTPe1UuLNZgfKLzE=;
	b=k00qLVDWHWkPDcE3gI2dn7Lx5MlpdJwD6ICfluUDuNgwm+s6xcESpGw9vUY3TMQRPzn0jv
	AMTgFJY3tyFOVxmLsij4E6yNflOjhtssSB6xyUx037ZqPeqYFRP5xLPWuvacYyhRd7DmpE
	8Y5hpm/8nu9jxCn2J4LxhpadpFUjnSs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668356; a=rsa-sha256;
	cv=none;
	b=hZRl0FwVb+ioDJjAjGaatcI8kUazAU76qevKt4VrfMfGB7PwgUNbVQhKXzXpqyG5bC8SaJ
	lP3kx/t0mJ3LinaoYAHOwmrdHV0hb63v61M+MVsC6pbhsgPIeFN/yUj7yW8jaYlqB7RU+m
	lPAj4fABClEI5G6V7cBIV79cc4A5MrU=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cNTBc5PcPz24j10;
	Fri, 12 Sep 2025 17:09:12 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id BA9AD1402CA;
	Fri, 12 Sep 2025 17:12:30 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Sep 2025 17:12:29 +0800
Message-ID: <8a524eda-c3fe-4e28-a24b-4050484e472f@huawei.com>
Date: Fri, 12 Sep 2025 17:12:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH 4/4] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-5-wangkefeng.wang@huawei.com>
 <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
 <8508e8fb-77cc-43a7-8460-456f68a552ba@huawei.com>
 <667133bd-0021-4d4e-9cde-fc8c1324522a@redhat.com>
 <d63e7e02-b2ab-46fb-b981-ad4f4f28d634@huawei.com>
 <3a842ae3-f13a-4f5d-8870-d81cf1f0d56d@redhat.com>
 <1da42002-9dad-45a7-98f8-90a97801002d@redhat.com>
Content-Language: en-US
In-Reply-To: <1da42002-9dad-45a7-98f8-90a97801002d@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: A20281C0006
X-Rspamd-Server: rspam05
X-Stat-Signature: 8d9qpizyd45kgeewnwp4do88nzx15psd
X-Rspam-User: 
X-HE-Tag: 1757668354-243475
X-HE-Meta: U2FsdGVkX19gIyBD/gFhgYeod+55Nfco85JZwl6SoBbIua+U0Bw2ytYLX/G500YqmWs2Pm2nF+i1S8kK0yUn/lShOJSmRiBDmWGOIxBfW9NZqGaFb37xNnz8xU5icSqQPyo986HDjlQauKyhB03eAAHHdYjCjVMK+2YlWp4dENyJ85cwHno6QRUaX6e/p2BtQ4n1d5Q3pntL/2PqhYHbE4LpGXq3YHuTjrP1dKZLAGGCR8o/kqDXd/NZd0ob2/HbgP6nGFWcEdzkp95ggxMvHTcsLmSHD6lOML184T5DydNiSuIFMsDEMQplfSLmjnzSLFVTYLTPC4JIDl/KoQK2wu1ddVI7zN3rNtG9V7My3DnCZ039RG9XYCpky1pScbIaUHCC4u2BhXj/Y4Z08YsM+cOFvuUe216XhXjmCsAJ8qqY+DJLVEeWMVDLcFBHM6RVDoYZoemG67dDtfgiuFTaMW3cSS/ah0kzo25WqbsADd2jFq0np36sbt4Yv99lLtxvxRgfqXiTYdwyxxRPLdTNAjzQX5sog77sGrm3Q8APv0E4r2dj7T1ydVeNx5JBlUvpvhQiw2+tUfdXGwQ7ZJdux0OrczQkCgpX6b0G4vP23eVAQouFvfYM0ZYhp4rAyqtYxaLg9tYK7HhammCWnG+G4HzTOh2CKkfgI4ttRkAEnv91W0+K9LrE+ceJ6T9x+qGUT9DzxrZ4ldHWhdzNb8c3gi1o+T+TfMAvsdVOLeDbIHFzldDkoA28vOl0WXnaPSZX5PlHFmPTCdhuRwriUCRDieMl9ZfZgIAzOpNgWJMS+PlgMc6ju+kW89ux2F5fuMVyugMP+1z41YAloX2BKnoNDY0TGBsF1+bSCVrxAdwkkr7PhoBSpgXoCYBAhQm8dazEk+bGqWnHlZU89WiFJ6qG+1dVX6p7fr1y0bXKpj8Hp+35FkcwP0BgfV33yWQ0J4JsRH5tFGDzT4tNUJvsRFU
 HqLIykQi
 jGUMToRBw6k/Ai7uFU8zUlBL3CkdgUj9WSEFqUY5RkuvyR6uwCWXQ4w1eHe2iCHxVluNQJw6XPsUykEX5+eL3S7TBbInrfDUEIqBaaS+IA9qxLEP5ttU5s/sZM7j5WJa+2BKB0ZJ6QrMAA4NDEg/G8nFTP+v34pJrTCRGYklOQka4/XKmPWxyxlBXzXy1By2xqRwM6D52rVAg/ft75NVvwNyi79GF+CoATL4mnh6j8kst6B8rauoU6XiVw8/aLCgsaoYFvsSwQ5ml+8lDwni13KiCXlG0AcijwGyB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/12 15:23, David Hildenbrand wrote:
> On 12.09.25 09:18, David Hildenbrand wrote:
>> On 12.09.25 08:57, Kefeng Wang wrote:
>>>
>>>
>>> On 2025/9/12 2:56, David Hildenbrand wrote:
>>>> On 11.09.25 11:11, Kefeng Wang wrote:
>>>>>
>>>>>
>>>>> On 2025/9/11 16:25, David Hildenbrand wrote:
>>>>>> On 11.09.25 08:56, Kefeng Wang wrote:
>>>>>>> The alloc_gigantic_folio() allocates a folio by alloc_contig_range()
>>>>>>> with refcount increated and then freeze it, convert to allocate a
>>>>>>> frozen
>>>>>>> folio directly to remove the atomic operation about folio refcount,
>>>>>>> also
>>>>>>> saving atomic operation during __update_and_free_hugetlb_folio too.
>>>>>>>
>>>>>>> Rename some functions to make them more self-explanatory,
>>>>>>>
>>>>>>>       folio_alloc_gigantic            -> folio_alloc_frozen_gigantic
>>>>>>>       cma_{alloc,free}_folio          -> cma_{alloc,free} 
>>>>>>> _frozen_folio
>>>>>>>       hugetlb_cma_{alloc,free}_folio  -> hugetlb_cma_{alloc,free}
>>>>>>> _frozen_folio
>>>>>>
>>>>>> Can we just get rid of folio_alloc_frozen_gigantic?
>>>>>>
>>>>>
>>>>> OK, we could kill it.
>>>>>
>>>>>> Further, can we just get rid of cma_{alloc,free}_frozen_folio() as 
>>>>>> well
>>>>>> and just let hugetlb use alloc_contig_range_frozen() etc?
>>>>>
>>>>> HugeTLB can allocate folio by alloc_contig_frozen_pages() directly, 
>>>>> but
>>>>> it could allocate from hugetlb_cma, cma_alloc_folio() need change some
>>>>> cma metadata, so we need to keep it.
>>>>
>>>> Hm. Assuming we just have cma_alloc_frozen() -- again, probably what
>>>> cma_alloc() would look like in the future, hugetlb can just construct a
>>>> folio out of that.
>>>
>>> I get your point，firstly, we could convert to use cma_alloc_frozen()
>>> instead of cma_alloc_folio() in hugetlb_cma_alloc_folio().
>>>
>>>>
>>>> Maybe we just want a helper to create a folio out of a given page 
>>>> range?
>>>>
>>>> And that page range is either obtained through cma_alloc_frozen() or
>>>> alloc_contig_frozen_pages().
>>>>
>>>> Just a thought, keeping in mind that these things should probably just
>>>> work with frozen pages and let allcoating of a memdesc etc. be taken
>>>> care of someone else.
>>>>
>>>> I'd be happy if we can remove the GFP_COMPOUND parameter from
>>>> alloc_contig*.
>>>
>>> But not sure about this part,  GFP_COMPOUND for alloc_contig* is
>>> introduced by commit e98337d11bbd "mm/contig_alloc: support __GFP_COMP",
>>> if we still allocate a range of order-0 pages and create a folio
>>> outside, it will slow the large folio allocation.
>>
>> Assuming we leave the refcount untouched (frozen), I guess what's left is
>>
>> a) Calling post_alloc_hook() on each free buddy chunk we isolated
>> b) Splitting all pages to order 0
>>
>> Splitting is updating the page owner + alloc tag + memcg, and currently
>> still updating the refcount.
>>
>>
>> I would assume that most of the overhead came from the atomics when
>> updating the refcount in split_page, which we would optimize out.
>>
>>       Perf profile before:
>>         Alloc
>>           - 99.99% alloc_pool_huge_folio
>>              - __alloc_fresh_hugetlb_folio
>>                 - 83.23% alloc_contig_pages_noprof
>>                    - 47.46% alloc_contig_range_noprof
>>                       - 20.96% isolate_freepages_range
>>                            16.10% split_page
>>                       - 14.10% start_isolate_page_range
>>                       - 12.02% undo_isolate_page_range
>>
>> Would be interesting trying to see how much overhead would remain when
>> just dealing

Patch2 skip atomic update in split_page() with alloc_contig_frozen_pages(),
I could test performance about old alloc_contig_pages() with/without
GFP_COMP and new alloc_contig_frozen_pages() when allocate same size.

>>
>> OTOH, maybe we can leave GFP_COMPOUND support in but make the function
>> more generic, not limited to folios (I suspect many users will not want
>> folios, except hugetlb).
>>

Maybe just only add cma_alloc_frozen(), and 
cma_alloc()/hugetlb_cma_alloc_folio()
is the wrapper that calls it and set page refcount, like what we did in
other frozen allocation.

struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
				unsigned int align, gfp_t gfp);

>> Maybe just a
>>
>> struct page * cma_alloc_compound(struct cma *cma, unsigned int order,
>> unsigned int align, bool no_warn);
> 
> ^ no need for the align as I realized, just like
> cma_alloc_folio() doesn't have.

since cma_alloc_frozen is more generic, we need keep align,

> 
> I do wonder why we decided to allow cma_alloc_folio() to consume gfp_t 
> flags when we don't do the same for cma_alloc().
> 

cma_alloc_folio() now is called by hugetlb allocation, the gfp could be
htlb_alloc_mask(), with/without __GFP_THISNODE/__GFP_RETRY_MAYFAIL...
and this could be used in alloc_contig_frozen_pages(),(eg,
gfp_zone).

For cma_alloc() unconditional use GFP_KERNEL from commit
6518202970c1 "mm/cma: remove unsupported gfp_mask parameter from
cma_alloc()", but this is another story.

Back to this patchset, just add a new cma_alloc_frozen() shown
above and directly call it in cma_alloc()/hugetlb_cma_alloc_folio(),
get rid of folio_alloc_frozen_gigantic() and cma_alloc_folio(), and
we could do more optimization in the next step.


