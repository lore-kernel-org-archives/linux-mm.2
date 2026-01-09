Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A96D232E8
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 07:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23526B0088; Fri,  9 Jan 2026 02:34:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0706B0089; Fri,  9 Jan 2026 02:34:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2596B008A; Fri,  9 Jan 2026 02:34:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA2A86B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 02:34:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 212A813AB5C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 07:34:45 +0000 (UTC)
X-FDA: 84311613330.27.40F61F7
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4A554A000E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 07:34:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=An5bTQJw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of praan@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767944083; a=rsa-sha256;
	cv=none;
	b=YkEn5G4LGktri2wFj4h2WpTk0AVPBqxaDBWAv6/y5q4vOi/iveUWCsrbdp6RaoYu2DFFmr
	Rp2K+pA5c0vbxS4fSZ+BMWeoonZuv7iZpqAsr8K+F6iH9iy7PpSZC3lzvYNikOzFEBjCx2
	kblb0VNo1lSkzxqpFjLCKl173nAVRBs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=An5bTQJw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of praan@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767944083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXFThduoh/FW3X3hmcDPgZVUcXZLVLfg8hOMDEL1+OI=;
	b=24FtbsMf5Kc6/rLV+11l7vcbuwmWFUz7GuGGENiWgke+qzZv0/0Y8RaoUBh0nuXMr5Gbld
	lAjUMSl5dRFdHZl/BtIcTrcNgmu1LDznrd4wZz83+9ybPTsMvT8ceKigbT8SMiOvx/84q/
	8s3mq/treMWNJTxpGZkhVOojGjy3Kf8=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a35ae38bdfso37685ad.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 23:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767944082; x=1768548882; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nXFThduoh/FW3X3hmcDPgZVUcXZLVLfg8hOMDEL1+OI=;
        b=An5bTQJw49YN5b9N72tm2OxE61mfA3YQmIsjH47Tt0gj8uQ3ssZdMjtGYmNRKjckfG
         9sCfb9fEp3BN+vTS6q0zY/8hxbBdOYukXHu/oWJRTLKY83xYUFRb64WnZ3pILijqQf3m
         kMtVaXE16O/DlqOpxpxudAHdAEhhKY/2u6QsI4q5PZ/6P86sZwY7PofP29R4Y4I1F6ve
         WXuhPB2FjmFpJE3ncM+eTfDMYwLLV/koYMo7Ub1+fYyN3nVudQEuagZHmf4o6GgLkY2u
         DIT6ZLza6+nCMFrba3gW7bd4G3jOgJ2tebM55k7LcWKbw4nVD4dz7RDpMhLwFaPCwXds
         OtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767944082; x=1768548882;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nXFThduoh/FW3X3hmcDPgZVUcXZLVLfg8hOMDEL1+OI=;
        b=HSklmUxG6QfZEuPvYJG93I++TQxIdkmBJERhgTO2aSVV28SHg1GadqPj6LcTtNLfUl
         EJNsSyXUaDDk5MOkZ/HnTB7ZzdNG8ubz37w/UgBsQrcCSWvuoLyTwo4Kst4us7bW4SEl
         yX/7oj2P6H1FXyEINsikOABLhLFfKR5isnQmudm3qeI8XAckO/ZObS7L5FSYC38t/Rtu
         yC37h9+kwuKZSrZroXspI2eUiXHtQzoJNUKhHyTqjeL8NOUzHgIDT0pslQdys0Dfqu2p
         zSR/B8iFO/6FiSzxpL2zUmLIhRaqffmq+P9+ju9ym8QWekDvMep/V90T254ItaG/WeOb
         zOUw==
X-Forwarded-Encrypted: i=1; AJvYcCUxlko4XzY6vzhY5oXMYJnlWEgAn6dBpFn3vJAjAUUyqwvYPikrPHXNgkzTyasfoaSly3clq7tajQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7mQ4xI3MO6uyGxQie57O53NSli3LOQ7UfUDCJvvZE+8CxYNKp
	i8HiENzIzwyrHNDqnDfLECUe4+k8JlUxfCuK7yUbCGq0ogf38NI6O353nyy0g1GkIQ==
