Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC16CA0EE0
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 03:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2FC9000E7; Wed, 13 Aug 2025 23:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9AA900088; Wed, 13 Aug 2025 23:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF759000E7; Wed, 13 Aug 2025 23:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C940D900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:07:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4865DB9ED1
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:07:44 +0000 (UTC)
X-FDA: 83773878048.21.65A3535
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 93D7980004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:07:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VSsQQGJq;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755140862; a=rsa-sha256;
	cv=none;
	b=y4y1Kk4PpVycv3rVg2pLsnH6B2z2FfR+ktG4YDDjx6s684pBxP/9HJH2MjZlrKLAKiLfcn
	Dwh+GpNyo/oVYfesZm6KNcAIMupQE3U6yEuvvhBhHT0hgVJItGTzzzprMXHFAP0fWWdMc1
	J+f+w6OUPBzgo2dMr/wjaafi/ze+Me0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VSsQQGJq;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755140862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUDzc1mdDHBjiqG/zzLcUzG9tliWvoEfjM11Vf1vwNI=;
	b=35flSJuQmYVnkqihQuYSkK7X2V1/N/cJMcns51mVZmxO4YpLCQi7c441FZgZ3GXe4hf2E2
	fNA2MHaaShQ1HpbnESFBrzcGdoRpuuv51+LJo4xaUhmsUwq9bf5KOsvWaZL3ZYjQQhvFvX
	ybT4Q/jyRcrl3+ojuOVZWgKHQ8fC35Y=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-70a9f56b1f2so3689216d6.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755140862; x=1755745662; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUDzc1mdDHBjiqG/zzLcUzG9tliWvoEfjM11Vf1vwNI=;
        b=VSsQQGJqX3Z+w6sQEsj84xHpRtJvmlyOGBBzqjT13jCRnOafYaQS3dcHH3Gl+T2liQ
         pzgwOmmGOwVh0HIxMq56medCPFoO951Pn3SswfrV24ypaVVPVYslGrrpO8SVFSRiNVNL
         nmRp9uYA7+HX9PaOlt8MPoAxS0AznJS1GEJPgZR1US/2T7BpvSiFRpAMZ69piAS4quTB
         WiVxSDJVlwqYNc/oAjw3O0nOeeBiS/rRLgO+/3gVuw1hDQ0K0PWMjMhLntdbOAV1z2Zo
         LWLsO663k9/hwzEwUP4eOMUhOEoPFPqjQRv70Cyj25wI8zcl+SEPXjNahfz/thilcD1q
         RfXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755140862; x=1755745662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qUDzc1mdDHBjiqG/zzLcUzG9tliWvoEfjM11Vf1vwNI=;
        b=LRgHRAj/37Wl273qEXlBkTxfhXWiyMjDP7blRLtzvyuK1XVc7VZYYRODNoI8Db1UE5
         CtaDDGjhtECaziPKcAzcBlJo7Nv50evc/IbRLGWDLxAh9rClL7J7LISf7gXXm90B/8vp
         e08fCwiHR7pSOp6hbtpL3DgDPpY1mnCKyabGZAasXRnE7MlPfvCfTj+bXIfgdbAnmNaY
         +NCMNbv8L+UAzEsHo0d5hUJp+VvzIDF7XUu5rBbkGhyXNhnXbk82Q0gQ9dzau9HIOQDn
         r+oNZmzkQUQh+bwNFoPL3OOpeQFmLunx89jtiOK7PXrKnhxI3h12+3QArrWgIrmYakgV
         7RAg==
X-Forwarded-Encrypted: i=1; AJvYcCW6MMME4NHK7J50cLtsDtvPj0BwJ2AhFAzjGGXmX3NlRTHVduiIXL6WHOcDOwdhi+eNCm3cUabbNg==@kvack.org
X-Gm-Message-State: AOJu0Yy1B5h740Zqp3JUEjlo+1nv3UwgQRvA8d/igri6mtkCprK2rwdJ
	kpJA+nUXP2xYaEAvRgWfvbq7UEj8WKlaEmqRXFhjf5Z1J/+HaleYsY62dQUvUDXKdxmgTl6xvOu
	v5ThV4uB5tb/SfkHB6m1Jtw6neo1mxc0=
