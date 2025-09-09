Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 890FCCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 18:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAFAC8E0006; Tue,  9 Sep 2025 14:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87D48E0001; Tue,  9 Sep 2025 14:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4628E0006; Tue,  9 Sep 2025 14:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A88A68E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:52:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D24511ABAD
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:52:04 +0000 (UTC)
X-FDA: 83870606568.04.FCF2727
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7404A40002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:52:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qp+3Kndu;
	spf=pass (imf04.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757443922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAwDhU2WUoYnohm20pg+eapTEZHSXIxK7W5ZKC0ZArg=;
	b=P8YhztID9QlD04Fp+qKYJJPOxqQATstvy3zFQ840Ll7vJxrAGxtPSd77G5P1KBXv3DDxIk
	wyqWruBxfINSAXbJO4calZUFAk7Ed3qzSKAhLzPHMLSdzOW5RIM45333vq3D9H5Eos0ZD2
	D66EonwsQsud/5REkeKxR4GTNLueW5E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qp+3Kndu;
	spf=pass (imf04.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757443922; a=rsa-sha256;
	cv=none;
	b=lPu/FggRThYajx5NNVdvVV0uoHElrosTWJddvm61c64P8v0Ay9fPa7n1CoVELTjjAYlZNA
	KHRPjkffH+ddvQGjGNzZocnak+LAd35BTHAcfWFd4N0rA+9+3Vo+6iKg42SB9zWUfjQQtX
	4Oe/iQoPP5hr4igQFJjA8AgZQuXl/KI=
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-412a2fe2f36so22775ab.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 11:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757443921; x=1758048721; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dAwDhU2WUoYnohm20pg+eapTEZHSXIxK7W5ZKC0ZArg=;
        b=qp+3KndufH9ltnH7OD2frdwKnJAB1h6SZj8wCRxtQU2SeZyMLsc3dXfb9nSkRJUPZl
         DjWwR2UECrK5LLbuDgjmt3soKMkNz46NkQeYgjQHAZt5EhUmJ5YbbUz9XzhGMIcPA9Is
         Gc41mX0t+ThU4r+yuOGpIlwsqG0GujQe5Dk3wHAUnoTu5EBDvm+xBM+XUdwitneVsxvn
         v/Bog8s4//bxsx9SvNmWg1WALwKKsvOB76XrFcivVhwV8mO+7MNE1nvWC+f2i+fIkVTc
         zPFe/zbIMe/S6NMC8bzP3nr++SqMhUi+6y0xvlYnRSXRfWeudooYmI5tvnIyu5YTLZzb
         ca+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757443921; x=1758048721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dAwDhU2WUoYnohm20pg+eapTEZHSXIxK7W5ZKC0ZArg=;
        b=p+McTISPd6ZnPt/HiAIhInI4LFKS6rnktM810mmnFThM6542odF3i6WgojVMZDDB8Z
         SJGgDAIAnNcGC+dFnP9jOuPahAbOx6NI0F7185xJaYcTKJ03RaIUqMzZeJRJBxMl3FDZ
         IUfjBA5XMn6rYxPFJcJxNyUmJm4dKmr12C3a16dLCxXrY42vV+H1/1uYPda7UNq6vuQO
         wf7rvRvHJtz+tzXMCVrYBXmTweySEVRqmetApcGKevLTe11uDvZa7JSmcuVxNUdXGVUM
         KRXnOiAx50OSs20xJlJWgG+lEvoC8AoYd0I4sPyRzV9WXTgRhx9ElkWWr3zdZTSSq2QY
         56FA==
X-Forwarded-Encrypted: i=1; AJvYcCWtdma1iOSMRKZKH5V6tVkQhyZoBiy4tducPCkdydk+z10HS51A5bEW0lgXDfNWFJGd06RF65KsNA==@kvack.org
X-Gm-Message-State: AOJu0YxBktFjcT+udW/d+7H+NQb/z4Kh7AOpKF6KKPrK7srU7h3N0Oyo
	ntN1tjCeJnT+5kJ/pgKeUIMBYg93GcfPX5CkQTzxy6xF/wBR4KcpyPtcG61rA/k7CQYiIsydQWj
	EPnoydT1s0g3sFsh2wcluX1S/PCIADBI1PDmBeYJe
X-Gm-Gg: ASbGncs+WKfI62EBoLGgv3pCbT9DzTkJJ38W7VO4LROUjIeFxGp1mqAyDCEL1VDkhoL
	ASZuJNjPX+QMnCBDlJnDiikl6MA/RZ7K0VYYik9lQvhKs8iDpYBYn2j3l2CRpEuLbtJuuTMM2Kv
	VCCFSzzcU5CPtbe79AHpYawaY2utqSi3hCfVKcs1gRWlZ75/jtjQF3SgH48XDey5tD8xginuF+F
	zKm9eH26sw1G8s=
X-Google-Smtp-Source: AGHT+IEKNjxibAxv1AfgJxTvJn5B0kzJMG6nPy7yfiMaYwP6fvdKYN5v/N8vavDSij2H8a/O9KlZs6Vgz5lU92981k4=
X-Received: by 2002:a05:6e02:250d:b0:400:7d06:dd68 with SMTP id
 e9e14a558f8ab-41655b596admr576495ab.14.1757443921008; Tue, 09 Sep 2025
 11:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250908075028.38431-1-dev.jain@arm.com> <20250908075028.38431-3-dev.jain@arm.com>
In-Reply-To: <20250908075028.38431-3-dev.jain@arm.com>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Tue, 9 Sep 2025 11:51:23 -0700
X-Gm-Features: Ac12FXwgKz23RzNrJlXWoPmYg-m3zmsRje2pwnne6Wug2tegfeiTYXWBxKPK1qs
Message-ID: <CAAa6QmSf4yFMXrCLNgrk6jYGyceox_DtZ0uOOA5OgqOpmR7Ljg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: Drop all references of writable and SCAN_PAGE_RO
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, kas@kernel.org, 
	willy@infradead.org, hughd@google.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qngg3tgsufe89ni3wrfp5yd7n35ksx5m
X-Rspam-User: 
X-Rspamd-Queue-Id: 7404A40002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757443922-271984
X-HE-Meta: U2FsdGVkX1/F7Nob8uaxNLdqWz52tMiI0Mf+x0n5xkF3yIzClXR/22Jd1MwCMfFtkA9bGxshFSaBUh26hzbPkgJEfwFYOUdgLbNW2ZpwL24m1Tac160nlmTwrkL16gTy76Rp1Tg7owAjjujT9yfCsw1R0o9hXyCcj4LsqkcyYYvuVYulf/QTXES7KlGb5QcfOsTIH+tX0nOjtPIoYwrPRcTxrDJQRwXBZKfNC4OZBvjVBGHxaxtUXjchCD/VANwV8TVn/2pktHcsJYC2d7Nh4LeJCB1rqNaM8MMdu7Caf5yvDiD4mgWsXirVEoywvyDHMOrl+GexYsRbfjOojLVBlPktqPCFbYA/ZUlLVzNqE+D7WlBIBNbr8nGnZuEvx+l5a8++mTANVccyNHWzmoMHbIA5Saf92k/IHoMe6nq7eCDy6bkiCjRZ+t3JKtLKItvnvAjIk/j0IrJnwoFh9sxjpbCO05W20p/Z3vq8FoGUioy9FG20vYW/el9ZC1abJh3ISqbWR3AdFB7WT1wwQHpbWqwdTVumOSdn461nTGOsSLh2rEoBC8N1VHON4+2vHxpcFrmlaBQ7k9QtBQKFSXL3txVzcCJcaUs8eF+bGWFUHCNemSihFeIImearpaOqkdWgG5VIMu27WyqzO977Sp08yWe+1JpsHkB9H95JvAMvGrwIR59PCoZe9aK257KJbG/9+pE1Pr0GwE1LEX7wH0V1ECGtP8fIrhg5AWXlq30CchmLCC615rkQBoKj5OqEosFKuCbqiRfeb4kctVxdZ+Ho2Tr+LjA4eyWdM+2UlZL+93kRSf9fFyoVIZbdTlF1Ay0pJddzion1dEfxFTAzczNWiABS8i2FKy1ZWev69zqjMCzpCArBAlDfNacAh00LrhAcJzISY/p6m1PbQLDBXR+Sc2LbvFM1H4S4eYWyxNeq66uopnProBQ13lN+N33k34gWcMnsPdP830sEFR6ugST
 r3dSpf2T
 rDzZBIJFkR3s8KGbMmtj3i9oG81vh/kwYpOa33Sih6XsGplj4wrdUu1Rw7Qq5tt6wHGrgbJ3sY6LNZkwRSFsRhpVYU/jjyR82YsQcfg7DE9Kxz8U8RhKaL7ks3fww4srKD73RHkMxJtjlNlqW9tkRvHbaVHEKqK6uprhd1PWqvo9JU8yWSFDQ4vyvkzTcY2xPJwslg9GHPQjp22ZWIm1b1/iuSqz/buUxR89vGq03F8fdj1VF6WoVGSZvhbee+eMbBmN+Mx2rOsr1lEebSwMNw7UmQUgty/dWIgqzS09IxpB/zdnqljxDF1JJC25s0PPmMAXjVpP97VQR/YrKkTAQsWHAS3DWmitT9s3uJbgs6mO2RPwLFojElXs6Fp6z9KcekkgqT2R65QrbccL8sdsOGhh4hC6S2znDI9MA2yeAk+Qv8ALCdAjP4ZT+VSLnVJCffAG+OpL7RA87sjoD0jyZRi7OP0k6vG6M3NnpEf91H0jaaew4hGau7F3248cF/L7bdhtYMue1Hpn2ZxgsrazSODpN3hoPOQIFlaFG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks, Dev.

On Mon, Sep 8, 2025 at 12:51=E2=80=AFAM Dev Jain <dev.jain@arm.com> wrote:
>
> Now that all actionable outcomes from checking pte_write() are gone,
> drop the related references.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Zach O'Keefe <zokeefe@google.com>


> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/trace/events/huge_memory.h | 19 ++++++-------------
>  mm/khugepaged.c                    | 14 +++-----------
>  2 files changed, 9 insertions(+), 24 deletions(-)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/hu=
ge_memory.h
> index 2305df6cb485..dd94d14a2427 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -19,7 +19,6 @@
>         EM( SCAN_PTE_NON_PRESENT,       "pte_non_present")              \
>         EM( SCAN_PTE_UFFD_WP,           "pte_uffd_wp")                  \
>         EM( SCAN_PTE_MAPPED_HUGEPAGE,   "pte_mapped_hugepage")          \
> -       EM( SCAN_PAGE_RO,               "no_writable_page")             \
>         EM( SCAN_LACK_REFERENCED_PAGE,  "lack_referenced_page")         \
>         EM( SCAN_PAGE_NULL,             "page_null")                    \
>         EM( SCAN_SCAN_ABORT,            "scan_aborted")                 \
> @@ -55,15 +54,14 @@ SCAN_STATUS
>
>  TRACE_EVENT(mm_khugepaged_scan_pmd,
>
> -       TP_PROTO(struct mm_struct *mm, struct folio *folio, bool writable=
,
> +       TP_PROTO(struct mm_struct *mm, struct folio *folio,
>                  int referenced, int none_or_zero, int status, int unmapp=
ed),
>
> -       TP_ARGS(mm, folio, writable, referenced, none_or_zero, status, un=
mapped),
> +       TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
>
>         TP_STRUCT__entry(
>                 __field(struct mm_struct *, mm)
>                 __field(unsigned long, pfn)
> -               __field(bool, writable)
>                 __field(int, referenced)
>                 __field(int, none_or_zero)
>                 __field(int, status)
> @@ -73,17 +71,15 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
>         TP_fast_assign(
>                 __entry->mm =3D mm;
>                 __entry->pfn =3D folio ? folio_pfn(folio) : -1;
> -               __entry->writable =3D writable;
>                 __entry->referenced =3D referenced;
>                 __entry->none_or_zero =3D none_or_zero;
>                 __entry->status =3D status;
>                 __entry->unmapped =3D unmapped;
>         ),
>
> -       TP_printk("mm=3D%p, scan_pfn=3D0x%lx, writable=3D%d, referenced=
=3D%d, none_or_zero=3D%d, status=3D%s, unmapped=3D%d",
> +       TP_printk("mm=3D%p, scan_pfn=3D0x%lx, referenced=3D%d, none_or_ze=
ro=3D%d, status=3D%s, unmapped=3D%d",
>                 __entry->mm,
>                 __entry->pfn,
> -               __entry->writable,
>                 __entry->referenced,
>                 __entry->none_or_zero,
>                 __print_symbolic(__entry->status, SCAN_STATUS),
> @@ -117,15 +113,14 @@ TRACE_EVENT(mm_collapse_huge_page,
>  TRACE_EVENT(mm_collapse_huge_page_isolate,
>
>         TP_PROTO(struct folio *folio, int none_or_zero,
> -                int referenced, bool  writable, int status),
> +                int referenced, int status),
>
> -       TP_ARGS(folio, none_or_zero, referenced, writable, status),
> +       TP_ARGS(folio, none_or_zero, referenced, status),
>
>         TP_STRUCT__entry(
>                 __field(unsigned long, pfn)
>                 __field(int, none_or_zero)
>                 __field(int, referenced)
> -               __field(bool, writable)
>                 __field(int, status)
>         ),
>
> @@ -133,15 +128,13 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
>                 __entry->pfn =3D folio ? folio_pfn(folio) : -1;
>                 __entry->none_or_zero =3D none_or_zero;
>                 __entry->referenced =3D referenced;
> -               __entry->writable =3D writable;
>                 __entry->status =3D status;
>         ),
>
> -       TP_printk("scan_pfn=3D0x%lx, none_or_zero=3D%d, referenced=3D%d, =
writable=3D%d, status=3D%s",
> +       TP_printk("scan_pfn=3D0x%lx, none_or_zero=3D%d, referenced=3D%d, =
status=3D%s",
>                 __entry->pfn,
>                 __entry->none_or_zero,
>                 __entry->referenced,
> -               __entry->writable,
>                 __print_symbolic(__entry->status, SCAN_STATUS))
>  );
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a0f1df2a7ae6..af5f5c80fe4e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -39,7 +39,6 @@ enum scan_result {
>         SCAN_PTE_NON_PRESENT,
>         SCAN_PTE_UFFD_WP,
>         SCAN_PTE_MAPPED_HUGEPAGE,
> -       SCAN_PAGE_RO,
>         SCAN_LACK_REFERENCED_PAGE,
>         SCAN_PAGE_NULL,
>         SCAN_SCAN_ABORT,
> @@ -557,7 +556,6 @@ static int __collapse_huge_page_isolate(struct vm_are=
a_struct *vma,
>         struct folio *folio =3D NULL;
>         pte_t *_pte;
>         int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, refer=
enced =3D 0;
> -       bool writable =3D false;
>
>         for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR;
>              _pte++, address +=3D PAGE_SIZE) {
> @@ -671,9 +669,6 @@ static int __collapse_huge_page_isolate(struct vm_are=
a_struct *vma,
>                      folio_test_referenced(folio) || mmu_notifier_test_yo=
ung(vma->vm_mm,
>                                                                      addr=
ess)))
>                         referenced++;
> -
> -               if (pte_write(pteval))
> -                       writable =3D true;
>         }
>
>         if (unlikely(cc->is_khugepaged && !referenced)) {
> @@ -681,13 +676,13 @@ static int __collapse_huge_page_isolate(struct vm_a=
rea_struct *vma,
>         } else {
>                 result =3D SCAN_SUCCEED;
>                 trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -                                                   referenced, writable,=
 result);
> +                                                   referenced, result);
>                 return result;
>         }
>  out:
>         release_pte_pages(pte, _pte, compound_pagelist);
>         trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -                                           referenced, writable, result)=
;
> +                                           referenced, result);
>         return result;
>  }
>
> @@ -1280,7 +1275,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>         unsigned long _address;
>         spinlock_t *ptl;
>         int node =3D NUMA_NO_NODE, unmapped =3D 0;
> -       bool writable =3D false;
>
>         VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>
> @@ -1344,8 +1338,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>                         result =3D SCAN_PTE_UFFD_WP;
>                         goto out_unmap;
>                 }
> -               if (pte_write(pteval))
> -                       writable =3D true;
>
>                 page =3D vm_normal_page(vma, _address, pteval);
>                 if (unlikely(!page) || unlikely(is_zone_device_page(page)=
)) {
> @@ -1435,7 +1427,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>                 *mmap_locked =3D false;
>         }
>  out:
> -       trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
> +       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
>                                      none_or_zero, result, unmapped);
>         return result;
>  }
> --
> 2.30.2
>
>

