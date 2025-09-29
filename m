Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D1CACAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7088E002D; Mon, 29 Sep 2025 03:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EB28E0002; Mon, 29 Sep 2025 03:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC188E002D; Mon, 29 Sep 2025 03:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4AB2D8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:54:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E653E1194C7
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:54:40 +0000 (UTC)
X-FDA: 83941525920.08.CBE9532
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0E71340005
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:54:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Yx1Z/ysK";
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759132479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVpToKISTa8VE/h8x/0KonSGNktaLtqCR9k5a/zcWWQ=;
	b=hFnha8n8ormhG4BDx67Hn8UaEW2PiyqHT+X5F7wZRFdqEqFBvzQus/4UwKdd9JG7yPVXXV
	oMA6aNwZA6LfR7b/eBLsrz1Uj+98+6ySKcAVHj1t9FbRzi79u7PP19aXid5yI8t/hWZXTH
	f5aI/dVrvPMM2js/ZHUs4EUQLEhU/UM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Yx1Z/ysK";
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759132479; a=rsa-sha256;
	cv=none;
	b=Ql3q0LNY4zF5hZ4DyRMJT5vgULYNDKFGRQAkQu3NYJ5eXZvqoVWENfOuwFnm3I55JSeXDq
	oGo0sVSfw2TtSWUsDQKF8aOaYh2Mzjo8fDcRDFVnUHtxWV+BfK95yOH5rfv+lsEWhDcVs8
	SB+37YQY1irTrZMHXxAQBuVPBofBnOo=
Message-ID: <4d13ffd1-25a5-44f7-9d7d-baa8bc576c04@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759132476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UVpToKISTa8VE/h8x/0KonSGNktaLtqCR9k5a/zcWWQ=;
	b=Yx1Z/ysKsp9m+j/fouRP9o5rGGuzMMG87cOpe8a9FM3eXbntfj1TuuB8NDst86aPvi9rID
	6AekzqTQ/Klq9XgQFi/rCzRgv86y7EJrNzUzccesAzKIdf4NLY6NNoXQjxtjKsc+AG8Hjt
	QG+DtlJxBaBF7w72FO2t67L6JTJebrc=
Date: Mon, 29 Sep 2025 15:54:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Muchun Song <muchun.song@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <cover.1759056506.git.zhengqi.arch@bytedance.com>
 <2ddd0c184829e65c5b3afa34e93599783e7af3d4.1759056506.git.zhengqi.arch@bytedance.com>
 <2EC0CBCD-73FD-400A-921A-EAB45B21ACB8@linux.dev>
 <08a4f0b2-1735-4e3b-9f61-d55e45e8ec86@linux.dev>
 <1A84CFB1-FB4F-4630-A40C-73CDE7CA8C21@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <1A84CFB1-FB4F-4630-A40C-73CDE7CA8C21@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0E71340005
X-Stat-Signature: 6ox3haegfmjebibpcoujidjthdsxarik
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759132478-840825
X-HE-Meta: U2FsdGVkX18z27HUiCTjQJIUkikwMmm67rgGFzPZ3qGfMluwXGh0YbjK9u06vv8xUMvqD1GHofANQy7S4dUXv1wm64YxnH38CFSOhF6J4QjkdBDNjx5qCrDihcBDBFqq0WB32Gm/FfQeqJ7db3EYWuWhzKMxPx7nHq+vDKowg5/ZCgZscJrSSig1+/3BXUjw1DmmwMAUB8tdKNAQ5O07V4dB8ZZgK3NpXv3+ECPdGja9+Iv8ALzre2xfVlHBMm0wRKd3f9EkiaJEajc8/vqbiQnoWy18xMyZ7B7ec9aLjCyMbvKIs98ZEfwJ98rdhGOE7mPpQQvqnIoYdksRc5HeVaYcw3nybJ1BSmvxPszwwSXGQrGyMFFKpr+J3BGhx/pgd/BBCP84Bj82joHZdUKiFv2+U9/aR7Ew3oHv0FRtED0ViZxgcvR1ZcWKHa5oOvxj7lYZXXYr4AFVH0pphz0kDBkTMBkRLOOG/DGtIh7L7QW2rp1Jn1Uoz6znaRDmS0QhDeuU2qrf2vBpi5RmlaZR1n//qBJfp5Wy8imlTGlyJ74X2E2yJS30RAggxczHiGmu1f7safX01V4ZOoNR2csrI1TLHTB/arBz92ySrfVxqT+B3CV7w3nqPRFQSVYhACyRATCzuXVTysz4Fj4a5EQ3ApJd9cqlw3Ibt/fX8ZsMCYxdtaRqS+3j79KSn2EOQ1WRyiYh86EzEKC3ISjiSjlnuL0j3OU8PHUUrIDR4x4NIee1jj3p/JlwErjk53vEetWCBZJYpol02SfDjvXlRkygp3gbPXaNmA3m9PE1VWMsrntUPiPYKrp8hsyzCQWxUTg52tD5KWBsDvH0LqjYaZrsTKKdsCkn/fN8CI74SSwG58hM2U3jx8Qw2ySXX4iOxv/5cAQ9br3G8J1J4gZQVargXznFH8rjjRXjzx0keUnPv93t8BmQvOBhy2omkQ9Z+FhydFT/uhrlUIX+26T8flu
 944aZIsd
 PmdZNrtUAeu4rZxDiD/hd3gpQv8KzvWNpPeC/6gofUs01aYi0u0HiipXyPkLNwgxwj0YfD4vu6ZN2pmDbpUHpRspu1+y5X4nj5RednynOq0X71stt7XN+Yr7HwA+1hTHKLFqkdtgD029FWc1AbApQsGk4t2PKBXp3QqSla8tNG5DDD9beH0HRRl3l+bcfKT+aM63w8rRlYgnuiIOdUt1FBxmEiPClgVYquhxlWTPJ+MvTtu/K0BiVYIM3wrBAiDLVCyy4GtQoEcWjtr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/29/25 3:38 PM, Muchun Song wrote:
