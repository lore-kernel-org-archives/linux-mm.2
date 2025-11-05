Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D708CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 01:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038218E0006; Tue,  4 Nov 2025 20:04:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A498E0002; Tue,  4 Nov 2025 20:04:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A528E0006; Tue,  4 Nov 2025 20:04:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF2BE8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 20:04:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5DF50140121
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:04:55 +0000 (UTC)
X-FDA: 84074758950.20.B006ADF
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf23.hostedemail.com (Postfix) with ESMTP id D3DE6140005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:04:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YyPBOKz8;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762304693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwhJO6D1YRqJyWqNTP219TL5jK04SEJ2/5eraLPP68E=;
	b=ov4nVj+HJAqynYtkbSUBTk+R8ExGWRYhwcFc3DAgKIrPVeJAi3Ar185Dm5nN/wdSWw0xcH
	1cJFHA2BF4A0D/Wtk5NZvmFQz95M/FArZ40o/N3lYx9AXapVt7j7y5Q0deXMj8aOLvqbSv
	pgh9lPrq8e9/nPLxwPYKLoxcI3CCfdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762304693; a=rsa-sha256;
	cv=none;
	b=BvHbLHayKOVnufiKWocXG5YeuXlQO9St+EI+kIsE/AyX4/PGyFOM5zdNMTBlgxmpnYzy1V
	Tjiszn/MIY51TFGdHTzErODSqX6urC/u04VkAIRiQNo3FNa76Vhlu/w9IKTKiBrCLSCL4M
	2NrChSJ2GyTlgrZQ8Pvn639YAj8VlMM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YyPBOKz8;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CwhJO6D1YRqJyWqNTP219TL5jK04SEJ2/5eraLPP68E=;
	b=YyPBOKz8KlSTPlZmtrXSfd1exx5/7AM8+l+NIdMItrrelTblzNAr/vAe6rMUT2v10CWlSjnPd
	NSg5NGaqmsITjCQhW0kn3dQHSzSKg+hObriQq4alXHUBlo5BaSaLrfJTjaw2L06a4mvCxeUaLoS
	hTy5terBnIr/JV3RPhkoql0=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4d1Rrw2HVYzRhxs;
	Wed,  5 Nov 2025 09:03:12 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id CE120180080;
	Wed,  5 Nov 2025 09:04:46 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Nov 2025 09:04:45 +0800
Message-ID: <545c6e40-db22-4964-868a-74893d6ad03f@huawei.com>
Date: Wed, 5 Nov 2025 09:04:44 +0800
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
 <c9925b2e-207b-447e-afce-07873406a853@huawei.com>
 <7998c1f1-fd53-45e9-b748-55043522f1c7@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <7998c1f1-fd53-45e9-b748-55043522f1c7@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: hahsaw4o1xfhgugzw7aahgeb8ctn7cb5
