Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 503F1C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD3E6B008C; Mon, 27 Jul 2026 12:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4646B0093; Mon, 27 Jul 2026 12:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2646B0099; Mon, 27 Jul 2026 12:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF11F6B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:18:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85B6CA0052
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:18:59 +0000 (UTC)
X-FDA: 85035065598.29.EFC4AC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 95829140002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:18:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvQuwjVR;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785169137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91SGC46wteTA8UqskPXqZ2MjsKPL+bnm4sYk32isMto=;
	b=8qiMiph4PwlA1G654CWuFeVPdf13C2AoLFn5CubYAN7xnczowqgdLUxN/zD8fIE2HaGjqK
	MdY4vLIAdbPcyl1iJ+RUrevkCU7BdbonCllbPNVcj18aoqA9r1gQEzrLmA2Xz+Wr0rHph2
	fgusYl8uOsxXO0Z7c/C7koO0bZLs7KA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PvQuwjVR;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785169137;
	b=lLds3MGDagLzJHxjwgb/qOBF+6FoDy9FFki33Rm+vDKuwvZ31sfr/w3J5zEiehEoOki7v9
	K7BaEHXrQV97f4nuFhJlJTwKDJ0R4fzF3HkSCgFXsFnDzeeD4wUIzPM0uOz09nCdGYZMCP
	mykEeoossx9B1UShJrHKVLRd4JbZYB0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E7AB409CB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6107F1F000E9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785169136;
	bh=91SGC46wteTA8UqskPXqZ2MjsKPL+bnm4sYk32isMto=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PvQuwjVRBb9rJCFkho4AEu6YakJdgcF2n653RTkhlU/Gs8Mq9+4u8oy7kgkCIwJKT
	 oTls3DsPaskQ2YJX9EDJXL1r10fiiKUyVuLoQSPQXPrZFMc/SLObuqWteMM7TJantN
	 3rtgirpjhcmiHA1JIww7Mblx9BPNVoAfNJyot56Xzd22AmhtwxxJ7IyBTZzjBiqi1w
	 WAD5oYmpe/nXaZ2kKtMhWWVxTOQ8mHf1PkWMFvIztRFS38VsSA0+GB0VF8KXZa/rW0
	 2nTL5swgX8dKNUk+ybe2Oni4JdxZakELQZEI5PjZNXDQWK800iTa8HAyPZkuo5vZHD
	 t+1t7pGKoZINA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c12614b81c9so492278866b.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:18:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RraO92/8XQFKde9ad9LT6hSsraHDZNpEaO/uApEH4CpPri6Ipjpta7NROCiThGpUxnjTSJW25wykQ==@kvack.org
X-Gm-Message-State: AOJu0YyBuoGwex5D9Nt0/0P9SUZfA4seuFoEHCZMPvfhCg5JYFcjKC+U
	5aWC74VDrhMb5gGDm1LVEQS6NI+dZlQ5swNdbCo7nD6lEk+fEky4t5N9mXpCUkXnSYEh2EqzrL8
	1ez7B8NbSXi3mM/VHar99mdnvcsUJvDo=
X-Received: by 2002:a17:907:a4a:b0:c15:f395:ac31 with SMTP id
 a640c23a62f3a-c1f1f3e5ddfmr414865366b.61.1785169135321; Mon, 27 Jul 2026
 09:18:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com> <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org> <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com> <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
 <CAKEwX=MG0F1+my1krUiOrHCn-Lypq2gq-g8Rv07Mz7sC=YEKaw@mail.gmail.com>
 <CAO9r8zOH93mfdjHq+Ljm7X+ykZS_rjzAvp9OBCzo+uyTbM1fDQ@mail.gmail.com>
 <amO-hwo8OGV5Goz0@cmpxchg.org> <CAO9r8zMgVmgQET+PUGexAgNqCZavA2YoTTXKSbWWoUv=A=ytSQ@mail.gmail.com>
 <f60fe501-7605-64dd-0572-77f7f3060f35@gmail.com>
