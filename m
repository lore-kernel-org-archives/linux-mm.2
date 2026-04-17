Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D980F43688
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3ED6B00C7; Fri, 17 Apr 2026 05:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55016B00C9; Fri, 17 Apr 2026 05:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A922A6B00CA; Fri, 17 Apr 2026 05:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9737B6B00C7
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:40:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B709C3754
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:40:13 +0000 (UTC)
X-FDA: 84667551906.19.1A4A45F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 682B140004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:40:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OSVghLqN;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776418811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmlXRoXuOzQ43h1Lk4egNiL2vgtKgLb7+att4sbEeBw=;
	b=RuA1EcpmS6878fBGSpvp37Cf2t8Oz5yBRggLFr+gD96IwfYk3HeqzmKoPpQZkrzwWwDYNV
	dX4W5F9Wy72rriP27wPWmyAV7dCEXgMHagj02WAAC7WC+LqKLn/x0LugbN4IOlkx/Qyei0
	qs46tSYjuQB7w16ui/ger+cMlkefFkk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OSVghLqN;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776418811; a=rsa-sha256;
	cv=none;
	b=ELPZzrihoXWXpXleibzAtApundUntY0198tvQroll1jqWDXMPeqBWPn9jYJtZj3pK1W4XP
	GBSLArdwjX4svp5jWdxUhG3ZaFqtrDFVsXFs4laNbbvPGxrlWIsHkKBqDbNzvMWPQEFpok
	f82Jzvz9K+kTlcakrp7rpRUN9uKNHAQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89AE241877;
	Fri, 17 Apr 2026 09:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB02C19425;
	Fri, 17 Apr 2026 09:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776418810;
	bh=2+EMGZatx3elNtBDlV9a/oYfPOATBv6xqm+cipXEGjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OSVghLqNmqkMpxBP85e1D60Dz6LTrCtADyGYU08LtrCCu+90HR/qQkBnTH2SHg7KY
	 TGlxWvYOWovben3j+MI3EOtni2YXfI810ccmqxt/aH0MOeyUtrJ+K7DhkC4FzoiM5L
	 okbaqgN/Ys7HX3Pwx1vUJBcwOayn9lY2PgR+l0+cjSQA8iX5ShSe7/sIMLoP6ZPoD+
	 TUTRGfboVCq5RMtmJttzSTQldqMSdYEAji57BrgqvbKUK1FOlpl98+HyUErhgfVyv/
	 UgpKgbQenAQNjjZ5t3OC17A/SQXYWEC6w4SYQH2CtxRdDd3tNeouMTDCvBY17GYHxU
	 Ms//PMrELMt0w==
Date: Fri, 17 Apr 2026 18:40:08 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>, vbabka@kernel.org,
	akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
	roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.orgg
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <aeH_-EYzI3IkeOv4@hyeyoo>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <87a4v47xk5.fsf@intel.com>
 <wamsxmuhcbr6hj5y53bheub4cmkq7pd3psntl66o74k4bmtygi@qhyse67jvr3f>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <wamsxmuhcbr6hj5y53bheub4cmkq7pd3psntl66o74k4bmtygi@qhyse67jvr3f>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 682B140004
