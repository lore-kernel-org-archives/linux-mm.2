Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04BA2CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 22:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5668E0085; Wed, 17 Sep 2025 18:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5B48E006B; Wed, 17 Sep 2025 18:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB258E0085; Wed, 17 Sep 2025 18:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 294758E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:04:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B51311606E3
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:04:44 +0000 (UTC)
X-FDA: 83900122488.10.6F145F8
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id C72621C0014
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:04:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kzyHlkMI;
	spf=pass (imf21.hostedemail.com: domain of fvdl@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758146682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7c037OBepDtABbodeSYdc9GHv27CVVqxlwOzBg6Xtz8=;
	b=N5Qo7XFfHVB9TJ1PgSKkfCHHICFs1szPFgsK9gfLUZuzQK19C3xe95YtkYyzjLtKpPISBZ
	mzjXo8szcAO8DAwyMH+cwJbzyWEOZDQ7aHoZX00YNVpvb+lsjs4bcIYBXxSuRF+brUxeAg
	y2jXEH3zzFlbuIZ1fnS80JUPxPHQDis=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758146682; a=rsa-sha256;
	cv=none;
	b=IgDSPcJ9oeUJRhlyuSQmvwpdKDmRTmF+K02aRyFs8dVE5BKUOuBYK0IyaR2iBh3bgUfSiQ
	2xmG0gAhj5ultxFVT2suVbsaJX3TnzYNtzfqHLf9SrtKxGeHjo6bsq0Col9Qc/Q9/43dsB
	kx4An8wivhsHfWaPI1VBL/eTDcTapwA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kzyHlkMI;
	spf=pass (imf21.hostedemail.com: domain of fvdl@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b78657a35aso116441cf.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758146682; x=1758751482; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7c037OBepDtABbodeSYdc9GHv27CVVqxlwOzBg6Xtz8=;
        b=kzyHlkMIFTR+sbli0BkMpC2tC19o6bh0K92SydfOy2mgPhvOWaReB2+mmLbVo3Wc8g
         yAa79SoDwKuavDYFJR3dOk2qIW6WTWkVtryrd6zDL4LS1anI05NFXCy919GzEEOB405C
         WqxeIJc6s4a4dTrQkSvqYSi6TixiIWiQz1bw6iYFnFE6Lry/aPVsf+n/UWj3LCCDShX9
         F9CtvMoz5vRujePmZk13BNWDB6R0Sy/mgnR5yGCuhOkcvG31Dc3RSmzf/bKSDEKiz8jQ
         wPJRARPbjW2/1+c1ntbEAjSDHqG5tWi7+OMepOjbgHOSttqgLagVnlNMF/BDue6+j0Yd
         CNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758146682; x=1758751482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7c037OBepDtABbodeSYdc9GHv27CVVqxlwOzBg6Xtz8=;
        b=RREPXfvHtMwHuwDWbj9RomqJxo7C2B4BCsQ5h/acyyAIL7zcH0hqUi5tM1ivb5UTid
         R2Czp0jY7BkMr8wI2Sge3/6vHEPT4N5Sy+NmBUkTUfr79kJm0ZDkQiRDasYCP5nBpc1v
         54tkdA6bRxTse836fCrb/1di38vOiqhS2gw3z/2WL77Xql+JweAFp8ETz7GbkMEqG8cz
         FMf/HrXyE6+ijttHceCwPCjjPgZog3ogdYSukN3lretaW3X76bmm6Ew+nLTCuUtcp9cl
         vQMLeJZdToRz/9oHi/LRde2Py9Qoe4GRrhF34hkoFZCFMWSei8BsV+EJKdU1Kl0lCVm8
         1GNw==
X-Forwarded-Encrypted: i=1; AJvYcCVCcuOsUuyHXz4LYiuEYlcvR/xYqQN0g3uf9Ju7FeA6GxrqJswIt7WQUF5Ec+ldVhQJSBZFXrGffw==@kvack.org
X-Gm-Message-State: AOJu0YybC8vybLgIUFiD65Pvv5OmtkKeDGead+5OcMeHSEyDIkVj+w60
	VwJovyIiu4z2Cbp29BWdG17hfp6abKWT/Z05vqlrEUXXs7vE7/KXS9zcgjwjLBJXLsAIeKg0TIe
	B0C1mKVBFm0n0psD/59a58DXxeK24wmRHF8Szvgcu
X-Gm-Gg: ASbGncsYrA1LTVNnQfAKF6gtGFCN13sYQatYd1YJWuwZvCN5FRfvMF12hK5h7PBgMuw
	2nrMMdyYbAkkDyTh8xyw4oAnn1YRbFfr6ZkZPfIWt2oU3A7gvHyVYOIpCfPHevkhlUbQJns7ga+
	q7Zy8DYMKzUudiaFn3e9blVAywGNEqVhOC0lUgX+kwXZJ0mAzmXfUVcxpHQ58eZ+6GjMhsNrETY
	2qi9zTwKfxaIohwpxzPf/kMnvVxtA==
X-Google-Smtp-Source: AGHT+IGDI6LJLfycjfeE1B/pgIh/9NIsQqEJIx7nxHWRrjhDqG/oq1RUbkZqCENyyqfCAvnUxyLWTbnk2uL801F6uvk=
X-Received: by 2002:a05:622a:8597:b0:4b7:9b7a:1cfc with SMTP id
 d75a77b69052e-4bbf022e4f3mr4682571cf.10.1758146681555; Wed, 17 Sep 2025
 15:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com> <7ia4ecs59a2b.fsf@castle.c.googlers.com>
In-Reply-To: <7ia4ecs59a2b.fsf@castle.c.googlers.com>
From: Frank van der Linden <fvdl@google.com>
Date: Wed, 17 Sep 2025 15:04:30 -0700
X-Gm-Features: AS18NWCkUN2Jz1n68DzLl5mlp3KsVWCGAZPBnGbVyd4mox136r8TgQG5palyZuI
Message-ID: <CAPTztWYp2yPsdvFfMm6bVB-juwHM11zKAEty9q+J8gy5d-8=KQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/12] CMA balancing
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C72621C0014
X-Stat-Signature: 6isx6jo9s6k7auxj8uts8cn3h98unb5h
X-Rspam-User: 
X-HE-Tag: 1758146682-770585
X-HE-Meta: U2FsdGVkX18MN1e1KFOVP79fRFr/1RMV3OiEMgG+ypi9f8hZRNE9iI1C6xwfnWsAG8Q38P6F4r0/uGo4UBMM8kIGUSNUw6drpkS0DkuPFZgYjAprIWEBKewNi80x7Br2YQBejBV4m51Fge0OCAYyS4HXa/VzyikfuFeXl+cCNyXw70WXJy2JnLIdljwuysllrYFjWNDfYOMXxj/9nMWc0E1eyaAhatrztMCTuLfmQq/0TRIj5csG1F75CMCMealf9bfRjzKAQcC/W0TUmZA81KsBkUWdWXnXyBsk+t9VakYCoKFAZ/2crP1RM13ncEzXJc4f1mbnvlW9aSvd2LBTI7/UHoOKo1EeC65UymlBNl7T7+Mf9v7Ng2pCwgdmoJwFyf/K7NN/5MdEJwoRow+gIxF3/ThoxSjt36xvk5vwCZA8gOu3NDGuB0XCUAlgf1WJqv4peSiYaEkrHJPH8dDoy1nNZ1vm6mHFQj+LdBerDBAc88CZ0l7IFYwDHk0bRMcMGwamzIOIQM6Uc6XNjxHH/jpQMQjMH3wvUcrTimk7kEhnX8+hd4Vrl2toKXyECRo1b2qBP0tv7i3lf9YmhBazS3Dzf/4xbdwODyq+egfGUm4arS3Af+DUVy48YsVlhmuv/FU/u5Vct5iggMTqc3fAZcEJF8SRH92O7CGX+/TcEKf9pVEIh1ckcixj+F4IdIw4zMh8eOjud+id2DLb8IDHdE0c/gmrIRs4ckRqfvhMLSy24fesPwpJRno2mTJxgk/gi6Q9m+PzS211EWgT42GABGobTS2+J2C1032RbWwgdWIIvQVDF6a96tmytzjIdJPSVBELVm/1aX3Zg800dwQelTmkHZ0sZxkd6qeekWRXmqNN2+R2k2moAO/V+eRBq+/g1OuYaVznLa494oyV1YfGFDMXNVY8rp2kMaXNtKnAgrj2ZrPIf1mtfMWEbPeQUnHqN/215fqV7znpyzbDt4M
 J8zHGi3l
 0jSp2BTEIUu/Z7tb/ei6IocxPu9ZEoMhs2sw6lFbW3ldoNIxSHPNqJvB39dkP0GcHfh5wS6uQGkVsV+znCU1sMBmb1nCC31olR3T36VCdXTbhiDVV1vIxc9rpLupCN88uZzV+n+pIhZeDntJ40FfezgeEIb3+GbA/DqNgZk+nwHu/MURT6sLZNt5ST0NGR5Y8Y3NSMP9zieHabFhYm9SkmlzOoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 5:51=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Frank van der Linden <fvdl@google.com> writes:
>
> > This is an RFC on a solution to the long standing problem of OOMs
> > occuring when the kernel runs out of space for unmovable allocations
> > in the face of large amounts of CMA.
> >
> > Introduction
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > When there is a large amount of CMA (e.g. with hugetlb_cma), it is
> > possible for the kernel to run out of space to get unmovable
> > allocations from. This is because it cannot use the CMA area.
> > If the issue is just that there is a large CMA area, and that
> > there isn't enough space left, that can be considered a
> > misconfigured system. However, there is a scenario in which
> > things could have been dealt with better: if the non-CMA area
> > also has movable allocations in it, and there are CMA pageblocks
> > still available.
> >
> > The current mitigation for this issue is to start using CMA
> > pageblocks for movable allocations first if the amount of
> > free CMA pageblocks is more than 50% of the total amount
> > of free memory in a zone. But that may not always work out,
> > e.g. the system could easily run in to a scenario where
> > long-lasting movable allocations are made first, which do
> > not go to CMA before the 50% mark is reached. When the
> > non-CMA area fills up, these will get in the way of the
> > kernel's unmovable allocations, and OOMs might occur.
> >
> > Even always directing movable allocations to CMA first does
> > not completely fix the issue. Take a scenario where there
> > is a large amount of CMA through hugetlb_cma. All of that
> > CMA has been taken up by 1G hugetlb pages. So, movable allocations
> > end up in the non-CMA area. Now, the number of hugetlb
> > pages in the pool is lowered, so some CMA becomes available.
> > At the same time, increased system activity leads to more unmovable
> > allocations. Since the movable allocations are still in the non-CMA
> > area, these kernel allocations might still fail.
> >
> >
> > Additionally, CMA areas are allocated at the bottom of the zone.
> > There has been some discussion on this in the past. Originally,
> > doing allocations from CMA was deemed something that was best
> > avoided. The arguments were twofold:
> >
> > 1) cma_alloc needs to be quick and should not have to migrate a
> >    lot of pages.
> > 2) migration might fail, so the fewer pages it has to migrate
> >    the better
> >
> > These arguments are why CMA is avoided (until the 50% limit is hit),
> > and why CMA areas are allocated at the bottom of a zone. But
> > compaction migrates memory from the bottom to the top of a zone.
> > That means that compaction will actually end up migrating movable
> > allocations out of CMA and in to non-CMA, making the issue of
> > OOMing for unmovable allocations worse.
> >
> > Solution: CMA balancing
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > First, this patch set makes the 50% threshold configurable, which
> > is useful in any case. vm.cma_first_limit is the percentage of
> > free CMA, as part of the total amount of free memory in a zone,
> > above which CMA will be used first for movable allocations. 0
> > is always, 100 is never.
> >
> > Then, it creates an interface that allows for moving movable
> > allocations from non-CMA to CMA. CMA areas opt in to taking part
> > in this through a flag. Also, if the flag is set for a CMA area,
> > it is allocated at the top of a zone instead of the bottom.
>
> Hm, what if we can teach the compaction code to start off the
> beginning of the zone or end of cma zone(s) depending on the
> current balance?
>
> The problem with placing the cma area at the end is that it might
> significantly decrease the success rate of cma allocations
> when it's racing with the background compaction, which is hard
> to control. At least it was clearly so in my measurements several
> years ago.

