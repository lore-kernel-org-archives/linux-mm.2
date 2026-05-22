Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E879CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A816B0093; Fri, 22 May 2026 05:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB106B0095; Fri, 22 May 2026 05:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1356B0096; Fri, 22 May 2026 05:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9B66B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:37:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFA81C2D17
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:37:03 +0000 (UTC)
X-FDA: 84794551926.08.D6D9BCB
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1068F180007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:37:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xk5f4tHq;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779442622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVo/FFXfWI6Siu3pboylHv8St2O3FHDrAkJHWhb+UAc=;
	b=yLwXngiy99nehbNsS1A3GRFp8JMOel7PvjAjDJnjl9a3M97rmdBu8PW0FDg0rg0ZT3GrKI
	42fhfVGT8W2n5REA7rlo4qaVozIjuSy+Tm/lJw2Zz7kXBVus3SF5/x/8izYf5eQLoO5GPt
	Lh/98igS2mM4rG0MHkXmYSH2/XU8DnU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xk5f4tHq;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779442622; a=rsa-sha256;
	cv=none;
	b=SVCpjhu1FY6M1IOYbM5iAOx0zESjGS+61MB4mfqdfU1GPe+Vo3MrN6Zlp+Yv8RyuboNeAF
	ze4IScuYVexXFAm4AdPVK1YmTf3SHjnrp9VjTEcUg1HyjaNP318q74aPoctoIkqFXQUtUF
	MfVfPunffzZOATQT7qBMn8mWuN1Mpxo=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-45ea19f412aso1223973f8f.3
        for <linux-mm@kvack.org>; Fri, 22 May 2026 02:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779442620; x=1780047420; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XVo/FFXfWI6Siu3pboylHv8St2O3FHDrAkJHWhb+UAc=;
        b=Xk5f4tHqR2lqBahMaUTL67A9ZKY4KpSk99XQ1PKJ/CJOTlD+AtbwyU4dGYjWt95Qdv
         xGGYzzxS6buO82U9dMhMz9fNf1iwEQ0EniUvHPGEXpxY+eSgK6Qv9Lo9/D832ptoTIKN
         2h1iZthnVeqCrvkXfsWSf9+RejSgYGNdMYfSVdcOR1uUtU+zf93xVtGGZ/vLWhF+JnZo
         A5GjV+ey0hMp227Q0KHtDEzqWc1MmTl/0IAeoMmZ68rbXLyN/hnNS1+jXdxgF4kV37iJ
         F2bJ4sS5Aq5JxXZT355JhMSWghGwh/q0SBFpMWMoeKHsVCcOyG4O1j2lInKFhRuhulwD
         4J7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779442620; x=1780047420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVo/FFXfWI6Siu3pboylHv8St2O3FHDrAkJHWhb+UAc=;
        b=TmUaW6obQp40siKJcn//kasgJ9P/vmLop/vaQLqWQcRG2Lf8ryaJt2PrWBoiJyWqrJ
         4vK6gtim9asm/tPdF8jOp4QMBC4fxJVuCmirZH2rcXqPAMb2e2li2IJASwI84Mf6KGf2
         J0QGT51CLscgVU+HOTyejjZzt0zVQ6255d8iJmlWE0UKrCtqu/kv4a4FkT4o7Up9AFer
         KBxaBZvbDWCAnJTwlAmMn3Q8BtZ/jBpe0EJALCoxj0S/ikhUI7ueSDLrj3aNfkY6ALO+
         J69dtjBWeVhhSX906Tnq8XS9cR1nQ0iLF7CjYdC5W1+WBpMQOuGpQwAISLKK7QvaFN65
         1scA==
X-Forwarded-Encrypted: i=1; AFNElJ+syshH+v0H2i+OBy6ARTCoEUvC0ao6lFm6bcruc0yaFSYxv7h04Tip6LoHKbd/9ttjTyRYkYDamQ==@kvack.org
X-Gm-Message-State: AOJu0Yxvvj0brG/Uyf5RpWotlYa9hVdYH2FiXDQwNPSVbNCX8g8eMNYe
	oOK0rt5NPu7Bmo/LlLlO7LayoB/sQsB1IcVY0n2Wloy1Wccsgo9oZY/p
