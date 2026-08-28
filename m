Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E94C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 23:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861196B0088; Fri, 28 Aug 2026 19:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812606B008A; Fri, 28 Aug 2026 19:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9696B008C; Fri, 28 Aug 2026 19:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 442F66B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:48:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF8F61C1F1C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:48:15 +0000 (UTC)
X-FDA: 85152319350.02.AB4B6B7
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id C2AB1180005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:48:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cWuJWrVL;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787960893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yc+vOqjH7EkbGiYMYTHlmr955fm/fNcVpennfZlqFLU=;
	b=h2nssF5vN59KpUm3+5rIDC8NC/ocn6f0lSA3jd0thtNAcxyqpSf9HK1hbqAgPXNqx0Oqmb
	tqSRBXZkAN7hyWohm+n3Yu9mdV0NtGEZsK+Hynhy29/EvhrUl7RqgVT2ShU+Urkm9FLvEh
	fbiDDJZnzpVmRX5fhgsBMIV5H2Duy2I=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787960893;
	b=y/uDViunX81NxVSbWvLsdMFnnsnB9fY/6HwSoyQc2tSf9BH1jQmefnGqVgfFH/p5exBI4M
	2DaGufMU4ue+gfIMQtPD4zY+h0h/WT0Q9tMnc0+Jn8iadYLK3xzjssMcS2NvvMxKFs/GS4
	GsNANJ/iks29/Z+7yt5uTlo+TjudBmM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cWuJWrVL;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-52fac937235so52611cf.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:48:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787960893; cv=none;
        d=google.com; s=arc-20260327;
        b=dLHf/ojDNQnHHknMayrUokOG9FRzbtqzojicB/0jNpQG+alzNdkjGQwaFczKZwr54x
         mhekAVTEX14p1q+tCHXhUEJEYFS4jRMre3gP7dT5AcNkTGsABdpvSsCe/fG1fknIxYeg
         l1KrAmO6L/H+/kSl1X1jw79b9dgcEQwAOWm8pLIk3vBRe6PPfCIlVVNa5efHwOerbHNH
         Nidpt0VE3XddaJECmqgIDmDRDxIdbp0dWOSxp/P/eMm62cASErm0MRY/DEa+HyfuPnUH
         waXF3kJVWnMZYTjgbBOyNgiFYLq/TGIaCL9qYaNPy2h1XClhWMP010AzuL9PnOTm0766
         fYFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yc+vOqjH7EkbGiYMYTHlmr955fm/fNcVpennfZlqFLU=;
        fh=nzCs51IOsrxqPQa+R4dF8IiV1nz136t56u4gB7RSSFg=;
        b=M2drz0i0mK+N+ECOu5xbIta5vdWJvc9b7l8at5F/eIc4GKMRG2VQWgSIBW8sSQi+Rk
         GiT0FDxcJfWHrsndq/U4D0FqjiWsYnbNxonSP6bl4jPNUqiTlJPC3uL4VT97/8iocn+1
         narNMHVSHbcWnCeoPPQu36/W6nyhP4EWB/3/pAXv1fgkvK16mqZsDMNhwF8rtcSraEzB
         +5Gd1uAgRhAYxe1Ct4IzFWOcA5l8idPadYUh3AewCB5hfD++inc1llgP1HJ7ez/4AtBf
         kkcO09h1Gv+yLvd5JJA1UfcTRS+1AashBgVHx8v4d4OcLD/2FgucHxWzlz+gWuE+5eRt
         co1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787960893; x=1788565693; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yc+vOqjH7EkbGiYMYTHlmr955fm/fNcVpennfZlqFLU=;
        b=cWuJWrVLQAsLqqVTIjct9+3IDXYu0Lrqs92D0MR/3VIUvCsZvZmwhJ/a/1HkrAk4m9
         nyH/bsFTt0krx/SY5InBF1deIWQuJdL8BMftKjwdyVMC3IGZK4nea+DZ82/5s3OkAh6q
         aTAaXVEEPs4wkI8FNb9NPF4WwFCOk4/SNKwrTN++MM4+l9Jiwbak0r15HWyRtrgSP5JU
         ZL/cKxNYdCyAaW9dGO3pub/VfJYWy2cdtBAVZ5zFtlD6ElbsZk5CetLlzJrufzu1Mi2Q
         jH2aaIQ2OWmv7rSVgVs2pFD91D5KIMM65LVwBIDgb3P1T7/e6hpNCIE4V02P0eDnwRZi
         a0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787960893; x=1788565693;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yc+vOqjH7EkbGiYMYTHlmr955fm/fNcVpennfZlqFLU=;
        b=FE2+gQ0nDEJy2gTxVOzYiOCUzQZzqFKrcMCQcF1ginnSWSB4nkyyab9I1e9g3Ed+SH
         OuqOH90LgM8uoGz/vRgLGw7vtVjJ6yZnWviBiotillqTspZhmLYpWgCnId+mI6LQpq2d
         uwzISMEWmJyFmROd4h7kfrzoW5iuHCC70DZYMG9xsnZjOumecrMR4fIeTmwYfMaackCz
         acf3FqLqNjj50KSV6aFacj1MWv6Ca5Nrxwdbdl4/wywja6eJCd/Qp78VBv6Rif94orLC
         +ObA0pmlpgcP7BgYju+Z8ZIZEc+Gki987BfD65sqnBJEAeaIBKUaHjFjU0PbZYK7X+hE
         9bMQ==
