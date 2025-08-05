Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756AAC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018E76B0093; Tue,  5 Aug 2025 06:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F332D6B0095; Tue,  5 Aug 2025 06:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48FE6B0096; Tue,  5 Aug 2025 06:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEE0D6B0093
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:21:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A52D80F74
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:21:22 +0000 (UTC)
X-FDA: 83742311604.17.B985E0B
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 669C9140006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:21:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TpkbAcrf;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754389280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KINrld3kBoM9uGnKfXQjYnfgm20s8mcD75wPbUpT8k0=;
	b=gOl7PxpY0a9MlFrVLvnFg0+u0PLJ6Yjc2cA991++EZXcxz2rAm6YR4NmRTHMUFnhDd/u/G
	6uB9O2Z2Vh9IuAYGXCs1CUxM7UWF05QgTHkIZDijcQfz/n7TNd0EpBqMHRo0NgUVqS/TwK
	4yVTmp6ycVVO3LtzVndD34f53nv72n0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754389280; a=rsa-sha256;
	cv=none;
	b=XNvGuyzOmFY9tnbmHrci0zCEx+LE74/Gy67KpjzleMSDcHoqDe70CYrpSxzJtoxo0p4gNm
	xWZPCgAAfIjD2iQGdizt4P6+jdkyYDecDYpXfJ1B45tke0bOTAdQ066ClrGefle5OQDkxi
	UiS1yfW7PerPqd1iGuIw1Xrl9MZtNOs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TpkbAcrf;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-500006b3efdso1664008137.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754389279; x=1754994079; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KINrld3kBoM9uGnKfXQjYnfgm20s8mcD75wPbUpT8k0=;
        b=TpkbAcrffeNOyGFrqu/NU7FGtp76u8bUcix3j56X4HFSmK6qt4/NPpM8HQrvh58Dvq
         /SLQ3Y6pwlC5kT0irtLaOxMhRA5YjNc8x7+Qtp4kfyAGaLFQdOSegAaVwLWoW4x87J1I
         HH0kBBSidPPb1aCCOgFOO+MHJs6B1/9qoWum41qadXHxkN/ioY7he9B0Rf5xoB7tLv48
         UoQOOqcg6Dh2MAz8KnkQl6E/Ts8uJSrJZi/wcEhVwMdyi45dN/poF9mRdLuiaH+FJqSD
         J87U1D7/KwRJA9UMa/ix6MaapLl0SXFwOnvm9nw4JSC83ePsQNc/2zI9952jM26NwzUj
         8lbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754389279; x=1754994079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KINrld3kBoM9uGnKfXQjYnfgm20s8mcD75wPbUpT8k0=;
        b=Lsmlg8lfL5xqFMz5Ci2vYSvgo9Yw/bYszAE9dl9YwqYO+xVIzFy0/rU8rZekGOMLKB
         +JUL0/rga/TwJ7ck7j2/mhEtQQhaysV6g56YzOMce+Dc7KmgbfH6YfMiounpdv/WuUWj
         nYPtdLCaXMbE//HvesASU11hzZXK+qNNHKaqP/DJnd8bnyA1RLJw9fgXC92NNECb/+vk
         EbylPiY4pMQHd3IkzAu5o94qRSmhc7RTDf7dENn3l/J1IWdbeiyXkl9f8//IL2/Gamcd
         xeOSjIyJR7JHeTX8zuHPaSfOouUw2eqordjwzxlilZo5Z/eDfTYw2sNqPO70idq2JK9R
         D+Ow==
X-Forwarded-Encrypted: i=1; AJvYcCX+gD8EbpH+I5yYUAsnoCx4f+QEksc0Q8tUy0ih2/q3C9h8lGPLcYwmFCxjji2MFxdlvxrIb35qSQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/romgi3DCFwlG61MSDCYz9BEjSz+NO00fACfjMaUmGZun8e72
	jXe12R8nsQ9KaMwSMI4jO9QCjPCfbLc59xbHfybN/5J7y4ahRJlj/qNZhkWCi03j9rfrdcvAgf2
	ozoSQB/Dk2tKDA92CutJsPbbjpWMBST8=
