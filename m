Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13147CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 02:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490038E000D; Tue, 14 Oct 2025 22:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466E88E0005; Tue, 14 Oct 2025 22:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D3E8E000D; Tue, 14 Oct 2025 22:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22B9C8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:55:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE98947A64
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:55:50 +0000 (UTC)
X-FDA: 83998833660.26.4429CC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E8BA21A0013
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:55:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UpNC1ett;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760496949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffwWdVaMvGj5/BrOBuULDMDke1WZp+0XtZglN9EkD48=;
	b=BAtRK7uKJKGnsEiFd8w0wOoM/tiwq/81XA8HO2ve4d9n/M5CC624tmQVYwI4AH0OruCuW3
	Q99XCmz0ZLgsxMygVbq9f+mri2ToFIWl2TKVmmX4qnqvN/G+CEaLIVA3JhHZaDjclRdJxO
	SsA9EZ96hVt4eQa2DGfIxDB9Nhs+zcs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760496949; a=rsa-sha256;
	cv=none;
	b=BcOO/AUCanGAzJaFX+2NRqhr7aj2dee7pTs+e+TiGMHZjFkgCmLz+mboKbQvesB9FIBUNE
	4TyetWbyonkAzVBTBxSG7bTU7yr1ngXlhdaNYeyF1XMrtu/IDOp17ayrM8nCc0zB0IW94T
	WcqS2Ft5yzkH0eXKS6EqYzx+6qr2MSQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UpNC1ett;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E85F492B9
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A3AC116D0
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760496947;
	bh=ZjQO9YASSQ9YmD0GwnCCMAB05fZ1Be+6EzsqcebEKrk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UpNC1ettMjm/SvzmDFpZrQ+S+KhaEO4c52cVGT9ofEB7FNrQ+7atycqmINH9vnWoZ
	 /+Q36sGW4S5qp7teuC0/vyBtVfanMIR8+SRf2kEzX0fLVH3dMobDPjKQDNAeW2A5/3
	 kAqDI3bq2uGwbKqgBVgbLqOV1ShONOS65gEkPBMXxL/WA1Xx3tArPSoX10GrCYyj3p
	 zB36P97jwO6c2GXM/3FajVDlvtWc6190sl2T0oJyFSYS1jV9ViptUY5CJiMxvnREYX
	 50S5Azu2hzFcMQCjMCsUc4/Q+cCUGGSXAikNBERmPWxK/xoBMMy3dlGAd7bIC1Qofj
	 MOu2YXfBRDqXQ==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71d60157747so61225277b3.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:55:47 -0700 (PDT)
X-Gm-Message-State: AOJu0YzPlzthzBe/jgcjli0gkeM4jwlf9xuoU6lH0hMf2HICNMZ1XCDk
	uuprNeYRU1U4nBUyzUy3nhjCHak8c+dY2qp8zLqZD99o1w7XfY5y63mJK3SevueS7WyT5bG42hB
	OaGKbvjEgNb1kvEMv2lepKdcbNbvuvaBVAWtRkIa7Qw==
X-Google-Smtp-Source: AGHT+IHDi62Md3RYzlXc9yzK6FT9l8HbXOqO+cwO7cT8WbWgn2KWaPdN44ccSPVpA1vvJXkBCNeSqaMzQyE+2O6Pn88=
X-Received: by 2002:a53:cb8c:0:b0:63c:f5a7:3e8 with SMTP id
 956f58d0204a3-63cf5a708bbmr8772028d50.68.1760496946606; Tue, 14 Oct 2025
 19:55:46 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
 <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
 <CAMgjq7BD6SOgALj2jv2SVtNjWLJpT=1UhuaL=qxvDCMKUy68Hw@mail.gmail.com> <CACePvbVEGgtTqkMPqsf69C7qUD52yVcC56POed8Pdt674Pn68A@mail.gmail.com>