X-Stat-Signature: 1k1646hr7493tfyzaaima7pndrxjzyks
X-Rspam-User: 
X-HE-Tag: 1776418811-328165
X-HE-Meta: U2FsdGVkX1+nyFHKEmfSreAUA2U9g46tBzDWvSc6QwaVUBNXWgYcZrBpxHZjpmwsIPCsLKiWEQlNweZYAvRiruhDQsclbgx7U4S5fP/KOtfugFzN5SVw5aE5LUyAaqnApX2vOsKG0zAp9skDs6xX2TWX7tw/Nqb/RdxiKgaqHebdZZXBctWz7y2lD8C91VQz4EGZQIhHOd7oOSa9a7AzLDFkKYj/AshTf6Oa8KoTjsalYxmImmyNgemsnjRLN2uzpCZ0tjGG68vAynCqi+dnncxYC1/49KYQE9u989iboRfpP29QpZq5gHljeBEPjOoIkUiXXj1R4ySRBsdBVGjgXSGo+6GpYbQW7ppBLpUqTACs/icEPkMfBrjEtE9+Ko0lsyJyJ0E5KMrc/D0EhPHu8jrrbW5DfQu8YYS+0kJsidcBLkwFfDLxd3dXjSirTa9xDkBZ1o5Prz9Iq8QfsHkAo3xmSPe7ztZ1CWhuUYBtBCIgCWhY247Dj+6GDzIBFmscD2lWymGBZouKzB9bztbxh1ZT/W3rBlWyBgW56HgsKB4rXFUINcpo+POk0HR0nkLw+TAqbYanUa/zPyK7Z9u35H5rBK8+DrO8+Lu9O19CRXoO05Vge6shYuSWEtJz6GjA0lsE1Jw7AZfnA+dXlDBoe2ZmGqHBlaeU0moF6v8/yWUsar+flka9BlijIuakcS8DPBnrNN1ohFS3v77Up/MAi9/9RTaZaQo0uO8Ucjzx+CxhSdC3UbgkboXxfcxzx43//lL5wBcjto7GUSxATrxfRdpgc3iOT6VKU3T5w75DP0QMc+TJJsOzni5//dhz8BCc5d42xuVvjUICxN1P5Gc/hLxIQc0BpHOwZYBNZyabIV+kfGkHSSs6ONZ5iyK407jCxW+nK61FdzRmMovWxLCTs7KtQi+m/B3nxyWs2Q4lC6RQgU+plYW7lCyleUI9sumw8ZkhrRTV0h1jh5VHp/y
 5+jUmWpZ
 OnCk/27GimnmY1bNzTlSPuoggcQxFL9TL3VWccom65QDcVX2ZWJIA/cnyCPAZDoJPHgWksKXvNOaC0cl4kY/kgsaBtO1nX0Z+9avuNhrgYZ0KLIMrUsj3YoPB38/1BcYmm6UFkX7KT8plkqFc7mDn9yiF9tzc0tkgyHE7rc1tPv8lT9yK39kTxAjLFNmZCuVGRDnXnZDZnUD1LzMC+oJZGse2wUeQFS2rDvYpGiETGMbF9YggguNv2Ggp9ayh5a5tIT1PrKbnz07kI2kk1lboiXHiWPGYr34qZH1YtzAVF7uArkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 01:49:01PM +0800, Hao Li wrote:
> On Wed, Apr 15, 2026 at 01:55:54PM -0700, Vinicius Costa Gomes wrote:
> > Hao Li <hao.li@linux.dev> writes:
> > 
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
> > >
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
> > > On the mmap2 case in the will-it-scale benchmark suite, this patch can
> > > improve performance by about 2~5%.
> > >
> > > Signed-off-by: Hao Li <hao.li@linux.dev>
> > > ---
> > >
> > > This patch is an exploratory attempt to address the leftover objects and
> > > partial slab issues in the refill path, and it is marked as RFC to warmly
> > > welcome any feedback, suggestions, and discussion!
> > >
> > 
> > I was also looking at these regressions, but I went from a different
> > direction, and ended up with 3 patches:
> >
> > 1. the regressions showed a lot of increase in the cache misses,
> >    which gave me the idea that a cache would help (and it seemed to help)

I really appreciate looking into the performance change but think we
should first try fixing existing corner cases and/or try tuning existing
parameters (s->sheaf_capacity, MAX_{FULL,EMPTY}_SHEAVES, s->min_partial,
and s->remote_node_defrag_ratio) before making such design changes.

Exploring a design change too soon without fully exploring
the limitation of current design isn't worth the effort.

in the first patch description:
| When the sheaf allocator needs to refill from the node partial list, it
| calls __refill_objects_node() which walks the freelist of a cold slab
| page — one that has not been in any CPU's cache since it was last freed.
| On NUMA systems with many concurrent threads, the majority of these walks
| hit remote DRAM, causing a significant increase in LLC misses.