X-Gm-Gg: ASbGncseuGa4B/JOuMjqh8nmPdA431d9+O/0ckgmFYpZobJjRH8+kZHX6K2FasX3mTz
	KuEOOU3jVfV8aopu2iPMOwWqMIyEbX8MXYHOFCS5aycYv3sPyE/8EoWZB2qKERFP9IkZZO4eLF0
	rUuXgyh7Or7YxlfPZte9D3w+ZuSReVEq+KTfmnG5oDk3ylE+lE61U7X38agXVNUFA9m4O5wJHQ2
	UDU3bLGxc8RGxzj6w==
X-Google-Smtp-Source: AGHT+IFiRL5PcOs1FQx48CRe5A6PcEXbWyQo/8AusmOYo9ZpAmIECE3WDqbz+GbbDlmaW/1cNGDn7nJP0to2f5oId4M=
X-Received: by 2002:a05:6102:26d3:b0:4fc:156e:1046 with SMTP id
 ada2fe7eead31-4fdc4212c13mr5641344137.20.1754389279324; Tue, 05 Aug 2025
 03:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250731104726.103071-1-lokeshgidra@google.com>
 <CAGsJ_4yJ5mtk_mp3r=PsMZOnHdtEk2Q_UTDjwy=4cmV8mcz+mg@mail.gmail.com> <CA+EESO4d_iriWeLit6RbODxxMPLnns64cuo+gkQhbYebZdHDdA@mail.gmail.com>
In-Reply-To: <CA+EESO4d_iriWeLit6RbODxxMPLnns64cuo+gkQhbYebZdHDdA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 5 Aug 2025 18:21:07 +0800
X-Gm-Features: Ac12FXyQkOqRzRVUcG4YdSynxxkbngwEJT937lRNpCEpIlwwe--WfZbW0U12FOI
Message-ID: <CAGsJ_4y7WmQaFCZsxqfLD8c6qG0NuN2Hyqxq6mgHTpCMcRuyNw@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: opportunistic TLB-flush batching for present
 pages in MOVE
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 669C9140006
X-Stat-Signature: wbkecyzc8oo6469u3ux5bccuuftpr4f9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754389280-340987
X-HE-Meta: U2FsdGVkX1//ORssKuhhOa2+6rNnt3JZxkxNqya0AVfaZyvdXv5TxH0uK6HU7CQFe0CNxZoWBedZQp/oKhduVZ1PRGroLRpoZxdKH1pxfOk7sAf6+QY0zIBleGPoDlLQK3BA8Ago0J25loTGdQ2PRNspZb6Fv8SmdQscwBXLrjR2J000rMEYVaLFEULlN+P0/4Ov+3YwCsGpWAiRNDKtheFu/kbtetwcbSd7Q4NrWBtO90S7JxFG83g+zIdMbRrJGvv+GY+WLT6LW/ahQw8pnGcOW8tvFZYy3xApcGngPT0Ze/rETJ57p/4bkIiBIEHdN1E1TjzrpUXuGesKc4Wumlu+sSbcpw/fNkmtNxQQ5LY4LLcRP/0bOfkYP6vdXLct90vhZFko1xSRprlxVcneKNYZBH/oi9wWIiBdpm/sDA7JDHLAU9m27bvLfLKhMsfO5Xx4w063uIJoshRSG3u1wmblaNU2osrgaT5k9UphK/VHCmLwqsVFsEETJxsje2enhNg8fCBvcTLAjRga5VLNRf1B7t6mS3MqIQ61tbIyBaHwXAJ30ImGxRuW7FF75IFocbSP8CC+FjfZweycV/4RkPbVXlth9qbMeNyAsmXP+rOUCKJbqzELipRApp00W+L6iL0II6T2wsOBVfsK7VifPUWBfJZDpSkndYXN8f28N3Nxo7koumYfweSizMWUJPz88bxrcddUHmbG72xHdNMiB9PNN6av3ZxXFn9oTXadlX6G7YfqifuoMjm9McEu6mAOjdX6MqZ0guLN0LKgyejIaMaQvI9xSWQLbgm86qOGP+uH0U489nz9fcEtV9lhRTG1oQwwTzxtNPwlGCRC3zK9w02kq4FKljBp4CXvj4ochfbfjnJs/0TYeMkd9CF0aXwUNoEvSy892NLQ6JyMoUkfqXIK+cQxPcg2csV2rSvdi8D3LkvVjsrtLrKBVV7WRph9btgd/92mv9DVZnQdhCa
 ZQ3mi8va
 1li4g+rN0vN7EftZgEsHYTU0AnLPOpQDqLPjVxGt+2MW0MQAshi/dkVzpltz+vCiM1IFi0uBAHurGaor9UjEhx3x9w7NZmaUty2MinPifqDclhuU1fVWxhOrfPd2/jWOP+NvtpyY/m6pPH3Fv4tIni0H2aH9cjPLidraz95gp3Q8e33g2hlHt2idFVIw308ldCWI/oo5T/OrZWTckc2aGsD3UrC64neVP5rZzqrKaUUP52jB1NE352q1gguo7AScX4q+YXkHrDxXsGO5Xp5pqg3FVgSjw9CdO1yd9TnXWYBbLSvfz5/H1qklZbFaiCYj676Vpx2tuJ5avSXt9R1ivcHdNNzwqYTBB0Ct4yWEwcL5kyk/+NJKBVtmmrVxyUHy8UY5F/QWM0i7gj5vFkvcz8keojxq2j+0I+UD/Wn5TIInpQYU/OhGoW9PTbbweLF+wfXN2Z+mxdgW5kYI650yu15cd64bFc0qOR1FcuJQSuUb3Shr4S/9JcuqypMGiaEy+EIIl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 2:30=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.com=
