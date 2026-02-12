Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 937A1EEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 19:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1016B0088; Thu, 12 Feb 2026 14:45:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86EDB6B0089; Thu, 12 Feb 2026 14:45:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7502C6B008A; Thu, 12 Feb 2026 14:45:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 633426B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:45:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F28971402AE
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:45:41 +0000 (UTC)
X-FDA: 84436834482.25.6A8F128
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 69CD220003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:45:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cge36uTu;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770925539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQNTZFk8qzqU61yEpnnfUW55vq5xrM0eDfE1aSGr2zA=;
	b=Mgk0LeicbeBwCx0zapQaR5+jro/jSLXhLM2YFqbqIlufMiAd1GHoVy1hOMz9rrPkTKacYp
	BAmqdTqLJIKbdlwn2iKPHQw64h0CGbky7izz1UYdBZd+7suvFJi3AFSWydwvUR9+rclLyg
	Ew6Lh5Ty8PbhtPp7XBsWUYENZ4cEtEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770925539; a=rsa-sha256;
	cv=none;
	b=NpmekzasZCD/FnOkbd2TP37yXrQWXfQd55GCzKvQRMM4ql5lt6OgDO0B2wdJfLJzYSngUB
	8rrx9bWIVwRV+H3K0KRT5R4cI1xZArRajOHgX7Pb69xwWdbHw/QvD/AitmU2rcUe0XZ9zl
	7rqPNWBhLrXvscDbPHwGSQBIuaNP4Bs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cge36uTu;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770925538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zQNTZFk8qzqU61yEpnnfUW55vq5xrM0eDfE1aSGr2zA=;
	b=cge36uTuQDtpdkSdgqLRAhQEv4fDGXoKPuuZHP/ph63gfdu7L/1pJiTOHNlw660JyONvIr
	SnQxVuA300I2Tzx/yHmeSMLbFbjo85vfTiSij4GmlW0grrlmFdJN1yP63I+kxro08PGIOM
	leEUL91Xwx9xdvQVkHthIusB0X672eQ=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-d-5oYTN3NiuNYK6UWXEHfA-1; Thu, 12 Feb 2026 14:45:37 -0500
X-MC-Unique: d-5oYTN3NiuNYK6UWXEHfA-1
X-Mimecast-MFC-AGG-ID: d-5oYTN3NiuNYK6UWXEHfA_1770925537
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7962a21167dso4198547b3.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:45:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770925537; x=1771530337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zQNTZFk8qzqU61yEpnnfUW55vq5xrM0eDfE1aSGr2zA=;
        b=RikQmZN/7QK2nKSBLM4woFVTdlUh4eEU8EVBoc7u+Zj2gK8V+zF2pECJ2j/A7eqWV5
         r8iLt46I3cKeDaZoYaryvB12JGp4KGfgo0NGQs9/iRDz+B349BwtqzUYl/kdmMzNxwsF
         RLh1K2CK4154FNP7+CIIsA8iNH/Zy0Hqi3SZC+wWv9SA+P3JpzyJOjx6YX+MaEE2/Elq
         /3wmOGECNecdevs+18r02rGgrVrayg7fWHaqJJbbIxRQiPbUkq5i6F1+p5L5SIKLq1NT
         hWzGyJpPf+s3cVx+inmxaj7+3g8mYPKC1kvURZWcbRumJJpFKdhIK3o0NiKXYGsgrlNK
         3SXw==
X-Forwarded-Encrypted: i=1; AJvYcCXqXv+sEsqZwyClJCOXZdLuIon+jPiqIeZM9lNgt8Q/aTdcRnPxtUESheDQJnO6Lca9nVWtyXL/3A==@kvack.org
X-Gm-Message-State: AOJu0YzIEyWIEVNTp8pOeZiqw6fBZGDsTfVB/sooxMCfgyqe66HYep+m
	xw8i1t6MBpuC9wL81ahJKHEM3HtScJFsGNsZwudffDvctYRzTSBA3DEClQ6RflWpJZFbQJV+yxf
	W/FdyGM3tOH019q3Hs4rv/KWc4/gJci/liqmLMNF/6BKvPLU56+E83DxbkgraI3P8bOMW8rhAeP
	a5ym5ImFps5qS+ZHAFCG/igB18gyI=
