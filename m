Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6E3DF41986
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EE26B0092; Wed, 15 Apr 2026 06:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2FF26B0093; Wed, 15 Apr 2026 06:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45706B0095; Wed, 15 Apr 2026 06:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 944C56B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:20:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 400181B81CC
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:20:26 +0000 (UTC)
X-FDA: 84660395652.25.7C42BED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9ADE020005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:20:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNtKUlcX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776248424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=beSTTiJ9+CWIXQSuIxQtLmL5Gxy05TeMjLjDwVxhmns=;
	b=4Wv/feZDj6JF3lrjqWd7d6awqEWfx6bNJE5oC9Yiu/MWtZ2Ymkxr6irawAF05eVE+7zwZF
	RZ9ddCAM044BS/uDeJmfQzGk6/AtAmJbsz4TQ0pQZQqcwD7FgqCAtgjeLePAsdwgjyeYGh
	kWJE0+Nz91UxW+W4kcccfn3daXtDqXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776248424; a=rsa-sha256;
	cv=none;
	b=LXW0BT7XOe3ncCcIyAUMdardaPcUWSb6EWreaMxypXOJeWduQ87L5vw2KuGJGIUVWk5oTJ
	Rbs25g45QZw27qPXfF9rtHbzR6Wdgpx07HtAJhGTswT9wHgfNAOk23O35dyRerg6heVvsN
	kNe7uiSvpNfwHIXgl9Fr5urYMs20WAo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNtKUlcX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04678600AD;
	Wed, 15 Apr 2026 10:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF54C19424;
	Wed, 15 Apr 2026 10:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776248423;
	bh=3W7oDSldjIH5and8d1MkEeryH5EnFVbZIKn3P1rs9AM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fNtKUlcXr58bAFxCNT0MSa1aoVKHO70TFNh51wS6FW1yQ/iOiGCNVoxWYf7XWwuOY
	 chOl5S6rjU/Dx7nvmOB3WCiAkUexvLDpaJpnv5mNGQSfJXWaSyKEz9CR4SbkDqtLIH
	 1fTmS8AiqAD6ERDrkBV/kirK+eXgCGabqqKn3DX2/WcNhQWubwO72iXLOZRlsDMWx3
	 TQpPyoyXWA7NuGgYBNZSvM267UEPkCtZNi6cs1XTHQIL2W5bbwQpa6kl9Y20pB2dbb
	 3Rp8TkqS8k+Sj2ZKV5vXBw7KLjGlIQh0ROPpK372f+JuFst0KQIlJgeG+OM3vn2uYp
	 pTIDFIR7yj3TQ==
Date: Wed, 15 Apr 2026 19:20:21 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <ad9mZeERenhwh7De@hyeyoo>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <ad39TJZYLItrEnIM@hyeyoo>
 <bbtmo4fffalhjglohnazrxvplzfxelmuivbonnbfi3gzsm7qj3@bvh42p47dsqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbtmo4fffalhjglohnazrxvplzfxelmuivbonnbfi3gzsm7qj3@bvh42p47dsqa>
