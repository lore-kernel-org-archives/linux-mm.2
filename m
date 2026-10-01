Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7860DCA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3446B0096; Thu,  1 Oct 2026 04:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98B8D6B0098; Thu,  1 Oct 2026 04:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 879976B0099; Thu,  1 Oct 2026 04:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62A596B0096
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:02:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C7FA40328
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:02:32 +0000 (UTC)
X-FDA: 85273315344.18.82BE2C5
Received: from mail-wr2-f33.google.com (mail-wr2-f33.google.com [74.125.225.97])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D229A0006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:02:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aM+n4TRd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.97 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790841750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wFYgQFxyClJH+0q2sU9iXyjK0XmqVNpkJ48os8SONM=;
	b=7DP1zNNY7JZn4R+C4tJFRjdyTiYiimepEzGGu6wHqcKQufSXengIZuGC9crwBSr/Kzgjum
	E2KAHxRUbgoaKzkwGpXzjUIJgTdY/W2t+pCClgOyI9SG0jwUEAWFchPljqJEt9ggz2AnFb
	u04iONtdv4kgrFGTG4zJhEMRPXZpa8c=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aM+n4TRd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.97 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790841750;
	b=3dBQHOsOuWJKE2X8HqQUJRDoH7CNOaFf1tf5871Bi66ZSJcjWhJNnvL5YNDWlFxA7plf5q
	w3mLSbWDWzxkDJkn1vEwVoBEqORxf/fbsOyXdJh/JNty1bFQtx0+pGxB0cXubo3dbwQpet
	DyQRYkBxS0qeEegc9+IPhu5Ga0oOt+E=
Received: by mail-wr2-f33.google.com with SMTP id ffacd0b85a97d-48b024549a2so1151841f8f.3
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 01:02:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790841749; cv=none;
        d=google.com; s=arc-20260327;
        b=npRN0U5pH+ZEzf3hruOiluub48uPN9s3VH93MH8JaKTrQWQg4SWTvmNqEfaDsPILbE
         Wagh9NuQg1NikzCYKmT7CeP+hY8XAY7OyNdOumfM1mkm5SHo8cuaEZF5Bt7RiMxif7jM
         xRnANQxRgRqdrEwpRGDzEoAvN18owGwnsUY0DK/SMP3wb1O1VFVHqbQ0qWBdP2vZecC+
         TCIE6VHOBHhiXcTAXWoI3qwq4fIf+FtiYe+hpyYZR80D9AR/ynyoJIUk4IseqbGNjJJP
         ciq86vWSTFAXkTj6SvHgQ/pN4u3uTPTKIvb5Bo5tufbcO+r+0Dhcsn8znXS33hCy3363
         H8bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8wFYgQFxyClJH+0q2sU9iXyjK0XmqVNpkJ48os8SONM=;
        fh=/jZaevutFyFBV+CktKSqeRtyc0TzLJyoTBxXNNAzt68=;
        b=VFo8c0+O+piXGYUR2FRFw5aQTItmpzZkcbnWLVRHZf4b7W8+mJOhHpL3ZTZGA54fJK
         lkvcOpq0hggJdozEz6705TrSIiEcP1jJ9Pgt/S0FORoXzy0cNQnMfRyG0L4Jco4DaMd+
         oslwUNGYZ9Kvw690PA5jdXqPKbqFGQJZd9pQQCoODj4tgRb2a5EPxt0SvzyWQN8x4QZW
         mHtSrFcWbPmjfWFQBU8CabfZsaah9LTIUoeb7G/3RUyP54ROC0X5sUgCUZPadXx8u9TR
         TA1zTs3ejPBpucrDwQvoTo+YqxgwIW2QR5UEfdh3KIlxKn+Y178eh30jCDNR/m0V9MTW
         9e+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790841749; x=1791446549; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8wFYgQFxyClJH+0q2sU9iXyjK0XmqVNpkJ48os8SONM=;
        b=aM+n4TRdFVMz+/9SgbXI/kQJfdMx8Lwdt/o30vkllZqBrpnkimedYGUZAmk5qPUMK0
         zUAjpUoDzuTTFYN84bEC4HQzsp9ehBWNfPOgXpL1UW1XKpwlW/Dh0LiGawQ7GYEQpNee
         0mmH8f12ElE+qqsko0qMxccuBn/Nuqvw5ojR6uXksNzkFMjGiY5XlV9DN1HQ2hmUDtb7
         uMYseo03JDiURaw5TLazzw0Ti1hKoNAnmWRwK7EXdNP4htV+BRq2KM/K6TJwFMiv/wuE
         /hGUYdhcaRSlGwS32T2oMMXj4rvlM75lLJaALrI2i1L7CtWWtVJ2/8b8M70Qt4eJPIRQ
         fT2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790841749; x=1791446549;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8wFYgQFxyClJH+0q2sU9iXyjK0XmqVNpkJ48os8SONM=;
        b=PSK93dyylem29OKNmnMeNqrjtPjBBjonsRk2zI7qTDWB4ichNnAO1iUIRZB9uj5xrO
         jtYKZ+akUthbjXBz9KR6oUrTsFllmIj67VKER2KxSc8vLfWecTxenljxCFomZOg+yGsM
         GBjN7qbnlr5M/bSABjhshF5bBoyrs28otqb3Xs+Rkd/55BDkAx08yBCjeGGN7pNB2Vdm
         ndApgq010/ppXgjnQDQIv2gbxAKRh96Y9kuoSEOXdZqXzzklfF0sggqFkG6o/5vOJak6
         nqDoP1davNbGeRLTGoakzFsAdDpe7C+Xl3WwbSM07fOxujtaD+Za7Xbrl+R4oPAZZ8LA
         Fkgw==
