Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAADC9831E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 00:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1436B008C; Thu, 24 Sep 2026 20:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551B66B0092; Thu, 24 Sep 2026 20:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4404B6B0093; Thu, 24 Sep 2026 20:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 185CC6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:44:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92BD116050E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:44:13 +0000 (UTC)
X-FDA: 85250437986.17.BE11641
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A1CE91A0004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:44:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYI9kiAb;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790297051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7CueezjDbKGuBoVz0Yahi05qKiOZJU4eRx078XbgJlA=;
	b=WnIPLeza0UMEzUYIZOKRaVedgS1iqUEsQ7GVIRo/FFGxmSZvBJvLibcHQ7wk3RfDed/euo
	m4swLYVkV78x0mlufQrYdZeNCx2TEzZSXz0Jt60dt1Zy2SYlltFE321OFHceqQGEmcuyPQ
	0FGwvZgvHk3Booepa+VbkSbbwPABm58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790297051;
	b=p8s2p4MEJzkHMOfRWdHnntunWJhyWg9ax4IezWYzjHMZ7VETH6K3ebBEaM7cHx3jeBtfTK
	2E83ytKmPFoAJ9XAIZlVhWWlc0LOGl3ttu0b0wCDVOzNOogsZe91TGJy6pMAbgB0fJansp
	6sWSLkycch+72jWzpC7/Mupyr/xxA3A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYI9kiAb;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2080943FF1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4451F008A3
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790297050;
	bh=7CueezjDbKGuBoVz0Yahi05qKiOZJU4eRx078XbgJlA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YYI9kiAbgX1TdDDAgkEuTAlJ0KkFp2+uT33t80rtu9RyLC5Hpa+cT70M7QH/STGJy
	 GtljrnarEHB5Xu4ajcF+/FpnXGlmLXBtjMOb18yXRgaUhSE3l/d4jcqByEvokX9q2x
	 4w72CE7EtH9tbtbyjg3tA/KbT76ApiW/3uSk8LVyD4M7qlcK6pFDdyJd0FTXg4UMJA
	 S93Z618G2yRMrr5zbRV3b7u6v51Q80yCLRwbRceYbRlRJa4EsV2O9ycmvvipDAXblS
	 QJwDkYqSq5zoTGyvQ0Brl6UeI9UUszo1U1HuyHWDxo+Ujp8us7rs7L4hkelY6huZzK
	 C1EVsXcStG5tQ==
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-67375a844dfso446971d50.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:44:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx4xx0vYLcz0Ttgn2sgqNKEYH6g9SZvRVZInGj/uC2vroFfSlHfswRFRGdh8nKiujMS++CpGNk8EQ==@kvack.org
X-Gm-Message-State: AFuF++mrzgrPKTBjuj64Uk+a1ddrzIPbFdJNE6vLExYMX2QV5904MSQn
	2fXJcADOx7ex98EHWfchNuh5/8EE359rR4lAj8D/COHKDQGs5UTJJWZlXc+4M0u0TAYv7IQLlQz
	dMGNu64vhq/2lstfqEGejFh+Ypd2FEcR1E9LY3E9Otg==
X-Received: by 2002:a05:690e:14c3:b0:672:f5f5:49e5 with SMTP id
 956f58d0204a3-672f5f549fdmr2112852d50.58.1790297049175; Thu, 24 Sep 2026
 17:44:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com> <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