X-Rspamd-Queue-Id: 9ADE020005
X-Stat-Signature: f9zokmo8rkas63ytzr1rs9kznit81qfm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776248424-637802
X-HE-Meta: U2FsdGVkX1891w1vO8dd/isApw0jGF89Y+MRACEs2SoLS6oFsMtBP0CSai5HXDIUFsyNATlDmPphsi1Gn2C6Ub2RKJxH8JyWLB9ggcopqp9wQlwNvcqDYVm5VTy7sSRZE8x+NMWuf3sRY5KEOJFa8iEF18KHD7vwAElXboynyYwHsFXBUTUdiBUo0zb2KTxXRLQN5EZHe1vqPJEqwTw7kFdFNhi9Fv01J87Bl5vNcS48wz7KIUNauHXIuWz7ToUZCsXqaKVwzY0/2Uuut4sqZR3vibif2p+UF5b4Fauh13THz7UA0woJxdf8S5wA1T4JBIG4tT8wPJz37zyXbmrC8O6lQFQTM2pUeAMGH57Mb5S5QcdvuhBKcfrY6OsfPEdjKiKsDpZUUwm47FB9zp9ruryWe2OM7N+l1OKD4qjRRw9hIhA1xqBTTnqBWldFe+OpEAfJ3JHCosm8f1g7DkTolNR2gpxYf+Y9v9oJFIB5etHPPrqgcyiEBxosYXYgzmJoDaSMunfu0yRKh6a4yf0bseSu+/GV2yJ3njSwbARhdejJoAT3tWhrHSaZbzbU7FGNvEXTinlHNUu9LyIdwOEic0CuChGeKuFz84MbfLic/V/ZjcBboxaUOcNn03lxfLnR5rOyf1Fdt1uWlRftz7rIR4y6W0eQymqhaItVNxLHWRs1LTuoLZcw5i3Ba+yjLPO/Iw1p/suDFlwClImdFiO1WJ2+ECRA2cKo2vgwxYTVFepaSrZ2/0nEK0Y7lctiaDXEMTMj3AxArOai3HJjLIh3i9z/3n9PQSglB6NLXvKlU/Og5YO7caYYdEgNKRfCU4hJKx0EAcKLjEzKjCWRQG5z1bWMlRbIZUi4/SjdHK8jjGvTCFvwzaGU48Cx1G8NBO8f6gd9eF16XVUHCFj1BB5bcAg29tnSu6CiR5YcHxcj3yR54ewADBZm3EaK7VCsqGhYicC5oN8yHlpbagSZWrx
 u3VAornN
 Bn932MpQqcL4QW8lRqW5kKPssOT7sDsr/l68Ofcu/Clg1vmNUQlHrXRm2fOwB3FIbkh03o6A4IQI7/FM40CTSrronVVYt/lsx0SbNPHxhTB04oiU/LSOf5H5zCrEMbCQYv45IUyjcS57uX+UCRWKOq0wD4p622O4EFiR9K8Jn1FHFPx1k27udjUQEVjiTc4ekDmZg133heVXCT9qVRl7ro6ST5X1uCyAf45W58EqG5WGIPuDeW+RKUOBIxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 05:59:48PM +0800, Hao Li wrote:
> On Tue, Apr 14, 2026 at 05:39:40PM +0900, Harry Yoo (Oracle) wrote:
> > On Fri, Apr 10, 2026 at 07:16:57PM +0800, Hao Li wrote:
> > > When performing objects refill, we tend to optimistically assume that
> > > there will be more allocation requests coming next; this is the
> > > fundamental assumption behind this optimization.
> > >
> > > When __refill_objects_node() isolates a partial slab and satisfies a
> > > bulk allocation from its freelist, the slab can still have a small tail
> > > of free objects left over. Today those objects are freed back to the
> > > slab immediately.
> > > 
> > > If the leftover tail is local and small enough to fit, keep it in the
> > > current CPU's sheaves instead. This avoids pushing those objects back
> > > through the __slab_free slowpath.
> > 
> > So there are two different paths:
> > 
> > 1. When refilling prefilled sheaves, spill objects into ->main and
> >    ->spare. 
> > 2. When refilling ->main sheaf, spill objects into ->spare.
> 
> the current experimental code is biased toward spilling into the spare sheaf
> when possible.

Oh ok.

> for kernels without kernel preemption enabled or !RT, the spare sheaf is
> generally NULL at that point,

Right. We're either refilling the previously-spare-sheaf (->spare = NULL
now) or an empty sheaf because ->spare was NULL. (in both cases 1 and 2)

