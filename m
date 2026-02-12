Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D1DEEA84B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 19:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F536B0088; Thu, 12 Feb 2026 14:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED106B0089; Thu, 12 Feb 2026 14:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1676B008A; Thu, 12 Feb 2026 14:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96B286B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:34:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5EE9F13A42E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:34:04 +0000 (UTC)
X-FDA: 84436805208.12.7309CFF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id CEA8E160013
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:34:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RUTUms1H;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770924842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G43Shz89BIl9KPf/JITngHZa5sAhqrl5n9SusWwgid8=;
	b=x+H7QJuWgr3iZPkmuwBz8MYf8GQPtMH91DpYoXBCZ72xMXFhR6nC6IMqXTLX6blEyFM3Dl
	Jx6RdYxMkv/dR7CbTWPZcW1HIlMWyG6L9U+t4/MaJFLF75ymB9jnOUpvcAiiBY90ljNk8I
	Mn26ft4qki2V8CBh6arwgDZYHWR/F7A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RUTUms1H;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770924842; a=rsa-sha256;
	cv=none;
	b=Wm0vTAE4hiS5Ix2pEp6Vl5n3zY1wIYon2Rq/EzQCp13uQe4/r70KXh1sROBQL9ltPt0nZR
	xgnlG/Zo8xdUZaPOyFygj0U9k4/5mwNGskaDZiErFliNSx+XaxJArWUxCuiY6wU1oW7Ivl
	isoMxCUxH/yNEWK9yuDrh9/n0RTTu34=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770924841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G43Shz89BIl9KPf/JITngHZa5sAhqrl5n9SusWwgid8=;
	b=RUTUms1HMNAQ93l7yyS3BAoT60lOjfMjstsn0pZS9NjQOrZFPfPGze9Ga8HjSLuSH/mK/t
	BGchZojIHO3Dw7FYLniMw/mbtHFWWJFFvhOe6myIpgXbfTPMkPEkULSjP0zUBlxiCbT/rS
	fwaM/LJ4S1Rc4u3dXCaoJPPIa0VL6ng=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-a2aQIfzgMB-I7BKRZY1i2w-1; Thu, 12 Feb 2026 14:34:00 -0500
X-MC-Unique: a2aQIfzgMB-I7BKRZY1i2w-1
X-Mimecast-MFC-AGG-ID: a2aQIfzgMB-I7BKRZY1i2w_1770924839
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7943aea6515so5022417b3.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:34:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770924839; x=1771529639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G43Shz89BIl9KPf/JITngHZa5sAhqrl5n9SusWwgid8=;
        b=qlqeVKktUyGq7C1FE1jgtpqMDbwCov8BmvlMynRkL1Htz42Rs/zsBjsxiJKvkc6fxN
         QexwlFM+bxoPLjY8+56KeAXqVeZ4Gc2ix/IU/wFuJOXxEqtiQEpvKJ9fOeaq2TJdbtbc
         yWoFfger76DtrCkFFS3Jnno+b5tikap+RIcfZwvNzp0CGs3TV+OSrFm8GxprplWr8cvy
         DlUkUYmougheLadoMqyLyOpgI8dQlb4nlpLi2XTkAOd0OJxO8eOC0s8Ij2Zit0zmSlr8
         zuVDErzlXivzvL1I84MBJC4pOg3nkJGm6Q6LYLymKIqsJmFUBijMiHFAnGwNT73uD029
         NEJg==
X-Forwarded-Encrypted: i=1; AJvYcCXAuJ5FfC1dG7ubhWJ+uvy09wPRXrK/2lHsvW4lVSspGSBcL3ItDYVJmepiS5KKTRyA9FhaVeLk6g==@kvack.org
X-Gm-Message-State: AOJu0YxF1kgJkd2YmbB5Q3kmFSPRd+TZgDV00VO5jD4Z4NxzoMO76CRA
	QoYMp+3G6GwxjuxP/+4b0I+NJtwqRDKrlBI0/sD+aDeBW4Qu1cBhGR9TJkOUDzjO2UPgk++eKsr
	5XTi7kS0xxNiyOBmskzNAbDarzrp6wBNKnDboetXcyRkE/eZcvuXsdVmkTMx7vkMxNQnfP62XoT
	GiHbFg34AVsX+HTyaaTV1ZmN4v+9I=
