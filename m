Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42055D6ACE9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1ADB6B0088; Thu, 18 Dec 2025 06:34:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8B16B0089; Thu, 18 Dec 2025 06:34:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9C26B008A; Thu, 18 Dec 2025 06:34:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 795CA6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:34:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F5EC137514
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:34:01 +0000 (UTC)
X-FDA: 84232382682.03.D41E8E7
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49441180006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:33:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B+SplR6+;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766057639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1x3E1VR0Gpbdp6wnRrDsTcGeQICBEEEiprP37wFkWvI=;
	b=yAkjRM7Q78JH72NivJZPEpEI/BSdOPpsKt5JZXVBvKj26Dj/E/RHZl2F6cHgeVI/LrYL0e
	DT420Xd5IuxXoDFB8SEYdpR2mBV7KdN5+iNCk12dkolISCHVTPde7/5M+AtePonTl3eiu+
	/NFoJ3pDM0k+mPCPF+uS2iNE5zQq910=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B+SplR6+;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766057639; a=rsa-sha256;
	cv=none;
	b=NGplqsBNdbZx0aIasr08iTGiGKBVN3ecC5AgPQrzpYHwXNG/fsCjSTFlWmnf9RIndgfMtO
	rgjLiiEpdENBtJfs5gAMzIEjbLsIPACbfyxWnEiyUzp7PxhjeHGbmj/RzPiNNKOvItX+Pi
	VCVHXYSoE+bpu5rJ9eAFYQH7FC37RaU=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-37a33b06028so4130541fa.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766057637; x=1766662437; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1x3E1VR0Gpbdp6wnRrDsTcGeQICBEEEiprP37wFkWvI=;
        b=B+SplR6++DUappePd68IYBuuHTPIOuuOxfnT+j86d6NPlNGS+y9NfCMBsWA8jMrDzM
         nyVf4WZuyooRnESijImWBhETXCMUpPU/ie87XAfdbfTVFepJatOtqQUFDmEkvLpfZka1
         edYBnA1VN9/U4Dd0i3C8vO7OK9A/wGVrAp9kbZmi14KyJx0OZ5sx9Iq7T8t90NZrQjcd
         AlbxYToLo/e5zGEeMzfRfhMf/lHKnvXm/vvaVCxJFTV4xringjC0kWThxFBqWYzBXZW/
         n/UT8oYNC4MeeuvKY87UEVmmSxqC61Bybvl9IMuVaXuHx3Nq+OG0dE1qFI7xe9EKV/n4
         Kviw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766057637; x=1766662437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1x3E1VR0Gpbdp6wnRrDsTcGeQICBEEEiprP37wFkWvI=;
        b=N9Q4CWKn0S/OdB75BAc71bzfurwLHRSp+R1lhW6ITQnG5VDOrjcLRqWNUtcQreB2o6
         7ln/8D4Fn9lTR3bIyWmaURQKRQcCXhTa/jaLyW1PuzW3xIN9SwvE7kyK39yT0B4kSDeg
         1wJdVavCbBwzDUJFUa4jtoE5ULtWSAIUaqHCcszyxZOJygwSizYN8Dd+iXwyNneFPWaD
         HhkazbWQPTs/ZsLaz8JlsGpGDCJJC3g9nUHGZn1ndmUW0K5x6gXFdxrKjtF8o/hS4C+i
         3xSUjySizE7agotmLZFSWUXAHUV5HfitkI02GIXWkNISltJtqqwvbyOGkVE+YX4dVwuo
         mCBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVHssfPxFPUuRTFL9Soao5usp100YdfJFr7QX8KVb2tpEX9IiIxp0gDPN+3lJdeQCgAaRgAD4sew==@kvack.org
X-Gm-Message-State: AOJu0YzYSJ7Eykfoesqw9IFtKUDXWo0WbGau/ngfK9zbG0AqZt1o3dJa
	hRj8SDYaeDHSVZ4Rp7z9wqKbRQomfRCWKonC2GBTHy5t8sLOchejcHws
