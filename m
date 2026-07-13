Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ACCFC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 19:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FE36B008A; Mon, 13 Jul 2026 15:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57F76B008C; Mon, 13 Jul 2026 15:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70196B0092; Mon, 13 Jul 2026 15:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2BE6B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:57:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 208791A01AB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:57:51 +0000 (UTC)
X-FDA: 84984813942.18.7A202E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1EBE11C000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:57:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZIKYpWk;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783972669;
	b=mm9jydWt87ze1MOpn96E/IKtU9uPM85l9B0uAQoznnefX2EytfJnGlj9JlWRkOTO52x/aq
	dEZ93RUNDCrLR0EoIS4sKLnIAjeyFX4iPEvN1CGaiPa+prqM2+n/I1czhd/LY94K2sHfj/
	K65akWSrFqrVFZb7LR1Za4h8o+3d7/4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZIKYpWk;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783972669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lb0u9083uAGrWjVRQ9Qk+A8Z+iONhqOvEGQOCQR578I=;
	b=jE3j/F9yjeA9HixjScDwMJ7qZQEQ4rDGShJ0Av48CGNs7Ma8bef0qxpVID2Q2EkOEg/Re6
	Vx21cLKSF22Kt4r0P+DswsIm7vLAU5tXctV4I7SSBfVT4HkBuenOzB2Z3+1PebCma62X3z
	5Dxq2vN1ID7bTGrspvmGWjpULmDFKp4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B23B4384C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38581F00A3E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783972668;
	bh=Lb0u9083uAGrWjVRQ9Qk+A8Z+iONhqOvEGQOCQR578I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CZIKYpWkmwL7fBz0EYJI/nWVVRo8dIncc2EbkWJWCc7zPOWJBom6lr6vTsp2/8ZUf
	 WgtN82SoNrktYL/1fB3AW7AHfMED2SaWAWCOIJEZrY07ECr+wCuAd/QppjxLTCHEYt
	 /LTBWOE4ToV+91i3OPXdPhbPtEBUoFLuSJtl5nhV2oM9FQxYyL+lY35V2vHIpvXhzy
	 CdrK78U4870HwGn/Xb6Qw7bQOA3xOt5Zc7sF279cEpHvcisS1RvvqCX70/G5dlEvHX
	 MlrqgRtohaaiyj0G8a8eg4HZa4GqlaE/3kfYVnX53IFMfvq5FhnR1f5yYbIR2qIQhH
	 wb1AJLzkcB2HA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15ea93028dso389796766b.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:57:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Roy4YvGQb22R7+0WvjLT36bz0cvqkspEW+N94tha4oXP28XI7Bocn0z1YXVim7nsxWBwzBsiHuhlg==@kvack.org
X-Gm-Message-State: AOJu0YzAGzZd49tb4uTkPtC6cu92IlaeWa3YdNYYd8TMV78FOH/86gVi
	pvMzwhjeDTv5px1mn6ffY+Qy3bU4AzryfhHzTHA+/pPiGv98K6VYWfAmK28YtHp2QUNt98Xi3TZ
	eGnumwsldcgc+URcU3FctMsm7uHY3S/g=
X-Received: by 2002:a17:907:c80f:b0:c16:f32:6ca3 with SMTP id
 a640c23a62f3a-c161f36ebb3mr490349366b.46.1783972666876; Mon, 13 Jul 2026
 12:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
 <CAO9r8zPtcne97wQKZFsNoMS-4zpTFvaA3EU8ghnEHPfwD28zoQ@mail.gmail.com>
 <CACePvbWOm3EL6Ph+A_NgAp80GcQt2N-qW1qbyxOVDL3EZSAh8g@mail.gmail.com>
 <CAO9r8zO4uW=SX7se154Z6+DrxfawZfAiRO6Ar5rUm3T78x5HUw@mail.gmail.com> <CACePvbX5oWcTRpQeBCQsod5C5KEhd-0vA4B1PGYddNfgTW2tvA@mail.gmail.com>
