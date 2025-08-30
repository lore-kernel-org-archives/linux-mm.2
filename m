Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F37CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 15:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A18F6B0005; Sat, 30 Aug 2025 11:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9799E6B0006; Sat, 30 Aug 2025 11:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F356B0007; Sat, 30 Aug 2025 11:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74E526B0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 11:16:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF5FFC0191
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 15:16:21 +0000 (UTC)
X-FDA: 83833774962.24.AA3BCD3
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id DD85CA0010
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 15:16:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="P6p/4fiH";
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756566980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLPiSegKxUNYAw3Zd6EdR2OPLH/om+bTuQuXULc/mjI=;
	b=XQv0rKJ6arsl0vE4qUk26zNnqehb0bn+ZUi+BTIWe/KW78PIXjDHY8CokZzSYlJ6ApTeqi
	ZUOgBAn/DdVzSiwv8Rxtdabpt7HT2qMXxF2N61tPVRnqwXQNLL3yWcAsgjaPn6wH3Zs9gz
	lA6j8jky8j8Jq8Q/V+pKtcaUedltnjQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="P6p/4fiH";
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756566980; a=rsa-sha256;
	cv=none;
	b=RPQAhjgE1d5bd0If8FRJlCbRCq8PgsxlkCU8qMkAQ+zUIPstERhHandOe9FO+WsM2WUeF2
	L0lR19MSFBzm7g+DGpRffIJ5phvZRu8QjHAmm9ZHwpDASrra1PyMKzgEhqYOb86Lm9Ak4N
	h6qSO67fl/wOofRA6MLxG8O7OlwUuxM=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b03fa5c5a89so61133366b.2
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756566978; x=1757171778; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SLPiSegKxUNYAw3Zd6EdR2OPLH/om+bTuQuXULc/mjI=;
        b=P6p/4fiHe9gQCybPqaQefRh4vUiSabE5YOpIzPZOMkTspkUqohFfutgbkejM03boUp
         p1h5yx9HLlH326ttbFIaOc7BCy0mL4PUPVzEExlL/t1p51H/9cRxLtAzZalBwjfROe8B
         j4/L0HmuaM4xhy6RyWjVpoGBQqzgpvnCMxyG0RECOHfNcSishE/tond6LpOXQpqdMqek
         IUAkzURD72N3YH6GkypZkFuOYanlK9EFV1ikx39zMsyBeTJzJK0Iev4seZG0aLwicwyZ
         16LHvY4y+r10qIr49j7g9InuyphjIumVkz4KhSqeXWcoiByOAtESU+m/MF5uLrqGiWQQ
         lGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756566978; x=1757171778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SLPiSegKxUNYAw3Zd6EdR2OPLH/om+bTuQuXULc/mjI=;
        b=pVudxlUNL6dh5+gkZo83LKLjNUCI3VLXq71QGdJwG9F/SaKcFWMCwQEm0gKRT7QTs7
         YGkwyib7FTMHo+8td6yhjnwme2BeZCB3nj3IChOm3PYxK/evUHDhX+gB9CcLUQTennH3
         V0OB0gvLKdr3zb+MCC/EKU9AR0b6VqKipAhubpCCW26e17eszs77Ms2J+N0Aobs0/S7q
         3vYGQ+X3wDJzudDTg4JKsOtXV+4NaA5XIcXn6Hs57Z3V7E5/Ya1ei40b046oIbGdUqFu
         sAI6iEcnfrHDfNjoOdA2bzrj6mI3MqyuB5uZB9JfRrG7nt/BtQjeX8dqXpEbTuFCYdEi
         OyPg==
X-Gm-Message-State: AOJu0Yz5oLxMao/E+AHSt1o90PH3C/aUdalnJIgxIHLzhT9Dial59qS/
	gCYn1iTYbpUlpJNDyCO8gwEQbVpngAnAZrmPJ01q6cUZidczUpyvqPZrAxUoInIcp84mGM+iBgi
	V95qsshsuuSCyGJ/ZJO/kFezkvl1Zz4k=