X-Rspam-User: 
X-Rspamd-Queue-Id: D3DE6140005
X-Rspamd-Server: rspam01
X-HE-Tag: 1762304691-605290
X-HE-Meta: U2FsdGVkX1+oojFyRVGn7h4oxRKR5E12RoZSRzs7zhrL5wjCd6Jv1PXwyjtK2ecrbjDbF6GLJYHh+J8Kyfy0TDEcsz0IzQzemTySno2qhgpmbThrVRZgj89Jqr23p1JmtVbD6K4kUd/v2dW7+OJcG7c5h8sgQnKL43JDTzcy9P8Ot3hIHwhetCWa9TQjfAnukw5AAbYK1ES2RQSD8nZA6kNrcTTWc2IY8t7YxWTusSguKx3HaKQlPnGjyEc5uflByqH9c+mmPI0TVdg2hvZT/Fjf8boV+tOxs/yW4+Pn0BikuhAjL+QPYwHd4uv3FdiYfRT1wppHcv/P1fQsehf3FMeJx7lHuLXlK3dyRw9G3eK0+9dwLFk4s/Ig0tY+27Jdb/QvqCmi+818Xpn6MBkCdJDSkbz/8V9ngvfuxK9dEpsWnv6bgegYvrUOZtCXBUgMWY1MxF0jMzCic7chRaOS0QE+m6HOSX1Fk041pwbMjjClltq3bg7sUZqjb8e/G0m0uoWJmLEHMKoVZNg/IUZlgaXTP/lWBcgm3qH9LCfE/I9XUBL1Q8b78mIqkmbG7nZwhbPBM4sHcsciORkJ4xytoTj1hiKDhx5arHg7oBXPL0E9dZSCbnFWjbjGM73jOaxIO0OaIRJ/DkKxloVAR32i9cFMNztfex4THBIPjsJI3yLdGlEBcZJwZnytFwbSHsCr6qq/nGY8AmpRD/H5s4WU1m4sZZ4xPBeOj5z+H7yyxlGsHa7QWimrzcE1KVbjIr8aVH0IriTos3vEaSzc0tzjtHgnk79oyY6WGO+F8STnnukn/XvAFDprDR+Gv4wPg0oDw/QcbGnxSRjtE+fiBiiKsY+TUyiwwmSGpZIAL5IOuiTHXfh6svrH/4DglDyatwd2zqAeMPZCQH8K7/9RnhgpLKyDPPGIvVVjTpXdLBnCmluRClA3Jkr52VljS98NsFSna1FRcS5hX2cnHzzn7zj
 EgpeSaxg
 wVHbzpth7VRpN0uKr6Kqk8RrUPKCDLPQRlqT1bcGfKAA/vsaANfEqqXuw5QNHBTTEOSvQvc8DB27B2iT/82qkAKUY1JSn15iiRsJLKi0EzYeDICx2t2BdOtre38MAtn89i7Z/Ra0UPMbr1f7pAgW8cQ/7Sm7uEz9Wc7kx/C5a7wkeiiIoCEUXNS7/DX/Elq71agSJGmfXfUu+1f7YLXOSA3QnAr7ZYyLvbocLm0Vtt2F1clDaYSbZq1SqOwOjPSrwpwr+2Q7DA+a0eADsWVrySg9/xaJcZqCmJCywQDXdyIWWGLtZbc/vGYnPdtSZTLT9+4pDlFrvZDXFOeDNHoqXD5vCpiU4IEPoxiqsMUmxLr4oHd4mInJdwfnV2qf+gLMBZInb+51FC/tT/GHGc82qQleZt1A8NbnszFGMtdpc/zdqfcbr5rUR0/+fCfHPj+xDDDrrXc9yokFhWHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/4 23:21, Lorenzo Stoakes wrote:
> On Tue, Nov 04, 2025 at 08:09:58PM +0800, Kefeng Wang wrote:
>>
>>
>> On 2025/11/4 17:01, Lorenzo Stoakes wrote:
>>> On Tue, Nov 04, 2025 at 04:34:35PM +0800, Kefeng Wang wrote:
>>>>> +static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavior)
>>>>>     {
>>>>> +	int behavior = madv_behavior->behavior;
>>>>> +
>>>>>     	if (is_memory_failure(behavior))
>>>>> -		return 0;
>>>>> +		return MADVISE_NO_LOCK;
>>>>> -	if (madvise_need_mmap_write(behavior)) {
>>>>> +	switch (behavior) {
>>>>> +	case MADV_REMOVE:
>>>>> +	case MADV_WILLNEED:
>>>>> +	case MADV_COLD:
>>>>> +	case MADV_PAGEOUT:
>>>>> +	case MADV_FREE:
>>>>> +	case MADV_POPULATE_READ:
>>>>> +	case MADV_POPULATE_WRITE:
>>>>> +	case MADV_COLLAPSE:
>>>>> +	case MADV_GUARD_INSTALL:
>>>>> +	case MADV_GUARD_REMOVE:
>>>>> +		return MADVISE_MMAP_READ_LOCK;
>>>>> +	case MADV_DONTNEED:
>>>>> +	case MADV_DONTNEED_LOCKED:
>>>>> +		return MADVISE_VMA_READ_LOCK;
>>>>
>>>> I have a question, we will try per-vma lock for dontneed,
>>>> but there is a mmap_assert_locked() during madvise_dontneed_free(),
>>>
>>> Hmm, this is only in the THP PUD huge case, and MADV_FREE is only valid for
>>> anonymous memory, and I think only DAX can have some weird THP PUD case.
>>>
>>> So I don't think we can hit this.
>>
>> Yes, we don't support pud THP for anonymous pages.
> 
> Right, so we can't hit this.
> 
>>
>>>
>>> In any event, I think this mmap_assert_locked() is mistaken, as we should
>>> only need a VMA lock here.
>>>
>>> So we could replace with a:
>>>
>>> 	if (!rwsem_is_locked(&tlb->mm->mmap_lock))
>>> 		vma_assert_locked(vma);
>>>
>>> ?
>>>
>>
>> The pmd dax/anon split don't have assert, for PUD dax, we maybe remove this
>> assert?
> 
> Well, we probably do want to assert that we hold a lock.

OK, let's convert to vma_assert_locked.
> 
>>
>>
>>
>>
>>>>
>>>> madvise_dontneed_free
>>>>     madvise_dontneed_single_vma
>>>>       zap_page_range_single_batched
>>>>         unmap_single_vma
>>>>            unmap_page_range
>>>>              zap_pud_range
>>>>                mmap_assert_locked
>>>>
>>>> We could fix it by passing the lock_mode into zap_detial and then check
>>>> the right lock here, but I'm not sure whether it is safe to zap page
>>>> only with vma lock?
>>>
>>> It's fine to zap with the VMA lock. You need only hold the VMA stable which
>>> a VMA lock achieves.
>>>
>>> See https://docs.kernel.org/mm/process_addrs.html
>>
>> Thanks, I will learn it.
> 
> Hopefully useful, I made it to remind myself of these things as they're very
> fiddly + otherwise I find myself constantly forgetting these details :)

That should be definitely useful :)

> 
>>
>>>
>>>>
>>>> And another about 4f8ba33bbdfc （"mm: madvise: use per_vma lock
>>>> for MADV_FREE"）, it called walk_page_range_vma() in
>>>> madvise_free_single_vma(),  but from link[1] and 5631da56c9a8
>>>> ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock"), it saids
>>>>
>>>>     "Note that similar approach would not work for /proc/pid/smaps
>>>>     reading as it also walks the page table and that's not RCU-safe"
>>>>
>>>> We could use walk_page_range_vma() instead of walk_page_range() in
>>>> smap_gather_stats(), and same question, why 4f8ba33bbdfc(for MADV_FREEE)
>>>> is safe but not for show_numa_map()/show_smap()?
>>>
>>> We only use walk_page_range() there in case 4 listed in show_smaps_rollup()
>>> where the mmap lock is dropped on contention.
>>
>> Sorry, I mean the walk_page_range() in smap_gather_stats() called by
>> show_smap()  from /proc/pid/smaps, not the walk_page_range() in
>> show_smaps_rollup() from /proc/pid/smaps_rollup.
> 
> show_smaps()
> -> smap_gather_stats(..., start = 0)
> -> walk_page_vma()
> 
> Because:
> 
> 	if (!start)
> 		walk_page_vma(vma, ops, mss);
> 
> The only case where start is non-zero is show_smaps_rollup() case 4. So we are
> already using walk_page_vma() here right?
> 
> I may be missing something here :)

You are right, I don't check start value :(

> 
>>
>>
>>>
>>>>
>>>> Thanks.
>>>>
>>>> [1] https://lkml.kernel.org/r/20250719182854.3166724-1-surenb@google.com
>>>
>>> AFAICT That's referring to a previous approach that tried to walk
>>> /proc/$pid/swaps under RCU _alone_ without VMA locks. This is not safe as
>>> page tables can be yanked from under you not under RCU.
>>
>> But for now it tries per-vma lock or fallback to mmap lock, not lockless, so
>> do you mean we could try per-vma lock for /proc/pid/numa_maps or
>> /proc/pid/smaps ?
> 
> Probably we could, but I'm not sure if it'd be really worth it, since traversing
> page tables is a very heavy operation and so optimising it against contention
> like this seems probably not all that worth it?
> 
> Suren maybe could comment on this.

They only operate a single vma(walk_page_vma), I think it is always 
better if we could only hold the vma lock, but wait for Suren comment on it.