In-Reply-To: <CACePvbVEGgtTqkMPqsf69C7qUD52yVcC56POed8Pdt674Pn68A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 14 Oct 2025 19:55:34 -0700
X-Gmail-Original-Message-ID: <CACePvbWu0P+8Sv-sS7AnG+ESdnJdnFE_teC9NF9Rkn1HegQ9_Q@mail.gmail.com>
X-Gm-Features: AS18NWCjYxeUpYAxxf-joSuybLzW8FpxJrP_QvpG3PEOz2Qp-sYui7dE4Dpcmfg
Message-ID: <CACePvbWu0P+8Sv-sS7AnG+ESdnJdnFE_teC9NF9Rkn1HegQ9_Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 3ogn3x7xqj4itspfbsr8xwftbwq6mxuh
X-Rspam-User: 
X-Rspamd-Queue-Id: E8BA21A0013
X-HE-Tag: 1760496948-49625
X-HE-Meta: U2FsdGVkX1/bsfCE6A2ZcN1XGVjnrRzv6bxVZ6qc/cp3sblxE9xh2I1hM6mawKv5THvemkFW/AcAlU5fMGFdR+BGSvpECTIMVoYIOVALOpqXF0jHEIb+QU7Qyb9hpgivDEcVxLb1iMBqRO2FJpc4RZEI3LwWuKdblsLZZ7wY9KekC482ZRxnoERq7hCO4oxL9A8+uGrouKe8pKE0SiCl1ibl1u3G6RkSXYjz++mcaMBEMxRgzEXAy/s49V3t4wg1/HLbF48hgIpcogzoONkldfJPTGC0rXV4L44qBZSs65oLepjrljNw81zXIkuBlTgA7UQUkRHj+Q0jVroCL2Cdk7n04tk3fGGQB2LmI3lxCqEFMYaNrR3FSgQS6IWes15MoZsZXQp9bW33hGjYTSEh7Rl6F/qYrkDOHvfarSbATdnser24iw7affeSb5XysRqM4/IXcgf1pG2nTvoV9Lx4PHxH1woCjL99jhO6zgSsG7lLki8V0OhPddmxsr4BhowTBX2QT3exAs2Ov3nyyCbZHz0YVfFufPltrZqMKYjJsR+7+qO0PlogItP2UR6YF3rkgIGaF44+aS4oBUR08XpC0cdX6XU9L4pBBg30SYpe2x6zBUL+oQlSzCHtiCH1yJ9muKqwjqVLbTGTg4OLwp4KFVtMC+mMxhLMCFSZOQYYRyK+OG6fW9ZVYXl5W9a2jwP2v7pc0bjBrsoLkQyYFppayIReIOrEQ45/LKJILI87W26IeqDbaQEFdiBaT3Dx9pAVXZwtTcFwmB6wOhMhyH8Gysmi5qyQiocFvKDLBkQvxgcueVGzrlJyo113QmwcHiCK8g+eS0ss2FI4H4EhXRJqJIfD+sVVldfGNCQB2caO2wwY14JXuH73579lj+QelFNftglToyJPV3P4+e2/oi5Lg5WIkQBL9BLTzHmaalZi+tKS2uBtfZsGq5EEto0GqD9s+xVGGmXrc8j2mGugsvb
 7eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 2:27=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Sun, Oct 12, 2025 at 9:49=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > index cb2392ed8e0e..0d1924f6f495 100644
