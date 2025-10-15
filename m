Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E3A0CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 00:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9788E00E1; Tue, 14 Oct 2025 20:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A6F8E0005; Tue, 14 Oct 2025 20:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B01D8E00E1; Tue, 14 Oct 2025 20:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43BFC8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:43:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 906AA160938
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:43:45 +0000 (UTC)
X-FDA: 83998500810.04.6CBD607
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DFE00C0007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:43:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v9QnkIUm;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760489024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Omc6TNPlqTlsy63+D5qzEpE+EP52tM0YYCPum+OtXVY=;
	b=3ltbTvv98mfkAw7USiTKB7tfCcDiMqTKdctItUxVYJQiis7qKmuzTnZVMNPc/p/guIGhMJ
	QnAD2ufMxp5L58QecF6h6vwZlV+lt+FLy3XOSV8e1/GU32z2qQ0hEu6UuCxVqOWBCX5/r5
	ZtxWoOhFCXgjB5BasMjYlsTnXIdPROc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v9QnkIUm;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760489024; a=rsa-sha256;
	cv=none;
	b=KSQIqEH4PvX+9X9Ssi0MOI23yMuL688zsryf9a9Cxm8/xr13Q0Mdtt+oucI2K4B5vMjY8j
	/ef2Xk5DZe85Qf5GKDdyITTjV9wb893l7TXsq1hIdlRGnQRSVvX2KfaJWq9NG2h+rU3W4g
	HFfPjxzv/tP4dCWJR619F90gTntvZIg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FA366022F;
	Wed, 15 Oct 2025 00:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F03C4CEE7;
	Wed, 15 Oct 2025 00:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760489021;
	bh=KlTltCVjzil8zVBXTbYHXZHdEEBKkgd41/qdQ/Dc+Ms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=v9QnkIUm4Z6bwO4R7RVxKZnIh4L+AuvydsQgUMCypyYdq/0R1FL+RIIM99oNJyAcK
	 6Mz5UDsCYld2vxhsaBOiTiIFgLsE426IcH1omBVfvpHcRoz04HtnsJmgdMsefK11w5
	 F1D0Ln/JMyOu5c0utKnsEIauL5D5p5udyEj+lvQE=
Date: Tue, 14 Oct 2025 17:43:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin
 Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Jann Horn <jannh@google.com>, Vasant Hegde
 <vasant.hegde@amd.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@intel.com>, Alistair Popple <apopple@nvidia.com>, Peter
 Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, Andy Lutomirski
 <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Michal Hocko
 <mhocko@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/7] Fix stale IOTLB entries for kernel address space
