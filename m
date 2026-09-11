Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B02A1C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DDA46B0093; Fri, 11 Sep 2026 09:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8036B0096; Fri, 11 Sep 2026 09:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA4A6B0099; Fri, 11 Sep 2026 09:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 496696B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:06:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7CABA0248
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:06:51 +0000 (UTC)
X-FDA: 85201506222.27.51DCC86
Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	by imf02.hostedemail.com (Postfix) with ESMTP id 958FE80008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:06:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aO31goT4;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789132010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kfi+H+0vRX+9VC7bkZyCEQ2q2gtnzT1MRFZfyg5T0To=;
	b=rZkDQVXRCktHfUjc76uf5vMjQwicG+AaLTS2IGyTa7P8G+x1kHwpHwjT9tlbmAHeL8F6nZ
	ITpf4huJWnxGBS3JY3MU5yE1RNecKD0RgfX8VnU02IFlcqebyHZE4zWjyfzkFkVRbz3rWa
	p6Y8MffojU+mTQ1uFURaIQSFsn4ooBM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aO31goT4;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789132010;
	b=AK9SeCcnY4Plo7/3vwXcNL0ltLIiGDjTebxNwxInEPVvJGYpo8sQ+TSxsh+PJXChqojaQB
	V3Ron7XAIODt9XRRR9oARjV/lDNvMP35C0Sae815A09wkdXJY7sxGQBYGLYeRQEv9Z9MGs
	GvykN/4SEeKkal6JQvmmQLlAmMeFD3U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VrBjQrAkdEmXpDtyAwR3LekOouRL0ah5gO9kVtcaIVc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789132000; v=1; x=1789736800;
 b=aO31goT4eBg8mrZ/YU2k05CeAV4GE9o3qUnnorPxnzpX7bOM6v4n+rEXbU3vBpcguuipk6p+
 5s5oOZbCsx1O8PTyArfmtipwAJvWrQNT1K6zyI6mOfDyC4AhTOW1r7MezCvl5jmPTqsiuOLtj2k
 SWy8Ahve9ew3CzW1ikeyA5aI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3936e15f4d3d1065;
	Fri, 11 Sep 2026 13:06:39 +0000
X-Mizu-Trace-ID: 3936e15f4d3d1065
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 21:06:25 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>
Cc: harry@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [RFC PATCH 2/2] mm/slub: introduce slab parking to reduce
 list_lock contention
Message-ID: <aqPlMzUIw-4g2iOX@fedora>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
 <20260824122513.3829-2-hao.li@linux.dev>
 <8d73f087-42e2-454c-8e5f-93c1b64cb969@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d73f087-42e2-454c-8e5f-93c1b64cb969@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 958FE80008
