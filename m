Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74AD3CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 03:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19B66B0005; Mon, 18 May 2026 23:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB336B0088; Mon, 18 May 2026 23:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0A46B008C; Mon, 18 May 2026 23:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8936E6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:36:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34BBD8B463
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:36:06 +0000 (UTC)
X-FDA: 84782755932.22.1294423
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 62A631C000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:36:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i7WLipU/";
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779161764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79xn5oODka7E2yFSa2rWy0pgiQ4vVTV+hSyNwQyFHq4=;
	b=l8Xid4NUG0q2YJbgBiqncYniRHQixb/YFKGdnhkJH0KnJk7FT7A3Fb4B6NiTdOxKvrYYxT
	QLtHh9Pl4YCqb7tb075ZhtDwILzn6sbyBoHrQWnlpQ8Y5yX3l/lBUrBMWG28rsvsA6ir52
	oHnGUAOwAjCv2n7/VHfU41gEpTU0yHg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779161764; a=rsa-sha256;
	cv=none;
	b=UihquvEPC5M3sPu7W31T0VQ9YHPMDvrV6tsdza92wzVpSKZwTAlm7grnZW740gofOBYbaU
	G1oBiz69TBiWoy5RHSBpu2j0ZxD7E4JWIQaRz7O3jrnCAuPpNaRc+9QqHE/gpDowlQo1On
	Rgai7U9Aql0DuLWrKm0PxdK0lkGkDAs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i7WLipU/";
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <06b25f78-8e2d-4075-9b80-133bbd691c71@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779161761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=79xn5oODka7E2yFSa2rWy0pgiQ4vVTV+hSyNwQyFHq4=;
	b=i7WLipU/jyMHBPg4YSql7DyviH9pGydMk+r+CvMT+MEB2g68jI2FOwOD0OL8Z5XzvhADnK
	3TdjaPPJgQf7XfnE7ARh4sA8OoDDtXFgfoKuumD2VNmlm/R2T2LaTp+n1Suz+YKZO//JRH
	9asWZmRbhkySKFgbSYwbdy72mRK/T00=
Date: Tue, 19 May 2026 11:35:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
 <aguiSnY3ie1y4nEl@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aguiSnY3ie1y4nEl@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62A631C000A
X-Stat-Signature: pczrt18c97c3qmj87988rh94rtps6okz
X-Rspam-User: 
X-HE-Tag: 1779161764-739000
X-HE-Meta: U2FsdGVkX1+glox5FxPFwPUU64Tiu7RFaa6r2Wp01/Bhn92gJO0/mEczvajtCuQ3JNEPD3uZKvg+b23ZEnPs3yiQUALsKQ4yiSL7Y2wMwlAERMARMAR2mxlhzRyEmJH8Sgov+9hGQb10ULoggPAy4lX4j5fF8KAfIQf6kvmaheXbtq/40HXyuL3RqNf2gFTqq6wjNCXVnZTbs65nxbZryINoSes+qzzLFq34aMnx5y2VZnC8WpyJ0QG+oIOLS9447gZDXpOjSrLPOp00FC6G3kXm7JDTRuVGS1rtS8ZSBlDAwvvqihKuIIhGPnKjJKC9YL9l3D1oNhnkkQ9Ptuh2NajRd3x2aKN4bTAinyFsaKfMJFhyDHyPc2WeHcV/JAmP1993ZBnrud7S4QJl01Vc1FGWhG9tptrCjC0sYYrABUs14eQWLPggjtDIAJlRpFXv0oxdL1IDG3qG5dAwkQg1FSjvi+ymbWdR4MTKpFDiemUIV8UZjz0Y7A/GzXUAC6tW3KvmKzc462cSgg4IGPo00WTGFG3CALlag8RbelAtTT6UORrQ4XO6nZdAyrxbqaoJMJES8mv0T4DngFKaE36VHu36Ps7tS6tZ9nWOhDXOWO22Ss6ACmdvafYh0NSkcP1ly+RaosbY5qFCwKP4WOqEZ6CaE3UiESbOUsvBzs2PG5SXpn4bifegHE6WEccmkXsHiNjXEJ4XvuqbY84kaU7f7qeIxIqtupi/9W101vREzqshG6O5VVzS8I4pL2WsLKOy6pVl0K6ffzdMl+np0DQVE8F8s5sfY4W3d05Efl89HHCjRoysbWKCvKzwH+dQOsDPjUsygIBZ+RVx0KBwVPAZXUhhQRH2KrtfZN3naNmNOGM6epal3/GkrXjckGcr3Bts35dfdgEGwHLAgJ4bnKbL7rz9C50F6ZE1MI6WVQYPt1fu5Sv6B/vv/MifQORGJNlMe57hNnmJfG5WhImfZXI
 oUrM8RWf
 6EBNokU9Mr9AaVRP65K405Op3tMYEK5Jl9/Bvv568m7A68uZa/hrt+rzAZT+yhVGgAdUbZ/ReK14NBIDAkAlRG0G4oj3AHPC5tD+BcQSk/qeziGg52patZWN3PdXkb7DEdG9+ziJQqhzW5miPLiIT6biSdevXex/CKjaqX1N4F1S3W9JRWZCyofRetiv7eiVMYBUkjp0GisweYsBsdpVohRo4De5xRF1pWzcXQI1v2LVDQR6jr77OU7nhs8arQH/fNawXsMmo13T3pV/RskU7/sYZmy3xY05uHUrPibnEa0m4uOTK6qMJ4GFiiA+l0wBHMsYOyEHpQe+H+IiPRnJxcKNgNHPTyrjsPmtBlTMDojaUWjNMq3Oe2aHgknrLYmAPSzM/ocM4BX/aHteIzZXgXzXxBOfvz/2LfUr3Dhzg/9oEUvD8iuzzuyv3x7VQqSUpUyRc3gK4Bdjqud4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/19/26 7:41 AM, Shakeel Butt wrote:
