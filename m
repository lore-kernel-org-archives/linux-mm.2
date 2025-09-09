Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20264CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 21:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642B58E000C; Tue,  9 Sep 2025 17:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616008E0002; Tue,  9 Sep 2025 17:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504F68E000C; Tue,  9 Sep 2025 17:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD4E8E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:44:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C0C4160763
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:44:22 +0000 (UTC)
X-FDA: 83871040764.15.7E0297C
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 721C44000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:44:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KmFnVsyA;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757454260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cORFDYgvyY2ZoZSCiHszBh/KszgVx6wKBPF6YytGcNM=;
	b=cVaBZYTkA9G0dSFSHU3XJ+Bl7cdjLE6kpJVMvskhs+/6Axy5xbmBmRW7KD9lgHZygiBcNa
	NUHQYA3pc9FVD1S5EjxiVj/XKfgzm4ZwZJQ3GIu0/sm8L3z9+7zMlOvxmGQjn0Hk3wRRNd
	bOcqTIvR3u1HOiqFLXY6/xM7OHpozU0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KmFnVsyA;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757454260; a=rsa-sha256;
	cv=none;
	b=R6mSBVeB9n9jGtsi9gGmyGD2MtFLZ7F0wjCZCEnXdZr7Skc4zSb4K3DUn0NMy0OUG+YlTW
	hdk73iCJteL/O0IxNmdRqnBRJYlydHBWAGZLSLmnP9BgiXyOCo/6+x0E5Oa5A+ua+VqWz9
	5qpm/u8pfs1epEyL+jM3qPVS8wV1SFM=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61cfbb21fd1so3907a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 14:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757454259; x=1758059059; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cORFDYgvyY2ZoZSCiHszBh/KszgVx6wKBPF6YytGcNM=;
        b=KmFnVsyAMdDv1KNH9chJ8g98ra9OPtrFVRIpIYEGLATsybMM9nvO9IdBxUkk6w6jFO
         Rr87Eh53s51leNPEEDacU/8aDKcr9WKLF11oxd1ywBLAclJKuk/vXXGqWHo7P92J4FvD
         BqSofqwyNbScvTXmWNrTY2qXcCFolywFA3Enb8+iJsnEnFlBoP6Ti9MhCRfCyRh8HzKC
         MECoFXZvTUircE28JIgh32C5l0vm6i8zAjBqVBUxkAOEfo2gHG2coc85FaDn3XPWBUuS
         6KAkrnsHShh5r3C+t8MQf/vlN5yxUkvaDOo6gkloDEcrX1foEwbjbnG/XrTR/3+lOKhm
         FW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757454259; x=1758059059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cORFDYgvyY2ZoZSCiHszBh/KszgVx6wKBPF6YytGcNM=;
        b=H/+G9aqrwPN5Z0UJXL6dQFhkHlIqA8/UwjUu4kOKppFXqrqkpIsvgNnvgAaBcCQpk/
         kvOj4NJHteL+rnxHglbn+isQMx13fNaByUd+fyaVoTQYrQUMJdqwl///HdTSRJiRG+Te
         hbodipkzIZMkSD6gKN8xytTXo/w6PpyAq0yaJd9DtzhnM/HQiEcrA3cOP1gKef161H97
         hWd8WrPnIyFHQTSjyo6rgyLrYsHZ4I7VfNF3E//hcG75/kA9CPSL6aVqrludDxm7QhT/
         QofZ0OcDSb0aqRWcFi3xA3p+uH2dyhlUlOaUE43hTsA5FTug642R2jIs4m2/qx7AH3Jt
         71JQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9/SJTuqEQXjKFA/q1k79RCjDUA4a0HXnWycWn4L44D8I58uxA+WC/mWrXoHZWQy3fsqSJnAWJzw==@kvack.org
X-Gm-Message-State: AOJu0YxO49udCAIXjr0F+TKlddL7y8tdix+Xbaf2iAFFLiSaBKnVGhev
	HGAgZle956rFknT4bTWetdRKkbZs1LvN1BE6oSwGF2jTRrPBIDJrsUyIwoeWbl3cvcbyi0dHAQc
	Q/oUbrwcjiN01rWeYTUHafB30AYFX0ASSMICdjt0D
