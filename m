Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14844C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9599E8E0002; Tue,  5 Aug 2025 02:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90AD38E0001; Tue,  5 Aug 2025 02:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820888E0002; Tue,  5 Aug 2025 02:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7232B8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:30:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2433D140F2B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:30:51 +0000 (UTC)
X-FDA: 83741730702.14.84BA86C
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D972160003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:30:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Vi/drBEI";
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754375449; a=rsa-sha256;
	cv=none;
	b=uRUVpOWkR8OSe83VPr0TTr05AKqmVbpwjg2g+xzmDLH/W/nN6AhpKNJqin3Ji65nx3U+O8
	F+xUJrkQ+7EYUMxLGUZcolcDn91xcvM8TpALAFQyTV1+mUSSarvIOEIpHLOgJKkzJVeqO4
	B90brXTAtUoA1aRGeKeebcwPy/nVMDw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Vi/drBEI";
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754375449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jKCzNiBFP4betutlAHF95RVjFqwZC+QyEzLLbZpDpU=;
	b=zj+E/v1WsM88ba78fvG+vM33ZdCnOB/CiBpV1XkLi2CLeWex4D26ha2RPQJltHkZt4TRnC
	5Lm93rpSSU+Nt7avhCVIHLytMpz2ah3dANq2hmfTo0PKA8WBA9QcwTDxWremX3p7oZH9M8
	YQ5PTNcB8Da8GNrtOjx6XE7Si2iEnto=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61543b05b7cso9629a12.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 23:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754375447; x=1754980247; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jKCzNiBFP4betutlAHF95RVjFqwZC+QyEzLLbZpDpU=;
        b=Vi/drBEIz66Fgy2tHS8mallQHrHE0nBTp/lslEsGZh+wh94t6bxP2lfgCjyNK80IRu
         XSIQ9swGRCs+3mMJ+xUu2rh47GJXJCIZ3DXDcLIweHZ2uknl6hOdzxghmFYyZ+EFVSGZ
         NSHmyczALRA2MHTyEqKL2ylfnp+VC4HrTkXIRM4ZI8mLOlVwUKFvZNg+TnySvlVlRJzv
         UVYPsxRwjOrxZzaa+15Ag6YQkh2EE9RLx6psAatmqttm33e53cQuVNrVK7wF5huNObuK
         lRvAxdOlUr7/23sbPk8RZk493q12zz0o1ENX47mMWnAVhk6hNIqM6sJa3fL4BZD2rWpf
         A6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754375447; x=1754980247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jKCzNiBFP4betutlAHF95RVjFqwZC+QyEzLLbZpDpU=;
        b=bQHwj5EBl7quGnFHmDoM8XcBQW50E0ZikCtGDvkNA/6CEqYl9VEuAY0T7mAt+iW7uz
         9vi3pxs+pGmFLADfDchzlgeXx4FjWelpfpea6dne6uhgGs/6aqy+TlJXqdlXeE3a9EN+
         gvkhp3qrVuZBo99Fb4XIRXG1FXB9gDEWnmN+6FTaIdSqIB3dMX6cZzlGu2hOsMEnpXGP
         DZoNOYdKPKCTAcWV46sHjxiotgGfLvkB5BJaJDXExKeSD78aGa+THu9WBKQmADC6vv2F
         jMIyQwqnvrUoHETFwXxsNR7MWnCGi7ZWHspKHrNpeprn5ob3Y2Ayt2RFZEPLMKs9cl4f
         tMsg==
X-Forwarded-Encrypted: i=1; AJvYcCWNRGxpemUPZ0NwKP9XYR9gflVQE/DwVtRdhPtbZXSBd3jRoGwUu86un3Fj1x4DJrAlMr0nP3ZzHw==@kvack.org
X-Gm-Message-State: AOJu0YzXNe1XJ+ic2Kvh2x93NZkXgwf1cLZ4PmRdd08CIBudODiOSiBc
	G6DHCPhCBfX7ckjXaf7kdb3pc1Xwliw4jqqN3nimmHSnd2Hr9AL9CZ0t74REIz6qn4d1ihoSXUq
	ib66Xr3wOhQ5I6zqhxaEeHbg24I+oWBjQbdGsUlro
