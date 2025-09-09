Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96098CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 22:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9D08E0002; Tue,  9 Sep 2025 18:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881468E0001; Tue,  9 Sep 2025 18:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796E88E0002; Tue,  9 Sep 2025 18:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6848E8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:16:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B462BA7C6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:16:31 +0000 (UTC)
X-FDA: 83871121782.14.257C890
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2248B16000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:16:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LSfT86pC;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757456189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UED7BejBHlF/77adf0K9Lgcj4lQwJd8bxj9aaOqzio=;
	b=PcKjc13kM9VH+OYuWJK7hJ79mXKpaBWmcPNiOi/Tc6ktscE7rq73WB1fAlRxsohnjAwWFx
	qz9GyIE70jbkA79XQMGraT+QS/orsaj0XqN7vUKKhwHXbw2u9tKgDw3u8pxu26NUC1LCjk
	tSbaopWvABL+a0fIbRIJJLvYLdsq8EM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757456189; a=rsa-sha256;
	cv=none;
	b=cOQGjAWY3NKYIJS1rDJ8KqLwgmA/9MSAggJCx4DjUqyKSD5iaf6fsR0IpiaJZfhPQrWyow
	ZcGGJpX8xgDtLjIgcffncSqAHfTz4qaYmD5w0gqoys3aaN1XYqHZ7hExB3hyZoTzT57WzL
	RzuH003uf37bO8H2fIpQvaDdwZBF4Yg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LSfT86pC;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so159101cf.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 15:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757456188; x=1758060988; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8UED7BejBHlF/77adf0K9Lgcj4lQwJd8bxj9aaOqzio=;
        b=LSfT86pChREvW8iJ061nfdTcEhe0o8+bPNSQIaMeOosXSEuq0tr2jgSLUx1W+SpNFd
         mJ5HwjCqI5ibWwGwZX+SgadOnClCGXgOsl5h8J3zlZkCNFlBVi7/q8Dlxi3h6km0sRiN
         /7YzMz+NJFh8nKL2d3+aImvYEZSIUvkWlNSR0d/MvuMWqAaFmMk8R+X/kT+lnDh0Y904
         WjkdDvtRZbKQURTeNqsmXOk+pRaqJHn3yR/1TKmCS4CyPMGavDXKeo9v4JqEpP8aYs2/
         bMpHdFi7XoLCcph0JQUTUAsjlh9GalximKkdNhm6dQYESkQLoA6dQA4F/tKkwQALStNj
         ORdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757456188; x=1758060988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8UED7BejBHlF/77adf0K9Lgcj4lQwJd8bxj9aaOqzio=;
        b=k0a8p4SI4QL33NzYehPPVPyW3/TmiHVkj3iIzOpmA74JcYC3G0omUoSunyv2FhymI4
         cAk3GzD+F1OzqMRApf0VoNvwyH25aPykBYTCmjxdMt6fl1I6GQPddtEqiJ5aaRLYPZtG
         J83XrvcxPiCeLnas5XxSM3I4iLvJWnF5VY9pEN0n6U83mt2IitcYwA3I6l+YPupMJNbL
         /osifCHp27aKkzizFjCX4ILANI4Zo5A7R9EEYFmjMwCyZqxIUUiWFos8bfFqu1wAXXrN
         CmLFlgqxleg/L9j5FJVOuzFBXQRxJObdlS1QoRjzLjszETlaas4SH4Y+UbB4kKPM0FR9
         AvSg==
X-Forwarded-Encrypted: i=1; AJvYcCUuYJiYeQWXeucBqpgfz4waQYohXovbhs8CySuDf14plPhIc8pFP0xkirTH6WPPy+DJ+pCDfCLZ0A==@kvack.org
X-Gm-Message-State: AOJu0Ywc2kYaqUsSyCecrMQPcV4p1eafX7otOET982lGjSBpAyRAHiHs
	G0z2aF50cv1kjw+pFG3LKQWSvpZjVbcyZPDRTJ2QixTBlS+oRYW25uobOnQGgi/yoFb/U6iq4+e
	XNzbxprFuGUcWQd8/HMCgd4kIU0FPalEp08r9JNll
