Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F91CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18C58E0028; Mon, 29 Sep 2025 03:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0238E0002; Mon, 29 Sep 2025 03:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CF08E0028; Mon, 29 Sep 2025 03:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 813E48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:22:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28F28C0286
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:22:56 +0000 (UTC)
X-FDA: 83941445952.07.B40B4CF
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf27.hostedemail.com (Postfix) with ESMTP id 440EF40006
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:22:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VYslHZ0S;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759130574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=496tR+1nCfJ5pMJ3flSASce4X+8Hs2xr9YohPB9v6U8=;
	b=RcpUppJMIjCIj1BwUXhb5G9BByH50xUwKSEaCjBl/wO86Wsb+j5dspgDB+TzS0yowTnppK
	f7wszc+cyuAFERyuwmgwpcpbAxZWrOCX9Yi+Z+slg7uq2Myp++2OAw3Nn1z9WifhrDRRy3
	1q6Bty8EqxnQx4eu0CsDX8PXmD9Kn2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759130574; a=rsa-sha256;
	cv=none;
	b=BdBRghvYBct9ur8+HmneZT12tiflJKN8rRfyy3KGrErKZLtzDkQrgaGqM3fv1GukzdndWO
	+oOvaW5LKyg/Nk8fe2IO+fCCbRhfbU4Nupr8cIslvs9c88yqYCA2zfEps/Dn78z6Wy6ivz
	zMH2m+4co4N+xaSxI37AIQ1yYfAL3G8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VYslHZ0S;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <08a4f0b2-1735-4e3b-9f61-d55e45e8ec86@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759130571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=496tR+1nCfJ5pMJ3flSASce4X+8Hs2xr9YohPB9v6U8=;
	b=VYslHZ0SqUSQSRUI8LkqSa1EC3AisZePf4ZJzWMHfC02EaHIkI9ZXeUF/4HzNIL3jIrqe2
	mbsc9HhAiRNJUl7tBA0kVCnsbte9jCiKP3iRYGU8CW6aw/citZryM34Od2wQMQvxN/28Qn
	g3LWMqieR6IJpupFArem/kJUcklhqn0=
Date: Mon, 29 Sep 2025 15:22:33 +0800
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
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1759056506.git.zhengqi.arch@bytedance.com>
 <2ddd0c184829e65c5b3afa34e93599783e7af3d4.1759056506.git.zhengqi.arch@bytedance.com>
 <2EC0CBCD-73FD-400A-921A-EAB45B21ACB8@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <2EC0CBCD-73FD-400A-921A-EAB45B21ACB8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 440EF40006
