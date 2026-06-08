Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D8FCD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE426B0005; Mon,  8 Jun 2026 16:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF496B0088; Mon,  8 Jun 2026 16:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5176B008A; Mon,  8 Jun 2026 16:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2DC6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:19:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAE7B1C1C6D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:19:47 +0000 (UTC)
X-FDA: 84857861214.05.F47A39E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 05DDC20003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:19:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CCaq9/IJ";
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780949986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2E8zGT5xOyDSmdwu3J6sYJf2Yq5VI7x+0ZWpD9LyuJc=;
	b=iQpi6mlfA/m1Ohe8S6QlEhJRfTQwy0RlInTVEjaOyxLvJWcVRqyeTAmBAtRJFC2Outwch0
	WtwmfKbJdSjNx6kLSHJqmkKZl8ry2/HmDDLbzvOLXK2C3Diyllm6OtmxcgiOR/X/acn8tB
	Sc8t3vVi6aVNdhyZA3Vriam6owOJ+l4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780949986;
	b=R5MsVoiZ9GNpiaheInqhZbebDJU3vA4qMdsXIZkjgGb6pYd1MtGZKKDpYS5EzFdnO295hJ
	lc9QFgdvFlXFUztlVk4BghtrBa/t8a5QCiKW7s4dLSvIt2ejaS1e+mCmZSh87E0q+qxNJk
	Z3rtVOF6fVO3U7w48PHBYeguxsEPO/k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CCaq9/IJ";
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D0D643671
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43FC1F0089D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780949984;
	bh=2E8zGT5xOyDSmdwu3J6sYJf2Yq5VI7x+0ZWpD9LyuJc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CCaq9/IJBxuXvV6cfEUyYGqZZ353g2VavYVoMHw1Mj4h5NVjZQEIv1MgkROtD1YJZ
	 gh0mQJlrVUQzwSufctn/wjDP1PV/3djpyJngB01kGvXnGK+OVsuLdA38arOor7pWfG
	 lTIAxSurAPDs1exx2/1WemHtIy7dgJNXs/FQx17zYEFRBP5mZRfGUw60iW27LLuTns
	 702QcNjyLcS695xsH9orvhNN8wlZl0GAlt8imcu2xZQxJRGhAbkmAdAxtWjqciUWcZ
	 qZTkoRkmnCw4O/tKRQlxWwSoR/v6D7lcoULAnhP87wZNM8C17IP1/OWHlmZUgPelis
	 1ooxkgVGXhHzA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-691c5776f95so2237534a12.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:19:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9HjlXE91AK7PfZNVH/gnQikKdXgPYSV+RfkaOZoB49g8VGOK2MEJN1rVw/TM/IOHYOmxqFue7BHA==@kvack.org
X-Gm-Message-State: AOJu0YwiMXTSO52Irb+Ka66oncV3jENxVE8ymNaYk5cepPJmOIwPvnaE
	0uIi6+9bYLzQN+f61bhf7CN+cu3oPLNQ3JRT8k0I8hC1GrFHnzTwsEQcBhvchLMZ2jW6hbcZSA5
	UNIr0LY+1g4cV2pwC1f9U/HkxCnhOjw0=
X-Received: by 2002:a17:907:9812:b0:bec:18d5:ddec with SMTP id
 a640c23a62f3a-bf37311392cmr824666966b.41.1780949983628; Mon, 08 Jun 2026
 13:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com> <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com> <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com> <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev> <aicZ-5GX9De3MAU7@linux.dev>
