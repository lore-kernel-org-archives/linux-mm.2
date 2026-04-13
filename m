Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A80E9381A
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 05:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6D66B0089; Mon, 13 Apr 2026 01:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567696B008A; Mon, 13 Apr 2026 01:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D3A6B0092; Mon, 13 Apr 2026 01:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 395716B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:27:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D28C68C948
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:27:58 +0000 (UTC)
X-FDA: 84652401036.07.04CB3EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 480254000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:27:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TAtV06kg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776058077; a=rsa-sha256;
	cv=none;
	b=w2Xem30xjJQqE99SWjf8fq7R0V9EoDjdBf1VcAJu9g2s9hHul0uHhRgXPYoWHTwFJjuSlY
	dC2WqD/lCymMWlyelpZ6s03pEk2cDFy+RG4+fChYV6sHbYFrv7/acQXGofdriDMRnl0WAD
	hF7GlidZpQMOuf5UbvzWMXPS7GaUWq0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TAtV06kg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776058077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgoISnYLdI9QyAXxfY52eqqZjz4oxdxOidlesfso/AM=;
	b=uPcxII00xjF6bSSPiFNNTH8TS+4E9ZpJINRPM5u79CtglAt3Ex4IvPms30Aqu4Bf4FeGIz
	s51C5qi65VRuH5/C3uOiiiQQPjZTMFVTi61dez6aM+tzf7nCrCTwarjurw98Jfi2qAtodI
	lkYkCMiewRMBqtqbdiVyZbxIWGI/VQM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3A3F60172;
	Mon, 13 Apr 2026 05:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACE0C116C6;
	Mon, 13 Apr 2026 05:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776058076;
	bh=5+VMTHyuuHgbMkbPJeo6tYqt5zrzeCoT3X8f0VCF/x8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TAtV06kgTF9g6eDS4QotH/KpzXnLfzjfIPfKdDaIx0LKLnd6iq7ow5mkR66DPE9eP
	 JGROvPTALZ6oba9Wn1Ro47BMYpq3JCzbfBxdjeqNUWA+5ffUd4OkKUbkHVu90LWbRM
	 EspztUpYeH+gihFv4WgVMpOCesZNgDOsvIg1coOXA/CCuj8VcjGvppD25ODzgrUY2X
	 YASzQ8/X4kLt4mtu6LErRGMu0L+TeNkx6Ypden4bRn3RbSxlfU2G8wQvzttXQrU00L
	 dn+kVhND0Lm4KeLpSBYAMha+MlM4S7Kxs4ReZ/sXcEbqKRgLGY7rty6z4ApQGwOxxk
	 TKzzyy2RGqqFg==
Date: Mon, 13 Apr 2026 14:27:54 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
	yang.yang29@zte.com.cn
Subject: Re: [PATCH v5] mm/slub: defer freelist construction until after bulk
 allocation from a new slab
Message-ID: <adx-2p09xEKz5Zdb@hyeyoo>
References: <adxm5az9EfHr2aYg@hyeyoo>
 <20260413131423382u868NVr2RkcvDe0Ii3ERj@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413131423382u868NVr2RkcvDe0Ii3ERj@zte.com.cn>
