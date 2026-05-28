Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61AC6CD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 03:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75FA6B0005; Wed, 27 May 2026 23:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25A36B0088; Wed, 27 May 2026 23:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14DF6B008A; Wed, 27 May 2026 23:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F75F6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:42:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E9981C1D32
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:42:21 +0000 (UTC)
X-FDA: 84815430882.18.48850D5
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 549B34000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:42:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vh8nyLvo;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779939739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCjNWcFWR6sJCprx1waql78UPwtAbOc2aIj3hPZm7SU=;
	b=0pEkHDRQ7w+88WPaWkik1n+FCb6XK9Jb7PRDPhZU4GJrlKJjdX6bQ+BMto8Nt300GIEV7M
	49drbPSUfv2+XnIQ/Jj3jt957h/ofSwr7klLK7JcW/bMUDal0V3G3SsD8oZjQazlyydd9O
	LhwodjFbpWjb2iePlG4xEZzWCDss/gs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vh8nyLvo;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779939739; a=rsa-sha256;
	cv=pass;
	b=RXwbKzoiBxBTfEVCufMS6tbWxwwed7RNktFmm/A28PuSgcjNPALlwkdPO1zJG1evQO8hQu
	irWvv9ZJ/aMk3TnCHzmgrbwT995DzNX2aY61Kdgyn6XEleA5rQCxc4ottzGTNEnZjzW2uy
	yLavV0jVedbisA0oGm8bKpGXyjNGPLU=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45edc09f51bso850251f8f.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779939738; cv=none;
        d=google.com; s=arc-20240605;
        b=k3pylBbU4gr1oRf9u2Z5gytqSz3NssmkJSYQMF7I6gOrz6J/IiEF1HID2uu49o98M7
         RQi6rrIbK8r5G00kOB+G/CeQ7Ls2bM0mxhi199EIL6/HyXPpCP5SzDtL4eQPDnnpAyjK
         0j/SzEW0AyDYcw/RijONtcBJ7bdVPE0/UHn2Xm6+g/Nk9Dh/aS/RV4SNpcmnPSyQ7MPS
         nvcLvBoDKDGA5fxK+p62c4qtyQhzZxHhVJ4ZwOQFTYOUx4JD0e0lLSK2qpJ3s9bJ72gF
         aAkDjjoEsLX+tM7HAIPZHrJnKBVWMEsKr654zjlQSrjsAmw7POExaBf7Sqy6RAZL31EJ
         sIqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mCjNWcFWR6sJCprx1waql78UPwtAbOc2aIj3hPZm7SU=;
        fh=C8b6lZPtrB2LD7MBO+6F3n+PqcmJOfb95NDq1lhAU2o=;
        b=PM/oxQFJNPi/x73545b5XvT10ckH3riTO2lKSOFdobxaGxbZKMZC+PRkXTq4Ln4nTo
         XJJ5cl0EEOrn2fap8C+uQaVpJOiRQ1JSL7N/R8lRkyCuoSR1g5T1DpGrgO2MVCBjUBfP
         vQCUL1CGvGWY3w5HYZ4v8rP4+v92DAJtkTSyFzCgvyno4N6A+la5awrjNVqRC8rSjDgn
         Jo4QHTWQ4nrwOQbQIRqa9gwQHLjjZCZqSphYwo01kMGZtBELENeM9K8MRdn4ZvwbNvi9
         OEuhdWJqPjs/Pxs1oJLMUbacmdz2yBrVtfyYC6yAEzmGVlxuPuE9db166Y4rKUgtfnU/
         hc2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779939738; x=1780544538; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCjNWcFWR6sJCprx1waql78UPwtAbOc2aIj3hPZm7SU=;
        b=Vh8nyLvolZrVNpoJ3vBDP10p1iWQOMbErWaUUfYAyQvjiH2jWjToLs6Uo0ObWPQTNd
         STkon+NlnAoykbaOn4KyTEcpFXsZvGCh6WBJCLuFJktbpqT46/uwW4cyug+SKkKrSWGi
         9FqrjREoBFcJWvdxGmw1fXhXSOGmg7DnRH8U7MV9gvsDUsso84P2ODo4eJmj9n+mB94i
         ZQ/h7WZcY39RM/9llX8gOThEWUCqftntO9qz/HtsUPFKvFpXEjOCFfsIS9pJJewRPmfA
         bP3Ft8yj9+rs7oZvjTe6C7I7GkHLqN09SaXkFRkzd+m9eeU666DvPu3BWnV5vNs87qfn
         jPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779939738; x=1780544538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mCjNWcFWR6sJCprx1waql78UPwtAbOc2aIj3hPZm7SU=;
        b=Rlf98wwG5+e8a0M6mumnga7G5yzZCJBKmyzSq2+1DaJNsg+liwQwFTJ7uadcNFsRjv
         jcoK6cccnaOQXuyqVsoRqHanLMtexP0uLIBlnxB+AdLe+BX53MFPsqyd+oHcE0ymLjyQ
         pAuSevl23M9WBJ3Ys0ll0hDUmRSWtX+Oxzhh4u/4YNEO4NhJG/qAWKgd+STPhYzAg0c9
         l40Khk0dWVJoZhKNMhA+9PQQH8VjT1iJMk61UvvE9dksVEND/A9Hck9prRn8JmqhVNAi
         acshkGgiCcn2WSyTbCWzSRoQzRRqRpVYCuFuLqXlKP48UVwKA134ZxZrr/NudMa/Xng5
         IfJQ==
