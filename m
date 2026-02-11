Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE236ECD6C4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405616B009F; Wed, 11 Feb 2026 11:09:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2EE6B00A1; Wed, 11 Feb 2026 11:09:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B2A16B00A2; Wed, 11 Feb 2026 11:09:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3626B009F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:09:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6DA31B3BD1
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:09:04 +0000 (UTC)
X-FDA: 84432659808.03.AC627E6
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 16DC5120014
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:09:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ktUA/uul";
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770826143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HM2IjAcTUnEdBWt63uoKHzhXSYFluNXHm3QawevxRTY=;
	b=3/oAotBc2cWvld94eXrx5h9pLglymhHGgDHW+puIv+c4omTUffP1P1zjNnr2OnuZt8Waf9
	ekaj3CffVR2A0BNph0cCOS8FGjVWHZIFZraw0FE70RRfjfdj0DxaX9wq7bk4e5RFj8rD9Y
	z+eQTDJA2vr0JCrYwRCbMmPDFcAlVBw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ktUA/uul";
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770826143; a=rsa-sha256;
	cv=none;
	b=qW5NuOTaB4yAMZJxZQ8ve+ZZXrJTwKob6lar0y8VWoMLwGgVkq1sIObobt59Xp+rXRDjma
	F249u9w8wkKma1/zcNhuAv1PzlxVlGEg60JbSKlLHe9JTNjbq8CVHW1F2pn7JAuKHsRzsL
	6bLm1wv9Xk++aZpTMee5asvAn0tr0Go=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8c70ce93afaso229029585a.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770826142; x=1771430942; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HM2IjAcTUnEdBWt63uoKHzhXSYFluNXHm3QawevxRTY=;
        b=ktUA/uulMR+2dKfRLsHQZNrt1o3z+jOtUpXnOIXrRNd77/Yg4Xskb/kII3+BNyMU15
         ENjahBswg+QAfGu2Pc8pbatXzi99t56b0yRzBMQzbcjNA1kFAOa1BstxoAb800uGs9BH
         W/Sx13bDUnWu6X4fuQixp8U1/Tful4xeePVaRo5SmiLCov8kgxRLzz+xAR3W6hAFHqOH
         06ylIvom1hlZUYIc85h26cz+htCz8GiPKbqJpYUsOtLBPMa/VWF/SRHt1VYKCQKPmmVP
         bz9nBkEpH6WPPQde507OKqMrdnjLAZoQDqju7sCYKX9syAQ1pRFxA9MKGrwZ2s+seXw4
         56Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770826142; x=1771430942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HM2IjAcTUnEdBWt63uoKHzhXSYFluNXHm3QawevxRTY=;
        b=QGXLM0gzZEZQZKFzkqXWdMtw3KourjPHrzOGEE0JA0BriSyy52QrjqsuwNcaDZgJNy
         DViD4qpeXfSex4yX4knVA7RdrhgHcS1IRDk97QXuYRfxu0L1xmX1Fr+josIre1Z6EI1d
         dAm4Y+j4YUVTcPJcKuaGpAnED21QnbsItv+CrNvgthC0hWr+n8cFEFGZXfiYJ6ANEr+u
         u75jv1K0tQZcc6D3+fyg2IhYGMPV3aqCTvTwum+Aq2d0c7M6fZz5lqV7B+nxUms0CpoW
         7HJXL1qOVZfdSNcXOYzyrk6LR405xAcFkXyRmGVoASB08aZl2gg7tJsnHjBZYoELy9Oh
         unpw==
X-Forwarded-Encrypted: i=1; AJvYcCVTiqNTYhhnrM9d3EuWhB9hFFv4t8L+lgIwfievl++5H4X/sYB5XkE8gDsrYKD05CyyhzX5ZbOroA==@kvack.org
X-Gm-Message-State: AOJu0YwD5T+LZlefpDkNglJo+uuUGDDANyiMl/g11W3jLBM9T6xxEue2
	8FLt7W8xnJ5vVoHxXKPuXwPM2hD9oFgGp54gXal7TOubdsR/Qx+xy4V2Qre+FmSJHJY=
