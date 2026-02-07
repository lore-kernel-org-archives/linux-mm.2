Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC260EE6B6C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 00:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290386B0092; Fri,  6 Feb 2026 19:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239496B0093; Fri,  6 Feb 2026 19:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108B86B0096; Fri,  6 Feb 2026 19:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1FDB6B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:16:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B54BCC18E7
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 00:16:49 +0000 (UTC)
X-FDA: 84415744938.11.26A080B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 36F51100005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 00:16:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJ8QBU3g;
	spf=pass (imf05.hostedemail.com: domain of "SRS0=IOST=AL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=IOST=AL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770423408;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGr1ePV66UvuGQOjrkpWkxTE6A1swlAzKdjhTQJYHVw=;
	b=wQDmIXONTci1TYRu+WyTaFIkbQrtYBxhCWywEUg7jeXuto4JpOpHwb/G5XruW+d7raG3eT
	oudLAPNrWlzG+aWTuZTGxT8Wmxrid76xhaCCknx/KNLLc/G/xtAmXTB43+s0vs4BmfF8V3
	epjJp6TrW24IanWRlhpv2sMBO+pSQ/c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJ8QBU3g;
	spf=pass (imf05.hostedemail.com: domain of "SRS0=IOST=AL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=IOST=AL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770423408; a=rsa-sha256;
	cv=none;
	b=cylmw8nrC+hGfpZUN5CmXL9kgBbV2hBfAUKrMS8hJOsmjX1hhu9+AeYmhvwY2tnqw5cGqN
	kDM8woCdojQIA9pintDxoMp4pjJE6nQBVupK4lfl88KZPDYswdli7/EXQJVKpnegjsFL7K
	Fle3oK9nQQ4SIRk6HejQjGyGic4WIAk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 378836014C;
	Sat,  7 Feb 2026 00:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69A9C116C6;
	Sat,  7 Feb 2026 00:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770423406;
	bh=cmHcOieE29bkmKS4OIrRotVZKXlaKd4m1k0Q6/r1ulo=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=WJ8QBU3gAvqXiJztkXogHR7//XU6ECPlbV7aQWFk+TWGS2vbvP5MpnlyXlu0PjbfG
	 JsTV1sG4Fu2/789HI+xuWRG8WEu3rzIHeONZc6A7+TqxM6S9p3eeG2UijE1vSap2Kx
	 VrZXn6iH7vFAyT9cMavRBSkLwd/kk6GHO6/uj8sPQ32xLxEeHMIidELEzVnBtJeiQf
	 Q8iRuqD/x8BsFqjqqIIPyrtlx+cCmUqxegKJlCxhh4Qdr0NYbiLD7n35cvhV5P6fck
	 FuCI+dMSmtoNTZ4YpeDOcP6KaaMhwLnNEHXvVUx8rPnmkQREjTF//zot0M9ZtrRbqI
	 iW/zKYHKsn12g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 6D37ACE0F9F; Fri,  6 Feb 2026 16:16:46 -0800 (PST)
Date: Fri, 6 Feb 2026 16:16:46 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] k[v]free_rcu() improvements
Message-ID: <3069e76d-5c7a-4c3f-9b83-43ed1700b95f@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260206093410.160622-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206093410.160622-1-harry.yoo@oracle.com>
X-Stat-Signature: cqw75jtn16o7qra7b91m3wpau7npdtf4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 36F51100005
X-HE-Tag: 1770423408-632194
X-HE-Meta: U2FsdGVkX1+Mzq91vdqrrboRwkxfW7SvGtOXmBxtrUVa0ZtKKxMfncSxmpb2Vk5+jHYjVQu84gn/cs0tK6rkx1qpeFK4EMS4ik3b/+SNexMILUcVwA15yi5RSNLSrpS7EiAqav6jB04yK19bumYrYmqHpCsq6E1QJTowVbWarhrCGViGyOxh5swtKV7To4CWR1g/XUa8rEVccpXOSz1TGEsMeCyX/ZD9V+/WKdRKm3Q7ekMakVvDi0gsT0/nTQkDMp4/Ah0n1lplDMnozogDBr2p4dhMmqrhGT2yb+FVWEGc/nRFKr0MIacXOHOTgQFrWK9GuS7Sb0BsEg8oEy3QSiRUiWU6uy4d3N9frG9T7HyHt5aj+9F7mwzwT5o7nStdoDYGhBBFPteSYCTt6vWX8jDNJ0S/H9WMJGx336Jt5BwQQJhhL+w1CKpOf31nyvS0oNIe2UVqNX3bOig8f9TVe6axu4yEkhyf7DqLO4xS5jJx6G6++9IzGmxS4iMpqXYdmA6yWwuixtnssSh89+nwkB1SqqP3d+kefEkmJvcadWE1BxeCgO9J9P/h61O7u03TfdR8XRByYLBIwcKFxdhVt8uO2pop+wnIvJqnMZn2liMyU3TxpXGZJHzEGzUdWBMwqY3sbfyGObJN5R8kCX0J+lbpXKUs2myK67KSlMYw5ddnFcPuCAv3W4QerN83ADtZqen2fMS8FGtZHyJdU/V4/VNW6hu6/YAJhwD8VlSgFWcNVjRYUKICzL7mCWr0qSPaTFFtt13cKyRNL8A8Up8lTinqVipG/VrPlCSY4RkHFobWLrr0rpwMnq6M2Zzar6jgYPO+LeUxynQgzVBHsJPckJ8EbszleZ8SWhKdpL9nlEEgwZVrfXMpKHfxMFw5jB1KsB9DPIjrelAQ8qVtlSW6VjUobdqFlV/I4lNtVtqp+56DW0Ay/FWG6i5Au/dUu9hBdX14SMltvP/IGeh7Skv
 2uQOYj1u
 RKRmm0tE3fvT6n/cedZlpzsm9xiFQPxwzoR0SEcc5KXwfZawaG2KpNHMI8+KvBMJOblRz/fOK6ZGfQQU7KV047cXYN0CMFqPVSkP2DTgt43aYcIBH/2PpzEjT3F8AYeN38DlIwkEpJMsXwQGEih1eXy3v6nXv0h4J95CeaZqMsTirZgI/hp4pkILBlWrPP+3G8yB7bgVxdvv7idfGdOxhmruws0J1Fi3L/uORj75sxk0dnhY/aFd3hXQCBLmBC1odojk3MNmgJplzHvErfhnTpCX62GccQiclywEEOZ0YinhPOlGSlZ2Dx7SIGktkslhmxhq7VzHlU5tZlJjohbtb7U1D2PXYYRmrMMRoWdUGxpfiYt1w81IQJWAThhzaocWW9xv2ano6t2lTRhN63yq8FA/KhqxwFSp9wwz2F1FhbbMYI/DXIkjKTNsh/4r4SUrjXUQj5ZRvhUT5u8N4nrK7E/uuwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 06:34:03PM +0900, Harry Yoo wrote:
> These are a few improvements for k[v]free_rcu() API, which were suggested
> by Alexei Starovoitov.
> 
> [ To kmemleak folks: I'm going to teach delete_object_full() and
>   paint_ptr() to ignore cases when the object does not exist.
>   Could you please let me know if the way it's done in patch 3
>   looks good? Only part 2 is relevant to you. ]

On what commit should I apply this series?  I get conflicts on top of -rcu
(no surprise there) and build errors on top of next-20260205.

							Thanx, Paul

> Although I've put some effort into providing a decent quality
> implementation, I'd like you to consider this as a proof-of-concept
> and let's discuss how best we could tackle those problems:
> 
>   1) Allow an 8-byte field to be used as an alternative to
>      struct rcu_head (16-byte) for 2-argument kvfree_rcu()
>   2) kmalloc_nolock() -> kfree[_rcu]() support
>   3) Add kfree_rcu_nolock() for NMI context
> 
> # Part 1. Allow an 8-byte field to be used as an alternative to
>   struct rcu_head for 2-argument kvfree_rcu()
>   
>   Technically, objects that are freed with k[v]free_rcu() need
>   only one pointer to link objects, because we already know that
>   the callback function is always kvfree(). For this purpose,
>   struct rcu_head is unnecessarily large (16 bytes on 64-bit).
> 
>   Allow a smaller, 8-byte field (of struct rcu_ptr type) to be used
>   with k[v]free_rcu(). Let's save one pointer per slab object.
>   
>   I have to admit that my naming skill isn't great; hopefully
>   we'll come up with a better name than `struct rcu_ptr`.
> 
>   With this feature, either a struct rcu_ptr or rcu_head field
>   can be used as the second argument of the k[v]free_rcu() API.
> 
>   Users that only use k[v]free_rcu() are highly encouraged to use
>   struct rcu_ptr; otherwise you're wasting memory. However, some users,
>   such as maple tree, may use call_rcu() or k[v]free_rcu() depending on
>   the situation for objects of the same type. For such users,
>   struct rcu_head remains the only option.
> 
>   Patch 1 implements this feature, and patch 2 adds a few users in mm/.
> 
> # Part 2. kmalloc_nolock() -> kfree() or kfree_rcu() path support
>   
>   Allow objects allocated with kmalloc_nolock() to be freed with
>   kfree[_rcu](). Without this support, users are forced to call
>   call_rcu() with kfree_nolock() to free objects after a grace period.
>   This is not efficient and can create unnecessarily many grace periods
>   by bypassing the kfree_rcu batching layer.
> 
>   The reason why it was not supported before was because some alloc
>   hooks are not called in kmalloc_nolock(), while all free hooks are
>   called in kfree().
> 
>   Patch 3 adds support for this by teaching kmemleak to ignore cases
>   when free hooks are called without prior alloc hooks. Patch 4 frees
>   a bit in enum objexts_flags, since we no longer have to remember
>   whether the array was allocated using kmalloc_nolock() or kmalloc().
> 
>   Note that the free hooks fall into these categories:
> 
>   - Its alloc hook is called in kmalloc_nolock(), no problem!
>     (kmsan_slab_alloc(), kasan_slab_alloc(),
>      memcg_slab_post_alloc_hook(), alloc_tagging_slab_alloc_hook())
> 
>   - Its alloc hook isn't called in kmalloc_nolock(); free hooks
>     must handle asymmetric hook calls. (kfence_free(),
>     kmemleak_free_recursive())
> 
>   - There is no matching alloc hook for the free hook; it's safe to
>     call. (debug_check_no_{locks,obj}_freed, __kcsan_check_access())
> 
>   Note that kmalloc() -> kfree_nolock() or kfree_rcu_nolock() isn't
>   still supported! That's much trickier :)
> 
> # Part 3. Add kfree_rcu_nolock() for NMI context
> 
>   Add a new 2-argument kfree_rcu_nolock() variant that is safe to be
>   called in NMI context. In NMI context, calling kfree_rcu() or
>   call_rcu() is not legal, and thus users are forced to implement some
>   sort of deferred freeing. Let's make users' lives easier with the new
>   variant.
> 
>   Note that 1-argument kfree_rcu_nolock() is not supported, since there
>   is not much we can do when trylock & memory allocation fails.
>   (You can't call synchronize_rcu() in NMI context!)
> 
>   When spinning on a lock is not allowed, try to acquire the spinlock.
>   When it succeeds in acquiring the lock, do either:
> 
>   1) Use the rcu sheaf to free the object. Note that call_rcu() cannot
>      be called in NMI context! When the rcu sheaf becomes full by
>      freeing the object, it cannot free to the sheaf and has to fall back.
>   
>   2) Use struct rcu_ptr field to link objects. Consuming a bnode
>      (of struct kvfree_rcu_bulk_data) and queueing work to maintain
>      a number of cached bnodes is avoided in NMI context.
> 
>   Note that scheduling delayed monitor work to drain objects after
>   KFREE_DRAIN_JIFFIES is done using a lazy irq_work to avoid raising
>   self-IPIs. That means scheduling delayed monitor work can be delayed
>   up to the length of a time slice.
> 
>   In rare cases where trylock fails, a non-lazy irq_work is used to
>   defer calling kvfree_rcu_call().
> 
>   When certain debug features (kmemleak, debugobjects) are enabled,
>   freeing in NMI context is always deferred because they use spinlocks.
> 
>   Patch 6 implements kfree_rcu_nolock() support, patch 7 adds sheaves
>   support for the new API.
> 
> Harry Yoo (7):
>   mm/slab: introduce k[v]free_rcu() with struct rcu_ptr
>   mm: use rcu_ptr instead of rcu_head
>   mm/slab: allow freeing kmalloc_nolock()'d objects using kfree[_rcu]()
>   mm/slab: free a bit in enum objexts_flags
>   mm/slab: move kfree_rcu_cpu[_work] definitions
>   mm/slab: introduce kfree_rcu_nolock()
>   mm/slab: make kfree_rcu_nolock() work with sheaves
> 
>  include/linux/list_lru.h   |   2 +-
>  include/linux/memcontrol.h |   3 +-
>  include/linux/rcupdate.h   |  68 +++++---
>  include/linux/shrinker.h   |   2 +-
>  include/linux/types.h      |   9 ++
>  mm/kmemleak.c              |  11 +-
>  mm/slab.h                  |   2 +-
>  mm/slab_common.c           | 309 +++++++++++++++++++++++++------------
>  mm/slub.c                  |  47 ++++--
>  mm/vmalloc.c               |   4 +-
>  10 files changed, 310 insertions(+), 147 deletions(-)
> 
> -- 
> 2.43.0
> 

