Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD30CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 22:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48A48E0003; Tue,  9 Sep 2025 18:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D27C8E0001; Tue,  9 Sep 2025 18:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A0F8E0003; Tue,  9 Sep 2025 18:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 717678E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:27:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E913111A79A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:27:29 +0000 (UTC)
X-FDA: 83871149418.20.445C8DF
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 170324000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:27:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=z9N6Cqci;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757456848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8BzVWhX0R5cEUCY7Xkosw1VZPrvaUx+cbbGdJLdaNY=;
	b=NLk39KNYx83Yb74LTO6kkKQmBt9Fh2gx7AgQS1MsS6tKQoNHTJf5wQ5B1oFNpfn9NDAVCM
	h1qHXwLnOPVu8WzUzXZYYPHx6ur2cql/C19ZF2aHg2U+vNkVcAlprZ2e7YCTf8Nn19RJLA
	FiaJ1yw+Y8DWBPT9gtqnCADnnUma3CU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=z9N6Cqci;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757456848; a=rsa-sha256;
	cv=none;
	b=HFVqBVZnu8a2YlgVr2VFcBCAAsPGZEAUlo5eWkzXHu1HJjoXeUEGrqF1KHo+XAgB/Uk/5W
	qHGQOfyAle57u8ZF3UCrOJMwAgYKC14arrGXyqUIvwypP6zkVANzNEVwpKEkIt+PutHRkW
	ATlbilkerMMiwRSApUkTwxJA0y75eFc=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b350971a2eso39891cf.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 15:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757456847; x=1758061647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8BzVWhX0R5cEUCY7Xkosw1VZPrvaUx+cbbGdJLdaNY=;
        b=z9N6CqciMDLGSYbzMQ8HtacDw//7byqZiN8Qb1Pq8llJ2k2l67hlwcd+FC6mPc7fGh
         T4N9HfPimIYqkz9cpLHhH1UPJsCpmgKyAuTVerYbfkg0mRsh9XhbC9g8eErUiX91ZvnX
         GY5x6jNnLpRvpx59JPtA2u5KJWNsKplgSAYzHiKA54tqw07SnYwiYQIzAkAhidq65SSi
         AEcohJbJT/jf7nB0TPNVMEg8JWqD+0ypkDzaiDOd5/8HaBrVtrTh/YHAeuwERS0Uerpz
         ioBQn9d8imdR4v02c02Cs1LH4jaE85ELZPQUtnKj68TadghFkuARwlAveBPclmA7pJir
         nzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757456847; x=1758061647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G8BzVWhX0R5cEUCY7Xkosw1VZPrvaUx+cbbGdJLdaNY=;
        b=X6wbXLriSh6oJ4B3hjUM7s4lkw+vtwBSXcOGeUeslnDWDYNrbA6wj4++xJZeHHwHyY
         vqvboTZ99GcSkU1XL8sQqpzihGrsHfLd0cQPag1x52baMb7cU7vowIUmfu9iypDhSqxk
         tPXS9mFFvmCZiM38Q0hnVawO7ErcEmHhLMi2k41FTAKp8rcn7peJay3O+ODVKJuMAl4V
         /ELX6L9H1uA7KoLQG8Bq+RiFPZYkuXyZkZcNnCDptFEREEF9GSGZ2s3Ei1LJuFepBP6l
         b97DSZIOsBG7H0JsxfSPnnkxI5rA+KumaGtd/ca3RGV4sl/5JX9SL3x70mGYvWiEN3cS
         q4DA==
X-Forwarded-Encrypted: i=1; AJvYcCVXZ2acIwmzBydZMydw5PVmQPcDct6wcGHaW2sDkwPK2tL6eKtUO/zz1Yd5TZ9Z/ByPi5rUkhYHgg==@kvack.org
X-Gm-Message-State: AOJu0YwscUvuHHTKZ2957LePbUAz3sUDGCJl20jEIIDNsMlpPtA4sQUX
	KthEznQhFa0EOl6swy1UFcGjNc38Mu4zVSNoXgfMwmn5T0J6XSECCssKE31o2x6Pz4/lnr7n6BG
	mMDM0fgQ/opP2IVao/cyJKqw1zqqfuF7DdkpH/j14
