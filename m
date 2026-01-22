Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC721C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB716B0173; Thu, 22 Jan 2026 07:17:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2BF6B0174; Thu, 22 Jan 2026 07:17:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B346B0175; Thu, 22 Jan 2026 07:17:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E04076B0173
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:17:33 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E2F41A028D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:17:33 +0000 (UTC)
X-FDA: 84359500386.21.7F9C9F4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 19D40C0012
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:17:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fxr0chao;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769084251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhMArfCu/iqSdQPsNlyImFzuioozcnAHNjZIal/dIk8=;
	b=YK3BFaSmQXK85gIh16K5IpvZhVyj2RU8ldYqPLEogaUr9BbchaFDdFDmGU3gC0I+qr+hhw
	RysjTdxbhmJnGVU6tI7GQk/cBvCvfCnIjFeUWLjWF4d4wM9CAnwZJabYXjXJcpgANYhFzd
	4ORIbXaFYujBBGjtvYT6awvXQfCzRWI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fxr0chao;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769084251; a=rsa-sha256;
	cv=none;
	b=LGUE+iR6m1CF59VT2cUzSFqle4X4VWgekqgcXX8IhQIQd+QrGOAdfTi5dyXK8lNmNNTOqV
	owd8yfIjSg6/CZoQ4mdz6sRK3zQHx3PdyY9WjFjLab8lwvMsq34zMyYHbE195VLkdeVV3+
	XC1yH6BQk0kqV6DkeyF+hE/h+n+Plag=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769084250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uhMArfCu/iqSdQPsNlyImFzuioozcnAHNjZIal/dIk8=;
	b=Fxr0chaoQ6KLn24oJMmNUof33YT7RijvK6Jfle6PTxqftuUfKY7vfs8DGL9HaACfSgAuQh
	IVf2hwBbTxsd8hTe79NyfYVYWbOaJrjE8zsJVHDwHvYGUXd453mtGFw8OjqrJNhR/h0U29
	auYh0OZYzMstpmM2TbGOuCp4LAfqheE=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-fcSZ6UjCN_Ssi0RNuP9DzQ-1; Thu, 22 Jan 2026 07:17:29 -0500
X-MC-Unique: fcSZ6UjCN_Ssi0RNuP9DzQ-1
X-Mimecast-MFC-AGG-ID: fcSZ6UjCN_Ssi0RNuP9DzQ_1769084248
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7941ad16eeaso12933527b3.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:17:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769084248; x=1769689048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uhMArfCu/iqSdQPsNlyImFzuioozcnAHNjZIal/dIk8=;
        b=iJxbz+CZsxVl539Fv1PyB8FOgb1YL0X/0/VZqy53y/M8hEp8yGTXqPHDl2LcSCg7SC
         BAdoGRe4NGaC5EqjxTAWkTBC+sHqcJbPJnV4YQQaKk6/BAVYwe2WXrBo1UIuQAMy6Oxr
         c2MTxF/4oqlbtVwoB2Ev+IFPhuCa0GncKzH23JGBKKREZiDdUGevMrdy/TWwELPzgWns
         j9hWoo3reN9HVBnhUSJ3CynBY/SKObyW/0QLszDOLH4dOAxwMO2yefrMuq0hPieK+rlo
         rpFNc4cLxjaToW6lbwNq+9bnsrGnFcxFS+uJ0SQ+PR+4IBvybpeIsoola+j9gUSfoceW
         y6QQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMgJjg/+U7ZEwRhGJgdpn9fq3/juOIjGn264lKBj3zXqS+2oR1huK6lQkN+FVVaA3P6sHaZALJPQ==@kvack.org
X-Gm-Message-State: AOJu0YzTtCNsdjWK74xrb0Iezche+xflsxjG0TfsP7zb/pYClxQVwe6N
	Wh5WkGF5xOJVsjQyQZ04oiGUPNDuXa5XppmMSXXn8fSulz7EyWMN622DcSTUw/S3iN6dXRXzPgq
	HMqbCLJdKw6cu7gvV0QlbwRgbbFHVPRPaQYaUWE9gmT5/WpoOIPxHd4f5osrJgJ84LOtrYKUQ8+
	Xqvunx/lRgyJXYIWJgb7d8SZJy0uY=
X-Gm-Gg: AZuq6aJ1Vg4DrmHLwCTS7nMR5WplD340C+WcvN5FH0/sEyuhyyR0b/qwIuph3cXfmCz
	hZznmv9Vwc9GsWH01Tp67oX/BRXgrP7UtoPeaZpBeoKsfW7Gn9qskCgVNTEdU+mcxvIvduxb65j
	Gz5rI0eeGjlKAZa2HnCNrWrxmdp8mzSuQiDmMg794pkqMsQ0VpwQJa2GgJXB/qEukIQfmMWAaxB
	SmYbk4V
