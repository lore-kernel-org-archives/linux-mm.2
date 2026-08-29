Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19882C61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 03:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B29C6B008C; Fri, 28 Aug 2026 23:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062F16B0096; Fri, 28 Aug 2026 23:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6CC16B0098; Fri, 28 Aug 2026 23:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB4296B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:06:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D10BC05F1
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:06:49 +0000 (UTC)
X-FDA: 85152819738.16.0AFCB9C
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C893C0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:06:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e0kgbPve;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787972807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAd6Cs6cAIBMoTEeCRV3gq9M08ePmZpyE5FmQw284bs=;
	b=ICrKcFcy72GfrW2dkRnqwJWZvj7NzmxSMIsuv4H6Mjdu1vNXmMT8YEZdcQsaPhw7wFkI1/
	ZXacPdyMYLnC3/5ww4Zwn16JZ3H61XlxVbwzoDHpYU25Vx4nTdZamtU1OCOFrkQ+Tzvfit
	FquOv16og0l+RhR5lOVaSxm/b4Cy5HU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787972807;
	b=0tpc1JCWI8t4SLsg9LYqL6YcwjOsBZxXTJLiVhTJKH5Q1pLB/lKrE+im2RsPBGtHOTayVj
	enchNmac8MRsxTS54T2164xabbTD74vfbS1ZKANcW8JSQRklQYWvTkgEszlbHyE4E6WUYc
	f9kYyMlhfoGxl2+GllxFfmWV0B4zTao=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e0kgbPve;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52faa58bff5so102241cf.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:06:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787972806; cv=none;
        d=google.com; s=arc-20260327;
        b=cr9y2FW9LMg2zK0igTfixpkKbYPmoLo9iuLA9vFElt4h4N8JcEuUwDwEZwJGPjwWi1
         hPvUBofRQMt/JTtkR8ZNM85xRmqBvPxYbceGtqZ3GI2qq2ajK+nSN1eI54Kt6Y+30NkQ
         GnlHHXfXrGMr52TBofRAZ1QRfzRvtcGjziXKiZ/aXubaRlTMdVbD6VpoxEFAgRCkfOOT
         UY3Cf5MwSoKj5WMTUR4ZmNRKK2HJfypixYJWlceT7P44KsSjvfkjpAUaItqUSkfEvDjm
         2S1wXXW04lh5SJalZN18UsLP35oTjXFF6FnaVFTe4Hrvr4hBUQeCjY+OZML3olkX8sZy
         RjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bAd6Cs6cAIBMoTEeCRV3gq9M08ePmZpyE5FmQw284bs=;
        fh=1WljNLkSWuZ6P1OlTj7ud1A61mnaLcEc7UrAXdvlKdI=;
        b=TU0UpGrUndTooascmD70rejlC5mzPcl6PCOH27K+iVvADvtQesif0mZRw0wuxzLi54
         ne+zUfW+mQbtjHVPDHxRYr8YXOa1RRPTI5QxEp+lEh8De1KgF9ZFaonOHNqPTrE7A5Lc
         ZAXt2AvaA8upMiKK4kzYzHIdEx+2coEwJUysE9o2SVvpYVcdRqzNjGX5h4/QNkIu8Q4Q
         zgG2SBKESAb/98CG1tYwlqcVcWSOBlKlslVzIrr4z1f2AWqNxVDfQ+HhCgpo1HJPaoB7
         6aZfn+dMkIrUaQ7XO5xzChvnrMdJSDqjr7Bjss6HyGQp+Boh0Z0WDS2Vba6lGV5diOpL
         7AuA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787972806; x=1788577606; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bAd6Cs6cAIBMoTEeCRV3gq9M08ePmZpyE5FmQw284bs=;
        b=e0kgbPvekKnWJgUIH3Ke5wOONgfX+3pTp/yHGTBRm1ZRprduz+iTTO+Kx7t4Cdp38w
         Z5NhF2mGclEIcdI2+rX6bjOWFYcwU1DwgiTqG2UISbSGnJl2EtqVnEOqzkF6nE4ECya3
         s+qPVh4DNh8veWuO+itzWmL/Q+lGmzwz7/xqpWr3onhKxfg2ul7da3s0x/XKtrGUZzLn
         f3E5wUpuL1DwnJH+UM/Kk9RH2QnU1aPt98rDVEd6UW1fA15NpRnfb0bOOW9rYpEP3HXD
         rL8Z2cJUq7Ct6xeAmiKk0Xj0ioYFeK2fUBbFHW9oD1WcBeslITtL8AunjuH092mfDPlL
         K74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787972806; x=1788577606;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bAd6Cs6cAIBMoTEeCRV3gq9M08ePmZpyE5FmQw284bs=;
        b=Z3BQD/BiISpymc7/dArhC8W9jUUgO1zPGwwHJa9qR1sUYeveMFOyl3Jg/nP6vJJnzN
         Rpw6JNs9/yM+4NS54PW1L514/Ycp4Kvx0g2422JAUU2mPqUIFFV4fS1lC/igKJMc8TOP
         Tl1A+wx3wUSUu/zleCIJjQHoHGML7SZy2F7zzz3UZWrZ0V+vHDCbRloDLSpUghBrp7VX
         MtfXLTlS1FJetJC+1i5hBTR6YGI+827Calm5JIcFAS6gnWvC9NcsRsaE37lnGL+fM7m4
         JfD2ar0VgrN/ND6YtxHIjBMgll0bn13B+DpSKbEQfga8QcJPIMSJFt8AY4KqaKI0fuTC
         WRow==