X-Forwarded-Encrypted: i=1; AHgh+RokQaiPn4LW9WiJ9Z2MG9Z1mYnezEq9RAeo07IycRJf/yKFtIu0V8I4/7y1tPYyU8A/T6RzdW3qpQ==@kvack.org
X-Gm-Message-State: AFuF++l1L3x5hGwuvmWJKEAt9wmz7Dl6JUY94hdURlguCW4pk3/7MrHR
	i8Fts6oojiHmSaz/PtTQPoReKaQwwMS4iBwORMhggjeJ7D5luFIJUKQWHBMW7tpfADeH9dkv02U
	QrEKA8RFZ0jwDlFjEd4oOwUJHD9N3247Xm/SVbIAQ
X-Gm-Gg: AR+sD13T41wBypOVLwKoqgxoL1Qc+xA4R4VIhKQ4/hsZjFcMxg0B5wrgemBUam6/yH3
	orciyrK2JQYNYc3laWOpkxZMmFs13pPS/ow7CLY7lBs4/KtdMmvBQwUCmwdtJQU8QnG10p+gesI
	q8vpjnt5G9UGNjodP+Jc+ixCfhrNx8SqSos8bGSH4je+1iHXI5723R2QOpDDz1EQXELjOimP/tK
	XjYNuHhAW8IcFio+nYtWg6q2QaZAfkdp4xmxz1U3ZrShVKfIL5ma6KiIKVBzuYZyRO0/SQvYZ91
	5Q6mVKPjl0YWncBInIZY5KLF8bNpDRiya74tBoZXTo0=
X-Received: by 2002:a05:622a:90b:b0:52b:806e:2633 with SMTP id
 d75a77b69052e-52ff716a474mr6023051cf.1.1787960887478; Fri, 28 Aug 2026
 16:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260811025157.1632867-1-riel@surriel.com> <20260811025157.1632867-5-riel@surriel.com>