X-Received: by 2002:a05:690c:dc2:b0:794:c2:5e55 with SMTP id 00721157ae682-79400c25f2bmr90233547b3.17.1769084248253;
        Thu, 22 Jan 2026 04:17:28 -0800 (PST)
X-Received: by 2002:a05:690c:dc2:b0:794:c2:5e55 with SMTP id
 00721157ae682-79400c25f2bmr90233337b3.17.1769084247882; Thu, 22 Jan 2026
 04:17:27 -0800 (PST)
MIME-Version: 1.0
References: <20260118192253.9263-4-shivankg@amd.com> <20260118192253.9263-10-shivankg@amd.com>
In-Reply-To: <20260118192253.9263-10-shivankg@amd.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 22 Jan 2026 05:17:01 -0700
X-Gm-Features: AZwV_QhBn8_Xm-_mpY48XwoexFaU0P70k1w4yQIPdlK0qHbhw8TRVL5n48B0CI4
Message-ID: <CAA1CXcD7EmDO1v-x4uw4MHqg0r3hNPPXDZBqDsdXrpD08+xh9A@mail.gmail.com>
Subject: Re: [PATCH V3 3/5] mm/khugepaged: change collapse_pte_mapped_thp() to
 return void
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z4-8WciVXjc8aaFtJnSwjpBdXhCdJPBhzjOOoTTE2zs_1769084248
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 19D40C0012
X-Stat-Signature: 4mhojqgewpwqf3moxay1rma4tfyqhgwi
X-Rspam-User: 
X-HE-Tag: 1769084250-960140
X-HE-Meta: U2FsdGVkX1/NjxD8IfzGgZozSMnXLuNvyBCrAPVieE4wpoP7mT5pOnzSdVVp4rW4msUu09FceTjFrIfxBekEWQldMT414+tPIujMniCbA6NSl6/dQLFdvFXhtj6Ji3th//5ajwmL08A3rhmK7jeDVbDTlCLz215W4D8xo6f+86S2WycAU67OeCr0hltCawXy5OnN4zgdadcwR+ma3YhXz4mlBnuJIvKrAtQVMgYE3u50jZk4WnuZSS0YSt7lFjhkeJJUheWOPkJKAiehF8OkFCSGZ1Fch8KaQzRlTpF9yA6ZBXQ3RwPuPFtI2uiqt7DAVRQvm80qRV5GTEWFC3tIT6+gK4RGzi19d7guMoLfjYk8oaGL6Novp5Dm8FLkz4mWCroTq9JFUmlyb/HYzBDstXUgzaPeDjLws65nyQKIjsInVoPzwp83M5k27CnbX8VcpFBk+/ymhBhUg9GxZm/B3uGzPudsmWCEHxlohuMmxDc8zsfaFGp4TbmiQLMYVAn6u4l2Mppij5DK2gDiNep2DpuvU3DHFt1HCF9gpIaNuxh91UFgdpN4ZZtn1Dk7KQGyRX61CeTT/S4ZzCbbrmcZXXbLGl0bUrS7YBkMq7ng2JI5Yrx9cjugp80m4Ux0MLNm6jViWMNbW1rTaVGoLHbRRl98k17RywVw2fPbz/a68zNntUyt1C8C6m1Bk14TypKH5dQkf7BrApoBJTIN5UhLIVLfxHM6QiG8xRVdcfuOaXyFsOzCCoXSmJQuVGEnf6ryGRwuhhGSInPqGzZDL0bH4+D1OILNjDBxvCbkICHFJz0ESm5OfMM4TbDsHAsABnz4Tq5uzyYpja2cdd3G2MQKZJjNx3xcTt38ds37EGrsNFb55IOhQZFekBTZ4A4pzkr13Jq5Ch+/NXOK6o5ed9P0ZLGN7WEqfwZ0ftoKeXO1sHETHBl+bM4xbMg8eR49pmZPuvNwkFBD+V709FU41C/
 P9wr0KnD
 vhDyLUFrvSacRcMZDhcdASnjV1xanIfcuhTPRyJvln/iG0A8SshzCXNiqImNF67irhEA4CEawHSkGSLiTY7kKs6HCzHKxCLCQuP9oSCU+SvZ8GEURQzQ8R98w3/4nMoZCihfE2mgOZfydg5es7ljpBmxGr2S8dRdGEIXrIB5+ya5pNuIvH03tiAdouU1vksu9pm+LzHVJOMvCQjLKZbHvPGmK1jAPz/wKVP5756DdiDMh50rfQldoKAR9R8406VGzQggXy4AXu2onJsWSU2NtFrNOl+4jwYD1RnutRRY6SdD29xY+9j5ksHbtqgAxEBU7JXQaHFBG2LdeUVIKVPA8Hlo4HuBjIP2plQAQoiD9wwXWLASAsfCIrGmnjTYPpwYMluegaChpJvy//SODpPszX8SSY422vEO27WxjvK8lzsHRWUY3rn+O6BH+tg/TVpRLHp7l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 12:28=E2=80=AFPM Shivank Garg <shivankg@amd.com> wr=
