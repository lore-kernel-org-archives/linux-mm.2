Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71AFC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1366B0092; Tue, 21 Jul 2026 14:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8892E6B0093; Tue, 21 Jul 2026 14:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705566B0098; Tue, 21 Jul 2026 14:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7DB6B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:37:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B586A160274
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:37:55 +0000 (UTC)
X-FDA: 85013642910.11.8D16C2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE7BF18000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:37:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=neRUdQxB;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784659073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gCO/l330njD+stDZZDZMLF87f8BoqEZxyb0CUTX/00=;
	b=xlZtIeUJFLM3N7TrOkQpamGzYg5Sg3RrE7xYJ5LX/bB3gPdHuXUWrJIxTDYEEAKlVMcSeM
	L8+xspIBeElrkO77pA9XF/GPmqedmAHF66gRTmzx0xN0FvTu1AMIN8WdhuwkeQCw57K/ZH
	3cag5viWINzfKC24cmz1OduC3ZhDDEg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=neRUdQxB;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784659073;
	b=LpCd2ABxt6difphCgGXZ/E8GIGGwgvl49VdxSvCr4FYzrAY+93wlEG5DbnQApY8hqfvnHQ
	YykOGUHh1ApK1KG64sMsa9SatOkB7fo79vEYaODck/AddXwYwI+GT9cm2XzlSbxxn5+NTl
	c502R4La8O1DFeYBV60BDSq1KjqcC68=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED3E345013
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17C51F00AC4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659072;
	bh=8gCO/l330njD+stDZZDZMLF87f8BoqEZxyb0CUTX/00=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=neRUdQxBKLqQrRIQNz70wA2fddtdidhc9DCyd5fwMHfjrATKdfDGCWSzXMBQv6q7a
	 Q0YHJz7VFDl91+kuoMq56voRfAJcoUifjQVtM92W2JR0NWrrlOYNNUoH8HeVgSb9/Z
	 SEsqlyTy4THzgAU6Q0siiX6JtXI8UpzbW6YWpdmlQlYhwHbdJHQlobB13mvqfpyZ+L
	 ymElO0NFDOP5+fz8g+DIRCXox+3fi3jbh5jlqbp8rGxWlVy2wqZOt2RCcLw/Vsz5ms
	 o9o+wjt8oplkcUs8C7D2vU45y+DmduDw9sDCNuhY4IE8CEt0XOSF+vaVox4AljNqRh
	 vOpYk91SANE6A==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81ee6b2da98so57617657b3.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:37:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpMaQU4YRgajaVPIIJ3odIHzx8JHVhiO7HgOQnWCtLa+X7ilvD7IuChj+dOekoWp6IbxJ8BMIOQLg==@kvack.org
X-Gm-Message-State: AOJu0Yxg/GLidQ5FlTE9frXmUiFaioyO9qBgAWFg9G2yWcbZK41Gswqw
	A7+1q8I8c+bTwVKksRtatcOGkYB2RyDqQlUxyTQHqTDieA0LVR5UEKo8YDX++6VZu7VCCtQ5NOU
	mSKvX1OGMn0LItA8uagXNALQXTxWlSg2i8qyb8zOjpw==
X-Received: by 2002:a05:690c:c4c3:b0:81e:9826:942c with SMTP id
 00721157ae682-81ef2174c78mr60414247b3.0.1784659072225; Tue, 21 Jul 2026
 11:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com> <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
