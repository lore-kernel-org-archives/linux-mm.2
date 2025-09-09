Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1450CCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 21:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A908E0007; Tue,  9 Sep 2025 17:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EADF8E0003; Tue,  9 Sep 2025 17:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA208E0007; Tue,  9 Sep 2025 17:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 184C58E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:06:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D808013B6EE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:06:01 +0000 (UTC)
X-FDA: 83870944122.29.1A315FC
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 03D0E1A000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:05:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ZBTOWO/P";
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757451960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7aPxEQ+PcTqWBMeSB4ZYtBZNSzyodKpLG/dBw3V5jw=;
	b=WGuuPzwFTrZh5r2JwT8mkOAkrl9AXWbuYz961xzgeKt0GKBwa9rAo91vmDnf/Xcek9tQ19
	aQuWknEkNqtYdQc9uBx4VvbfxVuZDCHVCV+fnk1YQaqZnX0+9Mwl7Gf2l6FYv5cwefoPtE
	61jUV07jezv7D4FEDLd82keDJuf5+no=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757451960; a=rsa-sha256;
	cv=none;
	b=nlgaiiHwKPJdKp7bSu9CAahD9PBuTLq6gwTXoIxLuzcCaTcQ2+rX+q7DeEaJM2Ub2hbM0E
	gde82OwVzIRfozEz+LSe8LubO3dJo+cRHAVHFzGLD/Hsb0ebPLv3qP1oLYMRL69O+ln5J2
	CXrw3ZjoyTkZRjfv51TFPm8QCiqx0vk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ZBTOWO/P";
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b4bcb9638aso162691cf.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 14:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757451959; x=1758056759; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7aPxEQ+PcTqWBMeSB4ZYtBZNSzyodKpLG/dBw3V5jw=;
        b=ZBTOWO/PlDrX3A1qdHndqoQ1G241+ixrnqbbPrnSYYB0bvYQIh8TR4uJXlPm+JJbNF
         ZUZ8zcVMNwF5G3HLQyBxRg8LEFaZWM2nEl3Dns2pjCQLD/UhsrCQk0Y8DmU/ef9kZg2B
         E8Nz9ZwVFLdeubBO8NaZNtdHKb2qIAeG3f4wnbsdlI/STcnz3h6BsW7zaZQXNnFCm1Fo
         K8WN0DcgtWV6OcUeCwmPtM37epYK6cbcjJqubLklUOIPKKhkCXANSRyxKEPWZi6I2zMP
         zAmYNdNsGLo+1o5RbWhROc/jO1re8JkRKJhSACb7SPP3zuX0iS/KQE77w5UsrbBM6PiM
         tDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757451959; x=1758056759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7aPxEQ+PcTqWBMeSB4ZYtBZNSzyodKpLG/dBw3V5jw=;
        b=W7G/MTZaY1m5Cmb0DsQ9aH2+t9bo0oFhq7EspAUz2F2fNxF+tKH/AwhoDk9GhruiSB
         g47E/2aSXwSC58Gy3fAAxQRfN431UE/XmXlIG1p/yT3eimpfkGRCENM+qySDue047t/x
         wKFBXpwgIjcUa6qRRXKU5QweLqkx4ATCc8hywge/yen9aK8EIVZjCr59axT0H2vPnILQ
         USQa50Ny3O0LKKmwmwPSyVxQ6UDmmF8yJ6QaXt24aMRiLMuOFcfCJVqWYYp1ABVjEBBo
         k0GpCrFcL7Z5hobLRQ3sNUezCY06/BF2Cb0Xue/wkjMYzQr/oDeyqwj/ritmSuL9aksv
         UhGg==
