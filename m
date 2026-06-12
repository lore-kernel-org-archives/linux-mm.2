Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C3C8CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1D466B0096; Fri, 12 Jun 2026 13:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACDF36B0099; Fri, 12 Jun 2026 13:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3CC6B009B; Fri, 12 Jun 2026 13:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3556B0096
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:02:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37366163F2E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:02:42 +0000 (UTC)
X-FDA: 84871879764.17.D20F351
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41D0A16000C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:02:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RhEx3Z8V;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781283760;
	b=TVsrQrZ3PtaiOlgYBUBrKgDD6O4H9mKN6zwgzgo6+u7aUsIRAFmZk9BaeCv9MhKiNGMdRV
	OU2X413G8oopkCawwp/XYT3MtPMaRIw8yzB90vMyw8PaISL2q1iB45oRPe4RQ7sekLIwNc
	HE13kemipymFSyijrA7Lvj7ytJVLI/I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RhEx3Z8V;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781283760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=laE9N/rFk+g9gKLRRTmV/tr2adDTNsrG3i/u6WEqO7E=;
	b=U5DyxwNivnbbkJSDJayndwHDokK9wcGPM2BCq4GXucKHyvEARPeXCqiNf+r27aXQ+h+5jo
	iTjT8OGoisHm7lCp6YYjIJUgwxhRHi60PFmtnfCiVStU5FobU+VnXp0SbDmuLMzfCvKAeU
	Pdc/1A0j2mCefOiNCCTtDxEB9fjKXvs=
Date: Fri, 12 Jun 2026 10:02:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781283758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=laE9N/rFk+g9gKLRRTmV/tr2adDTNsrG3i/u6WEqO7E=;
	b=RhEx3Z8Vm6DEMJrxApUrLKFqec7yFZPSFbWMn6B5zFYlCj/RA80FMvDLq9p5vbYGkxVIMa
	0fPXY/x086T9BPWkMYW1P4Qo18Dotxg0tKyrVhsW4se5N46soreQ7svztZze2OhzHzpOYY
	Lai1OdzrkJzn0lqBQ87JQdCdx4uH498=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, kasong@tencent.com, baoquan.he@linux.dev, 
	joshua.hahnjy@gmail.com
Subject: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
Message-ID: <aiw2p5ANjsQUCIHA@linux.dev>
References: <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev>
 <aicZ-5GX9De3MAU7@linux.dev>
 <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
 <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev>
 <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 41D0A16000C
X-Stat-Signature: wu5rgg5nfdrjw534dq5xwxgipjy9ex9f
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781283760-493519
X-HE-Meta: U2FsdGVkX1+MmAloOgqna44eSif4TUaD+LZ1w+vsTK/lMVhBexFhBSys+sX22rHWkwtAal6MIAdWJ4qXfSldIcJ58YMLJj/B8RipSUDsB4BxC8X9Ff7D1pnsAHiHk2CO8cfatCgQyHul4dljgL3Sxe19Oq5gmw3GsOj8LI53SNJxPpnTxwarpF1ZDb+gJM7t3W5iO01kkTldPn04KcpuGseegkXMEqjsrFzQODx2VPpFoTeubse4C7iboMXibZAICoJqMi9u1BsNkqMbIXuOzc1nYkfbULB1PpvK1qUxpuqaL4HPvIgWBGkFchm0CTw9zDgoZ23qTwT7giPnf9Mm1TjNL5B8m7TvpM1nrVCw3DZWlo6M4b+hY7IBI1MK6ZoNaytVyHHgPBoD1nOpPfzPTZ0/qwsbG7uPVszrhk+aG5TujAB0L6UpMqIuxzo66iZBdHTvlXaqTlPxep1FCGM3PqOP5lBCXA/rjcFJBha+29BKb04WmFscdPSCOo/IrOAJlrDb+ubqpqI1IVnt1+AhMMiQJ9wyox/f802n1vCxo11o1vBLDd9B2E6S4FtROxyAVLb4+PzYgz7HjsXnKd5I7pcjhlGxC1r0sNi0OfhlWkvDq8WqAVhOwRhJhm3M6kSZFiJB+3QQdi52sHc2HZ4K40egBhhJpwmV1x29rC3rUG9/QwHBNGbe4G08TR///NUSJSdgWJth00C0sn9mCkqOOyFr+huP1jV0QglYy8mIhT4xJs3FWXn0Z/79sybddGt3WOVqbBMxDenT+Vh2MvMWbqFWCpj/YqhyYzEhpfOqGMhhWOQs2q3tSAy2nI8retTKCnJX+q2anhpWdFHuKB2TPiW5Ujcc43yHkTeRHo/3jvVGrR1SUetHvN7xIHBR7M3x6xq0fpQBVUnMedGybEq+1XjUkKjpwFNaJpGNe5xrzGdeXEn0Amkh548uyGs1s2kY3aMw41m3o4JBdGctbqc
 mapCLqXA
 DgTRlVxO8nmEUUA0QiraAqwv7suO3vass9Vd4VR0i8yjofOiCHKL79jvxh7JEesg66luR8TdILpe9IgeH1Dz9/D+CLUfoTEhcZ+eBkJbIKyrIixLhDGpwFsRUgf3SMvpbd5owN8ythGXa6iJXUU5exYAjXKkxb8qwzQAdzB6s8Is52MHwn98NNDZAs9btAKQ0SZH8XHAj20lNZ6UwSsVzY0FInaqwSQnrNp6N3ehk36Y2yAWmzJ9v2du2yXepFHWWWDKahY32VLV8CBAWxaeSnHlBNFxqabS/eoJdbc5EgzYzcqBz4AciJFlaUvoliS5CV3kMASbzf6xpB4HE2x+sQ+7OEer+Jy4BV9H8tO8C6JvzXkM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changed the subject to separate the discussion on swap tiers.