> 
> 
>> On Sep 29, 2025, at 15:22, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>>
>>
>> On 9/29/25 2:20 PM, Muchun Song wrote:
>>>> On Sep 28, 2025, at 19:45, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>>
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> Similar to list_lru, the split queue is relatively independent and does
>>>> not need to be reparented along with objcg and LRU folios (holding
>>>> objcg lock and lru lock). So let's apply the same mechanism as list_lru
>>>> to reparent the split queue separately when memcg is offine.
>>>>
>>>> This is also a preparation for reparenting LRU folios.
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> ---
>>>> include/linux/huge_mm.h |  4 ++++
>>>> mm/huge_memory.c        | 46 +++++++++++++++++++++++++++++++++++++++++
>>>> mm/memcontrol.c         |  1 +
>>>> 3 files changed, 51 insertions(+)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index f327d62fc9852..0c211dcbb0ec1 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -417,6 +417,9 @@ static inline int split_huge_page(struct page *page)
>>>> 	return split_huge_page_to_list_to_order(page, NULL, ret);
>>>> }
>>>> void deferred_split_folio(struct folio *folio, bool partially_mapped);
>>>> +#ifdef CONFIG_MEMCG
>>>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
>>>> +#endif
>>>>
>>>> void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>>>> 		unsigned long address, bool freeze);
>>>> @@ -611,6 +614,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
>>>> }
>>>>
>>>> static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
>>>> +static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
>>>> #define split_huge_pmd(__vma, __pmd, __address) \
>>>> 	do { } while (0)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index bb32091e3133e..5fc0caca71de0 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -1094,9 +1094,22 @@ static struct deferred_split *folio_split_queue_lock(struct folio *folio)
>>>> struct deferred_split *queue;
>>>>
>>>> 	memcg = folio_memcg(folio);
>>>> +retry:
>>>> 	queue = memcg ? &memcg->deferred_split_queue :
>>>> 			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>>>> 	spin_lock(&queue->split_queue_lock);
>>>> +  /*
>>>> +  * Notice:
>>>> +  * 1. The memcg could be NULL if cgroup_disable=memory is set.
>>>> +  * 2. There is a period between setting CSS_DYING and reparenting
>>>> +  *    deferred split queue, and during this period the THPs in the
>>>> +  *    deferred split queue will be hidden from the shrinker side.
>>
>> The shrinker side can find this deferred split queue by traversing
>> memcgs, so we should check CSS_DYING after we acquire child
>> split_queue_lock in :
>>
>> deferred_split_scan
>> --> spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>>     if (css_is_dying(&memcg->css))
>>     --> retry to get parent split_queue_lock
>>
>> So during this period, we use parent split_queue_lock to protect
>> child deferred split queue. It's a little weird, but it's safe.
>>
>>>> + 	 */
>>>> +  	if (unlikely(memcg && css_is_dying(&memcg->css))) {
>>>> +  		spin_unlock(&queue->split_queue_lock);
>>>> +  		memcg = parent_mem_cgroup(memcg);
>>>> +  		goto retry;
>>>> +  	}
>>>>
>>>> return queue;
>>>> }
>>>> @@ -1108,9 +1121,15 @@ folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
>>>> struct deferred_split *queue;
>>>>
>>>> 	memcg = folio_memcg(folio);
>>>> +retry:
>>>> 	queue = memcg ? &memcg->deferred_split_queue :
>>>> 			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>>>> 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
>>>> +  	if (unlikely(memcg && css_is_dying(&memcg->css))) {
>>>> +  		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
>>>> +  		memcg = parent_mem_cgroup(memcg);
>>>> +  		goto retry;
>>>> +  	}
>>>>
>>>> return queue;
>>>> }
>>>> @@ -4275,6 +4294,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>> return split;
>>>> }
>>>>
>>>> +#ifdef CONFIG_MEMCG
>>>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg)
>>>> +{
>>>> +  	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>>>> +  	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
>>>> +  	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
>>>> +  	int nid;
>>>> +
>>>> + 	spin_lock_irq(&ds_queue->split_queue_lock);
>>>> +  	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
>>>> +
>>>> +  	if (!ds_queue->split_queue_len)
>>>> +  		goto unlock;
>>>> +
>>>> +  	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
>>>> +  	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
>>>> +  	ds_queue->split_queue_len = 0;
>>>> +
>>>> +  	for_each_node(nid)
>>>> +  		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
>>>> +
>>>> +unlock:
>>>> +  	spin_unlock(&parent_ds_queue->split_queue_lock);
>>>> +  	spin_unlock_irq(&ds_queue->split_queue_lock);
>>>> +}
>>>> +#endif
>>>> +
>>>> #ifdef CONFIG_DEBUG_FS
>>>> static void split_huge_pages_all(void)
>>>> {
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index e090f29eb03bd..d03da72e7585d 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -3887,6 +3887,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>>>> zswap_memcg_offline_cleanup(memcg);
>>>>
>>>> 	memcg_offline_kmem(memcg);
>>>> +  	reparent_deferred_split_queue(memcg);
>>> Since the dying flag of a memcg is not set under split_queue_lock,
>>> two threads holding different split_queue_locks (e.g., one for the
>>> parent memcg and one for the child) can concurrently manipulate the
>>> same split-queue list of a folio. I think we should take the same
>>
>> If we ensure that we will check CSS_DYING every time we take the
>> split_queue_lock, then the lock protecting deferred split queue
>> must be the same lock.
>>
>> To be more clear, consider the following case:
>>
>> CPU0              CPU1              CPU2
>>
>>                   folio_split_queue_lock
>>                   --> get child queue and lock
>>
>> set CSS_DYING
>>
>>                                     deferred_split_scan
>>                   unlock child queue lock
>>                                     --> acquire child queue lock
>>                                         ***WE SHOULD CHECK CSS_DYING HERE***
>>
>>
>> reparent spilt queue
>>
>> The deferred_split_scan() is problematic now, I will fix it as follow:
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 5fc0caca71de0..9f1f61e7e0c8e 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4208,6 +4208,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>         struct folio *folio, *next;
>>         int split = 0, i;
>>         struct folio_batch fbatch;
>> +      struct mem_cgroup *memcg;
>>
>> #ifdef CONFIG_MEMCG
>>         if (sc->memcg)
>> @@ -4217,6 +4218,11 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>         folio_batch_init(&fbatch);
>> retry:
>>         spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>> +      if (sc->memcg && css_is_dying(&sc->memcg->css)) {
> 
> There are more than one place where we check whether a memcg is dying,
> it is better to introduce a helper like mem_cgroup_is_dying to do this
> in memcontrol.h.

OK. I will try to add a cleanup patch to do this.

> 
>> +               spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
> 
> Yes, we could fix this like this way. But I suggest we introduce another
> helper like folio_split_queue_lock to do the similar retry logic. Every users
> of split_queue_lock are supposed to use this new helper or folio_split_queue_lock
> to get the lock.

Yes, will do.

> 
>> +               memcg = parent_mem_cgroup(sc->memcg);
>> + 		spin_lock_irqsave(&memcg->deferred_split_queue.split_queue_lock, flags);
>> +       }
>>         /* Take pin on all head pages to avoid freeing them under us */
>>         list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
>>                                                         _deferred_list) {
>>
>> Of course I'll add helper functions and do some cleanup.
> 
> Yes.
> 
>>
>> Thanks,
>> Qi
>>
>>
>>> solution like list_lru does to fix this.
>>> Muchun,
>>> Thanks.
>>>> reparent_shrinker_deferred(memcg);
>>>> wb_memcg_offline(memcg);
>>>> lru_gen_offline_memcg(memcg);
>>>> -- 
>>>> 2.20.1
> 
> 