X-Forwarded-Encrypted: i=1; AJvYcCVooh4Zq07dmAJZPZDCxu95zlvCEbuqcS72huaD7yZmnlFXtOZCRo3DDcL5u+iBIszHb49lewI0rg==@kvack.org
X-Gm-Message-State: AOJu0Yx6/UWh4eV3+JWhgpKXW5CYNTtHV0jwC5lW6ix8YSGMqra30Mb0
	OeTxcpLoZcjH3mKPs47adSmIDZeGmkd16kMPPAkC7nGmIbwsAANpSZjACZraBp+NqnMtbNQWvgG
	cqRNB9EzAD2Wo734mmFi4BqwX9KZQV85PEvoxptzX
X-Gm-Gg: ASbGncvyt38X2pIx+O95bBy68aG6qXTFfjd7A7ijMBLk7vT6vMQGk5ulPSkrSEqlqQY
	jkQnrLysM+8YL3V9o46B/XoqNAXH40zbWCR9qPOpqVK0MFRFGS7g73TXy3ktuUHRusMNVwLFbeV
	KbOE7Di9RpjzSAFv0wYpM8I9dMXDoGfVWnpqW6eMlB0sNa8fI+gIL+CJScQNZXnENeJa/lydpX4
	DMjhCEU2EuqbceIhO19AmjC/dbF17138jXXZmzAsYYd7dq4awzc61zteQTofAO2Lw==
X-Google-Smtp-Source: AGHT+IHYqLGZwcCj8WIVAJW8IX3MTEP6IpYbXuPKVIphZeJfdaSHiOIX5C7fhE1xa3LrvrxWk3YrRhPxvgF6g7kIjH0=
X-Received: by 2002:a05:622a:83:b0:4b2:febb:fc96 with SMTP id
 d75a77b69052e-4b626e89b95mr338601cf.9.1757451958611; Tue, 09 Sep 2025
 14:05:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com> <20250909190945.1030905-5-Liam.Howlett@oracle.com>
In-Reply-To: <20250909190945.1030905-5-Liam.Howlett@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 14:05:47 -0700
X-Gm-Features: AS18NWDhW-RpyHOFHP86Anwyxq8qqVpegZ1q2Iz_pJoyckneNoNTTx8eojGrgpQ
Message-ID: <CAJuCfpEqVNyYtEabhDc4DqHbgJdYXcMvryvfxmXU8uJGe0FdRA@mail.gmail.com>
Subject: Re: [PATCH v1 4/9] mm/memory: Add tree limit to free_pgtables()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, 
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 03D0E1A000C
X-Stat-Signature: p59qttfup9p9gsmbduiuxbocyak3bp7s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757451959-53062
X-HE-Meta: U2FsdGVkX1+L+CItt5bw+rw3Ek6vYHxMHcOBE5pHrIdNWQzBmW/P5i+71MzdA5lQi/bYkStAoCWqbjqEjYMypK4buTKjULxhUzaZfZp9JhbigYr5B9xiq8UArIEbs8WwjWyKbf4d077qB/D3L65PLfHSw8dKi2GIKObCxAW7K6AuhUyKwF6RPw/1MqIwwqR/Hb31QgDc4vMPVwlZGFsEd4gcK2JnpiwujmNK5vcbwdf2qh92BhDzW7MkLfqyQTWy+cagGQ3pmOVWEzmBJhHEe2TamT6TaEzTtQwEnbhiKydmcKIGWjbY7HDTqrRNV1pdZg/eitRj6nt0JAqs9S+zTo63Idlqw7Fjtij8HM77cs3jhEQqgF77p68eNBtGaRUakWjvQl8zoC0d4chrBC2kPaVYTzD9lLixX56NsOHnXfw7zWpXU72uEqAMs7s7iBqY5pqW+ucJfmkIIs2kKTscpyIpwoVUY5Q8YvHGwUqFjsytu8RHiK6pssXqzls+mqLJVt0WiEaGKde8+8lPIZRYGKQDrZE6J7R6EC3dvlJi9jzc9FVaBuTXkeQRfX2Wft8z02mlh3SdTpf9294fWopMpcgB0mRY6qIrpd6KAvS9dgGFbExvJEGkP2fGQg15bs6xVGGBisMbt79YNJZd8ri9m4IlydsWl4TKsjROz9Luj3l2XPCrM8fXkGurkPYQD3iw8ZsC2aEam0uF7aoNMCTmERfgtWjNbRV7otslprm20o1O647TNd2YatYDtxB4BMtuF73fYTM7mH9Kkx+jH1R22lpYh3e1pMWzuy5Wa5y+O7N2pbhOsPVDzzayW4WwoOaYorTeQG9Q0/FjECJo61z6PE0nmnSPKEgY41+LljD3J5OVOI1ShAAsOBzgABup8Njzf7gyO3lE/ndo/4WM07N3LG5sINIAnILyEwI2UcpAutKzAhWmShwqesfmO/9js2t7Zx2y0ZNI84c68VTXO3l
 zK4ws8bL
 RYU9yp8id3WYIuLcaIsjOad9CieNqOoMNPxFIgLLZUz5NTqFSDloah4O5a7Uf37Be3O2T2H3/523aNHnbnIYC1Q4q9iclgnO25aFkF+AKjfm8Gsc52ZQ/6ABCvdmN98G19sYdMNviRdlc3xUJqnlhn2xQQhFoEvmgp/qjoxVeqFg93DHZ/B4uucdJfB05mTaf21Bu92ctQge+6JLFb20hILCsknfUYE8e5GJguV6fEIP2FC5Z/y9zEUoevznlObHzTSR9bmjNcPZ5lv+YbDAQG7wKTdb3dsGjjnzDN1oIKjOugx0074a2nt5bU84WIm4RbZCt7BP8Incl2HM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 12:10=E2=80=AFPM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> The ceiling and tree search limit need to be different arguments for the
