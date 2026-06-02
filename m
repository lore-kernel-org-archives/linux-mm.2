Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD496C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25EDE6B03FA; Tue,  2 Jun 2026 03:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235F36B03FF; Tue,  2 Jun 2026 03:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14BD86B0401; Tue,  2 Jun 2026 03:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0473A6B03FA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:45:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A80011C206A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:45:16 +0000 (UTC)
X-FDA: 84834187032.09.B4F628F
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id B038D2000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:45:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jVzSWXF8;
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780386314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoOkMm4OeQAfjk4gTQ8GixghnDTp8Phdv+rBtxWQnF0=;
	b=Q1fBaikB6BexewoIDHkMIqzwxR1HV8gZT3Q49gW5rRc02Jhw3vhrp7kqJ/LIhmhnMOuRtO
	+ezd66dyrIpFeDPkaSy7IXe7I8qyvEXEUEODFolLGFw1oI7nMGIBGN/+yug77+YlQcS7xq
	3LQzIU9y2dvNRtsW/3psOsfTLvvy3J0=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jVzSWXF8;
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780386314;
	b=Id/b7Vg9ogXEIMudOFI3hI7BwcHyXTYTPG0xBRN2hDfAHHxWIUGtIrE1fm/QbnREJakaZp
	m035VXGFHDClKNinm1UDLcYqUaOuw9/K2zsozt7CfWHIE6ftHtrXNZxQKnwqEF2au9IXqr
	b3rMCAhQybd2xpNpPQnmZLeQxGGJQB0=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490b1bbcf3aso3413925e9.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 00:45:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780386313; cv=none;
        d=google.com; s=arc-20240605;
        b=L2RYPeoQbBH07AkgE7iIysKmPYg23FR5HzgqcwqC+UzM+DkYYTth7miT9RDEw34vzI
         3O1cMbMaa58m0mnr5sdKF4P3yOT6VxvjNVB/ZWNOgiy+L9uMYnL7XADbEb3WTJASrYar
         oAUutUbqSrtmFxC1MlHLOuSN4Ply5mMSCNxolL7J4PIZeVOUhucmq+ln2vg3fB24IhUE
         Srliax0OC5nRd4uYcD24abCwxxc5hUmRTfMwHetbvYJ+Qmc37BO0XHD/TLQmgu8R5SHA
         EMd21XuxaDOc8UOkf2s+DX6HkOuQFLCz4JgSGNGTB1jVite87MLFo40BQ+FGAG9buyr+
         XYNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eoOkMm4OeQAfjk4gTQ8GixghnDTp8Phdv+rBtxWQnF0=;
        fh=0pqm6OYUx7HeloWdyShp2IBf/zK3KGe3MfLGFDaAUww=;
        b=ArLib8TJKsSz3m5CfUxruPV6HRdAzquJtRGZle8XHFDKOJfUufrcDDfclCsM/p49Am
         suMeK4zj36NqytoWohxLOZD6lgpNn4l9G9F7d/DEn2QPnKsP7nn7On2EsKsKBKT9sh6J
         DvVlojA5MDUs3aGsz2m3ppr4Dry2rE0+M+ib00nkkjiYdy1LsLNptiOomp8ck0QZzyFA
         JGXM0Etce+RIExhr4OqZyIgMb7ExmHVE+kCrfZC7ymjJjO2X9aVmQNQxBYw7g9aF5d2+
         FqF4AhmLAOpPNlLKTPkACmYL73qOTMIHNONWB10rA11sViCPhOcvGNdhfmurb7JLV6UZ
         U20A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780386313; x=1780991113; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eoOkMm4OeQAfjk4gTQ8GixghnDTp8Phdv+rBtxWQnF0=;
        b=jVzSWXF8boYVih7qDZ3ml+JJHcrZjq1tuypXEfxRHKRI3LIr0VW+/pgK3TWuXxyZso
         1bOKi44JCA4bkX+BCiBTHExod/YhVcUkuZdRwTZhAXLmKs8IKSPUBhCtf9reAFZKQgb1
         riln+R8NFSiBCdOpvAoxmjDSXX0Hjb9kINdCl8RaYijByxn7plRfzmw1NhPEtHdUCsGh
         bAEC4flH1ZztwIK1WtWqpgfvzALp1aTXy9vxyOx2SoxUywvbLqk9u7LXCIHchc3oUrAK
         7zaUeTzlwKnlWoQWmZTF4NflXd9CW+vqILhmuCwu6RErA8xtRcmqPoSSgyE/qVBgcghz
         K1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780386313; x=1780991113;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eoOkMm4OeQAfjk4gTQ8GixghnDTp8Phdv+rBtxWQnF0=;
        b=LixVFAG/gAtwU+D5w+ojyXMeinYIUGSYkDi3v0bOAo2Ciz2El7qP6zU8DTNgXgtPHE
         oEBJR/hk3vAC+iRLrQNj3SvbCFR4T4OcJ33FcI7I90wutY06UmAScyhlkXWu6eDKhUwI
         bvwSLV7oSCG5BKPzbq87XvQP6VCLekqIaU/YasWZzyzzkTbSXINA52yHTRt93MMJF93o
         nmc82cfjNNRBCDlAk914CeQcLck3+FmNQ4PNxg9zcn2nhx3DepuJSqD+/e4jMghO44UH
         xnwIyGfRFRpvNGf5LajlXl3ZffYg+h7dQrgAaELrVgFlwy6OLh3B9pwZ7W+Bee81QGoN
         vN4w==
