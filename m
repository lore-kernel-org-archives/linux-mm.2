Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45706C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FFE6B0095; Mon, 24 Aug 2026 20:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0676B0096; Mon, 24 Aug 2026 20:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8BA6B0099; Mon, 24 Aug 2026 20:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB3796B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:17:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EC7F1202F1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:17:38 +0000 (UTC)
X-FDA: 85137878196.26.1FFB449
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 60F98A0005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:17:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wJ59VmWm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787617056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFqARnaWsfVIsueHxYAc51tuCHmb5rqqqqfMHtoWdZU=;
	b=IQ24VON93MBlK8fNDMwhg6pjEqjeu5PDjZupapIgKvDffuXbs0de5EJF5xy1CJbgoFohyP
	hZmsYGr2yQBM8PEH4ldFFbvfv2BPDm6xPJGGuB/4Q2PSIuNIiY4lIwvoIC0rv9YeS/RkAz
	hBxRs8AFk84lqDK3/7HbY7ZvqF+Q6yU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wJ59VmWm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787617056;
	b=YqiBhYWpR607NsscS4+Pmk6ZWC46GqvRgtPHRZHfRVYrr1EJNf0i2lZObBCbqQWVuqJCYB
	vaGzuc8NsFiJYNwzxNOSHt/dck2GVM1UqwpdI/XyflrrTPtkdniKrl3ar242KtWrVZK1Fh
	4pop8VCD6IDfvrGXlS6jAfoRAFVf1/0=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c214321dc32so810043866b.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:17:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617055; cv=none;
        d=google.com; s=arc-20260327;
        b=IjXju4b4f5y27KlLnB3jcSJ2Au7aWp4+mt3OzlhnqVf3dy4neLXw1IsqDzDk0ws3iK
         b2/w/xEeP1HETpcSkYvoEyPot9+CQx8reoxvpLctJzyqx49cdB3CIR3CK5KGkZeZB2J2
         l/3rhfGYYWDOwL09K8JQnr+h6HDYmLv7xFH/B03b4pkQN7jpNDreSIe8W6rqNyLjQj8l
         o1xAT8/wOvgpRtB4p520YeirXOyE3Z7wNf/OFmnnUmmFe6aHCeWxPdXe8joWn5J7ozP5
         bcNjhzePsAae19yxYqYCba/jPcXXqvx5jl4jgBphlScjkntbowx3BkFFH5wCEM5bXMOj
         6eiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cFqARnaWsfVIsueHxYAc51tuCHmb5rqqqqfMHtoWdZU=;
        fh=geCL76dH9g/Zk6nfB+7Vqdt38iFOm9YEwOQI1WYOFKk=;
        b=amVcq4JE7rmV6CKbt4F2cvqnrw7WywvpnAmhnyxxpX3i/2K2XpMo55sFmIG249P2ZN
         HB58bmUFxKmPi2poXA7a9uR6FuCoVRUox8KxDRZzqmnGWdhA2+ZxJp4KiVd0/Tdo6bnX
         6n22ny+0+eiYzWXIiahkroRBPPyiOz4UrRb1Uaxd9HvRJeLNkBGjELAVSD/6AOalog2i
         DHmpOG0bXJqJNV2HXEBHb7R626w77MwaoPxeFetsYMbzp4VilWsXIVwRFGLJ2de48G42
         Stexm9fiHPDS63g/6naycDssoZbx6mGSvHfioix96h12lIaU/eY9yrYVkbIHAtWzDQnC
         qNrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787617055; x=1788221855; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cFqARnaWsfVIsueHxYAc51tuCHmb5rqqqqfMHtoWdZU=;
        b=wJ59VmWmjcHRHQ1suewkWKLhXiO6RUrP1+2+FNsa60GWrlrrFB/lve1ukaql8yEmUn
         ZI2s8Fc4bdR1YcPt9ATv7uk7/1cJJiHKT0BBgx9yFudN6uFo3nExqfmARiFyKeSsQFHw
         QtJIRlsdq5zPb2xHUWFI7/9Es77IsuhtRQf/zTm0EAnxrawN3YyBUtkDNBjY54wLWVn1
         MdccY0UY/EPhUD2cTK/M/sqSjTNC9g18j5ZFw7szNYzwyuND5r7HFvpXAfaLSazIBDEh
         1cPCAuPvqUNvod7qAOZiSpK8Itj5n0R2rPRT+3mFc/mtbKLfkjbbe2cRj+b4ck7553rR
         Px8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617055; x=1788221855;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cFqARnaWsfVIsueHxYAc51tuCHmb5rqqqqfMHtoWdZU=;
        b=qy8fOHnyt3DFV4Zt6qvGV2Tg5ebDv7VD+OBIrCokfCWUfYCJOAvJxcTt4SKPAIDbgP
         URH6uREtgt7jhhlbkyt2qF1fQEWdhbHKd7K8kJ1JIsYaEfhCkV2fHNJiafihgZUsnnkR
         9JOr8xYUmpSYnSKfHDJn7y1B8E7HnlQ7Ol6gF8XYPBq/6W5sb/DoDv0z5o/BXjxxooRa
         DDVz/0KHcnihYYP+Xr5cv8zW6DfruTbFJbaOGPTPm+7Mw/glQlsgQB3xgWyZXH8DGPSe
         ySzPq3hufSHQXaiQxvZOIQWKZrumvheHQBaRCBPQewOCA1FKWLMvF/pJcxziCCqyEQOn
         PBPQ==
