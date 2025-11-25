Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E9B3CFD315
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 09:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98866B0032; Tue, 25 Nov 2025 04:42:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70666B0062; Tue, 25 Nov 2025 04:42:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86B06B007B; Tue, 25 Nov 2025 04:42:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B492A6B0032
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:42:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72CF51A050D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:42:51 +0000 (UTC)
X-FDA: 84148640142.01.13013E0
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91761A0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:42:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NLeUf8R8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of smostafa@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764063769; a=rsa-sha256;
	cv=none;
	b=B9WdVWxPHBJxZaodr5VdRtpRu/niHMPIZ7nTL2G9mr09lJu0a/pQAkQ9CsR9X2rnm24L7T
	N4Yn8+qAJPWXFP3dmGUN4lOPuRUTbcB5GWdrcuQDyMtMgbdn8c+iwnBjoEtBeIreaI13ak
	t75HAmYYTcz3Lb5S0RWEZqqWd9Z6fuM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NLeUf8R8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of smostafa@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764063769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCXHGSoCQLbBnbJkgfyqXAP9QKSn53WdyAoVSewwZH8=;
	b=yaPfULz1yrZc2FVOnmFkendZY1qinbdW/OyJtQg+3aYpCoCiXazZWKqRk8IiCNwppkxNpu
	JceCcukeXI+MZaJvclFNNC7BBUVjJEntjzmP+HCDfaw3z8C7nWHkO3GkwutXbWmMPqGfWh
	xqBWkm/bEaIDs3tJZ6N9FeiIeLnu6Bg=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso47715e9.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764063768; x=1764668568; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gCXHGSoCQLbBnbJkgfyqXAP9QKSn53WdyAoVSewwZH8=;
        b=NLeUf8R8VOQWh3rL/HqDQBIykHyb8SbUqv+Nd012VlxQxOy4QnlWGykXh/1vK8pjbm
         eoAeLHSMlDdq65sDC8pHhwzjdhJAOkgYvhcuGwLhN+mbKpqv7YyyNkMjppB+nJ3bePQX
         Uon1aQfbGMkbcMnFI52tvCQhrxwuzDU5Z0vyOZlReXHGevq1QI4yKGLMdNzkF++cQhLn
         JElUxlHJdnAduYjQ5NGhPpR35NHr4iQy3aDgl85GWm8EoncPa+gfevhVG6xoM8oVFQQE
         UALVLdDHrcLAsg/B5dCl6UVlqnCTs8osmDg+eeOuF6R6sAPL0n/JmtBwWMd1tgeIo8G4
         Ikfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764063768; x=1764668568;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gCXHGSoCQLbBnbJkgfyqXAP9QKSn53WdyAoVSewwZH8=;
        b=jrw4YkBH28/udwseG35yaRHPVRaSipmBLohVQReQbUBQJUaY4iUOxNDoH/RY6A9DFo
         zXN9M0waQvHvQwZkS3p2z4f1u1IX1AGG25L76RE865kAUda4t7sZQl9Uv9ibSIjKmBDB
         0NwUFfloQ7Hd3cuJPfcVDlK46KFLenqESdrQeZ5MIrf8kF5odOBy7SE3Qi34tTd4gDGg
         GowCNQvYoZHadjPLDSrVlXC5BUiVIZwmM99fm4/ntOvzVe2DKvp+WzipPqn1XSwiDguT
         tvQnJKwKBC8G99GJuHBslMPLQnewdf5j65sQFS3NahQ64bKKrNFc9pY1il5QFeAGJAPz
         fx4g==
X-Gm-Message-State: AOJu0YxBOTX4yh0LfkHSPHo+S4yZzY0CKDg+d2S7SIG5v7vh/AZPbQ4Z
	555TtJw5CoNgMxAEXavbMbmYbr3mvLeDsap11mnt/fTboirqGWYVMkUoftvD3EfZPQ==
