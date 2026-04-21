Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A1CF5A8DE
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 03:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94566B0088; Mon, 20 Apr 2026 23:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44F56B0089; Mon, 20 Apr 2026 23:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34D56B008A; Mon, 20 Apr 2026 23:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD49A6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:35:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6AA3C13C123
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:35:22 +0000 (UTC)
X-FDA: 84681147684.16.1CD78C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C60CC0003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:35:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s9Zh1QKB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776742520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxnByL9A7Lxu09KCzn/dzXDPK9ZjlD8rlcxnr7sCdVg=;
	b=wG2OFcnxRULUt71VELxFmwCerAcs8kou7mvdesYsQuOkD1vHwixVHJ7lYGmlmB34jAtKsJ
	LuKxe0s7n66590kUy0DbbU3gX29rSImuebUsHauDqyz4floIVJ+Kh3ub09OUweJuS7aJHs
	Y0xp2wsYb6bVNf/PUH18sUuaTRwmgrQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s9Zh1QKB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776742520; a=rsa-sha256;
	cv=none;
	b=UyIJ1Q1nauOyU/qCnOETqnW3fl3skDD//oiKtbmRptRp2IwCirF6dL6VWspFvRdMe1zEvL
	DXNs9lq1duExzq8NgGgyefLArJ+aJJTi2QxrXpgjDf8igYXCP1DQHczisqIRaXNNTSJuNn
	WsPy4CvYtXvtnuBk5FEbdTprOEmDFmk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D29542E41;
	Tue, 21 Apr 2026 03:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B214CC2BCB3;
	Tue, 21 Apr 2026 03:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776742519;
	bh=Cei8ph+R3GmKmj6ieR8Gj909JPjX7yBRxjPIycifgtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s9Zh1QKByRIF7UFwpRpDiKcXxaWInrm+BYrmGlFg27lW+PibJxBk9mdkL01Tve969
	 VdOs/tK+b/rvZ7hR8biaf6dn9C1btA1XuyHvZkawXpxc/ZKAUJSxgHhgc8zt9OTBHT
	 WvPsAHm9A4cqsM2xTi3Hrp/gDQ+8b2GyaPRX4Y2JMCZRo7L4us6z6r2ryBUl8GahbA
	 d/I6Ar8hslVNQ5XQxE6pVxyGiJ0MC49eGLc13eroVBJhTXhrVLHaWyXOCdKYBl2A4u
	 Y7Ow9s6bS9O03bWZdwXnVqpfkBaypfjLbzX5TcW/pOlYSr76J0QaNXy5PsZUqFcVPz
	 lprFsmljXCMvg==
Date: Tue, 21 Apr 2026 12:35:16 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <aebwdFf645couPgu@hyeyoo>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <ad39TJZYLItrEnIM@hyeyoo>
 <bbtmo4fffalhjglohnazrxvplzfxelmuivbonnbfi3gzsm7qj3@bvh42p47dsqa>
 <ad9mZeERenhwh7De@hyeyoo>
 <6k3etcsawcw3zsh5mphc2kj3l2griymug3hvchnwubskwanbc4@gekaw6jn7pi4>
 <aeHMfXldGQ0ANL-K@hyeyoo>
 <ybffdlcvyls3cmen67b3ewno3vwdag6timnqjcoomipd2ei5sg@r3goxchyn3ib>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ybffdlcvyls3cmen67b3ewno3vwdag6timnqjcoomipd2ei5sg@r3goxchyn3ib>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9C60CC0003
