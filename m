Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D08EA3C23
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31496B0005; Thu,  9 Apr 2026 06:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2406B0088; Thu,  9 Apr 2026 06:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0B36B008A; Thu,  9 Apr 2026 06:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7EF76B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:20:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 599C18C2D8
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:20:18 +0000 (UTC)
X-FDA: 84638622516.17.380F16C
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5E94D180009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:20:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OkqtWNXp;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775730016; a=rsa-sha256;
	cv=none;
	b=UFJ2EmGWtE+IfUeY7BV/vnjrdPINsRR5vgFDDoEfP+KIbqNCWiAHZK2V1ciFp06Yrf+K5n
	M2sZvSe6h1sriKmFRpvpGlPEMeor8IF7HB3ZuAhDN2ShWJ0UwzUuAwyxYYLUlq1n8cDUz1
	74pWjEqxup4d8g48QlaGjR9VV4Pd9tQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775730016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/CrLVrNrD/BoMaAhUshUQsHT/vPQb3nnMxgKIza7ds=;
	b=oZ2Tajfmucukvx+JiSvqP0RYWawm+sTWREI+RzbtaKRuOYSzsIX4SPt2ZpOW2PXHF+B9oK
	jwbGhVOnlsY5maxkNcnKjjM2c45UJ7YNsmmKV+vuuj7H9K7tqoQw2Qv+JMiCCEYoxhNTKM
	OFofO8sPd9pwqyMCcIDol4AaSt0Ykig=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OkqtWNXp;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38cd00b3b12so5476031fa.0
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 03:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775730014; x=1776334814; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u/CrLVrNrD/BoMaAhUshUQsHT/vPQb3nnMxgKIza7ds=;
        b=OkqtWNXp/8R2arrl6a5IJYtvbrnw42uu+GsZEbrCmz8bJ812qie5kLVUargJDspXLU
         xmuwjxZG2cWjVms6gySGl1RyBNrvxDHPPyXPVKQHvmvy7wMuTwAnOpWJe5x/G3QV1k1U
         iNbu4su/m6y5bWQYX+MWSMCBsXRmWwv14rVAYUwCOxIxeFcw3xn1FgbOuqnbIWjtWdeh
         DXcY2fkpNiBUK6BrQAlRlHbAFaTOX8LIjQec8+1Zqw84ye/oe44ivSCyWpDQ/T5TYexs
         3i/4CVN9fvMS86XT+howUQebg4pM30WZNbKWyRXBrhbMnJEKsFqf5ph5UIzvpr8l2Lim
         WoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775730014; x=1776334814;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u/CrLVrNrD/BoMaAhUshUQsHT/vPQb3nnMxgKIza7ds=;
        b=k5EnyPvVIrV4gN7mXnrupg95fmyFwQ0azA/gGmYBQjsbj00e/znhPF+bbENaRihbM4
         14LF8pH6sEQnVNYCesBbYVJS+V8yo5FkY+Gb64CXihnBJE//UfHUE5O7NZoioKjJ3e2F
         D0wPc1dgM6et1sWmmrrbzOsXvnGKaUrjdskCNRAKN+cFELGOLgaGrz81d41AMJcKZ0XU
         Nsb6Cgt4JI0Qqz8H/qSasQW7aIDn4Zap6/JojCKjkWCbq5qd2SMWpPN/qzNoxdQCahEq
         Xj4rAuWvCNvBY6iAwUyysbV3HHfXfIJYKo55hBGcTe6vK9D9ni74qLhfISmer+cuXiEY
         f3OQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4uljQPhN1GOAW7S0QlsbKGDRgOkIKzPx49UdBdy5AgkW8HxN4CmJmJ2o8+YOxNfWPiwfz+Vww8g==@kvack.org
X-Gm-Message-State: AOJu0YyxEPwP27aR4bUFARppoJ8WoRhRSXlS4CIYaV+aX77WDv6VI34p
	HWgF7LFv53QPTkBqtm8ijOOo693ZSRELerVjmoEw41miICx126dzZ8uh