X-Gm-Gg: AY/fxX4a3cKGEeqb8AyHuLimobee/HpWDydXuCo3pLcteVog4Y+lhLSgWKhmRnkGo2J
	CDfaYMpRFSMGHRfijkEG+/Ml5k16czHgrRD7U47R+E2KKzLLWcg3b71gK9cSkvTTuaRJJ7DF9yO
	PgFRwVhemwHUAoIHsKB5U3fRoc3ax3jH5lvES0SlJWRY7e6j2fsV9QK57v8XUECaVf9sQP3cB7M
	4zssw6b66gdAxv2UB+FBiaE5Xg8mfU9QKNGKPC3IfN8YKyswVdnp20q3S1zsXAr7nWolApF8wuY
	csvL5SiWXCVqWg71l0kvGGok+60p1WXON7t1QUuKNv6XJNclw7u4kPZIByWK/e8cuFqNLme1nAB
	GvfnzXzp7No1kX7KwlueCUbiUSOhCRanaEM0MF/EW9M+MVszxD7wYtWRQKabcBOA=
X-Google-Smtp-Source: AGHT+IFoD+L6d3uJMTpeMtYDLCM7M3rSnWjOpPMSstf8SjInvaVPiSlxyhM8o8R8yZAtTFMR0ZJ7ew==
X-Received: by 2002:a05:651c:418e:b0:37a:4918:91c3 with SMTP id 38308e7fff4ca-37fd0792d91mr56475861fa.14.1766057637217;
        Thu, 18 Dec 2025 03:33:57 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38113711213sm9602351fa.34.2025.12.18.03.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 03:33:56 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 18 Dec 2025 12:33:55 +0100
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vishal Moola <vishal.moola@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Message-ID: <aUPmo686XKsD1uQY@milan>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com>
 <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <4a66f13d-318b-4cdb-b168-0c993ff8a309@arm.com>
 <aUMDCSTewPSLCbYM@milan>
 <37efa0a9-99bc-4099-ba64-2474f3f09aa2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37efa0a9-99bc-4099-ba64-2474f3f09aa2@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49441180006
