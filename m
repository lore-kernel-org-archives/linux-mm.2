Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F60C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 22:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E28E6B007B; Fri, 25 Jul 2025 18:36:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692866B0089; Fri, 25 Jul 2025 18:36:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7DE6B008A; Fri, 25 Jul 2025 18:36:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49A356B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:36:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93097133EEE
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:36:11 +0000 (UTC)
X-FDA: 83704246542.30.2384048
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7496B180002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:36:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ClEvzSw2;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753482969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9d5B9fr4Nfm+zF43cKINLpDPc+Ji1sf50+7PmWlTvU=;
	b=YCXueNgVICte06Tg3CrqGD/+pLmSdKp1ASArSJ6Lgv+VmDiGniYx5WBT9f1T9LQZ3MdD2r
	6+HgGCfNPtItoLum/CoiDoe1FaAq/bbDHbFrWUiiZDrzqsXcDEmPNhErJvcUHs9KES06e0
	SLo3exqSJmZa/ZIQD67/ltl9s8tvza4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ClEvzSw2;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753482969; a=rsa-sha256;
	cv=none;
	b=scNLGBKRvgtGYM/EtfbNCpJWZTK7bpr+D48JGAzOrmnuD7kWb4A+HNJINBS5XAL3gWOHX3
	E3zwFFcNuFVjoEv2HKA7D4Ny67DxnMobGWj2bj77kNK1Gmc+bNxs+W1jtB2FvpH7PgZGwT
	lSA4Cln0y6hVzgBBGJjWXTWdlu/ZVE0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753482968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a9d5B9fr4Nfm+zF43cKINLpDPc+Ji1sf50+7PmWlTvU=;
	b=ClEvzSw29ilwq3GvBP/oGl09JW/jVycRd+Rf5Eczo2OpjsWGkWiAJC63tOB5kY6JvZ9pUn
	Uz2pxJKCs9ovzzJ15+I5GzlExa9BKrrkvCniDdEthfEhU5kydijQae36lnf6bEs25kNQfG
	QjFbfJydLoTKMeqyUlw1Kv0EC+dEc5M=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-PMFCfbm4NmuGbcLCFzYWig-1; Fri, 25 Jul 2025 18:36:07 -0400
X-MC-Unique: PMFCfbm4NmuGbcLCFzYWig-1
X-Mimecast-MFC-AGG-ID: PMFCfbm4NmuGbcLCFzYWig_1753482967
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-71838151744so38501847b3.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753482967; x=1754087767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9d5B9fr4Nfm+zF43cKINLpDPc+Ji1sf50+7PmWlTvU=;
        b=UQ2Z4FyYjfDv0RPSgZ/2++Waolx6MlO85Khwb8euVcBhOim9vdHiykEvDmaIqK9R3w
         TD4eGXizg6sDvrrxjuc/oRXD8cXyzDlzf7AwjqXVQQk+yZaFFSL9B1Y+TyllkibvyxHO
         LD9tDx+8XHHGHKhN4Prnmvspn0JCa9ggT5RmWWY3iuAP/NvaA1ldDBb4hvXjWMfCZ1tp
         ZLYwS353v6kW+v4Ua2uGJk48RTxhbkfZMli+dHOYh7N7e+Em/MbxnM5bCuKTsCCgXfR3
         Io9RnRHjQucJHFEAwGD2fMomM+0kWKkzEg3pz/LyYF0VxBtPcS/wXRSr4W5h9CfIEOkM
         4xwA==
X-Gm-Message-State: AOJu0Yz0kMCn1UL1FXmZDmBX8zWi4osk27QKqjvnh5LwT2LtHatlnjYV
	sI0gHTZxY9/sL2hWEc4xb0qdL0RQdiQAlYsqMtgR4EDy/VdzsX07HLtJE4lE9i03EsdC/YCLmZf
	gn0D1k/QsbD3C9pREhcuxYDNFELxGOvb52ff1MdSY/5Zqbdr3d9KzPHyXfjcUbYAONyaMaqsvKy
	clfErtSy1OgU4VEip7vRmze8Fdblo=
