Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1356FCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E376B008A; Tue, 12 May 2026 08:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698126B008C; Tue, 12 May 2026 08:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587766B0092; Tue, 12 May 2026 08:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43EE26B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:25:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02AD9404A9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:25:31 +0000 (UTC)
X-FDA: 84758688504.04.FB06250
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 846EAA0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:25:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SNXZ9iwY;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778588730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4HWagasbPMCVt2zEZqRn6HnLJ9RH9GudAe7GZqL/ueQ=;
	b=7cUx3+K4+hSqvY1VK8bAO/sECt1rm7nOQwe1TqWiEjFUhPbgFthk8npeM781pjDKqksSyl
	3xH4XzDBWlNmDGFxYqyuASkHu+2joxRAmfxJUmxAgj6Bcz0s8kRqgwYMX+KRzRhn1VcDKy
	2jlLJokJX+ukTXolJ/0qhlNgC6smngU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778588730; a=rsa-sha256;
	cv=none;
	b=Xce5ewEZ7c2/KDhpIiFIuXPNbI1aaSsosuwgRbGbNyxkvZUCibWv5fSjtGZ+BUS3AqD11D
	h2JfEI3Xja5hg04Sd6CcFbpVw4SRuUpcO5YjqTlJ77LSE2Q+PCiDrhrcDNg1tp1Z1k/1ke
	rrywnXWBy0+/6u/cnKFbrEukTVUT+jY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SNXZ9iwY;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 077A660055;
	Tue, 12 May 2026 12:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EE0C2BCB0;
	Tue, 12 May 2026 12:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778588729;
	bh=0RXUz7YJtUgH3NHoplRgNBgOPpNfBk69RhQj1tBwiL4=;
	h=Date:From:To:Cc:Subject:From;
	b=SNXZ9iwYKiRfJE0ZYpee+yMlFOprVutfjh3JfVHjpSN6YsYT6CwOAARrZbKwHOxsM
	 YAjBEQ1pyiz2Duweujpa1G36NwoK/P+MPTtybLDyKz3DTbFbEuM7+GpWUFf1QAa3vQ
	 AOVFx7IX96tBjIfthl6CQPow3LsR+HAJwXifA14886jwba26Bjkr9EjQtVRIFuCZSQ
	 h1acq5r9QCVvvrklFeTye1cFxB4fvBbyug+NpzxhTTl42gRztcUSo8Zrt02h0nutfa
	 WxT1/qGB/vF4hpT8roaTmEwLpAXoj9jnoba73s6uLu6csgAvT/KrJNbyT0W5nq+Eja
	 ZlY6nplvEguFw==
