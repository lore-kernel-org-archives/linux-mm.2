Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE20C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 10:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2309C6B008A; Fri,  8 Aug 2025 06:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208726B008C; Fri,  8 Aug 2025 06:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E0B6B0093; Fri,  8 Aug 2025 06:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02E8E6B008A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 06:18:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F9A6117E22
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:18:36 +0000 (UTC)
X-FDA: 83753191032.01.19C1C77
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99443100006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:18:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mogzh9xo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754648314; a=rsa-sha256;
	cv=none;
	b=71UN0SPSflfTz5G/Jk0oHo3bMH9k1ScrOl/1GqqMJRmh5/Vq4XCbXfGRA6rdU7UHLfIrP9
	9iB+/QzSPTYdaY6Xo1rXzbDHIvaSKHro094TtSOs3XBURtYKH7ZenHMC5EUhFlbjwaCvox
	Ywm2FOI5Wpxxw5dsloIqGeJJjD1Sdvk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mogzh9xo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754648314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFpV2UfwtJi7jtfjpuA/lo/gdccwZuyYsBGQpSGx3dc=;
	b=i7ZMhqaA4qiTZsYF9NQJJLyfnqqcL2wDqhXBRRw6a29dsECFwaEtKlRGvUrbFyQ3uOM/H+
	YBJrIS7KK9on3yyPnxmORi5Fv/ogG/rW7r8B5T+DIlp+sx1Fp5G2jsx5eojqpsNkH+AVuN
	KQk8deUx6gohiQ857liX/x8NZppnXmc=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5550dca1241so1854446e87.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 03:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754648313; x=1755253113; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hFpV2UfwtJi7jtfjpuA/lo/gdccwZuyYsBGQpSGx3dc=;
        b=Mogzh9xoRPd0QX1aR730SuOOQ+9G4/cWS9hVMKeFBsWSCMM95yrxDwxiLYTQ+86K7t
         16BnfSsUqqWSA9kPHqL81dmQMz7hJ7l/2fXaJT22jlD5MS2TmeZJYlwLeBIi58DBKHib
         1Jpe6umjtAcwFwvb269E4J1ZrBwxprcMqS13O59zJr28EN8joxlLN55c3c/Wz9p7FyPU
         5cECUVipGNL2tVy9MMaH8aezEc7PcJ7ST5wWl2HkHWHrveZ3nC6flnBttYHDlFNDJ4hX
         qt43RwM/czu3T1tj6ToILSXrqmELUYajtZmOKF0j4AzsTqFnSGHg9KH0U8U13nQTlzku
         Yh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754648313; x=1755253113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hFpV2UfwtJi7jtfjpuA/lo/gdccwZuyYsBGQpSGx3dc=;
        b=BiEkS3jpivBcGTyTJT8gFxuxwVhmlFQTQ5y+h2V//s/WS3Jvo0p4/QyClmh1LNTtFe
         XbfHVuwKfEDFJbVrlAezA/ykxMN3/tbyXc1h3MWFGur1+hFgXiTP9AV5AYMKrpuUQbHl
         Zcz7KrNQ/SIpcNq+bwibglRtunuBaL9Mzekad9qkdpiqUvEcaNTmF8mUsEdj3YG93sgj
         znwMl1vnweewFzTdykypABkWO/zGi1AX29Y8Xvj5/9OaVIkmjEDVaJ51sHr9pvD1rvXI
         gU8LBidCApFs/HpNGStnJ9g6WvcIlRkVF1dXCfOndgidpTeqec43TOrTKHG2lNhF15QP
         Quig==
X-Forwarded-Encrypted: i=1; AJvYcCXmc43SW6vEf2qCpYVEX5FHEfoP8dNBS+JHI46Od6IeN2xtT5K8kctZX4DrhPtr36PlssYbPBvtng==@kvack.org
X-Gm-Message-State: AOJu0YxgJsrClumHJs6IFlDL0VPHDr49j/OD81wovL2xnarV/4jUq6iI
	/SBEFTlGJyUACm7zKFSd/EKI6DwXuKz2XHgsUTt2xY8QnCCPq+HozSKJ