In-Reply-To: <CACePvbX5oWcTRpQeBCQsod5C5KEhd-0vA4B1PGYddNfgTW2tvA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 13 Jul 2026 12:57:35 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNjouSvVABM4WhsXu8Uzcbd53gLEK0SXLeDMKJm1PeLJQ@mail.gmail.com>
X-Gm-Features: AVVi8Cc2d5Jy4K-zB3uOZEByCUGAsFCJAB8Scukxi2qhgJNF_HV08DJxXMaC9aw
Message-ID: <CAO9r8zNjouSvVABM4WhsXu8Uzcbd53gLEK0SXLeDMKJm1PeLJQ@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Chris Li <chrisl@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1EBE11C000A
X-Stat-Signature: 98w3ikojgxen1gdbhjdt59b58e4nsgkw
X-HE-Tag: 1783972668-833401
X-HE-Meta: U2FsdGVkX18G91tlWuvtxZmOtVw+XzkCDc5kf5lhflo9HSgjXSOWLvy5YKskjD6Jkt9vCvRYF2h582s6wW9FZNew6nRXkkQprLaYatT/Ddq2hCUKw9m+mGpPbYqh7IURfwE3gknDcMbO/k+0pZYVhb7InldquBXe4oFZq4JrE9OU3p8GvCmEDLRpE30IJk/ogSlPfqU1ZSQDpS8smcIwazUyY6I1Xc8UmKyzgX8P+bwbDnOA3M3/BzBzdkDt0JE8zvGfQYdZg2QvG4Zh1hCf8cCmME4SPyDUYhZCDQLqQRb44JNJsuasQTZiu9maYyMngZwm6RyqWS+HpV2WiAUZusirnkrlju3G1Y8kbbWAuJV4GCPyPUozI3CVvt8dnTYq3Dr5WNLmg26JgUWgXrAOQuEEytNBcF/Oy0xjdMRPK8eRhZWarADMp7GKvYHP4TxgwtsPlrDDCs7r4WiebQJzXy1sCk/2QqbC21TNx5uxR598Tp+7syV1AYkO3lXtif4Ej6Y5n5u8PszDVR3EH9fwFhaPhVa2L2X3me0rcpg9qSn5gnlETActDLcidwOPGrI5Q/XigPIW4e44lDSsVaz0hXPLtCqTN7eH9C6o7dL6wi75ePrj8vrctLI/qjiTkYFSiy974Fo/jYc768FV95guCUUH6Fbsmg99qHLA/uBc4iT1dUsk9/wfMuQmfZ5tVwS4nZ1fdubadvxAhY1WxKaAOLRRGkqWOwY5fECX4ShM+NrXj+urbCprPLiR+vCl+Gy0emAjI0FWOLbaiK3DvmoPT9GM6iNCzPuR+j7dvn5BBibcriUjJdcPgV5TbXvvjztlOEH0lxa/4MM7CmCvXh2qi7Sd3J920cjzQ+XZ/R1cOCtOd7O7jSaHV/Hht1+/yrt5uHmd2VNq+0+aD5geHg1Mq9c0hpyP7M8WSlgcfVd2vkYW1MbKvxt6WpEtRIU2eUyRpZlVH+P+S1/aeCyff4C
 4UqAkXoN
 2Sh1bHU8QkExorNSKGIpZpH5gabr82MU18QcgwETjTQsNlpspy7lqvIlsGR/BboJS0Ahn+vqbEmMha8+3duPxdsHzltbvioqQBJNj/bd/kP63PsdOMaL6UJNHFu6Cc4tYHRyeuyDOa3vhH6DEjNXFEmZ7GSv7GIR/LToux92mCIgF+BaaV5FNUw1+ZfSfklGz7xCHoc2/cj3JUNvj/Q4NOC4A6PtKd66oZRqwJULHtBcZ1R7NvnJEIP5KZ9ReBgbRMm6jK5qoI3/AtbY/fcrtkLUBbxS33ldR5XGneuk/r+ey//zXE5oOMaXUa4gZ98EPph6UhBkcJXvNeCSLM7uqnthU8Ayez4hm+y6IhMTMTV+3qI44m/i6D0o06k+i8Rr0y+2x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 12:39=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Mon, Jul 13, 2026 at 11:38=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> w=