X-Gm-Gg: AZuq6aLKoqS/uzztFtPN2BypfdWpE2XnnBr85VZ2Gj4XK8fOCLWty/CXJILz6Gp6844
	q2RdsNwp4haGJP4EsGClysOTFatfeax7wJyfehxZ25VU2TguUjgdbHjgmWMZJm5xvc8q9cfI/kZ
	Qo8mZSS/WntfI5y9kcasoa1EfqbnEUivJREQ7XWzjgBx3fZorOOrGVsm+DzEDgO5p/NVkALrZkg
	yRYrJxV6rvLmbVaHBii8u0P/5Akh6IfdXNUj2urPar9CizYUhCSh4aOib9Q+g3+CHXoO5UAaM2h
	rDRUbiYt16l3VhXyeNJSw/DuVwOwIgHY1PfhbyF6nQSKmlOathSuoG8lu9c5TzbzfN61nrBQPq3
	X+/1eRDux1YhlQRlRjEdCYyw77lB82kPE841o4oE84NGneYkNzZxlY/9SZSJr45MozVld/V4Ei4
	zSwDs0Oe9eQqR+Ac070acO3/yxUhohkznxcqrKyjeavmieP8F6H77iTRQAPvW8mi3WMqo3TVlLc
	/85elZ9/w==
X-Received: by 2002:ac8:5fca:0:b0:502:6ed5:7b0c with SMTP id d75a77b69052e-50639a0decemr242931101cf.71.1770826141985;
        Wed, 11 Feb 2026 08:09:01 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cca9b6bsm18300556d6.23.2026.02.11.08.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 08:09:01 -0800 (PST)
Date: Wed, 11 Feb 2026 11:08:59 -0500
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v5 03/10] mm: Hot page tracking and promotion
Message-ID: <aYypm59N7SlS3Gme@gourry-fedora-PF4VCD3F>
References: <20260129144043.231636-1-bharata@amd.com>
 <20260129144043.231636-4-bharata@amd.com>
 <7c6d427a-9fe4-4af0-93c8-18ecb2296e36@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c6d427a-9fe4-4af0-93c8-18ecb2296e36@amd.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16DC5120014
