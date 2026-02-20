Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B91C5ACD9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 17:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A46C6B0088; Fri, 20 Feb 2026 12:36:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F646B0089; Fri, 20 Feb 2026 12:36:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810536B008A; Fri, 20 Feb 2026 12:36:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63A3E6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:36:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA5D91C206
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:36:18 +0000 (UTC)
X-FDA: 84465538836.30.06859FD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D298940013
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:36:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R5uJSYVE;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771608977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IqjOdiofWjjCWCfPy8j7WH4t5XK2/Efigokxu3dvlE=;
	b=GEAQnjPXm00oJbVSc3X74z1j2akpyRRnlqbo75BLrNXB3aa82WHxntM0MwEDMzgFz9ZeCS
	EjZlUWy8WijfH1zR74NGK7NAySGbjrGa/m+ZyRCfOMqX6Up261GU+5TSEnRXz2EDBqEU4I
	OEBpEvZI4my1YeAVt7pm90JlMn46QkY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R5uJSYVE;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771608977; a=rsa-sha256;
	cv=none;
	b=OtZczbYYceUgeJIfk2aMZyJsppdnHEK2nUihZNqRaHckmwqxy3kNxavPH9ZDGj7rbCTfZh
	i07GvUK5aJ28ZGpwaHp7oXaiLEF207PUMGGbYDayM1S3YUG4frL7hlMzPQMaUTnDsetJIY
	4VoOZ19fvy6Cm0kPUsKMOjb5TXQ/RTc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771608976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3IqjOdiofWjjCWCfPy8j7WH4t5XK2/Efigokxu3dvlE=;
	b=R5uJSYVEIN2JuvNK/ygmw/76BsKKRz2pd+hxXhR7RYAXgAxzPvuQ6+/sGM0B/EEGrqf/LU
	YCjVM9aKGeRcn5FaUfxPnF9m22udYMQ+f6hw6Sl1cW0nGLSbn+2RfK+2BUSRabiyrnZr/T
	pWJyl9oQGDGDjjylOoGYtKVY5J1DAkM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-GCy-qzgoOVO6a-GZTQQOwQ-1; Fri,
 20 Feb 2026 12:36:11 -0500
X-MC-Unique: GCy-qzgoOVO6a-GZTQQOwQ-1
X-Mimecast-MFC-AGG-ID: GCy-qzgoOVO6a-GZTQQOwQ_1771608969
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F65719560A3;
	Fri, 20 Feb 2026 17:36:08 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF4231800348;
	Fri, 20 Feb 2026 17:36:06 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id BD690400DC5A8; Fri, 20 Feb 2026 14:35:41 -0300 (-03)
Date: Fri, 20 Feb 2026 14:35:41 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Michal Hocko <mhocko@suse.com>, Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZibbYH7yrDZlnJh@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
MIME-Version: 1.0
In-Reply-To: <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: Ed3yG8ifXcw6x6QxZdb2p8RMDrOdpgkECwTD_kAlxRQ_1771608969
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: sw3kjt53b4434tqosarf8cw735wwiqim
X-Rspam-User: 
X-Rspamd-Queue-Id: D298940013
X-Rspamd-Server: rspam01
X-HE-Tag: 1771608976-938138
X-HE-Meta: U2FsdGVkX189ctDibx3MBe1Rh8mYLoSjDt6ma2ADKplmPp3rGL837bb+CPiQS8pmteJXbsyAM79zi3NQ4O6a2uoq+HI6FCG0g5Q3AScQ9/Z1NPEuz697l5cxBfOrQ9oQ+BVhswFIOWAVMLEFkC/r7+JoPV8qxXdq/b2a3SV5zr0Nz5Mdi40Zy24LcSQC7uChaTfEzWAaWXZZL0GYZhkYMz4moYOn09y0JgU3aE3+LVxWD5Y7dtZyB+CxKIrWs6aFBEnI7QLBymvCtQQxww9t5HZi5m8OH0Ee0DD8hvPnNRM7NHNbPVFqfoR31OdY+Vt4a/Q3/eLzpSyCVc8O4hg4ad6bdDgcq5nPILuhrIwXG3WHQP5S4d+vQshlJQWo6DrdQ7arsEBQFihlG4U+xjffTYJMzBbpf5gsQ3UOx6EH0TZchS4hwtDOseAlsDVpwOjkqTYPFoHHU4K6uJHkGNxWMX4vq25KQIRFIbL7DMZS4rNxaUFl1tgcGyWwZ+0QcDdgyei/Rv7SwOPryCm+6zeCY6zffM0km5YO6ftLrBmpzT0FWMLOCf0haPoDFle9VTj8ptlMvjBI81WKvS9C9p3uqXoi7+PfJ9eMjZTVD2wLxBGIi/Z2amx9AuYQU8YftiQ5ndlOvaZOZEhvLvOq24l/F8aafmXFz67LwccTmVYQs7QbUpa5mG5gOoVzEW28TYh8KUzNvIEJVXzET3CCfH9flcJk8Dlh2U4tGuG7wjFc6dYsBB7fvTChLHzmTUT8eWnGFB5WMREvIYpVihJLZQ13N2NJ8TzYGq/e6NVERiYJ0OaLxxdLokybF1OjFmQswmORLcpm1XGItsN/fhdrSsWJ1FhLRxnZJ678jgRf6cdUtHyvT/FT7HUj0tccjS02t6bHnowwZxCirPvL/zNxZpL03mxCFMNkzcQd+3qwRwv/SufLmzkengTnJFRTlRMm43c1T4Z3jh3KTSEEDo/EMJf
 ZTTXvI2X
 6MdkT1g/rLP2ZaZEqsUQQPoldKxps2gWeqD9jBcPFkz2y4Sy0d//Zv0HWwTGN1Dnjdm1Ay/ZXmjW95q9/mbEjWIw4C3M66voOMZR+zi71UuzXwvH4fGDvLDKh+Ouc/q+P8ioF+MihxPfgi9wN6/l5BxDpXW3/rYIJT6VqGK9DiS4MYpc2/k/icneB/PLMljVOHbIHf5HotlHDMoBqfeCTZqhypluHe7G0HWj4VNdZphM5t3mpS7BvQU5iT26pKOfp/AO3W9TDAhY0RkgMQeOa0PtaPPk/7sLBtEWsppZJPUoWBZtkQ2t1oUSO3RGirWxSK0arGkssUUvz34EELzU9+8DE8KrOoAvbNkLvvgOTVn2aB1YSP0wg8CIWKEtPJEXqKeNuiRb5HefikBpUSCEjd3BnMe3IZNeZpFnyPpPcqOi377b5PDzGfh3BfvSLs82Zqu8V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

