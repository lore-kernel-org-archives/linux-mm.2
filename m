Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE79C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4883D6B008C; Wed, 15 Jul 2026 12:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439C16B0092; Wed, 15 Jul 2026 12:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329066B0096; Wed, 15 Jul 2026 12:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 054196B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:25:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7396E1C0160
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:25:22 +0000 (UTC)
X-FDA: 84991536084.19.15FD19F
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8B8B21C0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:25:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VpGBx2aM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784132720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYFz+BLLR5wpciF0ebXIUZFDHZ3ZsvyoUkgOaonjmmA=;
	b=W+LXjwKX/nxVvsnVIriSmZHLfPEDsZXGxPtCpY1icJA6rO2IVIIpj0y6cLrnXeuCTdXbZb
	lMfBLh/ocWXt0R3JrvxY14DXfgEAkyiXOEbpb10W5L4VzavWphR6BweQmbzKHcOSTG2v7q
	7OkzM7A4hMTBP5bJ0FFNQnKVdvjvWro=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VpGBx2aM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784132720;
	b=2vBJBL58pIJ/DGsja73H8Jf1bsrnAe82V2Yhl3t/yUMLJWiJ449idGPQEZZsYoccL9CiIv
	TKaS0NLbd8O0qQlicFWnHg7JfjmFaKFfhmngPLqkSdaj2DAlJdE6kWpX0sWJ3RrOPiDwKB
	3ZUqgzw16Sq0Zr21Adpf5e19Yqzrrfc=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39d4c864bfbso26372641fa.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:25:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784132719; cv=none;
        d=google.com; s=arc-20260327;
        b=i7vzvpNEH/EPwy7w5wSBkJpb75UnvEmOfDXIngnpMDgvB6czU+52iKKT0zoXz+WqdX
         63SmU2jfFi6jPYDQcaRpG07kMsOfV8ll5yHp/J5uU/EXMaXICzN+PoBTcoiEq6W0qdjV
         PY8sS2ayb3Kbn7UdDqCjCcx9OO66Rfxrae6UJjsmFku6JGxMKv4ewLd/8WfBNI4LVd8x
         fE6Ir0BB3259DatrFs+sU6cCgNvyuKLL28WIUggYQebgPVakqCJucdnniIp7d2ZnBJHa
         1lAJ6PIHmYSw/T9YAv3IOjCqZVfBM9kTZbCKJweJx23moHfVnCH5GvCIyiqYgIbYJ3t3
         zChg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LYFz+BLLR5wpciF0ebXIUZFDHZ3ZsvyoUkgOaonjmmA=;
        fh=vaecG6QtO6r12GzAj38pAxqRjsWQrAnjzLyMhvd9eFw=;
        b=NeP0EP8RPbPQAmUBey7InZSoVWSU/R0f/9w3kSY0bOOThr13MC/Mb/1BfvfFH4HFfl
         eaCZulyuDOhaGzUXTquGZTE+5JANgccgd0FQikZJrXXZxVqGfJklq3NLk8GPDaIjpSGV
         /SV+OA3T6PMFzP8Krnot8idlHs3ADkTjRxSbx6UY/q64ZlAoN5OMab+9i5/NoK1Zdq0P
         eic1ZB8kgP31h6TexTH+rQN93zKNnDgeWyBH1f1DuuMdFV3GGboJMhh33k2JG9+Iz5FH
         LIxuSL0wm7rLRvJJ4aZT8r8LHHhqDZSDercMj4GKrF09DlIR6npTsNobFkF12nZZ7yiL
         VkQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784132719; x=1784737519; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LYFz+BLLR5wpciF0ebXIUZFDHZ3ZsvyoUkgOaonjmmA=;
        b=VpGBx2aMwiV4VcVHKk11edgNXi3wmz9vYYxir0r4GxPqBjSM5lgXFvqlLGAAVOuPVY
         IyRniZn8nC52d59flqwv1hFined5M6gashQwrFtqv1DLfwiLVfuOVxoFbDM6vRAaDLca
         XrFsRjwhDVw14HTz2E7sHwFUHBDot+8ynAK3DMYzWE8MNcwbo4JOcQdpRexS9pLLFxUu
         VdVnBPHDKccyWX7H7GYHFmHLD0vDf33MDQZlkkYs5c89l7ujbZVMQb+ezRnLbkj5c6VZ
         ASoCeIg5CZHGB0Up0q9/Am9/mPwqV/qJ0mOmxlbM9RQUn+fGExDFZDEjJiGw7k97Ad5W
         IrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784132719; x=1784737519;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LYFz+BLLR5wpciF0ebXIUZFDHZ3ZsvyoUkgOaonjmmA=;
        b=MKEdjqvakYKaA52s8+Tzwf3Jp61CW9g0jONI/FBjAws2/bgSeWWNc9jg+LHcczSuxh
         a3z/ft/8EgMIRfeHsKzD+W9poByDDnml8XtCatfd4I/oxpkchX+dGDDpWE0icBFBa0oJ
         xMNjzfyNQq7qeXdm+7vhVin2INoTP5JfeYGVrDZOaHsCXeBzR1XYP3BpoN70bj3/Dfud
         DKwEXG501XouQB2s/zMA7Zl0bTa6PZkL7wc4AHosb3tTo/shU7TNtmfTD85t1SKRhioQ
         BzPNLeD+WBLXvb1FzdACJyG/lcvXSHyj01OgbWbndm3uZOxOyYkkClGPGvlSP79RIAAd
         f1NA==