X-Gm-Gg: ASbGnctaJkQ1jxFY2kCfmu0TaPAbMgrhm1wicnONIhM+ZMMUYXvFYqbrh2zTB8ixwNT
	qj5O+ocjVQLRsfT/m5woR3rH0i5NfnT041QBEIWLQk/pBfAuSeqsdEvaQt4Zt+LHGwQu7pGXqxi
	0I8JoLL88z+FPBydTDaiCzjg2A/KvIRNNFQWcx5TSzL2QywAbgWS5yKjlVroUjhFvzT6naz4yPU
	Ojh5wyPMbRshOMkhPBuoIBv3Q8FuQ==
X-Google-Smtp-Source: AGHT+IFYxDmdtCd1AOfg3PPu0GGuc/CboEux5FPcuVbxvPt1Q0ZG3/4JBDkLE42D+b8yyII1bAVdU+IUJHNYlXKAF6Y=
X-Received: by 2002:a05:6214:e6e:b0:709:bc45:b9f7 with SMTP id
 6a1803df08f44-70af5b03e24mr23289996d6.14.1755140861453; Wed, 13 Aug 2025
 20:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250813135642.1986480-1-usamaarif642@gmail.com> <20250813135642.1986480-3-usamaarif642@gmail.com>
In-Reply-To: <20250813135642.1986480-3-usamaarif642@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 14 Aug 2025 11:07:05 +0800
X-Gm-Features: Ac12FXw7qs-tSJF4aKoa8rmDweW7mQyT51zC6eFE-QG_TX-v7WWZYuuumuDMqoY
Message-ID: <CALOAHbAe9Rbb2iC3Vnw29jxHEQiWA83jw72fb_CQKGDFHv6+FQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] mm/huge_memory: convert "tva_flags" to "enum tva_type"
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org, 
	shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz, 
	jannh@google.com, Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93D7980004
X-Stat-Signature: fmjza43ta76qx3d9h4794of5pny7rooq
X-Rspam-User: 
X-HE-Tag: 1755140862-709383
X-HE-Meta: U2FsdGVkX1+mFnn95wZUoWoiLTmJjFADeVZG+HY3pXA9LabJG4VC0b1yr31bYvH8CmHGKWeQexO/iPQWVRq7DT6vOsU45JCuW1YO3J9wDTvEAHqc2+x4AACQWOIKpZTxHA1UnrFR5F3ezPzUrv0Lt/wIvOEUiLSkr4sDz8Wd6eqXUEAkkTBiWHAYpQjdGPxmlS0Q9McpHfclc+nFjbo9AVfmR4zNh16jq/RpRrlPtPxgOKoeWkr60aPheAoBAz+VppXBto600NiW/ew2u0bsKbQ0WGk2RNp98raExANWIom5mSqOZPkMEjDmo/xTqhMMjMTBc4hKN8u6jElJ8Ts28tQaeXTBzIOO0zc9x/3OMUAN1ovxeX8B6GNidrCp9hG22Jkhk4k60Lb46oTUwpv8+yw3yW99CQZjS6VJK9iCy+Z8qYWAqMQsB3q/VLtBPQYMu7KRU3uVs2FIvWWM+lxZ1O316ATN6zElVVbdsqMNq9dY2jTppWrNk62uZXfQvtPkIFmWQr/ErgAMugrIiWZaEm8K1TMkaX+ey9XqcYNlclUPLtkmt1PHSZdDDOcyEWO6KECGLz+ps45jToHYQxjkXlu6073fnSCmatxjn4H+yNPBRasM7bBVdqw48N6YbWcgan9nxyn7N2pWyyhFZ0DrbYVaruxrhfogYIYf8ewrP6+CHeSd2xlifyxA48aIaiedj48g8osBJdJOs7lvhq3slZ5guvQ0jKisKAoy9LNNpgZ+tjLNdN11xvZbfA21ZHrBeYtW4Saykg6YB572uDA+70GVlo6Qi0wCsF3HaSMawAqQoHhB+mzmO5cr3FZ/ps1ERfNHlDS+RrB+I5V/wI77d5nmJIlUPSomu0FPRE0kAyfxSCF+cb2+Hngk0VLwVs8e9gzi3LrhU3YUqSjOuE0yE7aov/cbpwFYre44xvq487TzTRUSt4jfaSW6tO2qquSy54iopLuQ/Qxs4imXgC0
 x1iQeYkg
 tdVf1jJ1zK1bga6YgRHie4dxoWIdwqVzceSaO60kpmnf6lFBPTqGe+QNFrQEdUprGAPuHd6WeOp3pz5pw+FCS4umObuMPRd1wu0Mjtc4CzznoQz4h36dd7AM/h5T6PPlUjTzg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 9:57=E2=80=AFPM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
