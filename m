Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8850D6E2CA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E466B0088; Thu, 18 Dec 2025 12:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 157E36B0098; Thu, 18 Dec 2025 12:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067226B009B; Thu, 18 Dec 2025 12:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6F1A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:49:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D31C1A029F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:49:43 +0000 (UTC)
X-FDA: 84233329446.28.39B4D4A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CA241A0003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:49:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=d9TBZcwh;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766080181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEGX9NCRxVFvkAo1SyCOWmoT8Y8UVkLNsscKPRE6j7c=;
	b=YMPwDlURB5IkIAltmChDPRUa6IL7gNrWn3kXcbjWmHKKrcBJanXlqo7PTEWUZykFknl0FU
	qocub/N4gPhm1/Jc6Y28lOYLl28n0z96zGN7mnrff8PpEIa7PUNYxDrLV4mfEdnlkKUlej
	cDaqAFfp6sehsNMOlpXLFVcGWFceXnU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=d9TBZcwh;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766080181; a=rsa-sha256;
	cv=none;
	b=3Y54wo2rTlNZuTTXXmpBuwMxGnafvn/X8qT/pV8COqv4mLKTsemPBQEzJX7EfGNPjU7jMn
	yrM61Jyvt/ZoRaVY4hKXgtWHKe8RW1OT9slKEWx0J8qtv7DWF56bu9HOhvFSkSqntIO+rv
	hwLS8AOx+5DXBgyS4BIaTSaFwXdgZQI=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64981b544a1so1229358a12.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766080180; x=1766684980; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xEGX9NCRxVFvkAo1SyCOWmoT8Y8UVkLNsscKPRE6j7c=;
        b=d9TBZcwhdpRwCc6sT2rqp/+G3AXpwGlzd/X8kR3hN741FkUNKCkSlIIK5Z9HaW4AgL
         kXK2Q4VBYXKqtkw62uQI52ThGGK4hqrhvRmfbnwm2Ud25SwI6pwzsprQ5uOe1GrH1nJw
         tXC0e48/7+bDLt9ZLXh/n5Yb5e0XE8nOUbQpHa/U9bN+5VI7trQmnMLkOi43vYuciY5k
         fa9DB69ZKtwxaoyDzSmAgP9oJ3DJ2Rk74meQlC9gFEBQ/0b7HnpuauBHDkg22jRWLkw4
         TLRiHdKNAlczCEoyQqsBprZRkZFbhdayMRF6PGdaMfp6xe5r8o7LocqIjFMDYsdhPHYs
         onRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766080180; x=1766684980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xEGX9NCRxVFvkAo1SyCOWmoT8Y8UVkLNsscKPRE6j7c=;
        b=YRMrRBruExoJHEa6RjFCtpUlfT5FGwRhhIcoNzAYsSPsEIp45jtwJz4g/jez7Mh07U
         dP+utTqDVuUVdRSDAmbYUFCD6e/FogFu+c4H9QBBdAvk+t1oe3ckudBZ4fPkE025kQj8
         gyuhzhAK/7WMm8yZue+/eGaMQGgsgdlJU7CtWGnLf4xSKYbnYZWt4ZTjQ121uQAYQ0em
         nQK0QYzkwRGfyrbwsvGJqH2OPY4RegP2yf5HFx59VBc5qFDrU07rtv4OHprxDLE3Gk6E
         nE3GzrZh8H8kO2wDFeoHU+YBFn8OMw1LUjCSnxK5QlCgCpamfmT9MuJB39rxn/JnXCqW
         Pbvw==
X-Gm-Message-State: AOJu0YwDWaZ7z29++eeAWT7H3eDKMjojPSvBn8m5jXFv2CH/xgoDfm0M
	woSfh6f5oZmv2x8+wuz+fu4n121jAUvR5+MiqpNIDnyiopYpVnfIXHZ0Mv0uhFcUxQ9hhKY82of
	ZtkQPC2WHeKFrACFoZ3P8DAqVbetpPVxdIjVR8krJ/Q==
X-Gm-Gg: AY/fxX4H+bRQXzNZ8DtAcMsoAzG9aDKGT7Gu/VGrX2uU2O5UARntucEdAl3EDRikGTa
	WVojDjxoAcOCSfuDAyxc2eo8kZfG9B5dOh1QRfYfs/nyBK1vAoH6LcSea3MBEwfCnwd8aF1JLJL
	H994OxpvGRp+aWyqjc+Wp+ZizuaXVzGUZcbK+JRH01u0I1gpmIB215UknCTRxXK1HyopzO4F/q4
	vKrIz8+szhyC0XodZBHiZ1NsWVCXbBN/SON00G+E+StGpyewQdOSgPFqtnl/69v19U1MQNGGSzg
	ys4OZFoydbJMCJ63lj6Wp8LE
