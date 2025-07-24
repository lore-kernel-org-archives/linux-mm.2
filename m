Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0D9C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 17:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7D38E009E; Thu, 24 Jul 2025 13:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4018E007C; Thu, 24 Jul 2025 13:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB4938E009E; Thu, 24 Jul 2025 13:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C84028E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:03:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 753671A0359
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:03:11 +0000 (UTC)
X-FDA: 83699778582.09.1969F04
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7425D14000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:03:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aDasFNrs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753376589; a=rsa-sha256;
	cv=none;
	b=IeZUo8BXgXSasLmWCKQWb19kkd9jj9NxWIJhR4JI5jTi1QYoc3mvOcOAZOkQvyM1w6RKzm
	rp/xx9CcUmmsbD0lJBBwyxZQUQ5NU+07ehCSBfUeOU86V1QIh/WxvDQRozX/ab+G4wV+SF
	KyK41RjzbMVFVXAT98Tg2AhGBElaJsI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aDasFNrs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753376589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FGOOiPVQqYASE7Wmz67+AH5G3BHXQxt/qem1BnGLQw=;
	b=CjL0xyl/ZY/MrkorrXvdQHptkYs7qMMZvWvpgRnJYxUqC4lM6ciCsk3hKHrMQuL5blVDt1
	RorITo9jP8uzDVHsvPwsa+V6wK5d8UcrZnbA7Ia9roFoRJIr+9/w//7lDwZbyPsTWaBih8
	G9yaEk0/mgZYflnHStCEezfuIfeQJ0M=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-32f144d0db8so8362351fa.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753376587; x=1753981387; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0FGOOiPVQqYASE7Wmz67+AH5G3BHXQxt/qem1BnGLQw=;
        b=aDasFNrsHIeZiOnJ1UvHV9vXi4RqxOPHDLquqyttfTayyRF4R8AVUg4y8nZjdiSj8n
         qYbPK0r1tRAZ9GkY5Yw/cQ8/xZTf6Fy/LSytz/HdB0fwUjG/jwDhVM+yJQVlfW+t9kxo
         mtAdtWXUAl5NgJ9YPgEKJYp5nEp0mBCvqoksrxl5RbyZP9cbIhfPVtua4UsSi1ZG4y6P
         ddNhJnrFCoOp7fY2666mzR0LH3SiNALrDZx3hK8DHTGjctHHlZ611c6F5pcVIegtiGy9
         zBGBRoeqoulB0Dk0eNfwQfFB9BBL0QjpPUFmKE70pZe57/fpEcjWGVshSpDVAvkY1TZh
         Ncug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753376587; x=1753981387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0FGOOiPVQqYASE7Wmz67+AH5G3BHXQxt/qem1BnGLQw=;
        b=iuRDl90jnnjmV6nzQaeXqhki2HBX2spG43/0oFKUCpwdXyn6x+kSgTg6ZOnUKqubDG
         utPTV9ltMPYtNYTqPE8/80Lqw1PxHCdEqjWRv0xGJ3iBZMXDe/PzWLnIdr3n076yPgpA
         iDUs++LWSOFgvrSLXa9skQWlzqBC94PnLE/5cjHJBTk+BsuDSivECOagnFyHOrI3GMew
         sV4jQMF5f2gooEvyPA6fiEu5fxTa2Fc0auPld+4ucy4LQ4tGAi1AjrzTh953sGIML3yv
         RiNuQ3wxvIgihvzlRqpx1Cr0lpHWDSrP6ujwFIPDFhU7W1OxBuXCP4CTBskS7/qrQCEA
         V+8A==
X-Forwarded-Encrypted: i=1; AJvYcCU5TuIeerCjwZ52rszMUXMDKNQGITuICgAEjYc94jyRhk/yothJRIw5hHolTTMj5/zTtOXbielVkg==@kvack.org
X-Gm-Message-State: AOJu0Yz1PuwF9lLGmVDQo5Li6/iJ6UtAwMoiX+0Pd7mOMFOQFGM26oHf
	rlrhkoxXFLyWWcxDO/fameDOjHyYDJBpGnXIAZPTCmXiZRRhPQmYQins/EeqpqT9njxOkk4IiiW
	8XhknIvJ7OuV9fn+uOaM5O1RZAZNEXXg=
