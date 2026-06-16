Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D926CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1C86B00F0; Tue, 16 Jun 2026 17:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91E36B00F1; Tue, 16 Jun 2026 17:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A815B6B00F2; Tue, 16 Jun 2026 17:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 793296B00F0
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:37:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF8341C130F
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:37:55 +0000 (UTC)
X-FDA: 84887088510.15.1A19FF8
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id B9926180006
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:37:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mRKQHsBT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781645873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5foDtgqeTQXrOWV48GNDC5TnV9fQo3PaQ7iDDwN1xA=;
	b=PCO2GBGmoqcrQ0UPmOWgYtizmLh11bdWX8MrKrIcT01cWTXS2riIEWOoOieOtPdJT6E+lS
	IG4ikvEi0/VQIP+2ZHZDdx/po2MALXDOW3evLUmslxBLjai3Bb1oi64Xy4HlL2IhbbnZoY
	8LCHmZ/TdxPAiy/vhfRmiTk6iKmV3VQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mRKQHsBT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781645873;
	b=QKX5o8X82qHh1H51gRKmcFaR/vPzbiVBRx+803xDhbjrKML2x1XTR73C/qu+hyhAhnmzTl
	LvGBCTgTwvKe8Iiqz2lLW6wX8ZRtOkkfnK8qPqRYU7wjAECznnluHgN4iv1ipP733juTtl
	bmHWqLHb0V6MIP1JEw8vuCBkmYF2XyI=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-691c5776f95so9873630a12.3
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:37:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781645872; cv=none;
        d=google.com; s=arc-20240605;
        b=O2h3MBhnzK64KA+aTUmV0AKUh9P37njHrWr9oYmjvLHfkE+bp+uiCxDKrmk1/FwRbu
         peOa2STgKHd0OdUt5pkRBK2jHl3U79/uOV2Wfvl7DBiEfudnOL8C4BT48H6wJdbmNRzf
         P7yUht0BYAuCpQXbOMwwLN/nbRKP70Hq8qUF1mDdJTit784aWHy4kwC0HBDlQD1P9eBx
         1CYOyt44Ngk9iSGmpN5DJ3OR2x7Ncvy+CqxI4L3SAvZp1geGkHK9UVzXNd8JdKCuKxiQ
         hZ7FlKAlbagUlcqYNDXcwrseY3fio8swnysp5aZhPHEMGySrneAEXYqxLJaP5u9xzoBv
         C3SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K5foDtgqeTQXrOWV48GNDC5TnV9fQo3PaQ7iDDwN1xA=;
        fh=+WrTcS90RmioMWGS0YHKWksHsyRZecvT4IzCakd8SdM=;
        b=g2OQr0zxcb3RnfOmCe0j1oElRYdnwH4C/JOI5k1+12znA3PwxMcZZGNmUCJ9ptTtce
         C7bWdAUbmCdj9YT398GQhxAcwfgKERCgSyjzjaUkfTr0+hgaa6+HDb6udligajmI+3j8
         OIv62x9DJDtoVqCRjhxxOnEad5FuGpT+lEn/6nZX26Fxzd6B1eRyo50bZpHJQifuR16E
         4wPOX7eAfreUdprodpuvnGS1c46d4nvSCRohXgxOYcKHCnhw5VNVzrA+QyqKAIccG+jz
         goCti9AIHntVPm+JOvhntBLyFJ01AxNzSqnPe0H00NqZfOv1aKxx13cbi7VEEepMwqUY
         ASgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781645872; x=1782250672; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5foDtgqeTQXrOWV48GNDC5TnV9fQo3PaQ7iDDwN1xA=;
        b=mRKQHsBTGgVBh0NeH48RTBDAnMvhp0FamKC5Bn8QhYmXiZNX7nZJnGnzRYFl+8uPYr
         osmHm6o2xh3SBeHDkhpOC7RBagA2vJfYqWdBetLgHMGK4oq+EbDYBntmUq3TFgIStTcp
         Y3ppNnUjsKuWmk6ag3IAnpQSv72e8cLah7HzJp5szoKOpKRQT+dpaIQtR+HhxiACHPE7
         EDqWYyLyZQIc7nNEPZor+aF0Pb2jP+l1uA1ZI9qAzrllY4pLueEH0cCCpIEgVdiAWZWE
         LEl+HQcfOlU/A0FtZFC4ogOtODGCooTCpYQfr7CDSBEbj64TtDHBrlt1sS/ZVX6TIr2Y
         c7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781645872; x=1782250672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K5foDtgqeTQXrOWV48GNDC5TnV9fQo3PaQ7iDDwN1xA=;
        b=QsDmq1A7mZWNTqXu1blk26929bj0kFkcxJjNC9e5M9USKOfH/iUw+hyqBE4E3Fhtqi
         zRROdjI7g/D8WEY96/ybpeO2gfIcut9Nw2oaq+g/TVWm4mWTntFJuz9+yQOS8Ck8U146
         BX2LSQS4b5DYTBiIy05VHNG3qZqyBmF3N3OufF1UexfGivcuC9LPWXUgXgGn616zWkup
         0TMDg2yb64/x8ZudpxHgmnXbdD8P3T35V4DyrA24m66zuJAwoYvVvqdS85jkamF1WDM6
         SbhIxSwp+nqJofMf91028NiQJG1xZ+Q8z1taczYx1IAyYHNhBxVcLbTwdbdf0aqr8Woz
         1aGw==