X-Stat-Signature: bf9f9zx9cgrxyhnku3g1poashw6qurts
X-Rspam-User: 
X-HE-Tag: 1776742520-767374
X-HE-Meta: U2FsdGVkX1+bPWgLF6gs8v0oBiR+SNmR8jowMu1lRLqwrd3pvV94UO4O3350EVGH7TgRbg/0gJgV9W5aG7JnLFSbSmILJrPW/J/ao+1825jlBZ6LAAjt/QA6xLfC1tj2aQdOwh/5NPJKFvqGHhkm4xHypepqkrGZGWc9t09X1qnEOJiKdk01N1oUA1byAMW8QH4FLOCJ1m1qa3HmmNY1vW65ro6L7xm6Y1HYlopj1RSMD4nszZsTwfpLrXjFTl9yc2Q0N3tZ8s+qCOuHP62JI9YgOndpskn3X//Zl03tTYX4nGihD/egwReiSP9i9d+mReDSzwhtZkKTGuNUYUfKYJNi7sl050/q5iVkFhMU+yqpVmkA7JoKT2G/D8/hmUrtS1t+UhO3F9tfKwf+AMR1BrKD2jXchlkh/fZc7/In8RokCwjAH2BNm+HpOTG47g/F9/OYJE2JjQjLudghlIMOGyy7p4tq9elb26QgW4dRCvGjbWDGP8F1BBrqNQlo1N9TGN6LGWolYI7Ayq2eS2phsWIEQe8I0VZGRub4dGZouOFdoH18AdH61Y7QVH3fAJ17aqWTr5R3OIvRx+GWEGIIuypq8CTwdXr5aGg0FVcsNO+xo4uyv2Iqmy2sWlZoDzxT+dVk3ozhVAnVBTVmVdl0Opa/nK7ik647TBSDRWJWcAQcc/jT97qNnJRklhQL5rFkwQ+819PQ1B/JkJKShSj782Zt+HLRFU1A7+5Ze36TaiefYIsQTab+IA254F2WulzOCj1A6Fmbm95Lwlt9RWYxWJrdJZIwauna4HrTk2XqcOpbDMXaIpWT4uXQcpQxAgjOR7CRFqo1lCQGXTHVy5NtaL4yU9BzabV3Errk1EsbBB3iMJz7ZT0iOzhAikCrFjDH3fe/L7V9u9hZ5qz2GqJMoiqkgDlCv0EKQEIP973EmpNHjzyTsVG3zgDqEcoND/RmlLHSjn+uJZbUHndRAoG
 6pUdjktq
 kRTzX5eOj2/KCzrdg05v2EnfdsBhRIikZydAyjoO2Ie2StgwVyfrzyhP0HLdsDWu2vgpoVbspuXdsaxJiGot9xmU31X+UfSBNThHPhl1Y2zk1ErmpRT/BVWWkO5QnJSqK2heaBxyBDJs7Kw2SFYc180wlhjQDmgScCOYK9QTngcerC8mKTRvuPyAw4xUwb0cFgx/pB/pBn3Lrl8z08KfNxgleLDgpWq3T0n7ROH+SZJhxlvqTn8mBj778u65bKllv8jtf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 07:40:55PM +0800, Hao Li wrote:
> On Fri, Apr 17, 2026 at 03:00:29PM +0900, Harry Yoo (Oracle) wrote:
> > On Thu, Apr 16, 2026 at 03:58:46PM +0800, Hao Li wrote:
> > > On Wed, Apr 15, 2026 at 07:20:21PM +0900, Harry Yoo (Oracle) wrote:
> > > > On Tue, Apr 14, 2026 at 05:59:48PM +0800, Hao Li wrote:
> > > > > The 2-5% throughput improvement does seem to come with some trade-offs.
> > > > > The main one is that leftover objects get hidden in the percpu sheaves now,
> > > > > which reduces the objects on the node partial list and thus indirectly
> > > > > increases slab alloc/free frequency to about 4x of the baseline.
> > > > > 
> > > > > This is a drawback of the current approach. :/
> > > > 
> > > > Sounds like s->min_partial is too small now that we cache more objects
> > > > per CPU.
> > > 
> > > Exactly. for the mmap test case, the slab partial list keeps thrashing. It
> > > makes me wonder whether SLUB might handle transient pressure better if empty
> > > slabs could be regulated with a "dynamic burst threshold"
> > 
> > Haha, we'll be constantly challenged to find balance between "sacrifice
> > memory to make every benchmark happy" vs. "provide reasonable
> > scalability in general but let users tune it themselves". 
> > 
> > If we could implement a reasonably simple yet effective automatic tuning
> > method, having one in the kernel would be nice (though of course having
> > it userspace would be the best).
> 
> Yes, I'm gradually feeling that SLUB's flow is so tight and simple that doing a
> one-size-fits-all optimization is super hard.

Agreed.

> It might be better to just export some parameters to userspace and let users
> tune them.

Agreed.

However, people often don't try tuning and report
"regressions"... *ahem* ;)

> After all, introducing an auto-tuning mechanism into a core allocator like SLUB
> might make it as unpredictable and hard to control as memory reclaim. :P

:-)

> > > > /me wonders if increasing sheaf capacity would make more sense
> > > > rather than optimizing slowpath (if it comes with increased memory
> > > > usage anyway),
> > > 
> > > Yes, finding ways to avoid falling onto the slowpath is also very worthwhile.
> > 
> > Could you please take a look at how much changing 1) sheaf capacity and
> > 2) nr of full/empty sheaves at the barn affects the performance of
> > mmap / ublk performance?

