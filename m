Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 750E8ED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55866B0088; Tue, 14 Apr 2026 06:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B066C6B008A; Tue, 14 Apr 2026 06:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BD56B0092; Tue, 14 Apr 2026 06:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 912BC6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:00:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A7411404B6
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:00:29 +0000 (UTC)
X-FDA: 84656716578.12.B627CCE
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5A920140016
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:00:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fXCL30p1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776160827; a=rsa-sha256;
	cv=none;
	b=vXFo9YYALx9JdQ4O0AbL/KS3lgc8WzhX405CbK6urgC8uTZ0oWPjTyAqj9qVg5UulTBOg9
	ccZiSwOISSUgiLmTNBHpSjS+ioKzy/Y+/mG2Og0Yi5Hw2hpj9VsgHlBvHwJS/1J7tsH2Zh
	Mgb7/AV47siFYggZV2+JhqMgbJ9jB1s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fXCL30p1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776160827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aS0c1n45wXQTaxQSe6C+loc9iFSRt6diMHIuKTsYOOo=;
	b=iG1a3UC0jnFBW/oy0LkkVFLM5CWlwdpOb4b4pmbjjUkkcUXnkS7okQA/vod5fTIu/XoHiE
	uo6FU/3N+PWVuhtmVM/vhWSSE9SCFlcQwaK2nS9nstprkOCGFK/gDVtyJCyNduYiwLe+Lf
	7xaV9IvFz/PHPIOVdTYhVELLVXjnVEk=
Date: Tue, 14 Apr 2026 17:59:48 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776160825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aS0c1n45wXQTaxQSe6C+loc9iFSRt6diMHIuKTsYOOo=;
	b=fXCL30p1yYk2a/TLz/1nhGr41Ce9pu9rh6GaebUwquuQlgZSLDBk3EYMoJAP+KngDsZZvU
	N4i+NwKQfl7e3cPOBl7OygyOntu1MQQARRJsjlFJ/V12GBSLMGNLgzWwOUSqW0nLiAqbqW
	OqhQYEEE7mrcLgfHg8HWbJ97I5C+2wY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <bbtmo4fffalhjglohnazrxvplzfxelmuivbonnbfi3gzsm7qj3@bvh42p47dsqa>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <ad39TJZYLItrEnIM@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad39TJZYLItrEnIM@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qp99ppd649b7fbif89yxtxb1rwr466aw
X-Rspamd-Queue-Id: 5A920140016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776160827-124468
X-HE-Meta: U2FsdGVkX19KXDAU9BItlq1PQDdnhrvb+MTeKRrSy5BZoaRGpms5wLQk17A8MNLaPKjgE/LqUcgOhZAY/xAyFG1kaWe5DNSux6CCu7VDSyFRA42NUATZel06oKfhsjZ5oPgxvR0MKIkC/Bwpv5Q6qnJncLt3hEXFa3Ha5ZSc8FOE6u9mlmLjzen9ewMbZ2T/m+jXnAmj3xvzuIdp5Aua8tuNLx/aaVMKIhZzT5UjEtrhNMutygGgXE3pWrEbfDJG+2aXDuzYCIjIeP9bz34fLaZadO6VoLpQsjO9s8isB5UNXxHv/lS3UH6Qbu228sM8MoppkmDDbf1yOVSEGKv0chNN7nzC/o1E1lMbHqJu/t3IekJa+o0Ge5WNyiwLbGHLvtJ+qnUtUsL4FuJ/a2cVOsygxS8sCDCWZnMer0teESBWB/dOl4+0uwlDt4LE25i55bR1QCFiJGXSdscbL2jRrvzVhVjSAO4viWAHgybAD8PqALXl+ATBATHkCd/pAP8KjcbWITpSve5IjV+P3TgRWjYMUqz7ayADX6LLLna5Pk0Hj1xUwPQ0OY5AIrWIfNBj0Q3EBXJOnUCHPg8eafz1tlazY4eItgbTUrybV/z1jXh4pvCufDJSnMb2z2K7lDA6YINiKZXxluVa3CuLXIaw/MjRqXJalA+Vlf4mkOzU0iFxqoW32yZ/4Jp7m8pWelxVYv1iHeAjVRNX8XVNSF+LT9fb0SWW81ICHq7Db0oEW8Ie3FYkLS8f1a/S6LJB8B9Knx/1+m2HcwAoJcv+uNL/AqHVtG523PYfprnkzVj5sz2kPecHD933EUENb/gMqkU6YiLosAZRDmBzM0KWyL6L/x+4mxsvHSLWiulVOCsfQe5bakAA2AuxYuYJsKs7sVfzLMcbxlUvtshAnnaXE7ksynKvCSkKBX1tobsz8NbiRlysetcyCMRl7Dola0zgLMTChBc9B3juXaEx9DIX0ey
 kH7zOJXb
 GLyZRONeWAndWXgSO3gt9mMstl2iUvmI8tF51Rr1nY+HYdhm7pcihniwvVXc5oSovkLeYptKfn3FexNWcC+QLDBcPujey5GwtVGFvvBcgAwdTHfB18pzQTof7a8TksliHFqlITx+yeomWHY0NnnOlF8VMahiBDX8eCIsM3/3Ds/VF9FTGhnni8AyUtNolsfBdGKjXFj9R1+3oGok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 05:39:40PM +0900, Harry Yoo (Oracle) wrote:
> On Fri, Apr 10, 2026 at 07:16:57PM +0800, Hao Li wrote:
> > When performing objects refill, we tend to optimistically assume that
> > there will be more allocation requests coming next; this is the
> > fundamental assumption behind this optimization.
> 
> I think the reason why currently we have two sheaves per CPU instead of
> one bigger sheaf is to avoid unfairly pessimizing when the alloc/free
> pattern frequently changes.

Yes.

> 
> By refilling more objects, frees are more likely to hit the slowpath.
> How can it be argued that this optimization is beneficial to have
> in general, not just for caches with specific alloc/free patterns?

Yes, that's a very valid concern. My thinking here is that the leftover objects
have to be kept somewhere after all, so in this current experimental
implementation I'm trading off future free-path performance for better
allocation performance. It's a pretty tough trade-off either way :/

> 
> > When __refill_objects_node() isolates a partial slab and satisfies a
> > bulk allocation from its freelist, the slab can still have a small tail
> > of free objects left over. Today those objects are freed back to the
> > slab immediately.
> > 
> > If the leftover tail is local and small enough to fit, keep it in the
> > current CPU's sheaves instead. This avoids pushing those objects back
> > through the __slab_free slowpath.
> 
> So there are two different paths:
> 
> 1. When refilling prefilled sheaves, spill objects into ->main and
>    ->spare. 
> 2. When refilling ->main sheaf, spill objects into ->spare.

the current experimental code is biased toward spilling into the spare sheaf
when possible.
for kernels without kernel preemption enabled or !RT, the spare sheaf is
generally NULL at that point, so the main sheaf may still end up being the
primary place to absorb the spill...

>  
> > Add a helper to obtain both the freelist and its free-object count, and
> > then spill the remaining objects into a percpu sheaf when:
> > - the tail fits in a sheaf
> > - the slab is local to the current CPU
> > - the slab is not pfmemalloc
> > - the target sheaf has enough free space
> > 
> > Otherwise keep the existing fallback and free the tail back to the slab.
> > 
> > Also add a SHEAF_SPILL stat so the new path can be observed in SLUB
> > stats.
> > 
> > On the mmap2 case in the will-it-scale benchmark suite,
> 
> > this patch can improve performance by about 2~5%.
> 
> Where do you think the improvement comes from? (hopefully w/ some data)

Yes, this is necessary.

> 
> e.g.:
>   1. the benefit is from largely or partly from
>      reduced contention on n->list_lock.

Before this patch is applied, the mmap benchmark shows the following hot path:

- 7.85% native_queued_spin_lock_slowpath
    -7.85% _raw_spin_lock_irqsave
        - 3.69% __slab_free
            + 1.84% __refill_objects_node
            + 1.77% __kmem_cache_free_bulk
        + 3.27% __refill_objects_node

With the patch applied, the __refill_objects_node -> __slab_free hotspot goes
away, and the native_queued_spin_lock_slowpath drops to roughly 3.5%. The
remaining lock contention is mostly between __refill_objects_node ->
add_partial and __kmem_cache_free_bulk -> __slab_free.

> 
>   2. this change reduces # of alloc slowpath at the cost of increased
>      of free slowpath hits, but that's better because the slowpath frees
>      are mostly lockless.

The alloc slowpath remains at 0 both w/ or w/o the patch, whereas the
free slowpath increases by 2x after applying the patch.

> 
>   3. the alloc/free pattern of the workload is benefiting from
>      spilling objects to the CPU's sheaves.
> 
> or something else?

The 2-5% throughput improvement does seem to come with some trade-offs.
The main one is that leftover objects get hidden in the percpu sheaves now,
which reduces the objects on the node partial list and thus indirectly
increases slab alloc/free frequency to about 4x of the baseline.

This is a drawback of the current approach. :/

I experimented with several alternative ideas, and the pattern seems fairly
consistent: as soon as leftover objects are hidden at the percpu level, slab
alloc/free churn tends to go up.

> 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> > 
> > This patch is an exploratory attempt to address the leftover objects and
> > partial slab issues in the refill path, and it is marked as RFC to warmly
> > welcome any feedback, suggestions, and discussion!
> 
> Yeah, let's discuss!

Sure! Thanks for the discussion!

> 
> By the way, have you also been considering having min-max capacity
> for sheaves? (that I think Vlastimil suggested somewhere)

Yes, I also tried it.

I experimented with using a manually chosen threshold to allow refill to leave
the sheaf in a partially filled state. However, since concurrent frees are
inherently unpredictable, this seems can only reduce the probability of
generating leftover objects, while at the same time affecting alloc-side
throughput. In my testing, the results were not very encouraging: it seems hard
to observe improvement, and in most cases it ended up causing a performance
regression.

my impression is that it could be difficult to prevent leftovers proactively.
It may be easier to deal with them after they appear.



Besides, I also tried another idea: maintaining a dedicated spill sheaf in the
barn, protected by the barn lock, and placing leftover objects there. Then,
during refill, barn_replace_empty_sheaf() would first try the spill sheaf, and
if it contained objects, it would swap spill and main, avoiding consumption
from barn->full_list.

With this approach, I still couldn't observe meaningful performance
change. Slab alloc/free churn still present, although the increase was
relatively small, at around 1.x

My guess is that while this approach pulls leftovers up to the barn level and
avoids the cost of pushing them back down to the node partial list level, the
serialized nature of the barn lock means leftovers cannot be deposited into the
spill sheaf with high concurrency. As a result, the placement is not fast
enough, and the performance gain remains limited.

-- 
Thanks,
Hao

