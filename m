Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA3ACCD196
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63CD8E0019; Wed, 15 Oct 2025 04:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B538E0002; Wed, 15 Oct 2025 04:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77FC8E0019; Wed, 15 Oct 2025 04:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A49B38E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:50:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 678841A0978
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:50:56 +0000 (UTC)
X-FDA: 83999728512.15.80D909A
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2DF99160010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:50:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vDORZKbz;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760518254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Aff6UWucet03xCuuR3gGl7WpAj11Cx7rcc7d8WgQ2s=;
	b=EIoTNm8yG5ldsau1y8MIITsxZ2Zn9jPp/VDnQHNN2DZOmqt0sPT84kbjOoqszLHk27tin2
	tOpFrTSc8udyzR8REtteH+l/2FQdTLX4741MgY+voybmrcfju1x9fCpsHFwoNU1RG28cBN
	3J7t54OUbPBc0Uxu9MwewdkmRIRmOig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760518254; a=rsa-sha256;
	cv=none;
	b=MyhAF8JTdMfilrdzZ8Xr8spomTwhsG6fXbG/p/T7e2qaqeMauMu27wIi7wO8XEW32HfQAT
	EvW+Mh+GzUYHOpWWm7x5BKomrNHCkSja5bQa8+1DdBixtexTgaH5oOtuKD0Afj7gpOU1Qk
	vSc2I9FouufVPWTDTI2cYCV28a9cYTk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vDORZKbz;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1Aff6UWucet03xCuuR3gGl7WpAj11Cx7rcc7d8WgQ2s=;
	b=vDORZKbzGAY6WMT3QD/oqUbe8+evLJYQDlJLxR0nvewseXXqrykpTSK3yrURV8hdAflbvDZ/2
	weybBn6GobbckpRCPF3ZrnBt1DhM6WRNmEj8a095+3zfS3hwte+PKAngr0/LI8AQLwDMa4BDPUt
	1d7WwZlYIUW5rLbz601rrRU=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cmlCm2G9KzKm6d;
	Wed, 15 Oct 2025 16:50:28 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C1101400CA;
	Wed, 15 Oct 2025 16:50:48 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 16:50:47 +0800
