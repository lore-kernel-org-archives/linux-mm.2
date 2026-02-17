Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76093E9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DBBC6B0089; Tue, 17 Feb 2026 16:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A66D6B008A; Tue, 17 Feb 2026 16:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674286B008C; Tue, 17 Feb 2026 16:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52DC06B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:03:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E76E2C18C9
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:03:04 +0000 (UTC)
X-FDA: 84455173488.01.98A8CA3
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A0471C0012
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:03:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QCYNV9md;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771362182; a=rsa-sha256;
	cv=pass;
	b=ctU4zyawcOtywybma903/s9xf2ssZXh8Rv+46C5Kl5EMbhzW65hvmGpwENS1RaNZgh/oC/
	azlthA9zC8vKta1MgRlq/PkRFcxeIN35lJlPfcBXwvkcUJE7UrIK3Q0FzmbQYjRYX75NRY
	MRPuZEWePDdpGIAlO+I6r6n1yqILUhk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QCYNV9md;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771362182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qg7unfpae37+olsmr8ztHQ2bOQfrmh4+RuxK8GGnbgk=;
	b=JYcGNwHbJ4ocKYP+BJ198Blfw1/kKV9UR5HN1+wlpBuoTSRzMN3VqkgoPovdg8PgIsvZc9
	3keu4RYe1u9EQhKpD/LFXzhdXyl+tgwx5PEovZld6VI1UIplqnw1nbqG5oaGTXjItllm1l
	wJtDvD3lDMNY9qQlqScGZ5t7mI6OENA=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-505d3baf1a7so33061cf.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:03:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771362181; cv=none;
        d=google.com; s=arc-20240605;
        b=QQ0Plq61uOxxjLFK/LpOuuI2zBNMZ1//34C8U03zH/Wo23gM8cEAfelu+86lLk55yM
         522zGfW38cz3V2cUcrpekyyiQlaKLEtwwrZI3tYqKIxQG/upOJWuKE/Mdj4AA0dWalA6
         O0zA1yrr2SxvlBrvrIffHClCAvsWX4SeC5NFJJZF7NGkeVdzkz5jKw2LCBxsiylqazZL
         3kmQdT2DLCBgUZDzKupFcQ31xvDrOaAx1J8mW0WkZKD4j2RaLGNLQPjC+edEkq1lz0TK
         gkCqdkuL4naIWqFJxKfVqSfl+nlCWekqsPO8/JIW8YeNAyU/miZ5l2Fv1Kv/N4a6WDLr
         Fp0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qg7unfpae37+olsmr8ztHQ2bOQfrmh4+RuxK8GGnbgk=;
        fh=QK/JBaRwhqj/Di0XZv8PR3REnZ9EGa6LvK3rS8QtKrs=;
        b=cpCrRCuk/WzO04cvzL/RNevH5mehKRsHn0YnCof5As3Kk+yxVoRW721r+DJx+EHQ66
         rlMZrPPyREH8KOkNNinQvP9J8iwHC6/84YEBMSmKbP4e8Jev37pvzI1/8wfnyHWDBCOO
         AMQ4qlyk6NEEt+zeM6yv9rjX9+QjTXgsJfnUUXtdQN3vzGQV6U6NEDVb95JkY9lvpwGO
         PusncHQYOGdja5LRWpXvIeMiVfaxVzJ0DN0pyHmGdYOON4dbODmmBHZZan5ouZMTr1xP
         WKWGAZkBfAeyTfKOzrXTcDTdJaNiGYgQStZH9rsCAtfn0AG+Vu5kNEqs5caoKPEBYsY5
         h1qQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771362181; x=1771966981; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qg7unfpae37+olsmr8ztHQ2bOQfrmh4+RuxK8GGnbgk=;
        b=QCYNV9mdap3FZltWDNUr5XtTPL35dripJEBgBpoJNdEqhZnONmfp++5vp2CHc2YehH
         o2tcv+eWefEsO7rwD8JqhPexISgHEAaVn3VVWw3K0bignjbORaBPsUoVvttJ5xKOLptP
         O5pf5+QjA2H2zfVnn8zWyiG7ilOQlfbsL2qyxwu5gX+W0e4iZfEwIbZSNfJqXPfdoMOe
         Hex2nMHCeI9I668cNKFqAH70jZ7Bq/JL4+t16BRkvceKX2jXFC3VAPdtpfB33LaVP+jq
         FU1cnwjYV7INzBa1oVKnGlJK59Iqm0+D5P+1mrx8uczlYPuj1IxwsT3whm/lPnnjV9Ve
         DjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771362181; x=1771966981;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qg7unfpae37+olsmr8ztHQ2bOQfrmh4+RuxK8GGnbgk=;
        b=F3FbmyEjSyowVfUN3bAbt4728GSDq5dLDikWkdY0xkddFUsqxQ6/7S2WHu7hHofoPH
         I+MzKzyCxfR4ivYy1KypzkKuMwIVBOP/DJrKmeEa9hGCBBd+4AHHIH5D7u56uDza0TEg
         ypqFIxiXHr2c62hfnkiP1Pgc3y2oy3ZelHBaD/Mgxa81RFhBpZLjIA+WjR0Ro2SVzg7O
         Q1LW7rTu0/u3y6ZePf0ORKDA38pCKP7lH4OOWdQZTK3VkCqPcqY6wSK599Wx5+6SVBF3
         OcpOnxSmhfa5AG9XoGbFwTMCwnz/sxquU3ubX3Aa6eREOzn6cyGrqePeB73Sh9x7fjV4
         8CHw==