X-Stat-Signature: yfcuczsx6mcsipd7zou87ejghf7193rp
X-HE-Tag: 1766057639-853657
X-HE-Meta: U2FsdGVkX19GLlyBlg1Dg0kkeNmravm829DIyyQRU1jHTpDz7ewpiMZXK0xz1mN6H/Wp1xC3UJ4yOgwAUBFjGUeUCK23gKtV4NXMIocZV5CnOqfYCgFmk8gOalw7VWTlp6l8r2JOx6WKSehR/vqus+kRznpkdiBqhtzDYZAfE9c9U/bpJyuwsypmkBcm01BVgXX2R3gUuTo4ehr+pC4Yqn5LR2VBXFSLMuS98bgPTSyBm3BRxGsIzeMTjSvaZE7G24DTwvuD/EvI1BBkWLExjzOn4CDRGGS/YSY1PBMJOdd5OEdJ8Tfysn5/KQilkF3Dlv4y0DlzNczCM9yJZwOpVAxWaCjvjjsl0fLQS1BdzDLVohFH4/rPZLIKwiwOXpInt3bU8JT4ro7BQD+OoxoXIluoVG+V1QXM2MvJBu12xWudajcmxAx5aS4qiGHsXSY/rx2xgY6GYSLwR0lun4m5TFz/ZeBuf1uFOb9DFfSJg0EWc72ICcQ56zCNYR3x8DRIKTu+2VPv1AHI9lkqYXflAdhIOS2/ZYIsHP8nL9wokjp39xp8ctDFJkUdo7CE4P9AnaPiR3yq5jzmocmdRwSly/8kOxWOwLn1NokxIfxR9876ahOnvIwyNX7QQqCvIZoL6Z4s2QoXscGjip6ER3yFigNDPuY/rAamjyjvSUAy4sQ6V2PF2qKCwHZbg2qXB6sME9TTNCE50XddVPgPO5JCJFWkW6+mITwRwQRtSDeEOrwv60w9KmcdhOZVou876N0i8SUr0Cz7Fd3vJc64Hra8upLMDduzqUKm2vEFkixpu+Rjmm31nNgq089lJ7GXG5hP+V7DPkrIgxkAgcrUJ2tIy6vhe15KQitzfAHOPenT1r1znsB3S5u2GjgRntFMbJkKvnvSyEvvQTWnlqEGJF5m2q0xqYJqbH6ZIp6T39U+w2MM0EXxet8r0nVTQkqk9c5kJZ6edYi1z1IYt4GRB/o
 +rG49Vfr
 EM8Rb6hweWmRmPqXJE+cFJvS4Tt3rdXT2DeaujVaLhDhmjzfOCksmmjjFXSPvHY6EIoDMdmXvQPLKqcEh2MRHP4GN6fTFzFezxNjPCwdZjpcElL4AamJsf2hD/eqUtnlU2VPOpVb2pb8pwRDSf/1AS8mt2KEuCMAmRy1CRWZnLqfsKyWIdJk5m6MeO0P26B9xcYr1fS3yn44zHjaXsSDfDOiktcg63TNqyGl6N/mhFRWkh2T3V4XbS3MvHtDSiZQhfgC663xqYHJJQRFUbXo2ApgbzzjFN6ddsImYvFFGtZZDneesix60lMARWd0NJR7ZrdckgvAQkDOckuC5cVSpBnXnGXUsJgeuWnOKRz42KaoyU6A/XoXoSzdwj8GgNPyc3aZgpk8cH2UUi8YmEi2Q040gKwp/b05+Alajb2oygIxOUvMcaRvPgHSN5/qT+dVwIuSn11fnD+pYMsTGMBdhF0SsBKv7Ge6fFvQLcp983iapdnd9zV0ML15q4t6e9wEkzyZbAlPEOBSWLvPCUqqEUo1PA4WhCHJY1qGIRbE8GJYisQMHfbiYUnKCooMEuxAaEXWmisp+EMKFxoOS0XucklRg1UScwijQknrf2pbr1CvFjK+zCXlL46LiuwZKSfj4u3Lpe07PBVp5h04T3rPQjmtafw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 11:12:15AM +0000, Ryan Roberts wrote:
> On 17/12/2025 19:22, Uladzislau Rezki wrote:
> > On Wed, Dec 17, 2025 at 05:01:19PM +0000, Ryan Roberts wrote:
> >> On 17/12/2025 15:20, Ryan Roberts wrote:
> >>> On 17/12/2025 12:02, Uladzislau Rezki wrote:
> >>>>> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
> >>>>>> Introduce a module parameter to enable or disable the large-order
> >>>>>> allocation path in vmalloc. High-order allocations are disabled by
> >>>>>> default so far, but users may explicitly enable them at runtime if
> >>>>>> desired.
> >>>>>>
> >>>>>> High-order pages allocated for vmalloc are immediately split into
> >>>>>> order-0 pages and later freed as order-0, which means they do not
> >>>>>> feed the per-CPU page caches. As a result, high-order attempts tend
> >>>>>> to bypass the PCP fastpath and fall back to the buddy allocator that
> >>>>>> can affect performance.
> >>>>>>
> >>>>>> However, when the PCP caches are empty, high-order allocations may
> >>>>>> show better performance characteristics especially for larger
> >>>>>> allocation requests.
> >>>>>
> >>>>> I wonder if a better solution would be "allocate order-0 if available in pcp,
> >>>>> else try large order, else fallback to order-0" Could that provide the best of
> >>>>> all worlds without needing a configuration knob?
> >>>>>
> >>>> I am not sure, to me it looks like a bit odd. 
> >>>
> >>> Perhaps it would feel better if it was generalized to "first try allocation from
> >>> PCP list, highest to lowest order, then try allocation from the buddy, highest
> >>> to lowest order"?
> >>>
> >>>> Ideally it would be
> >>>> good just free it as high-order page and not order-0 peaces.
> >>>
> >>> Yeah perhaps that's better. How about something like this (very lightly tested
> >>> and no performance results yet):
> >>>
> >>> (And I should admit I'm not 100% sure it is safe to call free_frozen_pages()
> >>> with a contiguous run of order-0 pages, but I'm not seeing any warnings or
> >>> memory leaks when running mm selftests...)
> >>>
> >>> ---8<---
> >>> commit caa3e5eb5bfade81a32fa62d1a8924df1eb0f619
> >>> Author: Ryan Roberts <ryan.roberts@arm.com>
> >>> Date:   Wed Dec 17 15:11:08 2025 +0000
> >>>
> >>>     WIP
> >>>
> >>>     Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> >>>
> >>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> >>> index b155929af5b1..d25f5b867e6b 100644
> >>> --- a/include/linux/gfp.h
> >>> +++ b/include/linux/gfp.h
> >>> @@ -383,6 +383,8 @@ extern void __free_pages(struct page *page, unsigned int order);
> >>>  extern void free_pages_nolock(struct page *page, unsigned int order);
> >>>  extern void free_pages(unsigned long addr, unsigned int order);
> >>>
> >>> +void free_pages_bulk(struct page *page, int nr_pages);
> >>> +
> >>>  #define __free_page(page) __free_pages((page), 0)
> >>>  #define free_page(addr) free_pages((addr), 0)
> >>>
> >>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>> index 822e05f1a964..5f11224cf353 100644
> >>> --- a/mm/page_alloc.c
> >>> +++ b/mm/page_alloc.c
> >>> @@ -5304,6 +5304,48 @@ static void ___free_pages(struct page *page, unsigned int
> >>> order,
> >>>  	}
> >>>  }
> >>>
> >>> +static void free_frozen_pages_bulk(struct page *page, int nr_pages)
> >>> +{
> >>> +	while (nr_pages) {
> >>> +		unsigned int fit_order, align_order, order;
> >>> +		unsigned long pfn;
> >>> +
> >>> +		pfn = page_to_pfn(page);
> >>> +		fit_order = ilog2(nr_pages);
> >>> +		align_order = pfn ? __ffs(pfn) : fit_order;
> >>> +		order = min3(fit_order, align_order, MAX_PAGE_ORDER);
> >>> +
> >>> +		free_frozen_pages(page, order);
> >>> +
> >>> +		page += 1U << order;
> >>> +		nr_pages -= 1U << order;
> >>> +	}
> >>> +}
> >>> +
> >>> +void free_pages_bulk(struct page *page, int nr_pages)
> >>> +{
> >>> +	struct page *start = NULL;
> >>> +	bool can_free;
> >>> +	int i;
> >>> +
> >>> +	for (i = 0; i < nr_pages; i++, page++) {
> >>> +		VM_BUG_ON_PAGE(PageHead(page), page);
> >>> +		VM_BUG_ON_PAGE(PageTail(page), page);
> >>> +
> >>> +		can_free = put_page_testzero(page);
> >>> +
> >>> +		if (!can_free && start) {
> >>> +			free_frozen_pages_bulk(start, page - start);
> >>> +			start = NULL;
> >>> +		} else if (can_free && !start) {
> >>> +			start = page;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	if (start)
> >>> +		free_frozen_pages_bulk(start, page - start);
> >>> +}
> >>> +
> >>>  /**
> >>>   * __free_pages - Free pages allocated with alloc_pages().
> >>>   * @page: The page pointer returned from alloc_pages().
> >>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >>> index ecbac900c35f..8f782bac1ece 100644
> >>> --- a/mm/vmalloc.c
> >>> +++ b/mm/vmalloc.c
> >>> @@ -3429,7 +3429,8 @@ void vfree_atomic(const void *addr)
> >>>  void vfree(const void *addr)
> >>>  {
> >>>  	struct vm_struct *vm;
> >>> -	int i;
> >>> +	struct page *start;
> >>> +	int i, nr;
> >>>
> >>>  	if (unlikely(in_interrupt())) {
> >>>  		vfree_atomic(addr);
> >>> @@ -3455,17 +3456,26 @@ void vfree(const void *addr)
> >>>  	/* All pages of vm should be charged to same memcg, so use first one. */
> >>>  	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
> >>>  		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
> >>> -	for (i = 0; i < vm->nr_pages; i++) {
> >>> +
> >>> +	start = vm->pages[0];
> >>> +	BUG_ON(!start);
> >>> +	nr = 1;
> >>> +	for (i = 1; i < vm->nr_pages; i++) {
> >>>  		struct page *page = vm->pages[i];
> >>>
> >>>  		BUG_ON(!page);
> >>> -		/*
> >>> -		 * High-order allocs for huge vmallocs are split, so
> >>> -		 * can be freed as an array of order-0 allocations
> >>> -		 */
> >>> -		__free_page(page);
> >>> -		cond_resched();
> >>> +
> >>> +		if (start + nr != page) {
> >>> +			free_pages_bulk(start, nr);
> >>> +			start = page;
> >>> +			nr = 1;
> >>> +			cond_resched();
> >>> +		} else {
> >>> +			nr++;
> >>> +		}
> >>>  	}
> >>> +	free_pages_bulk(start, nr);
> >>> +
> >>>  	if (!(vm->flags & VM_MAP_PUT_PAGES))
> >>>  		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
> >>>  	kvfree(vm->pages);
> >>> ---8<---
> >>
> >> I tested this on a performance monitoring system and see a huge improvement for 
> >> the test_vmalloc tests.
> >>
> >> Both columns are compared to v6.18. 6-19-0-rc1 has Vishal's change to allocate 
> >> large orders, which I previously reported the regressions for. vfree-high-order 
> >> adds the above patch to free contiguous order-0 pages in bulk.
> >>
> >> (R)/(I) means statistically significant regression/improvement. Results are 
> >> normalized so that less than zero is regression and greater than zero is 
> >> improvement.
> >>
> >> +-----------------+----------------------------------------------------------+--------------+------------------+
> >> | Benchmark       | Result Class                                             |   6-19-0-rc1 | vfree-high-order |
> >> +=================+==========================================================+==============+==================+
> >> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |  (R) -40.69% |        (I) 3.98% |
> >> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |        0.10% |           -1.47% |
> >> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |  (R) -22.74% |       (I) 11.57% |
> >> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |  (R) -23.63% |       (I) 47.42% |
> >> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |       -1.58% |      (I) 106.01% |
> >> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |  (R) -24.39% |       (I) 99.12% |
> >> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |    (I) 2.34% |      (I) 196.87% |
> >> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |  (R) -23.29% |      (I) 125.42% |
> >> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |    (I) 3.74% |      (I) 238.59% |
> >> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |  (R) -23.80% |      (I) 132.38% |
> >> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |   (R) -2.84% |      (I) 514.75% |
> >> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |        2.74% |            0.33% |
> >> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |        0.58% |            1.36% |
> >> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |       -0.66% |            1.48% |
> >> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |  (R) -25.24% |       (I) 77.95% |
> >> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |       -0.58% |            0.60% |
> >> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |  (R) -45.75% |        (I) 8.51% |
> >> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |  (R) -28.16% |       (I) 65.34% |
> >> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |       -0.54% |           -0.33% |
> >> +-----------------+----------------------------------------------------------+--------------+------------------+
> >>
> >> What do you think?
> >>
> > You were first :)
> > 
> > Some figures from me:
> > 
> > # Default(3 pages)
> 
> What is Default? I'm guessing it's the state prior to Vishal's patch?
> 
Right.

> > fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 541868 usec
> > fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 542515 usec
> > fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 541561 usec
> > fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 542951 usec
> > 
> > # Patch(3 pages)
> 
> What is Patch? I'm guessing state after applying both Vishal's and my patches?
> 
Right.

--
Uladzislau Rezki