X-Forwarded-Encrypted: i=1; AHgh+RpKgDYBzv6g46XowaJrW4Z5Znybc3j4aer6rh8UYh+SskqTt4EXN00fvzRPwf0tWRNRLpAw83D8Iw==@kvack.org
X-Gm-Message-State: AFuF++lDAn/gyI+KHd1XM8cS6ge3FlZ6oSbxGW+kLHIBLG/UHRMt7AEP
	uAF2X97EZ6MPMzVzPVoYoUbsgJlAlJOCG5y6L9YuGH3zcZVfI7QIEoV6otc5U9NovmpNX4joXFU
	hXQZpWvD05dqtAp3wN2Ge5/xr4r2I8n8tsIs0Q5P1
X-Gm-Gg: AR+sD12bvr/ZtS2vHT3rsz5BZ75kWMoOgDf7AaZDKgJt+88gcTalMh84Y3pG3nMp921
	hRMihvJUhTkeRg9pGQx3jXxZuo4zFlhvjF5lhBK5bra5wnCuhNkSUq+/9aUBJ+Z1a+QaAyFM0CN
	5RXpfay+V/6ivo5McEiuwMM1bDRw4wsRibLAnmd5efJuT6p0kGVT/sjS/wRjDMSmw8pOQSDj+3F
	G/dhvliDlqVey3uXkpkaB92uo0UGJPCFV/KBUWwR6gCIyDy2gHKIQM4z8rukszrwvmflbWFZuAR
	XUQlO1pkH1byGUXBWVuriWUT+LL72WZXVQsUtsZIwEy71Pn8SsWNsw==
X-Received: by 2002:ac8:58c5:0:b0:52d:9d62:6163 with SMTP id
 d75a77b69052e-52ff715f2cemr6683411cf.9.1787972805626; Fri, 28 Aug 2026
 20:06:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260811025157.1632867-1-riel@surriel.com> <20260811025157.1632867-8-riel@surriel.com>