> so the main sheaf may still end up being the
> primary place to absorb the spill...
>
> > > Add a helper to obtain both the freelist and its free-object count, and
> > > then spill the remaining objects into a percpu sheaf when:
> > > - the tail fits in a sheaf
> > > - the slab is local to the current CPU
> > > - the slab is not pfmemalloc
> > > - the target sheaf has enough free space
> > > 
> > > Otherwise keep the existing fallback and free the tail back to the slab.
> > > 
> > > Also add a SHEAF_SPILL stat so the new path can be observed in SLUB
> > > stats.
> > > 
> > > On the mmap2 case in the will-it-scale benchmark suite,
> > 
> > > this patch can improve performance by about 2~5%.
> > 
> > Where do you think the improvement comes from? (hopefully w/ some data)
> 
> Yes, this is necessary.
> 
> > e.g.:
> >   1. the benefit is from largely or partly from
> >      reduced contention on n->list_lock.
> 
> Before this patch is applied, the mmap benchmark shows the following hot path:
> 
> - 7.85% native_queued_spin_lock_slowpath
>     -7.85% _raw_spin_lock_irqsave
>         - 3.69% __slab_free
>             + 1.84% __refill_objects_node
>             + 1.77% __kmem_cache_free_bulk
>         + 3.27% __refill_objects_node
> 
> With the patch applied, the __refill_objects_node -> __slab_free hotspot goes
> away, and the native_queued_spin_lock_slowpath drops to roughly 3.5%.

Sounds like returning slabs back indeed increases contention on slowpath.

> The
> remaining lock contention is mostly between __refill_objects_node ->
> add_partial and __kmem_cache_free_bulk -> __slab_free.
> 
> > 
> >   2. this change reduces # of alloc slowpath at the cost of increased
> >      of free slowpath hits, but that's better because the slowpath frees
> >      are mostly lockless.
> 
> The alloc slowpath remains at 0 both w/ or w/o the patch, whereas the

(assuming you used SLUB_STATS for this)

That's weird, I think we should check SHEAF_REFILL instead of
ALLOC_SLOWPATH.

> free slowpath increases by 2x after applying the patch.

from which cache was this stat collected?

> > 
> >   3. the alloc/free pattern of the workload is benefiting from
> >      spilling objects to the CPU's sheaves.
> > 
> > or something else?
> 
> The 2-5% throughput improvement does seem to come with some trade-offs.
> The main one is that leftover objects get hidden in the percpu sheaves now,
> which reduces the objects on the node partial list and thus indirectly
> increases slab alloc/free frequency to about 4x of the baseline.
> 
> This is a drawback of the current approach. :/

Sounds like s->min_partial is too small now that we cache more objects
per CPU.

/me wonders if increasing sheaf capacity would make more sense
rather than optimizing slowpath (if it comes with increased memory
usage anyway), but then stares at his (yet) unfinished patch series...

> I experimented with several alternative ideas, and the pattern seems fairly
> consistent: as soon as leftover objects are hidden at the percpu level, slab
> alloc/free churn tends to go up.
> 
> > > Signed-off-by: Hao Li <hao.li@linux.dev>
> > > ---
> > > 
> > > This patch is an exploratory attempt to address the leftover objects and
> > > partial slab issues in the refill path, and it is marked as RFC to warmly
> > > welcome any feedback, suggestions, and discussion!
> > 
> > Yeah, let's discuss!
> 
> Sure! Thanks for the discussion!
> 
> > 
> > By the way, have you also been considering having min-max capacity
> > for sheaves? (that I think Vlastimil suggested somewhere)
> 
> Yes, I also tried it.
> 
> I experimented with using a manually chosen threshold to allow refill to leave
> the sheaf in a partially filled state. However, since concurrent frees are
> inherently unpredictable, this seems can only reduce the probability of
> generating leftover objects,

If concurrent frees are a problem we could probably grab slab->freelist
under n->list_lock (e.g. keep them at the end of the sheaf) and fill the
sheaf outside the lock to avoid grabbing too many objects.

> while at the same time affecting alloc-side throughput.

Shouldn't we set sheaf's min capacity as the same as
s->sheaf_capacity and allow higher max capcity to avoid this?

> In my testing, the results were not very encouraging: it seems hard
> to observe improvement, and in most cases it ended up causing a performance
> regression.
> 
> my impression is that it could be difficult to prevent leftovers proactively.
> It may be easier to deal with them after they appear.

Either way doesn't work if the slab order is too high...

IIRC using higher slab order used to have some benefit
but now that we have sheaves, it probably doesn't make sense anymore
to have oo_objects(s->oo) > s->sheaf_capacity?

-- 
Cheers,
Harry / Hyeonggon