X-Gm-Gg: Acq92OHTNnNrdTFF0ZLHfSWPj/+L6anoHiR3U+CwDk4Zu/aE9NYLEb+pJKVzoO9QSim
	1k6m/W1Z7DIyDpCJSW1xbh8HJW1y+JpUTQhRQLX/2PnUEsUxB9JswfFiXEFlcmaLUtN/3XthiEp
	HUPtVHFzgPmZdHwdmJqXhXVcKG9dPHBp0rUSAizE4307s8zs04eOpEbj+8FfjxQFZa0kdLRigI/
	b5wDH0lElk3HCR3iI2xMP7hkC/w/wTgVceowylSnZ4APtUJjf2fj/BY8+Axx06d4S3zVWqtlTTZ
	Q75M4LUX+7PT5sKd1wr/WsVVNrgWX7PXo+gkAkK/fQbHC/2cfrpNiVTu0CWqAosOOV1gxy+WH6G
	MjjdChJbJtY21Owe6l/0apkZVE1WVuENAK1AoOsOynyMD/9zSZi+vIug8AIZwMuPNW20UBDgvMP
	PYJhpLGKrXVUeDj3cmGyzhqYX0U+iWWVuy/drFcXBlXPNq8YaVIQWt4WRy2GJW1GJUTjC/0Nlu7
	dzdPhJAKXdOSSWVRMNWgX5mC4i/3AmtCO7miSbnuX0A
X-Received: by 2002:a5d:64e4:0:b0:45d:3a84:709c with SMTP id ffacd0b85a97d-45eb38d45e6mr3805787f8f.31.1779442620182;
        Fri, 22 May 2026 02:37:00 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9ba2esm2815306f8f.8.2026.05.22.02.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 02:36:59 -0700 (PDT)
Date: Fri, 22 May 2026 10:36:57 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, will@kernel.org, david@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-ID: <ahAjudlB32VbkKbG@fedora>
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahACfQ6kCfONqz5h@arm.com>
X-Stat-Signature: dw8a67kdmfzps9mkr8dbcqykhn8t43eb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1068F180007
X-HE-Tag: 1779442621-5375
X-HE-Meta: U2FsdGVkX19V3U9Swy9OjEsJrZA0j/kkjNmpqYdbNuNY8KVhySaqrQLw8OhBc5uT/BltXWW1R4h/pcN9FXhUcEnd87+8qm4XwWZ7T0Ci8xKW0QFvnwVCvKHdHaHa8QRbjTe2ZHmxYVNx6lKDPJI9USxTVR4cCJV7BXKaZdWOcB/9O01HCek3z6CifWJoNpnqxwNsWFYAAFxN8fCyNL33NH3f+8wkRIJzMEO+58SnYKT+h9zjvG8MEYmBF3yrd2fILjLhfeQRjxEc1lY7gIfx466X0+SeYbpqwqULFzjN4Lj3dpBWm+pGPcJ3SLZLRyIlUjorNrrPr0GDoP+67MnLFbUEUMbvqEc7NnNyU4PMGTdbH8TlGH2Lk3J1kN0s7MnNIX5GE3Ydoi0qCN+SmtJWzo0NUAk+4KuPL0eUeWlEc8BpDPPRjOAoLno7yaZ5GMU887pDOpXkI/VaVxQI3uIp/uqIgnoiTfymu+vE3328GjyCVjgBPwhu0ZKt5NHoEsKNplg+hl5xbAGUApBnb6vH31CKMV52gUhF2KuIFJlv932zHYgPsQulZjooik/iE8GjvKHuATgHwCm4oBuZC2v4aLT4ypppRd5K0VO8HopR6Y8YCMcgNkdBl77cZHndM9awmT4fFneq70mrhKKicdzXWgOSQWneXhDABR20/mm/+QyNLuzJ5Hho2+9njv4j6dDvKWavOTz3wmexz9ybxycG9GvW4q80LirHD36mpP2cl36oKktruIrGRzCl0fzN8nLiEl163oRNdVsVddjugCiw4mfIXnPhBFV83xCtIwXKXjEAg6CI6yfSrv+Q8Sm1f7hiOQJ3ZcRblfMCSzPnqdbrDZoGYhQJrpYGXleFa9ZJW6A71vMqHJNTHawWFTXfDwIPl9LDWJb2DE/xb4LMDSuug4rqcwj8+bgzEGLBiYBwD/BciyyX0/liO6ej8sZW0qEZLWhDyftJbE440YaGDOX
 2H22ch4j
 w1qMWahs7IrXMMB2wYWw7mNH6s+LahdKGrKumTW064eGlC9hovDWtq3Moc666bWgrB4/8tV4yvz0yO9ULEOIF0VXoZ8fPuyRQPB/6dtxbZS/ik5rG4fjf9nhxeZg/0ZBcI8EnN+c7vhN5cvQ2iwOVQv4P8AdvzDyMFKkoJkMtx/Nh4OjZP8j3zZFshyVm/xF8BV7QTXxieldATpQxeZmHr4kXGHLY3ktsW49IDzdTXHmLFcWJ/h9dAUCEN3WoDrn7L7tVZ4gmFvSoyjzunpePEvh/l2JpljMAXNEteM5c4gHi4HKS9EMPcN4E25BxtyLRdP4MLzClPDT7Iixa4Cccs8UmZ6TurTReDdpVysagSOnt2gOctChST6u3dxULj8qtdmzMG+agbH9RQwoM5wKna0u/475mCxHpMSk1Vl2O82SqFdaTEZlNtbQK07/9qDTsHTlOfrUgIShReBNhbr4RYgnTd0SqlIQX4JfsMDUaXFF83FEmWRyQlxQ5VCejntkUNsR/bZpsHskOxflesxb9QRc0p1L3zRRAa9aCok3JFDwgeDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:15:09AM +0100, Catalin Marinas wrote:
> On Thu, May 21, 2026 at 03:31:30PM -0700, Andrew Morton wrote:
> > On Thu, 21 May 2026 13:27:30 +1000 Alistair Popple <apopple@nvidia.com> wrote:
> > > Since 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in
> > > __create_pgd_mapping()") page-table allocation on ARM64 always
> > > calls pagetable_{pte,pmd,pud,p4d}_ctor(). This sets the page_type
> > > to PGTY_table, increments NR_PAGETABLE and possible allocates a PTL.
> > > However the matching pagetable_dtor() calls were never added.
> > > 
> > > With DEBUG_VM enabled on kernel versions prior to v6.17 without
> > > 2dfcd1608f3a9 ("mm/page_alloc: let page freeing clear any set page
> > > type") this leads to the following warning when freeing these pages due
> > > to page->page_type sharing page->_mapcount:
> > > 
> > >   BUG: Bad page state in process ... pfn:284fbb
> > >   page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x284fbb
> > >   flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
> > >   page_type: f2(table)
> > >   page dumped because: nonzero mapcount
> > >   Call trace:
> > >    bad_page+0x13c/0x160
> > >    __free_frozen_pages+0x6cc/0x860
> > >    ___free_pages+0xf4/0x180
> > >    free_pages+0x54/0x80
> > >    free_hotplug_page_range.part.0+0x58/0x90
> > >    free_empty_tables+0x438/0x500
> > >    __remove_pgd_mapping.constprop.0+0x60/0xa8
> > >    arch_remove_memory+0x48/0x80
> > >    try_remove_memory+0x158/0x1d8
> > >    offline_and_remove_memory+0x138/0x180
> > > 
> > > It can also lead to leaking the ptl allocation if ALLOC_SPLIT_PTLOCKS
> > > is defined and incorrect NR_PAGETABLE stats. Fix this by calling
> > > pagetable_dtor() in free_hotplug_pgtable_page() prior to freeing the
> > > page to undo the effects of calling pagetable_*_ctor().
> > > 
> > > Fixes: 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()")
> > 
> > 6.16+, so I assume we want cc:stable here.
> > 
> > >  arch/arm64/mm/mmu.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > > index 8e1d80a7033e..0c24fe650e95 100644
> > > --- a/arch/arm64/mm/mmu.c
> > > +++ b/arch/arm64/mm/mmu.c
> > > @@ -1422,6 +1422,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> > >  
> > >  static void free_hotplug_pgtable_page(struct page *page)
> > >  {
> > > +	pagetable_dtor(page_ptdesc(page));
> > >  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> > >  }
> > 
> > I'd of course prefer that arm maintainers handle this.  But
> > 5e8eb9aeeda3 came via myself so convention kinda-dictates that I get to
> > fix it.
> 
> That's fine but Sashiko has some points:
> 
> https://sashiko.dev/#/patchset/20260521032730.2104017-1-apopple@nvidia.com
> 
> The __remove_pgd_mapping() path is fine but we also have the
> vmemmap_free() path where the constructor was never called.
> 
> We could pass around a bool dtor argument but I wonder whether we could
> just check it's a pgtable page:

Free_empty_tables() looks like the only way we'd ever get to
free_hotplug_pgtable_page(). I'm a little curious why we can't
consolidate unmap_hotplug_range() and free_empty_tables().
I.e. just fold unmap_hotplug_range() into the latter.

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 4c8959153ac4..9d42cbddce27 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
>  
>  static void free_hotplug_pgtable_page(struct page *page)
>  {
> +	if (folio_test_pgtable(page_folio(page)))

This should work.

> +		pagetable_dtor(page_ptdesc(page));
> +
>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);

In the case we presumably have a page table page (ptdesc) at this
point, we should really be freeing it with pagetable_free() as well.

Its not a big deal that we don't right now, but losing track of the
matching allocation/free sites will become a headache when separately
allocating from struct page.

>  }
>  
> 
> -- 
> Catalin

