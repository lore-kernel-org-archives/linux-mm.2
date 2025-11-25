Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2256D0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B746B00A9; Tue, 25 Nov 2025 13:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B55E6B00B4; Tue, 25 Nov 2025 13:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DA06B00B5; Tue, 25 Nov 2025 13:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 130616B00A9
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:26:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B40031403A2
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:26:48 +0000 (UTC)
X-FDA: 84149960496.20.702CB1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E35218000E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:26:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vbdu0avW;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PBE8m8ys8JNPsn083xMZZuChpBUp1nSgqO0lI75GniA=;
	b=HMpI8KeZ/FzJoj5oCwUqZ+p39WqEdYSVc2iBNB9RwRm6Ujo7jSF0+TZsOJAqvmlaOQVBdc
	YURnB2iBn44Hx5BrzCMRqqvvI1QxAb85A/lSIfUZOfw+Xbjfj7PzMMoGMQofrpu5qzmVHR
	Wvtjycw9rlqEob0bZ379aJmxhgn12Nw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095206; a=rsa-sha256;
	cv=none;
	b=zQFvwLe+xXhKhIassJAHdxkL7bBZO3w648VZNqRET5DlqsN6uM21D0vT4KxSOd7Ljc6OVA
	slWSa3M7ex9h5z6ZsVjldYFnujmRgqqXcfVAlRHLNn1Gm/1WUBMQ1zujnMzF7nAT/TYYER
	Gf03DvqJKiZiV0CGzgWLtcDZhaBSPx0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vbdu0avW;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DFFD43C38
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E00C19424
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764095204;
	bh=g7TAyI5gc/uHAoEljLpxgsJJ4jTgDVOeBzTFzUm0uUg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Vbdu0avW4u9PMdN48D38zYidN3JT9YkGaYVtK7LtDv4Kvwi0wvOgES/BsJIHbjqbq
	 +CCypG8WxWTTagedGPeYE4lPB6Djxa2OKrr6q5jUfPSN7gMYRDAPpbrbmOPUYPjhBO
	 oquex9lxVE4zSdErJypqO6+6dMCtyEqGK9SsB3qqmPQSMa/xzeRtYCz9hr1TD3p7Wv
	 v8Q3k+5ywNp3K7D9HuC6Dr/C/7gEbHwqfEs6rDoiFDwtKQklykkT17rtkVoMcHO84d
	 v8ebqIVO8HkB7CXlCDbQBbSlLOySp2KbsTo75DjWIa506CEzNA7c8HWoO9ETH8Keco
	 PRsz8uHx4L7NA==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-641e9422473so4625289d50.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:26:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW4haADRJRYQaPyZexqKOie5KTPqOuGil+CF+G90mQvZADhjyK7Tncz92wC9tAtNT+YdRrycyiDEA==@kvack.org
X-Gm-Message-State: AOJu0Yx51dhJ6BK4HXIQAzgdIJKXn0wfsENL9DfqGYN0ZdKLgXxoSEZo
	vERyE09dEYC4TKu84aGgcWjucIare2Strm+WGFVVxaNhTQ8osLbMSk4H/GeWn/L8t5enkthhTAW
	34L53D47pgJZtzbIdQXV/ljN6BojR8rZXSt4JTBu+rA==
X-Google-Smtp-Source: AGHT+IEoyCQq9I1et1kShtfHxuQL5YK+Ww74bw8Prroe4gXTizcnGHhv0B/rFVIqzIeLcw93cUaDnB6Xg3glJxOG8to=
X-Received: by 2002:a05:690c:f83:b0:722:7a7f:537a with SMTP id
 00721157ae682-78ab6f01706mr60058987b3.38.1764095204090; Tue, 25 Nov 2025
 10:26:44 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <CAKEwX=PQM_4Mp75R4yeQ=WoqOxj7EJK=FpgcemNSYDS3fLXQLw@mail.gmail.com>
 <CACePvbUxCN_2fHz0Ds=u52mmOvdhonvRgm6mPdcJcs5qLZj55Q@mail.gmail.com> <CAKEwX=Ph6ynA8hRWchy2XeU2bB7ZSdcrZ-cu0X0KCgu8ZBfTVA@mail.gmail.com>
