Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1094F36C58
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 11:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 333116B00A4; Mon, 20 Apr 2026 07:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E42C6B00A5; Mon, 20 Apr 2026 07:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA296B00A7; Mon, 20 Apr 2026 07:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC326B00A4
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:41:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 908355BB73
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:41:48 +0000 (UTC)
X-FDA: 84678744696.24.84F772A
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id CFA2EA000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:41:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V9J4oCiY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776685306; a=rsa-sha256;
	cv=none;
	b=l1mXzG1/1Osi/4wTNtYMywIbzwt5CtlaAcIP/2YrbH7aaHWCOsEURzIhgANwn8tMYcEOf+
	wMxXQZdIYNDEQyLW+wKnn/bImvMsgDY/UqDcXB3EtCgEdgOavZdzbnadYGhnNPU7rRfwd7
	uHtoXmmEfSsi6k6NOX4PBzGSd9RhkU4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V9J4oCiY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776685306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LxKNCVj8zW4SLkH4nmFq3H6C9VGsJhMzrkrSfjf0UM=;
	b=U+b8j/PID7nHDUX5Z6+uZHJYEAAUbws0BO2PaDlm8WkOi+mr6q5NL0yhr4Klu6+eHTF6vm
	LTKRjXim7Tim7qtD/X5RDGgNv3/aPsNd/ebNo8rloIL1P2ybdvCmvK9qXJ+Rsd8UOSOLip
	xzT2qyp2FJucEyR9Q9KyaYvoRZjiVcc=
Date: Mon, 20 Apr 2026 19:40:55 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776685302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2LxKNCVj8zW4SLkH4nmFq3H6C9VGsJhMzrkrSfjf0UM=;
	b=V9J4oCiYSFEKZ39z1ZSxBwGlvbjlM8j9nQKDDaMtG9cpouVFZQO3b5JATMJ7EjXpwSESUU
	qicY51QEWGw5CLMv7xNRFf6gB8QyURpYVeYmeUtthjh0OyylZdk87E7WUx80s+c09BV0xM
	lFeqiDASZy9qxMCoAyzEikXStvm+Lrw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <ybffdlcvyls3cmen67b3ewno3vwdag6timnqjcoomipd2ei5sg@r3goxchyn3ib>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <ad39TJZYLItrEnIM@hyeyoo>
 <bbtmo4fffalhjglohnazrxvplzfxelmuivbonnbfi3gzsm7qj3@bvh42p47dsqa>
 <ad9mZeERenhwh7De@hyeyoo>
 <6k3etcsawcw3zsh5mphc2kj3l2griymug3hvchnwubskwanbc4@gekaw6jn7pi4>
 <aeHMfXldGQ0ANL-K@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeHMfXldGQ0ANL-K@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: m1ujtp8nztzu7z96cb1khd6jqm7kkqwt
