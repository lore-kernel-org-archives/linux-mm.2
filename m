Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23250C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF996B0170; Thu, 22 Jan 2026 07:14:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86FD86B0172; Thu, 22 Jan 2026 07:14:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752296B0173; Thu, 22 Jan 2026 07:14:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5F46B0170
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:14:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16D99D25F2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:14:38 +0000 (UTC)
X-FDA: 84359493036.28.B0E5891
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A23E840009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:14:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gTY8ILWY;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769084075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVc63fzP8jYJOu4M36nOSwhzqNqPKt1gOJVpgrHGEmQ=;
	b=L+NkX/kOJ0XmJji3983Pi2oTdKzKi7eKky3vfph2O/qS2NEwwCAPvWb0LCSJadvu1XEHE5
	l5lXgf1PSnngbI1VSInzZC/95RJAvZXShnjelJSaWOQLrarm2FgiQLoFY7Zp8zbJjoQejH
	Zrv8vnzxAEqLwm2POkcZ69d6tyXhF1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769084075; a=rsa-sha256;
	cv=none;
	b=1+WiRXKQN+vuhbiUEr7trdceQHI+Q9VR5Ba947+LyQwEPklE5I4r3Xi8y8pdHybm8zeAlL
	kLi+vTF1SmgTkTGqQRHa2QGBXoTgm8UA5BjM3gUFeKeJz/EsyGLLqQuMNNceMeiJ4kYvsh
	RNKw6NMlNZQK95pErrt3oPZGT4RuRIQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gTY8ILWY;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769084075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fVc63fzP8jYJOu4M36nOSwhzqNqPKt1gOJVpgrHGEmQ=;
	b=gTY8ILWYkXW+CtL3VC+ewPX+PdzU3thYpVgzffWxduiZoE90aWphn0oLD4yz/2AHqJID9p
	1JxajGjAQzadW7SnEmzeMSGccc2J6QAo8SMW4IYJGKNjsP+44CWdpTyTjP0qZbiZb2p1sW
	0Wk18Y34qp/rtNNzyF2ZtLded68SGl4=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-8OOp5ZViPa2TzMLkC8VETQ-1; Thu, 22 Jan 2026 07:14:33 -0500
X-MC-Unique: 8OOp5ZViPa2TzMLkC8VETQ-1
X-Mimecast-MFC-AGG-ID: 8OOp5ZViPa2TzMLkC8VETQ_1769084073
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-644548b1d9aso1326079d50.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:14:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769084073; x=1769688873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fVc63fzP8jYJOu4M36nOSwhzqNqPKt1gOJVpgrHGEmQ=;
        b=NsrRQomno1TWuYS+wHznWidfbJurh2lVOrWxmgUqhS3yURjC6U1rqSeJRITXdVQ10S
         Es88736U5AZgsUkErqm1XMuBcOQWyaP8yZruEMlfx4i11EmqGSx03GKUcXq89IAQ3YMp
         7/oJuMqgp4ArMPUK0kJ0r94pfFRh7EUNUevvHjILBCWsl/tcEbD0AUYWOMxr1daU98p/
         b5goveC69tzUAxez3sNoT3wcVS5JqzTsjYYNN345HxVd+3IPqrzR14RfqwTXNvk3oXnA
         6mkk377nOEqLqKJ1VNzeo5GnS66YyIW9jciaw0NrQmKR9JtU0TxsQQoU4GPzUHIf3V9o
         +blA==
X-Forwarded-Encrypted: i=1; AJvYcCWgn/LtqUmhBgtjXcxPe+aU+WViHjGaBZxjMgF5hznKyJFRwM9VMWLg/PUixxz4GVmLV97bcNhyUg==@kvack.org
X-Gm-Message-State: AOJu0YxcjKFYNOPCD4rDVxGTZ8QfAcgdGpERV9gBRfsMeYgVvRIUxy/j
	rZJSoPrxbAkU9e8eN7KJsuMH5hB4gNdh1gARrlFyRRKvuy1ON2uQBMFEdHHRChiuLGELpJjhX2f
	8Y4/OEhPQaktbveJWzGzvakkNMjkDJyWn7Bor6bBVnVvNgmWH3pMn1IfmzthTH5FHqu3W+37J8z
	feoPPSl+E1pKIXcqMS2J8u192GPGY=
