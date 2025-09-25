Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31226CAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 19:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2EB8E0008; Thu, 25 Sep 2025 15:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563DF8E0001; Thu, 25 Sep 2025 15:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452958E0008; Thu, 25 Sep 2025 15:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3222D8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:02:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA0181A04BD
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:02:22 +0000 (UTC)
X-FDA: 83928693324.29.4F52B6D
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8077C001B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:02:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vv0ALtzl;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758826940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5BGgKN1hYVlPuGDz0FxzI5j2NNaYJevvvmLa3nnM5k=;
	b=B+nU6csA792kmGS/YFdv/HTVZo2cADxGW+dusMbociZOywbAlMX3mgXf+LQtIqdYx/ySuw
	VbqGdjE7mQtgIVMZp8Byam/6Qs5bU3TiOTgFo0OF53W2XraVRHANL+0+PO8jIFC1QJq6+M
	RbR3FZdchdmxplRUUyoYUc5p8STDu8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758826940; a=rsa-sha256;
	cv=none;
	b=VHy4mLVj3SjUexoGudWRDejb5T6NFiPNLFbEcqo6HQ5UHmT9+4MioFwfrMIZoznxiLOprH
	B12Jh0km9MZgNtHUhILTk6hkPSMsAoajZ2yuekRMjIty1prG6V9Da061z1tKWrgQzIkNt4
	IewZOJiyXV9LQxaPwYPPkKeAPCBCO5Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vv0ALtzl;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-4258ac8f64dso11436035ab.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1758826939; x=1759431739; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i5BGgKN1hYVlPuGDz0FxzI5j2NNaYJevvvmLa3nnM5k=;
        b=Vv0ALtzlSUX5SeaNM7u0nbq/FMlihQSDmu2GLin1kcTAc4maO/M5AVbOsbvtlncWk4
         CBzvaBVdtIcjQlnp4Fn1xKU81lK6yxlVJTPgjQfybAhZzj2SQrPKeIUEZLRs9hxmQGvm
         035IWmgp/d9FkjRnDlCD+j/Tl6YM0jHGe8BkGq4AhtQQiWEmYGCCqMCz18FupozTbPIB
         T7aUXcOJAp5Ix8hzlA47cA4MSP0BW1CVxNdGhGxu2ZJConOCrrG5YfI+6zeyDcLnyIDE
         M/Dp61/rSNOMqQ9aNxi9OInyE1hxl6V/itGyOsVUARZPBrbxln0ts5C9q5BGwXMAQrUE
         TXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758826939; x=1759431739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i5BGgKN1hYVlPuGDz0FxzI5j2NNaYJevvvmLa3nnM5k=;
        b=JVz7GOgdkIklUAml4Q7M5S4LxIe/zBFJBK21ihGeVdTfIbmvn5+MmRyBvxjXSgs5ML
         ZL9IcqSPyrPhf5UyxQEX6N4eh+Kqqr7aI5R9ziaPmJXeSVCfnlk6tKMnMPn2KvOlOS/W
         OnritK/A1iIkzmKHJfJvmWsIykrc0Qv1/ze2uSW+IPZOGBbIlBRaJYany9zBFYXSwZyq
         TakM1Jq3t95xjDx6eYO93G+7H7hVk0TTXtRn9nTPy+JQ2A8z5Ia6XsksvG9WiTBfzVsa
         A5WsyBIf9dsVpZ7a5fb+aVpOmLxC0Qx1mKTgNeS+APUIPOAGaVLhmjdOxeKTk7ytdGaS
         ixeQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3jnmNhqa7WH74q4gne5mhxIXmq4Wj4FW3sjlBi/PB9GkZH1X5lAgm6/C8j7zwG9sWxi0lsG6uPw==@kvack.org
X-Gm-Message-State: AOJu0YyrLvnvx4Jxz3IIma1SYsXzx+kLwnAVmb4gTdZt7CqS8yIWJzck
	2FbanjbEb2h1PUwqMbA9X+jIcTkRe8VY/WoMPteU1c+Sz+P7Nu91RFL4cl9pwTgI0fc=
X-Gm-Gg: ASbGncvW5ekq8iuZPg1tiLUoJ6iYFVRDNC5vwZOyGpBn20Ep05z29SyVBXG+hur+AVv
	MxlvPA8wc0fhZbwJqqv8D+sAfkEZDgTYrydPXhCPDKnxDYyccJ6Zq0Q7rtbt7GF5zco60tQHslf
	Oa3lPrFyDo1XGnyFCz8squTAr7AA4Tofl9DeFJu59H6iHyMtrik0HdwrgBEFC2lIJ4mtp9io5ZI
	WLFFqjQb4lyQ+hRVjIZxgetlEJRPS031mNfmmY/8SNOA7UiGtf8vezk3GAt4J0vZz4jam6sTtOF
	T40+WQNib9xFHaNxUB/9NXoVna5UuZAeV0kv7zT1soehkypJGaWjaheYij4xiW3k8egwxBeSBEz
	H8O2VU32XHE1ctEnDk61/sbaqepnyJ4OW9CXDiLAFUqqgpiqbFCq1uZ754iTcke+K+HQJQz0p2Q
	0=
X-Google-Smtp-Source: AGHT+IElHzEjP4n2pPcMoIuxsAK3EgVQOeQkGgr0O77OUi809sXnbgs87TM+n1OoXUW5tPgUfSZIuQ==
X-Received: by 2002:a05:6e02:482:b0:425:79b4:9ef6 with SMTP id e9e14a558f8ab-4259564482amr49397665ab.27.1758826939416;
        Thu, 25 Sep 2025 12:02:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (50-32-2-77.vng01.dlls.pa.frontiernet.net. [50.32.2.77])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a6b152a0dsm1065149173.81.2025.09.25.12.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 12:02:18 -0700 (PDT)