X-Gm-Gg: ASbGncu4Br1FQG6YgVckowBVC1iYevYT/GNX1mriEDjXPdNFe+R0Sn3vyyTPvq9Kk8F
	5x7Y6JbbQ6FXcVBWgufgb0kbdsTnat/MhuHOtP3WW+odU9BKe7igx22SEs10HQ7vPsJuo22gQAJ
	VFuRVVv8QCXiATT5fGsTaJMVJCgrybjI1WuKZhvM5pZ7lq7D1BcC09v0fAAfrnTuB4kLXdhO/Cr
	rfWVimgfacp8HYPHw==
X-Google-Smtp-Source: AGHT+IGN/lEWRlwT6eKifuXyyLzVLEsXneoy1dl2bE2k/h77XFsGwwJyYUKYAzuWeQ9thvjF6YVdF4tOL+9DsEHwGxg=
X-Received: by 2002:a17:907:7f90:b0:afe:d0c9:8f50 with SMTP id
 a640c23a62f3a-b01d978e50amr206066466b.44.1756566977983; Sat, 30 Aug 2025
 08:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
 <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com> <CACePvbWnsrGxUv15R4kMpc10wsBE2Bc-rapGyBYjekrqFJgJbw@mail.gmail.com>
In-Reply-To: <CACePvbWnsrGxUv15R4kMpc10wsBE2Bc-rapGyBYjekrqFJgJbw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 30 Aug 2025 23:15:41 +0800
X-Gm-Features: Ac12FXzTgmJbHwtTxDAlynGWHj0VIPcPVJqjGLFzJhXQmeTqGU9ymfK1vQbPET0
Message-ID: <CAMgjq7B-Uvs7CcCdVaFjgzK6DEr47v7ULg6EbzE72OouPRFcSw@mail.gmail.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD85CA0010
X-Stat-Signature: c3mm8mggz8c9uynxhsqmskymh5bbofap
X-Rspam-User: 
X-HE-Tag: 1756566979-625635
X-HE-Meta: U2FsdGVkX18hEQVMWGoRNj41khSkbmSMGUNt75jczCkQlrJmUeOtjSyhSI5tfZzlk8deB40DUxMfaOecQJn9lyNPrDFKO91dY40KeGV32bL0XU3BvJwPV/BWVbg3elcVBBehBPMyzgT3J8UQXf2lyhtrPPlTZ0E2wD8GPgtWSqAJlCSxtCC3+wc21oHvvbKgIhf0URQkVbfsT1anpwI4apQDKMZxl1vXRgiKYOGSLJqjKEoF7QG4W8ugZtBH9PFTQ6Hq+LHn7VjWkPgmbrYGCwSz7sC60BWWD8H9oUvqS+NphClIVa/WZUhXTeW65khyLjaCp0jMUiTcJ9U/o1wlXuW4Okkvsv3XTNvb2Yf9i4hDlneJibDhStiTAa8ojjLZfwb/JqRspViEGwtjjpAha6r0atESNUUdm9SkaprKjTNuwIb/Yt0GR53EDSUGhgliM6Hbmt0D6zF4ow+5WsZhuziw3alOoRNQX6rmdMVcybR0jLxNSZNC7DVeE3fplIWEHQzBEIFS5Ff/I+5bSQ+t16BK96C4CaYIXLnN2rTgz6+1Nzyf+jT25BYMI/phwW/Oz51yUPbGOwv0lVEMOyy0VD5q2gTy00dd8hSgBFdJztZAcVuVVIJPTRi8jmY1fWF00yUvPcdC5YOvVEANqPa1TofvGONqht27HvST0+WcMi7+SyQc2UBTTwz2dCk90yAgyH1MlZOK/MMSISqbKS2XyeDQQdfeu72V4iYa9wtt231eA0E0lEVdDAQ/maCIZhSmaob+8r4cvVPOJ1z8ZZ7BudYVsu8e573VUvxrNU1mz5Y4Ecyn/UR+wMzv16qJZTxF0KYN+7UQp+Qco43YSNl7N0Gruerw8btG8xk1cHMo8wiqPSFw1/CDnnwYMnYDFHbhrbbcuMFfz6HYNL/82uPzQd3GgeDeJEs3iXreP8lf92OeOwWr6TBZUdLw2C4U6JYQfEXIH71Hw+AZWx3pPxc
 /FPyvwvo
 6vGLhfc08Bw9qyTWM8yD9SeRIRSe6DRzafLyFcVs8ntHYjrms5gD2ae5g+bC03cEkjk0meBTSNEdJtt/XS6YhC+mMnMyYRQ4gKc+v8pkFMUxwq8Dnwt8QrzeLMrPWMEShpMZCUMxvyHxdUIpPaatPKZwDBqVhE/4vUUP1thSd0yMQtNds8iaw+yTTDLuQvFY1w8on4Jgeyx/dpFeVzASvJoMdFZTDYjfRq9gAosUVYJiOLdSSj/m8VNDedJSgFE+BN67l+/3tFBPPMRFyC1+SMrSw9VmB7XXWFd/X3i06dUw5FCf+5SwdqZaPO+PDW2ZZNob9bQUd73krQtTL+vpkvwiljAdsIQ4OHqudaSoCDGi+W9e0pGg+Qs9dtsiViG88gzTu2wHqa4pslfoje7a4FiG+jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 9:54=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Wed, Aug 27, 2025 at 7:36=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Wed, Aug 27, 2025 at 4:21=E2=80=AFPM Chris Li <chrisl@kernel.org> wr=