X-Gm-Message-State: AOJu0YyIsBSwFZz9y0N5JyNLwtIxzSc44caAFmpf85ZSQxGVByzb68YQ
	3hXbRNvgccHNdEYAIZBpZ2cPSs6gL4N/buSKZCBquSWGmCct4rXFQfea4c/KLCT8CMPQ53pDyKY
	jxvAiIW+muUWrihaWD9CDJyl3lZPVjc0=
X-Gm-Gg: Acq92OHXzNSfj0awoI3fa4FugJDHi8MGTdhyeHA7Ez2LDYR2OLcN0m9x88LJOeJ4TNh
	Y4k1ZfvCEfuHwpVKErOtWveouYY+t2K711w8eSWvWEGnEqgQ/mP5hEqNZGBWm6gAF+klbVhqBWh
	oTei5y511WA1wHUTAhO+6RfAJq3xEzzgt4kwwIOqjKi7aNRSjAkNe3PXPL7OhR+5lVFAw4dcoe1
	INIlmj8aXmH3l6V4OdZ2j24mqcz3ZC/qWI6AxrWDALaY3PA0+/kg7CuEr+iIWNT7kMArtyDj8tU
	dTTSTajBZynt15VL9t8=
X-Received: by 2002:a05:600d:6446:10b0:48f:eb8b:997a with SMTP id
 5b1f17b1804b1-490a2965784mr191160295e9.31.1780386313064; Tue, 02 Jun 2026
 00:45:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-4-jiangwenxiaomi@gmail.com> <ah3Cn3YnefIVJDo2@milan>
In-Reply-To: <ah3Cn3YnefIVJDo2@milan>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Tue, 2 Jun 2026 15:45:01 +0800
X-Gm-Features: AVHnY4LHIiZAvO6g2wLLYc8-PfJq3HI0lmGYLHd8htw04EtCN26_I2MET48q0q4
Message-ID: <CAHKocdGjD1Fmq9sE-Q4o-_KLz8qv5tXRXRaAZN3Ktw7YdA3+Dw@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] mm/vmalloc: Extract vmap_set_ptes() to consolidate
 PTE mapping logic
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	baohua@kernel.org, Xueyuan.chen21@gmail.com, dev.jain@arm.com, 
	rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
	jiangwen6@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B038D2000D
X-Stat-Signature: hte3fjujjwfk76s7hasd1u1puzf83zf9
X-Rspam-User: 
X-HE-Tag: 1780386314-946419
X-HE-Meta: U2FsdGVkX19mZF61JGnusiAoYICf6kgjOybmSa64/C7anFH+6FUFBvr5Yed8P5Ng7q3elgIF4/gwealiUpdlt5vG5MD5SiFMDgw4wu5FzUwI1Up4FgER6e9FT9r7tmZNbfLUJJREv6VgbMxmMifixIe56KB9R0OrL8SyMMaFxYt02rnKLvDS6L5caBMJwCCcs2dRt4GKhlyh7pRjUktDfZILHB1ZypxwKIukUJezRjuspak7rSMhPZPqCkGB6GUY5ptXiZtBm7ZuV1tPIGNiikdK1WjDI+1iixPBAur6UEGdEdiSRqCbeOWaxKyWRSioM19YDjF+Mgd2w70m9lRF8Ox5QEnOVOFFazmZqLM9YRXtrQSPCEs8qgkP1BVXz5hkvFtN/4AS3pG55LjGN0gOvuvLLPrs8HQ2TBC01xaBDwXPLuy6mHwlyrpbHXX0p0b0VBJ340lpqHcih2IE66NgqEeOHk5Fbp7FnKd5huuo2UeFbBQA3LppxK6XuU9ileaBGtFSFm21EkKH+eB5S+f9BxVdGo37w0ubD1FNXEoYxTtpt2wDh7Ot8Y0n20viTR5c9tiuGNBQo6uVMFKzoiGU4dpu+tcPYtU9RbYYmPmg0uNOUdG47+4pX3co5y5FTk4IPpC+e8IqbhSvwc0BHOd6MiVuTKvKOml/IEE+ldRjFmRHXwUvC9MIogOKcVacqmQfAPAVFLf+Kmm7++8kLueALRM+lQh8q2OsHA9xGc2kl5KDy482Zbg5mReLQ9EY5/fugr7/50tFfYoTkvS4NktPmMGtkm3Ur3f8sekNFVmG2/kLeilx9iiFB+FSJd0Pii5e81bZquMVH8Dgos2H8I6J2rfbzFS0dJeQWBilkkxEzzWYckbL6xXgRcAYEbnBI3B55XE/RrBBVRG/2yZ2bd22J9Aac7erKlQfoLoiG8C+j7DeR24XYEBugtWzLVf04BQqPvQwoVlWANq7tJjYswX
 O5wXpedb
 A49gR20qUk56YsDKbk0WO0LthvvhZAfxilM243VL6Jh7kqayTI6bB7TMf4vnJQb+vej1W4JM4vVc0P2HRuGv//eAUQxBUsH7g8FdwT+XXYGmNEf4BZgTUJyBkwJQiyrJkXNgWo3/NxEnFN3TrTGc2RjUIyWGUVfo3YXR8HVGHOAXjOfVycn1B4OZdKrr67kKq5m/JFw7jirA07BLStAqk4ojJorZAjFTw3yMe85ABVpEb8d7yPp6X/A7cYRN0uXBNU6xqPeTohmwTCleB41fzFrbmbBJ/EJXnGPWhCGqUXkpQUZwECv55i0WwZCSWEXf0d4AB6xcaK+zbyK4j3FzNxB+jWRMygOZfK3iMA6QnN4Q0+Lslc47iKBIZ0XzFZuDU3QpMZ6y0SJNcfvuDdfH7cGhqUYyqaaYT21JU/KEl8093cJPj7/9mQ5ba6kpPTYH0v+SuBkcLw/UXDXm+1je8ujsGaq10uObP48uSdy7L0Hrz1Vvac9VxjJ69BCqf6Q7LWt5WE4G0CEC0SuHIU3fA64Fryxf9FH+ty2GOvT+4iKn2jTN1IL/NavRUMBrnA/Fg5SGR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Jun 2026 at 01:34, Uladzislau Rezki <urezki@gmail.com> wrote:
>
> On Fri, May 22, 2026 at 01:31:43PM +0800, Wen Jiang wrote:
> > Extract the common PTE mapping logic from vmap_pte_range() into a
> > shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
> > PTE mappings in a single function, preparing for the next patch which
> > will extend vmap_pages_pte_range() to also use this helper.
> >
> > The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(),
> > so callers no longer need to handle the conditional compilation.
> >
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  mm/vmalloc.c | 49 ++++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 34 insertions(+), 15 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 2c2f74a07f396..53fd4ee460ea4 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -91,6 +91,35 @@ struct vfree_deferred {
> >  static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
> >
> >  /*** Page table manipulation functions ***/
> > +
> > +/*
> > + * Set PTE mappings for the given PFN. Try CONT_PTE mappings first when
> > + * supported, otherwise fall back to PAGE_SIZE mappings.
> > + *
> > + * Return: mapping size.
> > + */
> > +static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
> > +             unsigned long addr, unsigned long end, u64 pfn,
> > +             pgprot_t prot, unsigned int max_page_shift)
> > +{
> > +#ifdef CONFIG_HUGETLB_PAGE
> > +     if (max_page_shift > PAGE_SHIFT) {
> > +             unsigned long size;
> > +
> > +             size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> > +             if (size != PAGE_SIZE) {
> > +                     pte_t entry = pfn_pte(pfn, prot);
> > +
> > +                     entry = arch_make_huge_pte(entry, ilog2(size), 0);
> > +                     set_huge_pte_at(&init_mm, addr, pte, entry, size);
> > +                     return size;
> > +             }
> > +     }
> > +#endif
> > +     set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> > +     return PAGE_SIZE;
> > +}
> > +
> >  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >                       phys_addr_t phys_addr, pgprot_t prot,
> >                       unsigned int max_page_shift, pgtbl_mod_mask *mask)
> > @@ -98,7 +127,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >       pte_t *pte;
> >       u64 pfn;
> >       struct page *page;
> > -     unsigned long size = PAGE_SIZE;
> > +     unsigned long size;
> > +     unsigned int steps;
> >
> >       if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> >               return -EINVAL;
> > @@ -119,20 +149,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >                       BUG();
> >               }
> >
> > -#ifdef CONFIG_HUGETLB_PAGE
> > -             size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> > -             if (size != PAGE_SIZE) {
> > -                     pte_t entry = pfn_pte(pfn, prot);
> > -
> > -                     entry = arch_make_huge_pte(entry, ilog2(size), 0);
> > -                     set_huge_pte_at(&init_mm, addr, pte, entry, size);
> > -                     pfn += PFN_DOWN(size);
> > -                     continue;
> > -             }
> > -#endif
> > -             set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> > -             pfn++;
> > -     } while (pte += PFN_DOWN(size), addr += size, addr != end);
> > +             size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> > +             steps = PFN_DOWN(size);
> > +     } while (pte += steps, pfn += steps, addr += size, addr != end);
> >
> >       lazy_mmu_mode_disable();
> >       *mask |= PGTBL_PTE_MODIFIED;
> > --
> > 2.34.1
> >
> IMO, we should add just a helper with "no functional change" and second
> patch will extend it.
>
> Otherwise you added a helper which has already been slightly modified.
>
> --
> Uladzislau Rezki

Make sense, will split it, the steps/loops refactoring will move into patch 4.

Thanks,
Wen

