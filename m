Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4113D66B85
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 19:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077796B00A7; Wed, 17 Dec 2025 14:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021756B00A9; Wed, 17 Dec 2025 14:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66AA6B00AA; Wed, 17 Dec 2025 14:22:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D360D6B00A7
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:22:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 913B08BA62
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:22:56 +0000 (UTC)
X-FDA: 84229935552.05.7BAA240
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7EDF94000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:22:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cvu5h0MG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765999374; a=rsa-sha256;
	cv=none;
	b=QSYGpVgtuLZ83EIRQNK4WjM0t5RjQZuaoZF0FTz9dO/98X25nATB4jXn54UhxodiGJ8/W8
	OC2qVc7qzQ7iMOV0KIJJSdFYpKsIJHKx5EYsnDmFgXuIONOL3cP/fKgp6gmVRnFUrtxfs3
	UdER4pA+opLKRx1tPbg24LtJCU/ykA0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cvu5h0MG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765999374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXv71vQRwZmSrjPwJYiXG0fsD7GmbALfv0SmwgVeiGQ=;
	b=icdGiLm7/ki3lV3eqxL/+j9ogeUUESmZF/FjG/HQiZoj94T/h2e2feY8mTbQtblXnxCA6l
	5n4RI59Tv+4kR8esTWWSUoHG/75407HjIAXxwXAkpxG9MEf+s1NcHyS4rETTLN21Z6s28w
	RbgTG+SVozRqDwMc/MK4QkhzdcPTlW0=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5957d7e0bf3so783346e87.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765999372; x=1766604172; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tXv71vQRwZmSrjPwJYiXG0fsD7GmbALfv0SmwgVeiGQ=;
        b=Cvu5h0MGKlUuCi/02NriWIQ1KvRARTBs6X0WJptBCiwvPesXvWntHPsqTcOJVlTPFx
         uNBEAZQ+zq33F4oR0JrwEQ012lRa/8rVyeB/XBErRiRqRR9fmWL9wWH96bOgVISkIb0j
         X3RKfIFFmkBVICTQMUDsY723TrdYmQWGPAPQPWdGgMaHSB4V7YzyDf2fcaNgMPxJgaV9
         7CF2ipbKYg+SF4ZWHTW2uB6SNL4vswW8olS2FyuTh0zBbnXYGnYyGCMi7a7JA+lrig9A
         shk3SblfiXZHcUadXoFgf/PmFjdp/3quJncvqqedu2xsUsoWhnD6iaqDItFTw0dMQeyQ
         Gz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765999372; x=1766604172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tXv71vQRwZmSrjPwJYiXG0fsD7GmbALfv0SmwgVeiGQ=;
        b=FFTkFnmIx/9uQqCsb7hW2L7zfkWJYWpYSfaaqzmj8mICZn4at0zS+PclKQoTI5UJr9
         X2WxRNwma4TGd4h1LKeXDgDHSAk+q8XfPYpYohRYOA4LpjQBtuATPZH0/SE3KdhRLDFP
         75Wd/m935qAzJ/jFO/MVGQUlncY3DO2hKbyTpoToaCCjSfJO8phxQTAqlBcqnHEow/eL
         Oai5WR7QTEYcV0y2V6PaTpT7jhpoMpTxLoOoP1Pj0ac7z9XaZdOQWIffuFn0miSunvQY
         URpVdHeYwLnT3WJhrmmFNUUIdkz193LafoZ3S6RX7/4/iXjs8GAWwItx4kw7cvAKpRpX
         VhSw==
X-Forwarded-Encrypted: i=1; AJvYcCV7cKX8VVYvRLj6L9WC4x9IXsLsFPNS9navInjzVldO+2unrJXjz5SCzK4+2jDLhGGcrvR/l0Jf3A==@kvack.org
X-Gm-Message-State: AOJu0Ywu+TzZ5djvYvUyxXvygiuutbHnStuSzpOJqUcqdAnzP2al88EO
	8ZMnfN1goJWxPXNUXp55OpHAZKIn+b01Xi8bhlSUJEI9D7/9v2DZvP48
