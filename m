Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3454CC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3504D6B0093; Fri, 31 Jul 2026 11:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3009C6B0095; Fri, 31 Jul 2026 11:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F01B6B0096; Fri, 31 Jul 2026 11:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E93606B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:04:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 856AFA1731
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:04:12 +0000 (UTC)
X-FDA: 85049392344.26.9E7572D
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3DD05140018
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:04:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DO4geTNe;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785510250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUEbNrW9/UnpiqJgVKJmhk4NpMeX0dug4W8nQe/yncQ=;
	b=Wtt/lNnQNdltsPE68awPb0QV9sCDsOBPCxOlA5DHirzryz+2ItHyybFYqWJ9ZQNS+MrXFp
	FtyoUyMpQ2rHqrCHCMO8WT6+V4J3htSEkeBC6RovqN/llYAC/bZ9ecTyi9adPTpftKhv6K
	kprOICyloAZ8xwp39A2HdkwGle+/AnE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DO4geTNe;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785510250;
	b=4L6TI5qxBK5R59XmeIZx+cR+QIqjcuuOWSTGRvadDiwu8th3KrlbQBT+5HQDwjQ+FrEqO4
	Y7URuF1y2xBNIuGEmhnQakr7GotX1YMZXZBkYag/fsvQ3OzL4Gf5ho80/gBNNHSVGCplj2
	AwqUaaGy8zFt3B8wFQscP7kwzFKxYrk=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e512a9a6bso59590185a.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785510249; x=1786115049; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FUEbNrW9/UnpiqJgVKJmhk4NpMeX0dug4W8nQe/yncQ=;
        b=DO4geTNeemDBFCD6lM3eosv7cHpXQdzyFu3ECPe1lsoaRAu1tmO6xxX+qo4y7Qy14M
         sM7Mgc7CUSa5hHAbozJRSn7NhQX1wbTyhQzJtm5X063d52yFdK8p1mi/kG5Ywv8U85MP
         D1oAJHYWQgX3kf7YHpntHgHGeH9RCObiCDnOgTyfDKV6s9M4BD97j8kNPFrTWvUWfkb3
         6tBvHQeW18pd62NPNfWDDTinnjz7p12W7PDhfLUFaIEIH6JpbyWuWVVlglNpeMXf9fvh
         N4MjWESjCeqBft49GNCDwWFm5vce3hLrRdVSLcPBSOo2ydM60O+0eVL2KNx5pb8AAG9r
         YcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785510249; x=1786115049;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FUEbNrW9/UnpiqJgVKJmhk4NpMeX0dug4W8nQe/yncQ=;
        b=RdM/I8+MOqlwyRrHgbg0Pa4VMvAPCgJiH+UqX5lUx1GVpQH9Wa4O4o0IM4AaFshxwK
         6zIbVXdir8pM2kSysS1ByjY2xvj8eLZ7Z5OFgCz5Fw8pRP8E0dvzMhmlpMojWqfVibXI
         QA87Z/2PwjHNVeWa5xF8Zri1pHPeJ9CXnsj0gaQIO5tKuXM/DPptx+RGvRRdJJmOYnj+
         jClzBPBr3Lz5LTrMJKSq2hrP2KZJxmKL2DdVOeiIsGGFSJscM6noMPsoP1OSjArzdyk6
         1jwyFTYTPfweTiQy2KHaiaHSEI3GlOGk+ScsvNIPDRpAU5OWnGURDsP7qUKt0CLoZI7q
         mIUA==
X-Forwarded-Encrypted: i=1; AHgh+Rpk9T+QBWN5ANjzWneurI+xOo4TyU3tCWLEKNNOV/0cjk7E1lIt/HzxFxSkcPcWRtwQpTUf7o59Jg==@kvack.org
X-Gm-Message-State: AOJu0YzTT2LTSWf2T+zSqbMaSUeJoY8NL6G6xFic0Sgj3554nY1VhSty
	H9sMUSab5vCP/om5S+WnaqH0SUz/dXI6vWHfaQKpOjfuz46b4fwNg+jN64ZecREWd/8=