X-Gm-Gg: AY/fxX7HduoJP+xCdI9zfAQDDbgzHD6kQf9usxWQc9/j+g16QUOe0dngFmuv6bgyYf1
	Tc6BXfNsZutHtZHW2WGXGdNhHrYDh9LkOUgcqSbQH8R516YZw/7qIhTlYknRGB4HyCSm0/rDYD/
	sV/czqXfqlYt5sY9iZapSaZR2rI7QuxSwh4MtFKvjmv4eKFjuvXFhesuXguXINrkJ5jqTLklWUq
	xZ61w8mFy0972luWBRRbXW/vvnpvw9ZEyPZIyiaV2946p6o8C1ttQa6DCQvLW+SNpBnU6BQQl57
	LOLognR++2uMR+YfetCy2aYEA8ZcDYccC7TV2khTnNNQWphL+8eRzqpvs0pheTl7Rz8jeXCV4u4
	W9EwiL22s1rvQr66JUKh8/HCpre7jxHTP/N9PrlWPlqcw0fBoNArmAL5INYBii8ljtRqLsvU0Bj
	sH2aXkD1eRATzAbdSr5aT4LwVbl2NlzruDEniTpzYxcGjrt2ka
X-Received: by 2002:a17:903:228b:b0:2a1:3cda:8e98 with SMTP id d9443c01a7336-2a409adbb36mr2245665ad.20.1767944081624;
        Thu, 08 Jan 2026 23:34:41 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3a560sm96327345ad.21.2026.01.08.23.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 23:34:40 -0800 (PST)
Date: Fri, 9 Jan 2026 07:34:33 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	rdunlap@infradead.org
Subject: Re: [PATCH v5 3/4] iommu: debug-pagealloc: Track IOMMU pages
Message-ID: <aWCviSCK7IBddLTn@google.com>
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-4-smostafa@google.com>
 <aV56BWisUQTMK2Gk@google.com>
 <aV-PvBqQ0Ktiha8e@google.com>
 <CAFgf54o4Ja7jQwxo6XyW+JaT+aUuj3O2dvLqOTb+YSVCKTdvyQ@mail.gmail.com>
 <d6236413-7385-45c5-94ad-8b0f2007f1ac@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6236413-7385-45c5-94ad-8b0f2007f1ac@linux.intel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A554A000E
