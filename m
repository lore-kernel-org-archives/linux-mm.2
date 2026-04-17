Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D104F8E491
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 06:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503306B008A; Fri, 17 Apr 2026 02:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA706B008C; Fri, 17 Apr 2026 02:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0646B0092; Fri, 17 Apr 2026 02:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5266B008A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:00:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C64B51B8D4F
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:00:34 +0000 (UTC)
X-FDA: 84666998388.03.63BC7A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6CAF140009
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:00:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOYGFLzv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776405633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZg2Y3q9djQVoBgs/LXcszSFpY14s15DNUlk5Pi1BH8=;
	b=MnjigJ7a2GBneHcS1I5ebC9Jx3IKIlGrrZjVfT3TO06uFxBs3no684LX3WHKT+P8yN7efb
	eN++PvckEBnC6zg2HscOyoScJYtYUhdYSxgSi3BsPoLjYgDo3UTeF7LNeTeJCZSk/zWUla
	tHep84QyNoiS6XmUhIhYkEc0mym62yQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOYGFLzv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776405633; a=rsa-sha256;
	cv=none;
	b=noSI5zaxjKC7w7dJCHbgPKLGOSLauX4DIi2Da0ANjtO68YLwv53it2NqSk/BN5og1qLdse
	Zb5kapNOKZEfIaUoWq6S2YJXiMY9C7B+tsdzsLdo0fPhEQ+OK60kmcuOo4eUmVS2tFrqDp
	73DoOXcyvmk6tP+owz8NRlldzNT49QM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3BBF43B58;
	Fri, 17 Apr 2026 06:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED4FC19425;
	Fri, 17 Apr 2026 06:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776405631;
	bh=QK6DE8sd6tIkwDxgDv1WOkd3cmGqQGTM5H0vG8DCnsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EOYGFLzvjTQMdtXtHvRT75tx4Z/INsbD76ZhS2uLHDip/VBaR6Tvl2Ju4MNeMN1LI
	 U7SF687Sx8J6Hl8++peQyFA5bLbGce+lvsUkYA5NCxFtvSCvMT10WvYqnOFs1RnA+H
	 dd2sqck0NoY++3jcxadIbVIqTEOogw6D5NHbvrwtK6ZbCLAECrYIvAA0PgMtYIsdIL
	 tOn7fwQxzInSVrPCIgwG2bkQ32rwBjJyKam5ArCizrllJXozb2nCWO/thSc7xFDb8S
	 +31/GgwetFJg2Hd+RJrSuuwQD2hj659l+t9iPIMOIFMaNE0gUpUihqhjF3E7uSI4uP
	 7D/rBzWmJR8Ew==
Date: Fri, 17 Apr 2026 15:00:29 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <aeHMfXldGQ0ANL-K@hyeyoo>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <ad39TJZYLItrEnIM@hyeyoo>
 <bbtmo4fffalhjglohnazrxvplzfxelmuivbonnbfi3gzsm7qj3@bvh42p47dsqa>
 <ad9mZeERenhwh7De@hyeyoo>
 <6k3etcsawcw3zsh5mphc2kj3l2griymug3hvchnwubskwanbc4@gekaw6jn7pi4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6k3etcsawcw3zsh5mphc2kj3l2griymug3hvchnwubskwanbc4@gekaw6jn7pi4>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E6CAF140009
X-Stat-Signature: 4z7euecbsypcwp5ixp4pr57tkh4x1w5k
X-Rspam-User: 
X-HE-Tag: 1776405632-111156
X-HE-Meta: U2FsdGVkX1+pPXBoW+qrOBD2Y/KMaC3DX7TjsavhDuVEmKlwXU3Vjbl1jezykh8aBom1fpEemqgHyt6p6jr2i5rJcY5hYCA0kMY85o6Zak5OIUZOZ77Wf6wNqflNZha2nj8jEt+zTip4aYxLORHpFj/Nab/WUa6BPnKkN3CaK7lclAwLHYoNLhnia6PV+ajjIPIAh98HjwwEm/jpcv3TpON1TfyGwk8zhWqvhzXl46BZecc46GYg67h8QGW1XyTJmXRVDxpHpP6dktt5dhNoZ4oRD3xLSDJL5KAag+P+eMQgKoXeX2vPS+CjXpbjLZtVZ5ixwPDNrSmtSLWYZzg0MqGPWrgvN6JHAbQn/p1GLRk9J7OgBoP+9rSIeZPCEnZd5m8ECPBdUI3kJo8mppHm8nXvhZX2eCHMONqK5e/gazI6mj6dHKNsuxNvndzQ6pKvG2D3oepIrcgly/fcHDyrSc8rqtg3GkczYt06pat+j7o4Yl6/kh+UdK5Z2k0t2Jtumdl/qBVL0HcTGGk9W88ds+iORf7fnpslC7ZvVttaLfNGsDUWhGB3IKWqRUNeg4xWjw33DzkXdB+7n0Dl3jI5Q2hZu0ik7w2M6o6/Xh++lCtzT8BRZ9w0AviGPtWjJEHvuBU1EJ22m2lld9KxEnjPRhO1NXiwEBT6+ti396n3h7Rlr6F06xoz54D0oHMynriK8oVMWs5YFO3E/8TXjdGR8tRQWmfMaY381oYq9X0LPzdlykUCfMRMkQkAZWS7USSyOGYRBBMhuqeH2EHWnsY9mGaf+b7YVrBCaPDBOlz2JC83Pfru5cn42reJviXrZBAmKBp1xOL8eQojrOeER0RdYLTQKGi69Jsm8iNiUjoWP5cSRaeXEiozLIY8Bz8mN/kydkj2ybsI1cnHvzIvaa0NmxqjrWR7j6/L2bQAADcFbSYjzNzi0q7YXnv5g5EcZ/kf0z1m6kg3rpFOpXgaXA2
 mPP9GvOL
 +wuZoGvvgIC7BaAGb0CQwtz8Pm4Wojn0/fKcDHScI2OM/0RBBZh7RvlT6aGgXLPI+IK61gbgCTqXb3A8xGN3v/Rm8ii5nUmAcVirbJpwHAlKLvIpQmXwbnW1VKq8+M8i7cvsSiyMg2Eayttk3PMpjXKRIN1WORyW9/OUTAk6hfMLAj0ON5NUdZZkCDUEb7HO/bCPHXtFsqps5iLW/DBPWhVuVQFyrHpi6RmvAOZMvF8nSxuDJd7BPlt+k1q3BGq66xaiN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 03:58:46PM +0800, Hao Li wrote:
> On Wed, Apr 15, 2026 at 07:20:21PM +0900, Harry Yoo (Oracle) wrote:
> > On Tue, Apr 14, 2026 at 05:59:48PM +0800, Hao Li wrote:
> > > On Tue, Apr 14, 2026 at 05:39:40PM +0900, Harry Yoo (Oracle) wrote:
> > > > On Fri, Apr 10, 2026 at 07:16:57PM +0800, Hao Li wrote:
> > > > Where do you think the improvement comes from? (hopefully w/ some data)
> > > 
> > > Yes, this is necessary.
> > > 
> > > > e.g.:
> > > >   1. the benefit is from largely or partly from
> > > >      reduced contention on n->list_lock.
> > > 
> > > Before this patch is applied, the mmap benchmark shows the following hot path:
> > > 
> > > - 7.85% native_queued_spin_lock_slowpath
> > >     -7.85% _raw_spin_lock_irqsave
> > >         - 3.69% __slab_free
> > >             + 1.84% __refill_objects_node
> > >             + 1.77% __kmem_cache_free_bulk
> > >         + 3.27% __refill_objects_node
> > > 
> > > With the patch applied, the __refill_objects_node -> __slab_free hotspot goes
> > > away, and the native_queued_spin_lock_slowpath drops to roughly 3.5%.
> > 
> > Sounds like returning slabs back indeed increases contention on slowpath.
> 
> Indeed!
>
> > > The
> > > remaining lock contention is mostly between __refill_objects_node ->
> > > add_partial and __kmem_cache_free_bulk -> __slab_free.
> > > 
> > > > 
> > > >   2. this change reduces # of alloc slowpath at the cost of increased
> > > >      of free slowpath hits, but that's better because the slowpath frees
> > > >      are mostly lockless.
> > > 
> > > The alloc slowpath remains at 0 both w/ or w/o the patch, whereas the
> > 
> > (assuming you used SLUB_STATS for this)
> 
> Yes, I enable it.
> 
> > That's weird, I think we should check SHEAF_REFILL instead of
> > ALLOC_SLOWPATH.
> 
> Yes, I will compare each metrics for later testing. Maybe we can see more
> clues.
> 
> > > free slowpath increases by 2x after applying the patch.
> > 
> > from which cache was this stat collected?
> 
> It's for /sys/kernel/slab/maple_node/

Ack. And you also mentioned (off-list) that kmem_cache_refill_sheaf()
is not on the profile. That's good to know.

> > > >   3. the alloc/free pattern of the workload is benefiting from
> > > >      spilling objects to the CPU's sheaves.
> > > > 
> > > > or something else?
> > > 
> > > The 2-5% throughput improvement does seem to come with some trade-offs.
> > > The main one is that leftover objects get hidden in the percpu sheaves now,
> > > which reduces the objects on the node partial list and thus indirectly
> > > increases slab alloc/free frequency to about 4x of the baseline.
> > > 
> > > This is a drawback of the current approach. :/
> > 
> > Sounds like s->min_partial is too small now that we cache more objects
> > per CPU.
> 
> Exactly. for the mmap test case, the slab partial list keeps thrashing. It
> makes me wonder whether SLUB might handle transient pressure better if empty
> slabs could be regulated with a "dynamic burst threshold"

Haha, we'll be constantly challenged to find balance between "sacrifice
memory to make every benchmark happy" vs. "provide reasonable
scalability in general but let users tune it themselves". 

