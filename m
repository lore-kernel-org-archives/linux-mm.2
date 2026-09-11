Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8ADBC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84D06B008A; Fri, 11 Sep 2026 08:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7C56B008C; Fri, 11 Sep 2026 08:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAEC96B0092; Fri, 11 Sep 2026 08:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A20F46B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:27:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73975A0219
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:27:16 +0000 (UTC)
X-FDA: 85201406472.12.AE475A5
Received: from mta0.migadu.com (out-219.mta0.migadu.com [91.218.175.219])
	by imf03.hostedemail.com (Postfix) with ESMTP id CE8EA2000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:27:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="O/BfAYPe";
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.219 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789129634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrNycxRjw4aYkF/JzDBMuhCLwRJARPW8e3b9KotqwVg=;
	b=ATSjeAtXwfcB0JKJJDPd0G8NQ3iadKQQFiXXeUNnNqdddBKSBkKMtC8lrwWa7s8DMza0Vx
	BkweaZeXaJldL/ZAIenEtETz4Thxcb0OJMpAPPnt+hF5vOe7v6kFb0C1zH9gTCTKcBTe3C
	aJVmvfsLClK1ZX04fP/+S/Vydw3O+l8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="O/BfAYPe";
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.219 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789129634;
	b=dijSVko66QV1nsHYMXhxdFXe5S01YZUPYOJuy29LtBDc8DuMz0OCTLCWkakAo2mphAmED+
	Jd3U2Ocjji4s2nW8y2pI9VYacGwb2JuoEM0TSxjcx9vvE8Y1g3S45z0SZvrinJwAI2lstt
	8NxcrOnaUCM3xwfuOADU8TlbOIiAFlk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7iFYTSzOCrAOlJrqwK4LCwzVc3QImSJhyOWmype30kI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789129626; v=1; x=1789734426;
 b=O/BfAYPenqTbyKfYweZsqLIo3Mk0Ydsp/ojGbUSeri1hr+V6ZzV5jZxp8jnrqrmEEv6vCoAD
 OffsAji8Lj4GQ3+7vov6N3xslUZ175D7mhM/MddyCC/cSOCWZIOkDpCgqvWN3Bd4rnMyMYsjTdV
 +OTn0cqkv7gLbPzv4lZioMu0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id a3a6938cd6c1d893;
	Fri, 11 Sep 2026 12:27:05 +0000
X-Mizu-Trace-ID: a3a6938cd6c1d893
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 20:27:00 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqPzlIVJccbqbaUr@fedora>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqLi6cIjD2wJwk0B@cmpxchg.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE8EA2000D
X-Stat-Signature: fkjzhzea9h1o11st9imi5fpfxm8zf4ss
X-Rspam-User: 
X-HE-Tag: 1789129633-51931
X-HE-Meta: U2FsdGVkX1/sAGrmlzuq71/LWIf9+3Nktd3kKIepLFM6mKALTTbK2JoF2/Yc5ei7XctHEeSaluGW1Y73i2YWENuqIOFF2Ydq9uaIKyPWWD4bc3LpxZybw9TRM1GfvqC54iaHZn8c+fYtWb1fLayCv9hik698HFQp/pqrtgaozfPrxZC1xY1dgpymeNhJTyHpzeCdJafJd7VbQ57CiKc4+BZkq/MeztEZUtOqkXG6TkB8Du3v22wqwoOgzBX2BjyBkv8Kh0eRFxadVYObLztQxUks8Cz0NuwdptW0GBMjPfrgbsrqG/RYFqs902Kqpypj2bDiaxXu7UAaeU9/k7YKhuV9MPHZhjtAoYvuSEGzjjyKdMobjF8DhR1+JxmP2KFxCH2sexR/lcIdPABOb4OR4mhYk2t77KuXXJ0lxTQW0QtB4XzRGbRfy0yBFuGEgZcN11pS53V4GgZdMdDCawUiWzYc0UVOAmjKs8LziGoKYCO8Qap4nlRCY52+nGt3WtdBC5kFwNjw7fDiKGzYLGaj427P5ziio0xTjcDuXfiQELLs+a7MzgHFf3TTmN8u//d5mbSMKDbks5g70de7r9ej8JZyg/w+eTWS1F/8IE0V5CiRIWdAyOL2FsUD/LchZTbtmVAMa1cH3w8Ob6bZH10UOdYItLWltuvVQ47MFW6zg6ow4cwerj0Q7nZSo7AvOV2OjpcpYvSv+x9T0zDiGyS2e/3jAI7Aa+ZR9kHtb66WhL4XKQ8ruvoFHeZRYcITXoeVcjee+sBl9Hc34N5pORWZjPl1gtTZZESANLI1QDwemMxVxitGJBJ+0SeRJhjBOVE8RWwDYsXONATL61GceI2VFVAesVqA6L4kL6yPPdgT4piWrWqdrjiZX+do/5rJs/647+XJbc/BdvDJQLGN6a7IQkPe5VqHps5c2y9D23OaRD/tjv3Gb31E5wHf45mUj2NnfDhJWZjUermA1GaG7Fl
 EgE9YFs+
 Nt77G6v4uVi3td9BeKMXzH00XT9Tdi019McHIQVIv/JvBdyUlupc7OqC5P0rqbEWKgEs6mh3y5QYT1ifln8CjsJ38QWw9kmKI4kC6UUwmttqomoa+Qhu5f/HFFgtudsGXavQ8L62rbj9As0PQJIsHvWHc1u1RaaGjjjyLujGL2seHtRIi83JdAPLfUHd13tB3UecwDqrqQxa3rF8KZagKSr07XUCjsXhal1CsoDTIcc4tRE5M6OzdMXcvTR7nUmAJdGDf5/v0zXqyGvusYICOzSG05hk3qHJWDROJsBuQMspra3kvzZ/GIVByEgQJL+IkgOLQulA6dqLllYtTRuPmk/7SeKqbOjrmmuR/iCa8ogN1cvU6SW1pl502a6nizAUxet7k0luDHAWEFEb5flZ9VM1rNsVGu2EICGuz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/10/26 at 01:03pm, Johannes Weiner wrote:
