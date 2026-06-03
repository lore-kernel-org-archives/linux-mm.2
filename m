Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10697CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D45E6B00AF; Wed,  3 Jun 2026 14:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484936B00B0; Wed,  3 Jun 2026 14:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373506B00B1; Wed,  3 Jun 2026 14:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21A2B6B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:58:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B278116310D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:58:56 +0000 (UTC)
X-FDA: 84839513472.29.B9F7D57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F03A514000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:58:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGsrNp4V;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780513135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7NW7GBbndKKy+0XI/JSnMfnKxb8c9R/OkuZ5OvLGXI=;
	b=Y3BfiO/2FRCgZC8N5WlbhjT33ypolz+rc2B/ZJQKGjR59ujgfKcgJWPnqicsgB76WJOB+q
	KBSOBoP7yMjEhx7s554IPrR1U4q1XvHfdJGG4bm6JE8GLhhpDSfEFLszG5HFUfCuI1LV+T
	MKnwoDzKFp5EUx62PuTvUubHWDSTn1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780513135;
	b=SX9sEGWpRzddU2y/hgfTuMMSUGsnXJQ4ys0V/czXZfAaEQ35ohtlFNbKiAJJtdny+pPmeJ
	XU0n/xndFUBo8U4mRp5jUQCmUAR0OFK0qweN9QLUs/xE1+WVKHCUILaKQW/sAimnADJ4WJ
	y5jK9fxWOewLHx+w9WStTH0xZVL8GOM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGsrNp4V;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C05C406E5;
	Wed,  3 Jun 2026 18:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E559A1F00893;
	Wed,  3 Jun 2026 18:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780513133;
	bh=U7NW7GBbndKKy+0XI/JSnMfnKxb8c9R/OkuZ5OvLGXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FGsrNp4Vc2QMRZcccyTX2RnTiuRZ0l5wgp2+kPbOnGRkZHVclJobF4pcYjuyt4H0J
	 Q+8jplS7HCL/TPG/UEWSqpFougpcC07AxrW4FNJEgy8Wuw0YVNVJIp9D06lIhl/xBL
	 7oV2LJZRP/i54zmx+8j5y0I5EdINUQh89qMMotviHkrYDGrsCiir9khVNVlvat+f5c
	 8Iw5tjqYi2zGEy4tEDKkpBZ+eY55Ce+aT/Sz8qzZGqj4QBBe13WSI8yLMualo2KMhs
	 stVjTHlcVqE58+WKekHjLX0IVOb0nCE2lgVOg1tik7I5u+c/5WrcUtCl28scHSAfM2
	 Ac+upOUDWzP4w==
Date: Wed, 3 Jun 2026 18:58:50 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org, 
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com, 
	kernel-team@meta.com, riel@surriel.com, haowenchao22@gmail.com
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
Message-ID: <aiB2sHqxcBAJrTkP@google.com>
References: <20260528212955.1912856-1-nphamcs@gmail.com>
 <ah-A2gQ0GPgerXop@google.com>
 <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
