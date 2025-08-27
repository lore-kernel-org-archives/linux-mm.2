Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD85CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 14:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47E18E0006; Wed, 27 Aug 2025 10:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E568E0001; Wed, 27 Aug 2025 10:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C349F8E0006; Wed, 27 Aug 2025 10:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B03738E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:36:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64C321A0171
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:36:32 +0000 (UTC)
X-FDA: 83822788224.29.5538A26
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id A6361100014
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:36:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MSIY8E47;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756305390; a=rsa-sha256;
	cv=none;
	b=fGDatG8PxDj2fRlTs3vi1ureggF3BGEa4VB/6Mdin84kfml1yNy6U97P/LsHGqXeYkow6W
	VP/30qeRreWtMqn/QN1EkC4psE5QnKQnnP0Bej0kFZL65b+aPZLT1D5SZIxUHa18iWEQ+L
	0s24CbIM4krTh8EbmRBEtAC/9+4Efug=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MSIY8E47;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756305390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yER43C8X788IpQP0esrNVi7SuiWvauhx8PuShr745bA=;
	b=ac1e8kR0IWL6OoNOjzlUGwx7jaLAIxu5QdGwiz8S+upyIZLJItFNaoQQYYdZ0cSDb9kJrD
	q/XxriYaynPkTF/y3015l6vWTSt7/w+ZsCGYaOKwNJ1bycuNl8OofI3Nb7vSmImlQGkeqD
	FbGbPTc0WcqSVkpASbGiHBgdZkOQAGU=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-336989ed3a4so4350991fa.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756305389; x=1756910189; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yER43C8X788IpQP0esrNVi7SuiWvauhx8PuShr745bA=;
        b=MSIY8E476odPRM92DcY6IEqzLh7Ydz1jCvZMBLwgjRGzhV82Dklou0Y2VwBHKaycrE
         ufkTjdaS5DLRwlT0aINTqQXO622MGA/IVwe6Le7y0gpfAWz8n7iUzV4qm8VqjO3O4Ob5
         oSFUV2mYAFKsgHp7IVjMr8tYKAoYrttIGcah/BqLyPs2nE0ioZLSim3jkMG7uIpyBBa3
         xmaI902ViO9RBrxx3kqRmt4BhtOxktxsfnTQlYTtarh1uiajDxP9GsSixjOaCCZ0NhK8
         mjIKWzAyCiaF5wogIltQjFPwW6bYJtrvDK077mIn1eNQ2g2Q2FQAixItCVKDGQPV8XC/
         sfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756305389; x=1756910189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yER43C8X788IpQP0esrNVi7SuiWvauhx8PuShr745bA=;
        b=MSIzoh36mn++Blwm0GaH44uj4Z4/rQYjFDMCZoue1T8lA+S2/t/CRSxlYfCX/IbtdM
         7EFmKnBYp0MtxxBIh0eiy7OvbDh2bQ71VF3Mb9HfGo+euhFUxjZGlfibuOWEwh+h7oOS
         SGjoEerYKsGh/VAc9sJG47VLHhKvC2gk80XZYAwbZfopL/rFisaK1zlFSfBTNVMGP6y2
         E3v5vWRY3OHjpFCnSCsKA4cyaJg5FAQTqmPVG2GHMehUuuKKhOPDbc+kER1mVLJImm1h
         lU5qwDH2CWjOOJ961Xac9EXcQ6rm4GFPUfjTj/ZK+tdCpQsMEQPFGcrxKDegTWSmtrU8
         crZA==
X-Gm-Message-State: AOJu0YzRn97uXqgjssVQwT1pMZE3Tuq5QYc8LwysKwSNLS6apDbmOB10
	v1PX8gf99Ckb54lclwPeldrnhNLIgfkkjqDQrNFPeS9Eks2K9MzSAoP2t36a0f7v1OUC8XJsapg
	Az2GaTOC9BK5X9dFYitULwgPq3x1BXgY=
X-Gm-Gg: ASbGnctt2c+0o3RLjowhknhb7Zw0WGOY3X8Q7a4vYphgCgS+Ujjl+xuy1hpZ2wCzp0U
	PAnIJ5l7fUHlRz8rl6xGXg6zunYXQ+RphlR3jsWZvd9kVGG1jKTvbVpNwq3FtwgNxorKo8iXXCC
	EJMYSdq/H4nj5b0tTOr6L7FP2s+MSCkjrWHF3AMJEAOnqiAXr6YnPZQEQ2HxUJE+UHsOj2Tdsnz
	aA4+xE=
