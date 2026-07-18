Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B0EFC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 15:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8A26B0088; Sat, 18 Jul 2026 11:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0606B008A; Sat, 18 Jul 2026 11:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E68F6B008C; Sat, 18 Jul 2026 11:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3C2A6B0088
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 11:11:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76A28120495
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 15:11:09 +0000 (UTC)
X-FDA: 85002235458.13.F9A7AF8
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 307C04000D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 15:11:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784387467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C7WT9R+c7nsTlJzlDMI/p1qPrm6WanAXTz0UBS7CuaY=;
	b=lmI6qwEekBzQcn1wxm3uUwPwTaCaitQy9U6hQvkL/d2F8vlGW/c30vGxGG13o7czJNZwQx
	rC2fZSaMAVYac06OCETRT+m/jWwsWXj76c9zsZ9tw6yauUW8OCJFyOMrjZmzB8YZ0YFYU5
	+oZ4+8ZVXrnPM2MbdhjBv2sPlzzBF34=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784387467;
	b=Yzhx/izzQmPBHS6ucrKtTzcmysWxusnCqIDHJGt6qlgUbf7Mlv3Mv503pDiwIAu7Qxzvci
	Yr+EkyF7VcRX8Mq4XOak5l2PejR9BlgMHJwgG0WcwBvt5iwEmXeJVl9iTvFADna2LxyYMP
	HZs+zHRJOTmAiwCwuDNEOVPgZIdTblY=
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.52 with ESMTP; 19 Jul 2026 00:11:02 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 19 Jul 2026 00:11:01 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 19 Jul 2026 00:11:01 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	joshua.hahnjy@gmail.com, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
X-Stat-Signature: 5jpj7oiicw7p6xnrch3ee6qmd4d4h6jz
X-Rspamd-Queue-Id: 307C04000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784387465-919976
X-HE-Meta: U2FsdGVkX19wQ7kihmrkpl4jIoxL7+HB/SPy8nng1y+dPcz/8gszrLyUy1bfFhrJ5SaeUvJ6H1t78hkx58/46kS3wwhUHSW/nz5VMTV3jsv83JanPKWA/iuBod1NGu8CkL0FBWVYtiRJ2cv86zpcplcfKmvLBKjUkU4iR2ZuBfhBFjsHYZaRKY5L6aGDJc3arR9M7Djm6cUB13tjCyKjbG8GNScJCrxm6VpfDCtZ3Hiuy4Yrac9I0apmvQxgRSkE+Y+wOLQP9LAeDmD1cYYbsSjvH1RsYcxzHfsRAGB5C16AyuzHa2hIj+RaRF5/1d03OgAJ3sCel01/RT1gxUiDnBVGbT8Ij4JPm/3o/JmZ4DNnV2zwEXnAf7l8pT5NFb2uS0UFeP9NbltJN14JcXWHnav/wXymtmMvaIfDa8EBCohIsRkm0JyWc6au3rryir9KwNC6yEBO4h4YlrlXuCzFthfsT5YQmTNjRZiv17HejpRmyeCFf6tdlZ7ufaEG6cVXNW/BhmNobcKy3/hByKE6RWV9iNY53QR2FdHeykNdkyam9cDrjLWUjeyfRhsajdQfXrdvYW7AG4ZsZ7IEifU5F04Hv6xNjSsG1jrKwFSpCCuWONwCcCJu+e9A463fcOld2DxaVdtJ9iRVoZI+ydMWrA7HNJ8JlBfamPSLpx9NTyWpYIZ2IqogRsT/PDzMCGT8hUM8BWckbFUV4bQ2RMC7WI2BnMoDF9pZYNkEovGhMqeLf08VIeJEJlOVyPljlNRIshDRcIUx/Z5XN1Icand4e7rzrtwTqLPL8gE1LmvkcRjAfBWnY7QG8sCxlOc/G7MTFXqsRAr0o41dsBnz6jR09SeR26Imjw+XJJ94FcyPBm+FcwbvSo1Aqa4crGcVIV7aoWxo69QLomHMdRPW76HEU+4kgjP3PQNL9Aa4Ch2ril3KuB4/1Fapu/J2xsxys6zoEWTGYgIihdldSTdXIw3
 y4dAZCeZ
 PNUnzoVKck8uVVvdXLYysXRdAIvfu6PxK7h5gfTEg3+N5yNHNci/J3iEP/tFb1flMvcoyeNGte9W0keOFI/w4rM83BSHh5t46d9JlHceqpACEngs5PiEPBWWfZg1/BHrb9/LLF0OxTh1XN6S4Qn2ETH/Z9GijRTptbilZ/0fo8QyMoXS9GhunlFM8H9h9589gJ4awTREs/iwvVwHdcM2yDRtWWFuFjpoYcXF7f9l/OR84JltcSFOweEn8lJkAJ/3m7DcH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > > > >
> > > > > Hello Yosry!
> > > > >
> > > > > This series does not cover zswap as a tier yet.
> > > > >
> > > > > My plan is to land the swap tier infrastructure together with the
> > > > > first use case (cgroup-based swap control) first, and then follow
> > > > > up with zswap tier support in a subsequent series, continuing the
> > > > > discussions we've had above.
> > > > > (I mentioned on cover letter, right above the overview section)
> > > > >
> > > > > Does that approach sound reasonable to you?
> > > >
> > > > How does swap tiering work with zswap in the current series? I assume
> > > > zswap is just enabled for all devices in all tiers?
> > >
> > > Yes, that's correct.
> > >
> > > > I wonder if introducing zswap as a tier after the fact changes user-visible
> > > > behavior. I guess if zswap will be introduced with a default "max"
> > > > value it will more-or-less be the same behavior,
> > >
> > > Right, that's the plan.
> > >
> > > > but I would check all
> > > > user-visible behaviors related to zswap (e.g. interaction with other
> > > > zswap interfaces) to make sure nothing breaks or changes in a
> > > > meaningful way when zswap is introduced as a tier later.
> > >
> > > Fair point. Let me review this more and get back to you!
> >
> > Please do report back what you find.
> >
> > Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
> > requirements for that?

Hello Yosry, Shakeel,

I have been working through this in detail at the implementation level.
For now I am adding on/off control of zswap through the tier interface.

> From zswap's perspective, we just need to skip zswap is zswap as a
> tier is disallowed. Could just be a check in zswap_store() similar to
> the check if zswap is enabled. I am assuming that if a swap tier is
> disabled, nothing happens to the existing swapped out pages in this
> tier, but new pages do not get swapped out to it. This is the same
> behavior that happens if zswap is disabled at runtime.

This part works as you described, with no real issues.

> From the tiering perspective, we need to accept "zswap" as a possible
> tier, or maybe creating it as a tier by default if zswap is configured
> would be better to avoid handling the case where the user doesn't
> create a tier for zswap. We also need to disallow zswap being the only
> tier as that combination cannot work without vswap.

I tried to forbid this at the implementation level as you suggested
, and that is where I ran into trouble. 
A few code paths can end up with zswap as the only
tier, and they are awkward to handle.  Below is each case and what
handling it would take:

1) A write turns off the last device tier while zswap stays on.
   -> rejected with -EINVAL.  The write does not take effect.

2) The last device tier is removed via /sys/kernel/mm/swap/tiers.
   -> the file goes empty, so zswap is not shown either.

3) A cgroup has zswap and one device tier on, and that tier is removed.
   -> the cgroup's zswap entry is reset to 0, which the user never
      asked for.

4) A cgroup has zswap and device tiers on, and swapoff empties them.
   -> the cgroup's zswap entry is reset to 0.

So the problem is that in (3) and (4), memory.swap.tiers.max has to
change on its own independently of what the user wrote 
and it is not like just error handling situation as (1). 

There is also a consistency point.  memory.swap.tiers.max already
accepts a child enabling a tier that its parent has disabled: the write
succeeds, no error is returned, and the difference is resolved
internally.  The user's setting is kept as written, and only the
effective behavior is constrained.  By that logic, accepting a
zswap-only setting and guaranteeing only that it cannot do anything
would fit how the interface already behaves.

Having thought it over, I think one of these two directions would be
better than enforcing the rule as above.

1. Allow zswap-only in memory.swap.tiers.max.  As you say, it cannot
   work without vswap, so today the setting does nothing and there is
   nothing to prevent.  Once vswap/xswap lands it becomes meaningful on its
   own, with no interface change needed.

2. Expose memory.swap.tiers.max.effective, like cpuset.  We already
   track the user-set and the effective-set separately.  Exposing
   the effective one would show that a zswap-only setting is not in
   effect, giving the user visibility instead of rewriting what they
   wrote.  It would also help the parent-off/child-on case, where the
   child could see from the effective value that the tier is off.

What do you think? or any other ideas?

Thanks,
Youngjun