X-Gm-Gg: ASbGncv8MDVaeV1UUKyTZrC7CyONTunKFX1Nj47lC6kaAfEWosowMZ+rXRuvCcyxXsi
	MlZQAu/LGRBTtZVrNZAnJwv0P50bEapZepN/6Nr0UwnMH+4CBT8OjRrN3Criitc6CDqfpgQ1nuz
	vv7MOnsqslXrBdtys9H0dT8QEASQma3X7peH6vWsoQlZiVtolfBbP5FYeD3vUfsl7TyHj0FYtDo
	oBGHws=
X-Google-Smtp-Source: AGHT+IH2SK9nNFgrAJTPUO9UuVWjDcmLx1aMVGa4BQ7jWyaoMvsByiN2oGkEo7mQNMXKziQVY3Jn0YtJZ4JLlWl3sdU=
X-Received: by 2002:a2e:a00f:0:b0:32e:aaa0:e68c with SMTP id
 38308e7fff4ca-331e25b98eamr7355731fa.19.1753376587111; Thu, 24 Jul 2025
 10:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250710033706.71042-1-ryncsn@gmail.com> <20250710033706.71042-2-ryncsn@gmail.com>
In-Reply-To: <20250710033706.71042-2-ryncsn@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 25 Jul 2025 01:02:28 +0800
X-Gm-Features: Ac12FXz-JktFoi6dxbYyvTuXYPqprk55h_78M1lLvSRdsUEznKRvFtJBvXljRws
Message-ID: <CAMgjq7A+DBw=z8RPP-P1hcCH4Mid0txfmKqgqXghoE_v7zGEoA@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] mm/shmem, swap: improve cached mTHP handling and
 fix potential hung
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7425D14000D
X-Stat-Signature: x3dx393zzkgjfnatij59qxpqgjompxir
X-Rspam-User: 
X-HE-Tag: 1753376589-26811
X-HE-Meta: U2FsdGVkX181PnZ6Dx6mRMJRq01Q+E0GjIAqeNpGq+Ayjlbv5dKuSQAAalHVkdF4PA3YdoE950cIM46sgeIkdj45tiAypb+byhljRtRiD8n3NmEifSjXn93z9Ac43AY16vLRWjlYpnG44QDOgwoz3/6Pd1oHbJ8Bqs+4qtddEuSCk/LtkJVgtZUg+jf0nQoecWb9lsSsbj3OBPcTeSefVx1MTfJ6ND07lCnjRmDiNHBTisjGLC3vY+v3hRjorrsZ5swm+sNTUFMPnYmn/EXVTnZgOSSV2rAti+L8jW8yTAWg5ExLPpXkEfh/+P71D2uRVwaPP27+70KbZCTlDp4eesCSjNK7zuRxn/UCld/R4gxgoMZvhRE0WBkY4K8KH19wvKZHJB8U5ZhNtHZUahWwCwUjT7LjgtFeskfzxUgMoD2AVH4IYeI4krgTEESFfaSHly5Q4RAsVxRASQOJ5i0NmnQRUGLOYizXrfLkvbnQLzGl26q4rDuSGMAQ9UYtMfzKASed2vU2hnDY+SLEvAOyMdRDt/afRTrTdcG4n4aREXvkDIyQOOgoy2lX/9WfdnpF/8873mOo4/o/FGZ3+cNhktnrxLdFwXOmSxctnqiZFMTK4p//pv6wRq4MUZNTF3BIm4q51/JM4o6a4Bw/5SkWlpRHhMcsXvAVDwFEsmwnptjhYG74faKx5OF0Ve+j8QdRzNDuX2xIvfPLRxjZQu67sW1Y4mvDHaGhk7tMVe/SZqxnNNSeRK+KFhXV21SRc2mzQcbfwj6zF1JGDZL5bC7GhBG/JoXqEiOBPxFZCpZpR5aggkzzEP0ZzgOFLNmkvzW6Oa2ztUBw52S4hfNarJ3/ryteYMT5mrAWhOLLCQxq8Y1rxcLZlF1H2oG8YHpim8G5oYxoQEiTU0YhRR460HEvOccrba6ISKD5KjxzCJ/sqNgvOTc2SXn3orlXtn9a0+jpzarWBHyxPRjvN2ZdRTd
 Z4qJm9CL
 QQSFSZtD0AAUxPS+lgKz4zGwZI/MBIN7SbcpWaPQ+YDRIiq6kqvEK70glhoTUI32GXvHD3gwmKuNKf8B/NamJyG7We7clzVy3N5Uk/tCzXwSFG/WFIxsZr0zJxaq8RaXLb38mVj2I6ZMaLkjekfQlMpcUuQMzBGpCGoRIUAaboouODxOmevI4ckGsTyqIyPuGwUTLuF+AceIQKGUIg7/t0oEmLABN9IkwOFVBMhsZ6R2/fgCdXyPDMSruMkab7kYZbO53eKm6pGvTUtl1eiOMosK8hdXgN3HT93r8hMGNahf41OC/p4RKwT3Mw/NtFqW1/8ELEcUfJBit/ej9W5snWsMuplhQqAVEWkEuHUXDItZqLrMTx/PmwBUxFbdUz1702s8XJddRODwQF9Nhrl7DY+UxiyS1t6wTvDLdIsVbxlLrrx3+KTjEulTWBOi7RRSeVycFRP3ZUG3it6dGyT1EQRswSeEAHCTqMGcV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 10, 2025 at 11:37=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> The current swap-in code assumes that, when a swap entry in shmem mapping
