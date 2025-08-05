Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7F3C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D5C6B0098; Tue,  5 Aug 2025 06:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E386B0099; Tue,  5 Aug 2025 06:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFCF96B009A; Tue,  5 Aug 2025 06:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A98DF6B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:36:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4ED18C0144
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:36:38 +0000 (UTC)
X-FDA: 83742350076.24.AAA675E
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5276C40006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:36:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NEBbQ/LV";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754390196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flYd0l6wlhO1kycZFNP4VtdlMKPos7NnhaXuJWucl9w=;
	b=ZQxYuextcxHU9G3iDWnWheYhnIiOkgxUu02/ZhZnYmjjwrAZV+oY9mghIfc6L87aV+46xe
	LaKKzfwsetluiXNCjSHfMpjK1zTT8O7kvPpx8MgZEbbgvgziD/BnkhQl41KD29mK45/Q6e
	N2T0/SYrRNxlLPf3GvpExeUKTeV0HPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754390196; a=rsa-sha256;
	cv=none;
	b=MpaIMZ0gVk3DjpfrHbDbzXRiCn+zyD440+RZl+phARLgmWfTfA6X4689l0ZzjGscSiw99h
	yCjnTQI1g+yz0nPOhrT8jqLtW8lyYetMwbpR3fT9tNVsxWqT33yfhkuhmFEhOkSzYIJURd
	THVqaeqgx8Ly7fffls7lYt7Z0/qOx2s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NEBbQ/LV";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61543b05b7cso12281a12.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754390195; x=1754994995; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=flYd0l6wlhO1kycZFNP4VtdlMKPos7NnhaXuJWucl9w=;
        b=NEBbQ/LV9CCjwBLYZ3w5uG7Rmy602fwGsnE7IoK0osuRI6YTMVFtwh7ENwjPptXgTu
         0kI/7696q8P4bcFJY3ycA59gB865mjkvWT84Xg+u3zGgz6aDUtqlP0cQxGC3VtQqDFQg
         DRjSZ9as5366R6o7ZRI0jQw47ucTriK0dZYcN3EYvho4xsmT4oPkjAuXuJfndYk4bHRM
         NBoM/mP5L8cFkh8K9JyvsjAms0Qbq6WJ6zF4B8pH/HuANmolW/7c2N5UcB6/aR4chzcm
         /LnlMxKjuTQFzlyoChx8k6hs4r//LLHPo20ZcNZaMZSQPBk+D8NWgru3E36SV+P98v09
         oPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754390195; x=1754994995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=flYd0l6wlhO1kycZFNP4VtdlMKPos7NnhaXuJWucl9w=;
        b=LCHXgJP3McTF9YNB01txZyujyeyj9MrHlZ1BpoYhoQIP/ojL7Pi+4HJzyQjSafvmwh
         O+etkOXE8ZH1ddE59+5xBqSNXwg873CvyIA6hdOqHX7njpeKB5Puvc+XlAQS0r+jRjOV
         gOO4+BbYBp//DhRHp3UY/HGnnms4aUCyrBrGyC3b9TQOuLs4V4XacRxp7qL6/fYTToUG
         Ly8aIijLK48ChomPQ37ExLms//0xF1FRMDZTRcIlb2v1PmC7itOpyrE91yd0QN2QJWs9
         4cfv3tERbFEHXjFUpgbB3qGO5BuhWgP/3I0hrdBOqD9pfe54bE2LgZOlsqRFQPWEBjIY
         M8vw==
X-Forwarded-Encrypted: i=1; AJvYcCUyoygNoaeZA3g1w2I4rzu5WHRO28UAianptMaOYPza06N/+ImNLbMgv2s29I2c3gheECLB7UQsNw==@kvack.org
X-Gm-Message-State: AOJu0YzqhV4BCW5P4Xdlz1O96RFKxMHEv3OJ9TL4aJjmmI/YxCTL2W34
	XIB2OKHtm4JW9r3KEQZvOJpqJVHW5rFRkWGvndgVF1EkbmLQPnNK6wW6+KbcnExjZhnvGsKXZ0f
	a/NJZzzbT0Atd40uoURPSiEfuw9Pj/T71iih49+hr
