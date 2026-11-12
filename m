Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D45606A334
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JsLmb+4T
Received: by kanga.kvack.org (Postfix)
	id 7B7A06B05B0; Thu, 12 Nov 2026 06:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740C16B05B4; Thu, 12 Nov 2026 06:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630856B05B8; Thu, 12 Nov 2026 06:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 403E46B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:30:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC686C0551
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:30:38 +0000 (UTC)
X-FDA: 85426249356.22.E306592
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf01.hostedemail.com (Postfix) with ESMTP id ED9FD4000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:30:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JsLmb+4T;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794483035;
	b=PpbnYeHudmbvD+0PTrVgPK3C1sMSo4iKoC/3xLanPOq5Do83vFcKtt569b5A3ARE2mdl9l
	vO2bYB9Nt8TbTyKu1HX6U/BBkf+C0Fbh/vj0i6EXr7ZmoUJd7B6ZEJthykE3sEpDbV95dZ
	zKeMTtih2e18hpobuYYxQo8TBXRs5yE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JsLmb+4T;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794483035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dtoPzgIAyTZmTJOXmbFfXRIYwlyrp1T0CX/jpuE8Sc=;
	b=gbCC5YtbvWbTfgb2LiBwZbum/ShSdaP0P6FW+5R/GGmGzS5dQdBTmct5Ap88WVv3ew3j+o
	QqTmK3wIrMLB1Br5MzpLyChqsXhT6RJZR72Ll+g46QvLx4dYHJOvZAojhlmKdfCwDXqYSw
	MR0w6E6nalSP1Ht64ZTpVKKWVCfzJnw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8dtoPzgIAyTZmTJOXmbFfXRIYwlyrp1T0CX/jpuE8Sc=;
	b=JsLmb+4Tk+a7iKdRyTfJwMH5VClwAn5+pSrMX5WFckZNZJu7p1WXAYf11555CnuG5DEsfGp9k
	BeuE9orOg/o9PoYKmww8z59bwTSx0uEfbqY/D9m0WXNHqJpX6Jrt1Xgr1Ehv7eeqGmf6oDtQjc+
	M7ICNe9Jlqzp2nRZ8ChCv3Q=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jQJ8j2WsDzLlSW;
	Thu, 12 Nov 2026 19:30:13 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A88440565;
	Thu, 12 Nov 2026 19:30:29 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 12 Nov 2026 19:30:28 +0800
Message-ID: <3ad97d52-9229-4b15-818e-4fcba66a0251@huawei.com>
Date: Thu, 12 Nov 2026 19:30:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm: hugetlb: fix GFP mask propagation to CMA
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Qi Zheng <qi.zheng@linux.dev>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>,
	<azpijr@gmail.com>, <lance.yang@linux.dev>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, Qi Zheng
	<zhengqi.arch@bytedance.com>, <stable@vger.kernel.org>, "Oscar Salvador
 (SUSE)" <osalvador@kernel.org>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <1c5e8c4ae230dc238a16f2f42d65bffac6244ad3.1794379434.git.zhengqi.arch@bytedance.com>
 <7def88b4-cba5-4e8b-9e68-6069c492b582@huawei.com>
