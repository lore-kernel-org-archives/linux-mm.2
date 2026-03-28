Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0EE110BA423
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 18:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF946B008C; Sat, 28 Mar 2026 14:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397E36B0095; Sat, 28 Mar 2026 14:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD536B0096; Sat, 28 Mar 2026 14:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19A626B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:49:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92A191A01E3
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:49:31 +0000 (UTC)
X-FDA: 84596360142.04.DFCDB3E
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 926B04000D
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:49:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qZttoJjT;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774723769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvBwZe6OAmUwW/qKvOnQ/88d+Y9b6bSQtv++afhsia0=;
	b=7m4+jLMP6BBiNcTFdJ6Q4xUVT5jPGg/uqr/SsI3I+l2NUpDu/1rsdCroVWQaCIOUCQR3UP
	Pu2DOX+F7SHA9KsTdbeP8jKYgq/BDXqgNR4XPkRQlV41hT0lIt5tTCJSIu8Zi6a/H+KMvh
	ZtCkYrYazoKt1UABmMW8dzvrOndtL6Q=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qZttoJjT;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774723769; a=rsa-sha256;
	cv=pass;
	b=zkOO9c6EeOyEk6J0D9k1crPK0HibCYm3/A8yW7h0jGmR4kbxEYYjNTJMnn7dTuBfVvw2vr
	YOtqaFaQ/KSHGoe9q81uyqOIstnsqqrCQGbRZ69SR4tLOz89ESycQss1xYZwzriohcAaR2
	347hgD4XDth1/ElKTKt6VwCWr42hPQ0=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50b6c45781aso493171cf.0
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 11:49:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774723768; cv=none;
        d=google.com; s=arc-20240605;
        b=iHLyCV8qFCOEEaHJ8nYs3FEfzYtykhE3xXL75M3TlNsgOYX5rBIOcPtaWbNXRYXTo5
         h3x2WHKeVrNPiloC01kBCIL/h8WEOfl9X0XgVE265LxUU1DugcWI6nMPRYZMqwMmBDi9
         A1fF833VX+gZMdGAjVGtmhiii3nHuEzbuz+Tn882BIyehUEP+9icmGbuDML8s60y1a8F
         W50C1Eo1/yfSP4hIj64UH6L1ntFNTMg4NNG3IKUEQPaF5L8s6XgX5x5WN98CHT5XOJVK
         jS0RpS3q9K+G4KbCj7lMMqQX+5t2GdKB79n8flVgtkZvo8p6GrcMh/BhiCvcOxOxq3Uo
         v3eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hvBwZe6OAmUwW/qKvOnQ/88d+Y9b6bSQtv++afhsia0=;
        fh=9hjU2MVFtE4baMsbKE8Mwt/pPJt4420SC+pYdCqrs2Y=;
        b=WgsmrDN+oG0yUGOczLESWCa+Pdadd+17+vVOshRZbKminsYx3XXjTt1SZS3CbMM/IM
         SJXjvs6L/B1dygkt6P4r9qz2vqm7tMdfJD3wKiCb9zlIycnM3yqsG/bcsY6QET0YpyD2
         +2HbLmSDOgXF3R8PJlW7iZyDcoPDgxRL3iLzOx4sy1qGWW4um/LR7m1PW+m/pMZSaT7L
         nIE/nhgNbONpXEo+zgR7vh6g6lDMeSQwEi1naTHiwS3XIAt1DjldrS+TT3eoC4WUFuJ1
         jUWXAJLHDVqp1Dcswak79Xwej+0ECOespeToZgCIeq2pB6QjrXNtd4BsLczfc/FHJrss
         KKzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774723768; x=1775328568; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvBwZe6OAmUwW/qKvOnQ/88d+Y9b6bSQtv++afhsia0=;
        b=qZttoJjTZa9hCJ2dQvDIuyp7PNm9VHUpmOzYhl47B1YSxWhbI6aDviQhauL47EP+h0
         u+BC3qmtwmc8ZOJVsNyvwY5Xm/BnZX10O1Xmx+0xhUiiEEIrMYOXQZhpcwZHLojUlao/
         zjzDSiDd/+JEybJ0gJlTyZ4xNFxaIpICFpVCBZQ8VzUMRYaJgLSoZ9deKiKxwfEgdfsn
         4wuyKg3jwamXxexJUVknyVeKQHkmbW2SJqt6JIyVTVVRnyOkEHdVHbrdGBI/i05W3pB6
         UZHBtE5aiqppgoHzSTxvag70+6Hhs03vqpPpLD7A3tXNhNq2jhFi+69XkP1ELbjyvfDf
         YVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774723768; x=1775328568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hvBwZe6OAmUwW/qKvOnQ/88d+Y9b6bSQtv++afhsia0=;
        b=G2wYIRhPXnlQGVb9fP3u1A3CndCuuvdJK0vgtP8yLX/aJxeN9NsA+exNQ4ybH7orW8
         PZtp/1624XYEkZsAGA4kmkPoCJ+fSWFbFn2JZmxkujhLX6q79zYBe/vhUMZy2PvpSWlL
         GiXL0AGgqmSuvK3P2nYs3HppHUh3qaQjeSLywm9JvKOA3iqEfZHkRoiy5rSEkFuSVmqi
         nXa2qnpeg0mYnnshUt6rzvmWFDwsg2625B4RBszDu1JOvVRPkm9+4DAonQ4PlTqq/F9A
         2vMPaJotd8YZuGGk7JMgGNcvRiFiUSZYi+pDzmV3KJG6DPenUDOua3K+mcVe5YsmhH2k
         aoag==
