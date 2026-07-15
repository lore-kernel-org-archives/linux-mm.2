Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13135C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0EB56B0095; Wed, 15 Jul 2026 13:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98B36B0096; Wed, 15 Jul 2026 13:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B876F6B0098; Wed, 15 Jul 2026 13:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF296B0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:30:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14F951C00C1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:30:42 +0000 (UTC)
X-FDA: 84991700724.22.2305916
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 221D44000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:30:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4jXkB68;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784136640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AaDK0YcKsOX8dmK42gislw1t6ZfV6eThD1LeGUn+aoE=;
	b=bNrvi49cV3LP537VMHIOXNPVc9YE9n61EIk5Iu3becOAHredkas1+mfIpInhGr5auvRm5T
	1E6OxFJmqV+bU8Vkb+3GFFgYADdQ9n3Ez+NxKnlljLcMl7LR063QEj5LzXybrxAkEHK588
	wKzDzNvc0vEGx9EUK+TNaEdH5AeH+8k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4jXkB68;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784136640;
	b=e5IFky1MpeVKfgeYMwTRlV8or1NSI99Aap7zg9Zyoy/fx6A2oEZ4SWaHl5AWWBMxesZd1K
	BdMPWFolpYSyj2ifj5PJbWc9iU3Skn45V2v1CPvH3Wcp34lrhT3ehRDG8RfIu/XU8/6kC8
	xNDC3ioPc8FcGKkw817XD/ZvgZoOSjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 100C943901
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85FC1F00ADE
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136638;
	bh=AaDK0YcKsOX8dmK42gislw1t6ZfV6eThD1LeGUn+aoE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=c4jXkB68Gb1XnDXaW9+gZlTfSyrLocbWid5fbGkjFhP7vfcpH1MiHxXxI4T8FqeIh
	 ErijgV2Q0++5gGY1ztLczsGqEeqPfvbfKcoJ4yA5mS7TO+9mYi+gWMP+us+jxvQYpZ
	 0Gzb8oMUH7TvivEj9XzleX0schlLn9RnvAcGPhu54ZJCbFQjn11PgCFDyQdgUWCBOe
	 lTahMv1gHnNNlvK7ha97BfoJJhElvgcOERouQqsa268d2zip0VDNh/o2GEdHlzam3w
	 cgrqjIMAn9EPIWUJUzVxuRQbCiJMVxRbo1S7nJDO9H6Jgj9BSQxM4a8Ft8sbKWCNDa
	 0PQ/bBz1ACKfg==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81ed073fed0so14661867b3.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:30:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqhCVVXGBGKj30+Qzlw74LJDWGG3XC/7jucTw1b0TZLusCQY8Hs6NIRUEVUkQB+GE1YGToNU7rWIg==@kvack.org
X-Gm-Message-State: AOJu0YzMejx9wtsY9nauB+z/RdTNQ2zFClI1TDCAGbERDujHYL9JXR69
	pzSYNl0GTz7KhU4zH5NuUqw7/L0IjUmEqZk6akHBpp8b9Bi5XHYMro1pUytDOewrpCKD/FDtryl
	IOFdYf81Q4DaTY+Rx1CraPhCvynG4eO0CXKyYJWV06w==
X-Received: by 2002:a05:690c:61c6:b0:814:608a:acb4 with SMTP id
 00721157ae682-81ecf8769e3mr27004517b3.27.1784136638214; Wed, 15 Jul 2026
 10:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <alawYov0c7a0Q6_l@linux.dev> <alchYX43oV9KybWx@yjaykim-PowerEdge-T330> <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
In-Reply-To: <CAO9r8zML09YzraA6rstMz6+Krui5Vma6a9D3j10_FXGbqfEQvQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Jul 2026 10:30:26 -0700
X-Gmail-Original-Message-ID: <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
X-Gm-Features: AUfX_mwNi5Y1pwimKjBk_MgYVZ1E3p7vG6fWGe6nDpPFl9wzmA0F3NoEIhyTWok
Message-ID: <CACePvbVQxvZKa1y4b=mAgdT_uUO=nk4uvuSob3xvW9MZ6OEONg@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	joshua.hahnjy@gmail.com, gunho.lee@lge.com, taejoon.song@lge.com, 
	hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 221D44000A