X-Gm-Gg: AY/fxX4HasDhD99XO1prkDdm1fItESLmwqvR+sWrEyUxHwGXqk+Q9LIz+dqwZZug3i3
	rddq4k0dcFHvILYiQ4taUJB4EfCxhVtwa+uC+HkUnfJDz5oTg1uL+rW/0SX09LvJlLifeuK3gdp
	/YFuREJjCAG6pYrV4YMQgaCbdzVWrRpE8lwUxySga/0DjWr2eA/DVS1E9IA01R71+1K7CmG6CKf
	YNgdslL4J4tXi+Hq2mc3Ka64PmTh+DPuS/8YuzeSpJGcCZvRUVDScCu68c8lR3YygrWa/wcEwu8
	YypkRhFAzGmpfv/DYPQlyrC0I2R/EtpkgXqfy/WoMvIuw5/+z7/ELZHsKfpVIU2+QEu/H1Ml7kS
	tYNDjOO8GbzkVzwTD/ClPHiktUFWcW+YaaIPK2F/8CfXL9moToJg+
X-Google-Smtp-Source: AGHT+IGAARlvvyw3ne2FlyuYzdtP1XaHjkMmk9qDhN9jJePGA5iBzMwPYucwEJAgVxQA5q92hBEZew==
X-Received: by 2002:a05:6512:12c8:b0:597:cfee:db20 with SMTP id 2adb3069b0e04-59a126ed5f0mr145924e87.23.1765999372064;
        Wed, 17 Dec 2025 11:22:52 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a134fea6csm39753e87.80.2025.12.17.11.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 11:22:51 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 17 Dec 2025 20:22:49 +0100
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vishal Moola <vishal.moola@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Message-ID: <aUMDCSTewPSLCbYM@milan>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com>
 <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <4a66f13d-318b-4cdb-b168-0c993ff8a309@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a66f13d-318b-4cdb-b168-0c993ff8a309@arm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7EDF94000A
X-Stat-Signature: zf177srb1oudaeip1qx6fbmqpnihqwc9
X-Rspam-User: 
X-HE-Tag: 1765999374-875128
X-HE-Meta: U2FsdGVkX1/6hdZkqr6BcxdF8GzReQdHDJeCKR+8GPb7mKfjkXdGIWdG82AuU5fHuqWV1o9aJVG27AOaZ+J2W7xs7Wh1Yv4pZiYzFBqJUNBwhYs0Dv29ozEyOPmymKMsXUikQvYX3CZ9PrC43QsH3nxSjKhUTXC9km4Bob+SrHneZeTg6cHyca8pSf4jPhf2SIJxOLPKLqFboHDEEJCOhaVtVW/aSDJVL6dsZ1dk+SMOqD9Otpmrj9PytBYCRa3IKF9zUohS9H3OT1S9Yssd/ic3fQyez96IlCQKUNDGZsxzvPaSSR//yMOR+2H8oez54mmOiat8k3MebvtcKRTrKWcuZmNOvKcmUFd2aUjbjFoV+NfLJbyuJEeFruN0FXX2uMjo7O99zGvENCat0l9K1vQ9GbVPF0AXNU0NA8Tcj1TPcfZdr0svgJXKOYvFWreQDaMrxqPt7eF6CsEf0NhWUPgn+67coIGEUoC4/CX1+2b+IZJWH4eJF8UIZ3RDi1l+KM8lZOpfATkil8xHgywHUrMSwFpU7Of+0fidMKMTkNpd5bvKmCo7dp/DC5/E1i9b2tQJWZIf+k3LkOjPbRNsqsxtqsMmV+ig6WcItQ58dcirK8X0BuNKr7jRx7iqdVk/fWhXYiq9gYNq3Ydqtegg/g+HEYU9AsvC+Pn3bfBF34kXDQFUO3e5KfaG1tzYcd4M0+EnLMIrrzvhZKKesYPuWBEPbCtiQ3EH75yh41/yptZ2wU6a9NfxgOtaH604g1UwBIdeXYhNR6HXoAbL5Ny48aPjIJ8iqIsWkSISuTqMuChF40h30mqp0lLyn/nW3TEV5gj39K/Wv5e0QnYa2eUumUJqaWrRZgCCSoI/ZNXlJoSsBDWPpj9xpmNeX/grLra2iI6eoM3StIYXySD2RZ8nEZFCAqB8kgr1dUeeeWBrf0IlgUO6LW9laubTtqJP0hflgC7Np5XEIqyXBPhI1Dd
 EpI9eetq
 6Zz0HTWN9RnALi8Go//92P9Hoxoee/8aFNMgREuTNSZmnzNm/JPuBOZ4pTo+ELgt3Kyu0L7JU7jjfksNGpChkFH/1GoXnAXYq59HrahruQDqC5TSzmmFa15QlHerneH7w19kcvZvotsT6Z3jOKArpJYwVXNtMt+otYfZo1nsj9+v5bNP8xmi3rHapaVCW/o0EkywpBkHWFDjPSZ2K8g9KHxD6F79CpAPSRt2ZbUw/Z3iraplbbEM7sz57bs96TLC7zKYUVCo2FCr59VuWURMuVQouy+7Kw4Agr4NTwifGmqJ9rKnrQ+8gKtSlhDgRL30HrNwYv4TrXaJJuAqxU8e2ab3kbD+zRGau8+yGqtLainPPH4B4XNbiIwnxxTalic2KnNDHd2741eB3ENPNgF9cXfXWyBuX7RZ+45acpZfsYKjQiSEMKWck/Baa+ARBem76vClBGK91NzwBMS8F1ygiMgyWIgt5EpMH3h+V4fkm2QZDZ30oKIdTUPLAcw4/bxSYUucRQc7o7iBC1pAtjwdSx89o8gWI2cDYMmoV697kWJE/Rves84WqsFnvWasFurdIW5SZwHoYn1IZU26gFzcOLurKK/prRZC0Wgv+51s9LHbcepfo7AQWxqYhxZ8bLoWDwNEPCBVDL5NkZDTzLCCbsA5nUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 05:01:19PM +0000, Ryan Roberts wrote:
> On 17/12/2025 15:20, Ryan Roberts wrote:
> > On 17/12/2025 12:02, Uladzislau Rezki wrote:
> >>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
> >>>> Introduce a module parameter to enable or disable the large-order
> >>>> allocation path in vmalloc. High-order allocations are disabled by
> >>>> default so far, but users may explicitly enable them at runtime if
> >>>> desired.
> >>>>
> >>>> High-order pages allocated for vmalloc are immediately split into
> >>>> order-0 pages and later freed as order-0, which means they do not
> >>>> feed the per-CPU page caches. As a result, high-order attempts tend
> >>>> to bypass the PCP fastpath and fall back to the buddy allocator that
> >>>> can affect performance.
> >>>>
> >>>> However, when the PCP caches are empty, high-order allocations may
> >>>> show better performance characteristics especially for larger
> >>>> allocation requests.
> >>>
> >>> I wonder if a better solution would be "allocate order-0 if available in pcp,
> >>> else try large order, else fallback to order-0" Could that provide the best of
> >>> all worlds without needing a configuration knob?
> >>>
> >> I am not sure, to me it looks like a bit odd. 
> > 
> > Perhaps it would feel better if it was generalized to "first try allocation from
> > PCP list, highest to lowest order, then try allocation from the buddy, highest
> > to lowest order"?
> > 
> >> Ideally it would be
> >> good just free it as high-order page and not order-0 peaces.
> > 
> > Yeah perhaps that's better. How about something like this (very lightly tested
> > and no performance results yet):
> > 
> > (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
> > with a contiguous run of order-0 pages, but I'm not seeing any warnings or
> > memory leaks when running mm selftests...)
> > 
> > ---8<---
> > commit caa3e5eb5bfade81a32fa62d1a8924df1eb0f619
> > Author: Ryan Roberts <ryan.roberts@arm.com>
> > Date:   Wed Dec 17 15:11:08 2025 +0000
> > 
> >     WIP
> > 
> >     Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> > 
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index b155929af5b1..d25f5b867e6b 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -383,6 +383,8 @@ extern void __free_pages(struct page *page, unsigned int order);
> >  extern void free_pages_nolock(struct page *page, unsigned int order);
> >  extern void free_pages(unsigned long addr, unsigned int order);
> > 
> > +void free_pages_bulk(struct page *page, int nr_pages);
> > +
> >  #define __free_page(page) __free_pages((page), 0)
> >  #define free_page(addr) free_pages((addr), 0)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 822e05f1a964..5f11224cf353 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5304,6 +5304,48 @@ static void ___free_pages(struct page *page, unsigned int
> > order,
> >  	}
> >  }
> > 
> > +static void free_frozen_pages_bulk(struct page *page, int nr_pages)
> > +{
> > +	while (nr_pages) {
> > +		unsigned int fit_order, align_order, order;
> > +		unsigned long pfn;
> > +
> > +		pfn = page_to_pfn(page);
> > +		fit_order = ilog2(nr_pages);
> > +		align_order = pfn ? __ffs(pfn) : fit_order;
> > +		order = min3(fit_order, align_order, MAX_PAGE_ORDER);
> > +
> > +		free_frozen_pages(page, order);
> > +
> > +		page += 1U << order;
> > +		nr_pages -= 1U << order;
> > +	}
> > +}
> > +
> > +void free_pages_bulk(struct page *page, int nr_pages)
> > +{
> > +	struct page *start = NULL;
> > +	bool can_free;
> > +	int i;
> > +
> > +	for (i = 0; i < nr_pages; i++, page++) {
> > +		VM_BUG_ON_PAGE(PageHead(page), page);
> > +		VM_BUG_ON_PAGE(PageTail(page), page);
> > +
> > +		can_free = put_page_testzero(page);
> > +
> > +		if (!can_free && start) {
> > +			free_frozen_pages_bulk(start, page - start);
> > +			start = NULL;
> > +		} else if (can_free && !start) {
> > +			start = page;
> > +		}
> > +	}
> > +
> > +	if (start)
> > +		free_frozen_pages_bulk(start, page - start);
> > +}
> > +
> >  /**
> >   * __free_pages - Free pages allocated with alloc_pages().
> >   * @page: The page pointer returned from alloc_pages().
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index ecbac900c35f..8f782bac1ece 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3429,7 +3429,8 @@ void vfree_atomic(const void *addr)
> >  void vfree(const void *addr)
> >  {
> >  	struct vm_struct *vm;
> > -	int i;
> > +	struct page *start;
> > +	int i, nr;
> > 
> >  	if (unlikely(in_interrupt())) {
> >  		vfree_atomic(addr);
> > @@ -3455,17 +3456,26 @@ void vfree(const void *addr)
> >  	/* All pages of vm should be charged to same memcg, so use first one. */
> >  	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
> >  		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
> > -	for (i = 0; i < vm->nr_pages; i++) {
> > +
> > +	start = vm->pages[0];
> > +	BUG_ON(!start);
> > +	nr = 1;
> > +	for (i = 1; i < vm->nr_pages; i++) {
> >  		struct page *page = vm->pages[i];
> > 
> >  		BUG_ON(!page);
> > -		/*
> > -		 * High-order allocs for huge vmallocs are split, so
> > -		 * can be freed as an array of order-0 allocations
> > -		 */
> > -		__free_page(page);
> > -		cond_resched();
> > +
> > +		if (start + nr != page) {
> > +			free_pages_bulk(start, nr);
> > +			start = page;
> > +			nr = 1;
> > +			cond_resched();
> > +		} else {
> > +			nr++;
> > +		}
> >  	}
> > +	free_pages_bulk(start, nr);
> > +
> >  	if (!(vm->flags & VM_MAP_PUT_PAGES))
> >  		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
> >  	kvfree(vm->pages);
> > ---8<---
> 
> I tested this on a performance monitoring system and see a huge improvement for 
> the test_vmalloc tests.
> 
> Both columns are compared to v6.18. 6-19-0-rc1 has Vishal's change to allocate 
> large orders, which I previously reported the regressions for. vfree-high-order 
> adds the above patch to free contiguous order-0 pages in bulk.
> 
> (R)/(I) means statistically significant regression/improvement. Results are 
> normalized so that less than zero is regression and greater than zero is 
> improvement.
> 
> +-----------------+----------------------------------------------------------+--------------+------------------+
> | Benchmark       | Result Class                                             |   6-19-0-rc1 | vfree-high-order |
> +=================+==========================================================+==============+==================+
> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |  (R) -40.69% |        (I) 3.98% |
> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |        0.10% |           -1.47% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |  (R) -22.74% |       (I) 11.57% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |  (R) -23.63% |       (I) 47.42% |
> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |       -1.58% |      (I) 106.01% |
> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |  (R) -24.39% |       (I) 99.12% |
> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |    (I) 2.34% |      (I) 196.87% |
> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |  (R) -23.29% |      (I) 125.42% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |    (I) 3.74% |      (I) 238.59% |
> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |  (R) -23.80% |      (I) 132.38% |
> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |   (R) -2.84% |      (I) 514.75% |
> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |        2.74% |            0.33% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |        0.58% |            1.36% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |       -0.66% |            1.48% |
> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |  (R) -25.24% |       (I) 77.95% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |       -0.58% |            0.60% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |  (R) -45.75% |        (I) 8.51% |
> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |  (R) -28.16% |       (I) 65.34% |
> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |       -0.54% |           -0.33% |
> +-----------------+----------------------------------------------------------+--------------+------------------+
> 
> What do you think?
> 
You were first :)

