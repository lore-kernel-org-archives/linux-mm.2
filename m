Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF639CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6B96B00B5; Thu, 20 Nov 2025 10:33:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286FF6B00B7; Thu, 20 Nov 2025 10:33:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176EF6B00B9; Thu, 20 Nov 2025 10:33:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03C266B00B5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:33:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9ACA11DF61F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:33:18 +0000 (UTC)
X-FDA: 84131379276.10.929E977
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id AA61F4001A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:33:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S5BnA7FO;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDYWvzV00war0PaG8iXR9EC5P7ybowhtaV/Mule0Tpk=;
	b=LCHW/2RauutA5vKsHXO0pmUXYz5LkLlkC0NuzcWAiozq5d6OIwcrvEQGYlJPR+HV+rFYyP
	/Ce9M42y/JuS04gWgsr5NWpqmJwBiJltXZhwqCi63N8JXRNbbX0PfFavOq7xZnESyWZBsW
	Bwd5r1JMg3U4wIddTgmex4gwAf8od9U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652796; a=rsa-sha256;
	cv=none;
	b=lGj4uN+xlgAYzmlCotMwZUtpLXnYAI05TGIvew2R3O7FJSqH0oxfTGe7vWeDvs5Sd5up28
	Qg9a8fvoxkRMurQ4ITgL9n+suqZNxD74DpIrhhDvQu1HdR7kx/XqlSaMNQ4qnSZcDQZn3G
	80QuDwoDb4ExESYG2+khARjWd2ph7d4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S5BnA7FO;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso942986a12.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763652795; x=1764257595; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDYWvzV00war0PaG8iXR9EC5P7ybowhtaV/Mule0Tpk=;
        b=S5BnA7FO9hk6cTlSQXmpoBr9GtyRJwTS2wiPlcLMu2grC4506xNGke5fOCQKyXoLiZ
         AtK65hbLIbcRnXSVy8Xc3Inhd7OBbWprBQCVj9CVTfFHmAj5nZZD/IvY+NSyT5zBR0b+
         b53WrurKHcV0BREgaYQJLxUiF/En2oU4uOFlkOtWWjGKjQhbpxRO4d41LsWNyNn/Rknl
         zpu5V3MwksF+aKCwESJVYxI0I393fiDIYK9FbOj7Gw17wmdGCsfqM1cz/KlAnM1YkCmQ
         sWR05/8VWLn92O33c6Ze27mKIEwe+voeAmFJV8+USzbVXCKfcaDlFlnw3Lg9h+ZnxANA
         tctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652795; x=1764257595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lDYWvzV00war0PaG8iXR9EC5P7ybowhtaV/Mule0Tpk=;
        b=gdFnTQEkwEDdkc8tauRwrfZUDn3Yk87BHAtI2OVN8e1LRMcZ2JpQwt7J1ZYQQ0ut5w
         0CSzkaClBZg6aIusnP5RGUP5q9Bxwnk4u3r2LMkHwMRMuvpbZnVxG03Hf0yIHPD8Ur7E
         CakJS3InRWWT2Kiwdd1Yb0QTbaqe5ioeKEhMn7KiMX12ctnzuFXZmX3KJjOR3bDY6zc+
         XGqqZwHMCxpT4TsPLZO4l3KQZAVMajjOzZpH4CowLSDK5X6i5ipfbXf8ZZ85hVQJrOd4
         WtX4WfteScXSHoPs3izhl541qX9WVvuCGvYyq22s5cKpHcG7LNfgJwprdSJztVbHEJM9
         qVBA==
X-Gm-Message-State: AOJu0YxhTNVk1R73qf2afx6QwyPMxj7PxdFazjovCHOERbcgGsGf1vNq
	NnEwgd7hXUhEeb3HB62U9artj7fcU7nqoaLuSlvB2PuwbYf+IdousSJ5qSv5Y5FSGcU7atkJ4Ub
	ogheu6V8gj9LkUFTgsJ53Jv5kqFv2rOQ=