X-Stat-Signature: g9pg3dgu35od6afef6nq8ocmntcwmm1p
X-Rspam-User: 
X-HE-Tag: 1767944083-281159
X-HE-Meta: U2FsdGVkX19MKo9mrb2jXieScz8DlYf5A/RQkkhabiQb0NvbctRz1gLAAAjWbkTEF9CURt5naLHMvoZ6KWg+E6M5sKsEQrRLagH3mSY8fo6kHEb8pSOQIcLs3r3SAKprt4XXTRU5LxD6QEfynmQWdYGwvGx7lZlkNrekpiAfds/VbjWcMdYds9MC+84krZlkpJSIXhu3ZkTNsApsoirhvvVQOMUoEB8btna3XecvQG80v0Q1DfOlS4PFiZ+5d/nvAfMdZnRWYBjkmg78pesHlMe+GbXj4EYVgarQTvysTwmuuYVS0TlXVrLbfG98tt61ZY4wzJFfki8lNyywBJHNApiIt0//Ayb2tp9UH7EbC8EP/A26g7QZb1gVwQK04aT/p9zsgsaed1XdlMxix2IZs8Dux6djtIz/FVqlvWRQAEwJiGIwhGV77NzGv8oB/2yHM4JhwLZaeyfq8Ij++SgD3fPy0+mYtoWc77jJxqt2H4bbWnrPJAF2DEBEnYeyxyQbcF8T9ywlMN3l4Nl9Zl82X87LBG49e3dOeU60kvv2rYe3JkjhpU6n10L2Ha2AZVba1/Bhora/PFAMJITaX/VUAV4cRkgxgpbKa/GcUwT7qkiN1qI+p3I1bB9xCdIaC5xKvPbGKiLx8aq8pYopM7pLDcUSOTr5garqoKTYGKlvEef/VZ7Q4grCEy+Dp9+4p+18UNQoS2fV8ExBt0qwp16+c/fNWw5c7ediMA1daFSkjRJ5sq7zVohu4VvWdAsOYFUX6WXAL/KourDAtwPkMyxi1ZzWmYIMlyIOYpqNxdSHPhC8514VXcmFSIh1pST8tNRSP2qalndc0cR6KGrdrQ6CKUbDvvsbIzeABcTOkXiZmW2wzk1pjhI+XDgvM9PV5NiBLKmFJiSy7wtIyFaWl+RL+RcAZiqXykSzgs5bxVUFg5YlzaiM9+zlL6YU3Wo6mCWftY8TRmRMAlGAFJvWrnk
 POOiJNjc
 tm5zZwQCpiIWPc0LGrTtXs+OQvilz5wl4Cb6AD9vxhR6DjaBxEHF9ruQb+6Kfj1yzxzHp8e7vbT+9hC/ZZz8qiny5/v8k+BNb57xye0477yYi71fep1fQo0LHKUtVjaKt9DDmBcJ/aT8U327nqTdlo1Ljx3gpSGq8Hvvf3i36A6761jEM9CH20O0SE1O25oLJ7JiYyaMKfEaQwfw/gcQhIyQoPQzdFhedTlkvtx6MlyvakuqD9+tJZ7rkg1QI45LTPaJ+icOPxofm8Eo2ZXOofraA5gdiV0ijb0iKXTyo5xNipXbB8SYrm5ZncZvA4qpwrqxRDhWJxBVyWz31pYcAtsTKrNNQhtTUnzzdnEyvXwXYjKA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 11:28:32AM +0800, Baolu Lu wrote:
> On 1/8/26 19:33, Mostafa Saleh wrote:
> > I have this, it should have the same effect + a WARN, I will include
> > it in the new version
> > 
> > diff --git a/drivers/iommu/iommu-debug-pagealloc.c
> > b/drivers/iommu/iommu-debug-pagealloc.c
> > index 5353417e64f9..64ec0795fe4c 100644
> > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > @@ -146,16 +146,12 @@ void __iommu_debug_unmap_end(struct iommu_domain *domain,
> >          if (unmapped == size)
> >                  return;
> > 
> > -       /*
> > -        * If unmap failed, re-increment the refcount, but if it unmapped
> > -        * larger size, decrement the extra part.
> > -        */
> > +       /* If unmap failed, re-increment the refcount. */
> >          if (unmapped < size)
> >                  __iommu_debug_update_iova(domain, iova + unmapped,
> >                                            size - unmapped, true);
> >          else
> > -               __iommu_debug_update_iova(domain, iova + size,
> > -                                         unmapped - size, false);
> > +               WARN_ONCE(1, "iommu: unmap larger than requested is
> > not supported in debug_pagealloc\n");
> >   }
> > 
> >   void iommu_debug_init(void)
> 
> How aobut
> 
> 	if ((unmapped == size) || WARN_ON_ONCE(unmapped > size))
> 		return;
> 
> 	/* If unmap failed, re-increment the refcount. */
> 	__iommu_debug_update_iova(domain, iova + unmapped, size - unmapped, true);
> 
> ?
> 

That's nice, We could also print the message as Mostafa mentioned, like:

	if ((unmapped == size) || WARN_ON_ONCE(unmapped > size, 
	"iommu:	unmap larger than requested is not supported in
	debug_pagealloc\n"))

An explicit "This is unsupported" warning makes it clear IMHO.
If a driver triggers this, at least we know the sanitizer state isn't
supported.

Thanks,
Praan

