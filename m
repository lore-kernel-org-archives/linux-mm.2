Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4781CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6628E000A; Tue, 23 Sep 2025 12:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE228E0001; Tue, 23 Sep 2025 12:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D40E8E000A; Tue, 23 Sep 2025 12:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 18B7F8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:23:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA1F7C01C6
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:23:29 +0000 (UTC)
X-FDA: 83921035338.10.804F236
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 881DBA001C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:23:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HWYJ2zyG;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758644607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKss1Vq/qNskbdjEuoAF34BI2EldAPZBijh148HYB4w=;
	b=xEjj80hF0H63F27WjvzV61wuJaGsXuCekxSLNTAdEkozdpKIvU+eijho4gUVRLM0EFDa6a
	kcowkXWh9QjuG8WfCJEy/h5wc+SJJqdxet4qVMmkSknZEJoiMYKzhwPoji6l2Ce67fslfs
	7zM9iw91cp+M5JAb+q0IlvLl6byWah8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HWYJ2zyG;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758644607; a=rsa-sha256;
	cv=none;
	b=bs0wtKKxyg0QHgoqYQaC5xoiw2C6WiaHLFEoY1lb3u7gYxzxtiElws7q7jqqqzks0PW9mU
	yvKVMBDHKhKCBrJfU5JVIyUcYPPFIPs0RWeV3EymSyyEDnXxCe795KYXY5vgZ1EGXHOsj5
	fLpQ7+Yflje+AVMGoC/AXebyJgCJduM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758644607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKss1Vq/qNskbdjEuoAF34BI2EldAPZBijh148HYB4w=;
	b=HWYJ2zyGZAujigSZRjhzt1uWoS2Yn2OrbozB31aUijfbAtmWJo1rx2kVeg0ClbAgzr5qDB
	VlJbzJZTNjPv3gzhSqmiXU+umJhiT3rXgE7suCiTJxO5BYT6Yi0Exx0SXSW2OgsCMkpeVO
	8azxZwWQ9YJx2rdykufOhqZoYKsEGi8=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-ZPzWFByQPUiWesQZc0Pm9w-1; Tue, 23 Sep 2025 12:23:24 -0400
X-MC-Unique: ZPzWFByQPUiWesQZc0Pm9w-1
X-Mimecast-MFC-AGG-ID: ZPzWFByQPUiWesQZc0Pm9w_1758644604
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-ea7624be2e7so8135015276.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758644604; x=1759249404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UKss1Vq/qNskbdjEuoAF34BI2EldAPZBijh148HYB4w=;
        b=AwgxHQxq2/1r+9V9Pb4iEoWMrGPrj0tFwOS20rOaeO2IHGuUNWNNEshEHbQrArQ0BT
         QKlu9jeAvb/99iqMzHs/FFotS9GtsezTocY+UC5bLGdWProZX8tyTt4WTVU9YfiEnJwI
         I7ijO3/QEml60pXGcsP0C0JEb+WVGlR8CCh7oDZlKyM/S1WCZhnol7CL22mCIcp0bZJP
         buxglqiBCog6aY05iC2kcNsRPLLqWebtTFzS4r080w+8B9iKSH+lfBn9MIVGPc19IKm0
         2I+NNpMuw85xekXfkahrr73OAftoFr0IY+BmDlAgbEu3skfHPLpOptoWI7+tCmqH6g8k
         O5zw==
X-Forwarded-Encrypted: i=1; AJvYcCUFpC/pUUXBVb9JtL2H5fc+CnZ9xklabDKgsFrUVqPPUv9bvX8myellXW0vKtBSDre5Totp8ai72Q==@kvack.org
X-Gm-Message-State: AOJu0YxXSbTgGMn8ZlOo4acQRoNRbdK0m144OoJ2sGXbOhRezEJGM5Sw
	yCweMEURgE4vNjbHOQbjrLumELDAKnTntutMwYdsGfqRrG/XvCRMDFTAygrIyXr8Z5c76+EjDiI
	uefbdMFBjoWNkY3C8PbVfEBsp30EgIwZbuw0rrg//H3KVOrdmZEX8bJXkcgfB/C2UCpVBsIGtrQ
	At63ZuDUA+xtS8oCCEpH68kwzj4dI=