X-Gm-Message-State: AOJu0YzlvyMSZhPsXG7JrGGzjvNoz/aSsBNUJbO0EiYyD46AMcl7MJqq
	UpxNNSIq/i8UbNTaaEo3Gle58o9ES/VOOq92jvOHRv5x7+AUQeCMpb+43yiWFzQPlULCWap62wT
	AUfO85dzXALFGXyxLJ8OeH5KLHKaDuWo=
X-Gm-Gg: Acq92OGGBNxraYzbpgb0wskdKdmkRgbFRKvD5IWgwgkBqjPQjyH5LS2AM+VKyFw2J5h
	Gzh7qEIUJlBVk0kaOrXECCO1jq64np4PIQjg7QSej2KOH/zcpE+JfNha1GRS3876P8q70JzcITK
	lI7EBsTPeqGDNNaI4WtT2w9C5E3+Zzm8ay97GSQpYr/iRMGywrJxyc1vNFrdLv8HreLkSu476h5
	Jr7F0IuDGQbe1d5V/23Jto1qH181h67qzMAZKKEiR66/eXRjQTajmYYMqdvC3BBsoHv8AV6ysR5
	u7A+Uj8ACA+KJIqNTP0=
X-Received: by 2002:a05:6000:2992:20b0:45e:c786:5cd4 with SMTP id
 ffacd0b85a97d-45ec7865d9amr22197007f8f.42.1779939737939; Wed, 27 May 2026
 20:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-6-jiangwenxiaomi@gmail.com> <340c811e-2501-46c3-8a55-19e955c5ae8a@arm.com>
In-Reply-To: <340c811e-2501-46c3-8a55-19e955c5ae8a@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Thu, 28 May 2026 11:42:06 +0800
X-Gm-Features: AVHnY4KddDJ3QPES_Z3XlC4q6Bj_kB7V574_4-TqsJtLPivMCxYpwZ5XM5S6H0Q
Message-ID: <CAHKocdHOT13DHdz+DsT2BaP0EJSKdoWU2NO-wjFwB9+--CqsHw@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com, 
	rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
	jiangwen6@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 549B34000B