X-Gm-Gg: ASbGnctl/wIN2RHKXVbAZo4IjmyizCGJjm54zl5DqGg5kPOBfxzsz8vQZ7Bdo6MIAi/
	stJoGPlI7yX9xroWWi0015NlIPICN1yUkkSwFJnLPwypZQpjYE29lpntHuxdD3Hh1VtNsl+AAsV
	R2fkp4AwG/f+7rgdAAsnWHCTaYDafLav651452RhhL9cq6hwgTjQqDPc8EZ/tSMZOqrDzS0joYH
	Z/lesDcJtIsiBsy/Sfk5PbKBjO4Q9KQdgprPcgt2PL7pcsfgI6hCwa9HsIkK4TDss80OTFl1nmK
	Wdg5k9aJjSC/TgzRHzHu6SANi+RBOHw=
X-Google-Smtp-Source: AGHT+IGalPEqSt5aEJqWgWpdGvkPdtBO/Z+NyWAgvLtLH5FfiPrf8NoCtColJJLUTMAQQPTzFSce/o360XEGIps+8Ts=
X-Received: by 2002:a05:6402:1454:b0:643:4e9c:d165 with SMTP id
 4fb4d7f45d1cf-6453965384cmr2831419a12.5.1763652795015; Thu, 20 Nov 2025
 07:33:15 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-10-37730e6ea6d5@tencent.com> <aR65k5Xxl28MvMcf@yjaykim-PowerEdge-T330>
In-Reply-To: <aR65k5Xxl28MvMcf@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Nov 2025 23:32:37 +0800
X-Gm-Features: AWmQ_bkAxXmKncGUVav5WnvWHw5-ZVR6S13_zc6f-YdEmo_U7b_i2-MtTZ7_py8
Message-ID: <CAMgjq7BREEfVxET=xDU32=K4j_qps1ccmozvw3_X3CnVqHxFKw@mail.gmail.com>
Subject: Re: [PATCH v2 10/19] mm, swap: consolidate cluster reclaim and check logic
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: AA61F4001A
X-Stat-Signature: ttdzgt3wxbqyisp1asar1qrdbd11rsxp
X-HE-Tag: 1763652796-247063
X-HE-Meta: U2FsdGVkX1/mzu/YlUG6fDKvKyFcmtgswvsPQ4fIl1tcQ00OpeCVQ2TM2B3kdMkHDlkkNPY9Yi2WaH2u3EoAXGTJG5BN+YdJKlyixqMRB+RPFR1MFWLQGK8/tTvxPNl253yWSJ6YLlKDm/Le8dLxIdkIbYEBgijW3uFVR0cVlXpvr/FVqGwZwpsOw4CPC4OvPZ5PldpPRzceb83QRnrSy46AUI0NHOvPYShgwRPafz7BOmDGLuk00tekwq6x4XoN3K5e3KoAgOILUPnk/qhaBaMQ8a4Onf1x9AmONAmfVCZB6UFJhLD+IerpXaWeB5UxmPa4Fefuu40Glhx+IDZiUST9ud9+ARwWiRnhFUDHrE//Cradjy1LD0VJew3kgbrRFlUvqM4vtyDT9SsoufmT/BpZw3JHkhzg+CEXzIXYfFxY+tfgycLSyn6XsEwj0f/2FhMocuznDsp+SCTGVFnaR+mZ7waWaYuCexuYKB7CjgWu5uAbX2BFkxE07d37Kp4qz5B1dzm96p0UQuNMCkwxJ/QgSvOfS0T/RKA4mTy6SbXuH0HKQrcXGpOTAYq/OiFCEJ8IUmnFPZCc1lm+USaczRLghpkjSCyIOzl2OwIkS2I02qIWnXKCbyZnsFRLF5KnZ4couCsszyxT27Gwg0vtb6V2rz4qczrAsjJoOAn0ZKOK2fUbL2u07oGSr+j7nHiGye+vhG2jy5s0sn5GytmhM+jrImzub01DsJq6nuTuIDdG03fy1xBNhJkpBHIHL6+rD3uNG20HYPZREVDPKHcJ4bIGlXuEvAkHpzusa1n9dWgRvSO+mF5LneyWKIfM5ViPGvZla/UB5Ml9zO+jOwyuOlFwUODvwYMYd68sV7Xc8Vdpq8wMN3ffp6sz2G16Pml1x+JaYaSAS0KNnL8cqH7KLnOPkLNsFogQOA7SVIU1PfgEaV1/FHpsEEnDSLM/2G9Ixjw/J7O/KK1SHOfnNio
 eoCZeYyB
 C47FjB4IbTdwAxYeHnu6/vs1/jqT1cY4omJuk2T/iTQWIeKYpOOQQYCPVcFHNK5A4vMRc7d/u4jlmq8UTWpFBXPJePu1V0KC+HHO4sXTAEGvNmbJiGL8mSihnvIzuzPGT2Bx/AbrXQRByAtdFy9KiyfvSognfZk8E3cFaTrawuXyN9FoVMBDbes7W1j8iust79yO8YWmPREhXUzM88ZVWH1lN8wjowckqj04xb0Zd7UzquDMbV+HxEFGKEd0vSHzRAT9s6nAb6E1kchyk38z3HcqmWmTYN8MDE+aGGBn5/UoOF+p0YB28zQRgRnYGs9ts0KHfnK0ZtmoeK9eJuPR2ViQGFPoORB6/jdVrUh1pr0Egm92wNZGBGuupA7ly31S+L/tj89a8GDyNfkytblP2wvZtaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 2:47=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Mon, Nov 17, 2025 at 02:11:51AM +0800, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Swap cluster cache reclaim requires releasing the lock, so some extra