Indeed, I saw your change that moved the CMA areas to the bottom of
the zone for that reason. In my testing, I saw a slight uptick in
cma_alloc failures for HugeTLB (due to migration failures), but it
wasn't much at all. Also, our current usage scenario can deal with the
occasional failure, so it was less of a concern. I can try to re-run
some tests to see if I can gather some harder numbers on that - the
problem is of course finding a test case that gives reproducible
results.
>
>
> > Lastly, the hugetlb_cma code was modified to try to migrate
> > movable allocations from non-CMA to CMA when a hugetlb CMA
> > page is freed. Only hugetlb CMA areas opt in to CMA balancing,
> > behavior for all other CMA areas is unchanged.
> >
> > Discussion
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This approach works when tested with a hugetlb_cma setup
> > where a large number of 1G pages is active, but the number
> > is sometimes reduced in exchange for larger non-hugetlb
> > overhead.
> >
> > Arguments against this approach:
> >
> > * It's kind of heavy-handed. Since there is no easy way to
> >   track the amount of movable allocations residing in non-CMA
> >   pageblocks, it will likely end up scanning too much memory,
> >   as it only knows the upper bound.
> > * It should be more integrated with watermark handling in the
> >   allocation slow path. Again, this would likely require
> >   tracking the number of movable allocations in non-CMA
> >   pageblocks.
>
> I think the problem is very real and the proposed approach looks
> reasonable. But I also agree that it's heavy-handed. Doesn't feel
> like "the final" solution :)
>
> I wonder if we can track the amount of free space outside of cma
> and move pages out on reaching a certain low threshold?
> And it can in theory be the part of the generic kswapd/reclaim code.

I considered this, yes. The first problem is that there is no easy way
to express the number that is "pages allocated with __GFP_MOVABLE in
non-CMA pageblocks".  You can approximate pretty well by checking if
they are on the LRU, I suppose.

If you succeed in getting that number accurately, the next issue is
defining the right threshold and when to apply them. E.g. at one point
I had a change to skip CMA pageblocks for compaction if the target
pageblock is non-CMA, and the threshold has been hit. I ended up
dropping it, since this more special-case approach was better for our
use case. But my idea at the time was to add it as a 3rd mechanism to
try harder for allocations (compaction, reclaim, CMA balancing).

It was something like:

1) Track movable allocations in non-CMA areas.
2) If the watermark for an unmovable allocation is below high, stop
migrating things (through compaction) from CMA to non-CMA, and always
start allocating from CMA first.
3) If the watermark is approaching low, don't try compaction if you
know that CMA can be balanced, but do CMA balancing instead, in
amounts that satisfy your needs

One problem here is ping-ponging of memory. If you put CMA areas at
the bottom of the zone, ompaction moves things one way, CMA balancing
the other way.

I think an approach like the above could still work, I just abandoned
it in favor of this more special-cased (and thus safer) one for our
use case.

- Frank