Content-Language: en-US
In-Reply-To: <7def88b4-cba5-4e8b-9e68-6069c492b582@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Stat-Signature: ueqbo457q59xj1n53c6nqd8r5gcpda5x
X-Rspamd-Queue-Id: ED9FD4000E
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794483034-774459
X-HE-Meta: U2FsdGVkX19jDwNzwMMP/1UV8dnhSJOU77XUdvRsoHXakj1psmIVovei9o/onWvVDf/tUz4Js8siP/CHbvbOrn4y8Qfv6ZnFl6HZYPPpG84WW7S7Ir+thiII4aNPiuotTXH/xOYJSCiapu6tRD7I8qTMLallDmMh0Df1KmC77dO+H7Zl1COzQFWzXv7TgyMcRpVMoeSffY2hyqvTM8I8IVD9m/b0AdvUmLzRhIZOC0iipZLo4pt+L6tOQ68baoYtWFjtogGxt5i7Bi0GOSHDnP1ZFQ73rupcuCXkw3DvjP+8pdHBmUyQ3fmll3vwmpb0z2trzIORcexQiQc+/SJYAXOxrcbAHyN/6mH0/G4hyRwM7v8R4uhpBXXeIBJqXCZ+oE23CPYa6xo213BfdmGX3Mqcn0fdp1mJIfba1vIRPikIfUkqw2Zs44ZXjp1wItDXRQWAMMhlSYXFYmi/Q9B+pGBt/xdPnLNJIgfhhKbICgITyi6elppi13X+lB4zrHxsCNM0O6Hc0F0y10uPm//TRA+nyAJr3N37DYvbLlTzqz0oBu4onqgEQVX8Wkb98Q0aD5/YIQT88beTx19CpKnjFm9x0+MEVMb+dl5sm6im+zQhE8QbzBaQuf85TOWvSHSjUPH6ZEFTuiw28S6ltz3cqrXL4bv3yARxABZoUOE0Q4qMTg5E9UjTuZ216XQ7aSq5HttJo110HsRioUEfcjr76DXtnLmlzpR8ku4ySVmmxphYoX/rL1cvFyoiQ51bdKjncxhMftYTPbBxapK7V4EVOenZN8moaBT5TP7mYLxgJC59/xwXxC1RBG6y2VSBHkju3TKwTaGtDNkwyeZIlODNVce9tRWKdJ2Ljc7C82p8timHaiZ9MTrIgEER6pGZHIV4MdIgBMv8ZK4c+miEBoi4ziVRjK1we3KGFkrmjgK4RMdsA9/ocTEjYeqiQz3ezua/xhEJUuZ0Km5g/8D/tbC
 A65I4Js6
 adDIwAn2/GyDX2c5oliOCYlKgZJfkM9x5IN86ikFnIjnsVJi/Mp2w4tAoJbzQqVhqZoImP0G0FIbtXv4Ra32k7poKbFBwY8Th/DKAfnAROw7bwTWquJIh32vRfHbX/j6HzINBHWd1sEMZsKgJEG5dV7qlSduuugU+RG/TptS8QhgVxwr7XpgoRdsFRDb5ET1QQRwe2TJNiS9euucfoDsJUYMTp588DGhgGNOYmGzU0RCZSJF/SEtRV8dgpZKaxnQeMO9W1KijOHcsIdYkt1jpoZdgGY/kW9pyidFqRo1hyORAs8qm61qRyzb/qegECEw+laYaX9em2NTbkUTyjKRs5+kJWhMn6PDqcNUqMOAcxfZo/rCxddD+SRDgym54fsCtGgoCgu8iiX4kaF0G7l3iKvBUz2g7H+s31zZq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/2026 7:27 PM, Kefeng Wang wrote:
> 
> 
> On 11/11/2026 2:46 PM, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
>> during the first MPOL_PREFERRED_MANY allocation attempt even though
>> the caller clears __GFP_DIRECT_RECLAIM.
> 
> MPOL_PREFERRED_MANY is only used for the partner allocator. Without your

Sorry, buddy allocation

> patches "mm: hugetlb: add CMA support for PMD-sized pages,"
> cma_alloc_frozen_compound() is only used for huge page allocations. In

gigantic allocation

> this case, I think we don't need the gfp flag, which is why I hardcoded
> it, so there's no need for the Fixes tag; this patch should be part of
> your new feature. Maybe I missed something?
> 
>>
>> Pass the caller's GFP mask through the helper so CMA respects its
>> reclaim constraints when trying the preferred nodes.
>>
>> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Muchun Song <muchun.song@linux.dev>
>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
>> ---
>>   include/linux/cma.h |  2 +-
>>   mm/cma.c            | 10 ++++++++--
>>   mm/hugetlb_cma.c    |  4 ++--
>>   3 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index 8555d38a97b1a..4539ea5f2c4e8 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -53,7 +53,7 @@ extern bool cma_release(struct cma *cma, const 
>> struct page *pages, unsigned long
>>   struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>>           unsigned int align, bool no_warn);
>> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
>> order);
>> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
>> order, gfp_t gfp);
>>   bool cma_release_frozen(struct cma *cma, const struct page *pages,
>>           unsigned long count);
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 9ec1d1fd5dff5..a7c47c0e7d070 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -933,9 +933,15 @@ struct page *cma_alloc_frozen(struct cma *cma, 
>> unsigned long count,
>>       return __cma_alloc_frozen(cma, count, align, gfp);
>>   }
>> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
>> order)
>> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
>> order, gfp_t gfp)
>>   {
>> -    gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
>> +    /*
>> +     * The only caller of cma_alloc_frozen_compound() is hugetlb, and
>> +     * hugetlb constructs its gfp mask via htlb_alloc_mask(), which 
>> already
>> +     * sets __GFP_COMP. Check here for usecases bypassing 
>> htlb_alloc_mask().
>> +     */
>> +    if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
>> +        return NULL;
>>       return __cma_alloc_frozen(cma, 1 << order, order, gfp);
>>   }
>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>> index cd6a64986278a..3e5a30571524a 100644
>> --- a/mm/hugetlb_cma.c
>> +++ b/mm/hugetlb_cma.c
>> @@ -69,14 +69,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int 
>> order, gfp_t gfp_mask,
>>       }
>>       if (hugetlb_cma[nid] && node_isset(nid, *nmask))
>> -        page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>> +        page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, 
>> gfp_mask);
>>       if (!page && !(gfp_mask & __GFP_THISNODE)) {
>>           for_each_node_mask(node, *nmask) {
>>               if (node == nid || !hugetlb_cma[node])
>>                   continue;
>> -            page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
>> +            page = cma_alloc_frozen_compound(hugetlb_cma[node], 
>> order, gfp_mask);
>>               if (page)
>>                   break;
>>           }
> 


