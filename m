Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5665ACD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 09:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4D26B009F; Sun, 14 Jun 2026 05:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA58B6B00A0; Sun, 14 Jun 2026 05:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994236B00A1; Sun, 14 Jun 2026 05:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 850D26B009F
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 05:23:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29B6D140652
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:23:10 +0000 (UTC)
X-FDA: 84877979340.11.8707AEC
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id A22AC120005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:23:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781428988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eu7CZX1tL9ZftgmiUDlCbgNaoN46c6mOx0nSdxIlLKc=;
	b=WWAgQZmItIK/Jw9GvrKq2RPragq3WY97QXNzbN9m+09o32dleVDjp6BWPwaEqw4EjVpMSM
	lmDruwnxfDgP4dbMEreiW6JjG/SiTEnZGAvTL1V61cdtZwret2fP0UCZKt/CZFTFm9btlX
	qWc3zeVC4LUH4zHx7Agdd5gBnyabnUg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781428988;
	b=OZQ/moQQ9zeZF4XPYV9/nhCj0n9FZrzjY6Df6ecrd5M8w2JeXbDKJj2rph3LF6sRFpSTjR
	mBExZg5OqBcYfrdEwOqPeTeIRJno2iuyiH8uF3vLjnWbciTMu7rgYsUsKQU7b21eISjrgy
	vkIIUWM0P7pzWTDeD/jtLu2ibhmuN6s=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 14 Jun 2026 18:23:03 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 14 Jun 2026 18:23:03 +0900
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
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
Message-ID: <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
References: <aicJBVT4pBvmyooT@linux.dev>
 <aicZ-5GX9De3MAU7@linux.dev>
 <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
 <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev>
 <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aiw2p5ANjsQUCIHA@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A22AC120005
X-Stat-Signature: 49p7zs4e3sh9ec46nekpgso1kcauwum3
X-HE-Tag: 1781428987-560257
X-HE-Meta: U2FsdGVkX1+henhkal8PT6yx8whTly+A/fEhVIhoWVjaO9Qz/OWVYWFUbjpZgQOYZ0hdQrblGViuv4SnwIKOLUFpg0WS0eQ4gVu0Qw+ovSOkyGikijSEjDt1Er4t+OqA6yW11s6QCFKBnlmi2OmembZ8g3GSK2CwTupeaW1qjU2V4X5CJzLKCfVlJ3FcZl1dto+EQIx4zaCDq2hK/G+7tdsc8Ur+nLdZ7K+JTjhPhLhHaZgEqC3KOKMMp3Pyr8b/taf8EeccLrA3zGEyN0eNhBjHtA6czBE2i/Rr+dYKhijGMnoEzYPxPbVaH+ZupHGP2SUPaC8TyNexanSFRseEFSupn7X4pnVIRqfQpHQ77xmvtaYEEeFg/I0QMN7iHRPwTM+pmPQ4cuxfSX0fkj+G/2qBeCR2p9hXTvucancEN2WYbIbyDp0o7jwBwLpRm7/XZi/Iaa1K1sVsDAwZVGg/x6srQBXvNbRzJSAx37PCme8DWKbNbLFkuA7ZWBLU5/4JfbMDt6YXbKcced9ZRxAXY7CrPGS0YgQdxVNR6PhtRYD9NXgMQ8JazYZSpYvSKf1Q1Ja2gzifNzmH9yqgKkQUWfU0EfvtCTJ9e/xaKVnfO702G60dsCuqofniIWPq7RBJKQB1mzaLRLh7XMacZFWShW8jXO4HHenSY88J3CBYF48qpmd7wuhaQxOtiJ23HWBev51xtB4w25+5rjKCaBOJJTGeQDzMLzFQZFkg/8gzAK9OHOmQN7bERnTh2Jl2kBL6LyzD6gZR5kx3qYskgBgOGNeu96usyqfG//cuZMKrstj2gkoA2IFEL+WbFogkVYcPf0wN+nsKr8QAw8SFbEBM1gzzR/kcmHQ/Q0aBQeWr8mfLzzhaiHNYCrDdKpxrrSFu8wLTEng4kBFR6188GM76XkwU+Be+P5iZyQNyYLAZYzpzogRmESjvE0OOPBv9YagslHPCjyQEf/IjLKW+05A
 bwqNoLWD
 Sb8mxGwZe4NtD/tp6yVc0oAdT7uMUFL1bpy1NaoLcWxxoK8xN2ZCbjNrjI22slqR2gCsMQD8BooaGLe8o4gEaee5HWvk19oEshRwa1x6GzF+RT/4w35TjggtKxSgX+HL1qLF8xHs3UV0YL9c9ov/bd/w9mvZ7xY6FkbYTRWuMJgMNAYafUHpEahZ1G/TMi3O/3MEBVtV2GG9njAjh/FUlmXiWaV2p3vGkcT/NRMKCIP8gmJxj7jG+C/d4K+Jv2pojE6G/MwaYj8q5oND75IPG+cKQrfLenQGVpKb7thaJvOsmgNBYS1p/yUb2yDBWGH3q6pqIVZonv7/ZUciZX3B6O69k6PIFqDIj4slaLB3eu1BhP30bqL6zPqCf8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

