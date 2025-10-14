Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 354BDCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925578E0045; Tue, 14 Oct 2025 02:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FCEB8E0005; Tue, 14 Oct 2025 02:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83AB18E0045; Tue, 14 Oct 2025 02:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E95F8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:06:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 066D513BA61
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:06:27 +0000 (UTC)
X-FDA: 83995685214.23.1932C6D
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf01.hostedemail.com (Postfix) with ESMTP id 146274000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:06:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Xjjtj9l1;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760421985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YishKlWjcWfoOsI7rtfQfm39VnY1xSC4FwuToHdPTjs=;
	b=kTy3OT/7eFSmv5x4pQLWXtTal2klAhTqD2zAszch/zGDsJAEz9RKL0nkYbaGrLrv+OnZY+
	wm0GQdi0CJR6FYIENstQnFY5E0HMeWjO0/G4eF3PhMJTvIJRyW6Z4ybXl+bLJZgQa/G3I8
	n7HcxD4/5N+hKdh8lQ5lG5ME6HzAtTA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760421985; a=rsa-sha256;
	cv=none;
	b=KFxrwMSs1/mYTw4lLwaMlsuqRuFv/mGlia32QwpD3EtWmhscUr82v3iwrjU0PMAfGmW6dO
	J/J7WC+x6boi8NEUfsPm/Pe+ozJwOY9vTz+nksVVi/MyFLrswZAa3IiWeMm8lpEt/eKwbe
	oH9TT/lGKaXao9THLqHYry0DasEbh9E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Xjjtj9l1;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YishKlWjcWfoOsI7rtfQfm39VnY1xSC4FwuToHdPTjs=;
	b=Xjjtj9l1ChA6JZ6YLBja4Mv1IMWtF39G5PG2+1E526cK4YSa42dbsFjc5BJEwaWe5ro9n+7ma
	J0bOcYuAZXkrk6Pk+qX/hEqJ4HhILP3cj6MM63zHO26yM+84ydCrlYXyRkqI0Ow+UgvFQEa8FRd
	DDlf3vTYkCJfNx8GvgNtV5M=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cm3cM2cXvzKm9X;
	Tue, 14 Oct 2025 14:05:55 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D68BA1A0188;
	Tue, 14 Oct 2025 14:06:14 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 14:06:13 +0800
Message-ID: <4469b9c3-3656-44f5-897d-b024e030587f@huawei.com>
Date: Tue, 14 Oct 2025 14:06:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: mprotect: avoid unnecessary struct page accessing
 if pte_protnone()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
 <93d00bb0-8aa7-4f52-b9ba-ef777ec191dc@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <93d00bb0-8aa7-4f52-b9ba-ef777ec191dc@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: xg4kg1miy4kdoiebibqj75w6atwqkc6j