X-Google-Smtp-Source: AGHT+IEdOj0pKOFhGzu8gBtRzFTYOZWkbszM7Fmdw5DNtYW3ObU2NnNlfYN3QQ35XVly64iYYt24LonYJUdBbferTSA=
X-Received: by 2002:a2e:b8c2:0:b0:336:74c6:37b with SMTP id
 38308e7fff4ca-33674c6093amr32296471fa.22.1756305388609; Wed, 27 Aug 2025
 07:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
In-Reply-To: <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 27 Aug 2025 22:35:51 +0800
X-Gm-Features: Ac12FXwm2WfLl0mEmBMmQ0g2aVDQZhjEraUkxB4QSctNwOn_Ntr7pZee2ZGHLyY
Message-ID: <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A6361100014
X-Stat-Signature: tcjdzcaj1z8msazmbm9xzx6tqrqrupnh
X-Rspam-User: 
X-HE-Tag: 1756305390-425225
X-HE-Meta: U2FsdGVkX1+PQOPc83ximpeBQH0v4XKyrtjpPmkoO6IGsVJcjFLO4SHQPFeWHUJSDo+765q3kEYv6vkfVV8hYF+5nFBkBNEjSuJrDYY1mFxwJ3VnsOmwtTOAnseY9q3RHsAISHqlrau8WZr3TBQL3g+O2sEhqd53tdz+fcDnwG9mCXXHUmIcgph7qVFJCimM43huvwz9+OeClKZqJgqNfjd+rV7W1we62KUihbFTEce/FnOvyCDSzj/b37oxEzEapLUrxyXzqetR8vWp4e6hbVT7rN+UUCcmnHwtnxjkV8c2JTyRC3E2/xMKikr7Ff953IwFNaWja0aerIPouUTUB1ax9n74wLYWxaT0At+t/F1KTzuz/8lo2MPGDA79UwzJQUnAX9NkURfnEndEM5zDZCDBrDQSbBnUIxxwu7ANo23gNXKboo2/jQfhLwV/9KlIVDB5cwrNflfGv3kZGuo5apCMPzK0jBztAXaiZxmvHgf9Farqnzl5f9RBXivh+mLRyjuNuntMEYmuvAjgnwXc1+j1wFmUeST/13w2QvuP1qtCl2OhCGT7vuBVKJbdY/E+eo1JVaHh636mEScjnHg1zioWMBd9Uk6pa0cfAV4A7VRI69Sh+XPb+e1djIBfgGNe1b5rRso7+FC29wzUFPM4QOR/MKKFOGJlliSG69Pxl0meLC9c2Tom62ObeZNRcOjTrwSAYOvl5Dfh8holwmHK+ZkoQZTkn1ps3bZiPBNEJXGxi7G2O9Xo4vQDqKc2eS4em0IKtShIdl97lOi6/zADZUfTnlhIiAnqQ+BZ7Rdbw5wM1Y+MPHxNC+3TQbUkSblCGGMA0ao6KBkK9lAnRC/RdsKbUgGy2ehNIqqge1QTVZBL4v0z5FvDVjynPqB+tm/jye8GNGbJmLg9bGom86a3ANAuDqYsvFou2TTg9gVJ14kq7O/QVSB7Su5OZmaL+LJ8LWB6ub2ZnNU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 4:21=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
>
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index e9d0d2784cd5..b4d39f2a1e0a 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >                         count_vm_event(PGMAJFAULT);
> >                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
> >                 }
> > -       } else {
> > -               swap_update_readahead(folio, NULL, 0);
>
> Also this update readahead move to later might have a similar problem.
> All the bail out in the move will lose the readahead status update.
>
> The readahead deed is already done. Missing the status update seems
> incorrect.

Thanks for the detailed review.

The only change I wanted here is that swap readahead update should be
done after checking the folio still corresponds to the swap entry
triggering the swapin. That should have slight to none effect compared
to before considering the extremely tiny time window. We are only
following the convention more strictly.

In theory it might even help to reduce false updates: if the folio no
longer corresponds to the swap entry, we are hitting an unrelated
folio, doing a readahead update will either mislead vma readahead's
address hint, or could clean up the readahead flag of an unrelated
folio without actually using it. If the folio does get hit in the
future, due to the missing readahead flag, the statistic will go
wrong.

>
>
> >         }
> >
> >         if (order > folio_order(folio)) {
> > @@ -2431,6 +2429,8 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >                 error =3D -EIO;
> >                 goto failed;
> >         }
> > +       if (!skip_swapcache)
> > +               swap_update_readahead(folio, NULL, 0);
> >         folio_wait_writeback(folio);
> >         nr_pages =3D folio_nr_pages(folio);
>
>
> >
> > diff --git a/mm/swap.h b/mm/swap.h
> > index efb6d7ff9f30..bb2adbfd64a9 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -52,6 +52,29 @@ static inline pgoff_t swap_cache_index(swp_entry_t e=
ntry)
> >         return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
> >  }
> >
> > +/**
> > + * folio_contains_swap - Does this folio contain this swap entry?
> > + * @folio: The folio.
> > + * @entry: The swap entry to check against.
> > + *
> > + * Swap version of folio_contains()
> > + *
> > + * Context: The caller should have the folio locked to ensure
> > + * nothing will move it out of the swap cache.
> > + * Return: true or false.
> > + */
> > +static inline bool folio_contains_swap(struct folio *folio, swp_entry_=
t entry)
> > +{
> > +       pgoff_t offset =3D swp_offset(entry);
> > +
> > +       VM_WARN_ON_ONCE(!folio_test_locked(folio));
> > +       if (unlikely(!folio_test_swapcache(folio)))
> > +               return false;
> > +       if (unlikely(swp_type(entry) !=3D swp_type(folio->swap)))
> > +               return false;
> > +       return offset - swp_offset(folio->swap) < folio_nr_pages(folio)=
;
> > +}
> > +
> >  void show_swap_cache_info(void);
> >  void *get_shadow_from_swap_cache(swp_entry_t entry);
> >  int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> > @@ -144,6 +167,11 @@ static inline pgoff_t swap_cache_index(swp_entry_t=
 entry)
