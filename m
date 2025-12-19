Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE7AD78784
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEAE06B0088; Fri, 19 Dec 2025 09:20:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98B16B0089; Fri, 19 Dec 2025 09:20:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997366B008A; Fri, 19 Dec 2025 09:20:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC956B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:20:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3984AB7A54
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:20:06 +0000 (UTC)
X-FDA: 84236430012.12.63D3891
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 581C540012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:20:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ByRMx1Ew;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766154004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hW7NRm3sDPFQ7nrkAaNC4Y4Wd/wDKIKOLKQhRLlFa/g=;
	b=LDI3eOGjDGrkHvoAFijwu4iVQYwO3z3Litle8DNrlrS/+XJOJUIt/MM5VWNq7z/WYqu2XK
	yLk/y5FyvAUHW6iXzHYzmM+K/lCny2XblDy9J515EbJs5zMZvsKB7p3iI2ndymYDNuk7BM
	Y95Y+lT7unoQyIN76O01cg07XGZk5cE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ByRMx1Ew;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766154004; a=rsa-sha256;
	cv=none;
	b=b21RTJU3vk71ePa5L1A+EwCcbkxfi8d04VfMl8hJf/kmZTOxuUzZR+JVggpOEfLsJplhA/
	kPCQCUKah3M1kFPQwFbEebNKc/UQS8aH/YaiT7kqDKOuUR1ZFHscc3UNJuvvkFlIf1TR6c
	5P5Md/sWuZK9KhGxz4LpSAhOFBAPu8k=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b2a4b6876fso264260185a.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766154003; x=1766758803; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hW7NRm3sDPFQ7nrkAaNC4Y4Wd/wDKIKOLKQhRLlFa/g=;
        b=ByRMx1EwrPgoxNZjU4Ec8Nlki0qm1tkQwdIaDMETS+G2DiCvNBadV1UkmaKkTiWCU8
         dMgPLvgHbKmz818Zwii/Np9h3CuLXYmyL5+gKV8S1H35EtNpD/GIvOSIxiWhGPiq699P
         vOQGkOvnk9uYZ5/A6d0l7BxXBG1ucYzY0c1AI3BegBCasSTpq9KgYzl+wCPE7ZPDXu2c
         QJh1DQkm53bSGXakvx6wTb2yoe9/soxG/905fGA+voUi2yPZXE/EFNCSyMAAn95GuiaP
         vtz6gcaEQFZ3h3C5sD3Igyv4mxnHN/V9mTDNUlvvbUQxIQX4afmJ8E52nY/BqpmP5CnB
         vKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766154003; x=1766758803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hW7NRm3sDPFQ7nrkAaNC4Y4Wd/wDKIKOLKQhRLlFa/g=;
        b=glchlhKoIYa9uDeIIWqYQ+c7VIzOpB/LA8MOlx4dTWzZkJR9x3FmnC+9ozFMcBk7uE
         K/hBikcPWGOiwVsJhk4GbsSZ2S4BDAGOQKzM/GVjYq8Coav8V7K8tkxq8KbIX8MYNEvb
         /nfI5HjTnXaCBVdbVR2AS2IB7q43yc8n2jBk6prdNfZKjU21rbZwCg471ON3jdrmxEcu
         Ex+tB6X+tcoUEENnD1HjICmee8ajy5ZfsdZD8Iz2ysAQkp2Btl90RJOiSpcEBXrpKswV
         zyy4H5GeF/KoMMtHLcWgKMiPzWjnCP1APVK3dHYi0LY/mYb0w3Y8Kpc7DvuwVYDq019z
         zgfw==
X-Gm-Message-State: AOJu0YwbeWkHjhtul7I5YKah2HGH9ws4H456+d5h9exCJYjGFGBIEkN5
	H+HsixSi8fVtIJFrs6RpjImohsjstOStKOUMMtpM99rHSJ8fIoWBw4UoGkO025xSqV0AUwsKtDp
	PKlcC
X-Gm-Gg: AY/fxX6y/D6ENpXJLcSpJoDw71BAmfMYE/nJZ/OWIvFqa1gYYEo/T1lqId3i6JCzeiI
	52CbVGNQOdlPzzAJDPMM8L9+3ZeI4CD0npiKfBP1g61r+zfpXxffk7yfml2NIETed1vHMSO5dAM
	KL7Du76FFBnQeDQ4+8wPo/6gU72CmqIDNnYsjl4Rw16xgjY0bjneT5Y6Lr2R6MnEGnuT31CvXmu
	I4mhi6trRoFJnmkwsBOif8Y3C3xwytECBmPPwwMqZVU5i9bWHFs517ehd+F5G6X0eBnEJEhgEzl
	H52nme5g5Yuh8yTzmtH7N291KJa20gcs0tymWPd+APMOEl/1qKk/3trZiFTJ8u0e6gk0pB/AQIA
	vcy3A7Rh3/Ba8POYE4/M3BsqL4eNCT6edi3Ajo7UQElInztkxuysmUeu0jumTVFoK1JA7pms0Ib
	N0hwyJ2VLMdZ17xYM5EFctGWJS6E++65LhcL4c8CtQCwDZ5g/s+4a8ADGoWU5G4aM5/lGKHA==
X-Google-Smtp-Source: AGHT+IHYIJem5uFvmhfvke6poQSoVh8bw4dQD1q/LPyab5JVfwmTl1oj56sHyV4WyvlwsvYQx1rjSg==
X-Received: by 2002:a05:620a:4108:b0:8b3:3d62:67f5 with SMTP id af79cd13be357-8c08f65683amr458504385a.11.1766154003033;
        Fri, 19 Dec 2025 06:20:03 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0975ec0f0sm188333085a.50.2025.12.19.06.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 06:20:02 -0800 (PST)