> is order 0, its cached folios (if present) must be order 0 too, which
> turns out not always correct.
>
> The problem is shmem_split_large_entry is called before verifying the
> folio will eventually be swapped in, one possible race is:
>
>     CPU1                          CPU2
> shmem_swapin_folio
> /* swap in of order > 0 swap entry S1 */
>   folio =3D swap_cache_get_folio
>   /* folio =3D NULL */
>   order =3D xa_get_order
>   /* order > 0 */
>   folio =3D shmem_swap_alloc_folio
>   /* mTHP alloc failure, folio =3D NULL */
>   <... Interrupted ...>
>                                  shmem_swapin_folio
>                                  /* S1 is swapped in */
>                                  shmem_writeout
>                                  /* S1 is swapped out, folio cached */
>   shmem_split_large_entry(..., S1)
>   /* S1 is split, but the folio covering it has order > 0 now */
>
> Now any following swapin of S1 will hang: `xa_get_order` returns 0, and
> folio lookup will return a folio with order > 0.  The
> `xa_get_order(&mapping->i_pages, index) !=3D folio_order(folio)` will alw=
ays
> return false causing swap-in to return -EEXIST.
>
> And this looks fragile.  So fix this up by allowing seeing a larger folio
> in swap cache, and check the whole shmem mapping range covered by the
> swapin have the right swap value upon inserting the folio.  And drop the
> redundant tree walks before the insertion.
>
> This will actually improve performance, as it avoids two redundant Xarray
> tree walks in the hot path, and the only side effect is that in the
> failure path, shmem may redundantly reallocate a few folios causing
> temporary slight memory pressure.
>
> And worth noting, it may seems the order and value check before inserting
> might help reducing the lock contention, which is not true.  The swap
> cache layer ensures raced swapin will either see a swap cache folio or
> failed to do a swapin (we have SWAP_HAS_CACHE bit even if swap cache is
> bypassed), so holding the folio lock and checking the folio flag is
> already good enough for avoiding the lock contention.  The chance that a
> folio passes the swap entry value check but the shmem mapping slot has
> changed should be very low.
>
> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/shmem.c | 30 +++++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)

Hi All,

Just found some issue here with this patch...

