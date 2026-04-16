Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672DBF8D758
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98D16B00A4; Thu, 16 Apr 2026 11:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48FE6B00A5; Thu, 16 Apr 2026 11:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37636B00A6; Thu, 16 Apr 2026 11:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D78D6B00A4
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:06:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FFB113BB25
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:06:27 +0000 (UTC)
X-FDA: 84664745214.10.4E5C786
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3A6854000F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:06:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eLCJ9OTF;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=mclapinski@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776351985; a=rsa-sha256;
	cv=pass;
	b=GBy8RtqttxVQhPcvhkr66AUCLm/WPwL8bOLdimhbkRReaDVH0UaOQ4e3Pu++Ws92KVhxnp
	+get3k3Z0SuoTnF3sS8zhiRMsxAh7kFEP5A/nSVmoXtJm79P9VG3G2YK/8t7YfiIddupPY
	qK24S1csS4dTX4EYnZbQ825LhAr3ZBk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eLCJ9OTF;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=mclapinski@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45BgfgnYSvNFM3E5UxQrEO2kHNtJ//4sETpS6wYzv3E=;
	b=0HTIMmXM703k+aTwoUc9MTzrqrsKjIkweVnI9w9qxHS4/VJoreBnodQO0dERxEA+a4xsrt
	VyouKM+PstAIFi8QbuyN/me6dR/ciPWyeuwauTxn5cSRDYlu6AKWg2tv3RezC9qQHHXD9x
	YeBQg7EVQD0/MtYHh5qaDb/oTMKDTdU=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-126ea4e9697so7268c88.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:06:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776351984; cv=none;
        d=google.com; s=arc-20240605;
        b=Xfz0dKt58Ck5dPiAnQcXKi8w/OEmTzRqLLNAHXhK7k455JUGe+HsExgm6a5HqurLLH
         pW/OlIDDccE2pcxqBgY+w971gnvk8vuFa/1Xo2LJbvCpb1Ats9foWdVTSj0LFQPHa1oa
         3vUoFVU5xcwjYvtOloRwonv7RiPKKY1Sl3qpOhx7qKa6zfKsDiDcuC/pJnNiNAoIc8om
         eVC1f38qwx8hkgqOEo8e1Ocxcp7MZQRhoeJ6+Kru60vjF/qR8o0Dx8Pnb4iq1roWd4p5
         mt9iJMPSlo7fHoZzIgNsFnrSPmiS6CyliQKubDBglJ8/C44JdvQNk6t3pBsquQfsJbZT
         b+Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=45BgfgnYSvNFM3E5UxQrEO2kHNtJ//4sETpS6wYzv3E=;
        fh=a0PoJ5//TxKblISYUCXbFQd38hEdxuTQLQX1hXBu9ps=;
        b=detCviL9I6p/ussrECuq2QkA/LCaGylHth5Cys7HB1q/FTczQJBa/aemEErJIF0I1T
         2bA4JtURah+Mvwt1wAaE9m+28ibEE2noA5KcAoLcwk8UkzOYpz7MB8hyUP0fTpUixFJZ
         OcOcs+IOpscX5yor4K/kLDfJAsCatiHulJ9xxdehc034jTgqJ851Fa91kvu7bJwYrIfr
         9Iu6StvnDsNHHTIDEPOeWfvT1YHJ1vw+w08deF/UEtondtegHioWJgWJiS+OnoFUSghy
         v82C3RdYp3+ynXW+ZiT+yqz/sdVHgn+J9etlNzcB4exOrO49rfG4fxesqaEzQ0ulb+Qm
         R/mA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776351984; x=1776956784; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45BgfgnYSvNFM3E5UxQrEO2kHNtJ//4sETpS6wYzv3E=;
        b=eLCJ9OTFhihD/ZKRzMjIGNYhu6b8xWAhjrXEpr8u28WyyH01Afp22MvLPz8nfzPJ6u
         5QxzCry/R8zrTwa8yIaLSfKRrMJC6NMArsSFvlo4ByNRPFPf+QNWnHix6BO1WOYmHypy
         A+8MMuH6AeXvvG7cw3Gsel8l3vYOOtfvMcQAeLr56ozBKqH6+NWR7aacMsjASYj4SKIz
         dF2KJQl3a60aXxAYqfXa0y804fNcC4cfSJvB9rBEPiL8qHWasxvoBtJlF5r+8g1O3aAy
         SFXmRosO9BfWBGxTFdeole5nXdEt1xRAGl3hr/mXMH2GJn9OFtpHfkpTlJi6HYgYOkkT
         Kj4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776351984; x=1776956784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=45BgfgnYSvNFM3E5UxQrEO2kHNtJ//4sETpS6wYzv3E=;
        b=OEsQ/XUVHbHx6tp8b2MlXIK2iH8qIkpzJS8stTBXIzzKSRalh0RBgn+rR/c47aMk8I
         0ZwpqfUUDC+ELuHciVTA13npOpja5o9QjXItwirC35lQKVcCo5hTsbrskKqFZyI3eVps
         ZubyroNRIs5qqPbItV0i3oiJXXaNJdtjcs3v7LPviezHTyYF2QyobZ0QSHlgnmIoo1sN
         n8ONDwuXh10g1RR6UFN3lpNOCAnV1rkH9cqUjpI/R5+/amz5Q29dY0TelYR07ZHZqLKq
         K6wQz1UwDnlQLCLbMX098WhOZqhXWxpAuen2AV+s0BO2k2W9FKeM2an4EZUEL6uZ6hOQ
         eDJQ==
