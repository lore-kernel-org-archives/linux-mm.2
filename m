Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D8C4CA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 01:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E9B6B0025; Fri, 29 Aug 2025 21:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE036B0026; Fri, 29 Aug 2025 21:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887B46B0028; Fri, 29 Aug 2025 21:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 711746B0025
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 21:54:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCE971DEDE3
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:54:08 +0000 (UTC)
X-FDA: 83831753376.05.75B4A21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1162440008
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:54:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QdHGQGoo;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756518847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2W4dyk8J8cW1pwRTTdWwzYSoSq8kL8Ozw3jUcEu+SuU=;
	b=UaCzDAayi3r+RsbbhwtRwH21ed/RZK0cND7YLmRQVmZsiA+LhCreQLExz7OXjLU/aG9yYc
	hqqXIGSNDGolS8caDJ5+z+yS4peDkL4SayE2jTe6rU/UJW1uQqwoQUrxxlzymU/WIFDiDc
	tuszGsdp0xFV3cEBx1cO32xwlC/9usU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756518847; a=rsa-sha256;
	cv=none;
	b=ouCSBUQTqVcBxrBy6JQ/LNnMhLkD3em2XHSnrHOWptPOPeZNe7XULf+hpmOqzcRE8hbNIm
	ZWvJNHhxHL0gXgTnkmcfWSOzFexjRkIaZuSZtStr0TZsLKXkEQVJR9ANwXpyQPbvUXcaXU
	NIi38BQcCQWePtyZNapgMoWIDEbeq+A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QdHGQGoo;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0A75455CB
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E089C4CEF9
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756518845;
	bh=ege+hdo/NEDl5bVu2HF6qh6wJNLzx4jRvmLsvzMn2x0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QdHGQGoo83RrwtkK94aa+YmoalGy22EoLSWJRK2acQzpAKmHAPSkEETJyvnBO7rW6
	 poVhTZ8Wr4W6FhBD7A5pKPnatWLHSnbUdr4T9TGRc4iSIiM2dizpFdtH0UFF1U2EbB
	 DRNOk8yaVKZZ4geziUQVLEwUutsBCdmUElGZq6F0mGAWGf1OexB8cemIDG+ZcaL/iq
	 rDi3oHRXgqMkz1ROzE1zvcug5LGADDgDauSpssu35NvczW7H6LhxISBp/F1U8E3IU1
	 HzSpZj2LHVraPOJ6vlyXz3Pqyhy/oREdnbP+Ddo10DB9TumzuNc/wBMmB5Lnn7ELk9
	 R7VXO9VHAwPEg==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d603b674aso18358137b3.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:54:05 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx8ZwYkojfyZVpkYSVk0/B/H6e6TOzFcUHCH7lO1j7sxSWMOkaz
	i56VHQCrhxfzpIwJbxPt8R4a9BiASLStNeJ9DXpY/z0qjw8tnsHxN916j/z+XE1YFmhitivmUyr
	5gwz8enpKKQCBo7O2lFxT5RUgX4U639RbK1JO17crgw==
X-Google-Smtp-Source: AGHT+IGBZ1xL6FdwTO9yXaxuU6Nt58z3MWQ9+wnEUCEIX9zmetn0MTjllloph7ia1dbpPu0gIUEf8L0hQ0/Kiuu3Lrs=
X-Received: by 2002:a05:690c:358a:b0:71f:9a36:d33c with SMTP id
 00721157ae682-7227656413cmr6269987b3.46.1756518844763; Fri, 29 Aug 2025
 18:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com> <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com>
