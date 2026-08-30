Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF0EC61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 14:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C9CB6B0088; Sun, 30 Aug 2026 10:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97AD76B008A; Sun, 30 Aug 2026 10:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86AEF6B008C; Sun, 30 Aug 2026 10:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55DB66B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:59:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B48301A032B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:59:31 +0000 (UTC)
X-FDA: 85158244542.09.D0987C8
Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D624180002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:59:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sUmia9Iu;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788101970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbtuljDZctEdZQ1tRBsBVKjABx/H8Vjjnb82/fQNtEU=;
	b=LAUk1ww/oPhT67r28t0KCtURrRSJu8Smz0M1UKo8RsWCCq6/KMqvh/xxGhQn/mKGHcJeny
	9lrtnL9zL5Sn/t3t7IvMONVYWa6JN2BtWhrEFVW/JUlTaP3J1pi1rrt0zxjOYfxUbhBQj/
	0nIPgO3N+AF/MZ44FaPB+E51Cs/wjcU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788101970;
	b=aRRoLU1njVlTT6zfmKCg+cb5grxRvhkxsGFAbCgBThYaCSnf+swqV31C0ulmuGlROvnzWw
	h5kJsZFkjY+gMdvxwFToZcOAFZR8PZolGH62bf7PaPChLXUAfeixGT+vWgmAYMTg1sH591
	y2HhDibW9jdtSpaI1JlHNnoNTwcYlko=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sUmia9Iu;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rLY5GKWhKys/u3ldPHSR1SF53EIXXyEYyCrHcX2TQiA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788101967; v=1; x=1788706767;
 b=sUmia9Iu4pFWxfswH31SEz/JfpAcztqfKcgtOVAIlp+z9/icgXskxfBQwoqM6LvcEK9wZwbQ
 ift1RZWg8PY/VXOY2I0rVuGl+TxD7UIE3UC7yiyixw68ec/kELsJUHKjLvdYXf3zahIho3TfNv/
 7SyVhaJzzEfSigkAvoVbmexs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c08b8e8a6516a298;
	Sun, 30 Aug 2026 14:59:17 +0000
X-Mizu-Trace-ID: c08b8e8a6516a298
X-Migadu-Flow: FLOW_OUT
Date: Sun, 30 Aug 2026 22:59:10 +0800
From: Hao Li <hao.li@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm/slub: reduce list_lock contention with slab
 parking
Message-ID: <apRBmrMB6bJ6tTqY@fedora>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <apBioBxd4VkmaGhA@pedro-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apBioBxd4VkmaGhA@pedro-suse>
X-Stat-Signature: 446sirnhoidjzix1ga76pybm45i7fez1
X-Rspamd-Queue-Id: 8D624180002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788101969-808896
X-HE-Meta: U2FsdGVkX19Dpkl662LmNduuVpUbYw57dWyCzIrzOJ41SJtu58ddwp9DXIO8uRkFQ80MPfRUkFU67dzz9s2jq9WWjhfHtQ/h+DGtIHtY+3cJjmtRQnu04IGB6bCbOHrcOvsbAAUr+j1Ky98pyhJSPLxnbv94bQU22shr1s3/bwsvFcUEOvtTh9GVnkJPqOcX3cw9+5dQJksjWdlz1Al4FjlrAB6xrxwWmudmwvoV3RNOmlU+Aa+3oXgWfuR8wGA/9LB1tKN/UFDRFCA6KR8DV7Bkd5ouBWrZMkTjHXU7BXE6spJkHQz2ChgzjHlEOQtrOfnzSjDu+b2y2kWzPTrwxeIT/tsUyc3yn51T2CBkknTTM1yqGQ6HBfeNL0DnvtC3WTGQR5CY7B7IZGcaLGvDbftYmjjpWIhPUdWFA10ZpgG4Zbqxah+0YZ9QuyJvDnN/lfxnv6JOL3td9nIKtJYjDsfIs8Te8K3eBQHru/0HbK47zMtLWUhot8pBrrNxEAADE/S5mvF3NzHyHQ1hBcYhyo56ezzNqcNPDWRiFi+nr2cCzbo9QFTdC6TwWPo0wOoB/04V4p/MRkHdHinek3J/vmjmAOhg1LQmzoMnz4y6drHYJqpWJwFMTZiAdoL7v5DWnJAMXS5BS/F7a31OLGS4L8HFD9kxzWxf1nz90e6Vv18FNddsJd/AMoCVYoqchjpOsjNVkIr7KP+yUjJE2+JXBG/kVHwB1nALergnL4+iiWetg9b4k4UvSqQOPL9hHYgWwGZlduGoDT9/F0cKsQnqSwspR98q12nq+JNadxIAwuVvQH8e0sy9sfrnghVtqa7k2WeeG8lPI6nDhv/JAo4sIuArGXpjaBRfJLyYQnk0QroJnOdSQ456o8LMaDPv3MDFauhJGBcwczoSzJPNz1Zt43mNu9bRuadgh8fw1b04FyReHcv01wOdMxVDbNqi8zm8nE2kAHRTc5UbTL+fwIJ
 i6ybSzIP
 H6ydywDGYPsoti4WzoLDJDpbzvYO/0KhuT5r0Web4kUWxxrPmVY73dvLU4iukkNbEoFS574xhmZ3EwR+NCXsb42eDEsg9SoXZscAf8ZACZQu3J5ncTdmET9WGiYdvRw/hFG5HdpYQLmvAWkGySdFpNEzvy67pcYR0Y2aSUYYfly+txQ2G1Cbgd5mQ1XMhD/yoteKOXjBx1HtQC9un+uvCtO3Jq0gyxHeSJ/eHu7Un0C8zOMBlh/R8++d88cxvJnG5CKe6jr+sXrKaE5CQfp057n1fOW9iIKofNrwOllYeSlAdjxC+cM/IvzmtK/GQLtsHaiyA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:24:32PM +0100, Pedro Falcato wrote:
> On Mon, Aug 24, 2026 at 08:19:50PM +0800, Hao Li wrote:
> > This patch series might sound a bit wild, but the initial numbers don't
> > look too bad so far. I would really appreciate any feedback and
> > discussion :)
> 
> The numbers look great, I have to say ;)

Thanks and sorry for the delayed reply!

> 
> > 
> > On a will-it-scale mmap1 run with 192 processes, list_lock is the top
> > contention point: __slab_free() and __refill_objects_node() together
> > spend 44% of cycles in native_queued_spin_lock_slowpath. The free
> > slowpath takes the lock mainly to add slabs that became non-full to the
> > partial list.
> 
> Doesn't this mean you're hitting the slow path way too many times? I think
> that's the actual issue, no?

Partly, let me separate the two sides.

> 
> > 
> > By adding extra instrumentation to __slab_free(), I collect the following
> > data for the maple_node cache (in counts):
> > 
> >   partial->partial    843017414
> >   full->partial       550719384
> >   partial->empty      17459564
> >   full->empty         2
> > 
> > We can see that full -> partial transitions account for a significant
> > proportion, and optimizing them can help reduce lock contention to some
> > extent.
> > 
> > This series introduces the parking mechanism to address this issue.
> > When the trylock fails during a full -> partial/empty transition,
> > __slab_free() parks the slab on a per-node llist instead of waiting. The
> > paths that consume the partial list (sheaf refill, alloc slowpath,
> > shrink, cache destruction) unpark the slabs after taking the lock, and a
> > delayed work covers the case where none of them runs.
> > 
> > Patch 1 cleans up the case handling in __slab_free(), no functional
> > change. Patch 2 introduces the parking mechanism.
> 
> This looks like fundamentally the wrong fix, when we want to find out why
> 1) you're hitting the alloc slowpath so hard

Regarding the alloc side, it mostly goes through sheaf refilling, which isn't
quite the actual slowpath in the usual sense. The full slowpath would be
allocating a single object directly from the partial list, and from what we've
observed in testing, that path is rarely ever hit.

> 2) you're hitting the free slowpath so hard

Yes, the free side does indeed take the slowpath, which is precisely the
problem this series aims to address.

> 
> and ideally find some way to tune it properly. Maybe if sheaf size is scaled
> up/down in some way (by default at least), according to amount of RAM or amount of
> CPUs.

I think the idea makes sense, though it might only offer partial relief. Since
much of the overhead seems to come from free-side lock contention, a lockless
approach could be a more fundamental fix.

Thanks for the discussion!

-- 
Thanks,
Hao

