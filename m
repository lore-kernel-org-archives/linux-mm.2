Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7681DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17ABF6B0088; Fri, 25 Jul 2025 10:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C4F6B008C; Fri, 25 Jul 2025 10:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042616B0092; Fri, 25 Jul 2025 10:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB0B66B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:48:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A357807C8
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:48:49 +0000 (UTC)
X-FDA: 83703068778.28.CFCC61C
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id C6EC440012
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:48:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ECe/SPaf";
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753454927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fTiJ/2yQ7EUbjCeVCBz++1COYxUgI84X7sP0FcZaWQ=;
	b=cNRI3eL+l6TSCwy4fmKvFZ3HNk6JAS7VAhHmZs9R4Vn46QRhjRSQfn7vKWaP1vblmOykVC
	/oXcF1eRqNfvmJCU/J3JillTQzUuci9Q3VOyfTf3/+US4tFLj4UNRPKK+Js96Sn1wN+DXp
	VzS+2/2PJ7WHZUxFx+vS1tuDvaIdksc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ECe/SPaf";
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753454927; a=rsa-sha256;
	cv=none;
	b=wdJlWWFkW8azWuYl8IoMat5+ihUI/2pOK3kz25jONjDruteW2lZEe9n7I0WwSK0ufsRmon
	1mmNvpliLaUrJ5E6bL1PSicq8VDcVi2cXQjMkiXe3PHJ+lxTlLlLQRWi+SeTRrZmnDotWg
	1RQlou867Uh4nIW5haXKqEoGbpFt5ws=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso9598a12.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753454926; x=1754059726; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fTiJ/2yQ7EUbjCeVCBz++1COYxUgI84X7sP0FcZaWQ=;
        b=ECe/SPafsbJkAjD3Vsp3X6SCEHBGKJHS81vUvksNrCCE2lZfkIkjCYjc4js+5Z5FZt
         LlF1sSx6VqCu9woEauN7q4afAMi1Si5BBooH5rRZx+H9Sn6DXHbAeKj6vr4l3UiCWBpa
         quZLrY2tpxM4t7scgPmAIyawU3sVSAxlrt2vGfwW88CgrgGkImNhWxLCjh8LeYrS+7+2
         A4/QY/UX+8LXRECKMVmgIkAuj3qhux9qTeBHZ11whvEupRDUR2F6RfIQXp0a4otKggEM
         podO4nJX0va7oE9GnUEHOwiliojLFHIaxMUbn1gPvkTkSksPwxawWK8FAooQoR/xZJdI
         +Onw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753454926; x=1754059726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fTiJ/2yQ7EUbjCeVCBz++1COYxUgI84X7sP0FcZaWQ=;
        b=aMO15QqC3c6lmNFBpdu0EKEV2JwCDaMlHdR1dCTfXzmK0wufepBtyy9SaodF3m5L1N
         dKeNo884PWpc2aeEzAJRhj0cBQn4dE1r9I08qJVCiGRSuBr+T9iLn+dtd/M3E06BpgzH
         Rv+UEW8YrXj0HgJy/Xw3ep7MCu+Wtte85LnmAK+dO41ngOBQ7evszYG9FVCpuCMGuest
         GvojHiwE2m0nnKfKil+QlrVTGPTcZXk/xCENznRYliWWebIDE8iShyuL4FcgmakAHAxg
         JPT9Z6pLgdHZzDn8aRSflYoszAWzM6TDJ8ojDLcYmBL+yo6RpXdMcAzhNTIcsYD2wY5+
         uBJw==
X-Forwarded-Encrypted: i=1; AJvYcCXcVYeNs1U1xVsUH+phb80wVPcLUlA5gNcAU5OOt8W2K494GDxjJhl4jzKaJYd3AYAXN04BLPFnjQ==@kvack.org
X-Gm-Message-State: AOJu0Yzyy+Ccj34zLGRF2mpUAP/4X+XO0Zgmq+z61ZpH9p2x+CqTu5Wg
	Ar6C2UOw0WGhfqIyR+Z17MPPj2v6YEJDpG5EMCHAPuMVe4MRAh7k/zooz8poyQM7QIAwY4zxM2b
	q48w6xKKkrGzK3knVXQNBOUnYAPcHwTwGQALF0cnW