In-Reply-To: <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 21 Jul 2026 11:37:40 -0700
X-Gmail-Original-Message-ID: <CACePvbXZ44Bc0=cDTw=Cufr7Mv5794OLza+62P92f2Bt0tfUFQ@mail.gmail.com>
X-Gm-Features: AUfX_myhvEmXsVXoszuyQLbanbBrOMNsp1yYWYSSVM3a0AG2ZrP7P8oBaaZl42c
Message-ID: <CACePvbXZ44Bc0=cDTw=Cufr7Mv5794OLza+62P92f2Bt0tfUFQ@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE7BF18000F
X-Stat-Signature: pkkwbjt7ey3m385ykzy895yjkjha4i6b
X-HE-Tag: 1784659073-689779
X-HE-Meta: U2FsdGVkX1+UJpt6U5Xy268k/uhhrSqjcyBtYU2kHp4JD4BdvyzbnTxUoHpEZT6nN1AL3Yr/O3Xaf+pThBVBkToaEJ2AAprkowk1ZWqlYOsVuRfVgCc0d+Md8BzxJJtUu97XrefnfaQ1MNLD4MHStux3qecXyI5xo75a4W9Hq/+Ia9Nq9K57l/C6/WiPAALb3XfqhF683oQUBnZdl/KafN6E7jM4AorVtkNK8Gg+J7y+jMTnICto3w66BXS9ojpmFFIw/RYv6vyhcxdDXDTXQBYl8zypKsjddcP7kRW9OUWhR1xjGKQ6MWiC63UqSFnZdy/Hf0bj5UWPnlu/W8fyVWTdBt2pgnVxm3OPGwQ+s9+ChM+1dfHrBFNM+6Kb8YjWwJWKkdh/tPIDihYJJTFC5709kTSjv5ixOlV/C5wTxL11wEtU838K4WskQGXga0aKI47V888aqp6h6yNBJE6sOGDmyZeHcFYE9LwFCyRWPR23BLSqXOpczaOB1uW+cQl/z2KnfLvuW1u0Wlcc2QKzAgcFX/gnspxoAVGJdO7Gltoj8HHLTCzrAI5oS6Bc7N4ip7RRrIgo87cPcYEJ6A2FNsVhWt+MFM5zplhKzaPCf+oL1b178vcidT4TJpVw1+sF4LL3z1S4X+I+sDhPhRnF5XWVkqBUuEObHX1Wz172qLDgF8kD+fWLDF9aIOZZHF78+5B93c96Q+YyQynzpy9UPYDrLlawqcrWU5k+ncJJc6XjemTvNhxIS2snNKR5kz22J/u+Fg6cco6PxOQ4P8lsK1g/hqQ4cTWstnlQuwlE7SzwGK0WvAH4AnLMEqXwsrUV8t5OB9cU/sOgAcPrCbkLDaQS2OKMk0dChk1fNoMJ6yWeP6GzTAnx2Nrs0XjLciD5bhVjCMIZ3l0MdxKDpl4Er+qbWanuBSwECZ2aE4htEGkgFt7PCQLdrKAi7Jg+pXTkZNMRt28ecFu/ePkhD4E
 EVDeBV14
 dpoRNfwGwDLt4WiUyl46dyubxAcXZ6hLQ3whmQQXgAEFkkJgrvWARrimzQnV4pQJr1/0KobhoXwYOLtjadPTTUHTBLTIBYIjy4JjjSVeFLgK86vN4Whd9kc+tT02wcBmb0zFD9+g6f0QzidlYlxnwg8DwCqVT6oRd/+IZaRh/rIDIB4RLsyXTqhpm8yq08aQ/lipdfDm6rG06AlLiuw1aKq0QlXKfaL69hXrLVsSkWc9S673acJzVgHexB+zB2RTSIdjVENd1NKwCI5jM2yBx0AsgpxY3f/LACwhvGWkMNFKoUI2bnZXHVQAilBX5b7audnSywb8qBoGFfJVBsr613LncprL2VTtzV4jVJxnJ6INV4lwcV2fi63hKSaUHAoh+2z1W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 8:11=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> I tried to forbid this at the implementation level as you suggested
> , and that is where I ran into trouble.
> A few code paths can end up with zswap as the only
> tier, and they are awkward to handle.  Below is each case and what
> handling it would take:
>
> 1) A write turns off the last device tier while zswap stays on.
>    -> rejected with -EINVAL.  The write does not take effect.
>
> 2) The last device tier is removed via /sys/kernel/mm/swap/tiers.
>    -> the file goes empty, so zswap is not shown either.
>
> 3) A cgroup has zswap and one device tier on, and that tier is removed.
>    -> the cgroup's zswap entry is reset to 0, which the user never
>       asked for.
>
> 4) A cgroup has zswap and device tiers on, and swapoff empties them.
>    -> the cgroup's zswap entry is reset to 0.
>
> So the problem is that in (3) and (4), memory.swap.tiers.max has to
> change on its own independently of what the user wrote
> and it is not like just error handling situation as (1).

This kind of complexity is exactly the reason I object to having zswap
as a tier in the first place. There is very little gain in having such
control for zswap in the swap tier world and it introduces a lot of
corner-case complexity.

In my mind, we should introduce a separate swap tier native memory
tier. e.g. xswap. which has a clean conceptual break from zswap
(though code can be shared). The xswap will behave like zram in terms
of tiering, but be more integrated with MM like zswap.

I think the simplest answer is just to allow zswap as a special tier,
meaning it only has an on/off control on the side. Allowing zswap as
the only tier means the cgroup won't be able to use zswap because
there are no real devices.

> There is also a consistency point.  memory.swap.tiers.max already
> accepts a child enabling a tier that its parent has disabled: the write
> succeeds, no error is returned, and the difference is resolved
> internally.  The user's setting is kept as written, and only the
> effective behavior is constrained.  By that logic, accepting a
> zswap-only setting and guaranteeing only that it cannot do anything
> would fit how the interface already behaves.
>
> Having thought it over, I think one of these two directions would be
> better than enforcing the rule as above.
>
> 1. Allow zswap-only in memory.swap.tiers.max.  As you say, it cannot
>    work without vswap, so today the setting does nothing and there is
>    nothing to prevent.  Once vswap/xswap lands it becomes meaningful on i=
ts
>    own, with no interface change needed.

Allow it on paper and accept that zswap is not a real tier. It is just
a cache in front of other swap devices.
That is what I think as well.

>
> 2. Expose memory.swap.tiers.max.effective, like cpuset.  We already
>    track the user-set and the effective-set separately.  Exposing
>    the effective one would show that a zswap-only setting is not in
>    effect, giving the user visibility instead of rewriting what they
>    wrote.  It would also help the parent-off/child-on case, where the
>    child could see from the effective value that the tier is off.

Seems more complex than it is worth.

Chris

>
> What do you think? or any other ideas?
>
> Thanks,
> Youngjun
>