X-Forwarded-Encrypted: i=1; AHgh+RrOQ4tCDxHDvL79VJ5l/pKl/7qw8Vnht+wYoKC/GKMxx4n63owD49StEohz6f1Yj1RfxcXtCglSrg==@kvack.org
X-Gm-Message-State: AFuF++nSQ0TESnp6F6S5Rc1NBbqRWUzSb1zLNgIF6nH8it72xNV7aWvl
	X6MEt8FYt5HK5OBD8ZjB+FZwdmjeQBGNQ88A32IkjQO/uA1RiAbrehvr+2hdBE8b2k3DaPsELnN
	AQD2rXoG9by0zk2EW3Yl2Cpw0SnfjjNukxRQG0ocf
X-Gm-Gg: AR+sD13eX8mM+ZXIAOKN9Cb3yZGk5Kpgr7aU6oW+BlgnaEM1cJCKjxxSNFIDO1bKb1O
	S9Zh96lZBZKtjo6aSG4BkKpFBmJfl6R9mzuGAzTlMDihMQWC4Cx0pS/lewWly97zUZLD0192kt3
	vg8NvVeyibYXMKHcdUlJlgSPg4VxK5KR9jP7hOXrXAQpehx7HhZhOt0JphEx9+5lX7/WAuELuwt
	C066Ug2LBtM3i8sLSrI0yBTCf2XhDeh+pfbMqxGMMrBDPZSAB7MvVIfuca87SlYz053/7jB54Jc
	LUOnoiFAkZrNzha8vE9d1gnLDqDaEGgR24tBtz4bipeBPdDuZn9noCTajiC4alj+JRmN5A+K08X
	K5bn48xIzjmQJhUh3feCoEQlBHUmEmkj1nZgFP5YDPzffXdvGGGHuCrOoc6JtoZhQOCP/YWiB9W
	VlrH7V4x92HfRS
X-Received: by 2002:a17:906:3e5a:b0:c20:2165:d74f with SMTP id
 a640c23a62f3a-c246a6ca4f5mr2781903566b.22.1787617054440; Mon, 24 Aug 2026
 17:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-12-jthoughton@google.com> <aoR_5LHPsVXUnxt6@arm.com>