X-Forwarded-Encrypted: i=1; AKwUvBzD0nu4CGbmc0lnrdlAhPEll9m/vIfsByk6RTpj3ivDktqVq9MTSmZ7MWu5OC+64RRNUnX3KbsZOw==@kvack.org
X-Gm-Message-State: AFuF++mk/eHSuK6ONY6MPqD0jpGXTW2oVWZi9F7sq4E9eJRfvOsY9SI8
	OQiRcnG5Nk9msd06A8yTd+k+Xyu9sIoeLDxBwOaPP0Dik6ir5aZ0RXTOFOedu3Gz7r+IJZYIC0R
	paCDxOG5A71L6W4E+nYXkeQGz6iFkF3A=
X-Gm-Gg: AYBFou0CtW6r1UOeQ9NEDHiKsjHncZgr7iT5LOlSMBc6CJE3cWSs3TD13LhKVrmowbo
	dollNdzc0PKjyiz5SvJn172eyHQCBJNFDjKyOSADTJKxE17huGieN5mT/mcrodyA2mkG8xfMANm
	9qjgJEcDL3Yf/PSfNEdZnfGz1JFuYejndVmZd2Bljul/Jcu11xCvg6oU4JrVsAy3+QViJCta2Am
	P+M/WMagWRYfhS2ewsnkgTu4JpVjeWpZEWLMOf9ZMai+G9Tnkqeaqm3IUMxp+Jp1wPHn7brhxDJ
	PUbVhQhUO9qJ3UD7IkXNiEDP1XFMM3ng0ujqbLAm6OvwAS1UdaWl1o6Z
X-Received: by 2002:a05:600c:3152:b0:49c:fc6e:8cbb with SMTP id
 5b1f17b1804b1-4a01b131631mr63017475e9.31.1790841748605; Thu, 01 Oct 2026
 01:02:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260923062832.479455-1-jiangwen6@xiaomi.com> <20260923062832.479455-8-jiangwen6@xiaomi.com>
 <ar0nuJ7ocTMgbiMu@milan>
