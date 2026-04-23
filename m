Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 367F6FAD3E3
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 06:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6186B008C; Thu, 23 Apr 2026 02:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CD406B0092; Thu, 23 Apr 2026 02:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD2D6B0093; Thu, 23 Apr 2026 02:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79E406B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:17:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F41BF16047C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:17:05 +0000 (UTC)
X-FDA: 84688812852.25.C730F9E
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id A8A9714000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:17:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SeCnUT6B;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776925023; a=rsa-sha256;
	cv=pass;
	b=Qvyy4ujgv2e7fuqs+4kOD7XnpcZpt8JmaRtAio/4JFIakx+Z5t8K4LsPZar8oMKn3CcSKW
	Er36se60TIgBE+eyfEGJLJkoNRVJaQAO4oGh99PGL5qEDzxq2OBzm9yRhFHJvWD6sZ8RkD
	jWkJhSebi8lSduSUwR3MGdCxoMGEngA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SeCnUT6B;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776925023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qrM7qsAzBHvv/VI+HqLPPP6FQ3qhsBu/FQQBvDaXwA=;
	b=OpPQLkhk3wAfKiLY95ovCGkF+F3dDjrblinJRrbeMisEWd94MnE0Jk9h5fGfQaojKlF+Ap
	SDA7NSgmHenDxR1G7HENqmbCjZdAa9NF2GLCIneGKa8pd5PrXp0XLg8hNv7I2Ut8Y+hzYj
	dg5xwrB/nFMmTSvpYDWLN5a4L4mT2Lg=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-670ab084a39so9532393a12.3
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 23:17:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776925022; cv=none;
        d=google.com; s=arc-20240605;
        b=lFlae3n17+ZKOnfDIel6me+MhvsYV8hXxq5W6BkAUlGirraQhPfWEavfrbKUWvtKbS
         Uk0Lw9D4PUc2//Kwbiw9uX4PL1ZgtgiU3ZjfOPrVawsEOSsKjFeOE7J76TCqnC5wGKr0
         oreG7ox0ZiLqpsA2e7zLmXwuBE3xAvHyGibpz1CligqOs7ttC3aLLesaVbxbE4K5E/r0
         N2PIsDUtrK+YZoWXLRa9P8ZV5qf0ZtKIK8FYTEd8I0lyefTXBk61suvKm8q1i+R7vvBw
         Lk1jzEZHDjjJQg/2uHje8R8KQ0dlLg955YnX4s9G/GoCeb/G1b6KS6h3bvkKvMS4n0K9
         ORpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6qrM7qsAzBHvv/VI+HqLPPP6FQ3qhsBu/FQQBvDaXwA=;
        fh=VGdKSbhrfRts69hWugLkWqIREow9pxYSL+mwCctJnUk=;
        b=EsraGbNbDBYNBQCBYnr7JbySBlAW/2DkEjIIJMDTonhAM37YRp/unPh7JYhkiKvX0A
         8w8YcVvY7wfJfqi1E+PsEd2Dzrl1X/k4lMxJ+CG44w9IQIxDS09gi0xWIJYsSwk5mogZ
         skk/AO2bwidHlFpXpBrpDHH4i8gtAotnd8iQhYjJP1g1t8cy6LN6uaSoQECLhODJKkKW
         tZFTgagaRf3rE5cxbgf4iBwRVaMQi93roXB79UOUOjc1WzB3cpLFqjHQT6EUpbGDgaxK
         McjnQXw4AH9VmwKuQ13HYKAKLUXQkP2QuJgvyQxNoBQBVYBh/XSHgDWbWwTJc4AOuwE4
         B7OA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776925022; x=1777529822; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6qrM7qsAzBHvv/VI+HqLPPP6FQ3qhsBu/FQQBvDaXwA=;
        b=SeCnUT6BejVjU2ir7vZaziccxdydYErfSpoGvKnD6OoaPD0ODY4QWCWlVS8zNHBMF5
         MTFYU8knUwLP7rdK6Zb6VJZ/fcfGuOvHuR/IMRWBjpzj67sWqOg4qECN7s+P8UljGgPs
         VvVABHeDPcFWvhTIQmAuGQNrNgKbTH/PGVgHIv2ngroOLy8fzrq5zUquvpB8jZj1Wf8K
         +VRT/DPe9AV5CVNU3b3MxaecW1WbwKcyJ7edSjIlsVP9EzDP0iZzVo056IXTyf0I7p38
         a4Lo4y2hD01G8mc2jQpxtugfTrdu5gZCA3S6r9DPjPjflWbfIUtTUJiXRMN24eo268Bj
         Ugpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776925022; x=1777529822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6qrM7qsAzBHvv/VI+HqLPPP6FQ3qhsBu/FQQBvDaXwA=;
        b=b0c9ideXtxwyEp1v0qww/icDntWjT+GLwUTAuJNMHOYsqLpbK71SwAG0O5e0eaOyU3
         4KTV8iBUvlehHqEF8FRy8FmuFp1UfUbFB3mnPOcOIuoBPnmsEdhsWoHQlFe8tP+ePbUK
         9f/vy1sQVhgS3+D+1nmFG0y0oOdij5+QiC6371KDvdZ1CzjuyN7hOK+RiBO9EbhKeL7G
         4tWEiIbN5LXoOBih4OOlarEYaoze1xADfCe+eEJA2WuCMqjPO+uSt+koQ6kiqeFVoWKV
         28nxqkcX/dafbHPR7imYen9+V6udKjsELFhJjsjGwgScB4puRscOwzjWGoF7WHKgREwq
         FODA==