X-Gm-Message-State: AOJu0YxdZKBNfInsSssy7uwnGVagC9/oNQ9oRhI9InDGbRri205AGYnb
	qxq0jZhhU2PTawU09rnx20bpw/gjPdUo8DCEp2AkSRGZO23C0q9xJpRC1hh1uLl4LsyVelKLaU2
	u/lLYdUhYWfS67Br1LvmY6APznsn35bCTaHKy07L2Ew==
X-Gm-Gg: AfdE7cmGmG+VdGGW/GpJoykkG/xFB5Wk5mGJudGW6R5pRXyM19+bJwbXEjlQOG7lz1d
	XVugHeshyaCkJ4FBnWpxmR+DxET4HTfcuknpWmS+cn9rzJP3JvcKrZ7fwAlqSUTp8dwkydliqTI
	+xQSwnN5d+fmzo/tTt83PRvuy9AjcLztAPN8jJNOIQGU32YYOsy/A+QVizkm4lG9pPCO3xcr6tj
	lla83XOOb5EGx5kIEZ6cypsuyfyvyeFj7mBIi+v3KI1tMp1B4yEoVmNs3C8S2Wzobt0M9Y4wJhP
	JGlz6aFkbSW8t6mbEP81YhTyFL/Pe0C1PHMJzVAhQEm5
X-Received: by 2002:a05:6000:220f:b0:45d:4a00:b927 with SMTP id
 ffacd0b85a97d-47f2dcd7876mr22960079f8f.31.1784132275600; Wed, 15 Jul 2026
 09:17:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
In-Reply-To: <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 15 Jul 2026 09:17:43 -0700
X-Gm-Features: AUfX_myDRiXvEcbH0kTMV189rxGGfoEnvRZLJ1kyk6qh9OoCLGsjI2wlui5CBRQ
Message-ID: <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B8B21C0005
X-Stat-Signature: 5xxbzqko6xee6qsoi7pqpbnamdexz866
X-HE-Tag: 1784132720-954195
X-HE-Meta: U2FsdGVkX18u9Yv3RHRZahxzMsbZImRrVGva6zPRbEhnJFT0Yz3ACeCLqgftyqmOxiB9eIkVx/ShQV/QFxexS2o7U5w+ed6LlPRIx7j8pxH0dDfz69ZoOQoJ4xav3K6knMSk0AzQYAunhsIXwRYA/czo0wiKmzHnKGIj5DYIVoeMFv4uc4vVWaoy4927zAqgSZMz4vJXSOr0z7b92eJypyo5oYKN8bKb4nilXLIMuQ2UZEVm9w1MAjiWqfgFH1wH9PS4fSJseMILKN6XoLkAjEA/azl8bkTFHKqh1TeyNJXNzh2kOP+jxv6s10rnl/9ygLEcAtCrYGa5jMXAtyU0xwbJd6T7KnyFLfjB6rX4YBdy0/EUQQbhCJsvsrzOqDagz0QBe0tvQMZ670bhpdL92d7BvSJCFAWB0uVWKxvekdjgupWkWq8EN+LiftNdA9vPjuc9/78pVBoGEE+bPekOvI4/QxG1onzbH7/bO1udU8akdTU9yVO3rtrSUY/nZ0ncAxCyseTOTLGAj42PAIXD/sGHCtLK1LaE8HmV9itTLSxS+o9E3rjWtN8ZaeAjMp3Ir4K2GfnJvo2raR35fFNArYax3Inu/U6t0iBQIIOccG8jGmRhMwJ7o0y3o63PkY9GrVi6ZRaR/+KhJfZaubSBYkex3eJ4grNqABZXxdP4hoZg/F3yCz9TQHhqcheTlAfb4lbl6FJtHCH6II+2nwqIcAPpaNTfFnR46FwWMsnwFF4b1DzFB1+Rk65wbYxJwIsYjZQ5Jf5wROxFgzHBo0srW8zzhD0yiq9QLpxKo5hrS0+qyBz6tEEiD4RXs6ZRSnekFm00JO0KFiaWw1FPiK23r+K335Lw0dvqnV+c+2puhzoRarTSu6EuNL7TMwK4Kp5AkW5KUzATJu7tV8y6vUm/VlP/8pbREdJ+V0G2Ce0YG81qgikj8fPnYfmP3gQ71HibEpF5VB5+K63X0ezo6Kr
 +wl713vt
 gk98mTiIBD9bzWDvZ9K89ixjrwQIaGVUTFQfb1avpDSQ/KVqF/6h2/UginR56VtE9ChMswAVRr0h4JTpsfHCQsnDNnId89vgi783KXWiu+hzK88iJIupaDnyP567R2w/rTNAedtvUfbdItnfzNVJQyiBcZHzX8ALlNX0JORcdoVyIJgsKiQveva95ixRicUFV2u8nMxwptow9YPdd0ufIuCxLXoL57urhvsZkXzD2iPhy8oQ96+3n/c66hMI0407aWEg2c94kCLR+c//adphwIA5LrwmSzwNPIFPK6Vh6ZcZoAPQSe/VlebrsJhmiehEAbO/rDeDp9nmLEQduR//ODSaoiPmf8M3/XK9mQg6w2ZJCHRvpWBz25kxYahf5yB3DRzSBcIp6/U7vd/I4t7TI+GusJZqAzxHZ5aSa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 7:19=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 07/15/26 at 07:21pm, Baoquan He wrote:
> > Hi Nhat,
> >
> > On 07/12/26 at 05:02pm, Nhat Pham wrote:
> > > On Thu, Jul 9, 2026 at 4:39=E2=80=AFAM Baoquan He <baoquan.he@linux.d=
ev> wrote:
> > ...snip...
> >
> > Sorry, I won't reply to each comment individually. I'll just leave
> > a summary reply at the end.
> >
> > > > I think VSS goes beyond solving the "zswap without backing store"
> > > > problem =E2=80=94 it is fundamentally an architectural restructurin=
g of the
> > > > swap subsystem, with virtual swap as a first-class abstraction laye=
red
> > > > above physical devices.  That is both its strength (comprehensive,
> > > > future-proof) and its trade-off (more invasive to existing paths).
> > > > I respect that.
> > > >
> > > > My goal with ghost swap is different: address the immediate pain po=
int
> > > > with the smallest possible change to the existing infrastructure.  =
Both
> > > > approaches have value, and I hope the community discussion will hel=
p
> > > > identify the right balance.
> > >
> > > That's because I believe "zswap without backing store" just by itself
> > > is a bit narrow of a problem. It's certainly nice to fix, but it's
> > > more of a nuisance - you already have userspace hacks for it (as I
> > > mentioned above).
> > >
> > > The problem I'm trying to solve is to support:
> > >
> > > 1. Writeback.
> > >
> > > 2. Dynamicity.
> > >
> > > 3. Decoupled backends.
> > >
> > > all of which are motivated by real production issues, not some
> > > theoretical problems. I'm concerned that if we only focus on the thir=
d
> > > goal, we'll dig ourself into a hole that prevents us from solving 1
> > > and 2 efficiently down the line.
> > >
> > > >
> > > > Thank you again for the detailed review =E2=80=94 it has already cl=
arified
> > > > which parts of the design need more thought and documentation, and =
will
> > > > make the next version stronger.
> > >
> > > I really don't want to be antagonistic, but I hope you'd take the rea=
l
> > > production pains that we've had (and have tried to communicate in
> > > multiple mailing threads, across a timeline of almost 2 years at this
> > > point) seriously.
> > >
> > > Collaborations should go both ways. I've gone out of my way to try to
> > > address the concerns of various parties, from spending *multiple
> > > weeks* testing and investigating performance regression on zram
> > > backend (which my company does not use), to a rewrite/re-design of
> > > virtual swap to accommodate parties who wished to opt out of virtual
> > > swap for now.
> > >
> > > I hope you can extend the same good will to our needs :) I've include=
d
> > > you (and other swap folks such as Chris and Kairui) in my cc-lists. I=
f
> > > you have concerns, you could have commented. Instead, you decided to
> > > send a patch series, which is basically just the ghost swapfile, with
> > > a bit of afterthought to handle writeback and dynamicity, rather
> > > inefficiently (no dedicated per-CPU caching), and not even correctly
> > > (the lack of rmap means swapoff / swap-cache-only physical swap slot
> > > reclaim is broken).
> > >
> > > I respect you and Chris very much to assume bad faith, but please wor=
k
> > > with me rather than against me.
> >
> > Before I get into the technical discussion, I want to address something
> > you raised at the end of your reply =E2=80=94 the concern that I'm work=
ing
> > against you rather than with you. Our paths in MM simply haven't crosse=
d
> > much until now. I can't think of reason why I would want to target you
> > or your work.
> >
> > I respect the work you've put into VSS. I did check it. Honestly I am n=
ot
> > fan of it. In your v2: 2244 insertions, 250 deletions, 15 files touched=
,
> > a new 455-line header (vswap.h). While swap subsystem has just absorbed=
 the
