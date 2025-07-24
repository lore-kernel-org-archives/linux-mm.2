Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F02CC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E988E00AA; Thu, 24 Jul 2025 14:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB948E007C; Thu, 24 Jul 2025 14:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393548E00AA; Thu, 24 Jul 2025 14:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 252E58E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:17:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F50E1604AD
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:17:34 +0000 (UTC)
X-FDA: 83699966028.05.04C9B4B
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 725F6C000C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:17:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Sjm/CJm8";
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753381052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mstO5bBA8SlBMK0W+sc+fnBo7qspVaUrHWJekQ5o+x8=;
	b=CrM5F+GAqIalXQeD6xouxzU9sNhW0BX7bQUJZTocqi4ZBqbEjeZgxRhZuuQmL6ezb1P8Vi
	zjssUFusCkMHDBvCxObdV4EONQfC2yXi8kz45jem5yGdZ92YcuJi7WvyfnmMT4pAvnDS5g
	0XwoJ376/6mU68TtWQHmWsJW9fpaTzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753381052; a=rsa-sha256;
	cv=none;
	b=OyuN9xqcA46OZn2ZPe6Q/A18wDc0d6rskv+Eluf1jGxZC/5pWmciod+0SUuUqUMME52N9R
	LNXJ73eyi2VA2XqBONw6O/b6+akWBxNygyb3DZYhxTMoV0JOak+S1DenJYdlC7r0VwBDf4
	hCcODECqfL4rDX+om0A1gf0vHQY07kI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Sjm/CJm8";
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-32b553e33e6so10274801fa.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753381050; x=1753985850; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mstO5bBA8SlBMK0W+sc+fnBo7qspVaUrHWJekQ5o+x8=;
        b=Sjm/CJm8f4QCxStlaR2AsedvZ0YkRvHMLmP0W56F8y/eJqs812HirAq1zj22457LRy
         U2f7a56fqbrteLf5+1sAs1a4A5cZNA8IS34KJoiT9+6e3aKF7B8K3CtNHCsArshxqgvT
         dEK7zCb5sxR/GJCpaXlL9FvixV7zgAPpbTC1ZLdnwQObVg1tGcWtuDnOsry0ud0LGLgm
         tU5PfTasoclz1sI0l+ANsa5rQIdHTrlc7TNR63UtUQcZgm96i9+dHafa/xcSSoggD9qu
         d+ofr0huP0UnWanuFiK+qWW3dyey3fxt1KwNKowCdlrvlY53x116YW908McE+mlxtHEF
         4Xgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753381050; x=1753985850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mstO5bBA8SlBMK0W+sc+fnBo7qspVaUrHWJekQ5o+x8=;
        b=gcy9asOd9tzghUB6D/eHM+24XTm3+alfHz/nqntTmZbALQKYn6P2WjpxMP+tcP+Fj6
         70B4iVkjqpI9KE6b64ykspAJ5BhcwUFKwNNtoxv5zZ/J4hHMuqoyIggOmud0dEkM2ThC
         YCnBDq9JKGLOknLXYy/4doZ9DsuVjtjreJ7IbpBFl73E3C9ZCXKppHJovgfISUQf+QNF
         PADkPH37fNuFDYoKtaeQfAyCPvyFle3IKBiAb7gtu3ZN8vmLWjmqe/2ZhuTHlKt08bPA
         x3PtkxHBkHlwEQmLu/tf9dgEFYKcn2SuH5aoj9PH9monIk1K5xEfCGz17+UYEMUV3zuo
         8DWg==
X-Forwarded-Encrypted: i=1; AJvYcCWJGOuEPtOZfIiLwmM50DCvqYPAKR6J6OsrI5a70gbXeiCTs3VBQ5AF7aT3/VK5byYk1ZsfmB7l9A==@kvack.org
X-Gm-Message-State: AOJu0YwBPQPoj2SlDfdbSxoAOhejKdDrnmCdRJ1De+wip0aimsLW8sfY
	jG2/VFnnhysFkB36Ugix7UTk29dZyiGRTnmgGifLjHMmVi6WFVlz/aCwNOCoxdm/6rMwukbhuU5
	HOK/lyeRY6RtyhZ5e949VASFPtxBx7T4=
X-Gm-Gg: ASbGncsYBITPMSOTuOru6X3IKhjPrkusdAyqUyup9efArx2PmHY2KvSJQpbg/aQYwIz
	07McEWel1dUSuTKqpQSuORJSZBcraHyv5BaQJ+Zixv6Bff7EcA148E9HAxAeKvEjOPNxBDj6iYS
	hZOWdl5ecuz3BVvohiLJSxNncm00k0IQP+Va1xQT4QwU2KODkeETvu1ouCxD00HOU3ypRoDxRl+
	inwNGA=
