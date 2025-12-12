Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A378BD59D82
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 18:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1366A6B0006; Fri, 12 Dec 2025 13:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E346B0007; Fri, 12 Dec 2025 13:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024BE6B0008; Fri, 12 Dec 2025 13:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E1F2A6B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:37:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 972E2B7A88
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:37:39 +0000 (UTC)
X-FDA: 84211677438.13.59E5A06
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD03640010
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:37:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="e4w/Ay9u";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of smostafa@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765564657; a=rsa-sha256;
	cv=none;
	b=TgxCElFPm87lK6vtPHSAzt6M6aPMnmrIscsYH+Lgv3x3qMxhplWRNQe4TWko1ToCro1Vli
	vy8YSW0KvOaVnGoROm75arA/varhMRtKdpiNIcLAtGQT8etAJUNlv4zr8HAah43vRZavej
	3QJe4ias6FmEyrp9eVNs0cbmvOmRdAQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="e4w/Ay9u";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of smostafa@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765564657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSEL5ePgx5RjiFkm4T13sS/CnpCa9se0VHC4VBAtFtg=;
	b=rWCYKVk41Ls8cdIHiFGBWUlnXNcPDQzVubr9dE2GvNMr8nZATjviCLNlNZMMtCgjyy5Qo7
	uel9fnA4Dtl8hKG85Odl7HZW0ZWbPtGzZ0pbiCHJcV8b7gHJL85nvajz7IQUXbFNtFC6iF
	vOyIwI45nfnajUpNYr1Eml6ZktyOP74=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so180625e9.1
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765564656; x=1766169456; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pSEL5ePgx5RjiFkm4T13sS/CnpCa9se0VHC4VBAtFtg=;
        b=e4w/Ay9ukdvXjNj1ug8TfV574T356TDIzi1oSvlHxsC7SEIWOg519epuofhdQggX7L
         YKSqd+Zj2qjA1bzn/Xb6JhlisF756SF/Q4t1yVj3dkY2e+5dVj/J7IMQxJGwhhCw1Xlf
         1OzKr6SyrWewkLjeyk41tRTqLtDu05owdn7xp2rY8RnsbZRVZK53rU3/8cTkqBtnkoWj
         75FOK5peGx7C/DNjY0kcOhU2tG5NJx/CX2Ib3hYMl8YH0x8IUPqbjf8UxhKPgquhk8BK
         gAQqsza2fKL+R8T/qew+ApmbI5243TIQDrmAu/Xlhj5FNiSKE8cryBQPR2Qs43Wv+1ao
         yGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765564656; x=1766169456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSEL5ePgx5RjiFkm4T13sS/CnpCa9se0VHC4VBAtFtg=;
        b=fPndK+isl+iPrIMnAd51lSyo3Bt4MNoHwUPawre6It5NpJtZBvantxbXLrN0zzWKk7
         bFOgfKoZY7gE0qgaxb+ecvia14ViG3JVK3GJyG9Dm/IgWSnzIDNFYUCQXe0sAw2jZaVR
         eTxOiX5uSeNHRiAJz0yUcTLpju7gGSPL1Nq6c/hXzIu3/unsSKMwB5WxDEyKx6KCbWlB
         CJOe2jY76y5yzBo8zMC3zCx3RL/+YANBdiv779fP11cravsEMKkrWlEI33eqd3Hu756e
         TAZ4clvMy5Z775itRnpWvU+yZsARbc2tOhQacwn5YlvTdLS3WAPJqFkzWQw0R67wLgXr
         SnKQ==
X-Gm-Message-State: AOJu0Yx0aLnOXtfNCSV/jqqTQwkx6xz33swGvzQVNOCsNDsOONPVOic+
	WuP2vQxfTa95y5H1fEbK2y0O7HCTPFZIZL/IiRXrRKGHWqXGZHZ1X6NE4NBrXx21Bg==