X-Rspamd-Queue-Id: 480254000A
X-Stat-Signature: gt41rint654a55iew11egsdj1rnbnq6x
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776058077-176191
X-HE-Meta: U2FsdGVkX19J/sA2G/lkZJdLnIYli1IQ+4cuhFbHT4PEripTOwsJb70MxLo5uQIY3kTSUJcdfAj5rH0uSW3Da9fmMfjaleui4HZ8RSwKCYh+hDWwxbgLkVjl5xsgXXWJALb8/gNT6urTBe5ACU4+nOU32aszGkMiflUW8ATGoZxOgUhPJoPT5KJRdYkkWRnUgQBW/8h9iCISmjJ6fJeyyKXzz6FJvnTx+knGBg6G8tB5H2WPXGE6Rt67f/K+/XVxtANOY3BYFqaOa3FT9eLbPARj256Yk3tnJ4Ez6oUUX/43An6iBZiGChji8+zSLIWf5joxbBXckugy1LATncisTT+ADE5FRO42o1jcLHLqc1+Uk0/s1m+zWixIAF5DF+T0BNvB403gqCGpywNkt+0jbS7fObDXDgZJfjcY2Y0kbcS7X0mY8mbxCWp7KKtB8qhvGl+JlepoTsw+ex3CvpgFfUs8iz/NFl2m1eyJhrFj0b9d/5HYAXEHQxy6ejqdaXAr7yueLMqCjcVNJ99YVe+/0BPX42Ve11yZW0XfSTn76jCpd5ZlJ1u8ACPGhtDEDqLeFJmbt5xN76gysV+Q3eWcyCc0XomEgOjG/0VAZA1LX0qEL5OOTXFzUKYfLA3TcxN21UAsxrgStMw4NtRj+X566NacJGmXhBbaKGQ/ZgCVCelchmyh4bI2hKaZmXY1mwr8YQSaJ1wDB3ZI4kGR11wlMMXvk9UhxkJfD64JWRaZDA9P/Kb/10xk2pL7Hc75nUGnhtu2c3cU6A0PI1w+IvISA4zLI+klllj645VGt8qlBf2aolTY020/JRF+lWTxxCp9vkdXBRlBehwKaBolGBYyWt66+CuricSefMYO2R0s1Idt0OSNqOdGRVujw7Zffv9ubfK0bbDA4k6RUnZMw4+tHrz5hX7yqzdsDdWq6FWCy9W+bKEKhBjX09a2bN6JRteQCtjYcg0o7V8SW98AUHg
 cIm35Z92
 7l3D+xyFhfZzt9Xk/L4ByOhgrcwXekUgt1y3fLsR6jeLXqmqsWeSp4btMiVcSPacsab5oOkjMdDR+i+sCrTLo2EUuMepvEIMgOYjBL89ho77ZfF5u+nIBXRxJ7tpuqw3b7zQ61WgEFcPucHXD+QrD9SUzmmlOedpHvp83zXIfn4mZJwgFgXBRwkXhn0sMCsY0Hay5WMDLbFLrvxfMvOMaVeak6wGUR3566ncHOKGNJlENIug4/J/FVDVs2sdymGqxDHuUoSLywm2xyfmfxolYPvvUKSVZFLhSZvWdfERQa1Al99g193KyQcUZN4WhssLrr/TAK0FUlwLdOOMXFrbD3LZRw0Y6RiRTm1aWHLFb+zSW//rOZ0elQW5J3Es/WrUarUYzuF+L2hG5HZo53oMMSxorUDRZMxDOAyav
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 01:14:23PM +0800, hu.shengming@zte.com.cn wrote:
> Harry wrote:
> > On Thu, Apr 09, 2026 at 08:43:52PM +0800, hu.shengming@zte.com.cn wrote:
> > > From: Shengming Hu <hu.shengming@zte.com.cn>
> > > 
> > > Allocations from a fresh slab can consume all of its objects, and the
> > > freelist built during slab allocation is discarded immediately as a result.
> > > 
> > > Instead of special-casing the whole-slab bulk refill case, defer freelist
> > > construction until after objects are emitted from a fresh slab.
> > > new_slab() now only allocates the slab and initializes its metadata.
> > > refill_objects() then obtains a fresh slab and lets alloc_from_new_slab()
> > > emit objects directly, building a freelist only for the objects left
> > > unallocated; the same change is applied to alloc_single_from_new_slab().
> > > 
> > > To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> > > small iterator abstraction for walking free objects in allocation order.
> > > The iterator is used both for filling the sheaf and for building the
> > > freelist of the remaining objects.
> > > 
> > > Also mark setup_object() inline. After this optimization, the compiler no
> > > longer consistently inlines this helper in the hot path, which can hurt
> > > performance. Explicitly marking it inline restores the expected code
> > > generation.
> > > 
> > > This reduces per-object overhead when allocating from a fresh slab.
> > > The most direct benefit is in the paths that allocate objects first and
> > > only build a freelist for the remainder afterward: bulk allocation from
> > > a new slab in refill_objects(), single-object allocation from a new slab
> > > in ___slab_alloc(), and the corresponding early-boot paths that now use
> > > the same deferred-freelist scheme. Since refill_objects() is also used to
> > > refill sheaves, the optimization is not limited to the small set of
> > > kmem_cache_alloc_bulk()/kmem_cache_free_bulk() users; regular allocation
> > > workloads may benefit as well when they refill from a fresh slab.
> > > 
> > > In slub_bulk_bench, the time per object drops by about 32% to 71% with
> > > CONFIG_SLAB_FREELIST_RANDOM=n, and by about 52% to 70% with
> > > CONFIG_SLAB_FREELIST_RANDOM=y. This benchmark is intended to isolate the
> > > cost removed by this change: each iteration allocates exactly
> > > slab->objects from a fresh slab. That makes it a near best-case scenario
> > > for deferred freelist construction, because the old path still built a
> > > full freelist even when no objects remained, while the new path avoids
> > > that work. Realistic workloads may see smaller end-to-end gains depending
> > > on how often allocations reach this fresh-slab refill path.
> > > 
> > > Benchmark results (slub_bulk_bench):
> > > Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
> > > Kernel: Linux 7.0.0-rc7-next-20260407
> > > Config: x86_64_defconfig
> > > Cpu: 0
> > > Rounds: 20
> > > Total: 256MB
> > 
> > [...]
> > 
> > Hi Shengming, it's been great to see how this patch has been improved
> > since v1 to where it is now. Thanks for taking the feedback and steadily
> > improving things along the way.
> > 
> 
> Hi Harry,
> 
> Thank you very much for your helpful reviews and suggestions from v1 through v5.
> I really appreciate your patience and professionalism throughout the review process,
> and I have learned a lot from your feedback.

You're welcome!