X-Google-Smtp-Source: AGHT+IGj1ZcHTui7KBWUYP4FXCtel/5ayalcHtcXFNH9hEXSeqZ0F+Z3lWPo8TWqbx8PXpNtXrjwPKCaynSUAFZ631g=
X-Received: by 2002:a05:6402:1e92:b0:649:8b6f:99c5 with SMTP id
 4fb4d7f45d1cf-64b8eb7194amr231643a12.15.1766080179958; Thu, 18 Dec 2025
 09:49:39 -0800 (PST)
MIME-Version: 1.0
References: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
 <20251219-pgtable_check_v18rebase-v18-1-755bc151a50b@linux.ibm.com>
In-Reply-To: <20251219-pgtable_check_v18rebase-v18-1-755bc151a50b@linux.ibm.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 18 Dec 2025 12:49:03 -0500
X-Gm-Features: AQt7F2r7kiXa3gHIKUaDejuDxi7v3d-8CVx2-W_EwfFsV1tLHpl2uarz70Sl-ZA
Message-ID: <CA+CK2bA-3p1iy9ryaQSthV0MhpxzuMVK91F1YF45qw90PUtG3g@mail.gmail.com>
Subject: Re: [PATCH v18 01/12] arm64/mm: Add addr parameter to __set_ptes_anysz()
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>, 
	Christophe Leroy <chleroy@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, x86@kernel.org, 
	Nicholas Miehlbradt <nicholas@linux.ibm.com>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, Srish Srinivasan <ssrish@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: h9ftbrjby4ot4rwb4psz5ndmffyg5axr
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CA241A0003
X-HE-Tag: 1766080181-754726
X-HE-Meta: U2FsdGVkX19eYvJIqs3DbBpfOXqKNt4nXVRYEVe4jSEsJfKuGp7n+X7Dd4aKGaQeGIWwHB/Rs66iAFU98v8xZ+7HFMxOmu4tBhk4ThlTEZGOhyx9+eHKbUHX0KJ4DruQsretmC9J9PkFSyFgTGNlOctd4AR4SZ2uRKOummdooInwu5k9l6YmdkasSSojOmmSfbU5egTQmsYI5qweA59WaBieWGN14Ng8abNTpYlvXmvdUrwhLzSS0klGirkGdL0YHvPx6naGeFrDlixhno3dYNHKUxX4kYBa3OHjG3hkwv3xPFejfaopKFFNc4GEMNhDKNrPzkyXHF9ns4Zk4mwlibXn6ZV3Xj3Pk+BDXCtjxqgTmICA52faXP1GY4tiAGK7jMEHmwI8+laHKic3g/5OKbdqx692k5Vi5y0P4TTBcjXy04sd211kWtE3zpa9IDLc/hfvZyTr4VEezKuo+GFcXxUu+qG+rf0DvRP0owH7vvHqe+c3w2i01lXqwToTgMRDlt9SXsmH6slUlSXAikzOOzpLsEq96YLUpJXOGawY2hRBjQP92qLV8itigABXQHx89wnnlVn7IFbIsqLW9RFjy3brVP11jjtgP0n44tbrDIE/tmSoW/Lm6urxhuFJoh38Q01K1XzKU9QwQLppN8XSXzF9xCLwrG0zrRSyI2f3NkG8SDLQYfndjWkxgdt2AmUGU8QuUblJOwAVjvCgEuueA5Opvk9dKdMUzGP4mV9+SaO7ltljH6dYLCA/ULu0eZeJWBlHjLdUMxuazsOTLfkcfW6f0ANA8+/aEmdBadS3bMixm+UbY0Wkt6ZAbIrcScqR83BXh4wbJcn6A0XKDNXnT1LEAQnmOEWydCNpmxI9WTD5AzhqbDs1yJ8yT4fsIIZT7YM2KQ0+BE8pzRciN6x919m4Eh0oUwKFmEgc86MHQe7Kfa4X9e62GW4jqKVzTCdMOXfySTnHL3l0iAyhwEd
 Hy6UOQf9
 JSv8eqGuwFkDp3SmxeHLtcx42p2tx6uV+JBegt/qAHLPMjFxeiaO4/1u4LHWIlO17kAEkRyhmOjSQqBzHmQygiImgWbPgkmpIDExpRLzNfu66gdImHwfqGOYi9smFe/gZHup3ZDPVoUsWh9ICAlkOSBVHjgu+8Xv0czaaIHf/5Noe75RlCrdBst7wDllI21iQRnUiAb5UpyjjqL3P4sOoBRDrk9BICynrTGk2wmffzRFBjuYMqSL51Aq0YuBp+kywPHdi87Sr+CW/DpQFHypRqi8rz6fluwIDbZ6kWwr+zu894jODq9s4CU4KJAa2jhW9jsveSeCmzZ8bm/5E8f7HvpXTPyilUbLwQVq25rqPqICprU8btda/K3d5rkZ0OooQ+tORcEBQNQSzd/XngDmIQhQFWQrkjNIOUav9O0ZDKSMy2Qypt0yMjdIfrqYj0nv9qfrgAXHYv5zbxiSUI9qzgFdnhMRM7ZuPHiTA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 12:10=E2=80=AFPM Andrew Donnellan <ajd@linux.ibm.co=