In-Reply-To: <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 18:53:53 -0700
X-Gmail-Original-Message-ID: <CACePvbWnsrGxUv15R4kMpc10wsBE2Bc-rapGyBYjekrqFJgJbw@mail.gmail.com>
X-Gm-Features: Ac12FXzjoYWbR33a8qw8WcX8eQ87VF6jdqd98ld297qjjjUhlL6PIubCngMCzzs
Message-ID: <CACePvbWnsrGxUv15R4kMpc10wsBE2Bc-rapGyBYjekrqFJgJbw@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1162440008
X-Stat-Signature: ps473s1r4pwytoe797i9wzdnh1y3etrq
X-Rspam-User: 
X-HE-Tag: 1756518846-811562
X-HE-Meta: U2FsdGVkX19dMb60RISK864/7LBw5f17lyAoxj+GXdBVcrSR8c3RlZHPPH9CWWfdF9yu/Xy8u4Ltrhi4VMlJxo3Y7JhiLd+Ae60TYxkC5hiFM6LRSspl9EDYwqvBzPDhfuq9U9VZ/AtbIa+Fz32mU54yq+Jq+53tJRnCmsK/cM5byRrSnyskB+W1pNSDzLVDuT7BAM7NQzaMBKux6GlLHORI+TuffswUDxmBP6A++2s6uXJ4XnsYRhoVaFtp8D2WCiEBGJAt14yQoVno5iCEOZyaDgByX9DJz7Y7/L1GaWgKLzeEsSsv8zWOhTuZVA/uNoey32RTicpmZPHDJybsLFl7Hibicpmh8pmeSsRXieaYkor7YiCgYw28DpW3TDMQB3UZPQiPeZsINcnrqf5+g2tL80ugRfGcsB9Ujr3aUiBOBiCTxW2G1yr2YV03gKKkyadSAxmUc6Y/xdFOpi9p6D76zrB4w/UQv/fbrmIOU2QKfcMs7VCJ1Zs3BLUx4WBgfPIz4RJCfwAGLH+qHDUyShesBq2jiq5MfiAx+HQ8ZUn2lY0LagXKzObzFXpqu5YoDuUeZClrP0ocXztYKp9rUwzeUMWZpxXfLiVAMT3LurIofKP6DYG+CxcUYikS1HyuHt3qSKGc8HFDFcyV8m81wrsxxj6pEuycNw5YNVQ1C8ABx4Aks17AuIbcxD6Iw4LWBzeOT2X4SccQ7Ri36w6kWVlrxxoU8vHPxLlvhKyBPUGi0Hf2T5UAoNJhNrGpxwn73VqWCrEiaaoDNRuaTM182GReej8uBQ5QDMB+biJz51tVw8b9MSCK3PsDZixW/c5Txys/Es22Hkeq7H7l66yqv874h5eKEJbY8+ZXPd0DrAQeMsybDN+4+rDcWbv2EKG6G42oi10yQk69GjsvZSexYLfFUm9HklX920l/Jks9le+eeY8qw5K56qYAG6CaySa02CBQnFpVrixtEthUS4y
 /+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 7:36=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Aug 27, 2025 at 4:21=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> >
> > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > index e9d0d2784cd5..b4d39f2a1e0a 100644
> > > --- a/mm/shmem.c
> > > +++ b/mm/shmem.c
> > > @@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *ino=
de, pgoff_t index,
> > >                         count_vm_event(PGMAJFAULT);
> > >                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
> > >                 }
> > > -       } else {
> > > -               swap_update_readahead(folio, NULL, 0);
> >
> > Also this update readahead move to later might have a similar problem.
> > All the bail out in the move will lose the readahead status update.
> >
> > The readahead deed is already done. Missing the status update seems
> > incorrect.
>
> Thanks for the detailed review.
>
> The only change I wanted here is that swap readahead update should be
> done after checking the folio still corresponds to the swap entry
> triggering the swapin. That should have slight to none effect compared
> to before considering the extremely tiny time window. We are only
> following the convention more strictly.
>
> In theory it might even help to reduce false updates: if the folio no
> longer corresponds to the swap entry, we are hitting an unrelated
> folio, doing a readahead update will either mislead vma readahead's
> address hint, or could clean up the readahead flag of an unrelated
> folio without actually using it. If the folio does get hit in the
> future, due to the missing readahead flag, the statistic will go
> wrong.

So the missing readahead stats update behavior is the correct and
better behavior. I suggest you spit that out as a separate patch with
appropriate comments about it too. It is also easier to bisect the
commit if that kind of the subtle change which is considered safe
turns out causing a problem. Causing problem not happen very often but
it does happen before.

> > >  /*
> > > - * Lookup a swap entry in the swap cache. A found folio will be retu=
rned
> > > - * unlocked and with its refcount incremented.
> > > + * swap_cache_get_folio - Lookup a swap entry in the swap cache.
> > >   *
> > > - * Caller must lock the swap device or hold a reference to keep it v=
alid.
> > > + * A found folio will be returned unlocked and with its refcount inc=
reased.
> > > + *
> > > + * Context: Caller must ensure @entry is valid and pin the swap devi=
ce, also
> > Is the "pin" the same as  "lock the swap device or hold a reference"?
> > Not sure why you changed that comment to "pin".
>
> Yes it's the same thing. We don't lock the device though, the device
> can be pinned by the refcounf (get_swap_device) or locking anything
> that is referencing the device (locking PTL the a PTE that contains an
> swap entry pointing to the device, or locking a swap cache folio of a
> swap entry that points to the device). So I juse used the word "pin".
> I added some comments in mm/swap.h in later commits about what the
> "pin" means.

In that case why not reuse the previous comment keeping "lock the swap
device or hold a reference" instead of "pin"?

> > It seems to me that you want to add the comment for the return value ch=
eck.
> > Is that it?
>
> Right, the caller has to check the folio before use, so I'm trying to
> document this convention.

Again, I recommend reducing the unnecessary impact to the code, make
it more obvious what you did actually change. I spend quite some time
there trying to figure out what you are trying to accomplish with the
comments.

> > > + * check the returned folio after locking it (e.g. folio_swap_contai=
ns).
> > >   */
> > >  struct folio *swap_cache_get_folio(swp_entry_t entry)
> > >  {
> > > @@ -338,7 +340,10 @@ struct folio *__read_swap_cache_async(swp_entry_=
t entry, gfp_t gfp_mask,
> > >         for (;;) {
> > >                 int err;
> > >
> > > -               /* Check the swap cache in case the folio is already =
there */
> > > +               /*
> > > +                * Check the swap cache first, if a cached folio is f=
ound,
> > > +                * return it unlocked. The caller will lock and check=
 it.
> > > +                */
> > >                 folio =3D swap_cache_get_folio(entry);
> > >                 if (folio)
> > >                         goto got_folio;
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index 4b8ab2cb49ca..12f2580ebe8d 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -240,12 +240,12 @@ static int __try_to_reclaim_swap(struct swap_in=
fo_struct *si,
> > >          * Offset could point to the middle of a large folio, or foli=
o
> > >          * may no longer point to the expected offset before it's loc=
ked.
> > >          */
> > > -       entry =3D folio->swap;
> > > -       if (offset < swp_offset(entry) || offset >=3D swp_offset(entr=
y) + nr_pages) {
> > > +       if (!folio_contains_swap(folio, entry)) {
> > >                 folio_unlock(folio);
> > >                 folio_put(folio);
> > >                 goto again;
> > >         }
> > > +       entry =3D folio->swap;
> >
> > Can you also check this as well? The "goto again" will have entries
> > not assigned compared to previously.
> > Too late for me to think straight now if that will cause a problem.
>
> Oh, thanks for pointing this part out. This patch is correct, it's the
> original behaviour that is not correct. If the folio is no longer
> valid (the if check here failed), changing the `entry` value before
> could lead to a wrong look in the next attempt with `goto again`. That
> could lead to reclaim of an unrelated folio. It's a trivial issue
> though, only might marginally slow down the performance. Maybe I
> should make a seperate patch to fix this issue first in case anyone
> wants to backport it.

Thanks for the explanation, please do split this subtle behavior
change out with appropriate commit messages documenting your change,
why it is safe and the better behavior.

Thanks

Chris