> From: David Hildenbrand <david@redhat.com>
>
> When determining which THP orders are eligible for a VMA mapping,
> we have previously specified tva_flags, however it turns out it is
> really not necessary to treat these as flags.
>
> Rather, we distinguish between distinct modes.
>
> The only case where we previously combined flags was with
> TVA_ENFORCE_SYSFS, but we can avoid this by observing that this
> is the default, except for MADV_COLLAPSE or an edge cases in
> collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and
> adding a mode specifically for this case - TVA_FORCED_COLLAPSE.
>
> We have:
> * smaps handling for showing "THPeligible"
> * Pagefault handling
> * khugepaged handling
> * Forced collapse handling: primarily MADV_COLLAPSE, but also for
>   an edge case in collapse_pte_mapped_thp()
>
> Disregarding the edge cases, we only want to ignore sysfs settings only
> when we are forcing a collapse through MADV_COLLAPSE, otherwise we
> want to enforce it, hence this patch does the following flag to enum
> conversions:
>
> * TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
> * TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
> * TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
> * 0                             -> TVA_FORCED_COLLAPSE
>
> With this change, we immediately know if we are in the forced collapse
> case, which will be valuable next.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Yafang Shao <laoar.shao@gmail.com>

Hello Usama,

This change is also required by my BPF-based THP order selection
series [0]. Since this patch appears to be independent of the series,
could we merge it first into mm-new or mm-everything if the series
itself won't be merged shortly?

Link: https://lwn.net/Articles/1031829/ [0]