FWIW, we have two more parameters in SLUB
(yes, we have too many parameters):

3) s->remote_node_defrag_ratio and 4) s->min_partial.

The default s->remote_node_defrag_ratio value is configured to favor
smaller memory usage over NUMA locality (which, in some cases, is not
ideal).

Higher s->min_partial makes SLUB cache more slabs in n->partial.

> > I've been trying to reproduce the regression on my machine but haven't
> > had much success so far :(
> > 
> > (I'll try to post the RFC patchset to allow changing those parameters
> > at runtime in few weeks but if you're eager you could try experimenting
> > by changing the code :D)
> 
> Sure thing. I'll run some tests and organize the data.

Thanks a lot for taking a look ;-)

> > > > but then stares at his (yet) unfinished patch series...
> > > > 
> > > > > I experimented with several alternative ideas, and the pattern seems fairly
> > > > > consistent: as soon as leftover objects are hidden at the percpu level, slab
> > > > > alloc/free churn tends to go up.
> > > > > 
> > > > > > > Signed-off-by: Hao Li <hao.li@linux.dev>
> > > > > > > ---
> > > > > > > 
> > > > > > > This patch is an exploratory attempt to address the leftover objects and
> > > > > > > partial slab issues in the refill path, and it is marked as RFC to warmly
> > > > > > > welcome any feedback, suggestions, and discussion!
> > > > > > 
> > > > > > Yeah, let's discuss!
> > > > > 
> > > > > Sure! Thanks for the discussion!
> > > > > 
> > > > > > 
> > > > > > By the way, have you also been considering having min-max capacity
> > > > > > for sheaves? (that I think Vlastimil suggested somewhere)
> > > > > 
> > > > > Yes, I also tried it.
> > > > > 
> > > > > I experimented with using a manually chosen threshold to allow refill to leave
> > > > > the sheaf in a partially filled state. However, since concurrent frees are
> > > > > inherently unpredictable, this seems can only reduce the probability of
> > > > > generating leftover objects,
> > > > 
> > > > If concurrent frees are a problem we could probably grab slab->freelist
> > > > under n->list_lock (e.g. keep them at the end of the sheaf) and fill the
> > > > sheaf outside the lock to avoid grabbing too many objects.
> > > 
> > > Do you mean doing an on-list bulk allocation?
> > 
> > Just brainstorming... it's quite messy :)
> > something like
> > 
> > __refill_objects_node(s, p, gfp, min, max, n, allow_spin) {
> > 	// in practice we don't know how many slabs we'll grab.
> > 	// so probably keep them somewhere e.g.) the end of `p` array?
> > 	void *freelists[min];
> > 	nr_freelists = 0;
> > 	nr_objs = 0;
> > > > 	spin_lock_irqsave();
> > 	for each slab in n->partial {
> > 		freelist = slab->freelist;
> > 		do {
> > 			[...]
> > 			old.freelist = slab->freelist;
> > 			[...] > > 		} while (!__slab_update_freelist(...));
> > 
> > 		freelists[nr_freelists++] = old.freelist;
> > 		nr_objs += (old.objects - old.inuse);
> > 		if (!new.inuse)
> > 			remove_partial();
> > 		if (nr_objs >= min)
> > 			break;
> > 	}
> > 	spin_unlock_irqrestore();
> > 
> > 	i = 0;
> > 	j = 0;
> > 	while (i < nr_freelists) {
> > 		freelist = freelists[i++];
> > 		while (freelist != NULL) {
> > 			if (j == max) {
> > 				// free remaining objects
> > 			}
> > 			next = get_freepointer(s, freelist);
> > 			p[j++] = freelist;
> > 			freelist = next;
> > 		}
> > 	}
> > }
> > 
> > This way, we know how many objects we grabbed but yeah it's tricky.
> 
> Thanks for this brainstorming.
> If we do an atomic operation like __slab_update_freelist under the lock, I'm
> worried it might prolong the critical section.

Fun fact: SLUB had been doing __slab_update_freelist() under the lock
for a long time until very recently. (If interested, see commit
8cd3fa428b5 ("slub: Delay freezing of partial slabs"))

> But testing is the best way to know for sure.

Yeah, that really depends on which is more problematic:
doing cmpxchg128 under n->list_lock vs. grabbing too many objects
(due to concurrent frees) so that we return slab back to the list.

But without allowing partial refills, we'll end up returning slab back
to the list anyway.