In-Reply-To: <f60fe501-7605-64dd-0572-77f7f3060f35@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 27 Jul 2026 09:18:43 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMBWA7nxM24VXQT00CVEZwFpMFNe73FFdPSZw2y=J-0HA@mail.gmail.com>
X-Gm-Features: AUfX_mwTEgxS4l4XImwz7KgQJvkaUx5l8XpYB7q7Jw8ztGF1XlaoG-9HK5W-0bM
Message-ID: <CAO9r8zMBWA7nxM24VXQT00CVEZwFpMFNe73FFdPSZw2y=J-0HA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	tj@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 95829140002
X-Rspamd-Server: rspam01
X-Stat-Signature: ru84zacso7ook7tzhtftojzug1gertkg
X-HE-Tag: 1785169137-226917
X-HE-Meta: U2FsdGVkX19nM5R4iHnk8emDyi0EzknVCIGVZqnVIIpVbcyYahEwDCiQdSSoPGG39EpNNnYNwNyN9WGVyxwHEJnNgZEL/zX3M2QOsY4iAlt/YNZzC070Y1Vc/WAk56kfq/KlXFImV/7AOtEVaa34SL7vvB4gmRuwvxizExNW5ivJuL736J8pIOP2gauT2cQtxiIQeG5PEq7wemJXr+AoG27cTUsW0leKiNSn6P5OkG+eQ6L2iVhJ+qNWdH4fggdfHcWXqEsDVt/UOCotSgMPjhptvCy//8ocsQDXa632sYnXdK/8rFNneyluhzampykxTPefAT5y/tbZ0aXh8pzIwTuS3gtM6FBdd6QDG09sBKfO2YNVWYbP/G+xfjaWVICjaNqRql+xk991usVmbmYVOMcTNPH9KE46Mgkl013WlHTsKZuxK46BdVwOR/kYuIwBexOnzULr5CyAMtTOZSdYbJpqoQaMGrzxqV/dPT6z0fZHehA5jm4wU13LS6fRaYzB3TOHWtO5P5DtX5CZGk6qY/PqTmXov0q2ivvDBpbN4O5cLwl1yCvnjWR+MU4wEs5Zu5IAfAAUmM9CH1uT3xR0JIQ+9don+Ie3hX04Q6NUm9zQYF4ZLdBi9V51Iws7hGhSPjMXEFgiJwnl/hjXcLi+0PIdisMeUoE65hqd4i4kd7uwPOrrXFs7yBA1sDMvL1EZo0iZ6Wxud4tkDTZ7zcImpS43PJsW2Tot4H8/H0m7M+v/zcefgWFC6AtjpPO9G/G7e7F+LQnXvUwabuAMj/7x6jAY6QxBlruUHZGHb16catQiNwjxIJf/VNkZAMBSpu5eoxntddjEUemj2diPUI/njunecSQUltcdw1dl9GyfIRO0qkftg7M0IbJzKT7RXqPlpgg0RN+cI++BiYu2juM3aK21A5t28l1/qedNW5uleUzdfe/SYs5NWfTTiyxFlDHcNAjaVRhLfAYammTfYyU
 OPK+8c01
 +Q8q8agCojiUKBFsNXDYu5dNDS3pU/SSWxcnx4Yt4AnozVWheRJ2Zz/PVFLQWpeyP6bEBztYJ2tKW1HKTcLRSyBx6GKZjFROhM/y+EWogUC3rb1RZZi3uTRCUvInqYEpsPDDzqFo5yWLJiY2WCUY7hTM2E+BDl/Hgsn6bskjWAn77VFQRL0pcTI1rvV6mHGyWjQH1+xHMDLi3BulJewGCmPk4wd62arFhZM4Y6hcl626kstMh3oLHkp9FPfSpMp3Vofg74/pUY6nM3bY6GsNBWY+M96eejiM4c1mjkQtR0JUQGSRJZh4iikbEFxHk5lRu7s/p5JSm9ehGe8oxxy3FHHcmM96P7QebNL3WYpGTU7sSouOUKDUhDMSxJYVqxvK/fc2Eh8AD/HImkG4WidJLu/hFpSFc9CwpShU+b5dECBs2oMYFA6PMNCdsncoFhaXpXwBFduett1SAy8xGeRM+R8fwpTUB7cUUsuPfqhIdmojgMpiQkciXXnWVRa0Leb9QBIpaf4p35LBlcs0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 7:39=E2=80=AFPM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/7/25 06:22, Yosry Ahmed wrote:
> > On Fri, Jul 24, 2026 at 12:35=E2=80=AFPM Johannes Weiner <hannes@cmpxch=
g.org> wrote:
> >>
> >> On Fri, Jul 24, 2026 at 11:39:41AM -0700, Yosry Ahmed wrote:
> >>> On Fri, Jul 24, 2026 at 11:37=E2=80=AFAM Nhat Pham <nphamcs@gmail.com=
> wrote:
> >>>>
> >>>> On Fri, Jul 24, 2026 at 10:57=E2=80=AFAM Yosry Ahmed <yosry@kernel.o=
rg> wrote:
> >>>>>
> >>>>> The numbers generally look good, the store rejection rate is
> >>>>> decreasing and we are naturally doing more writeback which makes
> >>>>> sense. The store rejection rate actually increases when the batch s=
ize
> >>>>> increases to 64, maybe aggressive writeback is more likely to fail =
and
> >>>>> cause a store rejection, so that also makes sense.
> >>>>>
> >>>>> The only part I can't immediately reason about is pswpin. How are w=
e
> >>>>> reading from physical swap more than we ever wrote to it?
> >>>>
> >>>> The same page can be swapped out once, and swap in multiple times :)
> >>>>
> >>>> Unlike zswap, physical swap in is not necessarily exclusive. You loa=
d
> >>>> the page in memory, but if the swapfile is not full, etc. etc. you
> >>>> don't invalidate the copy of the data on the swapfile. At reclaim
> >>>> time, we notice the page is not dirty, so we just skip (z)swapout.
> >>>
> >>> Oh right, I forgot about that, thanks.
> >>>
> >>> I still don't fully understand why pswpin is significantly increased
> >>> with batching here. I would hope that with less LRU inversion we end
> >>> up with less disk swapin. Probably the test access patterns are just
> >>> too random compared to real workloads?
> >>
> >> Maybe more time in zswap for those tail entries left behind with the
> >> smaller batch?
> >>
> >> That's a 32 entry window that could zswpin with the smaller batch but
> >> pswpin with the larger one.
> >
> > Oh I was talking about going from no batching to batch=3D32. pspwin
> > increased by 387,400 (~30%). We are writing back 272,880 more pages
> > but we also have 209,837 less store rejections. So overall ~ 63,043
> > more pages should end up on disk, which doesn't explain the increase
> > in pspwin.
> >
>
> In my previous runs, I also collected zswpin. could the following
> explanation help account for what we are seeing?
>
> Assuming stress-ng maintains a roughly similar memory access rate,
> batching flushes significantly more pages back to disk (meaning pages in
> the zswap pool are evicted faster, keeping zswap pool residency lower).
> As a result, when stress-ng accesses swapped memory, it is more likely
> to fault pages in from disk (pswpin) rather than hit zswap (zswpin).

We are not just writing back more pages to disk, we are also accepting
more pages into zswap. The whole point of writeback here is to evict
colder pages to disk and accept (relatively) hotter pages into zswap,
as they are more likely to be swapped in again.

>
> In fact, zswpin in batch-32 dropped by 143,425 compared to
> baseline=E2=80=94which aligns with batching having a lower zswpin and a h=
igher
> pswpin.
>
> To be frank, under the Test Case 2 workload, we cannot strictly
> guarantee that the total volume of page reads and writes remains
> consistent across all three runs within the same time window.
>
>                       baseline-cgroup   batch-all-32-cgroup
> batch-all-64-cgroup
> shrink_worker wakeups       7,238             766                 367
> shrink_memcg calls     12,059,142       1,961,194             983,878
> written_back               28,277         301,157             327,997
> zswap_store calls        1,349,572       1,168,190          1,114,549
>     store succeeded           492,861       521,315           459,246
>     store rejected            856,712       646,875           655,303
>     store reject rate           ~63%           ~55%               ~58%
> pool_limit_hit             510,130          50,096             57,715
> pswpout                    884,989         948,032            983,300
> pswpin                   1,251,268       1,638,668          1,878,453
> zswpout                    492,861         521,314            459,245
> zswpin                     309,631         166,206            84,977 <-

One possible explanation is that we are shrinking too aggressively due
to concurrent shrinkers. That's one difference between hitting the
global limit and the memcg limit. There's a single global shrinker
that all store failures will just wake up, while all concurrent stores
hitting the memcg limit will start shrinking.

The other explanation is that, as I mentioned earlier, the access
pattern is just too random and we are consistently refaulting cold
memory. I am honestly a bit concerned about these results.

Hao, would you be able to try re-running the test with a single
stressor? It would help us figure out if concurrent shrinking is a
problem. It would also be useful to increase the global limit, to
isolate writeback from hitting the memcg limit. I don't think both
limits will often be used in conjunction, at least not in a way where
both limits are hit simultaneously.

It may also be useful to run an actual workload if you are able to,
like a kernel build or something, to see if the access patterns change
how much we end up swapping in from zswap vs. disk.