> ---
>  fs/proc/task_mmu.c      |  4 ++--
>  include/linux/huge_mm.h | 30 ++++++++++++++++++------------
>  mm/huge_memory.c        |  8 ++++----
>  mm/khugepaged.c         | 17 ++++++++---------
>  mm/memory.c             | 14 ++++++--------
>  5 files changed, 38 insertions(+), 35 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e8e7bef345313..ced01cf3c5ab3 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1369,8 +1369,8 @@ static int show_smap(struct seq_file *m, void *v)
>         __show_smap(m, &mss, false);
>
>         seq_printf(m, "THPeligible:    %8u\n",
> -                  !!thp_vma_allowable_orders(vma, vma->vm_flags,
> -                          TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL)=
);
> +                  !!thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SMA=
PS,
> +                                             THP_ORDERS_ALL));
>
>         if (arch_pkeys_enabled())
>                 seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 22b8b067b295e..92ea0b9771fae 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -94,12 +94,15 @@ extern struct kobj_attribute thpsize_shmem_enabled_at=
tr;
>  #define THP_ORDERS_ALL \
>         (THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FI=
LE_DEFAULT)
>
> -#define TVA_SMAPS              (1 << 0)        /* Will be used for procf=
s */
> -#define TVA_IN_PF              (1 << 1)        /* Page fault handler */
> -#define TVA_ENFORCE_SYSFS      (1 << 2)        /* Obey sysfs configurati=
on */
> +enum tva_type {
> +       TVA_SMAPS,              /* Exposing "THPeligible:" in smaps. */
> +       TVA_PAGEFAULT,          /* Serving a page fault. */
> +       TVA_KHUGEPAGED,         /* Khugepaged collapse. */
> +       TVA_FORCED_COLLAPSE,    /* Forced collapse (e.g. MADV_COLLAPSE). =
*/
> +};
>
> -#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
> -       (!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order))=
)
> +#define thp_vma_allowable_order(vma, vm_flags, type, order) \
> +       (!!thp_vma_allowable_orders(vma, vm_flags, type, BIT(order)))
>
>  #define split_folio(f) split_folio_to_list(f, NULL)
>
> @@ -264,14 +267,14 @@ static inline unsigned long thp_vma_suitable_orders=
(struct vm_area_struct *vma,
>
>  unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>                                          vm_flags_t vm_flags,
> -                                        unsigned long tva_flags,
> +                                        enum tva_type type,
>                                          unsigned long orders);
>
>  /**
>   * thp_vma_allowable_orders - determine hugepage orders that are allowed=
 for vma
>   * @vma:  the vm area to check
>   * @vm_flags: use these vm_flags instead of vma->vm_flags
> - * @tva_flags: Which TVA flags to honour
> + * @type: TVA type
>   * @orders: bitfield of all orders to consider
>   *
>   * Calculates the intersection of the requested hugepage orders and the =
allowed
> @@ -285,11 +288,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_=
area_struct *vma,
>  static inline
>  unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
>                                        vm_flags_t vm_flags,
> -                                      unsigned long tva_flags,
> +                                      enum tva_type type,
>                                        unsigned long orders)
>  {
> -       /* Optimization to check if required orders are enabled early. */
> -       if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
> +       /*
> +        * Optimization to check if required orders are enabled early. On=
ly
> +        * forced collapse ignores sysfs configs.
> +        */
> +       if (type !=3D TVA_FORCED_COLLAPSE && vma_is_anonymous(vma)) {
>                 unsigned long mask =3D READ_ONCE(huge_anon_orders_always)=
;
>
>                 if (vm_flags & VM_HUGEPAGE)
> @@ -303,7 +309,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area=
_struct *vma,
>                         return 0;
>         }
>
> -       return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, order=
s);
> +       return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
>  }
>
>  struct thpsize {
> @@ -547,7 +553,7 @@ static inline unsigned long thp_vma_suitable_orders(s=
truct vm_area_struct *vma,
>
>  static inline unsigned long thp_vma_allowable_orders(struct vm_area_stru=
ct *vma,
>                                         vm_flags_t vm_flags,
> -                                       unsigned long tva_flags,
> +                                       enum tva_type type,
>                                         unsigned long orders)
>  {
>         return 0;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6df1ed0cef5cf..9c716be949cbf 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -99,12 +99,12 @@ static inline bool file_thp_enabled(struct vm_area_st=
ruct *vma)
>
>  unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>                                          vm_flags_t vm_flags,
> -                                        unsigned long tva_flags,
> +                                        enum tva_type type,
>                                          unsigned long orders)
>  {
> -       bool smaps =3D tva_flags & TVA_SMAPS;
> -       bool in_pf =3D tva_flags & TVA_IN_PF;
> -       bool enforce_sysfs =3D tva_flags & TVA_ENFORCE_SYSFS;
> +       const bool smaps =3D type =3D=3D TVA_SMAPS;
> +       const bool in_pf =3D type =3D=3D TVA_PAGEFAULT;
> +       const bool enforce_sysfs =3D type !=3D TVA_FORCED_COLLAPSE;
>         unsigned long supported_orders;
>
>         /* Check the intersection of requested and supported orders. */
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1a416b8659972..d3d4f116e14b6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -474,8 +474,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>  {
>         if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>             hugepage_pmd_enabled()) {
> -               if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SY=
SFS,
> -                                           PMD_ORDER))
> +               if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED=
, PMD_ORDER))
>                         __khugepaged_enter(vma->vm_mm);
>         }
>  }
> @@ -921,7 +920,8 @@ static int hugepage_vma_revalidate(struct mm_struct *=
mm, unsigned long address,
>                                    struct collapse_control *cc)
>  {
>         struct vm_area_struct *vma;
> -       unsigned long tva_flags =3D cc->is_khugepaged ? TVA_ENFORCE_SYSFS=
 : 0;
> +       enum tva_type type =3D cc->is_khugepaged ? TVA_KHUGEPAGED :
> +                                TVA_FORCED_COLLAPSE;
>
>         if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>                 return SCAN_ANY_PROCESS;
> @@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struct mm_struct *=
mm, unsigned long address,
>
>         if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
>                 return SCAN_ADDRESS_RANGE;
> -       if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_O=
RDER))
> +       if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER)=
)
>                 return SCAN_VMA_CHECK;
>         /*
>          * Anon VMA expected, the address may be unmapped then
> @@ -1533,9 +1533,9 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, u=
nsigned long addr,
>          * in the page cache with a single hugepage. If a mm were to faul=
t-in
>          * this memory (mapped by a suitably aligned VMA), we'd get the h=
ugepage
>          * and map it by a PMD, regardless of sysfs THP settings. As such=
, let's
> -        * analogously elide sysfs THP settings here.
> +        * analogously elide sysfs THP settings here and force collapse.
>          */
> -       if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
> +       if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLA=
PSE, PMD_ORDER))
>                 return SCAN_VMA_CHECK;
>
>         /* Keep pmd pgtable for uffd-wp; see comment in retract_page_tabl=
es() */
> @@ -2432,8 +2432,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, int *result,
>                         progress++;
>                         break;
>                 }
> -               if (!thp_vma_allowable_order(vma, vma->vm_flags,
> -                                       TVA_ENFORCE_SYSFS, PMD_ORDER)) {
> +               if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUG=
EPAGED, PMD_ORDER)) {
>  skip:
>                         progress++;
>                         continue;
> @@ -2767,7 +2766,7 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>         BUG_ON(vma->vm_start > start);
>         BUG_ON(vma->vm_end < end);
>
> -       if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
> +       if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLA=
PSE, PMD_ORDER))
>                 return -EINVAL;
>
>         cc =3D kmalloc(sizeof(*cc), GFP_KERNEL);
> diff --git a/mm/memory.c b/mm/memory.c
> index 002c28795d8b7..7b1e8f137fa3f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4515,8 +4515,8 @@ static struct folio *alloc_swap_folio(struct vm_fau=
lt *vmf)
>          * Get a list of all the (large) orders below PMD_ORDER that are =
enabled
>          * and suitable for swapping THP.
>          */
> -       orders =3D thp_vma_allowable_orders(vma, vma->vm_flags,
> -                       TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1=
);
> +       orders =3D thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEF=
AULT,
> +                                         BIT(PMD_ORDER) - 1);
>         orders =3D thp_vma_suitable_orders(vma, vmf->address, orders);
>         orders =3D thp_swap_suitable_orders(swp_offset(entry),
>                                           vmf->address, orders);
> @@ -5063,8 +5063,8 @@ static struct folio *alloc_anon_folio(struct vm_fau=
lt *vmf)
>          * for this vma. Then filter out the orders that can't be allocat=
ed over
>          * the faulting address and still be fully contained in the vma.
>          */
> -       orders =3D thp_vma_allowable_orders(vma, vma->vm_flags,
> -                       TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1=
);
> +       orders =3D thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEF=
AULT,
> +                                         BIT(PMD_ORDER) - 1);
>         orders =3D thp_vma_suitable_orders(vma, vmf->address, orders);
>
>         if (!orders)
> @@ -6254,8 +6254,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_=
struct *vma,
>                 return VM_FAULT_OOM;
>  retry_pud:
>         if (pud_none(*vmf.pud) &&
> -           thp_vma_allowable_order(vma, vm_flags,
> -                               TVA_IN_PF | TVA_ENFORCE_SYSFS, PUD_ORDER)=
) {
> +           thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORD=
ER)) {
>                 ret =3D create_huge_pud(&vmf);
>                 if (!(ret & VM_FAULT_FALLBACK))
>                         return ret;
> @@ -6289,8 +6288,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_=
struct *vma,
>                 goto retry_pud;
>
>         if (pmd_none(*vmf.pmd) &&
> -           thp_vma_allowable_order(vma, vm_flags,
> -                               TVA_IN_PF | TVA_ENFORCE_SYSFS, PMD_ORDER)=
) {
> +           thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORD=
ER)) {
>                 ret =3D create_huge_pmd(&vmf);
>                 if (!(ret & VM_FAULT_FALLBACK))
>                         return ret;
> --
> 2.47.3
>


--=20
Regards
Yafang

