Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5534107BCF2
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4566B015F; Wed, 18 Mar 2026 06:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3DD46B0160; Wed, 18 Mar 2026 06:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE1A6B0161; Wed, 18 Mar 2026 06:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 93F5D6B015F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:29:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30CD48C07D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:29:01 +0000 (UTC)
X-FDA: 84558810882.11.04EA69A
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 26052180006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:28:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AWoBfgnW;
	spf=pass (imf16.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773829739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9NIKR5k+1KiAIlFBZ1fGk/oXZDI7bdXZbvHJYtXjC0=;
	b=Qtl80lkpimZgvh3T35g/zOrCKd9riyFwaR9+/T8Ybx7Rf0QUxmDr2QwP+Rf20w+nRzy3De
	pZattCsyY0m4OnFECsIJaEMaKeoTAUI/TUcgUn1fwKCnA0i4mQdOKR7K//zOvPuv/pkMQN
	Cxa6MDoOCpCNKn9gTHGYagqfV81a3ZM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AWoBfgnW;
	spf=pass (imf16.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773829739; a=rsa-sha256;
	cv=pass;
	b=FosS6xVQ4XU2hbVWwpUD/w/P/8gJlZaH0dBIRoKmqKt0kpbmiM8wiRlVn+1cQCB4Q6bqoS
	iXz0g+u0/WipvvrH9a4Ivi1GgTeIJMT80H/07qR0Q+6AzzD+WyXhlDQFHTDHB6OLXRPLmv
	JZ89vnW2ZFeMrEeNcqPDIehtnDuFMrI=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1270fc2bdf2so9273c88.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:28:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773829738; cv=none;
        d=google.com; s=arc-20240605;
        b=WNsRW3TWgZOp6sLcGfGoaUcbKgxTZYX/U2eLzBwrJy34hdOkmi1CIVBS1TA21TkSU/
         u/vs/2K44x0ikD4gHm5HcSYvSU2TmZdM+jMpqVIM17w3RPCLhNOeMds2hM5TViX81Cm8
         MnflYWfCnd8ayfAbohGcx22se1guB4lAcXqtDBdVYDic6QOJfdC03AQ62nv5hP+yAYBa
         NX7QvL4zpQePf07s/9GV0F4LM0KEnkIMJqHmaXzWizNkCeinsf03PCk1ZBDefn1JHUSd
         FXYEbWTz2SBqfyia7GzN3Y7MeHSswc1yL/CSKFVqirWVObKJa2DRtkmLCEeUm749Q+UC
         YBfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=o9NIKR5k+1KiAIlFBZ1fGk/oXZDI7bdXZbvHJYtXjC0=;
        fh=SGYgdpu4srI+r+VMm7az3Hib+6Fl1G5kOaBNWwi5pBk=;
        b=eT/NSgpfbSHcJ/+IzDrolSgL6fuUVZAPlpS99m+bUulccbLJYR0YPVXJrSR75AaWd/
         gEEhI25gqHsxWTEsY2qeNscKq6bJrR6iJpL6TMgDZSmDPgDCJzin7ly7gwFBzgjdeGep
         lB5VPNAhhuwpO9RcR/OImLD0caAsxpdXbEiwCFDeRnT/56e3noW1EySehsHJ+QqTf29W
         DfK9NB4wx5tjV3Yr2zBLJh8Juo+Y+5nV8HIRC4vpQs9n61iVV16Li6jsglW2BjjRDz6F
         DHwAgKho1RDhI12UAOvVi1gJWZjbwG+pCXX5BUOqpmMdlGDtuqJBRYOnSr8GCzqIbnTT
         tKNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773829738; x=1774434538; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o9NIKR5k+1KiAIlFBZ1fGk/oXZDI7bdXZbvHJYtXjC0=;
        b=AWoBfgnWaPBaZc4CAZ/GNRgBTIGdLLCT3uO7ZnfFEt1ku4Xqrds7RisOxmy8wVUMww
         GgYlBEYCgn+uC+6t7DOL7NaU132SMS/GDkUtbAlTY0dAoCWcU86gp29Af0jUJ9PZRzpm
         RPv1tF8TvbaeuRUqmtBNCBWhqCZHyHBSLi171PRUiBghCycOCvFPvLNLmBXTfm0jobxq
         QLb+2tK1zOteR6lzWBFyqlAoiQ6nbDkgB7T7WDRNkJgrRDbyXskVlCOz+GhuvhMkJWuu
         YDiiPrkTlD2JQsirKbRxr0OA+2jm89eWvpSZVRhV9kqLUthp1nlfCp1E6J9Vl50jT6zY
         dWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773829738; x=1774434538;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9NIKR5k+1KiAIlFBZ1fGk/oXZDI7bdXZbvHJYtXjC0=;
        b=gwXF+IOJHBEchfI8mMZKknJ1NWgcE/lNhYn0gYPoDyismo9uTcGZD+/JTwVoM/lh94
         jwz0mCvjntyNeNbg4evHCgALRsgp1KGBzqWH+fbRerkU9de7e68nMJ7QTVhFXmd7ENCD
         lObLIQRm3iUSkSCQ4tI0PCZ7HL4Rf+oFdKwNAn1l8SmYMgxWsa/vL4Hpy4fNFja/2LNr
         7+5Ef4no6lhPy5sd7j1vOydhApVNr0XH6sRZLDyokq5edIjeRuFFoBxH1vPPIaImEJqs
         CdZz/v+qJlsVGXWTERRo7VroX8vfYvHbcM2slqMJenhEsg9h9T0oz0jzXeOBnHcYnkVw
         4oqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgNrEObpqqzo+obK9iNI8OhaYhBihwBooHKdPWAANtgWXrpWqBhKm9Gfdft2Axiu6DW1wLOv0Y0A==@kvack.org
X-Gm-Message-State: AOJu0Yz4oH7v6oriy8f/4JOLGIaW0lNT6ygcl+FelSr70OipZm0EgRqU
	+PWKoOlI6x8tQXKHDrqKEyl30bbZRmrBpA5uWxuAvaOiopKMEhEe8RmK/c/g5DtZ91aeEHuVabk
	+BMvXecQlbCE3IlCM4wnOdUhsjGlLI7iZrnDAU8Io
X-Gm-Gg: ATEYQzynaGqd2j1Z723bPCEvXhK6pgJ2yywEvRNbE42P0pDh5CbObLHq7ATxj3CYj4F
	OARxNciKG7C48fNDGzEDN2UkixeGd1LpnDMdBC+GEfS+Ug9IIXfdWB1hglCx5U0m2bRVw2eeBIx
	szsvW1pKvXGcz+6OdE+uFJprLAJcJBITbvpjQ6svlyq30ZYXa7fjDiIaaXF0lk1NhnOqbgCOHWS
	OYxZdIlcYnOG9T/Wqj1YpLLq1AoYFXqOMhty+ZadZwN1hQLptj9vgpHKLKOf1NGItSP5C5/aLvS
	eMfLEA==
X-Received: by 2002:a05:7022:170a:b0:123:3640:33e4 with SMTP id
 a92af1059eb24-129c59229a9mr116624c88.18.1773829737168; Wed, 18 Mar 2026
 03:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com> <abpxUEijdHJzziEV@kernel.org>
In-Reply-To: <abpxUEijdHJzziEV@kernel.org>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Wed, 18 Mar 2026 11:28:45 +0100
X-Gm-Features: AaiRm52laPvQvDgSChpWDdFSr_bQXYvKW4oBN86rr7pIfvjd1jv3wL-Z8jGuFvE
Message-ID: <CAAi7L5e1rPb8tUZXTSegom1X=2CpzWkriy3San8V4_zbRbAQ2g@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/alternative; boundary="00000000000060fe86064d49ebee"
X-Rspamd-Queue-Id: 26052180006
X-Stat-Signature: 7pbniwbt7yifddum79phku3dyrps8mz6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773829738-105102
X-HE-Meta: U2FsdGVkX18dXrIpDmk6gGmVXynElaxdZv/USnnFKLIX8NZBGDn8azqIf9HSrVSuqeF5PPNBJEDXL0BSr2wfvOKmvLYbwMYdO+WHO4hET+xdpZAAVXxu4xq2q3pTi265dexPUoR6sh2yNtygtioa9MEpBdzh4AbafQw3EiS0Kv5PNhyn53qQK7OwNyIpUTJhiIfyRerzxP95/PAEj00ILFhidR+bS0W6h7Lpc7YScFxsmu1EUUsVRS9b0+sNoIxTej0VAkdUgUu8VnofCb6PMWlPLiLSKd4ogKp7Nl68iBpMMWPahAap0feY52chflUOhEr42A24/ARRjeleEVrYLh04PSmi8VB9Tbi2eC1JyPShfSrehAIn4jIhenKeZ5GGMVg08bgEasUTBmSR2hhiL0Dz+3kqqJ7AzOgF/L7DFXGEuoPPd0SJgEhwSivimqEOQ3SoST2bTQt506Vv1Wb9wVTq4t6XLDkijxK8jm8pozFzPnCkH0kxUeQcitXjVMt7HOCATt1CAgsXWUiseSF/bg0MEemxwniE0/HUybbd+zJLfjH7bRQxlB8vin/9zm+hvOsiL1uc1nmdGnZNs7lhz9za1rIMwgWxRdOtOUzvzKDoYt42c5yVy1AFod46lMbc3cT8FhFNwPFoW7dJ3fgeCYVB1XvsLcKiTaQb+MPfDELdC2DlLrpdFvaQsbUEmaxH8H1nWlfQjXI7RUtWIK4YQ+4QQ2K/iUT222xg30eyRjpH5IU+XdEFWAc2B2utzloQt4m2zhZduBj4+Df2Q4Gg6BhmONo9KRL3OMrudICSTgVC7hW9YJ/ilwJ+3DRxbkMfAWGb7D4xkzuN4xN9ztGJmTIhO+ZULUOsLmdqcD9TDTHL44FlOW6IAgoUlQY4eZ19YzphW4o68haJiwtDEU1oVj18cJOkLFFAEHhd0mvlMX7ozx8cr4EJYOwvAGKjc2I66EG3RtYRV/OHAMnX81a
 zCEKZnjO
 dWzSMON3OppxPMAfxJLeiC7Lpc/bbl+lcKz/vrtPHwEyJDy8pPTlyUyTzjGlaaG0mZaQgEci36Aq/20dF9JJe2wQnyfT8xLGjMSOO6nfF7hU5icUWHkvqbq4Ys5IG+a0W5/VIWSWdMhvxS3Rs3pCqfEpN2cm/ZpPURWxpnaA2AxKp7r+mORatPGSWwN7xHI0T/zThTBklXBg35lZQpPfL8cNZIfxk5fh5zzhYqXRB5N4MbaawVrQHJVfWr6ew5iLdPhNFMjLHrjyYlIfkX7sBWbQyYjIJlIR0nvawNPZspZD7pS6XIDafS8bIdA/M7W6LFDsDmx8hCvFCRYjMrvpD7ZPZS50C701ZwoeF8P+avCVNVU9zKbm4UO1v2gnAoMynhLdgqqkRE5rvEXXhJZfe2e3rrlFOUYEoARYfLOMztUMUs+0Lc0iRGj3iqVQD1X37MBfdsJliXI8qAkjzlXEhENqZKU9DynAHBOhU2ULeTv8l6OI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000060fe86064d49ebee
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2026 at 10:33=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:

> Hi Michal,
>
> On Tue, Mar 17, 2026 at 03:15:33PM +0100, Michal Clapinski wrote:
> > Currently, if DEFERRED is enabled, kho_release_scratch will initialize
>
> Please spell out CONFIG_DEFERRED_STRUCT_PAGE_INIT
>
> > the struct pages and set migratetype of kho scratch. Unless the whole
> > scratch fit below first_deferred_pfn, some of that will be overwritten
> > either by deferred_init_pages or memmap_init_reserved_pages.
>
> Usually we put brackets after function names to make them more visible.
>
> > To fix it, I modified kho_release_scratch to only set the migratetype
>
> Prefer an imperative mood please, e.g. "To fix it, modify
> kho_release_scratch() ..."
>
> > on already initialized pages. Then, modified init_pageblock_migratetype
> > to set the migratetype to CMA if the page is located inside scratch.
> >
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > ---
> >  include/linux/memblock.h           |  2 --
> >  kernel/liveupdate/kexec_handover.c | 10 ++++++----
> >  mm/memblock.c                      | 22 ----------------------
> >  mm/page_alloc.c                    |  7 +++++++
> >  4 files changed, 13 insertions(+), 28 deletions(-)
> >
> > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > index 6ec5e9ac0699..3e217414e12d 100644
> > --- a/include/linux/memblock.h
> > +++ b/include/linux/memblock.h
> > @@ -614,11 +614,9 @@ static inline void memtest_report_meminfo(struct
> seq_file *m) { }
> >  #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> >  void memblock_set_kho_scratch_only(void);
> >  void memblock_clear_kho_scratch_only(void);
> > -void memmap_init_kho_scratch_pages(void);
> >  #else
> >  static inline void memblock_set_kho_scratch_only(void) { }
> >  static inline void memblock_clear_kho_scratch_only(void) { }
> > -static inline void memmap_init_kho_scratch_pages(void) {}
> >  #endif
> >
> >  #endif /* _LINUX_MEMBLOCK_H */
> > diff --git a/kernel/liveupdate/kexec_handover.c
> b/kernel/liveupdate/kexec_handover.c
> > index c9b982372d6e..e511a50fab9c 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -1477,8 +1477,7 @@ static void __init kho_release_scratch(void)
> >  {
> >       phys_addr_t start, end;
> >       u64 i;
> > -
> > -     memmap_init_kho_scratch_pages();
> > +     int nid;
> >
> >       /*
> >        * Mark scratch mem as CMA before we return it. That way we
> > @@ -1486,10 +1485,13 @@ static void __init kho_release_scratch(void)
> >        * we can reuse it as scratch memory again later.
> >        */
> >       __for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> > -                          MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
> > +                          MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
> >               ulong start_pfn =3D pageblock_start_pfn(PFN_DOWN(start));
> >               ulong end_pfn =3D pageblock_align(PFN_UP(end));
> >               ulong pfn;
> > +#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
> > +             end_pfn =3D min(end_pfn, NODE_DATA(nid)->first_deferred_p=
fn);
> > +#endif
>
> A helper that returns first_deferred_pfn or ULONG_MAX might be beeter
> looking.
>
> >
> >               for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D
> pageblock_nr_pages)
> >                       init_pageblock_migratetype(pfn_to_page(pfn),
> > @@ -1500,8 +1502,8 @@ static void __init kho_release_scratch(void)
> >  void __init kho_memory_init(void)
> >  {
> >       if (kho_in.scratch_phys) {
> > -             kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
> >               kho_release_scratch();
> > +             kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
>
> Why this change is needed?
>

It's not necessary but kho_release_scratch() will
call kho_scratch_overlap(). If kho_scratch is NULL, kho_scratch_overlap()
will return early, making it slightly faster. Alternatively, I skip
invoking kho_scratch_overlap() if migratetype is already MIGRATE_CMA.

>
> >               if (kho_mem_retrieve(kho_get_fdt()))
> >                       kho_in.fdt_phys =3D 0;
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index b3ddfdec7a80..ae6a5af46bd7 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_only(void)
> >  {
> >       kho_scratch_only =3D false;
> >  }
> > -
> > -__init void memmap_init_kho_scratch_pages(void)
> > -{
> > -     phys_addr_t start, end;
> > -     unsigned long pfn;
> > -     int nid;
> > -     u64 i;
> > -
> > -     if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
> > -             return;
> > -
> > -     /*
> > -      * Initialize struct pages for free scratch memory.
> > -      * The struct pages for reserved scratch memory will be set up in
> > -      * reserve_bootmem_region()
> > -      */
> > -     __for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> > -                          MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
> > -             for (pfn =3D PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
> > -                     init_deferred_page(pfn, nid);
> > -     }
> > -}
> >  #endif
> >
> >  /**
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index ee81f5c67c18..5ca078dde61d 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -55,6 +55,7 @@
> >  #include <linux/cacheinfo.h>
> >  #include <linux/pgalloc_tag.h>
> >  #include <linux/mmzone_lock.h>
> > +#include <linux/kexec_handover.h>
> >  #include <asm/div64.h>
> >  #include "internal.h"
> >  #include "shuffle.h"
> > @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct
> page *page,
> >                    migratetype < MIGRATE_PCPTYPES))
> >               migratetype =3D MIGRATE_UNMOVABLE;
> >
> > +     /*
> > +      * Mark KHO scratch as CMA so no unmovable allocations are made
> there.
> > +      */
> > +     if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
> > +             migratetype =3D MIGRATE_CMA;
> > +
>
> Please pick SJ's fixup for the next respin :)
>
> >       flags =3D migratetype;
> >
> >  #ifdef CONFIG_MEMORY_ISOLATION
> > --
> > 2.53.0.851.ga537e3e6e9-goog
> >
>
> --
> Sincerely yours,
> Mike.
>

--00000000000060fe86064d49ebee
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">On Wed, Mar 18, 2026 at 10:33=E2=80=AFAM =
Mike Rapoport &lt;<a href=3D"mailto:rppt@kernel.org">rppt@kernel.org</a>&gt=
; wrote:</div><div class=3D"gmail_quote gmail_quote_container"><blockquote =
class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px sol=
id rgb(204,204,204);padding-left:1ex">Hi Michal,<br>
<br>
On Tue, Mar 17, 2026 at 03:15:33PM +0100, Michal Clapinski wrote:<br>
&gt; Currently, if DEFERRED is enabled, kho_release_scratch will initialize=
<br>
<br>
Please spell out CONFIG_DEFERRED_STRUCT_PAGE_INIT<br>
<br>
&gt; the struct pages and set migratetype of kho scratch. Unless the whole<=
br>
&gt; scratch fit below first_deferred_pfn, some of that will be overwritten=
<br>
&gt; either by deferred_init_pages or memmap_init_reserved_pages.<br>
<br>
Usually we put brackets after function names to make them more visible.<br>
<br>
&gt; To fix it, I modified kho_release_scratch to only set the migratetype<=
br>
<br>
Prefer an imperative mood please, e.g. &quot;To fix it, modify<br>
kho_release_scratch() ...&quot;<br>
<br>
&gt; on already initialized pages. Then, modified init_pageblock_migratetyp=
e<br>
&gt; to set the migratetype to CMA if the page is located inside scratch.<b=
r>
&gt; <br>
&gt; Signed-off-by: Michal Clapinski &lt;<a href=3D"mailto:mclapinski@googl=
e.com" target=3D"_blank">mclapinski@google.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 include/linux/memblock.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 2 --<br>
&gt;=C2=A0 kernel/liveupdate/kexec_handover.c | 10 ++++++----<br>
&gt;=C2=A0 mm/memblock.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 22 ----------------------<br>
&gt;=C2=A0 mm/page_alloc.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 7 +++++++<br>
&gt;=C2=A0 4 files changed, 13 insertions(+), 28 deletions(-)<br>
&gt; <br>
&gt; diff --git a/include/linux/memblock.h b/include/linux/memblock.h<br>
&gt; index 6ec5e9ac0699..3e217414e12d 100644<br>
&gt; --- a/include/linux/memblock.h<br>
&gt; +++ b/include/linux/memblock.h<br>
&gt; @@ -614,11 +614,9 @@ static inline void memtest_report_meminfo(struct =
seq_file *m) { }<br>
&gt;=C2=A0 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH<br>
&gt;=C2=A0 void memblock_set_kho_scratch_only(void);<br>
&gt;=C2=A0 void memblock_clear_kho_scratch_only(void);<br>
&gt; -void memmap_init_kho_scratch_pages(void);<br>
&gt;=C2=A0 #else<br>
&gt;=C2=A0 static inline void memblock_set_kho_scratch_only(void) { }<br>
&gt;=C2=A0 static inline void memblock_clear_kho_scratch_only(void) { }<br>
&gt; -static inline void memmap_init_kho_scratch_pages(void) {}<br>
&gt;=C2=A0 #endif<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 #endif /* _LINUX_MEMBLOCK_H */<br>
&gt; diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/ke=
xec_handover.c<br>
&gt; index c9b982372d6e..e511a50fab9c 100644<br>
&gt; --- a/kernel/liveupdate/kexec_handover.c<br>
&gt; +++ b/kernel/liveupdate/kexec_handover.c<br>
&gt; @@ -1477,8 +1477,7 @@ static void __init kho_release_scratch(void)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0phys_addr_t start, end;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 i;<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0memmap_init_kho_scratch_pages();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int nid;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Mark scratch mem as CMA before we return =
it. That way we<br>
&gt; @@ -1486,10 +1485,13 @@ static void __init kho_release_scratch(void)<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * we can reuse it as scratch memory again l=
ater.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0__for_each_mem_range(i, &amp;memblock.memory=
, NULL, NUMA_NO_NODE,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 MEMBLOCK_KHO_SCRATCH, &amp;start, &amp;end, NULL) {<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 MEMBLOCK_KHO_SCRATCH, &amp;start, &amp;end, &amp;nid)=
 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ulong start_pfn =
=3D pageblock_start_pfn(PFN_DOWN(start));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ulong end_pfn =
=3D pageblock_align(PFN_UP(end));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ulong pfn;<br>
&gt; +#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0end_pfn =3D min(end_p=
fn, NODE_DATA(nid)-&gt;first_deferred_pfn);<br>
&gt; +#endif<br>
<br>
A helper that returns first_deferred_pfn or ULONG_MAX might be beeter<br>
looking. <br>
<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (pfn =3D sta=
rt_pfn; pfn &lt; end_pfn; pfn +=3D pageblock_nr_pages)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0init_pageblock_migratetype(pfn_to_page(pfn),<br>
&gt; @@ -1500,8 +1502,8 @@ static void __init kho_release_scratch(void)<br>
&gt;=C2=A0 void __init kho_memory_init(void)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (kho_in.scratch_phys) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kho_scratch =3D phys_=
to_virt(kho_in.scratch_phys);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kho_release_scra=
tch();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kho_scratch =3D phys_=
to_virt(kho_in.scratch_phys);<br>
<br>
Why this change is needed?<br></blockquote><div><br></div><div>It&#39;s not=
 necessary but kho_release_scratch() will call=C2=A0kho_scratch_overlap(). =
If=C2=A0kho_scratch is NULL, kho_scratch_overlap() will return early, makin=
g it slightly faster. Alternatively, I skip invoking kho_scratch_overlap() =
if=C2=A0migratetype is already MIGRATE_CMA.</div><div><br></div><blockquote=
 class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px so=
lid rgb(204,204,204);padding-left:1ex">
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (kho_mem_retr=
ieve(kho_get_fdt()))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0kho_in.fdt_phys =3D 0;<br>
&gt; diff --git a/mm/memblock.c b/mm/memblock.c<br>
&gt; index b3ddfdec7a80..ae6a5af46bd7 100644<br>
&gt; --- a/mm/memblock.c<br>
&gt; +++ b/mm/memblock.c<br>
&gt; @@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_only(void)=
<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0kho_scratch_only =3D false;<br>
&gt;=C2=A0 }<br>
&gt; -<br>
&gt; -__init void memmap_init_kho_scratch_pages(void)<br>
&gt; -{<br>
&gt; -=C2=A0 =C2=A0 =C2=A0phys_addr_t start, end;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0unsigned long pfn;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0int nid;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0u64 i;<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)=
)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * Initialize struct pages for free scratch memor=
y.<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * The struct pages for reserved scratch memory w=
ill be set up in<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * reserve_bootmem_region()<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0__for_each_mem_range(i, &amp;memblock.memory, NUL=
L, NUMA_NO_NODE,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 MEMBLOCK_KHO_SCRATCH, &amp;start, &amp;end, &amp;nid)=
 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (pfn =3D PFN_UP(s=
tart); pfn &lt; PFN_DOWN(end); pfn++)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0init_deferred_page(pfn, nid);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt; -}<br>
&gt;=C2=A0 #endif<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 /**<br>
&gt; diff --git a/mm/page_alloc.c b/mm/page_alloc.c<br>
&gt; index ee81f5c67c18..5ca078dde61d 100644<br>
&gt; --- a/mm/page_alloc.c<br>
&gt; +++ b/mm/page_alloc.c<br>
&gt; @@ -55,6 +55,7 @@<br>
&gt;=C2=A0 #include &lt;linux/cacheinfo.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/pgalloc_tag.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/mmzone_lock.h&gt;<br>
&gt; +#include &lt;linux/kexec_handover.h&gt;<br>
&gt;=C2=A0 #include &lt;asm/div64.h&gt;<br>
&gt;=C2=A0 #include &quot;internal.h&quot;<br>
&gt;=C2=A0 #include &quot;shuffle.h&quot;<br>
&gt; @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct =
page *page,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 m=
igratetype &lt; MIGRATE_PCPTYPES))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0migratetype =3D =
MIGRATE_UNMOVABLE;<br>
&gt;=C2=A0 <br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * Mark KHO scratch as CMA so no unmovable alloca=
tions are made there.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (unlikely(kho_scratch_overlap(page_to_phys(pag=
e), PAGE_SIZE)))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0migratetype =3D MIGRA=
TE_CMA;<br>
&gt; +<br>
<br>
Please pick SJ&#39;s fixup for the next respin :)<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0flags =3D migratetype;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 #ifdef CONFIG_MEMORY_ISOLATION<br>
&gt; -- <br>
&gt; 2.53.0.851.ga537e3e6e9-goog<br>
&gt; <br>
<br>
-- <br>
Sincerely yours,<br>
Mike.<br>
</blockquote></div></div>

--00000000000060fe86064d49ebee--