On Fri, Jun 12, 2026 at 04:27:37PM +0900, YoungJun Park wrote:
> On Thu, Jun 11, 2026 at 12:12:40PM -0700, Shakeel Butt wrote:
> > On Thu, Jun 11, 2026 at 05:45:04PM +0000, Yosry Ahmed wrote:
> > > On Tue, Jun 09, 2026 at 01:19:13PM +0900, YoungJun Park wrote:
> > > > On Mon, Jun 08, 2026 at 03:27:07PM -0700, Yosry Ahmed wrote:
> > > > 
> > > > +Chris +Kairui +Baoquan
> > > > 
> > > > Hello
> > > > 
> > > > Thanks for inviting me to the discussion, Shakeel.
> > > > 
> > > > > > > > Youngjun is working on swap tiers. At the moment he is more interested in
> > > > > > > > allowing a specific swap device to a memcg or not. I can imagine in future there
> > > > > > > > will be use-cases where there will be a need to demote data on higher tier swap
> > > > > > > > to lower tier swap. What would be the appropriate interface?
> > > > 
> > > > Speaking of my work on swap tiers, I recently submitted a patch and am
> > > > currently considering memcg integration:
> > > > https://lore.kernel.org/linux-mm/20260527062247.3440692-1-youngjun.park@lge.com/
> > > > 
> > > > The future use-cases imagined above seem to align with this
> > > > direction. (BTW, I am currently waiting for reviews/feedback from the memcg
> > > > folks on this patch. Any reviews would be highly appreciated!)
> > > > 
> > > > We could potentially assign a target tier
> > > > for writeback within the existing memory.zswap.writeback interface. 
> > > > 
> > > > For instance, '0' could mean disabled, while non-zero values could represent
> > > > specific tiers, which would maintain backward compatibility with the current
> > > > version. Alternatively, if zswap is treated as the default top tier, 
> > > > the `memory.swap.tiers` interface could potentially replace `memory.zswap.writeback`.
> > > > 
> > > > Furthermore, this could be expanded so that each swap tier can demote data
> > > > user-triggered demotion between swap tiers.
> > > > 
> > > > Based on the current patch's ideas combined with my swap tiers concept:
> > > > 
> > > > Assuming a hierarchy like:
> > > > zswap -> tier1 (SSD swap) -> tier2 (HDD swap) -> tier3 (Network swap)
> > > > 
> > > > We could configure the active tiers via a setting like `memory.swap.tiers`
> > > > (tier2 enabled, tier3 enabled).
> > > > 
> > > > For example, the concept of `echo "100M zswap_writeback_only > memory.reclaim"`
> > > > could be extended. A user could run `echo "100M tier2 > memory.reclaim"`
> > > > to explicitly trigger demotion from tier2 to tier3.
> > > > (BTW, if we combine these features, my personal preference for the keyword
> > > > format would be `<size> <demote_prefix><tier_name>`. I think it would be
> > > > better to explicitly indicate that it is a swap demotion by using a specific
> > > > prefix followed by the tier name. 
> > > > Or make demote prefix another key is also possible)
> > > 
> > > I am not sure if proactive demotion between swap tiers would be driven
> > > by memory.reclaim, I am guessing a new interface might be more suitable.
> > > But yes, you are right that it's very possible that
> > > 'zswap_writeback_only' with memory.reclaim will become obsolete once
> > > swap tiering matures and starts supporting things like proactive
> > > demotion.
> > > 
> > > Part of me wants to wait until the swap tiering interfaces are figured
> > > out so that we don't end up with redundant interfaces, but I also don't
> > > want to hold Hao's work since it doesn't directly depend on swap
> > > tiering.
> > However I would need zswap folks (Yosry & Nhat) help in figuring out swap tiers
> > interfaces. Zswap is the current top tier swap usage in real world. I want
> > zswap users to eaily (and hopefully transparently) migrate to swap tiers.
> 
> > > Shakeel, how do you want to handle this? I think there's a few options:
> > > 
> > > 1. Add zswap_writeback_only now, and when we have swap tiering demotion
> > > it becomes a redundant interface, like memory.zswap.writeback -- or
> > > maybe we try to deprecate both of them at that point. It's difficult to
> > > remove interfaces tho, but maybe easier to stop supporting
> > > zswap_writeback_only.
> > > 
> > > 2. Add zswap_writeback_only behind an experimental config option, to
> > > unblock development but have a line of sight to dropping support once we
> > > have a swap tiering interface.
> > > 
> > > 3. Wait until we figure out the swap tiering interfaces and then add
> > > the proactive zswap writeback as part of it.
> > > 
> > > WDYT?
> > 
> > Is Hao's work needed for some followup work/development? The earliest Hao's
> > work can is 7.3, so if we aim to figure out swap tiering interfaces in next
> > couple of weeks then option 3 is the way to go. If swap tiers take more time
> > then we can discuss other options as well.
> > However I would need zswap folks (Yosry & Nhat) help in figuring out swap tiers
> > interfaces. Zswap is the current top tier swap usage in real world. I want
> > zswap users to eaily (and hopefully transparently) migrate to swap tiers.
> 
> I am looking forward to the discussion on this interface!
> 
> To help boost the discussion and progress, I would like to share a few of my thoughts.
> We could either introduce a new interface to trigger demotion/promotion,
> or we could reuse the existing one (using tier just internally)
> 
> Based on the memcg interface currently proposed in swap_tier
> (memory.swap.tiers, memory.swap.tiers.effective), I think it aligns well
> with the current direction. It provides a foundation for selectively
> targeting devices in tier order.