X-Gm-Gg: AR+sD129LKGgFYXODTG7seDwoMMWO6ilhxFh6wsxNZ1p3XVcyvn5fhiBW4sLPnvEls5
	IPzkZ6KBbfLqoyTHxfKQjCenb9m3s/qjcn0YXccLDqSOzh+Th242NwQ/P+poP5J89IPIBVIQQiC
	8x2VSxUVSuG60j/cU5T7SeF8P6TNBnd4F8wwU/Lb4l7jUJyrmjqlDGzb01sCQgYX4XFfZyNlhWu
	dSuQtApkksa9pBxVFJJ9eQAT/9NT/ffP6RQJi0Sh75pRe4EQ5cs3gP0AqIET6fqeka3d40kpTvB
	+EJ3xFt+R9nHYF+R6UxdIlMCAB70ygqO/YT3/jQ1dRT9GYx6X0OsWPhyDIBwiCGc9lcMHLFhVZu
	2phXrxyGJgHRqG9sjJzh5YDeOUIZCI5XGShs0CauFwLpg9OfRpIo09AHwEIOtkvDF7zxR2nK8gN
	RfAd6Gco4jS5agS3+c4XefSdSG/aP3r9UGa9JpoEczFl16951hgdmgun/yPFE=
X-Received: by 2002:a05:620a:a414:10b0:934:9535:8d08 with SMTP id af79cd13be357-934a0ab83a5mr47682085a.43.1785510248860;
        Fri, 31 Jul 2026 08:04:08 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9349bc6cafasm74557585a.20.2026.07.31.08.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:04:07 -0700 (PDT)
Date: Fri, 31 Jul 2026 11:04:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, willy@infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
Message-ID: <amy5ZKC2Kc7RX94Q@cmpxchg.org>
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
 <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
 <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
X-Rspamd-Queue-Id: 3DD05140018
X-Rspam-User: 
X-Stat-Signature: qfadjsfd4j55kjfnx745qsiatdjsbx4u
X-Rspamd-Server: rspam04
X-HE-Tag: 1785510250-513680
X-HE-Meta: U2FsdGVkX1+hvSLL+ZkgUUkLPJMguuTnoypHVMlHMJLgAl8gmyXgbkX25TgA3I3eldTuDPgxOObJLrNh7Cvc6VWNFUgJrFkYfIbnYLYM2SzI98UP3n1xn3y6mgjqn+6CsnozSWrzBcrns7jUWRGNIrdZCbxsTEXDkAPRtH6GpQTZPm3od2w5kq34e9oq3tmG3c15kqht2vDk+AfBI6xW7k/2+qDL+rPjGXGeZrGNRIIr8XszBu1O2IxlSSsDuDOWvq9cQY6VWMkpnROTszOeu1ZMpRucOyKJB0YCASm+BJejjz2FZ7Ro3gW4AVbLF7/xshcgYt7W7Da91ZNeqj2v1s/1ZrPTWB/qRo7K+1su5G6XNjvejnC0YnBJSQB3JhurdEZnCN0rNhMmVPmCpV59DjbxGEplDQfdDyOal3XS+qa8m5QHJ8KX5Rkv/6fqRRHQ1+f5WtoPo1qzkryo77Ir+beRAQ3WAoEQ6L4HiYupyTMoc1uW6tHUWxd8cGQ322gbh8hZaYT08QJwL/CY1hQK5qMiX2GuZOujr6aHRvj+2KTy2KOXN04nxnU3nrYMmiYpv+YQJJtLkThEFJX0krJ9lhASD3Xf3Qro7dqJPQSSeNNdJsiBbTbveFX6AkmPfwhC+l5uuGLR2unuPKgCWEOzKJAxeRj6jtoZv0yC9iuUQbn5NbgFGSrcCGpxvZW4pev3H5wTH/2d/xpVzsIFp1xSMSeFTGq24TJVMwqgzm9mtnnYXLNBziWbEW8aJ5/e0R+aonAUB0w+ShHdZdXi2IopRdKEWP/5qZE1I014dv435Ftr88cUV77vLd7QvAHVI4Fv65pkC767ZZnok6NuNp0/+CMcXvo/l1/WAtVyviCZlssbgsY4SMDRbxT9VwqwOSNxODsBjEVF/hjonXVuj/f7ch97JdgLI+9bw8dmtYfSTb6Xug7agkTArCfYLJt2u/M7nmtlr7j5AD06r6yCm36
 OfZbnfOQ
 eNg5ELI1aLXnTmdCYWquESu9i2tjgJ5u5zEBQoW6weprolsoxcmdnJOpqk07LwJFV+CzeVbTlxYAEchUWt3VvBMv0lrWqE4Lm8eD0KY8Wp2F4TSqL/MKeQmlKtKiivgsIjAdCWYOBXzOUwD06JIcWpGhrtlZZ46cM1+KbKF3FpNQLqPYHeub47/gYPUWVaantfU2BZQuc6+5niFQdrXPRHbwjKDk2aSrjt7ASYeZXu02p+4ELnUFUs28zuUHKGkfVFTlrovZ0ntxsqFQxf02UJcxmcFZxePjRQrSA581GjF4PDpyZjRR18XlSkG+8HaqasZg9kUWbdNirHy6JEeqjmSSfMfWU2Q73fvhw+JB2Pm4SHl9KDsT6fzYcplmsnSPIcjZ3Wf+uoAaBDfSXARaykfgPMGpDimte1KVcrwp/AjIUhScv4Gk5C5TuSWiqEI94IvVV7OMS2k6CBcxJJw0Rde9wgn1ucwEpB3RKTfdjDxruRtxAi+0NxNoKDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 05:31:20AM +0800, Barry Song wrote:
> On Thu, Jul 30, 2026 at 11:38 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Thu, Jul 30, 2026 at 03:46:25PM +0200, David Hildenbrand (Arm) wrote:
> > > On 7/29/26 17:04, Johannes Weiner wrote:
> > > > (2) With a mix of basepages and THPs, there could indeed be a lot of
> > > >     basepages ahead of underused THPs. That means swapping before
> > > >     getting to space that is much cheaper to reclaim.
> > > >
> > > >     The current setup isn't perfect in that regard, as the shrinker
> > > >     runs simultaneously as the LRU. But it's making guaranteed forward
> > > >     progress through the THPs, even as the first LRU pages are scanned.
> > >
> > > The shrinker would obviously remain and scan the list for candidates.
> >
> > That's slightly different from what I had pictured. But I don't think
> > it changes my arguments much.
> >
> > > We might want to remember how man / if any such entries we have on
> > > the list.
> >
> > Right. The question is how does the shrinker actually find them:
> >
> > > > (3) The anon LRU has folio lifetime, but the splitqueue is one-shot:
> > > >     we scan each THP once, and then it's either split and dropped, or
> > > >     found full and dropped. That THP never needs to be revisited. The
> > > >     queue actually empties as the workload establishes itself.
> > > >
> > > >     The anon LRU ~ splitqueue argument is only true around startup.
> > > >
> > > >     If we used the anon LRU, we'd need per-page state to avoid repeat
> > > >     underused checks. And we need external state to not scan the anon
> > > >     LRU at all if there are no new THPs (and no swap). And if that's
> > > >     just a counter for "new, not yet scanned THPs", a single fault
> > > >     will cause you to walk the entire anon LRU before you get to it.
> > >
> > > Remembering "not yet scanned" through a pageflag (for large folios) is indeed
> > > very easy.
> > >
> > > I don't quite understand the "a single fault", can you elaborate?
> >
> > Let's say you have a 1TB host with 800G anon populated.
> >
> > The oldest folios on the list might be THP. The newest ones might
> > be. You could have a mix of basepages and THPs. The ordering
> > constantly changes as the folios are aged, rotated, reclaimed.
> >
> > How can it find a handful of unscanned THPs in an ocean of folios?
> > Even if you mark the folio state, that's hundreds of millions of
> > entries whose state you have to check in the worst case?
> >
> > The lru lock is one of the most congested MM locks on large
> > machines. *Maybe* you can do it locklessly.
> >
> > Maybe you can add thresholds where you don't scan if there aren't
> > "that many" new THPs just yet. That means magic numbers and reduced
> > predictability.
> >
> > Maybe you can be clever and scan from the head of the inactive list
> > where (most) new folios start. You still need to skip over basepages
> > that faulted after. Skip over the referenced pages that have been
> > rotated around concurrently. That could mitigate some common cases,
> > but not the worst case.
> >
> > The search pool stays enormous for the entire runtime of the
> > workload. It never gets better, never converges. It continues to
> > include every other irrelevant anon page, and every THP that you've
> > previously scanned already. A single new THP fault and the search
> > problem starts over.
> >
> > I just don't see how that's algorithmically sound.
> >
> > > > So I think reusing the anon LRU is flawed. It's fundamentally
> > > > different needles in fundamentally different haystacks.
> > > >
> > > > If we can agree on that, then the lock contention problem has a
> > > > different scope as well: it's a simple optimization issue, not a
> > > > fundamental data structure arrangement issue.
> > >
> > > I don't agree yet :) But maybe I am missing something important.
> > >
> > > Note that the "simple optimization issue" is not so simple once you
> > > realize what kind of a pain the batched LRU already creates us when it
> > > comes to predicting the number of expected folio references.
> > >
> > > It's a pain I don't want to extend to other areas.
> >
> > Since we already need to do it for the LRU pages anyway, isn't it a "+
> > in_deferred_cache(folio) extension to existing refcount checks?
> >
> > I don't want to sound dismissive at all. It's a problem. However,
> >
> > - it seems way more tractable than the shared list,
> > - nobody has produced hard data to show that either is justified.
> >
> > > > If I understand you correctly, the concern is that people will enable
> > > > all manner of mTHP orders, and 99% of the anon faults, including all
> > > > the order-3, order-4 pagelets, will go through the list_lru lock on
> > > > fault, with no batching.
> > >
> > > Yes. See Barry's LRU cache change I linked as reply to Usama who is looking for
> > > example at a system that mostly just uses order-2 anon folios.
> >
> > I took a look, but I just see a microbenchmark. That doesn't seem
> > enough to make a proper cost-benefit analysis on the complexity that's
> > being proposed - whether that's a shared list design, or a splitqueue
> > cache.
> 
> Hi Johannes,
> 
> Sorry for being lazy and not including the necessary background in the
> RFC cover letter.
> 
> The background is that our goal is to enable only order-2 (16 KiB)
> mTHPs on Android. Based on our long-term experience with large folios
> on Android-like systems, we believe this offers the best tradeoff
> between the benefits of mTHPs and their costs, including increased
> memory footprint, fragmentation, compaction overhead, and internal
> memory waste.