X-Gm-Gg: ASbGncsRKf6scftjE/BP/bH9YlGxCpnkGGMrHS52kPRdvejBh8BOJlIk8Hd4LQ5Lt+a
	V3BFVb4EjiEgqpUx4IXi1yyH01+DM6PEJZ0KS14ooaYtOrT+0MDHD7LXwhrnzu7tLQo4TtT1B3q
	+vngctzAJ7l9kOnFnYEMdzMKrDB6ksggTsbTptT59r0RUzDE/ZEe3R8ooo7IV0RJR2/3Yz0dxRA
	VoJdY9ieQ==
X-Google-Smtp-Source: AGHT+IF9dyc8YKAvaICZJqlHqULJ/wR5cCC0kOw7URmA5UotgvJ3JQZgE4a/yTHHwWj7ulJFSDFnaIqvUefbB3nwqTw=
X-Received: by 2002:a50:8ac7:0:b0:615:6167:4835 with SMTP id
 4fb4d7f45d1cf-61784827174mr16808a12.7.1754375447152; Mon, 04 Aug 2025
 23:30:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250731104726.103071-1-lokeshgidra@google.com> <CAGsJ_4yJ5mtk_mp3r=PsMZOnHdtEk2Q_UTDjwy=4cmV8mcz+mg@mail.gmail.com>
In-Reply-To: <CAGsJ_4yJ5mtk_mp3r=PsMZOnHdtEk2Q_UTDjwy=4cmV8mcz+mg@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Mon, 4 Aug 2025 23:30:35 -0700
X-Gm-Features: Ac12FXwPLT837tjNVzFz6ic90cBYQizv07IErS2ipoubEYgqHnUpZl2nCWBF-FE
Message-ID: <CA+EESO4d_iriWeLit6RbODxxMPLnns64cuo+gkQhbYebZdHDdA@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: opportunistic TLB-flush batching for present
 pages in MOVE
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D972160003
X-Stat-Signature: 86jo48bbpfjypihf7daeyi876z1mec3q
X-HE-Tag: 1754375448-731603
X-HE-Meta: U2FsdGVkX1+YkVnH573nJI4BsyUndoIJDEwlws7QzeYdHs1+fYMXPdeQVg4NIJb3kdkyJjHmIUBQAqzQcpGMmuJ3G/qPKIl4LFEmrsBlp93XEuT1a12AcpY1f1sgyxppecJqI2kxDWmt0FcOH+CeiFlOGqfHteCAkMhBxdz+kvm/2drooOG03gxPszMB2cFtRgKdfyXKSZEgsEbBY1FhgSS0aVVmqDu7dUPxov4A77zDEApr0twlQ8x+9zosRZIPcsjrnWNCFSefxlb95iwv2ep7HJA762mk1Jsiq91atPvly4gSg0a+07XQAof0VY3er4IH4K/gZL+9gXsta4+eWL7mY5U6IfeqvtysmynRc3lKX+VVoLkEsmxiUeHPaOuosTgPBl/MDgNhzC0VUswe8zD3JuA/XVXMlqzuUwYJe51KVLi6IzS3t5S2rXYzeWZmCyc4b74tfGWml+04PNLvmOqatWCQVLTqhLtfJgwGeJPNQ6jQGDSAOk+7+R/WsXC7IuWPCIgpf/lWwrXZHIMNECLrXvq58mr9k6OiQ/Ojt0b8M0IImU/q6v2A4I+8D9yAv+OGObhhQQDzQ7IW7uNJM1QGyE2ouJjI9mzJg8UeK61139FawcczCXJDrBXd7jr1XFsSXQCH9jy9031jXsWJJKBpQ2nd+PWv52SSK1Ow3KApZjBT6smezrdjkODKardnKUtg6v9tQmHcUveKld084n2RGQHSmooDlvn3XppSNHyfeofqdIdvYcu7vrVZelTiyQ5kuOfe9wtvA3bt5aP1X0dFdWQUJgTmgF4nMz1ARI12vnJP5aZLFnSUhGUsnVvSgfoq9fiXu/VKGs1l5P97GPyjc23veMaDBbEPUg+d9iWqBMH6omRIBHLT7dzrKR8DZAAMWckIlegJe4+mK1BHIuBRKHkD6MDvkIlJeG9oF+EGYisrZoeneOzIFiOJgZKw2kQcua4qhcznxgrhE9m
 cOkkqJKF
 6t3FGWc1l7tTYuWDPHa/IPAAx05U5gwbZbq2VS+3kA3tf63DuER9ZEG9G/Lw8bX8V2l3z2HvhQTov9k5+heHpvA/8Kid7hPF6vJDsdpmzvjuJUKdR8+WmdCUjapyhpQ8uXIYSuVXy5phL3gf+U7rdKrDtMcJpbQDmdP9TWupDdcovirsFDwEhq3QUz3EWtFANgReiR4q1G1+LClqna6eRfmlqWG2rnd+LUka/SXzJawmp/Le78cg8T9wsplPgEx9+LJyFHMAKZtqadk2kLeD2oL8z9X/c9O+Pg1uNf5e+kFybB91HH97RNmgWQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 9:35=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Thu, Jul 31, 2025 at 6:47=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.=
