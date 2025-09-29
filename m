Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51788CCA468
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709278E002A; Mon, 29 Sep 2025 03:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691D68E0002; Mon, 29 Sep 2025 03:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532F98E002A; Mon, 29 Sep 2025 03:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC968E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:38:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA256119427
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:38:55 +0000 (UTC)
X-FDA: 83941486230.04.27F4179
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf22.hostedemail.com (Postfix) with ESMTP id 08F20C000A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:38:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=il47pTnW;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759131534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBKcXxbFuAD2KtWE6V9eoV+FPlnLvv6nJCJZHelUJiI=;
	b=0bUSfxFEZO1Z1uK0ENrY/u1ruOXm2s+mYU83stDf2h3xVm1qhabTrJBEIfr+Bhfq/gDoW/
	kOhhr/wAy1JM/4GlJCG1UjpEuAFL6GZYtBqpz2yXtcu8NIzUOabYG7bg3WBouFKvhsgO/9
	CKjmZJtIAZWdSW2BGNc9m0gDnkTENFc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=il47pTnW;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759131534; a=rsa-sha256;
	cv=none;
	b=PiDPqmQTRa/JHTgOM69vjqC/AylxKu7N2+0ty4vZZkqoVqirVylTLpYYIECoemXRYjuLr4
	TmJNZ88eR5CbH6QKHyIzHoLxL5W1ymtkfPAnYYDgaszbj4mHqZp+ZGyeTChRRpWmcU+Bjc
	5YZtahudZTeotCYxr6IUDpTduil8IRs=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759131531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pBKcXxbFuAD2KtWE6V9eoV+FPlnLvv6nJCJZHelUJiI=;
	b=il47pTnW5lKvMmF0hfqv3+bQcd4xRrn7/+pMihocPIoLbqKiN1aXRfl/bxjlhWc4f1ay5a
	h4m8jnuYsv3WPBmjRn2PEN6CIR7diOFpIE3ZojuyRkp8pqDS8ChmlRDLgQF4wbx/0w+qBK
	TeiFp75bfDTvqiMvYnpGvYOw83RLyz0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v3 4/4] mm: thp: reparent the split queue during memcg
 offline
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <08a4f0b2-1735-4e3b-9f61-d55e45e8ec86@linux.dev>
Date: Mon, 29 Sep 2025 15:38:05 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@redhat.com,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com,
 npache@redhat.com,
 ryan.roberts@arm.com,
 dev.jain@arm.com,
 baohua@kernel.org,
 lance.yang@linux.dev,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1A84CFB1-FB4F-4630-A40C-73CDE7CA8C21@linux.dev>
References: <cover.1759056506.git.zhengqi.arch@bytedance.com>
 <2ddd0c184829e65c5b3afa34e93599783e7af3d4.1759056506.git.zhengqi.arch@bytedance.com>
 <2EC0CBCD-73FD-400A-921A-EAB45B21ACB8@linux.dev>
 <08a4f0b2-1735-4e3b-9f61-d55e45e8ec86@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 08F20C000A
X-Stat-Signature: 81npdqonnqedtwgfdm3msiqfdtkpksxu
X-HE-Tag: 1759131533-397599
X-HE-Meta: U2FsdGVkX1/NBzkMA6uAOM5Gu5IHguIIqXTMOtnAEfP6v30sfxjigRPmo+d3A0Xb6D2zYBlqtecc7+P6+D3OgF5phlE/ys/pFcesqIt0hNJ2UBu+82dElQxxgGYHRkf2l4d0WPr+c2ml03MrBfNKgLOP3j/mmg9CXYe8ajup9vubzp34qCIpJ+x4Yn/ONgF13vcmb797I9MBGs4Dquv8EfpBlulIGAxGy8yMV6C73ox9Z9sGYaMw+SpqaZPhcliw4kmwiGIvlM/PQEGtUF9CSUI9yfRWM0UicmLqkB68RM+kFumQA9V7qjO2ZsiYsTbvhCXokkYt6J2xW0PE1K0u3yqByLvmyZXw46yTXf17fveG2c/Cuql//uzqlKg4nrqSpAYBqTjBe99Q7HzWWaBDw/Rj+67dP0edUBn98LHByMym1qgJlx7GNyiLZWzggLXq34rv9I6xapO4H/ZTndmeeLwOqpfIU3H3PJNGtQt/BuY9sPS3o0qFQ1z11UTSEppRYBMju77JunZKGTDOxfiXQfUEcEOPEg8UdeLHUzrB7hclccr91BPeTkWq92pRC/fepmPJI6P+yub5LxUWKAQG8K///+Mkr/HeKClZzoJnoyYzh9vBsksMSUHNMQRoieEKwUmLiZpCvIMgzsNdmKCqXvVLhjmEwA6EbSNi5K4u5mBMxLpfeFLRQ9/A5Rjqm0YbYwOtHnyZzR9LrmL1dYDjnT6hk+T94uLVj0PH/cStQ1D7Uoy7iz/WQNmNjOFErGQ3/JXpRhL5kKjhQ6A/vTtICcPcbdVvHCv/yQnvgDfcVTjf5L/rdXBX0dcbCSNJS83bvx5MCPz2Cn579jr5OpVLQOmnRxVX+8nR1nQPsgQsUQ+X/SnvkqQQc23CGKlOmJjsmQyQv/AcSt245FhoA6Ed+p8GbE+XO6fgAC7uyN+Z0/uYcARIjkIJaRn0zcsE4snfEuIYM0sU2m3InaADb9Z
 lbP8p7d7
 7CYq3r2Py1jZjsEL8/fI99GJFW2MJ31f1Hd3FNPH+PsI8cvd0YJBLffJtyLeZVmtAzjhLAfUZQqtz72UEJObgNvKMJCeFYycHmMdO6kkJhhpQw8q00MlFe9aMxQB6pOWetNy0fdgXVl/tZWMhTYa8jcuNwjsw6sJHkBAl3k2XpxdDXWmihFGpl9BJyVy+V5+qIidAFww0CA3rqWkXAYIJWXws0VMFDTMp+1fu7gdH8bX4guwM87e5DCUivdvuF+pF45ZqMQ3BbQ84Bmkpn6bJL92XumnukqG/rYz29rIxRa9lHvo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2025, at 15:22, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 9/29/25 2:20 PM, Muchun Song wrote:
>>> On Sep 28, 2025, at 19:45, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>=20
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>=20
>>> Similar to list_lru, the split queue is relatively independent and =
does
>>> not need to be reparented along with objcg and LRU folios (holding
>>> objcg lock and lru lock). So let's apply the same mechanism as =
list_lru
>>> to reparent the split queue separately when memcg is offine.
>>>=20
>>> This is also a preparation for reparenting LRU folios.
>>>=20
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> ---
>>> include/linux/huge_mm.h |  4 ++++
>>> mm/huge_memory.c        | 46 =
+++++++++++++++++++++++++++++++++++++++++
>>> mm/memcontrol.c         |  1 +
>>> 3 files changed, 51 insertions(+)
>>>=20
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index f327d62fc9852..0c211dcbb0ec1 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -417,6 +417,9 @@ static inline int split_huge_page(struct page =
*page)
>>> 	return split_huge_page_to_list_to_order(page, NULL, ret);
>>> }
>>> void deferred_split_folio(struct folio *folio, bool =
partially_mapped);
>>> +#ifdef CONFIG_MEMCG
>>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
>>> +#endif
>>>=20
>>> void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>>> 		unsigned long address, bool freeze);
>>> @@ -611,6 +614,7 @@ static inline int try_folio_split(struct folio =
*folio, struct page *page,
>>> }
>>>=20
>>> static inline void deferred_split_folio(struct folio *folio, bool =
partially_mapped) {}
>>> +static inline void reparent_deferred_split_queue(struct mem_cgroup =
*memcg) {}
>>> #define split_huge_pmd(__vma, __pmd, __address) \
>>> 	do { } while (0)
>>>=20
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index bb32091e3133e..5fc0caca71de0 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -1094,9 +1094,22 @@ static struct deferred_split =
*folio_split_queue_lock(struct folio *folio)
>>> struct deferred_split *queue;
>>>=20
>>> 	memcg =3D folio_memcg(folio);
>>> +retry:
>>> 	queue =3D memcg ? &memcg->deferred_split_queue :
>>> 			=
&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>>> 	spin_lock(&queue->split_queue_lock);
>>> +  /*
>>> +  * Notice:
>>> +  * 1. The memcg could be NULL if cgroup_disable=3Dmemory is set.
>>> +  * 2. There is a period between setting CSS_DYING and reparenting
>>> +  *    deferred split queue, and during this period the THPs in the
>>> +  *    deferred split queue will be hidden from the shrinker side.
>=20
> The shrinker side can find this deferred split queue by traversing
> memcgs, so we should check CSS_DYING after we acquire child
> split_queue_lock in :
>=20
> deferred_split_scan
> --> spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>    if (css_is_dying(&memcg->css))
>    --> retry to get parent split_queue_lock
>=20
> So during this period, we use parent split_queue_lock to protect
> child deferred split queue. It's a little weird, but it's safe.
>=20
>>> + 	 */
>>> +  	if (unlikely(memcg && css_is_dying(&memcg->css))) {
>>> +  		spin_unlock(&queue->split_queue_lock);
>>> +  		memcg =3D parent_mem_cgroup(memcg);
>>> +  		goto retry;
>>> +  	}
>>>=20
>>> return queue;
>>> }
>>> @@ -1108,9 +1121,15 @@ folio_split_queue_lock_irqsave(struct folio =
*folio, unsigned long *flags)
>>> struct deferred_split *queue;
>>>=20
>>> 	memcg =3D folio_memcg(folio);
>>> +retry:
>>> 	queue =3D memcg ? &memcg->deferred_split_queue :
>>> 			=
&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>>> 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
>>> +  	if (unlikely(memcg && css_is_dying(&memcg->css))) {
>>> +  		spin_unlock_irqrestore(&queue->split_queue_lock, =
*flags);
>>> +  		memcg =3D parent_mem_cgroup(memcg);
>>> +  		goto retry;
>>> +  	}
>>>=20
>>> return queue;
>>> }
>>> @@ -4275,6 +4294,33 @@ static unsigned long =
deferred_split_scan(struct shrinker *shrink,
>>> return split;
>>> }
>>>=20
>>> +#ifdef CONFIG_MEMCG
>>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg)
>>> +{
>>> +  	struct mem_cgroup *parent =3D parent_mem_cgroup(memcg);
>>> +  	struct deferred_split *ds_queue =3D =
&memcg->deferred_split_queue;
>>> +  	struct deferred_split *parent_ds_queue =3D =
&parent->deferred_split_queue;
>>> +  	int nid;
>>> +
>>> + 	spin_lock_irq(&ds_queue->split_queue_lock);
>>> +  	spin_lock_nested(&parent_ds_queue->split_queue_lock, =
SINGLE_DEPTH_NESTING);
>>> +
>>> +  	if (!ds_queue->split_queue_len)
>>> +  		goto unlock;
>>> +
>>> +  	list_splice_tail_init(&ds_queue->split_queue, =
&parent_ds_queue->split_queue);
>>> +  	parent_ds_queue->split_queue_len +=3D ds_queue->split_queue_len;
>>> +  	ds_queue->split_queue_len =3D 0;
>>> +
>>> +  	for_each_node(nid)
>>> +  		set_shrinker_bit(parent, nid, =
shrinker_id(deferred_split_shrinker));
>>> +
>>> +unlock:
>>> +  	spin_unlock(&parent_ds_queue->split_queue_lock);
>>> +  	spin_unlock_irq(&ds_queue->split_queue_lock);
>>> +}
>>> +#endif
>>> +
>>> #ifdef CONFIG_DEBUG_FS
>>> static void split_huge_pages_all(void)
>>> {
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index e090f29eb03bd..d03da72e7585d 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -3887,6 +3887,7 @@ static void mem_cgroup_css_offline(struct =
cgroup_subsys_state *css)
>>> zswap_memcg_offline_cleanup(memcg);
>>>=20
>>> 	memcg_offline_kmem(memcg);
>>> +  	reparent_deferred_split_queue(memcg);
>> Since the dying flag of a memcg is not set under split_queue_lock,
>> two threads holding different split_queue_locks (e.g., one for the
>> parent memcg and one for the child) can concurrently manipulate the
>> same split-queue list of a folio. I think we should take the same
>=20
> If we ensure that we will check CSS_DYING every time we take the
> split_queue_lock, then the lock protecting deferred split queue
> must be the same lock.
>=20
> To be more clear, consider the following case:
>=20
> CPU0              CPU1              CPU2
>=20
>                  folio_split_queue_lock
>                  --> get child queue and lock
>=20
> set CSS_DYING
>=20
>                                    deferred_split_scan
>                  unlock child queue lock
>                                    --> acquire child queue lock
>                                        ***WE SHOULD CHECK CSS_DYING =
HERE***
>=20
>=20
> reparent spilt queue
>=20
> The deferred_split_scan() is problematic now, I will fix it as follow:
>=20
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5fc0caca71de0..9f1f61e7e0c8e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4208,6 +4208,7 @@ static unsigned long deferred_split_scan(struct =
shrinker *shrink,
>        struct folio *folio, *next;
>        int split =3D 0, i;
>        struct folio_batch fbatch;
> +      struct mem_cgroup *memcg;
>=20
> #ifdef CONFIG_MEMCG
>        if (sc->memcg)
> @@ -4217,6 +4218,11 @@ static unsigned long deferred_split_scan(struct =
shrinker *shrink,
>        folio_batch_init(&fbatch);
> retry:
>        spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
> +      if (sc->memcg && css_is_dying(&sc->memcg->css)) {

There are more than one place where we check whether a memcg is dying,
it is better to introduce a helper like mem_cgroup_is_dying to do this
in memcontrol.h.

> +               spin_unlock_irqrestore(&ds_queue->split_queue_lock, =
flags);

Yes, we could fix this like this way. But I suggest we introduce another
helper like folio_split_queue_lock to do the similar retry logic. Every =
users
of split_queue_lock are supposed to use this new helper or =
folio_split_queue_lock
to get the lock.

> +               memcg =3D parent_mem_cgroup(sc->memcg);
> + 		=
spin_lock_irqsave(&memcg->deferred_split_queue.split_queue_lock, flags);
> +       }
>        /* Take pin on all head pages to avoid freeing them under us */
>        list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
>                                                        _deferred_list) =
{
>=20
> Of course I'll add helper functions and do some cleanup.

Yes.

>=20
> Thanks,
> Qi
>=20
>=20
>> solution like list_lru does to fix this.
>> Muchun,
>> Thanks.
>>> reparent_shrinker_deferred(memcg);
>>> wb_memcg_offline(memcg);
>>> lru_gen_offline_memcg(memcg);
>>> --=20
>>> 2.20.1