X-Forwarded-Encrypted: i=1; AFNElJ/uxcuDXBOFF8aOcUo6olRhhfAWK0ehgC2XVL8kJ6m33JHZ4Ol/HvkVsh294bh4SCCvG5/nB8Sckw==@kvack.org
X-Gm-Message-State: AOJu0Ywz41DQBd0ztqCVrXay+HQxp6Awy9tVwB3reYbf5qJ04smjE9m2
	RZpHWT/KRdiiTEI97akPEToXqMyZ6l/uv/p1jrXfBPSDjCCKlCKe3WEup29N+0OzT5LWv+jpebv
	X/flefyng6orYVL/+IRI31fgvd/8zkK0/QsAmbkLg
X-Gm-Gg: AeBDiev3OxtPlsBAmaaBTLGYr0Z+G597YqeMEiKPSt0xRjvh2hivDhjAQJwzNm28/N4
	1v2L1Vt/rTqfZAHl7Ny6heun/ha76F87CBcH/YIWBUMfa/pwtg71PfiITASdrGJ5h8TV/YUYtJd
	vhrcO6bUkbShxbfziwyV7mVZDusZt8mwZhOit8ikja0tnr5web9TB2iyFo3lh8GmSFHoVz0A+3t
	5Wpyrlu/pvrMxvtig9ZFaRRjzTQTDznENyZMfSEp89NLx4rabGkS5FIjjau3gLIcX7yOLKgW7nc
	K5uWOtVgqpJjSBJLM/FkRwSC3cSeysxo4aopBLBiwEgdfXqj5Tzjigxiqn0=
X-Received: by 2002:a05:7022:6081:b0:12a:77e6:68d9 with SMTP id
 a92af1059eb24-12c6376e195mr157713c88.16.1776351982854; Thu, 16 Apr 2026
 08:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260416110654.247398-1-mclapinski@google.com>
 <20260416110654.247398-2-mclapinski@google.com> <aeD2Fzr6yr4pu9-X@kernel.org>