X-Rspamd-Queue-Id: F03A514000D
X-Rspam-User: 
X-Stat-Signature: eubc377zgz1grdeaee9mhxqx4czmgpd1
X-Rspamd-Server: rspam08
X-HE-Tag: 1780513134-730741
X-HE-Meta: U2FsdGVkX1+LJAOmSA2LAleUeefJA0E8cuzRVCSwXcb7OZu3PKe9Sew05XQOIDJYXBNKdYuybcLJcV7cH7iSIjWg7Y0coTD+xJp9YGnugvl4Kxdq6r9w95wzm90chefmJHZ/28bYqL9n0XVm5EFvP2jRQmXNArnNLYHWvaerp6MbbmPWJexlmkG+J1aTSztliLnXRVsJaoB8Kqi24IRWUdoxTe24h2sjLvtXl+ly4WOilolyf5JPOJ35lY8W4ZwwJhq8mQD/4yb1R3ABpPo/cg2GLJ4BF8/7nabcRXH7/7dByOqjwe49bCK6hWlUmzXUBlMkA2e2iVNKNYtBRLI5XoYZnQz6uku766bILsI73QzcUUeOVDuBNIUcg2mHnHPz/DBumi57odB+4Q924QewTXQa+iBzP02wZrdmRawOIws+sNuBY4k36dlR2/clTYxJYFVN1feaqj13gwohIcEQK4ycOEMoCNieWTcQPSf2DnxfigiVNxJpmbSHbqxkzHpDV0nWtNAXyhiI3Wh8HZybS0r+QqkQFm+FGfUgS+zNKUlw/Z1dldxcZ1UogEygg0VAQ30nZbKtQUZAizJYUc0CBkj/w1h4oIuwv8J+Ux7p6X/b17STQTTsqiihZFVXojAc7+xVgg2yKOHVrICRxDPasTc4lvOBgEluwyTtOwDmNviJEYl19ijgMxHD3IWVssX2RywnRvclh84mn1Bye5fQ5Z2J/ex/WEO4OZtck4M5lK+C4qRBMSIdvvdrE/ck0hsHhvBz7VaGXPmCnMu2JvKLn5l1qo9ifSv4Zy2SBhd+mhV6iX+JNdczzgLx2mHtHdEhvWzbc8lYSR2HKDuw+LvNNlIeM6RzgnEH+CyNoyeyzXeQpRs6eTyMQKFHm2LbOgJfeNGHJbbaMyAZu4jTXEEzwPzGHwKmA3ypOD4Wk/iBSibt0Hwu1/82DxnLiWpMRYTjgJL4zyvuVmY3IS/YO/v
 YwNU9EK+
 yuplINpK2nFzjZNB1pBDNpZMe5o48GvPSf93lZXwiOuTd+sQz0BhbePQznyT4v6MHjzvk5mGnEuUmHYZB18DL4e3CgEmKslJcz1dq1JSLwWSEd8ByXQStBVND+yyrVF+OG0Vmzba1Da0fkK86XrExamGXkMmaXI1FBGxhCSEbY/0PlC1whpLquwOp4BCa+Fyr/RAXAYsmWwu7Pp7KIm8JkO57hm5t46az9krvULwGy9Xwev+6lj9jCfb8nXYO18tjzQJoWZB3kUtbNsmPajXqYlCB0KoA3tXjbMxKbf73p3wajl/Q32GVPEOZaJnMQhyPVY7F1OIP7zXkbG5Gsr9bI4h26Xn6DO/xUdl5R3o87m5BL0dbXCFkp1RIKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > I assume the main reason here is to avoid the extra overhead if
> > everything uses vswap, which would mainly be the reverse mapping
> > overhead? I guess there's also some simplicity that comes from reusing
> > the swap info infra as a whole, including the swap table.
> 
> Yeah it helps a lot that we don't have to rewrite the whole allocator
> and swap entry reference counting logic again :)

I specifically meant using a full swap info thing for the physical swap
device even when it's behind vswap. That seems like an overkill, and we
don't need things like the swap entry reference coutning. We probably
just need a bitmap and a reverse mapping.

So I am assuming the main reason why we are not doing that (at least for
now) is simplicity?

> >
> > I don't like that the code bifurcates for vswap vs. normal swap entries
> > though. Not sure if this is an issue that can be fixed with proper
> > abstractions to hide it, or if the design needs modifications. I was
> > honestly really hoping we don't end up with this. I was hoping that the
> > physical swap device no longer uses a full swap table and all, and
> > everything goes through vswap.
> >
> > I hoping that if redirection isn't needed (e.g. zswap is disabled),
> > vswap can directly encode the physical swap slot so that the reverse
> > mapping isn't needed -- so we avoid the overhead without keeping the
> > physical swap device using a fully-fledged swap table.
> 
> Can you expand on "vswap can directly encode the physical swap slot"?
> I'm not sure I follow here.