In-Reply-To: <20260811025157.1632867-5-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 28 Aug 2026 16:47:56 -0700
X-Gm-Features: AcwNN1XddQRvVoPMDPAL9MgcNlHgxAaz5oDRgEf6NIvOFt4vTdIHMC1as1eA0bg
Message-ID: <CAJuCfpF47Mpi40=8yujBNruCDvY-Ezk0WFEacCqxcdRjmUqt4g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/8] mm/gup: break out follow_one_pte() helper
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2AB1180005
X-Stat-Signature: kk7qieb3cxdjd31j6th1sjn9smfcexqe
X-HE-Tag: 1787960893-538358
X-HE-Meta: U2FsdGVkX1+Gsbtj0W4rbMOlIwtoAcTO7R12b9RCUv6Bce3/o4w6owuT6O7h0Vop/XsImuAQSyVCmfcTXSpE+t7xxnjkOJLEbIUo9YWmgKlLWq7Qr4ewBpzr79K4NO3Zb2kR1gSW1W+t+RJhfOnZOi2FINrtGc92iX3iaL9K96wEefjiqkGIL90D199HnBPhKZtyykduLg35WFZvGAEX5ImNVyyPycLWRoN4KElvepv6VdCPWwnipMG0G7eSxLz+rgU7XxH9jr0Mxx/TMNFLKO+jvK9JmviBviLEMhQz4meDQf39WiLt6rfcLWtiRKDbiwlcEDdZOSfC4r33udaMBSyhld888opI0OGE81jq+IpJdXow1YPweET2jAo3uyoB7q19RIiHkwAK0K8OD2ZrzFttgFDwLvF6GhLq+Ehy5uplZ00yiAYPJEx7TibTrDjC4a0wDpAZE7uaegk+dVakgUoxKgUO43yHsJ/Aug4lXhJhdzjuvptikDjCxcBxLuysEU/kA6eBKCEoCHx4t4u4ShG9UCtMnunQX/teBCmvSnwBrl3Tbq4VUuul+WyUbufjwX9PvnnIgccXiVIm9zxZuiecWzzyzJimCKj7ySPQO37Y+sv6nUj4Kg6fdBVL16GqJiuKbhMZhKJ2OZZ85jz9stgcW4wRsB91ovtfIxDh8mqu/LuuxiLJAxGzVeKB41y2IMSG3Hs6zBD2bfqsqLFofHy73qY5YFK1D/1O1/rOJ0XGJmG7aIbB9KtLQi+aBqnF6CdxFl+cScPJLJ6awnj3X81IYZMsSATRllU+HTglAcXmRZRgSPGeUmsqAvB4Lu15cZHh5wnaHMi8rsgpripVBUrKSXwLWrnAJCkS7ARRGMvOa8B5eUZgqNf3hWXoU5ogWyEdlQFF8Mqz9L+cBnz3sl7A4Ljeki5Pv0Dd7OvqCwdwZSxm0jkAaY9X8gCp/Xa45LYCYARHCqTD0xI2SvS
 VBSkHd/O
 whhCXfecA8zxzwLLuIMcFyzfyy83Uc0R09LW+21V8Irnuww0BpHaCjfX9eFG4yYFsfWcWEf0+hjdAYLOHFXOasVAoZFPX2fEOW2jpLhurFREZPwCeW9d4kU0PHNwHMYGBQep8JNs/kOjosul2E9fmJA9YhIVWdSnbxSnZkNNdFKbzFFJVS4gcNRtVH4NVLWrsauadxZqkZCzkbRbVXaBioSnED7qPjzk0y61Hf7K0k2LEevHHgTyvVv/VpYGsLl8R1J0H/NqFf05g9At5W/l79CGzfK1M0kNZ6mUIQPcrw9mgWCW1UcFZO9OKHJpHpVP3RHVovFdfV+Zeb7vu9I7vtWEg15tunacnTRPiw1lwp2AJbt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 8:07=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> follow_page_pte() is 92 lines and does two separate things: work out
> which page a PTE maps, if any, and commit to the page it found. The
> first half reaches the second through five exit paths, two of which
> unwind the PTE lock in different ways.
>
> Split the resolve half into follow_one_pte(), which returns the page it
> resolved, NULL when the PTE cannot be followed, or the errno the caller
> must report. follow_page_pte() is left with one unlock and one exit.
>
> no_page_table() can look up the page cache, so the case that needs it is
> recorded and the call made after dropping the PTE lock, as before.
>
> No functional changes intended.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c | 100 +++++++++++++++++++++++++++++++------------------------
>  1 file changed, 56 insertions(+), 44 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index b755ceaac0f5..5af6a23285de 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -868,74 +868,86 @@ static long follow_page_pte_commit(struct vm_area_s=
truct *vma,
>         return 0;
>  }
>
> -static long follow_page_pte(struct vm_area_struct *vma,
> -               unsigned long address, pmd_t *pmd, unsigned int flags,
> -               struct page **pages)
> +/*
> + * Resolve one present PTE to the page it maps. Returns no page and no e=
rror
> + * when the PTE cannot be followed but the caller may fault it in, and a
> + * negative errno when the caller must report the failure.
> + */
> +static long follow_one_pte(struct vm_area_struct *vma, unsigned long add=
ress,
> +               pte_t *ptep, pte_t pte, unsigned int flags, struct page *=
*pagep)
>  {
> -       struct mm_struct *mm =3D vma->vm_mm;
> -       struct folio *folio;
>         struct page *page;
> -       spinlock_t *ptl;
> -       pte_t *ptep, pte;
> -       long ret;
>
> -       ptep =3D pte_offset_map_lock(mm, pmd, address, &ptl);
> -       if (!ptep)
> -               return no_page_table(vma, flags, address);
> -       pte =3D ptep_get(ptep);
> +       *pagep =3D NULL;
> +
>         if (!pte_present(pte))
> -               goto no_page;
> +               return 0;
>         if (pte_protnone(pte) && !gup_can_follow_protnone(vma, flags))
> -               goto no_page;
> +               return 0;
>
>         page =3D vm_normal_page(vma, address, pte);
>
>         /*
>          * We only care about anon pages in can_follow_write_pte().
>          */
> -       if ((flags & FOLL_WRITE) &&
> -           !can_follow_write_pte(pte, page, vma, flags)) {
> -               ret =3D 0;
> -               goto out;
> -       }
> +       if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, page, vma,=
 flags))
