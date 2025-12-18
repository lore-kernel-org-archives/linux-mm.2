Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592C8D6ACE5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823AF6B0088; Thu, 18 Dec 2025 06:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D13D6B0089; Thu, 18 Dec 2025 06:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD146B008A; Thu, 18 Dec 2025 06:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2CE6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:02:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D7148BE31
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:02:53 +0000 (UTC)
X-FDA: 84232304226.09.584B22B
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 039D01C0022
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:02:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fcXsbGA4;
	spf=pass (imf20.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766055771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=En+EeawiMP0LdiaonSFSpPBJQktT87DSvgUkdcBwHPI=;
	b=mD3OROAhHX/9uJuLrSSFpi4JIc37o00eI+Nsiqa/m5UayHp4+rNeAvZ8JklEf73iytD52M
	BzS+GtZSQYQAo3nZGUn2HdhmjsBflRt+SHm3fb63fAXPZ4zaNxGV3fn3mmK/S1hr22qACn
	tLf4kRPTpcdhF3tOx7d01gd3reLmZdc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fcXsbGA4;
	spf=pass (imf20.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766055771; a=rsa-sha256;
	cv=none;
	b=TKaAz02B1Nk6CkdXo3HLYQodpOylQ/urMo3YTmfqlmXCC0ytG/XvFEc4N8ccjKOaaZ1TxR
	BNrqM8IjU8d/j8ixwWMq+ZNDA9AlSyDO35lyiBIU1iBTWM8HOUi/stZVQKk1RUGE/rMgVs
	rmAZpWiyp8Ik+xGJbmnH3RgarTLCmlM=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34aa62f9e74so649856a91.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766055770; x=1766660570; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=En+EeawiMP0LdiaonSFSpPBJQktT87DSvgUkdcBwHPI=;
        b=fcXsbGA4pxGAld3NEAVZ9MB1WpHwEdPASy+5rsDtQK5iUlhh/8gU/HEKUERbyXG+Ih
         kwprRoQ814R20EKjli119PBYGpLpkdmQBjWB5iTh/3DR2hU40fnTHHiQG75YY0MnxAOk
         ilNzSKfrLep/yhGVMtIb8lb4iQHHknqouFPOgenuLP2L+PWwcOTUqeKf/WwuUOCPPfVi
         jEDV1MWygzd0aep9hY+fR1IBHw4KxNCRFObskMUDp/nnCnriHOTxP40kZUJ7eEGtHfM5
         EI4Ro1REo6Viuqp/qKjU8sMgUFlNJ+0NcZDIcgg35NuoYHGahjMlmhkwdO3v6R7o6TiF
         JOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766055770; x=1766660570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=En+EeawiMP0LdiaonSFSpPBJQktT87DSvgUkdcBwHPI=;
        b=smDSlV8X519SKYIRpX2hZ2MhS1r9M8V0WMsEWo0Mq7lXc9s7ylG2YK41DJiwzMKnwY
         bfx4NskbYw3sD+94auzcM9IE6YngaqEvWFBc0Fob7snNIvpwhLg8/kRIbrvZyNGBWnIG
         FYgzLVGI+7HRznzQzpDE4oE/qc5ZbwDsPRCzOtob4Fz/Iq4YPxj1gv8ZIFOmafg+q1BI
         ZN+sr1n1fDOcQajy8wWdwMTJG5kODSdrS1nf9L4JvxhdGkvAriNIlUK4PvV4ntWirWWx
         ESgXUjhPcqD5HBEIdjKZoDHnBX6ADAy3B6cME2a20tD+sO7BxTtnyTXY+T87z70uCCXz
         bS7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVjwQ0Y2JOg9zPeg5136HQg1blkM7FLHEs2SRa82GcqX+bgg3DVUUr0PQAk7hLviC78csdQkQSPjQ==@kvack.org
X-Gm-Message-State: AOJu0Yxcgk/CPGI2BnQoJ2Ny+D9XFfdnfoGX2teg9WU2Pv8HWkPIBoJq
	UkqSjoNyEwnB+sKVTIHrvAvhz/cyGjTCRMBdfsWmp7SXJ6dlE4/ssnY0+rGQb24Jhs8zhPtk54Q
	14Jz4cdWc9YDoEjie2GYctsKrSjt+1wM=
X-Gm-Gg: AY/fxX6wy5rriwAgq8Z+yR4B7wBkeCzbXqGKlYrUL67eYosBZ9lsSl7IPaBsSjBZvhX
	wQ/emFQi2gxrirdHvpPErsBUtRE4aSvh4xLstF/wAIIh1fxAb8e26PyKU2WYLL6hv7544R0p4pk
	TuRGncu/VsqY4KUpsh1hUDzyg0O/IihR9i5S8J6hR2FkBxDEb4SDct/gaDrazjn7K5ipcmByoiw
	iyZBkJRaBkGtYu7lg7pYRswd5eFYdQef6heCVTICz0fHTQbDHid1aZQpxU+oSzj8yMgxg==
X-Google-Smtp-Source: AGHT+IH1/DrYChO2Gun9o9bXvGbxXOFiFy9ttJqooM/uiUGdaYOlzL1RUFDLa7LiwEssz2HZQDik54yEGJN9oN42ooI=
X-Received: by 2002:a17:90b:3912:b0:33b:be31:8194 with SMTP id
 98e67ed59e1d1-34abd7bae4bmr17935657a91.34.1766055769647; Thu, 18 Dec 2025
 03:02:49 -0800 (PST)
MIME-Version: 1.0
References: <20251217120858.18713-1-pilgrimtao@gmail.com> <d373f7b0-f822-4c31-990c-41a6cdc76db3@kernel.org>
In-Reply-To: <d373f7b0-f822-4c31-990c-41a6cdc76db3@kernel.org>
From: Tao pilgrim <pilgrimtao@gmail.com>
Date: Thu, 18 Dec 2025 19:02:38 +0800
X-Gm-Features: AQt7F2p1oM-UBi3ufPsqgWlQ-JAwKfsIrRnsxPaSt1TZSRjeGmYZiIlx4BsjFqA
Message-ID: <CAAWJmAYJdEJyybVgD7erzZgvwufZ8gSmP_FCohmZLYozbhbb3g@mail.gmail.com>
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com, 
	dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn, 
	willy@infradead.org, zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: iw4t776amj61q3bh7984aqih99rkcyxk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 039D01C0022
X-HE-Tag: 1766055770-43323
X-HE-Meta: U2FsdGVkX1+gnux7kxSNbPbnrKDZlsz1CQ7oW+Kzi+kx9PRS1EROp0NxU8BlzWecF8TqugHKZJZMWd2hs78CY8f4UrIZO6cJQUvTGv9UFHA2kt2c0m8Nh0FWDY3dxQ5CxNu3IVW/q3ghhCYJp8uSo5ZoHfe33zKszJEpoZaaC8jlxXx0FByMPAdBX8sgidgHOjD9BNvrtEP9Zwyc26QrMGq6vcPFKhx+5aBrnxMXjhNsro4GLvJXWhgs8o/q58Hbvn5/0tM6LzL6dGRWVlAEgQL7mbC1dUnWrATyPNKIyyzZZZsbiCxapzbwqlGAErzRjD9Tq1/dPqIParoxfJgYK6SAF/nPEAn2LZsOAVNx22e3CyYHTsJLmYtFa3G6Hg7BuTk+TI4iv5yQHd27RkUHfNUVA4TQQGrIENkVENWoIUPww9YKdppfFUSn2Z4/6P++8SZEzAitSlboujiCGjJsHoQZIfnFkN8XfX4gvvovweF0igeUauWtKRmYzb3mTJZ7+VrdOLh2VPxO8/JakZ2Ab4iIoDkGIYd7xazfyQ4YsmKbat4wloL9NL7hRi+lFlibp1FXUMOiziuEBkGZRzPnctmRO9XLQmxXDgEt0NWy7y3Om/qAxmw+f2s2MMfCUc7E9OM7e5ysLoPltcH+MQtggSMLBVI9W+RZS2qwXHN1idBSsf8QUjRGYPBphopm39LIAbg3KwMKUFrsewkkNATvo6yJMNn1wO3SWky5p/KDeuLYfGr/cCH9VdBPnGjwDqWOJ0ZvdIaUYKf3LuOdlbcwnL2kQE0neXSgNNxm3dwfWUD4FBbkNUSCKDuUjcqPS0vlA8KYdxlZofQXk9EeAIoVKfMHqC22MZoFZVtc4q6XEyuwREDl8DO4rxnP6CGG25AHl566aPhVGNgpO9pUsghmqvBBj4P0BO35GoVyjTlxmhKdDcC7Qzxe7U3eZsB9jOWfw0doIjasS7QOxDUywah
 vQV66j/+
 hPEBbvlmjUrf1Mx85nGK3V8QUc4zWE3XtenZkFUFHX8Ct6GV/mGxZahMBC+6QypMHdcC3FJrB0JsJ4MyrTsJ2FRKZ/c+gUh0Hh9eEuUYzbGP3dhL/fnrfa+0owQGVUEE9cF/oJ/a4KaFkoqB/3IyMTMsDejlR1jSLF++PPVFCzW45NXKdCcHrbj+28EdrQIkkKcakeC0oP4+vItTf0Dd02Yg+pr4CYKAIQUiXxLIvlQ0SwDo85m0z8vVx3bCbXL3oz46rWSe2m7RZW0Z99hmKVAoMemr1oNzU1tBnPhFbUEKq0QAy+vrmm01w/neJjvBkxvz/0VVyV4bMjsBBKlJxxrYuwDkgSXDIfKn+vUPQMirwZh/GhCrgE+IRmp+fZ9HP10G/PkS6K6VWWf6xlykTofMPNB8rLiGlFHwrf5IfjtvX3uM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 4:44=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 12/17/25 13:08, chengkaitao wrote:
> > From: Chengkaitao <chengkaitao@kylinos.cn>
> >
> > 1. Added the vmemmap_false_pmd function to accommodate architectures
> > that do not support basepages.
> > 2. In the SPARC architecture, reimplemented vmemmap_populate using
> > vmemmap_populate_hugepages.
> >
> > Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> > ---
> >   arch/sparc/mm/init_64.c | 56 ++++++++++++++++------------------------=
-
> >   include/linux/mm.h      |  1 +
> >   mm/sparse-vmemmap.c     |  7 +++++-
> >   3 files changed, 28 insertions(+), 36 deletions(-)
> >
> > diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> > index df9f7c444c39..a80cdfa6ba98 100644
> > --- a/arch/sparc/mm/init_64.c
> > +++ b/arch/sparc/mm/init_64.c
> > @@ -5,7 +5,7 @@
> >    *  Copyright (C) 1996-1999 David S. Miller (davem@caip.rutgers.edu)
> >    *  Copyright (C) 1997-1999 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
> >    */
> > -
> > +
> >   #include <linux/extable.h>
> >   #include <linux/kernel.h>
> >   #include <linux/sched.h>
> > @@ -2397,11 +2397,11 @@ void __init paging_init(void)
> >        * work.
> >        */
> >       init_mm.pgd +=3D ((shift) / (sizeof(pgd_t)));
> > -
> > +
> >       memset(swapper_pg_dir, 0, sizeof(swapper_pg_dir));
> >
> >       inherit_prom_mappings();
> > -
> > +
> >       /* Ok, we can use our TLB miss and window trap handlers safely.  =
*/
> >       setup_tba();
> >
>
> Bunch of unrelated changes that should not go in here.

This indeed contains some unrelated code changes and removal of
extra whitespace. These could be split into a separate patch,
but the new patch might be somewhat redundant, lol. If you'd
like me to proceed this way, please reply confirming.

> > @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
> >   EXPORT_SYMBOL(_PAGE_CACHE);
> >
> >   #ifdef CONFIG_SPARSEMEM_VMEMMAP
> > -int __meminit vmemmap_populate(unsigned long vstart, unsigned long ven=
d,
> > -                            int node, struct vmem_altmap *altmap)
> > +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> > +                            unsigned long addr, unsigned long next)
> >   {
> >       unsigned long pte_base;
> >
> > @@ -2595,39 +2595,25 @@ int __meminit vmemmap_populate(unsigned long vs=
tart, unsigned long vend,
> >
> >       pte_base |=3D _PAGE_PMD_HUGE;
> >
> > -     vstart =3D vstart & PMD_MASK;
> > -     vend =3D ALIGN(vend, PMD_SIZE);
> > -     for (; vstart < vend; vstart +=3D PMD_SIZE) {
> > -             pgd_t *pgd =3D vmemmap_pgd_populate(vstart, node);
> > -             unsigned long pte;
> > -             p4d_t *p4d;
> > -             pud_t *pud;
> > -             pmd_t *pmd;
> > -
> > -             if (!pgd)
> > -                     return -ENOMEM;
> > -
> > -             p4d =3D vmemmap_p4d_populate(pgd, vstart, node);
> > -             if (!p4d)
> > -                     return -ENOMEM;
> > -
> > -             pud =3D vmemmap_pud_populate(p4d, vstart, node);
> > -             if (!pud)
> > -                     return -ENOMEM;
> > -
> > -             pmd =3D pmd_offset(pud, vstart);
> > -             pte =3D pmd_val(*pmd);
> > -             if (!(pte & _PAGE_VALID)) {
> > -                     void *block =3D vmemmap_alloc_block(PMD_SIZE, nod=
e);
> > +     pmd_val(*pmd) =3D pte_base | __pa(p);
> > +}
> >
> > -                     if (!block)
> > -                             return -ENOMEM;
> > +bool __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
> > +{
> > +     return true;
> > +}
> >
> > -                     pmd_val(*pmd) =3D pte_base | __pa(block);
> > -             }
> > -     }
> > +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
> > +                             unsigned long addr, unsigned long next)
> > +{
> > +     vmemmap_verify((pte_t *)pmdp, node, addr, next);
> > +     return 1;
> > +}
> >
> > -     return 0;
> > +int __meminit vmemmap_populate(unsigned long vstart, unsigned long ven=
d,
> > +                            int node, struct vmem_altmap *altmap)
> > +{
> > +     return vmemmap_populate_hugepages(vstart, vend, node, altmap);
> >   }
> >   #endif /* CONFIG_SPARSEMEM_VMEMMAP */
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 15076261d0c2..5e005b0f947d 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4248,6 +4248,7 @@ void *vmemmap_alloc_block_buf(unsigned long size,=
 int node,
> >   void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
> >   void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> >                    unsigned long addr, unsigned long next);
> > +bool vmemmap_false_pmd(pmd_t *pmd, int node);
> >   int vmemmap_check_pmd(pmd_t *pmd, int node,
> >                     unsigned long addr, unsigned long next);
> >   int vmemmap_populate_basepages(unsigned long start, unsigned long end=
,
> > diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> > index 37522d6cb398..bd54b8c6f56e 100644
> > --- a/mm/sparse-vmemmap.c
> > +++ b/mm/sparse-vmemmap.c
> > @@ -407,6 +407,11 @@ void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, =
void *p, int node,
> >   {
> >   }
> >
> > +bool __weak __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
> > +{
> > +     return 0;
> > +}
> > +
>
> Reading that function I have absolutely no clue what this is supposed to
> do. :)
>
> Also, why are you passing pmd+node when sparc ignores them completely
> and statically returns "true" ?

The pmd+node is indeed unnecessary. My original intention was
to provide convenience for future architecture extensions, but
upon reflection, this appears to be a case of over-engineering.

> If you can tell me what the semantics of that function should be, maybe
> we can come up with a more descriptive name.

In the SPARC architecture, the original vmemmap_populate
function does not retry with vmemmap_populate_basepages
after vmemmap_alloc_block fails. I suspect SPARC doesn't
support basepages, which is why we need to modify
vmemmap_populate_hugepages to provide an interface that
skips basepages handling.

--=20
Yours,
Kaitao Cheng

