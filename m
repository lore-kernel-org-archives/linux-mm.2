Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E89DEF587C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 13:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D2A6B0005; Sun, 15 Feb 2026 08:04:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900F76B0088; Sun, 15 Feb 2026 08:04:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAF56B008A; Sun, 15 Feb 2026 08:04:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6762B6B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 08:04:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 015C41A0B09
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 13:04:36 +0000 (UTC)
X-FDA: 84446710194.02.A543D1A
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0773840005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 13:04:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iUTzC89v;
	spf=pass (imf01.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771160675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kAfsVURHjtL1SjXKf5qAuSO+4oS4zBs7/TyPRXPRRQ=;
	b=FhL1jEA/pB8zWAnbpzQmgqJCB4ZYd2RR06ZfdYrW5ipVFyrSjFzOx5cuRhZvQLj7XQn4X7
	LEEkJzwAoMbDfngFW44LE3EavFmUig/ivL3SP0jnaxGLafTjhYdru2EWhVVAil63l19QH0
	JhpvCR3JBRl/UaC1wnnUae2ZowQ1stY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iUTzC89v;
	spf=pass (imf01.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771160675; a=rsa-sha256;
	cv=pass;
	b=7WcTx7djI9R7uAV/Qat2QxZ8nBSiMY8rRfQTyHFwy0LptB14iDLy0ZiUnnlHDd+I90a7M6
	FJGeqUOzIzezgoeFK35IlHN3VNSYoIaqVTxbpERPO6UWzNP3fPtRDNUihT6MRdpaEJ6I3N
	ZLfSdb8DGHKMI16rGx4eNMcbMckos9U=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ad20007c73so3307825ad.2
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 05:04:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771160674; cv=none;
        d=google.com; s=arc-20240605;
        b=FpkloBUAj/gjgB8/1u6qh/1lHhHVzSwfPCYqU6Np/BPOJ85392ZF0wt0F/eVEqy+t5
         5GYBTMxQ2yhMH6oRVHcgJugGilzqS1OcBRALFvHmh1OfNYkgFnDTe84q2x5qP3t/06pr
         D1bX0LYPNnlURWcQAdUrDNy4jD4pweDWXKd1ldDeA+UmFu0OgdIvjobUb8Rc1YSUluoO
         QZ2CaaH0464gWQl2qQk2DF+QX9KxvYOCZaL+paVwbLJnPVtP78UzV+yNaHOc2By8ozf3
         N+14SkaiM7ZNxKgwyzOBKsQ1FQqMC6ogTJigNqf09XYzPi88opmY/S5Wscw0KLG/MsPI
         A3EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/kAfsVURHjtL1SjXKf5qAuSO+4oS4zBs7/TyPRXPRRQ=;
        fh=r6FWjxWzH1p7RSNN3xptlSOPjkfblRciRsSd4TlZ140=;
        b=d2MtbdiQ0Z6vHB9NCbmEgKbG12miUZuYV9nrA3F7BBZRMlhpElZKU8iO7EbE5md/IZ
         sgf7dAGeWkdSJwTCVfHosJFxRUYWb3uSvw8msmKKYoqb87KoLFprjpRrf8V0nTUyU0wl
         ZzbMaaFOF+iSLM4p3mrsX+2SxPzMSf4buIhkLWM8Iek6UIzRfa+dG+pVKapXVubWBsKY
         0eKilXSjq393kNhoX9AJJK/RYXepm0NtYc9HZFwYE0AlSGDF/OOL4p2nLvQ/OGb5MbLt
         Jo8e8X3t9sQl5vMPRZikQvbpYlHNQhklw0RDcMCzFJAkNhZ03WDYxbyHlnLPYIzEkHaI
         GezQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771160674; x=1771765474; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/kAfsVURHjtL1SjXKf5qAuSO+4oS4zBs7/TyPRXPRRQ=;
        b=iUTzC89vuPWpRZW77ywy9ws8SXJb2OC7pVg26MWaF0B0JK5TPV6YoUxNovztmMNNf8
         Kn4wcXHRQcrRdMyOKMNBt3Cklj8ZvXy0kI9uqTKvctXH5L8egojpnuyekU0C/D1bYZbg
         F607wygHMhPq3g3JocQQEQjy72VuWTicTn+80ZUCbSKKJN+EHy8Hsyp5ZGJBz+gneGM/
         sEjNLtNrOQLF1p1u4rWIQ4usbWAzEAK7XhiRpO7MiJE44PLkz/8w/ZBvTlXFzFS/ul6r
         dkhSPn5F1kTVfEZ2uXh/PAFGEz8qD/B3R6OlwsAWqBF8ahEYRYpGez7/ScKK0Q5DYiNt
         EKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771160674; x=1771765474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/kAfsVURHjtL1SjXKf5qAuSO+4oS4zBs7/TyPRXPRRQ=;
        b=OIkgp6u2UevErFGIeMfUUYBIVcHbEpqyFZh2CXCzzW/OMTc+jl6L/mAqTO+FDPZgSv
         f692h4Ue25aGytHQ1Ok5hZYqYurmbwDCyHoaBmgTPrNxpr7iq8s3yfvb7s29ULLxiR0n
         D/JAk407l6rnVNknUu2Rx0N0fCGj/KzvLCeLAV0ytrM+PsFxBYXHdz8TmAm+MnonxsyB
         kd4vhE+cIAmEADgB9FtY6ZppLeP+b8PYGiO4oxwPzlGswgtO7JbEODxg0VX2AOruY/U8
         mTFhI4aMpAsQfJ6XUvnx4izB0PACs8Ml8PX8NQ6QNJTDr+u1alxW5ymFedMQQIqtWUa6
         iBqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWCChRmlD4JsPh+qHOqQhQiNlAuMdJ9Wu687c7SWSdWWtIjxjEb6wSG328m+pBNDlmZpKhKkVz2Q==@kvack.org
X-Gm-Message-State: AOJu0YxLLM91fx3kpVFUPv/yN79gTsE1Sns5CbiBuABTScnGWqHgaQva
	hTYk5h+LaM4ALNXXFFCFEUHx8t1x44Tanb1p25FLT1Y8NMc6k/l2npw3tSK1YVbJ6wCPBJRIbpe
	B9/t6/4vK/0XXxB5OMpxMRWjdN9W2m04=
X-Gm-Gg: AZuq6aJv3anQ3bHxaxyXHVLDF30wJ2mziK7NzedVPGrJAHAp+UH79pM50q6AqqOY8kj
	pSrMFOHctAmtZrHVFpK3PZGXI2gmXBdf3AnF5kOze6VHsFGdjpHWo4wBjy45GM8OLSvqyymGCa5
	XcssboCwomBEbc1sHdjlKJBWz6gt9egfgDWRs/GcJlkbAIm7HOv+lTAfnwM6R3o+aVhAd84oHio
	DMrsUVXOLGnKZFfqToSN4dteh/qfQrUnTVfJ/eggez8bVIUgpeL9c3ARrqP6dy2oWS+qHcyY7JZ
	eLSwiQ==
X-Received: by 2002:a17:903:22c7:b0:2a4:8cd:c3cf with SMTP id
 d9443c01a7336-2ad17570671mr52720985ad.49.1771160673702; Sun, 15 Feb 2026
 05:04:33 -0800 (PST)
MIME-Version: 1.0
References: <20260111074453.66728-1-pilgrimtao@gmail.com> <20260111074453.66728-2-pilgrimtao@gmail.com>
 <aaf30e1e-be55-4212-b096-69f71bafd406@gaisler.com>
In-Reply-To: <aaf30e1e-be55-4212-b096-69f71bafd406@gaisler.com>
From: Chengkaitao <pilgrimtao@gmail.com>
Date: Sun, 15 Feb 2026 21:04:22 +0800
X-Gm-Features: AaiRm515p7wM45fzFdzJOfFAX4z0PPQknnxh8KEacuRNrwbe5LM6_K1ydvVjsk4
Message-ID: <CAAWJmAZpk7dj1CgDMRtkUAf6C-uc6FQKX32+v3BgXN=3NQv1yQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
To: Andreas Larsson <andreas@gaisler.com>
Cc: davem@davemloft.net, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com, 
	dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn, 
	willy@infradead.org, zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kcxskn6a8k7d3qc3a1zt9rgqk77egmcu
X-Rspamd-Queue-Id: 0773840005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771160674-29622
X-HE-Meta: U2FsdGVkX1918pciWRESa+Gdnjhd4APOqgreFuR2D1VOFUvLpmBqrriiT7nySl8twD9JdNBaP7jSB2BgclbBYbeJdy5t6Fjgu+lnWnsRlUEPZWhtorCP798kzK/7ojTT5H86JYp1IZuP6P4qia5LIocs4BIDY9xQFA+o/cKBMjiZQZTo3SMMtNtWZypFAAbcs3WqFjT8KShUY/DvGbb9AJQgIYfXG7/XExNeDQvWSJhL/N2x3qNfaryquvtk3WyYGxNUAJFKVhhIb0gYHTZJSAKlfMkBYvd0WPTsM26Lqor6Q8KdUQQotMvy0l8Ac0wOwSRC8Vpg5BRX/FRiUucj8sMU4Gmtv9NeguqwKEtE2mW1YuDSObRGNuDqFBfuVeFLuY5Do9//lynqPrW623mgxnK/FQ4wAtqP7/+XckSfGof3JB8qoPYPJyS/4jDU/yfncJR8BVdXb4x7tk4yVq/VK1Rjq1G7PS9mc1BnvfTMjosOqL9mHOWOjGeuX8OTwTxTJaw7BF+lb8hx9/KRoILpZH/9hq/D5IuE24DoyQr5kKzGFzOu82J+zn/HOIYdFT8UtImqnib0Fj2GDujCPfWP4Rwp2kTeNNe2koaaQfHhNjYggXDQQwDRW4wYG+vQvo8FVQdC5OaWlKWX6zQMRMJ//ME90s4mDz7dynEzanJ9w7ZR+zW4T4os0+uAhbkLjZ4RSGD1+XDR7/Ni0jN4ngyf3Uuha54H7pnYWAIgn36c7wgpjmarR7mxvT2DcoSMqxA5DfOITYhoa+UrDGRP8gnZmENGdDOl9KdqqSvDjms41O68ovCXnwWFSQNDwuN6qTUG7U4Koqh1/Oq0WZuVjFhGRILawvKd1fT6kJKxY/J0uLjOfEHCvKW+1E+7W0StczKKmveMEoTa1Z6THMzqQ3hX820vbk9bNoK/IF4vZwqnMp/kAToifK9uOfQxPWl64ZiyDnknlcpOu+NOBDCAj9P
 ZTEQ6BwL
 3LMAO9eL8rmrpP+Q94JhGuzjc8ei/ez/D1/Z2P5FGaBi3zUQMhCiUeln+8TAjOBK7k4wx3nnoPBUoPPEkdP6KsiQKlLeq4PX07fKFSy+MosuECKODFqdKoaOHPCBgNZsm9StQHshTwwxE7l2r0cqNr+oF5q2GNnwCbGw+BjaMK4Y6JkkH1MWziQBvaVq667mlHVvN3sXQvFWUqR7Cy3ShJ+0KywbBbHqS6u4pca0Xx5EgGkeimxh26Qb58XC/vzJvTdNnjaazJx1OTXDPLqfh0lgFvCJUPDwODKYd0d9hzttJuwklsJeDlkUxNUMUahCoWTNmiEnAj2Z2H8Ue4CwTIggS5VTjsGaCRXcnlZJU5RigPIQqoph38gzDSnXV90P8Z5Qc1JA4m+w6sKzss4UlHCh0vm3Eoa4yYrGmb+xdyiEejg/Of2nTq7WEWeoZcI4dEH3KDV0HCXPWjEQGuPG5hIyvenRxW9G5GBh+p4Y+ZLsHs4Vic2kN1hfj0tTqQ2xNUWoXeEPBJWunBVhDf5OWJ4Pyx+G7T0kjjiMOdF4uCN9o8qw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 10:50=E2=80=AFPM Andreas Larsson <andreas@gaisler.c=
om> wrote:
>
> On 2026-01-11 08:44, chengkaitao wrote:
> > From: Chengkaitao <chengkaitao@kylinos.cn>
> >
> > 1. In the SPARC architecture, reimplemented vmemmap_populate using
> > vmemmap_populate_hugepages.
> > 2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
> > when vmemmap_alloc_block returns NULL.
>
> This patch seems to potentially make more functional changes than what
> the descriptions gives impression of.
>
> Given the amount of changes this seems to introduce, more on that below,
> I'd like to see more description on the changes and why they can be done
> than this.

Hi Andreas Larsson,
Regarding my previous responses to the questions raised in this
email thread, I have not yet received your reply. I would like
to provide additional clarifications on these points here:

> Nit: use active language, "reimplement", not "reimplemented".

This issue has been fixed in version v6.
https://lore.kernel.org/all/20260201063532.44807-2-pilgrimtao@gmail.com/

> > Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
> >  1 file changed, 16 insertions(+), 31 deletions(-)
> >
> > diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> > index df9f7c444c39..858eaa6615ea 100644
> > --- a/arch/sparc/mm/init_64.c
> > +++ b/arch/sparc/mm/init_64.c
> > @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
> >  EXPORT_SYMBOL(_PAGE_CACHE);
> >
> >  #ifdef CONFIG_SPARSEMEM_VMEMMAP
> > -int __meminit vmemmap_populate(unsigned long vstart, unsigned long ven=
d,
> > -                            int node, struct vmem_altmap *altmap)
> > +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> > +                            unsigned long addr, unsigned long next)
> >  {
> >       unsigned long pte_base;
> >
> > @@ -2595,39 +2595,24 @@ int __meminit vmemmap_populate(unsigned long vs=
tart, unsigned long vend,
> >
> >       pte_base |=3D _PAGE_PMD_HUGE;
> >
> > -     vstart =3D vstart & PMD_MASK;
> > -     vend =3D ALIGN(vend, PMD_SIZE);
>
> It seems that this patch removes alignment of both start and end. Is
> this a functional change in practice or are these always aligned for
> some other reason?

In the implementation of vmemmap_populate_hugepages, the start
value remains unaligned when entering the for-loop for the first
time. However, there is no need to apply the "start & PMD_MASK"
operation in the vmemmap_*_populate series of functions. In
iterations after the first one, pmd_addr_end() will align the
start value; since start is already aligned, there is no longer
a need to align end.

In fact, in the original code, the presence of
"vstart =3D vstart & PMD_MASK" made "vend =3D ALIGN(vend, PMD_SIZE)"
redundant as well.

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
> > +     pmd_val(*pmd) =3D pte_base | __pa(p);
> > +}
> >
> > -             pmd =3D pmd_offset(pud, vstart);
> > -             pte =3D pmd_val(*pmd);
> > -             if (!(pte & _PAGE_VALID)) {
>
> It is not the same thing, but is this equivalent to if
> (pmd_none(pmdp_get(pmd))) at this point?

Since the vmemmap_*_populate functions all use vmemmap_alloc_block_zero
when allocating page tables, (pmd_none(pmdp_get(pmd))) can be used as a
replacement at this point.

> > -                     void *block =3D vmemmap_alloc_block(PMD_SIZE, nod=
e);
> > +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
> > +                             unsigned long addr, unsigned long next)
> > +{
> > +     int large =3D pmd_leaf(*pmdp);
> >
> > -                     if (!block)
> > -                             return -ENOMEM;
> > +     if (large)
> > +             vmemmap_verify((pte_t *)pmdp, node, addr, next);
> >
> > -                     pmd_val(*pmd) =3D pte_base | __pa(block);
> > -             }
> > -     }
> > +     return large;
> > +}
> >
> > -     return 0;
> > +int __meminit vmemmap_populate(unsigned long vstart, unsigned long ven=
d,
> > +                            int node, struct vmem_altmap *altmap)
> > +{
> > +     return vmemmap_populate_hugepages(vstart, vend, node, altmap);
> >  }
> >  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
> >
>
>
> This change introduces using vmemmap_alloc_block_buf() instead of
> vmemmap_alloc_block() seems to introduce two new behaviours that was not
> in use for sparc64 before:
>
> 1) Using altmap_alloc_block_buf() for a non-null altmap, that was not
>    used before. Also the fallback to vmemmap_populate_basepages() passes
>    on altmap.

This issue has been fixed in version v6.
https://lore.kernel.org/all/20260201063532.44807-2-pilgrimtao@gmail.com/

> 2) Trying sparse_buffer_alloc() before vmemmap_alloc_block(), which was
>    not done before.

The sparse_buffer_alloc function here is usable.
Both sparse_buffer_alloc() and vmemmap_alloc_block() essentially
call memmap_alloc(), the only difference is that sparse_buffer_alloc
performs the allocation in advance.

> Neither the commit message nor the cover letter touches upon this. Could
> you elaborate here?
>
> Given all the (at least seeming) functional changes could you share how
> you tested this change?
>
> Cheers,
> Andreas
>

Is there still a possibility for this patch to be merged into the
mainline? Should I continue modifying and iterating on it? Could
you help with testing it?

Regardless of your answer, I look forward to your reply.

--=20
Yours,
Chengkaitao

