Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B625FD185DB
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 11:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2DF6B0092; Thu,  8 Jan 2026 06:37:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94AB6B0093; Thu,  8 Jan 2026 06:37:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96AA6B0095; Thu,  8 Jan 2026 06:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 995B16B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:37:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AEF11A06CF
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:37:47 +0000 (UTC)
X-FDA: 84308596974.28.BF7E371
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 50A9F100006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:37:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1BFb90Q8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of smostafa@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767872265; a=rsa-sha256;
	cv=none;
	b=4JqQtjyemVeIvj56HMk7wkYuDS6HAD7raeFhQVMcfT5Zmg/sXDYEbfldksLAWkT+t53B1m
	0hFdN9AfgGuDJm4qKxpi+uHT6fNZRCyR7xVw55sjRPKXEeGYMmX6i7TxfuHbSQPo4fBJS1
	t7lZhM1OUg4Zj/ZalbgvFWT0NaWsxGA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1BFb90Q8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of smostafa@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767872265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeCkOM2Cu2fdrKkUm4jDLC5UzEO1Q6YJYSDtB9D9vrY=;
	b=C2Z9IDevpS6/yHFZZqhxnsquMenGlhoIlsiFmwa0zT1YINI8pkOOt0CQ1Y2KHJ3SA1IXeI
	bo78AUmHgYqEGX+hw04RAjNF5LF0/59F0HyzmD/SffPTMTTIxrhU/SwIlj/kMJC6TP6id/
	UsU8rLUdMv7NhyPlnzqcQm1Vo1qwKZU=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so130895e9.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 03:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767872264; x=1768477064; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SeCkOM2Cu2fdrKkUm4jDLC5UzEO1Q6YJYSDtB9D9vrY=;
        b=1BFb90Q85rirG79FdkKSFL+lCnbuis/Brs613ZJEyZYV3xMIBwWu7sN5bLz5i7/Jmc
         OembM/tfP8WAi6LOjsDWSsmalWoRf4jfTElqtrer6ABzuVALQhjxJ1ODgAs48GdVxvGJ
         MmSaIl61GA3Zcn75whPz+R1N/npaXE6o1r1YVnaguADsatu+p3IS5yllvM6uGiTa5T1r
         F4bXt7nu+S/0frochzNsYMtUjDD5zBgFU4eWux5jBfp7DIYpRXzxQbE4QPMRrNop0Z0D
         oFYuz5X/VAVqfg3R9wFRlltIRG+hdhl4llaKo8Nv/FV8R3OMk/50r2rTQ88I/o1N+4AR
         SrAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767872264; x=1768477064;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SeCkOM2Cu2fdrKkUm4jDLC5UzEO1Q6YJYSDtB9D9vrY=;
        b=Tw9XImY8iRb4BXdrwi565gjvvxspazygNmyeljGG53La4mcQjQJdmixwZvu57uvwPg
         D8Z7XYTMiYo/q1I9tafd29laW7SK0s5e2uZMQNs8AQMzGpeAlKzaiLDPiuPK9iMkfJc0
         c5CLlmEstDy1UTPd7dnKI5n8wBH9hVrHeMZcJIHuWfWdMz5HSC9xYWkvr2Fz9kEQrlL0
         ntEWGDppb2N/pW2qYV4kNIdDNv5/PyyuTfhfolJbu2jeFsIlp5jiQ+sQo8gnKwlWzXSM
         u4Yl5SGC8HqRWN0/JsMMOmdeA/g8toaUn3sHW0/p92UX3dXjDv67HCerM7xL5afemj8A
         5LMg==
X-Gm-Message-State: AOJu0YzlllFWjO9tkrOptObZd2lqUYX27Q+PuTbA/cSgHu6DbaMz0tCk
	4rTtAfHP/s9BcXsuMAh2fgaJF+WuNfOyXKOUsSlHtTB5lwhPkrXH8u41rD7SAThT3A==
X-Gm-Gg: AY/fxX5yehPN4q3T9Mrh2gfn1WbIHttYoxT0s4treiIBdCuFCkPPTfKEVGexwSbr/05
	mWimP/Uo6FSGAFeiyD/ZOrUNXs3JS5oVysocJTak73yeaymTD7l6VQBXjqo9U4V6C6wUyJN2oeQ
	CZiFZH4yB155UYqYmkEQwklAsPtEUWAHYPMB2yGgFyXpfseOR5vNZQQ7y1NoIJweateLwcC8EpY
	whai1tQ0bY2BC3btGGkm1AVI1A2Mf/PhLL8uu3NRVQcuXhoSRvAFyEeUkdXLbfNPovBrmRrPUtB
	esk7Du+VpcO55+4SG6t3sqENJkbkR1/rW3ihr1grHKgaJ4/yQn9dyTvNPNYQEX8FtIZ9XYtKRgZ
	md6+mMkjN+DyBSqSTvlj2nSSrFLTVceMgWHIrhg3L2SB6ugpxZRcH6/NRb40V5EH/2uiqYEMcFS
	G7qn7+XgjWOfSgG58GeljnDpPTaHiNedywhIAG4l7ZDAiu85QQxJN9
