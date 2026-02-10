Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D18EB2718
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099806B0005; Tue, 10 Feb 2026 16:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043BA6B0089; Tue, 10 Feb 2026 16:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88746B008A; Tue, 10 Feb 2026 16:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D80DC6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:24:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A9BB1407DB
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:24:18 +0000 (UTC)
X-FDA: 84429825396.18.200B618
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85887C0013
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:24:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ql6bLMuZ;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770758656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pWZ+p2ceSr3CNx2N+ya3LDY+vSM3JLrFsXqd3CbSWo=;
	b=y2v/c7TBJhF2rvjW0lKilG8D9lX9gtza4iCqAmcsA7soOjeNUsLepe3ItxjN/so7gb3ARu
	Hmi6DiN8GLtHB8wnIW5Nv6f5AepAQ5vHuSUx6UjuYmqFeT++WRV0DzWXM0GB2Ii/cGkv9Z
	7iLI6GifKGzYO9YqaR4JWhkaTQXl5y8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ql6bLMuZ;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770758656; a=rsa-sha256;
	cv=none;
	b=TARQ/OH3NP78EMaI0dXkPmYRcmA8drpxW537P2DBtJTTsmFNtLaNyga+rZgY2v+jDJtUSb
	6UpfKb1JICGXrLmtZijJqxJem9B8Cqn0We1A+WubBrUrVC3C5zezu7UK0HdZdYWWuzbdAi
	4CkvxoXhcwU9Vt3F/ODR1eoorU3l2Bs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0C4B6014A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F6AC2BCB6
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770758655;
	bh=XFOqVKonzJIvX2M80FEWCluKWLmbrP9Xp5QWqG/BvAo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ql6bLMuZPJmRGsTuyEa+77lXrv1YJk9kcYvkFL67RIALVmN8bkWSfCgO7i8V/1G5J
	 5usIlHhWzUIGF9rEcGiNJ1UM7nqwNnqMZbTYP6+KKK94UGJiermuxHyyWgJnXVOGhe
	 4VMq7VPXLh+eZAuHBmyK5AZHmVqzsxWGqVoNWdRkWPPXgZlyv7L0v0lbQGzuheLYTe
	 0J7qyGwueuYZiUtK3Q9bcYnf9vN1Tw2XiZL/0HAQ9CVgMNBhRPPHXaTq6t5NVTB56t
	 05GlUoVm+xB0/asIaUG7YFjOIG1KIBGr075txHXWPj7IwpH+yVU/v8OOTG4ps0fxVo
	 gTLYs0nyMrcHg==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-794fe698e36so13985937b3.2
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:24:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVGfB7k6YG59YVmwEkWrqtImmQ7fW6iExSSimDLrj1cVJVEER86nzHNLvH5kOh8bVCFBAowglKfzA==@kvack.org
X-Gm-Message-State: AOJu0Yyq/W6fYSGL5GACJx1icga8nxSXkP7+14nYveomfl+8sxQf2PAp
	p1gHyUn9QqgxrvGAIy+YV86eqheZ4nsnXBR3P2L6FBlCNiYVU/8MMQ/B6aUEZHT3r2Pyk7G5nY9
	s7z3H2a76siE+Ydoys2bPybtPs0jQeDJ/ytvbt/Cbgg==
X-Received: by 2002:a05:690c:55c7:20b0:787:ffc0:40c7 with SMTP id
 00721157ae682-7952ab8a9d0mr122001867b3.68.1770758654505; Tue, 10 Feb 2026
 13:24:14 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-2-nphamcs@gmail.com> <20260208223143.366416-1-nphamcs@gmail.com>
 <CACePvbXsngZmn0OrJZjvMhhHnL5FazxYX7ShEpbU9RwHSJaUuA@mail.gmail.com> <aYqZppn4yDbTP2_q@cmpxchg.org>
