Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41E4C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 01:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1676B0088; Tue, 28 Jul 2026 21:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790F86B008A; Tue, 28 Jul 2026 21:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6B76B008C; Tue, 28 Jul 2026 21:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF326B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:22:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E2D81605B7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:22:11 +0000 (UTC)
X-FDA: 85040063262.29.089E57F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C69280008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:22:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilMzXKMF;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785288129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0t+IAasOBTAZXdXVEKb9SrgtdAFOWGHpWG5YeS1gqYA=;
	b=pbT+cTFXIZCfOGJpBMRuezZVZjzemv0j/2RgUiEDpURC9yW+szyW6NfENEyD8BZ/AcYMSZ
	d5Mxx22CXay9o0si+F8qtnh9BP0k+44ddftC7//N6cvo/CA0tinot4C4avdXPHG6FuXS4R
	OnVX7CR7B3fy23/VZ8aveVBolNDQEQI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilMzXKMF;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785288129;
	b=2fJ52TFeTv3/XY7OB0sauVlZyUnvmN9+7jypcIifIeREPCZU3ASsX5UMMU1FYBHPTglKwG
	I2B9MTZ/OZTqtPYiD06LL2VUY1ImZrhCuOKuzdUUbc5yelwohnjNoSPlX25Tt2nrrfd8lc
	m85Zt2LvJjC2C8NCSw4P6hrGYKOHk1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 578DD43EB8;
	Wed, 29 Jul 2026 01:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CFA1F00A3D;
	Wed, 29 Jul 2026 01:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785288128;
	bh=0t+IAasOBTAZXdXVEKb9SrgtdAFOWGHpWG5YeS1gqYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilMzXKMFyYAdxLu8llGrYeS8DZhGN0EyufAWHOK8i2Xq3AKDxcZk8W3osWsNYwHoN
	 k/SYFoyuT0z8x+dZ/nCJ01WD/90pwIxoAbZHpnFsrQrIqQWf8lpUENXC5vtfYoCOaB
	 6IImUXw2GWfLEpMU0jXHnGrx9MzSTZZp61qPjf8Xw5VebWu2LuaxRO88kosPZV7zXK
	 S9O80Ao9P4zMGDpmUJp9SJbMLhfOpO6kgl3Qz/WbDP2knVHqZDq4cXC9QZHzTtz94C
	 aXY0LY9zS+bhVh8QvLmwwjPMhbGVEL9YVrLgrSObnrMMsh2eqYtL6qD9MRsW0mK3dV
	 0g0kqrz5Vg7HQ==
From: SJ Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: cover discrete System RAM areas with per-range regions
Date: Tue, 28 Jul 2026 18:21:59 -0700
Message-ID: <20260729012200.98442-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1c815b59-915a-414c-9029-eaac11dcf804@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C69280008
X-Rspam-User: 
X-Stat-Signature: hzin3wsm1g4a8myfpijicy1hxrh3ao84
X-Rspamd-Server: rspam04
X-HE-Tag: 1785288129-192597
X-HE-Meta: U2FsdGVkX1+nUsUsfbyenPPHXdckv+0h2J2RgQhJHQX1BoXcq+VaER0gm5Y6uQT4fHkpa1mBa3OgVICIuwZ5jDZ+Cu/Y+vSDZsWdEY5xlkQQdBibo37S+AxLu/tMmx77aN8Bt7dJ3m1ZawlBxae2kdGLBabzqBrpHdCnw2t7+ge/2AQidcJDg6ZH9pHQzIX8Ydj4KCGZsUZLOvED8b/ZCt7aho2P6GMJBkjoLq0Ot4F6cZEwmrtyUmoVXtyut93on+hgOPkkzrWhFW51XpOQaSE+G9P3Ijtw/h0eTPaSgpaloY2rHvoUfPogmGR66pl1Og6eTiDd7o9PcXZdVa/IIRHjTdHJNZbkmuG3WvN67925AP4PR6Ul9fYL1t0crJhcQyFvdYEw2SGcWQ/cyIIu+VdaL+i1kz9+UrMKDNuWmqYwunx2J0bEydX8BDmP3+mdwwI+fGpZuZQjguRxApKlG1eb4T86aKJCd4cvns4QUOjanfl8UakHNs03Im6fbA2SIop8x21sHcFm5cvTzqsFfCsyVdpQNHvSqwUx+81QoyJV5ig5nEBH+ZkphSQxRW2WI4AmSThZn7CAoMO0G8DrTA2qHOcvIgjslSsC+l/kM2SBlDLRQijmKxSpFfIj6sFXuOOycyl/+StWP0quF4Rt8tz/mIC7J2i0JFmG6bf5ONBU8s2UlnmBor/FcZ07MWlTrkNI9y9wkUaaOHfuJK94/q63VzRW43mlvUwkBJXIfFwUqniDIzzNhJ+epxrUpu3RLzWlwoEZaNGTdj/PZ5vwy1e4plbvO9Z3dBGuOKIuTg+0v5fIUQ6tyT/FS4fVh287jNVTaLJsfBa8VUWaSVR48WQ5s1gEw7a8iMEqEonVzub4HvwXwJwR088aA567sPXyiBiffu83Pjm2iiOhUbYzMISTM0gLBKw0+uJzX7b3C1AW9K/aedLbQiQQVpDb1EGWRqf/KZLsX0/H2v8xrDI
 w1ZmQqya
 D0LkJrtwFQWQtNJ9Dgipc+D1rBemp2c+jw5KMlbkcN50vU72jsFg7djm2hn/aer9Q+jkpHkM6cJmQ0HXSLmboEfgqolGMV9Rt0yZ4k6qkEiD0y3mNwiarYKLqzXbdzP0qdfc07EyFPaOIKMoZqEes0B347M/5Yafj+iyzYtdB7GRWAWiq9p4XTSvKYMmeTAOz7M8TWuzMpHOhX9l2xp2tG2pSY2Jhixzl7KJ2v0hPasdECeS+skKMI7QWrLEeIFGHX4Je+j5czC0ZVF4pnxdodbKVBKVxP4K3fDipeypXc5DikNieGrc0KUCNrruscRYG3JNOjIaKkdKbPd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 23:17:01 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> 