> > > > --- a/mm/swapfile.c
> > > > +++ b/mm/swapfile.c
> > > > @@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_swap_entr=
y(struct swap_info_struct *si, int o
> > > >                         goto done;
> > > >         }
> > > >
> > > > -       /*
> > > > -        * We don't have free cluster but have some clusters in dis=
carding,
> > > > -        * do discard now and reclaim them.
> > > > -        */
> > > > -       if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_dis=
card(si))
> > > > -               goto new_cluster;
> > >
> > > Assume you follow my suggestion.
> > > Change this to some function to detect if there is a pending discard
> > > on this device. Return to the caller indicating that you need a
> > > discard for this device that has a pending discard.
> > > Add an output argument to indicate the discard device "discard" if ne=
eded.
> >
> > The problem I just realized is that, if we just bail out here, we are
> > forbidding order 0 to steal if there is any discarding cluster. We
> > just return here to let the caller handle the discard outside
> > the lock.
>
> Oh, yes, there might be a bit of change in behavior. However I can't
> see it is such a bad thing if we wait for the pending discard to
> complete before stealing and fragmenting the existing folio list. We
> will have less fragments compared to the original result. Again, my
> point is not that we always keep 100% the old behavior, then there is
> no room for improvement.
>
> My point is that, are we doing the best we can in that situation,
> regardless how unlikely it is.
>
> >
> > It may just discard the cluster just fine, then retry from free cluster=
s.
> > Then everything is fine, that's the easy part.
>
> Ack.
>
> > But it might also fail, and interestingly, in the failure case we need
>
> Can you spell out the failure case you have in mind? Do you mean the
> discard did happen but another thread stole "the recently discarded
> then became free cluster"?
>
> Anyway, in such a case, the swap allocator should continue and find
> out we don't have things to discard now, it will continue to the
> "steal from other order > 0 list".
>
> > to try again as well. It might fail with a race with another discard,
> > in that case order 0 steal is still feasible. Or it fail with
> > get_swap_device_info (we have to release the device to return here),
> > in that case we should go back to the plist and try other devices.
>
> When stealing from the other order >0 list failed, we should try
> another device in the plist.
>
> >
> > This is doable but seems kind of fragile, we'll have something like
> > this in the folio_alloc_swap function:
> >
> > local_lock(&percpu_swap_cluster.lock);
> > if (!swap_alloc_fast(&entry, order))
> >     swap_alloc_slow(&entry, order, &discard_si);
> > local_unlock(&percpu_swap_cluster.lock);
> >
> > +if (discard_si) {
>
> I feel the discard logic should be inside the swap_alloc_slow().
> There is a  plist_for_each_entry_safe(), inside that loop to do the
> discard and retry().
> If I previously suggested it change in here, sorry I have changed my
> mind after reasoning the code a bit more.

Actually now I have given it a bit more thought, one thing I realized
is that you might need to hold the percpu_swap_cluster lock all the
time during allocation. That might force you to do the release lock
and discard in the current position.

If that is the case, then just making the small change in your patch
to allow hold waiting to discard before trying the fragmentation list
might be good enough.

Chris

>
> The fast path layer should not know about the discard() and also
> should not retry the fast path if after waiting for the discard to
> complete.
>
> The discard should be on the slow path for sure.
>
> > +    if (get_swap_device_info(discard_si)) {
>
> Inside the slow path there is get_swap_device_info(si), you should be
> able to reuse those?
>
> > +        swap_do_scheduled_discard(discard_si);
> > +        put_swap_device(discard_si);
> > +        /*
> > +         * Ignoring the return value, since we need to try
> > +         * again even if the discard failed. If failed due to
> > +         * race with another discard, we should still try
> > +         * order 0 steal.
> > +         */
> > +    } else {
>
> Shouldn't need the "else", the swap_alloc_slow() can always set
> dicard_si =3D NULL internally if no device to discard or just set
> discard =3D NULL regardless.
>
> > +        discard_si =3D NULL;
> > +        /*
> > +         * If raced with swapoff, we should try again too but
> > +         * not using the discard device anymore.
> > +         */
> > +    }
> > +    goto again;
> > +}
> >
> > And the `again` retry we'll have to always start from free_clusters aga=
in,
>
> That is fine, because discard causes clusters to move into free_clusters =
now.
>
> > unless we have another parameter just to indicate that we want to skip
> > everything and jump to stealing, or pass and reuse the discard_si
> > pointer as return argument to cluster_alloc_swap_entry as well,
> > as the indicator to jump to stealing directly.
>
> It is a rare case, we don't have to jump directly to stealing. If the
> discard happens and that discarded cluster gets stolen by other
> threads, I think it is fine going through the fragment list before
> going to the order 0 stealing from another order fragment list.
>
> > It looks kind of strange. So far swap_do_scheduled_discard can only
> > fail due to a race with another successful discard, so retrying is
> > safe and won't run into an endless loop. But it seems easy to break,
> > e.g. if we may handle bio alloc failure of discard request in the
> > future. And trying again if get_swap_device_info failed makes no sense
> > if there is only one device, but has to be done here to cover
> > multi-device usage, or we have to add more special checks.
>
> Well, you can have sync wait check check for discard if there is >0
> number of clusters successfully discarded.
>
> >
> > swap_alloc_slow will be a bit longer too if we want to prevent
> > touching plist again:
> > +/*
> > + * Resuming after trying to discard cluster on a swap device,
> > + * try the discarded device first.
> > + */
> > +si =3D *discard_si;
> > +if (unlikely(si)) {
> > +    *discard_si =3D NULL;
> > +    if (get_swap_device_info(si)) {
> > +        offset =3D cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE,
> > &need_discard);
> > +        put_swap_device(si);
> > +        if (offset) {
> > +            *entry =3D swp_entry(si->type, offset);
> > +            return true;
> > +        }
> > +        if (need_discard) {
> > +            *discard_si =3D si;
>
> > +            return false;
>
> I haven't tried it myself. but I feel we should move the sync wait for
> discard here but with the lock released then re-acquire the lock.
> That might simplify the logic. The discard should belong to the slow
> path behavior, definitely not part of the fast path.
>
> > +        }
> > +    }
> > +}
> >
> > The logic of the workflow jumping between several functions might also
> > be kind of hard to follow. Some cleanup can be done later though.
> >
> > Considering the discard issue is really rare, I'm not sure if this is
> > the right way to go? How do you think?
>
> Let's try moving the discard and retry inside the slow path but
> release the lock and see how it feels.
> If you want, I can also give it a try, I just don't want to step on your =
toes.
>
> > BTW: The logic of V1 can be optimized a little bit to let discards also
> > happen with order > 0 cases too. That seems closer to what the current
> > upstream kernel was doing except: Allocator prefers to try another
> > device instead of waiting for discard, which seems OK?
>
> I think we should wait for the discard. Having discard means the
> device can have maybe (many?) free clusters soon. We can wait. It is a
> rare case anyway. From the swap.tiers point of view, it would be
> better to exhaust the current high priority device before consuming
> the low priority device. Otherwise you will have very minor swap
> device priority inversion for a few swap entries, those swap entries
> otherwise can be allocated on the discarded free cluster from high
> priority swapdevice.
>
> > And order 0 steal can happen without waiting for discard.
>
> I am OK to change the behavior to let order 0 wait for the discard as
> well. It happens so rarely and we have less fragmented clusters
> compared to the alternatives of stealing from higher order clusters
> now. I think that is OK. We end up having less fragmented clusters,
> which is a
> good thing.
>
> > Fragmentation under extreme pressure might not be that
> > serious an issue if we are having really slow SSDs, and
> > might even be no longer an issue if we have a generic
> > solution for frags?
>
> Chris