In-Reply-To: <aYqZppn4yDbTP2_q@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 10 Feb 2026 13:24:03 -0800
X-Gmail-Original-Message-ID: <CACePvbWnJFkMOtX8LbL+0hm5RP6jD5nfZcYUyxrJsPNTq0vbPg@mail.gmail.com>
X-Gm-Features: AZwV_Qjcbo9saS4Hk5tJX7q1wTM6Ct_T44mYK2YA18JDo-CVVbZphMtbeIM4Ar8
Message-ID: <CACePvbWnJFkMOtX8LbL+0hm5RP6jD5nfZcYUyxrJsPNTq0vbPg@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, hughd@google.com, 
	yosry.ahmed@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, len.brown@intel.com, 
	chengming.zhou@linux.dev, kasong@tencent.com, huang.ying.caritas@gmail.com, 
	ryan.roberts@arm.com, shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk, 
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, linux-mm@kvack.org, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pxxe5zundm8e74ggzhmrd3xtd8868ezu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 85887C0013
X-HE-Tag: 1770758656-502701
X-HE-Meta: U2FsdGVkX18nil2R5Uoz8zXGzZAkBIiG6HijQqRS1lk6hNuABRgMm1AZpYOkpzG/YHm/WLy2BDVBdPYuD/PRRILmncYeKdNdw9MapzauFBWqmACQ7mgEG6AlYUqJCdmxjT8mopJp55X7cp0nC18xCTGZAddgfTEm6BET3/hITYHM/M1HNun6gxl9eQAP06dXT7UwmXkNXdh0vXItnmPW7iaJVFfMVOVM5SLiiJdubPFV36cg1Bm6E+r0wuyRYMb4hlg+Tk4OfgraDZnAtQ5JGmisEz/P7Z516BxuwYVkHQLKtvAtfkEIsBC9HKZTVtv7jdIPl8eUWPeBYHiUqPlPOH802swVZa44mpRheVaHPOFn0Vc8ovXGOePKyPPXSU2Gxy5hv3lFAQSaYiRbNvGsFhsoW/uxNpiUL/nt9Zcpd5NwblhSrx9s+iWxi02SsC3Q9gqQ07I3nZDQZMH5VKTqaikgPSRy/2aBp7O+S1NqqQ72kM5genNBOmXstFQ1e8BpTz9he4ismhWAXnzOW/SzbM3ZribrlGeG0oqJVigJBW4w0fx0bcKwgI9q06kNv5xZmeZ7v2DSeKmh/mULdHN8ThUuAqIp3fdxS/K7hfk1D5wVQIdDp02a3gWVXAk4EyjrM01cmsLHSt3B36g1COqnbDHLr7BTBKSrBmmpcReAeGcXZOHaa2B5ZYhLUuJBx0mVqnAO1UvZuQQ7z2amy4WQKCsdTUPM17MiCIqJBAsRUOYsbdS1yt2ojiD8tM441rqpWKGm0+tsaIBgigqc3qV3Xo0CbWsCsKJkTooNKgo9MTCMqzmexoZc6Ux6tb/NbaWX1rPATsBKev/qBs+R9po31JPR/eTLBNN26vpsvijFAsNDQzOlehfWaokFvoiPYRqGzJdocZoNsIrw0Yyj+6/FwBue/1raCblL7fCzFwHH92sJeyc7jEC0WbNC3shXihUeLfY7r5T7EpaSatDcnZm
 ti1I4TUj
 d5IH21zUQUs4bfmLlnTkQ2mjWFg8EKtLfd+gtqRumuM5WrXdMRVGbpflPyA8jahtchsR8cUN3g+hBHrXZrd34mQ78ECLPJsPTYhDKUCUcUu/8Y1sfNvaiu79uKAnsKCNA1kUZVYGXt0DgBQFeMTHQhPjYLwzsz7re5A0GlsQ4Tbp26eeDFqAz6QlSVMOpojKjrQJxVvBEGS2zCYFdsEhBY5nSjt4UwB5AxZE65dlM8UTmft5rswU4ss3bR8zddGQDfUl0JbFl9V27z2x4fsT4Z7+QqwO51PFndLD9VepXqncxa0aynDmFH4JFOnyWMg8Hzv80imHp68I0rnw4kXcAMX2nhgnlxDdoMebv7NVRKDB6AN503gowcOM/l3FWtuF9rJXgL07Cvoa61OUB9CEYFDNlfBfUHRUUKjxF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Johannes,

On Mon, Feb 9, 2026 at 6:36=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> Hi Chris,
>
> On Mon, Feb 09, 2026 at 04:20:21AM -0800, Chris Li wrote:
> > Is the per swap slot entry overhead 24 bytes in your implementation?
> > The current swap overhead is 3 static +8 dynamic, your 24 dynamic is a
> > big jump. You can argue that 8->24 is not a big jump . But it is an
> > unnecessary price compared to the alternatives, which is 8 dynamic +
> > 4(optional redirect).
>
> No, this is not the net overhead.

I am talking about the total metadata overhead per swap entry. Not net.

> The descriptor consolidates and eliminates several other data
> structures.

Adding members previously not there and making some members bigger
along the way. For example, the swap_map from 1 byte to a 4 byte
count.

>
> Here is the more detailed breakdown:

It seems you did not finish your sentence before sending your reply.

