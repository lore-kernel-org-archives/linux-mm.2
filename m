Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C7B8CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 22:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47798E0003; Tue,  9 Sep 2025 18:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1A98E0002; Tue,  9 Sep 2025 18:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99078E0003; Tue,  9 Sep 2025 18:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2B138E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:03:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AF4BBB194
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:03:53 +0000 (UTC)
X-FDA: 83871089946.14.F6C883D
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6AA06120004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:03:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FAZ6lyX7;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757455431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdfxY/tmePyPQQZ4AQC4iyvAmEwVEuUt1ANSa6zzOfk=;
	b=7/j1yfMY8Qwo1RYKeZhx58IwYGBu5lJksJBzdxEn05wjhJGsBeWY8m+V4P8opPrQwnuVza
	c7ckrURFZCT5pdyD6FjUMCTbZ6uq2//kVplPue8/sHnHJPvJ5D9/mpW3dnkfIZ32jnpey1
	3wgq1AR76HX0+X6I03m65fUWriPn3N8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757455431; a=rsa-sha256;
	cv=none;
	b=X4TCu/6eXE+Tk/8snrZkLkkhBcKTg8RJmsk4cyNO+NHibezlxfWSUE1gML4lnkgsPAtfEi
	CrNRI70kdEIqeL8g/jKn0FRVnWXMzEZuFHT38SrYJA49eX2lxKBlAaBdf1jSMxNTYI/pY8
	wCAFkmN1dBSUwDwe9VwV+XPk6mdaI8w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FAZ6lyX7;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b4bcb9638aso183401cf.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 15:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757455430; x=1758060230; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdfxY/tmePyPQQZ4AQC4iyvAmEwVEuUt1ANSa6zzOfk=;
        b=FAZ6lyX77byTNvVVckDn9f+5vWmcNv42mbWn7q4g9n3wepxVloy4XZBS3fqkciorIR
         Vsv0g5aPaR9necRGvh3mQwomG+y7n7r824YGia/z0p+8H0jFQA4UdjRYLObY7X9cpgJr
         GpKuxvUI+aRUcsQmBMgIxjXfA9e3G0GdzeoLPBIA6cEfqh4X1QqUAs65Bxxu2E0C/St+
         xrBlNPAkSAnJuY+0x+EpKZC3UZCO40f1k5MMzPE95tSwlAFLXpUvlL9ccyf/fny42tsP
         oiG4KsyScke9C2/Dbzw3adeM6brtHkb5W4kwm02M5L7HmvgLUUaNgds+UyHYK23B1lKD
         uM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757455430; x=1758060230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdfxY/tmePyPQQZ4AQC4iyvAmEwVEuUt1ANSa6zzOfk=;
        b=VzXgsboo+24CmTo7HQ19HQClu7x5hdyjmF6/bwO1aC90g6CslD9Ejk+um8zy4LrbVY
         EY6QPWcMvBTvGFjnDsE9UP6mxXU3GRbc16YoDQ4Ri4zfdWDNsBFK9v4NtUEzLmq/S7qC
         /Tz3MMmV4Ytm4xcyy2LtCDxvt+RtNusMMIF1z0EUYa07N+AGepFbPqc5PrXPnFlOypnR
         O5oYae1HeKTybHewONK1HRti2rugtTH8q9UeS3IT9HkHs/b01WM0bcbobXhNzWG5SyBq
         zaLl2OoisfYaFI/5AZAP8zOFyKk0HauFWo9qMB3blGMAac/ItOvmjhxNHvcRALZpPSAa
         WVOg==
X-Forwarded-Encrypted: i=1; AJvYcCXz+C3XRrCYX3rtwYP1Tywn36iADj5WrfW/FyOtC1nlsTacKxDn1CLeGinYdai8rWrXs3F6gBIuPg==@kvack.org
X-Gm-Message-State: AOJu0YxH4hogNCmg44oAQgTE+cjBr8w71NOKs+OWLamCgpw+2Hx5uKZE
	s67fiSskACNvCwRxlZgRDB3q5PGk8rcY1WJ5lyD/MS/29Lq90ujBES5knwEht8AtgVLTXs80X0D
	S8wTbueDleVhfVQa5KPxu6Ulqtd+dq8SHy87359naNKImU/HFiUg36Cx/
X-Gm-Gg: ASbGncvtpoE/GalNmm/N97xANeZbywYZlt7rq5Ydiid0KtvnpYRCG/uZ6KIZYP1ueTd
	9jXYeIKp7jTJsSQTRoUszve5QVFzZf0A3tIsyiObQD7rOIVBsqX2J80BQ5F/SYMpf8rXZl8IJBN
	rcZge/QlKC//UOqvs04Pe42sOqfneUNhM1M2O0cDAVD9Sy0K0HZQCQMnz495CP1Sg/c0qDddUjs
	sn79beKLASOUF4XXdCgSaNOv4QzbN14Z9G+VYBt9PdY