X-Rspam-User: 
X-Rspamd-Queue-Id: 146274000F
X-HE-Tag: 1760421982-899228
X-HE-Meta: U2FsdGVkX184aA1/YTpH+CnM9vTkRZgT+rJ/HrYyVlRdLKROREsBbL41MkopAktT7jvbOXDNKUAs8/kB2hguId6VNq7X+Vdend7fr9RMBOAYMO3Ei3BOHLzOx21b0u4Nsr413nU/T6VXAMw+rpJCLojcSWhuHtGpXswLm/MMTEFmiP5eK1C+huGWvSYn4QMoyzGgoFvc8TblQGd6j874uKqX+4O91T68zQs3uhL/FHGIdUGPrv0oY3ghTVgXqCQh0ri0By6kUJZt7odXgQxKx7rIqoPWxFIO2GbwJlfACyQuU+BL+g4NoEuU6dIzmQ4vtdBsgj70Kz5bXarC1/3m1dEel2eNSjspgO+2L6TCqsW0e9XCobWX66agPe0B60eNfMZRfBvTk/b8bZRBsrgGjY2vYTaFIWYv+MwgFv+RISRhtKX7OWgknT4dL2KOVqI2EPfOPxYFndB2VxShj81CZ44I/sUuLCByOJxzYxbTYOQ73vA/uA1jX1hL5s4Jnv4uEYl+NdTt0V4sBdTWZBbYYEacYDT5ib8HUz5Ari1rBYAAkPJe+6XBLCpRtAfI0qNDsBrolZlraZSz7XFK8Zt2Q+LZMJG8TO885b8OEKgXon8k3eKF/pTgvWGwMTxGpQHINjhvBstnmOz0OCB1KxrfqaNKaeUX9hWCKtK/BWuu8srv3Seda6G4iNKYV7XSjsdZQUPi8RpX7MVDHvBnfrn+yu7suh1AUGLiKMccyb5KIi5Wz/PthBinvzHcyynhBbsRYaNB4LRwSGUZzZt2k8uZe4SeTO9UXf0qJE92gO7nU9Z4JCfgQj/uBGOs6zPnuQphCnPyB1BArdRsi2Xghhwzrow//qmTmnW6mRouMc6Ltum2JkLK2F1tp5wPJLv0PRs9Q90Xwc+ehRVMIuiHuDWJ65qXMZqGNT5Ioy3EkRoNsk3EFHWOOhNcAZd14LpQbAQ8gCPDU0CPtZEq0YY43fc
 pGAl1ORX
 uwxI05gvdm3A9uBmE1T1Ys8mHtXG+FduKjXi/iLRCFulXK7wejtQ3IOWL654jRJ1PsDvGjwtZQNRb0SANQv4ZVA36uH+GnTCZLpiCmcpnx0CDLVHayRVo8FWwK3q32cnR4R/nvW4wopN3HbyMCU/kLvV0lsGzkgCpo7NXNPJaV31PGAHkl3PiaRTWYZqdEyj4nKyOyr2PzbtuYPi/gj3+OVkbzJwci/QrgZF454OQcOWBIGGNKXMzwICRy+xKoAEgMW9U3vkq2lio+BOhTeXogphmogwWkG+9hLVfSw4b31xym8ce3aGwqWA3zPqkK4wetgGE3lqS8pdBeQEKJq4cTXl1DPMHq4YAVdAv3UckDte7G1O8zAnWso9kIATriAU7gNJk6JzPtdkR84Cu5H6U1SgRIdckU7Ox3tsE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/13 23:53, David Hildenbrand wrote:
> On 13.10.25 14:15, Kefeng Wang wrote:
>> If the pte_protnone() is true, we could avoid unnecessary struct page
>> accessing and reduce cache footprint when scanning page tables for prot
>> numa, the performance test of pmbench memory accessing benchmark
>> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
>> footprint when scanning page tables").
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/mprotect.c | 21 +++++++++++----------
>>   1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 51a28781de9d..0f31c09c1726 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio 
>> *folio, pte_t *ptep,
>>       return folio_pte_batch_flags(folio, NULL, ptep, &pte, 
>> max_nr_ptes, flags);
>>   }
>> -static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long 
>> addr,
>> -               pte_t oldpte, pte_t *pte, int target_node,
>> -               struct folio *folio)
>> +static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
>> +        struct folio *folio)
>>   {
>>       bool ret = true;
>>       bool toptier;
>>       int nid;
>> -    /* Avoid TLB flush if possible */
>> -    if (pte_protnone(oldpte))
>> -        goto skip;
>> -
>>       if (!folio)
>>           goto skip;
>> @@ -307,17 +302,23 @@ static long change_pte_range(struct mmu_gather 
>> *tlb,
>>               struct page *page;
>>               pte_t ptent;
>> +            /*
>> +             * Avoid TLB flush if possible and unnecessary struct
>> +             * page accessing when prot numa.
>> +             */
> 
> I think we should just simplify to
> 
> "/* Already in the desired state. */"
> 
> or sth. like that. No need to mention the struct-page implementation 
> details in this comment. Also, I don't think there is a need to mention 
> the TLB flush when it's really in the desired state already.

Sure.

> 
> 
>> +            if (prot_numa && pte_protnone(oldpte))
>> +                continue;
>> +
>>               page = vm_normal_page(vma, addr, oldpte);
>>               if (page)
>>                   folio = page_folio(page);
> 
> I could have sworn we discussed that while fixing the prot_numa_skip() 
> fallout.

I'm not follow the thread, but we found that vm_normal_page does
introduce regression for mprotect benchmark(libMicro) with
this vm_normal_page().