X-Forwarded-Encrypted: i=1; AJvYcCW/rLKQIYv8S+z6N2GGFKVqgbish88bOyRvyIB75PTMX3psbvlrZawPA7TQxmX9QFT6Wa8I0b5b+g==@kvack.org
X-Gm-Message-State: AOJu0Yx2R9btfe293hhYDW7HiPdUfyYod0M7OUpKj2RF+Sr43RF9gpot
	PqQjAceTOA2BIVTJQWrOOATwnCR10eDFJgJkcOpGAqwk2+VHGxFc7X9QGWeXRg59NqRW9mX274C
	2gYFSo06MHGWcNRfjUJBPyGBq5NwIzEJo1FRZFHRK
X-Gm-Gg: ATEYQzyB0ubsIGUkbbQMjxNOq+Euxc8GR8EmGdRh8GR9y8mE+vdYzUyJPcHEZxP/Wn2
	yvrZ5o0eCq39GHm7yYhGi0M0tiFq13LA6iOcRn4+k2kxzctaMnauOiQ4LuuYCQeWh6x5Mf4ItBX
	fbZZKXtbGtCKz5N7qykN0VT2y+oRoBtD6Wpu//O+QK3dDhVAoimoNmpmOlgGTOnm7V2oQMmwkvI
	F0jmP2Ttkw6BYL4oCzxnM/pL8sWg0yEY8858fVHxCkvf3veN6a/UHplTIduwngsIrvt9gj0hZqy
	uerA2Q==
X-Received: by 2002:a05:622a:247:b0:50b:6c6f:9ba6 with SMTP id
 d75a77b69052e-50bb3d608f1mr10143251cf.0.1774723767910; Sat, 28 Mar 2026
 11:49:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <d2b65883dc4895f197c4b4a69fbf27a063463412.1774029655.git.ljs@kernel.org>