X-Gm-Gg: AZuq6aJc0fNcY9b6EUWLCWlFQj+atvKDvby0m6idszcD5zzy09T+gz3EtRBqINxkcag
	MBDzSdybIcpHOD28ZE15nV6FygUqEHecVrBO6C1FqgbbR46LfSn/QYeyf4kci9XcsvIO7LWwa3E
	IwiT3IpRwewpygnYcxym8Jw+ohZ0JNXZdcURoog35wLdJVdeFsU3ljGAhOU4VGRR9GqI2mJbMxT
	UAJWvnYM33i35jVG7gX
X-Received: by 2002:a05:690c:e3cb:b0:796:4f04:bbc1 with SMTP id 00721157ae682-7973767279cmr39975197b3.36.1770925537004;
        Thu, 12 Feb 2026 11:45:37 -0800 (PST)
X-Received: by 2002:a05:690c:e3cb:b0:796:4f04:bbc1 with SMTP id
 00721157ae682-7973767279cmr39974487b3.36.1770925536452; Thu, 12 Feb 2026
 11:45:36 -0800 (PST)
MIME-Version: 1.0
References: <20260212021835.17755-1-npache@redhat.com> <20260212021835.17755-2-npache@redhat.com>
 <048C7077-3E54-4DFE-A25D-05D3CCB132D6@nvidia.com>
In-Reply-To: <048C7077-3E54-4DFE-A25D-05D3CCB132D6@nvidia.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 12 Feb 2026 12:45:10 -0700
X-Gm-Features: AZwV_Qg_TNyStzXHisdTSNQcGqrw5FQjE4iTj6kIBfa1iRKFUrV7kYsvzJLI1uo
Message-ID: <CAA1CXcDNX6g8c09q=oaW6RdPYrpEfZP-Hk2rXo-2XqREm68Twg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HyiPYTTQPRo_q0ZAI-r9j1YOZHXrMbGQ_WI7tm6VTlw_1770925537
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 69CD220003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3rqbnabuguab7qr1yfi91byhsmtk55d7
X-HE-Tag: 1770925539-123215
X-HE-Meta: U2FsdGVkX19/9ueHj6YWWNpcj4OnOT4+v6mc/zEcPVAoCM3wXH+uoRE7/WYb7b+06O4n9fwt1AfllkD+BKv8nst6uiKdzg0CLcZjpVn5JvQl0X5wFMUg0oZmlibVESRZhkn2146SIwC5PwNZertO9f5Z0HVWmcdc0LbiO+z9aCzoGeWt9VZoGXdp9eOzfN1gpEd4WJD7v8iptw0fwkuuZF//sNUQWyP6p6GhwaVnERru+4XmQWylELfeac10FDKKsd7VsyC0XKqY0aCAgltUWPk062ldkmxfsfxws+3TFTFFauT50VJzIiM17u9VjSkX1/XUYsWk8cvviVYEzkzqspzL4dG8J+nbHVxgQkY7kF6vJXRGb5608CYBxmXMNQRxjWpHvXXb9eQUf9ZaeUW8r8/3uEJOfLA80lTATSHHwRgmWy0Mvszy1x5yiWZ/XgW+7/pyIIWbsBC1ZR1B5bw6ofJWzIqgdCuQg/6TgkaciEDiWeLO9e6oKfwGZf/FMvZQW+EuCCQQikk+S2cg2y2VKmVdocy7U4+x4Nw8tGEYPoAr4cJCJFQ9vWtnSM0ayDVHVaEvQ218/k0s2+FrMSM5XcD6IiPdgUFy3k+d9RWRgoi748aBVGCogi+0qN1xSvxPgptWt1IUbmIlkAALY4GdjjinuQHtsiKi4fs1QUjGvi+meGTeQLp5n5FU1HJFMQ73QAG40BIhwbuzDdS3JS4zkuhwrKRHrTXIIjPQU4EVtBBsTQV1s8lPeCauvMPq9hIjZ4bZYbhVolx3ubOZvAo9lK0gAI9Ntww8MZ58pibObkH4Ito/kixZPiWYYGNCemUjp1MD+i61PStGDMPSwlxOVYiL30OhZZY5SkrHwIPaodyy2Dbdb4bVsJcxwg4TMwutbviC/zcREpZQqjSc2f46oAJStkEv8xWreUr0ACYMwLoigESs53XFzuUT3/64DGoABjo+Hxrc4Ctd0tu19PK
 LnzD65J+
 YN5k9+XmP9xQIP1jGYMwwtYcad4HuNv9PXi5fEUW/U0yQtYUnmknU+SvzfXT5NInxEEVJDntm2E2mZs1nHBeFXNdRCevaZcO8JaQQeaHUPTprSskaP2y+YsfbiaoVPJi/mVX93y39TD6BEOQ3b47OeGcbqFEyV4mCPlnDQa4pCIHAXuKxnLi89YTwQTfzeKDfg9T5uNKWFUUa+RO81tIy59ADjDk0FNQvnzLbEYI5R13dVColYXFTqy0mKwrdJAH1Z2iku1VsvVP2mM4tjkIlu7mIRR+MNAzl9T4k+RQPm8pemphLo7g20gdFLW7C9+NZEdcuFvgPsqhOkFznQaiTeRmKJypnbRYJebldCj11pwEBKbolB8fOnqo1+RhMFrm/NcvM8jjb5B8PAEO+yg6mldFo65VlRrmpUS/rfH6ADDh8EB4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 9:09=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 11 Feb 2026, at 21:18, Nico Pache wrote:
>
> > The anonymous page fault handler in do_anonymous_page() open-codes the
> > sequence to map a newly allocated anonymous folio at the PTE level:
> >       - construct the PTE entry
> >       - add rmap
> >       - add to LRU
> >       - set the PTEs
> >       - update the MMU cache.
> >
> > Introduce a two helpers to consolidate this duplicated logic, mirroring=
 the
> > existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:
> >
> >       map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
> >       references, adds anon rmap and LRU. This function also handles th=
e
> >       uffd_wp that can occur in the pf variant.
> >
> >       map_anon_folio_pte_pf(): extends the nopf variant to handle MM_AN=
ONPAGES
> >       counter updates, and mTHP fault allocation statistics for the pag=
e fault
> >       path.
> >
> > The zero-page read path in do_anonymous_page() is also untangled from t=
he
> > shared setpte label, since it does not allocate a folio and should not
> > share the same mapping sequence as the write path. Make nr_pages =3D 1
> > rather than relying on the variable. This makes it more clear that we
> > are operating on the zero page only.
> >
> > This refactoring will also help reduce code duplication between mm/memo=
ry.c
> > and mm/khugepaged.c, and provides a clean API for PTE-level anonymous f=
olio
> > mapping that can be reused by future callers.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  include/linux/mm.h |  4 ++++
> >  mm/memory.c        | 56 ++++++++++++++++++++++++++++++----------------
> >  2 files changed, 41 insertions(+), 19 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index f8a8fd47399c..c3aa1f51e020 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4916,4 +4916,8 @@ static inline bool snapshot_page_is_faithful(cons=
t struct page_snapshot *ps)
> >
> >  void snapshot_page(struct page_snapshot *ps, const struct page *page);
> >
> > +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> > +             struct vm_area_struct *vma, unsigned long addr,
> > +             bool uffd_wp);
> > +
> >  #endif /* _LINUX_MM_H */
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 8c19af97f0a0..61c2277c9d9f 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5211,6 +5211,35 @@ static struct folio *alloc_anon_folio(struct vm_=
fault *vmf)
> >       return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
> >  }
> >
> > +
> > +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> > +             struct vm_area_struct *vma, unsigned long addr,
> > +             bool uffd_wp)
> > +{
> > +     pte_t entry =3D folio_mk_pte(folio, vma->vm_page_prot);
> > +     unsigned int nr_pages =3D folio_nr_pages(folio);
> > +
> > +     entry =3D maybe_mkwrite(pte_mkdirty(entry), vma);
> > +     if (uffd_wp)
> > +             entry =3D pte_mkuffd_wp(entry);
> > +
> > +     folio_ref_add(folio, nr_pages - 1);
> > +     folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> > +     folio_add_lru_vma(folio, vma);
> > +     set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> > +     update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
>
> Copy the comment
> /* No need to invalidate - it was non-present before */
> above it please.

Good call thank you!

>
> > +}
> > +
> > +static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
> > +             struct vm_area_struct *vma, unsigned long addr,
> > +             unsigned int nr_pages, bool uffd_wp)
> > +{
> > +     map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
> > +     add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> > +     count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
> > +}
> > +
> > +
> >  /*
> >   * We enter with non-exclusive mmap_lock (to exclude vma changes,
> >   * but allow concurrent faults), and pte mapped but not yet locked.
> > @@ -5257,7 +5286,13 @@ static vm_fault_t do_anonymous_page(struct vm_fa=
ult *vmf)
> >                       pte_unmap_unlock(vmf->pte, vmf->ptl);
> >                       return handle_userfault(vmf, VM_UFFD_MISSING);
> >               }
> > -             goto setpte;
> > +             if (vmf_orig_pte_uffd_wp(vmf))
> > +                     entry =3D pte_mkuffd_wp(entry);
> > +             set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
>
> entry is only used in this if statement, you can move its declaration ins=
ide.

Ack!

>
> > +
> > +             /* No need to invalidate - it was non-present before */
> > +             update_mmu_cache_range(vmf, vma, addr, vmf->pte, /*nr_pag=
es=3D*/ 1);
> > +             goto unlock;
> >       }
> >
> >       /* Allocate our own private page. */
> > @@ -5281,11 +5316,6 @@ static vm_fault_t do_anonymous_page(struct vm_fa=
ult *vmf)
> >        */
> >       __folio_mark_uptodate(folio);
> >
> > -     entry =3D folio_mk_pte(folio, vma->vm_page_prot);
> > -     entry =3D pte_sw_mkyoung(entry);
>
> It is removed, can you explain why?