X-Stat-Signature: 99o7m7hughxcdr1wpkjju6w73ib5gwk1
X-HE-Tag: 1779939739-122764
X-HE-Meta: U2FsdGVkX19Tayk3SYsGpO7GLzmW5zVcNGVfB93qbtP0WV+5pD2Q+su9ed3mRUpfFKkrGi5adyUYX2NYr1zAXQHE65a3Sqm53/7VSTX7l/XcaKJy6h1Ye45VKPeexPd8COq703mjnl2FvE/kbLTzE+HSFKazBfeBEvHW0BpPxPW8QwsfgAafwrOT3uSSJyGNkTfxT7sPkdX3i8uPE6/3mpQz2rcjZNy3HrTLUhmEVayirFu2CPYcEBghJ++O/OMSo46SiivsPtmOklNJLpY6GtBwJCNrls0dw6UcB2D0K/uxitUC3/phuv/rp66uJuxcmE4R5tWwnMd31CWZ6KXEdqggSrsIW99UQ7dvLfysbmpSuXb6G2PXQxoPvafETfWAgSozbpdpq6EHZlacDrSHd1mGCwhpBT+boCwWJvRdkkpIr0Ttz0Qpbgl8YgqMJIWApRAO3zcOGaDWzYxrttad6+Wyi6b+iWj4AEbBlUieBIGlnZpk7Y4Qw7k1vqpBTAGbPvZjecz1Umuriaw1r1bAf0plCS+zI2REnQivr+i6vvzaLPME1YjFmtBogD3HfIvatu56I1D+qXj44oHcOHBque+CtVYmLMrKgWIpWYGsfxBz9akCK/hVuA/8nzmT8p6gmlcX11JZMClu7ow1MCgWr/WheW6y6vYxbOF7UILjPwWF+ioJE00C/fgQV7oTaZK7u5tIXGfmePFS/O8X1rhFwGMWT/6xQMCJKg5/TuJDnrk9c8z24nmHre3K3EfPyfKO6NB5g6X+xpNEspFBWGWKkujlR/bXpC6lTGhoLh3thyO+jZNh3vBsDL/HGv9Ou8EfV2J0W+w3Uqv+Aokn/FZeZTr+oCE/omAApTKgbplRmaDTBcAYMawju7rChJjHY+a5582kS0itUVbgQwgG2tvmdbSm3FTx68Fs24IgkkFAUTB72SWpP65U4jaAhx4hc+yPi979noLnXbSNVneDlLL
 6YO71Bzs
 4AmCLa/9hjRQIzjTDweRw/6GO4DiDXclj3vx/2E4+EFQDidOF22ZsG4C7dFJW9vkuIX+MjyWbrYrKay2x0ZvhHTLNKKXeiD/t+M36b+6t6D0MoHa0kh/3xW7lNx1jZBvB1kyoF9PqWEMbbUjy6bKy54ISvOPHt3DewywQEeTCcUkDF/31SD/zbyhf1aCmx99rUraEwMYGTBSomMeKNWYxrXWHlqznqaQ4cKSz+WRX1/sDSyle768X2XvMDBL6cjWYahnqdGRb2EyAB7k0P+HbsEucIPXiBJfooe/6kdUeppPK5GWyudbmsAqiU3h1go+2o9qeRWta5CsCL/Kk/jLhyxe7mXd8zWQD0VgThJG45bEfSO3Y4Ts+Mwqln7cMIVcMGnmfY6v5QuYcXQ29dIz5vHfpXC6nmKKM/G5JiHVPEA2nMchRUHjxsOmOMJNgc/H8x8pNW47VVWuWTJ5nwX9p6RGV7fjILLFMu7jJSwku9xpquQw8rrLhqZLbi1MWmIjJSXyzK4sgkp0MxWM7koG60yaE/neVdhJqHJP0SahudtZ3J+VQs1dDA93iGl4WnVsVcHgYn+tekEGdrySpxkcrNW8YodqsdZBcLB3eV6AuQ3EqmWEbqyzPkTMfv60qenY3otVFGyOE3ptfPZJcyhEUK1s90PPAWTnYQELQtQImYkICVyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 at 16:28, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 22/05/26 11:01 am, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > In many cases, the pages passed to vmap() may include high-order
> > pages. For example, the systemheap often allocates pages in descending
> > order: order 8, then 4, then 0. Currently, vmap() iterates over every
> > page individually=E2=80=94even pages inside a high-order block are hand=
led
> > one by one.
> >
> > This patch detects physically contiguous pages (regardless of whether
> > they are compound or non-compound) by scanning with
> > num_pages_contiguous(), and maps them as a single contiguous block
> > whenever possible. The first page's pfn must be aligned to the
> > mapping order for the batched mapping to be used.
> >
> > Pages with the same page_shift are coalesced and mapped via
> > vmap_pages_range_noflush_walk() to avoid page table rewalk.
> >
> > As users typically allocate memory in descending orders (e.g.
> > 8 =E2=86=92 4 =E2=86=92 0), once an order-0 page is encountered, we sto=
p scanning
> > for contiguous pages since subsequent pages are likely order-0 as well.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Co-developed-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 80 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index deb764abc0571..50642246f4d40 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3542,6 +3542,84 @@ void vunmap(const void *addr)
> >  }
> >  EXPORT_SYMBOL(vunmap);
> >
> > +static inline int get_vmap_batch_order(struct page **pages,
> > +             unsigned int max_steps, unsigned int idx)
> > +{
> > +     unsigned int nr_contig;
> > +     int order;
> > +
> > +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
> > +                     ioremap_max_page_shift =3D=3D PAGE_SHIFT)
>
>
> Why bail out on ioremap_max_page_shift =3D=3D PAGE_SHIFT? The code
> path for ioremap is different from vmap right?
>
>

