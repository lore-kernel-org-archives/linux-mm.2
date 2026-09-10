Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85187C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933AA6B008A; Thu, 10 Sep 2026 11:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5226B008C; Thu, 10 Sep 2026 11:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4526B0096; Thu, 10 Sep 2026 11:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 511836B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:46:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F6E816059B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:46:06 +0000 (UTC)
X-FDA: 85198278732.07.CEB2F69
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6ED914000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:46:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nygSCXIB;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789055164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1gukMKgmXXLSe/xkuRtjWvRwSakZxXxaaknc5QrDEs=;
	b=c9NzDm5Yy0liL/X08fUBSYhflTrs4gvcYZzL6gjaMbXWfNekgdzlkmWFaRkjZc5+Pmb4j/
	F6R2/tfETXa+gRFzabrYM6BrTBkvj5KjDjILQ1YsIC9xi0esWgEsk6qYKVE4F3W8VrHMsi
	doI0eurNVNnqTs0acPUbzuQ8Zh33X3A=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nygSCXIB;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789055164;
	b=8Nh+/NC7Dkd4vqbWnkiBAwOct4/LWzxyVcZ1VcnhmroHGCTovtyVrPh9zg75LAmtEM40Qw
	iyfuvnOk3VfvpEh5HJnebls6mOBwB3O/089/jpNrO1Hlop2hWww+Vnb1SnrxIFVG39jCr6
	AgerLLls6ETHBvI0U/8K1uSg8nwVQLs=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so312181cf.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:46:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789055163; cv=none;
        d=google.com; s=arc-20260327;
        b=YWD+h6KUY2AQIedpeLr/qACTy8R6/ncP0B3/TLvaPVOy0VrUtM59K5oV5oG//jDQBO
         UUT3SICDX8cNBjf8ohKj5am9XyADZb6UDBSa+y4Uga7AF3kiIl3dE3Hu+dhFftHZEEVT
         /OZl+75GhGMHzuaTu2fcTeOmATOnsDHcTKC8nKNH42fgSEuMljVIsxZ3KSpZqCzfqnIx
         zXtf7bisTzXVxZLWrCbD/5uvQysBFmR6pmg0y15qN92TF606w/JNO2dXmmzsZcQPvc8H
         kLRzRDcImUhVjmU+zQNpgDonZT3SqqMepmraUiF43w7DeyUfZiMGetpIFMGCwGd3O6t8
         bT3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m1gukMKgmXXLSe/xkuRtjWvRwSakZxXxaaknc5QrDEs=;
        fh=Pxwa+FNoex63KzzBkRJ+Q/FGt8FrLUf/v1Drd0uR0cQ=;
        b=M8quFikn6ssK/C0SDzne8kRwA5QMMEr+aqqv1DJHtIfuCkGfcoKx5PtSOUPGysnU2K
         BBnMUfqMB1r+KoUzibDWNmftUY7tlVtdamA3j3j578MFf46pMqUGJpzbLvgkyqUTHBRx
         VVIayGPLquW7s8dKlbxbet16Nhi+rQWmhFTs1UBf/eBQWneIBNlcRzyGCetcxDG4Yqpd
         AbFeQxEZYppKYDaXC+MOT+Ga+/H93tX1CNb/K4ancrLk+fzXoipOHdbHFUQ8sBQwBfOf
         QTiuaCE8n4NBwPp2YxGVyvR1D/5YYLhu5xsfEyxmfqPVIsf6Xu8ehoz6gwW2L0/2Iq3r
         6O+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789055163; x=1789659963; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m1gukMKgmXXLSe/xkuRtjWvRwSakZxXxaaknc5QrDEs=;
        b=nygSCXIBDzu6yGQBQuYny7ZzohmnOAAl457HTwsdYEOq0l7B4YIUkqAKigxWNswK21
         mFrCssMM85eX2QnsWdmgs4xj3+Sa5FCXT0BTOkIjvNLmreCVLiKrpmowixwGVPPsEQX6
         D9baEDzl7gXhG2zZZ/nhdvnERez6olqY3vHtijwmQW69k590MuZYtupH+Fjn06UOEkpN
         dsaiUdlrFSymYWSLzqXMs49Mhi7OIgvw0yEg8mpQVFCLWNG1utc1jwp8YAFcEUyKdDXE
         TRgSLerN7UQR2DUtIV2cpRaFCzdE1UxwZun4EWQiqRsprGJHsRtjSuAzFw99Fl8dBoAd
         A00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789055163; x=1789659963;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m1gukMKgmXXLSe/xkuRtjWvRwSakZxXxaaknc5QrDEs=;
        b=F2LoXYytF7S9yV47fCv5tUQRdgRaatxGwhkaIG9Gh5uvmuSEdz2/RTTDdes/wY8RPg
         gqYRv7xko5S1eAN2uUiNyJMBT2HYEPgjPXjRHQiqfmDzmJd19+L17cxyxgM/c4pTjGxR
         GP64OTEuoYJ5qnIcy08OzaoiDHbTwFB2MyW//xBiRTGA6hO7rUfrP9M+F1bSVcU5x/x3
         MVDAu10+P4SPlWhMX0hdmgF5gdmj+t5jzmOpLF3VTIsqn0v1Rw3Y+mBIKP//kuRpvPHD
         olkw+bqxi/YkHy8KqxHIc1MoAYXwxgRKWorKpD0yps0aQSWwNxTKY9aMdkY2K2YwV1tt
         2DYw==
