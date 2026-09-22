Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5233DC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5456B0098; Tue, 22 Sep 2026 07:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4658C6B00A4; Tue, 22 Sep 2026 07:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B6D6B00A5; Tue, 22 Sep 2026 07:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05B816B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:36:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 988591A043B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:36:24 +0000 (UTC)
X-FDA: 85241195088.07.291D4B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A70334000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:36:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQ0nz1aQ;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790076982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1y8smlT8SEgYsl3GfoZCkbJ8M71szX6QVg/Na+X554=;
	b=0+IklWFCEsCzmFuduqoEjbYE/ZJgUYl4d6jwsYXFwDfT32hWP5l0bId+rmgpzwMSXWDYdC
	gbZUAyAkaNZmGShpavEnOhkOWBAOMp2svhhrFd3Pm7uhmCikn1GGGJrAe1CKST7rR6HWWJ
	KubxgE9oPxLre9ggxmGyx0C8pS2CRMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790076982;
	b=bszhP8IYX5Xwif4TNwGWU5LvY5YeYPZ2GYi24kkKH7aVuyfyRHjSVOQFCjv3derPiFtgNr
	WPfCTRGt2qryR3Jg0LqTlZQyXraitfzZ0/mGnNlPQMKvBOWIs2z93PiIoxqtFfeUkfktY5
	YlhsCO610lx0H9DTxsDGFGV71Xp3ue8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQ0nz1aQ;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD66F449B5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE8C1F008BF
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790076981;
	bh=D1y8smlT8SEgYsl3GfoZCkbJ8M71szX6QVg/Na+X554=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gQ0nz1aQd0KF+sdKgBCaCMiQPt9/AYv44mLPOdMt6odP8xBYc6qckEKuLnBrQALde
	 +zLz6NebY5Amgrrn+RizYhKaYJOVrP+BONrtP42Wro4MWn+ESlRrvuZeFaxgShSuKS
	 YVQzbTUykTtnjLg086aFGYXj512OoRQ2OCJz+Ix3Kp/ut+uns+a5g2ddEzxVcsmE2d
	 SA/biEdHfBhtJOpYz3nThoZry0kYfvXOCtEXAs9o3mpQdVdGAhqd94neDNFH5kkCuU
	 sWBBFNhH1Der5QeFe14VawMXKYIpcDH9dL6YXUg5AfST/SUeE89bvavl2pbcH1n3UW
	 M88cGBjrF1RUg==
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb7692a57so49564221cf.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:36:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzDrMalmbZSgo4C+6FbiQkw7dKQpwpuF/8pXs9rmTSIRZTnB8hDoZ88c7SZcqy4wdTHBRrCQe5KLg==@kvack.org
X-Gm-Message-State: AFuF++mmdsxgA17+1cusLyCpghUqFvam8V+8RDZewYcUGX3FOjD2pmiS
	0e599d8Jt0zCUC+DV3T65KMiptIgevbUuPLXpDc2C6Or4BE3+qBmcYAnCvmMuKmSWT5DTz53TZw
	sUc+hge2l6bASWdQeX1cz0u1AfhGU1gk=
X-Received: by 2002:a05:620a:2810:b0:927:25f5:ee08 with SMTP id
 af79cd13be357-93c19a46375mr287077185a.43.1790076981023; Tue, 22 Sep 2026
 04:36:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org> <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <arJcPIaqJOzLpkel@gremlin> <CAGsJ_4zLY6eZWUufuVqLgEVf93G1JoKtk9ObftkoTwbAimG8Yw@mail.gmail.com>
 <arJi8RRxLM-1JiPV@gremlin>
In-Reply-To: <arJi8RRxLM-1JiPV@gremlin>
From: Barry Song <baohua@kernel.org>
Date: Tue, 22 Sep 2026 19:36:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zcLsLOwLdfv6MrcXKyzKXXomKuksso=A+Es3XLYdjQ7Q@mail.gmail.com>
X-Gm-Features: AcwNN1UE4EUboSCEVXHPDRCyhIyUNiRiG1qyey5lrqdrySt5cOAnSD54vDhJd2Y
Message-ID: <CAGsJ_4zcLsLOwLdfv6MrcXKyzKXXomKuksso=A+Es3XLYdjQ7Q@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	willy@infradead.org, jack@suse.cz, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu, 
	hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A70334000C
