Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68190C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 21:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417B46B0005; Mon, 13 Jul 2026 17:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEDA6B0088; Mon, 13 Jul 2026 17:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3056E6B008A; Mon, 13 Jul 2026 17:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F41516B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:50:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7990E140194
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:50:00 +0000 (UTC)
X-FDA: 84985096560.25.26B2438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 900121A0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:49:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X8nWQ7y5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783979398;
	b=llTUCJSayqd4x1JEMZ0EBKO8w2icLo/cu8FWKW7cGZlBFAaVPK3Y9ptOu35C+a/lsddET8
	AnbX7jqDN3/VcTa5nST/PBwY/Y9SNwLKMmJY0TUMc0dn9SMqJAKn8AcLdVGSnDPruPGNk6
	zTFzTe9b/44EkRha5Mv2dpgWN7azWNo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X8nWQ7y5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783979398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1LxEGkWwF9grkI8B8e3VnBbGRWm0GD+OzdbQnvtfqI=;
	b=klT1AqZ2wddLiOgCBesO+W4F9hbP/RDTk3x4JWjpp+uU5piJOE99WQ5CJ7LY0GwgQXuLrW
	cNO0BX/qQsoqnFpr0IvWqmlUR76LYS9+BBLFybHE+xg6c1QeJvS9FgoUJGSWDaXW33bD5f
	cNmGBDQ9Q5GM8/IoZpQbD8EE3uhl6do=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86D9D43B5F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642641F0155A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783979397;
	bh=f1LxEGkWwF9grkI8B8e3VnBbGRWm0GD+OzdbQnvtfqI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X8nWQ7y51HrTb42UThg5sBmCbyDPvW2uM17JjqpIzQAPLLo9RkBnqo2/nkqEOwGkX
	 /drhjE0T7HZSQKyMq3GZpvck76THY27FIivyQNmqfBnWQTPZnJeIFumaNo5W9pqwMn
	 vKIrQPxYjH8uV10B/jGtubq64HVCq6bpnoFtlnLke/6aQzRNxCaS4+fS5Tvv0vx9SJ
	 TsHpEbboml+XLb5VJ2dGRsLOgs4SiNYpKYBI7wcon2myV7wZDme6lpF0P0FHF+M8RM
	 +WLQVH4qzMaFUSi0qr9nKXH4GYL46+FZjbq4sctjl/OkeMR1BENj3q3MENbxeJwi76
	 Y2tGcOMrgo4Xw==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-667ef69424bso1815850d50.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:49:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrp5rCf6nXF8JSaqDbSEy8hNMZRhowAEustqN9B471bMv/Fz/Ar7zyAfXT6/EHyMW5TmPx9ppV2gw==@kvack.org
X-Gm-Message-State: AOJu0YyZRHMx4pEc9+Y9TMuOBfR53d/37FSMrA8CV4Ats9XsVVb+ltuA
	IxO21UOZA9CsIAKNhps+6Tv98n9qhChuK4/UFBHk8mRUylOGPx6ds9zV+kJ460YXCNlMty7cV3f
	Mb9nxwUunx8ZQTjKoKg20ZSIWlDdyb4W2NM63bPlMPA==
X-Received: by 2002:a05:690e:4803:b0:667:83ad:b3e6 with SMTP id
 956f58d0204a3-667d7a949e5mr5088170d50.16.1783979396512; Mon, 13 Jul 2026
 14:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
 <CAO9r8zPtcne97wQKZFsNoMS-4zpTFvaA3EU8ghnEHPfwD28zoQ@mail.gmail.com>
 <CACePvbWOm3EL6Ph+A_NgAp80GcQt2N-qW1qbyxOVDL3EZSAh8g@mail.gmail.com>
 <CAO9r8zO4uW=SX7se154Z6+DrxfawZfAiRO6Ar5rUm3T78x5HUw@mail.gmail.com>
 <CACePvbX5oWcTRpQeBCQsod5C5KEhd-0vA4B1PGYddNfgTW2tvA@mail.gmail.com> <CAO9r8zNjouSvVABM4WhsXu8Uzcbd53gLEK0SXLeDMKJm1PeLJQ@mail.gmail.com>