ote:
>
> The only external caller of collapse_pte_mapped_thp() is uprobe, which
> ignores the return value. Change the external API to return void to
> simplify the interface.
>
> Introduce try_collapse_pte_mapped_thp() for internal use that preserves
> the return value. This prepares for future patch that will convert
> the return type to use enum scan_result.
>
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Acked-by: Lance Yang <lance.yang@linux.dev>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

LGTM!

Tested-by: Nico Pache <npache@redhat.com>
Reviewed-by: Nico Pache <npache@redhat.com>

> ---
>
>  include/linux/khugepaged.h |  9 ++++-----
>  mm/khugepaged.c            | 40 ++++++++++++++++++++++----------------
>  2 files changed, 27 insertions(+), 22 deletions(-)
>
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index eb1946a70cff..d7a9053ff4fe 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -17,8 +17,8 @@ extern void khugepaged_enter_vma(struct vm_area_struct =
*vma,
>                                  vm_flags_t vm_flags);
>  extern void khugepaged_min_free_kbytes_update(void);
>  extern bool current_is_khugepaged(void);
> -extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long a=
ddr,
> -                                  bool install_pmd);
> +void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
> +               bool install_pmd);
>
>  static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struc=
t *oldmm)
>  {
> @@ -42,10 +42,9 @@ static inline void khugepaged_enter_vma(struct vm_area=
_struct *vma,
>                                         vm_flags_t vm_flags)
>  {
>  }
> -static inline int collapse_pte_mapped_thp(struct mm_struct *mm,
> -                                         unsigned long addr, bool instal=
l_pmd)
> +static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
> +               unsigned long addr, bool install_pmd)
>  {
> -       return 0;
>  }
>
>  static inline void khugepaged_min_free_kbytes_update(void)
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 93ce39915f4a..17f3f0043368 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1477,20 +1477,8 @@ static int set_huge_pmd(struct vm_area_struct *vma=
, unsigned long addr,
>         return SCAN_SUCCEED;
>  }
>
> -/**
> - * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
> - * address haddr.
> - *
> - * @mm: process address space where collapse happens
> - * @addr: THP collapse address
> - * @install_pmd: If a huge PMD should be installed
> - *
> - * This function checks whether all the PTEs in the PMD are pointing to =
the
> - * right THP. If so, retract the page table so the THP can refault in wi=
th
> - * as pmd-mapped. Possibly install a huge PMD mapping the THP.
> - */
> -int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
> -                           bool install_pmd)
> +static int try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned lo=
ng addr,
> +               bool install_pmd)
>  {
>         int nr_mapped_ptes =3D 0, result =3D SCAN_FAIL;
>         unsigned int nr_batch_ptes;
> @@ -1711,6 +1699,24 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, =
unsigned long addr,
>         return result;
>  }
>
> +/**
> + * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
> + * address haddr.
> + *
> + * @mm: process address space where collapse happens
> + * @addr: THP collapse address
> + * @install_pmd: If a huge PMD should be installed
> + *
> + * This function checks whether all the PTEs in the PMD are pointing to =
the
> + * right THP. If so, retract the page table so the THP can refault in wi=
th
> + * as pmd-mapped. Possibly install a huge PMD mapping the THP.
> + */
> +void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
> +               bool install_pmd)
> +{
> +       try_collapse_pte_mapped_thp(mm, addr, install_pmd);
> +}
> +
>  /* Can we retract page tables for this file-backed VMA? */
>  static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
>  {
> @@ -2227,7 +2233,7 @@ static int collapse_file(struct mm_struct *mm, unsi=
gned long addr,
>
>         /*
>          * Remove pte page tables, so we can re-fault the page as huge.
> -        * If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_th=
p().
> +        * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mappe=
d_thp().
>          */
>         retract_page_tables(mapping, start);
>         if (cc && !cc->is_khugepaged)
> @@ -2480,7 +2486,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, int *result,
>                                         mmap_read_lock(mm);
>                                         if (hpage_collapse_test_exit_or_d=
isable(mm))
>                                                 goto breakouterloop;
> -                                       *result =3D collapse_pte_mapped_t=
hp(mm,
> +                                       *result =3D try_collapse_pte_mapp=
ed_thp(mm,
>                                                 khugepaged_scan.address, =
false);
>                                         if (*result =3D=3D SCAN_PMD_MAPPE=
D)
>                                                 *result =3D SCAN_SUCCEED;
> @@ -2845,7 +2851,7 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>                 case SCAN_PTE_MAPPED_HUGEPAGE:
>                         BUG_ON(mmap_locked);
>                         mmap_read_lock(mm);
> -                       result =3D collapse_pte_mapped_thp(mm, addr, true=
);
> +                       result =3D try_collapse_pte_mapped_thp(mm, addr, =
true);
>                         mmap_read_unlock(mm);
>                         goto handle_result;
>                 /* Whitelisted set of results where continuing OK */
> --
> 2.43.0
>


