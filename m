Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22859C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 23:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1246B0088; Wed, 15 Jul 2026 19:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9316B008A; Wed, 15 Jul 2026 19:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B82E6B008C; Wed, 15 Jul 2026 19:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C66D6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:04:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93ABDC02F1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 23:04:03 +0000 (UTC)
X-FDA: 84992540766.19.EDDCD65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6AEA14000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 23:04:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FazrS5ZM;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784156641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSb/pkneEjl1tluDcf0JGWXSHFW2tZLVqDpYWPHPt9I=;
	b=GSuxdr2T9o7bUCRW3jfxeyglUHxMnu8NN96sduvQtH/OYv7ueykzSMHCPvMFGDaaLBsrIG
	oEV6H2M7VG5ijYBHgP8kvdzqAyo/dAcK3fzqGSIgw93LapVpk+K38eBKySlDYN0u1wAfNI
	AK8RhJ+d3stjftyMKyUTa8qU398g82E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FazrS5ZM;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784156641;
	b=sO2U1QAU4Gqz/EpSSg3xtgaoWY66qhb0kl23uBDayE/K/rjp3Yt7Ktk4V1oJMZPnTiQE3Z
	VrdLNTW4x/BHhzpKm0eZSMrFDjLpPYh+s6+i6Fh5ng9K5ow4e0PHU6e6zBbywAp5hFu3J3
	ESg3Sd/EYZYmkKDBEYIA2KH3SNSgRbo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E153E600B0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 23:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AE41F00A3F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 23:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784156640;
	bh=zSb/pkneEjl1tluDcf0JGWXSHFW2tZLVqDpYWPHPt9I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FazrS5ZMltQFQNqPaSz6k4lIXILI1U9whL5zQ+9OhDV/mx/mrBn16W4sfmah2l/MI
	 6WRdKY5+01frihBwIlpy3HztpyXiAmS0KXN1wO9GB/GieMwTEPG5ttz0enZpjWSbwR
	 N4rh+cYo+Js24OyOrETqEDppnNL8WgloZMf3nxhwmem+ODRkAHvmCyr8t3wy/MSkY7
	 f8+vxRVoqJqzlXMTmRqn38IsjDUhbTYgYTAI1CHc1cz14q/0RbpvzXs8pr/OssKY7V
	 /C9S90aR+U1ZiuRa72u8s+SQCpCb2MX9H5g1NgVveHqyiBPqaKUx9S4+htePLWm2gW
	 MPHmjlfOlt4PQ==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-81ea0b7d137so50863087b3.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:04:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpIY1REAtZn2h9Z7F/Aphik2UCU+yKIw7x0EOSE2+e2ZTgCm2814GgGGQKRJ0tMjgEARlTGTy/nkw==@kvack.org
X-Gm-Message-State: AOJu0Yy8KoT8W9BlkpJPjEHHT6ijPnvLEZFRISOnh85GFNV/ea+ppRGP
	svPAlrhXhy2X+z1pmgfDqiiZhuz10mIv0l0HR2VflDsOrc8VuAorwD3+H72sOovabOdigaMY1TW
	4cm62flGSNQqfzsrnNffdWBxiB8S7zQC+Bdkuw2doHQ==
X-Received: by 2002:a05:690c:c8e:b0:814:47f2:217 with SMTP id
 00721157ae682-81ecfadb793mr39724207b3.65.1784156639477; Wed, 15 Jul 2026
 16:03:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv> <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
