Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2935FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D3D6B0005; Tue, 14 Jul 2026 16:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74186B008A; Tue, 14 Jul 2026 16:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8CC36B008C; Tue, 14 Jul 2026 16:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACD876B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:44:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 489CE1C04FA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:44:38 +0000 (UTC)
X-FDA: 84988560636.20.764A675
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 684ABA0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:44:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VM14Fzrv;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784061876;
	b=RyBr2ZEG5vQCV7jiJL6rQa+dD11ALczzHdh5SEcK2W/poHcviBvm4jnhkT3wofO7vhArno
	f3tRi/PM9IDd5Eeq15Qo1yDsMLuLJYtJIeceTHA+bN2Q5m1ovVajJbxj6nayRcu4K4gTA9
	mmmnwymBfZdImmJdMGudEQCoa5iWKNU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VM14Fzrv;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784061876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RkI2sO9yZj8cmAzvmTm/IbUcZKQV9FT/HcmLICp+GM=;
	b=a032rGfB8wXXLVKZalWaB1aYY8Lt8wOGmvGzZeogbLm3jr2vhYD/X1bFLA9z7zQ/ZDbAuD
	/uqw8zY+pIY6mfHysQjjvesIYXqhLrbKOmLplkJTX4tUu73F7MqP0ou/zMifIHPipx05nU
	rFFA2LXEPZof7NngUDvvjcLpbr0XFfQ=
Date: Tue, 14 Jul 2026 13:44:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784061874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RkI2sO9yZj8cmAzvmTm/IbUcZKQV9FT/HcmLICp+GM=;
	b=VM14FzrvtM74reto72dbQHA46p1dBJffJFJ6TCnZFkbTix0p8Y8gDPUefUaspl77mI123m
	yj4e4kQ1hVDRknPqoNlSZQ2dTNC6zG6QUTibcPd/i9VGrTvVOwEW2DjFlAZiIqnaSNdTt+
	JYv+nsiZY4XeBaX93fc1jJvzoSRXz34=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, 
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alae-LIRwEFUjgs1@linux.dev>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 684ABA0005
X-Stat-Signature: eip3e1mgzcqcsday7pctg5td9sq1io4w
X-HE-Tag: 1784061876-322823
X-HE-Meta: U2FsdGVkX1/gKcoxVDTs36gfVdwmEyutK8UiCotgroEko9ryMcO+0BIlTsefhJM43WpvJiUyNM/IlXi6KM1qJ21EfQlm/98ewhK2xeUKs0+C2sYNq62LJq8ihxZR5cYHAwklV21at17jFIO6CJLNUWDIs1ZL3VLPIRsQcmRK7c1JVoIzmYCj2NxrNuexlPeMh10sRTmI6ETwoZ7FwzKR/9cbo+q6X3e0nhcMw08idP0wQN01sOMT419TKdBmfyd24N5eGbPyY3hyw0WXFGpe60w9DIo8UkMdAmY/m/1VqMs5BYLzN34lefYopWQRv/KCvzz9DkkTDpRY+lnpfP/UPhRCvcZYG1yJInzGNdI4KDdyadqKsmEfun51IhSsukgrtsB5Kz1+qe9dJZGYzFMTkDHOqnagvNu7eb38xbIy9B4Cj3JLkpmmUz+DbT3JdkvajL49Ahs0tuewDtVLsv0JdIrH4q6MlhswLbFzQJdGp/DC4laq+ZyG4SJP6jRF4P50b1bJrEIOl4bzIEx5jWP/89Cg6SPw/M8ShFG/DnD+IFiRhuMnxrP73M8jbsQjzFa6LWjAH+VinkoGvmcy3oEOgqwfbKXvNmmWBp4D//mngKiDCl+w7/IqVPTGjTkgY4JXov3O8CG3dlPbnQhLfg23rpNEHs8q4zZ9l6PYg1f+ZOAE39ShaGAMtbExcSJlK+vB3vEKp/GZs6KVxmDMcdAcf/FuZU3RBEsvAWvCNiu0FQ2Y8zNBLaJvtf0BE/UzEnDp+HALXhPWDy+khtrzlQlIo4RrzTIiRpW5vQmW20EVwFwwgx9f9/ssi2Jv+IJtKrm+4SqmEnD3LSVikaKigsYsePQBJJwyvQN1gGo0AnXL0YhjiHjmGqobKAUHI9Q/PolKc31Dt9Q0YBzvbDPzDNV8KMYakcuWHp2+21iP0uaYfakdoLiPe6YhaU5eOZ0czS9mMmRMe90dd6HSIF+dPXu
 2WrRZR7e
 uU8EsplkmeQfEUzHkazq8zVXhLIZpyFyl4ERXWjhhd8RKcnd158DRt6pqY/Zl+0/xrXK+6K0ySPJ1qZJRWjGVJV7zKHR/LSzy/aT2WXSK7uayf9CnqPauvuHnEJ6y0atACSPCEkhlcN4zJApmgXQlGHhxe3vKcPTKInwEh6GB7F8j4cfADjUunKJDWBpfBoIAF3gImtBvNSbuw4CE1zcFhDG5KTgYcbuBh59DLNKHlWiqPDl9SffZxdVDwadmYsnVt968L/saII1Qxjjyln+oQ3qzScopWktzPn2fa9JmRTkm6IrHRr85HBRAwSN+qlu5aLc1TSOYF1Yw6LMmd4a/c5vcQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

