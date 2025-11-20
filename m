Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63604CF64BC
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA2E6B0005; Thu, 20 Nov 2025 00:26:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A816B0022; Thu, 20 Nov 2025 00:26:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF6B6B0023; Thu, 20 Nov 2025 00:26:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 880CB6B0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:26:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40C10BB194
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:26:11 +0000 (UTC)
X-FDA: 84129849342.30.FF2C008
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 263E4180017
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:26:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=qXme2O7N;
	spf=pass (imf24.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763616369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUqeS6K4g0hUxh5GcRzYb7k8IKeXwg6G9epDSLnS8mY=;
	b=InrL6OFfy4PFc59daho+xiyNfDtrnIDNK/96kHJFehCeN0pUSy2RXI3AL5xUtsaS80BJTE
	nqSiSJiIIjz+842DbOyxQu3hh1O92I5EsJRsVKfzPk1fV7qVq4mVw/IRUKLvQAaxwsS+eo
	nyrCqmFOn4byULNPAyHAAasD/Q1j4aw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=qXme2O7N;
	spf=pass (imf24.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763616369; a=rsa-sha256;
	cv=none;
	b=uES9XJj9FLp2Qw8vgHdj5OZddLpFlObHRu2+3dKA3HBK2znoe/ZwRCwTLpHx8ZFs2NreAg
	qgs8cikPdZET/C8gxKpKvdBm2rK3KwbOH9GU+12ZHgYyCt1AMCHgpAfMGvk+08QwdgR6TH
	aTrur2UVn7wErh4afQtCY3s74yNuTIw=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477619f8ae5so2535045e9.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763616367; x=1764221167; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vUqeS6K4g0hUxh5GcRzYb7k8IKeXwg6G9epDSLnS8mY=;
        b=qXme2O7NqCbpUpcd4ZJS2hYVIl1ragLBOg885rFQgFNNusTRCWE3ESjpVJBMMRcw6a
         JiyTytg6WScwptpcDnJsmgTEyrszdpv8Sn0r4J1f8VLIlkhDr5Mq1UV3oRe0IZ1umSM1
         m+87zBqqwRRy0qzG2ZWO0qGgvdaI1Ij6u/2/Ip21wdytAIitf/QaTX8j4yDjkiwkJdTi
         T7APxzynuLUmGJ6JW6DxddoDZZG0kRtVnrwXwzURwNAji+ew0TZKMrQNQ5dfXbqDetLI
         ubh6GXibnRonGEMplW82cRnGdEJSdshZ8IazBDUQdU4TCHi28kyuunzi5aQaxeBQxMaE
         hfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763616367; x=1764221167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vUqeS6K4g0hUxh5GcRzYb7k8IKeXwg6G9epDSLnS8mY=;
        b=QAFbDgO2fIkh4DxBnkdd86Ye1HQimPmV2vZVpkbfy1YpGFLRUYCSk1upiGOEIn5Ykk
         fvs3+ETPUmkN9fYCpDpUMpkwEcIo2GF+s+mmOZ8YX57mXUI1WgTSoZ4P6o7nrUa8e7hs
         krjxegTtNQdKqQaVOEMqQnBvEv6vZjTvM+y7N5DdboUk+xfd6L/dWeE2rsGrJfU/KOsA
         tyPsTvLBc5+RX0NrAnnTN1/v9ZRD2G7e2BnDehOs8FTZjyQcWb/eq4/Kwwdyk4IY+YME
         rCLLL4+ID6erpDAgUslxkL6H4nXWp2LU5FpiCI/16jBBOiob6cns/edLmV9MuFYihm/s
         L6jg==
X-Forwarded-Encrypted: i=1; AJvYcCVxYh0ESMeT7OcbUOgRxm/vzI8vlLMZEm0rcIF/BazD3u8UFPOMb7biy667t/8yR2q4ZPHywYV/Tw==@kvack.org
X-Gm-Message-State: AOJu0YyB5F+TgNi9ZyXHN7tqy9dU1rkXBt6+KoFjcCjuA+jTKx/LcSfw
	koLORZ4RFh9GvgQXIq9f5jIGzsCzojrtI+X7Pyq79lkvueLjPPIKkx5iLkOxS7akb2Q=
X-Gm-Gg: ASbGncvne2jWVMLUBjiL+Z1X3KXsJrS/4UFVvFcwStQdIVDDAZd5B+j3zWfIdw91a2a
	Zqrbuh5sXWK20t7MFNEGqrhyIqsswHo3pacG7X0AQ1AoD/EzGwmtEDi8DtgsXZw+EUaiXlMuGkH
	vZpuZniiN/DcaYBKxrbj2VcMHnD7o2Lu4RQFRTT21SZn12lH8d40X+2BRbyUG4hB75XqHIyJiNX
	sbrhz6kiTp+ZVtZW4rnRodBMk8RjrI4ZnWcAmtc7VCG7qxpNIpv0l+SerwP5rI17zm681+eY9HA
	0OFfMSlirNckj5BzUau/zhSo+vvZOjtlwdh4fzbqEJoPdYrAJ7w2+5zK6dEg6vIs9vWlUQGvyCS
	fIJKg4jqqDcZK+gV6UN8WW3IC9hljaLd5Y4TkN8Bf/lmP4X/wWyjbbBEDkZqhdxB/bGvDuwFodB
	e+VHA6aQ/fIc085Zv9
X-Google-Smtp-Source: AGHT+IFWWOupAlmioPPlt+riq99upzqU3hX3m2vpY2Y33m3pRyb3Gi9KlUndDLVMEA6CzkdsEjgEWg==
X-Received: by 2002:a05:600c:4746:b0:471:1774:3003 with SMTP id 5b1f17b1804b1-477bac1d90bmr5158065e9.29.1763616367195;
        Wed, 19 Nov 2025 21:26:07 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-477a9df8db3sm53497665e9.11.2025.11.19.21.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 21:26:06 -0800 (PST)
Date: Thu, 20 Nov 2025 08:26:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: oe-kbuild@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
Message-ID: <aR6max8N4djU5OVB@stanley.mountain>
References: <202511151216.rhK2ItOb-lkp@intel.com>
 <661d1f3b-0f04-43fc-85ef-d29d492a2b06@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <661d1f3b-0f04-43fc-85ef-d29d492a2b06@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 263E4180017
X-Stat-Signature: h57kqkeqhbupbnccgy5t7mny1uojztfz
X-Rspam-User: 
X-HE-Tag: 1763616368-483917
X-HE-Meta: U2FsdGVkX18qNGFkm1SQ/QRBz1+6Nxm6PN/L2JoS2QsNHAWcwhkru3XpHmI994WykOGL1AUX3bzqCI4GFad7ZurzvaTPDXP7HYgcMWLyUFzoKbAgVcCr3Th/29qzAQ26GR8D4gSaNlSOUyauYjnuW4N1iBfLA6VtyiYAG0z7Z2J/a0baa/pMS7tEucrMGsx4TWmMcmyOhIM0jq3FSFbJTi3iOxDuMc0bUxcTS91NGj7Usimd4IHu1OZ24x6Z3phmYA6wlRm6a3EXeiq5SkyOfYCULfYraLI6Jgd72rAYKfAXkP/AoUjMfL1vsht8CChR8K472m+Q89IyeVHIPScrylsYpUMW7RBpGopnl1Gpgfvy3w1HSf+h6awAIpX06Klo/K8MaTj+jWjN5SDuSlSQOb5b+oKnmx5vvS+VbA/368Z5QvBtXYw9tbD+YTLgMgusZI94Y9jf57KfY/TnIwM/+Znzh4+dbZrsk6hykivgF7dIsZYBaLzUI5+hE7OxqUjCwFpjrwuvdmh+f2CRVh/615DNZO5eHMHOReZYKM6AiTCzYr9aO/0QUFK+gPwu2Et/skglgUXmJxG46QG8kC9Hr4KfJKVbWjqhhCoz9RpV0mpHsn1WFynCNBErgGWfo2/0vJ65iBvCxr4GG60wyr0FHsPW8LdOSSm8vPK5M2gZ7Fxtlbnhpp3frfUOjgC4+lIfMfCUEGujanb0hYqikn/cz1AaYokLkrc1lZRCsUxDF57oD4qSV12ihecWgg6goZf1k+P5OvLfoh39ChjVA9SEvrJYabXMiL1stYcwqlMrzofsILjnhf6gzcR7nwVUFRTwTZrXb46Nh7nEsQAdQeoeQt4qpvHlRw0/vX8X6Ww8tV6uKj4qrv6TBszm3oFDPlHjsLpR26gc/4v9nT417txUORubzYS+DZlubUfpT98Ey4FE28dJxl9WU8SlwFFuO+0dIn/n4epUq95mK4ULaSd
 EJSlS66l
 AVmxOIDO9Vq2n5kN3h1+u1LIrHYnSQPS7Qkl8OFvg4ebl5ZGTZy0uT4y27QiBuPtC5rF8tdbV5ICKdk5PYYd4GEJLNEGucxehenmbiWZZAFepu7j2kVx//+6srUGmiypgXDqc3hPBCVE1k/bfqkRSUSpAIZAgMwbqyYLX8950UGOV8DwfzbuKE6We+i454iRoMOx5KUp2v1XmMbz/09u8B0BzXWWOo0n76BZ5r73c1FspC27YB/pISSHzcIGa36Zb7ubuvF7ZFWVijnFCJELdxV1JFKS30PB6563CGvMbAKdjgs9p6f2BM0VZKmRFTYSnU7dLE/lq4pwQBJmh9j7q4lBcEUDLMe5i8FjCR6OhXroXlOzUVn2t3HRt34VcfXm2UctO0xQGB7rW1QXAMb4YQR2H6g8yOD8OKT5B2Km6NH7PEqMbJ9sdKs0ripRSoUeftLz/svZjD0MDhRs1bOYwv7bq5ri74aiapoMhm3JoohpPymRy847WTSTeqcM+cDz310wPkoqKpLLhZ7wOLFWyC3H5MHfD47x1O4lVu/bBoE7sraGDvshTaUSbj+4Nok7f9xLuv4fUuon3dbILNe19/B98oPTmCpjk62tR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:58:07AM +1100, Balbir Singh wrote:
> On 11/19/25 23:32, Dan Carpenter wrote:
> > Hi Balbir,
> > 
> > kernel test robot noticed the following build warnings:
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Balbir-Singh/mm-huge_memory-c-introduce-folio_split_unmapped/20251114-093541
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > patch link:    https://lore.kernel.org/r/20251114012228.2634882-1-balbirs%40nvidia.com
> > patch subject: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
> > config: i386-randconfig-141-20251115 (https://download.01.org/0day-ci/archive/20251115/202511151216.rhK2ItOb-lkp@intel.com/config)
> > compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > | Closes: https://lore.kernel.org/r/202511151216.rhK2ItOb-lkp@intel.com/
> > 
> > smatch warnings:
> > mm/huge_memory.c:4044 __folio_split() error: uninitialized symbol 'end'.
> > mm/huge_memory.c:4052 __folio_split() error: we previously assumed 'mapping' could be null (see line 4046)
> > 
> 
> Thanks for the report!
> 
> If mapping is not NULL, end is initialized. More comments on UBSan below
> 
> > vim +/end +4044 mm/huge_memory.c
> > 
> > 6384dd1d18de7b Zi Yan                  2025-03-07  3908  static int __folio_split(struct folio *folio, unsigned int new_order,
> > 58729c04cf1092 Zi Yan                  2025-03-07  3909  		struct page *split_at, struct page *lock_at,
> > f6b1f167ffe29f Balbir Singh            2025-11-14  3910  		struct list_head *list, enum split_type split_type)
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3911  {
> > 58729c04cf1092 Zi Yan                  2025-03-07  3912  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
> > 6c7de9c83be68b Zi Yan                  2025-07-18  3913  	struct folio *end_folio = folio_next(folio);
> > 5d65c8d758f259 Barry Song              2024-08-24  3914  	bool is_anon = folio_test_anon(folio);
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3915  	struct address_space *mapping = NULL;
> > 5d65c8d758f259 Barry Song              2024-08-24  3916  	struct anon_vma *anon_vma = NULL;
> > 8ec26327c18e1d Wei Yang                2025-10-10  3917  	int old_order = folio_order(folio);
> > 6c7de9c83be68b Zi Yan                  2025-07-18  3918  	struct folio *new_folio, *next;
> > 391dc7f40590d7 Zi Yan                  2025-07-18  3919  	int nr_shmem_dropped = 0;
> > 391dc7f40590d7 Zi Yan                  2025-07-18  3920  	int remap_flags = 0;
> > 504e070dc08f75 Yang Shi                2021-06-15  3921  	int extra_pins, ret;
> > 006d3ff27e884f Hugh Dickins            2018-11-30  3922  	pgoff_t end;
> > 478d134e9506c7 Xu Yu                   2022-04-28  3923  	bool is_hzp;
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3924  
> > 714b056c832106 Zi Yan                  2025-07-17  3925  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > 714b056c832106 Zi Yan                  2025-07-17  3926  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3927  
> > 58729c04cf1092 Zi Yan                  2025-03-07  3928  	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
> > 1412ecb3d256e5 Zi Yan                  2024-03-07  3929  		return -EINVAL;
> > 1412ecb3d256e5 Zi Yan                  2024-03-07  3930  
> > 8ec26327c18e1d Wei Yang                2025-10-10  3931  	if (new_order >= old_order)
> > c010d47f107f60 Zi Yan                  2024-02-26  3932  		return -EINVAL;
> > 58729c04cf1092 Zi Yan                  2025-03-07  3933  
> > aa27253af32c74 Wei Yang                2025-11-06  3934  	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
> > 6a50c9b512f773 Ran Xiaokai             2024-06-07  3935  		return -EINVAL;
> > c010d47f107f60 Zi Yan                  2024-02-26  3936  
> > 5beaee54a324ba Matthew Wilcox (Oracle  2024-03-26  3937) 	is_hzp = is_huge_zero_folio(folio);
> > 4737edbbdd4958 Naoya Horiguchi         2023-04-06  3938  	if (is_hzp) {
> > 4737edbbdd4958 Naoya Horiguchi         2023-04-06  3939  		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
> > 478d134e9506c7 Xu Yu                   2022-04-28  3940  		return -EBUSY;
> > 4737edbbdd4958 Naoya Horiguchi         2023-04-06  3941  	}
> > 478d134e9506c7 Xu Yu                   2022-04-28  3942  
> > 3e9a13daa61253 Matthew Wilcox (Oracle  2022-09-02  3943) 	if (folio_test_writeback(folio))
> > 59807685a7e77e Ying Huang              2017-09-06  3944  		return -EBUSY;
> > 59807685a7e77e Ying Huang              2017-09-06  3945  
> > 5d65c8d758f259 Barry Song              2024-08-24  3946  	if (is_anon) {
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3947  		/*
> > c1e8d7c6a7a682 Michel Lespinasse       2020-06-08  3948  		 * The caller does not necessarily hold an mmap_lock that would
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3949  		 * prevent the anon_vma disappearing so we first we take a
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3950  		 * reference to it and then lock the anon_vma for write. This
> > 2f031c6f042cb8 Matthew Wilcox (Oracle  2022-01-29  3951) 		 * is similar to folio_lock_anon_vma_read except the write lock
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3952  		 * is taken to serialise against parallel split or collapse
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3953  		 * operations.
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3954  		 */
> > 29eea9b5a9c9ec Matthew Wilcox (Oracle  2022-09-02  3955) 		anon_vma = folio_get_anon_vma(folio);
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3956  		if (!anon_vma) {
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3957  			ret = -EBUSY;
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3958  			goto out;
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3959  		}
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  3960  		anon_vma_lock_write(anon_vma);
> > 3d4c0d98eb8572 Balbir Singh            2025-10-01  3961  		mapping = NULL;
> > 
> > end is not initialized for anonymous folios.
> > 
> 
> Yes
> 
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3962  	} else {
> > e220917fa50774 Luis Chamberlain        2024-08-22  3963  		unsigned int min_order;
> > 6a3edd29395631 Yin Fengwei             2022-08-10  3964  		gfp_t gfp;
> > 6a3edd29395631 Yin Fengwei             2022-08-10  3965  
> > 3e9a13daa61253 Matthew Wilcox (Oracle  2022-09-02  3966) 		mapping = folio->mapping;
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3967  
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3968  		/* Truncated ? */
> > 6384dd1d18de7b Zi Yan                  2025-03-07  3969  		/*
> > 6384dd1d18de7b Zi Yan                  2025-03-07  3970  		 * TODO: add support for large shmem folio in swap cache.
> > 6384dd1d18de7b Zi Yan                  2025-03-07  3971  		 * When shmem is in swap cache, mapping is NULL and
> > 6384dd1d18de7b Zi Yan                  2025-03-07  3972  		 * folio_test_swapcache() is true.
> > 6384dd1d18de7b Zi Yan                  2025-03-07  3973  		 */
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3974  		if (!mapping) {
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3975  			ret = -EBUSY;
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3976  			goto out;
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3977  		}
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  3978  
> > e220917fa50774 Luis Chamberlain        2024-08-22  3979  		min_order = mapping_min_folio_order(folio->mapping);
> > e220917fa50774 Luis Chamberlain        2024-08-22  3980  		if (new_order < min_order) {
> > e220917fa50774 Luis Chamberlain        2024-08-22  3981  			ret = -EINVAL;
> > e220917fa50774 Luis Chamberlain        2024-08-22  3982  			goto out;
> > e220917fa50774 Luis Chamberlain        2024-08-22  3983  		}
> > e220917fa50774 Luis Chamberlain        2024-08-22  3984  
> > 6a3edd29395631 Yin Fengwei             2022-08-10  3985  		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
> > 6a3edd29395631 Yin Fengwei             2022-08-10  3986  							GFP_RECLAIM_MASK);
> > 6a3edd29395631 Yin Fengwei             2022-08-10  3987  
> > 0201ebf274a306 David Howells           2023-06-28  3988  		if (!filemap_release_folio(folio, gfp)) {
> > 6a3edd29395631 Yin Fengwei             2022-08-10  3989  			ret = -EBUSY;
> > 6a3edd29395631 Yin Fengwei             2022-08-10  3990  			goto out;
> > 6a3edd29395631 Yin Fengwei             2022-08-10  3991  		}
> > 6a3edd29395631 Yin Fengwei             2022-08-10  3992  
> > 3c844d850e4486 Wei Yang                2025-11-06  3993  		if (split_type == SPLIT_TYPE_UNIFORM) {
> > 58729c04cf1092 Zi Yan                  2025-03-07  3994  			xas_set_order(&xas, folio->index, new_order);
> > 8ec26327c18e1d Wei Yang                2025-10-10  3995  			xas_split_alloc(&xas, folio, old_order, gfp);
> > 6b24ca4a1a8d4e Matthew Wilcox (Oracle  2020-06-27  3996) 			if (xas_error(&xas)) {
> > 6b24ca4a1a8d4e Matthew Wilcox (Oracle  2020-06-27  3997) 				ret = xas_error(&xas);
> > 6b24ca4a1a8d4e Matthew Wilcox (Oracle  2020-06-27  3998) 				goto out;
> > 6b24ca4a1a8d4e Matthew Wilcox (Oracle  2020-06-27  3999) 			}
> > 58729c04cf1092 Zi Yan                  2025-03-07  4000  		}
> > 6b24ca4a1a8d4e Matthew Wilcox (Oracle  2020-06-27  4001) 
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  4002  		anon_vma = NULL;
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  4003  		i_mmap_lock_read(mapping);
> > 006d3ff27e884f Hugh Dickins            2018-11-30  4004  
> > 006d3ff27e884f Hugh Dickins            2018-11-30  4005  		/*
> > 58729c04cf1092 Zi Yan                  2025-03-07  4006  		 *__split_unmapped_folio() may need to trim off pages beyond
> > 58729c04cf1092 Zi Yan                  2025-03-07  4007  		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
> > 58729c04cf1092 Zi Yan                  2025-03-07  4008  		 * seqlock, which cannot be nested inside the page tree lock.
> > 58729c04cf1092 Zi Yan                  2025-03-07  4009  		 * So note end now: i_size itself may be changed at any moment,
> > 58729c04cf1092 Zi Yan                  2025-03-07  4010  		 * but folio lock is good enough to serialize the trimming.
> > 006d3ff27e884f Hugh Dickins            2018-11-30  4011  		 */
> > 006d3ff27e884f Hugh Dickins            2018-11-30  4012  		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
> > d144bf6205342a Hugh Dickins            2021-09-02  4013  		if (shmem_mapping(mapping))
> > d144bf6205342a Hugh Dickins            2021-09-02  4014  			end = shmem_fallocend(mapping->host, end);
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  4015  	}
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  4016  
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  4017  	/*
> > 684555aacc90d7 Matthew Wilcox (Oracle  2022-09-02  4018) 	 * Racy check if we can split the page, before unmap_folio() will
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  4019  	 * split PMDs
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  4020  	 */
> > 8710f6ed34e7bc David Hildenbrand       2024-08-02  4021  	if (!can_split_folio(folio, 1, &extra_pins)) {
> > fd4a7ac32918d3 Baolin Wang             2022-10-24  4022  		ret = -EAGAIN;
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  4023  		goto out_unlock;
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  4024  	}
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  4025  
> > 684555aacc90d7 Matthew Wilcox (Oracle  2022-09-02  4026) 	unmap_folio(folio);
> > e9b61f19858a5d Kirill A. Shutemov      2016-01-15  4027  
> > b6769834aac1d4 Alex Shi                2020-12-15  4028  	/* block interrupt reentry in xa_lock and spinlock */
> > b6769834aac1d4 Alex Shi                2020-12-15  4029  	local_irq_disable();
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  4030  	if (mapping) {
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  4031  		/*
> > 3e9a13daa61253 Matthew Wilcox (Oracle  2022-09-02  4032) 		 * Check if the folio is present in page cache.
> > 3e9a13daa61253 Matthew Wilcox (Oracle  2022-09-02  4033) 		 * We assume all tail are present too, if folio is there.
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  4034  		 */
> > 6b24ca4a1a8d4e Matthew Wilcox (Oracle  2020-06-27  4035) 		xas_lock(&xas);
> > 6b24ca4a1a8d4e Matthew Wilcox (Oracle  2020-06-27  4036) 		xas_reset(&xas);
> > 391dc7f40590d7 Zi Yan                  2025-07-18  4037  		if (xas_load(&xas) != folio) {
> > 391dc7f40590d7 Zi Yan                  2025-07-18  4038  			ret = -EAGAIN;
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  4039  			goto fail;
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  4040  		}
> > 391dc7f40590d7 Zi Yan                  2025-07-18  4041  	}
> > baa355fd331424 Kirill A. Shutemov      2016-07-26  4042  
> > f6b1f167ffe29f Balbir Singh            2025-11-14  4043  	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
> > f6b1f167ffe29f Balbir Singh            2025-11-14 @4044  						true, list, split_type, end, extra_pins);
> >                                                                                                                                 ^^^
> > Passing uninitialized variables isn't allowed unless the function is
> > inlined.  It triggers a UBSan warning at runtime as well.
> 
> end is expected to be unused when uninitialized, are you suggesting we need to have a default value even if unused inside the function.
> My daily build has UBSan enabled, I'll try again
> 
> CONFIG_UBSAN=y
> CONFIG_CC_HAS_UBSAN_ARRAY_BOUNDS=y
> # CONFIG_UBSAN_BOUNDS is not set
> CONFIG_UBSAN_SHIFT=y
> # CONFIG_UBSAN_UNREACHABLE is not set
> # CONFIG_UBSAN_BOOL is not set
> # CONFIG_UBSAN_ENUM is not set
> 

Huh.  It's interesting that UBSan doesn't complain.  Potentially, the
function is inlined?

Technically, passing uninitialized variables to a function is undefined
behavior in C.  But in practical terms (and it make Linus cross that
the C standard doesn't account for this), when a function is inlined
then that shouldn't really be undefined.  But otherwise, yes, passing
uninitialized variables is not allowed, even when they're not used.

Everyone sensible is going to set CONFIG_INIT_STACK_ALL_ZERO for
production systems so initializing variables to zero doesn't affect
anything.

regards,
dan carpenter