X-Gm-Gg: AZuq6aIqk6Kq30aQJAy3DOvDQHSoeKJ4pHINn4f1T84Nap6FEZYA3VmOiP90B76wCin
	MMJg309zG6S24rcrqscoo7hXaumMsW/+WG23U0buLkX72xAIQ5lM4Xx0eKDxUlffWZJ2/m4P+m5
	unUb335wICjRLTodwwC6QYAx0pf4H8jur4SHzbDTUT4uax1K9e8qTv6LvhOOPaxQNIzleo5J7oR
	0x2to0/
X-Received: by 2002:a05:690c:6209:b0:794:87a:fba7 with SMTP id 00721157ae682-7940a116c60mr146238487b3.15.1769084072969;
        Thu, 22 Jan 2026 04:14:32 -0800 (PST)
X-Received: by 2002:a05:690c:6209:b0:794:87a:fba7 with SMTP id
 00721157ae682-7940a116c60mr146237997b3.15.1769084072482; Thu, 22 Jan 2026
 04:14:32 -0800 (PST)
MIME-Version: 1.0
References: <20260118192253.9263-4-shivankg@amd.com> <20260118192253.9263-12-shivankg@amd.com>
In-Reply-To: <20260118192253.9263-12-shivankg@amd.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 22 Jan 2026 05:14:06 -0700
X-Gm-Features: AZwV_QjkvXSRyZYwsuEixLBEZunsyAhqEWm3V1WvL2iCvdVIhxDFRUeuUzlnaFM
Message-ID: <CAA1CXcCGgX0QjtQR3NT6m-kRNg2jDJo5-JEV0zYK3MDXZvoE3w@mail.gmail.com>
Subject: Re: [PATCH V3 4/5] mm/khugepaged: use enum scan_result for result
 variables and return types
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PCzkhgquTd5AE2QZ8EYdWNTJ7gWGiGwoocUHuFf9L9Y_1769084073
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A23E840009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8ps58kpp7x4cor46xi87hcadppfpjow8
X-HE-Tag: 1769084075-232957
X-HE-Meta: U2FsdGVkX19Zv+D5mCjg2i2v81H4GG9ma6WpSTja5oUTptaY4CMEiJjpne3/UlctIw58+2kT4iVqYO6vLGR3tklLsLYBdIicYvaIYsHz21HNDP3kU1jM+amheu08Zb3uLgJKvlIxV8xdh9hpc81nKt2+Wi25ZnLCmdZ/Fd4cU5nIb7GVn07gaGdcEV53lBL1fxKgSEba6pP0etTvc4NYsReJPuB3LcE92bMeeuMnUHd2lmRfmCuB0CP2GkKoNlVkNxL06R1X+bbRK4L2lVpagZS6LmvUffTo7HzX0iMbFCj+wvkXhmunsl/OAXUbw2b5hbqpd57XuBsUOo1RFQDRWfQg4AqSLLIYZZyT3RDpbbMxtAaYQcIO3BeZ3rP0GpdyBh4caRkHgCOZlFhxbGRs0kK2ZrfUIwBDBFHjcmoeCLIGBtq9XNnLc0qWjqhiSe0GejfUm7JaE42bT8r//i5jcEjSbgqeRmJ/2Z9WsMniTo5p6q1i6Q7enMwPzs2HWhKmSxReYVtSnQcsqtDfNhBd/Es0qVJrLomZeD26QP7P68YBc7U9z1pxUXH3zuk3t9kq4ZaTQktpz7rXNgqaXCsPrpBZfBUa2cGz0t53yhmlXxgNGQahvCwSSXnIDa7XvLM2bjefmaMCTcUbMN5UbM2WFU6eBcI3jo5HZcxZR05z7KwJq8QpFHy5WDiskAbbrQFHsbnB7hQkmN8LGZJAUST316papfxl4536Ylov/uw2dF45whBMH7IE+saN5bZyf9ZCqX3jre6UqO5aWdQeoCaINgNOt+Qxk9JyEuOluZEQ6FVSTNH23RDcyN8v4fu5/dZTpuLrvSgCj1sAO+KwIGpxe611ZabcEYu/K1JGz2WzKi59UZl2PXDNOIArodw2hjKa5BFJAjXVBfWpn/PpjfkOjlQrGaFi1NtHKN9Jlthu458ErahBIPbKVcvaSJqdwqmFdO2cBJfAdPm+jeh3e02
 wqSVFMDo
 /VxAq5lmBDgJiF6kEb1ZCFel+byqqskESjm+7/MLybJlr/dMs87RYN8oJE0KoZDeohbQN4UBpZ4V/D8K7abytY5bG2rzas6BNyWTK1RF4M73esLInKZBsiiU16N2EhFNnGlvPWOx3B2q8qYSuZYkhNm3uZxH8GDkWwkQLWZW/RBdbOmGC12GUm5a3GYzt7UvCi6fpE6IbW/HEroo9/Ba+e06IWfF8LS+4r2Hw9a4YvmD6CMV7ZIP53mo9cWiilyMnwh5TDxsvuj5I/tG/qg50TU3F0nJ9ekWYU5VUB05ggH16tjoJvlm51mBwnTio9eLY30mPNfZGFHCSG0rGHWsPZa1Hdt9qBRG9sVFq6TXqq64X2gP2Ty+xk/dXtL1Njudg0Yh5a1h8Fpizw508V09kp6yK3q4b/jCzV1o0dsOsXHZNmPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 12:31=E2=80=AFPM Shivank Garg <shivankg@amd.com> wr=