> future change in the failed fork attempt.
>
> Add some documentation around free_pgtables() and the limits in an
> attempt to clarify the floor and ceiling use as well as the new
> tree_max.
>
> Test code also updated.
>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  mm/internal.h                    |  4 +++-
>  mm/memory.c                      | 28 +++++++++++++++++++++++++---
>  mm/mmap.c                        |  2 +-
>  mm/vma.c                         |  3 ++-
>  tools/testing/vma/vma_internal.h |  3 ++-
>  5 files changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 63e3ec8d63be7..d295252407fee 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
>
>  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>                    struct vm_area_struct *start_vma, unsigned long floor,
> -                  unsigned long ceiling, bool mm_wr_locked);
> +                  unsigned long ceiling, unsigned long tree_max,
> +                  bool mm_wr_locked);
> +
>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>
>  struct zap_details;
> diff --git a/mm/memory.c b/mm/memory.c
> index 3e0404bd57a02..24716b3713f66 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -369,12 +369,34 @@ void free_pgd_range(struct mmu_gather *tlb,
>         } while (pgd++, addr =3D next, addr !=3D end);
>  }
>
> +/*
> + * free_pgtables() - Free a range of page tables
> + * @tlb: The mmu gather
> + * @mas: The maple state
> + * @vma: The first vma
> + * @floor: The lowest page table address
> + * @ceiling: The highest page table address
> + * @tree_max: The highest tree search address
> + * @mm_wr_locked: boolean indicating if the mm is write locked
> + *
> + * Note: Floor and ceiling are provided to indicate the absolute range o=
f the
> + * page tables that should be removed.  This can differ from the vma map=
pings on
> + * some archs that may have mappings that need to be removed outside the=
 vmas.
> + * Note that the prev->vm_end and next->vm_start are often used.
> + *
> + * The tree_max differs from the ceiling when a dup_mmap() failed and th=
e tree
> + * has unrelated data to the mm_struct being torn down.
> + */
>  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>                    struct vm_area_struct *vma, unsigned long floor,
> -                  unsigned long ceiling, bool mm_wr_locked)
> +                  unsigned long ceiling, unsigned long tree_max,
> +                  bool mm_wr_locked)
>  {
>         struct unlink_vma_file_batch vb;
>
> +       /* underflow can happen and is fine */

This comment is a bit confusing... I think the below check covers 2 cases:
1. if ceiling =3D=3D 0 then tree_max can be anything;
2. if ceiling > 0 then tree_max <=3D ceiling;
Is that what you intended? If so, maybe amend the comments for the
free_pgtables() function explaining this more explicitly?

> +       WARN_ON_ONCE(tree_max - 1 > ceiling - 1);

I would prefer WARN_ON_ONCE(ceiling && tree_max > ceiling); as more
descriptive but that might be just me.

> +
>         tlb_free_vmas(tlb);
>
>         do {
> @@ -385,7 +407,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_=
state *mas,
>                  * Note: USER_PGTABLES_CEILING may be passed as ceiling a=
nd may

You replaced ceiling with tree_max, so the above comment needs to be
updated as well.

>                  * be 0.  This will underflow and is okay.
>                  */
> -               next =3D mas_find(mas, ceiling - 1);
> +               next =3D mas_find(mas, tree_max - 1);
>                 if (unlikely(xa_is_zero(next)))
>                         next =3D NULL;
>
> @@ -405,7 +427,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_=
state *mas,
>                  */
>                 while (next && next->vm_start <=3D vma->vm_end + PMD_SIZE=
) {
>                         vma =3D next;
> -                       next =3D mas_find(mas, ceiling - 1);
> +                       next =3D mas_find(mas, tree_max - 1);
>                         if (unlikely(xa_is_zero(next)))
>                                 next =3D NULL;
>                         if (mm_wr_locked)
> diff --git a/mm/mmap.c b/mm/mmap.c
> index a290448a53bb2..0f4808f135fe6 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1311,7 +1311,7 @@ void exit_mmap(struct mm_struct *mm)
>         mt_clear_in_rcu(&mm->mm_mt);
>         vma_iter_set(&vmi, vma->vm_end);
>         free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> -                     USER_PGTABLES_CEILING, true);
> +                     USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true)=
;
>         tlb_finish_mmu(&tlb);
>
>         /*
> diff --git a/mm/vma.c b/mm/vma.c
> index a648e0555c873..1bae142bbc0f1 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -486,6 +486,7 @@ void unmap_region(struct ma_state *mas, struct vm_are=
a_struct *vma,
>                    /* mm_wr_locked =3D */ true);
>         mas_set(mas, vma->vm_end);
>         free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_AD=
DRESS,
> +                     next ? next->vm_start : USER_PGTABLES_CEILING,
>                       next ? next->vm_start : USER_PGTABLES_CEILING,
>                       /* mm_wr_locked =3D */ true);
>         tlb_finish_mmu(&tlb);
> @@ -1232,7 +1233,7 @@ static inline void vms_clear_ptes(struct vma_munmap=
_struct *vms,
>         mas_set(mas_detach, 1);
>         /* start and end may be different if there is no prev or next vma=
. */
>         free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
> -                     vms->unmap_end, mm_wr_locked);
> +                     vms->unmap_end, vms->unmap_end, mm_wr_locked);
>         tlb_finish_mmu(&tlb);
>         vms->clear_ptes =3D false;
>  }
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index 07167446dcf42..823d379e1fac2 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -900,7 +900,8 @@ static inline void unmap_vmas(struct mmu_gather *tlb,=
 struct ma_state *mas,
>
>  static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state=
 *mas,
>                    struct vm_area_struct *vma, unsigned long floor,
> -                  unsigned long ceiling, bool mm_wr_locked)
> +                  unsigned long ceiling, unsigned long tree_max,
> +                  bool mm_wr_locked)
>  {
>         (void)tlb;
>         (void)mas;
> --
> 2.47.2
>