X-Gm-Gg: ASbGncubyB9xx1pHXXnzZ3GvRor555Emq6IJIA2OigawYJI89NmcdqM5ATBLFZ6sr4x
	pB5LJW6aaXmfTM6C4kwVNE5RNgzXABSSwdr5ZZ1e4fMw2Txcv0z8s5jvewVUQOLT6mJGOED3fF3
	Nxc3AXjkp+nQm5GA2IUn4QgdsmUQtXJRoWlWBHuQUbMRGi4RZLdjQoBIFZ4stasw6/Og+SPi58Q
	Au/YyU1Pridu3vhuRpkCOHg/muesTDMHiJGltDppNi0
X-Google-Smtp-Source: AGHT+IEcXgBXlv8XPNCxv6BkbMGmnKO+vkjF7bIJRkUFgM/Y8hmvK9zA4Y0Tpy1PvYPFWYUJApeFEFOuOBn4s9kvME8=
X-Received: by 2002:ac8:5fc4:0:b0:4b4:9590:e091 with SMTP id
 d75a77b69052e-4b626eb8d89mr803731cf.5.1757456187636; Tue, 09 Sep 2025
 15:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com> <20250909190945.1030905-9-Liam.Howlett@oracle.com>
In-Reply-To: <20250909190945.1030905-9-Liam.Howlett@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 15:16:16 -0700
X-Gm-Features: AS18NWCg20zYnHtLpwe4CYG1V6SoxxfcPtcH39dZBp2f7xr11kxNoKhH3k65OYs
Message-ID: <CAJuCfpFGo4JXQQGECFdCgNNVaQc5MDLghdmnVXEK8Zfag7KHiw@mail.gmail.com>
Subject: Re: [PATCH v1 8/9] mm/vma: Use unmap_desc in vms_clear_ptes() and exit_mmap()
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
X-Rspamd-Queue-Id: 2248B16000B
X-Stat-Signature: i1uqrczo368pptawrqaby4p974mgxoq3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757456188-326358
X-HE-Meta: U2FsdGVkX18KoU97hJySHNurwlKyHV3vrqTNtV2WIr6wuIPugNhBt5oacq6PVDSo2cwl1WTslYuxbLH2Pq6KPwbfDmGsRWkAKZUGIdXdSfD1Z4NPiUUyCVS+7lTxGEfpAi8lFcjs6TYNdfnbc+BOj/t8RmoHvJW2kNU1bpbDgC31je71hNiJtrtiEXi2eYHBSMkPx5/SemTOuar8yeHPPXU+tGQswYvy1tzgK16Af/IfK0Tgbq/Xoo2GJzgkem1SFLeJK3sa1S5Eb4rVk81Ots/ZGB0OS8Cbn2Yg/J/3tc1p1/mqKa12ribvE9NdplK6ue5Jzt2LAaCicaHItEA/CpEeCuQhlzZNiZvtGsWYFEpJd+YhMj0DneK+6za8yw6CWLRl7zoTVlY+np/B3tgPt7uHSQbNBTnRSjIhe0+4WIQOVKDEgwfDa5tzFX+UPRDK3HYb4xWstnONm9s4XVd6CwXkmdzVwvz8SLYEmE3OsBMvHDQoRajBcVngEZ4Een1dexUttStNygJ4+lz8fXx/BgKZI1r5uqk76SU05yOLzMeGqy66enhCDUG78Y58IaBeWfR5L1zp6X+NZkRE5XGXbQQGwS2CGA+/hA3++s531GVDA4WlKqkqW76JZPW7cV+R0/wPNf2i/XzXDlIu1i36zzp6O/2UZsc2PaCajVfs897mKmS27/83UgXLmHrefhNTsENe43RbI+2XlU5nPau7x//cM4MlsPr38ZO/5NThuhhSzyFcaIXtkvUFWtI0iBB2yq1fbXkgKQM2AibeP1kO0q92rv6gmt0kqbRgmssrgrrWYPocTpbsHwlaShbEX72imHeQ0bbpfs1sycO1qVzWa7/7GFbnsGjc48xVxj+LaexPj3qh+UWpPdzEPVHbGFwqdXZOe6yZx2V0OluQ8k0qwWkGWRt7fWTtQuR3hdBIjjFiISUDhwdJyHXnA5vFu6dyLSreHvKo8GWrQQG4967
 61lJ2sgy
 dOBqYnKHxLaB07j4eY21uN4QMU2vi91thG/Z+UyjM4v4K8JvOBlhc0vsh2JT47lpz5c70qfD0G5sbGTL3kiTzEjwMb+A1XpqZN19+04wk0Pvy4L/IAOYBBl9uRvsoX9Z9uJSLjQVBoxXocCUzhsTYh82jUIxI1c061adtw89ivlt/NYul5J0BB2+OM3RUclS15wrS+flVXNWU9VoS+/YmstOD/LUhng7Ko/UOgDLw6hvYa0v3TmhFc9Z1RXrgSMduCDak/AEOKO6pW2HSuLdTBShnXCeB7tSO1q5HYTweNZ3Xi3U=
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
> vms_clear_ptes() is slightly different than other callers to
> unmap_region() and so had the unmapping open-coded.  Using the new
> structure it is now possible to special-case the struct setup instead of
> having the open-coded function.
>
> exit_mmap() also calls unmap_vmas() with many arguemnts.  Using the
> unmap_all_init() function to set the unmap descriptor for all vmas makes
> this a bit easier to read.
>
> Update to the vma test code is necessary to ensure testing continues to
> function.
>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  include/linux/mm.h               |  3 ---
>  mm/internal.h                    |  3 +++
>  mm/memory.c                      | 24 ++++++++------------
>  mm/mmap.c                        |  5 +++-
>  mm/vma.c                         | 39 ++++++++++++++++++--------------
>  mm/vma.h                         | 14 ++++++++++++
>  tools/testing/vma/vma_internal.h | 14 ++++--------
>  7 files changed, 56 insertions(+), 46 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 892fe5dbf9de0..23eb59d543390 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2450,9 +2450,6 @@ static inline void zap_vma_pages(struct vm_area_str=
uct *vma)
>         zap_page_range_single(vma, vma->vm_start,
>                               vma->vm_end - vma->vm_start, NULL);
>  }
> -void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
> -               struct vm_area_struct *start_vma, unsigned long start,
> -               unsigned long end, unsigned long tree_end, bool mm_wr_loc=
ked);
>
>  struct mmu_notifier_range;
>
> diff --git a/mm/internal.h b/mm/internal.h
> index d295252407fee..1239944f2830a 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -197,6 +197,9 @@ static inline void vma_close(struct vm_area_struct *v=
ma)
>         }
>  }
>
> +/* unmap_vmas is in mm/memory.c */
> +void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
> +
>  #ifdef CONFIG_MMU
>
>  /* Flags for folio_pte_batch(). */
> diff --git a/mm/memory.c b/mm/memory.c
> index 829cd94950182..8d4d976311037 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2084,12 +2084,7 @@ static void unmap_single_vma(struct mmu_gather *tl=
b,
>  /**
>   * unmap_vmas - unmap a range of memory covered by a list of vma's
>   * @tlb: address of the caller's struct mmu_gather
> - * @mas: the maple state
> - * @vma: the starting vma
> - * @start_addr: virtual address at which to start unmapping
> - * @end_addr: virtual address at which to end unmapping
> - * @tree_end: The maximum index to check
> - * @mm_wr_locked: lock flag
> + * @unmap: The unmap_desc
>   *
>   * Unmap all pages in the vma list.
>   *
> @@ -2102,11 +2097,9 @@ static void unmap_single_vma(struct mmu_gather *tl=
b,
>   * ensure that any thus-far unmapped pages are flushed before unmap_vmas=
()
>   * drops the lock and schedules.
>   */
> -void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
> -               struct vm_area_struct *vma, unsigned long start_addr,
> -               unsigned long end_addr, unsigned long tree_end,
> -               bool mm_wr_locked)
> +void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
>  {
> +       struct vm_area_struct *vma;
>         struct mmu_notifier_range range;
>         struct zap_details details =3D {
>                 .zap_flags =3D ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
> @@ -2114,17 +2107,18 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma=
_state *mas,
>                 .even_cows =3D true,
>         };
>
> +       vma =3D unmap->first;
>         mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
> -                               start_addr, end_addr);
> +                               unmap->vma_min, unmap->vma_max);
>         mmu_notifier_invalidate_range_start(&range);
>         do {
> -               unsigned long start =3D start_addr;
> -               unsigned long end =3D end_addr;
> +               unsigned long start =3D unmap->vma_min;
> +               unsigned long end =3D unmap->vma_max;
>                 hugetlb_zap_begin(vma, &start, &end);
>                 unmap_single_vma(tlb, vma, start, end, &details,
> -                                mm_wr_locked);
> +                                unmap->mm_wr_locked);
>                 hugetlb_zap_end(vma, &details);
> -               vma =3D mas_find(mas, tree_end - 1);
> +               vma =3D mas_find(unmap->mas, unmap->tree_max - 1);
>         } while (vma);
>         mmu_notifier_invalidate_range_end(&range);
>  }
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5c9bd3f20e53f..6011f62b0a294 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1280,10 +1280,12 @@ void exit_mmap(struct mm_struct *mm)
>         struct vm_area_struct *vma;
>         unsigned long nr_accounted =3D 0;
>         VMA_ITERATOR(vmi, mm, 0);
> +       struct unmap_desc unmap;
>
>         /* mm's last user has gone, and its about to be pulled down */
>         mmu_notifier_release(mm);
>
> +       unmap.mm_wr_locked =3D false;