In-Reply-To: <aeD2Fzr6yr4pu9-X@kernel.org>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Thu, 16 Apr 2026 17:06:10 +0200
X-Gm-Features: AQROBzARF615Kab2e80dancapvA5l6qTAyjo5RjoXtClPQ7kr5-X60F2Yw6i9FE
Message-ID: <CAAi7L5d-ujEa7R21Lmd37X9451KBmK8ZhagSKbJde15aQLi2MQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] kho: fix deferred initialization of scratch areas
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3A6854000F
X-Rspamd-Server: rspam12
X-Stat-Signature: akw19a4x6oorygj98cmitqh4wu3dqjfq
X-Rspam-User: 
X-HE-Tag: 1776351985-632110
X-HE-Meta: U2FsdGVkX18Smooj008tUL9B5Ppa1v7D1c3RzNGWlQoPaH2Rn75vEx71A4JQ0P8j03pEY4RnSPn+owh7siRBgYRhDTXtJLTMe7/cA4hHfm/kUiJjy5OATOdyLjHZvShMmbu5cYkDRyMCiajMWq3Qi9J05Z12a7QxXxwCWXR0uCEGeSlP1fY7+6hhk/0Oymuxct/2CBn1rIwdyepFyqgpgxJPkecqBl7SsWBlf2jd9E0kI6TccN5f5udEz/GlMBl6RCPLRCh6AW8rPLFbG4SjKwafd3fpkZuMh3VbWIrFr5FfT2gtuGd9wkTTSc6A+L4ah+8XsOXszDW1RlPjeSDa61TL5lfdrX6zI6BOiIibPTxGYm7zgMLplI2cGUea4fRuMpcrs6nzBo52PWqFZlSnLp00iQjb6/P3hVYAe+8lCEbpDo0a6XCDSqJkENKO84fSmEFPnsZE1pd1v800ssbMF4poFKExHMWJbEXTsT2GGP8SWrMC8ImMgP+xkDYDYEDtta/bg1iNSMF6gJIJQCqVF8JWiTLYd2GGzVq9rQzmVDFvJMh7ERvkXidLZKKVgCr4nsMWDddiEjyzFuNuW0vX0yhL4Hh2miEt/Swg9DJlpmT0u4Qcb9he3obeZ1O7wXagYP2WxUAm72LQL0Io8DH1g0rWi630+weIZN4qxt/lqcEfWu/VPEFESdoio1n2eO6msZbB3h6zwvCOB6iqIGVzQ9ni28SEs0SQWX+WHCxlEupPmsbkDfW6PSRfSMYHFzcWRBi6zCvJMkyiZuAhU6u6rTMBlozs49LegZipY6dG8/OqocnNE3SQaULHFOH9RJLYtVZ8L7neKaghHiGohMTr2+u52DqS7pldpAD+Czq5lOwZpC4k3HBOOQjsAGdeHmH5MsxJbt1L2xU3qGrQRwC+MoFC0L1TMPR6ASrO9B4uT7TX48WDwSDmJ11iFthBPnxXoZPFJ3O780KyMVxFOXK
 JEz8RqPd
 ufl2aSb8aC6KaiUBe9wv8vpxvY2Nq6j3FKR0FYGWaretwN4DDnnoT/m3aKIxR1PCoSR/OQiKlvrAlEH0vipTaGbUT4HyGPkDBaYBSqBCEDIvTtPSrQl0zDCbjqBET9F1pcHrPCF/jqdK1AlZBv4cqg0DW+vv/P+KpLyHdNM4691gSzwqyoN5Is+fTi1nmH0jhS9InmK8tHPx+NHK+40J8yd8c8V4DCGS3GKdA+YnB1UsaktY6gCzY9R7CVaxErMtGXpMLxKg6zXCPhkwlbE8+xVseufXdPmmqDlGKnGvgz2IEIXBEsUIJ/CfMKsxSHTQlm/CAZ6jxHf955KTFgklX/5ZXMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 4:45=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi Michal,