X-Gm-Gg: AY/fxX4gTln6TCBSYG6X+CXriCtVM6tcyveKjkcgyLdQ5AtQyKRQfymTwGpnZiz/suV
	XlbQKIEkip5tW1etTLO6kEgDzIv1zqe47uv3MGoirHP+I43aPcb1ZPtlCkmk2OLkcD4nIqO5dO7
	Mc05HsBMsYjLEOntpg99LSmeAf2nYSAnYrWPlTCbQjb7FlQ28G+yZjL1tUK4jTEIU03NbiqL76N
	8dh/BL2XI4y4xARzljHuWu6ON14wcPVBQN740hyA3mZxil/kSwZwkgkMR9nRRV3ZpW5W/fU7RI+
	7N2r37neBxArXASGpossD7E5Y8q4zUIFGm6Lp94Fc/u9spzpyxvFnpUcmcIRldh1qTAUNe104AJ
	UZe7IIzSFJ1B0dtwHZsrJvgCkKhGtqn6HpJ3rdllFQSkei2XKehNH5DjJwikJaZ4jYCtWvtl5QQ
	XoIt07XdB2LySMxmkT+7QWpTum+A8yrh3e/o/+fKys0Lk1n9D6XA==
X-Google-Smtp-Source: AGHT+IHzdWN4hpt7McD7KCWGDX7vpqcZJcLk3uQhWd353UqV22b/mGz1ioCMGsLdTgWVBmvLQWc0hw==
X-Received: by 2002:a05:600c:83c4:b0:477:86fd:fb18 with SMTP id 5b1f17b1804b1-47a94869ebbmr37675e9.8.1765564655960;
        Fri, 12 Dec 2025 10:37:35 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f6f2238sm16173315e9.13.2025.12.12.10.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 10:37:35 -0800 (PST)