ote:
>
> Convert result variables and return types from int to enum scan_result
> throughout khugepaged code. This improves type safety and code clarity
> by making the intent explicit.
>
> No functional change.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

LGTM!

Tested-by: Nico Pache <npache@redhat.com>
Reviewed-by: Nico Pache <npache@redhat.com>

> ---
>  mm/khugepaged.c | 99 +++++++++++++++++++++++--------------------------
>  1 file changed, 46 insertions(+), 53 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 17f3f0043368..1667abae6d8d 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -537,17 +537,16 @@ static void release_pte_pages(pte_t *pte, pte_t *_p=
te,
>         }
>  }
>
> -static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> -                                       unsigned long start_addr,
> -                                       pte_t *pte,
> -                                       struct collapse_control *cc,
> -                                       struct list_head *compound_pageli=
st)
> +static enum scan_result __collapse_huge_page_isolate(struct vm_area_stru=
ct *vma,
> +               unsigned long start_addr, pte_t *pte, struct collapse_con=
trol *cc,
> +               struct list_head *compound_pagelist)
>  {
>         struct page *page =3D NULL;
>         struct folio *folio =3D NULL;
>         unsigned long addr =3D start_addr;
>         pte_t *_pte;
> -       int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, refer=
enced =3D 0;
> +       int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> +       enum scan_result result =3D SCAN_FAIL;
>
>         for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR;
>              _pte++, addr +=3D PAGE_SIZE) {
> @@ -780,13 +779,13 @@ static void __collapse_huge_page_copy_failed(pte_t =
*pte,
>   * @ptl: lock on raw pages' PTEs
>   * @compound_pagelist: list that stores compound pages
>   */
> -static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
> +static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct fol=
io *folio,
>                 pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
>                 unsigned long address, spinlock_t *ptl,
>                 struct list_head *compound_pagelist)
>  {
>         unsigned int i;
> -       int result =3D SCAN_SUCCEED;
> +       enum scan_result result =3D SCAN_SUCCEED;
>
>         /*
>          * Copying pages' contents is subject to memory poison at any ite=
ration.
> @@ -898,10 +897,8 @@ static int hpage_collapse_find_target_node(struct co=
llapse_control *cc)
>   * Returns enum scan_result value.
>   */
>
> -static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long a=
ddress,
> -                                  bool expect_anon,
> -                                  struct vm_area_struct **vmap,
> -                                  struct collapse_control *cc)
> +static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, un=
signed long address,
> +               bool expect_anon, struct vm_area_struct **vmap, struct co=
llapse_control *cc)
>  {
>         struct vm_area_struct *vma;
>         enum tva_type type =3D cc->is_khugepaged ? TVA_KHUGEPAGED :
> @@ -930,7 +927,7 @@ static int hugepage_vma_revalidate(struct mm_struct *=
mm, unsigned long address,
>         return SCAN_SUCCEED;
>  }
>
> -static inline int check_pmd_state(pmd_t *pmd)
> +static inline enum scan_result check_pmd_state(pmd_t *pmd)
>  {
>         pmd_t pmde =3D pmdp_get_lockless(pmd);
>
> @@ -953,9 +950,8 @@ static inline int check_pmd_state(pmd_t *pmd)
>         return SCAN_SUCCEED;
>  }
>
> -static int find_pmd_or_thp_or_none(struct mm_struct *mm,
> -                                  unsigned long address,
> -                                  pmd_t **pmd)
> +static enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
> +               unsigned long address, pmd_t **pmd)
>  {
>         *pmd =3D mm_find_pmd(mm, address);
>         if (!*pmd)
> @@ -964,12 +960,11 @@ static int find_pmd_or_thp_or_none(struct mm_struct=
 *mm,
>         return check_pmd_state(*pmd);
>  }
>
> -static int check_pmd_still_valid(struct mm_struct *mm,
> -                                unsigned long address,
> -                                pmd_t *pmd)
> +static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
> +               unsigned long address, pmd_t *pmd)
>  {
>         pmd_t *new_pmd;
> -       int result =3D find_pmd_or_thp_or_none(mm, address, &new_pmd);
> +       enum scan_result result =3D find_pmd_or_thp_or_none(mm, address, =
&new_pmd);
>
>         if (result !=3D SCAN_SUCCEED)
>                 return result;
> @@ -985,15 +980,14 @@ static int check_pmd_still_valid(struct mm_struct *=
mm,
>   * Called and returns without pte mapped or spinlocks held.
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
>   */
> -static int __collapse_huge_page_swapin(struct mm_struct *mm,
> -                                      struct vm_area_struct *vma,
> -                                      unsigned long start_addr, pmd_t *p=
md,
> -                                      int referenced)
> +static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm=
,
> +               struct vm_area_struct *vma, unsigned long start_addr, pmd=
_t *pmd,
> +               int referenced)
>  {
>         int swapped_in =3D 0;
>         vm_fault_t ret =3D 0;
>         unsigned long addr, end =3D start_addr + (HPAGE_PMD_NR * PAGE_SIZ=
E);
> -       int result;
> +       enum scan_result result;
>         pte_t *pte =3D NULL;
>         spinlock_t *ptl;
>
> @@ -1062,8 +1056,8 @@ static int __collapse_huge_page_swapin(struct mm_st=
ruct *mm,
>         return result;
>  }
>
> -static int alloc_charge_folio(struct folio **foliop, struct mm_struct *m=
m,
> -                             struct collapse_control *cc)
> +static enum scan_result alloc_charge_folio(struct folio **foliop, struct=
 mm_struct *mm,
> +               struct collapse_control *cc)
>  {
>         gfp_t gfp =3D (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpm=
ask() :
>                      GFP_TRANSHUGE);
> @@ -1090,9 +1084,8 @@ static int alloc_charge_folio(struct folio **foliop=
, struct mm_struct *mm,
>         return SCAN_SUCCEED;
>  }
>
> -static int collapse_huge_page(struct mm_struct *mm, unsigned long addres=
s,
> -                             int referenced, int unmapped,
> -                             struct collapse_control *cc)
> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigne=
d long address,
> +               int referenced, int unmapped, struct collapse_control *cc=
)
>  {
>         LIST_HEAD(compound_pagelist);
>         pmd_t *pmd, _pmd;
> @@ -1100,7 +1093,7 @@ static int collapse_huge_page(struct mm_struct *mm,=
 unsigned long address,
>         pgtable_t pgtable;
>         struct folio *folio;
>         spinlock_t *pmd_ptl, *pte_ptl;
> -       int result =3D SCAN_FAIL;
> +       enum scan_result result =3D SCAN_FAIL;
>         struct vm_area_struct *vma;
>         struct mmu_notifier_range range;
>
> @@ -1246,15 +1239,14 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,
>         return result;
>  }
>
> -static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> -                                  struct vm_area_struct *vma,
> -                                  unsigned long start_addr, bool *mmap_l=
ocked,
> -                                  struct collapse_control *cc)
> +static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> +               struct vm_area_struct *vma, unsigned long start_addr, boo=
l *mmap_locked,
> +               struct collapse_control *cc)
>  {
>         pmd_t *pmd;
>         pte_t *pte, *_pte;
> -       int result =3D SCAN_FAIL, referenced =3D 0;
> -       int none_or_zero =3D 0, shared =3D 0;
> +       int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> +       enum scan_result result =3D SCAN_FAIL;
>         struct page *page =3D NULL;
>         struct folio *folio =3D NULL;
>         unsigned long addr;
> @@ -1441,8 +1433,8 @@ static void collect_mm_slot(struct mm_slot *slot)
>  }
>
>  /* folio must be locked, and mmap_lock must be held */
> -static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
> -                       pmd_t *pmdp, struct folio *folio, struct page *pa=
ge)
> +static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigne=
d long addr,
> +               pmd_t *pmdp, struct folio *folio, struct page *page)
>  {
>         struct mm_struct *mm =3D vma->vm_mm;
>         struct vm_fault vmf =3D {
> @@ -1477,10 +1469,11 @@ static int set_huge_pmd(struct vm_area_struct *vm=
a, unsigned long addr,
>         return SCAN_SUCCEED;
>  }
>
> -static int try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned lo=
ng addr,
> +static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm=
, unsigned long addr,
>                 bool install_pmd)
>  {
> -       int nr_mapped_ptes =3D 0, result =3D SCAN_FAIL;
> +       enum scan_result result =3D SCAN_FAIL;
> +       int nr_mapped_ptes =3D 0;
>         unsigned int nr_batch_ptes;
>         struct mmu_notifier_range range;
>         bool notified =3D false;
> @@ -1862,9 +1855,8 @@ static void retract_page_tables(struct address_spac=
e *mapping, pgoff_t pgoff)
>   *    + unlock old pages
>   *    + unlock and free huge page;
>   */
> -static int collapse_file(struct mm_struct *mm, unsigned long addr,
> -                        struct file *file, pgoff_t start,
> -                        struct collapse_control *cc)
> +static enum scan_result collapse_file(struct mm_struct *mm, unsigned lon=
g addr,
> +               struct file *file, pgoff_t start, struct collapse_control=
 *cc)
>  {
>         struct address_space *mapping =3D file->f_mapping;
>         struct page *dst;
> @@ -1872,7 +1864,8 @@ static int collapse_file(struct mm_struct *mm, unsi=
gned long addr,
>         pgoff_t index =3D 0, end =3D start + HPAGE_PMD_NR;
>         LIST_HEAD(pagelist);
>         XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
> -       int nr_none =3D 0, result =3D SCAN_SUCCEED;
> +       enum scan_result result =3D SCAN_SUCCEED;
> +       int nr_none =3D 0;
>         bool is_shmem =3D shmem_file(file);
>
>         VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> @@ -2293,16 +2286,15 @@ static int collapse_file(struct mm_struct *mm, un=
signed long addr,
>         return result;
>  }
>
> -static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long =
addr,
> -                                   struct file *file, pgoff_t start,
> -                                   struct collapse_control *cc)
> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, u=
nsigned long addr,
> +               struct file *file, pgoff_t start, struct collapse_control=
 *cc)
>  {
>         struct folio *folio =3D NULL;
>         struct address_space *mapping =3D file->f_mapping;
>         XA_STATE(xas, &mapping->i_pages, start);
>         int present, swap;
>         int node =3D NUMA_NO_NODE;
> -       int result =3D SCAN_SUCCEED;
> +       enum scan_result result =3D SCAN_SUCCEED;
>
>         present =3D 0;
>         swap =3D 0;
> @@ -2400,7 +2392,7 @@ static int hpage_collapse_scan_file(struct mm_struc=
t *mm, unsigned long addr,
>         return result;
>  }
>
> -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *res=
ult,
> +static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum sca=
n_result *result,
>                                             struct collapse_control *cc)
>         __releases(&khugepaged_mm_lock)
>         __acquires(&khugepaged_mm_lock)
> @@ -2562,7 +2554,7 @@ static void khugepaged_do_scan(struct collapse_cont=
rol *cc)
>         unsigned int progress =3D 0, pass_through_head =3D 0;
>         unsigned int pages =3D READ_ONCE(khugepaged_pages_to_scan);
>         bool wait =3D true;
> -       int result =3D SCAN_SUCCEED;
> +       enum scan_result result =3D SCAN_SUCCEED;
>
>         lru_add_drain_all();
>
> @@ -2775,7 +2767,8 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>         struct collapse_control *cc;
>         struct mm_struct *mm =3D vma->vm_mm;
>         unsigned long hstart, hend, addr;
> -       int thps =3D 0, last_fail =3D SCAN_FAIL;
> +       enum scan_result last_fail =3D SCAN_FAIL;
> +       int thps =3D 0;
>         bool mmap_locked =3D true;
>
>         BUG_ON(vma->vm_start > start);
> @@ -2796,7 +2789,7 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>         hend =3D end & HPAGE_PMD_MASK;
>
>         for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
> -               int result =3D SCAN_FAIL;
> +               enum scan_result result =3D SCAN_FAIL;
>                 bool triggered_wb =3D false;
>
>  retry:
> --
> 2.43.0
>


