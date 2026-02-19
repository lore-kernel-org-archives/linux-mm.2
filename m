Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DFF4E9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08E16B0089; Thu, 19 Feb 2026 10:28:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1E06B008A; Thu, 19 Feb 2026 10:28:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE82D6B008C; Thu, 19 Feb 2026 10:28:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5AD6B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:28:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42B5B1405E2
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:28:38 +0000 (UTC)
X-FDA: 84461588316.26.8B685A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 06D52100015
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:28:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O1j3YrU0;
	spf=pass (imf14.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771514916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOn9mbgWLfiu0CBe21NitF6R9PRIUFVeZ7gu3te+hp0=;
	b=6512McIBa6YNlY6Ep21BFUoDC2LRqowzUeW5AA2pEURaqr019FdHydmUkurNAK7uFp1fuh
	DeI0GrLC7acG3V3r6yQOuzbX2dYFKxwfZ9QLtZ9mHCsEgGyIU4a2y0mnr4uyNeufPby9f4
	0dNW9JS3FvMPJEzT0WgYG2jCtnqlMOE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O1j3YrU0;
	spf=pass (imf14.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771514916; a=rsa-sha256;
	cv=none;
	b=XtXGFapPhdjK8NQaW5UV4j0ALIK7SL2sfWorleWZ6lEWIVCYXFO8p1i6y28XjbK993xxen
	KpXzur6LC+92E6vpyoxcCbJmw9ClD28Fe7SNxLFbBG1qQkkVSeLYHlZW8DxNZHS2VsMGgv
	vw4wIq7awxY9DmXIIgzkJsQxyNNAtsU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771514915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fOn9mbgWLfiu0CBe21NitF6R9PRIUFVeZ7gu3te+hp0=;
	b=O1j3YrU0w00Gidr5ewGnAZbV3ChH4B4nvrHZcxl0Ow0nEcBvWhXTaeWdVVwABXeBIvkRv1
	mEkR7OBd7P08iH4FoxWXzQTZ0dy0UFxVnGRCPjNyNxBA9tSnLs826Tqc3xtPE4WnNA5v6C
	N1ccNqUfPJahLlged2yqwmKZENsictI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-yXcD8B0TNmmJdn3IohuKgw-1; Thu,
 19 Feb 2026 10:28:31 -0500
X-MC-Unique: yXcD8B0TNmmJdn3IohuKgw-1
X-Mimecast-MFC-AGG-ID: yXcD8B0TNmmJdn3IohuKgw_1771514909
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B545E180025E;
	Thu, 19 Feb 2026 15:28:28 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA3121955F26;
	Thu, 19 Feb 2026 15:28:26 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id AD065405281A6; Thu, 19 Feb 2026 12:27:23 -0300 (-03)
Date: Thu, 19 Feb 2026 12:27:23 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
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
Message-ID: <aZcr255pGT3B/eaL@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <aZL45yORfkNvS9Rs@tiehlicka>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: PMaRb-xct7Ifo3GZxRQJjts8vm_NnjUd-GPxTzthw9c_1771514909
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 06D52100015
X-Stat-Signature: pkrq1k94jktasi61sb1w91iofq61m61f
X-HE-Tag: 1771514915-741082
X-HE-Meta: U2FsdGVkX1+HBHffNreqZbqXeB7DZu0lOtVSR0D6UVKE+UQMVLVY4ryptwynchgEDJS5WBp8MOz4QDutE2w5CY9/b2DewY+i4Sy6E2viRr/64reqSVKAQSEaK/ZIw0SrL1zRmTA0RLhU3gc6UIkc0oP0OyxTnNY9+hsLg1Aa6gWtyk1ewLdEeNpZIU/dzRbBxSexRMn4iHGYNqgliAUv6JqiiY7Tg/1/rY6fkRG0bYU0w8G/bqAOUVxYbFTR3Umem1GjxvaVcb9rNfugouAnEqslA0P+u8V5Yo/8zdElc4T2zEeyj1fJDmes43qrovlZMsKo2XOt6nfSnQ9BbSjanNdg6Yi55K5uBVZEqa6Yr+2VIBpJNaztB9ldePGR2zmxFB2gH6TVvw4kYREPtU0VXV5tBMbwOGC8XPCKO3aPdAWBzOIH0BsSJi8MU4PaxENYY1Ce5pwbdeMfQQN+f8yIKBd70uUR3oUM9iI85X9HMsH8mGPwo+woxiW6ts+6UCJ1/LVVJN2RbT+nPbWTMyCx99lYBVwsgMJCjIS6zQD3aTuAeJ2NMAcDes/4IfXlPFU50PxkcgNcaYE7VSFfPVjhRb8yoEqOq8K1SnUVV4mYjFgRWqectNCZ2e/NfOfk/05a0dZTQJ17THqtbDbpB9zSKdIB5koTfZRwlluZczufObpBRATahsBmQQIburib9bVlsrz8N8sk7co7EVOqlsb0LhwhZhE3m1sKxlHfT1qLclO48VrR8AopB0eNp55ewAdGsVWZOVIvKjp0MYbZKU8E0s5yg8tplLNTfmpxbtUg2FeyikhbwUNdkKXzJp1MJNvBPAhK0AhcIyWoLF/QG4GY8Nv0TU4/XW/frETNm7x6Qs/DtZsZJ+WHmNlBqWLjzCCW1WMPfbuC5pvaplTxSzL//sPU9FTrnVJhs9dXtMkeXPWo+F+WBX3Bd80jueKQgb5ySvGkYbrEfsMOrOYjVxT
 UPUIsH6K
 bw1PHQXyeuesGuhmPb0jsSz6TCrnYRBL4dteyFSQSlgU3Z1+C8/RTrKGZFHGuthINh/a6FATJwNVzkl7flVpw/O69MdgN9nfM+sHhu/BgXXtD/NxiKhw5BEfS0fv0vGa2jNf3vd6QaO00ex96iIeb8KX8w/O/d3GWYGNj5g3P2rPBn3kxgYCnqlyDIQs05V+e4aLv95I75/G5yNoCqMm7mN9HkFe1/0vJXxGMDwi8Yrb4gx6XXPbd956jObO9UjziX3EgUQDQGghFSmYUqpwT4h0IjsjLyY78Tdz0TCv/xggOeVmKE0V4v91gb6qrO+NBru4n66TdfhfMKe1d0ePLFsEBqve6MhXXtpOtLHKmhV7INxuXlhyrGo5VBtKXGTGwXXVY5GOK9X4WOlQlZ4nJYfOJQwYOR6Pi1MvisyJTmkq1jH7teFuDpBTiwljWxsIQ7vfnucUWp55AvO8ErXNnFIij4TPZ74PFZSvb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > [...]
> > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > have requirements as strong as RT workloads but the underlying
> > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > the userspace which should be taking care of both RT and non-RT
> > > > > configurations AFAICS.
> > > > 
> > > > Michal,
> > > > 
> > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > 
> > > My bad. I've misread the config space of this.
> > > 
> > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > (and remote work via work_queue) is used.
> > > > 
> > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > to happen before return to userspace changes things related 
> > > > to avoidance of CPU interruption ?
> > > 
> > > Essentially delayed operations like pcp state flushing happens on return
> > > to the userspace on isolated CPUs. No locking changes are required as
> > > the work is still per-cpu.
> > > 
> > > In other words the approach Frederic is working on is to not change the
> > > locking of pcp delayed work but instead move that work into well defined
> > > place - i.e. return to the userspace.
> > > 
> > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > paths like SLUB sheeves?
> > 
> > Hi Michal,
> > 
> > I have done some study on this (which I presented on Plumbers 2023):
> > https://lpc.events/event/17/contributions/1484/ 
> > 
> > Since they are per-cpu spinlocks, and the remote operations are not that 
> > frequent, as per design of the current approach, we are not supposed to see 
> > contention (I was not able to detect contention even after stress testing 
> > for weeks), nor relevant cacheline bouncing.
> > 
> > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > is only difference for !RT, which as you mention, does preemtp_disable():
> > 
> > The performance impact noticed was mostly about jumping around in 
> > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > lock/unlock cycle. (tested on memcg with kmalloc test)
> > 
> > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > operations (even if in a local cacheline) in !RT case, but this could be 
> > enabled only if the user thinks this is an ok cost for reducing 
> > interruptions.
> > 
> > What do you think?
> 
> The fact that the behavior is opt-in for !RT is certainly a plus. I also
> do not expect the overhead to be really be really big. To me, a much
> more important question is which of the two approaches is easier to
> maintain long term. The pcp work needs to be done one way or the other.
> Whether we want to tweak locking or do it at a very well defined time is
> the bigger question.
> -- 
> Michal Hocko
> SUSE Labs

Michal,

Again, i don't see how moving operations to happen at return to 
kernel would help (assuming you are talking about 
"context_tracking,x86: Defer some IPIs until a user->kernel transition").

The IPIs in the patchset above can be deferred until user->kernel
transition because they are TLB flushes, for addresses which do not
exist on the address space mapping in userspace.

What are the per-CPU objects in SLUB ?

struct slab_sheaf {
        union {
                struct rcu_head rcu_head;
                struct list_head barn_list;
                /* only used for prefilled sheafs */
                struct {
                        unsigned int capacity;
                        bool pfmemalloc;
                };
        };
        struct kmem_cache *cache;
        unsigned int size;
        int node; /* only used for rcu_sheaf */
        void *objects[];
};

struct slub_percpu_sheaves {
        local_trylock_t lock;
        struct slab_sheaf *main; /* never NULL when unlocked */
        struct slab_sheaf *spare; /* empty or full, may be NULL */
        struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
};

Examples of local CPU operation that manipulates the data structures:
1) kmalloc, allocates an object from local per CPU list.
2) kfree, returns an object to local per CPU list.

Examples of an operation that would perform changes on the per-CPU lists 
remotely:
kmem_cache_shrink (cache shutdown), kmem_cache_shrink.

You can't delay either kmalloc (removal of object from per-CPU freelist), 
or kfree (return of object from per-CPU freelist), or kmem_cache_shrink 
or kmem_cache_shrink to return to userspace.

What i missing something here? (or do you have something on your mind
which i can't see).