m> wrote:
>
> To provide support for page table check on powerpc, we need to reinstate =
the
> address parameter in several functions, including
> page_table_check_{ptes,pmds,puds}_set().
>
> In preparation for this, add the addr parameter to arm64's __set_ptes_any=
sz()
> and change its callsites accordingly.
>
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

> ---
> v15: new patch
> v16: rebase
> ---
>  arch/arm64/include/asm/pgtable.h | 19 ++++++++-----------
>  arch/arm64/mm/hugetlbpage.c      | 10 +++++-----
>  2 files changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
> index 445e18e92221c98eef717888aeac71d1d6b1da06..52f3ea07427cef399e68bea0d=
bab39d03ea83060 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -673,8 +673,8 @@ static inline pgprot_t pud_pgprot(pud_t pud)
>         return __pgprot(pud_val(pfn_pud(pfn, __pgprot(0))) ^ pud_val(pud)=
);
>  }
>
> -static inline void __set_ptes_anysz(struct mm_struct *mm, pte_t *ptep,
> -                                   pte_t pte, unsigned int nr,
> +static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long =
addr,
> +                                   pte_t *ptep, pte_t pte, unsigned int =
nr,
>                                     unsigned long pgsize)
>  {
>         unsigned long stride =3D pgsize >> PAGE_SHIFT;
> @@ -709,26 +709,23 @@ static inline void __set_ptes_anysz(struct mm_struc=
t *mm, pte_t *ptep,
>         __set_pte_complete(pte);
>  }
>
> -static inline void __set_ptes(struct mm_struct *mm,
> -                             unsigned long __always_unused addr,
> +static inline void __set_ptes(struct mm_struct *mm, unsigned long addr,
>                               pte_t *ptep, pte_t pte, unsigned int nr)
>  {
> -       __set_ptes_anysz(mm, ptep, pte, nr, PAGE_SIZE);
> +       __set_ptes_anysz(mm, addr, ptep, pte, nr, PAGE_SIZE);
>  }
>
> -static inline void __set_pmds(struct mm_struct *mm,
> -                             unsigned long __always_unused addr,
> +static inline void __set_pmds(struct mm_struct *mm, unsigned long addr,
>                               pmd_t *pmdp, pmd_t pmd, unsigned int nr)
>  {
> -       __set_ptes_anysz(mm, (pte_t *)pmdp, pmd_pte(pmd), nr, PMD_SIZE);
> +       __set_ptes_anysz(mm, addr, (pte_t *)pmdp, pmd_pte(pmd), nr, PMD_S=
IZE);
>  }
>  #define set_pmd_at(mm, addr, pmdp, pmd) __set_pmds(mm, addr, pmdp, pmd, =
1)
>
> -static inline void __set_puds(struct mm_struct *mm,
> -                             unsigned long __always_unused addr,
> +static inline void __set_puds(struct mm_struct *mm, unsigned long addr,
>                               pud_t *pudp, pud_t pud, unsigned int nr)
>  {
> -       __set_ptes_anysz(mm, (pte_t *)pudp, pud_pte(pud), nr, PUD_SIZE);
> +       __set_ptes_anysz(mm, addr, (pte_t *)pudp, pud_pte(pud), nr, PUD_S=
IZE);
>  }
>  #define set_pud_at(mm, addr, pudp, pud) __set_puds(mm, addr, pudp, pud, =
1)
>
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 1d90a7e753336d86314fee0f753e8779d6a6bc12..1003b502075208d4252c27ffd=
acb1aaf4928639b 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -225,8 +225,8 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned l=
ong addr,
>         ncontig =3D num_contig_ptes(sz, &pgsize);
>
>         if (!pte_present(pte)) {
> -               for (i =3D 0; i < ncontig; i++, ptep++)
> -                       __set_ptes_anysz(mm, ptep, pte, 1, pgsize);
> +               for (i =3D 0; i < ncontig; i++, ptep++, addr +=3D pgsize)
> +                       __set_ptes_anysz(mm, addr, ptep, pte, 1, pgsize);
>                 return;
>         }
>
> @@ -234,7 +234,7 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned l=
ong addr,
>         if (pte_cont(pte) && pte_valid(__ptep_get(ptep)))
>                 clear_flush(mm, addr, ptep, pgsize, ncontig);
>
> -       __set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
> +       __set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
>  }
>
>  pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
> @@ -449,7 +449,7 @@ int huge_ptep_set_access_flags(struct vm_area_struct =
*vma,
>         if (pte_young(orig_pte))
>                 pte =3D pte_mkyoung(pte);
>
> -       __set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
> +       __set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
>         return 1;
>  }
>
> @@ -473,7 +473,7 @@ void huge_ptep_set_wrprotect(struct mm_struct *mm,
>         pte =3D get_clear_contig_flush(mm, addr, ptep, pgsize, ncontig);
>         pte =3D pte_wrprotect(pte);
>
> -       __set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
> +       __set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
>  }
>
>  pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>
> --
> 2.52.0
>
>

