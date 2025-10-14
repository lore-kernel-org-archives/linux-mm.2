Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BE6CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB3C78E004B; Tue, 14 Oct 2025 02:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89D88E0005; Tue, 14 Oct 2025 02:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F938E004B; Tue, 14 Oct 2025 02:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4B848E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:11:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74BED13BA80
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:11:08 +0000 (UTC)
X-FDA: 83995697016.03.870C44B
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf09.hostedemail.com (Postfix) with ESMTP id C48AB140004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:11:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ql+oU+Bp;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760422266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYeipiQqVCMoF06AGBtM8TxiIU3OmSmtIj2DkFQ3rzI=;
	b=UrYTpi0Huh/TFwXcg8nnlo1UQmuFkMEx6WAay5ehnXor6PWOC0ePeV8O0hsl9DdfwPLLBw
	QVw/aogNx175fW7IKU6yiu6ia05bstJa2RT1MjFDfPgegkjjAe3LaglEFrqEMgoad/BVXn
	vy7LLCO0xU9YXeAqliFX0F4/DqDLkY8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ql+oU+Bp;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760422266; a=rsa-sha256;
	cv=none;
	b=FIMAVD5C0LNPe3RPoz/IOsPjp2IDhwcv+rmfd5c7NdO8J051ntrPS9ndrVfMj5DIieVEaY
	3oxBs9CUVXbVm7Os7PSjlCtKJaklPbnx5ZmtHGARGihg77IvOOInKAqO4fQYkEkQ1Bdq39
	HoKYFVGkpDxq4z/JJCZ+YsNj13RyAMg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zYeipiQqVCMoF06AGBtM8TxiIU3OmSmtIj2DkFQ3rzI=;
	b=ql+oU+BpO1lXFera4KzsqCuSY4rvMP8j9TgEDeYlPD0tzrDK50QDke+ODkemfysKprnQgrtum
	62i3+GVECLR/FLhVxCBymuPljUqONVEH1U8XEfL8kSG3zZhlqyfJx8GBBZkPMHO0BPyRBDjDQqS
	wNJwWft21jgRyBl1zVHRdKI=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4cm3jL6cGyz12LFQ;
	Tue, 14 Oct 2025 14:10:14 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id AD2A11400D4;
	Tue, 14 Oct 2025 14:11:00 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 14:10:59 +0800
Message-ID: <c4feff94-ea84-4610-a836-e1f2ebf800a9@huawei.com>
Date: Tue, 14 Oct 2025 14:10:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: huge_memory: use prot_numa_skip() for pmd folio
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-4-wangkefeng.wang@huawei.com>
 <c31abe19-f13c-49e7-b305-d899536ce9bb@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <c31abe19-f13c-49e7-b305-d899536ce9bb@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C48AB140004
