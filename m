Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2EF3CA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670676B0092; Thu,  1 Oct 2026 06:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA446B0095; Thu,  1 Oct 2026 06:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A1F6B0096; Thu,  1 Oct 2026 06:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB516B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:00:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C3791A034B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:59:59 +0000 (UTC)
X-FDA: 85273611318.23.BF2E0A8
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8F43580006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:59:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y5zXywVE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790848797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7zfFlQbZsD4jNNxAMI//QTzfDx3O4jrcwxTHNnPvxI=;
	b=n7FD1Bp6K9RwwEmBz1td4KNCoQW9fKH9Evr+MjIDwxL2tE+n3oM1pOWL5g+LzQZewf5Fwg
	nPjSW/K8yvdM2eXricg30wBNDNiG8v0IPER2wiMXEWwhdjkykKNrNZGDLiUzN2uch7n6SE
	53tWUC8aF5++3cMINejm6oMBk/WBq4s=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y5zXywVE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790848797;
	b=3Jc8Wxr49sxLtW4oqQOnNE7vQZXoI/rlEIsxWka24yEbsLIGoAYUev5jwDZVc0XbecQMmM
	dAgFrxDdIj3B0TaGselLkLXMZzjlUp9Cdu/ZKTUkwCobMOih0Tma++oHDTTfl+CvqWeqWT
	T+iVhm8xobDIwTqob8gPL/d1EHps/SY=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3931so47965525e9.3
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 02:59:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790848796; cv=none;
        d=google.com; s=arc-20260327;
        b=Tqq1MeKNspNXQrEOr3Fuub2jGH392KCh8hcr6L539kpCntx88QKboAz/iIWhxseynu
         iobqKVbmj1k4YHZj6km1QXyY266hqPpZXtimVzwuMl1oOLbTJydNAYelcBxD6ophxETd
         bJCn8zYUbeUkN0AEFsnuG5B5PubGhctD8VFS4YBfOc78Hm6lEd/Be0fMKq4o61L1MSAI
         9tbSXUa3rkRpsTfsETuejjq5A2ifvL4L7ODMhyOshBr2UJtMnf4TQvzJDvOrBAhQqFTX
         IDqYvZlxZ8rC/sa/ZK8EppDW6rPqsdfAIYx06aPmxd0Axx91DFdV9xT8nnFyu01DmTo4
         gtLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+7zfFlQbZsD4jNNxAMI//QTzfDx3O4jrcwxTHNnPvxI=;
        fh=ujmgLF1wrHbmGUnlMDcMMq1xguK7eFmPj+yR/gER1Gw=;
        b=h+O8r7BaQp29+vZ7vTlsdsDVhrcgXNwR5lU41ChNgMrjbiS0EIgPZYL6XsNiUEpkoq
         TTqBSCSMw7owZnmqD2NaSJ2gpB3SB7QDQhlOSj+NExBwdErSWoAeXWoJyYQse/bwgdJ4
         zY9SMZncmMWvhlt7y5DaIWeP+J8FQv+FpaBmZEYf4bESW++QprS9d0MeD9IDMtaY5Mk7
         TIsjZuH5zqgKmBAHFt7s7TSRhYbRStEep9U3QMsX2yje1MDTgebrPmUAdfl4Q7EDzp+k
         V6PVZCflfWYxHpE8187tufsDcKLKm63yjOa+HjHuSxc2mHoyXJro9ahIoom38jGa23tC
         bvJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790848796; x=1791453596; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+7zfFlQbZsD4jNNxAMI//QTzfDx3O4jrcwxTHNnPvxI=;
        b=Y5zXywVELyXYBgLMuN2Y+gJ+5rJCBqI8L0upWGfsBfeJEWJlZb7CYW6mNxuMULNiJz
         UDnbBCkLVGCRm4mch0P9dFonk3YaUG7drMEgZY/rCTyHt/TqFW1kAhmrV1d8eQ0jOwue
         vjCIOs7iTN1sGhEJOV2nh0nrZ3AfSRGScQkEziEEbclN8aVZDbSSgMVhL3CwqG6qzCY4
         tVrqGGt6GxR/ou4dyYLtABodIKad858kxGnj560bHECjt5rsmEMnsCVCUTyltajZa55D
         LLEssLFfAdGhs2WRcfnvSdqs3DMseT5hSdBq+xF54Vwu83JPzr+gGxN7stSGWnc7jkKP
         zCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790848796; x=1791453596;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+7zfFlQbZsD4jNNxAMI//QTzfDx3O4jrcwxTHNnPvxI=;
        b=yQfgnJbs5KpeeTQmKAQBNMc5U6YC8tMkyp2LIHVBUF0IWYOo/aDi5x4gwbadek9T7L
         btC0mzbc3ZzADTySvTtO5H5/GajNM+OTyHfrpj7MOPH6btMJqya7tpgZreX648z4RSfh
         jtp+hmOQqE0b3WziEQkFlBMi1xgvoukTZpKd/yyflbbGsnGy/sE+R9wfxadAt0iTdKK+
         FGSJ4nLArue1ZyLOZ02c0+h+wEmYIV0vUQ3FHeqwt2kLHZHMLweIxX5rHSWy1gnPd2NO
         NS4eL0TJHR0h33M1K1S7Vi7mh5I9Q/au+Pfjx5FGDLHpZJ7LsIMWT5FEtSF/iIeMLEMB
         3I+w==
