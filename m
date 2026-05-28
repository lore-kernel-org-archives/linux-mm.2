Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F2BCD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 03:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD60A6B0005; Wed, 27 May 2026 23:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD926B0088; Wed, 27 May 2026 23:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B886B008A; Wed, 27 May 2026 23:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96CF66B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:40:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35AD08FE0E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:40:05 +0000 (UTC)
X-FDA: 84815425170.07.114371D
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 41699180005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:40:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gXIFaena;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779939603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8eCXBGOd5t/87xeLw45c9cWsz3mamZ+scLdG/p0E2Q=;
	b=EuKmeiwJk+8OU7NUBuYGcCxJf6IAZuqMtuwX+/mfNUrQZhvtq/LPmgRMc0pHZ/cZmyWtDU
	quHoxdMcHdCaD+OIftLQ7T0RDKg/Dnc4C2hrwRShSl2jdbVgpAPcUVaIBb4KD56Upmq06Q
	8U0RRGFFGxvZoxqidiRflaKlpL5kWDo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779939603; a=rsa-sha256;
	cv=pass;
	b=pKKYorsk2crAG6uCs97KPvQ/2jZZ/2Xb9hMMBx8/zA1Zz2WWALZUUM1H8j8c6dRie1EpiE
	CjrsgHEAfyrV4u2TGsjmTCTf/D/dsnPkg9OUrJPpjtYEfHJsl4l2BNrkNBgoJIQmzx4e8l
	O9OarxsmLtn+AUTyQePuY7pC2KRYijY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gXIFaena;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-44e1860558fso7757839f8f.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 20:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779939602; cv=none;
        d=google.com; s=arc-20240605;
        b=hVC7ySF/2KAffnkKrNyLoLny4ahWm5QkWFB3h1l2UGPV/Kq1Y1ZeYs0NgSyDFUJBWj
         CbMgk11ItF3+DlUzZG1dV3TWjsyK3vpXGwegkyzS+WDZsh0kZPLoFm6qvIhyfl/4E9vn
         JPCyT0eZrmDHEG1YkH1g/WJTgYyVL15kbZ9ox2WOlQNLxBGVatvDh8FP4tDmzKqVl9bd
         ZyIP4Rt28hCySRjAbiRY0BG6j7mM66VxHhR5FQw4XJP3EZ35qSjco629Ldn7CYlOOd76
         1u3ycrHscCPLlxOCRTcuC8vSwlOd/SkNp69LLmGC/h65JG/hU1V/5EjMg26uxg+9J6S7
         xa1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e8eCXBGOd5t/87xeLw45c9cWsz3mamZ+scLdG/p0E2Q=;
        fh=C8b6lZPtrB2LD7MBO+6F3n+PqcmJOfb95NDq1lhAU2o=;
        b=P++4/Gk9XuBYzu9+1utLgvAckCX2uRmlmlFtFgwevL583XKGR+NhL3Nyi8we00H7/i
         SjTBmQJU4bKzVkgXUT3fLx/s/i7jGcdlck/RrV7c7FlEGPdWucki1xwoFQRcHkfZpCy3
         Z9u7GW+YYdrr9Fk0a7xZgMhGqr7LVfHWvo8pEuhV7NA2ALZQzZ2uqXgCbQ2zzWZt2GTo
         XAo+Sp/fCqfLUSMy+Pkryx15kimEvtWaLEYkDwZO8GpHWmlBuWxw4YmYWFGe9RsJTZ/C
         +fBrlA6/ieem30XQDTbjf3jMWt8V3JY5KJJKA13LLRe6YR0Yn+8NZPFCSiDSNJ/URmyK
         UfrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779939602; x=1780544402; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e8eCXBGOd5t/87xeLw45c9cWsz3mamZ+scLdG/p0E2Q=;
        b=gXIFaena/t3bmlH6paoMxQHlFPFdmXbVHUv83+aIWFc3BEVFAgqPUSvT1OSj2veVyv
         dV0Zm/aK+opVVCqiHYL3Q6KaI2Hm8TfS6XefqwVprD5+owkEwVVcPSOXmRjpNzZkASgg
         UwsFyFD/7F16l7eE8sTInx9ud1B7ZuzlkqB3Kjqqd9uYM9uFdXAux7pgBuFdS091UmzJ
         e7KMbrq2M5NCYJ7BdymW5Z1xrEfC1WaSuAFcikLqrK9/eZArjgezUqmk4l/jRw8CKSYk
         3V57v3jsuQ3ljUhC2TLWmFtj+NU4Nt6t8JbJVMOtTKxjOABT2Yi+Ugg4LNHThwbe7dUs
         ZUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779939602; x=1780544402;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8eCXBGOd5t/87xeLw45c9cWsz3mamZ+scLdG/p0E2Q=;
        b=A1BLxgYTFQHttzKNWfsMhu057hexVtT8ka0uMie/iunYNCXq+Z0jwZpmaVE+SBoDxU
         2K2/0KT/rYrZ2n1kMk/mTq0s5dc5Vx2bceUYM2sjMtloQ18iQcKIWZanV6QmUfpsDf8Y
         lxrjp6HPhbpzlYHWTLVN7dTtdf5SOrt2q4gxW5/wAxvVddHgoeOlbyn9KwlQT4oB5Jmc
         sY4VRLMfmvb45sw2S9ma2BVhvv9u+UNUJTLQoe+EV0f6d9aa8IrCSr52vRHFbxzScGAj
         JbV+mOnpqmJ1lk58TKr2WsCi1BlXiXONdIbk7wfw5j5rCwoMukjlHKfQHbGVP9ojZM5C
         z1/A==
