Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BA5CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1201C8E0014; Thu,  4 Sep 2025 12:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0FB8E0010; Thu,  4 Sep 2025 12:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28EB8E0014; Thu,  4 Sep 2025 12:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFB588E0010
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:34:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BC62139D5D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:34:46 +0000 (UTC)
X-FDA: 83852116572.30.9FDD82B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9A419180019
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:34:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4uDHqmFr;
	spf=pass (imf06.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757003684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIphyer/v3DPFwcbM/1VaFFLYbcPkwf7pTaOPXgyjPs=;
	b=DCWNwHe1tL+nnGeYrx+0Js5cP6I5k/gfN9THoUgjFaDA5nRnrsYcLEFj0Wz1I/FDAIDQ/E
	EdD5MqWf43raMw3EriPLBNmbpGXWMJZ352a9p0xyFu6Rs5egY8aTpvZzKy4epUGW8IafEr
	DzGENBwx3Tupv1I3RL8vbgYbI2ZB9hk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4uDHqmFr;
	spf=pass (imf06.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757003684; a=rsa-sha256;
	cv=none;
	b=cguVBL3tlZJmW3tchAWldM7Xf5SADqtGb5ntX185AIFRgG4LOUYnOaVmR7O1OjSHEX/uqa
	i5waMuRHQRs+rEm57BL4rXHiXKBbN/+BGZ4GZztDuVOaDfPDuP5YS7NB4qtGxRadm3HsmP
	6YwqWTmkuawe7OYerdKzv/xZJjyIdy8=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24b2337d1bfso3045ad.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 09:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757003683; x=1757608483; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIphyer/v3DPFwcbM/1VaFFLYbcPkwf7pTaOPXgyjPs=;
        b=4uDHqmFruQv5Y9APNV2czyNCu9Xg5SnzfrrqmphAHBU1Ob6w/h9qhUWjTItLnGK6uJ
         xtUo39H7SzKuICKyAUfthoWTPJxFhyfpD7dldz4btAt2OuDw6BoI9hDd8p6qIYL2ZF3U
         UxkDs6f1f70IolSV6s6eNC01f0prD9Oyp2rP2VsDpk/a6zR/JiNF7EJxxL8kFoKP/1Nr
         2MKJ1vnxSvRVZe+IEsxPyB3/duZCUK6QgmxUBFNc5KmHEqDQ3gAvj46258V8LMaaBlXr
         ASdP8PyRm3JpDnknwG5JHj2sT+4xbCrhXnzX3dmMWaH7nYA8bZiImPgPQiDVZnuvSzxY
         TtXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757003683; x=1757608483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZIphyer/v3DPFwcbM/1VaFFLYbcPkwf7pTaOPXgyjPs=;
        b=dVtNwDEh+qvIFPSSoNioEiMEn2e42Vxlz391lIB/eM0Z7LP4W+mg9+8eYMy2pEWZAL
         eXUgfiCcRh7nZ0vjHlJRbNWcm18zPtcIlaWG4du0CCXdZqZwqOMouK6bUNlHjnyEOKiL
         3SJA88VH9xEhxW3vxvWke0qsgjyxog/ryds1NFImM26LpeVVfylpzXgAIjFJZV0JgDaE
         t7YLXS0l0aouZw94ZIw9eh5WK3Ap/kkdOCi/J6VTDRl4yAq0PP2qX9FZMtD8J7R9zw/4
         PN8jjdtJ2TL8dBNul6tlnoQS2MXMFBZXp5itluxxAHlky+LYmCwQzVlo0Q2f/LAffyQ9
         y8aA==
X-Forwarded-Encrypted: i=1; AJvYcCUNZBt4jyiifMuiNRORWS+bliCCt5SyKAd8XKzRwRSseyvb2ImwqbgzMFmTY6CcHo5qC9LoawsDhg==@kvack.org
X-Gm-Message-State: AOJu0YxYQwXS6E3scHqcbQmuUYZVurfeHl7ZkdhdJtoB5fsVVYYrZllJ
	DO4TitxLXTCmQnUgMc9rGV253JSldoDF/T1f/+wA3eBCRGUIaqWdHEfgL0AMY3MUNLN5k00ZPMg
	B090Xijat//l+xjblB2PzoO8ymqQlTc+/selqgaVR
X-Gm-Gg: ASbGncuRhZ1qWh88N3B1KjhLZghzi8lPLwh4f9jcoAWvIIRKk9pHNyktmLeeGwRy4f3
	rF+s2w0nxCybLzOMoTAmBEwPm1TI/i01+/Wum9WXHjGqM3fzCDLF4VXdpOREMMNDNpNa4KaKJMx
	IUFkesHcqsN+XQAbGSjkEt7jUQwOPC+YjnCt2TWhC3aDUL7cKjvjkXMVdcI6nDZ+jhIh8Cp8lXl
	eRK6L6rqMaxk64v70OAb5PXTrrEhc/8RBbR1vyt4H7U
X-Google-Smtp-Source: AGHT+IFSPuUUCV+cBM50sI3Z+1DFuftHs12TO1fvAlwdozBMKG95tjjnen/h1oMKUTo1sitW0F5Uu9n6CiEUtIOosmY=
X-Received: by 2002:a17:902:ea01:b0:231:f6bc:5c84 with SMTP id
 d9443c01a7336-24ccaf6e116mr3651605ad.8.1757003683119; Thu, 04 Sep 2025
 09:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250903232437.1454293-1-kaleshsingh@google.com> <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
In-Reply-To: <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 4 Sep 2025 09:34:31 -0700
X-Gm-Features: Ac12FXyZ35C2YiXL_Ds3Xt1Dj85unZqP3Rp-ROvVkOK_JLyiLa944HgsyNtXqH4
Message-ID: <CAC_TJvfCRkDt-4BwffD_QN9hhuUz78N51ztwqcfDmA=wJjm_Zw@mail.gmail.com>
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, kernel-team@android.com, 
	android-mm@google.com, David Hildenbrand <david@redhat.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9A419180019
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tf813tpj6cnhqkpyfup1uxhfiznz8m1s
X-HE-Tag: 1757003684-869555
X-HE-Meta: U2FsdGVkX198s1PQIRzw8cHLXXMVCPD6zBXzZ/RXI6AesYH63MGSlsGNisoCfaTxH3hpP547ijjSFgT1ErVaGOj2U8G0NQkFYJ0TVsqf0lUaShoedI1g85mL2PQrfUgeh5m4BuamVLy7638rR+Mr5iBNkPf4TZH7crqXdpqQwmdDU/Ekc0niMX/61nsItL+5FnJwFDGGRzAhS3Vk2ijr6zUgLb+khq1WmNPtYZucCH8tOoiWxRb9kVX1VGZBLMqejlIrshbKKJ/hCqMJKebnxoNZzmJsvfEd3+++9JXUAO8mSkTbLR1meH53T4oukth+V1v/8hpJNj7g0XvS8894TfzRcGtYvdRPq8Nq0Qfm2qMeHDKj+x76tF1agu85738QWmjVg7vS2yxAq8qjGIt2FvuM13jQssYfDrjTaVuetEqtgG6IvBxDjTCE7O8cX1tlsSgrlD43qJfdGJb/bhhbrE+tCN93PnlhymEDvrTqYebx+olFTKo8hK7jc7N7TOdfckSEluNz7Zqt+39USM0VOGHkDWJzJ2NCtEr1389K32JpD4Mvzv0welUSyXSYe32V9QZizbkdtk7WakhhqZDMlLOYw5vaxvRKMaDJzWTco48E9MHQK7HpWJj+ID3XZqPzPd5TQ8j4n8IsUsgNbcS8mLqjedi5+bUhp9d/Re56iOBRRoRIcTW64PWQuc0weAGggtMJgbek1LbvG4FqnZiV4nlQUEEB07JwPcHOjrR7Zzt9+mcQ4tunvHY+C7j89qfxJgkgWs4bbJyZ3I7I+Vc3S3BWh979bHn0U4sZ0rCnUxJvBGGsYH61BY2UOFwMaRfrO48h7xzA+jaAlImkTHh+vhNKqxuL6ytUgvsI6oWcYgOhtst4ZSLpXnis8pdj6gcsjlo1Q+v1l1ahOBBuRbvTT5NKlZ7mAPVl2VeL+xBVriJAk/XFwAErQTQABxRnMOJD/LKMTH2Z1Gtal6aQ3/9
 9fQ878+o
 udjEwPiknOrDP5yNLlkuYNB7ZOalrGISqRzTeTHew4VkqZotc+U/kjIfV5LyNaTrl/3vvHRhEUlrXxp15/IvvNY982EqriSNxCbEf80nwdyjZAMCj5CFtbXd2apSX32XWJpX3wtGvOLAzSMptZTbs3qOXTrUpJl7Y9pNy9ylP4KylpRIQaJOAuw+0RJUOP2/8AVAOGn/vhsfz1C4k6cKwtZWEVHG9Ka+0xjXK8I9/glu6fivobi4tXlpBI11AZhHu1pkhQ54VcjDSzqK/lRxAknshMozUTFbvkimsSHiAl2FxmqzUXcCsg3jRpaJCW5IYqLaL5YZZWu6XkrOrcKvnJcfOl7sJ7qYi+alxRkEI+/T59Os=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 9:03=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 03, 2025 at 04:24:35PM -0700, Kalesh Singh wrote:
> > The check against the max map count (sysctl_max_map_count) was
> > open-coded in several places. This led to inconsistent enforcement
> > and subtle bugs where the limit could be exceeded.
> >
> > For example, some paths would check map_count > sysctl_max_map_count
> > before allocating a new VMA and incrementing the count, allowing the
> > process to reach sysctl_max_map_count + 1:
> >
> >     int do_brk_flags(...)
> >     {
> >         if (mm->map_count > sysctl_max_map_count)
> >             return -ENOMEM;
> >
> >         /* We can get here with mm->map_count =3D=3D sysctl_max_map_cou=
nt */
> >
> >         vma =3D vm_area_alloc(mm);
> >         ...
> >         mm->map_count++   /* We've now exceeded the threshold. */
> >     }
> >
> > To fix this and unify the logic, introduce a new function,
> > exceeds_max_map_count(), to consolidate the check. All open-coded
> > checks are replaced with calls to this new function, ensuring the
> > limit is applied uniformly and correctly.
> >
> > To improve encapsulation, sysctl_max_map_count is now static to
> > mm/mmap.c. The new helper also adds a rate-limited warning to make
> > debugging applications that exhaust their VMA limit easier.
> >
>
> Yeah this is nice thanks!
>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  include/linux/mm.h | 11 ++++++++++-
> >  mm/mmap.c          | 15 ++++++++++++++-
> >  mm/mremap.c        |  7 ++++---
> >  mm/nommu.c         |  2 +-
> >  mm/util.c          |  1 -
> >  mm/vma.c           |  6 +++---
> >  6 files changed, 32 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..d4e64e6a9814 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct pa=
ge *page)
> >  #define MAPCOUNT_ELF_CORE_MARGIN     (5)
> >  #define DEFAULT_MAX_MAP_COUNT        (USHRT_MAX - MAPCOUNT_ELF_CORE_MA=
RGIN)
> >
> > -extern int sysctl_max_map_count;
> > +/**
> > + * exceeds_max_map_count - check if a VMA operation would exceed max_m=
ap_count
> > + * @mm: The memory descriptor for the process.
> > + * @new_vmas: The number of new VMAs the operation will create.
> > + *
> > + * Returns true if the operation would cause the number of VMAs to exc=
eed
> > + * the sysctl_max_map_count limit, false otherwise. A rate-limited war=
ning
> > + * is logged if the limit is exceeded.
> > + */
> > +extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int n=
ew_vmas);
>
> No new externs please (as Pedro also pointed out! :)
>
> >
> >  extern unsigned long sysctl_user_reserve_kbytes;
> >  extern unsigned long sysctl_admin_reserve_kbytes;
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 7306253cc3b5..693a0105e6a5 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned l=
ong addr,
> >               return -EOVERFLOW;
> >
> >       /* Too many mappings? */
> > -     if (mm->map_count > sysctl_max_map_count)
> > +     if (exceeds_max_map_count(mm, 0))
>
> Yeah this last 'mystery meat' parameter isn't amazing though to be honest=
, it's
> kinda hard to read/understand.
>
> E.g.:
>
> int map_count_capacity(const struct *mm)
> {
>         const int map_count =3D mm->map_count;
>         const int max_count =3D sysctl_max_map_count;
>
>         return max_count > map_count ? max_count - map_count : 0;
> }
>
> Then this would become;
>
>         if (!map_count_capacity(mm)) {
>                 // blah.
>         }
>

