Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15FE9CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B6E6B0120; Fri, 26 Jun 2026 07:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52DB6B0123; Fri, 26 Jun 2026 07:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C216E6B0120; Fri, 26 Jun 2026 07:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE536B0120
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:09:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D28E1C1A42
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:09:43 +0000 (UTC)
X-FDA: 84921793446.09.44305A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 32154C0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:09:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ad89k8La;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782472181;
	b=fX+TWZaRO53HEZsspU70Gv2+Apy4X1JspxnCL1BHV78PD8rsJP2qTtg3WQ4fAYrn9uyrVW
	ZpJ5SGTjwSp/jSf9cAOqCzmSWBvGkb+AecY7m8CNzzbEtnsRsjOb3b02zhT1gnjpzdXdqd
	+W41oh6lkRiumKDsyL3ljPxbbiz8wbg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782472181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ya9r+sejhkuGFLbbHO9nWdEzjVEexGgZ9zOkP5ReoPg=;
	b=rPqhdzbyWm0Wj/6O1Y5ArHs5HKvmpq4Mat3+yl9FPukHIWZgmFkbeInQj43Cfo3mUxI32O
	YoLGa2SqJke9JQ/e0Rh1hxTET9WZOzns/y92voWTz29Ym6SMHQS9L187xonkgU04VljqFN
	J79A1YU6d3wtaRpNyzdwV3slS+/67IA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ad89k8La;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6724D44419
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0191F00A3A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782472180;
	bh=ya9r+sejhkuGFLbbHO9nWdEzjVEexGgZ9zOkP5ReoPg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ad89k8LakY0gQ+ppeRw0AEAUXT7nuF2a+vyTu8iezaBf/YL5EL2PJV4Zt0zqoDZZ3
	 MqF8xaEgQTvhw64+8DwXf+vueRwXX4Ig7OX/HQrtCxteUVGnxv1iKJ096YEOoSY434
	 TIrfzNDs3KRtlxT6vCdEvCGbQiY5a9zyQTSnbfMBlAVicI2xzn5bCba9SdKj3fpnOW
	 KJmDKtVyi1TBAMRr+yV7QC8OhHCfZfUSfOGvT+tfsX5KREBz67QouJjGCF4jTZ4D1x
	 F1imaXpmwlKcGQ0qKs6r6hSgzUnKKRa2JUahB+LwlTCpk9NJZsQk5SALges6gDVhmP
	 xJH48Vw8pE6Rg==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9157d3f2098so85124785a.3
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:09:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/IuJ3CuHGJsQF71tk+kBo+15CTEoKCfi0BYSx63tmcyq3e0p4Po5A31Gy+WHabJWQ00udQcg//HA==@kvack.org
X-Gm-Message-State: AOJu0Yy2yNUQVQkSiJHXredPeYZHllgGqQWdEYN6S78NkLbSCPHAblW8
	PGQkS1I1fyj0M5OJdzTL7/GH9oIpM0ZHe/UldHWTan1aafFIQqxweWQ5Y/X7c6obh9GZ9Fun5H3
	EA9pGWwnDF2VZPZx+9HgMLVTSDrHdVkI=
X-Received: by 2002:a05:620a:8396:b0:911:1a2c:f953 with SMTP id
 af79cd13be357-9293aea0081mr965857685a.20.1782472179730; Fri, 26 Jun 2026
 04:09:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com> <a6e410bd-7413-45f0-9033-a60cd5386512@arm.com>
In-Reply-To: <a6e410bd-7413-45f0-9033-a60cd5386512@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 26 Jun 2026 19:09:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w2N3Eo6PABhOvR_DsJUM2NNoNU=gG3O9AO+fv3rBs_1A@mail.gmail.com>
X-Gm-Features: AVVi8CdUISxG9j0fnCP2O4vacBi4CaJhMiEpwawXnrJPak73HEB-fJixal9lNBM
Message-ID: <CAGsJ_4w2N3Eo6PABhOvR_DsJUM2NNoNU=gG3O9AO+fv3rBs_1A@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Dev Jain <dev.jain@arm.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com, 
	Xueyuan.chen21@gmail.com, rppt@kernel.org, david@kernel.org, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com, 
	linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com, shanghaoqiang@xiaomi.com, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o3zzs3oocndjnhu8xxkgasfjbt6wkkbk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32154C0003