In-Reply-To: <aoR_5LHPsVXUnxt6@arm.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 24 Aug 2026 17:16:56 -0700
X-Gm-Features: AcwNN1XeyQDNjfznf_slsJ2-WVr_gTFPPucM9IuBLkDPTtT4L5ACRlCs4qb6Unw
Message-ID: <CADrL8HXpA7D3UAScj0+TpuqEPcQvLGA6htABnwYnOBXorBQrNw@mail.gmail.com>
Subject: Re: [PATCH 11/18] hugetlb_vmemmap: Use try_populate_vmemmap_pmd for
 replacing in-use PMDs
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60F98A0005
X-Stat-Signature: wiu4ebqwhdbisa9ok9xsajegzk5mwz1u
X-Rspam-User: 
X-HE-Tag: 1787617056-926624
X-HE-Meta: U2FsdGVkX1+JgwsLGIk4eQwwlgr6mlMfPBzFy815WsxscKDNCEsm6QgStY6+uvvSz6MVBGGdj47x5cucq0bQD2QwPHfUDvLFtweBEyO9LYsIo7ZvsCOEjUIcXa9A4IdGCAiPUtoPLgarh8m8EGVkWeTYOjMveK5a3YFNnecbWjyh3NMETfpVM6mSCaLLqsPL6zrxBRdrQzPa2yQZiFCT/N3++9sYqQg46ANrGM3tW8UcwAYvZNlPNgs+uJ4SlCnFixZb1XbCyPoHQ+28/F3G0TPWwiQWhEeYvnQjRbF8Kzdgx+xh2bwHqOa4iZlfLZTM+fjZhWD3TF8VdtzrR6f5KkUyDy42+O6ktatbEfYqf7ZgVl3bggtEO3/P2w+QvvzXMBUDk31b3YnkCfqPd5YSzoc8bQ2q1EvI0wzx6KA/nmd4+Vw+yK5+u8pvhXfd8zWyUdzMNAmdrzy6UYF/HxlOEpxL2lfaFM5Sk4JlHHzHbQr2D68/ti7sPXCni5hohUzO2afZ8IpL0Vxo4R4BGEgQJ5Hyoc9K6375iUklLNU0+t/mEIWINwZCDEiosYVOUVhw9/PrDGcY5OFo6r0cLeaSpJ7sTHvfIzzxbIbJbqkXVZeKxb26sIgkqJdvzpze+RJmV0rgbOMGkAM8zmKGLmQyaLmO1yuL9EVUrZSthfUZVqGYLzbMynlNsUNDMlPokj35VgycY8CjQYsqJNGjFOlNjMK86i0YufAPLxdQG9zfr8nkRMf+Ll4inJOJedsEaOpNqQaKptWSmWHnMEKuxMKCkFK/N6WEwUJE0AnFLRaHhuT359xRaQcQ+c/R3lQ4zOWwACFm5tePlhLDTV/AvCtR6KI9zvXv4lEvH4NnhorKbXcVQZiCnFaZlWK7rxSuPD0tW7ocDH0MHKCCZAU7KpP4ZBO3vPWdBpkh0lAu5IfqIDDovVQen/Dnu3QZPGFdpjiCQeYwkqqkt066u99pyM7
 woDyhzba
 0vSXTSOD2qBe3jAsZeqDw65SFvRJuQT+pVSR1OMIMa2Tde4lVLIga2Tbg9+XM19/jxAubZxM/0DaWl/LiSTGcbkjPVEHVM1JaJ6jBOdbG9rc3V30/vlRRBp+k3mBS0vkS2fx7OI0M0Iwai+1/ayIgPSqUP796nlZgnzbQrxPQzGOKqvI6yiL1Yifi+taNfLfo+32dvOklCvs2Mhn3dxCGVZNqq/54kdUHeE7Q8ceCp686i1XTaqXMHrVX9t2jbPv9dyb110OnWOtIethzcwrefwqGmF+TrCXmVCCKbDrpIeKI9P7qyXGwoMPSfObVU7vGsfQQiyQH+0w1nzEiIlSG6LcQybsYJlomcmNN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 8:53=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Wed, Jul 08, 2026 at 03:11:21AM +0000, James Houghton wrote:
> > diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/=
pgalloc.h
> > index 1b4509d3382c..c8946250d431 100644
> > --- a/arch/arm64/include/asm/pgalloc.h
> > +++ b/arch/arm64/include/asm/pgalloc.h
> > @@ -121,4 +121,13 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pg=
table_t ptep)
> >                      PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_PXN);
> >  }
> >
> > +#define __HAVE_ARCH_TRY_POPULATE_VMEMMAP_PMD
> > +static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable=
,
> > +                                        unsigned long addr)
> > +{
> > +     /* BBML2_NOABORT is required. Its presence has been checked. */
> > +     pmd_populate_kernel(&init_mm, pmdp, pgtable);
> > +     return 0;
> > +}
>
> This patch adds the same function in 4 different arch files. Can we not
> have a single generic implementation in linux/pgalloc.h, bracketed by
> some ARCH_WANTS_* (macro or config)?
>
> I think the same goes for patch 4 with try_update_vmemmap_pte(), we can
> reduce the code duplication.