I meant that if redirection is not needed (e.g. zswap is disabled), then
instead of having a vswap device pointing at a physical swap device, we
can just the data (e.g. phyiscal swap slot) in the vswap device
directly. Then we don't need a full swap info thing and swap table for
the physical swap device.

This directly ties into my question above, about why we have a
fully-fledged swap info thing for the physical swap device when using
vswap.

> >
> > All that being said, perhaps I am too out of touch with the code to
> > realize it's simply not possible.
> >
> > Honestly, if the main reason we can't have a single swap table for vswap
> > is saving 8 bytes on the reverse mapping, it sounds like a weak-ish
> > argument, even if we can't optimize the reverse mapping away. But maybe
> > I am also out of touch with RAM prices :)
> 
> In terms of the space overhead I do agree, FWIW :)
> 
> I think the other concern is the indirection overhead with going
> through the xarray for every swap operation, hence the per-CPU vswap
> cluster lookup caching idea:
> 
> https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail.com/

Right, but we should already avoid the xarray with the swap table
design, right? We just have one swap table pointing to another
essentially?

> >
> > I at least hope that, the current design is not painting us into a
> > corner (e.g. through userspace interfaces), and we can still achieve a
> > vswap-for-all implementation in the future (maybe that's what you have
> > in mind already?).
> 
> That's still my plan. Operationally speaking, I want to make this
> completely transparent to users, with minimal to no performance
> overhead.

So if CONFIG_VSWAP is set all swap devices are vswap by default, right?
Would it help with testing if it's controlled by a boot param?

> 
> The next action item is to optimize for vswap-on-fast-swapfile case -
> that was Kairui's main concerns regarding performance. I spent a lot
> of time perfing and fixing issues for this case in v6. The issues with
> the most egregious effects and simplest fix (vswap-less
> swap-cache-only check for e.g) are already fixed in this new design,
> and eventually I will move the rest (lookup caching) and more to here.

So is the end goal to have vswap be the default rather than a special
swap device? It would certainly help to include some details about that.

> >
> > Aside from the swap code, the only sticking point for me is the logic
> > bifurcation in zswap. Why does zswap need to handle vswap vs. not vswap?
> > I thought the point of the design is to use vswap when zswap is used,
> > and otherwise use a normal swap table. In a way, one of the goals is to
> > make zswap a first class swap citizen, but it doesn't seem like we are
> > achieving that?
> 
> We already have all the machinery to make zswap completely
> independent. Right now, if you use vswap, you'll skip the zswap's
> internal xarray entirely, and just store a zswap entry in the virtual
> swap cluster's vtable.
> 
> I just haven't removed the old code for 2 reasons:
> 
> 1. Reduce the delta on this RFC, to ease the burden for reviewers (and
> definitely not because I'm lazy :P)
> 
> 2. The only other practical reason is so that we can let users compile
> with !CONFIG_VSWAP and still uses zswap on top of the old swapfile
> setup during the transition/experimentation period for now.
> 
> But logically and conceptually speaking, there is no reason I can come
> up with to use zswap on without vswap. The CPU indirection overhead is
> already partially there (since zswap uses an xarray) and further
> optimized (cluster loopup caching etc.), as well as the space overhead
> (vswap replaces the zswap xarray). I actually wrote a whole paragraph
> about how we should always go for vswap if we're using zswap, but then
> decide to remove it since there's no code for it yet.
> 
> If folks like it, what I can do is have CONFIG_ZSWAP depends on
> CONFIG_VSWAP, removes all the non-vswap logic, and call it a day? :)
> Then, on the swap allocation side, if vswap allocation fail and zswap
> writeback is disabled, we can error out early.

Hmm maybe we can keep it around for now and do that after vswap
stabilizes? It ultimately depend on how much complexity we maintain by
allowing both.

I think another problem is 32-bit, technically zswap can be used on
32-bit now, right? So vswap not supporitng 32-bit is a problem.

General question (for both zswap and general swap code), would a boot
param make implementation simpler? Right now we seem to key off the swap
device having the "vswap" flag, would it help if it was a runtime
constant?