In-Reply-To: <d2b65883dc4895f197c4b4a69fbf27a063463412.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 11:49:17 -0700
X-Gm-Features: AQROBzBdEWDwxPGuda-gZ28S-EX-AfB6_NSRFDtvf06b-OFXIblYAI4TAW9Gjg8
Message-ID: <CAJuCfpEOwe7uYJFPt-R52u5+vRSaXADK9XktXDrGGtL1DTd9Zw@mail.gmail.com>
Subject: Re: [PATCH v3 01/13] mm/huge_memory: simplify vma_is_specal_huge()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: e6muhwwc37dhffko1cwpqnugjarbc9qg
X-Rspamd-Queue-Id: 926B04000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774723769-920099
X-HE-Meta: U2FsdGVkX1/jcPLNDGSmA3ZxVaJ7YBCtuBUOO7X5d0jVuWle8zaIvB6vhBhYKak0+HFdaCe1axKXf6IoAW3K4jBa0G3dTJd5f3+w5eG3Sloq8kTjxoM54iUzbkKO/ot8VwrrgbHEy3zlQANpN7lB5fVbcBkSBwFOygJSrCg/WRPaXh5ZOH9sM4MiD/isvvmjtSxy2u6/q+LfEHOk5o10XRtlijAfhWcFtAzqAE43NRJQmaPZMtaSPDNkD0MxpK6//qf55uXzV+yjpfEjnbY5GIge3kpSbkB0bFU1NY6lcW/HhTYmdZoGMQdthxzohwQNv6Zx/notjSQILDE9ETTlbdWCghkI0wA3ABqneEz00HU4NCz7hZKdTt9rPfHo1H4sHXT/k7+gNQcTolRByzeaSnX4i11w6N9zcwVi04KJCUJRqYDL0WU3G2vZNPotynz2VFBjlXpkguQdLyWtW8ut2laKsBnfeMrMtNTmMzVljNTCzazMa+WqjQ5TXubb2lWTa2J0vMOU60JRJcPlBQJlYO30SXGgLPbODEvorZ22F6xAcFVV9btj8Uf0yYd+UqHHoANRdRsB/sc6/aWVdrtnWpw5gjsdM4LLWS/+jx8neulqv1l2HyxpcfRxPvEUvEk1ejS9SbGTlk8Khd0ZQ4ACqsUrG3aQwg4teXFnd2Okf0VdrjXuPIqt5OKyQxjFRSUujMdYHdmRr8XXeo8+W1BavDtNuIRVoNqXlzEWe/Kg135PPwBVm5R+mUFUJptaMHL90FmYCcBQ1O+dCk4P8pebJY5gsaqFQyvRpf5T76El07WHXbUhpsJKtq8sftlchKR6YJuMYkE+Bw6I7BVX3gfF4BOOEk442BYDVkBgJDSRaAQtgpjyba81z6U15cK7Sz/QQpQauAOsEQxTCwVHOxJ0AJIx1+IOp/4WuEQaGqTlDDseMmuHTx5tBVeGIjY2DLECkfLX2NrmG977xJzyaSV
 5pBIZ6Hk
 zcGnPQiQEFoiIRErLMtGYZJcvtjDDqcQhxpnRK11jmKlCvhbtW7ZrTKMgesVVUnN4dvapEWEJ01fGSm3e7M4JRfBUAYGqYnXRp8rBIXlk/azzmbEoxhUwsbXpUzU704TDQgMSukMoYkCwN+tonm/ciPGG8KJkoVcoH6Rx3GO7S4nNGJjFpFIrdEeInO3kW5dB4YGuUOWYduvZOg6iKJvyZSKvnm87bp4906mzspqYPsew/a/+MiX/vu6mlGd8dmNclbKnS4giYjA8BPFXDIdlrFeIGVN09bd8eDQYTUX5Jpr7sx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:07=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> This function is confused - it overloads the term 'special' yet again,