X-Stat-Signature: ozynxzi9eg3tc39rm4mm9t1ee18o56s6
X-Rspam-User: 
X-HE-Tag: 1789132007-444554
X-HE-Meta: U2FsdGVkX19d0xHIOmk+Vf3/s5/RNcI6JTw+P1xLQRoV81jCOgDulbx/6N0qZzRu1I9FLaYwIYM+lnCPjfSDkR5YrO0LD5AsGkdXdfQd18eEHFSG5sQCcXG98kigGPT6WGIbkr59UdkOQi+R6sZFY5CLwlwIQ2eYPQDU5Qb52rcoWx85P13mSb48xBuzPKtNuPbr5O3wYZfZSUU/S8gbtJOLYA7yEOZU/3gDarkNT6gdsP2oVE6K7I13XF3ulP/LwNiwa6wZJdkdRxhVwwF35HE0lrJ7VIMPYIHgr79QKizdvCW2plzcnKOAHOu3Ge+7mwpI+I9X5QRPcGItOC6Jhpd3jk6oEhjXotOuJIJNKqZIW68YZllKlckhLTJNiIQobMVx6xhSbvj9wvOMSb0e28kzDfV3mZrcESgZnUbyv50vlYjy8n6WhOZE46RAXcpRGlt2f4u8t22cI2PEG0TcPhy1ZNgHeHuR/TnC+9PAn5okd46rA4453PEuLNT6msNApARc+nmuy4XWstHwSVIECaZjnBgzXqjAp4CxOcZPgkLhi1pL49uw5VlmhBaOtQNiVzAux8GQQJH7jR3SkhJDL/Ixg3pmGO/coUkP6d/GaSjag4SJuIPsPcfHNAGHyj7j8F5dhMSaZy0rsfgCLX6wCXT1QrbfLToYMyJwTeQx9wUnftcaAcv3E1wpYvb9rqIRizjtTIFWIzx40GXAb8M8IBVuVf4iWtRVK5ZrADpBo0gjr4fzzhm8APfNS8MoiLWgNHIGW4/7A8Dp0MfzHqcgeYyw6wCLCEW41kHNqO++wFRYaDpEkeF0oqCArsDxPExlmdgG8+OvPgnJFkUk5bsNjEnnpvQweWc3kL5F3NuiA8YwDExERDU3vz1QrAaRgM+y6CSyVTBsQ2ID0oXL/PSKgNy78u0DGix89U0uv8aM0N+tf00M85pW4DPcMsARONyxUi2xdRvg9fEQiamBwZd
 jWC33Fyr
 AOJHKBNG8M9s8jKHHVbs2aNs2y8tfycB8Ycyo8FjRMoLzQnXrtR6pKsat5anyGw1aOGH0de0iwYik71MwEpiiZQLsA81PxX5W5ISpgfjabNxnpieEszuj6iqmfbEDCQ4igjvtqOmR0IZtYZMuZulxd3heN8r2WCO3FjStdtLz+DCftfgkmVWjmntPbplDqi/uJY88SAC444aJIDUSy4b2idkSWKmGP2iQdLqF9wF6kNuRduQJg84T12yWXRA/CcKe3LNjLzlazNsKYHz2v9qVrqXaHDSv9dB9uzAhjqiLpScD6bSxrtf83hW68RzKyS//hV2R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 03:38:22PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/24/26 14:25, Hao Li wrote:
> > Introduce a mechanism called parking to mitigate lock contention in the
> > free slowpath.
> 
> Interesting!

Thanks!

> 
> > In the free slowpath, when __slab_free() transitions a full slab into a
> > partial/empty slab through a free operation, it must acquire the list
> > lock to add these newly freed partial/empty slabs to the partial list.
> > 
> > Why must partial and empty slabs converted from full slabs be added to
> > the partial list? Because only by doing so can the sheaf refill or alloc
> > slowpath see these partial slabs and allocate from them. Therefore, the
> > list insertion must be performed, which requires acquiring the lock and
> > leads to heavy lock contention under high concurrency.
> > 
> > Analysis of profiling data from the will-it-scale mmap1 benchmark shows
> > that full -> partial transitions account for a large proportion, second
> > only to partial -> partial.
> > 
> > With extra instrumentation added to __slab_free(), the following data
> > was collected for the maple_node cache (in counts):
> > 
> >   partial->partial    843017414
> >   full->partial       550719384
> >   partial->empty      17459564
> >   full->empty         2
> 
> That's a lot inded. I'd be careful if it's some specific aspect of the test,
> i.e. lots of parallel allocations followed by lots of frees, that wouldn't
> be that common in realistic workloads. But worth looking into at least.
> If it's this kind of pathologic behavior, then I expect changing sheaf size
> as suggested by Pedro wouldn't help much.

Thanks for pointing this out. I looked into this bursty alloc-and-free behavior
a bit deeper and ran some further experiments.

The core question we want to answer is: why does such a massive volume of
object allocations and frees fall straight through to the node partial list
layer, rather than being caught and handled at the barn/sheaf layer? In SLUB's
current design, the per-CPU main/spare sheaves act as the L1 cache, the barn as
L2, and the node partial list as L3. For the mmap1 benchmark (which heavily
stresses the maple tree), the allocation path uses kmem_cache_prefill_sheaf()
rather than the generic allocation APIs, and the frees go through kfree_rcu().