X-Google-Smtp-Source: AGHT+IF0MypcK2dGjntx3r2pyL18T1BhDfo21rUZX5OIUZyEse8hxlJDbtuCftcm3hJcCuDQ2VNQSNQn/6GmBzSuwRU=
X-Received: by 2002:a2e:a58d:0:b0:331:e667:90e5 with SMTP id
 38308e7fff4ca-331e667abd6mr7021501fa.18.1753381050141; Thu, 24 Jul 2025
 11:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250710033706.71042-1-ryncsn@gmail.com> <20250710033706.71042-2-ryncsn@gmail.com>
 <CAMgjq7A+DBw=z8RPP-P1hcCH4Mid0txfmKqgqXghoE_v7zGEoA@mail.gmail.com>
In-Reply-To: <CAMgjq7A+DBw=z8RPP-P1hcCH4Mid0txfmKqgqXghoE_v7zGEoA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 25 Jul 2025 02:16:51 +0800
X-Gm-Features: Ac12FXzqsdCRJwzfvRgVf_lgFJ6snqpfuboJ4Spb636Mjve2Z4ipOQIX7-yQ6oE
Message-ID: <CAMgjq7DfPXS4PkpGK-zem2L1gZD0dekbAyHa-CPHjf=eonoFXg@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] mm/shmem, swap: improve cached mTHP handling and
 fix potential hung
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 725F6C000C
X-Stat-Signature: wz7ma9hnao5bih97935r5ijo415em4p9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753381052-783075
X-HE-Meta: U2FsdGVkX1/RLxorwE+9y0UX0YE2ghmMF7/RjTR8u9LtfKBr5e6PJIyCEpalA3njqaYsHFBf0w2NnMXRrkTYAQ3SFXOt1vupjvZLcOhNZtlq9U9LFJcgr7FANeW3HTSP3uK9xU6JK5goUjenIgly5mFtnxit58vMrDO/pWbS64UwZ21toRZHYRUb7nLEseBunAy9SFO+/vIU9btbJVU2p7xIo5QfqyDWpfkpVUVL2wY2GbVV6Und3WLMQ1kCFjfhaqzviV0FengMQ9zepNaSB9K6LTLiKWVp7nxBtkQnPAzwfm2p89tgm+94YURTMWQg/gqI0u8HxIafw2/9V8Qs2A2Z8lUhIAGf1eBqJLgx+HNH1SNEt1RNOl6h4QdZ4r8z/uExydiCv+7j7AtzRhAeetN63w5z9B4FYPpfVuBE7VgwW1GoYZfgkrFTutAGLdgm94jrTNJSkYtEBKnJ4oAUfxcaK90YNtp/QBKxjt/quaHKdmzZ9Q+fMv0QF+9JZXyxLTUA/agu37Y7tpixwjtvZjKBS7pSPMRluGxflEbHz7nfQcyAXqXLYmXz29aHZ2j5n5h3UI8mz9k72mQmztttT0tW5H9CnovvNyHu/WkX+aGNn7Xw91NKVwLEvzdlDSQsa+kcgJJkzH/E7/uEgPr6fVMxBY8yKjhh5iCL2P6ID8yrObgns4C612Ev5CGoCWIe4Swc4baPpvy9Ebz2LOqVVYj5niLTLNzuxWBPnOiLnpNKfxi5oABjAG7V5RuYkK1HxjaSCmo2LJ8qS1DbjtxFkV+gOdO30GcQT4ULgKLe4eEBBjRgmmVnQD7Y4mJfhJYMBKFsElf3C9oppvT0S30Jbe43CteGUecM+ozyECC4oxkQSbt4RvZyQqw+W8nlqgh8wGojde5g66Sv2dDNPLvHuuWzryogrwhPCJpB1SG9h3nCVviPMT9GT0o+EbUB9UwapLuxvyRHfQQ/AcQoHed
 rWBcePQ9
 JkJovqdZ9MNhrsN3zVY0KaTwB2BfFFYe09VkiwjOcc3SnnZWh3KeSkavOFh8nXMFuhPwM2exD/BeSOPwOBdNTQQVdOGjXp0CVar2Vscag1QYCfw3ZU8ZJYUKW7Wg+zN+cBgjPHuW7LrEnb9qwc2yN78VV0saXAGuhPe9/uL4LvPG4uCo0dfYn7FupQefR92c/sxQq2c0ZA5NGw+cvzppgxgIgDoP0VQJdmTVxITDNxVpJcYGf8HF2Bz36eqJlK35X/8ty+n24etaA0XfoedG3ZHEJ6Nsi3/2xOZt1KovzqSsLRzlK68DuYQqyth2lLyxvo0zOWjGVALNEvQWQ/O4loI3+EVVXNtdDei0YXvAnvC4KFZXtdz5FjZOcYEYlyTpiVmQJInQ4AIvRozOgVEaxlaOY8qcdhqSnw8nCec01AaiTasYWk1vIXbIj/zbfJ3Igh1Yo3fSDrDWZMsPQDiPXI6f++XpjNBlEW7VU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 1:02=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Jul 10, 2025 at 11:37=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The current swap-in code assumes that, when a swap entry in shmem mappi=