In-Reply-To: <CAO9r8zNjouSvVABM4WhsXu8Uzcbd53gLEK0SXLeDMKJm1PeLJQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 13 Jul 2026 14:49:45 -0700
X-Gmail-Original-Message-ID: <CACePvbXt+6R3BcTZWnU=xgqUx0Jmhv8tOKASwhmBSYR_qHYgcA@mail.gmail.com>
X-Gm-Features: AVVi8Cdmy5FSejRgCuCwudbpOr1s_-ZdmoYi1-fyB3Ixs9dQBg7EENWp7B5cyCU
Message-ID: <CACePvbXt+6R3BcTZWnU=xgqUx0Jmhv8tOKASwhmBSYR_qHYgcA@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 900121A0003
X-Rspam-User: 
X-Stat-Signature: y8abtmnqawnss5f5hpx5si876e3x1sx9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783979398-352671
X-HE-Meta: U2FsdGVkX1+3jMXpvZTQHJt0mEic8Lus9qdSpxoTedvnIaCuS56L9pmubar+5txZjhBF5zUY4nkF3tpDY7gI/Q5jBs8Cf/IRTeOPnUxGI+RbNUgTwfjB79pMygAZfq3Ox+mEhiLi2TgxoIxmmgcugda5Bvs4bd3gTgiwm/3QG939gBNjdTVNI5gDcmHen2pW2BUYJEtudr/6i6OO+GntRzrRTuzu8wgXpqUa1Qy0ZcHPdWurKwDE1NFTudl2bpraz51XnZhllLF8VhiJqR8hW047G0VLcV6w+gjm+ZSa/1v7iZPrB7/tP6jW3lHGixjhXo+M9JhOfOUuud1VNsMGSK1Kcl1/p6reTphEYiD5M1nBPm+lIVK9AVQ7T95IBSjn6zzsaOZNsqHQ7I86z4mVT/7Eg3+0tU0KPYL2RRBdFw5C5YrRUikxoAANSNAIWVBf4vW6RbI8No5+Jq3fToh4aTvxj8n23t1D/fZmUyTLq16B7v+KnXQZfieGQEjIqZrOP3+gsiEQpEOPf7te7eVs7VmfBCVD0HoTqJqx2QN2vN/RxabjoM1vjar++tdT7mGsXqHJ1W1aPtktM50LXHK/7mDt3sKR6JjtD5j9/9678V4lD9G2ItqrJ3AWMBAFIzR9uszrcIKvAAeIpdxzcI8UEmC7Y4v/hhX+tWyqj6lR2OEMK9btocGHpaFPEmcw6FPgLvbfxlj205BZwXckwqDj5RLBcLnVCeIBJ0WFyqLdnKwPlogudRZfai/lwv/gR6lSZp1ZvhdFSt86zpweS/IAnu7JXhQ8I2vl6JIWnl3deIuKJ/sgKq1K4mG5bR7K4FMPx5tKjXG6DxgqW/XBDH+ZxyU9lRWotcYflL6SU7FkYyBUwopdYsMr7L2geN8mkm8ZVudfqjOA1/wAHmaHXiPW89oaSvf1Sj7K50iT/FBIlvAjZ7eNTwJk8jLfIRP8DLdCIoo05LudSaWBZ79/0Kw
 EQxZ07bO
 pkf8F1nlMEFBmysuJ9EXjMBflQVF+uMLyNHo3O8ViJEB2Qikjcgqrc084rWmG0eG47+6rx/wRAygED72QAcgCL8N2c9p4JtR6KGLeKkCoJLI1qOEuJ6Ifn6l4temdyhQQnbzMHoTB/m706lQEV2DwXXaGXf2nDEKnY6ZXxDY/MMh2FVlEEJEmGgoLprZY4Nq4u4Yq5iWz4Zj/QpFU92O5OcfvKVPV2rc7dy0ntITjLllR3e73JaSCOoMsVHEingnSe4yzZ2RmeeK0wbmc1I2U9OjNBpjnXRTuIj9wKReNJahm01gt+Hp8Oo1Rh2RtIz/L9MKPulWaaBscTj3aedFhPxtFhmEiUVpXu6ym94e796FG8gY02iJrVXLm5QyupV25w4ek
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 12:57=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Mon, Jul 13, 2026 at 12:39=E2=80=AFPM Chris Li <chrisl@kernel.org> wro=
te:
> >
> > On Mon, Jul 13, 2026 at 11:38=E2=80=AFAM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > >
> > > > > > Zswap will not be introduced as a tier. The existing user inter=
face
> > > > > > makes zswap not exactly compatible with the tier ordering becau=
se it
> > > > > > sits in front of every swapfile. If we change that, we break th=
e user
> > > > > > interface. I suggest we keep zswap working as it is now.
> > > > >
> > > > > The goal from making zswap a swap tier is to have a single framew=
ork
> > > > > to configure swapping for a cgroup, instead of configuring zswap
> > > > > separately. Yes, zswap currently sits in front of all swap
> > > > > devices/tiers, but we are heading in the direction of changing th=
at
> > > > > such that zswap is standalone, at which point it becomes more
> > > > > obviously a swap tier. If you want us to wait until that happens
> > > > > before adding zswap as a tier, I don't necessarily object, but I =
want
> > > > > to make sure that nothing will break if we add zswap as a tier la=
ter.
> > > >
> > > > I'm afraid your zswap user interface will have to break. I don't se=
e a
> > > > way around breaking your zswap user interface to fit the swap tieri=
ng.
> > > > Once we move to the swap tier world, I don't think we should contin=
ue
> > > > using zswap.writeback to control the tier write back behavior. We w=
ill
> > > > need to rethink this new world.
> > >
> > > I wasn't talking about the existing zswap interfaces. I want to make
> > > sure that if we introduce tiering initially without zswap as a tier,
> > > then add zswap as a tier, the semantics of tiering and user-visible
> > > zswap behavior doesn't break.
> >
> > No, the user visible part of zswap must break because zswap currently
> > sits in front of every swapfile.
> > I don't see any other way around it.
>
> If zswap becomes usable independent from a swapfile, it's mostly
> transparent to current users.
>
> > If you do know how zswap can interact with swap.tiers without breaking
> > the user interface, make a formal proposal and lay out all the
> > details. I did that exercise myself and I my conclusion is that it is
> > better to accept zswap is the classic behavior without burdening the
> > unified swap tier too much.
>
> Today pages go to zswap, and when the limit is hit they get written
> back to a swap device. If zswap is a separate tier, pages will still
> go to zswap and then when the limit is hit they get written back to a
> swap device. In both cases, zswap writeback can be disabled.
>
> Can you share the findings from your exercise, and why zswap being a
> tier is a burden? Any specific examples?

It is all good when you have only zswap and just one other tier of swap dev=
ice.
As soon as you add one more, e.g. zswap -> SSD -> HDD will make things
complicate when zswap using the HDD slot write back direclty to HDD.
Anyway, I find that this kind of highlevel hand waving discussion of
pros and cons usually doesn't produce the useful outcome. If you have
a detailed solution for how zswap works with multiple layers of swap
tiers, Laying out all the details and even better, providing some
incremental patches, is the better way to proceed.

> > > That being said, the existing zswap interfaces don't have to break
> > > with tiering, why do they? We may end up with redundant interfaces,
> >
> > Because zswap does not have its own swap device, it borrows the swap
> > slot from the underlying swap device. That behavior is unique to zswap
> > and none of the other swap tiers have that.
>
> Yes, but we are heading in the direction of removing that restriction.
> But I also don't see the connection between that and the current
> interfaces breaking. Do you have any concrete examples?

See above. This topic has already seen a lot of heated discussion.
Show me an incrementally mergeable patch; that would be a better way
to move forward.

Chris