In-Reply-To: <20260811025157.1632867-8-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 28 Aug 2026 20:06:33 -0700
X-Gm-Features: AcwNN1USY2yx7hCAprC1d-hQFovSZ7Q9NX1eU3m3N3_-DPrZ-emHexSsiEQQVi8
Message-ID: <CAJuCfpGyQkFOp4JPzGcMi05CzRZQyJJUBE5zckPLGNPj+7or8g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 7/8] mm/gup: walk multiple PTEs per
 follow_page_pte() call
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jggeiwzrwytfmapzsbugk1zxwzbj6mi8
X-Rspamd-Queue-Id: 4C893C0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787972807-705539
X-HE-Meta: U2FsdGVkX18V2iPI0rvSKYPHQLnTHAS5B7MuxDuhvsmIALPxQpx5VhbAfwb2UK6TJfG797c1akdTSjoiKuqStbjpd+rCnCFOmK6IfSoNdEbeV+gV6oDnmkcFZIBF61mcaTA3QJNhwHLsCeHqUEbL9e5UjOoE1NQRjC1p2gkq11tI5P1aa5DKfQagjQUlLDss7LcFX8Akf0GY1yq2OEa91RI6QXtFm3j/vpCEt0UoMrVBpCWGhNZU/Rpx1I577yz9PJr7uaLbzLz1wHLKJrpRQ0HgsULJimGoyh2UWv+i8idwMVdqWCBAeScRqBcK5T2GiWzS31qb5n+I7P+pPsMl100mMnIbhMMlDV0TEkjehUTQnPqyaUlwoEa6mWftWHmHPfelcbFwQ+TEd/wCaef+TzWvxtidGymWnUMc4nimdDz3/PlgGsQA0LD9VKpXlL65CFJ54eNzbd0B/3uRiWaY/P6/G4PM8BTl9eXJA6YAO4XLiRYWCL6O/cMgV3oyyZlUGI+2ljPmhCm/1e4H+xyg1W3b+5pWg4tPt2BdPFhZdoqM9+X6utMbM3g3OYT7KQM79Yw1lHp0Lbfg860RblLFarP/gpi518F2Rbrog/DNBqf1XMCtZPmwg9RigghYzz7k+/WI9k0LsRejzlY5scSk/hyIYkxW5AzwkrySX5ZWASU+Chf+CUKJ/+zcMI48DmlEAa8NGOvLRNaZS7TiFfCTCep/XL2XsNLESafeEk3cR8k4RLxONxka+JA20y301YPCfHkiFFKe6Iv2sbd+hmzT1COa1/vx7LZHW0WuM7Htii/0/QiIQNU/5L0oCg36X8+Gny2kEgWiaOLYJ4lYfEFhc9sYSh0EwPmsbR4nZTeaIG+ziVWUi6AjI0gpscvacoLJahACNcrBlyDlGTyDakyQvusmHdl/B4SoZ9UkDCLegXgyF6HMOAJdRq1sP9uB/irf+zLpRLt1sPaLOIL21BK
 KnGEQyyf
 Ed7SugkLQZSyCiHNS7Ch5516WZZjYVV7SjU3IGTVX1LjVHm1220BefB4/hg0/4UF9YBGQRikhlgDG5guwQZzGj7c+E/yUcb+/rgn0vDuu3fmm4iWeU7WHbIaZHVQDP4ThbTxI3tPdSiBCu6cMLWiHgzZPyQ2EcsnRw0+9EiiP9l8xBKukRd3no39KXlBsETk4fOUDINyBQoNJ4SDmXpWq9lZQP3K8/z/90ZtvGCOBkfp/gpr43X7ay54LqbjcJRSWlbG4Of/Nu+4grh3y2inGYuEA3tbbveOT1rn4atDZ2I/3jxmZZxK6MQEzUlCI5UUwszkEPeyNvqHOvfAg6UJ/7uzmMeiq3E2OEm37qw3Z02kDKis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 7:57=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> follow_page_pte() looks at one PTE per call, so __get_user_pages() calls