X-Gm-Gg: ASbGncvWIbJj3JMlaxe/2ZldtuC1ZA58OYCD5SeUZayZ9Fd+XAxWwDuhTe9bQoQqTql
	yx8o4fB3696ZWDc16ZtBsqpINmOmLs/DTG87qDI1QCj/GlkBkxxLq3MZDxDrI0xyiUu8OBfLOp+
	BO1CQ2BRAhxqMajyrGOyFqQERw5+XmBXJ7FQ5VtTdGu80cRIGUWT28fLIQxybkMWNY7bXV4nT7h
	sFZn+sG5Kjyr/R5fvYqZoQ65BQ6vmwPqsJ9ReK/Po/snWSgNPvlWEVwAgascRGHjUkhzDT/endn
	T7+18+bG+TdWDedmaCF3tPdhYUcylOYVCf/GrUD7GcYu19qM/drZlQtyUtYtxR+DgHmbO650gz7
	4UJnoGL4aI9Z4xXrHoo9k7QXEcCkJcp0iS9hh1v+llNg1lKGEZh5EQmQD4sfbvalfGu9BeYxV85
	eJhcvu7vhiprIKYrfz7ewOlk5IFQVji8a2XpOiIcS7/houL+QgD40qfhqsUma9
X-Google-Smtp-Source: AGHT+IEnhOrLJGeXT6QUokA3QYFoyH54rP3priqnpDd397EAHhk3ibEBNXSKphd8QyA5DX/xXbjC9w==
X-Received: by 2002:a05:600c:3582:b0:477:95a8:2562 with SMTP id 5b1f17b1804b1-479068fa210mr331535e9.13.1764063767841;
        Tue, 25 Nov 2025 01:42:47 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479052d95absm11951115e9.5.2025.11.25.01.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 01:42:46 -0800 (PST)