In-Reply-To: <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Jul 2026 16:03:48 -0700
X-Gmail-Original-Message-ID: <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
X-Gm-Features: AUfX_mzzERb5u7ncl3q-5z2GdYY51rYeb2c2RbOqF_GhNfWDzc9KNHkmok9bnso
Message-ID: <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6AEA14000F
X-Stat-Signature: 5eru5gtgjbkebkz4545ycjg4dw4ji7r7
X-HE-Tag: 1784156641-992561
X-HE-Meta: U2FsdGVkX19+s7+xjW25/EpKLCwuDeZv1YTC8om9maT2jIyhgZ5VTrfEgWL1I/qg1gVpDocY5vb91HGaGeMYNSolOlZ7XkQXi1D+b84y0UfCl+RrAZzvx4I620g3CZ514K9azoKcsdYfPdk3RVaPHM7Eo5vdUDUbnwEf92qbuw0JelRlyb9bAqqPLklWz5s7Ojzp+8lkkQEOJql8Fbffstxdp15DWc1n8LYlNP4O0jpTFve7eAzY3YqLb3OD2q1CJxLS28gMtKHhAzwf2cQVunofUywzO9WKGY8x5g/YwMeWJ2Q405tOiuv5W/26jdSjDv7zQy04XR/BFeIRZ/NHdq10/cYXYLStOx2wkqCvxCgYmPeK9OBbCinye7pf6ad4/hXFhZHeE6TDnSXXzwmA8Z65o3auDXGHNA4/CT+VE5a+XHtO8xLZrhvc6ewGokPrezT9nMclgLI5G5SqyXWlx+kNxKCIwqKogprHaQ9MVGuLHjjQ/f+ER6rN17bGgiXYOj+6UE3E4n/5ksrYm4q7MWkYxh8g4gBeGfhZUd9hSwhFizu5NK5wSAmbFaM9u9mIQ1g63Q65UcadmkbqzuhPbDAsXDpbm2jbTbrnRantgKlK10TiTLRSflPmH3CkkUZJCLLh+4EM52EFkh6TvEOFqAB5C+DdpnuZZ6upVqEH4aMacUJ7gJyhEzLaDiYi4sTTSbZJ+n+7Pgbf1DWWMwTYH6l5KBwCHRraWSIieXB7G9x1OPoRs/HIqhOL+ZKAUtynz4/Kn0c/bsZGL5DwWcJ8FqlHyUREoL5kIXJZl5RgHRsfccG+qJvWoio3P0g97kAZhE7AOq0f55XkpjdaS4YYjrMhNRpLZISb71l5ZnEGb7PWsCM4dn1G9D90VLLzDG6IfsVzgCQ9nzbNLYD2C6S7zoRjWkMmCWdeM+24ZqjQxU8GuGORyIIPvfISl/A0GV3QK1bISGpEdAxS2+OC6jC
 NsqF6/hm
 FDABPS4l0A9AcfxjxUXlCNgssArHH+9BIGE65TlTB/78k+JEQ3lIWpJ6YOi8cAmIh/4Ms73WH0EU72VbLaTbQAgJUpb/5Iei72tyf0mdI0+10zrjbj4OW82bxmOPUf5nicsD7fI3fLb79cNTPtPimbZWEwmNvPRe30N4FmxgbXQKBlwjkWtf2UrU22CxzgFgZmV2xxQyJNsvW01F4EUqvHqCOKuHTGIkl/dinWSqUbMOPosCNdNNDd9a3fWy8MpAWmzoWnkzgFJbbKGoE/G5z3GCZ0JQjL7LXRiDb61UDbYFgvFCbEX4YseAbI+h0Z1tEA2CgW6KKgeAU62k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 9:18=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Jul 15, 2026 at 7:19=E2=80=AFAM Baoquan He <baoquan.he@linux.dev>=
 wrote:
> >
> > On 07/15/26 at 07:21pm, Baoquan He wrote:
> > > Hi Nhat,
> > >
> > > On 07/12/26 at 05:02pm, Nhat Pham wrote:
> > > > On Thu, Jul 9, 2026 at 4:39=E2=80=AFAM Baoquan He <baoquan.he@linux=
.dev> wrote:
> > > ...snip...
> > >
> > > Sorry, I won't reply to each comment individually. I'll just leave
> > > a summary reply at the end.
> > >
> > > > > I think VSS goes beyond solving the "zswap without backing store"
> > > > > problem =E2=80=94 it is fundamentally an architectural restructur=
ing of the
> > > > > swap subsystem, with virtual swap as a first-class abstraction la=
yered
> > > > > above physical devices.  That is both its strength (comprehensive=
,
> > > > > future-proof) and its trade-off (more invasive to existing paths)=
.
> > > > > I respect that.
> > > > >
> > > > > My goal with ghost swap is different: address the immediate pain =
point
> > > > > with the smallest possible change to the existing infrastructure.=
  Both