Some figures from me:

# Default(3 pages)
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 541868 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 542515 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 541561 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 542951 usec

# Patch(3 pages)
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 585266 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 594301 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 598912 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 589345 usec

Now the perf figures are almost settled and aligned with default!
We do use per-cpu-cache for 3 pages allocations.

# Default(100 pages)
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 5724919 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 5721430 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 5717224 usec

# Patch(100 pages)
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2629600 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2622811 usec
fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2629324 usec

~2x faster! It is because of freeing now occurs much more efficient
so we spent less cycles on free path comparing with default case.

See below, perf also confirms that vfree() ~2x consumes less cycles:

# Default
+   96.99%     0.49%  [test_vmalloc]        [k] fix_size_alloc_test
+   59.64%     2.38%  [kernel]              [k] vfree.part.0
+   45.69%    15.80%  [kernel]              [k] __free_frozen_pages
+   39.83%     0.00%  [kernel]              [k] ret_from_fork_asm
+   39.83%     0.00%  [kernel]              [k] ret_from_fork
+   39.83%     0.00%  [kernel]              [k] kthread
+   38.67%     0.00%  [test_vmalloc]        [k] test_func
+   36.64%     0.01%  [kernel]              [k] __vmalloc_node_noprof
+   36.63%     0.20%  [kernel]              [k] __vmalloc_node_range_noprof
+   17.55%     4.94%  [kernel]              [k] alloc_pages_bulk_noprof
+   16.46%    12.21%  [kernel]              [k] free_frozen_page_commit.isra.0
+   16.06%     8.09%  [kernel]              [k] vmap_small_pages_range_noflush
+   12.56%    10.82%  [kernel]              [k] __rmqueue_pcplist
+    9.45%     9.43%  [kernel]              [k] __get_pfnblock_flags_mask.isra.0
+    7.95%     7.95%  [kernel]              [k] pfn_valid
+    5.77%     0.03%  [kernel]              [k] remove_vm_area
+    5.44%     5.44%  [kernel]              [k] ___free_pages
+    4.67%     4.59%  [kernel]              [k] __vunmap_range_noflush
+    4.30%     4.30%  [kernel]              [k] __list_add_valid_or_report