X-Google-Smtp-Source: AGHT+IGH9MAIkn9QIyO6RoFKXtsuPBpT+6kFM3APqUb2DuqRhmpbV0XtFElws++iZPivmby1/3S8CAb0x/ApQRsbgRw=
X-Received: by 2002:ac8:5f0c:0:b0:4b3:1617:e616 with SMTP id
 d75a77b69052e-4b62525e5cemr1785581cf.16.1757455429996; Tue, 09 Sep 2025
 15:03:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com> <20250909190945.1030905-7-Liam.Howlett@oracle.com>
In-Reply-To: <20250909190945.1030905-7-Liam.Howlett@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 15:03:38 -0700
X-Gm-Features: AS18NWCo9ZoQa9ZzyM3hmR7V51NOxY2fhATfOWnpl40gfbyxSS1Epx0ZyM8junY
Message-ID: <CAJuCfpHz9Q-GMSZQ0xY8_oAuoWTA6DUHfCses7e7_FL8mi_1bQ@mail.gmail.com>
Subject: Re: [PATCH v1 6/9] mm: Change dup_mmap() recovery
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6AA06120004
X-Stat-Signature: nzqnqxk9bs1gu55kfpia9fixsy8r3uak
X-Rspam-User: 
X-HE-Tag: 1757455431-717193
X-HE-Meta: U2FsdGVkX1/Zc9ayIR5IjUGkAN9BXQjcAVBgWhoiNuLwuiK+TFzmmOmXMpzA1qM+aR2+QKffF51VOPCY1PNY0TgnoJhdThwfg+ffkW4Z0ak7OZlnnK2vbQpla+Tdirm/FNa/XihplEsx0nmBqYqOdcdVQzLs7zYS+ee1phLOneyTLzuYIQsiorLp8Teq8PqAbgksEd+yGtn95HxON16AG4dlPQWRlQ5Aj1rDit2NIkWskbqMK7dqJKNMz66asr8uuGqa4pFZ606dXUTQCOH/bRjY7oHFtievPAxB002xilyTkTdg0jj2GwxGekECENj8+9huv9+La0QisoAnAIEMeeVoWRQIF2115hCdh9V0y8gQlpQVt9D2b0k331bPYPiNsIaf90scmCxVEE1wTRTB0JgPZjRAhZDlO4cH0O3/D441WDk59sxGpoVuIBbAUW+AlGxNgcidQqP9RA5NGwGvom0mzsmrJ1vYnTrIAzzV98bm9rQfwaHncbWVDrMs1aLOGuCNPyTRwtAu3outy23833nrFH8nvFjDY7pDiDO/AvjB3IJ/rrsJf1+AbX8JTAayGi1QCllhYsRfkZ0TvzxNp+483AnB5RuAaN2Mf5iFpUAS9THj9qyMC4TKnwAruRCmi5Di8TeDQ4inTGIFMUa5C585v0U1Rls+yoNGtRqsBTThxgKsVMWB4P4aw+jghAuyT4YjX5DYbqTE5yl7b7RdglQ5DBZ+4EEX0k4l8o39s4FUu8KGUgoj+KeMjSVdZIhzTmIRfBsUBte7Z6qwJS4zSU0regDf2oykoEN0rK85e6ZExaHpMy3omi41n0H5dzb10ndYxZahBrEUGyoQWJDznnXAY/Hy/dPmRq5GKHPkuyYkrzcPqK6+DRRbO7AdsWpmqxmdop5OhTV35zMGPa32BQBEXRdO0TJQ0Kv580V4RyTYpnWayfAkVUbkbBSyPl8DWqW8bO1agPX+fiK0PgR
 U7Fj4bdL
 7zG61gvkcB9OxZOLzSawmQuu8ueQUd/IqBeMRP/LxXfPYkP1xXh9XgFFTbq6aE/YKMw4VccSws5mOFhZzx8EDy6cyZvtw6zSCmytVVEb40d0HibSBcmsm3F5n9Kz4tuvGtuRKDWQ+qnXggBu5+0tQmydSslOkpmn8qIOSVjkGt9n8FQrlbUYPYIme/BvSx2tAzqzdC4h6B2gAKIrrxAPixCpXg7cBnHnNNHBijpASkrf0CK0VWLqLEM7rUQ==
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
> When the dup_mmap() fails during the vma duplication or setup, don't
> write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
> free the new resources, leaving an empty vma tree.
>
> Using XA_ZERO introduced races where the vma could be found between
> dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
> race can occur because the mm can be reached through the other trees
> via successfully copied vmas and other methods such as the swapoff code.
>
> XA_ZERO was marking the location to stop vma removal and pagetable
> freeing.  The newly created arguments to the unmap_vmas() and
> free_pgtables() serve this function.
>
> Replacing the XA_ZERO entry use with the new argument list also means
> the checks for xa_is_zero() are no longer necessary so these are also
> removed.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/memory.c |  6 +-----
>  mm/mmap.c   | 42 +++++++++++++++++++++++++++++++-----------
>  2 files changed, 32 insertions(+), 16 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 24716b3713f66..829cd94950182 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -408,8 +408,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_=
state *mas,
>                  * be 0.  This will underflow and is okay.
>                  */
>                 next =3D mas_find(mas, tree_max - 1);
> -               if (unlikely(xa_is_zero(next)))
> -                       next =3D NULL;
>
>                 /*
>                  * Hide vma from rmap and truncate_pagecache before freei=
ng
> @@ -428,8 +426,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_=
state *mas,
>                 while (next && next->vm_start <=3D vma->vm_end + PMD_SIZE=
) {
>                         vma =3D next;
>                         next =3D mas_find(mas, tree_max - 1);
> -                       if (unlikely(xa_is_zero(next)))
> -                               next =3D NULL;
>                         if (mm_wr_locked)
>                                 vma_start_write(vma);
>                         unlink_anon_vmas(vma);
> @@ -2129,7 +2125,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_s=
tate *mas,
>                                  mm_wr_locked);
>                 hugetlb_zap_end(vma, &details);
>                 vma =3D mas_find(mas, tree_end - 1);
> -       } while (vma && likely(!xa_is_zero(vma)));
> +       } while (vma);
>         mmu_notifier_invalidate_range_end(&range);
>  }
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 0f4808f135fe6..aa4770b8d7f1e 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1288,7 +1288,7 @@ void exit_mmap(struct mm_struct *mm)
>         arch_exit_mmap(mm);
>
>         vma =3D vma_next(&vmi);
> -       if (!vma || unlikely(xa_is_zero(vma))) {
> +       if (!vma) {
>                 /* Can happen if dup_mmap() received an OOM */
>                 mmap_read_unlock(mm);
>                 mmap_write_lock(mm);
> @@ -1858,20 +1858,40 @@ __latent_entropy int dup_mmap(struct mm_struct *m=
m, struct mm_struct *oldmm)
>                 ksm_fork(mm, oldmm);
>                 khugepaged_fork(mm, oldmm);
>         } else {
> +               unsigned long max;
>
>                 /*
> -                * The entire maple tree has already been duplicated. If =
the
> -                * mmap duplication fails, mark the failure point with
> -                * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encou=
ntered,
> -                * stop releasing VMAs that have not been duplicated afte=
r this
> -                * point.
> +                * The entire maple tree has already been duplicated, but
> +                * replacing the vmas failed at mpnt (which could be NULL=
 if
> +                * all were allocated but the last vma was not fully set =
up).
> +                * Use the start address of the failure point to clean up=
 the
> +                * partially initialized tree.
>                  */
> -               if (mpnt) {
> -                       mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_=
end - 1);
> -                       mas_store(&vmi.mas, XA_ZERO_ENTRY);
> -                       /* Avoid OOM iterating a broken tree */
> -                       mm_flags_set(MMF_OOM_SKIP, mm);
> +               if (!mm->map_count) {
> +                       /* zero vmas were written to the new tree. */
> +                       max =3D 0;
> +               } else if (mpnt) {
> +                       /* partial tree failure */
> +                       max =3D mpnt->vm_start;
> +               } else {
> +                       /* All vmas were written to the new tree */

So, the cleanup for this case used to be handled by exit_mmap(). I
think it's ok to do it here but the changelog should mention this
change as well IMHO.

> +                       max =3D ULONG_MAX;
>                 }
> +
> +               /* Hide mm from oom killer because the memory is being fr=
eed */
> +               mm_flags_set(MMF_OOM_SKIP, mm);
> +               if (max) {
> +                       vma_iter_set(&vmi, 0);
> +                       tmp =3D vma_next(&vmi);
> +                       flush_cache_mm(mm);
> +                       unmap_region(&vmi.mas, /* vma =3D */ tmp,
> +                                    /*vma_min =3D */ 0, /* vma_max =3D *=
/ max,
> +                                    /* pg_max =3D */ max, /* prev =3D */=
 NULL,
> +                                    /* next =3D */ NULL);
> +                       charge =3D tear_down_vmas(mm, &vmi, tmp, max);
> +                       vm_unacct_memory(charge);
> +               }
> +               __mt_destroy(&mm->mm_mt);
>                 /*
>                  * The mm_struct is going to exit, but the locks will be =
dropped
>                  * first.  Set the mm_struct as unstable is advisable as =
it is
> --
> 2.47.2
>