Thanks for catching that (as others have too), I will add it back and
run my testing again to make sure everything is still ok. As Joshua
pointed out it may only affect MIPS, hence no issues in my testing.

>
> > -     if (vma->vm_flags & VM_WRITE)
> > -             entry =3D pte_mkwrite(pte_mkdirty(entry), vma);
>
> OK, this becomes maybe_mkwrite(pte_mkdirty(entry), vma).

Yes, upon further investigation this does seem to slightly change the behav=
ior.

pte_mkdirty() is now being called unconditionally from the VM_WRITE
flag. I noticed other callers in the kernel doing this too.

Is it ok to leave the pte_mkdirty() or should I go back to using
pte_mkwrite with the conditional guarding both mkwrite and mkdirty?

>
> > -
>
> The above code is moved into map_anon_folio_pte_nopf(), thus executed
> later than before the change. folio, vma->vm_flags, and vma->vm_page_prot
> are not changed between, so there should be no functional change.
> But it is better to explain it in the commit message to make review easie=
r.

Will do! Thank you for confirming :) I am pretty sure we can make this
move without any functional change.

>
> >       vmf->pte =3D pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf=
->ptl);
> >       if (!vmf->pte)
> >               goto release;
> > @@ -5307,19 +5337,7 @@ static vm_fault_t do_anonymous_page(struct vm_fa=
ult *vmf)
> >               folio_put(folio);
> >               return handle_userfault(vmf, VM_UFFD_MISSING);
> >       }
> > -
> > -     folio_ref_add(folio, nr_pages - 1);
>
> > -     add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> > -     count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
>
> These counter updates are moved after folio_add_new_anon_rmap(),
> mirroring map_anon_folio_pmd_pf()=E2=80=99s order. Looks good to me.
>
> > -     folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> > -     folio_add_lru_vma(folio, vma);
> > -setpte:
>
> > -     if (vmf_orig_pte_uffd_wp(vmf))
> > -             entry =3D pte_mkuffd_wp(entry);
>
> This is moved above folio_ref_add() in map_anon_folio_pte_nopf(), but
> no functional change is expected.
>
> > -     set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
> > -
> > -     /* No need to invalidate - it was non-present before */
> > -     update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
> > +     map_anon_folio_pte_pf(folio, vmf->pte, vma, addr, nr_pages, vmf_o=
rig_pte_uffd_wp(vmf));
> >  unlock:
> >       if (vmf->pte)
> >               pte_unmap_unlock(vmf->pte, vmf->ptl);
> > --
> > 2.53.0
>
> 3 things:
> 1. Copy the comment for update_mmu_cache_range() in map_anon_folio_pte_no=
pf().
> 2. Make pte_t entry local in zero-page handling.
> 3. Explain why entry =3D pte_sw_mkyoung(entry) is removed.
>
> Thanks.

Thanks for the review :) Ill fix the issues stated above!

-- Nico

>
>
> Best Regards,
> Yan, Zi
>