> >         return 0;
> >  }
> >
> > +static inline bool folio_contains_swap(struct folio *folio, swp_entry_=
t entry)
> > +{
> > +       return false;
> > +}
> > +
> >  static inline void show_swap_cache_info(void)
> >  {
> >  }
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index ff9eb761a103..be0d96494dc1 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -70,10 +70,12 @@ void show_swap_cache_info(void)
> >  }
> >
> >  /*
> > - * Lookup a swap entry in the swap cache. A found folio will be return=
ed
> > - * unlocked and with its refcount incremented.
> > + * swap_cache_get_folio - Lookup a swap entry in the swap cache.
> >   *
> > - * Caller must lock the swap device or hold a reference to keep it val=
id.
> > + * A found folio will be returned unlocked and with its refcount incre=
ased.
> > + *
> > + * Context: Caller must ensure @entry is valid and pin the swap device=
, also
> Is the "pin" the same as  "lock the swap device or hold a reference"?
> Not sure why you changed that comment to "pin".

Yes it's the same thing. We don't lock the device though, the device
can be pinned by the refcounf (get_swap_device) or locking anything
that is referencing the device (locking PTL the a PTE that contains an
swap entry pointing to the device, or locking a swap cache folio of a
swap entry that points to the device). So I juse used the word "pin".
I added some comments in mm/swap.h in later commits about what the
"pin" means.

>
> It seems to me that you want to add the comment for the return value chec=
k.
> Is that it?

Right, the caller has to check the folio before use, so I'm trying to
document this convention.

> > + * check the returned folio after locking it (e.g. folio_swap_contains=
).
> >   */
> >  struct folio *swap_cache_get_folio(swp_entry_t entry)
> >  {
> > @@ -338,7 +340,10 @@ struct folio *__read_swap_cache_async(swp_entry_t =
entry, gfp_t gfp_mask,
> >         for (;;) {
> >                 int err;
> >
> > -               /* Check the swap cache in case the folio is already th=
ere */
> > +               /*
> > +                * Check the swap cache first, if a cached folio is fou=
nd,
> > +                * return it unlocked. The caller will lock and check i=
t.
> > +                */
> >                 folio =3D swap_cache_get_folio(entry);
> >                 if (folio)
> >                         goto got_folio;
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 4b8ab2cb49ca..12f2580ebe8d 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -240,12 +240,12 @@ static int __try_to_reclaim_swap(struct swap_info=
_struct *si,
> >          * Offset could point to the middle of a large folio, or folio
> >          * may no longer point to the expected offset before it's locke=
d.
> >          */
> > -       entry =3D folio->swap;
> > -       if (offset < swp_offset(entry) || offset >=3D swp_offset(entry)=
 + nr_pages) {
> > +       if (!folio_contains_swap(folio, entry)) {
> >                 folio_unlock(folio);
> >                 folio_put(folio);
> >                 goto again;
> >         }
> > +       entry =3D folio->swap;
>
> Can you also check this as well? The "goto again" will have entries
> not assigned compared to previously.
> Too late for me to think straight now if that will cause a problem.

Oh, thanks for pointing this part out. This patch is correct, it's the
original behaviour that is not correct. If the folio is no longer
valid (the if check here failed), changing the `entry` value before
could lead to a wrong look in the next attempt with `goto again`. That
could lead to reclaim of an unrelated folio. It's a trivial issue
though, only might marginally slow down the performance. Maybe I
should make a seperate patch to fix this issue first in case anyone
wants to backport it.

>
> To be continued.
>
> Chris
>

