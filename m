Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47159CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43EED6B0093; Fri, 12 Jun 2026 03:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F5A6B0095; Fri, 12 Jun 2026 03:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353906B0096; Fri, 12 Jun 2026 03:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24CD96B0093
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:27:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8E421C3777
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:27:42 +0000 (UTC)
X-FDA: 84870430764.22.16BD231
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf18.hostedemail.com (Postfix) with ESMTP id 62A6E1C000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:27:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781249261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bvd8Ju/Z2ZTK6MLCKnp4xH6vwFy//CUqHbTyKsg7u5U=;
	b=qfX4T+D5wQkdcZX3o44ANF1aaJITJeLYyAX+Daq4rk4vxXsuuFKB1iceOd7uQEeoZdtb86
	zaCKHe9iSQJeaop4odDWeJC9RwY0gh7PQKL+U8mrAUznawuXIGC75+9b1XNyjpihdMegQm
	bcBlxQdBYGOV6EILaUQvTBLq2sdEY3I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781249261;
	b=Qf4Qlcq6Dqq02VaFlgzNP5mnL/rUsbpLjVYMHbkOCBx+lGwwo/zSN2fxkowJyYIBB13GVO
	+iLR8MvnYnZ2qWGly2wosiKcMZKlfKRlvfPN8LrtjRAiuWCn4liHfv1y4FxwvdfSf2++X+
	3Py7NcLqeBzztX95w8KHkpLvbcbMWlU=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 12 Jun 2026 16:27:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 12 Jun 2026 16:27:37 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>, Hao Jia <jiahao.kernel@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org,
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev,
	Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org,
	chengming.zhou@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org,
	kasong@tencent.com, baoquan.he@linux.dev
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
References: <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev>
 <aicZ-5GX9De3MAU7@linux.dev>
 <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
 <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aisEWnb3pzmVC4dl@linux.dev>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: s3zgnrygx3ur3bhbhz9tz7dpdbakgyry
X-Rspamd-Queue-Id: 62A6E1C000B
X-HE-Tag: 1781249260-511798
X-HE-Meta: U2FsdGVkX1+3hP8iCNy6cU5XYRSA8Bbl0NBgn+bd47l+AJORoZPkp4livE7FaMVlssxsc/qeYbhHQVIUTgYW2gcTs/fDfxr9premFVxf+So6aMg1BRghusXrheBlgJfQFJsVN8tOwlqicSZbA03QVnGB3n8+PHqGfa/KNDLPAyudKFj2FGGydmp+/n2b7X1GI7EeKVRFBxWLXbwBrcgnAoDSL5mj5yIguQwOR9KaUSbZYN63MD4hZH9ebCjeQ7VIe3JDVJ12uxcSgPGLUQSha+rjtNUW+CHYHT/Ju7tgdcvMZMgXqcmBRkdWevuxFKUvd+RGBEMgYQkYa4hOd5wuoM6SL/orBAFEAPJW38G6vgFBdTBDkHUqZ6/M4Crkxk1DU5VAlHH2WVx7sjWPpTsEqdZ7SmlMrSyeaMgy4qXtqqmnq5JVxxU0X3rjZl1Z+deCBcqGJQwotvYbqy10tLwIsypL9paiZlxGBvlykU4N3KsiFqRMfNkITFK00AYJlNNWeKdqak9TvsG9ASRPXsgEoUSSIT0gCGxJ9FOJdnd1G29InXv59D8s3f4fXgjt5sBpvoo3r0S8ERb0lRR07la4uDwB+uJJIXBTW7+ey3JdEbwmsSdnNmDxWBHCiWoqbs0BDUwPs00evIPxxkhv2Ku+GYnlDPWtbsmLdFNsGsCDdzxxtc9aAIQw2HhH8khkSEbtBFj+qXdDwZbCOMsPL5T2Mzo41Ijp1DQkN97SE87EBA9a13TI5fiLqkhpUgyxJHfl3JuSyzGP7dCuqwnBcuwBPJSSIA6PyNKdaHq946uDNOa3Ia4fpxDHqlvLx4iWETTpPK995B+a/caUYp29ha8IYy87IFWbBn1yDAI+Q0toxweUJUiWQgqaRCVQ86Xs/gXPLtREk+IxZBdVymWTFmguvZ1alfz/iF9BeVyWQHmfEd/7CaitR2fUU69SZE0DLXVr9npc9bcpHsVIdhhrVyH
 LJOgSgXq
 +wd+AtoNbwBMALnBzSxFQBXHtRj4Qo9ZJhBhKyTBEiREj4MXikWUtoztm7nkZnDcUN29QL451PspIUBYj1A+CqnCwLRigv0d6RvPEGIT3nRyAblY6AJkPXbgsZerADc5QBb+MFlRI2Zeu2z/GpeDaOqd+Sg2lZ/xTJG2AuyNX1sAJkK/PNhbtCmTuF+ObsXzGH2Hd1UDeQXR+owHLimrgl61J/yxAEwsHGxBcZs1uLBlNCIoH+ILGGpqZh1JfIbQj1gzfWTBDCohBnH3HnHLCleutrKNrPpqAvvSxEHTfPmbikZX1humLy6Cxn+d1qdM+oED1ITED/AdLVPYG6sRza2dktySmUPVAgUjAknNxyjO1P0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 12:12:40PM -0700, Shakeel Butt wrote:
> On Thu, Jun 11, 2026 at 05:45:04PM +0000, Yosry Ahmed wrote:
> > On Tue, Jun 09, 2026 at 01:19:13PM +0900, YoungJun Park wrote:
> > > On Mon, Jun 08, 2026 at 03:27:07PM -0700, Yosry Ahmed wrote:
> > > 
> > > +Chris +Kairui +Baoquan
> > > 
> > > Hello
> > > 
> > > Thanks for inviting me to the discussion, Shakeel.
> > > 
> > > > > > > Youngjun is working on swap tiers. At the moment he is more interested in
> > > > > > > allowing a specific swap device to a memcg or not. I can imagine in future there
> > > > > > > will be use-cases where there will be a need to demote data on higher tier swap
> > > > > > > to lower tier swap. What would be the appropriate interface?
> > > 
> > > Speaking of my work on swap tiers, I recently submitted a patch and am
> > > currently considering memcg integration:
> > > https://lore.kernel.org/linux-mm/20260527062247.3440692-1-youngjun.park@lge.com/
> > > 
> > > The future use-cases imagined above seem to align with this
> > > direction. (BTW, I am currently waiting for reviews/feedback from the memcg
> > > folks on this patch. Any reviews would be highly appreciated!)
> > > 
> > > We could potentially assign a target tier
> > > for writeback within the existing memory.zswap.writeback interface. 
> > > 
> > > For instance, '0' could mean disabled, while non-zero values could represent
> > > specific tiers, which would maintain backward compatibility with the current
> > > version. Alternatively, if zswap is treated as the default top tier, 
> > > the `memory.swap.tiers` interface could potentially replace `memory.zswap.writeback`.
> > > 
> > > Furthermore, this could be expanded so that each swap tier can demote data
> > > user-triggered demotion between swap tiers.
> > > 
> > > Based on the current patch's ideas combined with my swap tiers concept:
> > > 
> > > Assuming a hierarchy like:
> > > zswap -> tier1 (SSD swap) -> tier2 (HDD swap) -> tier3 (Network swap)
> > > 
> > > We could configure the active tiers via a setting like `memory.swap.tiers`
> > > (tier2 enabled, tier3 enabled).
> > > 
> > > For example, the concept of `echo "100M zswap_writeback_only > memory.reclaim"`
> > > could be extended. A user could run `echo "100M tier2 > memory.reclaim"`
> > > to explicitly trigger demotion from tier2 to tier3.
> > > (BTW, if we combine these features, my personal preference for the keyword
> > > format would be `<size> <demote_prefix><tier_name>`. I think it would be
> > > better to explicitly indicate that it is a swap demotion by using a specific
> > > prefix followed by the tier name. 
> > > Or make demote prefix another key is also possible)
> > 
> > I am not sure if proactive demotion between swap tiers would be driven
> > by memory.reclaim, I am guessing a new interface might be more suitable.
> > But yes, you are right that it's very possible that
> > 'zswap_writeback_only' with memory.reclaim will become obsolete once
> > swap tiering matures and starts supporting things like proactive
> > demotion.
> > 
> > Part of me wants to wait until the swap tiering interfaces are figured
> > out so that we don't end up with redundant interfaces, but I also don't
> > want to hold Hao's work since it doesn't directly depend on swap
> > tiering.
> However I would need zswap folks (Yosry & Nhat) help in figuring out swap tiers
> interfaces. Zswap is the current top tier swap usage in real world. I want
> zswap users to eaily (and hopefully transparently) migrate to swap tiers.