Thanks for keep pushing this effort.

On Tue, Jul 14, 2026 at 01:22:42AM +0900, Youngjun Park wrote:
> On Mon, Jul 13, 2026 at 09:01:20AM -0700, Yosry Ahmed wrote:
> > On Mon, Jul 13, 2026 at 8:57 AM Youngjun Park <youngjun.park@lge.com> wrote:
> > >
> > > On Mon, Jul 13, 2026 at 08:50:36AM -0700, Yosry Ahmed wrote:
> > > > On Sun, Jul 12, 2026 at 7:57 PM Youngjun Park <youngjun.park@lge.com> wrote:
> > > > >
> > > > > This is the v10 series of the swap tier patchset.
> > > > >
> > > > > v10 folds in the Sashiko review fixes for the selftests added in v9 and
> > > > > rebases onto the current mm-new. There are no functional changes to the
> > > > > core swap or memcg code since v9; see the changelog for details.
> > > > >
> > > > > For context, the bulk of the series is unchanged since v8, with great thanks
> > > > > to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped it.
> > > > > The main change in v8 was the interface change to use memory.swap.tiers.max
> > > > > with '0' (disable) and 'max' (enable) values. This mechanism was suggested
> > > > > by Shakeel and Yosry.
> > > > >
> > > > > This change allows for future extensions to control swap between tiers and
> > > > > aligns better with existing memcg interfaces. It is confined to patch #3's
> > > > > user-facing interface; internally, patch #3 still uses the existing mask
> > > > > processing method, which is implementation-efficient.
> > > > >
> > > > > We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for their
> > > > > valuable feedback.
> > > > >
> > > > > Here is a brief summary of our tentative conclusions. Please correct me
> > > > > if anything is misrepresented (details in references):
> > > > >
> > > > > * Zswap tiering [2]:
> > > > >   Zswap can itself be a tier (typically the fastest one). But, until vswap lands,
> > > > >   zswap cannot be the only allowed tier,
> > > > >   since it still needs a physical device for allocation;
> > > > >   that restriction can be lifted once vswap is supported.
> > > >
> > > > Does this series support zswap being a tier? I cannot find any mention
> > > > of zswap in the patches.
> > >
> > > Hello Yosry!
> > >
> > > This series does not cover zswap as a tier yet.
> > >
> > > My plan is to land the swap tier infrastructure together with the
> > > first use case (cgroup-based swap control) first, and then follow
> > > up with zswap tier support in a subsequent series, continuing the
> > > discussions we've had above.
> > > (I mentioned on cover letter, right above the overview section)
> > >
> > > Does that approach sound reasonable to you?
> > 
> > How does swap tiering work with zswap in the current series? I assume
> > zswap is just enabled for all devices in all tiers?
> 
> Yes, that's correct.
> 
> > I wonder if introducing zswap as a tier after the fact changes user-visible
> > behavior. I guess if zswap will be introduced with a default "max"
> > value it will more-or-less be the same behavior,
> 
> Right, that's the plan.
> 
> > but I would check all
> > user-visible behaviors related to zswap (e.g. interaction with other
> > zswap interfaces) to make sure nothing breaks or changes in a
> > meaningful way when zswap is introduced as a tier later.
> 
> Fair point. Let me review this more and get back to you!

Please do report back what you find.

Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
requirements for that? If that is not too much, we can make that part of this
series.

Shakeel