X-Stat-Signature: ho9usa67x378chomamjehba6xno715fg
X-Rspam-User: 
X-HE-Tag: 1770826142-459179
X-HE-Meta: U2FsdGVkX1/Q39rUpgEIptZJOE6Zcg/dskqADxtBBVsPCVAK8i+D2ax9Z5aO6mZh1dDCJxr3e4nPeH44AyRw6cwSv/vmnXkTFW5EnspBOg+GEh6co214X4XyQweXH1JuNtviHgGtZXXLkU67UXanAVxExckty3D3tSXegRoWtUh34TLO+MsBEa7GwKUepoaROPsRGyJWfXd4s6HZSC5LZ1C/GsxAFnYizEt21Y9SVlOBtoJBvt1d4a8BWJ/dw1qrWupzm3PCOT+SNOGUostQNuWMYLNEVjNTCBO51CtTpwMuB4ASaZzcTrdQi7yVm5VPslCmaH+ea86Zx91srGaCqNPGNfY5pKw4rUH8Zdwic+jDT3Hsbvzi3WU2URdAR9Rg4PB9GvTJPpJ6eFNuMhFGKTP4irXVEkh+jvf2nMVTT5Zdig8zl3uh3ZUZs3+KO3M1aoaB34KzB3SQd6Z0xYqtQUAY6rjT28EVmVyPgL+lsApbzV0KgxKmnzlhalfbIasDMhn9bXZ16rprNXPq1fJfH4VLYQtpYvLSURnSwKMhvyGkahVdORaa/3lNshelN/pFghf+6S+XDGl3usfnKR8NWkhSIg0/S393N9FGUM3m1flz8NRMzBl04ik5d2afKDTFB222STWmKFwaVqMtkNjm+7SXBIIIsUCFczk6C+zEjAdUfpfk33Wq/OdHvz/BD4sYpclPQdPUr5CY9rWNc4txOudmgjHTXXX5SUiUI8fg964CQrC8USqv/eyaYGAVwhx1ohwbjNIEcSI63Ix8yAqcbxab3iR5pmfQY75Q7IOTqZmskdJDl7swh5JaMoc1vmgsPTjke2VHu+Das6clN0uuqA+pcUpqiwpLGpGRN1w7mBSSdaIFTbQOo13tep8P36p7Truby7kGqGW0jZHiBYAKTZpcscgiZA+XGnTfDp+c1AfCMyx83lS/jpAWzkw8F1wwj+tlu8sBWM7yqtgEWNB
 TnDyeZqt
 EAtG9PfMbVXClbEHseCpgh0gSFBl/ZPhBHdGBmCi0V06PEw5y02Zc4qxDZfvwqn/v9Yu3AqzL/Zfns23XMgNAoK/kko8gyYKLHln0wT4K/Rf0QIWjLr8VuOcYGJwV3Xhze3HUR3LJy9Oti9y4SwVNwj77tkR5Bz9aK771Zj5yBd5ci0N9Jyum4BDNSymRCWf9OCiFTCXD+fmGLPmP8uFtWgbT+hdqEZDiUyBWczzxpSeDZKvu9KZKCVJ8Il6g8KfI93gv9VPx9KZMcSb+Qh41151irgb0pK5/46V0GAJxd4TkKy0pHqux2+H0DpjVSqq2lHGCxcnsymyJ1sUpTyky26kcA1fOhX5wIvNoSIWzuhHMDqYEsohTcee6d4FKQ2h3f5/xe8I7u/jxWiwBrwi9RK8ldw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:10:23PM +0530, Bharata B Rao wrote:
> On 29-Jan-26 8:10 PM, Bharata B Rao wrote:
> > +
> > +/*
> > + * Walks the PFNs of the zone, isolates and migrates them in batches.
> > + */
> > +static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
> > +				int src_nid)
> > +{
> > +	int cur_nid = NUMA_NO_NODE;
> > +	LIST_HEAD(migrate_list);
> > +	int batch_count = 0;
> > +	struct folio *folio;
> > +	struct page *page;
> > +	unsigned long pfn;
> > +
> > +	pfn = start_pfn;
> > +	do {
> > +		int nid = NUMA_NO_NODE, nr = 1;
> > +		int freq = 0;
> > +		unsigned long time = 0;
> > +
> > +		if (!pfn_valid(pfn))
> > +			goto out_next;
> > +
> > +		page = pfn_to_online_page(pfn);
> > +		if (!page)
> > +			goto out_next;
> > +
> > +		folio = page_folio(page);
> > +		nr = folio_nr_pages(folio);
> > +		if (folio_nid(folio) != src_nid)
> > +			goto out_next;
> > +
> > +		if (!folio_test_lru(folio))
> > +			goto out_next;
> > +
> > +		if (pghot_get_hotness(pfn, &nid, &freq, &time))
> > +			goto out_next;
> > +
> > +		if (nid == NUMA_NO_NODE)
> > +			nid = pghot_target_nid;
> > +
> > +		if (folio_nid(folio) == nid)
> > +			goto out_next;
> > +
> > +		if (migrate_misplaced_folio_prepare(folio, NULL, nid))
> > +			goto out_next;
> 
> We should hold a folio reference before the above call which will isolate the
> folio from LRU. Otherwise we may hit
> 

Also relevant note from other work I'm doing, we may want a fast-out for
zone-device folios here.  We should not bother tracking those at all.

(this may also become relevant for private-node memory as well, but I
may try to generalize zone_device & private-node checks as the
conditions are very similar).

~Gregory

