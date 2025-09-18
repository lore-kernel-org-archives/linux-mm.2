Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00FF3CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2398F280038; Thu, 18 Sep 2025 11:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211418E00F6; Thu, 18 Sep 2025 11:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12734280038; Thu, 18 Sep 2025 11:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00FE98E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:43:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2C98C0246
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:43:50 +0000 (UTC)
X-FDA: 83902791420.08.79525D9
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id B3A49160015
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:43:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="sxj5Om/s";
	spf=pass (imf08.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758210228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUuz8CD3HO9jmYGP3x/Qi9AVUuWVNLWtlJSdhydOUbQ=;
	b=JT+BuAa+m0YLP01Jb0WeXomSf6eMWuG6VbHPhKLk/Z0HjwtJEttOEXzKT7xVOn5C4FH1pp
	jKbcc9cpCvvAlDt4DlPoxIFMYeG/oBog9Dd54avMo8MlVfQ1yxose5gOD+7Y5SowEj8jK+
	h3sVBS3+OD2yyZ4e5i143wKfQS7f1dE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="sxj5Om/s";
	spf=pass (imf08.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758210228; a=rsa-sha256;
	cv=none;
	b=cCwzKNOCACFrLklCRr4wfmgRuTaZunxN8LvKwcJXoN2nKznVl904+WP6aR7Vj8TsqvCfZn
	IQC3E3jwsdKoqVwdav/9YO4bhSqwsgCP9/b381sCV+5jptwqBIZAq2DLutvnAyUly6VYYS
	azETySonB53lkMapGqhN3DWpIidBnmU=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2699ed6d473so138255ad.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758210227; x=1758815027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUuz8CD3HO9jmYGP3x/Qi9AVUuWVNLWtlJSdhydOUbQ=;
        b=sxj5Om/spJLsFA9Jq4vzwRB6MKuUxI8rT7+u+e+NnxSVE/DsCXFQ6R+OdxyNskD1Ra
         jqHwcagDpnUS5ecZZSJJX6WBU6GN1UVJr0/b9Qv27cjvUcqq2ZYld9zdBV2m+h3LUSQM
         YffbOiRndkugIE+k5OeOpkz51Uh8Sm8rJoIFpYuy1vgKLjtW0QlOV2Q6vNUUAbIJL5nr
         fVD5tPGivljoTEY69uQ6X4zdLhARkj4frj/bX5R0cKqIsIpNrt+A/wxcY0p+qR+8ODxi
         7GjvfCEXmHaQzrLyxu0Xr2gVeq2OM5mxfeFKrRT5qSNjkwQ13n5FLyJ4KRJLkJJGlK/9
         1Lbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758210227; x=1758815027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUuz8CD3HO9jmYGP3x/Qi9AVUuWVNLWtlJSdhydOUbQ=;
        b=qKc+Xfr30Ws3k0jMk+aGi5TaHdJbaMgOHSIii1Lo/7LUTFMINzrC09U23Or+XtMqTA
         aKsFoMKeunIJCBve/0ACDig9dnH6UlOQlBtLzA2wM2y5/Jk67R6G8Iw5HrcpMe6i0Cta
         +5n4rMQpIiAD0u2vJgvwasxEPgo6PtwSYaB6wvOEZwxCl+MsHhzHTaKPz6MsdwOM1/Tw
         JISPaB8K25W+U8WIPNb8GyUS/jUoeOo1dyWTe6JBxyxeP6nVzlWduddPfxxqglTXSor9
         WofctdMBfTeqmFRXYs0DYdbJaLMPs7Nv8bdr9IG86eIbKuAsdpj1a6NOfWf5/CVGagvh
         +4cg==
X-Forwarded-Encrypted: i=1; AJvYcCXmTqXZj/oI7G6x6c4s1CTbAYKnMy/XTfkyP6t3cReLf65HIqYvbLNqyJwv+1MF03xs0do+ygIz0w==@kvack.org
X-Gm-Message-State: AOJu0YwSh3VFlAD2xoGE6a6UC1Cti7tOUkYWe8RZQajYW8iYHJ7Atk59
	R3Hp5P6a2bGTujffnzEmchqij8sfRv8BrgdpgDCT6Fl6dKSk76QV3xwLFb5aEJlxaHgKCmiy9nW
	Vb5667xpfH8vFQfaMXIT8DV7qf+XW14C3IoH5+gNn
X-Gm-Gg: ASbGnct/LdG+/o/FS5hPQSxx211LbNAYLfqD4tCXn+ZlyKbQP1VxW8RYbtOICaB7Ei1
	avTX9bDWzUzBMxSaNbGlxEUsQx0k6aeo5aD0yR1/8hh7rvuR2RwlCJ3xuPMEl8OolO7oBJgo4r8
	c4KL59rCQMyOWt0S9/xTgNtK6WKW2/R3esmUJR0AusyYOUTe9n8vgUS2G6RY4pI+icmeNK60Bsb
	TKV7k4+hAvTBuT+ztwpa+y1UUGaIhxXMxDoZPbD7W5eq3C24+9xfu38wWIOAh8=
X-Google-Smtp-Source: AGHT+IGOWncYtcrhMeRNwklhcx/jRPyb4GflMef3jOYgIJD25j97iYY51RH9RwZkkWDzLf+irjpmRR6Jnws4Dzhi7gI=
X-Received: by 2002:a17:903:1a68:b0:269:7410:d780 with SMTP id
 d9443c01a7336-2697410e815mr6509485ad.5.1758210227139; Thu, 18 Sep 2025
 08:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-6-kaleshsingh@google.com> <eb254603-edbd-4bc6-a4bd-57b6a85191b5@lucifer.local>
In-Reply-To: <eb254603-edbd-4bc6-a4bd-57b6a85191b5@lucifer.local>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 18 Sep 2025 08:43:35 -0700
X-Gm-Features: AS18NWAMaEgzDOdwxwrnrwKqopVJAdtQ-tQlRuAS1rNhBQel6t9gDKbC_aFTnDw
Message-ID: <CAC_TJvc9HNwBbH9953vnqZQ0zLYvRF4fdZvc1Sp7OYV8bPVOCA@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] mm: harden vma_count against direct modification
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, david@redhat.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B3A49160015
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tfa8o38kw8g6qm5jinas15zwp6mh5xa1
X-HE-Tag: 1758210228-179148
X-HE-Meta: U2FsdGVkX1/iBIgN27xOJFtEA56pjJIGGhBCM8UMTDtwi0hXQosiGUsCRRsjgCElqp8i5DRH3E4c4ns503cq0xPVV+J20gQwzAbwCxZr8gyKIjF8YizThLs1xbhlcLV1Z5IqMYAjcEaS4aCF/5L9WCjMEg7+l0/yOHS8fpByTk3U+vWhAnagxZy6iz38LzMcex795jWI6ig9FdnbkzCb7r9T9t0Q0mBHpPr2S8SC9PmJ6Uv3eBcKK9edmEQ1bfdPwZzqR6grO6Statfr3Zr06d1YcOee0a3XCR43+yeocRGe7/NWtul7PCc3S+6nnyo3aIoGEF+QRjMmBHQOY9eYR14hXiVNCQsEiKoP+zjCCwn+++fbT+pfsArhOsl4qXtP/QeQkB871aY5p5AgPPWyGAyFAp+afA7aMAngjF/+DqJ6hTM1yVX6kPdJKNIBjrS/KlR1y2SEG5U3bCdtt6XtSq38ll30QKHetEdieYvOxP0ecE23hSm5Elk5mAXafpNm0Op8ZyDRAQtA0+3bbJfZ8+tcA57IhvTnNot0ZKdN6R4KeyhA4t0Caq4uwT+JIeRjPKNuy33uJPQUxNQInT8JQruMUCLgT9F4zJC90USRKGAf5BE50XPWc7tbIpIJ98OkQERpiLJJ83iKBP70+Nghmu1Q9qEeloUYJMc9U1kczEHw5FRGXzS0xccOmjNEmAZg0w77krUtfm7TR2HU0IQQnm3B2CRZP5v7hfVbG5NKpVx8uOyXCxWuL9Hcn4Ba5N+NvyDYtFaD9rO1mS5SpQfusiUStwBRQAarIEBKIrbC4+FP0cdVH7j1cQMkYwQD07bPH8Fp1boChFFcwTIBXMKjz6zT6N8rej9D/OutlN5n0tZFDknyK/EWIIfeDnaLInMWlNRhjH27hF5Kbi2i765mzbOpxyGR+6fDmnewLuVCLGoRTd9j55iUF09cYb1KYvUIDUe+caee5wSNiuItLxY
 lbuBgcP7
 EXcKClgQ3jMXadHS6sWJDk9u801+PYSVmznSRn9ydaqw8mWO+zVv4HjxxyT3y/xWaslAluJFZ9RKKUkhvBdQ/euxBZzHgmZlzjkHbhJUV6CIs4FhMD09fVJisXRRT58sr0R6PFb7eptxNVHXU4OviM02Ks37lWn4vp8PIUAimjOkcgo8tvg1QhFzWpAvhzEC6+Atzpd/QpvNsUfp1inB7CMiqc2p+s7vgZr8tMYhVOQInFlREagSiJS8UTUHb3OQBGbSvvn35pxXHvSf3/DFHIQSuv2oonqUPhofrUiihfAy5vSfvqKbddOZRGCBeyrtjGqLSB89jdJ4P0mOXE7lvvb5ogcKXfBcTom5qqz3lIMyH1ibXXjP5jjLLpi/7tHYJNIPbHdHB4b9PlDqlAextCeYLNVLpQJJgWEkXeuhCdZMyvhc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 7:52=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Sep 15, 2025 at 09:36:36AM -0700, Kalesh Singh wrote:
> > To make VMA counting more robust, prevent direct modification of the
> > mm->vma_count field. This is achieved by making the public-facing
> > member const via a union and requiring all modifications to go
> > through a new set of helper functions the operate on a private
> > __vma_count.
> >
> > While there are no other invariants tied to vma_count currently, this
> > structural change improves maintainability; as it creates a single,
> > centralized point for any future logic, such as adding debug checks
> > or updating related statistics (in subsequent patches).
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
>
> Hmmm I"m not sure about this one.
>
> I think this is a 'we don't need it' situation, and it's making everythin=
g a bit
> uglier.
>
> I especially hate vma_count_add() and vma_count_sub(). You're essentially
> overridding the whole concept in these cases to make stuff that's already=
 in
> place work in those cases
>
> I don't think this really adds much honestly.

Hi Lorenzo,

Thanks for reviewing.

This was done to facilitate adding the assertions. So I'll drop this
along with that in the next version.

Thanks,
Kalesh

>
> (You're also clearly missing cases as the kernel bot has found issues)
>
> > ---
> >  include/linux/mm.h               | 25 +++++++++++++++++++++++++
> >  include/linux/mm_types.h         |  5 ++++-
> >  kernel/fork.c                    |  2 +-
> >  mm/mmap.c                        |  2 +-
> >  mm/vma.c                         | 12 ++++++------
> >  tools/testing/vma/vma.c          |  2 +-
> >  tools/testing/vma/vma_internal.h | 30 +++++++++++++++++++++++++++++-
> >  7 files changed, 67 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 138bab2988f8..8bad1454984c 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4219,4 +4219,29 @@ static inline bool snapshot_page_is_faithful(con=
st struct page_snapshot *ps)
> >
> >  void snapshot_page(struct page_snapshot *ps, const struct page *page);
> >
> > +static inline void vma_count_init(struct mm_struct *mm)
> > +{
> > +     ACCESS_PRIVATE(mm, __vma_count) =3D 0;
> > +}
> > +
> > +static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
> > +{
> > +     ACCESS_PRIVATE(mm, __vma_count) +=3D nr_vmas;
> > +}
> > +
> > +static inline void vma_count_sub(struct mm_struct *mm, int nr_vmas)
> > +{
> > +     vma_count_add(mm, -nr_vmas);
> > +}
> > +
> > +static inline void vma_count_inc(struct mm_struct *mm)
> > +{
> > +     vma_count_add(mm, 1);
> > +}
> > +
> > +static inline void vma_count_dec(struct mm_struct *mm)
> > +{
> > +     vma_count_sub(mm, 1);
> > +}
> > +
> >  #endif /* _LINUX_MM_H */
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 4343be2f9e85..2ea8fc722aa2 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -1020,7 +1020,10 @@ struct mm_struct {
> >  #ifdef CONFIG_MMU
> >               atomic_long_t pgtables_bytes;   /* size of all page table=
s */
> >  #endif
> > -             int vma_count;                  /* number of VMAs */
> > +             union {
> > +                     const int vma_count;            /* number of VMAs=
 */
> > +                     int __private __vma_count;
> > +             };
> >
> >               spinlock_t page_table_lock; /* Protects page tables and s=
ome
> >                                            * counters
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 8fcbbf947579..ea9eff416e51 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1037,7 +1037,7 @@ static struct mm_struct *mm_init(struct mm_struct=
 *mm, struct task_struct *p,
> >       mmap_init_lock(mm);
> >       INIT_LIST_HEAD(&mm->mmlist);
> >       mm_pgtables_bytes_init(mm);
> > -     mm->vma_count =3D 0;
> > +     vma_count_init(mm);
> >       mm->locked_vm =3D 0;
> >       atomic64_set(&mm->pinned_vm, 0);
> >       memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index c6769394a174..30ddd550197e 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1828,7 +1828,7 @@ __latent_entropy int dup_mmap(struct mm_struct *m=
m, struct mm_struct *oldmm)
> >                */
> >               vma_iter_bulk_store(&vmi, tmp);
> >
> > -             mm->vma_count++;
> > +             vma_count_inc(mm);
> >
> >               if (tmp->vm_ops && tmp->vm_ops->open)
> >                       tmp->vm_ops->open(tmp);
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 64f4e7c867c3..0cd3cb472220 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -352,7 +352,7 @@ static void vma_complete(struct vma_prepare *vp, st=
ruct vma_iterator *vmi,
> >                * (it may either follow vma or precede it).
> >                */
> >               vma_iter_store_new(vmi, vp->insert);
> > -             mm->vma_count++;
> > +             vma_count_inc(mm);
> >       }
> >
> >       if (vp->anon_vma) {
> > @@ -383,7 +383,7 @@ static void vma_complete(struct vma_prepare *vp, st=
ruct vma_iterator *vmi,
> >               }
> >               if (vp->remove->anon_vma)
> >                       anon_vma_merge(vp->vma, vp->remove);
> > -             mm->vma_count--;
> > +             vma_count_dec(mm);
> >               mpol_put(vma_policy(vp->remove));
> >               if (!vp->remove2)
> >                       WARN_ON_ONCE(vp->vma->vm_end < vp->remove->vm_end=
);
> > @@ -1266,7 +1266,7 @@ static void vms_complete_munmap_vmas(struct vma_m=
unmap_struct *vms,
> >       struct mm_struct *mm;
> >
> >       mm =3D current->mm;
> > -     mm->vma_count -=3D vms->vma_count;
> > +     vma_count_sub(mm, vms->vma_count);
> >       mm->locked_vm -=3D vms->locked_vm;
> >       if (vms->unlock)
> >               mmap_write_downgrade(mm);
> > @@ -1795,7 +1795,7 @@ int vma_link(struct mm_struct *mm, struct vm_area=
_struct *vma)
> >       vma_start_write(vma);
> >       vma_iter_store_new(&vmi, vma);
> >       vma_link_file(vma);
> > -     mm->vma_count++;
> > +     vma_count_inc(mm);
> >       validate_mm(mm);
> >       return 0;
> >  }
> > @@ -2495,7 +2495,7 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap)
> >       /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> >       vma_start_write(vma);
> >       vma_iter_store_new(vmi, vma);
> > -     map->mm->vma_count++;
> > +     vma_count_inc(map->mm);
> >       vma_link_file(vma);
> >
> >       /*
> > @@ -2810,7 +2810,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >       if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
> >               goto mas_store_fail;
> >
> > -     mm->vma_count++;
> > +     vma_count_inc(mm);
> >       validate_mm(mm);
> >  out:
> >       perf_event_mmap(vma);
> > diff --git a/tools/testing/vma/vma.c b/tools/testing/vma/vma.c
> > index 69fa7d14a6c2..ee5a1e2365e0 100644
> > --- a/tools/testing/vma/vma.c
> > +++ b/tools/testing/vma/vma.c
> > @@ -261,7 +261,7 @@ static int cleanup_mm(struct mm_struct *mm, struct =
vma_iterator *vmi)
> >       }
> >
> >       mtree_destroy(&mm->mm_mt);
> > -     mm->vma_count =3D 0;
> > +     vma_count_init(mm);
> >       return count;
> >  }
> >
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_i=
nternal.h
> > index 15525b86145d..6e724ba1adf4 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -251,7 +251,10 @@ struct mutex {};
> >
> >  struct mm_struct {
> >       struct maple_tree mm_mt;
> > -     int vma_count;                  /* number of VMAs */
> > +     union {
> > +             const int vma_count;            /* number of VMAs */
> > +             int __vma_count;
> > +     };
> >       unsigned long total_vm;    /* Total pages mapped */
> >       unsigned long locked_vm;   /* Pages that have PG_mlocked set */
> >       unsigned long data_vm;     /* VM_WRITE & ~VM_SHARED & ~VM_STACK *=
/
> > @@ -1526,4 +1529,29 @@ static int vma_count_remaining(const struct mm_s=
truct *mm)
> >       return (max_count > vma_count) ? (max_count - vma_count) : 0;
> >  }
> >
> > +static inline void vma_count_init(struct mm_struct *mm)
> > +{
> > +     mm->__vma_count =3D 0;
> > +}
> > +
> > +static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
> > +{
> > +     mm->__vma_count +=3D nr_vmas;
> > +}
> > +
> > +static inline void vma_count_sub(struct mm_struct *mm, int nr_vmas)
> > +{
> > +     vma_count_add(mm, -nr_vmas);
> > +}
> > +
> > +static inline void vma_count_inc(struct mm_struct *mm)
> > +{
> > +     vma_count_add(mm, 1);
> > +}
> > +
> > +static inline void vma_count_dec(struct mm_struct *mm)
> > +{
> > +     vma_count_sub(mm, 1);
> > +}
> > +
> >  #endif       /* __MM_VMA_INTERNAL_H */
> > --
> > 2.51.0.384.g4c02a37b29-goog
> >