X-Rspam-User: 
X-Rspamd-Queue-Id: CFA2EA000F
X-HE-Tag: 1776685304-147747
X-HE-Meta: U2FsdGVkX19kXb7dJXJSQYobzggR1/stQeTFwLMqBEkbOwQ+ZAUBqxlDcmldwQv6Erwz0HtsjiIDwBWKdtNp7cWcWgcdzou7C7a8Ekl0XZRmPhLk9F2I51moCcE1tWpJ0TGRDmkASpLZxUqwzklvFNsqWAAe+Ni1MeV9iOzsnLvzBlZMFgrR8g16MU5Ww7yl68bBQcCIqI81Kdis8f/tuNvevAzDKmYRQlnrl0c1cBVoqrav3bPBChPvpiful5b8AcV1ARhjldGi/sfltWhC5ZhxtMuT0831jeDg4JSK6A716SvgVa1kfI0WAorViVFygkyh4PzN/WzA/zDxNFFXhhroazA8FREl+KwPySm5ctW+a03gULP5gx+SyiqRRWW/LESQagEeVT0C1tIj796BavbtOcO3JcQdGxZkdcMpC3b+/8n7veoGO19Mg21yHUMs+Qi+1X8AoBcBeY/PWLg7bQqEkw9Cd5hTFRBAoY5aMVCIZBJXJs99FBXDk3ctFTdkmlVotV9T5axX7uq1Ke3EOSWUzpRWfBpCAA/2wMUgt7X9WxjxCh4fdIrmlUE2vdRmKPaj44IWQq5nmjo6oonDJI92swC9ahpd4SOjtbDYaohBxbS7fOHeEaexnfKJJ+W+jKI0CxVJYTilSTpkD/ykXzPJWfipoyNSA63xxb8O/rCvzhyT9b4TpIHs2bZJksRww4jKhkQG+2Flxpy9WCDH6mZzyzMacoQGcQfWW7QHAVb/O8wR4OGFA8A/1cmj9uBQaMJP7nnS39jl/rGHiD3YyOiK9ERbY90e25mYhJ1rmC1JVzxXgKWAcNcUDjy68qWMGsNZaBpMzLm4nRL/3v61Qy0e2jB16Niiv9ajgYLcMeyimsrlD8/s6BbSIJekOYOUFdgbihn82lZJV2DpFL6PMfWwa1kFJpUN5MG3q97WLKpeeqUi7IdtFoTuQRNX1VmAUVXwEn6K+7WJ9+Pukjh
 CmnfjG3E
 hpTb9BmwZlL5HxQjgHHLDnXp05nrp5pDUWjwFAMfmPXNJK1s9PsETwJhIlf4vkq1lgo31hGyrAPeuZRdIwJDlI1pswxq+nrZqEOrm2cuEL6BB7CVJsMGfj2sQdm1LQsE6D4apcw1PuZ0pC4euthcJjK8fih8mF4Ko9feHWY7ioWD31bv6s9u9fOag/L5X/fN6Zh60GW3zsWkq8/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 03:00:29PM +0900, Harry Yoo (Oracle) wrote:
> On Thu, Apr 16, 2026 at 03:58:46PM +0800, Hao Li wrote:
> > On Wed, Apr 15, 2026 at 07:20:21PM +0900, Harry Yoo (Oracle) wrote:
> > > On Tue, Apr 14, 2026 at 05:59:48PM +0800, Hao Li wrote:
> > > > On Tue, Apr 14, 2026 at 05:39:40PM +0900, Harry Yoo (Oracle) wrote:
> > > > > On Fri, Apr 10, 2026 at 07:16:57PM +0800, Hao Li wrote:
> > > > > Where do you think the improvement comes from? (hopefully w/ some data)
> > > > 
> > > > Yes, this is necessary.
> > > > 
> > > > > e.g.:
> > > > >   1. the benefit is from largely or partly from
> > > > >      reduced contention on n->list_lock.
> > > > 
> > > > Before this patch is applied, the mmap benchmark shows the following hot path:
> > > > 
> > > > - 7.85% native_queued_spin_lock_slowpath
> > > >     -7.85% _raw_spin_lock_irqsave
> > > >         - 3.69% __slab_free
> > > >             + 1.84% __refill_objects_node
> > > >             + 1.77% __kmem_cache_free_bulk
> > > >         + 3.27% __refill_objects_node
> > > > 
> > > > With the patch applied, the __refill_objects_node -> __slab_free hotspot goes
> > > > away, and the native_queued_spin_lock_slowpath drops to roughly 3.5%.
> > > 
> > > Sounds like returning slabs back indeed increases contention on slowpath.
> > 
> > Indeed!
> >
> > > > The
> > > > remaining lock contention is mostly between __refill_objects_node ->
> > > > add_partial and __kmem_cache_free_bulk -> __slab_free.
> > > > 
> > > > > 
> > > > >   2. this change reduces # of alloc slowpath at the cost of increased
> > > > >      of free slowpath hits, but that's better because the slowpath frees
> > > > >      are mostly lockless.
> > > > 
> > > > The alloc slowpath remains at 0 both w/ or w/o the patch, whereas the
> > > 
> > > (assuming you used SLUB_STATS for this)
> > 
> > Yes, I enable it.
> > 
> > > That's weird, I think we should check SHEAF_REFILL instead of
> > > ALLOC_SLOWPATH.
> > 
> > Yes, I will compare each metrics for later testing. Maybe we can see more
> > clues.
> > 
> > > > free slowpath increases by 2x after applying the patch.
> > > 
> > > from which cache was this stat collected?
> > 
> > It's for /sys/kernel/slab/maple_node/
> 
> Ack. And you also mentioned (off-list) that kmem_cache_refill_sheaf()
> is not on the profile. That's good to know.
> 
> > > > >   3. the alloc/free pattern of the workload is benefiting from
> > > > >      spilling objects to the CPU's sheaves.
> > > > > 
> > > > > or something else?
> > > > 
> > > > The 2-5% throughput improvement does seem to come with some trade-offs.
> > > > The main one is that leftover objects get hidden in the percpu sheaves now,
> > > > which reduces the objects on the node partial list and thus indirectly
> > > > increases slab alloc/free frequency to about 4x of the baseline.
> > > > 
> > > > This is a drawback of the current approach. :/
> > > 
> > > Sounds like s->min_partial is too small now that we cache more objects
> > > per CPU.
> > 
> > Exactly. for the mmap test case, the slab partial list keeps thrashing. It
> > makes me wonder whether SLUB might handle transient pressure better if empty
> > slabs could be regulated with a "dynamic burst threshold"
> 
> Haha, we'll be constantly challenged to find balance between "sacrifice
> memory to make every benchmark happy" vs. "provide reasonable
> scalability in general but let users tune it themselves". 
> 
> If we could implement a reasonably simple yet effective automatic tuning
> method, having one in the kernel would be nice (though of course having
> it userspace would be the best).