ote:
> > >
> > > On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.co=
m> wrote:
> > >
> > > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > > index e9d0d2784cd5..b4d39f2a1e0a 100644
> > > > --- a/mm/shmem.c
> > > > +++ b/mm/shmem.c
> > > > @@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *i=
node, pgoff_t index,
> > > >                         count_vm_event(PGMAJFAULT);
> > > >                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
> > > >                 }
> > > > -       } else {
> > > > -               swap_update_readahead(folio, NULL, 0);
> > >
> > > Also this update readahead move to later might have a similar problem=
.
> > > All the bail out in the move will lose the readahead status update.
> > >
> > > The readahead deed is already done. Missing the status update seems
> > > incorrect.
> >
> > Thanks for the detailed review.
> >
> > The only change I wanted here is that swap readahead update should be
> > done after checking the folio still corresponds to the swap entry
> > triggering the swapin. That should have slight to none effect compared
> > to before considering the extremely tiny time window. We are only
> > following the convention more strictly.
> >
> > In theory it might even help to reduce false updates: if the folio no
> > longer corresponds to the swap entry, we are hitting an unrelated
> > folio, doing a readahead update will either mislead vma readahead's
> > address hint, or could clean up the readahead flag of an unrelated
> > folio without actually using it. If the folio does get hit in the
> > future, due to the missing readahead flag, the statistic will go
> > wrong.
>
> So the missing readahead stats update behavior is the correct and
> better behavior. I suggest you spit that out as a separate patch with
> appropriate comments about it too. It is also easier to bisect the
> commit if that kind of the subtle change which is considered safe
> turns out causing a problem. Causing problem not happen very often but
> it does happen before.

Yes, I'm planning to split one patch out for the readahead change.

> > > >  /*
> > > > - * Lookup a swap entry in the swap cache. A found folio will be re=
turned
> > > > - * unlocked and with its refcount incremented.
> > > > + * swap_cache_get_folio - Lookup a swap entry in the swap cache.
> > > >   *
> > > > - * Caller must lock the swap device or hold a reference to keep it=
 valid.
> > > > + * A found folio will be returned unlocked and with its refcount i=
ncreased.
> > > > + *
> > > > + * Context: Caller must ensure @entry is valid and pin the swap de=
vice, also
> > > Is the "pin" the same as  "lock the swap device or hold a reference"?
> > > Not sure why you changed that comment to "pin".
> >
> > Yes it's the same thing. We don't lock the device though, the device
> > can be pinned by the refcounf (get_swap_device) or locking anything
> > that is referencing the device (locking PTL the a PTE that contains an
> > swap entry pointing to the device, or locking a swap cache folio of a
> > swap entry that points to the device). So I juse used the word "pin".
> > I added some comments in mm/swap.h in later commits about what the
> > "pin" means.
>
> In that case why not reuse the previous comment keeping "lock the swap
> device or hold a reference" instead of "pin"?

I'm worried that the sentence "lock the swap device" is kind of fuzzy,
people may misunderstand that they need to hold si->lock. Actually
they only need to hold si->user or lock anything. It's not wrong but
kind of overkill.

>
> > > It seems to me that you want to add the comment for the return value =
check.
> > > Is that it?
> >
> > Right, the caller has to check the folio before use, so I'm trying to
> > document this convention.
>
> Again, I recommend reducing the unnecessary impact to the code, make
> it more obvious what you did actually change. I spend quite some time
> there trying to figure out what you are trying to accomplish with the
> comments.
>
> > > > + * check the returned folio after locking it (e.g. folio_swap_cont=
ains).
> > > >   */
> > > >  struct folio *swap_cache_get_folio(swp_entry_t entry)
> > > >  {
> > > > @@ -338,7 +340,10 @@ struct folio *__read_swap_cache_async(swp_entr=
y_t entry, gfp_t gfp_mask,
> > > >         for (;;) {
> > > >                 int err;
> > > >
> > > > -               /* Check the swap cache in case the folio is alread=
y there */
> > > > +               /*
> > > > +                * Check the swap cache first, if a cached folio is=
 found,
> > > > +                * return it unlocked. The caller will lock and che=
ck it.
> > > > +                */
> > > >                 folio =3D swap_cache_get_folio(entry);
> > > >                 if (folio)
> > > >                         goto got_folio;
> > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > index 4b8ab2cb49ca..12f2580ebe8d 100644
> > > > --- a/mm/swapfile.c
> > > > +++ b/mm/swapfile.c
> > > > @@ -240,12 +240,12 @@ static int __try_to_reclaim_swap(struct swap_=
info_struct *si,
> > > >          * Offset could point to the middle of a large folio, or fo=
lio
> > > >          * may no longer point to the expected offset before it's l=
ocked.
> > > >          */
> > > > -       entry =3D folio->swap;
> > > > -       if (offset < swp_offset(entry) || offset >=3D swp_offset(en=
try) + nr_pages) {
> > > > +       if (!folio_contains_swap(folio, entry)) {
> > > >                 folio_unlock(folio);
> > > >                 folio_put(folio);
> > > >                 goto again;
> > > >         }
> > > > +       entry =3D folio->swap;
> > >
> > > Can you also check this as well? The "goto again" will have entries
> > > not assigned compared to previously.
> > > Too late for me to think straight now if that will cause a problem.
> >
> > Oh, thanks for pointing this part out. This patch is correct, it's the
> > original behaviour that is not correct. If the folio is no longer
> > valid (the if check here failed), changing the `entry` value before
> > could lead to a wrong look in the next attempt with `goto again`. That
> > could lead to reclaim of an unrelated folio. It's a trivial issue
> > though, only might marginally slow down the performance. Maybe I
> > should make a seperate patch to fix this issue first in case anyone
> > wants to backport it.
>
> Thanks for the explanation, please do split this subtle behavior
> change out with appropriate commit messages documenting your change,
> why it is safe and the better behavior.
>
> Thanks

Thanks for the review, I think separating 2 patches (one for
__try_to_reclaim_swap and one for readahead) out of this one should be
good enough and make everyone happy, overall the code is still the
same.

>
> Chris

