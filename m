Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F10DACFD37A
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 09:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4656C6B0005; Tue, 25 Nov 2025 04:54:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D446B0031; Tue, 25 Nov 2025 04:54:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A036B0062; Tue, 25 Nov 2025 04:54:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 269896B0005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:54:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79CD05B63E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:54:52 +0000 (UTC)
X-FDA: 84148670424.12.F1F33AE
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 96B5C100002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:54:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XPOqUt1e;
	spf=pass (imf05.hostedemail.com: domain of smostafa@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764064490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vL2SF6DadjEfReQqy+MahpgoTUep+XQ3TbZINCjIIpU=;
	b=VDU40rbKT71OPpdff5zNAPaz9V+o6J4SIm6urs5jbo7ouJpZ3YGa3S/kNQAsH2RYtOjxHG
	/60Ri7oLloADZNcbbBEuQZWytA0oEYR7e3Y48JeMOU7cXJyvCFPRadmiW4uizu9efHrG2x
	l5ncvPGxG8tcjOtAXhYvblXT/9On8sw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764064490; a=rsa-sha256;
	cv=none;
	b=svVzTnR2oVzqwNUCnqzMf344oBUUZPJpPLNOZC0pWQpaUTZB0JMeb51GQbAkJmA+VxpB3x
	jE5HlVPA2a4OcQFftkeItbYRteLGV6KP1QjPK4L9mB99P9AXfeGKlRZvGbXKvS+mnYawn9
	W8DK6F4f7ik09F6u1dcarVrZ8Qc9Lzg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XPOqUt1e;
	spf=pass (imf05.hostedemail.com: domain of smostafa@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779a4fc916so42755e9.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764064489; x=1764669289; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vL2SF6DadjEfReQqy+MahpgoTUep+XQ3TbZINCjIIpU=;
        b=XPOqUt1eJOpKzbELaYUvnxihrDsF1AgsEHIXsAaOXSrIzuOYZNdfZ99QxCCONbgqOW
         JZ7DU31VXE5hXOGy+lpq031KAa6It+GXjHiaX/65RU7/33plyXQFJ662XQGJA0Oaa4P7
         KSK5IPd7foJSCHYx2t1FsQRXHULR8798QLPAOELeZJ5XFHHedzhCcMVrbUU/Z7mvaHYJ
         JgmyDLZbeH+Ifb8GjZ+uER4a2NXY/cSkg9Py2yV/y9O8KRW9+K0Lz0CcALOQmbk/hk+C
         jfkf3brvFnzd6lr4rmHil5GvDdGW1lDC1iLRwz/Bx1vGvnNoeyBUXX9hpa2+Db0CI7NY
         YBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764064489; x=1764669289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vL2SF6DadjEfReQqy+MahpgoTUep+XQ3TbZINCjIIpU=;
        b=O/7XRZgnyyw2YO10AtPa3I1cWP6j3jHFjaalcx1Rb9AZH6XC50n6RLfEszU2hBZmTl
         xdmRCG5Hgj9cBxo4dWquGiEiqtPmX8/NNOrZVWSbe4s5TbIO7XsIidmNf2ytrTHH6C/I
         7vqW00GEKSVWU1JHhYIX05j42izsbhH5wcQAHGUVRP6xOUsOeSd1Pmtp+zPprvrKoAHH
         YEhALTq2DXfOlhvwUOuRlY48e8h5++W6OiW/Ct4H3Oc8GiD/rvWeELxUNFOVMAywppaq
         blcNQkajBzuvSgFg6JMqTvUvcAd/vQo4Bqf0ENhiCBiCGI3P8rXPYQRTwB6yLCv6TzAs
         GbCA==
X-Gm-Message-State: AOJu0Yx+R63bjU3PU1hgg8yVkBdA9UBDZtL5TxbNJUFrT+oHgZZTLAgC
	3pFi9w0It27vNxkyOf33o21WXnN5O1SPuXJqnQV/6kVajtooV8UYnM27t+5KtM7ndA==
X-Gm-Gg: ASbGncvppNSFdyTMEKhiYgLiJd76Ej99JsJw3Iud+nj/YR5Bv8u0UPagEgPaFnHZ3r1
	bn15EXgyQCB/GMXhrN+MV0zHlqWlm/YWTSs0smM/1uJ0ksRlN7RvvlKWvbuxkRQuyYNNUZiibKM
	OzRWmI8bePL89SAU+UaC3TzFLLoe8fF+IgLUws+p9osLcyulzwy8315HB6+S1cfcV+BERUlnSPJ
	LnpAVj7UH/2cxUXyUB4OY7aExJrO1yF23yPIudGBiBg/l2iQGAw/lwhSK/ADrOIExlxH4eLqMv2
	0eQHYj34cxh/WjVSU2mDlYItXBSDirH5enAaeqJEC6C7ugf+b/zs7kY2HwHhYUxsw0NYEu2kbOA
	sU1t7z5EMy2NatDQ3Ln1Ba+MG7JAaE9qcxBRb7PQh2kBnkBh7SLWsdFt/B3nQFau8BQmeNwiaLD
	nJAW3bl1b9Iope+p3KJcPCt+4djhUwG85pSLhJe20X4DdZ15t3hA==
X-Google-Smtp-Source: AGHT+IHEabe/7pXhdzmn7h02Or0O3qxqSNjpbYe1IcSPnLYCWEVv/evZDk1iZk2r+Q06y19BisRFJg==
X-Received: by 2002:a05:600d:1c:b0:477:86fd:fb48 with SMTP id 5b1f17b1804b1-479068edd0emr316815e9.9.1764064488818;
        Tue, 25 Nov 2025 01:54:48 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3a6bsm33143282f8f.28.2025.11.25.01.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 01:54:47 -0800 (PST)
Date: Tue, 25 Nov 2025 09:54:44 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com
Subject: Re: [PATCH v3 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
Message-ID: <aSV85G0F4bQNYwHE@google.com>
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-2-smostafa@google.com>
 <5f85e519-5a05-4359-9904-06f16737e28b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f85e519-5a05-4359-9904-06f16737e28b@linux.intel.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96B5C100002
X-Stat-Signature: r38qup79ech3jyuws9xika5ju63sokcq
X-Rspam-User: 
X-HE-Tag: 1764064490-991195
X-HE-Meta: U2FsdGVkX19obnPPYLzG1zpGFtgM9qSQYLJ0DGjqguKYSWFg0NQ/Y5PxEpz+l5fWfYK3t4KvWt0cSHg+S7HtzdNpJJ6VxYDHOz3dM5awzwD/X1FAMlKSXAh7Y+y4PmTY6/7vaH2Xk+RY1ZNlAELsq4PkY7QhxGfsA689I4tiWc+Ip5udqsGtG1kX5gWaGHUfnAN53ustM7fvMA9bLcx0u11gh+TyXgngB1db+jutDP4ACyZmC3nHXrYfbVrAKEtLJIQfTB6VM1DYXRKCl0gBj9xK9TChss3b6tBviNIJvKaxPBrBn9mgccBBDdx6x/gX3jAdLp+jKj2hSPhDAziLl3Enxs5g0pZPCDj7fBnaObN1CZH/kKP6BySGDcfjtAGXhiXtQIvqacb75at3/XElkUT6qLxwtCIuACIhgnUQ/cVc2MsLag9lYlHJSV9IYPwUvzV04/9Vqnyi8PPyHPlnE/vAQXsjS9TVzRZORTymWL/Xw2n0Cj1Yx5E1l0DSi2xTHYWpbAfSQSt8/JKOtS5xqhIrhdW/jyzvb7zY9AV/AUo8s03JncuMv/7o3bU6FYgo1vlCX/maiRtwnY40XKbrqzwcX51PtiN4kjSFEI/uIg4wGPOHZ5yYC+Jni+03Js6iYCuWHNkujOl3wyKVnwSmT8uY3+bTAhplTMLoKVgrj76FtKv49enF3dj3Wf9BaOn8iCv+DXyLTRPFx+vrwIdm3aaKnEyJM/y7Cdr3CixKvE9JBqT9wCMv0Pv0/hrWIPE4JoIyBS+og3nHt0iCRqHrobgF3pfEGp4T7SVnlx+1gxyB+WElQsGo4nEHUBrjiv4T8AjtZNrOltRPHHQ+dymqTonCjtcpAWu9F0HKQWgzMrkFwFvOl4Hpf/R+owfwHdmljO/RQ93yRLv9DdTgDJZcsR5iZp8BIWnXflhz2+ZdSGIwrAJI/da1GMM/tzJ5/VtraghI03qGzp2o0ybhVlV
 M19kfN1N
 lm7omJqoOHorD1Fzqh0lqCIgoetZPvmuPHd7q7KUG3mgAVuQZFkHVvJlr8d2DdZugXQMxQYlzJB2ZuNn6bVZZSr5wDq9rV+lQ4HGdPBmtGlzfgxXPIxTWabQFUM8O0vy1CURVjKxn+sW7SV8NF2e6+jtSUQ2W3lE60DBAh/e6ZdycfZEGxZggv5MY9GVTJb4LZh92lg+lZcRY/j+qBurp5DD4RquFxRzQmPPeuoMKK90RgVRxim7T37BD/at4KskxWlRkyS2E2Ck8JfmOT6xy/w6xvNzvgXT5PBjyrhY1JShnhC6C3JX5wn8i+8fZOt3u103Hx7leX162xPtk/CXIzkPFLSnhxYNWhpaG06w+Wv24csOdssz2bxwFM5Pxp6EZZZM2DIoXdf7Y4CoejSRxBaTN8+NimBGIYNNVsZhmOEgZHY5VV5+nRA7+Ykj+BIHkW0NKzZBGK+o//GMcxKoXbFyvCU44ZMU/aEVe5Tv/Xch7+AQu6KyR5BbNs5HjKSpNnC2Z6DFqtLE3gH4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 03:17:47PM +0800, Baolu Lu wrote:
> On 11/25/25 04:08, Mostafa Saleh wrote:
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
> >   .../admin-guide/kernel-parameters.txt         |  6 ++++
> >   drivers/iommu/Kconfig                         | 19 +++++++++++
> >   drivers/iommu/Makefile                        |  1 +
> >   drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
> >   include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
> >   mm/page_ext.c                                 |  4 +++
> >   6 files changed, 79 insertions(+)
> >   create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
> >   create mode 100644 include/linux/iommu-debug-pagealloc.h
> > 
> 
> [..]
> 
> > diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
> > new file mode 100644
> > index 000000000000..83e64d70bf6c
> > --- /dev/null
> > +++ b/include/linux/iommu-debug-pagealloc.h
> > @@ -0,0 +1,17 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2025 - Google Inc
> > + * Author: Mostafa Saleh <smostafa@google.com>
> > + * IOMMU API debug page alloc sanitizer
> > + */
> > +
> > +#ifndef __LINUX_IOMMU_DEBUG_PAGEALLOC_H
> > +#define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
> > +
> > +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> > +
> > +extern struct page_ext_operations page_iommu_debug_ops;
> 
> How about moving above to below mm/page_ext.c and remove iommu-debug-
> pagealloc.h header file? ...
> 
> > +
> > +#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
> > +
> > +#endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
> > diff --git a/mm/page_ext.c b/mm/page_ext.c
> > index d7396a8970e5..297e4cd8ce90 100644
> > --- a/mm/page_ext.c
> > +++ b/mm/page_ext.c
> > @@ -11,6 +11,7 @@
> >   #include <linux/page_table_check.h>
> >   #include <linux/rcupdate.h>
> >   #include <linux/pgalloc_tag.h>
> > +#include <linux/iommu-debug-pagealloc.h>
> 
> ... remove this include line and put the "extern" line here,
> 
> extern struct page_ext_operations page_iommu_debug_ops;

This file is needed for other functions added later, which is then
included by iommu.c mm.h

Also, the pattern in page_ext looks that users have their own headers:
include/linux/page_owner.h:extern struct page_ext_operations page_owner_ops;
include/linux/page_table_check.h:extern struct page_ext_operations page_table_check_ops;
include/linux/pgalloc_tag.h:extern struct page_ext_operations page_alloc_tagging_ops;

> 
> >   /*
> >    * struct page extension
> > @@ -89,6 +90,9 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
> >   #ifdef CONFIG_PAGE_TABLE_CHECK
> >   	&page_table_check_ops,
> >   #endif
> > +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> > +	&page_iommu_debug_ops,
> > +#endif
> >   };
> >   unsigned long page_ext_size;
> 
> Or, put it directly in linux/iommu.h?
> 

I tried that, but in the last patch we need to include that in linux/mm.h
which didn't compile and required including other files which seemed
unnecessary and that it would be better to isolate this feature.

Thanks,
Mostafa

> diff --git a/include/linux/iommu-debug-pagealloc.h
> b/include/linux/iommu-debug-pagealloc.h
> index 87f593305465..b2b82cf032e6 100644
> --- a/include/linux/iommu-debug-pagealloc.h
> +++ b/include/linux/iommu-debug-pagealloc.h
> @@ -14,8 +14,6 @@ struct iommu_domain;
> 
>  DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
> 
> -extern struct page_ext_operations page_iommu_debug_ops;
> -
>  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
>                        size_t size);
>  void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 801b2bd9e8d4..40133031985a 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -1185,6 +1185,10 @@ void iommu_detach_device_pasid(struct iommu_domain
> *domain,
>                                struct device *dev, ioasid_t pasid);
>  ioasid_t iommu_alloc_global_pasid(struct device *dev);
>  void iommu_free_global_pasid(ioasid_t pasid);
> +
> +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +extern struct page_ext_operations page_iommu_debug_ops;
> +#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
>  #else /* CONFIG_IOMMU_API */
> 
>  struct iommu_ops {};
> diff --git a/mm/page_ext.c b/mm/page_ext.c
> index 297e4cd8ce90..345af8c9fcce 100644
> --- a/mm/page_ext.c
> +++ b/mm/page_ext.c
> @@ -11,7 +11,7 @@
>  #include <linux/page_table_check.h>
>  #include <linux/rcupdate.h>
>  #include <linux/pgalloc_tag.h>
> -#include <linux/iommu-debug-pagealloc.h>
> +#include <linux/iommu.h>
> 
>  /*
>   * struct page extension
> 
> Thanks,
> baolu