X-Gm-Gg: ASbGncu3IyKZBEJCeg6UWVrd72km8pLdBz63bqBvhEyDJrfjHlZS/FpeMar6s1wUh+u
	HG9CkavDgaxGvAH0IRCZ+7uYjNP3fhQi1sz24L5XLvwYxygK4vdkQ5v2hXffNJvO0o+Z1iiZFty
	u/KSbCxqANbwanjeSZBY92N3qIq1J0s1o4GnDRwvuBMowAybIl6FdeKkVfx9aRT+cN53Ma4TE5x
	lx5jKkJg40Nkb85IfIh/rQBUmBI9YJQ5HzuYNGN3A==
X-Google-Smtp-Source: AGHT+IEKIxB3NV5wlCPKPv8vT9luYio/LExjAKeWprQDsnxwJRaBfQS1ZtSlMRl35+07ZwxzeRZTNMtuqejiewPOSJg=
X-Received: by 2002:a05:6402:20d8:b0:617:4dd4:d39d with SMTP id
 4fb4d7f45d1cf-617847c8f11mr43996a12.4.1754390194361; Tue, 05 Aug 2025
 03:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250731104726.103071-1-lokeshgidra@google.com>
 <CAGsJ_4yJ5mtk_mp3r=PsMZOnHdtEk2Q_UTDjwy=4cmV8mcz+mg@mail.gmail.com>
 <CA+EESO4d_iriWeLit6RbODxxMPLnns64cuo+gkQhbYebZdHDdA@mail.gmail.com> <CAGsJ_4y7WmQaFCZsxqfLD8c6qG0NuN2Hyqxq6mgHTpCMcRuyNw@mail.gmail.com>
In-Reply-To: <CAGsJ_4y7WmQaFCZsxqfLD8c6qG0NuN2Hyqxq6mgHTpCMcRuyNw@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Tue, 5 Aug 2025 03:36:21 -0700
X-Gm-Features: Ac12FXznEDF-mMQDb-Lp9bbITxres8ak3k8eIW7caylSRtM-PIsflY8r3osXfbY
Message-ID: <CA+EESO59gMnyPE1WmEpt8+mF8-6o9FBRH9QAUzdP4+i1ptdW8w@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: opportunistic TLB-flush batching for present
 pages in MOVE
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5276C40006
X-Stat-Signature: 16ncksdhpit5g4h1dhsj3hhtdhejfmc6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754390196-91455
X-HE-Meta: U2FsdGVkX1+12Dtm4NNGi+U9ENLDi0Dft9IsYXKPcqEJQjAvnjrm1QIwRjOLMcUj2tsQ0XrBUEWd2A1P0ybo4cIvb1GqXl2P/osKbHPyCBFc9Pr8JGeTwDMIDLOzIbsG9QPmbTzv4BFp3qD3NcYsGquOIrvDbCmcf4xcFf/KiCROHn2rN9IhVK705xMHbb5E+amYhmCrZZ6ZKaV8bYU7YI0nIcIUD4YvIZG1bbTKWaPXR0Xq1guuNHk7HJWOvam68taZyTxefwe/sn7JdDZyVTcDdlQV8jXJMb+auRQtjgXeZvuZCQViSzevuQkLGs2Ry9N2Ww9p36rsH5CBuS4HfvGB3pHpLTlCS6sN0jNnn++w3z+Xnn5l4TT57z+GmZ6PsM18OVAX11kQhPLWM0jQJXFeYNJNXNOb0OJ8py0IASOTRunhdCdCi4JsVqik3lYLADu+1bpZF37TA/ZKUTn4BkgRjWJzNzGd822Mfs7JL1AvDCWMre4NBBJ0fac4Cj9xuJilpT33ypa/8A2EY3tlstP2e+s8lPcoK5fl3w+z49Vsnw+H5OvHLyoizR9+w3YdFrpj3su4GZdml2lS3vaedu4o0gCQk0lZ8v18SLnthHACYtt4ZFDvFY5aDj8N51oh2JRuVTqZvn3EyykkCMfrX0yNKBLynEAjLp/vQZ+sUuiQ1mtO7M6GSvxKS15VYJjPGBScA9xAQEold8zlZX0UtfXu/kLKdbETJguAtB0XEqkEPjzt7d7cl9Yo2wvim8IvN/IZZWN/5nT3bsce3/ROyzaKM54zOnwgIMYQpXFYDhp10mYcKYi40Ep9gLXXfjFMU51UqzM7oKZPlaSVGZdbiMnNWbwLsnYikiglgBCbCK2bbqenvRjz05/LGzcNcxYGiusoxoaBIJl8A58YMWE6Y2MEtN65mQVaDUV7M5HJyZYks6PNTJ7u77ak2cHxrto0dyU9Vv8Tv6CuQFDtYEn
 Qh60XsKH
 efgcvu6TA7lAfIOjOirq/phxstfwNMXGJsTU4GNnjkHOObRUOEKNzjRbk2rfgHxaPCg3QuJ6FR39CFV9YUrXYMbswK84nwxzZVe7G69L1uC/BfIvX/Eke2SsoUvroqEKcU9ASw1adqXjZGNJLFfrpPpyVqWKqdTI3Iow/F1rKlXPdzJhfjIXcW5uTMJigyfEmcvvbRukK+5HTwg6cBKdEG6gZKJMR48YuiqXWrMehMBpFTaa4gM42wQEYzDxEkVl7RM4eLxyAlhKI/wJGXaRHFaAx4k2+kI1dsMbk4fxwVFduRZnEoHvvEissAL3vidjVbu6ZlZeZeg88kz8sRUhRlHZEJZgm8tLi4BgOP4YGQKGXw7gl3VTC3GpzLW+7x9py0eAm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 3:21=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Tue, Aug 5, 2025 at 2:30=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