X-Received: by 2002:a05:600c:4e0c:b0:47d:7428:d00c with SMTP id 5b1f17b1804b1-47d8ac49a26mr553445e9.17.1767872263247;
        Thu, 08 Jan 2026 03:37:43 -0800 (PST)
Received: from google.com (171.85.155.104.bc.googleusercontent.com. [104.155.85.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e16d2sm16560217f8f.13.2026.01.08.03.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 03:37:42 -0800 (PST)
Date: Thu, 8 Jan 2026 11:37:39 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Subject: Re: [PATCH v5 0/4] iommu: Add IOMMU_DEBUG_PAGEALLOC sanitizer
Message-ID: <aV-XAxCca8qeNVGT@google.com>
References: <20260106162200.2223655-1-smostafa@google.com>
 <aV56y9KcAS8mC7Uk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aV56y9KcAS8mC7Uk@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50A9F100006
X-Stat-Signature: 78csatuw67z5kmjct8ihseundz7kbyo4
X-Rspam-User: 
X-HE-Tag: 1767872265-729428
X-HE-Meta: U2FsdGVkX18aExcuuF4wRXZ5WcyiDK/f0q0WVp9asPFAtGq5AmUbcjy0xiOUc24tu2X6iKAEAa9oSKd1CSYUdtXYi7XeA1NmWdRcJ/MclNu16EcPRtXq+uVcEhFDiAryQjNbZaJGJlVPxjU3pATsE1C6WW4wGqymHlU+f1LIwt9ipFPGZv5P1nWq+HK/eIWWObJgyTwstWYdJj2adVF39NrBYgVkHyFmKxyMpwKlh1n0TmnWsrp6U07et0Ka0+OVsaZFkUUgR/SF7g9U2QJUNKtdO/TYFJ9fEroO1N+kUyFONfKvwhwFVk1mtGmCRAEr5czzg3152uS36XVT2bb7y9fpB+WvzT+m77LX+/VUUbPv+hHnYGlwBxFGupQHrkltoM3Xl0kn5o2m7enadomAWKrqG4ysGPDN//t2kj2BpuM4EZPLrVHadN9H/rMBHxR/b/VhanUIB/wS4ZCshw/U8NuFP6HqPkGQNBdyMt5oS7kT+tkAYW2jc9FclsAFrMy0XOxN/E5yDOj8IaO2+eurPv2xWD4LBZTCk8ywyj1jTDOj4SXKJd2kk2BvzIm6yGNdExzwTgza2aIBpLIsUwVI8KHusFTFkQtkvH9oouAfnK/4ByElNOrGQzpW4HQVIklqQYHr0NQ0s1bjFCqVbPdJnRuCf0Lqe3F4oVl1C8nuWAhAntJQ68+HGwwJsEfkaClHFTf0JrNCx18QyK/dlFQSqdNUEqZ4iByEIuPG2j1HiaiwAnXhQYQN+F80eoN2Vjy0ZtMlq9thRNWSIRKv35nt6V1ut3ruglEPEcrNwe1JdkHd8n1CxD7qxOh1ZIavIAuebDdQyO//nQmFerHxSVf/T44XzgWZXOMrTKztQUoRv09jnDse5sygTHzgUo6Rk/deMD79WKyjKsb6ZzC9g8VqQ13Zg8AHDpbaYO6H9htbbBEsAWOcm5cgMngCAEkwWaZ/wlow3RycISkElKGjtPU
 bOpNQpIl
 01p9/Xe7U3n1kNi02Zj350QsOFOBiuSDtSu39ClcML3TuB/1ZeRuvjw/JSlR0oC6ENAnX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 03:24:59PM +0000, Pranjal Shrivastava wrote:
> On Tue, Jan 06, 2026 at 04:21:56PM +0000, Mostafa Saleh wrote:
> > Overview
> > --------
> > This patch series introduces a new debugging feature,
> > IOMMU_DEBUG_PAGEALLOC, designed to catch DMA use-after-free bugs
> > and IOMMU mapping leaks from buggy drivers.
> > 
> > The kernel has powerful sanitizers like KASAN and DEBUG_PAGEALLOC
> > for catching CPU-side memory corruption. However, there is limited
> > runtime sanitization for DMA mappings managed by the IOMMU. A buggy
> > driver can free a page while it is still mapped for DMA, leading to
> > memory corruption or use-after-free vulnerabilities when that page is
> > reallocated and used for a different purpose.
> > 
> 
> Thanks for this series! This is really helpful!
> 
> > Inspired by DEBUG_PAGEALLOC, this sanitizer tracks IOMMU mappings on a
> > per-page basis, as it’s not possible to unmap the pages, because it
> > requires to lock and walk all domains on every kernel free, instead we
> > rely on page_ext to add an IOMMU-specific mapping reference count for
> > each page.
> > And on each page allocated/freed from the kernel we simply check the
> > count and WARN if it is not zero, and dumping page owner information
> > if enabled.
> > 
> > Concurrency
> > -----------
> > By design this check is racy where one caller can map pages just after
> > the check, which can lead to false negatives.
> > In my opinion this is acceptable for sanitizers (for ex KCSAN have
> > that property).
> > Otherwise we have to implement locks in iommu_map/unmap for all domains
> > which is not favourable even for a debug feature.
> > The sanitizer only guarantees that the refcount itself doesn’t get
> > corrupted using atomics. And there are no false positives.
> > 
> > CPU vs IOMMU Page Size
> > ----------------------
> > IOMMUs can use different page sizes and which can be non-homogeneous;
> > not even all of them have the same page size.
> > 
> > To solve this, the refcount is always incremented and decremented in
> > units of the smallest page size supported by the IOMMU domain. This
> > ensures the accounting remains consistent regardless of the size of
> > the map or unmap operation, otherwise double counting can happen.
> > 
> > Testing & Performance
> > ---------------------
> > This was tested on Morello with Arm64 + SMMUv3
> > Did some testing Lenovo IdeaCentre X Gen 10 Snapdragon
> > Did some testing on Qemu including different SMMUv3/CPU page size (arm64).
> > 
> > I also ran dma_map_benchmark on Morello:
> > 
> > echo dma_map_benchmark > /sys/bus/pci/devices/0000\:06\:00.0/driver_override
> > echo 0000:06:00.0 >  /sys/bus/pci/devices/0000\:06\:00.0/driver/unbind
> > echo 0000:06:00.0 > /sys/bus/pci/drivers/dma_map_benchmark/bind
> > ./dma_map_benchmark -t $threads -g $nr_pages
> > 
> > CONFIG refers to "CONFIG_IOMMU_DEBUG_PAGEALLOC"
> > cmdline refers to "iommu.debug_pagealloc"
> > Numbers are (map latency)/(unmap latency), lower is better.
> > 
> > 			CONFIG=n    CONFIG=y    CONFIG=y
> > 			            cmdline=0   cmdline=1
> > 4K - 1 thread		0.1/0.6     0.1/0.6     0.1/0.7
> > 4K - 4 threads		0.1/1.1     0.1/1.0     0.2/1.1
> > 1M - 1 thread		0.8/21.2    0.7/21.2    5.4/42.3
> > 1M - 4 threads		1.1/45.9    1.1/46.0    5.9/45.1
> > 
> 
> Just curious to know if we've also measured the latency for larger
> mappings? e.g. 1G mapping backed by `n` 4K mappings?

No, the max granule supported by dma_map_benchmark is 1024, which
is 4M for 4K kernels.
I thought 1M would be better for my setup, as I am using SMMUv3,
where 1MB includes many PTEs compared to 4M, and the 4K test will
cover the single PTE case, so we get more coverage.

Thanks,
Mostafa

> 
> > Changes in v5:
> > v4: https://lore.kernel.org/all/20251211125928.3258905-1-smostafa@google.com/
> > - Fix typo in comment
> > - Collect Baolu R-bs
> > 
> > Main changes in v4:
> > v3: https://lore.kernel.org/all/20251124200811.2942432-1-smostafa@google.com/
> > - Update the kernel parameter format in docs based on Randy feedback
> > - Update commit subjects
> > - Add IOMMU only functions in iommu-priv.h based on Baolu feedback
> > 
> > Main changes in v3: (Most of them addressing Will comments)
> > v2: https://lore.kernel.org/linux-iommu/20251106163953.1971067-1-smostafa@google.com/
> > - Reword the Kconfig help
> > - Use unmap_begin/end instead of unmap/remap
> > - Use relaxed accessors when refcounting
> > - Fix a bug with checking the returned address from iova_to_phys
> > - Add more hardening checks (overflow)
> > - Add more debug info on assertions (dump_page_owner())
> > - Handle cases where unmap returns larger size as the core code seems
> >   to tolerate that.
> > - Drop Tested-by tags from Qinxin as the code logic changed
> > 
> > Main changes in v2:
> > v1: https://lore.kernel.org/linux-iommu/20251003173229.1533640-1-smostafa@google.com/
> > - Address Jörg comments about #ifdefs and static keys
> > - Reword the Kconfig help
> > - Drop RFC
> > - Collect t-b from Qinxin
> > - Minor cleanups
> > 
> > Mostafa Saleh (4):
> >   iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
> >   iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
> >   iommu: debug-pagealloc: Track IOMMU pages
> >   iommu: debug-pagealloc: Check mapped/unmapped kernel memory
> > 
> >  .../admin-guide/kernel-parameters.txt         |   9 +
> >  drivers/iommu/Kconfig                         |  19 ++
> >  drivers/iommu/Makefile                        |   1 +
> >  drivers/iommu/iommu-debug-pagealloc.c         | 174 ++++++++++++++++++
> >  drivers/iommu/iommu-priv.h                    |  58 ++++++
> >  drivers/iommu/iommu.c                         |  11 +-
> >  include/linux/iommu-debug-pagealloc.h         |  32 ++++
> >  include/linux/mm.h                            |   5 +
> >  mm/page_ext.c                                 |   4 +
> >  9 files changed, 311 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
> >  create mode 100644 include/linux/iommu-debug-pagealloc.h
> > 
> > -- 
> > 2.52.0.351.gbe84eed79e-goog
> > 
> > 