X-Gm-Gg: ASbGncvqkBTAEugB9+n8opYUKOFJ4TvvHSLzLCDMcfzqXMZsxrA5OMHLJcM44QvcTxg
	w/imHTklXhWNRZNgtJHTL9skSAOFC5sug3RTZqrSTbiyn5BTmI1c3IeRxvImh1Rns5C0OQauVri
	VsSocNynsQteY/Ia2AcVrh89a3pLWBabzBCexQUeWn3lWsC/V+d4j5+RZdZ6R2ezMARGNRFYVBX
	T6w4iRLKXe3x6Xgb0W4qGdpsvzDHMIGC6Q=
X-Google-Smtp-Source: AGHT+IFQ5AMiQfPybrXcmBkRC8UMaPAwiYPs8TQcD30T1QIfVF3Vtd6z6dbAtwTEtc6Dd6Sjmp1+B0ZsJ9Yqhgfl2cw=
X-Received: by 2002:a05:6402:40d1:b0:60e:5391:a9e5 with SMTP id
 4fb4d7f45d1cf-614ea755d34mr89389a12.5.1753454925860; Fri, 25 Jul 2025
 07:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local> <CAG48ez31aVnoBiMMjUczbmThWnRGmod4yppgMVqf2Nu5-hjU2g@mail.gmail.com>
 <50502c3b-903f-4018-b796-4a158f939593@lucifer.local>
In-Reply-To: <50502c3b-903f-4018-b796-4a158f939593@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 16:48:09 +0200
X-Gm-Features: Ac12FXzAIpPjC-gw79jtBUmPpJHNu7DPT7TU7_vGFytRzjofambUs1vGAWWcnjY
Message-ID: <CAG48ez1TOULrpJGsUYvRSsrdWBepCJf9jh-xPpurRUXbMmAkuA@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mepstn999g1577bonh5irgn8a4wamg5k
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6EC440012
X-Rspam-User: 
X-HE-Tag: 1753454927-280560
X-HE-Meta: U2FsdGVkX1+tkIC6ucYmhV3mtkQlxmnmxHsGDwMyxocJ4uiRCU1qGmFFevgNccul9BoasJF3Nul8i26jVBBmW8qxCSupwlrvkFlZqOV9oCUYd42SKGqBB/F3XT6rbuuSc4qXO4tJnkDlxV1GtgAS8yhxEw5jeJXKlSXyAYUD8KAeJJpGQOPNPzHcDPQjUStbiOBkj+vLJ60GNoKLKIAG+kb4eVL/BEEmZytUHDsdVJY5s4qtVldtAoE++RAfdcOEWY6C/M2/5WJPcwvjDY7FFt0fFdCzWr05NydRZYGKo1nTY7wZq+1G75wY7ZIN1UkfJ5PjI0aRNo/UtZtoUUVWllzqFZfBiatV55ZNXeQewkfbFQmNKn8+22IIpyRA/XBdb76VyfB3xD4dSHOFqn0hay/bjjgHLRUFLrUrlHmvokS1PzqUTKhiP/nxY7ngNOUnI0fXL+h6Ky9M256SR3HVnTazlSdvYMjRZA2Wkd5aeoYb48DGMGY4wu00ikTRtlySP6Zuq4rhQwmCCnO+NImaJz2lKUsRwQQZAMsVqzfZx9YweT33zs2Jdm9U+78DJIY5RtQDzJ7nbVNJT7B1przc9KG/uadC1cFiC6vVzrjXNXtufwUtgNLbvaiYVSzXNWeOuNpiJx+IrwIddQ9+jcLTpXd2R+bfL7USJyMDiqVCPwk+ZxJ9stDzeJKP2u+kDn9phmFOIQEjojewCKV1TAVyS9PCHmT+RE2ImSPMUHcezB6Sod644MKj8UbMU0Ss54zYB7ePe926Ol6a5rDOZvtSvnAzCyAr6KW5Ley9KLx5wnuAOTJ/POU26O9HrVXfcQLH9fqQgYb2Bb+Yb/DxolFiuI7i8HHlNfOAkexgE70x5Pm3g+9DVn53aLmtsaO4s0qPCCDM0VzOqfmI0Nkxq9NvpflTC0fyttea0mQQwDUo5Zw17E0iwyd31rvAALlXfjgroHlXv737pgcnPuWP/Ml
 pXuKPOXN
 CX3dr5Hz01z/99lQzi5vk0HzISFcMN8BauNo1++2tpy55TwvbtniV4XwclZIYSu0GkqjkX2p1PHo6pFQRpEAvbwn9Yi4rdwuG+GcE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 3:49=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Fri, Jul 25, 2025 at 02:00:18PM +0200, Jann Horn wrote:
> > An anon folio may outlive the VMAs it comes from, so it may also
> > outlive its associated anon_vma.
>
> Yes, I will share some diagrams I did a while ago to outline this. They'r=
e
> ASCII and make you want to cry! :)
>
> Hmm, if non-root, I wonder if we

(looks like you stopped typing mid-sentence)

> > 2. Removing an anon folio mapping reduces the anon folio's mapcount
> > before the VMA can go away.
>
> the anon folio's mapcount? You mean the VMA's? :P

I mean folio_mapcount(folio), which reads folio->_mapcount and
folio->_large_mapcount.

> > 4. If the anon-exclusive bit is set, the folio is only mapped in a
> > single place (otherwise swapout+swapin could erroneously set
> > RMAP_EXCLUSIVE, causing the swapped-in folio to be associated with the
> > wrong anon_vma).
>
> I believe (David?) swapin can cause this not to be the case?
>
> > 5. When a VMA is associated with an anon_vma, it is always also
> > associated with the corresponding root anon_vma (necessary because
> > non-RMAP_EXCLUSIVE swapin falls back to associating the folio with the
> > root anon_vma).
>
> OK but we know for sure the UAF is not on a root anon_vma so it's not som=
e
> weirdness with trying to access anon_vma->root

Ah, right.

> > 6. If two VMAs in the same process have the same ->anon_vma, their
> > anonvma chains must be the same (otherwise VMA merging can break
> > stuff).
> >
>
> What do you mean the same?
>
> If you mean they both must have AVC's which ponit to the individual VMAs
> and each point to the same anon_vma, yes.

Yeah, that.

> God simple isn't it? ;)

Yeah, I prefer to think of this at the slightly higher abstraction
layer of "which VMAs are tied to which anon_vmas via AVC" and "which
VMAs use which anon_vmas as their primary anon_vma"; to me, AVCs being
separate objects is a minor implementation detail caused by the kernel
only using intrusive lists instead of the kinds of data structures
that you'd use in almost any other environment.
(Like, you wouldn't need AVC objects if the references between VMAs
and anon_vmas were formed with things like maple trees or xarrays, but
I guess they wouldn't give you the interval tree semantics you want.)

> I verified these numbers with drgn, interesting add a new child doesn't
> increment refcount...

Yeah - AFAIU a single reference is shared by all the VMAs that are
tied to an anon_vma via AVC nodes, and a child anon_vma can't be
associated with a VMA without its parent also being associated with
the VMA...

> > > We're sort of relying on this
> > >
> > > a. being a UAF
> > >
> > > b. the thing we're UAF-ing not either corrupting this field or (if th=
at
> > >     memory is actually reused as an anon_vma - I'm not familiar with =
slab
> > >     caches - so maybe it's quite likely - getting its refcount increm=
ented.
> >
> > KASAN sees the memory read I'm doing with this atomic_read(), so in
> > KASAN builds, if this is a UAF, it should trigger a KASAN splat
> > (modulo KASAN limitations around when UAF can be detected). Basically,
> > in KASAN builds, the actual explicit check I'm doing here is only
> > relevant if the object has not yet been freed. That's why I wrote the
> > comment "Part of the purpose of the atomic_read() is to make KASAN
> > check that the anon_vma is still alive.".
>
> Hm, I'm confused, how can you detect a UAF if the object cannot yet be
> freed? :P
>
> or would that be the case were it not an atomic_read()?
>
> I guess this permits this to be detected in a timely manner.

If the anon_vma hasn't yet been freed, but its refcount is 0, then
that's still a bug because we rely on the anon_vma to have a nonzero
refcount as long as there are folios with a nonzero mapcount that are
tied to it, and it is likely to allow UAF at a later point.