This will be reset by unmap_all_init() anyway, right?

>         mmap_read_lock(mm);
>         arch_exit_mmap(mm);
>
> @@ -1295,11 +1297,12 @@ void exit_mmap(struct mm_struct *mm)
>                 goto destroy;
>         }
>
> +       unmap_all_init(&unmap, &vmi, vma);

Can we use a macro, something like DEFINE_UNMAP_ALL_REGIONS() instead
of unmap_all_init()?

>         flush_cache_mm(mm);
>         tlb_gather_mmu_fullmm(&tlb, mm);
>         /* update_hiwater_rss(mm) here? but nobody should be looking */
>         /* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped *=
/
> -       unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
> +       unmap_vmas(&tlb, &unmap);
>         mmap_read_unlock(mm);
>
>         /*
> diff --git a/mm/vma.c b/mm/vma.c
> index c92384975cbb2..ad64cd9795ef3 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -481,8 +481,7 @@ void unmap_region(struct unmap_desc *desc)
>
>         tlb_gather_mmu(&tlb, mm);
>         update_hiwater_rss(mm);
> -       unmap_vmas(&tlb, mas, desc->first, desc->vma_min, desc->vma_max,
> -                  desc->vma_max, desc->mm_wr_locked);
> +       unmap_vmas(&tlb, desc);
>         mas_set(mas, desc->tree_reset);
>         free_pgtables(&tlb, mas, desc->first, desc->first_pgaddr,
>                       desc->last_pgaddr, desc->tree_max,
> @@ -1213,26 +1212,32 @@ int vma_shrink(struct vma_iterator *vmi, struct v=
m_area_struct *vma,
>  static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
>                     struct ma_state *mas_detach, bool mm_wr_locked)
>  {
> -       struct mmu_gather tlb;
> +       struct unmap_desc unmap =3D {
> +               .mas =3D mas_detach,
> +               .first =3D vms->vma,
> +               /* start and end may be different if there is no prev or =
next vma. */
> +               .first_pgaddr =3D vms->unmap_start,
> +               .last_pgaddr =3D vms->unmap_end,
> +               .vma_min =3D vms->start,
> +               .vma_max =3D vms->end,
> +               /*
> +                * The tree limits and reset differ from the normal case =
since it's a
> +                * side-tree
> +                */
> +               .tree_reset =3D 1,
> +               .tree_max =3D vms->vma_count,
> +               /*
> +                * We can free page tables without write-locking mmap_loc=
k because VMAs
> +                * were isolated before we downgraded mmap_lock.
> +                */
> +               .mm_wr_locked =3D mm_wr_locked,
> +       };
>
>         if (!vms->clear_ptes) /* Nothing to do */
>                 return;
>
> -       /*
> -        * We can free page tables without write-locking mmap_lock becaus=
e VMAs
> -        * were isolated before we downgraded mmap_lock.
> -        */
>         mas_set(mas_detach, 1);
> -       tlb_gather_mmu(&tlb, vms->vma->vm_mm);
> -       update_hiwater_rss(vms->vma->vm_mm);
> -       unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
> -                  vms->vma_count, mm_wr_locked);
> -
> -       mas_set(mas_detach, 1);
> -       /* start and end may be different if there is no prev or next vma=
. */
> -       free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
> -                     vms->unmap_end, vms->unmap_end, mm_wr_locked);
> -       tlb_finish_mmu(&tlb);
> +       unmap_region(&unmap);
>         vms->clear_ptes =3D false;
>  }
>
> diff --git a/mm/vma.h b/mm/vma.h
> index 4edd5d26ffcfc..8b55a0c73d097 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -164,6 +164,20 @@ struct unmap_desc {
>         bool mm_wr_locked;            /* If the mmap write lock is held *=
/
>  };
>
> +static inline void unmap_all_init(struct unmap_desc *desc,
> +               struct vma_iterator *vmi, struct vm_area_struct *vma)
> +{
> +       desc->mas =3D &vmi->mas;
> +       desc->first =3D vma;
> +       desc->first_pgaddr =3D FIRST_USER_ADDRESS;
> +       desc->last_pgaddr =3D USER_PGTABLES_CEILING;
> +       desc->vma_min =3D 0;
> +       desc->vma_max =3D ULONG_MAX;
> +       desc->tree_max =3D ULONG_MAX;
> +       desc->tree_reset =3D vma->vm_end;
> +       desc->mm_wr_locked =3D false;
> +}
> +
>  #define UNMAP_REGION(name, _vmi, _vma, _vma_min, _vma_max, _prev, _next)=
      \
>         struct unmap_desc name =3D {                                     =
     \
>                 .mas =3D &(_vmi)->mas,                                   =
       \
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index 823d379e1fac2..d73ad4747d40a 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -884,18 +884,12 @@ static inline void update_hiwater_vm(struct mm_stru=
ct *)
>  {
>  }
>
> -static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *m=
as,
> -                     struct vm_area_struct *vma, unsigned long start_add=
r,
> -                     unsigned long end_addr, unsigned long tree_end,
> -                     bool mm_wr_locked)
> +struct unmap_desc;
> +
> +static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc =
*unmap)
>  {
>         (void)tlb;
> -       (void)mas;
> -       (void)vma;
> -       (void)start_addr;
> -       (void)end_addr;
> -       (void)tree_end;
> -       (void)mm_wr_locked;
> +       (void)unmap;
>  }
>
>  static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state=
 *mas,
> --
> 2.47.2
>

