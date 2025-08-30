Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E89FCA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 17:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E60A6B000D; Sat, 30 Aug 2025 13:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE256B0010; Sat, 30 Aug 2025 13:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB366B0011; Sat, 30 Aug 2025 13:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 524C06B000D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 13:17:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C930E1A020D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:17:35 +0000 (UTC)
X-FDA: 83834080470.01.72044A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BF4AFA000A
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:17:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W9bHNT9d;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756574254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7hQw7nHFqj3xRUndBpg3KtR0VRxjI61BBFA/dqPbxI=;
	b=Zks8eTbSsomfP0fWjQqqUXQNDQwOsQj5qXNzN3m3k3iqXS31hZ2LI5Yv51ZDcLlUr2I0d6
	KCA/C2XgcsN9huzsifg6W34UO9MawsBvaDGStEUV5aWju2khRc4/jaKuw4fjuEMTs2U+QW
	UJeHx9FVIXbtBuUZX/z7hr1jsOq+mfg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W9bHNT9d;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756574254; a=rsa-sha256;
	cv=none;
	b=CwXM0Y2+UJU413xjNzfot17NBTZkg1sbYmBuHgpTxlN0O9xH//5Jw/nI4QWpGJfkXNGBN/
	S9Yo9OD1/h0hsWk7ns9DNzxWsAAzXF+QUu1Jr8pr9++rXz0YZIIaNNaZn6DtRllIUcScg2
	KJm7dzQNPyaTbLFZ2i6vo6upc4mmOWY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DE3F448CD
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53386C4AF09
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756574252;
	bh=zYGWS+/CkrUPWyjkFxvoPxHf5pqXrVxA/dhPwOro6RM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=W9bHNT9d1L31wYLYzZKyDzSvpdtEZe2wbduQgjHmFvGQlMW9zlcEH4t38Rbv+JHfJ
	 zNhwPQD2hyC/0sck6lXxbY69riXR07vWk0yJChbSypXGmERrAY4Y/G3sTnLOPbbG/m
	 eZ02LP2rK73QBoBfBVilvxvTDnQe/ZZzcpEBSUpQ1+S5bAXZA9omFbbaVLbztTjF6B
	 hqlNoVeXcdlKG/iMX5bpRKNLinE2Ijt/HRDvlnYLaTd4AQlv42EF6/zfBpIOti+YsQ
	 NQlPKEaS9uWx8TFIMVdWaiIUu3RYWot6sZi71BnLUcQzclyBLt8RvBjdlbwUP+rfx0
	 WpgFQsuU8WRjw==
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e96ff518c08so2513681276.1
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 10:17:32 -0700 (PDT)
X-Gm-Message-State: AOJu0YwvY0V9bPiAfeHni+nVG4VctUr/RnPXkFMCunVa9SSnZUFRp609
	RTh3PHZdLBj5jx62cmMu75NQQe/Kc9srJWfnsy3I1VwxMl8kyIJnvxHd+Bjf9+bRtUQNSomSL1x
	3nb5x5LHXxTfmVV4S/RVWbTewIJCRFIkTNMWIpBMTuA==
X-Google-Smtp-Source: AGHT+IEdAhZDP+hdNmVRZ+bpKP98LzQNJPQlctmdKbNNJ6Tvh/8OZfNSaP9u+dd1GC3FYlNNBFbdEQO21IDezBANZBw=
X-Received: by 2002:a05:690c:7105:b0:721:318f:85ba with SMTP id
 00721157ae682-72276361f59mr24403037b3.17.1756574251353; Sat, 30 Aug 2025
 10:17:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
 <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com>
 <CACePvbWnsrGxUv15R4kMpc10wsBE2Bc-rapGyBYjekrqFJgJbw@mail.gmail.com> <CAMgjq7B-Uvs7CcCdVaFjgzK6DEr47v7ULg6EbzE72OouPRFcSw@mail.gmail.com>
