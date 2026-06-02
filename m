Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51305CD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 00:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45AF6B04DC; Mon,  1 Jun 2026 20:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6496B04DD; Mon,  1 Jun 2026 20:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E58D6B04DE; Mon,  1 Jun 2026 20:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 908276B04DC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:31:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39014120827
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:31:47 +0000 (UTC)
X-FDA: 84833094654.22.432F4D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F892140009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:31:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1O5VgG7;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780360305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvpsrQF436x2L0cWUtnjT+RXsKFfyVf7IVhk+awr3Ns=;
	b=TWE0Tpclv5VQ8wwT0J6TXG1tMa6cAKf0Xf/vEEWq9AcV6hXELxN3iTgvVyysWkv5hkSpzD
	0FXMpRYJj8qNrx3amsMEg3jEnQpOr/09iDzxztpurynddgINVZhhDEmFDGrfdDuNKnQxTO
	h5JjGmeEAhKyFcoDZC6HC+oevjIPYPg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780360305;
	b=hz3jjgU4zS1rSM2i0BHOi/Jrh84GHaj1B0TtFNppEvKnACas+UIsqwVNb0/xoZxqFGs26u
	wR9ruMLMs5TWklGIiDsatOexUsQt5cGOHQspErtybV+GE7B/1n6ZS0S2aOhVphwMAVCmGD
	OcFHDxTH3bxHRmrB4oHt47kL1yEHBZg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1O5VgG7;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E9D143DE5;
	Tue,  2 Jun 2026 00:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0391F00893;
	Tue,  2 Jun 2026 00:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780360304;
	bh=dvpsrQF436x2L0cWUtnjT+RXsKFfyVf7IVhk+awr3Ns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G1O5VgG7fthYL5WKXAy3t/bCYnCqhKDmIUjEsm+ZGqi+ffXciopqgn1893NvG6rUo
	 PXyr5CNlmK0mjIB18aA5+8RD1D2IBm2SonVoAbGBtTdSDuXofu/Nhr9Qc12RD5QfFi
	 UmPwy7FucbWywRVVYGfBV7HJezhTMxaDpmhH+yP44zkO5Z/9z0zOh6rwNCSxdHM9ef
	 5ic6sxSiFHOkYFzrZmUyD0uFU72zisqaoyuoazfFbDgXuXeOFzGXz9v+mgeBo3sSNq
	 cshKdE57GJRSp5CmcTSFHCz/NC+2tfW7kW859Uhr1xAGX7GFsFy59m3DE39N+1qzid
	 wFBEPHOsVNq4w==
Date: Tue, 2 Jun 2026 00:31:42 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
Message-ID: <ah4ZZGl7GYJf54Wz@google.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
X-Rspamd-Queue-Id: 7F892140009
X-Rspam-User: 
X-Stat-Signature: 9cj84wukpbfuf8zmngodrig7fswpi6fn
X-Rspamd-Server: rspam08
X-HE-Tag: 1780360305-193671
X-HE-Meta: U2FsdGVkX19u5RdLu0TxEApLBP4J6885Ay3VH7v4vf3mQeVJwFDmjrrdQOlEjaIIgcWBL56mh0kI0ri4izWEv1ThTelhTKuDZIHm6ctoXJDgrYZqSV11e/8JydedTlWFEEEkpHOUMau2/jwrG0CK+XKzORIa9HVG8WJaViHCjqm9CF9OAjlcRAfuIzIi2tx2neIdncW39od9/UqAESG9S/QB7GyKA8+7uo5o1NFl4w5mDiJM8IThHpuYadkx7IKO8L76XkgxG4Tg/taADlYzM5PPkTEds3Wzkssbij8jKqXRsbNwvIhpzbaY+onfcsnCEErcMijUTH8+g9o50qaevCeiXBPsbH4VFFTHBi5DRj3ltIaBcgHLCQFwzV0YL0qltCmYXAmjBAxMHN0AYuon4uZXIgiko+8e/oU8jKPXeGC1W9alo3HOHIqvz/ERl8xoH9cCWF4kwpl7iBmTgiWggYVVnlHsiku87F+N2k38VU/BCq/yy167e4Fn3daQZO/wvQPYWvx5h4ywOSGu4GeaTqf5b9mAvzvJPdl5ayqfrgyWk8LvsatswFy1IxLMXT+RMXf/wPD/EHESpMMxoaXx9ZSjLyD5K8+uFHmeRJE6BkOMZ8bXjg7daI5Wf7HQT0hczOWLKthcpkgu3oHg3NRlMqF52+8k5b8IDvQEzUXtTOBFW+N0oRaCmZVgkIs1MWl0IirXALpZNECYVow2qPAHZKZluHVkZTMmc/O9yBHNPxnC77V5+vMVlGHwd8TdhzZ7qtzJmFVjB9ntOpORtx1uWE7aRQPl0O9ftXvpod0AK0AE6Bs+VeOEV+KYW6ObXB3EW3CISdIjRdbVu7rUobwOXMqIJoiIeNmfHsQ+b/H7yg4r0l2jMv9KHyag2fxisg1dH5rT+2KVaw4YiqfRs6ZfzJwqvQoDYih8xsjdNFA0f7zjt+DSfuWa7hqzdUsZXlRCr9uxavO3mp5M+MJFZw0
 xTXJxIq2
 8+8JcEhjy4/nLQp1+yf8xT3la9gxgT1YJM+isnaa9u+XfDqbJq43hQUvO8auwTmFNwTkm7vDF72DG0912BG1wEkwmZoKpOr3U4fz9BowvOcgG7hYy9BceCYUCGwYmcF/n3DBPZpfbXmNr/IyZEWrQby9CUCbnWMWVAEGh8KA7F7cPxzh67lEzvLsv2oBdoOv9f75bBuPweOGZYc2MztVt95o2on9u02Ex3ScbAzxZ+5zDD3yXGPFj/srsPW4PPFHzGmJWykUTMISUhE5jviIzLIsk9ZKCQTg2gtGzxLbVHh3GUq6Yw/5nVMuaGkDthPTJJ3c2pPlB2zlp2NBQO7RrZLwxnO8iHLJbTZaFfmqs+C1/gdXTzRmGhDSy6wHoewDGIA8H9NPVE3FF3VIoWlccVbDperut+zObl1LDDiLSjgTE9ks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 07:07:45PM +0800, Hao Jia wrote:
> 
> 
> On 2026/5/30 09:24, Yosry Ahmed wrote:
> > On Tue, May 26, 2026 at 07:45:58PM +0800, Hao Jia wrote:
> > > From: Hao Jia <jiahao1@lixiang.com>
> > > 
> > > The zswap background writeback worker shrink_worker() uses a global
> > > cursor zswap_next_shrink, protected by zswap_shrink_lock, to round-robin
> > > across the online memcgs under root_mem_cgroup.
> > > 
> > > Proactive writeback also wants a similar per-memcg cursor that is
> > > scoped to the specified memcg, so that repeated invocations against
> > > the same memcg make forward progress across its descendant memcgs
> > > instead of restarting from the first child memcg each time.
> > 
> > Is this a problem in practice?
> > 
> > Is the concern the overhead of scanning memcgs repeatedly, or lack of
> > fairness? I wonder if we should just do writeback in batches from all
> > memcgs, similar to how reclaim does it, then evaluate at the end if we
> > need to start over?
> > 
> 
> Not using a per-cgroup cursor will cause issues for "repeated small-budget
> calls" cases. For example, repeatedly triggering a 2MB writeback might
> result in only writing back pages from the first few child memcgs every
> time. In the worst-case scenario (where the writeback amount is less than
> WB_BATCH), it might only ever write back from the first child memcg.

Right, so a fairness concern?

I wonder if we should just reclaim a batch from each memcg, then check
if we reached the goal, otherwise start over. If the batch size is small
enough that should work?

> 
> Similar to how memory reclaim uses mem_cgroup_iter() (via struct
> mem_cgroup_reclaim_iter) and the old shrink_worker() used zswap_next_shrink,
> we need a shared cursor here.

Right, I understand that in theory we need a cursor. I am just wondering
if the complexity is justified in practice. Reclaim is a much larger
beast than zswap writeback. I wonder if we can just get away with
scanning a batch from each child memcg -- for per-memcg reclaim, not
global.

We can always improve it later with a cursor if there's an actual need.

> 
> 
> > > 
> > > Naturally, group the cursor and its protecting spinlock into a
> > > zswap_wb_iter struct, and make it a member of struct mem_cgroup to
> > > realize per-memcg cursor management. Accordingly, shrink_worker() now
> > > uses the lock and cursor in root_mem_cgroup->zswap_wb_iter.
> > 
> > If we really need to have per-memcg cursors (I am not a big fan), I
> > think we can minimize the overhead by making the cursor updates use
> > atomic cmpxchg instead of having a per-memcg lock.
> > 
> 
> Because mem_cgroup_iter() always calls css_put(&prev->css), we cannot simply
> update zswap_wb_iter.pos via cmpxchg() after calling it. Doing so could lead
> to a double css_put() issue on prev->css.
> 
> Therefore, if we switch to the cmpxchg() approach, we wouldn't be able to
> reuse the existing mem_cgroup_iter() logic. We would have to write a new
> function similar to cgroup_iter(), and its implementation might end up
> looking a bit obscure/complex.

What if we do something like this (for the global cursor):

	do {
		memcg = xchg(zswap_next_shrink, NULL);
		memcg = mem_cgroup_iter(NULL, memcg, NULL);
		/* If the cursor was advanced from under us, try again */
		if (!try_cmpxchg(zswap_next_shrink, NULL, memcg))
			continue;
	} while (..);
			

There is a window where a racing shrinker will see the cursor as NULL
and start over, but that should be fine. We can generalize this for the
per-memcg cursor.

That being said..

> 
> Currently, this lock is only used in shrink_memcg(), proactive writeback,
> and mem_cgroup_css_offline(). Note that shrink_memcg() only acquires the
> lock of the root cgroup, and mem_cgroup_css_offline() is unlikely to be a
> hot path.

..this made me realize it's probably fine to just use a global lock for
now?

IIUC the only additional contention to the existing lock will be from
userspace proactive writeback, and that shouldn't be a big deal
especially with the critical section being short?

> 
> So, should we keep the spin_lock or go with the cmpxchg() approach?
> Yosry and Nhat, what are your thoughts on this?

I think we should experiment with the global lock first. See if you
observe any regressions with workloads that put a lot of pressure on the
lock (a lot of threads in reclaim doing writeback + a few userspace
threads doing proactive writeback). See if the userspace threads
actually cause a meaningful regression.

> 
> 
> 
> > > 
> > > Because the cursor is now per-memcg, the offline cleanup must visit
> > > every ancestor that could be holding a reference to the dying memcg.
> > > Factor out __zswap_memcg_offline_cleanup() and walk from dead_memcg up
> > > to the root.
> > 
> > Another reason why I don't like per-memcg cursors. There is too much
> > complexity and I wonder if it's warranted. If we stick with per-memcg
> > cursors please do the refactoring in separate patches to make the
> > patches easier to review.
> 
> 
> Sorry about that. I will try to keep each patch as simple as possible in the
> next version.

No worries, thanks!

> 
> 
> Thanks,
> Hao
> 
> 