Message-Id: <20251014174339.c7b7d2cfb9f60d225e4fe5ec@linux-foundation.org>
In-Reply-To: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DFE00C0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: onk58ztkfu5txgm6gqhextk3dofyts9w
X-HE-Tag: 1760489023-96466
X-HE-Meta: U2FsdGVkX18xXThBhsoQa84ZeLOk/whKCT1MW5YqbcWt6OkvAKuyC+9BxSB6cYuqkTkGUFU0wkkYLHW3LvtdtgyHFVv41pwCzvO8NBPZcZDcPbY2RkCoRpzE1uIhN6cuHIAH3JGZHik5ftRhmqM8x3PBhnOrAAQJ+2dAgVzCI+krQLhcS2iaSD/Pc+HleihWUlUkaXFK3p1FreQbjdv0Wtq/Rbfi9aNN/kUVSvVj2TKmK5q6qahpB58OqH/1rVgRlAz6mvIa5Y3TQrkolakNwJnqPrtIVBDWCJA4p1VxDww3sRUMKczPW4AdlgJ0rC+KCwqBL7gAOYdzboYJ1l/J5h5kN/2kg1Xf/nIJu6MbMD7TBW1ATm2hEYVCNSdhbmJ71ZchAlR2LyIvvqnuNFmVEtVRsGQ2o6+nuVBo00C0PYtgZF++w832KMIklUDGq2/XJ8BqtUPFdz5hMRelLFuLLUAH/7vH9NQrDPj6Hp4POxxkOVraPV8MI5J/+cRQAHmDWW3jP7JRRUC8+p+ctJYzPlbSZd91ie87TuUJzl90X0IwbnKYndkN1HloRQ/ECeBUdmjC/niIllF6fdicw/qGiHf0P7AwBgWfyfh+4wjUdoPe5NkQaJq3dd5m8aB/kgWC6E/sMlqs6lEgbVw7gZBiG3l23wvodbFATSNORhVMBEzKHWzmZ8PaAJaMweQRhBI3ZXzQk6UDf4fgoQlBg4lzKAOiHKZPMhCb47Vvc9TSO2QBrAuPjiPIphTBISs7wu2VwxXZ2GrtHZDCY8a0OveyGCSnzbuEB59F6ftpoqHVrddi8pdod5MkoPf98g/XOfRSmC0VvJG3uHgkRjrcWzPEJG8A+ygNQKq/Nebh28/XPsdwAxTufAerb8uMouDVcPJSkhA2OVQOmT3aXvQSkIFhdOPg8cXxE9wVTk8/MgQh+3n/I7osai3BuB3h9chEoqmc6rSeo1vMlz4m7KvWAhm
 z7fsdGkj
 DsYdvh623JtV6i6JmBS+tebgZG/R2fb0UQYu0pkh9keryRRjwdR6AcfTbuBfCA0Ndb5dMArxL7UGB904twJXKo89Lkps0rANtG+7uvEI45DNrLmY48gMq3ak234/xHk4XcKngEkdmjdgL0rjPJtgwdJB4x3Fn2OTIiyXSwufk0a41bBS8hgQho4tLgNQyzeslu9Q+Mczdsc79Z6wa5eXQH9+ncqFoUBJJZtWJPuUGpUlYmzKAzWhPbgiUf6OBwHjtWyvq9nEz3zTUtnTfVSww4CLWRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 21:04:30 +0800 Lu Baolu <baolu.lu@linux.intel.com> wrote:

> This proposes a fix for a security vulnerability related to IOMMU Shared
> Virtual Addressing (SVA). In an SVA context, an IOMMU can cache kernel
> page table entries. When a kernel page table page is freed and
> reallocated for another purpose, the IOMMU might still hold stale,
> incorrect entries. This can be exploited to cause a use-after-free or
> write-after-free condition, potentially leading to privilege escalation
> or data corruption.

Is only x86 affected?

> This solution introduces a deferred freeing mechanism for kernel page
> table pages, which provides a safe window to notify the IOMMU to
> invalidate its caches before the page is reused.

Thanks for working on this.

Can we expect any performance impact from this?  Have any measurements
been performed?

Only [7/7] has a cc:stable, even though that patch is not at all
backportable.  Please give some thought and suggestions regarding
whether you think we should backport this into earlier kernels.

If "yes" then the size and scope of the series looks problematic.  Is
it possible to put together something simple and expedient just to plug
the hole in older kernels?

>  arch/x86/Kconfig              |  1 +
>  mm/Kconfig                    |  3 ++
>  include/asm-generic/pgalloc.h | 18 +++++++++
>  include/linux/iommu.h         |  4 ++
>  include/linux/mm.h            | 71 ++++++++++++++++++++++++++++++++---
>  arch/x86/mm/init_64.c         |  2 +-
>  arch/x86/mm/pat/set_memory.c  |  2 +-
>  arch/x86/mm/pgtable.c         | 12 +++---
>  drivers/iommu/iommu-sva.c     | 29 +++++++++++++-
>  mm/pgtable-generic.c          | 39 +++++++++++++++++++
>  10 files changed, 167 insertions(+), 14 deletions(-)

It isn't obvious which tree should carry this.  Were you thinking the
x86 tree?