Yes, I'm gradually feeling that SLUB's flow is so tight and simple that doing a
one-size-fits-all optimization is super hard.
It might be better to just export some parameters to userspace and let users
tune them.
After all, introducing an auto-tuning mechanism into a core allocator like SLUB
might make it as unpredictable and hard to control as memory reclaim. :P

> 
> > > /me wonders if increasing sheaf capacity would make more sense
> > > rather than optimizing slowpath (if it comes with increased memory
> > > usage anyway),
> > 
> > Yes, finding ways to avoid falling onto the slowpath is also very worthwhile.
> 
> Could you please take a look at how much changing 1) sheaf capacity and
> 2) nr of full/empty sheaves at the barn affects the performance of
> mmap / ublk performance?
> 
> I've been trying to reproduce the regression on my machine but haven't
> had much success so far :(
> 
> (I'll try to post the RFC patchset to allow changing those parameters
> at runtime in few weeks but if you're eager you could try experimenting
> by changing the code :D)

Sure thing. I'll run some tests and organize the data.

>  
> > > but then stares at his (yet) unfinished patch series...
> > > 
> > > > I experimented with several alternative ideas, and the pattern seems fairly
> > > > consistent: as soon as leftover objects are hidden at the percpu level, slab
> > > > alloc/free churn tends to go up.
> > > > 
> > > > > > Signed-off-by: Hao Li <hao.li@linux.dev>
> > > > > > ---
> > > > > > 
> > > > > > This patch is an exploratory attempt to address the leftover objects and
> > > > > > partial slab issues in the refill path, and it is marked as RFC to warmly
> > > > > > welcome any feedback, suggestions, and discussion!
> > > > > 
> > > > > Yeah, let's discuss!
> > > > 
> > > > Sure! Thanks for the discussion!
> > > > 
> > > > > 
> > > > > By the way, have you also been considering having min-max capacity
> > > > > for sheaves? (that I think Vlastimil suggested somewhere)
> > > > 
> > > > Yes, I also tried it.
> > > > 
> > > > I experimented with using a manually chosen threshold to allow refill to leave
> > > > the sheaf in a partially filled state. However, since concurrent frees are
> > > > inherently unpredictable, this seems can only reduce the probability of
> > > > generating leftover objects,
> > > 
> > > If concurrent frees are a problem we could probably grab slab->freelist
> > > under n->list_lock (e.g. keep them at the end of the sheaf) and fill the
> > > sheaf outside the lock to avoid grabbing too many objects.
> > 
> > Do you mean doing an on-list bulk allocation?
> 
> Just brainstorming... it's quite messy :)
> something like
> 
> __refill_objects_node(s, p, gfp, min, max, n, allow_spin) {
> 	// in practice we don't know how many slabs we'll grab.
> 	// so probably keep them somewhere e.g.) the end of `p` array?
> 	void *freelists[min];
> 	nr_freelists = 0;
> 	nr_objs = 0;
> 
> 	spin_lock_irqsave();
> 	for each slab in n->partial {
> 		freelist = slab->freelist;
> 		do {
> 			[...]
> 			old.freelist = slab->freelist;
> 			[...]
> 		} while (!__slab_update_freelist(...));
> 
> 		freelists[nr_freelists++] = old.freelist;
> 		nr_objs += (old.objects - old.inuse);
> 		if (!new.inuse)
> 			remove_partial();
> 		if (nr_objs >= min)
> 			break;
> 	}
> 	spin_unlock_irqrestore();
> 
> 	i = 0;
> 	j = 0;
> 	while (i < nr_freelists) {
> 		freelist = freelists[i++];
> 		while (freelist != NULL) {
> 			if (j == max) {
> 				// free remaining objects
> 			}
> 			next = get_freepointer(s, freelist);
> 			p[j++] = freelist;
> 			freelist = next;
> 		}
> 	}
> }
> 
> This way, we know how many objects we grabbed but yeah it's tricky.

Thanks for this brainstorming.
If we do an atomic operation like __slab_update_freelist under the lock, I'm
worried it might prolong the critical section. But testing is the best way to
know for sure. I'm quite curious, so it's definitely worth a try.

> 
> > > > while at the same time affecting alloc-side throughput.
> > > 
> > > Shouldn't we set sheaf's min capacity as the same as
> > > s->sheaf_capacity and allow higher max capcity to avoid this?
> > 
> > I'm not sure I fully understand this. since the array size is fixed, how would
> > we allow more entries to be filled?
> 
> I don't really want to speak on behalf of Vlastimil but I was imagining
> something like:
> 
> before: sheaf->capacity (32, min = max); 
> after: sheaf->capacity (48 or 64, max), sheaf->threshold (32, min)
> 
> so that sheaf refill will succeed if at least ->threshold objects
> are filled, but the threshold better not be smaller than 32 (the
> previous sheaf->capacity)?

I feel that simply increasing the sheaf capacity should generally improve
overall performance, although we'd likely see more slab alloc/free churn
compared to the baseline.

One thing I'm wondering about is how we determine if an optimization is truly
worth doing.

Micro-optimizations like this rarely have purely positive effects; they often
come with fluctuations or regressions in other metrics-such as more frequent
slab allocations and frees, which adds pressure to the buddy system.
So this kind of ties our hands a bit :/

> 
> > > > In my testing, the results were not very encouraging: it seems hard
> > > > to observe improvement, and in most cases it ended up causing a performance
> > > > regression.
> > > > 
> > > > my impression is that it could be difficult to prevent leftovers proactively.
> > > It may be easier to deal with them after they appear.
> > > 
> > > Either way doesn't work if the slab order is too high...
> > > 
> > > IIRC using higher slab order used to have some benefit
> > > but now that we have sheaves, it probably doesn't make sense anymore
> > > to have oo_objects(s->oo) > s->sheaf_capacity?
> > 
> > Do you mean considering making the capacity of each sheaf larger than
> > oo_objects?
> 
> I mean the other way around. calculate_order() tends to increase slab
> order with higher number of CPUs (by setting higher `min_objects`),
> but is it still worth having oo_objects higher than the sheaf capacity?

Sorry, I just got confused for a second. Why is it a good thing for oo_objects
to be larger than the sheaf capacity? I didn't quite catch the logic behind
that...

-- 
Thanks,
Hao