In-Reply-To: <CAKEwX=Ph6ynA8hRWchy2XeU2bB7ZSdcrZ-cu0X0KCgu8ZBfTVA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 25 Nov 2025 22:26:32 +0400
X-Gmail-Original-Message-ID: <CACePvbVuhvw2p6vaOd7YOsXOeS4-K2TPW=P2jhjtrNEvRZd64g@mail.gmail.com>
X-Gm-Features: AWmQ_bnVhSrheQpyQFSWfUf2aKmYY6ukM8NctgpduIpZ-k7I-tU-fCqa_eHRdkY
Message-ID: <CACePvbVuhvw2p6vaOd7YOsXOeS4-K2TPW=P2jhjtrNEvRZd64g@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E35218000E
X-Stat-Signature: r5r7a11nm9seghb5pw1du1kz54wcptwu
X-Rspam-User: 
X-HE-Tag: 1764095206-820755
X-HE-Meta: U2FsdGVkX1+K/k6gG3QL5gJdaJ1S9Cymi8KiBmtY+XOtJcVuXn6cRYlm+rQeAWAvHiU11KcXFx+99DXfiRzdBxY8T0OuozzZFsIj/N/BkqwbrcmOWSSR8i+JfSS56s6XWjJQSGmmpPGx/tNvxFGACO2xgbAfhs3aKXIr6tAdXiibiZ9j+fAld7FRuRl/DGElwiCLVxQLB4ZLf8nMkfzp5N6FcrqaWXCx6Of4Q6IjLX0Fept6Tb4Zkgf665R7taZ8XbmhUCm45rtnD9hto5ub3Ib7n4ZI5IIJCdCMqo5BpHgyC/Wu+6TE6iuVCk1g2JvlA9envgZZhGFPSqmvd/Sh0u3rulwn1Y+IlFGZcU+jSwdgZW3M9cscoczHvPDPgwsEXgl6VQuq8OSW5/X2fPbPI9vQtY/nvJ5G5GTJwY171F+O13C3C29yM+gRTm1CPz8PE+AlfJ/rqhpMVW7qz+MN862ettu40079FUAcGV2p8p8ErNnBcEqzDhbwODDPqfRo18Vo8bW9aEc/3Q6VJE3omKAzo/OiHt6zIk8Yql396XZnnvJ2kSVydwjMVBjC+NBYgZbCE/K5Ype7q/Y/wSpSS/VE80ORRrO7JNPKYFJiyJrjM6AdSHGabDDkEWxc1yzrGaU3PeMQyUhS4JnJRE1Ps9paWTFJXY0s2XSlYBN5GrAb5kxgv+pwb322NqCxnuG1N/d8ohaxEOKteRLWr02JiJNZP/1h9UJYuB4hn9wF/0ne1HBaZ2hNsdFZNjsMajb2cD05s/B/Ru32lSkupqfRpBpQIawkOXunT/li6yw9kzSGagAuBmX1G4br0G3k/g+yozkuGD9NLkmLQQyNloSo4CD68FaULJ/GR2AyqvLul/lUb6lEvnFmGAhLRWHDuzml4dKcWjNDtW96iZq7fji2Q03ZsSM9wV4QpY95/Lps72F3xTjMzyj1FOARE6kjOlUCcEnNwpK1DOwD5ftwv4w
 6xrmN5H7
 8olOF5CK5C8HDh3rR9EbTX+AoBTa2gkR8H7iRFf7N1MsSm2d9R27lErPqhT6G+SwFh6qOik4oTnxkbUlg1ZVCRLmkgN1ubsPvxoCqlWDgFSL9s6t1yRwJ6fz4jKI4drC556R6Y3oUSYjdJKewVcLLIeV+Trvp/KvOOjssHJQga9YjWkmz0WbHrJLG4wwWDCZugJX5M6tkiJP1kdAGGZ/svzQxKBgEuhz/yU3HW/j5cWFT6xN5RqJasLzVb9iQjluGD1BPuTh1kS5XZf7ZthXwBeVNTlig7fVGQWJw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 5:47=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Fri, Nov 21, 2025 at 5:52=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Fri, Nov 21, 2025 at 2:19=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > On Fri, Nov 21, 2025 at 9:32=E2=80=AFAM Chris Li <chrisl@kernel.org> =