X-Forwarded-Encrypted: i=1; AFNElJ8BHaPXeR1WiwMkjYkoaMN8J8rSwMM8UC/vcHkGRs8hZAnSPLD0bBTuTzfY2lS0aCPBMUFCkZKkjw==@kvack.org
X-Gm-Message-State: AOJu0YyzTUFhb/ockSUq70R5clniaB7BxbwJ7Sfhcx8nFFd+lIUHCWqu
	Cpi5GGEGwMcn+Y41jRXyUpZWy/PS/tNb2V4b2YVxzwJ09PAUaZqjIe0hFXPXAf41eJ3js7a3T6n
	VkHsKNWdbogvQeA5OGYTw6vSZyYajfE8=
X-Gm-Gg: AeBDietQsnOWS6w2M8C2P1f+MV3sqdqoT/qITm5Qv5GWuGAevSgFu1wUMfBrRr7PXUl
	XzVcS1EZaXsXsEdZLuigm65La/au6ZSlJiyBUnToE6Jh/dlxNX82Cz39D+W3QJvFz8GaCJndVoE
	imGMrXL1Cx4D0vm9F/wJHTk7/wQFVqGGUHTQ2eFEqmI32ZlPgD/GMvYskIgS1r9orMCm6mlZLy8
	/eEcfYK1puZIhz4L0b3t9xLvCcjFH5U1CrzhP5Mu7C/k08e8R/cYLGkrMKB/LHD9fzPmtG4fk3q
	3ZxvvvfjLmv7vJimWZaXpVBA6yJ72qnEUIhI/QYLbE4TwUVXcUE=
X-Received: by 2002:a05:6402:24cd:b0:66b:aa56:ee5c with SMTP id
 4fb4d7f45d1cf-672bffd3a22mr10256938a12.28.1776925021636; Wed, 22 Apr 2026
 23:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com> <aektdlD4npMVThu3@google.com>
