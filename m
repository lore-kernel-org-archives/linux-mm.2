Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41E0F8A141
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 07:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA136B0005; Thu, 16 Apr 2026 03:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B2C6B0089; Thu, 16 Apr 2026 03:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87DE6B008A; Thu, 16 Apr 2026 03:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C51E06B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:58:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 659B216076E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:58:58 +0000 (UTC)
X-FDA: 84663667956.17.AAC8609
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7D6761A000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:58:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XGffqLNJ;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776326336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJfP9gfY1w4vQIAW5gfovJ1h698JS1cwjlLneX0j8mU=;
	b=z/y3x4EEZMkcuuTMZmLqXFjnNx82E1AR5tghCuNOmInNEt9nsIidKAkC2OVuK1jQOvf+Ul
	QqPzmN/oGSP1K7cZN5P76c/ZZdvx7/g/zekE2V4DzQT8YSFao5fKxnBbdfo5ROQEP9a/Hs
	+Izd322Ezrknbww791PGl+r1VxOJXyo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XGffqLNJ;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776326336; a=rsa-sha256;
	cv=none;
	b=7MYDmvGQu81m4NZQyy6hZpPFsh2ZRfH7yUWNykJGfhf+aDbuSfLatB5YpiFQDkxAR4n3/u
	Yx6RDjhe+83c89VREDHbq6vqoWaAUCi9hdrZNHf92bokCfJ/qqAdwfZ/s56hNeQVKZDGYL
	2JP5JI4tksCNWU7DfZq88fSRjq+eNUo=
Date: Thu, 16 Apr 2026 15:58:46 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776326334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QJfP9gfY1w4vQIAW5gfovJ1h698JS1cwjlLneX0j8mU=;
	b=XGffqLNJcFeSswgBuWsZDcG7gGjeS3rXRTSKrIa26xN7cC2ep3mhVxn6H3BvgJPtuRagEB
	7Ouk/SpvzXsMnPHJdNwfFxUwgqL21TDQuYfqfpCFTeDbGcd7RIwamcFAktNocjkdWFyM9q
	iSEqI+Ss7Q1VsbmNDvAzfBQm/aELrz4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <6k3etcsawcw3zsh5mphc2kj3l2griymug3hvchnwubskwanbc4@gekaw6jn7pi4>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <ad39TJZYLItrEnIM@hyeyoo>
 <bbtmo4fffalhjglohnazrxvplzfxelmuivbonnbfi3gzsm7qj3@bvh42p47dsqa>
 <ad9mZeERenhwh7De@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad9mZeERenhwh7De@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: aqbneuxram534tow3oye7nzr5rbzjy5o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7D6761A000D
X-HE-Tag: 1776326336-946396
X-HE-Meta: U2FsdGVkX1+bZgMwoHhEBmrJaI/7kFPETAtqANmZ1KlAYTVpLkcikY6ockC96OUNJSPsNE32GbyMp+nfC+FkVeeCn6bGrdNggOc9XbgmcR78iva5bn+yktYDf11oMte9kaxmDS14I3LdIz7QcgUvAfo6nrC5Z8IwIp8Y8nTzOLNQh1Jrua1VDW+NZq0k6txhK7QTTdT53Ngka1QMyLLx2CNekpFJ1JS8H363Mj0v3ZPFVABM/k+/zkCSHFlfzzEvXBf9dPetZZWsqqP6BFMUmHDFWVxE64F/VXY+rK+TDPtaYJFXeJTyL6cNT67BMid2ewSSpjTbeVFk5lkdmQaCw5UMVI5wleOKNnxgFFVG6X0OOfXUmQ28Eeld7FD/W2jiwdPOSV6bMf7QtG3Pyx7yiGpIOonHDCALsAHdptpMDwKidcHFB3Jgdkt0e/5HoU8Fe0HDxpRv0o7IHf/P8snh0sCZCd8qPHCkSPeJwNVr6p28HabjdhS+SBZXrDQNjHzkk+DcBHl9hT+drdpShWLqOsyi1CcExeaiLGpaIbnySm5fQQ/UeDjyjeEWPoq93QgN2guNmEW2yfBO38YN+LAbeh4NaCb0RaiuDilrW1prqS9RTOBGlwbEIKNZn+NTBsiqxFK9UhyGi/Mxd4WJrJ0neWcXtWlSejSTlPVmdDUBQiRfCUJ3/dbVX9Am0AJV4Pqv3IpoLMfkOJm8ddJ72mWSY452djzM8qT70yvMLzclSRup6HfW262Jrt5MymPd4opwWjFo52ZFzsmZql5Z2kIZKFegTFVpfQH6IW4vEH2o15LkrOEDEnD7K2HhlyjMOZ2BT4InvRECt7ixoR+u8/q0VbbbPKZS+ye1J3IG5u5NyVr76CZrqBQNOe8I6nmjzepUkJz9SerNvNHdbFukFb6b8VCovsw7poQpi3qAe5hX1lsPL3GbsprrETkK84E/l0Ng+nBawgUTtOX3TBOixOK
 Ur2UYhPf
 /bSjElhDly4bc2oZCrTTsN1ye9xRPe6ZcQQu2Q4YbBVbfx1ohiL8QCvga3sAQbdoe2t+2FFMQcvWZdXjjxtH9Sqk/pu653cNcatYLW/YZvPQvQtz+7U6Ajz7iHYIEo4eLWU55SEb1fE2vmaJQqiAFXpKZf7Fib/ayBMtXYbr7a6CYoiWDRZ51Rk9gdW0JKR1KUr0F19dQJzANdQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 07:20:21PM +0900, Harry Yoo (Oracle) wrote:
> On Tue, Apr 14, 2026 at 05:59:48PM +0800, Hao Li wrote:
> > On Tue, Apr 14, 2026 at 05:39:40PM +0900, Harry Yoo (Oracle) wrote:
> > > On Fri, Apr 10, 2026 at 07:16:57PM +0800, Hao Li wrote:
> > > > When performing objects refill, we tend to optimistically assume that
> > > > there will be more allocation requests coming next; this is the
> > > > fundamental assumption behind this optimization.
> > > >
> > > > When __refill_objects_node() isolates a partial slab and satisfies a
> > > > bulk allocation from its freelist, the slab can still have a small tail
> > > > of free objects left over. Today those objects are freed back to the
> > > > slab immediately.
> > > > 
> > > > If the leftover tail is local and small enough to fit, keep it in the
> > > > current CPU's sheaves instead. This avoids pushing those objects back
> > > > through the __slab_free slowpath.
> > > 
> > > So there are two different paths:
> > > 
> > > 1. When refilling prefilled sheaves, spill objects into ->main and
> > >    ->spare. 
> > > 2. When refilling ->main sheaf, spill objects into ->spare.
> > 
> > the current experimental code is biased toward spilling into the spare sheaf
> > when possible.
> 
> Oh ok.
> 
> > for kernels without kernel preemption enabled or !RT, the spare sheaf is
> > generally NULL at that point,
> 
> Right. We're either refilling the previously-spare-sheaf (->spare = NULL
> now) or an empty sheaf because ->spare was NULL. (in both cases 1 and 2)

Yes.

> 
> > so the main sheaf may still end up being the
> > primary place to absorb the spill...
> >
> > > > Add a helper to obtain both the freelist and its free-object count, and
> > > > then spill the remaining objects into a percpu sheaf when:
> > > > - the tail fits in a sheaf
> > > > - the slab is local to the current CPU
> > > > - the slab is not pfmemalloc
> > > > - the target sheaf has enough free space
> > > > 
> > > > Otherwise keep the existing fallback and free the tail back to the slab.
> > > > 
> > > > Also add a SHEAF_SPILL stat so the new path can be observed in SLUB
> > > > stats.
> > > > 
> > > > On the mmap2 case in the will-it-scale benchmark suite,
> > > 
> > > > this patch can improve performance by about 2~5%.
> > > 
> > > Where do you think the improvement comes from? (hopefully w/ some data)
> > 
> > Yes, this is necessary.
> > 
> > > e.g.:
> > >   1. the benefit is from largely or partly from
> > >      reduced contention on n->list_lock.
> > 
> > Before this patch is applied, the mmap benchmark shows the following hot path:
> > 
> > - 7.85% native_queued_spin_lock_slowpath
> >     -7.85% _raw_spin_lock_irqsave
> >         - 3.69% __slab_free
> >             + 1.84% __refill_objects_node
> >             + 1.77% __kmem_cache_free_bulk
> >         + 3.27% __refill_objects_node
> > 
> > With the patch applied, the __refill_objects_node -> __slab_free hotspot goes
> > away, and the native_queued_spin_lock_slowpath drops to roughly 3.5%.
> 
> Sounds like returning slabs back indeed increases contention on slowpath.