....
> >Based on the memcg interface currently proposed in swap_tier
> > (memory.swap.tiers, memory.swap.tiers.effective), I think it aligns well
> > with the current direction. It provides a foundation for selectively
> > targeting devices in tier order.
> 
> Here instead of cpuset like interface, we may want more zswap like interface
> where you can put limit on the usage i.e. memory.swap.tier*.max. We can start
> with allowing only two values i.e. 0 and max which effectively will be the
> same as what you need.
>

Good idea, and it's certainly feasible. When I considered this a while
ago, the reasons I didn't take this direction were:

1. There's no real-world usage for adjusting the swap tier amount (it's
   either 0 or MAX). That said, your suggestion to initially allow only
   0 and max is the killing point, and it's making me reconsider.

2. The implementation cost seems high. The current implementation
   handles this at runtime via simple masking.

3. Relationship with swap.max:
   - If we tie it to the current interface, wouldn't limiting the swap
     amount within a selected tier already be possible? I wonder if
     that alone is enough.
   - If we add tier.max, it would need to be a subset of swap.max.
     (Any other complexities here?)

4. vswap enable/disable: vswap doesn't seem to have an amount-control
   aspect, so an on/off semantic would be clearer.
   https://lore.kernel.org/linux-mm/ai5kOOmR1LPTWs1J@yjaykim-PowerEdge-T330/T/#m8831ec057bf9387978d3bd698f51920600e09a04

In that case, the internal logic could stay roughly the same rather
than counting via a page counter. Something like:

1. Change the interface shell: tier.*.max — allow only 0 ~ max.
2. Keep the internal logic as is: 0 disables the mask (child memcgs
   off too), max enables it (child memcgs on too).
3. memory.zswap.max integrates naturally (it's memory."tier_name".max).
4. Extend later if use cases arise.

On balance I still lean toward the current interface, but if a per-tier
max is the better fit for memcg's direction and others feel the same,
I'm happy to switch. I'd like to hear Shakeel's thoughts again, and I'm
curious about others' opinions too.

A few more perspectives on the points below.

> I will respond to your other points later when I have time.

> > 
> > To summarize the discussions so far, the following points align well.
> > 
> > - Per-cgroup swap control, as I suggested.
> > - Proactive zswap writeback (Hao's usecase)
> > - Swap device target demotion(if it wants selective, then it is more better), as you mentioned:
> >   https://lore.kernel.org/linux-mm/aicZ-5GX9De3MAU7@linux.dev/
> > - Virtual Swap on/off in the future, as Nhat mentioned:
> >   https://lore.kernel.org/linux-mm/20260528212955.1912856-1-nphamcs@gmail.com/
> > - The memory.zswap.writeback alternative (no hierarchy model conflict)
> > - zswap is first swap tier.
> > - Promotion. (Also better for selectve usage)
> > - tier based swap policy (e.g round-robin...)
> > 
> > To accelerate this work, I believe we should reach a consensus and
> > merge the currently proposed swap_tier interface :)
> > 
> > If the above approach is difficult, I would like to suggest an
> > alternative for progress with the memcg interfaces removed:
> > 
> > 1) We could make zswap the first tier and create
> > a use case where memory.zswap.writeback internally is handled by tier logic.
> > 
> > 2) Or simply merge the swap_tier infrastructure itself first.
> > 
> > This would allow the swap_tier infrastructure to be merged and discussed
> > more easily.
> > 
> > If it takes longer to adopt swap_tier anyway, by doing so we progress next step
> > as a experimental feature.
> > 
> > - Apply per-cgroup swap as an experimental (debugfs) feature.
> > - Apply Hao's use case experimentally or as it is as Yosry suggested.
> > (future migration to swap tier)
> > 
> > How do you think?
> > 
> > (FYI: My emails to kernel.org are failing due to internal server issues.)
> > 
> > Thank you 
> > Youngjun Park

Let me clarify a part I wrote confusingly. Handling
memory.zswap.writeback via tiers is possible, but I don't think the
interface itself would be replaced even if memory.swap.tiers is adopted.

Selecting only zswap in memory.swap.tiers would not just disable
writeback.it would also block regular swap entirely, which differs
slightly from the current semantic. (... "Per the cgroup v2 docs: a
zswap-only tier setting is subtly different from setting
memory.swap.max to 0, since it still allows pages to be written to the
zswap pool; this has no effect if zswap is disabled, and swapping is
allowed unless memory.swap.max is set to 0.")

So the interface itself needs to be retained, and it could be extended
toward selective writeback — e.g., passing a desired tier into
memory.zswap.writeback so writeback targets only that tier. Currently
it only controls on/off. Other tiers probably don't need this. demotion
based on the selected tier should be enough.

Thanks,
Youngjun Park