In-Reply-To: <aektdlD4npMVThu3@google.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 23 Apr 2026 14:16:24 +0800
X-Gm-Features: AQROBzBVGp3guci_2n97e7eFyFpR7BCikY1iYf4lyc9Y4ueJzJNdB9B8Zs-KyXM
Message-ID: <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A8A9714000C
X-Rspamd-Server: rspam12
X-Stat-Signature: 8dtqwagw46hu6knkzqmx7h1am4gdedfj
X-Rspam-User: 
X-HE-Tag: 1776925023-871756
X-HE-Meta: U2FsdGVkX19+7e2gp1+F8lEA+Ng3Hj0DA9/JopzBdC0ttosHdDHOxgTHFdNnSnqs4DjcadgY5W5TaKo21UfYzx7PSG/xqiv67jcPdbZA7S8EPbrGPLZr4RqmYojFVjwIH67hZgdmQH3jLnB6jobRG6ATc0FQGDlgrGEibim35f6KCDwy9SSQb2VT+XMnAxIf+GAHoLs3NUlYfKBdh72hrFiTN+VyFylVkzL3OTWiCYFhWjEPGvxCaMaHbcrnDqHcNCgKRnXNwtgSxW59OARbJENPG0zLjVF+x/5EJSjG1BvGTRjMrz4uXLzWQ83zR/bIRV2NfRRS+x0VGbezXjSF7iSa70AOFg1ZvTlf0cd1QEHMI4aIrGSzpmjB5tjZlP724pUYU/pPlok2BFLMmDph5su+rXyrYo5tZpscYZKYqzVTv14wpC9PomW4MqYozWWFCBqfuhf8k/H6yp9ax/sXZ6LQA8fdP2uu7Z1drL7WDVRwpcEYT+5e+wfDsw/erxf9tf4uSMkPT5jKQN+eDKAA1MPL/JLb9Ke0VXEtrAnj7TnJ+MxtE05mjYOlAkMFEivB6NJJUnT3Vq4QPFeEv25lsb6Cw5xRPeUZxumqHaoRkwBbxy3eSyC3zhUEjP+A0DbVTa7Wp6ezrJJOr/pgzCzW7TLOM2tY//JiOf76ot3i9R/vlFqY0wkb5Y3fjzwPsFXTM4e4DAkWnqvTDfqqmMISV/Z6hBhak4KoUSiiV9OTkhjViOcDeketEBI+5a1tSfz8L2+UI1OhBYRUYk0Sex85Qlv8DBquE4hPpYSKKnQe7lP8G99A4f4jT1oBYc9+3okMXYOCmxrdiTCcuyTAUu/dnL7WlwNLTIyCOM8t+XeVf0o24q86eh92yrTrhSMzRyPcW6kGtRRhfwLt1Ct+NR2EUt+0lH6VjDfgWu2IG0cXfn8bwJfzP3ecFUgNl5b6f0yP+Als5Mcmzplo2nqkriy
 SJNM3JB6
 9dAxVqfy7HFQkoGRJRfS00M2NxTI4jxadJ5Ce4tY1NnM10BL8w5XN9C+JLJaLSoN5yUI/VDK2xL1t0BWrCat1eQZwTuXpZkV9/i5Xb/xa/iO/ktFr1lzBQQvNL3W8z2lNnF3CJlphfdEpa5oSdzDbXYksRUTsz4vR510ZgYydjMQcHz5qi+EAtIV1hG+sqyVZsWxu7KsOFjPC5dkOdMK09+vocPRjEF6RTylSpzIU3MIYefyGsc9m5eyaArd5YBA+opBMNedhyhYxn1ZwOMURLA5iH15xV8qaT6zuKRNpXUoUs8FAmnNf7MBWmMuJxzvAYHt6xo2VN2njV9/usVkXbL3mlHYEyOgPh+16A1sURkqdaMYmU2tEiVCxpc60mCN1l6sQjvXWzaf5Yxa1OZHo8zZv9sUrSEJQNVlSrhC0ZM1dnwdfnJF99640GEJjZh0V0IS35gUCMQoA+FaeMsH3U8aZFc69jUVcqcFIQAo7sbb/9yr+tfz9ZVhnGUnln6KYts4vE9OwTLy/n6QRFBtgJXTz/0ebU6jrnJ2F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 4:27=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Wed, Apr 22, 2026 at 10:18:35AM +0800, Kairui Song wrote:
> > On Wed, Apr 22, 2026 at 8:26=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Fri, Mar 20, 2026 at 12:27:14PM -0700, Nhat Pham wrote:
> > > >
> > > > This patch series implements the virtual swap space idea, based on =
Yosry's
> > > > proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
> > > > inputs from Johannes Weiner. The same idea (with different
> > > > implementation details) has been floated by Rik van Riel since at l=
east
> > > > 2011 (see [8]).
> > >
> > > Unfortuantely, I haven't been able to keep up with virtual swap and s=
wap
> > > table development, as my time is mostly being spent elsewhere these
> > > days. I do have a question tho, which might have already been answere=
d
> > > or is too naive/stupid -- so apologies in advance.
> >
> > Hi Yosry,
> >
> > Not a stupid question at all=E2=80=94it's actually spot on. :)
> >
> > >
> > > Given the recent advancements in the swap table and that most metadat=
a
> > > and the swap cache are already being pulled into it, is it possible t=
o
> > > use the swap table in the virtual swap layer instead of the xarray?
> > >
> > > Basically pull the swap table one layer higher, and have it point to
> > > either a zswap entry or a physical swap slot (or others in the future=
)?
> > > If my understanding is correct, we kinda get the best of both worlds =
and
> > > reuse the integration already done by the swap table with the swap
> > > cache, as well as the lock paritioning.
> > >
> > > In this world, the clusters would be in the virtual swap space, and w=
e'd
> > > create the clusters on-demand as needed.
> > >
> > > Does this even work or make the least amount of sense (I guess the
> > > question is for both Nhat and Kairui)?
> > >
> >
> > Yes, this absolutely works. In fact, I previously posted a working RFC
> > based on this idea. In that series, clusters are dynamically
> > allocated, allowing the swap space to be dynamically sized
> > (essentially infinite) while reusing all the existing infrastructure:
> > https://lore.kernel.org/all/20260220-swap-table-p4-v1-0-104795d19815@te=
ncent.com/
>
> There are a few aspects that I don't agree with in this RFC, and I think
> Nhat and Johannes raised most of them. Mostly that I don't want to
> expose ghost swapfiles or similar to userspace.
>
> I think userspace's view of swapfiles should remain the same and reflect
> the physical swap slots. The virtual swap layer should be completely
> transparent in this case. Userspace shouldn't need to configure it in
> any way.

That approach is definitely doable. For example, with that RFC we
could simply drop the interface I introduced and enable it via a
different knob, and that would be very close to it. :)

Using a swapfile to represent the virtual layer externally just made
it more flexible. I agree that the RFC design was a bit confusing and
could be improved. There is no technical difficulty in hiding it from
userspace; it's mostly a design choice. And even if we don't use a
swapfile to represent it internally, all the other infrastructure can
still be reused without much modification.

Using a swapfile does have its benefits, though. For example, the
virtual layer could act as an ordinary tier following YoungJun's
design:
https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.park@lge.=
com/
It also means we wouldn't need to introduce things like a new,
virtual-specific swapoff mechanism.

> In an ideal world, the only noticeable change from userspace is that
> with zswap, compressed pages would stop using slots in the swapfile and
> charging the memcg for them -- and that zswap would work even without a
> swapfile, by just enabling it. This is admittedly a user-visible
> behavioral change, but I am hoping that's a good one that we can live
> with.

Totally agree with the ideal end goal for zswap. just not sure if
that's the right place to start for this usage, zswap doesn't always
apply. For instance, we have SSDs with built-in compression,
software-based storage stacks with built-in compression and
deduplication, swap over RDMA, and, most notably, ZRAM users. They
don't necessarily need zswap or a virtual layer, and the upper layer
better be as much simplified as possible.

> If there are real concerns about this, we can discuss things like a knob
> or config option to keep charging zswap pages as swap slots (ew..) or
> only allow zswap with a real swapfile (double ew..). But I am really
> hoping we can get away with changing the semantics without doing this.
>
> We can add extra interfaces for virtual swap as needed, e.g. virtual
> swapoff that you mentioned to clear the swap cache, or stats about the
> virtual swap space (which translates to memory overhead).

Good suggestions.

> > It cleans up a lot of allocation and ordering, as well as memcg
> > swap lookups. Since some of these problems were also observed in the
> > vss discussion, I think this will make things easier for all of us:
> > https://lore.kernel.org/all/20260421-swap-table-p4-v3-0-2f23759a76bc@te=
ncent.com/
>
> Yeah I saw that (but didn't really have time to do anything else about
> it). Splitting this out is definitely the right thing to do, and the
> series looks great from a very high level. Awesome work, as usual :)

Thanks!