In-Reply-To: <CAMgjq7B-Uvs7CcCdVaFjgzK6DEr47v7ULg6EbzE72OouPRFcSw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 30 Aug 2025 10:17:20 -0700
X-Gmail-Original-Message-ID: <CACePvbUrxe1ynqKpuaaU3DfEO8UHwiFgOdVv2OWvxs2Eiz6_Wg@mail.gmail.com>
X-Gm-Features: Ac12FXzKH3DzMhXsO6Feyl6tISayrNok-qAv8F-WPT4_dkWAxnxoVPLD6zGRraw
Message-ID: <CACePvbUrxe1ynqKpuaaU3DfEO8UHwiFgOdVv2OWvxs2Eiz6_Wg@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Kairui Song <ryncsn@gmail.com>
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
X-Rspamd-Queue-Id: BF4AFA000A
X-Stat-Signature: 3buxz7uua4oik9e64kqzea4bp6ybmb5a
X-Rspam-User: 
X-HE-Tag: 1756574253-742480
X-HE-Meta: U2FsdGVkX19irumjsqQN6+RgJM0zpAzyWXoW5cGrOUZHuwnAi7dJ5Bfz0imCMrhXPPggXyPnwC2BvyssFFW93Ql9eD+Yv3nkqxX3pbnKGGjgBbRCYDMdenRn4Ul+dzkORVU6tm2VsBYJrJ5zq74hr5HZbMurAg+Gg8aJQgj3+s9Rc8ZzWF+zGiy29ZtUUqJuTQXayAClG9OEDnWsMsvdUGxhkjWCiAurJd8b83GK6gKoozpecphK4Lhj4nrWbrt9LyIZNEsfNDTDWSUmeFbWsdf2unAlYHLru8NP9f/kN4+tFJGxBq9uEq8GEnJ14a+PwWiTpu9+XKyFRlz9Y1WqJhh8H0zaQVOlXTDd9dnk5FUGUdQI0MTXy4YDYO1v/bze9KskKGhasVyQbYHl2xUAUXdIdrNThoRFmB5QAihFSkrmvxz7x1pEDqBdhk12fWjLgUOXzor+yAU4sIQy8FtpZtwf1Q9/b8FIHDLKkTSDVGbQhLziGAIgNNQP9Ew9kn0Wm60fQ6anYi7ZsaWxnTjQmu27M9dwmcNJUMxcvhZTQwJ623Zf0Ryc/vOzCOozlmVJg54o6n6kZqf1gWK9i6laTQhCRrLjlo6LXiF/pUYHbcidVZN4/jKobbsvu1YZeRS6sVwcm8nUqDgUxzgKtJlGJgbIke+ctQMH5xXoTIb8oTw6OIRBhqGZmRzASC1wKj88n13jJbGpIT0GZj/+1RNeu7QfaYRD+lWx7+An9GcyentY+POpxomhz8cSbYPgCO5QrVBW2OxshSlr5Telgy+4cHtb7lzr2eycu+NL1f9DstKk4oJmiNO0cXD8jvowveIPXh0xCnA6EGb6KmlbfehJPVSDeyfeb1+bLOnCs32wMY3Y4/zc+C90wGCq6ogOBBRe/Q48ns0TA7KmlP16SuhFlki5Ds8zFDslLuhwBRgGKgrgkV2agEacSlQdQLyk8GUF5LIwxSpaYOmbsVvGKnJ
 iBE8W5On
 RmIf9JxgxmaRuY4cHYPAKZKtnJmR73Ak69CIXfqYT5TW6TRdo30DIEl1WfGa1fbYYlyKMzWI2pxQl2qjQOWnEZSaVOI9TnFYlZrn7bK8AMaaEZK7W5LRXLo7tjudtWwd7unTsf//hCZPgqpdKLWrIvlJcxA6Sw9LGx4yiq8Hsxjxlo4lqRzdGHxy5boLK1Iy9MIKcwcZIT+as9YjNFlP0MLrb2GFpk3shCc/SrO5Mjw/0Vqp8VHj/+5+09ijdjNk4BRURbZhe8UsaGNVffRDus1RIqr2JvauX6yvp83evkgqJ5zojZReRL6fJKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 8:16=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
> > So the missing readahead stats update behavior is the correct and
> > better behavior. I suggest you spit that out as a separate patch with
> > appropriate comments about it too. It is also easier to bisect the
> > commit if that kind of the subtle change which is considered safe
> > turns out causing a problem. Causing problem not happen very often but
> > it does happen before.
>
> Yes, I'm planning to split one patch out for the readahead change.

