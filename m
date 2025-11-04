Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DE9CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 12:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 661038E0134; Tue,  4 Nov 2025 07:10:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6119C8E0124; Tue,  4 Nov 2025 07:10:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DA048E0134; Tue,  4 Nov 2025 07:10:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3ABAD8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:10:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C925E59200
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:10:12 +0000 (UTC)
X-FDA: 84072806664.07.0B9CE5C
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3B88CA0019
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:10:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0SvR9VoW;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762258211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=muowinBjB5u+VBZIerFKK9Iv670g+lCFTaqTXK7kMfE=;
	b=QssxcowjwoTfcyp0/llp3YSU68QE5PrSBP5EBpU+hlU3gOXpUq17ShmPo0HMSB0yNMgqpc
	FWUi9ZjOjau6DPXuUjz7ZXhvXonWw1y/l5XyPUBBxfL3ICFZDv/3YUfFKf6a4RFu96woCX
	Y6av0SBCYs4sTfErXEiY0reIucABSgU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762258211; a=rsa-sha256;
	cv=none;
	b=HZSD1f0TMMxdE6rSZSwZtL9+pBqn9n8m+9Z+E62Xdyz8Mq0wUgpUKq2sQRrFhpsq2VFEBB
	WZ9yd35Xeep/12rvA/0EU9+yC5g4tEpBsN0UG8p33nECumeOeHy+e9t3b4QgupTeVl6054
	Kpyfye5ji2RLLvuV+DXHE+6cFYHlwIg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0SvR9VoW;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=muowinBjB5u+VBZIerFKK9Iv670g+lCFTaqTXK7kMfE=;
	b=0SvR9VoWnt+T2u4dNohjI1F1XGclCpF4gVQDX59MF6RB1AetoxXCPPt0x5HpT6tj7G0EXNQXq
	D+L0xxUHXFYSuOFWuuFq3w9/akt8+DBjAXz1gFhoBNzSQQSXW4ILAJxcR4aqxRLtmR/z7BglSMZ
	1suk62WNhnA8ACmx1hOq6iE=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d16fy4f48zmV6l;
	Tue,  4 Nov 2025 20:08:26 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7B8CE140143;
	Tue,  4 Nov 2025 20:10:01 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 20:10:00 +0800
Message-ID: <c9925b2e-207b-447e-afce-07873406a853@huawei.com>
Date: Tue, 4 Nov 2025 20:09:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Barry Song <21cnbao@gmail.com>, <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-kernel@vger.kernel.org>, Barry Song <v-songbaohua@oppo.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Lokesh Gidra
	<lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>, Qi Zheng
	<zhengqi.arch@bytedance.com>
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <efeb3350-fbdf-408c-92ef-c6eada4a5755@huawei.com>
 <564941f2-b538-462a-ac55-f38d3e8a6f2e@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <564941f2-b538-462a-ac55-f38d3e8a6f2e@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: dgjpzf8e6rdmw6t67oabur5ozo8bf4xt
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B88CA0019
X-Rspamd-Server: rspam01
X-HE-Tag: 1762258209-363807
X-HE-Meta: U2FsdGVkX198ORGizgmSiqFt3tz94PZFQ51i+HRfLwugMcPl4fj+Ib0HbO2cgWLfveNYbH6f+jAlySRbxwoaejal9HtqorJdC2GRqtrYiKnJAdm/0aX7nUkSBen4XVrusqgH7VqDpQXM1LGy41Bd7FkUXmftwfvLuJc56AYVV8qBLXisrIvzn9rHYLaVyejgtzwrIXoG0Gr6UvWRVVB+Y6MUjJDBikAaNQu/ERYxs/4dUQjaByjLSOIo3/ma0Zcb/sLShA+te0hc0UPA9pBk4WQDbIKDnvtFJkuAKUzLnWiyCSjLcIDr5OCU9elEc8aoaU8/8UQc7oZgI03J1rkj6miMhkJEOZXwJheU7DcAxZSX/ZNwRAbpaPwLMluz7B6m1UQJyXYb4nfUXeeIW3yvvSnltFixZFAxXgw5kKMQBkgcVCJYaLFy5l7uBK1uteaR+HhjMLE5lMA7uU7z7tQjlbdmw3fkiH5Qkb30vhTPrqqnEyJfEfSy1CPrnE2MC2TlfY25tfHIpFTmq7x0O6zW7cv6lAw807uQO5gdMVMkLLqG1wTDs1Vbo26oghPguktfnhyWdwrqV1gmGcjaemOMMR/G762ItoOrkGbMc89c5GjAGFEfgj2Ld2qxhSdwFxjgL2lAx64ZurA7zYcQ5Vn/0kFz3YCAAoJtz3raYWdOrAEEW/TN8xAKN9wIpiQ55l7n/e3UgVWFuqP1EXGXJo88z913lJnm4s+pH4JFjWWF7TOi5EbpRIsfImavQCd7S/P5nU6UVNUWBJJiLL3Jemryo6Kb1QTmJ66pQmR/g0IHKLh8fiWpcuqIdVxbfdEitMNkDT1q+SLNlQF4fyPOTuADTSSCkHmR9Nz6tYGPTSd8jryhc2fX7pP7sKdpmySBnNphiC81rGjkalFzM5TLxlM37V02JsCqFR6zv1M6jsqAzUtlZf6xywNSO/ZLT8BxU1ed6b2poz8Ksqwbk6ByMN3
 WcqGUSQp
 xVskgpEufuGBxDkuohPnbKFW2zj8Oh4cjgMSediHfLaHIO+8UXkgsEl23X49innnV0szpOB5OtnG0FzAW0nQCRn1FJh+TySRIoKqztvw5abnWdjv5UA0kHhc1ZcXfUNL6l2wMBr1eGJA6CCmVmPacPl2G/2/cNjYGkD0WzHY56EFpl0m3hg7QbX+A3Y7idAzvOnUokyzTmOVGz9MR3OpJOMwm5ucspdiuKxHHvWpsOaQcxG/EWQs4PBl89vrsG4aeV14earoNWIEvW4rTnmCYp3cOcA4wtCzob2NrxBRMA4y8PeluDzgftgjMmj4MX0gaj+ov0Ht6MqqOwe4FlSUUkx8FGlPZY6xzCGQpPKbuwJ1eM6ZS1WXsKoJpjtbxwj4dVU6+08k2MmVeRvPUkE8WaCEfXzsFL7eGqJk/j4dRgSd+zKPoAXCmGshWa6GxlxgedoWwaDhRr+yiO3g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/4 17:01, Lorenzo Stoakes wrote:
> On Tue, Nov 04, 2025 at 04:34:35PM +0800, Kefeng Wang wrote:
>>> +static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavior)
>>>    {
>>> +	int behavior = madv_behavior->behavior;
>>> +
>>>    	if (is_memory_failure(behavior))
>>> -		return 0;
>>> +		return MADVISE_NO_LOCK;
>>> -	if (madvise_need_mmap_write(behavior)) {
>>> +	switch (behavior) {
>>> +	case MADV_REMOVE:
>>> +	case MADV_WILLNEED:
>>> +	case MADV_COLD:
>>> +	case MADV_PAGEOUT:
>>> +	case MADV_FREE:
>>> +	case MADV_POPULATE_READ:
>>> +	case MADV_POPULATE_WRITE:
>>> +	case MADV_COLLAPSE:
>>> +	case MADV_GUARD_INSTALL:
>>> +	case MADV_GUARD_REMOVE:
>>> +		return MADVISE_MMAP_READ_LOCK;
>>> +	case MADV_DONTNEED:
>>> +	case MADV_DONTNEED_LOCKED:
>>> +		return MADVISE_VMA_READ_LOCK;
>>
>> I have a question, we will try per-vma lock for dontneed,
>> but there is a mmap_assert_locked() during madvise_dontneed_free(),
> 
> Hmm, this is only in the THP PUD huge case, and MADV_FREE is only valid for
> anonymous memory, and I think only DAX can have some weird THP PUD case.
> 
> So I don't think we can hit this.

Yes, we don't support pud THP for anonymous pages.

> 
> In any event, I think this mmap_assert_locked() is mistaken, as we should
> only need a VMA lock here.
> 
> So we could replace with a:
> 
> 	if (!rwsem_is_locked(&tlb->mm->mmap_lock))
> 		vma_assert_locked(vma);
> 
> ?
> 

The pmd dax/anon split don't have assert, for PUD dax, we maybe remove 
this assert?




>>
>> madvise_dontneed_free
>>    madvise_dontneed_single_vma
>>      zap_page_range_single_batched
>>        unmap_single_vma
>>           unmap_page_range
>>             zap_pud_range
>>               mmap_assert_locked
>>
>> We could fix it by passing the lock_mode into zap_detial and then check
>> the right lock here, but I'm not sure whether it is safe to zap page
>> only with vma lock?
> 
> It's fine to zap with the VMA lock. You need only hold the VMA stable which
> a VMA lock achieves.
> 
> See https://docs.kernel.org/mm/process_addrs.html

Thanks, I will learn it.

> 
>>
>> And another about 4f8ba33bbdfc （"mm: madvise: use per_vma lock
>> for MADV_FREE"）, it called walk_page_range_vma() in
>> madvise_free_single_vma(),  but from link[1] and 5631da56c9a8
>> ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock"), it saids
>>
>>    "Note that similar approach would not work for /proc/pid/smaps
>>    reading as it also walks the page table and that's not RCU-safe"
>>
>> We could use walk_page_range_vma() instead of walk_page_range() in
>> smap_gather_stats(), and same question, why 4f8ba33bbdfc(for MADV_FREEE)
>> is safe but not for show_numa_map()/show_smap()?
> 
> We only use walk_page_range() there in case 4 listed in show_smaps_rollup()
> where the mmap lock is dropped on contention.

Sorry, I mean the walk_page_range() in smap_gather_stats() called by
show_smap()  from /proc/pid/smaps, not the walk_page_range() in
show_smaps_rollup() from /proc/pid/smaps_rollup.


> 
>>
>> Thanks.
>>
>> [1] https://lkml.kernel.org/r/20250719182854.3166724-1-surenb@google.com
> 
> AFAICT That's referring to a previous approach that tried to walk
> /proc/$pid/swaps under RCU _alone_ without VMA locks. This is not safe as
> page tables can be yanked from under you not under RCU.

But for now it tries per-vma lock or fallback to mmap lock, not 
lockless, so do you mean we could try per-vma lock for 
/proc/pid/numa_maps or /proc/pid/smaps ?

> 
> Cheers, Lorenzo
> 