> it once per page, restarting the pgd/p4d/pud/pmd descent and retaking the
> PTE lock each time.
>
> Walk every PTE from @address to the page-table/VMA/@end boundary in one
> call instead. Adjacent pages from different folios, or plain base pages
> with no folio relationship at all, are covered by the same call under one
> lock.
>
> A failure on the first PTE is returned as before. A failure after that
> ends the walk, and __get_user_pages() retrying the read gets the error.
>
> Measured with mm/gup_test.c, median get time over 16 iterations on a
> 256 MB MADV_HUGEPAGE region in a 4 CPU VM. Folio size was confirmed
> through the per-size anon_fault_alloc counters, 4100 folios for 64 kB
> and 128 for 2 MB:
>
>   gup_test -L -m 256 -n 65536 -r 16 -t
>                         before      after
>   4 kB base pages      2753 us     1178 us   (2.3x)
>   64 kB mTHP           2946 us     1361 us   (2.2x)
>   2 MB THP (control)     72 us       70 us
>
> Base pages and mTHP gain about the same amount, because what is saved is
> the page-table descent that no longer restarts per page, not anything
> folio-specific. 2 MB THP does not reach follow_page_pte(), so it stays
> flat.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c | 62 ++++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 20 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index ea2bb379183e..c4233a7b8a48 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -916,38 +916,60 @@ static long follow_one_pte(struct vm_area_struct *v=
ma, unsigned long address,
>         return 0;
>  }
>
> +/*
> + * Walk the PTEs from the start address to the end of this page table or=
 VMA,
> + * whichever comes first, and commit every page found.
> + *
> + * A failure on the first PTE is returned to the caller. A failure after=
 that
> + * is a short read; __get_user_pages() retrying the read will get the er=
ror.

I guess it's ok to explain your expectations about __get_user_pages()
retrying upon receiving an error. Could you please also document what
this function returns?

> + */
>  static long follow_page_pte(struct vm_area_struct *vma,
> -               unsigned long address, pmd_t *pmd, unsigned int flags,
> -               struct page **pages)
> +               unsigned long address, unsigned long end, pmd_t *pmd,
> +               unsigned int flags, struct page **pages)
>  {
>         struct mm_struct *mm =3D vma->vm_mm;
>         bool need_no_page_table =3D false;
> -       struct page *page;
> +       pte_t *ptep, *orig_ptep;
> +       unsigned long walk_end;
> +       unsigned long nr =3D 0;
>         spinlock_t *ptl;
> -       pte_t *ptep, pte;
> -       long ret;
> +       long ret =3D 0;
>
> -       ptep =3D pte_offset_map_lock(mm, pmd, address, &ptl);
> +       orig_ptep =3D ptep =3D pte_offset_map_lock(mm, pmd, address, &ptl=
);
>         if (!ptep)
>                 return no_page_table(vma, flags, address);
> -       pte =3D ptep_get(ptep);
> -
> -       ret =3D follow_one_pte(vma, address, ptep, pte, flags, &page);
> -       if (!ret && page) {
> -               ret =3D follow_page_pte_commit(vma, address, page_folio(p=
age),
> -                                            page, pte, flags, pages);
> -               if (!ret)
> -                       ret =3D 1;
> -       } else if (!ret && pte_none(pte)) {
> +
> +       walk_end =3D min(pmd_addr_end(address, end), vma->vm_end);
> +
> +       for (; address < walk_end; address +=3D PAGE_SIZE, ptep++) {
> +               pte_t pte =3D ptep_get(ptep);
> +               struct page *page;
> +
> +               ret =3D follow_one_pte(vma, address, ptep, pte, flags, &p=
age);
> +               if (!ret && page) {
> +                       ret =3D follow_page_pte_commit(vma, address,
> +                                                    page_folio(page), pa=
ge,
> +                                                    pte, flags,
> +                                                    pages ? pages + nr :=
 NULL);
> +                       if (!ret) {
> +                               nr++;
> +                               continue;
> +                       }
> +               }
> +
>                 /*
>                  * no_page_table() may look up the page cache, so it cann=
ot run
>                  * under the PTE lock.
>                  */
> -               need_no_page_table =3D true;
> +               if (!ret && pte_none(pte))
> +                       need_no_page_table =3D true;
> +               break;

The flow in this loop is a bit weird. You could save at least that
early "continue" if you break on a failure early and let the
successful case continue looping naturally.


>         }
>
> -       pte_unmap_unlock(ptep, ptl);
> +       pte_unmap_unlock(orig_ptep, ptl);
>
> +       if (nr)
> +               return nr;
>         if (need_no_page_table)
>                 return no_page_table(vma, flags, address);
>         return ret;
> @@ -969,7 +991,7 @@ static long follow_pmd_mask(struct vm_area_struct *vm=
a,
>         if (!pmd_present(pmdval))
>                 return no_page_table(vma, flags, address);
>         if (likely(!pmd_leaf(pmdval)))
> -               return follow_page_pte(vma, address, pmd, flags, pages);
> +               return follow_page_pte(vma, address, end, pmd, flags, pag=
es);
>
>         if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
>                 return no_page_table(vma, flags, address);
> @@ -982,14 +1004,14 @@ static long follow_pmd_mask(struct vm_area_struct =
*vma,
>         }
>         if (unlikely(!pmd_leaf(pmdval))) {
>                 spin_unlock(ptl);
> -               return follow_page_pte(vma, address, pmd, flags, pages);
> +               return follow_page_pte(vma, address, end, pmd, flags, pag=
es);
>         }
>         if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
>                 spin_unlock(ptl);
>                 split_huge_pmd(vma, pmd, address);
>                 /* If pmd was left empty, stuff a page table in there qui=
ckly */
>                 return pte_alloc(mm, pmd) ? -ENOMEM :
> -                       follow_page_pte(vma, address, pmd, flags, pages);
> +                       follow_page_pte(vma, address, end, pmd, flags, pa=
ges);
>         }
>         ret =3D follow_huge_pmd(vma, address, end, pmd, flags, pages);
>         spin_unlock(ptl);
> --
> 2.55.0
>
>