> > checks are needed after the reclaim. To prepare for checking swap cache
> > using the swap table directly, consolidate the swap cluster reclaim and
> > check the logic.
> >
> > Also, adjust it very slightly. By moving the cluster empty and usable
> > check into the reclaim helper, it will avoid a redundant scan of the
> > slots if the cluster is empty.
> >
> > And always scan the whole region during reclaim, don't skip slots
> > covered by a reclaimed folio. Because the reclaim is lockless, it's
> > possible that new cache lands at any time. And for allocation, we want
> > all caches to be reclaimed to avoid fragmentation. And besides, if the
> > scan offset is not aligned with the size of the reclaimed folio, we are
> > skipping some existing caches.
> >
> > There should be no observable behavior change, which might slightly
> > improve the fragmentation issue or performance.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swapfile.c | 45 +++++++++++++++++++++++----------------------
> >  1 file changed, 23 insertions(+), 22 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index d2e60734ce8f..d57e83a4d0a7 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -778,42 +778,50 @@ static int swap_cluster_setup_bad_slot(struct swa=
p_cluster_info *cluster_info,
> >       return 0;
> >  }
> >
> > -static bool cluster_reclaim_range(struct swap_info_struct *si,
> > -                               struct swap_cluster_info *ci,
> > -                               unsigned long start, unsigned long end)
> > +static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
> > +                                       struct swap_cluster_info *ci,
> > +                                       unsigned long start, unsigned i=
nt order)
> >  {
> > +     unsigned int nr_pages =3D 1 << order;
> > +     unsigned long offset =3D start, end =3D start + nr_pages;
> >       unsigned char *map =3D si->swap_map;
> > -     unsigned long offset =3D start;
> >       int nr_reclaim;
> >
> >       spin_unlock(&ci->lock);
> >       do {
> >               switch (READ_ONCE(map[offset])) {
> >               case 0:
> > -                     offset++;
> >                       break;
> >               case SWAP_HAS_CACHE:
> >                       nr_reclaim =3D __try_to_reclaim_swap(si, offset, =
TTRS_ANYWAY);
> > -                     if (nr_reclaim > 0)
> > -                             offset +=3D nr_reclaim;
> > -                     else
> > +                     if (nr_reclaim < 0)
> >                               goto out;
> >                       break;
> >               default:
> >                       goto out;
> >               }
> > -     } while (offset < end);
> > +     } while (++offset < end);
> >  out:
> >       spin_lock(&ci->lock);
> > +
> > +     /*
> > +      * We just dropped ci->lock so cluster could be used by another
> > +      * order or got freed, check if it's still usable or empty.
> > +      */
> > +     if (!cluster_is_usable(ci, order))
> > +             return SWAP_ENTRY_INVALID;
> > +     if (cluster_is_empty(ci))
> > +             return cluster_offset(si, ci);
> > +
> >       /*
> >        * Recheck the range no matter reclaim succeeded or not, the slot
> >        * could have been be freed while we are not holding the lock.
> >        */
> >       for (offset =3D start; offset < end; offset++)
> >               if (READ_ONCE(map[offset]))
> > -                     return false;
> > +                     return SWAP_ENTRY_INVALID;
> >
> > -     return true;
> > +     return start;
> >  }
> >
> >  static bool cluster_scan_range(struct swap_info_struct *si,
> > @@ -901,7 +909,7 @@ static unsigned int alloc_swap_scan_cluster(struct =
swap_info_struct *si,
> >       unsigned long start =3D ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
> >       unsigned long end =3D min(start + SWAPFILE_CLUSTER, si->max);
>
> The Original code. I'm wondering if there's an off-by-one error here. Loo=
king at the code
> below, it seems the design allows the end offset to go through the
> logic as well. Shouldn't it be 'start + SWAPFILE_CLUSTER - 1' and
> 'si->max - 1'?

You mean the `offset <=3D end` check below? That's fine because the for
loops starts with `end -=3D nr_pages`.

>
> >       unsigned int nr_pages =3D 1 << order;
> > -     bool need_reclaim, ret;
> > +     bool need_reclaim;
> >
> >       lockdep_assert_held(&ci->lock);
> >
> > @@ -913,20 +921,13 @@ static unsigned int alloc_swap_scan_cluster(struc=
t swap_info_struct *si,
> >               if (!cluster_scan_range(si, ci, offset, nr_pages, &need_r=
eclaim))
> >                       continue;
> >               if (need_reclaim) {
> > -                     ret =3D cluster_reclaim_range(si, ci, offset, off=
set + nr_pages);
> > -                     /*
> > -                      * Reclaim drops ci->lock and cluster could be us=
ed
> > -                      * by another order. Not checking flag as off-lis=
t
> > -                      * cluster has no flag set, and change of list
> > -                      * won't cause fragmentation.
> > -                      */
> > +                     found =3D cluster_reclaim_range(si, ci, offset, o=
rder);
> >                       if (!cluster_is_usable(ci, order))
> >                               goto out;
>
> This check resolves the issue I mentioned in my previous review.
>
> > -                     if (cluster_is_empty(ci))
> > -                             offset =3D start;
> >                       /* Reclaim failed but cluster is usable, try next=
 */
> > -                     if (!ret)
> > +                     if (!found)
> >                               continue;
> > +                     offset =3D found;
> >               }
> >               if (!cluster_alloc_range(si, ci, offset, usage, order))
> >                       break;
>
> I think the reason cluster_is_usable() is checked redundantly here is
> because cluster_reclaim_range() returns an unsigned int (offset), making
> it impossible to distinguish error values.
>
> What if we make offset an output parameter (satisfying the assumption
> that it can be changed in reclaim_range) and return an error value
> instead? This would eliminate the redundant cluster_is_usable() check
> and simplify the logic. Also, the consecutive "offset =3D found, found =
=3D
> offset" is a bit confusing, and this approach could eliminate that as
> well.
>
> What do you think?

That's a good suggestion indeed, I'll try to make the code cleaner
this way. Thanks!

