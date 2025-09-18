Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90F2CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0528E0151; Thu, 18 Sep 2025 11:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188608E00F6; Thu, 18 Sep 2025 11:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09EAF8E0151; Thu, 18 Sep 2025 11:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC1E68E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:52:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9804DC0260
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:52:26 +0000 (UTC)
X-FDA: 83902813092.23.8082585
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 48434100014
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:52:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gxB3gOMS;
	spf=pass (imf05.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758210744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWongCm8ZAf/azaHq+fEhrlTCA5Ds592xK8AQ0EqpNs=;
	b=XE9U2HoWLhrLU1sE7CuiVyFJN5fk6zSSqxDBAFfRxPSCgCmfkeJ/tyE/jaRXNYu0y4ihrz
	O83YuRY6z4VEPKvbI9Lgb7YgzGfujQM4HwPVMMnHJM3oPi26IRJ1GAf2nvl9g6YjjJjaSh
	M5cAyrFTkuN8/HQoCOedAjFGYvSi42Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gxB3gOMS;
	spf=pass (imf05.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758210744; a=rsa-sha256;
	cv=none;
	b=fia4i8bbKqcnxe1k5/KdXsGZpLHP4tdN5VkdLRymnde6x8LV0A9HP4y1hr/h7vnJEMdf38
	uCN5l10KNmyyd6ShfBGxG3RxvYCCYsKSJ3Pm0pYICBcgIKAZK11HGUYj8o+RPE3vJESIgj
	m9jPJcUYBRj9KEO3ehfXvMdo6MjRc40=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-265f460ae7bso188715ad.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758210743; x=1758815543; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWongCm8ZAf/azaHq+fEhrlTCA5Ds592xK8AQ0EqpNs=;
        b=gxB3gOMSY5PfH4hxUymehTSK5w2GLuygswQrRDH7iBqh1dCHmjGB1a1oOS1VQOAXie
         T2gYkygZ64AYgx44dgGOICNoY+bEyrRK2TbxKKmiwnYNwDCPrRlQ5fV/DQlg1fuem0b5
         h+5vy3hgezHA/yDbcVFdb3o34/k0/WCboT2BU8ojHY3WFmmx+J3p4oh6v5aaOCGSL5yo
         Lue+owhCYDlgz/boD9Bm/Pu8ycpg8LkQvUXKLW0t31LzznPkBDKpVTA0iax0/SgDC0/q
         sEW1dR/B5IKW4wfkLWodzhw+uqXwS1Cs4zONdLlVu8/wY3izmTFP6E3p8Fzw1bQjhlef
         PmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758210743; x=1758815543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWongCm8ZAf/azaHq+fEhrlTCA5Ds592xK8AQ0EqpNs=;
        b=mtB3wouyMVwiC4k2cok3ZxxUFVh2pbz+wn3ZfR+BT5Pf9hVFy/KycvZfwpTrXFSqCs
         m65aEq+9Kfdmk5U3RZw1vfSqxU89x0MYPsmRbFwYuzNmtI/ObQYLg67+VF1FSXC4jE5d
         gtyzsejt1gL/UrnYRjZ7VzlMcMKPOnu+gHTIzbdgd777mS6d1YYChq0k0I8XGrcugA+U
         IZztD+IpFhmvf77BnZqQzwK8ZNLObu8s+7zyOWV4DjrpNoChNsj/rIUAFZqPAvZ8SJjW
         Sj5gquET2CVt8w6f0WMLhjEWQcKO2kSaq+sfT+/5bjPulFPwhZOhtgjnQuS1M1hMDdP1
         +60g==
X-Forwarded-Encrypted: i=1; AJvYcCWYFAGGnE9yVNdOztoQXgkJLQ5HA8MTwPIx4LK4z0lFEm1KQIw6puwYbyM1aBbczR6Mm26Sb9DeyQ==@kvack.org
X-Gm-Message-State: AOJu0YyHHzlhHN+oVTul5LE9hOpCgSiXoHVwQCA2YP6eARjqXbMfClkV
	ZXpCOgpxPaA/efJT8Qihi4CZzl4eFuGoonaRUsLXqfWtxPMVOAKpJp8pNaN17+QheAsLUT8UhBh
	sNiCYTszMAem1OKnomRiwpVOyyaKftiT/Z87UpTEt
X-Gm-Gg: ASbGnctwhU6/fnEZsNWv0r1FXY3zoQKGAxlOzmldMzaed5aPsUJdWFZs6J2fIx+Xk8T
	20IFekMz/K1RxVqg3O9SBWaSIQOy6/1h0Rb3bMu86R9E6zFDaF736UMKEX1m1Xv9a4rNGF3TBV0
	kguxbTgt0c4P3H4SkodDlJlpPOc/9dUpJkAw79EJqfyoo9waZbnmMAm+TT32Zy1W8ijsAgDye07
	PsmJk5CD2zWnXZIX7/gkt6p05R2PFvFpN9fH4tJxK+V4c69F2EPnLuAB1ickgA=
X-Google-Smtp-Source: AGHT+IE1dVZDfdIlS5aJU2haj2U7eoaUKE7vXw1xNvbtSsJwxP5QUmxJfKZ0gNezoUJQtND9zTo/Z6GLyTbHTFmE7nk=
X-Received: by 2002:a17:902:e5cb:b0:248:7b22:dfb4 with SMTP id
 d9443c01a7336-26801092aefmr9948975ad.16.1758210742695; Thu, 18 Sep 2025
 08:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-4-kaleshsingh@google.com> <bed862a2-60a8-466e-ab71-b1c009bc4e5b@lucifer.local>
In-Reply-To: <bed862a2-60a8-466e-ab71-b1c009bc4e5b@lucifer.local>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 18 Sep 2025 08:52:11 -0700
X-Gm-Features: AS18NWB8tF0mUJ-ghoyohYGZ4lY14lQJBa_1Pd4HDuYcKkBQgWDOcSdxyZA-oBk
Message-ID: <CAC_TJvcYERvsRx+PfvgdRxOJAZPxvN+tyc-sHe4h_ZU-iH50Kg@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] mm: introduce vma_count_remaining()
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
X-Stat-Signature: bnn7tkek4j6h1iurts8gnnp9azene8z7
X-Rspam-User: 
X-Rspamd-Queue-Id: 48434100014
X-Rspamd-Server: rspam04
X-HE-Tag: 1758210744-404786
X-HE-Meta: U2FsdGVkX1/hWshNHmgSPzIUXGgMXNK+4zP8iemm0qRgakedURks40WMLnERreQ+sBuB0BkjBlaP9m2eyXepBgtagPqfN8b6Yg+mSO8s6Gr7zEaXfm6HQ0SZvGKrrYrSnkHD5LIjOE1iMcmWHzDsb+8NrXPbCxB83FvTED28kXeSciuE1WpKuk3xaH5w8VZWYfnduoT+PyiSDoqjktFZx5ef8srEPH+53djVlKQpaFTwHBgWxMTiPyJpZzzYLd18RIzTJBSVdx/FZ9n6+VeISAqw8izpbPQTaBJ8gDKUIeMFRsH55F+tjCf2EA4XdmPDmPUmYqMGmdp/5L9ER5QFiwzPQCYRZVx9Lb71WGBzELgECuBsJE6TOUoPHLcJKaK+gZATdHt6kXNmbFvi8q4WZlhi7nndSfmq5u/bfHoxNDxBtVce0pWUQgbXEwA1TUhUJqRvcriK73C1zjaZPeJb9CV9n+n8IjlPiWP6msRyjXPCQ3YIAlutsF/Dm/SZreOfL+WrvbySS7TiGqGIXDdvwW8+I/9G+u5A+d2lZPegk30aLygAMgqR6C9kbrHZED5TvMe4yybsA2w6pBl+Kh5oJmpeIBeNZf94vj950B3j9EgsOqu0NwpmddIuEvAhMB8Qj6IfGhwSHVeojqjNbdSWcroOW2gTvuEKlwvSeJKGVlfxOub8U4bnzNTqi4DJR+tOlqnk/VlNU0FgQ/MZ+Pt2Jtt3SE0qQcYFZeclK0dWUa7cxmupVR7XXgazxU0tchGt+LIm5tC3M7X0I7qosUiHbXQdImLzT+cj+GSFQOn+120ERGlZc3KEPnjyMlkeTfVL8kL4bUFy5yuOuCDJRZA+KfB9hsHvaTZ0UD83VwPvyVWppjMvpk18Qw0VuxAcxDtF280rOIVKJs8uUUSV9idgD6rLertDgDNNEC4JovOG+vEp0Fk0obtuY+uFlbKe9fNeczN8MxEmIHfIoBVdtAE
 s3tJd7NA
 c7BBw/JhHP3eVVLUWGjxvMl/XrNCsvQY4HnzWgCgxXMVuE1TZIi2g5jW9946xjqyTgbu1hYW2MTFSlhTA42naTg6s1Kv3ZIem3RhjEUVuqdHDj5MPrLTw6qsaKsuIlWPn29leGUviTWXKPVGVOjT5eLkLrRGJMoZDvZTz/w9JvK3C00dGVZ5Rj37AKqBj4LM60vTpU9s8eBfuDp1LABNGlANr5g7h1Mcw3Q/7t+1/2THVPBeUH+lqkTmCQWv91T3/ttp13NSTJQza0gaUkcDNWH2MQTCdV7a/RDEicxcLoeodrGRCv36jyN2A+T0PWLMGYMjtckPZ7AdRZ4u2GQ89k6R7otFiqp5UkZa9Fo91woF9QaE+7Un7gBJ5FakKRSYglbGpCIqqYQ4aScHDwYNtWHBqEL2+qaMk0T0R4Csa1SY+Evc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 7:32=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Sep 15, 2025 at 09:36:34AM -0700, Kalesh Singh wrote:
> > The checks against sysctl_max_map_count are open-coded in multiple
> > places. While simple checks are manageable, the logic in places like
> > mremap.c involves arithmetic with magic numbers that can be difficult
> > to reason about. e.g. ... >=3D sysctl_max_map_count - 3
> >
> > To improve readability and centralize the logic, introduce a new helper=
,
> > vma_count_remaining(). This function returns the VMA count headroom
> > available for a givine process.
> >
> > The most common case of checking for a single new VMA can be done with
> > the convenience helper has_vma_count_remaining():
> >
> >     if (!vma_count_remaining(mm))
> >
> > And the complex checks in mremap.c become clearer by expressing the
> > required capacity directly:
> >
> >     if (vma_count_remaining(mm) <  4)
>
> Double space after 4.

Will fix in the resend.

>
> >
> > While a capacity-based function could be misused (e.g., with an
> > incorrect '<' vs '<=3D' comparison), the improved readability at the ca=
ll
> > sites makes such errors less likely than with the previous open-coded
> > arithmetic.
> >
> > As part of this change, sysctl_max_map_count is made static to
> > mm/mmap.c to improve encapsulation.
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
> Generally logic looks ok, with various stuff fixed below + in commit msg =
we
> should be good to go :)
>
> > ---
> >
> > Changes in v2:
> >   - Fix documentation comment for vma_count_remaining(), per Mike
> >   - Remove extern in header, per Mike and Pedro
> >   - Move declaration to mm/internal.h, per Mike
> >   - Replace exceeds_max_map_count() with capacity-based vma_count_remai=
ning(),
> >        per Lorenzo.
> >   - Fix tools/testing/vma, per Lorenzo.
> >
> >  include/linux/mm.h               |  2 --
> >  mm/internal.h                    |  2 ++
> >  mm/mmap.c                        | 21 ++++++++++++++++++++-
> >  mm/mremap.c                      |  7 ++++---
> >  mm/nommu.c                       |  2 +-
> >  mm/util.c                        |  1 -
> >  mm/vma.c                         | 10 +++++-----
> >  tools/testing/vma/vma_internal.h |  9 +++++++++
> >  8 files changed, 41 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..138bab2988f8 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -192,8 +192,6 @@ static inline void __mm_zero_struct_page(struct pag=
e *page)
> >  #define MAPCOUNT_ELF_CORE_MARGIN     (5)
> >  #define DEFAULT_MAX_MAP_COUNT        (USHRT_MAX - MAPCOUNT_ELF_CORE_MA=
RGIN)
> >
> > -extern int sysctl_max_map_count;
> > -
>
> Nice to get rid of this as a global! :)
>
> >  extern unsigned long sysctl_user_reserve_kbytes;
> >  extern unsigned long sysctl_admin_reserve_kbytes;
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 45b725c3dc03..39f1c9535ae5 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1661,4 +1661,6 @@ static inline bool reclaim_pt_is_enabled(unsigned=
 long start, unsigned long end,
> >  void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
> >  int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
> >
> > +int vma_count_remaining(const struct mm_struct *mm);
> > +
> >  #endif       /* __MM_INTERNAL_H */
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index e5370e7fcd8f..af88ce1fbb5f 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned l=
ong addr,
> >               return -EOVERFLOW;
> >
> >       /* Too many mappings? */
> > -     if (mm->map_count >=3D sysctl_max_map_count)
> > +     if (!vma_count_remaining(mm))
> >               return -ENOMEM;
> >
> >       /*
> > @@ -1504,6 +1504,25 @@ struct vm_area_struct *_install_special_mapping(
> >  int sysctl_legacy_va_layout;
> >  #endif
> >
> > +static int sysctl_max_map_count __read_mostly =3D DEFAULT_MAX_MAP_COUN=
T;
> > +
> > +/**
> > + * vma_count_remaining - Determine available VMA slots
> > + * @mm: The memory descriptor for the process.
> > + *
> > + * Check how many more VMAs can be created for the given @mm
> > + * before hitting the sysctl_max_map_count limit.
> > + *
> > + * Return: The number of new VMAs the process can accommodate.
> > + */
> > +int vma_count_remaining(const struct mm_struct *mm)
> > +{
> > +     const int map_count =3D mm->map_count;
> > +     const int max_count =3D sysctl_max_map_count;
>
> David already commented on the READ_ONCE() here, seems wise.
>
> > +
> > +     return (max_count > map_count) ? (max_count - map_count) : 0;
>
> Not a big deal but would prefer:
>
>         if (map_count >=3D map_count)
>                 return 0;
>
>         return max_count - map_count;
>
> As the ternary here is a bit less clear, and it puts the 'failure' case f=
irst
> and the 'success' case afterwards.
>
> > +}
> > +
>
> As discussed in reply to the kernel bot, you've accidentally placed this =
in a
> CONFIG_SYSCTL block, so need to move it :>)