Here instead of cpuset like interface, we may want more zswap like interface
where you can put limit on the usage i.e. memory.swap.tier*.max. We can start
with allowing only two values i.e. 0 and max which effectively will be the
same as what you need.

I will respond to your other points later when I have time.

> 
> To summarize the discussions so far, the following points align well.
> 
> - Per-cgroup swap control, as I suggested.
> - Proactive zswap writeback (Hao's usecase)
> - Swap device target demotion(if it wants selective, then it is more better), as you mentioned:
>   https://lore.kernel.org/linux-mm/aicZ-5GX9De3MAU7@linux.dev/
> - Virtual Swap on/off in the future, as Nhat mentioned:
>   https://lore.kernel.org/linux-mm/20260528212955.1912856-1-nphamcs@gmail.com/
> - The memory.zswap.writeback alternative (no hierarchy model conflict)
> - zswap is first swap tier.
> - Promotion. (Also better for selectve usage)
> - tier based swap policy (e.g round-robin...)
> 
> To accelerate this work, I believe we should reach a consensus and
> merge the currently proposed swap_tier interface :)
> 
> If the above approach is difficult, I would like to suggest an
> alternative for progress with the memcg interfaces removed:
> 
> 1) We could make zswap the first tier and create
> a use case where memory.zswap.writeback internally is handled by tier logic.
> 
> 2) Or simply merge the swap_tier infrastructure itself first.
> 
> This would allow the swap_tier infrastructure to be merged and discussed
> more easily.
> 
> If it takes longer to adopt swap_tier anyway, by doing so we progress next step
> as a experimental feature.
> 
> - Apply per-cgroup swap as an experimental (debugfs) feature.
> - Apply Hao's use case experimentally or as it is as Yosry suggested.
> (future migration to swap tier)
> 
> How do you think?
> 
> (FYI: My emails to kernel.org are failing due to internal server issues.)
> 
> Thank you 
> Youngjun Park