> > swap table series. Then another 2200 lines of architectural restructuri=
ng
> > on top is added. Not sure if anybody raise concern about your solution,
> > or anybody suggests other directions.

Yes, it's a big patch series. But as you pointed out earlier, it
solves a larger problem with a single coherent design :)

> >
> > I posted ghost swap because I saw a concrete, narrow problem that I bel=
ieved
> > could be solved with a small change. It makes decoupling and dynamic
> > growth with the minimum possible mechanism.  Writeback is explicitly de=
ferred
> >  =E2=80=94 not because it's unimportant, but because it's a separate pr=
oblem that
> > shouldn't block the common case. With my shallow knowledge, it's optima=
l
> > solution to the encountered problem. If you agree, you can change to

The problem is not the lack of writeback support per se. I understand
that sometimes pieces of a design can be deferred to a follow-up patch
series.

I'm more concerned that the ghost direction so far does not seriously
take it into account in the design at all, which might make it either
impossible or very hard to redesign around down the line. I don't want
to rip a huge chunk of it out down the line later - we just avoided it
with the swap table with Kairui's proposal.

>
> Part of above sentence is missing. I meant if you agree on the ghost
> solution, you can change to take its way and continue, just add me to
> CC. Or we can work together.

How about this - let's solve one piece of the puzzle together, one at a tim=
e.

First, your optimization patch series. Have you taken a look at my
proposal ([1])? I believe that design should be cleaner, while still
allowing you to put it all you want to get (elimination of xarray
being the chief benefit), without requiring you to modify swap cache
and swap count operations (since you don't have to move the metadata
in and out of struct zswap_entry). It does require a bit more code to
dynamically allocated the backend array, but should be trivial IMHO.

[1]: https://lore.kernel.org/all/CAKEwX=3DOvR7GbU_9f2h_MtU4m0g6s-esHmNQKYNh=
Jz610M0P3Sw@mail.gmail.com/

Next, if you just want pure ghost swapfile without writeback support,
maybe something similar to the first 2 patches in my RFC? i.e up to
this patch:

https://lore.kernel.org/all/20260612193738.2183968-3-nphamcs@gmail.com/

I'm sure you could find issues/bugs in it too with some extensive
testing (a lot of my performance testing is done on the entire series
as a whole), but from a design point of view it should achieve what us
both want, no? It's literally just a ghost swap device - most of the
other design elements of vswap (the new charging behavior, rmap,
support for writeback) comes in latter patches. I think the difference
is:

1. It's transparently dynamic, whereas in your RFC it's driven by a
userspace knob. Do you think there are inherent values in a userspace
knob?

2. The address space can also shrink when swap usage drops at runtime.

3. The dynamic address space is backed by an xarray. Note that it's
structured differently than zswap's one (it's an xarray pointing to
clusters). If you have rationales or numbers to show that vmalloc
array is superior (while still support the kernel-driven expansion and
shrink), please let me know.

If you have no faith in me and do not like my code, you can take the
code as a starting point, or just the idea, and drive it yourself. Or
let me know if you're unhappy with any piece of it - we can discuss
further.

>
> > Otherwise, please continue to push virtual swap forward. I'll stop and
> > wait.

Look man, I care about the problems being solved and I'm a sucker for
good ideas, but I'm not married to anything, be it my code or my
ideas.

I have literally dropped my old code and adopted Kairui's suggestions
after playing with it and liking it, to make sure every party's
concern is met.

If you have concerns, please let me know, or keep sending code if you
believe you can get it done better than I do :) All I'm asking is you
take my concerns into account in your design.