In-Reply-To: <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 14:43:57 -1000
X-Gmail-Original-Message-ID: <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
X-Gm-Features: AclHuK8hG4dvBqcdqpHs3htOH0tZw8UjHorplhBJiHcYxmcYx2dg2FX15nlFTP4
Message-ID: <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A1CE91A0004
X-Stat-Signature: zqhyd4zieu7ngyz6aj95fmsmtrp9ndsc
X-Rspam-User: 
X-HE-Tag: 1790297051-486897
X-HE-Meta: U2FsdGVkX1/ItnhklCQOnb8+aO0IRlvrGuGmAkC+NoKOeCHGHrZpdV7Je25pN9Lg05/zDfGS+Y+C7JTJYOSN7eFJQAJEL8i/uEuAKn9ASwcBXiIU96dx/B1VRDRQfy482ffIP7sjTv37lsLXL1kInW2RgFFZMoTKwHVaq0UyUQaeWZ7EZjg2N/MQHrhdUYGJZ+oeYW0OO0CJU21tInRuTQ4oOt53WHIuKHT+Y8StgYDNA4TLi6g/Y4bXiI27GxSqCmZauosgw765xVEUOMl0BpZz9AMC6xz8Z+fU/lrOxzHe6EcayZ0OSInCZ0WFaAb9EPBMIp/mPx4HlApBGIqdZGziVj1cqn7txPI4dHDELLiY2Mw4MVfgFPBKhuyLVYMDCHChWjxO5sbif0uV83Nz1Ubeh+DNmEHDWigCss8WEjhLE2wfarYXWbQ1Ozkx9lNY0x+ZcpwiYr4C+xfseuj63my7qrsNvnDE2kN8MdBa38CsJ4wdIchNgiOebl9mFjGakxeD+njTD5gHERPh38yZAl57a1ovXKzoAj2V5Ew1UBtyyT4PRlL9XKqJ5caZfAd57jE3eTZIohrHnffk9UYiGKZ0A2DPp8yI3y+wVbq/ilbs4xT0p9QBY2OwvFow7oga29RgFo8gquWR6le/QxmLW93mJV1e3Vd7UqAnL0HUaeiK0twk6HfpJnkqdL9FNRvdoJtE9kBx36kQ1iT8xz5moDKNHQwOXJclUZm2dNXpuaKQaeO1NWoTOdcsT3RRhbKcrklqUBbiq7kq1Jh72TsVhmwCCEd7JwnrQ/RUoqMFKVCX2Z1z23Leo2npCiIRYbTeEQfJ/WmQ2k8JmTtzKm+C8WFniC3gJ6haLMaoHOizMD2FJ4uwvAMCcLUR/S1felHAVCmZnb23HABTi0Iq6iZUQNVdIPnKGsZEU/niWA2bYp4Lo9cU4SozNHCkkiQ0XBLKum83W67py0hdZeCaIno
 ATBzmnF3
 BDWmzjlcMvjtbgFp/cMfe9eL5/Hpu6hqDr5RFAZvDoqUnGFzY426Rybmf7y34kEldCWh+KFTwRizRs8GpVkJaNvGKjSsHj5k5cqBFv6vPEZyy3jLT88TTgF+GoD7wpgBa6J0Ju3p6ndzKEJNsRIVO46sFwFn3ZMZwU9N2vAZB8QqdysuiFnpyrpegVc4CAMo1YZj1GNCKqdNWFJT6QGzrJiVMgO9iZwNalVUdlTqxCC2z53x7cLk4206paAPwYtkgICdomjdPYvmj+X7hkNTF5BdKLRb1tk3NwS0mBux3QcWBtHWL+BCcYGySSMMfQk/SFUNXDDAK0V6bkrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 6:20=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Sep 23, 2026 at 2:18=E2=80=AFAM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> >
> > There are too many swap_is_vswap() in this series. It fragments the
> > code path, making things harder to reason about. Esepcially around
> > locks. I count 22 in this patch alone.
> >
> > I consider this the biggest drawback of this series. This
> > fragmentation of the code path.
>
> This will mirror my response at [1], but I'm responding here for the
> record and for your convenience.

Thank you. Really appriciate that.

> It is needed because vswap *is* a special device, with its own
> requirements. If you don't special case-it, you'd get undesirable
> behaviors.

Ack, that is why I am against making it a special device. That is the
whole idea behind xswap. It is just normal swap device implemented via
swap_ops just like ext4 is a file system implemnet on top of VFS.

> Let's take Baoquan's patch series as an example.  It treats the xswap
> device as just another swap device, without any special consideration
> for it. Which creates several problem:

That is a careful design choice. Keep in mind that design choice
usually has pros and cons.

I will follow your feedback here.

> 1. At allocation time, cgroups that disable zswap might get an xswap
> slot, because you don't do any check that the device you allocating
> the swap slots for is xswap. At swap_writeout() time, it is *stuck* -
> we already do the unmapping step, so we cannot reclaim the page.
>
> Ironically a physical swapfile backend could have bailed us out here,
> but it's not in that patch series yet :)