X-Gm-Gg: ASbGnctVyr7s+d0EAzcMo9Gh8XEeETn06aqYrymdHZJ6C/ZgxsLRiwzj0YfM4O+/Yxy
	iQsqI60CB5aGXUvAjwmUmsRTMqZp1DTiWJnaJzjFtbVPiRomHvag7nXmYfSoNwhz8x2j8smuIGR
	2w2spPK/kVVHqW1b45gLfSp47+jXLHc6lE3WcVDNVwEcrBiczCu++RVi3cOe3doaPLCYRhL9K59
	F62KGhNv1Rz5DsOQ6Qq0++nslmuWoJEUgkO9hxbCTK/pn1SUi+SWfVIxMvgnLKI9gwBByldg9qx
	RHjaIgVVFczSto4SFk9zme4bTG5QTpOWGlDEAlJDZ+I/aYqR0YoNlEkrn9OvdFGZX1J9tziZnK8
	wNzSFSbxUVSmwMBLKWo9s2ExjaneygF/Q+WL6jt5E04D+/Ku3WQ==
X-Google-Smtp-Source: AGHT+IGblVVXv4xgi3EmfmQQEQLXknArUFeZhkclCEdH9tMt2CWBMfgNwUaDFuUesG53xwDyk7NCMA==
X-Received: by 2002:a05:6512:ba1:b0:553:2f57:f8af with SMTP id 2adb3069b0e04-55cc0086413mr641911e87.20.1754648312518;
        Fri, 08 Aug 2025 03:18:32 -0700 (PDT)
Received: from pc636 (host-90-233-217-11.mobileonline.telia.com. [90.233.217.11])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88db2214sm2914329e87.177.2025.08.08.03.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 03:18:31 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 8 Aug 2025 12:18:29 +0200
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 5/8] mm/kasan, mm/vmalloc: Respect GFP flags in
 kasan_populate_vmalloc()
Message-ID: <aJXO9WwavhYFPykU@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-6-urezki@gmail.com>
 <0d24f6b7-0e4c-4879-87f2-e31ad988baad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d24f6b7-0e4c-4879-87f2-e31ad988baad@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99443100006
X-Stat-Signature: esx9kbpex4yccr8xcmte7zq1ius35g9m
X-Rspam-User: 
X-HE-Tag: 1754648314-509628
X-HE-Meta: U2FsdGVkX1+G1bLQZZeAkjoduXr6M1JaGiecgo0rkCaAQC13GRKPb6aBJaZ/nAdTpLZ9Sc2yRWutfyOqEWViJtu0v2DPNZvNYr2UylTbyq4rJKWqg4lf+99QImEL5y5sQrcjBMZl+kUoxdKL4ImI7lH3SteQEBTqFO5wp+eETjJYQg0qlDbS6LtIF6DpsBO68kclOWeARpEuNC/icIknx3zVj3BDE3GlFyjzNpgni1sxMZWDn/hOoihDQenzYlmVzlmMtfd44H/M47zCQEGTEsv+wqq/Qu4ma1TB+8IAeoh743JEgvRi+lhmVRZ9o3qaJW7lHRPb4LUhNxZv2OydmYpSi26ozmEVkhWx0qjhD/VqLC9gdJBqCwbKdWoPVl+deKOAsYLkX/D9lWYvkalRFkGXEr/V5sSLNx6vpHwTcKxe63CxoXc3Zp2yugLUCS8DrQfvvtxkaL1NT/GUh8lZVdwu72MZGfqo8h0MHnTj6kCgvdQ0u42c/N//guvpTSrXJYuWF3+MAAnaqH24AvgTcv4CWbne58HsoVN+aNSe8vIdb0NAG8bCzXzjRzcMaAx09jXQnmobLRPlSKzrbyUWjzQtr4aMOATTtDnAAhxFlv4tDG1N/b34j3Pk3hPg+Fww7gi3QbnZLOfC/6c2sEhCTQE2TLaqvH2tASL7zX89L4RQvIUx+F3iJ0pjFugT9qUS06bu3FtN+iu+HexZn4pm4fsG0Tw0liHtM3kvnHGwqKE1bzNNzb1BSCOnEYdFOgnkC2tAtb+FyldsNa/NwUv8L21RGdzYUbTWSpNHvEduzioMFvy7N/5qi/vh0LHF/04bfgdgxCOxcJ+eb2JxlJtvu2kdatLI1pvNCHpQWyLdfm8eJG5wHDuoFBG3W0REH3e+d6gb9ClCYgBGwlK8E033hBY5JpXy2AWrqMvCCi/WGN1CY7Gt0GQ4nli7IqXX6B4UDlzfoNoMrAqIMxnOdDO
 iAkMp3S3
 OC/NaR1bnM13mUvJ6r1L5VCjeuH4Z6f4YPDnQZFK2zedWRGg1YJhfHGDu7mN9u+fq5/lYnk07FAiua4VGQQqUL6rtr5yVbUxt80C3w5F6UflVZi4g0PuYfo8nR6wDnj7tjKAkG9kD1pKF1v9fuppdzq6SY0R9zFEuEDe7wYHB6nC+0gUeojOVFtKipRxQZ6zKlf0+A4dHTBygRNmI1BPGQBAv1KpM7Gca7qb5JFgBl7xaAAex1zQ2E1CTSn9dWuRNNy2+Yy3gDEtdgcwPEeTW9HiQCorrq6uotp3TgCRQj6KRVLaTTGXBfY8Z1wW/qLB/4FAF53/aur/yktFT0HoRqPuWWj7Ra6kbSMHnyk4VbHOBs/4805rYxIU2dTEz37kDUKtsk+3ycIi8Mky+yF5sf1dm7lsiaX1oKcV93SqsIwdhBXYSWKsyXx043zSBX2y6i60HdrQx+qTE/7QR2kELvldUeUzbPZFxVtxZI5+BK5z7Q+L9+2iX8GmFXxpJ7FnWH1pUQpsSkz9Zz156p7f0nx3AypXBac3qL7j5nx1qAOAjyxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 06:05:21PM +0200, Andrey Ryabinin wrote:
> 
> On 8/7/25 9:58 AM, Uladzislau Rezki (Sony) wrote:
> 
> > diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> > index d2c70cd2afb1..5edfc1f6b53e 100644
> > --- a/mm/kasan/shadow.c
> > +++ b/mm/kasan/shadow.c
> > @@ -335,13 +335,13 @@ static void ___free_pages_bulk(struct page **pages, int nr_pages)
> >  	}
> >  }
> >  
> > -static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
> > +static int ___alloc_pages_bulk(struct page **pages, int nr_pages, gfp_t gfp_mask)
> >  {
> >  	unsigned long nr_populated, nr_total = nr_pages;
> >  	struct page **page_array = pages;
> >  
> >  	while (nr_pages) {
> > -		nr_populated = alloc_pages_bulk(GFP_KERNEL, nr_pages, pages);
> > +		nr_populated = alloc_pages_bulk(gfp_mask, nr_pages, pages);
> >  		if (!nr_populated) {
> >  			___free_pages_bulk(page_array, nr_total - nr_pages);
> >  			return -ENOMEM;
> > @@ -353,25 +353,33 @@ static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
> >  	return 0;
> >  }
> >  
> > -static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
> > +static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_t gfp_mask)
> >  {
> >  	unsigned long nr_pages, nr_total = PFN_UP(end - start);
> > +	bool noblock = !gfpflags_allow_blocking(gfp_mask);
> >  	struct vmalloc_populate_data data;
> > +	unsigned int flags;
> >  	int ret = 0;
> 
> gfp_mask = (gfp_mask & GFP_RECLAIM_MASK);
> 
> 
> But it might be better to do this in alloc_vmap_area().
> In alloc_vmap_area() we have this:
> 
> retry:
> 	if (IS_ERR_VALUE(addr)) {
> 		preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, node);
> 
> which probably needs GFP_RECLAIM_MASK too.
> 
Thank you for pointing to this. I will check it!

> >  
> > -	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> > +	data.pages = (struct page **)__get_free_page(gfp_mask | __GFP_ZERO);
> >  	if (!data.pages)
> >  		return -ENOMEM;
> >  
> >  	while (nr_total) {
> >  		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
> > -		ret = ___alloc_pages_bulk(data.pages, nr_pages);
> > +		ret = ___alloc_pages_bulk(data.pages, nr_pages, gfp_mask);
> >  		if (ret)
> >  			break;
> >  
> >  		data.start = start;
> > +		if (noblock)
> > +			flags = memalloc_noreclaim_save();
> > +
> 
> 
> This should be the same as in __vmalloc_area_node():
> 
> 	if (noblock)
> 		flags = memalloc_noreclaim_save();
> 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
>  		flags = memalloc_nofs_save();
>  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
>  		flags = memalloc_noio_save();
> 
> 
> It would be better to fix noio/nofs stuff first with separate patch, as it's
> bug and needs cc stable. And add support for noblock in follow up.
> 
Right. KASAN was not fixed together with vmalloc. I will look into it.

> It might be a good idea to consolidate such logic in separate function,
> memalloc_save(gfp_mask)/memalloc_restore(gfp_mask, flags) ?
> 
> >  		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
> >  					  kasan_populate_vmalloc_pte, &data);
> > +		if (noblock)
> > +			memalloc_noreclaim_restore(flags);
> > +
> >  		___free_pages_bulk(data.pages, nr_pages);
> >  		if (ret)
>
Sounds good.

Thank you.

--
Uladzislau Rezki