X-Gm-Gg: AZuq6aIH1v6huJxXEfqh2xhSxk9ewvhH4icjfTHfbgMAmB/PdJhHdWzLT3Yo1yP37j9
	mfhr89w9lm8LnIG2mCrk3oPfSHIWnUdV3NsbkVmo4QkmctqLKHLbSGhdTkZJsFNGzHhoeaKwoTR
	CbvrXnunC213y+4cWVmJc370mgOSY1L4+fzVkDpfHKMgAq4qiT4YutGQOh8O1GsmEbunW8iJcGH
	p0BRsF+kE9QeHfiUo+t
X-Received: by 2002:a05:690c:e361:b0:794:feb3:b0d7 with SMTP id 00721157ae682-7972f113f01mr34679197b3.22.1770924839351;
        Thu, 12 Feb 2026 11:33:59 -0800 (PST)
X-Received: by 2002:a05:690c:e361:b0:794:feb3:b0d7 with SMTP id
 00721157ae682-7972f113f01mr34678787b3.22.1770924838716; Thu, 12 Feb 2026
 11:33:58 -0800 (PST)
MIME-Version: 1.0
References: <20260212021835.17755-2-npache@redhat.com> <20260212155539.2083102-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260212155539.2083102-1-joshua.hahnjy@gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 12 Feb 2026 12:33:32 -0700
X-Gm-Features: AZwV_Qi9xi4InA6L7Vb1GGvAygH5Cv0NThzqf-7CA0kwM_HN0d7Pz2aUHEW1fh4
Message-ID: <CAA1CXcC7SPkehNLT8FUnnUf6m0vm3GbhZuDZyMMW4X0DHDs6Mg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: URlAC_egoSoiOV2gsBk7vReDYsvVdqtB4o08--AU4AI_1770924839
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CEA8E160013
X-Stat-Signature: 9ea7qmegcztnmkxwijiksy3yd6u18xm7
X-Rspam-User: 
X-HE-Tag: 1770924841-554020
X-HE-Meta: U2FsdGVkX1/cDGIhcleL54TPclB+42Z2CDAoGWa2C4V4JtIqaWmmYwVxyPmSl4N4ZxX/EiZn04rvX240d8Q/rrBEUVP0cyRfECJECI82WbMb6ITCOQGpBHSpt6wIEQzAcUBt8pT0w68CLou9+S5zdJCTIS8ifp2+XNCuuTFxbPy80kxeEjQ7Lr7AkwCw7gxmrnrhE2CqbaufZricLJBhYNKEj8LUV9y5tmu+YrXWOMYHK4F969InKT9wtRkT72vQZtE3jNiY02dfAOVhwMhwW++5uP65k7GG0UzN6VyNkInBBU+Q03TSYLDblPPicgzOQhT8GdbktJqkAyGW4eUrPUs9OUnna1DpU3yD9ehoIIQ2ap0oYqpz9mH+Znf0GCi2KoqLtjKnaCm1f4BtbnpZDYB334WVvqaSswGhtIhrN3b6fUYgp5z/edjd5rhKUxmAOnSxWiDZ7oU1GWBqLhKC0thTizyI8BiL9BQYjAuZhah7wWAe0zR4QfrTtmaprhQ/RteuDUoilr3cKMwUQcZIIMl7tzerZHhX89EKrZqbc3gATrpIwMOK/gR7yAUd1DPUwnGQtlNpXIKwHcXH0YucpVLzXbLEbEvQHlhXJ7DdkPpouVzzMmIC+OuZxowHceOmIh8NWP8aS0Nhh41KsaTaaBBWAzLtiPh30oS9getQhFBXU53WAyCfXYmsVI66e/I86CRw8W4XkFkklHhUXo0rTgafH+X3afOzNgnRLrWEG8I8S6bPsmdfXtm7tUBt/Xd36CVNiSsQ5Nra4ozJHZcDOPc5ayVy8Qxdeyk+V6pvVCQJ6xixNAWsEjOd0CkDwHjeEaHQEa1883YWL9hzmdABKwUTUpOfKA9au7HfTshuucNmRvGsK9RP+IInQi9Yd0zfq5zKLzbsvTaGY+552brb9rXIVIKHBZimL59Aj8WEoo1gnHmCWWQXDt6LjdawPAnTVeL1dEUpB58M0I/FXXw
 yJI9QaXV
 Mbfvw7P9EUwqCFF5Go6D+5sDBdRDaTkZSDvLtfkaGFptCzbYLSeeYJOf7UVkqgslWzKqSfqtq0JfjOTTJzeOqXwCd4CWKMAzr+PvE++82kLXhsnIWFN0SLel2qfsqGsEXf76wxIaPE1y1B9ypo5VLtmOoqgd4wcyt1MJpJrQ2Ch/UYfxClVW4rNN7B2b8vLMLS9oPc6ATWowpLZyWbqnOReGyWleE0NPZB3BkcHDeaySJOR1SuPRhpPoJBxf0TgTsfqs7if6d1EXnpmFh2SaPP5HQ6w3WehQo0czlMOGrybMKPr9FhZ7lkAxmA2QBemp7sQ8PGc2EHXtv9U1d/e2Mu6SqBdQ8MR4FFv4ILVTY24+Tcgib5lqTr/WOnSCBXYafRiyts3g9gB/1vrEu7Flgnz5kMdDYzuIoRMgQXoV+Vb/3Kzw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 8:55=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.co=
