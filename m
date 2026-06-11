Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE82CCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 19:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE46C6B0005; Thu, 11 Jun 2026 15:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95B76B0088; Thu, 11 Jun 2026 15:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB196B008C; Thu, 11 Jun 2026 15:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8C906B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:12:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E9101407C5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:12:54 +0000 (UTC)
X-FDA: 84868579068.04.1735B59
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 17879A0002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:12:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Uc8i2xo0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781205172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/dpbNb5biEC/ytKDW9uZGewAoGZBA0EolTNHIvaZZk=;
	b=AqqMQ81omtUdMdLe7qVuukcWJkl18BzXpVbmO9BjwUOffFF/I8mJEVhyTeNZlVSrcSYGxC
	l9BxyV6ZhBfeOX212Th5vR6kVJPd0Hd1Uw7irXAQBYsIOg9gGxzY6oUVoyGLqZeEW+FdP5
	riguD+t1+Tt3veYuTzm09vY5+D0R1ew=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Uc8i2xo0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781205172;
	b=4UoJ4qEEodpudGPRK60FOlrIqQQefo3HvdVv/H9M/7VcmeMO7RyHCQ3kq/jYheeZhLRjHP
	QZ259Q2gXB4tDQW6oZnAAgP1a2bk7NXWwRgPyRZzjduEWPuyQFoHqNF8QMGPH3CliVJP0d
	uXnnHehmR9LjdnKWbUhgiQQ5HmawXBE=
Date: Thu, 11 Jun 2026 12:12:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781205169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W/dpbNb5biEC/ytKDW9uZGewAoGZBA0EolTNHIvaZZk=;
	b=Uc8i2xo0DpuSALr6ftYCaW+0Z/S4F6T6le8Fv3+0J0wM8ZOvUTo604t7eekw5yBWEE74rT
	1XToLGi4nkYSHnJ80iLFsNqN3yK320JIhhs0M1Kby8elC+hHeVYnHdf+3YGO5abK9j1c0Z
	i7Yrj0r9Y69Sjt0cQrqNNPoUtcAyeyM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: YoungJun Park <youngjun.park@lge.com>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, 
	chrisl@kernel.org, kasong@tencent.com, baoquan.he@linux.dev
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aisEWnb3pzmVC4dl@linux.dev>
References: <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev>
 <aicZ-5GX9De3MAU7@linux.dev>
 <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
 <airzE7jD9UtyR17J@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <airzE7jD9UtyR17J@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 17879A0002
X-Stat-Signature: 9qzxgjy54gk7fwe8pohhoe1eznjbw3oq
X-HE-Tag: 1781205171-438927
X-HE-Meta: U2FsdGVkX19aFO4efkqy7Tt5cHDXzVfM/ECDGR08iSLXgmH2nDr+fmeDDXETbNR1DGpXwNep00Knh9Yd7oeEFW3XMDBJK9f9WxYEhvRuDMceYJurlDIYD34KHKnTwhsCMh05Ot5UxIO9UU4dtVhiWuskeq+ch57Ut31SCt2esomtWRFX+nTPzsmgNuYbuKUahaNoF1lpoxrqv+3HdhhmgS9EefRO7nWRgQIOG1AdVekqLgr07I43DO+htD+omc0rP3zYoZtJiOo97CmjdjNo/3kGPs94kYvLxIgjF9jJ7w4TFAVh2KhCeM5rsCAZ127VWmlZHLngvM8h4fcpnpijQ06ha4dgjJDkQLN75zd0o5zWu/NCg9ZGDj5xCaesR1fDBWmA+xARQVeyX7U0B+xz0qtpjrWBI/J6ZVFx3cp0vimvqvRqjka8WLU74Aojgbfk0quWI052wJoHkmnxMe88gNfdA9Ha6yvAWqth4bxFb/Q5BnBNt1IDYPUV19Nk4Yb12xG0YyAukB5o6BOQTSk+PR35msU2McPWGk1br+fS6C4SsalARHaradkpdW9EPoIzUNVXjGgpexfWcUZMTPZx4Vp+02Vl8mrPbjfEAZ5/x97PdZ5wFwZhTqjxwpYKbBZCJmHgJtTq7Lr0JLHZBQyl7/XtZ6zr2QYqqWppJVCAmVrbt5KX6f+wbpBwYALoe6zmI//C0So5LbsL6dIP2mvuz7x4+Ex9K+UiMFrtD+VKNX/MTywJNKLX2hIA8OIV9fCHDYKont7WnZB3g5oTz6y4rDKbqqF3EWLluUD6agh9vuUXpF28fg03Df7Yn7BibdqlhNnSwAeatsg6JtNBdtO00KBKvMtlUipuYGE5RQjc/UyBm6OFm+ZozMiMKDc8m6ymMhsP8OLoez6n7114YzgEVKtC4OkH0qiM/jUmkKMDOjZBuS/wAy977YGkTxsJ1cFGP8yoGG8Hscjq5zA0i8R
 xrjtPMt5
 p8/OJ/t+xl+d8nTwFHpWYWQvUMMtQwXOLHH6to1/SZ2pbGr0kdyP1djfVgh9bxxuPAerWUgTadK/JVY9brkWeJK+x7BwmJAmfDNAzyeRNrDtbjeJmrKdJFX2JmkfISfM31GrFqOJbjs56rntqfvo05lsxYvwizIhXl4bVS8+yRWgMMhgS7goP5Ykbnngc4z8w8oezASg1inOX4iglr/KRroidfBBHSkMWSZPB2nqzNgil/GD6MYwawySumjO9uDfr3PBYKJYk20ox1TBmLj/v7phghw/m3Vi1vCn7RNtht4PPhxdAKSQxMa64L5VF8RmOZuej98/yYBsefUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 05:45:04PM +0000, Yosry Ahmed wrote:
> On Tue, Jun 09, 2026 at 01:19:13PM +0900, YoungJun Park wrote:
> > On Mon, Jun 08, 2026 at 03:27:07PM -0700, Yosry Ahmed wrote:
> > 
> > +Chris +Kairui +Baoquan
> > 
> > Hello
> > 
> > Thanks for inviting me to the discussion, Shakeel.
> > 
> > > > > > Youngjun is working on swap tiers. At the moment he is more interested in
> > > > > > allowing a specific swap device to a memcg or not. I can imagine in future there
> > > > > > will be use-cases where there will be a need to demote data on higher tier swap
> > > > > > to lower tier swap. What would be the appropriate interface?
> > 
> > Speaking of my work on swap tiers, I recently submitted a patch and am
> > currently considering memcg integration:
> > https://lore.kernel.org/linux-mm/20260527062247.3440692-1-youngjun.park@lge.com/
> > 
> > The future use-cases imagined above seem to align with this
> > direction. (BTW, I am currently waiting for reviews/feedback from the memcg
> > folks on this patch. Any reviews would be highly appreciated!)
> > 
> > We could potentially assign a target tier
> > for writeback within the existing memory.zswap.writeback interface. 
> > 
> > For instance, '0' could mean disabled, while non-zero values could represent
> > specific tiers, which would maintain backward compatibility with the current
> > version. Alternatively, if zswap is treated as the default top tier, 
> > the `memory.swap.tiers` interface could potentially replace `memory.zswap.writeback`.
> > 
> > Furthermore, this could be expanded so that each swap tier can demote data
> > user-triggered demotion between swap tiers.
> > 
> > Based on the current patch's ideas combined with my swap tiers concept:
> > 
> > Assuming a hierarchy like:
> > zswap -> tier1 (SSD swap) -> tier2 (HDD swap) -> tier3 (Network swap)
> > 
> > We could configure the active tiers via a setting like `memory.swap.tiers`
> > (tier2 enabled, tier3 enabled).
> > 
> > For example, the concept of `echo "100M zswap_writeback_only > memory.reclaim"`
> > could be extended. A user could run `echo "100M tier2 > memory.reclaim"`
> > to explicitly trigger demotion from tier2 to tier3.
> > (BTW, if we combine these features, my personal preference for the keyword
> > format would be `<size> <demote_prefix><tier_name>`. I think it would be
> > better to explicitly indicate that it is a swap demotion by using a specific
> > prefix followed by the tier name. 
> > Or make demote prefix another key is also possible)
> 
> I am not sure if proactive demotion between swap tiers would be driven
> by memory.reclaim, I am guessing a new interface might be more suitable.
> But yes, you are right that it's very possible that
> 'zswap_writeback_only' with memory.reclaim will become obsolete once
> swap tiering matures and starts supporting things like proactive
> demotion.
> 
> Part of me wants to wait until the swap tiering interfaces are figured
> out so that we don't end up with redundant interfaces, but I also don't
> want to hold Hao's work since it doesn't directly depend on swap
> tiering.
> 
> Shakeel, how do you want to handle this? I think there's a few options:
> 
> 1. Add zswap_writeback_only now, and when we have swap tiering demotion
> it becomes a redundant interface, like memory.zswap.writeback -- or
> maybe we try to deprecate both of them at that point. It's difficult to
> remove interfaces tho, but maybe easier to stop supporting
> zswap_writeback_only.
> 
> 2. Add zswap_writeback_only behind an experimental config option, to
> unblock development but have a line of sight to dropping support once we
> have a swap tiering interface.
> 
> 3. Wait until we figure out the swap tiering interfaces and then add
> the proactive zswap writeback as part of it.
> 
> WDYT?

Is Hao's work needed for some followup work/development? The earliest Hao's
work can is 7.3, so if we aim to figure out swap tiering interfaces in next
couple of weeks then option 3 is the way to go. If swap tiers take more time
then we can discuss other options as well.

However I would need zswap folks (Yosry & Nhat) help in figuring out swap tiers
interfaces. Zswap is the current top tier swap usage in real world. I want
zswap users to eaily (and hopefully transparently) migrate to swap tiers.