> wrote:
>
> On Mon, Aug 4, 2025 at 9:35=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Thu, Jul 31, 2025 at 6:47=E2=80=AFPM Lokesh Gidra <lokeshgidra@googl=
e.com> wrote:
> > >
> > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is require=
d
> > > for moving present pages. Mitigate this cost by opportunistically
> > > batching present contiguous pages for TLB flushing.
> > >
> > > Without batching, in our testing on an arm64 Android device with UFFD=
 GC,
> > > which uses MOVE ioctl for compaction, we observed that out of the tot=
al
> > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), an=
d
> > > ~20% in vm_normal_folio().
> > >
> > > With batching, the proportion of vm_normal_folio() increases to over
> > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > includes TLB-flush overhead.
> > >
> > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Kalesh Singh <kaleshsingh@google.com>
> > > Cc: Barry Song <v-songbaohua@oppo.com>
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > ---
> > >  mm/userfaultfd.c | 179 +++++++++++++++++++++++++++++++++------------=
--
> > >  1 file changed, 127 insertions(+), 52 deletions(-)
> > >
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index 8253978ee0fb..2465fb234671 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -1026,18 +1026,62 @@ static inline bool is_pte_pages_stable(pte_t =
*dst_pte, pte_t *src_pte,
> > >                pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> > >  }
> > >
> > > -static int move_present_pte(struct mm_struct *mm,
> > > -                           struct vm_area_struct *dst_vma,
> > > -                           struct vm_area_struct *src_vma,
> > > -                           unsigned long dst_addr, unsigned long src=
_addr,
> > > -                           pte_t *dst_pte, pte_t *src_pte,
> > > -                           pte_t orig_dst_pte, pte_t orig_src_pte,
> > > -                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > -                           spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > > -                           struct folio *src_folio)
> > > +/*
> > > + * Checks if the two ptes and the corresponding folio are eligible f=
or batched
> > > + * move. If so, then returns pointer to the folio, after locking it.=
 Otherwise,
> > > + * returns NULL.
> > > + */
> > > +static struct folio *check_ptes_for_batched_move(struct vm_area_stru=
ct *src_vma,
> > > +                                                unsigned long src_ad=
dr,
> > > +                                                pte_t *src_pte, pte_=
t *dst_pte)
> > > +{
> > > +       pte_t orig_dst_pte, orig_src_pte;
> > > +       struct folio *folio;
> > > +
> > > +       orig_dst_pte =3D ptep_get(dst_pte);
> > > +       if (!pte_none(orig_dst_pte))
> > > +               return NULL;
> > > +
> > > +       orig_src_pte =3D ptep_get(src_pte);
> > > +       if (pte_none(orig_src_pte))
> > > +               return NULL;
> > > +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_sr=
c_pte)))
> > > +               return NULL;
> > > +
> > > +       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> > > +       if (!folio || !folio_trylock(folio))
> > > +               return NULL;
> > > +       if (!PageAnonExclusive(&folio->page) || folio_test_large(foli=
o)) {
> > > +               folio_unlock(folio);
> > > +               return NULL;
> > > +       }
> > > +       return folio;
> > > +}
> > > +
> > > +static long move_present_ptes(struct mm_struct *mm,
> > > +                             struct vm_area_struct *dst_vma,
> > > +                             struct vm_area_struct *src_vma,
> > > +                             unsigned long dst_addr, unsigned long s=
rc_addr,
> > > +                             pte_t *dst_pte, pte_t *src_pte,
> > > +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> > > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > +                             spinlock_t *dst_ptl, spinlock_t *src_pt=
l,
> > > +                             struct folio *src_folio, unsigned long =
len)
> > >  {
> > >         int err =3D 0;
> > > +       unsigned long src_start =3D src_addr;
> > > +       unsigned long addr_end;
> > > +
> > > +       if (len > PAGE_SIZE) {
> > > +               addr_end =3D (dst_addr + PMD_SIZE) & PMD_MASK;
> > > +               if (dst_addr + len > addr_end)
> > > +                       len =3D addr_end - dst_addr;
> > >
> > > +               addr_end =3D (src_addr + PMD_SIZE) & PMD_MASK;
> > > +               if (src_addr + len > addr_end)
> > > +                       len =3D addr_end - src_addr;
> > > +       }
> > > +       flush_cache_range(src_vma, src_addr, src_addr + len);
> > >         double_pt_lock(dst_ptl, src_ptl);
> > >
> > >         if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig=
_src_pte,
> > > @@ -1051,31 +1095,60 @@ static int move_present_pte(struct mm_struct =
*mm,
> > >                 err =3D -EBUSY;
> > >                 goto out;
> > >         }
> > > +       /* Avoid batching overhead for single page case */
> > > +       if (len > PAGE_SIZE) {
> > > +               flush_tlb_batched_pending(mm);
> >
> > What=E2=80=99s confusing to me is that they track the unmapping of mult=
iple
> > consecutive PTEs and defer TLB invalidation until later.
> > In contrast, you=E2=80=99re not tracking anything and instead call
> > flush_tlb_range() directly, which triggers the flush immediately.
> >
> > It seems you might be combining two different batching approaches.
>
> These changes I made are in line with how mremap() does batching. See
> move_ptes() in mm/mremap.c
>
> From the comment in flush_tlb_batched_pending() [1] it seems necessary
> in this case too. Please correct me if I'm wrong. I'll be happy to
> remove it if it's not required.
>
> [1] https://elixir.bootlin.com/linux/v6.16/source/mm/rmap.c#L728

Whether we need flush_tlb_batched_pending() has nothing to do with your
patch. It's entirely about synchronizing with other pending TLBIs, such as
those from try_to_unmap_one() and try_to_migrate_one().

In short, if it's needed, it's needed regardless of whether your patch is
applied or whether you're dealing with len > PAGE_SIZE.

>
> > From what I can tell, you're essentially using flush_range
> > as a replacement for flushing each entry individually.
>
> That's correct. The idea is to reduce the number of IPIs required for
> flushing the TLB entries. Since it is quite common that the ioctl is
> invoked with several pages in one go, this greatly benefits.
>
> >
> > > +               arch_enter_lazy_mmu_mode();
> > > +               orig_src_pte =3D ptep_get_and_clear(mm, src_addr, src=
_pte);
> > > +       } else
> > > +               orig_src_pte =3D ptep_clear_flush(src_vma, src_addr, =
src_pte);
> > > +
> > > +       addr_end =3D src_start + len;
> > > +       do {
> > > +               /* Folio got pinned from under us. Put it back and fa=
il the move. */
> > > +               if (folio_maybe_dma_pinned(src_folio)) {
> > > +                       set_pte_at(mm, src_addr, src_pte, orig_src_pt=
e);
> > > +                       err =3D -EBUSY;
> > > +                       break;
> > > +               }
> > >
> > > -       orig_src_pte =3D ptep_clear_flush(src_vma, src_addr, src_pte)=
;
> > > -       /* Folio got pinned from under us. Put it back and fail the m=
ove. */
> > > -       if (folio_maybe_dma_pinned(src_folio)) {
> > > -               set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> > > -               err =3D -EBUSY;
> > > -               goto out;
> > > -       }
> > > -
> > > -       folio_move_anon_rmap(src_folio, dst_vma);
> > > -       src_folio->index =3D linear_page_index(dst_vma, dst_addr);
> > > +               folio_move_anon_rmap(src_folio, dst_vma);
> > > +               src_folio->index =3D linear_page_index(dst_vma, dst_a=
ddr);
> > >
> > > -       orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page_pro=
t);
> > > -       /* Set soft dirty bit so userspace can notice the pte was mov=
ed */
> > > +               orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_=
page_prot);
> > > +               /* Set soft dirty bit so userspace can notice the pte=
 was moved */