> >
> > On Mon, Aug 4, 2025 at 9:35=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > On Thu, Jul 31, 2025 at 6:47=E2=80=AFPM Lokesh Gidra <lokeshgidra@goo=
gle.com> wrote:
> > > >
> > > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is requi=
red
> > > > for moving present pages. Mitigate this cost by opportunistically
> > > > batching present contiguous pages for TLB flushing.
> > > >
> > > > Without batching, in our testing on an arm64 Android device with UF=
FD GC,
> > > > which uses MOVE ioctl for compaction, we observed that out of the t=
otal
> > > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), =
and
> > > > ~20% in vm_normal_folio().
> > > >
> > > > With batching, the proportion of vm_normal_folio() increases to ove=
r
> > > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > > includes TLB-flush overhead.
> > > >
> > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > Cc: Kalesh Singh <kaleshsingh@google.com>
> > > > Cc: Barry Song <v-songbaohua@oppo.com>
> > > > Cc: David Hildenbrand <david@redhat.com>
> > > > Cc: Peter Xu <peterx@redhat.com>
> > > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > > ---
> > > >  mm/userfaultfd.c | 179 +++++++++++++++++++++++++++++++++----------=
----
> > > >  1 file changed, 127 insertions(+), 52 deletions(-)
> > > >
> > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > index 8253978ee0fb..2465fb234671 100644
> > > > --- a/mm/userfaultfd.c
> > > > +++ b/mm/userfaultfd.c
> > > > @@ -1026,18 +1026,62 @@ static inline bool is_pte_pages_stable(pte_=
t *dst_pte, pte_t *src_pte,
> > > >                pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> > > >  }
> > > >
> > > > -static int move_present_pte(struct mm_struct *mm,
> > > > -                           struct vm_area_struct *dst_vma,
> > > > -                           struct vm_area_struct *src_vma,
> > > > -                           unsigned long dst_addr, unsigned long s=
rc_addr,
> > > > -                           pte_t *dst_pte, pte_t *src_pte,
> > > > -                           pte_t orig_dst_pte, pte_t orig_src_pte,
> > > > -                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > > -                           spinlock_t *dst_ptl, spinlock_t *src_pt=
l,
> > > > -                           struct folio *src_folio)
> > > > +/*
> > > > + * Checks if the two ptes and the corresponding folio are eligible=
 for batched
> > > > + * move. If so, then returns pointer to the folio, after locking i=
t. Otherwise,
> > > > + * returns NULL.
> > > > + */
> > > > +static struct folio *check_ptes_for_batched_move(struct vm_area_st=
ruct *src_vma,
> > > > +                                                unsigned long src_=
addr,
> > > > +                                                pte_t *src_pte, pt=
e_t *dst_pte)
> > > > +{
> > > > +       pte_t orig_dst_pte, orig_src_pte;
> > > > +       struct folio *folio;
> > > > +
> > > > +       orig_dst_pte =3D ptep_get(dst_pte);
> > > > +       if (!pte_none(orig_dst_pte))
> > > > +               return NULL;
> > > > +
> > > > +       orig_src_pte =3D ptep_get(src_pte);
> > > > +       if (pte_none(orig_src_pte))
> > > > +               return NULL;
> > > > +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_=
src_pte)))
> > > > +               return NULL;
> > > > +
> > > > +       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> > > > +       if (!folio || !folio_trylock(folio))
> > > > +               return NULL;
> > > > +       if (!PageAnonExclusive(&folio->page) || folio_test_large(fo=
lio)) {
> > > > +               folio_unlock(folio);
> > > > +               return NULL;
> > > > +       }
> > > > +       return folio;
> > > > +}
> > > > +
> > > > +static long move_present_ptes(struct mm_struct *mm,
> > > > +                             struct vm_area_struct *dst_vma,
> > > > +                             struct vm_area_struct *src_vma,
> > > > +                             unsigned long dst_addr, unsigned long=
 src_addr,
> > > > +                             pte_t *dst_pte, pte_t *src_pte,
> > > > +                             pte_t orig_dst_pte, pte_t orig_src_pt=
e,
> > > > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > > +                             spinlock_t *dst_ptl, spinlock_t *src_=
ptl,
> > > > +                             struct folio *src_folio, unsigned lon=
g len)
> > > >  {
> > > >         int err =3D 0;
> > > > +       unsigned long src_start =3D src_addr;
> > > > +       unsigned long addr_end;
> > > > +
> > > > +       if (len > PAGE_SIZE) {
> > > > +               addr_end =3D (dst_addr + PMD_SIZE) & PMD_MASK;
> > > > +               if (dst_addr + len > addr_end)
> > > > +                       len =3D addr_end - dst_addr;
> > > >
> > > > +               addr_end =3D (src_addr + PMD_SIZE) & PMD_MASK;
> > > > +               if (src_addr + len > addr_end)
> > > > +                       len =3D addr_end - src_addr;
> > > > +       }
> > > > +       flush_cache_range(src_vma, src_addr, src_addr + len);
> > > >         double_pt_lock(dst_ptl, src_ptl);
> > > >
> > > >         if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, or=
ig_src_pte,
> > > > @@ -1051,31 +1095,60 @@ static int move_present_pte(struct mm_struc=
t *mm,
> > > >                 err =3D -EBUSY;
> > > >                 goto out;
> > > >         }
> > > > +       /* Avoid batching overhead for single page case */
> > > > +       if (len > PAGE_SIZE) {
> > > > +               flush_tlb_batched_pending(mm);
> > >
> > > What=E2=80=99s confusing to me is that they track the unmapping of mu=
ltiple
> > > consecutive PTEs and defer TLB invalidation until later.
> > > In contrast, you=E2=80=99re not tracking anything and instead call
> > > flush_tlb_range() directly, which triggers the flush immediately.
> > >
> > > It seems you might be combining two different batching approaches.
> >
> > These changes I made are in line with how mremap() does batching. See
> > move_ptes() in mm/mremap.c
> >
> > From the comment in flush_tlb_batched_pending() [1] it seems necessary
> > in this case too. Please correct me if I'm wrong. I'll be happy to
> > remove it if it's not required.
> >
> > [1] https://elixir.bootlin.com/linux/v6.16/source/mm/rmap.c#L728
>
> Whether we need flush_tlb_batched_pending() has nothing to do with your
> patch. It's entirely about synchronizing with other pending TLBIs, such a=
s
> those from try_to_unmap_one() and try_to_migrate_one().
>
> In short, if it's needed, it's needed regardless of whether your patch is
> applied or whether you're dealing with len > PAGE_SIZE.
>
> >
> > > From what I can tell, you're essentially using flush_range
> > > as a replacement for flushing each entry individually.
> >
> > That's correct. The idea is to reduce the number of IPIs required for
> > flushing the TLB entries. Since it is quite common that the ioctl is
> > invoked with several pages in one go, this greatly benefits.
> >
> > >
> > > > +               arch_enter_lazy_mmu_mode();
> > > > +               orig_src_pte =3D ptep_get_and_clear(mm, src_addr, s=
rc_pte);
> > > > +       } else
> > > > +               orig_src_pte =3D ptep_clear_flush(src_vma, src_addr=
, src_pte);
> > > > +
> > > > +       addr_end =3D src_start + len;
> > > > +       do {
> > > > +               /* Folio got pinned from under us. Put it back and =
fail the move. */
> > > > +               if (folio_maybe_dma_pinned(src_folio)) {
> > > > +                       set_pte_at(mm, src_addr, src_pte, orig_src_=
pte);
> > > > +                       err =3D -EBUSY;
> > > > +                       break;
> > > > +               }
> > > >
> > > > -       orig_src_pte =3D ptep_clear_flush(src_vma, src_addr, src_pt=
e);
> > > > -       /* Folio got pinned from under us. Put it back and fail the=
 move. */
> > > > -       if (folio_maybe_dma_pinned(src_folio)) {
> > > > -               set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> > > > -               err =3D -EBUSY;
> > > > -               goto out;
> > > > -       }
> > > > -
> > > > -       folio_move_anon_rmap(src_folio, dst_vma);
> > > > -       src_folio->index =3D linear_page_index(dst_vma, dst_addr);
> > > > +               folio_move_anon_rmap(src_folio, dst_vma);
> > > > +               src_folio->index =3D linear_page_index(dst_vma, dst=
_addr);
> > > >
> > > > -       orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page_p=
rot);
> > > > -       /* Set soft dirty bit so userspace can notice the pte was m=
oved */
> > > > +               orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->v=
m_page_prot);
> > > > +               /* Set soft dirty bit so userspace can notice the p=
te was moved */
> > > >  #ifdef CONFIG_MEM_SOFT_DIRTY
> > > > -       orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> > > > +               orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> > > >  #endif
> > > > -       if (pte_dirty(orig_src_pte))
> > > > -               orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > > > -       orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> > > > +               if (pte_dirty(orig_src_pte))
> > > > +                       orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > > > +               orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma)=
;
> > > > +               set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> > > > +
> > > > +               src_addr +=3D PAGE_SIZE;
> > > > +               if (src_addr =3D=3D addr_end)
> > > > +                       break;
> > > > +               src_pte++;
> > > > +               dst_pte++;
> > > >
> > > > -       set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> > > > +               folio_unlock(src_folio);
> > > > +               src_folio =3D check_ptes_for_batched_move(src_vma, =
src_addr, src_pte, dst_pte);
> > > > +               if (!src_folio)
> > > > +                       break;
> > > > +               orig_src_pte =3D ptep_get_and_clear(mm, src_addr, s=
rc_pte);
> > > > +               dst_addr +=3D PAGE_SIZE;
> > > > +       } while (true);
> > > > +
> > > > +       if (len > PAGE_SIZE) {
> > > > +               arch_leave_lazy_mmu_mode();
> > > > +               if (src_addr > src_start)
> > > > +                       flush_tlb_range(src_vma, src_start, src_add=
r);
> > > > +       }
> > >
> > > Can't we just remove the `if (len > PAGE_SIZE)` check and unify the
> > > handling for both single-page and multi-page cases?
> >
> > We certainly can. Initially it seemed to me that lazy/batched
> > invalidation has its own overhead and I wanted to avoid that in the
> > single-page case because the ioctl does get called for single pages
> > quite a bit. That too in time sensitive code paths. However, on a
> > deeper relook now, I noticed it's not really that different.
> >
> > I'll unify in the next patch. Thanks for the suggestion.
>
> Yes, that would be nice =E2=80=94 especially since flush_tlb_batched_pend=
ing()
> is not needed in this patch.
>
> Whether it's needed for uffd_move is a separate matter and should be
> addressed in a separate patch, if necessary =E2=80=94 for example, if the=
re's a
> similar race as described in Commit 3ea277194daa
> ("mm, mprotect: flush TLB if potentially racing with a parallel reclaim
> leaving stale TLB entries").
>
>
>
>             CPU0                            CPU1
>
>             ----                            ----
>
>                                             user accesses memory using RW=
 PTE
>
>                                             [PTE now cached in TLB]
>
>             try_to_unmap_one()
>
>             =3D=3D> ptep_get_and_clear()
>
>             =3D=3D> set_tlb_ubc_flush_pending()
>
>                                             mprotect(addr, PROT_READ)
>
>                                             =3D=3D> change_pte_range()
>
>                                             =3D=3D> [ PTE non-present - n=
o flush ]
>
>
>
>                                             user writes using cached RW P=
TE
>
>             ...
>
>             try_to_unmap_flush()
>
Thanks so much for clarifying. I understand the issue now. I'll think
about whether we need it in userfaultfd_move or not. But as you said
that is for a separate patch, if needed.

I'll upload v2 in some time.

> Thanks
> Barry

