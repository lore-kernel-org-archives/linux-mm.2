Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768ADCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 11:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C371A6B0029; Mon, 24 Nov 2025 06:10:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE79E6B002B; Mon, 24 Nov 2025 06:10:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD66F6B00A0; Mon, 24 Nov 2025 06:10:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9558B6B0029
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:10:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EB93B79E7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:10:14 +0000 (UTC)
X-FDA: 84145231548.18.E8B9EE3
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 542C04000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:10:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gaZxLMZK;
	spf=pass (imf17.hostedemail.com: domain of smostafa@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763982612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8AjfdImdi3z82U5X17wqTjR004YKNEvjVP2eHyRFGI=;
	b=nUJZnY/LQwZO4I3VQp6fGW33Q/9+2blohBFjAHz9C3vvgBavOKp4TuTwVgliq4jaF4WsEI
	ZG6XE9ogOTDWUD4GDiCoyaqjhF4HiZ9hxte/t04C+Qp+dhTkZ75VBMdZzGKSixf2Ah+9hH
	MYAcQlaQfTvuVYzTkGWi71PALsVnaLA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gaZxLMZK;
	spf=pass (imf17.hostedemail.com: domain of smostafa@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763982612; a=rsa-sha256;
	cv=none;
	b=yCi8GLrWYehiO1vdKEij2+XpzcOWnJAgrsBJn/fjh1uGC4J2LuLyHatvJcPc2zmACqWgAl
	ZAk3OXxuHR4pljW2E7ug+z60fp2AZEeF7D8x/38fgQjVm2hGAvUXYYo+QKX2twtUlZ7A6Y
	CGWf22Kj54EUGeBJXfD9pQh7/j5HzKM=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so94245e9.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763982611; x=1764587411; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P8AjfdImdi3z82U5X17wqTjR004YKNEvjVP2eHyRFGI=;
        b=gaZxLMZK3n5ggCNJzH4uPIVdfTDHhxn7M2wtIyzfc37/aqIFftj/WPKl/RKBg0xPEL
         Ugh9EGHOg9NL3Gr98iQklglWL+AINvhNrhgRIqccHTck+gfVdKgf1cF0hgVqfF8ehT81
         cjnhFf8q4QCzX+TOfh3AZwFSW6hm5xaZbLFFMZdPpN3jPjmOxY6p45pyU/Hofvcak9ch
         qoTNTh7CGjmTJHT0gacY8qMtANTYzqDELGbVSdW48SxyqgYxW7+rIX7TI2kESywRaC6g
         d5+MoGGNfSErUUkbnHqfIckemrnr/zHYxlCY99ihkMKjEDnsoSp40T/HT7My6XMx3BRO
         UKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763982611; x=1764587411;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8AjfdImdi3z82U5X17wqTjR004YKNEvjVP2eHyRFGI=;
        b=ADlIanKagOgoYVl++m6aKUZGXzVUFbWFhdlW1yOAP7IFwe9FweWyr3cqUyusNFZ5hj
         CuG1jeZwWMZGZUO1d12U5OpAfsislptvi4m2D59yov/YB1AEf446tcKrvFS1YX/lEsM5
         vGyeXtbpNZS8e7tbFp/Xk4nqYNn4KvmEquBt4ZtU3CmARCRLqOhaN7MXRCByCIYpRIx6
         UUPBfnkx8MYVcNvO6NTXCFETeQwt/cOwOGKElcDewzTmQBP+gs+tdTI/0Xln652PDs3q
         h8bXZcuOUc3aWb1KvLIuT2Mo6U49tJuudaoOaI6+usraVqSepWxRGdt6UnfSTgYOpeZf
         BPwg==
X-Gm-Message-State: AOJu0YwzjcTbirqdHqjl63ZDo07NL3wOqJIY+OESwBfqH+Pkolk80wHA
	lPF3m8Vwz1KG2d7CcZs9SQy8pkemvyEb4nPudI3V8P3aUytO3YghuwCf4dQb4GxYMg==
X-Gm-Gg: ASbGncufNwBMMZSCSaGvJ0gokeSCiY/xmmqAPUI1IXcEdo2p1S/OWLbuLFv6wh8AgYL
	ck6gYiCymYXWq5+zRunGpYTWHGJq2fRJMrxoOSqU+JWYVg0fpJGSt2Ka21mw3CMf8qtmnw4XbEz
	/vDsOyhqtQvbULlG2KAmuy3peKzyJc8JGCn6nZzAYqksNCtASjJsDqmIkjMhsG6FxwpUOn9sz2F
	n+lKzrAa2QgqAziNjeTBsCdsiGhqMWhsJKUcZ8SGe8CoBzP6/Jrhjtinw7+yuCwV4CX/kD2jmPP
	+nFxA2IeHgMbBuxKG7WaV5XVUn0iFu0c8xlPJln1z7PZOsim9vDiui0pae7jM6M7LXK/b1+AcaZ
	GrjSKm2E2SAV6gDdjjwXC40AefhLvHXNZStGcdTCQDq8j5/GmJedjzQsbcd+Jml7eQvK/T5YCRO
	u7Pr2ZM4K0ffh+4tt3rnh0GULnx10FzCqIs5LZMnIdwmO3CAm3eA==
X-Google-Smtp-Source: AGHT+IGGRir/b7AxctEA/ruMRlHV3TbVGbHQsIMl63FPt6s5B9UD2TFfctY7Vuq6Em4LmFT2VkcNLg==
X-Received: by 2002:a05:600c:654c:b0:477:95a8:2562 with SMTP id 5b1f17b1804b1-477c5ea96c0mr823985e9.13.1763982610531;
        Mon, 24 Nov 2025 03:10:10 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e574sm27670466f8f.3.2025.11.24.03.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 03:10:09 -0800 (PST)
Date: Mon, 24 Nov 2025 11:10:06 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
Message-ID: <aSQ9DsR0nAAvc4Pd@google.com>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-2-smostafa@google.com>
 <aRWtX3n2I7El4Ykv@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aRWtX3n2I7El4Ykv@willie-the-truck>
X-Rspamd-Queue-Id: 542C04000B
X-Stat-Signature: w1rjdknq1p7fffuf4d6kqq8psihdto8q
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763982612-98390
X-HE-Meta: U2FsdGVkX1/hsvGSzCjcxxD81cRkJEnjx6Ul9XxKZvFhtF0aCXnHxjzKVYb4ZIRSTNlwWvxbLuAIxS64AcLcCkQtmSxZF6wCAaSgXvXzCPOWXOqpJn5+7BWjI+7JG7oV6desXDNAywiOSTwMH6T1Q+QbzcdA12c3hsu57lQe088c31RP9HjOqtgnm/9Uh064B5mv8BlRwrCuBf50qD20GAuymzawdFH5WQFXvTSH4qJCIwezGOuP3u+cvEFw7YMF6bTcNeoh0I14hBHg2q+r2uBYOWstrkAD+n/zsuXgShxvd/oH7om6qrJcoZ2RdIX73tSjRmJMBIsuO+ixRLOO1u4nqMeMCv5cIEV08yveNpmMR8hv3PvsL/CoV+2CmqAjF/zluO0oAfRzn5a1pM3bQuIVypviUxcry+SfQfodhbasirwgaERXMBnGo5vIcoY6/2XLOOQL9RzuEnjzPieTYvPn5JhkCS7Ru5qaSSwAJw4wl8Var3tsuMewuDzDHX0z7V6BrH5gUanGdwyVqY27rTledi2MpVAfoP9ZTAuO35TB89W43/BHy/+LhR8Hd2EaTrYWno39pDPkvbURtVJ96f0YBuLT1tN59mf3BVAo77GT7Dg/2bUNp2UDlp7H46HILBMQ1cnWJXz6Eh5HT5nJdBw26WqFdSdXdjaFAcqc/wHBgftUSQ3X4zfvOiKSizPXxtD4bYQgp0erTkFq+poIfCapMwwT0EKNJmSOlZD/OyKP55YjgwnFGYTsHb2A32882lmGRmB73C7c9Ow7AoK5r4zxSUvlADpPnSZpU01AtKJIN24Lavrl4ziZliFrOMLTp1sLB10uL/CHz6AWjJrnj8iwvrMFfxCWDeJwkZBzbYjC8Halnif0t8RBKICfAezpVnX0Oez3J8LvF7YG65Hk2E9Mb1tzGJ+K0DIiQcfGyrJqHmG8bd4DF7F0vjhUldmuFXYLLdMjROAo3vwgyxj
 fgn2Vm5K
 FFP833pxuC8kHyMFUD48iOKwxW9KkMZJVxJaKZ4OPNOdjpN10+aE3/fffDRHEei1JK5dIQE/0Yy/UwIK1gE9DHWNuwbAZennTQ+3cVVUJvkD+TZ5wpDqtehR8jgqm6x4u0k1ej4XVyO8hVvka9Ncm3tKbGkYZGEoQTCCOBNqyPxvdKkpeoK8JM6K3MORCgsnc4jVPijUL3gnk1yyhG/nePxGFbd239p07NhRhc/rZtqiy3V2w7CF4Usv3E+ZZCFv4bNqSFMQTRiMca901YDInyexAS7oxqWoqPsJH53dH1ch3QGq7ASxPnwebmaQ74UAqs+uWCfH6ZxI4B1TQwvtJLvNDBcoazVpIsCHX5bFJXVDuF+5HY0AY7QQnHjciT/6iO9wj8HRjSgWopa2jTqCucK9zmEHhbG7EcJmKiZXc/DgYZTTOhpdYIQG100vpPGDrgxhE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 10:05:19AM +0000, Will Deacon wrote:
> Hi Mostafa,
> 
> On Thu, Nov 06, 2025 at 04:39:50PM +0000, Mostafa Saleh wrote:
> > Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> > page_ext.
> > This config will be used by the IOMMU API to track pages mapped in
> > the IOMMU to catch drivers trying to free kernel memory that they
> > still map in their domains, causing all types of memory corruption.
> > This behaviour is disabled by default and can be enabled using
> > kernel cmdline iommu.debug_pagealloc.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> > ---
> >  .../admin-guide/kernel-parameters.txt         |  6 ++++
> >  drivers/iommu/Kconfig                         | 15 +++++++++
> >  drivers/iommu/Makefile                        |  1 +
> >  drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
> >  include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
> >  mm/page_ext.c                                 |  4 +++
> >  6 files changed, 75 insertions(+)
> >  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
> >  create mode 100644 include/linux/iommu-debug-pagealloc.h
> 
> This looks like a pretty handy feature to me, but I have some nits below.

Thanks for taking the time to review the patches!

> 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 6c42061ca20e..9a1c4ac8ba96 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2557,6 +2557,12 @@
> >  			1 - Bypass the IOMMU for DMA.
> >  			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
> >  
> > +	iommu.debug_pagealloc=
> > +			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
> > +			parameter enables the feature at boot time. By default, it
> > +			is disabled and the system will work mostly the same as a
> > +			kernel built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
> 
> Can you be more specific about "mostly the same"?

The only difference is that the static key to gate the calls, I was not sure if
saying “exactly the same” is correct, but I think it’s better avoid “mostly” as
it might be confusing and as the data in the cover letter shows no overhead,
I will re-write the whole help anyway.

> 
> > +
> >  	io7=		[HW] IO7 for Marvel-based Alpha systems
> >  			See comment before marvel_specify_io7 in
> >  			arch/alpha/kernel/core_marvel.c.
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index 70d29b14d851..6b5e9a2d936a 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -383,4 +383,19 @@ config SPRD_IOMMU
> >  
> >  	  Say Y here if you want to use the multimedia devices listed above.
> >  
> > +config IOMMU_DEBUG_PAGEALLOC
> > +	bool "Debug page memory allocations against IOMMU"
> 
> Perhaps "IOMMU mappings" would make this a little clearer?

Will do.

> 
> > +	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
> > +	help
> > +	  This config checks that a page is freed(unmapped) or mapped by the
> > +	  kernel is not mapped in any IOMMU domain.
> 
> I can't really parse this sentence :/

I will re-write it.

> 
> > It can help with debugging
> > +	  use-after-free or out-of-bound maps from drivers doing DMA through
> > +	  the IOMMU API.
> > +	  This santaizer can have false-negative cases where some problems
> > +	  won't be detected.
> 
> Maybe just say "The sanitizer is best-effort and can fail to detect problems
> in the case that ...".

Makes sense, will do.

> 
> > +	  Expect overhead when enabling this and enabling the kernel command
> > +	  line iommu.debug_pagealloc.
> 
> I'd reword this to say something like "Due to the overhead of the sanitiser,
> iommu.debug_pagealloc must also be passed on the kernel command-line to
> enable this feature".

Will do.

> 
> > +
> > +	  If unsure, say N here.
> > +
> >  endif # IOMMU_SUPPORT
> > diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> > index 355294fa9033..8f5130b6a671 100644
> > --- a/drivers/iommu/Makefile
> > +++ b/drivers/iommu/Makefile
> > @@ -34,3 +34,4 @@ obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o
> >  obj-$(CONFIG_IOMMU_IOPF) += io-pgfault.o
> >  obj-$(CONFIG_SPRD_IOMMU) += sprd-iommu.o
> >  obj-$(CONFIG_APPLE_DART) += apple-dart.o
> > +obj-$(CONFIG_IOMMU_DEBUG_PAGEALLOC) += iommu-debug-pagealloc.o
> > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> > new file mode 100644
> > index 000000000000..385c8bfae02b
> > --- /dev/null
> > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > @@ -0,0 +1,32 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2025 - Google Inc
> > + * Author: Mostafa Saleh <smostafa@google.com>
> > + * IOMMU API debug page alloc sanitizer
> > + */
> > +#include <linux/atomic.h>
> > +#include <linux/iommu-debug-pagealloc.h>
> > +#include <linux/kernel.h>
> > +#include <linux/page_ext.h>
> > +
> > +static bool needed;
> > +
> > +struct iommu_debug_metadate {
> > +	atomic_t ref;
> > +};
> 
> s/metadate/metadata/

Ah, that's embarrassing, I will fix it.

Thanks,
Mostafa

> 
> Will