X-Gm-Gg: ASbGnct/6KdYjOMToHQMiqTLf2od0JjW1yABcOBNR0Ks7YJRD14e1T2YZosm12H1UlE
	HZLg6Arj2B25lu5BfZ4baYVqeBXDY4wevXQe4nObSC6Gy2DetpiYJ9HWIAhqSlVMjVACVqqwhk+
	DSzHK67o4EiMcULE30s63RucKlWcotF7i7Aab83kqFoT6wIja3NVSxGoLiFguzLl4IqqlJcBWDD
	qWD5TljMB0Q1T2oNEp4lNwbK+enahpmeutJVUDprRJJ9Knry/e10o8=
X-Google-Smtp-Source: AGHT+IEdGi/d24y72Sxmx6WAkfXK/iDy1MEOtaD5CvEAQeQEYkSu881knGHU9baU8fe1W1ZSjLG2XGRiAndq5H5katk=
X-Received: by 2002:ac8:5d09:0:b0:4b3:46e4:38ee with SMTP id
 d75a77b69052e-4b625174b03mr1814331cf.6.1757456846670; Tue, 09 Sep 2025
 15:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com> <20250909190945.1030905-10-Liam.Howlett@oracle.com>
In-Reply-To: <20250909190945.1030905-10-Liam.Howlett@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 15:27:15 -0700
X-Gm-Features: AS18NWDFXXcz2H0b4WCBtGCngTAlRviZ_OVajr-POu4PX9407-Nsa_TiEj-HyIA
Message-ID: <CAJuCfpHp2sgKBqrfyn+xfCJTA-AFGFUTdhSz4dxNff=SNYLJgg@mail.gmail.com>
Subject: Re: [PATCH v1 9/9] mm: Use unmap_desc struct for freeing page tables.
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
X-Rspamd-Queue-Id: 170324000E
X-Stat-Signature: dtpcp8d3s9ucw8gsb8moaijuwp1bm8ei
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757456847-139116
X-HE-Meta: U2FsdGVkX1+9Krt5wgdoTJilGW7zZ+7NXLlNQvmmmaXo2QvMgzcQHlpVpD2FX8uCVDsMVrMAOMy36fjF4/lP1omAdFjxWa5O7dhzyEqLFsqIF9+pnk9x6CWyaOh11v8yG+CQ031NBYwbJ0kTa9kIvyU2SO4r/ImqaTBLtFPDpKbcSYrjicvMZ/ywS0CAmcBh2BwqzYd538+iSRDlUrZgsYdk4dUbEQ9JLf3G7S9YREMUDUv9jPR0yGDxldjpipMahLiBuTH/UeSPKg72sCJ3Yv6eVNr/Vh0YcilzsK+rcjXwhFQzgYL193s3NczS6vHlFJr3yP4gFpmcFiPAb+sw52G2P37F64vwhAXwuewhYFdoZ0PHuU07TdbWwLkfIWErjszZXP/2c+OUhUibFwd2lAppPpIB35SO2aElpqsqwNOKzf/Bsvc2Cu4ryS6LiX59pn/sWVDPwq3K08Sdrr2PB9C7AyZYW05yQRST2B8mdEeGONShBKbGXPD2qYO/tcxuKuiPfYhPngq43Btj4L9h5+49FGKOk8H6F4qn4SRTKH2pcjJFx5wOHZMdkVeT+EdIrhgHU/4k4sUKYCLIimNaYJuRCzFeVN9p74PnaHymdIMlmlZOb/5/npVjdeTHmwGGo/Ebhv7YD74U2g7JMb79C0h+O+UYLz7YvZ52wDabEYgLp4M2EDtDpEjyoJnOUjXOz45MS8rW8minwqxCzlhTTEbJpja3qMxhvBcPZXRO9KXyb28RkzrKPIfqgpOVPOFYoA0RpAcHb7v4iQMCzzAhRFwAaOOJy8ZREmy/ntwRhvTIRjtFJtputrrRkrECe1CT4kQpWrOvP3CuC++ovg0I4vhi8HVl5JUhcjEkoseowzDuFda7ny5/hU6pgXm4z9E8ablSfQk6mSxoI3caGsLXKWBDzSbn4poaqs0aNdvJsouSAAdUvFiELHnGGAr0NVAFC++hVfVHmuGAjPuvgu/
 tdRYmTrB
 j2uLVxoSfT35YX859mxNPg9h4E/JwvYnH4be2g3snUFDXOkJ5U0vkE0fTf63HL2+HZYPkpd6TDF9tUABXgnu9IGVVu+cEEatJwxisaCsWe5NcrGKqxaHvqXsB1/rHx1QLWfnbjlKEEh+TOo7/j5UQMK9iqlDOmQGSTruVwgqtnNLmqjdXNZ9ummFNyXHiWxaX08ZUUBF+5k6FIHSv2hC4j3BP+7sWXC1jog2GUnZ7NQzbJx9kAbXDHQisVLnzRTjWdG8ZM/7YpTCj5i9iEf4qR5I5usmoXLIZ4QX63KCMR/l4LdIgacILodKPgmysuTgo/vF5
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
> Pass through the unmap_desc to free_pgtables() because it almost has
> everything necessary and is already on the stack.
>
> Updates testing code as necessary.
>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/internal.h                    |  5 +----
>  mm/memory.c                      | 21 ++++++++++-----------
>  mm/mmap.c                        |  6 +++---
>  mm/vma.c                         |  7 ++-----
>  tools/testing/vma/vma_internal.h | 11 ++---------
>  5 files changed, 18 insertions(+), 32 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 1239944f2830a..f22329967e908 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -445,10 +445,7 @@ bool __folio_end_writeback(struct folio *folio);
>  void deactivate_file_folio(struct folio *folio);
>  void folio_activate(struct folio *folio);
>
> -void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> -                  struct vm_area_struct *start_vma, unsigned long floor,
> -                  unsigned long ceiling, unsigned long tree_max,
> -                  bool mm_wr_locked);
> +void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
>
>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 8d4d976311037..98c5ffd28a109 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -387,15 +387,14 @@ void free_pgd_range(struct mmu_gather *tlb,
>   * The tree_max differs from the ceiling when a dup_mmap() failed and th=
e tree

"ceiling" is not a parameter anymore, so the comments should also change.

>   * has unrelated data to the mm_struct being torn down.
>   */
> -void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> -                  struct vm_area_struct *vma, unsigned long floor,
> -                  unsigned long ceiling, unsigned long tree_max,
> -                  bool mm_wr_locked)
> +void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc)
>  {
>         struct unlink_vma_file_batch vb;
> +       struct ma_state *mas =3D desc->mas;
> +       struct vm_area_struct *vma =3D desc->first;
>
>         /* underflow can happen and is fine */
> -       WARN_ON_ONCE(tree_max - 1 > ceiling - 1);
> +       WARN_ON_ONCE(desc->tree_max - 1 > desc->last_pgaddr - 1);
>
>         tlb_free_vmas(tlb);
>
> @@ -407,13 +406,13 @@ void free_pgtables(struct mmu_gather *tlb, struct m=
a_state *mas,
>                  * Note: USER_PGTABLES_CEILING may be passed as ceiling a=
nd may
>                  * be 0.  This will underflow and is okay.
>                  */
> -               next =3D mas_find(mas, tree_max - 1);
> +               next =3D mas_find(mas, desc->tree_max - 1);
>
>                 /*
>                  * Hide vma from rmap and truncate_pagecache before freei=
ng
>                  * pgtables
>                  */
> -               if (mm_wr_locked)
> +               if (desc->mm_wr_locked)
>                         vma_start_write(vma);
>                 unlink_anon_vmas(vma);
>
> @@ -425,16 +424,16 @@ void free_pgtables(struct mmu_gather *tlb, struct m=
a_state *mas,
>                  */
>                 while (next && next->vm_start <=3D vma->vm_end + PMD_SIZE=
) {
>                         vma =3D next;
> -                       next =3D mas_find(mas, tree_max - 1);
> -                       if (mm_wr_locked)
> +                       next =3D mas_find(mas, desc->tree_max - 1);
> +                       if (desc->mm_wr_locked)
>                                 vma_start_write(vma);
>                         unlink_anon_vmas(vma);
>                         unlink_file_vma_batch_add(&vb, vma);
>                 }
>                 unlink_file_vma_batch_final(&vb);
>
> -               free_pgd_range(tlb, addr, vma->vm_end,
> -                       floor, next ? next->vm_start : ceiling);
> +               free_pgd_range(tlb, addr, vma->vm_end, desc->first_pgaddr=
,
> +                              next ? next->vm_start : desc->last_pgaddr)=
;

Much better names IMO. Thank you!

>                 vma =3D next;
>         } while (vma);
>  }
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 6011f62b0a294..9908481452780 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1311,10 +1311,10 @@ void exit_mmap(struct mm_struct *mm)
>          */
>         mm_flags_set(MMF_OOM_SKIP, mm);
>         mmap_write_lock(mm);
> +       unmap.mm_wr_locked =3D true;
>         mt_clear_in_rcu(&mm->mm_mt);
> -       vma_iter_set(&vmi, vma->vm_end);
> -       free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> -                     USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true)=
;
> +       vma_iter_set(&vmi, unmap.tree_reset);
> +       free_pgtables(&tlb, &unmap);
>         tlb_finish_mmu(&tlb);
>
>         /*
> diff --git a/mm/vma.c b/mm/vma.c
> index ad64cd9795ef3..ba155a539d160 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -476,16 +476,13 @@ void remove_vma(struct vm_area_struct *vma)
>  void unmap_region(struct unmap_desc *desc)
>  {
>         struct mm_struct *mm =3D desc->first->vm_mm;
> -       struct ma_state *mas =3D desc->mas;
>         struct mmu_gather tlb;
>
>         tlb_gather_mmu(&tlb, mm);
>         update_hiwater_rss(mm);
>         unmap_vmas(&tlb, desc);
> -       mas_set(mas, desc->tree_reset);
> -       free_pgtables(&tlb, mas, desc->first, desc->first_pgaddr,
> -                     desc->last_pgaddr, desc->tree_max,
> -                     desc->mm_wr_locked);
> +       mas_set(desc->mas, desc->tree_reset);
> +       free_pgtables(&tlb, desc);
>         tlb_finish_mmu(&tlb);
>  }
>
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index d73ad4747d40a..435c5a24480bc 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -892,17 +892,10 @@ static inline void unmap_vmas(struct mmu_gather *tl=
b, struct unmap_desc *unmap)
>         (void)unmap;
>  }
>
> -static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state=
 *mas,
> -                  struct vm_area_struct *vma, unsigned long floor,
> -                  unsigned long ceiling, unsigned long tree_max,
> -                  bool mm_wr_locked)
> +static inline void free_pgtables(struct mmu_gather *tlb, struct unmap_de=
sc *desc)
>  {
>         (void)tlb;
> -       (void)mas;
> -       (void)vma;
> -       (void)floor;
> -       (void)ceiling;
> -       (void)mm_wr_locked;
> +       (void)desc;
>  }
>
>  static inline void mapping_unmap_writable(struct address_space *)
> --
> 2.47.2
>