Date: Tue, 12 May 2026 21:25:27 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: linux-mm@kvack.org, rcu@vger.kernel.org, bpf@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Puranjay Mohan <puranjay@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Amery Hung <ameryhung@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: kmalloc_nolock() follow-ups, including kfree_rcu_nolock()
Message-ID: <esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 846EAA0002
X-Rspam-User: 
X-Stat-Signature: bihk9488u1jbbsxf88ymangdu6u1fajz
X-HE-Tag: 1778588730-832116
X-HE-Meta: U2FsdGVkX1/OH8uS2Nhh6+DE0n5+yfiSVX2WzgtnHvntWmAocW+kn9MaGyFie+ukY49kMbBMq/2wYuabpZE/MQifZ2IOKP0ICj3PRNgv29LRdNha4i/Qeh9qI9+g4ydpwk89K1PiARSzXOJCCe1Azixp/O48qAUdvnQZrahk3PsNogQ4qAWp1lSsc+piJFbOLUhGv7a4WniRYk8iiHcbEY6nD3Dc0CrPeIDzj64p0dm9E3d4joLlkTCj3+xfRDTemmIDhgYpMK/d2VWAgObN/FjFDNix3CC/j00s39i1R1FODNLREmr1mnyXFdU2n8ooaATGvGQOXBP/IANDZZtDXd5LatVKQHH27EV2zSBpG9daoIIj4tb9eroS8MGV0OeGhkdRwoEWJbtmrsPzR2R2GtpNPcOtulkIwcuSd2lXBk6lWPx9BaWaNJCKPBdCPQs/ns6kYrtnJKC2Ml0l6Gp82rRyFpm9kdE8R19fhr0mJPr5/0ZNJf2ZAM3BhAfK0PKDI4xc0fHm4r7AVjt23DfKMufeQwOH1ec/cDDAsLGmHlv1KnKkdMq9Cb/jBowIs9aLKKLVBkbhkgGDpjbr0gtxkYfBH+FPtfT9FJQNj41sBI2ow0AjXGZMJLWf9GFZxhhaQiDBqe6Nr3f83wmluwM7Ibd6D9CficrZ9k4TTDrmGZfH1fmCjrHabHAUvlZ3aj4wELxtHoUkAcLWuUJ4hpFU4RJu3S4ffpv3ElIkgxhoO0hbTvsJ6aorncRZa+wIdoyEqbz8zqloimxEYxe1OSj8uwpu9ww16CrsLiAF7uSPXdYo+3YdZ51KVLvBQw88xcoB7A/3kYbJ3veWjpssIdjOLIYPvhJmauCL//hgQKbGc3iGHTw2CYPWbNy0sH1qGHW0a2WXXI1Bifc4O/292AkhB4XNfapBdzkAYXGSLQ8QBrsJ7o7XXdc2kXYNTe06aPZaTPNYt1fbjxHN6mQK6Gh
 hsPRd/s3
 JT2q+2uy5ruoLSJrAWMGHfHfPGjCmiPrq7lhOl8BGr+jWvj25yH58wuBsNn0OHu3DR71F//oWzBuBVlB6iztZkAasYIQE70AgOr4xpNzsQHLOfigVJ+y3osLJThlGZeaHhFMLpw3N1ltj/RAmLdFRUzJeTXZ++eK0XmBxfWXiUvbQQEKPqXndmpFb3FMeb80LHxbN3OxOk564HHocVyWyiNIvO+eN9+EnKVBWL95HSnJXne0UMoj5K0T2IfQMH6GOaRPEEBP9ov7I3ddZNPf2o4BvlaDrOhbzq9qwMa1LXgCKot25aDLyVwPL//9IqDM2lCPu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello everybody. This is a follow-up discussion of
"kmalloc_nolock() follow-ups, including kfree_rcu_nolock()" topic at
LSFMMBPF 2026 last week. Unfortunately, many RCU folks were not there,
but we can still discuss over email ;)

The slides: https://docs.google.com/presentation/d/1kpaLd7D1dwRvIqRwQfSjJVVJL0CC2gwb-AV56yCMqXw/edit?usp=sharing

I'm copying the slides here to make it easier to reply.

kmalloc_nolock() follow-ups, including kfree_rcu_nolock()
=========================================================

Today's goal
============

1. Present why and what we're doing
2. Demystify BPF's requirements for memory allocation
3. Discuss solutions

Motivation
==========

BPF map preallocation wastes memory for correctness
- preallocate all elements by default, unless opted out explicitly
  (BPF_F_NO_PREALLOC)
- Typically not all elements are used, wasting memory

The BPF memory allocator was invented to avoid that
- Allocate elements on demand at BPF runtime
- kmalloc isn't safe in some BPF contexts (in NMI, or in a critical
  section), so a new allocator was invented

Challenges with the BPF memory allocator
- Memory is tied to the BPF subsystem and can't be used elsewhere
- A burst of allocations can cause failures until async refill catches up
- Trade-off between memory waste and allocation failures at large sizes
- Reinventing every memory allocator feature is a maintenance burden

The end goal
============

- Drop the BPF memory allocator
- Avoid preallocation as much as possible in BPF
- Use kmalloc_nolock() and kfree_{,rcu_}nolock() (and friends) instead

To achieve that, we need to define requirements & expectations from BPF

Background - RCU and BPF programs
=================================

- Non-sleepable BPF progs run in an RCU critical section
- Sleepable BPF progs run in an RCU Tasks Trace critical section
- Freeing by RCU for both non-sleepable (RCU) and sleepable
  (RCU-tt) progs means we need to wait both GPs before releasing memory
- RCU Tasks Trace (RCU-tt) is an RCU flavor designed for sleepable
  BPF progs, lighter than SRCU
- Since v7.0, RCU Tasks Trace is implemented using SRCU-fast
- Since v7.1-rc1, RCU Tasks Trace GP is contractually guaranteed to
  imply an RCU GP
  - Yes, that means waiting for an SRCU-fast GP automatically covers RCU
    readers

Background - BPF memory lifetime
================================

Objects allocated for BPF may be referenced by either 1) non-sleepable
or 2) sleepable BPF programs, or both