Hi Lorenzo,

I agree your suggestion is a lot clearer and readable. Thanks for the
suggestion :)  Let me update that in the next revision.

--Kalesh

>
> >               return -ENOMEM;
> >
> >       /*
> > @@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mapping(
> >  int sysctl_legacy_va_layout;
> >  #endif
> >
> > +static int sysctl_max_map_count __read_mostly =3D DEFAULT_MAX_MAP_COUN=
T;
> > +
> > +bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas=
)
> > +{
> > +     if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)) {
> > +             pr_warn_ratelimited("%s (%d): Map count limit %u exceeded=
\n",
> > +                                 current->comm, current->pid,
> > +                                 sysctl_max_map_count);
>
> Yeah not a fan of this, we aren't warning elsewhere, it's actually perfec=
tly
> normal for somebody to exceed this, this isn't at the level of a warning.
>
> > +             return true;
> > +     }
> > +     return false;
> > +}
> > +
> >  static const struct ctl_table mmap_table[] =3D {
> >               {
> >                               .procname       =3D "max_map_count",
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index e618a706aff5..793fad58302c 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_rem=
ap_struct *vrm)
> >        * We'd prefer to avoid failure later on in do_munmap:
> >        * which may split one vma into three before unmapping.
> >        */
> > -     if (current->mm->map_count >=3D sysctl_max_map_count - 3)
> > +     if (exceeds_max_map_count(current->mm, 4))
> >               return -ENOMEM;
>
> In my version this would be:
>
>         if (map_count_capacity(current->mm) < 4)
>                 return -ENOMEM;
>
> And etc. etc. I won't do them all :)
>
> I do think this is clearer...
>
> >
> >       if (vma->vm_ops && vma->vm_ops->may_split) {
> > @@ -1811,9 +1811,10 @@ static unsigned long check_mremap_params(struct =
vma_remap_struct *vrm)
> >        * split in 3 before unmapping it.
> >        * That means 2 more maps (1 for each) to the ones we already hol=
d.
> >        * Check whether current map count plus 2 still leads us to 4 map=
s below
> > -      * the threshold, otherwise return -ENOMEM here to be more safe.
> > +      * the threshold. In other words, is the current map count + 6 at=
 or
> > +      * below the threshold? Otherwise return -ENOMEM here to be more =
safe.
> >        */
> > -     if ((current->mm->map_count + 2) >=3D sysctl_max_map_count - 3)
> > +     if (exceeds_max_map_count(current->mm, 6))
> >               return -ENOMEM;
> >
> >       return 0;
> > diff --git a/mm/nommu.c b/mm/nommu.c
> > index 8b819fafd57b..0533e1e3b266 100644
> > --- a/mm/nommu.c
> > +++ b/mm/nommu.c
> > @@ -1316,7 +1316,7 @@ static int split_vma(struct vma_iterator *vmi, st=
ruct vm_area_struct *vma,
> >               return -ENOMEM;
> >
> >       mm =3D vma->vm_mm;
> > -     if (mm->map_count >=3D sysctl_max_map_count)
> > +     if (exceeds_max_map_count(mm, 1))
> >               return -ENOMEM;
> >
> >       region =3D kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
> > diff --git a/mm/util.c b/mm/util.c
> > index f814e6a59ab1..b6e83922cafe 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -751,7 +751,6 @@ EXPORT_SYMBOL(folio_mc_copy);
> >  int sysctl_overcommit_memory __read_mostly =3D OVERCOMMIT_GUESS;
> >  static int sysctl_overcommit_ratio __read_mostly =3D 50;
> >  static unsigned long sysctl_overcommit_kbytes __read_mostly;
> > -int sysctl_max_map_count __read_mostly =3D DEFAULT_MAX_MAP_COUNT;
> >  unsigned long sysctl_user_reserve_kbytes __read_mostly =3D 1UL << 17; =
/* 128MB */
> >  unsigned long sysctl_admin_reserve_kbytes __read_mostly =3D 1UL << 13;=
 /* 8MB */
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 3b12c7579831..f804c8ac8fbb 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -592,7 +592,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_are=
a_struct *vma,
> >  static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *=
vma,
> >                    unsigned long addr, int new_below)
> >  {
> > -     if (vma->vm_mm->map_count >=3D sysctl_max_map_count)
> > +     if (exceeds_max_map_count(vma->vm_mm, 1))
> >               return -ENOMEM;
> >
> >       return __split_vma(vmi, vma, addr, new_below);
> > @@ -1345,7 +1345,7 @@ static int vms_gather_munmap_vmas(struct vma_munm=
ap_struct *vms,
> >                * its limit temporarily, to help free resources as expec=
ted.
> >                */
> >               if (vms->end < vms->vma->vm_end &&
> > -                 vms->vma->vm_mm->map_count >=3D sysctl_max_map_count)=
 {
> > +                 exceeds_max_map_count(vms->vma->vm_mm, 1)) {
> >                       error =3D -ENOMEM;
> >                       goto map_count_exceeded;
> >               }
> > @@ -2772,7 +2772,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >       if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
> >               return -ENOMEM;
> >
> > -     if (mm->map_count > sysctl_max_map_count)
> > +     if (exceeds_max_map_count(mm, 1))
> >               return -ENOMEM;
> >
> >       if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
> > --
> > 2.51.0.338.gd7d06c2dae-goog
> >