com> wrote:
> >
> > MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> > for moving present pages. Mitigate this cost by opportunistically
> > batching present contiguous pages for TLB flushing.
> >
> > Without batching, in our testing on an arm64 Android device with UFFD G=
C,
> > which uses MOVE ioctl for compaction, we observed that out of the total
> > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> > ~20% in vm_normal_folio().
> >
> > With batching, the proportion of vm_normal_folio() increases to over
> > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > includes TLB-flush overhead.
> >
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Kalesh Singh <kaleshsingh@google.com>
> > Cc: Barry Song <v-songbaohua@oppo.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > ---
> >  mm/userfaultfd.c | 179 +++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 127 insertions(+), 52 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 8253978ee0fb..2465fb234671 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1026,18 +1026,62 @@ static inline bool is_pte_pages_stable(pte_t *d=
st_pte, pte_t *src_pte,
> >                pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> >  }
> >
> > -static int move_present_pte(struct mm_struct *mm,
> > -                           struct vm_area_struct *dst_vma,
> > -                           struct vm_area_struct *src_vma,
> > -                           unsigned long dst_addr, unsigned long src_a=
ddr,
> > -                           pte_t *dst_pte, pte_t *src_pte,
> > -                           pte_t orig_dst_pte, pte_t orig_src_pte,
> > -                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > -                           spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > -                           struct folio *src_folio)
> > +/*
> > + * Checks if the two ptes and the corresponding folio are eligible for=
 batched
> > + * move. If so, then returns pointer to the folio, after locking it. O=
therwise,
> > + * returns NULL.
> > + */
> > +static struct folio *check_ptes_for_batched_move(struct vm_area_struct=
 *src_vma,
> > +                                                unsigned long src_addr=
,
> > +                                                pte_t *src_pte, pte_t =
*dst_pte)
> > +{
> > +       pte_t orig_dst_pte, orig_src_pte;
> > +       struct folio *folio;
> > +
> > +       orig_dst_pte =3D ptep_get(dst_pte);
> > +       if (!pte_none(orig_dst_pte))
> > +               return NULL;
> > +
> > +       orig_src_pte =3D ptep_get(src_pte);
> > +       if (pte_none(orig_src_pte))
> > +               return NULL;
> > +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_src_=
pte)))
> > +               return NULL;
> > +
> > +       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> > +       if (!folio || !folio_trylock(folio))
> > +               return NULL;
> > +       if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)=
) {
> > +               folio_unlock(folio);
> > +               return NULL;
> > +       }
> > +       return folio;
> > +}
> > +
> > +static long move_present_ptes(struct mm_struct *mm,
> > +                             struct vm_area_struct *dst_vma,
> > +                             struct vm_area_struct *src_vma,
> > +                             unsigned long dst_addr, unsigned long src=
_addr,
> > +                             pte_t *dst_pte, pte_t *src_pte,
> > +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > +                             spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > +                             struct folio *src_folio, unsigned long le=
n)
> >  {
> >         int err =3D 0;
> > +       unsigned long src_start =3D src_addr;
> > +       unsigned long addr_end;
> > +
> > +       if (len > PAGE_SIZE) {
> > +               addr_end =3D (dst_addr + PMD_SIZE) & PMD_MASK;
> > +               if (dst_addr + len > addr_end)
> > +                       len =3D addr_end - dst_addr;
> >
> > +               addr_end =3D (src_addr + PMD_SIZE) & PMD_MASK;
> > +               if (src_addr + len > addr_end)
> > +                       len =3D addr_end - src_addr;
> > +       }
> > +       flush_cache_range(src_vma, src_addr, src_addr + len);
> >         double_pt_lock(dst_ptl, src_ptl);
> >
> >         if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_s=
rc_pte,
> > @@ -1051,31 +1095,60 @@ static int move_present_pte(struct mm_struct *m=
m,
> >                 err =3D -EBUSY;
> >                 goto out;
> >         }
> > +       /* Avoid batching overhead for single page case */
> > +       if (len > PAGE_SIZE) {
> > +               flush_tlb_batched_pending(mm);
>
> What=E2=80=99s confusing to me is that they track the unmapping of multip=
le
> consecutive PTEs and defer TLB invalidation until later.
> In contrast, you=E2=80=99re not tracking anything and instead call
> flush_tlb_range() directly, which triggers the flush immediately.
>
> It seems you might be combining two different batching approaches.

These changes I made are in line with how mremap() does batching. See
move_ptes() in mm/mremap.c

From the comment in flush_tlb_batched_pending() [1] it seems necessary
in this case too. Please correct me if I'm wrong. I'll be happy to
remove it if it's not required.

[1] https://elixir.bootlin.com/linux/v6.16/source/mm/rmap.c#L728

> From what I can tell, you're essentially using flush_range
> as a replacement for flushing each entry individually.

That's correct. The idea is to reduce the number of IPIs required for
flushing the TLB entries. Since it is quite common that the ioctl is
invoked with several pages in one go, this greatly benefits.

>
> > +               arch_enter_lazy_mmu_mode();
> > +               orig_src_pte =3D ptep_get_and_clear(mm, src_addr, src_p=
te);
> > +       } else
> > +               orig_src_pte =3D ptep_clear_flush(src_vma, src_addr, sr=
c_pte);
> > +
> > +       addr_end =3D src_start + len;
> > +       do {
> > +               /* Folio got pinned from under us. Put it back and fail=
 the move. */
> > +               if (folio_maybe_dma_pinned(src_folio)) {
> > +                       set_pte_at(mm, src_addr, src_pte, orig_src_pte)=
;
> > +                       err =3D -EBUSY;
> > +                       break;
> > +               }
> >
> > -       orig_src_pte =3D ptep_clear_flush(src_vma, src_addr, src_pte);
> > -       /* Folio got pinned from under us. Put it back and fail the mov=
e. */
> > -       if (folio_maybe_dma_pinned(src_folio)) {
> > -               set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> > -               err =3D -EBUSY;
> > -               goto out;
> > -       }
> > -
> > -       folio_move_anon_rmap(src_folio, dst_vma);
> > -       src_folio->index =3D linear_page_index(dst_vma, dst_addr);
> > +               folio_move_anon_rmap(src_folio, dst_vma);
> > +               src_folio->index =3D linear_page_index(dst_vma, dst_add=
r);
> >
> > -       orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page_prot)=
;
> > -       /* Set soft dirty bit so userspace can notice the pte was moved=
 */
> > +               orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_pa=
ge_prot);
> > +               /* Set soft dirty bit so userspace can notice the pte w=
as moved */
> >  #ifdef CONFIG_MEM_SOFT_DIRTY
> > -       orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> > +               orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> >  #endif
> > -       if (pte_dirty(orig_src_pte))
> > -               orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > -       orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> > +               if (pte_dirty(orig_src_pte))
> > +                       orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > +               orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> > +               set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> > +
> > +               src_addr +=3D PAGE_SIZE;
> > +               if (src_addr =3D=3D addr_end)
> > +                       break;
> > +               src_pte++;
> > +               dst_pte++;
> >
> > -       set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> > +               folio_unlock(src_folio);
> > +               src_folio =3D check_ptes_for_batched_move(src_vma, src_=
addr, src_pte, dst_pte);
> > +               if (!src_folio)
> > +                       break;
> > +               orig_src_pte =3D ptep_get_and_clear(mm, src_addr, src_p=
te);
> > +               dst_addr +=3D PAGE_SIZE;
> > +       } while (true);
> > +
> > +       if (len > PAGE_SIZE) {
> > +               arch_leave_lazy_mmu_mode();
> > +               if (src_addr > src_start)
> > +                       flush_tlb_range(src_vma, src_start, src_addr);
> > +       }
>
> Can't we just remove the `if (len > PAGE_SIZE)` check and unify the
> handling for both single-page and multi-page cases?

We certainly can. Initially it seemed to me that lazy/batched
invalidation has its own overhead and I wanted to avoid that in the
single-page case because the ioctl does get called for single pages
quite a bit. That too in time sensitive code paths. However, on a
deeper relook now, I noticed it's not really that different.

I'll unify in the next patch. Thanks for the suggestion.
>
>
> Thanks
> Barry