rote:
> >
> > > > > Zswap will not be introduced as a tier. The existing user interfa=
ce
> > > > > makes zswap not exactly compatible with the tier ordering because=
 it
> > > > > sits in front of every swapfile. If we change that, we break the =
user
> > > > > interface. I suggest we keep zswap working as it is now.
> > > >
> > > > The goal from making zswap a swap tier is to have a single framewor=
k
> > > > to configure swapping for a cgroup, instead of configuring zswap
> > > > separately. Yes, zswap currently sits in front of all swap
> > > > devices/tiers, but we are heading in the direction of changing that
> > > > such that zswap is standalone, at which point it becomes more
> > > > obviously a swap tier. If you want us to wait until that happens
> > > > before adding zswap as a tier, I don't necessarily object, but I wa=
nt
> > > > to make sure that nothing will break if we add zswap as a tier late=
r.
> > >
> > > I'm afraid your zswap user interface will have to break. I don't see =
a
> > > way around breaking your zswap user interface to fit the swap tiering=
.
> > > Once we move to the swap tier world, I don't think we should continue
> > > using zswap.writeback to control the tier write back behavior. We wil=
l
> > > need to rethink this new world.
> >
> > I wasn't talking about the existing zswap interfaces. I want to make
> > sure that if we introduce tiering initially without zswap as a tier,
> > then add zswap as a tier, the semantics of tiering and user-visible
> > zswap behavior doesn't break.
>
> No, the user visible part of zswap must break because zswap currently
> sits in front of every swapfile.
> I don't see any other way around it.

If zswap becomes usable independent from a swapfile, it's mostly
transparent to current users.

> If you do know how zswap can interact with swap.tiers without breaking
> the user interface, make a formal proposal and lay out all the
> details. I did that exercise myself and I my conclusion is that it is
> better to accept zswap is the classic behavior without burdening the
> unified swap tier too much.

Today pages go to zswap, and when the limit is hit they get written
back to a swap device. If zswap is a separate tier, pages will still
go to zswap and then when the limit is hit they get written back to a
swap device. In both cases, zswap writeback can be disabled.

Can you share the findings from your exercise, and why zswap being a
tier is a burden? Any specific examples?

>
> > That being said, the existing zswap interfaces don't have to break
> > with tiering, why do they? We may end up with redundant interfaces,
>
> Because zswap does not have its own swap device, it borrows the swap
> slot from the underlying swap device. That behavior is unique to zswap
> and none of the other swap tiers have that.

Yes, but we are heading in the direction of removing that restriction.
But I also don't see the connection between that and the current
interfaces breaking. Do you have any concrete examples?

>
> > which is unfortunate, and we can work to deprecate some of them over
> > time. But I don't see why we have to break them?
>
> I don't want to special case the zswap for from the swap tiers.

Neither do I, but I fail to see where the special casing is, beyond
the fact that zswap is not a swapfile but an in-memory swap.

> > > > An advantage of adding zswap as a tier right away is the proactive
> > > > writeback use case. It naturally fits in the tiering framework as
> > > > proactive demotion between swap tiers, which I expect may be useful=
 in
> > > > non-zswap use cases as well. Without zswap as a tier, we'll have to
> > > > use a different interface for proactive writeback, and then if/when
> > > > zswap becomes a tier, we'll have multiple ways to do proactive
> > > > writeback which isn't ideal.
> > >
> > > I am looking forward to abstracting a more common write back behavior
> > > in the swap tier world. The classic zswap behavior will be preserved.
> >
> > Right, but this requires zswap being a tier, which you seem to be oppos=
ed to :)
>
> It does not need to as far as I can tell. People who want classic
> zswap can use zswap as it is. I am thinking the swap ops provide some
> interface for classic zswap to use, but zswap itself is not a tier
> because it does not own swap devices.

A swap tier represents a class of swap devices or swap files with
specific characteristics. Zswap satisfies that, although it's not
really a swap device/file.