wrote:
> > > >
> > > > The current zswap requires a backing swapfile. The swap slot used
> > > > by zswap is not able to be used by the swapfile. That waste swapfil=
e
> > > > space.
> > > >
> > > > The ghost swapfile is a swapfile that only contains the swapfile he=
ader
> > > > for zswap. The swapfile header indicate the size of the swapfile. T=
here
> > > > is no swap data section in the ghost swapfile, therefore, no waste =
of
> > > > swapfile space.  As such, any write to a ghost swapfile will fail. =
To
> > > > prevents accidental read or write of ghost swapfile, bdev of
> > > > swap_info_struct is set to NULL. Ghost swapfile will also set the S=
SD
> > > > flag because there is no rotation disk access when using zswap.
> > >
> > > Would this also affect the swap slot allocation algorithm?
> > >
> > > >
> > > > The zswap write back has been disabled if all swapfiles in the syst=
em
> > > > are ghost swap files.
> > >
> > > I don't like this design:
> > >
> > > 1. Statically sizing the compression tier will be an operational
> > > nightmare, for users that have to support a variety (and increasingly
> > > bigger sized) types of hosts. It's one of the primary motivations of
> > > the virtual swap line of work. We need to move towards a more dynamic
> > > architecture for zswap, not the other way around, in order to reduce
> > > both (human's) operational overhead, AND actual space overhead (i.e
> > > only allocate (z)swap metadata on-demand).
> >
> > Let's do it one step at a time.
>
> I'm happy with landing these patches one step at a time. But from my
> POV (and admittedly limited imagination), it's a bit of a deadend.
>
> The only architecture, IMO, that satisfies:
>
> 1. Dynamic overhead of (z)swap metadata.
>
> 2. Decouple swap backends, i.e no pre-reservation of lower tiers space
> (what zswap is doing right now).
>
> 3. Backend transfer without page table walks.
>
> is swap virtualization.
>
> If you want to present an alternative vision, you don't have to
> implement it right away, but you have to at least explain to me how to
> achieve all these 3.

From 1,2,3 to SV as the only solution is  a big jump. How many
possibilities have you explored to conclude that no other solution can
satisfy your 123?

I just replied to Rik's email about the high level sketch design. My
design should satisfy it and can serve as one counter example of
alternative design.


>
> >
> > > 2. This digs us in the hole of supporting a special infrastructure fo=
r
> > > non-writeback cases. Now every future change to zswap's architecture
> > > has to take this into account. It's not easy to turn this design into
> > > something that can support writeback - you're stuck with either havin=
g
> > > to do an expensive page table walk to update the PTEs, or shoving the
> > > virtual swap layer inside zswap. Ugly.
> >
> > What are you talking about? This patch does not have any page table
> > work. You are opposing something in your imagination. Please show me
> > the code in which I do expensive PTE walks.
>
> Please read my response again. I did not say you did any PTE walk in this=
 patch.
>
> What I meant was, if you want to make this the general architecture
> for zswap and not some niche infrastructure for specialized use case,
> you need to be able to support backend transfer, i.e zswap writeback
> (zswap -> disk swap, and perhaps in the future the other direction).
> This will be very expensive with this design.

I can't say I agree with you. It seems you have made a lot of
assumptions in your reasoning.

> > > 3. And what does this even buy us? Just create a fake in-memory-only
> > > swapfile (heck, you can use zram), disable writeback (which you can d=
o
> > > both at a cgroup and host-level), and call it a day.
> >
> > Well this provides users a choice, if they don't care about write
> > backs. They can do zswap with ghost swapfile now without actually
> > wasting disk space.
> >
> > It also does not stop zswap using write back with normal SSD. If you
> > want to write back, you can still use a non ghost swapfile as normal.
> >
> > It is a simple enough patch to provide value right now. It also fits
> > into the swap.tiers long term roadmap to have a seperate tier for
> > memory based swapfiles. I believe that is a cleaner picture than the
> > current zswap as cache but also gets its hands so deep into the swap
> > stack and slows down other swap tiers.
> >
> > > Nacked-by: Nhat Pham <nphamcs@gmail.com>
> >
> > I heard  you, if you don't don't want zswap to have anything to do
> > with memory based swap tier in the swap.tiers design. I respect your
> > choice.
>
> Where does this even come from?
>
> I can't speak for Johannes or Yosry, but personally I'm ambivalent
> with respect to swap.tiers. My only objection in the past was there
> was not any use case at a time, but there seems to be one now. I won't
> stand in the way of swap.tiers landing, or zswap's integration into
> it.
>
> From my POV, swap.tiers solve a problem completely orthogonal to what
> I'm trying to solve, namely, the three points listed above. It's about
> definition of swap hierarchy, either at initial placement time, or
> during offloading from one backend to another, where as I'm trying to
> figure out the mechanistic side of it (how to transfer a page from one
> backend to another without page table walking). These two are
> independent, if not synergistic.

I think our goal overlaps, just a different approach with different
performance charistic.
I have asked in this thread a few times, how big is the per swap slot
memory overhead VS introduced?
That is something that I care about a lot.

Chris