On Fri, Feb 20, 2026 at 11:48:00AM +0100, Vlastimil Babka wrote:
> On 2/19/26 16:27, Marcelo Tosatti wrote:
> > On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > 
> > Michal,
> > 
> > Again, i don't see how moving operations to happen at return to 
> > kernel would help (assuming you are talking about 
> > "context_tracking,x86: Defer some IPIs until a user->kernel transition").
> > 
> > The IPIs in the patchset above can be deferred until user->kernel
> > transition because they are TLB flushes, for addresses which do not
> > exist on the address space mapping in userspace.
> > 
> > What are the per-CPU objects in SLUB ?
> > 
> > struct slab_sheaf {
> >         union {
> >                 struct rcu_head rcu_head;
> >                 struct list_head barn_list;
> >                 /* only used for prefilled sheafs */
> >                 struct {
> >                         unsigned int capacity;
> >                         bool pfmemalloc;
> >                 };
> >         };
> >         struct kmem_cache *cache;
> >         unsigned int size;
> >         int node; /* only used for rcu_sheaf */
> >         void *objects[];
> > };
> > 
> > struct slub_percpu_sheaves {
> >         local_trylock_t lock;
> >         struct slab_sheaf *main; /* never NULL when unlocked */
> >         struct slab_sheaf *spare; /* empty or full, may be NULL */
> >         struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
> > };
> > 
> > Examples of local CPU operation that manipulates the data structures:
> > 1) kmalloc, allocates an object from local per CPU list.
> > 2) kfree, returns an object to local per CPU list.
> > 
> > Examples of an operation that would perform changes on the per-CPU lists 
> > remotely:
> > kmem_cache_shrink (cache shutdown), kmem_cache_shrink.
> > 
> > You can't delay either kmalloc (removal of object from per-CPU freelist), 
> > or kfree (return of object from per-CPU freelist), or kmem_cache_shrink 
> > or kmem_cache_shrink to return to userspace.
> > 
> > What i missing something here? (or do you have something on your mind
> > which i can't see).
> 
> Let's try and analyze when we need to do the flushing in SLUB
> 
> - memory offline - would anyone do that with isolcpus? if yes, they probably
> deserve the disruption

I think its OK to avoid memory offline on such systems.

> - cache shrinking (mainly from sysfs handler) - not necessary for
> correctness, can probably skip cpu if needed, also kinda shooting your own
> foot on isolcpu systems
> 
> - kmem_cache is being destroyed (__kmem_cache_shutdown()) - this is
> important for correctness. destroying caches should be rare, but can't rule
> it out
> 
> - kvfree_rcu_barrier() - a very tricky one; currently has only a debugging
> caller, but that can change
> 
> (BTW, see the note in flush_rcu_sheaves_on_cache() and how it relies on the
> flush actually happening on the cpu. Won't QPW violate that?)

(struct kmem_cache *s)->cpu_sheaves (percpu)->rcu_free with the
s->cpu_sheaves->lock lock held:

do_free:

        rcu_sheaf = pcs->rcu_free;

        /*
         * Since we flush immediately when size reaches capacity, we never reach
         * this with size already at capacity, so no OOB write is possible.
         */
        rcu_sheaf->objects[rcu_sheaf->size++] = obj;

        if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
                rcu_sheaf = NULL;
        } else {
                pcs->rcu_free = NULL;
                rcu_sheaf->node = numa_mem_id();
        }

        /*
         * we flush before local_unlock to make sure a racing
         * flush_all_rcu_sheaves() doesn't miss this sheaf
         */
        if (rcu_sheaf)
                call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);

        qpw_unlock(&s->cpu_sheaves->lock, cpu);