m> wrote:
>
> On Wed, 11 Feb 2026 19:18:31 -0700 Nico Pache <npache@redhat.com> wrote:
>
> Hello Nico,
>
> Thank you for the patch! I hope you are having a good day.

Hey Joshua!

Thank you for reviewing! I hope you have a good day too :)

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
>
> It seems that based on this description, there should be no functional ch=
ange
> in the code below. Is that correct?

Correct, but as you and others have pointed out I believe I missed a
pte_sw_mkyoung.

On closer inspection I also may have inadvertently changed some
behavior around pte_mkdirty().

In the previous implementation we only called pte_mkdirty if its
VM_WRITE. When switching over to maybe_mkwrite pte_mkdirty is no
longer called conditionally, while pte_mkwrite still is.

Nothing showed up in my testing, but some of these things can be
tricky to trigger. Other callers also make this "mistake" (if it even
is one), but I'm aiming for no functional change so I appreciate the
thoroughness here! I will clean up both of these issues.

>
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
>
> ^^^ extra newline?

oops yes! thanks

>
> > +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> > +             struct vm_area_struct *vma, unsigned long addr,
> > +             bool uffd_wp)
> > +{
> > +     pte_t entry =3D folio_mk_pte(folio, vma->vm_page_prot);
> > +     unsigned int nr_pages =3D folio_nr_pages(folio);
>
> Just reading through the code below on what was deleted and what was adde=
d,
> Maybe we are missing a pte_sw_mkyoung(entry) here? Seems like this would
> matter for MIPS systmes, but I couldn't find this change in the changelog=
.

I think you are correct. In my khugepaged implementation this was not
present. I will add it back and run some tests! Thank you.

>
> > +     entry =3D maybe_mkwrite(pte_mkdirty(entry), vma);
> > +     if (uffd_wp)
> > +             entry =3D pte_mkuffd_wp(entry);
>
> The ordering here was also changed, but it wasn't immediately obvious to =
me
> why it was changed.

I dont see any data dependencies between the folio rmap/folio/ref
changes and the pte changes. The order was most likely due to the
setpte labeling which this also cleans up. I believe we can reorder
this, but if you see an issue with it please lmk!

>
> > +
> > +     folio_ref_add(folio, nr_pages - 1);
> > +     folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> > +     folio_add_lru_vma(folio, vma);
> > +     set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> > +     update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
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
>
> ^^^ extra newline?

whoops yes thank you!

>
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
> > +
> > +             /* No need to invalidate - it was non-present before */
> > +             update_mmu_cache_range(vmf, vma, addr, vmf->pte, /*nr_pag=
es=3D*/ 1);
>
> NIT: Should we try to keep the line under 80 columns? ; -)

Ah yes, I still dont fully understand this rule as it's broken in a
lot of places. Ill move nr_pages to a new line.

>
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
> > -     if (vma->vm_flags & VM_WRITE)
> > -             entry =3D pte_mkwrite(pte_mkdirty(entry), vma);
> > -
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
> > -     add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> > -     count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
> > -     folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> > -     folio_add_lru_vma(folio, vma);
> > -setpte:
> > -     if (vmf_orig_pte_uffd_wp(vmf))
> > -             entry =3D pte_mkuffd_wp(entry);
> > -     set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
> > -
> > -     /* No need to invalidate - it was non-present before */
> > -     update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
> > +     map_anon_folio_pte_pf(folio, vmf->pte, vma, addr, nr_pages, vmf_o=
rig_pte_uffd_wp(vmf));
>
> NIT: Maybe here as well?

ack

>
> >  unlock:
> >       if (vmf->pte)
> >               pte_unmap_unlock(vmf->pte, vmf->ptl);
> > --
> > 2.53.0
>
> Thank you for the patch again. I hope you have a great day!
> Joshua

Thank you! you as well
-- Nico

>