> checks for DAX but in many cases the code explicitly excludes DAX before
> invoking the predicate.
>
> It also unnecessarily checks for vma->vm_file - this has to be present fo=
r
> a driver to have set VMA_MIXEDMAP_BIT or VMA_PFNMAP_BIT.
>
> In fact, a far simpler form of this is to reverse the DAX predicate and
> return false if DAX is set.
>
> This makes sense from the point of view of 'special' as in
> vm_normal_page(), as DAX actually does potentially have retrievable
> folios.
>
> Also there's no need to have this in mm.h so move it to huge_memory.c.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/huge_mm.h |  4 ++--
>  include/linux/mm.h      | 16 ----------------
>  mm/huge_memory.c        | 30 +++++++++++++++++++++++-------
>  3 files changed, 25 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 8d801ed378db..af726f0aa30d 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -83,7 +83,7 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr=
;
>   * file is never split and the MAX_PAGECACHE_ORDER limit does not apply =
to
>   * it.  Same to PFNMAPs where there's neither page* nor pagecache.
>   */
> -#define THP_ORDERS_ALL_SPECIAL         \
> +#define THP_ORDERS_ALL_SPECIAL_DAX     \
>         (BIT(PMD_ORDER) | BIT(PUD_ORDER))
>  #define THP_ORDERS_ALL_FILE_DEFAULT    \
>         ((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))
> @@ -92,7 +92,7 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr=
;
>   * Mask of all large folio orders supported for THP.
>   */
>  #define THP_ORDERS_ALL \
> -       (THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FI=
LE_DEFAULT)
> +       (THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL_DAX | THP_ORDERS_AL=
L_FILE_DEFAULT)
>
>  enum tva_type {
>         TVA_SMAPS,              /* Exposing "THPeligible:" in smaps. */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8aadf115278e..6b07ee99b38b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5078,22 +5078,6 @@ long copy_folio_from_user(struct folio *dst_folio,
>                            const void __user *usr_src,
>                            bool allow_pagefault);
>
> -/**
> - * vma_is_special_huge - Are transhuge page-table entries considered spe=
cial?
> - * @vma: Pointer to the struct vm_area_struct to consider
> - *
> - * Whether transhuge page-table entries are considered "special" followi=
ng
> - * the definition in vm_normal_page().
> - *
> - * Return: true if transhuge page-table entries should be considered spe=
cial,
> - * false otherwise.
> - */
> -static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
> -{
> -       return vma_is_dax(vma) || (vma->vm_file &&
> -                                  (vma->vm_flags & (VM_PFNMAP | VM_MIXED=
MAP)));
> -}
> -
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
>
>  #if MAX_NUMNODES > 1
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e90d08db219d..2775309b317a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -103,6 +103,14 @@ static inline bool file_thp_enabled(struct vm_area_s=
truct *vma)
>         return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>  }
>
> +/* If returns true, we are unable to access the VMA's folios. */
> +static bool vma_is_special_huge(const struct vm_area_struct *vma)
> +{
> +       if (vma_is_dax(vma))
> +               return false;
> +       return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> +}
> +
>  unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>                                          vm_flags_t vm_flags,
>                                          enum tva_type type,
> @@ -116,8 +124,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_ar=
ea_struct *vma,
>         /* Check the intersection of requested and supported orders. */
>         if (vma_is_anonymous(vma))
>                 supported_orders =3D THP_ORDERS_ALL_ANON;
> -       else if (vma_is_special_huge(vma))
> -               supported_orders =3D THP_ORDERS_ALL_SPECIAL;
> +       else if (vma_is_dax(vma) || vma_is_special_huge(vma))
> +               supported_orders =3D THP_ORDERS_ALL_SPECIAL_DAX;
>         else
>                 supported_orders =3D THP_ORDERS_ALL_FILE_DEFAULT;
>
> @@ -2338,7 +2346,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_=
area_struct *vma,
>                                                 tlb->fullmm);
>         arch_check_zapped_pmd(vma, orig_pmd);
>         tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> -       if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
> +       if (vma_is_special_huge(vma)) {
>                 if (arch_needs_pgtable_deposit())
>                         zap_deposited_table(tlb->mm, pmd);
>                 spin_unlock(ptl);
> @@ -2840,7 +2848,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_=
area_struct *vma,
>         orig_pud =3D pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fu=
llmm);
>         arch_check_zapped_pud(vma, orig_pud);
>         tlb_remove_pud_tlb_entry(tlb, pud, addr);
> -       if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
> +       if (vma_is_special_huge(vma)) {
>                 spin_unlock(ptl);
>                 /* No zero page support yet */
>         } else {
> @@ -2991,7 +2999,7 @@ static void __split_huge_pmd_locked(struct vm_area_=
struct *vma, pmd_t *pmd,
>                  */
>                 if (arch_needs_pgtable_deposit())
>                         zap_deposited_table(mm, pmd);
> -               if (!vma_is_dax(vma) && vma_is_special_huge(vma))
> +               if (vma_is_special_huge(vma))
>                         return;
>                 if (unlikely(pmd_is_migration_entry(old_pmd))) {
>                         const softleaf_t old_entry =3D softleaf_from_pmd(=
old_pmd);
> @@ -4517,8 +4525,16 @@ static void split_huge_pages_all(void)
>
>  static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct =
*vma)
>  {
> -       return vma_is_special_huge(vma) || (vma->vm_flags & VM_IO) ||
> -                   is_vm_hugetlb_page(vma);
> +       if (vma_is_dax(vma))
> +               return true;
> +       if (vma_is_special_huge(vma))
> +               return true;
> +       if (vma_test(vma, VMA_IO_BIT))
> +               return true;
> +       if (is_vm_hugetlb_page(vma))
> +               return true;
> +
> +       return false;
>  }
>
>  static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
> --
> 2.53.0
>