X-Gm-Gg: ASbGnctiEFw1PXZL7BwFdWvQtQoU8Bii1IyA+0rH2vGiY51QsXeezBk3CnrTVys+Qo+
	bPzj5Izw78GTXzwAWe6c5p2oxhnIGTYHV57j0woazyiupApOu0HGq1jxyRIXCnPWbKrP0MTXKBf
	hZc7EOLN78Ry4eQu7dwr9S1+PYYBjVEnYmKsw=
X-Received: by 2002:a05:6902:6c0d:b0:e97:d52:c5c9 with SMTP id 3f1490d57ef6-eb32e153c6emr2423039276.1.1758644603733;
        Tue, 23 Sep 2025 09:23:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElG1psvLGlrCOOsQeaMXrxpi0LR+KmCR4yk6DkzIcT1sNcAqVvTC0+LYxsDcTOe5Xa5c3B8XAFOPMszGJUWWY=
X-Received: by 2002:a05:6902:6c0d:b0:e97:d52:c5c9 with SMTP id
 3f1490d57ef6-eb32e153c6emr2423010276.1.1758644603205; Tue, 23 Sep 2025
 09:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250922140938.27343-1-richard.weiyang@gmail.com>
In-Reply-To: <20250922140938.27343-1-richard.weiyang@gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 23 Sep 2025 10:22:57 -0600
X-Gm-Features: AS18NWCrgPCxhPHqfM8AUhmc4HSoU4EXElLGKZj86ch-rSpxXn-w_lc5CCxqcdM
Message-ID: <CAA1CXcCjDZ9Q6d9X4-dXsUfLPHMNYehZUTARzMNmZJvaSP_t3A@mail.gmail.com>
Subject: Re: [Patch v2] mm/khugepaged: use start_addr/addr for better reading
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, linux-mm@kvack.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: olGUl3AKQzJQwSURWi4u1jJlsiJeYcm7eUmvxUwCVwI_1758644604
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 881DBA001C
X-Rspamd-Server: rspam05
X-Stat-Signature: qqcoa5d5isatdhxnkek3ew4xpndxp7b3
X-Rspam-User: 
X-HE-Tag: 1758644607-139868
X-HE-Meta: U2FsdGVkX18QqHy8rwIJisKbTF7ZHysWC6OECgk4BB01bM6dw2WC0tP+TQUjmUJdqPcCESo4RB6K/mVmPxvCJREjOilJAqx1gNpXkARogl8HIQWVn7OhiXZ8p59HTYLc9A6wk8ux1kGFFHYv4sVeL06v97v+WDqFo60V38Sl9kPQbDa1gE3MfsSVQatud5hNUflx6DxIB/rHmpHgf+gFMUdi7hhqHiJo4gQTk6zDJeVUOoZ16K1CpFLsQGj2qIVxHBZ7ukrL4DWlM2DTJfEUOR4Y3aKo8bcfg2E3f8kwwGYW8v0HyLhN3jLHpi7jUuNs3mGXy41OWyj8PiN3JawKfmQt9OK3puu/qmoBalhgfF+PYi4ivAhGc+vRJmeRXix3JyShlHMozEYLK6NTXsvx6SH6bc4mUPdTWngelLtQRkE42Qh2xlfUnwrOMqlqww4quR2u7dBf3wEsWLFnifYHhS02HG9S1925OM4MR8NcBJE3cXmvP/6YuoC5WHIvnoSS9fqqifWyJk1fcr03Lz50UmS2QmxI7PByCUtQ4ZaHUMzo7WTj4RwcQAmSSqPzWisl/LQ4ycgFhqXPHqlHLTL+zrYTU/PM0ClCc0N6vWiUFFMW8XRRx67n5lVurr8oWFLzuwsCdsORt6z+atOY0wRiWurbXaefmBr4G/TiFT6eoZGquDbtYFfdjGuFvjImkLa1/F+Sekv8FgXOnTTg/16DjtyWyUMygx2WQoencCV7dBYKO/05VGeQiPGj1W4UrhTMKtimtKjUSAzeUj4xlXF6ddWo1+KqDOOLWdYkXBkQvGBTWOpxDrPGTKvx1uR2fFBfzfYNaSmUMkp0H3V/E2T3DzIcj3UE50KK4R//X3s9zlxg6re2axzFdA2jkLZACDtswpEU+gBHiPaMORVui77YtS1ail6jgtYnqnaW2XiFDmsJTIgvIQDcQNGSbiO/jkiCSnsR1iuS66WWW4YJMny
 s8oE0wlF
 MTIWE/f2dQPQP72ES9dVPyhS5ouqOezK10/SilmsfX5TmOm0kpsKtNKwjV2FUxeJGepYJwXcWCuaB6H4U4rubQngn36LaYM43ovu+Yf31ILe0j7g4G6GScmtnBBkB521zNyCRKRyByCeTIyPLkd03ds2KE8b164ne2lkXfbDW5X1chvZDJ5Iw2SylpsGt97zYOGbpCAsSTP/ScR/F4wzbMb8TUPsEJhxlizTb2e666VFbaJxgywu6p82a/pmtNde4KvfnDpGLQEXibbbk8rz/FWW8nI3yo6wxRzd8yvgrogRPHAMx0BieKL5sCInJPMe5PcRtDtv5oKVZd20TGhW6VeZojXzDUokBKn7QzYfdfTP/yRUMVhcKQA5wjqtkJqhK+mROOnMXRN5lfVUSsO2NHXu5FoxLchOlRY1dPZ/dI6h0tM2ASK8+Py6lU0MACKeDBmV5I3vNI6hmotk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 8:09=E2=80=AFAM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> When collapse a pmd, there are two address in use:
>
>   * address points to the start of pmd
>   * address points to each individual page
>
> Current naming is not easy to distinguish these two and error prone.
>
> Considering the plan to collapse mTHP, name the first one to start_addr
> and second one to addr for better reading and consistency.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
>
LGTM!

Reviewed-by: Nico Pache <npache@redhat.com>
> ---
> v2: use start_addr/addr instead
> ---
>  mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 21 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index ec3f91a345a0..e3f7d1760567 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_p=
te,
>  }
>
>  static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> -                                       unsigned long address,
> +                                       unsigned long start_addr,
>                                         pte_t *pte,
>                                         struct collapse_control *cc,
>                                         struct list_head *compound_pageli=
st)
>  {
>         struct page *page =3D NULL;
>         struct folio *folio =3D NULL;
> +       unsigned long addr =3D start_addr;
>         pte_t *_pte;
>         int none_or_zero =3D 0, shared =3D 0, result =3D SCAN_FAIL, refer=
enced =3D 0;
>
>         for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR;
> -            _pte++, address +=3D PAGE_SIZE) {
> +            _pte++, addr +=3D PAGE_SIZE) {
>                 pte_t pteval =3D ptep_get(_pte);
>                 if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>                         ++none_or_zero;
> @@ -570,7 +571,7 @@ static int __collapse_huge_page_isolate(struct vm_are=
a_struct *vma,
>                         result =3D SCAN_PTE_UFFD_WP;
>                         goto out;
>                 }
> -               page =3D vm_normal_page(vma, address, pteval);
> +               page =3D vm_normal_page(vma, addr, pteval);
>                 if (unlikely(!page) || unlikely(is_zone_device_page(page)=
)) {
>                         result =3D SCAN_PAGE_NULL;
>                         goto out;
> @@ -655,8 +656,8 @@ static int __collapse_huge_page_isolate(struct vm_are=
a_struct *vma,
>                  */
>                 if (cc->is_khugepaged &&
>                     (pte_young(pteval) || folio_test_young(folio) ||
> -                    folio_test_referenced(folio) || mmu_notifier_test_yo=
ung(vma->vm_mm,
> -                                                                    addr=
ess)))
> +                    folio_test_referenced(folio) ||
> +                    mmu_notifier_test_young(vma->vm_mm, addr)))
>                         referenced++;
>         }
>
> @@ -985,21 +986,21 @@ static int check_pmd_still_valid(struct mm_struct *=
mm,
>   */
>  static int __collapse_huge_page_swapin(struct mm_struct *mm,
>                                        struct vm_area_struct *vma,
> -                                      unsigned long haddr, pmd_t *pmd,
> +                                      unsigned long start_addr, pmd_t *p=
md,
>                                        int referenced)
>  {
>         int swapped_in =3D 0;
>         vm_fault_t ret =3D 0;
> -       unsigned long address, end =3D haddr + (HPAGE_PMD_NR * PAGE_SIZE)=
;
> +       unsigned long addr, end =3D start_addr + (HPAGE_PMD_NR * PAGE_SIZ=
E);
>         int result;
>         pte_t *pte =3D NULL;
>         spinlock_t *ptl;
>
> -       for (address =3D haddr; address < end; address +=3D PAGE_SIZE) {
> +       for (addr =3D start_addr; addr < end; addr +=3D PAGE_SIZE) {
>                 struct vm_fault vmf =3D {
>                         .vma =3D vma,
> -                       .address =3D address,
> -                       .pgoff =3D linear_page_index(vma, address),
> +                       .address =3D addr,
> +                       .pgoff =3D linear_page_index(vma, addr),
>                         .flags =3D FAULT_FLAG_ALLOW_RETRY,
>                         .pmd =3D pmd,
>                 };
> @@ -1009,7 +1010,7 @@ static int __collapse_huge_page_swapin(struct mm_st=
ruct *mm,
>                          * Here the ptl is only used to check pte_same() =
in
>                          * do_swap_page(), so readonly version is enough.
>                          */
> -                       pte =3D pte_offset_map_ro_nolock(mm, pmd, address=
, &ptl);
> +                       pte =3D pte_offset_map_ro_nolock(mm, pmd, addr, &=
ptl);
>                         if (!pte) {
>                                 mmap_read_unlock(mm);
>                                 result =3D SCAN_PMD_NULL;
> @@ -1252,7 +1253,7 @@ static int collapse_huge_page(struct mm_struct *mm,=
 unsigned long address,
>
>  static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>                                    struct vm_area_struct *vma,
> -                                  unsigned long address, bool *mmap_lock=
ed,
> +                                  unsigned long start_addr, bool *mmap_l=
ocked,
>                                    struct collapse_control *cc)
>  {
>         pmd_t *pmd;
> @@ -1261,26 +1262,26 @@ static int hpage_collapse_scan_pmd(struct mm_stru=
ct *mm,
>         int none_or_zero =3D 0, shared =3D 0;
>         struct page *page =3D NULL;
>         struct folio *folio =3D NULL;
> -       unsigned long _address;
> +       unsigned long addr;
>         spinlock_t *ptl;
>         int node =3D NUMA_NO_NODE, unmapped =3D 0;
>
> -       VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> +       VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>
> -       result =3D find_pmd_or_thp_or_none(mm, address, &pmd);
> +       result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>         if (result !=3D SCAN_SUCCEED)
>                 goto out;
>
>         memset(cc->node_load, 0, sizeof(cc->node_load));
>         nodes_clear(cc->alloc_nmask);
> -       pte =3D pte_offset_map_lock(mm, pmd, address, &ptl);
> +       pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>         if (!pte) {
>                 result =3D SCAN_PMD_NULL;
>                 goto out;
>         }
>
> -       for (_address =3D address, _pte =3D pte; _pte < pte + HPAGE_PMD_N=
R;
> -            _pte++, _address +=3D PAGE_SIZE) {
> +       for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> +            _pte++, addr +=3D PAGE_SIZE) {
>                 pte_t pteval =3D ptep_get(_pte);
>                 if (is_swap_pte(pteval)) {
>                         ++unmapped;
> @@ -1328,7 +1329,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>                         goto out_unmap;
>                 }
>
> -               page =3D vm_normal_page(vma, _address, pteval);
> +               page =3D vm_normal_page(vma, addr, pteval);
>                 if (unlikely(!page) || unlikely(is_zone_device_page(page)=
)) {
>                         result =3D SCAN_PAGE_NULL;
>                         goto out_unmap;
> @@ -1397,7 +1398,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>                 if (cc->is_khugepaged &&
>                     (pte_young(pteval) || folio_test_young(folio) ||
>                      folio_test_referenced(folio) ||
> -                    mmu_notifier_test_young(vma->vm_mm, _address)))
> +                    mmu_notifier_test_young(vma->vm_mm, addr)))
>                         referenced++;
>         }
>         if (cc->is_khugepaged &&
> @@ -1410,7 +1411,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>  out_unmap:
>         pte_unmap_unlock(pte, ptl);
>         if (result =3D=3D SCAN_SUCCEED) {
> -               result =3D collapse_huge_page(mm, address, referenced,
> +               result =3D collapse_huge_page(mm, start_addr, referenced,
>                                             unmapped, cc);
>                 /* collapse_huge_page will return with the mmap_lock rele=
ased */
>                 *mmap_locked =3D false;
> --
> 2.34.1
>