>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 334b7b4a61a0..e3c9a1365ff4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -884,7 +884,9 @@ static int shmem_add_to_page_cache(struct folio *foli=
o,
>                                    pgoff_t index, void *expected, gfp_t g=
fp)
>  {
>         XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio))=
;
> -       long nr =3D folio_nr_pages(folio);
> +       unsigned long nr =3D folio_nr_pages(folio);
> +       swp_entry_t iter, swap;
> +       void *entry;
>
>         VM_BUG_ON_FOLIO(index !=3D round_down(index, nr), folio);
>         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> @@ -896,14 +898,24 @@ static int shmem_add_to_page_cache(struct folio *fo=
lio,
>
>         gfp &=3D GFP_RECLAIM_MASK;
>         folio_throttle_swaprate(folio, gfp);
> +       swap =3D iter =3D radix_to_swp_entry(expected);
>
>         do {
>                 xas_lock_irq(&xas);

I missed a xas_reset here, also better reset iter value too.

> -               if (expected !=3D xas_find_conflict(&xas)) {
> -                       xas_set_err(&xas, -EEXIST);
> -                       goto unlock;
> +               xas_for_each_conflict(&xas, entry) {
> +                       /*
> +                        * The range must either be empty, or filled with
> +                        * expected swap entries. Shmem swap entries are =
never
> +                        * partially freed without split of both entry an=
d
> +                        * folio, so there shouldn't be any holes.
> +                        */
> +                       if (!expected || entry !=3D swp_to_radix_entry(it=
er)) {
> +                               xas_set_err(&xas, -EEXIST);
> +                               goto unlock;
> +                       }
> +                       iter.val +=3D 1 << xas_get_order(&xas);
>                 }
> -               if (expected && xas_find_conflict(&xas)) {
> +               if (expected && iter.val - nr !=3D swap.val) {
>                         xas_set_err(&xas, -EEXIST);
>                         goto unlock;
>                 }
> @@ -2323,7 +2335,7 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>                         error =3D -ENOMEM;
>                         goto failed;
>                 }
> -       } else if (order !=3D folio_order(folio)) {
> +       } else if (order > folio_order(folio)) {
>                 /*
>                  * Swap readahead may swap in order 0 folios into swapcac=
he
>                  * asynchronously, while the shmem mapping can still stor=
es
> @@ -2348,15 +2360,15 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
>
>                         swap =3D swp_entry(swp_type(swap), swp_offset(swa=
p) + offset);
>                 }
> +       } else if (order < folio_order(folio)) {
> +               swap.val =3D round_down(swap.val, 1 << folio_order(folio)=
);
>         }
>
>  alloced:
>         /* We have to do this with folio locked to prevent races */
>         folio_lock(folio);
>         if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
> -           folio->swap.val !=3D swap.val ||
> -           !shmem_confirm_swap(mapping, index, swap) ||
> -           xa_get_order(&mapping->i_pages, index) !=3D folio_order(folio=
)) {

And this part is incorrect. This `shmem_confirm_swap(mapping, index,
swap) ` can't be simply omitted. Some functions below before the
shmem_add_to_page_cache shouldn't be called on folios might have
already been mapped by others. This shmem_confirm_swap ensures that
won't happen.

It may seem like a small change, but it leads to some minor conflicts
in one or two following commits, the benchmark result will change too.
So I'll have to send a V6 I think.

We can remove this `shmem_confirm_swap`, but not in this series I
think, maybe after this. Need to re-arrange some functions, with some
clean ups for shmem_add_to_page_cache and others.

> +           folio->swap.val !=3D swap.val) {
>                 error =3D -EEXIST;
>                 goto unlock;
>         }
> --
> 2.50.0
>

In summary, I'll squash this patch into it and do a rebase of later commits=
:

diff --git a/mm/shmem.c b/mm/shmem.c
index e3c9a1365ff4..4ca0b665b79e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -898,9 +898,11 @@ static int shmem_add_to_page_cache(struct folio *folio=
,

        gfp &=3D GFP_RECLAIM_MASK;
        folio_throttle_swaprate(folio, gfp);
-       swap =3D iter =3D radix_to_swp_entry(expected);
+       swap =3D radix_to_swp_entry(expected);

        do {
+               iter =3D swap;
+               xas_reset(&xas);
                xas_lock_irq(&xas);
                xas_for_each_conflict(&xas, entry) {
                        /*
@@ -2365,9 +2367,16 @@ static int shmem_swapin_folio(struct inode
*inode, pgoff_t index,
        }

 alloced:
-       /* We have to do this with folio locked to prevent races */
+       /*
+        * We have to do this with folio locked to prevent races.
+        * The shmem_confirm_swap below only checks if the first swap
+        * entry matches the folio, that's enough to ensure the folio
+        * is not used outside of shmem, as shmem swap entrie
+        * and swap cache folios are never partially freed.
+        */
        folio_lock(folio);
        if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
+           !shmem_confirm_swap(mapping, index, swap) ||
            folio->swap.val !=3D swap.val) {
                error =3D -EEXIST;
                goto unlock;

And I'll do some clean up afterward to get rid of this
shmem_confirm_swap. How do you think?