X-Gm-Gg: ASbGnctr14pRI79LwuxuZJuXqGMZywyckc74cWMAFRMQKSNe3ewXOPX/g3+NjXUPCb4
	URJuV9+Tb33FttQngRqpRtumk+3I18+Ymxold90XGASLTiNZIxPsEiXusxIXkndzM+OuDIlDopL
	mDu/j66JUiPkzekwhXyOPCTVvziScSA9AlnBZH10gZo8c65JSOpcQiaVuW3y5RkzbsPsxspQv9Y
	unvfAiSibWZUlugokma/SKpinVkQ6aeXsQTd2vGWBD7
X-Google-Smtp-Source: AGHT+IHHjSzf3NV2oNZ+4jCL+Q3CGiZLU++ghIuFZUaAwP39HPwBNCyTkdmKOXeri3KEzlLXlrupijbAwtkieYahwpc=
X-Received: by 2002:aa7:d392:0:b0:623:27a7:25fc with SMTP id
 4fb4d7f45d1cf-62d4e6c02d0mr6933a12.5.1757454258460; Tue, 09 Sep 2025 14:44:18
 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com> <20250909190945.1030905-8-Liam.Howlett@oracle.com>
In-Reply-To: <20250909190945.1030905-8-Liam.Howlett@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 14:44:05 -0700
X-Gm-Features: AS18NWDp7h4tRRYW9-ZNijDGSt7aO40ogQOfSscUNHcKVszsllLYH7lJ_PsLcVQ
Message-ID: <CAJuCfpG4D4ikZO1c8zN7HNgLTAco1ggk21rg9AUFwoztA95qSA@mail.gmail.com>
Subject: Re: [PATCH v1 7/9] mm: Introduce unmap_desc struct to reduce function arguments
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
X-Rspamd-Queue-Id: 721C44000A
X-Rspamd-Server: rspam05
X-Stat-Signature: d3hzwrq1oq9mr43ikrtxnirb898nqc3d
X-Rspam-User: 
X-HE-Tag: 1757454260-582719
X-HE-Meta: U2FsdGVkX1+Q4/EtiGlApRFPFS8e9cYal8KBxprHPea00uP+h+z0gb5F/rcoOfRXZ5kTijmSjW/5yafbjaU9s14vax5TZAQUIyfm7ZYr/fCSNGE31jw8Dm8TjrPtmCluBOllF38Ax+3nwDT8eQhdw6EXxOErYgcfG3Wn/cgJcYlltEwpKG1+sc/or4dnXdBEVoEMYxV1AvoPs8+AdwAmHyPwyk5cTVE7ekrpU0NJ4tHRaGspsJ5IImmN/0UZe0vto5guXm8T83uz/EtcuBiG47KfIQrKlx9XrgU/78157SxZzkFKfHJr7h00FgInGJzQWbutHFT3SrCMnsN22Q0fbSDFF8BVEk1Qt2ubvdSRItJVz27I25CRmAeVtDEfkx8o2NaL6nykbdvkoup5X+dsS+GEKzqtiLFPOyv1xXVoLmTQpwG1QA+blm0i1swjAsoFfCJDZFC+XHGCW1Tq5ss9DvxMhX289cWwDFscuiVhtowoVBh6x9t2HmOsLXOfdvK5LbT0kaiXQ+AUPExGF85d+iDNSRc9l3Rn3Zbo9Sm5r+s76Lx9antkND8sXWIaUzIaBLWz5GzG4tTq/zz4l8G344D1PoKSHp0Jj87czYlb0v5K85TmrTtGewusqpHD6S7JImq+l/MrCxHWgMhtM0kppO/370o30+96EWRqlNJiZaIwRqmbm8OgEDxIVJMwEHLXYUjCaI1QlYuIzzAA0in0IGN7piuwsTG3nE5DiQQ16BuNz+RtTTQqBRMeZnVZHQNNOmPdvDVsN95plhw2yoQp+Poz1QzJJ89mLMvLt4gvfds38z6qVyeiBtjsrPwFgKnzIN5JsKNZSxxgHKlhjJb/Kr4n0LwxDmIeAZ3cgHm3u7FAfvDJnakSSn7RxpraZ236mzmRzDwv0we5KEkoy4rM6AIc569OB3ynFT/pWr6GrKuWq9BonhR3CVaEVE+7qFwyRBZyNhe8XZNytASdXHt
 eYRC+/oW
 KYiTKa7PWsblDAk8bZcjAmd41Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 12:11=E2=80=AFPM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> The unmap_region code uses a number of arguments that could use better