Then, here is what happens during allocation: kmem_cache_prefill_sheaf()
normally borrows the spare sheaf directly. If the sheaf holds fewer objects
than requested, it refills it to capacity from the node partial list layer and
this completely bypasses the barn layer. Once the maple tree finishes
allocating a batch of objects, it returns the sheaf back to pcs->spare via
kmem_cache_return_sheaf(). So in essence, this prefill path is just funneling
objects directly from the node partial list into the maple tree through the
spare sheaf. It skips the barn layer.

Then on the free side: these objects are freed via kfree_rcu, and then
rcu_free_sheaf() checks if there is still room on the barn's full list. But
since the allocation path never actually pulled from the barn, the full list
stays permanently saturated. As a result, rcu_free_sheaf() always falls back to
sheaf_flush_unused(), flushing objects straight into the node partial list
layer. It skips the barn layer too.

So looking at this behavior, the benchmark does seem to reveal a gap in this
allocation path, where a huge amount of traffic ends up bypassing the barn
layer entirely.

To see if we can address this, I draft an experimental patch. It introduces a
new field, barn->sheaf_partial, which is a single sheaf rather than a list.

[The patch code is included at the end of this email.]

Whenever kmem_cache_prefill_sheaf() runs, it detaches pcs->spare and checks
whether it holds enough objects for the request.

If so, it returns it right away as in the original code.

If not, call __prefill_sheaf_pfmemalloc() and then go into
barn_replace_partial_sheaf() to swap the non-full spare sheaf with a full sheaf
from the barn. The full sheaf is handed to the caller, while the non-full sheaf
is temporarily stashed into barn->sheaf_partial. This largely avoids falling
back to the node partial list. If barn->sheaf_partial already has a sheaf, we
merge them together, and any resulting full or empty sheaves are placed back
into the barn accordingly.

The key idea here is simply to let __prefill_sheaf_pfmemalloc() pull a sheaf
from the barn's full list, which makes room on the list for future
rcu_free_sheaf() calls.

Here are the numbers with just this experimental patch applied (without the
parking patch):

baseline: 28779879
after experimental patch: 35550211 (+23.5%)