> > I think this is getting pretty close to being ready for mainline,
> > with just one little thing to fix in the code.
> > 
> > Other reviewers/maintainers may also take a look and leave comments
> > when they get a chance.
> > 
> 
> I am also looking forward to any further comments or suggestions from
> other reviewers and maintainers.
> 
> > > Link: https://github.com/HSM6236/slub_bulk_test.git
> > > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > > ---
> > 
> > If you think it's appropriate, please feel free to add:
> > Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>
> > 
> 
> Sure, I will add:
> 
>   Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks, and

> Thanks again for your continued review and guidance.

no problem!

> > In case this was assisted by AI or other tools, please disclose that
> > according to the process document:
> > 
> >   https://docs.kernel.org/process/generated-content.html
> >   https://docs.kernel.org/process/coding-assistants.html
> > 
> > Not that I think this was assisted by AI, just mentioning because
> > sometimes people using tools to develop the kernel are not aware that
> > they need to disclose the fact. It wouldn't hurt to remind people :-)
> > 
> 
> Regarding AI disclosure: I only used an AI tool to polish the English wording
> of the commit message, since I am not fully confident in my English writing. :-)

Haha, that's fine and I'm not a native english speaker either :)

> As I understand it, the documentation says that "spelling and grammar fix ups,
> like rephrasing to imperative voice" are out of scope, so I believe an
> Assisted-by tag is not needed in this case.

You are right. In that case it's not necessary.
Thanks for clarifying!

> > > Changes in v5:
> > > - Call build_slab_freelist() unconditionally, and remove the redundant "slab->freelist = NULL" initialization in allocate_slab().
> > > - Check the return value of alloc_from_new_slab() to prevent a potential use-after-free bug.
> > > - Refine the commit message with more precise test coverage descriptions.
> > > - Link to v4: https://lore.kernel.org/all/2026040823281824773ybHpC3kgUhR9OE1rGTl@zte.com.cn/
> > > 
> > > ---
> > >  mm/slab.h |  10 ++
> > >  mm/slub.c | 279 +++++++++++++++++++++++++++---------------------------
> > >  2 files changed, 147 insertions(+), 142 deletions(-)
> > > 
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 4927407c9699..9ff8af8c2f73 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -3696,22 +3686,30 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
> > >           * corruption in theory could cause that.
> > >           * Leak memory of allocated slab.
> > >           */
> > > -        if (!allow_spin)
> > > -            spin_unlock_irqrestore(&n->list_lock, flags);
> > >          return NULL;
> > >      }
> > >  
> > > -    if (allow_spin)
> > > +    n = get_node(s, slab_nid(slab));
> > > +    if (allow_spin) {
> > >          spin_lock_irqsave(&n->list_lock, flags);
> > > +    } else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> > > +        /*
> > > +         * Unlucky, discard newly allocated slab.
> > > +         * The slab is not fully free, but it's fine as
> > > +         * objects are not allocated to users.
> > > +         */
> > > +        free_new_slab_nolock(s, slab);
> > > +        return NULL;
> > > +    }
> > >  
> > > -    if (slab->inuse == slab->objects)
> > > -        add_full(s, n, slab);
> > > -    else
> > > +    if (needs_add_partial)
> > >          add_partial(n, slab, ADD_TO_HEAD);
> > > +    else
> > > +        add_full(s, n, slab);
> > >  
> > > -    inc_slabs_node(s, nid, slab->objects);
> > >      spin_unlock_irqrestore(&n->list_lock, flags);
> > >  
> > > +    inc_slabs_node(s, slab_nid(slab), slab->objects);
> > 
> > Ouch, I didn't catch this when it was added in v4. When slab debugging
> > feature is enabled for the cache, inc_slabs_node() should be done within
> > the spinlock to avoid race conditions with slab validation.
> > 
> > Perhaps it's worth adding a comment mentioning this :)
> > 
> > See commit c7323a5ad078 ("mm/slub: restrict sysfs validation to debug
> > caches and make it safe") for more details.
> > 
> > With this fixed, please feel free to add:
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > 
> 
> You are right about the inc_slabs_node() placement. I missed that change when
> it was introduced in v4. Thank you very much for catching it.
> 
> After reading commit c7323a5ad078 ("mm/slub: restrict sysfs validation to debug
> caches and make it safe"), my understanding is that inc_slabs_node() should
> remain under n->list_lock for debug caches, so that validation cannot observe
> inconsistent state during list transitions. I will fix that in the next revision
> and add a comment along these lines.
> 
> Would a comment like the following look good? :-)
> 
> /*
>  * Debug caches require nr_slabs updates under n->list_lock so validation
>  * cannot race with list transitions and observe inconsistent state.
>  */

Mostly LGTM, but perhaps it's better to say
"validation cannot race with slab (de)allocations"
because it's not about transitions between lists,
but rather about slabs being added to or removed from the node while
validation code is iterating over partial and full lists.

Thanks!

-- 
Cheers,
 Harry / Hyeonggon