ng
> > is order 0, its cached folios (if present) must be order 0 too, which
> > turns out not always correct.
> >
> > The problem is shmem_split_large_entry is called before verifying the
> > folio will eventually be swapped in, one possible race is:
> >
> >     CPU1                          CPU2
> > shmem_swapin_folio
> > /* swap in of order > 0 swap entry S1 */
> >   folio =3D swap_cache_get_folio
> >   /* folio =3D NULL */
> >   order =3D xa_get_order
> >   /* order > 0 */
> >   folio =3D shmem_swap_alloc_folio
> >   /* mTHP alloc failure, folio =3D NULL */
> >   <... Interrupted ...>
> >                                  shmem_swapin_folio
> >                                  /* S1 is swapped in */
> >                                  shmem_writeout
> >                                  /* S1 is swapped out, folio cached */
> >   shmem_split_large_entry(..., S1)
> >   /* S1 is split, but the folio covering it has order > 0 now */
> >
> > Now any following swapin of S1 will hang: `xa_get_order` returns 0, and
> > folio lookup will return a folio with order > 0.  The
> > `xa_get_order(&mapping->i_pages, index) !=3D folio_order(folio)` will a=
lways
> > return false causing swap-in to return -EEXIST.
> >
> > And this looks fragile.  So fix this up by allowing seeing a larger fol=
io
> > in swap cache, and check the whole shmem mapping range covered by the
> > swapin have the right swap value upon inserting the folio.  And drop th=
e
> > redundant tree walks before the insertion.
> >
> > This will actually improve performance, as it avoids two redundant Xarr=
ay
> > tree walks in the hot path, and the only side effect is that in the
> > failure path, shmem may redundantly reallocate a few folios causing
> > temporary slight memory pressure.
> >
> > And worth noting, it may seems the order and value check before inserti=
ng
> > might help reducing the lock contention, which is not true.  The swap
> > cache layer ensures raced swapin will either see a swap cache folio or
> > failed to do a swapin (we have SWAP_HAS_CACHE bit even if swap cache is
> > bypassed), so holding the folio lock and checking the folio flag is
> > already good enough for avoiding the lock contention.  The chance that =
a
> > folio passes the swap entry value check but the shmem mapping slot has
> > changed should be very low.
> >
> > Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  mm/shmem.c | 30 +++++++++++++++++++++---------
> >  1 file changed, 21 insertions(+), 9 deletions(-)
>
> Hi All,
>
> Just found some issue here with this patch...
>
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 334b7b4a61a0..e3c9a1365ff4 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -884,7 +884,9 @@ static int shmem_add_to_page_cache(struct folio *fo=
lio,
> >                                    pgoff_t index, void *expected, gfp_t=
 gfp)