metric                              before             after             delta      change
=============================================================================================
aliases                                  0                 0                 0      +0.00%
align                                  256               256                 0      +0.00%
alloc_fastpath                      23,259            59,287            36,028    +154.90%
alloc_node_mismatch                      0                 0                 0      +0.00%
alloc_slab                      10,171,378         4,796,346        -5,375,032     -52.84%
alloc_slowpath                           0                 0                 0      +0.00%
barn_get                               441       193,807,528       193,807,087  +43947185.26%
barn_get_fail                            0               377               377         new
barn_put                               441       181,694,607       181,694,166  +41200491.16%
barn_put_fail                  272,868,220       156,335,632      -116,532,588     -42.71%
cache_dma                                0                 0                 0      +0.00%
cmpxchg_double_fail                744,975           357,255          -387,720     -52.04%
cpu_partial                              0                 0                 0      +0.00%
cpu_slabs                                0                 0                 0      +0.00%
destroy_by_rcu                           0                 0                 0      +0.00%
free_add_partial               337,390,126       162,178,648      -175,211,478     -51.93%
free_fastpath                        5,204            14,081             8,877    +170.58%
free_rcu_sheaf               8,731,794,372    10,816,953,777     2,085,159,405     +23.88%
free_rcu_sheaf_fail                      0                 0                 0      +0.00%
free_remove_partial             10,170,229         4,794,785        -5,375,444     -52.85%
free_slab                       10,170,229         4,794,785        -5,375,444     -52.85%
free_slowpath                   18,697,056        11,563,127        -7,133,929     -38.16%
hwcache_align                            0                 0                 0      +0.00%
min_partial                              5                 5                 0      +0.00%
object_size                            256               256                 0      +0.00%
objects                             14,774            14,596              -178      -1.20%
objects_partial                     14,774            14,596              -178      -1.20%
objs_per_slab                           64                64                 0      +0.00%
order                                    2                 2                 0      +0.00%
order_fallback                           0                 0                 0      +0.00%
partial                              1,913             2,544               631     +32.98%
poison                                   0                 0                 0      +0.00%
reclaim_account                          0                 0                 0      +0.00%
red_zone                                 0                 0                 0      +0.00%
remote_node_defrag_ratio               100               100                 0      +0.00%
sanity_checks                            0                 0                 0      +0.00%
sheaf_alloc                    145,870,437       151,536,660         5,666,223      +3.88%
sheaf_capacity                          32                32                 0      +0.00%
sheaf_flush                  8,731,787,311     5,002,740,743    -3,729,046,568     -42.71%
sheaf_free                     145,870,431       151,536,655         5,666,224      +3.88%
sheaf_prefill_fast           3,500,187,266     4,331,383,393       831,196,127     +23.75%
sheaf_prefill_oversize                   0                 0                 0      +0.00%
sheaf_prefill_slow                     322               646               324    +100.62%
sheaf_refill                 8,750,484,664     5,014,304,944    -3,736,179,720     -42.70%
sheaf_return_fast            3,500,187,348     4,331,383,596       831,196,248     +23.75%
sheaf_return_slow                      240               443               203     +84.58%
slab_size                              256               256                 0      +0.00%
slabs                                1,913             2,544               631     +32.98%
slabs_cpu_partial                        0                 0                 0      +0.00%
store_user                               0                 0                 0      +0.00%
total_objects                      122,432           162,816            40,384     +32.98%
trace                                    0                 0                 0      +0.00%
usersize                                 0                 0                 0      +0.00%

derived                                                  before             after      change
=============================================================================================
page allocator churn (alloc_slab + free_slab)        20,341,607         9,591,131     -52.85%

As we can see from the data, barn_get and barn_put spike significantly, which
shows a large part of the traffic is redirected into the barn. This eases slab
alloc/free churn and cuts page allocator allocations/frees by 52.85%.

Additionally, NUMA performance also seems to see some improvement. Under the
maple tree benchmark, the free_slowpath metric likely reflects objects that
enter add_ptr_to_bulk_krc_lock() due to nid mismatches and are eventually freed
via kfree_bulk(). This metric also shows a noticeable drop.

Metrics like alloc_fastpath did improve, but their absolute numbers are small
and likely unrelated to the maple tree test.

The tradeoff is a increase in slab fragmentation, with total_objects and slabs
growing by 32.98%. I suspect this happens because as more traffic gets routed
to the barn layer, objects end up being more scattered, which ends up pinning
more slabs.

For comparison: the parking mechanism reduces lock contention at the node
partial list layer, while this experimental patch absorb the traffic earlier at
the barn layer. They are independent in mechanism. Interestingly, both
approaches deliver very comparable performance improvements. A bit
frustratingly, combining the two only squeezes out an extra ~1% gain, I'm still
investigating why that is.

Phew, that turned out to be quite a long write-up!

All in all, I feel we could probably focus on evaluating and pursuing this
experimental patch first. For maple tree performance specifically, it seems
like it might be the better fit compared to the parking mechanism (which is
probably better suited for generic allocation pressure outside of maple tree).

> 
> > Since the fundamental purpose of __slab_free() is to make newly freed
> > partial/empty slabs visible to the sheaf refill or alloc slowpath, these
> > slabs can be temporarily stored in a staging area in a lockless manner
> > instead of making the free slowpath contend for the lock. The sheaf
> 
> However the lockless manipulation is still going to contend on the
> llist_head. But perhaps it's limited enough in both users and lenght of
> operations to make a difference.