Message-ID: <cd9462ce-eb0e-49ca-b2dd-49f92298d53e@huawei.com>
Date: Wed, 15 Oct 2025 16:50:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
 <20251014113349.2618158-3-wangkefeng.wang@huawei.com>
 <1562a70d-6778-41cb-be30-c83ca7eab373@arm.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <1562a70d-6778-41cb-be30-c83ca7eab373@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Stat-Signature: ogyupsh9zdybz1p76qxh3y7cj5fyijo1
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DF99160010
X-HE-Tag: 1760518252-527349
X-HE-Meta: U2FsdGVkX19H5Y3LcaIeSHQWL9n2PaG3oi8Cr5fwn4Qj6VhxhYsTAh3vw1jgBlYQ1vnjiMUU/zZ5bW7RyMAkXgm9uEbEQlVmOeEB/JRrfJ5xpMbMfQHuSnXyM10q4gdJyu9bIGeWp0bDDY9glq4b4TIvjzfB/AO5OSeeEY76kZMRhitP0RwtaHbNERbJI4XBNageGUKLK95e4Ygcy3iHsOj2D7qDB/EZ8Vx4VPkIMKEFOTlk3wymapeXfNg0cTtUeKizbQeGM4A+/eRtm1uA8eOSfvnvgNaChfWp4/A4rWKaybQSe9VgleQPxNDvzuRaDxVBcL0GGEg2vms7zMUdgGPQi8W3FYHWFM4q+mXjLtFSVEShxyl7S7EmWpWEWbbUE61qURywb1nyUHS7eS6K3Lo9WxfevIMOHEdHigw7+YV9tjLfK1YTGgCF39m++NRzYajELmP8AiNG7WP+9XmaWBlQ7me8m5Msxv/B8srBKjQqtP0JUbp8Saf/jUzlxZVcWYVO6MTv9JaXkjB75AYCzEjjAi87p44JO0Ei5Py6Z9NLwJP76SnSs2DwjvhqKTu4wpX9yeEJpkbURtX3W8WDalXxM2f41T9hBkh7Ba+TKUqRRMyCaelGjJAmkKsV0O7Dz1bSPS+UsIOsQ+t61+vPpA0leCcHiYzJCTaFmXOjQ+mCO5kbItzOt0T+uqdXdXExJ863uE29SVJsDl1oJNOEBuL30pqQDfz6Rf2aX0M4eQEP/gAdIlAT2sF83dgJPEeAyzD3E86+dbkK92WEguIV0y9ttMj/F2K8eX17G+Zzhf/KrVe9FYY70CxasgUzZYQpGoF4YzbAloM6+Q4dpOIENjJpY4Z3TesLF3R2W1Wox/EIveHbjIReZ4hZ1z+ZYkStpPIjuEazyPgea4CdCF7+yXJdVbObXYUcDKqKVOv99wwKR/OP4/VNycRsNlaeVZ/kVWWPeJTBG8IodkTIbXV
 zXEusKGA
 z7xv/hvDTE4eg2r7DEzSeA+Cw7h57g7UZhEmgbWIkdcpIasMq2TKfa8INnOlLjx88vVTtZVb6vjdr4bbWyloKnWYky+nhipkO9gefUppM2mzO/ZfZSiFXBLMXfYuuehJzFMKuCdccuzIaGCcn96TzqmzVkyhl5PA+vQi7AUFDqRgOzbow4j8l0aq0etTRvyLWUAkHFPtuWPXIkSN3j/2VTAoqjeYqZNBL5bGtHPQhJM39/rFy4H9EfTCNq55nzSL6eahPC0BcZsUYgOyXBHv1NBhcMKWvT0E7JGRu6UpsJoFiC0BEi/5VEltSDPqHOyQxsjLOzQKo1tjuDwGj960MSX5rJLj1dZQe3MHGE168eGo5lGQLQxungWsr2jwt/7aPCTh4dXzz0QEZa18CeWUmuglkVrIuYl3WwZI0G00Avt0TB39R6TMEmWbSQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/15 15:32, Dev Jain wrote:
> 
> On 14/10/25 5:03 pm, Kefeng Wang wrote:
>> If the pte_protnone() is true, we could avoid unnecessary struct page
>> accessing and reduce cache footprint when scanning page tables for prot
>> numa, the performance test of pmbench memory accessing benchmark
>> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
>> footprint when scanning page tables").
>>
>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
> 
> Thanks.
> 
>>   mm/mprotect.c | 29 ++++++++++++-----------------
>>   1 file changed, 12 insertions(+), 17 deletions(-)
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index bb59a42809b8..7affa88a6de7 100644
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
>> @@ -307,23 +302,23 @@ static long change_pte_range(struct mmu_gather 
>> *tlb,
>>               struct page *page;
>>               pte_t ptent;
>> +            /* Already in the desired state. */
>> +            if (prot_numa && pte_protnone(oldpte))
>> +                continue;
>> +
>>               page = vm_normal_page(vma, addr, oldpte);
>>               if (page)
>>                   folio = page_folio(page);
>> +
> 
> Unrelated change but I guess this is needed since we usually leave a line
> before starting a comment.
> 
>>               /*
>>                * Avoid trapping faults against the zero or KSM
>>                * pages. See similar comment in change_huge_pmd.
>>                */
>> -            if (prot_numa) {
>> -                int ret = prot_numa_skip(vma, addr, oldpte, pte,
>> -                             target_node, folio);
>> -                if (ret) {
>> -
>> -                    /* determine batch to skip */
>> -                    nr_ptes = mprotect_folio_pte_batch(folio,
>> -                          pte, oldpte, max_nr_ptes, /* flags = */ 0);
>> -                    continue;
>> -                }
>> +            if (prot_numa & prot_numa_skip(vma, target_node, folio)) {
> 
> Why not "&&" instead of "&"?

oops，will fix it.

> 
>> +                /* determine batch to skip */
>> +                nr_ptes = mprotect_folio_pte_batch(folio,
>> +                      pte, oldpte, max_nr_ptes, /* flags = */ 0);
>> +                continue;
>>               }
>>               nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, 
>> max_nr_ptes, flags);
> 