> > Shakeel, how do you want to handle this? I think there's a few options:
> > 
> > 1. Add zswap_writeback_only now, and when we have swap tiering demotion
> > it becomes a redundant interface, like memory.zswap.writeback -- or
> > maybe we try to deprecate both of them at that point. It's difficult to
> > remove interfaces tho, but maybe easier to stop supporting
> > zswap_writeback_only.
> > 
> > 2. Add zswap_writeback_only behind an experimental config option, to
> > unblock development but have a line of sight to dropping support once we
> > have a swap tiering interface.
> > 
> > 3. Wait until we figure out the swap tiering interfaces and then add
> > the proactive zswap writeback as part of it.
> > 
> > WDYT?
> 
> Is Hao's work needed for some followup work/development? The earliest Hao's
> work can is 7.3, so if we aim to figure out swap tiering interfaces in next
> couple of weeks then option 3 is the way to go. If swap tiers take more time
> then we can discuss other options as well.
> However I would need zswap folks (Yosry & Nhat) help in figuring out swap tiers
> interfaces. Zswap is the current top tier swap usage in real world. I want
> zswap users to eaily (and hopefully transparently) migrate to swap tiers.

I am looking forward to the discussion on this interface!

To help boost the discussion and progress, I would like to share a few of my thoughts.
We could either introduce a new interface to trigger demotion/promotion,
or we could reuse the existing one (using tier just internally)

Based on the memcg interface currently proposed in swap_tier
(memory.swap.tiers, memory.swap.tiers.effective), I think it aligns well
with the current direction. It provides a foundation for selectively
targeting devices in tier order.

To summarize the discussions so far, the following points align well.

- Per-cgroup swap control, as I suggested.
- Proactive zswap writeback (Hao's usecase)
- Swap device target demotion(if it wants selective, then it is more better), as you mentioned:
  https://lore.kernel.org/linux-mm/aicZ-5GX9De3MAU7@linux.dev/
- Virtual Swap on/off in the future, as Nhat mentioned:
  https://lore.kernel.org/linux-mm/20260528212955.1912856-1-nphamcs@gmail.com/
- The memory.zswap.writeback alternative (no hierarchy model conflict)
- zswap is first swap tier.
- Promotion. (Also better for selectve usage)
- tier based swap policy (e.g round-robin...)

To accelerate this work, I believe we should reach a consensus and
merge the currently proposed swap_tier interface :)

If the above approach is difficult, I would like to suggest an
alternative for progress with the memcg interfaces removed:

1) We could make zswap the first tier and create
a use case where memory.zswap.writeback internally is handled by tier logic.

2) Or simply merge the swap_tier infrastructure itself first.

This would allow the swap_tier infrastructure to be merged and discussed
more easily.

If it takes longer to adopt swap_tier anyway, by doing so we progress next step
as a experimental feature.

- Apply per-cgroup swap as an experimental (debugfs) feature.
- Apply Hao's use case experimentally or as it is as Yosry suggested.
(future migration to swap tier)

How do you think?

(FYI: My emails to kernel.org are failing due to internal server issues.)

Thank you 
Youngjun Park