X-Forwarded-Encrypted: i=1; AKwUvByFs/wVZ7mlPTnNfxswnQRY+SKXvg7wznBMXy92WL4jt8aZOM+qgtrvDDvRpGYYsre6uywfZ3tMpw==@kvack.org
X-Gm-Message-State: AFuF++ln7wUsK+oRRfWRCm5GNtnt0ehKc4cILjbIA3s6aEl6XeGFop6V
	ssko33r6ZuXUNh0TK1dY00Rosq7v0kkgi0RKWmmvZsf+UqlMlUP/27pj+a6xuuLrK5JUcvuLpf4
	rA6otNVAh17kre1SfMcAmpYzw94x/ClE=
X-Gm-Gg: AYBFou1LKGRyNBNkzHiqg4G8zokHH0usopk+p6Xv94sapwvnAWl77scxaXLO9fEKNnT
	YzqZ7gHbLFk+nFqLG3MwpUITQfXTL5mNxTWP3wYqtxw4lNvViRO8jLVrH/h7aIqjNKbmAzQAAAj
	JrfoDPqwybCRcIv5SpaBV4p2om5UcZssyuFAY5H6Y7LYAbQd9SCkfODR5OtW2C7vlEJNfm4fB+5
	X4cSox0h7Pekx7/uPwhM6V22Vf3Bh0caLBdl9qR2JCyCqTEnpQztfoHdSHdme8mDKt+G3vlmQB2
	ODQ49TRZP9gbS1lDkKzIkbehaH9Rly0nztQ7O9yxWCUQ+vQCgmeK6AXCf8ewPEKU3VT9Cmh2Fgw
	H4tLZfJqCWDKp+xT5p+Eisq/SePi1vBsl0frb+tjRjBQVKy8J0i0N
X-Received: by 2002:a05:600c:350d:b0:49f:d087:6526 with SMTP id
 5b1f17b1804b1-4a01b12d37amr65137455e9.34.1790848795224; Thu, 01 Oct 2026
 02:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev> <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
 <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com>
 <00d07f4a-f679-486f-9413-6917b5213854@kernel.org> <CAJnrk1bD+4tndrOWuSENvEb7ody47HL2aNv2n+RzUqDE8mpkrQ@mail.gmail.com>
 <790584e4-e000-45c4-921d-e55f173466dc@kernel.org>
In-Reply-To: <790584e4-e000-45c4-921d-e55f173466dc@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 1 Oct 2026 10:59:39 +0100
X-Gm-Features: AclHuK9sdmnQzTqyNGO1xe44gcMTglOi0dtdWOmlvfWueGviwXA67fsC1KB3MoM
Message-ID: <CAJnrk1Zixa9EAeAW-JUgo-AZN7AA1tKnsPZNhPy2BtHvF6drpQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, ljs@kernel.org, 
	usama.arif@linux.dev, hannes@cmpxchg.org, baohua@kernel.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hzqig84t6ws9nst3yyuuijooiwz3rqnb