X-Stat-Signature: inr9arztgebspyyj8igpz3egmasarm6h
X-HE-Tag: 1784136640-512458
X-HE-Meta: U2FsdGVkX1/exGjdMurl7zJ9Ggkz7kvR8xDMTShaBmVFGk+kmOsEPOK0POwNsF45K4XWYP1Ox3tgZAhnhCfI/WrtNbHxP+tyEtHoZFxyQSJXbQ35ECBmfoxuo/MaaSYkzmqcWIa/VJ4fbk8th1qVe/kRKPqoFZ0wdJY5pxwxFMOB55ULpatfEyLQI2+SwauOjRqsFBeBVsclzXTtWtJnft2t0rTHPRr9pN8Xbe7zO6WCjtCeAWEwP6DMjhJD2BmOz6okLHKjXp+XBdl3eLlidPN9xJiMowOaq+jhg06GO6VfH+Kl53HXWh5uNGEUOjfRn0PqGKm5LyCFObRZMP39AIyYHSd8/+YPYVJ0IWRnITaZ4AG1u2VSe3w4YwLe0EKcE++Q3T2YuhQ3JCpAqvjb3L/0DvcDCDsTfX4vVyndjQSi4WygbmOACSDPCrUyAnSGuBgZGajFCfmwcK8lrBdqI3nHXB4jNesLsXv5SGUWnlDuOIjGU41HtKl7b+smOp7xF1+c1fnfsQefM90rhfbGg9SYwnqe7/sGPHqlBcEEtf1pquK+Ob5WjIh70W23cvFt9KgB+ek6509/A1dMytUKOV/G7wwmtnzOqnJuxh7g4/cGv6KXXEPncpAnI48GwQ/+XBr0TYqDpEH4njuiVpielVaRkgT4ScK5NhyfM95u8faWtsouECzWHVtU9GRn3Vd7JVDsmCv/LJynF2wKfLHKHqGgNo09KcRICyI9DFhI/0FgHK1L4ZA8xjBfRnyQSu1G5XRKtW9LD9u4XkhoJbaQvJ1X5tFoY5UtMYcGCOlL7ZDQfmGZtQNrMdpA3wfkcSOjVPtHroWnBNiosgfQWqjVkL9xKHg+ZHyEOV5kXPphRw1b+6sXVGAyWxkALHO75Uj6I4tSp6x+Cm1NjCRd/d+8VWvDiBRnE/dcnsGyQrfiPn3diwmo0KoxxKHa2pYmsMpaT0t3NcaI3/OeElcZKKC
 e2GN8ofU
 pbGDGSAL88XOLwW5wfrsuWo+xZZGWb4ntS+AP+h/r5rN2n1+bpr38t3zSW1njG1c3+BWyJvvQvs5RAvZOPo0KUxMdpX6ll7HxynyBIuk5jgQaCoZzZ3EOVTx9E8dqsm0hTyauIKC7VDU1MDjWFOvPE7/KZWoSwIZPJoYwloTX2Bb+Ur31yaeaXJZ0D5zS5/FpcAvQGzTll/nO1C/KHb3EaSHfeMOaUmsIHTTue1kw5mdWuIXXQ6JsMrs/xhi02EOPC3fiLaQs9uys/2FnaL+3iQB0gVTLEkwS77aEvxaX2n0ehZ7OClcdtgQG2aIgHBKABW0/ykVUa+3ILktETfIHTs+3tQhg8ke0IwCxkW0riCuTMGb0/B9Ku6BUyHoLQuo430KcO9QCTTK0wKtqeNoQzW2P7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 9:27=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jul 14, 2026 at 10:58=E2=80=AFPM Youngjun Park <youngjun.park@lge=
.com> wrote:
> >
> > On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> > > On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > > [...]
> > > > >
> > > > > Yosry, what is needed to enable zswap as a swap tier? What will b=
e the minimum
> > > > > requirements for that?
> > > >
> > > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > > tier is disallowed. Could just be a check in zswap_store() similar =
to
> > > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > > disabled, nothing happens to the existing swapped out pages in this
> > > > tier, but new pages do not get swapped out to it. This is the same
> > > > behavior that happens if zswap is disabled at runtime.
> > > >
> > > > From the tiering perspective, we need to accept "zswap" as a possib=
le
> > > > tier, or maybe creating it as a tier by default if zswap is configu=
red
> > > > would be better to avoid handling the case where the user doesn't
> > > > create a tier for zswap.
> > >
> > > Default tier if zswap is configured makes sense. Should zswap be trea=
ted as
> > > having 32767 (or maybe 32768) as priority as it sits infront of all s=
wap
> > > devices today? Also whichever swap tier has priority range containing=
 32767,
> > > will have zswap in it.
> >
> > Maybe we can handle zswap as an internally reserved tier which is alway=
s
> > preferred over swap devices.
> >
> > I do not think there is a strong use case for grouping zswap together w=
ith a
> > swap device that happens to use the highest priority. Also, using a vis=
ible
> > priority value for zswap may have a small side effect that one priority=
 value
> > effectively becomes unavailable to users.
> >
> > That said, if zswap is represented as a tier, I agree that it should be=
 the
> > top tier. The exact priority value or whether it is internally reserved=
 should
> > be adjustable when we implement it.
>
> Agreed.
>
> [..]
> > I agree this is reasonable. I can treat the demotion/writeback interact=
ion as
> > future work and follow up separately.
> >
> > > Youngjun, what do you think? Is this reasonable amount of additional =
work or do
> > > you envision some complexity here?
> >
> > I sent a note with some thoughts about making zswap a tier. Since Chris=
 also
> > raised concerns around this area, I think it would be better to discuss=
 it a
> > bit more and evaluate the details carefully.
> >
> > At this point, there does not seem to be an immediate use case that req=
uires
> > zswap tiering in this series. So my preference is to keep this as futur=
e work
> > for now, and follow up with an RFC after verifying that introducing zsw=
ap as a
> > tier on top of this patchset does not cause problems.
>
> My main concern is locking ourselves into an implementation without
> zswap as a tier. One of the appeals of swap tiering to me, from the
> zswap side, is eventually unifying zswap writeback as part of a more
> general swap demotion, and unifying zswap controls with more general
> swap tier controls.

There is nothing locked. The major complexity will come when
zswap/vswap/Xswap/ghostswap become independent swap devices for swap
tiers. We are not there yet. But if you want a bool for zswap in swap
tiers world, we can make it happen trivially.

Chris