X-Gm-Gg: ASbGncuKE9px3qt99m3lABucSHR9pJ5KdgQSghJj6x15qWyp1eyInGFUMrfzijTjcnC
	SBweYa/SSv2SIDNL2VuOBtslbev4TuvPX9C8dkHFgUctHZhf4fZAqolEHHxCtaFLJ4s75Asw7Xj
	cVnFOlQgWCMUgFSUNWzxqoh7U=
X-Received: by 2002:a05:690c:d90:b0:714:268:a9f8 with SMTP id 00721157ae682-719e341e6a9mr44682507b3.27.1753482966596;
        Fri, 25 Jul 2025 15:36:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpjppnEr5ljWGh9tArrsIJ5IRH6CVauDHUkUdyxGIimReaTFjjdrsPrpmlcjRIbGNsIDizaerPjiiSlgiVQZ4=
X-Received: by 2002:a05:690c:d90:b0:714:268:a9f8 with SMTP id
 00721157ae682-719e341e6a9mr44681987b3.27.1753482965992; Fri, 25 Jul 2025
 15:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250714003207.113275-1-npache@redhat.com> <20250714003207.113275-2-npache@redhat.com>
 <02aa93fa-b179-48b9-a319-264be0e027a0@lucifer.local>
In-Reply-To: <02aa93fa-b179-48b9-a319-264be0e027a0@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Fri, 25 Jul 2025 16:35:39 -0600
X-Gm-Features: Ac12FXy8rwzZlL0SK2QdvPBGS9FXasbUCB1K3oRqNSBr9kuXSbYU0DuDKRZp-pg
Message-ID: <CAA1CXcAv=zSRwos-j7VeYuJRXRqUPy3VUZ06HuQ5u+6krG8woA@mail.gmail.com>
Subject: Re: [PATCH v9 01/14] khugepaged: rename hpage_collapse_* to collapse_*
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YNk3-kDJYk-Y8ls50y16-zvzaS10kwyB85mR2WRZKoQ_1753482967
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pp4yaaacmsy7b4zjni4p475a3ahfdcmp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7496B180002
X-Rspam-User: 
X-HE-Tag: 1753482969-326002
X-HE-Meta: U2FsdGVkX1+DrN3/y0s2ED/Y4DXG+qxZVhdqWiDpNQRrp0cktZOEIYWX52EVbH5l4CuYDtx/fHnPyuWSHrsMT2dNLG/bxlAdNRG+sU5QL560Rffo+oUGaVdi96g2peYjD9y8BoBQOr/9B0nObWveAy2W2tS17idd71mnwOCM8M76cB0vkIghPtXLDl5pXwDqhN7S2Jh312ukwhxaNd2FuSlC/iU0UXjitxosaja/uMWfvtu47FS3UC2w6lqQNlKekoF9SuYQehZwNXL4kcFLlmXMYRc4huGqvueDtzBEX+1XJ5p3MfzQPtz9HpWLRzyyQDfLx0i2i/R1cbdgk15O5V8ECKFtfZK3hy5h2vh/0qtne3R+oZU5axLy+pEOwL0lNaCvFumv87I8cx/q1AZjn2CoWFJw0dC0P4LLxfhGnjdpwzkHvtQsU0pX5kCvFs/Mq2H4yO6M5ZjcIZE4U1fMzsBBpW/jUD+Jn+JjP4c1ecQW1GJqm4d7KUN0fbSCZjNoQlnxDFuyh0SUlNOY4ZYUjr3zYS/1ZGkQBL6gMTgNpqM3coq44pCun+oE/6GyrklZtKAhGULYLI4cKi1x5R5tmbRzAivQn4Rzh9Cghd334UYLRh/f3jkPR+kBEvYavwn4eNDI1TP4A6u1Y3hszSGDTkwuJs69Lnm+XLfd+FLQdVyaBNkgBuIFuyG2NQozC5cWZGvyRvltl6LHrtyEgf4BNlXP2y6SbgMVXW54l4bGr0FIEfAqiU+ndg+9TvoQ/ofhpmAIRqkMho/IW0baS11sjYs8dRIaV6KKgTL5WaSKZLUrn9Ppk4B6Xz2S8oWuhdg614Aarx+7JC30TBJqdCFkdZOI+S3Nfgkdl1o23mOZUTg8L5m+ehSAeqX1XQnZQbNJZqEjCGkEJbCLiFIpqFEBVTzo5ivFDvMtbPJ33U1VsKJi1W87fGaocB/rciU2Rr4W80IfUYG1KHa8g+ipYhU
 Fvq5nwu/
 4orYIlxeTeb2yFolRDOC7ZNmEDhdzcbypUeJcSJYBwoPOoBy/pl+F4l3T1XWNFq3IHylANBHgHgxMJHDX7YFAEFt02gsAz+9tWDnIFBirOlPh0NU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 10:44=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Hm it seems you missed some places:
Hehe I did notice that after running the git rebase --exec script
David showed me. Already fixed, it will be in the V10!
>
> mm/khugepaged.c: In function =E2=80=98collapse_scan_mm_slot=E2=80=99:
> mm/khugepaged.c:2466:43: error: implicit declaration of function =E2=80=
=98hpage_collapse_scan_file=E2=80=99; did you mean =E2=80=98collapse_scan_f=
ile=E2=80=99? [-Wimplicit-function-declaration]
>  2466 |                                 *result =3D hpage_collapse_scan_f=
ile(mm,
>       |                                           ^~~~~~~~~~~~~~~~~~~~~~~=
~
>       |                                           collapse_scan_file
> mm/khugepaged.c:2471:45: error: implicit declaration of function =E2=80=
=98hpage_collapse_test_exit_or_disable=E2=80=99; did you mean =E2=80=98coll=
apse_test_exit_or_disable=E2=80=99? [-Wimplicit-function-declaration]
>  2471 |                                         if (hpage_collapse_test_e=
xit_or_disable(mm))
>       |                                             ^~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~
>       |                                             collapse_test_exit_or=
_disable
> mm/khugepaged.c:2480:43: error: implicit declaration of function =E2=80=
=98hpage_collapse_scan_pmd=E2=80=99; did you mean =E2=80=98collapse_scan_pm=
d=E2=80=99? [-Wimplicit-function-declaration]
>  2480 |                                 *result =3D hpage_collapse_scan_p=
md(mm, vma,
>       |                                           ^~~~~~~~~~~~~~~~~~~~~~~
>       |                                           collapse_scan_pmd
> mm/khugepaged.c: At top level:
> mm/khugepaged.c:2278:12: error: =E2=80=98collapse_scan_file=E2=80=99 defi=
ned but not used [-Werror=3Dunused-function]
>  2278 | static int collapse_scan_file(struct mm_struct *mm, unsigned long=
 addr,
>       |            ^~~~~~~~~~~~~~~~~~
> mm/khugepaged.c:1271:12: error: =E2=80=98collapse_scan_pmd=E2=80=99 defin=
ed but not used [-Werror=3Dunused-function]
>  1271 | static int collapse_scan_pmd(struct mm_struct *mm,
>       |            ^~~~~~~~~~~~~~~~~
>
> Other than this it LGTM, so once you fix this stuff up you can get a tag =
:)
Awesome Thanks!
>
> On Sun, Jul 13, 2025 at 06:31:54PM -0600, Nico Pache wrote:
> > The hpage_collapse functions describe functions used by madvise_collaps=
e
> > and khugepaged. remove the unnecessary hpage prefix to shorten the
> > function name.
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 46 +++++++++++++++++++++++-----------------------
> >  1 file changed, 23 insertions(+), 23 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index a55fb1dcd224..eb0babb51868 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -402,14 +402,14 @@ void __init khugepaged_destroy(void)
> >       kmem_cache_destroy(mm_slot_cache);
> >  }
> >
> > -static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> > +static inline int collapse_test_exit(struct mm_struct *mm)
> >  {
> >       return atomic_read(&mm->mm_users) =3D=3D 0;
> >  }
> >
> > -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct=
 *mm)
> > +static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
> >  {
> > -     return hpage_collapse_test_exit(mm) ||
> > +     return collapse_test_exit(mm) ||
> >              test_bit(MMF_DISABLE_THP, &mm->flags);
> >  }
> >
> > @@ -444,7 +444,7 @@ void __khugepaged_enter(struct mm_struct *mm)
> >       int wakeup;
> >
> >       /* __khugepaged_exit() must not run from under us */
> > -     VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> > +     VM_BUG_ON_MM(collapse_test_exit(mm), mm);
> >       if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags)))
> >               return;
> >
> > @@ -503,7 +503,7 @@ void __khugepaged_exit(struct mm_struct *mm)
> >       } else if (mm_slot) {
> >               /*
> >                * This is required to serialize against
> > -              * hpage_collapse_test_exit() (which is guaranteed to run
> > +              * collapse_test_exit() (which is guaranteed to run
> >                * under mmap sem read mode). Stop here (after we return =
all
> >                * pagetables will be destroyed) until khugepaged has fin=
ished
> >                * working on the pagetables under the mmap_lock.
> > @@ -838,7 +838,7 @@ struct collapse_control khugepaged_collapse_control=
 =3D {
> >       .is_khugepaged =3D true,
> >  };
> >
> > -static bool hpage_collapse_scan_abort(int nid, struct collapse_control=
 *cc)
> > +static bool collapse_scan_abort(int nid, struct collapse_control *cc)
> >  {
> >       int i;
> >
> > @@ -873,7 +873,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpma=
sk(void)
> >  }
> >
> >  #ifdef CONFIG_NUMA
> > -static int hpage_collapse_find_target_node(struct collapse_control *cc=
)
> > +static int collapse_find_target_node(struct collapse_control *cc)
> >  {
> >       int nid, target_node =3D 0, max_value =3D 0;
> >
> > @@ -892,7 +892,7 @@ static int hpage_collapse_find_target_node(struct c=
ollapse_control *cc)
> >       return target_node;
> >  }
> >  #else
> > -static int hpage_collapse_find_target_node(struct collapse_control *cc=
)
> > +static int collapse_find_target_node(struct collapse_control *cc)
> >  {
> >       return 0;
> >  }
> > @@ -912,7 +912,7 @@ static int hugepage_vma_revalidate(struct mm_struct=
 *mm, unsigned long address,
> >       struct vm_area_struct *vma;
> >       unsigned long tva_flags =3D cc->is_khugepaged ? TVA_ENFORCE_SYSFS=
 : 0;
> >
> > -     if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> > +     if (unlikely(collapse_test_exit_or_disable(mm)))
> >               return SCAN_ANY_PROCESS;
> >
> >       *vmap =3D vma =3D find_vma(mm, address);
> > @@ -985,7 +985,7 @@ static int check_pmd_still_valid(struct mm_struct *=
mm,
> >
> >  /*
> >   * Bring missing pages in from swap, to complete THP collapse.
> > - * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
> > + * Only done if khugepaged_scan_pmd believes it is worthwhile.
> >   *
> >   * Called and returns without pte mapped or spinlocks held.
> >   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
> > @@ -1071,7 +1071,7 @@ static int alloc_charge_folio(struct folio **foli=
op, struct mm_struct *mm,
> >  {
> >       gfp_t gfp =3D (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpm=
ask() :
> >                    GFP_TRANSHUGE);
> > -     int node =3D hpage_collapse_find_target_node(cc);
> > +     int node =3D collapse_find_target_node(cc);
> >       struct folio *folio;
> >
> >       folio =3D __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nm=
ask);
> > @@ -1257,7 +1257,7 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,
> >       return result;
> >  }
> >
> > -static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> > +static int collapse_scan_pmd(struct mm_struct *mm,
> >                                  struct vm_area_struct *vma,
> >                                  unsigned long address, bool *mmap_lock=
ed,
> >                                  struct collapse_control *cc)
> > @@ -1371,7 +1371,7 @@ static int hpage_collapse_scan_pmd(struct mm_stru=
ct *mm,
> >                * hit record.
> >                */
> >               node =3D folio_nid(folio);
> > -             if (hpage_collapse_scan_abort(node, cc)) {
> > +             if (collapse_scan_abort(node, cc)) {
> >                       result =3D SCAN_SCAN_ABORT;
> >                       goto out_unmap;
> >               }
> > @@ -1440,7 +1440,7 @@ static void collect_mm_slot(struct khugepaged_mm_=
slot *mm_slot)
> >
> >       lockdep_assert_held(&khugepaged_mm_lock);
> >
> > -     if (hpage_collapse_test_exit(mm)) {
> > +     if (collapse_test_exit(mm)) {
> >               /* free mm_slot */
> >               hash_del(&slot->hash);
> >               list_del(&slot->mm_node);
> > @@ -1733,7 +1733,7 @@ static void retract_page_tables(struct address_sp=
ace *mapping, pgoff_t pgoff)
> >               if (find_pmd_or_thp_or_none(mm, addr, &pmd) !=3D SCAN_SUC=
CEED)
> >                       continue;
> >
> > -             if (hpage_collapse_test_exit(mm))
> > +             if (collapse_test_exit(mm))
> >                       continue;
> >               /*
> >                * When a vma is registered with uffd-wp, we cannot recyc=
le
> > @@ -2255,7 +2255,7 @@ static int collapse_file(struct mm_struct *mm, un=
signed long addr,
> >       return result;
> >  }
> >
> > -static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned lon=
g addr,
> > +static int collapse_scan_file(struct mm_struct *mm, unsigned long addr=
,
> >                                   struct file *file, pgoff_t start,
> >                                   struct collapse_control *cc)
> >  {
> > @@ -2312,7 +2312,7 @@ static int hpage_collapse_scan_file(struct mm_str=
uct *mm, unsigned long addr,
> >               }
> >
> >               node =3D folio_nid(folio);
> > -             if (hpage_collapse_scan_abort(node, cc)) {
> > +             if (collapse_scan_abort(node, cc)) {
> >                       result =3D SCAN_SCAN_ABORT;
> >                       folio_put(folio);
> >                       break;
> > @@ -2362,7 +2362,7 @@ static int hpage_collapse_scan_file(struct mm_str=
uct *mm, unsigned long addr,
> >       return result;
> >  }
> >
> > -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *r=
esult,
> > +static unsigned int collapse_scan_mm_slot(unsigned int pages, int *res=
ult,
> >                                           struct collapse_control *cc)
> >       __releases(&khugepaged_mm_lock)
> >       __acquires(&khugepaged_mm_lock)
> > @@ -2400,7 +2400,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
> >               goto breakouterloop_mmap_lock;
> >
> >       progress++;
> > -     if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> > +     if (unlikely(collapse_test_exit_or_disable(mm)))
> >               goto breakouterloop;
> >
> >       vma_iter_init(&vmi, mm, khugepaged_scan.address);
> > @@ -2408,7 +2408,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
> >               unsigned long hstart, hend;
> >
> >               cond_resched();
> > -             if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> > +             if (unlikely(collapse_test_exit_or_disable(mm))) {
> >                       progress++;
> >                       break;
> >               }
> > @@ -2430,7 +2430,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
> >                       bool mmap_locked =3D true;
> >
> >                       cond_resched();
> > -                     if (unlikely(hpage_collapse_test_exit_or_disable(=
mm)))
> > +                     if (unlikely(collapse_test_exit_or_disable(mm)))
> >                               goto breakouterloop;
> >
> >                       VM_BUG_ON(khugepaged_scan.address < hstart ||
> > @@ -2490,7 +2490,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
> >        * Release the current mm_slot if this mm is about to die, or
> >        * if we scanned all vmas of this mm.
> >        */
> > -     if (hpage_collapse_test_exit(mm) || !vma) {
> > +     if (collapse_test_exit(mm) || !vma) {
> >               /*
> >                * Make sure that if mm_users is reaching zero while
> >                * khugepaged runs here, khugepaged_exit will find
> > @@ -2544,7 +2544,7 @@ static void khugepaged_do_scan(struct collapse_co=
ntrol *cc)
> >                       pass_through_head++;
> >               if (khugepaged_has_work() &&
> >                   pass_through_head < 2)
> > -                     progress +=3D khugepaged_scan_mm_slot(pages - pro=
gress,
> > +                     progress +=3D collapse_scan_mm_slot(pages - progr=
ess,
> >                                                           &result, cc);
> >               else
> >                       progress =3D pages;
> > --
> > 2.50.0
> >
>