> >  {
> >         XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio=
));
> > -       long nr =3D folio_nr_pages(folio);
> > +       unsigned long nr =3D folio_nr_pages(folio);
> > +       swp_entry_t iter, swap;
> > +       void *entry;
> >
> >         VM_BUG_ON_FOLIO(index !=3D round_down(index, nr), folio);
> >         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> > @@ -896,14 +898,24 @@ static int shmem_add_to_page_cache(struct folio *=
folio,
> >
> >         gfp &=3D GFP_RECLAIM_MASK;
> >         folio_throttle_swaprate(folio, gfp);
> > +       swap =3D iter =3D radix_to_swp_entry(expected);
> >
> >         do {
> >                 xas_lock_irq(&xas);
>
> I missed a xas_reset here, also better reset iter value too.
>
> > -               if (expected !=3D xas_find_conflict(&xas)) {
> > -                       xas_set_err(&xas, -EEXIST);
> > -                       goto unlock;
> > +               xas_for_each_conflict(&xas, entry) {
> > +                       /*
> > +                        * The range must either be empty, or filled wi=
th
> > +                        * expected swap entries. Shmem swap entries ar=
e never
> > +                        * partially freed without split of both entry =
and
> > +                        * folio, so there shouldn't be any holes.
> > +                        */
> > +                       if (!expected || entry !=3D swp_to_radix_entry(=
iter)) {
> > +                               xas_set_err(&xas, -EEXIST);
> > +                               goto unlock;
> > +                       }
> > +                       iter.val +=3D 1 << xas_get_order(&xas);
> >                 }
> > -               if (expected && xas_find_conflict(&xas)) {
> > +               if (expected && iter.val - nr !=3D swap.val) {
> >                         xas_set_err(&xas, -EEXIST);
> >                         goto unlock;
> >                 }
> > @@ -2323,7 +2335,7 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >                         error =3D -ENOMEM;
> >                         goto failed;
> >                 }
> > -       } else if (order !=3D folio_order(folio)) {
> > +       } else if (order > folio_order(folio)) {
> >                 /*
> >                  * Swap readahead may swap in order 0 folios into swapc=
ache
> >                  * asynchronously, while the shmem mapping can still st=
ores
> > @@ -2348,15 +2360,15 @@ static int shmem_swapin_folio(struct inode *ino=
de, pgoff_t index,
> >
> >                         swap =3D swp_entry(swp_type(swap), swp_offset(s=
wap) + offset);
> >                 }
> > +       } else if (order < folio_order(folio)) {
> > +               swap.val =3D round_down(swap.val, 1 << folio_order(foli=
o));
> >         }
> >
> >  alloced:
> >         /* We have to do this with folio locked to prevent races */
> >         folio_lock(folio);
> >         if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
> > -           folio->swap.val !=3D swap.val ||
> > -           !shmem_confirm_swap(mapping, index, swap) ||
> > -           xa_get_order(&mapping->i_pages, index) !=3D folio_order(fol=
io)) {
>
> And this part is incorrect. This `shmem_confirm_swap(mapping, index,
> swap) ` can't be simply omitted. Some functions below before the
> shmem_add_to_page_cache shouldn't be called on folios might have
> already been mapped by others. This shmem_confirm_swap ensures that
> won't happen.
>
> It may seem like a small change, but it leads to some minor conflicts
> in one or two following commits, the benchmark result will change too.
> So I'll have to send a V6 I think.
>
> We can remove this `shmem_confirm_swap`, but not in this series I
> think, maybe after this. Need to re-arrange some functions, with some
> clean ups for shmem_add_to_page_cache and others.
>
> > +           folio->swap.val !=3D swap.val) {
> >                 error =3D -EEXIST;
> >                 goto unlock;
> >         }
> > --
> > 2.50.0
> >
>
> In summary, I'll squash this patch into it and do a rebase of later commi=
ts:
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e3c9a1365ff4..4ca0b665b79e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -898,9 +898,11 @@ static int shmem_add_to_page_cache(struct folio *fol=
io,
>
>         gfp &=3D GFP_RECLAIM_MASK;
>         folio_throttle_swaprate(folio, gfp);
> -       swap =3D iter =3D radix_to_swp_entry(expected);
> +       swap =3D radix_to_swp_entry(expected);
>
>         do {
> +               iter =3D swap;
> +               xas_reset(&xas);

Correction: this xas_reset is not needed, the iter =3D swap is needed.

>                 xas_lock_irq(&xas);
>                 xas_for_each_conflict(&xas, entry) {
>                         /*
> @@ -2365,9 +2367,16 @@ static int shmem_swapin_folio(struct inode
> *inode, pgoff_t index,
>         }
>
>  alloced:

And it needs `nr_pages =3D folio_nr_pages(folio); index =3D
round_down(index, nr_pages);` here...

> -       /* We have to do this with folio locked to prevent races */
> +       /*
> +        * We have to do this with folio locked to prevent races.
> +        * The shmem_confirm_swap below only checks if the first swap
> +        * entry matches the folio, that's enough to ensure the folio
> +        * is not used outside of shmem, as shmem swap entrie
> +        * and swap cache folios are never partially freed.
> +        */
>         folio_lock(folio);
>         if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
> +           !shmem_confirm_swap(mapping, index, swap) ||
>             folio->swap.val !=3D swap.val) {
>                 error =3D -EEXIST;
>                 goto unlock;
>
> And I'll do some clean up afterward to get rid of this
> shmem_confirm_swap. How do you think?