So if it invokes call_rcu, it sets pcs->rcu_free = NULL. In that case,
for flush_rcu_sheaf executing remotely from flush_rcu_sheaves_on_cache
will:

static void flush_rcu_sheaf(struct work_struct *w)
{
        struct slub_percpu_sheaves *pcs;
        struct slab_sheaf *rcu_free;
        struct slub_flush_work *sfw;
        struct kmem_cache *s;
        int cpu = qpw_get_cpu(w);

        sfw = &per_cpu(slub_flush, cpu);
        s = sfw->s;

        qpw_lock(&s->cpu_sheaves->lock, cpu);
        pcs = per_cpu_ptr(s->cpu_sheaves, cpu);

        rcu_free = pcs->rcu_free;
        pcs->rcu_free = NULL;

        qpw_unlock(&s->cpu_sheaves->lock, cpu);

        if (rcu_free)
                call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
}

Only call rcu_free_sheaf_nobarn if pcs->rcu_free is not NULL.

So it seems safe?

> How would this work with houskeeping on return to userspace approach?
> 
> - Would we just walk the list of all caches to flush them? could be
> expensive. Would we somehow note only those that need it? That would make
> the fast paths do something extra?
> 
> - If some other CPU executed kmem_cache_destroy(), it would have to wait for
> the isolated cpu returning to userspace. Do we have the means for
> synchronizing on that? Would that risk a deadlock? We used to have a
> deferred finishing of the destroy for other reasons but were glad to get rid
> of it when it was possible, now it might be necessary to revive it?

I don't think you can expect system calls to return to userspace in 
a given amount of time. Could be in kernel mode for long periods of
time.

> How would this work with QPW?
> 
> - probably fast paths more expensive due to spin lock vs local_trylock_t
> 
> - flush_rcu_sheaves_on_cache() needs to be solved safely (see above)
> 
> What if we avoid percpu sheaves completely on isolated cpus and instead
> allocate/free using the slowpaths?
> 
> - It could probably be achieved without affecting fastpaths, as we already
> handle bootstrap without sheaves, so it's implemented in a way to not affect
> fastpaths.
> 
> - Would it slow the isolcpu workloads down too much when they do a syscall?
>   - compared to "houskeeping on return to userspace" flushing, maybe not?
> Because in that case the syscall starts with sheaves flushed from previous
> return, it has to do something expensive to get the initial sheaf, then
> maybe will use only on or few objects, then on return has to flush
> everything. Likely the slowpath might be faster, unless it allocates/frees
> many objects from the same cache.
>   - compared to QPW - it would be slower as QPW would mostly retain sheaves
> populated, the need for flushes should be very rare
> 
> So if we can assume that workloads on isolated cpus make syscalls only
> rarely, and when they do they can tolerate them being slower, I think the
> "avoid sheaves on isolated cpus" would be the best way here.

I am not sure its safe to assume that. Ask Gemini about isolcpus use
cases and:

1. High-Frequency Trading (HFT)
In the world of HFT, microseconds are the difference between profit and loss. 
Traders use isolcpus to pin their execution engines to specific cores.

The Goal: Eliminate "jitter" caused by the OS moving other processes onto the same core.

The Benefit: Guaranteed execution time and ultra-low latency.

2. Real-Time Audio & Video Processing
If you are running a Digital Audio Workstation (DAW) or a live video encoding rig, a tiny "hiccup" in CPU availability results in an audible pop or a dropped frame.

The Goal: Reserve cores specifically for the Digital Signal Processor (DSP) or the encoder.

The Benefit: Smooth, glitch-free media streams even when the rest of the system is busy.

3. Network Function Virtualization (NFV) & DPDK
For high-speed networking (like 10Gbps+ traffic), the Data Plane Development Kit (DPDK) uses "poll mode" drivers. These drivers constantly loop to check for new packets rather than waiting for interrupts.

The Goal: Isolate cores so they can run at 100% utilization just checking for network packets.

The Benefit: Maximum throughput and zero packet loss in high-traffic environments.

4. Gaming & Simulation
Competitive gamers or flight simulator enthusiasts sometimes isolate a few cores to handle the game's main thread, while leaving the rest of the OS (Discord, Chrome, etc.) to the remaining cores.

The Goal: Prevent background Windows/Linux tasks from stealing cycles from the game engine.

The Benefit: More consistent 1% low FPS and reduced input lag.

5. Deterministic Scientific Computing
If you're running a simulation that needs to take exactly the same amount of time every time it runs (for benchmarking or safety-critical testing), you can't have the OS interference messing with your metrics.

The Goal: Remove the variability of the Linux scheduler.

The Benefit: Highly repeatable, deterministic results.

===

For example, AF_XDP bypass uses system calls (and wants isolcpus):

https://www.quantvps.com/blog/kernel-bypass-in-hft?srsltid=AfmBOoryeSxuuZjzTJIC9O-Ag8x4gSwjs-V4Xukm2wQpGmwDJ6t4szuE