If we could implement a reasonably simple yet effective automatic tuning
method, having one in the kernel would be nice (though of course having
it userspace would be the best).

> > /me wonders if increasing sheaf capacity would make more sense
> > rather than optimizing slowpath (if it comes with increased memory
> > usage anyway),
> 
> Yes, finding ways to avoid falling onto the slowpath is also very worthwhile.

Could you please take a look at how much changing 1) sheaf capacity and
2) nr of full/empty sheaves at the barn affects the performance of
mmap / ublk performance?

I've been trying to reproduce the regression on my machine but haven't
had much success so far :(

(I'll try to post the RFC patchset to allow changing those parameters
at runtime in few weeks but if you're eager you could try experimenting
by changing the code :D)
 
> > but then stares at his (yet) unfinished patch series...
> > 
> > > I experimented with several alternative ideas, and the pattern seems fairly
> > > consistent: as soon as leftover objects are hidden at the percpu level, slab
> > > alloc/free churn tends to go up.
> > > 
> > > > > Signed-off-by: Hao Li <hao.li@linux.dev>
> > > > > ---
> > > > > 
> > > > > This patch is an exploratory attempt to address the leftover objects and
> > > > > partial slab issues in the refill path, and it is marked as RFC to warmly
> > > > > welcome any feedback, suggestions, and discussion!
> > > > 
> > > > Yeah, let's discuss!
> > > 
> > > Sure! Thanks for the discussion!
> > > 
> > > > 
> > > > By the way, have you also been considering having min-max capacity
> > > > for sheaves? (that I think Vlastimil suggested somewhere)
> > > 
> > > Yes, I also tried it.
> > > 
> > > I experimented with using a manually chosen threshold to allow refill to leave
> > > the sheaf in a partially filled state. However, since concurrent frees are
> > > inherently unpredictable, this seems can only reduce the probability of
> > > generating leftover objects,
> > 
> > If concurrent frees are a problem we could probably grab slab->freelist
> > under n->list_lock (e.g. keep them at the end of the sheaf) and fill the
> > sheaf outside the lock to avoid grabbing too many objects.
> 
> Do you mean doing an on-list bulk allocation?

Just brainstorming... it's quite messy :)
something like

__refill_objects_node(s, p, gfp, min, max, n, allow_spin) {
	// in practice we don't know how many slabs we'll grab.
	// so probably keep them somewhere e.g.) the end of `p` array?
	void *freelists[min];
	nr_freelists = 0;
	nr_objs = 0;

	spin_lock_irqsave();
	for each slab in n->partial {
		freelist = slab->freelist;
		do {
			[...]
			old.freelist = slab->freelist;
			[...]
		} while (!__slab_update_freelist(...));

		freelists[nr_freelists++] = old.freelist;
		nr_objs += (old.objects - old.inuse);
		if (!new.inuse)
			remove_partial();
		if (nr_objs >= min)
			break;
	}
	spin_unlock_irqrestore();

	i = 0;
	j = 0;
	while (i < nr_freelists) {
		freelist = freelists[i++];
		while (freelist != NULL) {
			if (j == max) {
				// free remaining objects
			}
			next = get_freepointer(s, freelist);
			p[j++] = freelist;
			freelist = next;
		}
	}
}

This way, we know how many objects we grabbed but yeah it's tricky.

> > > while at the same time affecting alloc-side throughput.
> > 
> > Shouldn't we set sheaf's min capacity as the same as
> > s->sheaf_capacity and allow higher max capcity to avoid this?
> 
> I'm not sure I fully understand this. since the array size is fixed, how would
> we allow more entries to be filled?

I don't really want to speak on behalf of Vlastimil but I was imagining
something like:

before: sheaf->capacity (32, min = max); 
after: sheaf->capacity (48 or 64, max), sheaf->threshold (32, min)

so that sheaf refill will succeed if at least ->threshold objects
are filled, but the threshold better not be smaller than 32 (the
previous sheaf->capacity)?

> > > In my testing, the results were not very encouraging: it seems hard
> > > to observe improvement, and in most cases it ended up causing a performance
> > > regression.
> > > 
> > > my impression is that it could be difficult to prevent leftovers proactively.  > > > It may be easier to deal with them after they appear.
> > 
> > Either way doesn't work if the slab order is too high...
> > 
> > IIRC using higher slab order used to have some benefit
> > but now that we have sheaves, it probably doesn't make sense anymore
> > to have oo_objects(s->oo) > s->sheaf_capacity?
> 
> Do you mean considering making the capacity of each sheaf larger than
> oo_objects?

I mean the other way around. calculate_order() tends to increase slab
order with higher number of CPUs (by setting higher `min_objects`),
but is it still worth having oo_objects higher than the sheaf capacity?

> That could reduce the probability of leftovers, though I think that would be
> more of a separate optimization of sheaf capacity.

-- 
Cheers,
Harry / Hyeonggon