In-Reply-To: <ar0nuJ7ocTMgbiMu@milan>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Thu, 1 Oct 2026 16:02:17 +0800
X-Gm-Features: AclHuK9TMMGS3_KK3AGC469G5gqBizlXQV9uB6i_baT8npA09Tvz5gZK4c--_ZU
Message-ID: <CAHKocdH-NeWYJBrCVfGctuDyh=D4a2YrzUf1VxB3cG7Di-EAMw@mail.gmail.com>
Subject: Re: [PATCH v9 07/10] mm/vmalloc: extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5D229A0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kfbfobmkteexacrwwwy8e4k3a4hh9qx1
X-HE-Tag: 1790841750-318882
X-HE-Meta: U2FsdGVkX18uN0aQTe3T+ycQh8BGiNXOhSEs8bBRyCTSUUzyb3sPW4kYz1KfOygeduXN6wQdLHGgFMpNXLQMZyPsqe4ZF9ZTypFa+NhB0XxgGVD9KHlF0wgWHLBVtxW5keKot+XsE+GXeyv9lI2y8j37cKoonHjDbDDXt6SAI4HU0UjmwL+HwmdAvyo0JyHIMhPtxopx0zV8XVYNdWKrB+GVbTSrEx/Hgb7fHbWGw4CGNMm2Catc9BYJexp6fDeTFXbhAPW5Bea0tn/QKBl8UdAg2ovsOK4BLCV4SGRvejecDKcj+szQINKj+uuXtkd8E6q8Wyqsi/twdE2pED57mn4BWZdwcmsk1sVFFcQyGi1F11lokyG6MRkgFDhF8ycMIC+J8+4DzNZepES4IGKCrT8x6v/PQ4pG6hAZOdKzkLVatPNdg1pIFRcMVRiOiXJJbt0WD1OfMI4d5pLWtfwqifiBJg+hEpZUWAhL8o6rEpmKs6N1G4ZjS8f1UKoOEptElk1+1zWW18GZ9cHkWYRhada9KNebGC6f8r+dUp6C8yhi+B4B78s8a4jnuGnOg0kzQry13fmsPI9FI99pNlNRNhbjzbDs0fI8zQ6y0j3Zce+Fp6V5bcfj4lNp7hmCDWlINrcz1Tl+YgKPr0ORBE/hrzCfdospgACDTpIfmzW5Bt2rn9Yc2DdVtgSS3cC/Xg4oJy8oQvNK1rssSedHfnxSIv0B/7ZUbajhzp2QryA9VFmP+bEcgtuTZiIzmYj/kSF8gjxFfcJddlr8PiuJkFjPy+CHCDG+Wz/uv38UmEMJwMCUpbOU4OnyMIhIEHCucL5ekYYb2ooTC+N5aWp2szdQSv+QMqU0t1mhYRkvMozC3vj6v+W5pWwM/tEkNJJ98ZRkBqIl5hT7/5HQmO5HXv6pnD2rTmPtrYj23iA+x8C7cfJeg7+S9Nh4TFwjzQJT4Jd5u9zonmUAqxsz1apHrlh
 ryRfKips
 5bL6EiVwtBgdtguux+K3vZigTP8emzH6IdVq9V3gqB1Pbfk9WR0X4YPGnu5Up1HWIrAVqoCXrj4iNJZOW10yIyJby+gkb27R21F3SU8yvogQ4+8SfqFqrbSRBxvaxDOIwR+P0VGGRGiOINgiqjVDUsm1VJGpIJntu0+xKg+nXFlHXaZcVzden+Y1eIDuOxnpzMPrd/PHYAprhACfqDA10YRAuylbg6tMNrEpvvlFDvwlwP737O8tK5gjmt+Ucbf1UlQeQNw8ngkLAOEvZaIAD73oTDXeqq7HU9GMhVHGR8K6pc6DS3vXlrp6r3TKuoQV60YSqhr/xhj+9Kblstn6FcI/dO0TkH6DXFqFskjtA5HxC5tJB66kBlBqyx6GWZ/mTTo4/pZb0e/C0VAAZAmUuGixOB1zKc4YBHpWf/JTAOc1A6ssvyjM8UGXE57hddGjvdL6OPwgcal695Sxstt41VLx77vt2W+vr0jlA7v3mr3kUyx/gNhg1zspLFxH85Su9c5yETwxnoA/svN6/Oi65FwfefB4Aj6Kf65mFq5mO5H3OBpu8qyTIGNk+xhbzymYmFquQEi7SiVS8LZPX3qDgUQnnJX22OK/8xN+d5rp4px3d6JlJvLu701ZJAyNG4WlS3Qox3+QZQoOIKa4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sept 2026 at 23:16, Uladzislau Rezki <urezki@gmail.com> wrote:
>
> On Wed, Sep 23, 2026 at 02:28:29PM +0800, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
> > provides a clean interface by taking struct page **pages and mapping them
> > via direct PTE iteration. This avoids the page table rewalk seen when
> > using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> >
> > Extend it to support larger page_shift values, and add PMD- and
> > contiguous-PTE mappings as well.
> >
> > Rename it to vmap_pages_range_noflush_walk() since it now handles
> > more than just small pages.
> >
> > For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
> > iterate over pages one by one via vmap_range_noflush(), which would
> > otherwise lead to page table rewalk. The code is now unified with the
> > PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > ---
> >  mm/vmalloc.c | 84 +++++++++++++++++++++++++++++++---------------------
> >  1 file changed, 50 insertions(+), 34 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index d475e52110e4a..6e0dec73107a7 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -558,8 +558,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
> >
> >  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
> >               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> > -             pgtbl_mod_mask *mask)
> > +             pgtbl_mod_mask *mask, unsigned int shift)
> >  {
> > +     unsigned long pfn, size;
> > +     unsigned int steps;
> >       int err = 0;
> >       pte_t *pte;
> >
> > @@ -590,9 +592,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
> >                       break;
> >               }
> >
> > -             set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> > -             (*nr)++;
> > -     } while (pte++, addr += PAGE_SIZE, addr != end);
> > +             pfn = page_to_pfn(page);
> > +             size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
> > +             steps = PFN_DOWN(size);
> > +     } while (pte += steps, *nr += steps, addr += size, addr != end);
> >
> nr_mapped_pages?
>