Anyway, I saw the total per swap entry overhead bump to 24 bytes
dynamic. Let me know what is the correct number for VS if you
disagree.

Chris

> > > The size of the virtual swap descriptor is 24 bytes. Note that this i=
s
> > > not all "new" overhead, as the swap descriptor will replace:
> > > * the swap_cgroup arrays (one per swap type) in the old design, which
> > >   is a massive source of static memory overhead. With the new design,
> > >   it is only allocated for used clusters.
> > > * the swap tables, which holds the swap cache and workingset shadows.
> > > * the zeromap bitmap, which is a bitmap of physical swap slots to
> > >   indicate whether the swapped out page is zero-filled or not.
> > > * huge chunk of the swap_map. The swap_map is now replaced by 2 bitma=
ps,
> > >   one for allocated slots, and one for bad slots, representing 3 poss=
ible
> > >   states of a slot on the swapfile: allocated, free, and bad.
> > > * the zswap tree.
> > >
> > > So, in terms of additional memory overhead:
> > > * For zswap entries, the added memory overhead is rather minimal. The
> > >   new indirection pointer neatly replaces the existing zswap tree.
> > >   We really only incur less than one word of overhead for swap count
> > >   blow up (since we no longer use swap continuation) and the swap typ=
e.
> > > * For physical swap entries, the new design will impose fewer than 3 =
words
> > >   memory overhead. However, as noted above this overhead is only for
> > >   actively used swap entries, whereas in the current design the overh=
ead is
> > >   static (including the swap cgroup array for example).
> > >
> > >   The primary victim of this overhead will be zram users. However, as
> > >   zswap now no longer takes up disk space, zram users can consider
> > >   switching to zswap (which, as a bonus, has a lot of useful features
> > >   out of the box, such as cgroup tracking, dynamic zswap pool sizing,
> > >   LRU-ordering writeback, etc.).
> > >
> > > For a more concrete example, suppose we have a 32 GB swapfile (i.e.
> > > 8,388,608 swap entries), and we use zswap.
> > >
> > > 0% usage, or 0 entries: 0.00 MB
> > > * Old design total overhead: 25.00 MB
> > > * Vswap total overhead: 0.00 MB
> > >
> > > 25% usage, or 2,097,152 entries:
> > > * Old design total overhead: 57.00 MB
> > > * Vswap total overhead: 48.25 MB
> > >
> > > 50% usage, or 4,194,304 entries:
> > > * Old design total overhead: 89.00 MB
> > > * Vswap total overhead: 96.50 MB
> > >
> > > 75% usage, or 6,291,456 entries:
> > > * Old design total overhead: 121.00 MB
> > > * Vswap total overhead: 144.75 MB
> > >
> > > 100% usage, or 8,388,608 entries:
> > > * Old design total overhead: 153.00 MB
> > > * Vswap total overhead: 193.00 MB
> > >
> > > So even in the worst case scenario for virtual swap, i.e when we
> > > somehow have an oracle to correctly size the swapfile for zswap
> > > pool to 32 GB, the added overhead is only 40 MB, which is a mere
> > > 0.12% of the total swapfile :)
> > >
> > > In practice, the overhead will be closer to the 50-75% usage case, as
> > > systems tend to leave swap headroom for pathological events or sudden
> > > spikes in memory requirements. The added overhead in these cases are
> > > practically neglible. And in deployments where swapfiles for zswap
> > > are previously sparsely used, switching over to virtual swap will
> > > actually reduce memory overhead.
> > >
> > > Doing the same math for the disk swap, which is the worst case for
> > > virtual swap in terms of swap backends:
> > >
> > > 0% usage, or 0 entries: 0.00 MB
> > > * Old design total overhead: 25.00 MB
> > > * Vswap total overhead: 2.00 MB
> > >
> > > 25% usage, or 2,097,152 entries:
> > > * Old design total overhead: 41.00 MB
> > > * Vswap total overhead: 66.25 MB
> > >
> > > 50% usage, or 4,194,304 entries:
> > > * Old design total overhead: 57.00 MB
> > > * Vswap total overhead: 130.50 MB
> > >
> > > 75% usage, or 6,291,456 entries:
> > > * Old design total overhead: 73.00 MB
> > > * Vswap total overhead: 194.75 MB
> > >
> > > 100% usage, or 8,388,608 entries:
> > > * Old design total overhead: 89.00 MB
> > > * Vswap total overhead: 259.00 MB
> > >
> > > The added overhead is 170MB, which is 0.5% of the total swapfile size=
,
> > > again in the worst case when we have a sizing oracle.

