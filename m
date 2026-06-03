Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE297CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2346B0092; Wed,  3 Jun 2026 07:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193446B0093; Wed,  3 Jun 2026 07:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D08A6B0095; Wed,  3 Jun 2026 07:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 028C66B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:53:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94A0C1C079C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:53:37 +0000 (UTC)
X-FDA: 84838441674.01.FB48105
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6EF26A0012
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:53:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X/BAccuz";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780487615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oO32gU/6GqPqmsbPD/EqqtNbEEfCeRvWof7NPW20STY=;
	b=BSyAiDenDhfXIV6c0JbVdvL5338TLZYw1P0nbcYklKGOoG8RtObj3WinWdmj8FiuHrGzsg
	acIO0VdfKAD3f9Sm0TSf99nXb2TDrYohIbk9WV3W7tiIq/0T8RdVkbp5U5L2YbqBDiNJwZ
	0j79rtyykUWFFL1xaBv4yJVHE6+l8Oc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X/BAccuz";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780487616;
	b=OSWwcb6+XuMOeBjHTMSm24VJWrPs+bnQwZyQn6S51i2H0IOV+XJX4QYsqUjs9nxuEmo8Ks
	DgRz1hNTyNdA8eLFa65IiCcV3t7H+AvQ14Qerpjbvpc1w4LltRq8NNG/VS8PvjJeOs/ypM
	9N4KsWdqIiEab7j3273GWJRQygNENyQ=
Message-ID: <4b2ebbf7-8c5e-45ca-a17c-111f68e2324c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780487613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oO32gU/6GqPqmsbPD/EqqtNbEEfCeRvWof7NPW20STY=;
	b=X/BAccuz5VRKWoWp8Tw5a2hyusMTKMdhoDQBENIqijF2kktRaXNzuLf0junIel8CkvdmcH
	7CkezdTUzOvIYcG1228DGzW2sck4oSGXaI2Nlo29boIh8aW+zNXC1v/kuuOV14NgNLfCos
	zI20XgSI/HCz3BejCUKEmsHCU+3KC+A=
Date: Wed, 3 Jun 2026 19:53:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 0/9] mm: switch THP shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, david@fromorbit.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, qi.zheng@linux.dev,
 yosry.ahmed@linux.dev, ziy@nvidia.com, liam@infradead.org,
 usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org, ryncsn@gmail.com,
 zaslonko@linux.ibm.com, gor@linux.ibm.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
 ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <ah9PGv12mqai84ES@cmpxchg.org>
 <20260603044426.54863-1-lance.yang@linux.dev> <aiAS7GxsffqXWILD@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aiAS7GxsffqXWILD@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6EF26A0012
X-Rspam-User: 
X-Stat-Signature: 4e7rcjpz9jyytot6778ea4n3zcxtecux
X-Rspamd-Server: rspam09
X-HE-Tag: 1780487615-10048
X-HE-Meta: U2FsdGVkX19thGo4NzVzxcryXhQj/WyDOJEjUtMxCFfzCEcG9EauDmWxhp+S/jVC8ruL20FOkAjFYhKxt2lQHkKmiHwKZzGQYgVVZw9uFZFlwfbqIPm3Hw/yOAltgDh6HIPb7vmIRC+DgMfaEKkupEB0QsjpL/fbjXyQh+bb5C2UxvZ3qguPsmt0QS9zh69ssV71TIV8wkhh6zXOIpYp6vOBWjFExiH+Y/WWY5Sw8jRSiB2WFdMCfmPhzo2QwnXnxM6OT1pruXdava66HyHFGAf4tbgolPMUwR3NlYvhOzwCuGn72/axuBjnaNrhXhxUjso9qxzk+meuf88guTxROrURMnLF6w5mthPIKbhnVYP+I2Bd1QIIfKTdGUzIHzmRMRPv8Q+dvUGCcqUQXhk2ewemWR85XvawNSOpLXqJS9UbSgVa6nkFwqXQaldxFoNx4rE0RzKQM82bgkjndt8gs/f9w8eysph1ExfRfKfG/ODGizGGsKK6OCs9Ru2NLDn/RhKGPeul/99hKZIyQM/dJdsVm48k0CWQ1O2cT8jHyTAqZluILldV/r7Pa2kcQ0Z/gZx6uq9Okw2UwI/XVIvh3EBE3tqib2WMp63pwFstPBFv1xtmk7Lu6un580ASfNd+U0cCJMPSnZcZj/3U0VZD9xjjwqmFsYIj9YBTehKFPVp9oxi8oclm0Qz9XuJg9etlfVmRD5cJ2sKG17+lDU47XG+gsf8WPjncSgxRk6GzKqBbi2CnRaBA4sPmLjeyzKufnaF6FtVOAjtWj3ub/NFgFr2NUsG/nhtNzfPFlAFSqO4wVnPy0XNbYq9DMxaSlXe1GS20ctEN49F/dc3/ieBPblx1Vz5cufkrnBbluq3ipEgsqmbjdMNk3l2BbOTiIKUBouj1cCV8q1qXhcgDlCmg9saFNrB3JlbkZ7vq+MgGZqh0naHFcFT33R7OAT6KlshlM93L2cRz3Rey9HZYxeX
 BGyN2r7I
 doBA0k88kWpW4hfGFqLLfDBDOtDypuQC1w7srO7fHGmyE0Gsl/MtHya7+pp7XjrJyG4ZtoG8+lQK6qQxWZqiAgBK66fFQP4duj/YNUhC16UqcFp2v511Fue4gixuEZd9KVlJIGtVsmfTu97qRu4n6T4p8T6Ekes7jPTM8oUVC1tLYtgpNDFT8bBYbj2UWFAXHUYts1sOB6oCN1hACGjsJmyhebnAa41HaICID+A4C7+3f2/MLfY+gNFOrXytK/lzUOE8g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/3 19:41, Johannes Weiner wrote:
> On Wed, Jun 03, 2026 at 12:44:26PM +0800, Lance Yang wrote:
>>
>> On Tue, Jun 02, 2026 at 05:46:02PM -0400, Johannes Weiner wrote:
>>> On Mon, Jun 01, 2026 at 04:36:52PM +0800, Lance Yang wrote:
>>>> As the changelog above says, the old queue is per-memcg only, rather
>>>> than per-memcg-per-node. So reclaim on one node can still walk the whole
>>>> memcg queue and split underused THPs from other nodes in the same memcg.
>>>>
>>>> But I think the new one can lose reclaim in the cgroup.memory=nokmem
>>>> case ...
>>>>
>>>> With nokmem, the deferred shrinker can still run from memcg reclaim,
>>>> because it is SHRINKER_NONSLAB. But the list_lru is no longer per-memcg:
>>>>
>>>> __list_lru_init() clears memcg_aware,
>>>>
>>>> 	if (mem_cgroup_kmem_disabled())
>>>> 		memcg_aware = false;
>>>>
>>>> so list_lru_from_memcg_idx() falls back to the shared node list:
>>>>
>>>> static inline struct list_lru_one *
>>>> list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>>>> {
>>>> 	if (list_lru_memcg_aware(lru) && idx >= 0) {
>>>> [...]
>>>> 	}
>>>> 	return &lru->node[nid].lru;
>>>> }
>>>>
>>>> That makes the shrinker bit unreliable. __list_lru_add() still sets the
>>>> bit on the memcg passed in, but only when the list goes from empty to
>>>> non-empty:
>>>>
>>>> bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
>>>> 		    struct list_head *item, int nid,
>>>> 		    struct mem_cgroup *memcg)
>>>> {
>>>> 	if (list_empty(item)) {
>>>> [...]
>>>> 		if (!l->nr_items++)
>>>> 			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
>>>> [...]
>>>> 		return true;
>>>> 	}
>>>> 	return false;
>>>> }
>>>>
>>>> If memcg A adds the first folio, A gets the bit. If memcg B later adds a
>>>> folio to the same shared list, B does not get a bit, because the list
>>>> was already non-empty.
>>>>
>>>> So in the A-first/B-later case, reclaim from B may not call the deferred
>>>> shrinker at all. The shared list is scanned from memcg reclaim only if
>>>> reclaim runs from the memcg that has the bit, such as A here, or from
>>>> global reclaim :)
>>>>
>>>> Anyway, only after the shared list is emptied does the next memcg to add
>>>> a folio get to be the one with the bit, IIUC :)
>>>
>>> Sorry for the delay, this took me a bit to think about. The shrinker
>>> code is a mess.
>>>
>>> I read it the same way you do. And this is true for all list_lru users
>>> when nokmem is set: we just set random nonsense shrinker bits.
>>>
>>> HOWEVER, the generic shrinker code fixes that up by IGNORING random
>>> shrinker bits like this when !memcg_kmem_online(). And shrinking
>>> correctly happens only against the shared root queue when the reclaim
>>> iterator walks root_mem_cgroup.
>>>
>>> HOWEVER, the THP shrinker explicitly sets SHRINKER_NONSLAB, which in
>>> turn overrides the previous override. So yes there is a weirdness: we
>>> get the root cgroup invocation against the shared queue, and then one
>>> more time triggered by that random memcg bit.
>>>
>>> The most direct fix is to just drop SHRINKER_NONSLAB. It declares
>>> independence from kmem, which is no longer true.
>>>
>>> Cleaning up the shrinker code is left for another day.
>>
>> Thanks for working on this!
>>
>> Wondering if this fix trades one problem for another, though ...
>>
>> Before this series, the deferred split shrinker had a real per-memcg
>> queue. Even with cgroup.memory=nokmem, memcg reclaim could still scan
>> that memcg's own deferred_split_queue:
>>
>> memcg reclaim -> deferred split shrinker -> sc->memcg->deferred_split_queue
>>
>> With the fix, nokmem + w/o SHRINKER_NONSLAB falls back to a
>> non-memcg-aware shrinker:
>>
>> memcg reclaim -> skip deferred split shrinker
>>
>> root/global reclaim -> deferred split shrinker -> shared list_lru
>>
>> Is that expected? There woud be no memcg-driven deferred split reclaim
>> under nokmem, IIUC ...
> 
> Yes, this is all correct. list_lru is still inherently tied to the
> kmem component of memcg (memcg_kmem_id()).
> 
> So without kmem, no isolation. But without kmem, no isolation *for a
> lot of stuff*. It's a legacy knob when slab accounting was new and
> expensive. But so many things depend on it now, disabling it just
> punches a nassive hole into memcg functionality and isolation
> coverage. It's not a sanctioned production use flag.
> 
> This change is negligible from a memcg semantics POV.

Thanks for clarifying!

No strong objection from me. Just wanted to call out the nokmem
behavior change and hear what folks think :D

>> Not sure what the right fix is, as I am not a memcg expert ...