X-Stat-Signature: b1hbfhq589akomcro8ybzrnd4k91pn81
X-Rspam-User: 
X-HE-Tag: 1759130574-853816
X-HE-Meta: U2FsdGVkX1/hYAy6wjfv5rbd+NX9MIrYy9l0mSLLwN13OgyAfOxWshiEBPCtWaQRTkAIWTLhNkUXcIyOir8bujgwIUZflG8Q28dfiZWpgEihp+iGda3EgDqj4GnPXP3OKEMgg3aTNBL8/6I9UwOHVIMFP0b0RcG0vNS6ydcgUFe/Dw3wH0xemkFwQo8/SlwZy/fdgpn/Fn6QoUBCjFswcTFP2E1LSmwKO4ldt++31ApAyPgLbapkOINGnBD232bonIGV/0gb1pVrx45md5b3TB+HHMB4DumtXWaflQycS34Omg5dKoNgagIwPYUNsL2UK7PXSgBjaiHawYtEBiTouPMZBiVVifK3UCXFLl0KsctdxUv45KW3kvdY633OzevTr8gMdVMtztAyNr8u3P89YHA90D604kXjvFPt3QOq3D/keHfPMxka23jTNGAB0foESUHqebxx7LpxpbbZhvFf1am94u1X9NEqA9zJIFTLcCQYe3kElCNfyylWNfWzwbRjiB+/C49WSilaUFBY56f+P3aV8gMtgULheKgnkJZBkPoNeflb72umdtcmjWk1caU/G6zfHVl+dKLCHNtqUi+9T9j3AlSzKwizKpjgzKGCpDoGgdPjHjdWg8Sq0r2QzzhSHTJSKWjiwWnmAPuKcqH3Ga7VpTb9Kphc5NI55H3mfIJqtASUlUwU6zdSg0MrKc9gOkWfI09sRhb8xTQH0M3iEpouTzlsR1UDF0r041Q+PwLSMv/p8ql3iHzoW9gKJRtYy2pR2hSCmh3Q0rVmWAJpIaShSTZaRRh6gnz1n37jnfG8jxRHYk8oXNywmQZ0xgsiFQwEUp9NcclT/DXdUHYyCjuQzT7Bwf5QuWIQIs5aI+c0QgaCrAns8ETwzXMV/Adz1BOQeJV97xtG9AuupvBwDa2Sk21Ck6nV5lGOkcR2sLt8gL50JgDaQT/mMniXr9meklxUbIQe1Bkgyw/Woy2
 DBntgupV
 QHCAeotJDeiUy1u8BN2grB/VDIOWt3Jx7lHPXa7VgBiv0bK5yohYp5uedtMdD4tlnGusTjqb3ZGwI+7ZtPr+oqvZr4vgTzsauTdjFQuu3YMHnItUmCv6O5XvJL6ABd0WphEUWZ3vJ5Md0JUubgz4CiqFDuz2BA/HW4Jm9L+kgGTMimbVy9feefWNYGVbrVgvKhfi77rqpRfzixfdXWInsMxx6v2cS1btAInXmRFdKWdMjK9yVZLzJZs1nuoBYqi0nlCc1Px1XFitIN+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/29/25 2:20 PM, Muchun Song wrote:
> 
> 
>> On Sep 28, 2025, at 19:45, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Similar to list_lru, the split queue is relatively independent and does
>> not need to be reparented along with objcg and LRU folios (holding
>> objcg lock and lru lock). So let's apply the same mechanism as list_lru
>> to reparent the split queue separately when memcg is offine.
>>
>> This is also a preparation for reparenting LRU folios.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> include/linux/huge_mm.h |  4 ++++
>> mm/huge_memory.c        | 46 +++++++++++++++++++++++++++++++++++++++++
>> mm/memcontrol.c         |  1 +
>> 3 files changed, 51 insertions(+)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index f327d62fc9852..0c211dcbb0ec1 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -417,6 +417,9 @@ static inline int split_huge_page(struct page *page)
>> 	return split_huge_page_to_list_to_order(page, NULL, ret);
>> }
>> void deferred_split_folio(struct folio *folio, bool partially_mapped);
>> +#ifdef CONFIG_MEMCG
>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
>> +#endif
>>
>> void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>> 		unsigned long address, bool freeze);
>> @@ -611,6 +614,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
>> }
>>
>> static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
>> +static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
>> #define split_huge_pmd(__vma, __pmd, __address) \
>> 	do { } while (0)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index bb32091e3133e..5fc0caca71de0 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1094,9 +1094,22 @@ static struct deferred_split *folio_split_queue_lock(struct folio *folio)
>> 	struct deferred_split *queue;
>>
>> 	memcg = folio_memcg(folio);
>> +retry:
>> 	queue = memcg ? &memcg->deferred_split_queue :
>> 			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>> 	spin_lock(&queue->split_queue_lock);
>> + 	/*
>> +	 * Notice:
>> +	 * 1. The memcg could be NULL if cgroup_disable=memory is set.
>> +	 * 2. There is a period between setting CSS_DYING and reparenting
>> +	 *    deferred split queue, and during this period the THPs in the
>> +	 *    deferred split queue will be hidden from the shrinker side.

The shrinker side can find this deferred split queue by traversing
memcgs, so we should check CSS_DYING after we acquire child
split_queue_lock in :

deferred_split_scan
--> spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
     if (css_is_dying(&memcg->css))
     --> retry to get parent split_queue_lock

So during this period, we use parent split_queue_lock to protect
child deferred split queue. It's a little weird, but it's safe.

>> +	 */
>> + 	if (unlikely(memcg && css_is_dying(&memcg->css))) {
>> + 		spin_unlock(&queue->split_queue_lock);
>> + 		memcg = parent_mem_cgroup(memcg);
>> + 		goto retry;
>> + 	}
>>
>> 	return queue;
>> }
>> @@ -1108,9 +1121,15 @@ folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
>> 	struct deferred_split *queue;
>>
>> 	memcg = folio_memcg(folio);
>> +retry:
>> 	queue = memcg ? &memcg->deferred_split_queue :
>> 			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>> 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
>> + 		if (unlikely(memcg && css_is_dying(&memcg->css))) {
>> + 		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
>> + 		memcg = parent_mem_cgroup(memcg);
>> + 		goto retry;
>> + 	}
>>
>> 	return queue;
>> }
>> @@ -4275,6 +4294,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>> 	return split;
>> }
>>
>> +#ifdef CONFIG_MEMCG
>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg)
>> +{
>> + 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>> + 	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
>> + 	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
>> + 	int nid;
>> +
>> + 	spin_lock_irq(&ds_queue->split_queue_lock);
>> + 	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
>> +
>> + 	if (!ds_queue->split_queue_len)
>> + 		goto unlock;
>> +
>> + 	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
>> + 	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
>> + 	ds_queue->split_queue_len = 0;
>> +
>> + 	for_each_node(nid)
>> + 		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
>> +
>> +unlock:
>> + 	spin_unlock(&parent_ds_queue->split_queue_lock);
>> + 	spin_unlock_irq(&ds_queue->split_queue_lock);
>> +}
>> +#endif
>> +
>> #ifdef CONFIG_DEBUG_FS
>> static void split_huge_pages_all(void)
>> {
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index e090f29eb03bd..d03da72e7585d 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3887,6 +3887,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>> 	zswap_memcg_offline_cleanup(memcg);
>>
>> 	memcg_offline_kmem(memcg);
>> + 	reparent_deferred_split_queue(memcg);
> 
> Since the dying flag of a memcg is not set under split_queue_lock,
> two threads holding different split_queue_locks (e.g., one for the
> parent memcg and one for the child) can concurrently manipulate the
> same split-queue list of a folio. I think we should take the same

If we ensure that we will check CSS_DYING every time we take the
split_queue_lock, then the lock protecting deferred split queue
must be the same lock.

To be more clear, consider the following case:

CPU0              CPU1              CPU2

                   folio_split_queue_lock
                   --> get child queue and lock

set CSS_DYING

                                     deferred_split_scan
                   unlock child queue lock
                                     --> acquire child queue lock
                                         ***WE SHOULD CHECK CSS_DYING 
HERE***
	

reparent spilt queue

The deferred_split_scan() is problematic now, I will fix it as follow:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5fc0caca71de0..9f1f61e7e0c8e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4208,6 +4208,7 @@ static unsigned long deferred_split_scan(struct 
shrinker *shrink,
         struct folio *folio, *next;
         int split = 0, i;
         struct folio_batch fbatch;
+       struct mem_cgroup *memcg;

  #ifdef CONFIG_MEMCG
         if (sc->memcg)
@@ -4217,6 +4218,11 @@ static unsigned long deferred_split_scan(struct 
shrinker *shrink,
         folio_batch_init(&fbatch);
  retry:
         spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+       if (sc->memcg && css_is_dying(&sc->memcg->css)) {
+               spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+               memcg = parent_mem_cgroup(sc->memcg);
+ 
spin_lock_irqsave(&memcg->deferred_split_queue.split_queue_lock, flags);
+       }
         /* Take pin on all head pages to avoid freeing them under us */
         list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
                                                         _deferred_list) {

Of course I'll add helper functions and do some cleanup.

Thanks,
Qi


> solution like list_lru does to fix this.
> 
> Muchun,
> Thanks.
> 
> 
>> 	reparent_shrinker_deferred(memcg);
>> 	wb_memcg_offline(memcg);
>> 	lru_gen_offline_memcg(memcg);
>> -- 
>> 2.20.1
>>
> 