Memory allocated for BPF may be:
1. Freed immediately <- This is supported today via kfree_nolock()
2. Freed immediately, but can be recycled with typesafety-by-rcu
   semantics (for both RCU, RCU-tt)
  - bpf_mem{,_cache}_free()
3. Freed after RCU GP
  - sleepable progs not allowed
4. Freed after RCU GP + RCU-tt GP
  - sleepable progs allowed
  - bpf_mem{,_cache}_free_rcu()

If you need something not listed here, please let us know!

The big picture (today, within the BPF memory allocator)
========================================================

- bpf_mem{,_cache}_free()
- Analogous to SLAB_TYPESAFE_BY_RCU, but for BPF
- Insert objects to free_llist or free_llist_extra
- When high watermark is hit, move objects to free_by_rcu_ttrace
  and then return objects to slab after RCU-tt GP
- However, they can be reused before returned to slab (again,
  analogous to SLAB_TYPESAFE_BY_RCU)
- bpf_mem{,_cache}_free_rcu()
- Analogous to kfree_rcu(), but for BPF
- Objects are inserted to free_by_rcu
- Moved to waiting_for_gp list, then wait for RCU GP
- Moved to waiting_for_gp_ttrace list, then wait for RCU-tt GP,
  then returned to slab
- Objects remain intact for RCU GP and RCU-tt GP

The big picture (today, outside the BPF memory allocator)
=========================================================

- This slide is intentionally left blank :)

The big picture (in the future - with kmalloc_nolock() follow-ups)
==================================================================

Let's drop the BPF memory allocator completely!

Case A: Free immediately
- Cache: existing kmalloc-<size> family
- Alloc: kmalloc_nolock() -> alloc_pages_nolock()
- Free immediately: kfree_nolock() -> free_pages_nolock()

Case B: Non-sleepable readers only, free by RCU
- Cache: existing kmalloc-<size> family
- Alloc: kmalloc_nolock() -> alloc_pages_nolock()
- Free by RCU: kfree_rcu_nolock(obj, rf) -> call_rcu_nolock()

Case C: Both sleepable and non-sleepable readers, with free by RCU
- Cache: existing kmalloc-<size> family
- Alloc: kmalloc_nolock()
- Free by RCU: kfree_srcu_fast_nolock() -> call_srcu_fast_nolock()

Case D: Both sleepable and non-sleepable readers*, with typesafety-
by-rcu semantics
- Cache: a fixed-size kmem_cache with SLAB_TYPESAFE_BY_SRCU_FAST
- Slab freeing deferred until SRCU-fast GP but objects can be
  reused (analogous to SLAB_TYPESAFE_BY_RCU)
- Alloc: kmem_cache_alloc_nolock()
- Free immediately: kmem_cache_free_nolock() ->
  call_srcu_fast_nolock() (to free slabs)
- Need slab dtor support to release resources when freeing slabs
  after SRCU-fast GP

Unlike kmalloc_nolock(), "try the next bucket" trick doesn't work.
Instead, create two caches: one for normal allocations, the other for
fallback. Free objects with kfree_nolock() without passing the cache
pointer.

*Even when only non-sleepable readers are allowed, you can still
use this!

Progress since last year
========================

- alloc_pages_nolock() / free_pages_nolock() merged in v6.15
- kmalloc_nolock() / kfree_nolock() merged in v6.18
- RCU Tasks Trace re-implemented on top of SRCU-fast in v7.0
- Transition to SRCU-fast was not smooth, ended up fixing bugs
- RCU Tasks Trace GP now explicitly implies RCU GP
- implicit since SRCU-fast was introduced in v6.15
- explicit contractual guarantee in v7.1-rc1

Things to do
============

- Define clear requirements/expectations from BPF (for memory allocation)
- Introduce kfree_rcu_nolock() (in RFC)
- Introduce kfree_srcu_fast_nolock()
- Add SLAB_TYPESAFE_BY_SRCU_FAST support
  - Need slab destructor support to clean up when freeing slabs
  - Need call_srcu_fast_nolock() to submit free slabs to RCU
- Migrate remaining bpf_mem_alloc users to kmalloc_nolock()
- Introduce call_rcu_nolock() and call_srcu_fast_nolock()
- Allow kmalloc_nolock() with large kmalloc sizes via
  alloc_pages_nolock()

-- 
Cheers,
Harry / Hyeonggon