Agreed, locked or lockless, there's always some unavoidable cost. But from the
performance data, contention on llist_head still seems quite a bit friendlier.

> 
> > refill or alloc slowpath then checks this staging area first when
> > allocating objects. This achieves the goal of making these slabs visible
> > to the sheaf refill or alloc slowpath while allowing the free slowpath
> > to operate locklessly. This process is called "parking".
> 
> I'm gonna pull a David Hildenbrand trick here and question the name :)
> It seems to me it's an (extension of the) partial list, but lockless.
> Parking would suggest to me that it's put somewhere aside not to be used, or
> something.

Haha totally! When I first came up with the idea, the word 'park' just popped
into my head. I thought it sounded pretty cool, so I just went with it :P

It definitely deserves a more fitting name!

Until we come up with a better name, I'll stick with the term 'park' for the
rest of this discussion. :)

> 
> > Parking occurs in only one case: when __slab_free() encounters a full ->
> > partial/empty transition and the trylock fails. In this case,
> > __slab_free() attaches the slab to an llist locklessly, instead of
> > waiting for the lock unnecessarily.
> 
> It could be interesting to also see if skipping the trylock completely
> (another cache contending operation) helps even more. Also whether moving
> the llist_node to a different cache line than list_lock (and fields
> protected by it) helps even more, or not.

That's a really insightful idea! I'll verify it next and follow up once I have
the results.

> 
> > Conversely, the process of moving these parked slabs from the llist back
> > to the partial list is called "unpark". Unpark occurs in four cases:
> > 
> > 1. Sheaf refill or alloc slowpath: This is the core case. The sheaf
> >    refill or alloc slowpath must see the parked slabs, so the first
> >    thing done after acquiring the lock in the sheaf refill or alloc
> >    slowpath is unpark.
> > 2. Cache shrinking: shrinking also needs to see slabs in the parked
> >    state.
> > 3. Cache destruction: kmem_cache_destroy() must also see parked slabs,
> >    which is obvious, otherwise memory would leak.
> > 4. delayed_work (see corner case b below)
> > 
> > Why is this scheme correct? Because paths entering the sheaf refill or
> > alloc slowpath can see both slabs on the partial list and slabs on the
> > parked llist, while allocation paths that do not enter the sheaf refill
> > or alloc slowpath would not check the partial list in the first place
> > and naturally do not need to care about parked slabs. Therefore, whether
> > an allocation takes the sheaf refill or the alloc slowpath or not, slabs
> > on the parked llist and slabs on the partial list make no difference to
> > the allocator. This visibility equivalence is the core of the scheme.
> > This analysis also shows that the scheme does not affect the utilization
> > of partial slabs or lead to increased fragmentation.
> > 
> > Corner cases to handle:
> > a. Parked slabs may become completely empty. Therefore, unpark must also
> >    check min_partial and free excess empty slabs instead of adding them
> >    back to the partial list.
> > 
> > b. In rare cases, the system may go idle immediately after slabs are
> >    parked, and the sheaf refill or alloc slowpath may never run
> >    again. These parked slabs would then remain in the llist until the
> >    next sheaf refill or alloc slowpath performs an unpark. To
> >    solve this problem, add a delayed_work named unpark_work to add
> >    parked slabs back to the partial list when no other path unparks
> >    them.
> 
> OK, but is this a problem that needs the delayed work? If the slabs are
> still partial, they would just sit on the partial list rather than on the
> llist, but it would cause no extra bloat?

Spot on, that's very true.
When I originally decided to flush it as soon as possible, the intent was to
stay as close to the existing code flow as possible, essentially making the
parking mechanism a transient measure that steps in only briefly at specific
moments rather than a persistent one.

> It could be a problem only if free slab(s) got stuck on the llist.
> 
> So I'd try to avoid the delayed work as it's quite a red flag.

Agreed, it's indeed not ideal.