IIUC you're arguing that iterating over slab->freelist just to return
the slab back to the list unnecessarily results in higher cache
footprint, right? (and even worse those slabs are from remote nodes)
(unlike Hao who argued it's more of a n->list_lock contention thing)

in __refill_objects_node():
| __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
|                       unsigned int max, struct kmem_cache_node *n,
|                       bool allow_spin)
| {
|         struct partial_bulk_context pc;
|         struct slab *slab, *slab2;
|         unsigned int refilled = 0;
|         unsigned long flags;
|         void *object;
| 
|         pc.flags = gfp;
|         pc.min_objects = min;
|         pc.max_objects = max;
| 
|         if (!get_partial_node_bulk(s, n, &pc, allow_spin))
|                 return 0;
| 
|         list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
| 
|                 list_del(&slab->slab_list);
| 
|                 object = get_freelist_nofreeze(s, slab);
| 
|                 while (object && refilled < max) {
|                         p[refilled] = object;
|                         object = get_freepointer(s, object);
|                         maybe_wipe_obj_freeptr(s, p[refilled]);
| 
|                         refilled++;
|                 }
| 
|                 /*
|                  * Freelist had more objects than we can accommodate, we need to
|                  * free them back. We can treat it like a detached freelist, just
|                  * need to find the tail object.
|                  */
|                 if (unlikely(object)) {
|                         void *head = object;
|                         void *tail;
|                         int cnt = 0;
| 
|                         do {
|                                 tail = object;
|                                 cnt++;
|                                 object = get_freepointer(s, object);
|                         } while (object);

So here we make the slab "warm" although we're not going to use it,
just to get the tail object.

As Vlastimil suggested off-list, we could probably assume that nobody
is has freed objects to the slab and try __slab_update_freelist()
and avoid iterating over the freelist? (a kind of blind Compare-And-Swap)

and then fall back if that fails.

|                         __slab_free(s, slab, head, tail, cnt, _RET_IP_);
|                 }

Back to the description:
| Add a per-CPU warm slab stash: a single (slab, freelist-head) pair stored
| in struct slub_percpu_sheaves.

Oh, calling it "warm slab" is very misleading. Warming the slab in
__refill_objects_node() when it has more objects than
(sheaf->capacity - sheaf->size) is current behavior

| When __refill_objects_node() drains a slab
| from the partial list but has excess objects (more than it needs for the
| current refill), it stashes the remainder instead of returning them to
| the partial list. On the next refill, drain_warm_slab() serves the
| stashed objects first, skipping the cold partial-list walk entirely.

and your patch changes that. It's not warm anymore.

> > 2. Allowing smaller refills (but potentially more frequent);
> > 
> > 3. A cute (but with small impact) use of prefetch();
> 
> Great!
> Thanks for sharing those infos!
> 
> > The numbers are here (the commentary from the bot are very hit or miss,
> > so don't pay too much attention to them):
> > 
> > https://github.com/vcgomes/linux/commit/c898c39ee8def5252942281353eda6acdd83d4ea
> > 
> > I am re-running the tests against a more recent tree, but if you
> > want to take a look:
> > 
> > https://github.com/vcgomes/linux/tree/mm-sheaves-regression-timerfd
> > 
> > Also, if you feel it's useful, I can send a RFC.
> 
> I also tried stashing leftover objects into the PCS before, but at the time I
> observed that this could quickly drain the node partial list, which then led to
> slab alloc/free churn, and the end result was a performance regression. So I
> gave up this direction :/
> 
> I took a quick look at the code and performance report in your GitHub repo, and
> the performance gains you showed there are really interesting to me!
> I'm going to try testing it on my own machine as well.

Comparing the patch 1 with Hao's patch (spilling objects)... it doesn't
touch those leftover objects (reduced cache footprint) and also does not
spill them into sheaves (hit the free slowpath less frequently).

-- 
Cheers,
Harry / Hyeonggon