X-Rspamd-Queue-Id: 8F43580006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790848797-145961
X-HE-Meta: U2FsdGVkX1+VPcykQptcu8xxVB2dwh8wgUBIFMYnA7QaGhA51T/ZQ+Cz7xiXhP5xOOfaGmofsxv+iejAEG2uFocfTSbLVaUp2Il6LKk4N6bhySc6+KN7bqGxELbimOw30EzbWcCOVUAnKGfLW58I3oC71QrMi68cpUok7XFdUk8cUh/LBdaBaMYzdyELtxtJ25jsXVdkDEQ1AmvnjVxwRRUxej2wz7vCc8+10gFPXgK+JrmyjjykQHMx5XYQ7mbL201NehwN9H3l2/1y5jLyGeDXn5VHoCMCneUiYY0UcjesUikxfbu4iqSOEQUC2QoW4t6Oa7fUtrUi3paTDM4cwDOcNSrrkkWKTCD7oAEc84IOua1yxnkaU7Lx4tF/PThB1t3ZO8FXYB8RdcNQEkNY20C+NrnPy318IBn66WQI+iNO8Ap1zzpOHpyPey3pfO8Q2+Y7crZ9qm6lNZoa9+6uL5+mbPKqCh+o76hqZ+RnDqABlgufpEXbe9Xv7MX250mEgpGDHYYZCy3tSgCxgv1jXMAbQlJ4pR4tBLOEoSbYOlImuGBLLWZDF8rFaKaXSJn59xrkYweDMvOp+W8rUsMXfhHfYhk9cfOEKRxaIJqmQVtkinGC8rCvLAbuL8odwAs+UzYiTy+Zf6p7sA9OMPTpWZXswc/JNXiRy6eUGdejmhVs5bHVF/tlgwiCZOEZYSFhihgEYM1miAja4xY3iRYXq3E3JCyU9QuFAe8l+5XZ9Z2Od9ba/eX50V/wpqA6SAZIRDSI3zY0GStpf6f8ZqWJJF8GC4OWRDgVNTpbfojiE6qOKeFe8cMyivGcuoHt5wjWcmz+APt7oSRIDHEOhtzuodZlh/x+/hqKXMIc+mGEvu5dxziT/r8I4W2dIL/xquTlzjACLriNg2r0aUxja8nZ3z3CAiqKaHKASHm7/PfGPFmnD3+VbQfqOCNvota5sgwugdlnQkvx5kJTQbCxv6a
 0HUwjEXX
 Mqrc/p/ilEjsqKw7ylGWYZUnbxMGevTWdZrOUtDembU/Q+gcXSAfSBDLcmq5grTAkMv+xeTSnCutJ/zpkngeYBBwQpFIQIrAFTyKDFzqobjAx4Eln1lo5HcWiy219N/SgrTG+GKRJbQX8gKXgTn2NX1mD9+N69BZGMcaJYqd/xw8m10E0k/bpK3Sqts42NmFABAO3hvVhdDwxmchxaMhZDk1bC/DwDmf8FsF4H4+9Yiv7H2Ig0jzm1/k5HMzf4J7SHKgINfF9eYuIqYB8hCxFIHTbI7tHe58MvhHIlrxjQZL3PPxqOoncrk8S9P5qBLvy4M+7bv2Ow5Icv/RGWN4ol03npOZy84Y2jX4ZQTnYb9lm193E7tj1gbTtKNtc2BIeXzML+JOulfAO5dZFjdN9xJVbIurPhjzyWz1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 8:20=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/26/26 01:47, Joanne Koong wrote:
> > On Wed, Sep 23, 2026 at 2:44=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/23/26 02:44, Joanne Koong wrote:
> >>> On Mon, Sep 21, 2026 at 3:12=E2=80=AFAM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> Ah, apologies for misinterpreting your comment.
> >>>
> >>>
> >>> With scaling, I don't see a way of avoiding having to queue every
> >>> anonymous folio of order >=3D2 to the deferred split list at fault ti=
me
> >>> in the non-default max_ptes_none case, since any folio can now
> >>> potentially qualify as underused.
> >>
> >> Exactly.
> >>
> >> I was primarily arguing that I don't want this overhead for the majori=
ty of
> >> Linux installations out there that ship with
> >>
> >> $ cat /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
> >> 511
> >>
> >> IOW: we add them (PMD THP folios today!) to the deferred list for
> >> uuderused-scanning but never actually scan them because of:
> >>
> >>         if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> >>                 return false;
> >
> > Ah, I missed this nuance in your v1 reply - I thought it was objecting
> > to the queueing overhead for the non-default max_ptes_none case as
> > well. Patch 2 in this series does what you mentioned above and it
> > automatically applies to PMD THPs too. I'll add your Suggested-by: tag
> > to this in v3.
>
> I though Johannes suggested that :)

Reading back this message in v1 [1], I think both of you had suggested
it, so I'll just tag you both :D

>
> >> Right, I raised that. Johannes thinks it could be fixed with batching.=
 I was