X-Forwarded-Encrypted: i=1; AJvYcCV4nBE0n1tqwSCN0lIoqDO62xMZvpHSY+eSoiNrY42EsdyIje6PPISdDXGwwJvasILDLJSY29LcIA==@kvack.org
X-Gm-Message-State: AOJu0YxytBdsSxim5fOSnFWuTPIqcX7DWaemc4hkqWPCsAS9qVMdvW6Z
	DaMLO57ODeNbMrj+Dn8iyvabvuXkd4hiynnuOoXTRR3QDx+j510L4lziPaQyhJLJuytSkRY9a4+
	ImYbd5+9CWE8MSmAZb0UdqEZcfttJnTt6uWiOC7O1
X-Gm-Gg: AZuq6aLIjmLvJytF0EEW6NOrSblY5yzjxcNZTyGnHohfcP5FSFg9BbFlvsLsVeHqRVa
	srwtzABLlpNYGUkUIgGtouYjQr1OWtd7VSmzOmKc9UNT4i+aklHx3FYeEUQa42+pRpkHD1Nd9w9
	vrt7y0Geagi0JQjN7XifeMvXfah85BRoe/vLxz4kY+6ur69JPe7hNoYxCOw0qZ/rEZ62w9m6HOa
	7WgsGUx1178A3nX8nnJ2qapiXg0NQ+DVYX2Zpedecs94wT6+8piovRUYs4UR/PcdcoOH6UbbUj9
	lromuBFBayfZArnRsYSA2eSrvN6v98v3Rc26Dw==
X-Received: by 2002:a05:622a:8c15:b0:4ed:ff79:e679 with SMTP id
 d75a77b69052e-506cdb80f2fmr23179661cf.19.1771362180478; Tue, 17 Feb 2026
 13:03:00 -0800 (PST)
MIME-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com> <20260217163250.2326001-3-surenb@google.com>
 <dtdfrko7uqif6flc4mefnlar7wnmrbyswfu7bvb2ar24gkeejo@ypzhmyklbeh7>