> > >  #ifdef CONFIG_MEM_SOFT_DIRTY
> > > -       orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> > > +               orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> > >  #endif
> > > -       if (pte_dirty(orig_src_pte))
> > > -               orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > > -       orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> > > +               if (pte_dirty(orig_src_pte))
> > > +                       orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > > +               orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> > > +               set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> > > +
> > > +               src_addr +=3D PAGE_SIZE;
> > > +               if (src_addr =3D=3D addr_end)
> > > +                       break;
> > > +               src_pte++;
> > > +               dst_pte++;
> > >
> > > -       set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> > > +               folio_unlock(src_folio);
> > > +               src_folio =3D check_ptes_for_batched_move(src_vma, sr=
c_addr, src_pte, dst_pte);
> > > +               if (!src_folio)
> > > +                       break;
> > > +               orig_src_pte =3D ptep_get_and_clear(mm, src_addr, src=
_pte);
> > > +               dst_addr +=3D PAGE_SIZE;
> > > +       } while (true);
> > > +
> > > +       if (len > PAGE_SIZE) {
> > > +               arch_leave_lazy_mmu_mode();
> > > +               if (src_addr > src_start)
> > > +                       flush_tlb_range(src_vma, src_start, src_addr)=
;
> > > +       }
> >
> > Can't we just remove the `if (len > PAGE_SIZE)` check and unify the
> > handling for both single-page and multi-page cases?
>
> We certainly can. Initially it seemed to me that lazy/batched
> invalidation has its own overhead and I wanted to avoid that in the
> single-page case because the ioctl does get called for single pages
> quite a bit. That too in time sensitive code paths. However, on a
> deeper relook now, I noticed it's not really that different.
>
> I'll unify in the next patch. Thanks for the suggestion.

Yes, that would be nice =E2=80=94 especially since flush_tlb_batched_pendin=
g()
is not needed in this patch.

Whether it's needed for uffd_move is a separate matter and should be
addressed in a separate patch, if necessary =E2=80=94 for example, if there=
's a
similar race as described in Commit 3ea277194daa
("mm, mprotect: flush TLB if potentially racing with a parallel reclaim
leaving stale TLB entries").



            CPU0                            CPU1

            ----                            ----

                                            user accesses memory using RW P=
TE

                                            [PTE now cached in TLB]

            try_to_unmap_one()

            =3D=3D> ptep_get_and_clear()

            =3D=3D> set_tlb_ubc_flush_pending()

                                            mprotect(addr, PROT_READ)

                                            =3D=3D> change_pte_range()

                                            =3D=3D> [ PTE non-present - no =
flush ]



                                            user writes using cached RW PTE

            ...

            try_to_unmap_flush()

Thanks
Barry