> I'm quite curious, so it's definitely worth a try.

Again, appreciate spending time on investigating the performance.

> > > > > while at the same time affecting alloc-side throughput.
> > > > 
> > > > Shouldn't we set sheaf's min capacity as the same as
> > > > s->sheaf_capacity and allow higher max capcity to avoid this?
> > > 
> > > I'm not sure I fully understand this. since the array size is fixed, how would
> > > we allow more entries to be filled?
> > 
> > I don't really want to speak on behalf of Vlastimil but I was imagining
> > something like:
> > 
> > before: sheaf->capacity (32, min = max); 
> > after: sheaf->capacity (48 or 64, max), sheaf->threshold (32, min)
> > 
> > so that sheaf refill will succeed if at least ->threshold objects
> > are filled, but the threshold better not be smaller than 32 (the
> > previous sheaf->capacity)?
> 
> I feel that simply increasing the sheaf capacity should generally improve
> overall performance,

Well, if simply increasing the sheaf capacity entirely solves
the problem, this isn't really worth it.

To reiterate the question: To allow partial refill to work while
avoiding regressions, we need to make sheaves larger than before.
That inevitably consumes (although we don't always fully refill them)
more memory. Is this trade-off worth it?

If we can avoid the contention by tuning parameters without
such a micro-optimization, I think it's worth it only if tuning
requires much more memory to reach the same performance.

Or if there are corner cases (e.g., perhaps cross-CPU frees or
remote frees? dunno) where tuning does not resolve this issue,
I'd say it's worth it.

> although we'd likely see more slab alloc/free churn
> compared to the baseline.

I think it's okay to allocate/free slabs more frequently, as long as
that doesn't hurt performance (luckily, today, buddy's PCP caches high
order pages, unlike a decade ago).

But if higher alloc/free churn means higher slab memory usage,
that's a concern.

> One thing I'm wondering about is how we determine if an optimization is truly
> worth doing.

We do an optimization when we can convince people that it's worth it
(or at least a reasonable tradeoff).

> Micro-optimizations like this rarely have purely positive effects; they often
> come with fluctuations or regressions in other metrics-such as more frequent
> slab allocations and frees, which adds pressure to the buddy system.
>
> So this kind of ties our hands a bit :/
>
> > > > > In my testing, the results were not very encouraging: it seems hard
> > > > > to observe improvement, and in most cases it ended up causing a performance
> > > > > regression.
> > > > > 
> > > > > my impression is that it could be difficult to prevent leftovers proactively.
> > > > It may be easier to deal with them after they appear.
> > > > 
> > > > Either way doesn't work if the slab order is too high...
> > > > 
> > > > IIRC using higher slab order used to have some benefit
> > > > but now that we have sheaves, it probably doesn't make sense anymore
> > > > to have oo_objects(s->oo) > s->sheaf_capacity?
> > > 
> > > Do you mean considering making the capacity of each sheaf larger than
> > > oo_objects?
> > 
> > I mean the other way around. calculate_order() tends to increase slab
> > order with higher number of CPUs (by setting higher `min_objects`),
> > but is it still worth having oo_objects higher than the sheaf capacity?
> 
> Sorry, I just got confused for a second. Why is it a good thing for oo_objects
> to be larger than the sheaf capacity? I didn't quite catch the logic behind
> that...

I think nobody intended that "It's a good thing for oo_objects() to be
larger than the sheaf capacity": when the slab order calculation logic
was written, sheaves didn't exist.

Having high order slabs used to have some benefits (before sheaves):

1. CPU slab could serve more objects (in fastpath).

2. Percpu partial slab list needed fewer slabs to cache the same number
   of objects, which reduced the contention on n->list_lock.

3. (please add if there's more)

I chatted about this off-list, and a few people mentioned that
having high order slabs may still help reduce avoiding external
fragmentation (at the cost of internal fragmentation).

[A bit irrelevant but fun SLUB history]

In the traditional SLUB, we didn't precisely track the number of objects
cached per CPU. In extreme cases, the traditional SLUB could somehow
tranlsate "cache 30 objects per CPU" to "cache 30 _slabs_ per CPU".

See how extreme it could be, compared to what we've been discussing
here? ;)

At some point Vlastimil fixed that imprecise logic and instead assumed
that all slabs are half full (which was still imprecise but better than
before) (If interested, see b47291ef02b0b ("mm, slub: change percpu
partial accounting from objects to pages"))

-- 
Cheers,
Harry / Hyeonggon