In-Reply-To: <dtdfrko7uqif6flc4mefnlar7wnmrbyswfu7bvb2ar24gkeejo@ypzhmyklbeh7>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 17 Feb 2026 13:02:48 -0800
X-Gm-Features: AaiRm52hFtG7L6yJLkbXYH1SBTkTSuw2iS_25yQRkmcsbZ2JjkS2e-zgf6Q_wu8
Message-ID: <CAJuCfpGViU4dDaLtPR8U0C+=FXO=1TuU-hT3fypNQO3LGOjbcA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0A0471C0012
X-Stat-Signature: m9rbfb9eqrbh5hnpqctbnjzb5pizdfpi
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771362181-426962
X-HE-Meta: U2FsdGVkX19C4cxMtEkZGcFuIO2IAMtb5fUYaTdeABGeuQLSGuxmEDTEhgvo4YRgi7eyZZXc+MpdKNNg5nHZ3ceo7NgLOyhGtAXjram1MzY6e46hbGHY7b6i9F0qb1Xg24Hbk6sfNtQWRTCmqdSdlRM+PngPWfnVhIznKooR6LwrG0Y9U3Ak3Xg5N2xBEDrmq/XcNZ40xSXFDstz5JKsjfRCgpQSIe0+Mtopw1ghPIVUNSAnRidVtkaDQJvSCa5+Sn6fG7Mqbypt53lQkyR8zx3UJGxgF+tJs5182xZAalcFuxF7wZyjbjOjJbB3Cgmj64jWYzuBHLu0VW4vIlOcqrCv63OI+uXvI1Riu7+9dsPkcTdthI383ukzArXYQH73RS9UwssW86aTEubPAISHzI3oF5wA7y/iI4aTSfOjGHQ7/Nh94IbcIRSli4+Izvnyro9jYw3J/8CKh2ODRnO8w9xtvM63NaNlnJJBmXLDWNpx0icXQw+CipsvQEjab9kiNvxWXPz2MS4kB4adKIVFrlbYQ8l9NHSXWdAGC7/dYnvbqqR92f94PSEBVTzb3WElvDSRemsqVi+tiiIote+5oLYe8p7XHYjYyU5RSN3wxhE26D7dLOFVoqrRoKHy8+V7cw8Vh6XeVArUCPPrToI1GPJ+/e8BQ6VNBd4AXIes/kMjRcnCf+fjtQh6+klvsBMxylTGiDXkBhTOfdXW0bIZZ6dLL3ziXXdoH7e8/GuRxNyxne5gaL6vt3u92rYyjlq5dbzu0xCydr6q1bVyyiBFgUvG2L31yBB/cTRRFJstdbTPEq5Is2g/u8VsRXToM8hQHcKerrNYzm6kAgrPFhR4xb5d/HkDmxRcXUbCT0NQ3lfYht3y0vlx2pDWcx7F+9K2jT911uWouLGZ+kWVGv59MW4CmETQEoJUkMpASK+dNPFf47bNe53fkQwCV6pbn5AsL6UoZwnioBG0qaxQa2x
 CQaOXsY5
 MPtnBS4M/s9e3QrV4skNHCBeDVXBw6sSOZZUMVz6qR2ARIwIzoL3f39ja7wDY/9ghxRNBDHyjarYWrPcW605KJ6ijXXXfo0ijFzBcmMUlBpH/Zjvdu+vyPc03+VbYffu8jNa0Co2wOy1ZbT7fOk8WHhKNknBx1Vl52Dej+mW4HSOvVn5zRvj1RZFMG8nggwx4Qk15xEESasZ4k4SbHp5rqZbEdiebYuNveV56g/3M9WhEmXR/UWms5PVugb16DbZns/kFnfY/2YTIktT+UdegKVOiTCQzL32RJpTjOcyIIKJ2yM/RIWM7I4LSPtvQkYFrwXdMmpUHqbSahUTfKvclR32lY3tT2x7uxCaWwMVvBZTnXkkHxGm7dDpO5S0pXqgNHse9Hq2KbMAP7cIwnNnhurcAIdOgdRXIGDIjU4UxMLgzybnQp0I+p/BArwgergUW2oWbIiC2zSx7oB3ZTftaIQovNatImDyY88pCnvs8xz0HAWA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:19=E2=80=AFAM Liam R. Howlett