I am not sure I follow. Are you referring to the uncompressible pages
that xswap would have to reject?

One way to address that is for xswap to just bite the bullet and store
the uncompressible pages within xswap. That way it will stay out of
the reclaim LRU. Zswap also stores some uncompressible pages. The last
time I checked, it was unfortunately not able to serve my case but
perfect for yours.

> Vswap both has swapfile backend, AND allows you to bypass it if the
> cgroup disables zswap. Both involves a bit of swap_is_vswap() check,
> but I think it's worth it :)

If xswap needs the lower tier it can allocate for one. I don't think
xswap should need to have swap_is_xswap() there. Also xswap does not
have all the baggage of zswap.writeback enable interface.


>
> 2. Per-CPU allocation caching: since all devices share the same cache,
> xswap will invalidate the caching of other devices, and vice versa. It
> would be fine if the these devices are interchangeable, but as noted
> above, it's not, especially without physical swapfile as the backend
> option. So you're forced to taken the slow path more often.

This will be addressed by the swap tiers series if it is not delayed.
This should be addressed in the core swap layer not vswap. Kairui also
has some ideas to improve that. Yes, it is a problem area, but it is
not specific to xswap. We are well aware of it and have plans to
improve it.

>
> Vswap gets around this by adding its own per-cpu allocation caching,
>
> So by being too lazy and not carefully distinguish the swap devices,
> not only does xswap not work for the writeback use case, it cannot
> even work in deployments where some workloads (cgroup) select zswap,
> whereas others select disk swap. It can only work if you intend to
> have a single class of device - either virtual/xswap or disk swap -
> but not both.

Baoquan's writeback series is out. It is by no means perfect. But it
is much closer to what I have in mind. That is a much better base to
work on.
>
> Maybe instead of just grepping for swap_is_vswap() and throw your hand
> at the complexity, read the code and try to understand why it's
> necessary first, then propose simplifications if you have good ideas
> in minds.

Yes, I already read your code I decide that most of the
swap_is_vswap() should not be needed if taking a proper swap_ops
approach. I wanted to offer you the chance to work closely with me to
achieve that, but you did not follow that suggestion.

Quote from my old email:
https://lore.kernel.org/all/CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81BYL=
grzA@mail.gmail.com/

"I am happy to spend some time working with you to discuss the generic
adopted version of vswap, if you are open to it. Or if you don't want
to waste time on it. I can have someone else or myself come up with
the generic adopted version of vswap for you to review, which I prefer
less."

Anyway, Baoquan's xswap writeback patch series is out. I suggest
following and improving that series instead.

> > This is questionable. A vswap device does not go through swap on.
> >
> > This changes the behavior where swap devices always go through swap on/=
off.
> >
> > I wish the swap device went through swap on to be able to start swappin=
g.
> >

>
> What usecase would necessitate the need for swapon/swapoff interface?
> Other than just trying to shoehorn it to an existing interface?

I like universal interfaces. Your vswap will break the /etc/fstab. The
current suggestion for xswap using sysfs will break that as well.
I would like to keep the /etc/fstab interface working, including
support for UUIDs for swap devices, etc.
I am very concerned that vswap will start kicking in without me
explicitly enabling it. That changes the previous user-visible
behavior. It breaks my mental model. Please take this feedback
seriously.

It is a different design philosophy to adopt a swap device to
implement VFS-like file systems for swap, making them swap file
systems.
Just like all file systems have a superblock so you can probe what
file system it is. You don't get a special sysfs interface for each
different file system to create them.
This aligns neatly with swap ops and makes room for future
flash-friendly swap file systems for example.

> I've expressed why I dislike the interface in [1]. Other than the
> sizing aspect, which we are already discussing in another thread,
> priority also makes zero sense. You are literally exposing an
> interface with only one correct answer - what's the point?
>
> Justify your interface choice with real userspace use case, not just by
> conforming to the status quo.

That is why I feel your patch series are really unclean. I dislike
special cases, I try to avoid them as much as possible.

Chris

>
> [1]: https://lore.kernel.org/all/CAKEwX=3DPEEkYiNRaVhCuM4E6mxB9huPKfkDa4m=
62VMTzedg1oYw@mail.gmail.com/