Thanks for laying this out!

Again, IMO the microbenchmark was plenty justification for using the
LRU cache, no worries. That's a straight-forward plumbing change. I
was just saying we should probably know more before pursuing a much
more complex direction for the THP shrinker. So thank you!

> Specifically:
> 
> 1. We obtain most of the performance benefits of mTHPs, including, for
> example, a 4x reduction in page faults, faster memory reclamation at a
> larger granularity, and making it easier to allocate higher-order
> dma-bufs. While larger mTHPs can further reduce page faults, they also
> increase memory footprint, which is a significant concern on
> memory-constrained Android devices.
> 
> 2. We minimize the internal memory waste associated with mTHPs.

This is kind of tangential, but I'm curious if you would have
experimented with larger folios AND the THP shrinker?

In Meta, 2M thp=always without the shrinker would also not have been
tolerable. It OOMed immediately on a large number of services. The
shrinker *is* what allowed us to use such large folios to begin with,
without the internal memory waste problem.

> 3. We can use a lightweight compaction strategy that only needs to
> satisfy order-2 allocations, keeping the compaction overhead low.
> 
> 4. Combined with large-block compression and decompression, 16 KiB
> pages provide more than 80% of the CPU savings and compression-ratio
> improvements achievable with larger folios[1].

That's very interesting, thanks for filling in the details. How this
jives with compaction and compression units is clever.

> For such a system, I don't think adding these folios to the deferred
> list provides much benefit. Since the mTHPs are relatively small, there
> are unlikely to be many zero subpages. Even if there are, they are
> likely to be short-lived and will quickly become non-zero again as the
> workload continues.

That's good to know as well.

> But I can see the benefit in Usama's case with 2 MB mTHPs. For larger
> folios, adding them to the deferred list could be helpful.
> 
> [1] https://lore.kernel.org/linux-mm/20241121222521.83458-1-21cnbao@gmail.com/

Here is an idea: the THP shrinker will not consider anything unused
that has <= max_ptes_none zero pages. See thp_underused(). Joanne was
proposing to scale this knob down relative to the folio size for mTHP
shrinking. What if instead we kept the meaning absolute?

The knob is an expression of how much waste the user is willing to
tolerate per folio. If the folio order in question couldn't possibly
have that much waste in the first place, we don't have to queue it?

Something like this:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..1670e9869bd3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4364,6 +4364,9 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (!partially_mapped && !split_underused_thp)
 		return;
 
+	if (!partially_mapped && folio_nr_pages(folio) <= khugepaged_max_ptes_none)
+		return;
+
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
 	 * queue. Nowadays that is fully prevented by __memcg1_swapout();

The setting defaults to the PMD-1, so out of the box we wouldn't queue
any new orders. It would allow that 2MB on 64k ARM usecase, without
jeopardizing smaller mTHP usecases like Barry's.

Thoughts?