<Liam.Howlett@oracle.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [260217 11:33]:
> > Now that we have vma_start_write_killable() we can replace most of the
> > vma_start_write() calls with it, improving reaction time to the kill
> > signal.
> >
> > There are several places which are left untouched by this patch:
> >
> > 1. free_pgtables() because function should free page tables even if a
> > fatal signal is pending.
> >
> > 2. process_vma_walk_lock(), which requires changes in its callers and
> > will be handled in the next patch.
> >
> > 3. userfaultd code, where some paths calling vma_start_write() can
> > handle EINTR and some can't without a deeper code refactoring.
> >
> > 4. vm_flags_{set|mod|clear} require refactoring that involves moving
> > vma_start_write() out of these functions and replacing it with
> > vma_assert_write_locked(), then callers of these functions should
> > lock the vma themselves using vma_start_write_killable() whenever
> > possible.
> >
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc
> > ---
> >  arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
> >  include/linux/mempolicy.h          |  5 +-
> >  mm/khugepaged.c                    |  5 +-
> >  mm/madvise.c                       |  4 +-
> >  mm/memory.c                        |  2 +
> >  mm/mempolicy.c                     | 23 ++++++--
> >  mm/mlock.c                         | 20 +++++--
> >  mm/mprotect.c                      |  4 +-
> >  mm/mremap.c                        |  4 +-
> >  mm/vma.c                           | 93 +++++++++++++++++++++---------
> >  mm/vma_exec.c                      |  6 +-
> >  11 files changed, 123 insertions(+), 48 deletions(-)
> >
>
> ...
>
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
>
> ...
>
> >
> >  static const struct mempolicy_operations mpol_ops[MPOL_MAX] =3D {
> > @@ -1785,9 +1793,15 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigne=
d long, start, unsigned long, le
> >               return -EINVAL;
> >       if (end =3D=3D start)
> >               return 0;
> > -     mmap_write_lock(mm);
> > +     if (mmap_write_lock_killable(mm))
> > +             return -EINTR;
> >       prev =3D vma_prev(&vmi);
> >       for_each_vma_range(vmi, vma, end) {
> > +             if (vma_start_write_killable(vma)) {
> > +                     err =3D -EINTR;
> > +                     break;
> > +             }
> > +
> >               /*
> >                * If any vma in the range got policy other than MPOL_BIN=
D
> >                * or MPOL_PREFERRED_MANY we return error. We don't reset
> > @@ -1808,7 +1822,6 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned=
 long, start, unsigned long, le
> >                       break;
> >               }
> >
> > -             vma_start_write(vma);
>
> Moving this vma_start_write() up means we will lock all vmas in the
> range regardless of if they are going to change.  Was that your
> intention?

No, I missed that this would result in unnecessary locks.

>
> It might be better to move the locking to later in the loop, prior to
> the mpol_dup(), but after skipping other vmas?

Yes, that's the right place for it. Will move.

>
> >               new->home_node =3D home_node;
> >               err =3D mbind_range(&vmi, vma, &prev, start, end, new);
>
> ...
>
> > diff --git a/mm/vma.c b/mm/vma.c
> > index bb4d0326fecb..1d21351282cf 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
>
> ...
>
> > @@ -2532,6 +2556,11 @@ static int __mmap_new_vma(struct mmap_state *map=
, struct vm_area_struct **vmap)
> >               goto free_vma;
> >       }
> >
> > +     /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free_iter_vma;
> > +
> >       if (map->file)
> >               error =3D __mmap_new_file_vma(map, vma);
> >       else if (map->vm_flags & VM_SHARED)
> > @@ -2552,8 +2581,6 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap)
> >       WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
> >  #endif
> >
> > -     /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> > -     vma_start_write(vma);
> >       vma_iter_store_new(vmi, vma);
> >       map->mm->map_count++;
> >       vma_link_file(vma, map->hold_file_rmap_lock);
>
> This is a bit of a nit on the placement..
>
> Prior to this change, the write lock on the vma was taken next to where
> it was inserted in the tree.  Now the lock is taken between vma iterator
> preallocations and part of the vma setup.
>
> Would it make sense to put it closer to the vma allocation itself?  I
> think all that's needed to be set is the mm struct for the locking to
> work?

I guess locking the vma before vma_iter_prealloc() would save us
unnecessary alloc/free in case of a pending fatal signal. I'll move
the lock right after vm_area_alloc() so that the entire vma setup is
done on a locked vma.

>
>
> ...
>
> > @@ -3089,7 +3120,7 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
>
> Good luck testing this one.

Yeah... Any suggestions for tests I should use?

>
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *next;
> >       unsigned long gap_addr;
> > -     int error =3D 0;
> > +     int error;
> >       VMA_ITERATOR(vmi, mm, vma->vm_start);
> >
> >       if (!(vma->vm_flags & VM_GROWSUP))
> > @@ -3126,12 +3157,14 @@ int expand_upwards(struct vm_area_struct *vma, =
unsigned long address)
> >
> >       /* We must make sure the anon_vma is allocated. */
> >       if (unlikely(anon_vma_prepare(vma))) {
> > -             vma_iter_free(&vmi);
> > -             return -ENOMEM;
> > +             error =3D -ENOMEM;
> > +             goto free;
> >       }
> >
> >       /* Lock the VMA before expanding to prevent concurrent page fault=
s */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free;
> >       /* We update the anon VMA tree. */
> >       anon_vma_lock_write(vma->anon_vma);
> >
> > @@ -3160,6 +3193,7 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
> >               }
> >       }
> >       anon_vma_unlock_write(vma->anon_vma);
> > +free:
> >       vma_iter_free(&vmi);
> >       validate_mm(mm);
> >       return error;
>
> Looks okay.

Thanks for the review, Liam! I'll wait a couple of days and post the
v3 with fixes.

>
> ...
>
>
>