X-HE-Tag: 1782472181-399785
X-HE-Meta: U2FsdGVkX18erbcyg4ErTCJ0Y7MERl0Nr5oPy+aYwdbIS3zVzcoCsAxPAVXW4gAX3676fz54iqYiN8INryjiu5zzcq6/7eRUm1iF9HfQ7FY5KqSoGaHZJ+CeZ0cmKroskZjJ7d9YGlaaSBIZxP5NuUt+fyVivJ7FAAyJdN3ruOoa+g7t6aAJtqIurz+u/mbUeLjkLyuqzG+Dqxd9wFGR26L3WfBoB8lraz1ZL2/anZoPMNUGUWZpUCiq75GYffNZyOvRKeyMb1FDI7+qXY4y8AkjFE+/ad13GP0iZIWfs8wuDJWrl8x2jDZzxfI1jaoiUFC8NePZjGFY3RUvgEDtuOIfyxjUduQYvynsyMU2qSslDA/Y4wsF4W3IrRRJ7YMHr9rAHt1nLUnk1wUjTXGGnGZgepj3UxQ14a3AhVJlfsCmh952KOzs6d77x/l6mzk5I0nuHTtNo7Svj8iXgjCd2Nj2FYcqfwT3F/4MD3Mv0kTY9oD+V9XulbSG5D1ejFrBU3frbh0wNRmgxZGTjDhiFMn45dzPi462Q/ZI0RnKgbMjMxl60/79DXZ6X70m+atcrxPiT+txdmm4O4MZ4NGY566N2STu0y0DRs0wnEHR0sl8kVGEkd0CcND4/Tra2z+HvREMBmjssJd+YPdRmx97oZs/rY5qkBDqgbLdZflgoGwgqvXdO2aP0BqcLjraMu26I18RjvgTAJRefPXjx4c2Ze8exs8Gx3Sbj9K48qBHnukphudx8nRrrwwXWjW0552NWHml0Lynnc1NTbl6fd3NbDUUgA7x7qlkv3wJEGQS7RGZ7tCGuFiZaOnULM4T2FBrlfOfVIZVJJkiuChniztQzM/Mgsi7D8+VHmms/IJb9w/hTORc6U8aGanTCIMmlXriq/+gnZ5kxAiVuI0g+uu+U6OqHUKjKaNaRcM82eF4XWji/4ntdYLFSELM/ty68cZ87FfMB/bjm6M7snPftnt
 310HNi/N
 kRTH3EkXL2ENUMtC2WaulxVuTMdhg18NM148PWsvYIK4Gl3keB2Y9aB5IeUt0bqAwYM3qtxQSnga/3pyo6N42gkcbZeTeKqaKnvrJQbvjiq094XiWvJUWrFTIPXWYlMvWGnHKgVhyiMlRcUAUDyzj75hKMZZ1k96S+53nGTPdEvOO0I15dYBAXrHTZfEBfnjJZ1KG9Xqb2ZauOs33ptsBSSz/+i8ezKWqu0llc/Fg2S3bsFWMmE2u59BnWuLIKma8W7gAeVzRpk0waCkr3YKYbfN63FWajZ6GX/bGy9Dr9aMVuJjayOlnGhwEShTJ3dTbWtsLVJ4hzUAQxoq/3J+7l3RI8YwwSLw4bxNDhAC52WjuHprhEvH9cawWC/EO96oJUPbQtH10QowyC97Y99PAUPgzGOYY7mdZTAbd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 2:37=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 18/06/26 2:17 pm, Wen Jiang wrote:
> > This patchset accelerates ioremap, vmalloc, and vmap when the memory
> > is physically fully or partially contiguous. Two techniques are used:
> >
> > 1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
> >    segments
> > 2. Use batched mappings wherever possible in both vmalloc and ARM64
> >    layers
> >
> > Besides accelerating the mapping path, this also enables large
> > mappings (PMD and cont-PTE) for vmap, which are currently not
> > supported.
> >
> > Patches 1-2 extend ARM64 vmalloc CONT-PTE mapping to support multiple
> > CONT-PTE regions instead of just one.
> >
> > Patch 3 extracts a common helper vmap_set_ptes() that consolidates PTE
> > mapping logic between the ioremap and vmalloc/vmap paths, handling both
> > CONT_PTE and regular PTE mappings. This prepares for the next patch.
> >
> > Patch 4 extends the page table walk path to support page shifts other
> > than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
> > mappings. The function is renamed from vmap_small_pages_range_noflush()
> > to vmap_pages_range_noflush_walk().
> >
> > Patches 5-6 add huge vmap support for contiguous pages, including
> > support for non-compound pages with pfn alignment verification.
> >
> > On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
> > the performance CPUfreq policy enabled, benchmark results:
> >
> > * ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
> > * vmalloc(1 MB) mapping time (excluding allocation) with
> >   VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53us)
> > * vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)
> >
> > Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.
> >
>
> I am still a little nervous about doing vmap-huge by default.
>
> We can play set_memory_* games on a vmap huge mapping partially, thus
> forcing a pgtable split, and not all arches can handle a kernel pgtable
> split.
>
> For arm64, we can handle that with BBML2_NOABORT, but interestingly, in
> change_memory_common, arch/arm64/mm/pageattr.c:
>
>         area =3D find_vm_area((void *)addr);
>         if (!area ||
>             ((unsigned long)kasan_reset_tag((void *)end) >
>              (unsigned long)kasan_reset_tag(area->addr) + area->size) ||
>             ((area->flags & (VM_ALLOC | VM_ALLOW_HUGE_VMAP)) !=3D VM_ALLO=
C))
>                 return -EINVAL;
>
> Even before my change fcf8dda8cc48, we were bailing out on
>
> !(area->flags & VM_ALLOC))
>
> So on arm64 we haven't been supporting set_memory_* for vmap memory at al=
l, because
> it has VM_MAP set and not VM_ALLOC. Although we have a contradictory comm=
ent above
> this code so not sure if this was intentional:
>
> "Let's restrict ourselves to mappings created by vmalloc (or vmap)."
>
>
> So either there is no user in the kernel doing vmap + set_memory_* (looks=
 like it
> by doing an LLM scan), or it is not fatal for set_memory_* to fail.