Date: Thu, 25 Sep 2025 15:02:16 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
References: <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
 <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com>
 <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
 <20250925160058.00002645@huawei.com>
 <aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
 <20250925162426.00007474@huawei.com>
 <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
 <20250925182308.00001be4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925182308.00001be4@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8077C001B
X-Stat-Signature: ob91861xkhtj6kjuo65jzwjwqbdsgfty
X-Rspam-User: 
X-HE-Tag: 1758826940-112025
X-HE-Meta: U2FsdGVkX1+HneEMlWtVidTjFkofCCixWqaarkUJQGvwJEP4u8UBZ0GvH1P+QtT1qIogI3EFqxkw/DyUVkmGqfOIfW0AGSsSsQY3/WNEeNIa4rTPAF+0eFNroCeswsLVldQdaoBHLm8O2V6sBFVfbrsXvqCYiLscuR8iNPv8MhdeHzMDZNtSbXWkwAAbZE0CIkJbNhTcB7HOToo+DKFBSzdeeAX33IauQojzRH0T3RlbZxt5efOnuRk46lD8qCbcHlhdyS0EJrTORqBCXqRopjFrNNq0X0d1ZoGixq7T1cAQ0CCkxRPRTeDF0uErn/o2lsY6OTryPt4WDayhw0TuVtJ5GjNp95WGJ3xk4+FdVxrwy3oD7/CH21+P3x/uFZks3+Lun6YOqGiuT14G2rN8IM6redjaJ7dFrRdX4u7b8w0kgCugNJgGZeQxdM0/Y3tjAOW8frFTvGxOAfuS7O6HuMPdHISBmTg3CUe/pTp1c2k9bz5tFPtTWv1OdaDOT9Q6DJdFAG1VcpWj7BUzJu4nwCIx+z76ZPPlQtOWrhtV1nzKL9B3iVEsYRX2OCp4jCpT0GrH83KOATOwogQmOVkV0JfihMflvvw/BOmZJI7yJNqW/u3m87oSx+nv2fpes+8Oh678jCYp+CWHlKJ30UckNBCCHIW1vaYZ7XGZdSFwEG/ip12ubNyrwES9FR0RiYjn7+ZZ4VqRYGcIxV3mkpJutTQhlJy2rprF6MNGgjjpG49HcV4Q589d5QFQlcWlMIZTlsID46C/zwu4c2mWvufHakWI73aOhWMZsz8gjEIYOc9tc4ZfxiaJfcTtTmQKD83330I6aeLwdZR+cFoqCSzFMWH0NPylKJP298cCpiJz1nGnrG7NgIehXcVnu9p8O+DW39D4y+8BrFe4neFQBEjtDA+83vKMOjNd8QtcNXO2yhnS/VIjWD1BkqbjJhRLueWz+EjvwKEvyLALgpydIPh
 yiRvGOzT
 y55/DySQdVbrddZhOVWt1S/an0VcNkVIwBl/kLqwPuAju244fz5hvFQI9t+f+aRumylgkVllRcupaWpFJ1OmZjBcCSwZ593nzSqUeNAY0+vBHkcB7Ok3WzjVQjkyvx9QjoPChxTWAOE1Uqpr3m1awZvbnTxDHmjpHN/yXEW4Tnc5Udq/BYQcgKTo4D3WfQ2zEt8Yn6hdOUgXG9ipP/UXqC2Au1nLumrlnob4zB2EidybeJjMEMT4nfiy/WIwnAaCTPbZHIKrE5KNvHBmEFBUEXg/EeUcMJ/2wQ54Pe6HgEG9K6GcJfVahZMLH12dwPM70I0UaQBi+BRTkHYPkyq0Z6sPe3QTflrcGf36P958b0+QUnikG5CsETMMpqsIidPvLz6zm7ookjBufAhZHjCSQAqOk5ANQNqv2ZFgn0PFV1et5Lt+OiSYFAu6VJAfaYFONSlEdPXP1d+xXuTI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 06:23:08PM +0100, Jonathan Cameron wrote:
> On Thu, 25 Sep 2025 12:06:28 -0400
> Gregory Price <gourry@gourry.net> wrote:
> 
> > It feels much more natural to put this as a zswap/zram backend.
> > 
> Agreed.  I currently see two paths that are generic (ish).
> 
> 1. zswap route - faulting as you describe on writes.

aaaaaaaaaaaaaaaaaaaaaaah but therein lies the rub

The interposition point for zswap/zram is the PTE present bit being 
hacked off to generate access faults.

If you want any random VMA to be eligible for demotion into the
tier, then you need to override that VMA's fault/protect hooks in its
vm_area_struct.  This is idea is a non-starter.

What you'd have to do is have those particular vm_area_struct's be
provided by some special allocator that says the memory is eligible for
demotion to compressed memory, and to route all faults through it.

That looks a lot like hacking up mm internals to support a single
hardware case.  Hard to justify.

This may quite literally only be possible to do for for unmapped pages,
which would limit the application to things like mm/filemap.c and making
IO (read/write) calls faster.

which - hey - maybe that's the best use-case anyway.  Have all the
read-only compressible filecache you want.  At least you avoid touching
disk.

~Gregory