Yeah I unintentionally placed it there, I've moved this out in a newer
version. Thanks.

>
> >  static const struct ctl_table mmap_table[] =3D {
> >               {
> >                               .procname       =3D "max_map_count",
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index 35de0a7b910e..14d35d87e89b 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_rem=
ap_struct *vrm)
> >        * We'd prefer to avoid failure later on in do_munmap:
> >        * which may split one vma into three before unmapping.
> >        */
> > -     if (current->mm->map_count >=3D sysctl_max_map_count - 3)
> > +     if (vma_count_remaining(current->mm) < 4)
> >               return -ENOMEM;
>
> This is much clearer.
>
> >
> >       if (vma->vm_ops && vma->vm_ops->may_split) {
> > @@ -1814,9 +1814,10 @@ static unsigned long check_mremap_params(struct =
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
> > +     if (vma_count_remaining(current->mm) < 6)
> >               return -ENOMEM;
>
> I hate that we do this silly check here, but the time to revisit it is an=
other
> series...

Agreed, I also wondered if this check is more conservative than it
needs to be in all cases.

-- Kalesh

>
> >
> >       return 0;
> > diff --git a/mm/nommu.c b/mm/nommu.c
> > index 8b819fafd57b..dd75f2334812 100644
> > --- a/mm/nommu.c
> > +++ b/mm/nommu.c
> > @@ -1316,7 +1316,7 @@ static int split_vma(struct vma_iterator *vmi, st=
ruct vm_area_struct *vma,
> >               return -ENOMEM;
> >
> >       mm =3D vma->vm_mm;
> > -     if (mm->map_count >=3D sysctl_max_map_count)
> > +     if (!vma_count_remaining(mm))
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
> > index 033a388bc4b1..df0e8409f63d 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -491,8 +491,8 @@ void unmap_region(struct ma_state *mas, struct vm_a=
rea_struct *vma,
> >  }
> >
> >  /*
> > - * __split_vma() bypasses sysctl_max_map_count checking.  We use this =
where it
> > - * has already been checked or doesn't make sense to fail.
> > + * __split_vma() bypasses vma_count_remaining() checks. We use this wh=
ere
> > + * it has already been checked or doesn't make sense to fail.
> >   * VMA Iterator will point to the original VMA.
> >   */
> >  static __must_check int
> > @@ -592,7 +592,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_are=
a_struct *vma,
> >  static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *=
vma,
> >                    unsigned long addr, int new_below)
> >  {
> > -     if (vma->vm_mm->map_count >=3D sysctl_max_map_count)
> > +     if (!vma_count_remaining(vma->vm_mm))
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
> > +                 !vma_count_remaining(vms->vma->vm_mm)) {
> >                       error =3D -ENOMEM;
> >                       goto map_count_exceeded;
> >               }
> > @@ -2772,7 +2772,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >       if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
> >               return -ENOMEM;
> >
> > -     if (mm->map_count >=3D sysctl_max_map_count)
> > +     if (!vma_count_remaining(mm))
> >               return -ENOMEM;
> >
> >       if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_i=
nternal.h
> > index 3639aa8dd2b0..52cd7ddc73f4 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -1517,4 +1517,13 @@ static inline vm_flags_t ksm_vma_flags(const str=
uct mm_struct *, const struct fi
> >       return vm_flags;
> >  }
> >
> > +/* Helper to get VMA count capacity */
> > +static int vma_count_remaining(const struct mm_struct *mm)
> > +{
> > +     const int map_count =3D mm->map_count;
> > +     const int max_count =3D sysctl_max_map_count;
> > +
> > +     return (max_count > map_count) ? (max_count - map_count) : 0;
> > +}
> > +
> >  #endif       /* __MM_VMA_INTERNAL_H */
> > --
> > 2.51.0.384.g4c02a37b29-goog
> >