> >> concerned that it would become rather ugly. We'd have to see how that =
could look.
> >
> > I ran Barry's microbenchmark to get a sense of the contention (more of
> > the details are in my previous reply to Barry [1]). With max_ptes_none
> > set to 0 so that everything gets queued, and toggling shrink_underused
> > 0 vs 1 with patch 3 applied, I saw roughly a 15.8% and 11.5%
> > performance hit on runtime at 16k and 32k, but only 1.1% at 64k and
> > noisy above that.
> >
> > I didn't see the cost being from contention on the deferred list's
> > lock though. Perf showed that it was coming from
> > folio_lruvec_lock_irqsave, and I think that's from the free path where
> > in folios_put_refs(), __page_cache_release() keeps the lruvec locked
> > across the whole batch, and folio_unqueue_deferred_split() gets called
> > from inside that loop with that lruvec lock held. I don't think
> > batching the enqueues would help in that case, since the cost is
> > coming from the unqueue side and on a path that's already batched. I
> > think maybe we could move the unqueue out where the lruvec lock
> > doesn't need to be held while the unqueueing happens, but I need to
> > look more into that.
>
> That's an interesting insight. If contention is less of a problem right n=
ow with
> that reproducer, even better!
>
> I prefer us not doing unnecessary work (adding folios to the deferred spl=
it
> queue) when we won't really split them. (if it's contention or some other
> overhead doesn't really matter)
>
>
> >>>
> >>> Does that make scaling acceptable to you and Barry? If so, I'd prefer
> >>> that as well because if/when intermediary values are supported for
> >>> mTHP collapse, that support would have to be proportional, and it'd b=
e
> >>> easier to reconcile the two with split also scaled. If not, then what
> >>> would be the suggestion for where to take v3?
> >> My opinion is (open for discussion :) ) that scaling is likely the bet=
ter
> >> approach. With the following notes:
> >>
> >> (1) If we want to enable mTHP collapse with scaling as well, this need=
s very
> >> good documentation and also another thought on how to work around the =
problem of
> >> creep (e.g., refusing to collapse if creep would be possible according=
 to the
> >> max_ptes_non setting and warning).
> >
> > Agreed. And if/when collapse gains proportional support later on,
> > having split already scaled means one value governing both instead of
> > two.
> >
> >>
> >> (2) Systems where the underused shrinker is effectively inactive shoul=
d not add
> >> folios to the deferred list. Including PMD THPs, which we unconditiona=
lly add today.
> >
> > Agreed.
> >
> >>
> >> (3) If we want to exclude certain small folio sizes from the underused=
 shrinker
> >> (e.g., order-2? order-3?) it might be better to just hard-code that in=
 the
> >> kernel instead of giving the admin a choice it cannot possibly make ea=
sily.
> >
> > Based off the benchmark results in [1] and [2], I think the cutoff
> > needs to be at 64k where we exclude anything under that. On 4k base
> > pages, this is order 4, but on 64k base pages, order 4 would mean 1M,
> > which I think would be overly conservative. I think it makes more
> > sense to express it as an absolute threshold value instead of by
> > order. I'll try to find an arm64 machine to double-check this on.
>
> If we don't add folios to deferred split queue if current underused shrin=
ker
> config wouldn't ever split them, I think there is no overhead for Android=
 in any
> case (so Barry wouldn't have to worry, at least for now).
>
> So the magic number we chose only applies if the underused shrinker is en=
abled
> and could eventually split them.
>
> There, I think what should drive our decision is not the current runtime
> overhead, but instead how realistic it is that we would actually reclaim
> "enough" memory on average from these folios.
>
> IOW, if the whole effort of scanning these small things is really worth i=
t.
>
> For an order-2 folio I'd assume "unlikely". Maybe we could collect some d=
ata
> from some real workloads?
>
> But I guess Meta is mostly focusing on 2M and doesn't really have data fo=
r any
> other folio size how effective the underused scanner is for them.
>
> >

I don't have any measurable data for the smaller sizes unfortunately
as our fleet only runs 2M. On the other subthread, Barry suggested
using 2M [2] as the threshold, which I like. That would cover Meta's
use case (64k base pages with 2M mTHP set to always) while being
conservative enough to keep smaller folios off the queue entirely,
where if we want to lower the threshold later, we could revisit it
when there is more substantial data. For v3, I'll use 2M as the
threshold.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-mm/65b4baa3-77bd-4d2c-a128-9884f858e63d@k=
ernel.org/
[2] https://lore.kernel.org/linux-mm/CAGsJ_4xWC4hg_-MLoDn3Zav7NUM709gu1jPeQ=
pRuODdt8OUpZQ@mail.gmail.com/