X-Stat-Signature: g4tpc5hyb8dgnoqjbymrgqd4gmifszcq
X-Rspam-User: 
X-HE-Tag: 1760422265-124580
X-HE-Meta: U2FsdGVkX1+ulyWHryzBXZCYj757IW1iY/vhWHRciIeJOiGC5DFadhN0vNPC2+g9gk44J2i/EczFkJ9WhYGkjTUb800vagMXluP1az/Bk+rwqIqXxAkQWm87mPLx38kmq8hEaUUniz48hQ+sUJ3IKH9ghgD56kRaFNzpB1U05p0ZoJ/cG6MeXUGMK1VxYqLqdMfcGDRMUKInK/rAZCCd+6omWDkhC5LDUus1G/po7uWUXrPPND9XG1TKJNWCXsL+I5R51D1y1H3KOA1+SR6BgrAGLwc7rcNOWjF3OQ61FksvsVOAcHg/VVA4s1s3vLQb2bqxjirR90pLNuE38pTb3VihFpkYf0h2U+9y7alLPn3WQejYHjiMX5duC607OmwzzEwAaNQWhZVC4qnqUSkKOXkV1NsIaJx1apFtWHwXAuhweUysyuAY8Q1HAFB/qnzgn76c7E8aKXcUpFlEKhjU88jS+nlBbIn6oFvw1Gm1hQrk+Ar+RNiuVnER6n9DeWPwjtRgg9MmHUH9vA4DovhyZBLdoUe9WCnKQmxoDKJQ4Rp/CKCwxAksQY5MbaewoiEKWRoBsNewgDxQca/dOK9zVVL56aE5SOlYrn4tlgWm5rm4LgH9EgGoAOuUEZ140UUXiJO8oZIVBOLwQAeW5slpe6+QY+K9sftzR3pTB335EeRNrfrvEU0JPCuxNvvNTOyHMtnZeDGefuQVioDtknbmZF39lceDeoHOYsTngfBjSl4jkf5Mran+N+9RCJdMTtWlgPskIRHBhOcvznoS2eNaI+wEXcYXkSS1BcRGT0jXKeCAGiKRSM7ilHMvNWkrcT3jMqchSlYL6Jzaf5DpQoju3goYwJK1IWty03Ut2iR0krfi7jTHXGCHVmbKAa3jiJcegzqih0mY0h4qLfYKpezY5RacGpXRm9qwQ8Ye71u8iCUo/1BfJ3JR4Xp9CbNBW2QkGFrogvv+DywWsqOgOL5
 DJToweZf
 T2ryAvsrkTDx/w2gPg08fsmKVLFoSUpAOHp1dm//fWC7ZRYjgjzRdtV0RWa6djY0AP9AFXeRUEnoQI5Y8gWg9vlgbF2YLCslOpWPGIemOkcVWqgnlOzceZ+ddreetRc/Q0Gx4EktjN53I0PZrNwsTtyK+N+HuerTkpviQ1Sy4D4Les5jLxenhCvOw8hbxhMSWzliPmC2+ZLM6QpGmC6LjML4sinA4/IS7S8+0RBOAaUUMV2vqyS8sAEfivcU7I9MgUbzK2tBIkgeOAiIKxP0CNWrz+AJs/C1rz+7kAf1k/8JHU9P2BTvXaD71WOsjj8rR+FgcIQCbk/rdVGTYk+TD3ekswk+82f5uA0zyj3B4M/V7ZOKhz5PLkfV7m3vOeDV8+GVfISx3PaSdF2UyfuqQUn9iVibPsHgPAsPA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/13 23:58, David Hildenbrand wrote:
> On 13.10.25 14:15, Kefeng Wang wrote:
>> The prot_numa_skip() checks should be suitable for pmd folio too,
>> which helps to avoid unnecessary pmd change and folio migration
>> attempts.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/huge_memory.c | 21 +++++++--------------
>>   mm/internal.h    |  2 ++
>>   mm/mprotect.c    |  2 +-
>>   3 files changed, 10 insertions(+), 15 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1b81680b4225..feca5a19104a 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2395,8 +2395,7 @@ int change_huge_pmd(struct mmu_gather *tlb, 
>> struct vm_area_struct *vma,
>>   #endif
>>       if (prot_numa) {
>> -        struct folio *folio;
>> -        bool toptier;
>> +        int target_node = NUMA_NO_NODE;
>>           /*
>>            * Avoid trapping faults against the zero page. The read-only
>>            * data is likely to be read-cached on the local CPU and
>> @@ -2408,19 +2407,13 @@ int change_huge_pmd(struct mmu_gather *tlb, 
>> struct vm_area_struct *vma,
>>           if (pmd_protnone(*pmd))
>>               goto unlock;
>> -        folio = pmd_folio(*pmd);
>> -        toptier = node_is_toptier(folio_nid(folio));
>> -        /*
>> -         * Skip scanning top tier node if normal numa
>> -         * balancing is disabled
>> -         */
>> -        if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
>> -            toptier)
>> -            goto unlock;
>> +        /* Get target node for single threaded private VMAs */
>> +        if (!(vma->vm_flags & VM_SHARED) &&
>> +            atomic_read(&vma->vm_mm->mm_users) == 1)
>> +            target_node = numa_node_id();
> 
> Wondering if we should move that hunk into prot_numa_skip() as well.
> 
> I'd assume numa_node_id() is not particularly expensive?

There is a atomic read, it may be expensive for 512 times atomic read
for change_pte_range().

> 
> While at it, I think we should then rename prot_numa_skip() to
> prot_numa_skip_folio() or better "folio_skip_prot_numa()", making folio 
> the first parameter.
> 

OK, will change it.