> > > > > approaches have value, and I hope the community discussion will h=
elp
> > > > > identify the right balance.
> > > >
> > > > That's because I believe "zswap without backing store" just by itse=
lf
> > > > is a bit narrow of a problem. It's certainly nice to fix, but it's
> > > > more of a nuisance - you already have userspace hacks for it (as I
> > > > mentioned above).
> > > >
> > > > The problem I'm trying to solve is to support:
> > > >
> > > > 1. Writeback.
> > > >
> > > > 2. Dynamicity.
> > > >
> > > > 3. Decoupled backends.
> > > >
> > > > all of which are motivated by real production issues, not some
> > > > theoretical problems. I'm concerned that if we only focus on the th=
ird
> > > > goal, we'll dig ourself into a hole that prevents us from solving 1
> > > > and 2 efficiently down the line.
> > > >
> > > > >
> > > > > Thank you again for the detailed review =E2=80=94 it has already =
clarified
> > > > > which parts of the design need more thought and documentation, an=
d will
> > > > > make the next version stronger.
> > > >
> > > > I really don't want to be antagonistic, but I hope you'd take the r=
eal
> > > > production pains that we've had (and have tried to communicate in
> > > > multiple mailing threads, across a timeline of almost 2 years at th=
is
> > > > point) seriously.
> > > >
> > > > Collaborations should go both ways. I've gone out of my way to try =
to
> > > > address the concerns of various parties, from spending *multiple
> > > > weeks* testing and investigating performance regression on zram
> > > > backend (which my company does not use), to a rewrite/re-design of
> > > > virtual swap to accommodate parties who wished to opt out of virtua=
l
> > > > swap for now.
> > > >
> > > > I hope you can extend the same good will to our needs :) I've inclu=
ded
> > > > you (and other swap folks such as Chris and Kairui) in my cc-lists.=
 If
> > > > you have concerns, you could have commented. Instead, you decided t=
o
> > > > send a patch series, which is basically just the ghost swapfile, wi=
th
> > > > a bit of afterthought to handle writeback and dynamicity, rather
> > > > inefficiently (no dedicated per-CPU caching), and not even correctl=
y
> > > > (the lack of rmap means swapoff / swap-cache-only physical swap slo=
t
> > > > reclaim is broken).
> > > >
> > > > I respect you and Chris very much to assume bad faith, but please w=
ork
> > > > with me rather than against me.
> > >
> > > Before I get into the technical discussion, I want to address somethi=
ng
> > > you raised at the end of your reply =E2=80=94 the concern that I'm wo=
rking
> > > against you rather than with you. Our paths in MM simply haven't cros=
sed
> > > much until now. I can't think of reason why I would want to target yo=
u
> > > or your work.
> > >
> > > I respect the work you've put into VSS. I did check it. Honestly I am=
 not