Date: Fri, 12 Dec 2025 18:37:31 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	rdunlap@infradead.org
Subject: Re: [PATCH v4 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
Message-ID: <aTxg6yHWdFrW41ZC@google.com>
References: <20251211125928.3258905-1-smostafa@google.com>
 <20251211125928.3258905-2-smostafa@google.com>
 <341bbfd9-e6bb-4d1e-b9c0-9077dc3eaba3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <341bbfd9-e6bb-4d1e-b9c0-9077dc3eaba3@linux.intel.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD03640010
X-Stat-Signature: kbgzhim7tuggfsauu14qjqtmhx1d3sad
X-Rspam-User: 
X-HE-Tag: 1765564657-54442
X-HE-Meta: U2FsdGVkX18ZrtuVM89DZcjohXncdDrtD9wNPRLXFhWiJx/HOS1wNRmulBgu7TpoERgaxQYKLlW4bnhsSfB9MAMEkDyPqrLJtDUxHhcxko9VtNEolhHXgs4XlAP4nPMIOUi1GafNQEcgifE0JYocbLuH0YBVOgq8t8bcHNa/pgmaKyFMbzdKkpVXNWY8K6uOmaYwOIn6u5QBL348Ck08SA44YoDCrxfKBO+j+10ZyG5Mr4eF4T6ENnutiWPz5xTIFcRdo7wHDSoBQWC4ANjgbeXj9VohyGI4Cldlkkkd/D2VUuST9xT7qfuPMUJ5dELfXY2I6yYbbG8jgx8xRCTYo3sCVCJXannfCgFQl3BzZbr/h5d1R4F/0lKqNN0tk6cAxjYIt1NXgotvo6pcZ4E5MjArZ+yeee3xAOkMsxIoZ/q/jhElSyBOWY9zi3AXj632EGZs9/aIiy6wnBzGs2alHVIBHHSUhbFb+F1nlTM3pHQayAHlaVo0UAxAPD1tb0hP1kVjd4v8uXA1CCrTqEc+LbVnPgy4FyDW9S0jaelR3GfoFLr+DubODMYWPYqP4kUB4Y2mP7+sEVGVgYTWu6ycrQgct7Gc0m9e3wjHk7v6qrYf+80KjbmHiRZ+l564Egq4KWsmrxFfbFsBw74BwiFeOVArQyeFIpuQ640on9bNryIWkAPbQ7HhLiB85nW/nO2i6FOO698JkcTfPQ339opHCTcMjS5TJA5A5l4J9iCJDQvNAJJCaUNBQeXtDHvTZXaZkEqtMyaCfm3/I7tFD/PLVfXp0GMlrTf49hKq9O91IrQ9Qm6yXRFCxe3Zz2Me0Xx2fIMLTLVLuAT50ec2c8JIQViNd02d73vjcy2cLd/04OP8aIeS3J481+wzMw330ImBQNGPYvO2OZqbMVkCGdkULhkpooOlhq1cjhT5ZquNUVEasF2L3qJ24CrVpk9iuTge22bibIobUNq8EEg6T6H
 ny7YWb/Z
 Yf5SywjobNIHASqNHGRlnn4LgnFzRQvvE0hNpJTVnHuYF3D1dTctLDOZG9s7pqVF9ZdAJ7VDJAASlD7idz3rApdMkcszx9QCqNtf4Ixt+Ir6+aTcqm+ztJ6XGRCRpSfcLdev1NI8yXftrLi9thSSI93ddBIjL9b6DCObqiCLoFNhsQsWlZTTqBKgtEPF1AFt7p0uA2wsOY0TmCaBMFNvTAb0CZ5FINsbd3m1ca6qMt+nbCuy+1lEgd1v0qlOUFuB1SwPFfUoMDPpRbFljYoFQkASNRtpN03jhXs2XofO0z7odMRScPq0Z/JtxOP7PNGPv+XT6NV5rpTztVSCCKdwJa1vmEeBAzPz12VS/50xZUzdJjd+fC0mJNSOuOJnu3HYgOC0Qsdusac14jDxXs+RrfZdIHclwU5zEiR3RWAz+VbsYsRc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 10:17:11AM +0800, Baolu Lu wrote:
> On 12/11/25 20:59, Mostafa Saleh wrote:
> > Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> > page_ext.
> > 
> > This config will be used by the IOMMU API to track pages mapped in
> > the IOMMU to catch drivers trying to free kernel memory that they
> > still map in their domains, causing all types of memory corruption.
> > 
> > This behaviour is disabled by default and can be enabled using
> > kernel cmdline iommu.debug_pagealloc.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >   .../admin-guide/kernel-parameters.txt         |  9 ++++++
> >   drivers/iommu/Kconfig                         | 19 +++++++++++
> >   drivers/iommu/Makefile                        |  1 +
> >   drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
> >   include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
> >   mm/page_ext.c                                 |  4 +++
> >   6 files changed, 82 insertions(+)
> >   create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
> >   create mode 100644 include/linux/iommu-debug-pagealloc.h
> 
> Do you need to update the MAINTAINERS file, since a new file (iommu-
> debug-pagealloc.h) is being added?
> 
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index a8d0afde7f85..d484d9d8d0a4 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2675,6 +2675,15 @@ Kernel parameters
> >   			1 - Bypass the IOMMU for DMA.
> >   			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
> > +	iommu.debug_pagealloc=
> > +			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
> > +			parameter enables the feature at boot time. By default, it
> > +			is disabled and the system behaves the same way as a kernel
> > +			built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
> > +			Format: { "0" | "1" }
> > +			0 - Sanitizer disabled.
> > +			1 - Sanitizer enabled, expect runtime overhead.
> 
> "iommu.debug_pagealloc=0" has the same meaning as "unset". Would
> "iommu=debug_pagealloc" look more appropriate?

"iommu=" seems to be x86 specific. I was following the pattern for
"iommu.passthrough=", "iommu.strict=" and also as "debug_pagealloc="
has it's own command line, it made sense to design this way.

Thanks,
Mostafa

> 
> > +
> >   	io7=		[HW] IO7 for Marvel-based Alpha systems
> >   			See comment before marvel_specify_io7 in
> >   			arch/alpha/kernel/core_marvel.c.
> 
> [ ... ]
> 
> Other changes look good to me.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

