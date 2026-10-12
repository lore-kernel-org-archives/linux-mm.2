Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E890CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 21:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16466B0088; Mon, 12 Oct 2026 17:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79306B008A; Mon, 12 Oct 2026 17:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41176B008C; Mon, 12 Oct 2026 17:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CCBB6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:19:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FD8C1A08FE
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 21:19:09 +0000 (UTC)
X-FDA: 85315239618.22.721AB4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 87D7FC0006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 21:19:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MPxmARo4;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791839947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3q83OZtY/52gnWp88T+wRIofbrnrdESy35LgvCqOC90=;
	b=QLaXTJQmTvRAfRgzkfL/4fkh0tUR4AvtrGzR4SsmmJqQ+6H/bls9x8Fy/zkzTEOD/tjQDx
	ZMI7juQ50FLw6PSIFpKQQLs1hhcno3utv6Rzi3smfB83WdNd2DK81MQkhRSzx0kyGYMGfE
	/lk0yfK2iYGRPr8BofRQmwQU1ClNLHU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MPxmARo4;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791839947;
	b=Wi4jnMfivdVDPrPvP3o64LWsFml4//a8aA9WOjUUG0MiODn6EiqcxPI0n6iGiwQ5SLfZV2
	ZvFR8HxCcYAyOCfx2z2I4UlnOY0P7BNL5VLN9gevHPAKelSz9GTlH7fhq2EmTb3xkMh+Ue
	GaKRfGfiGmnhFwuSrspvsk89Q7gwWto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C1E841A84;
	Mon, 12 Oct 2026 21:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1665C1F0089B;
	Mon, 12 Oct 2026 21:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791839946;
	bh=3q83OZtY/52gnWp88T+wRIofbrnrdESy35LgvCqOC90=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MPxmARo4aZE87AaSt/dDZn/5p++MDnAWqMEz0Okv95A7qBy8D0bloXwf60wv0eUPP
	 wF8FeH1ChRNQOg4r2/XOkl4NeLDU59X2sjraFX5q6vvRvjJVa9WsIh46v2cY/op80q
	 HHF5hzOfJh7o60OMdA0Q2+hXM9e4fyfpIzmbew9mE1mb71h0qOoh2sjMMZX3k3PrEY
	 +lVq1VvBT/+2rCLxIfACzoBUu/cSLrfL+pRzwCTlM9GTRJGrgh2lvp4mghRT6yJlc4
	 ZyIzTPGXZ6mZ1jWXeLLdGZ6mx2YF7A4OsfBuotIijPoF5mxI13DCojJyLcALQKlDMO
	 4mhf0zlx88N5g==
Message-ID: <01c89e02-28e0-4424-b32b-50363e4d2b95@kernel.org>
Date: Mon, 12 Oct 2026 23:19:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Content-Language: en-US
To: Kees Cook <kees@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, Pedro Falcato
 <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org> <asjhg2e4-WSeKuXd@thinkpad>
 <ask5kpMS4mpI8Api@thinkpad> <202610092014.AAB20B81@keescook>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <202610092014.AAB20B81@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 87D7FC0006
X-Stat-Signature: oq58qgjq5uqstqr613i1b5xsbuo7x71s
X-HE-Tag: 1791839947-779826
X-HE-Meta: U2FsdGVkX1/Yz12yJH2QXV2/fF/jAcu0jhuC8tpYSY8z5lQDRRxu/OspOn+AbERA4yCr4j4kh/MCdWu5++ylioWjSfrVUK5Zzftg1+NC01nT4lkxriGPw5S5uMon7MTq0lBl7Ks0/tmKJ2DWSHk+FDC2nerHunmCZgt7GFad1wNgok98jNqUGLVaRlN1YWvQ2FlekMS9E2iWki5yyoG9hnpskKc1Ee6Npt6aOhDnAeNxoT5osMZ2QkSUWXA1YcKs306m+yYO+5mKif0snc1rIsX/v066XE30byp3MCOWAme7NERRNcuz2bq+ad9Ij/ULsIjR4wxLwNjpyq1Y8+mhXKb6M++MwLxgDXwrHS6HVcLpZf+SAECM7uchCL1/i8nQp45oyMuv4wf99SudWn4PNS+mNCqI//LoUfZmS3uwGv+gCxlJLFA17gjAxtgpxcfsVKWCamULimG3aANPHDgPjh7/tR1i3DyYzsx+tcsgEDvHkGz+c+qYKnJrsO/xJFgZ5SE7hfx/4dFF5z9JaaMcuBOkrZQXt9xxhy6EiIgA51I+mXoeXojOW30m9O1KLKMmnmEz4okbHFnvjRtdAqg5b6BARzsFxrowDIUEtunEcq/n7xlWnSQTlE5jPrBAl+hybi7c0/2bt5/uyhppkbLR//by1SSUxRXJeoD2DRUAhFvWxWFyd9Ko2VcdeINr8Fg7+kf/6DGDQjhCT+shYoErDl5TcWRom9U6BfBuVm9L2oJfDQiSM4t1pPdhnbJyagdC0WB6XrQ3+jUR1p7WIF36YH/VmWUx1poU8dCONVQ6skMucwl8APD/YdffmAsdK7tf0ZoCSb8EpE55JPqDzXQDdHVpgb58mpM2FBe5pgKnILnApbsjnb7jCktqCmV02sg3Yw3hTnJLZJqmgx8Q3Xw6SGV+Rkv3rXX00qaEGs/6wObPABRC5WOcm1PU6saNqJI0VMUxlUFt8zb7AnCELaX
 6SYLThEH
 tX5dQSx1f1UH6BG5OLOlrYwIs+9bI4ENA9sMQGhiwTTWnR4A4GOwqVHR0V/JfAarV0U4HyMLQYw8+mCkSNuKCavgtmgFOeXxBgOEupFT0U5jvD/1xDy3K1SHlQfVoKbHZzF2Uc7g/H815xABroyRh6w4rME/Y3IcQUqTOEg8A4EDiizw3qm4YhvAWHQnJgeVYBHyYptPwtWvePdvuRPcxrh0DEgBxmKLzCsp08U0v1q8liU0j1Z85lq+vzn0nfy075ulIOEWDlj4uHYNfXm2KgxOpHXbU7aBjVCgNjBCpP8fN/OKcvPNzSHDdcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 05:18, Kees Cook wrote:
> On Fri, Oct 09, 2026 at 09:39:48PM +0200, Harry Yoo wrote:
>> On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
>> > And now I see the initial kmem_buckets design did not sufficiently
>> > tackle the question "How this should work when kmem_buckets falls back
>> > to kmalloc?"
>> > 
>> > I suppose the kmem_buckets' abstraction should not be too tightly
>> > coupled with kmalloc caches. Creating a kmem_buckets should be
>> > conceptually equivalent to creating a set of caches with speicifc
>> > slab flags, size, align, useroffset/size. (for variable size allocation).
>> 
>> Just to clarify... I have a few concerns on this area.
>> 
>> 1. Complexity.
>> 
>> It's very counter-intuitive to understand how it works when
>> SLAB_BUCKETS is not compiled. My brain cannot easily process two
>> different implementations w/ and w/o SLAB_BUCKETS.
>> 
>> A "compatibility layer" allows us to assume certain expectations
>> and ignore all implementation details when SLAB_BUCKETS is not compiled.
> 
> I'd rather make kmem_buckets not have a SLAB_BUCKETS option. :)

The tradeoff hardening vs memory footprint exists however, so I don't think
we can simply do that.

>> 2. Making kmem_buckets tightly coupled with kmalloc's implementation
>>    details is not reasonable.
>> 
>> Let's say, at some point we make SLAB_BUCKETS always enabled and drop
>> the config option. Then all kmem_buckets users will now have certain
>> assumptions inherted from kmalloc (e.g. alignment), which is not
>> reasonable.
> 
> Until it's always enabled, I don't see a reasonable way to separate
> those assumptions.

Agree. I don't think the assumptions are so problematic.

>> 3. __GFP_ACCOUNT and __GFP_DMA should be applied to all allocations
>> in the slab cache. For kmalloc, these flags are only used to select
>> the kmalloc cache (which has equivalent SLAB_* flags for __GFP_ACCOUNT
>> or __GFP_DMA) to serve the allocation.
>> 
>> Specifying it on individual allocations (rather than as SLAB_ flags)
>> makes it easy to break the assumption.
> 
> As in, you don't want a "pass-through" mode for __GFP_DMA?
> 
> It's a lot of overhead for __GFP_DMA to have multiple providers, so I'd
> rather allow kmem_buckets to allow pass-through (perhaps explicitly
> opt-in) where then the other options (e.g. alignment) must match the
> general kmalloc caches so that pass-through is consistent.

"pass-through" mode for __GFP_DMA seems reasonable to me. I hope we
eventually get rid of it, so I would support it in the most simple way possible.

>> > When it falls back to kmalloc, kmem_buckets itself should provide a
>> > compatibility layer when falling back to kmalloc.
>> 
>> For example, calculate_sizes() converts certain SLAB_* flags into
>> GFP flags (s->allocflags) for allocation. We can have a similar
>> logic when falling back to kmalloc.
>> 
>> Though current implementation does not allow this and requires
>> some rework.
> 
> I think the current series does everything correctly in the sense that
> nothing is allowing for mismatched fallbacks/passthrus. We could iterate
> from there once we have a need for this where a non-kmalloc-alignment is
> wanted, etc?

I think we can indeed simply make sure buckets have the same alignment as
kmalloc. It comes naturally and should (more than) satisfy everyone. I doubt
anyone would be needing a more specific alignment than that for a class of
allocations with a variable size?

ctor removal is clear I think

for __GFP_ACCOUNT and __GFP_RECLAIMABLE I think what we could do is not to
drop the flags argument kmem_buckets_create and instead require that it
matches the usage:

__GFP_RECLAIMABLE requires SLAB_RECLAIM_ACCOUNT and vice versa and I can't
imagine there would be a buckets instance that would allocate both kinds
(either with or without __GFP_RECLAIMABLE)

SLAB_ACCOUNT requires __GFP_ACCOUNT, memcg objexts are always created and used

SLAB_MAY_ACCOUNT allows __GFP_ACCOUNT, memcg objexts are always created, and
used when __GFP_ACCOUNT given
- perhaps not as optimal as the separate kmalloc types, but good enough?

__GFP_ACCOUNT without either SLAB_ACCOUNT or SLAB_MAY_ACCOUNT is wrong,
__GFP_ACCOUNT would be ignored

with SLAB_BUCKETS=y these rules could be checked e.g. with a VM_WARN_ON_ONCE()

with SLAB_BUCKETS=n these rules won't be checked but also not matter in practice

wdyt?