> > > fan of it. In your v2: 2244 insertions, 250 deletions, 15 files touch=
ed,
> > > a new 455-line header (vswap.h). While swap subsystem has just absorb=
ed the
> > > swap table series. Then another 2200 lines of architectural restructu=
ring
> > > on top is added. Not sure if anybody raise concern about your solutio=
n,
> > > or anybody suggests other directions.
>
> Yes, it's a big patch series. But as you pointed out earlier, it
> solves a larger problem with a single coherent design :)
>
> > >
> > > I posted ghost swap because I saw a concrete, narrow problem that I b=
elieved
> > > could be solved with a small change. It makes decoupling and dynamic
> > > growth with the minimum possible mechanism.  Writeback is explicitly =
deferred
> > >  =E2=80=94 not because it's unimportant, but because it's a separate =
problem that
> > > shouldn't block the common case. With my shallow knowledge, it's opti=
mal
> > > solution to the encountered problem. If you agree, you can change to
>
> The problem is not the lack of writeback support per se. I understand
> that sometimes pieces of a design can be deferred to a follow-up patch
> series.
>
> I'm more concerned that the ghost direction so far does not seriously
> take it into account in the design at all, which might make it either
> impossible or very hard to redesign around down the line. I don't want
> to rip a huge chunk of it out down the line later - we just avoided it
> with the swap table with Kairui's proposal.
>
> >
> > Part of above sentence is missing. I meant if you agree on the ghost
> > solution, you can change to take its way and continue, just add me to
> > CC. Or we can work together.
>
> How about this - let's solve one piece of the puzzle together, one at a t=
ime.
>
> First, your optimization patch series. Have you taken a look at my
> proposal ([1])? I believe that design should be cleaner, while still
> allowing you to put it all you want to get (elimination of xarray
> being the chief benefit), without requiring you to modify swap cache
> and swap count operations (since you don't have to move the metadata
> in and out of struct zswap_entry). It does require a bit more code to
> dynamically allocated the backend array, but should be trivial IMHO.
>
> [1]: https://lore.kernel.org/all/CAKEwX=3DOvR7GbU_9f2h_MtU4m0g6s-esHmNQKY=
NhJz610M0P3Sw@mail.gmail.com/

Hi Nhat,

Sorry for the late reply. I've been busy and just saw this.  First
impression looks promising, it is better than any previous version of
VS. Thanks for incorporating Kairui's feedback. Please give me some
time to sleep on it. I will get back to you on that.

> Next, if you just want pure ghost swapfile without writeback support,
> maybe something similar to the first 2 patches in my RFC? i.e up to
> this patch:
>
> https://lore.kernel.org/all/20260612193738.2183968-3-nphamcs@gmail.com/
>
> I'm sure you could find issues/bugs in it too with some extensive
> testing (a lot of my performance testing is done on the entire series
> as a whole), but from a design point of view it should achieve what us
> both want, no? It's literally just a ghost swap device - most of the
> other design elements of vswap (the new charging behavior, rmap,
> support for writeback) comes in latter patches. I think the difference
> is:
>
> 1. It's transparently dynamic, whereas in your RFC it's driven by a
> userspace knob. Do you think there are inherent values in a userspace
> knob?
>
> 2. The address space can also shrink when swap usage drops at runtime.
>
> 3. The dynamic address space is backed by an xarray. Note that it's
> structured differently than zswap's one (it's an xarray pointing to
> clusters). If you have rationales or numbers to show that vmalloc
> array is superior (while still support the kernel-driven expansion and
> shrink), please let me know.
>
> If you have no faith in me and do not like my code, you can take the
> code as a starting point, or just the idea, and drive it yourself. Or
> let me know if you're unhappy with any piece of it - we can discuss
> further.
>
> >
> > > Otherwise, please continue to push virtual swap forward. I'll stop an=
d
> > > wait.
>
> Look man, I care about the problems being solved and I'm a sucker for
> good ideas, but I'm not married to anything, be it my code or my
> ideas.
>
> I have literally dropped my old code and adopted Kairui's suggestions
> after playing with it and liking it, to make sure every party's
> concern is met.
>
> If you have concerns, please let me know, or keep sending code if you

May I add one wishlist item related to ghost swapfile here? I will
reply to your VS thread for other feedback.

For the ghost swapfile usage case (no writeback). Can VS support this
usage case while maintaining per-swap-slot metadata usage comparable
to the ghost swapfile implementation? If we have to put a number to
it, let's say the increase in metadata is less than 1 byte per swap
slot compared to the ghost swapfile implementation.

We have large deployments of ghost swapfile in the fleet. I want an
upstream aligned solution that does not increase the existing memory
overhead compared to the current ghost swapfile deployment, for that
usage. As you know, memory pricing and optimization pressure are high.
The ghost swapfile patch itself is relatively simple. If VS can
address this usage case, it will remove a lot of incentive to explore
ghost swapfile-like solutions.

Thanks

Chris