> +               return 0;

Before refactoring in the above case we would "goto out" and
no_page_table() would not be called even if pte_none(pte). Now I think
you will call it if pte_none(pte). I'm not sure if this does not
matter but this seems like a functional change.


>
>         if (unlikely(!page)) {
>                 if (flags & FOLL_DUMP) {
>                         /* Avoid special (like zero) pages in core dumps =
*/
> -                       ret =3D -EFAULT;
> -                       goto out;
> -               }
> -
> -               if (is_zero_pfn(pte_pfn(pte))) {
> -                       page =3D pte_page(pte);
> -               } else {
> -                       ret =3D follow_pfn_pte(vma, address, ptep, flags)=
;
> -                       goto out;
> +                       return -EFAULT;
>                 }
> +               if (!is_zero_pfn(pte_pfn(pte)))
> +                       return follow_pfn_pte(vma, address, ptep, flags);
> +               page =3D pte_page(pte);
>         }
> -       folio =3D page_folio(page);
>
> -       if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
> -               ret =3D -EMLINK;
> -               goto out;
> -       }
> +       if (!pte_write(pte) && gup_must_unshare(vma, flags, page))
> +               return -EMLINK;
>
>         VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
>                              !PageAnonExclusive(page), page);
>
> -       ret =3D follow_page_pte_commit(vma, address, folio, page, pte, fl=
ags,
> -                                    pages);
> -       if (ret)
> -               goto out;
> -       ret =3D 1;
> -out:
> +       *pagep =3D page;
> +       return 0;
> +}
> +
> +static long follow_page_pte(struct vm_area_struct *vma,
> +               unsigned long address, pmd_t *pmd, unsigned int flags,
> +               struct page **pages)
> +{
> +       struct mm_struct *mm =3D vma->vm_mm;
> +       bool need_no_page_table =3D false;
> +       struct page *page;
> +       spinlock_t *ptl;
> +       pte_t *ptep, pte;
> +       long ret;
> +
> +       ptep =3D pte_offset_map_lock(mm, pmd, address, &ptl);
> +       if (!ptep)
> +               return no_page_table(vma, flags, address);
> +       pte =3D ptep_get(ptep);
> +
> +       ret =3D follow_one_pte(vma, address, ptep, pte, flags, &page);
> +       if (!ret && page) {
> +               ret =3D follow_page_pte_commit(vma, address, page_folio(p=
age),
> +                                            page, pte, flags, pages);
> +               if (!ret)
> +                       ret =3D 1;
> +       } else if (!ret && pte_none(pte)) {
> +               /*
> +                * no_page_table() may look up the page cache, so it cann=
ot run
> +                * under the PTE lock.
> +                */
> +               need_no_page_table =3D true;
> +       }
> +
>         pte_unmap_unlock(ptep, ptl);
> +
> +       if (need_no_page_table)
> +               return no_page_table(vma, flags, address);
>         return ret;
> -no_page:
> -       pte_unmap_unlock(ptep, ptl);
> -       if (!pte_none(pte))
> -               return 0;
> -       return no_page_table(vma, flags, address);
>  }
>
>  static long follow_pmd_mask(struct vm_area_struct *vma,
> --
> 2.55.0
>
>