X-Stat-Signature: 1rq91c71agnkm8k43sn9u7f4coi6nf7h
X-HE-Tag: 1790076982-229098
X-HE-Meta: U2FsdGVkX1+OYtALqoa2WrPM5eHTCsc2B/63cl5CtQVXZE4TbT/0JL132Re5iBfgPFEforqE5nxkSvwDJGtivaK128O7iPs9eTkq5aeC0y6lii7rS1CEvLIu+UZjFmCVs3k8AQuHSUTJ27AKZlX2U/t3166v/x5D2uPh1+f7sBK2MIMTecSWfqhag4/U1w0Kgnc70q0NX9nhCttg9rPJ7BVNNISo1TZrC+SjUd0WbAGAt7rYdRTzKMDaMUOfME/4ajrgBkb80qrOVDZL2ePkQHnkWnsHvEQtbNxMjqX8F3nw3bS0ZBX9erZydl/M2a3xt/2LdRpoGYm3ZfrUQeAZOvTDbBBFrGARNTgBB42UzS+lpeMX9cZcqp98lDiwJvq3kRllvAeSSJF3E/R2WgWAxgpIbppOLgbwbnCDjsPMrXisa26X/AShAgiwHNpLu1GyIbkp4DW3JrsWFVgS9clitjwCSUEOypstmtxPZ8JA4V3HAKDU2x0knq44Q6Ft+BFM9s+PAhAMNZ24QRiNsaBomA0y/JdIdJRWc5FtDCzdxwEYhkhSydSHBrM0MeaGhCGNSkm6dFaLO4Wu71K24R/EVQefo/htOOTYpJYvR0300iffHUKpCBlsouVg8JgU31QC80Gul/5XR95Npqb2jz1FJ1u1hZeH0AWohnnrjGXoJCAwiaFhRZbYcwXgLMNaTJzg6z9zA/r+uelPyHf6npSxCCRZ62OTXVFdtGUS3r5W4k7otjncK9Mva0owo/BhEtYtO2nDexlv5ouT65GB6PjTonMMw1Cr98R9+q23KJSfGv/HCSdlRUUdRoeSi0z9TWjYC+AQNpYyu1aaRKI3iJRWygJfad74srkssgubB5IL2eaDA+gQOPWgvLS3/WMK8AakulMapnrhWnF0a6GzYXr3nvQJRWZsDf7B/7lYsObtE4s7PHtsJ2nFpQZ2238vcTud8aQs+vvpO3r4g7Hv65Z
 EKiG+OU6
 +a0YpHZFo9qMR03hiRaiLYM0FIYgxNhI12Y6NIR0I47H96M9RaJjifKCcB7+e8VrtYe2Hu5f/b7nMQyEGmw3bqonoZJOKja0Px+u0weF6wZuDI6I53uM6ZEZP7OcU/1BxzjnpeZmwoTaeRRNdI6FTT8V8yBhzTURp/+YV/KfuiyItgSnvEInywGVZ0aAxN7PLg2p2shD0+vRBx0ngAWOCqiFggaCFrkoh+n3Es+9podJrzM/SttWEqail+3yo4gvPOL8MF64iC4NLeT3p0XyBIcgCL+xdBYdL5ddNNZ/vLbV+iya0yxsLUTuC9FOVxjTtbj9Znxgdl4aPDcvWjn63cGJaKjJqE/5Di9WNGZ/be0PqhKNAjAAlG+t+E0GsduUy8Cwz4h1CP6ZIp+2NliUj5qkOUhQVgEDGPukDJSFpfY+zEO1VDrDVI0g5NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 7:16=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Tue, Sep 22, 2026 at 07:10:34PM +0800, Barry Song wrote:
> > On Tue, Sep 22, 2026 at 6:47=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> > >
> > > On Tue, Sep 22, 2026 at 06:37:38PM +0800, Barry Song wrote:
> > > > On Tue, Sep 22, 2026 at 6:20=E2=80=AFPM David Hildenbrand (Arm)
> > > > <david@kernel.org> wrote:
> > > > >
> > > > > On 9/21/26 23:56, Barry Song wrote:
> > > > > > On Mon, Sep 21, 2026 at 11:37=E2=80=AFPM David Hildenbrand (Arm=
)
> > > > > > <david@kernel.org> wrote:
> > > > > >>
> > > > > >> On 9/21/26 17:24, Alexandre Ghiti wrote:
> > > > > >>> On an asynchronous swap device MADV_PAGEOUT only marks the fo=
lio
> > > > > >>> PG_reclaim and rotates it to the tail of the inactive list on=
ce its
> > > > > >>> writeback completes, so the memory is not actually freed unti=
l a later
> > > > > >>> reclaim scan removes the by then clean swap cache folio.
> > > > > >> But we have the same behavior when just reclaiming memory ordi=
narily? It's added
> > > > > >> to the swapcache and only the next scan actually frees up the =
memory.
> > > > > >>
> > > > > >> Wouldn't we memory we reclaim ... just gone, like in the sync =
case?
> > > > > >
> > > > > > For synchronous I/O, such as zswap and zram, the memory is rele=
ased
> > > > > > immediately after sync I/O is done.
> > > > > >
> > > > > > For asynchronous I/O, such as NVMe, the swapcache is currently
> > > > > > expected to be rotated back to the tail of the LRU and wait for
> > > > > > another scan. Alexandre once mentioned that when he tried handl=
ing
> > > > > > async I/O the same way as sync I/O=E2=80=94releasing the memory=
 once the I/O