> On Mon, May 18, 2026 at 03:28:27PM -0700, Shakeel Butt wrote:
>> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
>> per-node type") split a memcg's single obj_cgroup into one per NUMA
>> node, but the per-CPU obj_stock_pcp still keys cached_objcg by
>> pointer. Cross-NUMA workloads now see a drain on every refill and a
>> miss on every consume that targets a sibling per-node objcg of the
>> same memcg, producing the 67.7% stress-ng switch-mq regression
>> reported by LKP.
>>
>> stock->nr_bytes are fungible across per-node objcgs of one memcg.
>> Treat the cache as keyed by memcg in __consume_obj_stock() and
>> __refill_obj_stock() so siblings share the reserve. Compare via
>> READ_ONCE(objcg->memcg) directly: pointer-compare only, no deref, so
>> the rcu_read_lock contract on obj_cgroup_memcg() does not apply.
>>
>> Sharing the reserve without re-caching means bytes funded by one
>> per-node objcg's slow path can be consumed/freed under a different
>> sibling, leaving sub-page residue on whichever sibling was cached at
>> drain time. The pre-existing obj_cgroup_release() path would WARN and
>> silently drop that residue, leaking up to nr_node_ids * (PAGE_SIZE - 1)
>> bytes per memcg lifecycle from the page_counter. Forward the residue
>> into a per-node objcg of the same (post-reparent) memcg at release time
>> instead, so it can be reconciled later via a refill atomic_xchg or
>> another release; the chain terminates at root_mem_cgroup, whose
>> page_counter has no enforced limit.
>>
>> Please note that this is temporary fix and will be reverted when
>> per-node kmem accounting is introduced.
>>
>> Update the stale invariant comment on __account_obj_stock().
>>
>> Qi Zheng built a specialized reproducer [1] for the corner case and
>> confirmed the fix.
>>
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
>> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
>> Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>> Debugged-by: Qi Zheng <qi.zheng@linux.dev>
> 
> Sashiko's review below and my response.
> 
> 
>>
>> Thank you for your contribution! Sashiko AI review found 2 potential issue(s)
>> to consider:
>> - [High] Race condition during memcg offlining causes a permanent page counter
>> leak when forwarding `sub_bytes`.
>> - [High] Unbounded accumulation of `sub_bytes` in a non-allocating parent
>> memcg causes a permanent page counter leak and integer overflow.
>> --
>>
>> commit e90ccbfce3bb9538bf1cdf185a1c10a7269e0939
>> Author: Shakeel Butt <shakeel.butt@linux.dev>
>>
>> memcg: cache obj_stock by memcg, not by objcg pointer
>>
>> This commit changes obj_stock_pcp caching from pointer-based to memcg-based
>> so sibling per-node objcgs share the reserve. It also forwards sub-page
>> residue into a per-node objcg of the same memcg during release so it can be
>> reconciled later instead of being lost.
>>
>> Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/
>> [1]
>>
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>   index d978e18b9b2d0..a547ec7c42d16 100644
>>>   --- a/mm/memcontrol.c
>>>   +++ b/mm/memcontrol.c
>>>
>> [ ... ]
>>
>>>
>>> @@ -160,23 +170,33 @@ static void obj_cgroup_release(struct percpu_ref *ref)
>>>   */
>>>   nr_bytes = atomic_read(&objcg->nr_charged_bytes);
>>>   - WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
>>>   nr_pages = nr_bytes >> PAGE_SHIFT;
>>>   + sub_bytes = nr_bytes & (PAGE_SIZE - 1);
>>>   
>>>   - if (nr_pages) {
>>>   + if (nr_pages || sub_bytes) {
>>>   struct mem_cgroup *memcg;
>>>   
>>>   - memcg = get_mem_cgroup_from_objcg(objcg);
>>>   - mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
>>>   - memcg1_account_kmem(memcg, -nr_pages);
>>>   - if (!mem_cgroup_is_root(memcg))
>>>   - memcg_uncharge(memcg, nr_pages);
>>>   - mem_cgroup_put(memcg);
>>>   + rcu_read_lock();
>>>   + memcg = obj_cgroup_memcg(objcg);
>>>   +
>>>   + if (nr_pages) {
>>>   + mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
>>>   + memcg1_account_kmem(memcg, -nr_pages);
>>>   + if (!mem_cgroup_is_root(memcg))
>>>   + memcg_uncharge(memcg, nr_pages);
>>>   + }
>>>   +
>>>   + if (sub_bytes && !mem_cgroup_is_root(memcg)) {
>>>   + struct obj_cgroup *fwd;
>>>   +
>>>   + fwd = rcu_dereference(
>>>   + memcg->nodeinfo[numa_node_id()]->objcg);
>>>   + if (fwd)
>>>
>> Could there be a race condition during memcg offlining here that leads to a
>> page counter leak?
>>
>> If this executes concurrently with the offlining of the memcg,
>> memcg_reparent_objcgs() might have already replaced the nodeinfo objcg
>> pointer with NULL. In this race window, fwd evaluates to NULL, and the
>> sub_bytes would be dropped.
>>
>> Since they are dropped without being uncharged or forwarded, it seems the
>> page counter would permanently leak these charges.
> 
> This is not much a concern as it is bounded (i.e. nr_nodes * PAGE_SIZE - 1) and
> previously for the warning case, we were already dropping the sub-page charges.
> 
>>
>>>
>>> + atomic_add(sub_bytes, &fwd->nr_charged_bytes);
>>>
>> Does this unbounded addition create a risk of integer overflow and page
>> counter leaks if the parent memcg never allocates?
>>
>> If the parent memcg is used strictly as a hierarchical container (like
>> system.slice) and performs no kernel allocations, its objcg is never cached
>> in any CPU's obj_stock_pcp.
>>
>> Because __refill_obj_stock() relies on the cache to periodically drain
>> nr_charged_bytes, it would never be invoked for the parent. Could child
>> residues continuously accumulate in the parent's nr_charged_bytes without
>> ever being uncharged, eventually overflowing the 32-bit atomic_t?
>>
> 
> This can be a concern for a long running cgroup. However fixing this would add
> complexity not worth it. This is a temporary fix and will be reverted in newer
> kernels.

I think this is fine as a temporary fix:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!

> 
>>>
>>> + }
>>>   + rcu_read_unlock();
>>>   }
>>>
>> -- 
>> Sashiko AI review ·
>> https://sashiko.dev/#/patchset/20260518222827.110696-1-shakeel.butt@linux.dev?part=1
>>