> documentation.  With the addition of a descriptor for unmap (called
> unmap_desc), the arguments can be more self-documenting and increase the
> descriptions within the declaration.
>
> No functional change intended
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  mm/mmap.c | 12 ++++++++----
>  mm/vma.c  | 27 ++++++++++++---------------
>  mm/vma.h  | 35 ++++++++++++++++++++++++++++++++---
>  3 files changed, 52 insertions(+), 22 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index aa4770b8d7f1e..5c9bd3f20e53f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1883,11 +1883,15 @@ __latent_entropy int dup_mmap(struct mm_struct *m=
m, struct mm_struct *oldmm)
>                 if (max) {
>                         vma_iter_set(&vmi, 0);
>                         tmp =3D vma_next(&vmi);
> +                       UNMAP_REGION(unmap, &vmi, /* first vma =3D */ tmp=
,
> +                                    /* min vma addr =3D */ 0,
> +                                    /* max vma addr =3D */ max,
> +                                    /* prev =3D */ NULL, /* next =3D */ =
NULL);
> +
> +                       /* Don't free the pgtables higher than the failur=
e */
> +                       unmap.tree_max =3D max;

Sorry, the naming still feels confusing... tree_max is described as /*
Maximum for the vma tree search */ and here we set it to /* Don't free
the pgtables higher than the failure */.

>                         flush_cache_mm(mm);
> -                       unmap_region(&vmi.mas, /* vma =3D */ tmp,
> -                                    /*vma_min =3D */ 0, /* vma_max =3D *=
/ max,
> -                                    /* pg_max =3D */ max, /* prev =3D */=
 NULL,
> -                                    /* next =3D */ NULL);
> +                       unmap_region(&unmap);
>                         charge =3D tear_down_vmas(mm, &vmi, tmp, max);
>                         vm_unacct_memory(charge);
>                 }
> diff --git a/mm/vma.c b/mm/vma.c
> index 4c850ffd83a4b..c92384975cbb2 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -473,22 +473,20 @@ void remove_vma(struct vm_area_struct *vma)
>   *
>   * Called with the mm semaphore held.
>   */
> -void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> -               unsigned long vma_min, unsigned long vma_max, unsigned lo=
ng pg_max,
> -               struct vm_area_struct *prev, struct vm_area_struct *next)
> +void unmap_region(struct unmap_desc *desc)
>  {
> -       struct mm_struct *mm =3D vma->vm_mm;
> +       struct mm_struct *mm =3D desc->first->vm_mm;
> +       struct ma_state *mas =3D desc->mas;
>         struct mmu_gather tlb;
>
>         tlb_gather_mmu(&tlb, mm);
>         update_hiwater_rss(mm);
> -       unmap_vmas(&tlb, mas, vma, vma_min, vma_max, vma_max,
> -                  /* mm_wr_locked =3D */ true);
> -       mas_set(mas, vma->vm_end);
> -       free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_AD=
DRESS,
> -                     next ? next->vm_start : USER_PGTABLES_CEILING,
> -                     pg_max,
> -                     /* mm_wr_locked =3D */ true);
> +       unmap_vmas(&tlb, mas, desc->first, desc->vma_min, desc->vma_max,
> +                  desc->vma_max, desc->mm_wr_locked);
> +       mas_set(mas, desc->tree_reset);
> +       free_pgtables(&tlb, mas, desc->first, desc->first_pgaddr,
> +                     desc->last_pgaddr, desc->tree_max,
> +                     desc->mm_wr_locked);
>         tlb_finish_mmu(&tlb);
>  }
>
> @@ -2414,15 +2412,14 @@ static int __mmap_new_file_vma(struct mmap_state =
*map,
>
>         error =3D mmap_file(vma->vm_file, vma);
>         if (error) {
> +               UNMAP_REGION(unmap, vmi, vma, vma->vm_start, vma->vm_end,
> +                            map->prev, map->next);
>                 fput(vma->vm_file);
>                 vma->vm_file =3D NULL;
>
>                 vma_iter_set(vmi, vma->vm_end);
>                 /* Undo any partial mapping done by a device driver. */
> -               unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
> -                            map->next ? map->next->vm_start : USER_PGTAB=
LES_CEILING,
> -                            map->prev, map->next);
> -
> +               unmap_region(&unmap);
>                 return error;
>         }
>
> diff --git a/mm/vma.h b/mm/vma.h
> index b0ebc81d5862e..4edd5d26ffcfc 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -152,6 +152,37 @@ struct vma_merge_struct {
>
>  };
>
> +struct unmap_desc {
> +       struct  ma_state *mas;        /* the maple state point to the fir=
st vma */
> +       struct vm_area_struct *first; /* The first vma */
> +       unsigned long first_pgaddr;   /* The first pagetable address to f=
ree */
> +       unsigned long last_pgaddr;    /* The last pagetable address to fr=
ee */
> +       unsigned long vma_min;        /* The min vma address */
> +       unsigned long vma_max;        /* The max vma address */
> +       unsigned long tree_max;       /* Maximum for the vma tree search =
*/
> +       unsigned long tree_reset;     /* Where to reset the vma tree walk=
 */
> +       bool mm_wr_locked;            /* If the mmap write lock is held *=
/
> +};
> +
> +#define UNMAP_REGION(name, _vmi, _vma, _vma_min, _vma_max, _prev, _next)=
      \

Maybe DEFINE_UNMAP_REGION() similar to DEFINE_PER_CPU() or DEFINE_SPINLOCK(=
)?

> +       struct unmap_desc name =3D {                                     =
     \
> +               .mas =3D &(_vmi)->mas,                                   =
       \
> +               .first =3D _vma,                                         =
       \
> +               .first_pgaddr =3D _prev ?                                =
       \
> +                       ((struct vm_area_struct *)_prev)->vm_end :       =
     \
> +                       FIRST_USER_ADDRESS,                              =
     \
> +               .last_pgaddr =3D _next ?                                 =
       \
> +                       ((struct vm_area_struct *)_next)->vm_start :     =
     \
> +                       USER_PGTABLES_CEILING,                           =
     \
> +               .vma_min =3D _vma_min,                                   =
       \
> +               .vma_max =3D _vma_max,                                   =
       \
> +               .tree_max =3D _next ?                                    =
       \
> +                       ((struct vm_area_struct *)_next)->vm_start :     =
     \
> +                       USER_PGTABLES_CEILING,                           =
     \
> +               .tree_reset =3D _vma->vm_end,                            =
       \
> +               .mm_wr_locked =3D true,                                  =
       \
> +       }
> +
>  static inline bool vmg_nomem(struct vma_merge_struct *vmg)
>  {
>         return vmg->state =3D=3D VMA_MERGE_ERROR_NOMEM;
> @@ -260,9 +291,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm=
_struct *mm,
>
>  void remove_vma(struct vm_area_struct *vma);
>
> -void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> -               unsigned long min, unsigned long max, unsigned long pg_ma=
x,
> -               struct vm_area_struct *prev, struct vm_area_struct *next)=
;
> +void unmap_region(struct unmap_desc *desc);
>
>  /* We are about to modify the VMA's flags. */
>  __must_check struct vm_area_struct
> --
> 2.47.2
>