Hi Dev,

The primary purpose of vmap() is to provide the CPU with a
virtual mapping to access memory used by device drivers,
followed by the appropriate cache synchronization with the
device when necessary.

Given that, I think it's technically quite questionable to use
set_memory_xxx() to change the page table attributes of a vmap
area, especially for only part of an existing vmap mapping.

>
> But even if no one does it now, technically the API allows it.

In case we ever run into the rather subtle case where someone
calls set_memory_xxx() on a vmap() mapping, are you
suggesting that VM_ALLOW_HUGE_VMAP should also apply to
vmap(), rather than only vmalloc()?
something like the concept below?
index 14e5a6f6cc76..204770474c60 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3559,13 +3559,15 @@ static inline unsigned int vm_shift(pgprot_t
prot, unsigned long size)
 }

 static inline int get_vmap_batch_order(struct page **pages,
-               pgprot_t prot, unsigned int max_steps, unsigned int idx)
+               unsigned long flags, pgprot_t prot, unsigned int
max_steps, unsigned int idx)
 {
        unsigned int nr_contig;
        int order;

        if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
                return 0;
+       if (!(flags & VM_ALLOW_HUGE_VMAP))
+               return 0;

        nr_contig =3D num_pages_contiguous(&pages[idx], max_steps);
        if (nr_contig < 2)
@@ -3583,7 +3585,7 @@ static inline int get_vmap_batch_order(struct
page **pages,
 }

 static int vmap_batched(unsigned long addr, unsigned long end,
-               pgprot_t prot, struct page **pages)
+               unsigned long flags, pgprot_t prot, struct page **pages)
 {
        unsigned int count =3D (end - addr) >> PAGE_SHIFT;
        unsigned int prev_shift =3D 0, idx =3D 0;
@@ -3597,7 +3599,7 @@ static int vmap_batched(unsigned long addr,
unsigned long end,

        for (unsigned int i =3D 0; i < count; ) {
                unsigned int shift =3D PAGE_SHIFT +
-                       get_vmap_batch_order(pages, prot, count - i, i);
+                       get_vmap_batch_order(pages, flags, prot, count - i,=
 i);

                if (!i)
                        prev_shift =3D shift;
@@ -3711,7 +3713,7 @@ void *vmap(struct page **pages, unsigned int count,
                return NULL;

        addr =3D (unsigned long)area->addr;
-       if (vmap_batched(addr, addr + size, pgprot_nx(prot),
+       if (vmap_batched(addr, addr + size, flags, pgprot_nx(prot),
                                pages) < 0) {
                vunmap(area->addr);
                return NULL;

I feel it's unnecessary, given that kvmalloc() already
always uses VM_ALLOW_HUGE_VMAP which will fail
set_memory_xxx() as you mentioned.
kvmalloc() is already a generic memory allocation API.

        /*
         * kvmalloc() can always use VM_ALLOW_HUGE_VMAP,
         * since the callers already cannot assume anything
         * about the resulting pointer, and cannot play
         * protection games.
         */
        return __vmalloc_node_range_noprof(size, align, VMALLOC_START,
VMALLOC_END,
                        flags, PAGE_KERNEL, allow_block ? VM_ALLOW_HUGE_VMA=
P:0,
                        node, __builtin_return_address(0));

Best Regards
Barry