X-Forwarded-Encrypted: i=1; AKwUvByc5ArKCmg2kQ3AY6zt6+lHBnArnGWTqCgwNkKMoyO3cs6+7XZz3K/U39lE6JgfWQxM6LYk7T8OMg==@kvack.org
X-Gm-Message-State: AFuF++mWl3EHNUruu/hvprbfKKITFM+PkEEmp1r3u5/lJzyjLnQpHGgj
	Dap/kqIwOySRn3MyD137pIFd5jwJHayrHgN9np0XJT2e/+hF66MrvC8xYVN7fgOpcm0JP9UwZvd
	Obh2sbOXZm/PVwDH/kVSzz35P92pVIr8aVIo+gmI9
X-Gm-Gg: AYBFou2nfCojKhcPcBu8SODjARQ+76nIBW7Taa6pocf0x7h7XBVvU+RnYuxToi+AaAr
	GpgdfWBUYpUx7hy9Xo0JE6I7VH67ukAeH8DkIYl9Ak6qLbTs6mLs2T1Jy1yeyQR2I3eoRjO7Hm1
	fy3ZQ0LHfiRF4+iixqlt9pxcDZt1mTdQHB7Zu02c4wLzv9oBQykB7//iD6zRsHbqbzHTqgXBguD
	g5z8VJbcU32CjCIgG5YP7AMrxob0+G1WiZ9G2C00f4MIMM3OwB3zBTU6qNl1e9SxPCHi2rIqqAF
	mMIblwVkISXIfvzKkPcYO5SbyjTKvxigMu6dql9eGHA74zK4wMugC9Gkn+0FwOVdTHQPe2DJPOn
	Dr8ebFYYiVg==
X-Received: by 2002:a05:622a:1c17:b0:52f:9ed4:8d76 with SMTP id
 d75a77b69052e-530b49672bdmr21908571cf.14.1789055162926; Thu, 10 Sep 2026
 08:46:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org> <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org> <CAJuCfpEYdj=u0wczKRrsB8uDkbSzPy+hrsCo9TW9-3J3r3p0xQ@mail.gmail.com>
 <2336140f-c993-467a-b2eb-e99dc9427a59@kernel.org>
In-Reply-To: <2336140f-c993-467a-b2eb-e99dc9427a59@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 08:45:51 -0700
X-Gm-Features: AcwNN1U3AJ7bd1wu5DAq47WAQ3768Dp9C-h3ciQoeJdMEez_KO5Qa_LhKJ8PHrw
Message-ID: <CAJuCfpEL40p+vk6-km6_BBuE3+YY0WqkpbvQnQGFEo_73MAomQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6ED914000C
X-Stat-Signature: iaguhjmdiacyi9ty6teffham5qei8ciw
X-Rspam-User: 
X-HE-Tag: 1789055164-727021
X-HE-Meta: U2FsdGVkX1+JzAQJffbs4b4ckfygQEVW6yYPRlkKfCcpy0vvVgrlROlz1tqijbXh4OzLyy7idVmzk/HQ0cM52+Bsd4GoKQ9rSpCo7KNqBY2EGVqsCCwhyiPJtbLO+7qZ20wDo8FElhtCdew0xljqJ+OzlRYIM//e2cVaYlEgPn1Zkirf59cOcKD0KeKvQg3T06NZZAFUZ5Ev0fXiVyTISj8IaLfP4EXsiC/4IhZipL7HukI5bj6HOGUpCqFwrUYR2XMmpouql1CZZvpqu79YvYfpU5zv8kvgmRwApEh+t8EyJRzDUa0QCUwUzSWOqAaVLCdBna4dFEEViARp+wZw2iip+0mt1KrmTQHtg6btltMoiNtnOGsdJ4N3QlSPLP2bSL6TRuQuFmAcPzD8q7q+hde2FcpuXCWgmPIcoI5BMyP9vtrs+p0OhRZ/1+5eBOVwlKE1AnrgWggHhDoEr1Lit63s2GsK+PxZ6/BddNwgvT+pgyzGzNvNe7A2OIPIUN4VINPMv7dDB4jwm3nZQgPpMMMg1zY6sj56Tg/r093gjkCcsgtk4prgenH1JElc/ntFoZH9VeO7IpgI99sstNp+JH+2FLUMKGpKM/3oXLffmzdu4HVI9XZ+lj2wkp0g6kXbQJfKctyssbRgtYNUbnjgfJJBTPw2MuBbQ6GrjOebn8u5JPdGIIqoZQN8IfDpcdiWQpZy1XwKtikSJ7PG4OASWmFI/YV83dhwVliuAaLIOdaArbSrqiwMpfRoVQlW7AObVlVySiCTUnoGT/7CFyLqxKgAztxix3/CAXAxmp80YL2OwA42/6HesUG+poj3za0Oxx4IUe1Kvy6fn117aEVVP942hGak/0BLJLSJwglm2DLQ2xkc1aGF1X2cUz5iyQRYMuqcN7vNmqwos7CbeE1S9dzLw032twt4TScvcRaZwY0qxM9cxD5cz1mGQljfENYKcZ1cwxCmXp/sRxHNvbA
 xc/qh0VF
 57WXhK4QOk3DaDEkbfyymgRVJpi957xeXnyNxzxu2akQsE55l8aAonnSsTGrLe1MeRpigxsmO6dScyDQhWRuoJKWpX1rtUvpngDuFkXbO36/nm8GqsupeuwPLuF82QAFdiC56G1iQZO/2o3eHPoRb6GnMhr2p0qJDrFmCFooPyTViZMoEpAPytBKklhRP6fCu60CtyDRG3sHbtuDC/P2CSiEFamyEcNHoWQuobZ0/8qJREG8Tw03Wo9O1tvZGvVPORkcPrJYVyuvbESy+pktI4gJ70PN3nomz1ju4LVpqmKsIbpS80oPGd2IVNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 12:41=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/9/26 23:51, Suren Baghdasaryan wrote:
> > On Wed, Sep 9, 2026 at 12:16=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/9/26 20:28, Suren Baghdasaryan wrote:
> >>> On Wed, Sep 9, 2026 at 10:16=E2=80=AFAM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> Hmm. So, are you saying that !is_cow always implies shared_or_ro? Or
> >>> maybe you are stating that vma_is_cow_mapping() was the actual intent
> >>> here?
> >>
> >> So the comment says:
> >>
> >> "For private writable mappings, we might have COW pages that  .."
> >>
> >> Which translates to:
> >>
> >>         private writable =3D=3D vma_is_cow_mapping()
> >
> > Ok, just want to make sure I'm not missing something subtle.
> >
> >>
> >>>
> >>> shared_or_ro =3D VMA_SHARED_BIT || !VMA_WRITE_BIT
> >>>
> >>> is_cow =3D !VMA_SHARED_BIT && VMA_MAYWRITE_BIT
> >>> !is_cow =3D VMA_SHARED_BIT || !VMA_MAYWRITE_BIT
> >>>
> >>> so, !is_cow would impy shared_or_ro only if !VMA_MAYWRITE_BIT always
> >>> implies !VMA_WRITE_BIT. But I think it's possible to have a VMA that
> >>> has VMA_WRITE_BIT but not VMA_MAYWRITE_BIT, right?
> >>
> >> VMA_WRITE should imply VMA_MAYWRITE
> >
> > Ah, good to know.
> >
> >>
> >> (in sanitize_fault_flags() we even disallow write faults entirely if V=
M_MAYWRITE
> >> is missing)
> >
> > I see.
> >
> >>
> >> For example, a
> >>> driver can create such a VMA to allow writing to the VMA but to lock
> >>> its content once mprotect(PROT_READ) gets called.
> >>
> >> I don't think that would be valid for a driver to do. But it wouldn't =
matter
> >> here because
> >>
> >>         shmem_mapping(vma->vm_file->f_mapping)
> >
> > I was obviously overthinking this :)
> >
> >>
> >>
> >> I think we could simplify the comment as well to:
> >>
> >> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> >> index e671b4fd8dedd..4b7e7089cafa7 100644
> >> --- a/fs/proc/task_mmu.c
> >> +++ b/fs/proc/task_mmu.c
> >> @@ -1303,12 +1303,10 @@ static void smap_gather_stats(struct proc_maps=
_private
> >> *priv,if (is_partial || (shmem_swapped && is_cow))
> >>
> >>         if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
> >>                 /*
> >> -                * For shared or readonly shmem mappings we know that =
all
> >> -                * swapped out pages belong to the shmem object, and w=
e can
> >> -                * obtain the swap value much more efficiently. For pr=
ivate
> >> -                * writable mappings, we might have COW pages that are
> >> -                * not affected by the parent swapped out pages of the=
 shmem
> >> -                * object, so we have to distinguish them during the p=
age walk.
> >> +                * In CoW mappings, we might have anon folios that are
> >> +                * independent of the shmem object. So fallback to the=
 less
> >> +                * efficient mechanism in such mappings.
> >> +                *
> >
> > Sounds good. Will update.
>
> Likely worth putting that into a prior cleanup patch, so there is less no=
ise in
> this patch.

Well, this is a cleanup specific for smap_gather_stats() funciton, so
I would prefer to keep all the pieces in one place.

>
> --
> Cheers,
>
> David