Indeed!

> 
> > The
> > remaining lock contention is mostly between __refill_objects_node ->
> > add_partial and __kmem_cache_free_bulk -> __slab_free.
> > 
> > > 
> > >   2. this change reduces # of alloc slowpath at the cost of increased
> > >      of free slowpath hits, but that's better because the slowpath frees
> > >      are mostly lockless.
> > 
> > The alloc slowpath remains at 0 both w/ or w/o the patch, whereas the
> 
> (assuming you used SLUB_STATS for this)
> 

Yes, I enable it.

> That's weird, I think we should check SHEAF_REFILL instead of
> ALLOC_SLOWPATH.

Yes, I will compare each metrics for later testing. Maybe we can see more
clues.

> 
> > free slowpath increases by 2x after applying the patch.
> 
> from which cache was this stat collected?

It's for /sys/kernel/slab/maple_node/

> 
> > > 
> > >   3. the alloc/free pattern of the workload is benefiting from
> > >      spilling objects to the CPU's sheaves.
> > > 
> > > or something else?
> > 
> > The 2-5% throughput improvement does seem to come with some trade-offs.
> > The main one is that leftover objects get hidden in the percpu sheaves now,
> > which reduces the objects on the node partial list and thus indirectly
> > increases slab alloc/free frequency to about 4x of the baseline.
> > 
> > This is a drawback of the current approach. :/
> 
> Sounds like s->min_partial is too small now that we cache more objects
> per CPU.

Exactly. for the mmap test case, the slab partial list keeps thrashing. It
makes me wonder whether SLUB might handle transient pressure better if empty
slabs could be regulated with a "dynamic burst threshold"

> 
> /me wonders if increasing sheaf capacity would make more sense
> rather than optimizing slowpath (if it comes with increased memory
> usage anyway),

Yes, finding ways to avoid falling onto the slowpath is also very worthwhile.

> but then stares at his (yet) unfinished patch series...
> 
> > I experimented with several alternative ideas, and the pattern seems fairly
> > consistent: as soon as leftover objects are hidden at the percpu level, slab
> > alloc/free churn tends to go up.
> > 
> > > > Signed-off-by: Hao Li <hao.li@linux.dev>
> > > > ---
> > > > 
> > > > This patch is an exploratory attempt to address the leftover objects and
> > > > partial slab issues in the refill path, and it is marked as RFC to warmly
> > > > welcome any feedback, suggestions, and discussion!
> > > 
> > > Yeah, let's discuss!
> > 
> > Sure! Thanks for the discussion!
> > 
> > > 
> > > By the way, have you also been considering having min-max capacity
> > > for sheaves? (that I think Vlastimil suggested somewhere)
> > 
> > Yes, I also tried it.
> > 
> > I experimented with using a manually chosen threshold to allow refill to leave
> > the sheaf in a partially filled state. However, since concurrent frees are
> > inherently unpredictable, this seems can only reduce the probability of
> > generating leftover objects,
> 
> If concurrent frees are a problem we could probably grab slab->freelist
> under n->list_lock (e.g. keep them at the end of the sheaf) and fill the
> sheaf outside the lock to avoid grabbing too many objects.

Do you mean doing an on-list bulk allocation?

> 
> > while at the same time affecting alloc-side throughput.
> 
> Shouldn't we set sheaf's min capacity as the same as
> s->sheaf_capacity and allow higher max capcity to avoid this?

I'm not sure I fully understand this. since the array size is fixed, how would
we allow more entries to be filled?

> 
> > In my testing, the results were not very encouraging: it seems hard
> > to observe improvement, and in most cases it ended up causing a performance
> > regression.
> > 
> > my impression is that it could be difficult to prevent leftovers proactively.
> > It may be easier to deal with them after they appear.
> 
> Either way doesn't work if the slab order is too high...
> 
> IIRC using higher slab order used to have some benefit
> but now that we have sheaves, it probably doesn't make sense anymore
> to have oo_objects(s->oo) > s->sheaf_capacity?

Do you mean considering making the capacity of each sheaf larger than
oo_objects?
That could reduce the probability of leftovers, though I think that would be
more of a separate optimization of sheaf capacity.

-- 
Thanks,
Hao