Date: Fri, 19 Dec 2025 09:19:25 -0500
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	david@kernel.org, osalvador@suse.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	muchun.song@linux.dev, laoar.shao@gmail.com, brauner@kernel.org,
	jack@suse.cz, hannes@cmpxchg.org, mclapinski@google.com,
	joel.granados@kernel.org, David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4] mm, hugetlb: implement movable_gigantic_pages sysctl
Message-ID: <aUVe7Q90PxGBCt9e@gourry-fedora-PF4VCD3F>
References: <20251218151211.1237411-1-gourry@gourry.net>
 <20251218165538.b299508aacdaf7d941035ec3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218165538.b299508aacdaf7d941035ec3@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 581C540012
X-Stat-Signature: ncb3h8kq15m7sywymfe8atbpi9ycjdiq
X-Rspam-User: 
X-HE-Tag: 1766154004-742247
X-HE-Meta: U2FsdGVkX1/ucTQeiZsQXHYRbgAzmcnTMUiAOPpbkxQQuQahxc13rU9Gi/kbzfhYVaPUQUs/RNkKlSk1SYJcOMnL5ge9XwjbXSPSr6SPgSFcqbYlJZmxX/k6tKw0trsGoSgUG55fYf8VU7SUkqkE6l262E/f9Y0lHAOMQZO5KwVjIG3+9L7RYjy9qU3H1KUuav9evOmL6ReQGOQN2N8Bw6Dl/8LRrVu6gpG8MGfV/zv+tTq3nVtQ0PxVm4jmGoSRgdRwnPi8Ny6bQqm1ltaktJ5UPQDw3pyJpl1xy7pRi0q/GcJ/r7Pu/u+NBJ/iOp9xkTRACFvYXXNROYW05MxnB/2wAdRtWR/WVgoQKoXji9rmUoZ4lnPTTHyzgPFP9PLANPeyi6RY6lB03SvNGtJcI7NJkg4QM1h1jl0KkRsXtCaM8qCVEAeu4ZPi3swbDzKnAdNngwyCwt33rx+6QdYGyKLMznemqfFxao2k56CBhJNQ4VQObbcyOCmlvJfEa5cok+EbBvBducvbZMjYbF+XhHrTCe2fBjC3HHH7q/jQQruEEHC08/Dw6naVtOnVwonZDqsI/bPB/oBtLNCUjYOUHjhNDhVeyxHRFYgjIqhIfxdf2lL1R21QeaIeAObrCv3UFIRHGZp4aDL/FmCw8KhqgqWDyk5Dajo6VS3FMH/3Tu1sXGBnGi23M+F85Pigi7omqMRDApREFnqzRiBn1eZ7r0iN9n/sAEYmMG6lgUdFfxYXYYoLUIes3yYDnRyFBpRr91CDdRLLVyQBU87DCCvgjxi8RdG8x1AwL3h1dlUeymvx+N/fJoSoA9mmORkdxax4iUMjT6DRgwtM4MtlhG0fXG5xRcbN+O4coGTP+eF6jFFfjdMd2S0RIfvlC/zbn9S5n/mEcdbs45VwQBa448W6/jXC2YE8uztQyp9obWXLvZjmCRNZeYsohtSc9oyvUcpBzr0RzhCv/YyNMULivR5
 F1whCxhu
 336RU3Nq4U61ll54/V6NvemfIKr5EEBwB5dSAgbaBVGH/BlGX3sQ7oaCPWJFU8BrHjdXmWpZEH5uoHvodUKzy0gWdGcEpLcKs6jJO6i963o47rKxvN3hH3jw7wPSeVrmK7x+0hJIXA+jTpYjLZatzMIUp/3SDfNRAnkGUTuW8MNMov8FM/GdmjlPe2Z9fl5v1sz6KI1+nEDu1gF1bKUagoNTdIUfE1mH+kGU0uSYVyicKcdt389pc9FULh/UFRLd1edenlls+8FbnfaTAiUcmKQ/uAQh4m/BVwimOIQ70lNL76pOrTsEdVsG8ux8R+woYm8iIfuUmGwJPsaFyY9jdotNJaEvHUxuSnFBRLJQGK48MCay689mfrXIn6Bs3TAWhd79ic2lKV0lD2uI5tDMvEJIEkUK4eQxKEcojW69zZHjztc12oU+OEMr5yTCzDoplXi/xkHigXWejh6zDW+OgqyzZ3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 04:55:38PM -0800, Andrew Morton wrote:
> On Thu, 18 Dec 2025 10:12:11 -0500 Gregory Price <gourry@gourry.net> wrote:
> 
> > This reintroduces a concept removed by:
> > commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
> > 
> > This sysctl provides flexibility between ZONE_MOVABLE use cases:
> > 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> > 2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable
> 
> My x86_64 allmodconfig blew up.
> 
> > ...
> >
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -49,7 +49,6 @@
> >  #include "internal.h"
> >  #include "hugetlb_vmemmap.h"
> >  #include "hugetlb_cma.h"
> > -#include "hugetlb_internal.h"
> >  #include <linux/page-isolation.h>
> 
> What's that doing there?  I put it back.  Helped!
> 

erk, this must have been carried over from a forward port, when all
these things moved into hugetlb_sysfs.c - very sorry, I will be more
careful.

> But the build still failed because the patch refers to
> 
> 	extern int movable_gigantic_pages __read_mostly;
> 
> but forgot to define it.  v5, please ;)
> 
> 

doh, well that's just embarassing

Will sus this out and send v5, sorry for the time sink

~Gregory