X-Gm-Message-State: AOJu0Yx0K1F/3uUVg7unQveiMcUiQugLVHKrAeH8uMq+6yx40DciCMX3
	vJaIikyEUZRviyTyiipXhQssW5+z8O3BQhj+hChUDCUixNidNvGbjDdQkS5LnxoFjaxYqyPhv0e
	Eu/IHoXtQcfhITF74Qv2iHEOXhgRWPNE=
X-Gm-Gg: Acq92OE/8WKSgBDHwPb+n57YGBSXTJYddkRN0IQD4xYEs6Nkjqg8cLMpg3J2FulDP42
	vXsucKDGtY1Gix3robVLK9D4LSx/mBIS8ree2Gkqy6SJIekVv9MAqsCuKwTCbOM7Ysm0/yVrGXw
	SYOPSauSa38aa2ltDG447KpxqMCsp0XrejKtrb69Vm9mUKFwSIC7UixG5mr3GYe4bWytEpOmAIe
	4jELmxmhZFdrdbqHnNU9p7GH4zL3Og+YFATOiO8NLEd5xSe3KvkxwqcsBPHN10DEO0g95IVzzrC
	pv+Na3OjdFrJNpOzoCI=
X-Received: by 2002:a05:6000:381:b0:455:4695:92d9 with SMTP id
 ffacd0b85a97d-45eb38a1c99mr44878903f8f.12.1779939601332; Wed, 27 May 2026
 20:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-5-jiangwenxiaomi@gmail.com> <46b0f2a7-3c0d-4372-a45d-946d8259d410@arm.com>
In-Reply-To: <46b0f2a7-3c0d-4372-a45d-946d8259d410@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Thu, 28 May 2026 11:39:49 +0800
X-Gm-Features: AVHnY4LR2gQ0CgXcwQN4_k_NUidEbLIum6ra-k-G0pa908sECZJ3chvNoXL5qT0
Message-ID: <CAHKocdEfX3dgUr3O6q1WOe4PddN2=LKfX6Y5DfrfTwF9MM5J3w@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com, 
	rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
	jiangwen6@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 41699180005