ioremap_max_page_shift is under CONFIG_HAVE_ARCH_HUGE_VMAP which
controls both ioremap and vmap huge mappings.

> > +             return 0;
> > +
> > +     nr_contig =3D num_pages_contiguous(&pages[idx], max_steps);
> > +     if (nr_contig < 2)
> > +             return 0;
> > +
> > +     order =3D fls(nr_contig) - 1;
> > +
> > +     if (arch_vmap_pte_supported_shift(PAGE_SIZE << order) =3D=3D PAGE=
_SHIFT)
> > +             return 0;
> > +
> > +     /* Ensure the first page's pfn is aligned to the order */
> > +     if (!IS_ALIGNED(page_to_pfn(pages[idx]), 1 << order))
> > +             return 0;
> > +
> > +     return order;
> > +}
> > +
> > +static int vmap_batched(unsigned long addr, unsigned long end,
> > +             pgprot_t prot, struct page **pages)
> > +{
> > +     unsigned int count =3D (end - addr) >> PAGE_SHIFT;
> > +     unsigned int prev_shift =3D 0, idx =3D 0;
> > +     unsigned long start =3D addr, map_addr =3D addr;
> > +     int err;
> > +
> > +     err =3D kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> > +                                             PAGE_SHIFT, GFP_KERNEL);
> > +     if (err)
> > +             goto out;
> > +
> > +     for (unsigned int i =3D 0; i < count; ) {
> > +             unsigned int shift =3D PAGE_SHIFT +
> > +                     get_vmap_batch_order(pages, count - i, i);
> > +
> > +             if (!i)
> > +                     prev_shift =3D shift;
> > +
> > +             if (shift !=3D prev_shift) {
> > +                     err =3D vmap_pages_range_noflush_walk(map_addr, a=
ddr,
>
> It would be worth documenting vmap_pages_range_noflush_walk() that
> it can take an array of pages which are not all contiguous, but it
> may have contiguous chunks, as hinted by page_shift.
>
> Otherwise this looks good.
>
> > +                                     prot, pages + idx,
> > +                                     min(prev_shift, PMD_SHIFT));
> > +                     if (err)
> > +                             goto out;
> > +                     prev_shift =3D shift;
> > +                     map_addr =3D addr;
> > +                     idx =3D i;
> > +             }
> > +
> > +             /*
> > +              * Once small pages are encountered, the remaining pages
> > +              * are likely small as well.
> > +              */
> > +             if (shift =3D=3D PAGE_SHIFT)
> > +                     break;
> > +
> > +             addr +=3D 1UL << shift;
> > +             i +=3D 1U << (shift - PAGE_SHIFT);
> > +     }
> > +
> > +     /* Remaining */
> > +     if (map_addr < end)
> > +             err =3D vmap_pages_range_noflush_walk(map_addr, end,
> > +                             prot, pages + idx, min(prev_shift, PMD_SH=
IFT));
> > +
> > +out:
> > +     flush_cache_vmap(start, end);
> > +     return err;
> > +}
> > +
> >  /**
> >   * vmap - map an array of pages into virtually contiguous space
> >   * @pages: array of page pointers
> > @@ -3585,8 +3663,8 @@ void *vmap(struct page **pages, unsigned int coun=
t,
> >               return NULL;
> >
> >       addr =3D (unsigned long)area->addr;
> > -     if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> > -                             pages, PAGE_SHIFT) < 0) {
> > +     if (vmap_batched(addr, addr + size, pgprot_nx(prot),
> > +                             pages) < 0) {
> >               vunmap(area->addr);
> >               return NULL;
> >       }
>