# Patch
+   94.28%     1.00%  [test_vmalloc]        [k] fix_size_alloc_test
+   55.63%     0.03%  [kernel]              [k] __vmalloc_node_noprof
+   55.60%     3.78%  [kernel]              [k] __vmalloc_node_range_noprof
+   37.26%    19.29%  [kernel]              [k] vmap_small_pages_range_noflush
+   37.12%     5.63%  [kernel]              [k] vfree.part.0
+   30.59%     0.00%  [kernel]              [k] ret_from_fork_asm
+   30.59%     0.00%  [kernel]              [k] ret_from_fork
+   30.59%     0.00%  [kernel]              [k] kthread
+   28.79%     0.00%  [test_vmalloc]        [k] test_func
+   17.90%    17.88%  [kernel]              [k] pfn_valid
+   13.24%     0.02%  [kernel]              [k] remove_vm_area
+   10.90%    10.68%  [kernel]              [k] __vunmap_range_noflush
+   10.81%    10.80%  [kernel]              [k] free_pages_bulk
+    7.09%     0.51%  [kernel]              [k] alloc_pages_noprof
+    6.58%     0.41%  [kernel]              [k] alloc_pages_mpol
+    6.50%     0.30%  [kernel]              [k] free_frozen_pages_bulk
+    5.74%     0.97%  [kernel]              [k] __alloc_frozen_pages_noprof
+    5.70%     0.00%  [kernel]              [k] worker_thread
+    5.62%     0.02%  [kernel]              [k] process_one_work
+    5.57%     0.01%  [kernel]              [k] __purge_vmap_area_lazy
+    4.76%     2.55%  [kernel]              [k] get_page_from_freelist

So it is nice :)

--
Uladzislau Rezki