X-Stat-Signature: wufcdu61q3ty1j8mgc653d45sukh6yp6
X-Rspamd-Server: rspam06
X-HE-Tag: 1779939603-949034
X-HE-Meta: U2FsdGVkX18ElEaNbO/xBrYTz3QotR71QbpIPISLgKW6BXCjkL/5XHJhUW3RWs/h26KJ/fv1PTBh+/qNoxlSgKEtPaITnkUbwGPkCa9inBV3SRcDBSO8WGAHVmTkHkm8/Ss0uLLyWML6Chl6CKZ2m4LfO2egQIIegL58qQ5I3rXcUVfivNhlUEMTMLRSLCv20tKJdLxw0yCXYNMZs0rQLiUjyFjQQ37dlVqUUHfZs06qoG2ST+9TGa9tzw4OMlCOzSZSDpNhEY/fJfewuKVqmwUTOoN/NojXUzsdfUzO4jEjWmNxeaEJp4ioAIG9KgicMrGW7IDK8w84cfdh7l5HenjoNrSKnaaTWbZ9grWSfI+C7c/j0qc4l1Zjt82/j32GjCLxSZe24gf33mdJQJgBhLLD+F3T8NSBzhebXU+6Vb4x32Ndqj8OKie4FLLsZq8sqL1Ib9sKqrJSkKyHN+/g+YzMaNN0fwv0vjbHgrvmdzDN6Ao7eRE7PKY/QKLqj38zQiP1B3gmBBnkL2B2I/Gd0zTqdVHCUAwJP43RGQ+O4Mgy/1Kb//lLIFPkL5PAwKHhRn+2J+j5c4CSWGQfPDv5to32V6u3R5Em2s1rx2o1R3odIxuL220XpWw1wBAzufQ0EA7kYv43o6NNnfAPndXons14tKhyAVoydD+ONeSJrWFfIMNT6rzDdHSjncF27KFxNhU3lmSgMnAoAvmMvWZ+fCOmfG2Uks7kempAq5UqjKWTUMjvQph8sRhzFeSJxkG3s2uc3WGoIrsFOYAZxRbUOEGm6clJvXqBRBfYzWi5DG7RX2jA4nZg2yZfWJ2bedXav/R0ClkoPn6FN+V36nfJmXdtVYU7g5lNS6lkFrQ4bCtQbOehKPqMdlptVOP9lv0IF1k0ooYRmRL7QHcxo5hC9DlPf8FD2CC/l3aRQTIilyQrRydDWxZHkA3ooXzMICPmgE+VdF4alD1GQluhpNa
 DUrIBgtD
 VeogyOaCMcCAJN/gnP2fqkDCdoaWFd/MnQ1qXIUARQN+V75yaGDbf6bslu2hYmUssgh6knBqFfRhqfN0HbExE+3Ba8XlDFeCx0u6CB0ifN30EyU0RWb28GORSozDJDPNdesXERTbZvyMD6aG5zbGLoyaHKCbXPopBQQAilUeZ/V5PDZe+kWIkzKUotr8qvapiqwHsol0Y6ZkHRdh3Sfe1MR8BgtRQXTJdsqxux+2YffAqDODaK/hjcOiwqCJWhhX06/B/gDSmtyDI1qT6hKYj94kYFL+6WeyWPOib8nEDKhQV8E/X5qbET10j6CVKa99j8lmNPSn6p1587ljnis3f66ck7fdDy5hfd+tcAeR7fA0ANKHfa2vkXTGXKwpLDV7oFB2x251J0J90yEFQnlqnYIPBp8jXLt7YKy1elpT71XctiZH+ljI/udwT4JtJs3cWWCF0sdcP406okGVn3WmX1Wjx6jEzUWHxCrUSV93dcCdvLoA7gyeePx/seymdRfqAMfGObdZ/OuqxOc2w7kP3yaodznsFSVGCUHy5vv2ajoyk47GpLacP74y21I6t44lQR+PGgsAXYYsO7SJ/0oNPORmxap+daUx8xMPsaeGJaZOTyUkZx61h2Q5x6loX9pXI72E+WExu5u9GyOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 at 13:59, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 22/05/26 11:01 am, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>
> vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
> provides a clean interface by taking struct page **pages and mapping them
> via direct PTE iteration. This avoids the page table rewalk seen when
> using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
>
> Extend it to support larger page_shift values, and add PMD- and
> contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
> since it now handles more than just small pages.
>
> For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
> iterate over pages one by one via vmap_range_noflush(), which would
> otherwise lead to page table rewalk. The code is now unified with the
> PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 71 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 40 insertions(+), 31 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 53fd4ee460ea4..deb764abc0571 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -543,8 +543,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
>
>  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -             pgtbl_mod_mask *mask)
> +             pgtbl_mod_mask *mask, unsigned int shift)
>  {
> +     unsigned long pfn, size;
> +     unsigned int steps;
>       int err = 0;
>       pte_t *pte;
>
> @@ -575,9 +577,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>                       break;
>               }
>
> -             set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> -             (*nr)++;
> -     } while (pte++, addr += PAGE_SIZE, addr != end);
> +             pfn = page_to_pfn(page);
> +             size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
> +             steps = PFN_DOWN(size);
> +     } while (pte += steps, *nr += steps, addr += size, addr != end);
>
>       lazy_mmu_mode_disable();
>       *mask |= PGTBL_PTE_MODIFIED;
> @@ -587,7 +590,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
>
>  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> -             pgtbl_mod_mask *mask)
> +             pgtbl_mod_mask *mask, unsigned int shift)
>  {
>       pmd_t *pmd;
>       unsigned long next;
> > @@ -597,7 +600,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
> >               return -ENOMEM;
> >       do {
> >               next = pmd_addr_end(addr, end);
> > -             if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
> > +
> > +             if (shift == PMD_SHIFT) {
> > +                     struct page *page = pages[*nr];
> > +                     phys_addr_t phys_addr;
> > +
> > +                     if (WARN_ON(!page))
> > +                             return -ENOMEM;
> > +                     if (WARN_ON(!pfn_valid(page_to_pfn(page))))
> > +                             return -EINVAL;
>
>
> So I know these !page and !pfn_valid checks have been copied from vmap_pages_pte_range,
> but do they mean anything?
>
> I think pfn_valid() makes sense in that someone may take a random VA/PA, convert it into a struct
> page and pass to vmap layer. But I don't see how anyone would pass page == NULL? At the
> very least, returning ENOMEM does not make sense because the pages are not being
> allocated by vmap() but have already been allocated.

Hi Dev,

vmap() is EXPORT_SYMBOL with many callers across drivers, each
constructing the pages array differently. The !page check guards
against malformed arrays at this API boundary.

The same -ENOMEM issue also exists in vmap_pages_pte_range().
Should I fix both in this patchset or leave it as a separate cleanup?

>
> > +
> > +                     phys_addr = page_to_phys(page);
> > +
> > +                     if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
> > +                                             shift)) {
> > +                             *mask |= PGTBL_PMD_MODIFIED;
> > +                             *nr += 1 << (shift - PAGE_SHIFT);
> > +                             continue;
> > +                     }
> > +             }
> > +
> > +             if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
> >                       return -ENOMEM;
> >       } while (pmd++, addr = next, addr != end);
> >       return 0;
> > @@ -605,7 +628,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
> >
> >  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
> >               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> > -             pgtbl_mod_mask *mask)
> > +             pgtbl_mod_mask *mask, unsigned int shift)
> >  {
> >       pud_t *pud;
> >       unsigned long next;
> > @@ -615,7 +638,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
> >               return -ENOMEM;
> >       do {
> >               next = pud_addr_end(addr, end);
> > -             if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
> > +             if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
> >                       return -ENOMEM;
> >       } while (pud++, addr = next, addr != end);
> >       return 0;
> > @@ -623,7 +646,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
> >
> >  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
> >               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> > -             pgtbl_mod_mask *mask)
> > +             pgtbl_mod_mask *mask, unsigned int shift)
> >  {
> >       p4d_t *p4d;
> >       unsigned long next;
> > @@ -633,14 +656,14 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
> >               return -ENOMEM;
> >       do {
> >               next = p4d_addr_end(addr, end);
> > -             if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
> > +             if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift))
> >                       return -ENOMEM;
> >       } while (p4d++, addr = next, addr != end);
> >       return 0;
> >  }
> >
> > -static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> > -             pgprot_t prot, struct page **pages)
> > +static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
> > +             pgprot_t prot, struct page **pages, unsigned int shift)
> >  {
> >       unsigned long start = addr;
> >       pgd_t *pgd;
> > @@ -655,7 +678,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> >               next = pgd_addr_end(addr, end);
> >               if (pgd_bad(*pgd))
> >                       mask |= PGTBL_PGD_MODIFIED;
> > -             err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
> > +             err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
> >               if (err)
> >                       break;
> >       } while (pgd++, addr = next, addr != end);
> > @@ -678,27 +701,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> >  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >               pgprot_t prot, struct page **pages, unsigned int page_shift)
> >  {
> > -     unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> > -
> >       WARN_ON(page_shift < PAGE_SHIFT);
> >
> > -     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > -                     page_shift == PAGE_SHIFT)
> > -             return vmap_small_pages_range_noflush(addr, end, prot, pages);
> > +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
> > +             page_shift = PAGE_SHIFT;
> >
> > -     for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> > -             int err;
> > -
> > -             err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> > -                                     page_to_phys(pages[i]), prot,
> > -                                     page_shift);
> > -             if (err)
> > -                     return err;
> > -
> > -             addr += 1UL << page_shift;
> > -     }
> > -
> > -     return 0;
> > +     return vmap_pages_range_noflush_walk(addr, end, prot, pages,
> > +                     min(page_shift, PMD_SHIFT));
>
>
> We can easily extend to PUD huge mappings right? Not sure whether we
> should keep everything symmetric to how vmap_range_noflush() operates
> right now, since P4D mappings don't exist, but PUD looks worthwhile.
>

PUD mapping requires 1GB of contiguous physical memory, but the buddy
allocator's MAX_PAGE_ORDER is 10 (4MB on 4K pages). So page_shift
passed to vmap_pages_range_noflush_walk() never exceeds PMD_SHIFT.

Thanks,
Wen
> >  }
> >
> >  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>