X-Forwarded-Encrypted: i=1; AFNElJ8Htjo3bm31F+qk8l/bjXmlvYZLGE7OIUbbeBx/85hhpxTYev2f1+SmNFPDkEiHhmq3A8r/EOWA+g==@kvack.org
X-Gm-Message-State: AOJu0YyyZlNPuz59kLdncXfYhhVnbdsXFgQ+Np9/hjYJFpkEmj3FxnEH
	NOuedRejoOX5c72g+pdhj5XNPqCZCw2D/fHA0kuedYt2ycMGgr9yVZgcPUMpd92QAZgaIGo4iT1
	Tp77rNNFSICYF1BYmYNKsvNW5unUvLJGfBA==
X-Gm-Gg: Acq92OHrQTBIyYhzbvbU5k6WQ+P8TMeObQNcMOXk2XW/Fx2nl2j7ZPuzx2pNnB3bJJk
	NrJgFptuJCNXILC9p/GxeMh72aFl1Y3/PkL3aClA8T5a+wLVwu0OLB6lq9v+KU+hKnZtO9jBZtH
	INIeQtcXCopsGcWll0ho1RnuvNVrzT6Lf9Ba2vnTk0MuF+3lJuFYEEbsl7St1wa03mHyKkZxw3V
	GhTU3KoBIQP1exZLVfXwzw5y3k7aGRXnIGNFyOD51qlcIEqVIbHmr11utSTf58AcYycyF1uyaz2
	+w0IFwlBsGFg8py0s/Bbqm62++Rur9ZXW1DndQ==
X-Received: by 2002:a05:600c:820c:b0:490:c2a3:3302 with SMTP id
 5b1f17b1804b1-490ec526f4fmr251514085e9.35.1781612147341; Tue, 16 Jun 2026
 05:15:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260612193738.2183968-1-nphamcs@gmail.com> <ai5kOOmR1LPTWs1J@yjaykim-PowerEdge-T330>
 <CAKEwX=O23a4iWBZoewKVb8QqODte6r3Xijckw3_oCJNoiO9M5A@mail.gmail.com>
 <CAO9r8zPj5EH8Mbpc6N+d1u2eEgoV33f+4s=v-84gaobAodPtUw@mail.gmail.com> <ajCm44rYpLOKCQ43@yjaykim-PowerEdge-T330>