> Periodic
> flushing of alien arrays used to be a very unpopular part of SLAB
> implementation. I think there might be two ways:
> 
> 1) submit the delayed work only when transitioning partial->empty slab on
> the llist. Would likely require flagging slabs that are on the llist.
> Hopefully this will limit the submissions to negligible amounts.
> 
> 2) remove the delayed work completely, instead __slab_free() would perform
> the "unpark" immediately when detecting partial->empty slab transition on
> the llist. Would need flagging the slabs as well.
> 
> I guess 2) would be preferred unless it compromises the benefits too much.

Agreed, option 2) looks like the better way to go. Perhaps have __slab_free()
detect the partial->empty transition, and if the current slab isn't on the
partial list (either parked or detached by a refill), trigger an unpark
operation. That would nicely eliminate the need for a delayed work. (The only
slab we could miss this way is one where the parking path is between the
cmpxchg and the llist_add.)

> 
> > On will-it-scale mmap1 with 192 processes, throughput increases from
> > 29237910 to 35585663 (+21.7%). native_queued_spin_lock_slowpath drops
> > from 44% to 30% of cycles and __slab_free() disappears from the lock
> > profile. alloc_slab,free_slab drop by 52%, and park_slab equals
> > unpark_slab exactly, confirming no parked slabs are left stranded.
> > 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> 

--- >8 ---
mm/slub: refill prefilled sheaves from the barn

For evaluation.

---
 mm/slub.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 112 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 27a78d63f537..7d337dbe26a5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -427,6 +427,8 @@ struct node_barn {
 	spinlock_t lock;
 	struct list_head sheaves_full;
 	struct list_head sheaves_empty;
+	/* leftovers of prefill or refill, protected by barn->lock */
+	struct slab_sheaf *sheaf_partial;
 	unsigned int nr_full;
 	unsigned int nr_empty;
 };
@@ -3183,6 +3185,69 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 	return empty;
 }
 
+/*
+ * Exchange @sheaf, which holds fewer objects than requested, for a full sheaf
+ * from the barn. The objects of @sheaf stay in the barn: it becomes the barn's
+ * partial sheaf, or its objects are merged into the existing one, which becomes
+ * a full sheaf when it reaches capacity. That way the leftovers neither occupy
+ * a full-sheaf count nor have to be flushed.
+ *
+ * Returns NULL if the barn has no full sheaf.
+ */
+static struct slab_sheaf *barn_replace_partial_sheaf(struct kmem_cache *s,
+						     struct node_barn *barn,
+						     struct slab_sheaf *sheaf)
+{
+	struct slab_sheaf *full, *partial;
+	unsigned int to_move;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	spin_lock_irqsave(&barn->lock, flags);
+
+	if (unlikely(!barn->nr_full)) {
+		spin_unlock_irqrestore(&barn->lock, flags);
+		return NULL;
+	}
+
+	full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
+				barn_list);
+	list_del(&full->barn_list);
+	barn->nr_full--;
+
+	partial = barn->sheaf_partial;
+	if (partial) {
+		to_move = min(sheaf->size, s->sheaf_capacity - partial->size);
+		sheaf->size -= to_move;
+		memcpy(&partial->objects[partial->size],
+		       &sheaf->objects[sheaf->size], to_move * sizeof(void *));
+		partial->size += to_move;
+
+		if (partial->size == s->sheaf_capacity) {
+			list_add(&partial->barn_list, &barn->sheaves_full);
+			barn->nr_full++;
+			barn->sheaf_partial = NULL;
+		}
+	}
+
+	if (sheaf->size) {
+		/* no partial sheaf, or it just became full */
+		barn->sheaf_partial = sheaf;
+	} else {
+		list_add(&sheaf->barn_list, &barn->sheaves_empty);
+		barn->nr_empty++;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	full->capacity = s->sheaf_capacity;
+	full->pfmemalloc = false;
+
+	return full;
+}
+
 /*
  * The following two functions are used mainly in cases where we have to undo an
  * intended action due to a race or cpu migration. Thus they do not check the
@@ -3317,6 +3382,7 @@ static void barn_init(struct node_barn *barn)
 	spin_lock_init(&barn->lock);
 	INIT_LIST_HEAD(&barn->sheaves_full);
 	INIT_LIST_HEAD(&barn->sheaves_empty);
+	barn->sheaf_partial = NULL;
 	barn->nr_full = 0;
 	barn->nr_empty = 0;
 }
@@ -3334,6 +3400,10 @@ static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
 	barn->nr_full = 0;
 	list_splice_init(&barn->sheaves_empty, &empty_list);
 	barn->nr_empty = 0;
+	if (barn->sheaf_partial) {
+		list_add(&barn->sheaf_partial->barn_list, &full_list);
+		barn->sheaf_partial = NULL;
+	}
 
 	spin_unlock_irqrestore(&barn->lock, flags);
 
@@ -5233,12 +5303,49 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 
+/*
+ * Refill by swapping *@sheafp for a full sheaf from the barn. The old sheaf and
+ * its objects stay in the barn. Returns true when the new sheaf is full.
+ */
+static bool refill_sheaf_from_barn(struct kmem_cache *s,
+				   struct slab_sheaf **sheafp)
+{
+	struct node_barn *barn = get_barn(s);
+	struct slab_sheaf *sheaf = *sheafp;
+	struct slab_sheaf *full;
+
+	/* objects from pfmemalloc slabs must not enter the barn */
+	if (!barn || sheaf->pfmemalloc)
+		return false;
+
+	full = barn_replace_partial_sheaf(s, barn, sheaf);
+	if (!full)
+		return false;
+
+	stat(s, BARN_GET);
+	*sheafp = full;
+
+	/*
+	 * The sheaf may hold fewer than capacity objects: rcu_free_sheaf()
+	 * puts it in the barn as full even when slab_free_hook() has taken
+	 * some out (KFENCE, KASAN). __prefill_sheaf_pfmemalloc() then
+	 * continues to refill it.
+	 */
+	return full->size == s->sheaf_capacity;
+}
+
 static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