X-Gm-Gg: AeBDievbyTTc89Y8EBwbqXJyBtKwBZaTLOpG0ynvbytoBs1WIu51QfIWGG+z3TmlESa
	lt1Sv8Bu2TEjKw5RL9NreZmtiY7hHMfoIUERBG/V8xPy4JmQu657h3HnmuTGftbN3sLnuB+iuoG
	DnyhY2ENUawHK2Qn+i57h0kCPWMMTn3gAMhWKOimWpq0PE5OXPlm5LJ+Ypbsgz/M4FNiMyzk5W/
	p+A4O59GLDnb9cXWwm3LlK5m6GnUT8LIKKZkdFUisQLGypk0KMV/8e8dRZU/zUiGj+UDJd0DNls
	9+YNsVWl1JHl9TXjGRivXgUvP7um6IXvYKJMTcZYRK3Zt6suxy76Q2k0vNwiaUnoD20ftIZQBXv
	ZOq3PzBTV/fhFK387t0BR3JvnQxhYweO8FrWQBSNHDojHTwGox7CmsVhSWwx+WRg9
X-Received: by 2002:a2e:bc27:0:b0:38a:5402:a9e9 with SMTP id 38308e7fff4ca-38d8d37ac6emr83380891fa.5.1775730013964;
        Thu, 09 Apr 2026 03:20:13 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38cd215cc94sm48932641fa.35.2026.04.09.03.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:20:13 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 9 Apr 2026 12:20:12 +0200
To: Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com,
	linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
	ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org,
	david@kernel.org, Xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
Message-ID: <add9XGTYL9sYilqO@milan>
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-6-baohua@kernel.org>
 <c54e12b0-1a35-48e1-b243-991de246a8ca@arm.com>
 <CAGsJ_4yL3Y1Sr0MjTd6=ROC0jKf4JkCqNPODMh-m155rUFcS9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yL3Y1Sr0MjTd6=ROC0jKf4JkCqNPODMh-m155rUFcS9g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E94D180009
X-Stat-Signature: me9cw3ncdsdm6e6ux5yd1hajuk6caapy
X-HE-Tag: 1775730016-396043
X-HE-Meta: U2FsdGVkX1+AX1l0q90Q79ZYUA5R6u//Trwo3r64Ub+CorBnIg5Ws1jxE7EcDQgh8hL1jvUbyToH7NfSXPGyEh1CzrE4r76ioOIQQ7Dos0KzyaLlQ3YwV1I9N5CHrHDzWQyOSbL4w2s9u6rRMEdFarAnzg2eVN6MFhQPX+D/6TWHaQ/wzpl/Guk2qc3l3/kmO7lMPa0seze9BNEsPnJIocA+WgFjqPr17zMuIslYo7zvhz7RVlaKtgw3b7NDvB/YtbS9cO4mfflbektJRl92KBMTBQRG23zxU+KPl8FNRL9RnW03JehJE65PkjzreARBg/i+TLo/uR8AksEe2i6TtcSuc1FW9zya7olhOl7WwTE0U/ZE1pywwwH70fZS9uBOd1GMT0iDJF9OtedbBTD12QL9O8WRBSeGv7kaDLY93vSvS6yoFJ4aMliSTHGuUoKmYS4SCARgb0OWRf8UcNF+58gXLGOO6U8Bwd0ZR6bQU9oEkOzHWLf8m4JEsYjBoJXJVJen9j0/9MxqafbSKcXX/NFJgj93/nWrskWwbY4jIO5VT/+29flFzK8JtmdfbPD0m/FWAhF6m/HsPxLXapnvjSAxnl3M37xSp0G7hCMiE4RU3eBB7xhyngTIDf/Q5HuCOsj4p2Os8/c7RKrj4wGNlfO8gkdluq5+tsUq2GAfMz32qNMv/XyF3QIX5yb9IawKoVqsyiUz/2MHKMZWunN1VgdRIT6XGC+Ih4PEBr/IDT//OgVie+DlFOCTlQnobguQ59HHv0+l/0Zaq/PVzHeu84XR45XCxwuKvhbaSRUF00fP8jHqEjv8b8PDNju+h2hraTRPclCK790aba0Pq6Nmg44KltLJr9oo7BFx9v1I7Y11NFC0mbS92NVTxOl+D2eAj3FhZsJ6iMARqvQDhXcP/IYwA2lgpgceWTsj8GgeCPVjCDN07vCBwm+tYoP2jIgrMicU+M70GlSQXJC288r
 LvSU+A47
 iuqA8dnlt++dy2tyEUXYnYlHgLkorc+jmDypwRadp0sdww082lINlJzFa73vzfoUL7AziRhJU46yt/sm9tO/6+lXcwr6C+Etw0+59OdJM+CyPbZjAug6zgtSmoYMSFD8n+UI0RhE2/uY4m/QzF/ezMVCmqQwoojgzI6HhzMQoKBglSQFW2/egHH97qwJWEsoweaBW+b5jY6sbs2W19bNtFwnlfvf7pPVvgl2b2lp83YKc3ddXdlJAprSeDypImpQHxh4/pYH2Qcg4WnKDBlVNiG7qoIJ/O9FG7+S/IhWx/k08O41hcyMTst82mypZ69lKyhOo/dcRuX7YKDafCxrcU3pJzADT2cVtGeV91wjyG3c6IyFDNX3JS0m3AWvsbhevKgm5IESXSkzPKQ3Zu9jWrQp7LprDPtS1KAy84Bd6VQeANsuwR/gEtmSHhHBJoliVa7dHZnyvshDCXN7x4iJgIwAGAEIXs8ddLoOSleyIfSYcWCFza8o0fE2AO5oU3dHZ0K+kU9WeorKYVOjxOSQD0R0Gydfsliz19h5pQdt2gonk41U1VEPAN6U2tfkM4piC+tJ1pvO3SlSJQE45Y0byUcFX8/9x0VTj6m3PPYU1hQQ67+gTFS0Ov8yalvmNv0mMaMN39PFZ8tGW+CRsHZhYC3a5ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:54:55AM +0800, Barry Song wrote:
> On Wed, Apr 8, 2026 at 10:03 PM Dev Jain <dev.jain@arm.com> wrote:
> >
> >
> >
> > On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> > > In many cases, the pages passed to vmap() may include high-order
> > > pages allocated with __GFP_COMP flags. For example, the systemheap
> > > often allocates pages in descending order: order 8, then 4, then 0.
> > > Currently, vmap() iterates over every page individually—even pages
> > > inside a high-order block are handled one by one.
> > >
> > > This patch detects high-order pages and maps them as a single
> > > contiguous block whenever possible.
> > >
> > > An alternative would be to implement a new API, vmap_sg(), but that
> > > change seems to be large in scope.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/vmalloc.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 49 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index eba436386929..e8dbfada42bc 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3529,6 +3529,53 @@ void vunmap(const void *addr)
> > >  }
> > >  EXPORT_SYMBOL(vunmap);
> > >
> > > +static inline int get_vmap_batch_order(struct page **pages,
> > > +             unsigned int max_steps, unsigned int idx)
> > > +{
> > > +     unsigned int nr_pages;
> > > +
> > > +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
> > > +                     ioremap_max_page_shift == PAGE_SHIFT)
> > > +             return 0;
> > > +
> > > +     nr_pages = compound_nr(pages[idx]);
> > > +     if (nr_pages == 1 || max_steps < nr_pages)
> > > +             return 0;
> >
> > This assumes that the page array passed to vmap() will have compound pages
> > if it is a higher order allocation.
> >
> > See rb_alloc_aux_page(). It gets higher-order allocations without passing
> > GFP_COMP.
> >
> > That is why my implementation does not assume anything about the property
> > of the pages.
> 
> If you’re asking about support for non-compound pages, I think
> that’s fine. My current use case is dma-buf, where pages are
> compound. I recall discussing this previously with David and
> Uladzislau.
> 
> If you’re working with non-compound pages, I’m happy to add
> support in the next version. I’m also happy to reuse some of your
> code and credit you as Co-developed-by if you’re willing. I actually
> prefer your __vmap_huge() name over my
> vmap_contig_pages_range().
> 
> Does that make sense to you?
> 
> >
> > Also it may be useful to do regression-testing for the common case of
> > vmap() with a single page (assuming it is common, I don't know), in
> > which case we may have to special case it.
> 
> I agree, so I had Xueyuan test single pages and highlighted this
> in the cover letter. There is no regression: "vmap() is 5.6×
> faster when memory includes some order-8 pages, with no
> regression observed for order-0 pages."
> 
> >
> > My implementation requires opting in with VM_ALLOW_HUGE_VMAP - I suspect
> > you may run into problems if you make vmap() do huge-mappings as best-effort
> > by default. I am guessing this because ...
> >
> > Drivers can operate on individual pages, so vmalloc() calls split_page()
> > and then does the block/cont mappings. This same issue should be present
> > with vmap() too? In which case if we are to do huge-mappings by default
> > then we can do split_page() after detecting contiguous chunks.
> >
> > But ... that may create problems for the caller of vmap() - vmap now
> > has the changed the properties of the pages.
> 
> I don’t see this as a problem at all. Splitting pages does not
> affect physical or virtual contiguity; it only changes the
> contents of struct page objects, not the PTE/PMD mappings.
> For ioremap, there isn’t even a struct page, yet the mappings
> can still be huge.
>
It would be good if you could combine the work together with Jain.

--
Uladzislau Rezki