> > > > > > completed=E2=80=94he saw some regression. So, delaying the rele=
ase until a
> > > > > > later scan may allow swapcache hits before the folios are event=
ually
> > > > > > reclaimed.
> > > > >
> > > > > "may", do we have any evidence that this actually is relevant in =
practice?
> > > > >
> > > > > We asked to reclaim memory. We wrote the memory out to disk. We u=
nmapped it from
> > > > > the page tables. We made the workload the could, access the page =
immediately
> > > > > again suffer already.
> > > > >
> > > > > We should just evict them as soon as possible to free up memory.
> > > >
> > > > I suggested this to Alexandre, and he found that it could regress s=
ome
> > > > workloads [1]. That is why Alexandre is only making the folios
> > > > immediately reclaimable for `MADV_PAGEOUT`.
> > > >
> > > > See Alexandre's description:
> > > >
> > > > "Future work
> > > > -----------
> > > > Barry suggested extending this to MADV_PAGEOUT and general reclaim.=
 I
> > > > prototyped dropbehind for all reclaimed swap folios and it regresse=
d
> > > > sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap ca=
che
> > > > immediately turns cheap in-cache refaults into disk reads and colla=
pses
> > > > swap readahead clustering. Neither blk-wbt, mq-deadline nor a PG_wo=
rkingset
> > > > gate recovered it. MADV_PAGEOUT alone may still be worth it, since =
there
> > > > userspace has explicitly declared the range cold, but I have not me=
asured
> > > > that case in isolation yet."
> > > >
> > > > [1] https://lore.kernel.org/linux-mm/20260921151306.625134-1-alex@g=
hiti.fr/
> > > >
> > > > Best Regards
> > > > Barry
> > >
> > > This patch as-is is just way way way WAY too complicated and fragile =
IMO.
> > >
> > > Whatever cases you have found, they need to be fixed somewhere
> > > fundamental. All of this feels like a hack.
> > >
> > > If you're having to write a comment like:
> > >
> > > /*
> > >  * If X is Y, but not if B, and if Z is J but not if the moon's brigh=
t at
> > >  * night, then maybe we will foo the bar, but only if the baz is blar=
ghed,
> > >  * ...
> > >  */
> > >
> > > That usually means you're doing something horribly wrong.
> > >
> > > And this patch has multiple comments like that.
> >
> > I'm not quite sure if you've read the context carefully :-) or why
> > you're angry with me.
> >
> > I did suggest that we should reclaim memory immediately after
> > writeback completes, both for general memory reclaim and for
> > `MADV_PAGEOUT`, while Alexandre was working on zswap dropbehind.
> >
> > Alexandre then found that this might not be a good idea for generic
> > reclaim, but thought it might still be worth trying for `MADV_PAGEOUT`.
> > That's why this patch came about.
> >
> > The discussion between David and me is whether we should do this for
> > `MADV_PAGEOUT` only, or also apply the same approach to generic
> > reclaim. So far, we haven't even gotten into the code details.
> >
> > And this is also the first day I've seen the code. I agree that I can
> > work with Alexandre to improve the code through review, but please
> > keep in mind that this is literally my first day looking at it,
> > my respected Lorenzo. :-)
>
> I'm not angry with anybody, I'm saying the patch feels like a (fragile)
> hack and the issue needs addressing more fundamentally, echoing David's
> suggestion.
>
> I also pointed out that when comments need to be extremely specific about
> exactly why you're doing something, that usually means something is wrong=
.
>
> To expand on that - the reason why is that clearly the logic you are
> adjusting is assuming something.
>
> You are violating that assumption, which is why the comment is there.
>
> Generally that means the assumptions are wrong and something more
> fundamental needs to be changed.
>

Thanks!

I agree with your description. But I'm still a bit confused, as it
feels like your reply may not be in the right context :-)

Never mind, I understand you're quite busy.