As noted in the patch 6 reply, I'll rename steps to nr_pages here as well.

> >
> >       lazy_mmu_mode_disable();
> >       *mask |= PGTBL_PTE_MODIFIED;
> > @@ -602,60 +605,88 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
> >
> >  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
> >               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> > -             pgtbl_mod_mask *mask)
> > +             pgtbl_mod_mask *mask, unsigned int shift)
> >  {
> >       pmd_t *pmd;
> >       unsigned long next;
> > +     int err;
> >
> >       pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
> >       if (!pmd)
> >               return -ENOMEM;
> >       do {
> >               next = pmd_addr_end(addr, end);
> > -             if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
> > -                     return -ENOMEM;
> > +
> > +             if (shift >= PMD_SHIFT) {
> > +                     struct page *page = pages[*nr];
> > +                     phys_addr_t phys_addr;
> > +
> > +                     if (WARN_ON(!page))
> > +                             return -ENOMEM;
> > +                     if (WARN_ON(!pfn_valid(page_to_pfn(page))))
> > +                             return -EINVAL;
> > +
> > +                     phys_addr = page_to_phys(page);
> > +
> > +                     if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot, shift)) {
> > +                             *mask |= PGTBL_PMD_MODIFIED;
> > +                             *nr += 1 << (PMD_SHIFT - PAGE_SHIFT);
> >
> *nr += 1 << (PMD_SHIFT - PAGE_SHIFT); --->  *nr += 1U << (PMD_SHIFT - PAGE_SHIFT);
> as it used to be?
>

Agreed, I'll use 1U.

> > +                             continue;
> > +                     }
> > +             }
> > +             err = vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift);
> > +             if (err)
> > +                     return err;
> >       } while (pmd++, addr = next, addr != end);
> >       return 0;
> >  }
> >
> >  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
> >               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> > -             pgtbl_mod_mask *mask)
> > +             pgtbl_mod_mask *mask, unsigned int shift)
> >  {
> >       pud_t *pud;
> >       unsigned long next;
> > +     int err;
> >
> >       pud = pud_alloc_track(&init_mm, p4d, addr, mask);
> >       if (!pud)
> >               return -ENOMEM;
> >       do {
> >               next = pud_addr_end(addr, end);
> > -             if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
> > -                     return -ENOMEM;
> > +             err = vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift);
> > +             if (err)
> > +                     return err;
> >       } while (pud++, addr = next, addr != end);
> >       return 0;
> >  }
> >
> >  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
> >               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> > -             pgtbl_mod_mask *mask)
> > +             pgtbl_mod_mask *mask, unsigned int shift)
> >  {
> >       p4d_t *p4d;
> >       unsigned long next;
> > +     int err;
> >
> >       p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
> >       if (!p4d)
> >               return -ENOMEM;
> >       do {
> >               next = p4d_addr_end(addr, end);
> > -             if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
> > -                     return -ENOMEM;
> > +             err = vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift);
> > +             if (err)
> > +                     return err;
> >       } while (p4d++, addr = next, addr != end);
> >       return 0;
> >  }
> >
> > -static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> > -             pgprot_t prot, struct page **pages)
> > +/*
> > + * It can take an array of pages which are not all contiguous, but it
> > + * may have contiguous chunks, as hinted by @shift.
> > + */
> > +static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
> > +             pgprot_t prot, struct page **pages, unsigned int shift)
> >  {
> >       unsigned long start = addr;
> >       pgd_t *pgd;
> > @@ -670,7 +701,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> >               next = pgd_addr_end(addr, end);
> >               if (pgd_bad(*pgd))
> >                       mask |= PGTBL_PGD_MODIFIED;
> > -             err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
> > +             err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
> >               if (err)
> >                       break;
> >       } while (pgd++, addr = next, addr != end);
> > @@ -693,27 +724,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> >  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >               pgprot_t prot, struct page **pages, unsigned int page_shift)
> >  {
> > -     unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> > -
> >       WARN_ON(page_shift < PAGE_SHIFT);
> >
> This is not about this patch but probably on that WARN_ON we should bail out
> early.
>

I'll send a separate cleanup patch changing it to:

        if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
                return -EINVAL;

Thanks,
Wen
> --
> Uladzislau Rezki