In-Reply-To: <ajCm44rYpLOKCQ43@yjaykim-PowerEdge-T330>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 16 Jun 2026 08:15:34 -0400
X-Gm-Features: AVVi8Cf1GupVHqkNcZhtYoOUz9DU0zT_2oeWtf5qDBtNiWLRx6q_yt7muoLsCPw
Message-ID: <CAKEwX=OPaUputOYJrJDvcNGn7WWoXOp-GzztA5MPbynj-4cPWQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/7] mm, swap: Virtual Swap Space (Swap Table Edition)
To: YoungJun Park <youngjun.park@lge.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B9926180006
X-Stat-Signature: oskmywjzpofyi9qj1dh4hxd1eriwwa95
X-Rspam-User: 
X-HE-Tag: 1781645873-92535
X-HE-Meta: U2FsdGVkX18ZlfCoRHHxs3vnI3EJ+g6EBeaxL1wf0MvHH2JYRRBxSw2wdSlm4yRvK0RBBkU7rYuatose6yvOT6IpjG4xHvp0EteYTWpMyIWpyLRVDS86wx33+N92IR/ulf3hjfMRAx1HOgEpDEAjFqBxbvEJp2QNFugcduCgx3c7HSED+lpbK5LX87dyISCwN+rOFPYIph9Z0zywazof2vEoTzMHl6y3E+hsfVTjyWE4bk1smjc8W0eKY/i9WcvQ66kZUfOilGqZFRC5cO2z5DsWF9IIwW7Sqorma5m6S577gxHjD4SQv0Cf4qKFmZ19ex4hh8eFI26U/2WUzULIZ5/qlgvjr8FT969XYvSUY8wXagNvM7nTlvW7zxGot98CagSMMbabTUwqG6VuWgDZyyqVGy2/BFcvQqk9nfnjfDIlK3WFmbDTjH95+IC25tOGlWPHF8Qz9MyqxUcp5TqKS4r1ggJvwoypiIYOrH2xTJ0K5RYZp7mjKw77kOX2DP5SPJbZ8DoF5Iu9KBUPQgMt3iui5iH15fJmdbjxoQZnReWjd+wghW8ZWT287qOD+jJ548Xpi/TGn/26A/B6mN6Gz3OdiDlvHMnm0UTgmcG+cP1RHOSgzok35TAe4HHMw6K+TKmdqEfz/1pLlaRCAZW5aAtbiEdW/ElIpZbSzNMwUmnH+m6MyBtiZRzwfS+r9ReoMd2sMiRnJ0Us0/6VZFEEzdPNc1AR9SGyXM7oQkkEujcFxzfshUbAbkJQjCLB64myhAYpO+IgnJFdWn3bngqKQuBu3HmWlgMVdUMg+fjVu8gvoLViy49UaxFTEMssaq5r7Ebh+Nm3dn+9cuJgbqZ5TIZQnQFnXjUi55ZP+RpP7HOK06M4Psc10zv8MBboRUiUmKoneANQlDBSjwtDvx85VdYy3HnaPa6vkz/dSXiAZxCucdyhYCj0BkGhP95O9O0YTEqLy0esNJZSa0KsBmb
 6LZn7gWe
 0O+x53T0tRXByBtg3iXy20aqeTA78lFZARoIVSD4cBNyiX0bS+6EB99WOF2T9P7swxcHMVYI9E2HeVZCCdzKOebMd27UJykoj5k6GZ6BS+1y/WSDUhTlMKR1klZv4TON/uEz0dhLEj8FcmBFAf5MwgDXLZZxK0vtQRlEScRP9wn70wCVSzeOleM8kBjguiTVU9WNkeMQvK1BYrJPIrockhx3rCUOpN0e7fec0tHMzYlIA7Yg3DLkJmHdHKunCMoL/EOMjelcmDbmdAUi0spqnf7XB9T1RfHUY0c3LPKdQSN5aKc1EcgyMtt5ku0Mmjsuvvdw377eH/DSO/sfPSmqZ+3PZ5moEs1BEMXDt2EdfqHMIyzfEDj4qph4CJdtcQ3+Ni8c44l625/NU8WwMCSCc8Nn/ESVlnk9wk3d/6r3wO9pO1c+bPuMklsY4XtB/Shc3t9AFn1a5BHrfRHXazzJrb8wplwBTmE0sYq6TEOxvuprFbWhi2birbLtrZqM9hs0dCA4RXv+RA8zcNvsAvB+XRVTINA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 9:29=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Mon, Jun 15, 2026 at 12:56:26PM -0700, Yosry Ahmed wrote:
> > On Sun, Jun 14, 2026 at 7:39=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > On Sun, Jun 14, 2026 at 4:20=E2=80=AFAM YoungJun Park <youngjun.park@=
lge.com> wrote:
> > > >
> > > > ...
> > > > > * Integration with swap.tier by Youngjun (see [12]). For now, I'm
> > > > >   leaning towards opting out the vswap device from swap.tier enti=
rely, and
> > > > >   treat it as a special device. Integrating it with swap.tiers wi=
ll
> > > > >   benefit the cases where you want some cgroups to skip vswap for=
 fast
> > > > >   swap devices (pmem), whereas other should go through zswap firs=
t. But
> > > > >   most other use cases, either the overhead of vswap will be acce=
ptable
> > > > >   (or not the bottleneck), or we can just disable CONFIG_VSWAP en=
tirely :)
> > > > >
> > > > >   Youngjun, may I ask for your thoughts on this?
> > > >
> > > > Hi Nhat,
> > > >
> > > > Tier 1: VSWAP, Tier 2: ZSWAP ...
> > > >
> > > > I don't see any problem applying the desired functionality with the
> > > > currently proposed mechanism and interface. With this, a user would=
 be
> > > > assigned the default Virtual -> RAM swap tier, and the overall pict=
ure
> > > > becomes one where swap tiers are composed according to the priority
> > > > setting.
> > >
> > > It's more - is there a strong argument to let vswap be a tier (which
> > > is not supported by just turning of vswap altogether).
> > >
> > > Because right now I'm not exposing vswap device to userspace in any
> > > manner, pretty much. It's abstract and transparent, and minimizes
> > > complexity (no vswap and swap.tier interaction) and surfaces for
> > > issues.
> >
> > I definitely think vswap should *not* be a tier. First of all, a vswap
> > entry can be backed by zswap or an actual swap device, which would be
> > two different tiers. How does that work?
> >
> > I also think vswap should not be exposed to userspace in any way, at
> > least not now. I still think we should aim to just make the
> > redirection layer always on and eliminate "vswap devices".

Yeah I will just expose a pair of usage/failure for diagnostics purposes :)

>
> After following the answers and giving it some thought, I agree that
> vswap should be kept user-transparent. If there is a strict need to
> disable it, relying on CONFIG_VSWAP to remove it entirely seems like
> the right approach.
>
> If a strong use case for user interaction emerges in the future, we can
> revisit the design and figure out how to handle it at that time.

Yeah the only argument for adding vswap to swap tier is if we want it
to virtualize swap on a per-cgroup basis, assuming:

1. There's a setup where some cgroups benefit from vswap and some
don't, in the same deployment or host (so you can't just use
CONFIG_VSWAP).

2. We can't decide it with some heuristics purely based on kernel's
knowledge (so for e.g, if a cgroup enables zswap, then vswap probably
makes more sense than not, etc. etc.).

Maybe I'm missing something, and if so please let me know. But
otherwise I'll stick with transparent vswap for the next version.

With Youngjun's new interface, if we made a mistake here and
per-cgroup vswapping turned out to be necessary, fixing it is fairly
cheap. We don't need to add any new knob - just need to expose it to
memory.swap.tier somehow, and we're done. That can be done as
follow-up :)

