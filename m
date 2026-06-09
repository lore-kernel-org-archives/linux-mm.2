Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3703CD8CAE
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 04:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216EB6B0005; Tue,  9 Jun 2026 00:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE9C6B0088; Tue,  9 Jun 2026 00:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B146B008A; Tue,  9 Jun 2026 00:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F01916B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:19:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82FC61C1B9B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:19:19 +0000 (UTC)
X-FDA: 84859069638.20.42FC84D
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2EC0940004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:19:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780978757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SOZp0gh/2PfoEyy8u28l7wEylW2vg6YnuVSVA+V7Vwc=;
	b=z/+T6XV5Bg70MxZ32mq06yuUxQ/5Jj4nzOlpA7hMpytZvNwC5UQw06JTJgcrQiuAiPYBQc
	0AcefxRf7v59KyuyaW0Z2IrRy4IbzFYt7ZeMYDgrIgqEhZl7zruqRT6cxZI1ev0zST6NE3
	EUiGjv4+y52E4cz3u5OpbkHFhiYKUBA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780978757;
	b=ER/b2peFXZw1j3TR3wdJcDwo1YmEFcK0iyMDRtx4QOtm4Fzb8NFZ92iRLYS2hSLZEUUhGj
	dy8L+nr6PNeCAG3dBDebepoHduiNom7AaxAkHekZTofvN2aTDX8ly2AGEOTrqRM7ymGx3L
	PgYIJn+yJ7ALamc8AZcp1C3ZLCLv/IU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 9 Jun 2026 13:19:13 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 9 Jun 2026 13:19:13 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Hao Jia <jiahao.kernel@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org,
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev,
	Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org,
	chengming.zhou@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org,
	kasong@tencent.com, baoquan.he@linux.dev
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
References: <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev>
 <aicZ-5GX9De3MAU7@linux.dev>
 <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
X-Rspamd-Queue-Id: 2EC0940004
X-Rspam-User: 
X-Stat-Signature: b9hc3r8b4z4cq4km7y38mt437j8srt1z
X-Rspamd-Server: rspam08
X-HE-Tag: 1780978756-436235
X-HE-Meta: U2FsdGVkX1/zdigC3XFk96jtckRTwnYW2BJhKAun81KWbpfqSjd8H86v2lIcVQo9T+OEpcRvEmVM6JiFKk+B/aw4M9ila4jJAlaw2v5UCShwQv7nikcdIhTeHAc3nEI1iB2qO7G99+MrkF6OMLrLELXTW0n498HbZS6I4e5PvxFYc3awSx4IXjYsGLahDTIR6gOlXUKQ9wW+6NoZpbg76Nr3xOXtRjLhubmb1ga7HFy+XcXP6SN1/cFk4shO4nH2sQxZVxOz0CqMZHwDRKMPngcwZYTebMl7N5TENdBUF381ILa3p5gwf7rRqF4BEVBMKTCEZ+1OduFArRgpDpQt2XnkusFMzY/l+Rpt/ewe4j0aDrBsjtshWiQVmBD5f2ANyNn5UcXDOETVD3yFzdYkeLGnrSf6Mdai0FtjcmmnEuURScQDZXrfn2R3F5c+6FgXAogI2VsZ4FeKaDfSJ88lKn5ek5UhP39ONGUpMRps5A9toFiMUbR1b1kr+TaPmTqNwFGLlgTNojf7otsJvYTJCphcUirhpUagBBTepTXk7zs22y4SZYkVW+mOQDYDKiH1SYQCSopT7NqF633Rz1jXWLs6prfBZZDKwCKTHG5/Ny1hIizx+pNTsHn+0pNM/WdE/yBIvn9czYHOW0Wxwo+FOFxPW3Fh/OLCzWr4SrMgqyjC/yQUJpwpPfgjWXRPVbVAQTiu6wWB43gh1+GXf74z7hIDMK3zwWWwYFR2TUHbCwUbbKL/7zIUEaafBUNwfvuJlOeVin1/pKCiLDGT3VZ4OZQ37D6vFa80eMYro81aGJuKtGVo06QajjfMptippm1PUIKUFERYQeVbUQYEfXJ4GmD6GSeiL9Z6ybzif0ohh6HOzVrs8i/p/zAYmgYl+hUN54ZTUpsfF36Nh+FN+N2nMvOqLhwzcjrNh0eH6P0KovS0nGJ3PUkiqdNh1TLg6/ZeuDguAaAUJ3rgqeIfAoZ
 MOVVkff0
 eXsqTKUlzk/yFVeuTLOQLugGl4O6rGKIJWEUTIMcSdXfdX+TkzbwtVWCrASSmb0xyhLEcKz5vsXZ1CBjAVMfpjGOM6IF0RiIQBIPGX09XOgvqb8IVx5g+YvfYswZ+YIVMnvhbNkdEyPLBL+S7tz2/H6BhTXJU01f/Y0tmR2B2gpnuQM41nvtltVuMTIxMUDXuKgKFqULkMb3C/+VqodhCYVSVkFogXpk1caZYByObdq05zJi+ETBPwWA7arvS4tnCbLmYhGgQw0gLmHc18YzKYUqhBqVszNh9NcIcU0A6Rr2kXf1yCUQfBCfzd+JbcwUNSAbGY/n1bmHprizV/TKELypT4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 03:27:07PM -0700, Yosry Ahmed wrote:

+Chris +Kairui +Baoquan

Hello

Thanks for inviting me to the discussion, Shakeel.

> > > > Youngjun is working on swap tiers. At the moment he is more interested in
> > > > allowing a specific swap device to a memcg or not. I can imagine in future there
> > > > will be use-cases where there will be a need to demote data on higher tier swap
> > > > to lower tier swap. What would be the appropriate interface?

Speaking of my work on swap tiers, I recently submitted a patch and am
currently considering memcg integration:
https://lore.kernel.org/linux-mm/20260527062247.3440692-1-youngjun.park@lge.com/

The future use-cases imagined above seem to align with this
direction. (BTW, I am currently waiting for reviews/feedback from the memcg
folks on this patch. Any reviews would be highly appreciated!)

We could potentially assign a target tier
for writeback within the existing memory.zswap.writeback interface. 

For instance, '0' could mean disabled, while non-zero values could represent
specific tiers, which would maintain backward compatibility with the current
version. Alternatively, if zswap is treated as the default top tier, 
the `memory.swap.tiers` interface could potentially replace `memory.zswap.writeback`.

Furthermore, this could be expanded so that each swap tier can demote data
user-triggered demotion between swap tiers.

Based on the current patch's ideas combined with my swap tiers concept:

Assuming a hierarchy like:
zswap -> tier1 (SSD swap) -> tier2 (HDD swap) -> tier3 (Network swap)

We could configure the active tiers via a setting like `memory.swap.tiers`
(tier2 enabled, tier3 enabled).

For example, the concept of `echo "100M zswap_writeback_only > memory.reclaim"`
could be extended. A user could run `echo "100M tier2 > memory.reclaim"`
to explicitly trigger demotion from tier2 to tier3.
(BTW, if we combine these features, my personal preference for the keyword
format would be `<size> <demote_prefix><tier_name>`. I think it would be
better to explicitly indicate that it is a swap demotion by using a specific
prefix followed by the tier name. 
Or make demote prefix another key is also possible)

So, the whole picture would look something like this:
- memory.swap.tiers		: Interface for configuring the tier mask.
- memory.reclaim                : Entry point for user-triggered demotion.

> > > Things will probably get more
> > > blurry with memory tiers and compressed memory nodes though.
> >
> > I think there will still be distinction between byte addressable and fault on
> > access devices.
> 
> Yeah, I think it makes sense to define "swap" as fault on access
> (zswap, SSD, etc), and memory tiers as byte-addressable (even if you
> put an SSD behind CXL and make it byte-addressable). But I also
> remember seeing discussions about unifying memory tiers and swap in a
> way, and it makes sense from a reclaim perspective (swap or demote
> first?).


> > > > will be use-cases where there will be a need to demote data on higher tier swap
> > > > to lower tier swap. What would be the appropriate interface?
> > > >
> > > > BTW does zswap folks think of zswap as a top swap tier or something different?
> > >
> > > I haven't been following the swap tiers work closely, but personally I
> > > do think of zswap as a top swap tier.

Regarding zswap's position, I agree it needs to be defined as the default,
top-most tier in swap_tier. In my early RFC, I allocated a separate tier
specifically for zswap:
(https://lore.kernel.org/linux-mm/20251109124947.1101520-3-youngjun.park@lge.com/)

> > Same for me though I imagine swap tiers would introduce some duplication i.e.
> > different way (interface) to set limits for swap tiers for a given memcg.
> >

I also agree with the concern about interface duplication. We will eventually
need a mechanism to control swap amounts per tier, which requires thinking
about its relationship with swap.max. (I raised this as an open question in
my early RFC).
https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/
(Further Discussion and Open Questions Part)
However, since this feature is necessary anyway, wouldn't the proposed
interface be acceptable without causing conflicts at this early stage?

Additionally, `memory.zswap.writeback` seems redundant. Restricting a cgroup
to only use the zswap tier (assuming it's the first tier) is practically
identical to disabling `memory.zswap.writeback` (correct me if I'm wrong).
But there is no problem to integrate it as I think
e.g  `memory.zswap.writeback` could internally act as an alias for setting `memory.swap.tier` to 'zswap only'.

BR,
Youngjun Park