>
> On Thu, Apr 16, 2026 at 01:06:53PM +0200, Michal Clapinski wrote:
> > Currently, if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled,
> > kho_release_scratch() will initialize the struct pages and set migratet=
ype
> > of KHO scratch. Unless the whole scratch fits below first_deferred_pfn,
> > some of that will be overwritten either by deferred_init_pages() or
> > memmap_init_reserved_range().
> >
> > To fix it, make memmap_init_range(), deferred_init_memmap_chunk() and
> > memmap_init_reserved_range() recognize KHO scratch regions and set
> > migratetype of pageblocks in those regions to MIGRATE_CMA.
> >
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> Your signed-off should be last here :)
> https://docs.kernel.org/process/submitting-patches.html#when-to-use-acked=
-by-cc-and-co-developed-by
>
> > ---
> >  include/linux/memblock.h           |  7 +++--
> >  kernel/liveupdate/kexec_handover.c | 25 ------------------
> >  mm/memblock.c                      | 41 ++++++++++++++----------------
> >  mm/mm_init.c                       | 27 ++++++++++++++------
> >  4 files changed, 43 insertions(+), 57 deletions(-)
> >
> > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > index 6ec5e9ac0699..410f2a399691 100644
> > --- a/include/linux/memblock.h
> > +++ b/include/linux/memblock.h
> > @@ -614,11 +614,14 @@ static inline void memtest_report_meminfo(struct =
seq_file *m) { }
> >  #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> >  void memblock_set_kho_scratch_only(void);
> >  void memblock_clear_kho_scratch_only(void);
> > -void memmap_init_kho_scratch_pages(void);
> > +bool memblock_is_kho_scratch_memory(phys_addr_t addr);
> >  #else
> >  static inline void memblock_set_kho_scratch_only(void) { }
> >  static inline void memblock_clear_kho_scratch_only(void) { }
> > -static inline void memmap_init_kho_scratch_pages(void) {}
> > +static inline bool memblock_is_kho_scratch_memory(phys_addr_t addr)
> > +{
> > +     return false;
> > +}
> >  #endif
> >
> >  #endif /* _LINUX_MEMBLOCK_H */
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 18509d8082ea..a507366a2cf9 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -1576,35 +1576,10 @@ static __init int kho_init(void)
> >  }
> >  fs_initcall(kho_init);
> >
> > -static void __init kho_release_scratch(void)
> > -{
> > -     phys_addr_t start, end;
> > -     u64 i;
> > -
> > -     memmap_init_kho_scratch_pages();
> > -
> > -     /*
> > -      * Mark scratch mem as CMA before we return it. That way we
> > -      * ensure that no kernel allocations happen on it. That means
> > -      * we can reuse it as scratch memory again later.
> > -      */
> > -     __for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
> > -                          MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
> > -             ulong start_pfn =3D pageblock_start_pfn(PFN_DOWN(start));
> > -             ulong end_pfn =3D pageblock_align(PFN_UP(end));
> > -             ulong pfn;
> > -
> > -             for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D pageblock=
_nr_pages)
> > -                     init_pageblock_migratetype(pfn_to_page(pfn),
> > -                                                MIGRATE_CMA, false);
> > -     }
> > -}
> > -
> >  void __init kho_memory_init(void)
> >  {
> >       if (kho_in.scratch_phys) {
> >               kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
> > -             kho_release_scratch();
> >
> >               if (kho_mem_retrieve(kho_get_fdt()))
> >                       kho_in.fdt_phys =3D 0;
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 4224fdaa8918..fab234f732c3 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/seq_file.h>
> >  #include <linux/memblock.h>
> >  #include <linux/mutex.h>
> > +#include <linux/page-isolation.h>
> >
> >  #ifdef CONFIG_KEXEC_HANDOVER
> >  #include <linux/libfdt.h>
> > @@ -959,28 +960,6 @@ __init void memblock_clear_kho_scratch_only(void)
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
> > -      * memmap_init_reserved_pages()
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
> > @@ -1971,6 +1950,18 @@ bool __init_memblock memblock_is_map_memory(phys=
_addr_t addr)
> >       return !memblock_is_nomap(&memblock.memory.regions[i]);
> >  }
> >
> > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> > +bool __init_memblock memblock_is_kho_scratch_memory(phys_addr_t addr)
>
> We already have a block under #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH, please
> add this function to that block.
>
> > +{
> > +     int i =3D memblock_search(&memblock.memory, addr);
> > +
> > +     if (i =3D=3D -1)
> > +             return false;
> > +
> > +     return memblock_is_kho_scratch(&memblock.memory.regions[i]);
> > +}
> > +#endif
> > +
> >  int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
> >                        unsigned long *start_pfn, unsigned long *end_pfn=
)
> >  {
> > @@ -2262,6 +2253,12 @@ static void __init memmap_init_reserved_range(ph=
ys_addr_t start,
> >                * access it yet.
> >                */
> >               __SetPageReserved(page);
> > +
> > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>
> No need for #ifdef here, there's a stub returning false for
> CONFIG_MEMBLOCK_KHO_SCRATCH=3Dn case.

In all 3 places the #ifdef is there because MIGRATE_CMA might be
undefined. I already broke mm-new branch in the past because of that.

> > +             if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
> > +                 pageblock_aligned(pfn))
> > +                     init_pageblock_migratetype(page, MIGRATE_CMA, fal=
se);
> > +#endif
> >       }
> >  }
> >
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index f9f8e1af921c..890c3ae21ba0 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -916,8 +916,15 @@ void __meminit memmap_init_range(unsigned long siz=
e, int nid, unsigned long zone
> >                * over the place during system boot.
> >                */
> >               if (pageblock_aligned(pfn)) {
> > -                     init_pageblock_migratetype(page, migratetype,
> > -                                     isolate_pageblock);
> > +                     int mt =3D migratetype;
> > +
> > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>
> Ditto.
>
> > +                     if (memblock_is_kho_scratch_memory(page_to_phys(p=
age)))
> > +                             mt =3D MIGRATE_CMA;
> > +#endif
>
> memmap_init_zone_range() is called each time for a region in
> memblock.memory. This means either entire range will be KHO_SCRATHC or no=
t
> and we can check for memblock_is_kho_scratch_memory() once for every regi=
on
> in memmap_init_zone_range().

Thanks, I didn't notice for_each_mem_pfn_range iterates over regions. Will =
do.

> > +
> > +                     init_pageblock_migratetype(page, mt,
> > +                                                isolate_pageblock);
> >                       cond_resched();
> >               }
> >               pfn++;
> > @@ -1970,7 +1977,7 @@ unsigned long __init node_map_pfn_alignment(void)
> >
> >  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
> >  static void __init deferred_free_pages(unsigned long pfn,
> > -             unsigned long nr_pages)
> > +             unsigned long nr_pages, enum migratetype mt)
> >  {
> >       struct page *page;
> >       unsigned long i;
> > @@ -1983,8 +1990,7 @@ static void __init deferred_free_pages(unsigned l=
ong pfn,
> >       /* Free a large naturally-aligned chunk if possible */
> >       if (nr_pages =3D=3D MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pf=
n)) {
> >               for (i =3D 0; i < nr_pages; i +=3D pageblock_nr_pages)
> > -                     init_pageblock_migratetype(page + i, MIGRATE_MOVA=
BLE,
> > -                                     false);
> > +                     init_pageblock_migratetype(page + i, mt, false);
> >               __free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
> >               return;
> >       }
> > @@ -1994,8 +2000,7 @@ static void __init deferred_free_pages(unsigned l=
ong pfn,
> >
> >       for (i =3D 0; i < nr_pages; i++, page++, pfn++) {
> >               if (pageblock_aligned(pfn))
> > -                     init_pageblock_migratetype(page, MIGRATE_MOVABLE,
> > -                                     false);
> > +                     init_pageblock_migratetype(page, mt, false);
> >               __free_pages_core(page, 0, MEMINIT_EARLY);
> >       }
> >  }
> > @@ -2051,6 +2056,7 @@ deferred_init_memmap_chunk(unsigned long start_pf=
n, unsigned long end_pfn,
> >       u64 i =3D 0;
> >
> >       for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
> > +             enum migratetype mt =3D MIGRATE_MOVABLE;
> >               unsigned long spfn =3D PFN_UP(start);
> >               unsigned long epfn =3D PFN_DOWN(end);
> >
> > @@ -2060,12 +2066,17 @@ deferred_init_memmap_chunk(unsigned long start_=
pfn, unsigned long end_pfn,
> >               spfn =3D max(spfn, start_pfn);
> >               epfn =3D min(epfn, end_pfn);
> >
> > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>
> No need for #ifdef here as well.
>
> > +             if (memblock_is_kho_scratch_memory(PFN_PHYS(spfn)))
> > +                     mt =3D MIGRATE_CMA;
> > +#endif
> > +
> >               while (spfn < epfn) {
> >                       unsigned long mo_pfn =3D ALIGN(spfn + 1, MAX_ORDE=
R_NR_PAGES);
> >                       unsigned long chunk_end =3D min(mo_pfn, epfn);
> >
> >                       nr_pages +=3D deferred_init_pages(zone, spfn, chu=
nk_end);
> > -                     deferred_free_pages(spfn, chunk_end - spfn);
> > +                     deferred_free_pages(spfn, chunk_end - spfn, mt);
> >
> >                       spfn =3D chunk_end;
> >
> > --
> > 2.54.0.rc1.555.g9c883467ad-goog
> >
>
> --
> Sincerely yours,
> Mike.