> On 7/28/26 10:30 PM, SJ Park wrote:
> > On Tue, 28 Jul 2026 18:06:48 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >
> >> On 7/27/26 10:26 PM, SJ Park wrote:
> >>> Hello Jiayuan,
> >>>
> >>> On Mon, 27 Jul 2026 17:54:22 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >>>
> >>>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
[...]
> > Actually I was also thinking about this problem for in the past.  One of my
> > idea at that time was, handle only a few largest holes that practically being
> > problems.  That is, while reading the system ram layout, find the holes, sort
> > those by size, and do make holes in DAMON regions layout for the biggest N
> > (say, 2) holes.  This may handle most cases including your 5 TiB hole.
> > Actually vaddr is doing this, so we may be able to reuse some of the code.
> >
> > If it makes sense to you, I will try to implement this.
> 
> One worry with a fixed N is that it's a magic number. If a machine has more
> than N big holes (more sockets / NUMA nodes, or several CXL devices), the
> extra ones are silently not excluded and get walked again.
> 
> And making N configurable just moves the per-machine tuning back to the
> user, which is exactly what I'm trying to avoid.
> 
> vaddr over-includes the gaps into its regions too, but it can skip them
> cheaply: it walks the VMA tree (find_vma / maple tree), it's cheap.
> paddr has no such structure, so an included hole is walked in full.
> 
> That's why a fixed N is safe for vaddr but risky for paddr.

I agree it has the problem of magic number.  That said, I expect common systems
wouldn't have that many problematic large holes.  If it is not clearly wrong,
I'd consider starting with magic number 2.  I feel magic number 2 is appealing
probably because we could reuse vaddr's code in the case.  But it would already
be much better than nothing in the problematic setups.  At least it will cover
your 5 TiB hole.

Depending on what we learn from the fields, we could change the magic number or
add more optimizations in future.  Setting N as a fraction of max_nr_regions
and/or handling holes based on their size (relative to real System RAMs?) are a
few ideas off the top of my head.

> 
> 
> >>> user-visible parameters and internal state is also a concern.
> >>
> >> I think monitor_region_start/end is meant to expose the overall range, and
> >> skipping the holes inside it is an implementation detail. Even if we didn't
> >> skip them, the adaptive region count is never 1 anyway — DAMON already
> >> splits [first,last] into many regions. The holes just add a few more, so
> >> the param never matched the internal state exactly to begin with.
> > It is arguable, but I believe this also makes sense in my opinion.
> >
> >>
> >>> A quick workaround would be adjusting the memory layout in BIOS, using DAMON
> >>> sysfs interface instead, or setting the monitor_region_{start,end} to cover
> >>> only the single area.  Have you considered such workarounds?
> >>>
> >>> Let's complete this high level discussion first.
> >>
> >> Right, this is doable today — the DAMON sysfs interface can set multiple
> >>
> >> regions manually. This patch is only about convenience.
> > Are you actually running DAMON_LRU_SORT or DAMON_RECLAIM in a production system
> > having 5 TiB hole?  Or, planning to do?  If the above idea makes sense to you,
> > I could prioritize implementation of it depending on this.
> 
> 
> I'm not actually running DAMON_LRU_SORT or DAMON_RECLAIM on such a machine.

Thank you for clarifying!  Let's keep this brainstorm level discussion, then.

> I ran into this while working on per-cgroup hot/cold page tracking, where I
> was comparing performance and accuracy across setups — that's where these
> numbers came from.

Sounds interesting.  Btw, there are multiple ways to do per-cgroup monitoring.
Using DAMOS_STAT with memcg DAMOS filter is one of the ways.  Data
access-as-a-data-attribute patch series [1] will allow doing that in a much
more lightweight and flexible way.

> 
> 
> >
> > Thanks,
> > SJ
> >
> > [...]
> 
> 
> 
> And to be clear, I'm not trying to land a patch here — I just noticed this
> as a possible optimization. If you have a better idea, I'm happy to go with
> it :).

No worry!  FYI, using subject tag 'RFC' could be a good way to make the
intention more explicit, if you want.

[1] https://lore.kernel.org/20260728041242.187380-1-sj@kernel.org


Thanks,
SJ