> [This reply was not LLM-generated.]
> 
> On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > Hi Nhat,
> > 
> > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > .....snip...
> > > Now, on xswap. Baoquan's working on a series [15] that covers some of the
> > > same ground, and the VM_SPARSE cluster_info idea in it is genuinely good.
> > > I've been reviewing that lineage since July [16] and I'd like whatever
> > > lands to end up with the best parts of both. From my perspective the
> > > differences are:
> > > 
> > > 1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) plus
> > >    a per-device limit to tune afterwards. I'm not aware of any use case
> > >    that needs those, and I don't think users have a good way to answer the
> > >    question anyway - sizing swap for compressed memory depends on memory
> > >    size, workload, and compression ratio all at once. That's precisely the
> > >    provisioning problem vswap exists to remove. The kernel should be as
> > >    transparent and dynamic as possible here, and not add knobs unless
> > >    there's a use case for them.
> > > 
> > > 2. Writeback support. Writeback is core functionality for zswap, not an
> > >    add-on, and a design needs to account for it from the start. This came
> > >    up before, in the discussion around Chris' ghost swapfile RFC [17]: for
> > >    a solution here to be acceptable, it has to work with the primary
> > >    usecase and support disk writeback. Without it, whatever zswap won't
> > >    take (incompressible pages especially) has nowhere to go, and cold
> > >    compressed data can never leave RAM.
> > > 
> > > 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against the
> > >    swap usage counter. It's fundamentally a different resource from
> > >    physical swapfile space, and memory.swap.* should read 0 when nothing is
> > >    on disk [18]. I made the longer argument for this in [19].
> > > 
> > > 4. Data structure (xarray vs sparse vmalloc array). Even with xarray, vswap
> > >    is already on par with or beating baseline. I like the sparse array
> > >    idea, but why are we landing an optimization before the feature itself,
> > >    without any A/B data showing the difference matters?
> > 
> > 
> > Thanks for laying this out, and for the honest push to converge. Let me
> > be equally direct about the ordering: I think the xswap base should land
> > first, and the things vswap demonstrates -  writeback, rmap lookup, the
> > charging semantics, later THP -- should be built on top of it. Because
> > it is the foundation that keeps the swap core simpler, and the first thing
> > to merge should be the one that doesn't have to be redone.
> > 
> > The VM_SPARSE array is not an optimization to bolt on later; it is a
> > structural choice, and the code reflects it. In vswap, the cluster
> > metadata lives in a dynamically-allocated xarray.
> > 
> > struct swap_cluster_info_dynamic {
> >         struct swap_cluster_info ci;
> >         unsigned int index;             /* for cluster_index() */
> >         struct rcu_head rcu;
> >         atomic_long_t *virtual_table;   /* Backing pointers for vswap slots */
> > };
> > 
> > To support dynamic growth and shrink, vswap stores its cluster metadata
> > in an xarray, and that forces two things the plain swap_cluster_info[]
> > array never needed:
> > 
> > 1. Every cluster has to carry an extra index and an rcu_head —
> > 24 bytes per cluster — purely so the xarray can locate it and free
> > it safely.
> > 2. To keep that bookkeeping from leaking into the normal-swap code, the
> > cluster had to be wrapped in a container, swap_cluster_info_dynamic,
> > so the xarray holds a pointer to the wrapper instead of an inline
> > array element.
> > 
> > So in vswap, every cluster access in the shared hot path has to answer
> > "is this a vswap device?" and take a separate branch:
> > 
> > - swap_is_vswap() is checked in 36 places across page_io.c, swapfile.c,
> >   zswap.c and swap.h;
> > - __swap_offset_to_cluster() branches into xa_load() for vswap vs the
> >   flat array otherwise, and the xarray path can return NULL (a cluster
> >   can be torn down);
> > - __swap_cluster_lock() branches into __vswap_cluster_lock(), which
> >   wraps every access in rcu_read_lock() and a CLUSTER_FLAG_DEAD check,
> >   plus kfree_rcu()/container_of()/rcu_head plumbing for node lifetime.
> 
> Well to state the obvious: the reason it does all that is to make the
> compression space transparent to the user.
> 
> The user can answer a simple boolean question: whether they want
> compression or not. And it will work on tiny machines, on humongous
> machines, and everything in between. That's a simple policy question
> with a clear answer.
> 
> What you're doing, asking the user for a static size, is much more
> difficult and has usability issues.
> 
> You're comparing implementations that don't accomplish the same thing.
> 
> The problem we're trying to solve is implementing a clean compression
> space abstraction. I'm arguing that vswap does, and xswap does not.
> 
> While they're both using parts of the swap device code to implement a
> compression space, xswap actually PRESENTS IT TO THE USER as a swap
> device, and then makes optimizations BASED ON BAKED IN LIMITATIONS.
> 
> But a conventional, statically sized swap device is a bad abstraction
> for the compression space. Here is why:
> 
> In conventional swap space, one memory page translates to one swap
> page. Compression space doesn't act this way: a memory page can
> consume anything between a few bytes to a full page in compression
> space. It depends on memory contents and compression algorithm. So
> right off the bat, this is a hard question to answer at the host level
> which could run all kinds of workloads.
> 
> In conventional swap space, the resource consumed is a different
> one. You're offloading memory by consuming disk space. This eats into
> the space available to the filesystem, which is totally unrelated.
> Asking the user for this tradeoff is a legitimate policy question.
> 
> Compression space is not a separate resource. It's page tables,
> backing pages, and swap descriptors. It's just MEMORY. There isn't a
> size tradeoff, because moving pages from memory space into compression
> space DOES NOT CONSUME A NEW RESOURCE. It's still just memory. All you
> need for containment already exists: rlimits, OOM killer, cgroup
> memory controls.
> 
> By making this a user-visible virtual swap device, you're sending
> users down the wrong path. You're asking them to set a new limit on a
> resource that's already limited by other means. You're framing the
> question as conventional swap which behaves completely differently.
> 
> If you ask them "how much swap space", they WILL reference this to
> available RAM capacity. Maybe half of ram, maybe twice the RAM.
> 
> But when compression space is referenced to RAM, it's trivial to fill
> it up with zeroed pages or easily compressible data LONG BEFORE the
> process or container would hit any of its MEMORY limits.
> 
> This creates an artificial resource shortages. It forces a competition
> where there shouldn't be one. And then you need new controls to manage
> a competition that doesn't have to exist.
> 
> Like I said before, including compression space (which is memory) in
> memory.swap.* (which is for disk space) is not going to be acceptable
> from the cgroup side. We can talk about that if you want.
> 
> But asking the user questions they shouldn't have to answer, or
> already answered elsewhere, is weak interface design. Allowing, let
> alone encouraging, answers that create a whole new host of
> organizational issues is outright bad interface design.
> 
> So if you want to compare implementations, you first have to actually
> implement the same thing:
> 
> Stop asking user "how large". Let compression space expand towards
> existing memory limits, such that it doesn't create an awkward and
> artificial new resource competition.
> 
> Then we can compare implementations.
> 
> If the optimizations still apply under those constraints, great.
> 
> Until then, there is little point in discussing differences that, by
> your own admission, have little to no impact on real world performance.