Date: Tue, 25 Nov 2025 09:42:43 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com
Subject: Re: [PATCH v3 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
Message-ID: <aSV6E1a4tL_Vt8cz@google.com>
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-2-smostafa@google.com>
 <7854489b-bc9e-4bb9-a19d-cff96badc180@infradead.org>
 <5d7a305e-d6b6-49dc-ab1d-bddd1339d4a7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d7a305e-d6b6-49dc-ab1d-bddd1339d4a7@infradead.org>
X-Rspamd-Queue-Id: 91761A0008
X-Rspamd-Server: rspam07
X-Stat-Signature: 373hjhm591m6rramagjuezocb11ddrqb
X-Rspam-User: 
X-HE-Tag: 1764063769-807321
X-HE-Meta: U2FsdGVkX18MAoQop0dI7k63A4dm6pNQS5Mx56xB+USrMROeQ7aPNI94N9dQEoJKNGFjFeZ9ZCinHjiqP6juOAN/vLf6b0+JOVos93HyoCMwDbClGf685zlNUtYWPZ3morcPSDfnk5UqyrNz1lDWNVf9nD0GjbzqRJ23q80DM9VYuyjzwZdb+6X6LZWn5PufLOSBcXTAHgAmvqHwzYOgCbGt4fyVnFu+hhE7SK2hxaf1Hr+skF1xeZ1h8ouKpcc0hRDKSbVBSBIZqJ/Z0S0R6YiS7P1Gka3xh1FG3S3I9clbvCcp5xt3b6SS27PhUh/DmAcnaeWZHKmqQz3Ntz7NupqXBZ0ptgju+kSr9wEyx90bCxCCVjeY9yHFx5I3yEoXstXzwce8/DiNKj+iKC3qd85/AolkMVNCQ6vz/A/qYmEyFNX2aAPxkOfNSK3Zf/Y99sOXK0DWyon7xrNBD9Bj1nukyYyxKbeMXDDVR8BXs0I7+qOERE+cqS6hRsv66vr/1KXTXtnliFc8lXcXIiVudSxcFIGFmTlhITDqEiWM/EwQPVAKt6OL/+1vGY95GOP4VhHRkGEDqArNhaHF4IMMvbpMpLvKon+i4lHiJc2iDT/fAR8akG2w1f5OlHStXpY4cK+ov6eVe19vVI7/dqWSdt4vxZtmW3M1julqQ4otzX1v/ui8j132eYRW40ruADKUMZbORp1Zkvg0qe9A/dTE2IUcWV/ZEO9dgfHeLs0jgF/xY/3xOB/64HV+tl1eIabpMViE1pGNkk8t44yeogMCvc6OVUAJJY6CQz6hBDmHRcXYJp3ivvQRFPkS6R03u4vzR9UC45qJMzxEu1c/vm9E5EP6U7okNpIV6Il9kzmUQ/MWEQM5PndWH6gZ1QI3edLpsaQktJuvE5UcpRJsLvezHGM9LibnqV0KkLBDVtoulVfW5bkjwOKdoVhMIq8kbV/Ymryc8Nb9uKcO/41SXcQ
 UCNNBqt6
 yfzMMk+VSf+EDvQqU8Hfl7rRt0wHPPgd+MpjoFvNX0FzTl4YiNLqmVAHYX1zQyL4XKxxVS89I/NuVFRSE4l2F1ZpyVk5JA3WTB6dAgnY8gH9Av4SGV++nyPAyysAViHp8XUqG2vUxGQdJ7FxIH0EUUZx4off6PJeFTbVgAqBoqpoTQkAW8KyicWYcVCBMOUPGw9NaKWNGP+rypy9DIp1zQwMsDBjQRn4yTiBtZZGaV/cmb3RXO3KqPwq87fFaAAO3RBp+UUd7kwy0+CpMt4HMCpQ7oX2eBSiFEaLqzL7mpOibdAojG1UuJR0JVe4vUaYLulIk5CUJi6kJ7uZPqGprXyw3DipRYwdVV+Zhw+aJdsZHB4y4B6YH0W/esC6+D4/61Yi9nCBy7u5jaAn06vKVhfPU3R6jJrLehRHoRTXR//Yi0Nw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 05:31:12PM -0800, Randy Dunlap wrote:
> I missed one other thing:
> 
> On 11/24/25 3:13 PM, Randy Dunlap wrote:
> > 
> > 
> > On 11/24/25 12:08 PM, Mostafa Saleh wrote:
> >> Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> >> page_ext.
> >>
> >> This config will be used by the IOMMU API to track pages mapped in
> >> the IOMMU to catch drivers trying to free kernel memory that they
> >> still map in their domains, causing all types of memory corruption.
> >>
> >> This behaviour is disabled by default and can be enabled using
> >> kernel cmdline iommu.debug_pagealloc.
> >>
> >> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> >> ---
> >>  .../admin-guide/kernel-parameters.txt         |  6 ++++
> >>  drivers/iommu/Kconfig                         | 19 +++++++++++
> >>  drivers/iommu/Makefile                        |  1 +
> >>  drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
> >>  include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
> >>  mm/page_ext.c                                 |  4 +++
> >>  6 files changed, 79 insertions(+)
> >>  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
> >>  create mode 100644 include/linux/iommu-debug-pagealloc.h
> >>
> >> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> >> index 6c42061ca20e..dddf435a1c11 100644
> >> --- a/Documentation/admin-guide/kernel-parameters.txt
> >> +++ b/Documentation/admin-guide/kernel-parameters.txt
> >> @@ -2557,6 +2557,12 @@
> >>  			1 - Bypass the IOMMU for DMA.
> >>  			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
> >>  
> >> +	iommu.debug_pagealloc=
> 
> Please note what format the option parameter value takes and possible values,
> like iommu.passthrough above here in the kernel-parameters.txt file.

I see, I was following the kernel's “debug_pagealloc”. Although, the
implementation understands “={0,1}”, I can add something as:
	Format: { "0" | "1" }
	0 - Sanitizer disabled.
	1 - Sanitizer enabled, expect run-time overhead.

To make it more clear.

Thanks,
Mostafa

> 
> >> +			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
> >> +			parameter enables the feature at boot time. By default, it
> >> +			is disabled and the system behave the same way as a kernel
> > 
> > 			                           behaves
> > 
> >> +			built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
> >> +
> >>  	io7=		[HW] IO7 for Marvel-based Alpha systems
> >>  			See comment before marvel_specify_io7 in
> >>  			arch/alpha/kernel/core_marvel.c.
> > 
> > 
> 
> -- 
> ~Randy
> 