Ack.
>
> > > > >  /*
> > > > > - * Lookup a swap entry in the swap cache. A found folio will be =
returned
> > > > > - * unlocked and with its refcount incremented.
> > > > > + * swap_cache_get_folio - Lookup a swap entry in the swap cache.
> > > > >   *
> > > > > - * Caller must lock the swap device or hold a reference to keep =
it valid.
> > > > > + * A found folio will be returned unlocked and with its refcount=
 increased.
> > > > > + *
> > > > > + * Context: Caller must ensure @entry is valid and pin the swap =
device, also
> > > > Is the "pin" the same as  "lock the swap device or hold a reference=
"?
> > > > Not sure why you changed that comment to "pin".
> > >
> > > Yes it's the same thing. We don't lock the device though, the device
> > > can be pinned by the refcounf (get_swap_device) or locking anything
> > > that is referencing the device (locking PTL the a PTE that contains a=
n
> > > swap entry pointing to the device, or locking a swap cache folio of a
> > > swap entry that points to the device). So I juse used the word "pin".
> > > I added some comments in mm/swap.h in later commits about what the
> > > "pin" means.
> >
> > In that case why not reuse the previous comment keeping "lock the swap
> > device or hold a reference" instead of "pin"?
>
> I'm worried that the sentence "lock the swap device" is kind of fuzzy,
> people may misunderstand that they need to hold si->lock. Actually
> they only need to hold si->user or lock anything. It's not wrong but
> kind of overkill.

What you just told me is a lot more useful than what was previously there.
Try to incorporate that into the comments. e.g. instead of "lock the
swap device", do "lock si->user or any other lock" or something like
that.

> > > > It seems to me that you want to add the comment for the return valu=
e check.
> > > > Is that it?
> > >
> > > Right, the caller has to check the folio before use, so I'm trying to
> > > document this convention.
> >
> > Again, I recommend reducing the unnecessary impact to the code, make
> > it more obvious what you did actually change. I spend quite some time
> > there trying to figure out what you are trying to accomplish with the
> > comments.
> >
> > > > > + * check the returned folio after locking it (e.g. folio_swap_co=
ntains).
> > > > >   */
> > > > >  struct folio *swap_cache_get_folio(swp_entry_t entry)
> > > > >  {
> > > > > @@ -338,7 +340,10 @@ struct folio *__read_swap_cache_async(swp_en=
try_t entry, gfp_t gfp_mask,
> > > > >         for (;;) {
> > > > >                 int err;
> > > > >
> > > > > -               /* Check the swap cache in case the folio is alre=
ady there */
> > > > > +               /*
> > > > > +                * Check the swap cache first, if a cached folio =
is found,
> > > > > +                * return it unlocked. The caller will lock and c=
heck it.
> > > > > +                */
> > > > >                 folio =3D swap_cache_get_folio(entry);
> > > > >                 if (folio)
> > > > >                         goto got_folio;
> > > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > > index 4b8ab2cb49ca..12f2580ebe8d 100644
> > > > > --- a/mm/swapfile.c
> > > > > +++ b/mm/swapfile.c
> > > > > @@ -240,12 +240,12 @@ static int __try_to_reclaim_swap(struct swa=
p_info_struct *si,
> > > > >          * Offset could point to the middle of a large folio, or =
folio
> > > > >          * may no longer point to the expected offset before it's=
 locked.
> > > > >          */
> > > > > -       entry =3D folio->swap;
> > > > > -       if (offset < swp_offset(entry) || offset >=3D swp_offset(=
entry) + nr_pages) {
> > > > > +       if (!folio_contains_swap(folio, entry)) {
> > > > >                 folio_unlock(folio);
> > > > >                 folio_put(folio);
> > > > >                 goto again;
> > > > >         }
> > > > > +       entry =3D folio->swap;
> > > >
> > > > Can you also check this as well? The "goto again" will have entries
> > > > not assigned compared to previously.
> > > > Too late for me to think straight now if that will cause a problem.
> > >
> > > Oh, thanks for pointing this part out. This patch is correct, it's th=
e
> > > original behaviour that is not correct. If the folio is no longer
> > > valid (the if check here failed), changing the `entry` value before
> > > could lead to a wrong look in the next attempt with `goto again`. Tha=
t
> > > could lead to reclaim of an unrelated folio. It's a trivial issue
> > > though, only might marginally slow down the performance. Maybe I
> > > should make a seperate patch to fix this issue first in case anyone
> > > wants to backport it.
> >
> > Thanks for the explanation, please do split this subtle behavior
> > change out with appropriate commit messages documenting your change,
> > why it is safe and the better behavior.
> >
> > Thanks
>
> Thanks for the review, I think separating 2 patches (one for
> __try_to_reclaim_swap and one for readahead) out of this one should be
> good enough and make everyone happy, overall the code is still the
> same.

It is your call. I am happy to review them the same. It might take me
more time to reason about it and slightly delay your series merge to
mm-unstable, that is all.

Chris