Yeah putting the generic version behind an ARCH_WANTS ifdef is so much
better. Then I can just nix the EOPNOTSUPP branch; a compile error is
always better.

> > diff --git a/include/linux/pgalloc.h b/include/linux/pgalloc.h
> > index 9174fa59bbc5..ed446d95ca37 100644
> > --- a/include/linux/pgalloc.h
> > +++ b/include/linux/pgalloc.h
> > @@ -26,4 +26,24 @@
> >                       arch_sync_kernel_mappings(addr, addr);          \
> >       } while (0)
> >
> > +#ifndef __HAVE_ARCH_TRY_POPULATE_VMEMMAP_PMD
> > +/*
> > + * try_populate_vmemmap_pmd - Populate a PMD that is in use by the vme=
mmap.
> > + * @addr: Base address of the remapped PMD.
> > + * @pmdp: Page table pointer to be overwritten.
> > + * @pgtable: Pointer to the page table that the new PMD will point to.
> > + *
> > + * This function is only to be used to update PMDs that map the vmemma=
p to
> > + * point to a page of already-populated PTEs that map the same pages.
> > + *
> > + * Implementations of this function must ensure that, while the update=
 is taking
> > + * place, CPUs will not fault on the remapped virtual address range.
> > + */
> > +static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable=
,
> > +                                        unsigned long addr)
>
> Nit: if we follow try_update_vmemmap_pte(), we could place 'addr' first.
> It matches pgd_populate_kernel() as well in this file.

Will do.

> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +#endif
> > +
> >  #endif /* _LINUX_PGALLOC_H */
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index 977249e22ed0..b445febac0d2 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> > @@ -55,6 +55,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page =
*head, unsigned long start,
> >                            struct vmemmap_remap_walk *walk)
> >  {
> >       pmd_t __pmd;
> > +     int ret;
> >       int i;
> >       unsigned long addr =3D start;
> >       pte_t *pgtable;
> > @@ -74,8 +75,15 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page=
 *head, unsigned long start,
> >               set_pte_at(&init_mm, addr, pte, entry);
> >       }
> >
> > +     ret =3D 0;
> >       spin_lock(&init_mm.page_table_lock);
> >       if (likely(pmd_leaf(*pmd))) {
> > +             /* Make pte visible before pmd. See comment in pmd_instal=
l(). */
> > +             smp_wmb();
> > +             ret =3D try_populate_vmemmap_pmd(pmd, pgtable, start);
> > +             if (ret)
> > +                     goto free;
> > +
> >               /*
> >                * Higher order allocations from buddy allocator must be =
able to
> >                * be treated as independent small pages (as they can be =
freed
> > @@ -84,21 +92,17 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct pag=
e *head, unsigned long start,
> >               if (!PageReserved(head))
> >                       split_page(head, get_order(PMD_SIZE));
> >
> > -             /* Make pte visible before pmd. See comment in pmd_instal=
l(). */
> > -             smp_wmb();
> > -             /*
> > -              * On arm64, this requires BBML2_NOABORT. Its support has
> > -              * already been checked.
> > -              */
> > -             pmd_populate_kernel(&init_mm, pmd, pgtable);
> >               if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
> >                       flush_tlb_kernel_range(start, start + PMD_SIZE);
> > -     } else {
> > -             pte_free_kernel(&init_mm, pgtable);
> > -     }
> > -     spin_unlock(&init_mm.page_table_lock);
> > +     } else
> > +             goto free;
> >
> > -     return 0;
> > +out:
> > +     spin_unlock(&init_mm.page_table_lock);
> > +     return ret;
> > +free:
> > +     pte_free_kernel(&init_mm, pgtable);
> > +     goto out;
> >  }
>
> Would 'free' first with fall through 'out' read better?

Yes, yes it would. I think the current ordering is just a holdover
from earlier attempts at writing this function.

Thanks!