In-Reply-To: <aicZ-5GX9De3MAU7@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 8 Jun 2026 13:19:32 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
X-Gm-Features: AVVi8CeXOXcjGUkNg7x1wCjnQhVCU2d5Mo_U0_PWWSBCHknTzqRDtrc94LmYLm8
Message-ID: <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 05DDC20003
X-Stat-Signature: orkfprm4fomqa4qmk48wp936kugpowuy
X-HE-Tag: 1780949985-8524
X-HE-Meta: U2FsdGVkX1+eNHZNqrffgwSwfUgvUwQ+kbmrb0VxPo9I1FUAvG8qMvSmMs7cjqwomAKxkEAP+lFu/ZZCy1BHmvD6sjtRLl2GHsntogJUBAqpDvP6q74nidd5KSKdY4lWgF5+FFZ84qYivLAq61S7vF/nCmuV2WwbT0U3i8McG2ePwTKbZ8g8/lukvEI8Qdw7d/tLRuIyWUuPGHAC3pOXmFFOcAZTcnAOcvnk/+9o+YC1HXeXuHJH36e0nTZadOmyPwTJHHwjFQK0EOz6Wf/0IeGXmKKCH5FighuFndypCuL15OK0DXHq967U4E6SjNwZqaofwp+FTt63njLzWf71jM6SuFK4xUltoJk7nqLagiz07F3TksITRj7VoMCG2TFWp8TbF0AkYCLTnBUl5z+SHcPGqp/K00WOF0oPnJnnKWiLruVtODJGFdF7DjdC0o3eVIfXZGYgktOpJwl593jyUxM3to07o3MEGMlpf+5TD0i9ahJ798AdxNbLq8XWJwVMVE5CiSnPJksTGLOGcxDcimLOZsVnCWXnXaWB++rQDi6Q+WKaJiwbYAj0pmZzNdMHq0oWeMc0zxJ4ffzysEUImJO6MRXxzuBCma8yxnPmZxeOIJM7i6oFOwQYbDlmQLXl47jMkqReIksYgVW6XR8Y1NHFCv+h2aGih17w8VZL7g8euns1Q3/sv25FLXszzw6Cv3IJuM5+disblLC8vt5nA11AlcJ9p4yguq5O4MOKe31QmsvZEFa1wDxJ1fYdPPpiMgLuXInX72ieKfqkLaWxZD3hCfmvE7qDgiKw3pWeIMo8ZQySZ9O2ZOvP3aQ3LdGAUgSBJKyE2LM5PYNApQjm8sgY8/i4hVBNxIIdvuO6SIAtPPde4qqPEmErmRZdNyo/HJ3u/Tk1P9A0w6dm4IgGb8/9UA/w3wdvUu9i5IFNvN6RghzI0I6vKhMpzkZ1mKHcnn3U5BgktJdKSTlh8dl
 BApi5NIT
 pvuCSTVf0zIFqS9kXGhsEIxnukGpH8ftDbFz34vA+vokCl4ppvZIVTXizL+OHEKfsSnRBFljHWIJr/FU0DJVfT8B1WhcFDUjAN1FDSU/031GR6rFJaoUt2gwJoQNCpwIwBi/OaOFaV6uJ0wvZGkcLxmTYqpUi1wH7s5fhm1/nqTlR4NWhwOh/Y+tKaoZZG2qjR0YAueHUnHxOTfZPl9Uf9FWBtHMK6FPahXx6+r1B+Zj+y7en9DNJP0CCiqIPGqeGiRPeLyZqkAPHA9AZdyBH1MZjxzvFn4cNxRiKyr22nwGVybqXjEuDHBBLr1kS3OqVYndvy0ZXbdLMLI59XojxoBvV6QZMJN/ZYHhHjTTmnWrnZTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 12:50=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> +Youngjun
>
> On Mon, Jun 08, 2026 at 11:30:30AM -0700, Shakeel Butt wrote:
> > On Wed, Jun 03, 2026 at 10:36:07PM -0700, Yosry Ahmed wrote:
> > > > >> But doesn't it make more sense to specify the compressed size, w=
hich is
> > > > >> ultimately the amount of memory you actually want to reclaim.
> > > > >>
> > > > >
> > > > > I personally prefer compressed size to pre-compressed size. That'=
s
> > > > > kinda what user cares about, no?
> > > > >
> > > > > One thing we can do is let users prescribe a compressed size, but
> > > > > internally, we can multiply that by the average compression ratio=
.
> > > > > That gives us a guesstimate of how many pages we need to reclaim,=
 and
> > > > > you can follow the rest of your implementation as is (perhaps wit=
h
> > > > > short-circuit when we reach the goal with fewer pages reclaimed).
> > > >
> > > > Got it. I will change it to use the compressed size in the next ver=
sion.
> > > >
> > > > Yosry, Nhat, should we continue using the zswap_writeback_only key =
to
> > > > trigger proactive writeback?
> > >
> > > I *really* want the memcg maintainers to chime in here, it's
> > > ultimately their call.
> > >
> > > Michal? Johannes? Shakeel? Roman? Anyone? :D
> >
> > Between the options of having an explicit interface (i.e.
> > memory.zswap.writeback*) or a key (i.e. zswap_writeback_only) to memory=
.reclaim
> > interface, I prefer the key option. I have not looked into how much pro=
actively
> > reclaiming zswap memory or proactively triggering zswap writeback makes=
 sense
> > but from the perspective of memcg interface, I think the key option wou=
ld give a
> > more clean solution if we decide in the future that this whole thing wa=
s a bad
> > idea.
> >
> > Next regarding future proofing zswap writeback trigger, do we expect an=
y
> > potential additions/changes/new-features for this interface? For exampl=
e do we
> > expect in future we may want to trigger the zswap writeback only from a=
 specific
> > node or lowest memory tier?

The way I see it, zswap writeback is just a "special" type of
proactive reclaim, but the goal is still proactively freeing cold
memory. In that regard, I think it makes sense to have things like
node-specific reclaim. Not sure about other extensions, but Hao
initially suggested making this age-based, so I think the answer is
yes.

For both of these examples (node-specific reclaim, age-based reclaim),
I think the same semantics could apply to memory.reclaim in general,
which is why I suggested making it a part of memory.reclaim. I also
like the idea of having a single proactive reclaim interface in
general, but maybe we don't want to overload it too much.

> Youngjun is working on swap tiers. At the moment he is more interested in
> allowing a specific swap device to a memcg or not. I can imagine in futur=
e there
> will be use-cases where there will be a need to demote data on higher tie=
r swap
> to lower tier swap. What would be the appropriate interface?
>
> BTW does zswap folks think of zswap as a top swap tier or something diffe=
rent?

I haven't been following the swap tiers work closely, but personally I
do think of zswap as a top swap tier. Things will probably get more
blurry with memory tiers and compressed memory nodes though.