Thanks for your sharing with deliberate thought.

Agreed, and I want to be clear that the size knob is my implementation
choice, not something the design needs.

Now in v2, xswap's create() already takes no size, only an optional
priority: the device's address space is set by the kernel to the machine's
memory and cluster_info is mapped lazily, so nothing is allocated up front.
The only knob left is an optional per-device ceiling. If we really want to
remove it, that's quite easy thing, we can just remove the runtime
growth ceiling and the shrink machinery that serves it.

When I asked why shrink is needed, Nhat told on system, memory pressure
could reach a peak, than later may not reach it again for a long time. I
don't like the continuous automatic growing/shrinking, I think it
doesn't make much sense just for saving that memory serving struct
swap_cluster_info. But it's not bad to provide a mechanism for
admin/users to tune it.

But as I said, xswap/vswap both claim to solve the problem of zswap
physical disk slot and swap slot coupling, and meantime extend
functionality to make it more flexible than zswap/zram. While Nhat's
vswap is boot-time per-device swap. And Nhat's own description of it
in this thread is "vswap is just a normal swap device, no?". If I didn't
apply Nhat's code and test I couldn't realize it. I executed swapon but
can't see any output. I was shocked.

I really appreciated your patient and detailed sharing, while it takes
you so long words to explain it. IMHO, it deserves a separate patch
posting to justify it so that anyone can know why it is.

Thanks
Baoquan