-				      struct slab_sheaf *sheaf, gfp_t gfp)
+				      struct slab_sheaf **sheafp, gfp_t gfp)
 {
+	struct slab_sheaf *sheaf;
 	gfp_t gfp_nomemalloc;
 	int ret;
 
+	if (refill_sheaf_from_barn(s, sheafp))
+		return 0;
+
+	sheaf = *sheafp;
+
 	gfp_nomemalloc = gfp | __GFP_NOMEMALLOC;
 	if (gfp_pfmemalloc_allowed(gfp))
 		gfp_nomemalloc |= __GFP_NOWARN;
@@ -5331,7 +5438,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 		sheaf->pfmemalloc = false;
 
 		if (sheaf->size < size &&
-		    __prefill_sheaf_pfmemalloc(s, sheaf, gfp)) {
+		    __prefill_sheaf_pfmemalloc(s, &sheaf, gfp)) {
 			sheaf_flush_unused(s, sheaf);
 			free_empty_sheaf(s, sheaf);
 			sheaf = NULL;
@@ -5401,11 +5508,10 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
  * the given size.
  *
  * Return: 0 on success. The sheaf will contain at least @size objects.
- * The sheaf might have been replaced with a new one if more than
- * sheaf->capacity objects are requested.
+ * The sheaf might have been replaced with a new one.
  *
  * Return: -ENOMEM on failure. Some objects might have been added to the sheaf
- * but the sheaf will not be replaced.
+ * and the sheaf might have been replaced.
  *
  * In practice we always refill to full sheaf's capacity.
  */
@@ -5427,7 +5533,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 
 	if (likely(sheaf->capacity >= size)) {
 		if (likely(sheaf->capacity == s->sheaf_capacity))
-			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
+			return __prefill_sheaf_pfmemalloc(s, sheafp, gfp);
 
 		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
 					     &sheaf->objects[sheaf->size]))

-- 
2.55.0


