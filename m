Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7BE7CD5BAD
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 10:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BFBC8E000A; Thu, 13 Nov 2025 05:05:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296EE8E0003; Thu, 13 Nov 2025 05:05:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3CB8E000A; Thu, 13 Nov 2025 05:05:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1BA8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:05:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8477FC08FE
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:05:29 +0000 (UTC)
X-FDA: 84105151578.16.1B62A6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C0146100004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:05:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KB4GxgXq;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763028327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cE9pu+snDC6uoaFKstoqWLBqx57bHPFMH55lxIL6myY=;
	b=NY5XCJotAfLVQONXzmdZtOYHXC3JNKu5sRakNzgpV+6chAXR9CpG5onOvENoYaWVYechWN
	B9UN+9BIT//Wv7pwci7M+L6QN/deiF0Rb8Ep+WSM9GNm75hqCxZwtetk53i490LKljuRbD
	lAyXn5oIN87WlHvrlp3zBwr+rkVxjDw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KB4GxgXq;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763028327; a=rsa-sha256;
	cv=none;
	b=G+HEcyV61qgNVo1iUbJm8bgxNZgYQ5ML+gvIQhyT9h3UPgvQEIT/vidMIoRmmTwV9ovGZX
	mFSKPMoNjJQZdDpL9H+EB5dWdhikPj9//PI3aoJkuOPk9Ifk+LDvscrMsGgTfe4VebrqLE
	AG/8PKlt6N+KyEloNIieDzNljNkVk2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 948B744457;
	Thu, 13 Nov 2025 10:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C075AC4CEF1;
	Thu, 13 Nov 2025 10:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763028326;
	bh=BLTb5heskjXzTldos1Pbf98tCoJwck1drSSFzaVhr3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KB4GxgXqJZ7cO7XBy6/guf626zim6beEsg/YfQpCnDOK4CIsFLP+coyBB5LQx6Ybb
	 I7s2JOUvrf+DC7c4xVdeR/uJQIhZpbiDJGmjcLEhP+OEhRO1+tbsNZG6fuOByhSJgv
	 hrWjyJWa5kG9pfQAPvUoU/pHuUUk5rTrKamkIEBUA+G0CgjhCtK37Erfyu+rqbuvOS
	 1dlhMdtne37nyvq7Z/8tU5sJt3/Nqm6oEBR+LDczDAuItX4mBgczhd8bAdZ7MliWdx
	 jGvHbgZSquL92vYPhyoBVwk+3NUER/r21+FimVga8kmJjEWv6mD2TE90Sd0NpsNNX1
	 bpUdQLOkX6ukA==
Date: Thu, 13 Nov 2025 10:05:19 +0000
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
Message-ID: <aRWtX3n2I7El4Ykv@willie-the-truck>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-2-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106163953.1971067-2-smostafa@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C0146100004
X-Stat-Signature: k53qqs6oc3bzq3fbed3ekirreafugdsz
X-Rspam-User: 
X-HE-Tag: 1763028327-508728
X-HE-Meta: U2FsdGVkX1+JJdfLGroQcDylU7bzaPCnMa6JL7bEZG9F7vBJHFL8KyqPR7FMyAIpcfaj/TI5gQ1dEMN7VR7MM4dl2bw2t6Mz/6ouRu+gLGF63u8UMOw14mkcBGi+GpTtUIZxf2Cs3KO5vUWDDP/kCRX1v47eCset/oGCokfWFItUv0LfTFIQuyf729XgGxxw2xxs3SemJQ4k2YcTRGlvW/F2f+ikJsrjtDciackaan6ANRb0yl4v2Q0q11CDJcpWIWNGbuAj5bIrvYcs8B/L/neZcJo3UBBYpa2UYBR9QgxvIhhUncXyt6T+ZFdUpjwbMVqOQQKt50xlqNsLc07WUaULFbWG/dlkTx9/jBTBMthypvJHFS9Ca9eveFuYtLzHYqHtuW/ws84ob3MGK9TTtZs3NU5DaZ5T+0JNXQ5/CGx6AjlSNxLyV0CtvGFBU0LP7XX5n+cKjbUGqXmaIrD/42KI2a026H1tV6NOxwHNwnmeAjYZmPeUGYWf+2uB5mgGVM2Db4F0d3xSoPNhQrqiTWIb4k4tdaMAvscAYd1lNMUICTaOJ+awrJ4RhTy6YYwGkI2LtX44JFHyfPlvKPvqOxLAe4sgVobb0LccNDf7718kq6o91K+MD3eniOnAXnoC34IxiQjks5ngzqWrvzP+BlJd8HILy5uj5GfEzkqcZMeIU9risyOx392qiGKsNPLSuul2mo2dhHSgkGMQU6O9/ITRIj1XsVzui1tWvzMvLzHR4YOZSMhdkVmUTTTLnIVmZQf69hNskS2uxNZ6AGz9zXmjQx1jNR/huEACZk/Uc89FkLSirPzHpdC4bnN32ZDTLUWBgVBXSIq+63eiMWGG+1KCO+buMRpZxpWdk6HLuK+WcAtoe/9YPo8uBPFfEsY3KQwPqh0yWztuUAMdKLurCVtSdsQai3bF8PPwuATMs2O2MWQ4UcIhex69JBFXgn7ozNEJbaAWLE5oD4YohaK
 3AJfNN0k
 A2tVyCgldqr2tljUQw6rusEr82ETHip7jfmhchQhLO/GuYm3z3od2jsMpQ9HnZAS9Q+gQz/q6TX9ZYW7L8A0kCLEYm04yc/lzgXoMgBPBo0zlJGTY80etjJyt82h+K6b43Z1qW00yUa5MhelEgP6+N3hEbvrUXcp1aRbTqU/wEuPM6WKvpr11LZLODEzmEh794qdh7T10wCSStWJ5LF+o0zrrI5dqkRT2Ixl5CGUx2H/cAAI1XwTtfLUR7H5TN2VO53yZucuKph0CYX5cW+e9f0JocIOfTv2KGdVt9se0d2OYDHFfIi2VdbewK2M3wsi5do9kLo5mWd3hlCakciV5WTcnapu0TDtuZmU2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mostafa,

On Thu, Nov 06, 2025 at 04:39:50PM +0000, Mostafa Saleh wrote:
> Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> page_ext.
> This config will be used by the IOMMU API to track pages mapped in
> the IOMMU to catch drivers trying to free kernel memory that they
> still map in their domains, causing all types of memory corruption.
> This behaviour is disabled by default and can be enabled using
> kernel cmdline iommu.debug_pagealloc.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  6 ++++
>  drivers/iommu/Kconfig                         | 15 +++++++++
>  drivers/iommu/Makefile                        |  1 +
>  drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
>  include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
>  mm/page_ext.c                                 |  4 +++
>  6 files changed, 75 insertions(+)
>  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
>  create mode 100644 include/linux/iommu-debug-pagealloc.h

This looks like a pretty handy feature to me, but I have some nits below.

> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6c42061ca20e..9a1c4ac8ba96 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2557,6 +2557,12 @@
>  			1 - Bypass the IOMMU for DMA.
>  			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
>  
> +	iommu.debug_pagealloc=
> +			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
> +			parameter enables the feature at boot time. By default, it
> +			is disabled and the system will work mostly the same as a
> +			kernel built without CONFIG_IOMMU_DEBUG_PAGEALLOC.

Can you be more specific about "mostly the same"?

> +
>  	io7=		[HW] IO7 for Marvel-based Alpha systems
>  			See comment before marvel_specify_io7 in
>  			arch/alpha/kernel/core_marvel.c.
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 70d29b14d851..6b5e9a2d936a 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -383,4 +383,19 @@ config SPRD_IOMMU
>  
>  	  Say Y here if you want to use the multimedia devices listed above.
>  
> +config IOMMU_DEBUG_PAGEALLOC
> +	bool "Debug page memory allocations against IOMMU"

Perhaps "IOMMU mappings" would make this a little clearer?

> +	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
> +	help
> +	  This config checks that a page is freed(unmapped) or mapped by the
> +	  kernel is not mapped in any IOMMU domain.

I can't really parse this sentence :/

> It can help with debugging
> +	  use-after-free or out-of-bound maps from drivers doing DMA through
> +	  the IOMMU API.
> +	  This santaizer can have false-negative cases where some problems
> +	  won't be detected.

Maybe just say "The sanitizer is best-effort and can fail to detect problems
in the case that ...".

> +	  Expect overhead when enabling this and enabling the kernel command
> +	  line iommu.debug_pagealloc.

I'd reword this to say something like "Due to the overhead of the sanitiser,
iommu.debug_pagealloc must also be passed on the kernel command-line to
enable this feature".

> +
> +	  If unsure, say N here.
> +
>  endif # IOMMU_SUPPORT
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 355294fa9033..8f5130b6a671 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -34,3 +34,4 @@ obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o
>  obj-$(CONFIG_IOMMU_IOPF) += io-pgfault.o
>  obj-$(CONFIG_SPRD_IOMMU) += sprd-iommu.o
>  obj-$(CONFIG_APPLE_DART) += apple-dart.o
> +obj-$(CONFIG_IOMMU_DEBUG_PAGEALLOC) += iommu-debug-pagealloc.o
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> new file mode 100644
> index 000000000000..385c8bfae02b
> --- /dev/null
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -0,0 +1,32 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2025 - Google Inc
> + * Author: Mostafa Saleh <smostafa@google.com>
> + * IOMMU API debug page alloc sanitizer
> + */
> +#include <linux/atomic.h>
> +#include <linux/iommu-debug-pagealloc.h>
> +#include <linux/kernel.h>
> +#include <linux/page_ext.h>
> +
> +static bool needed;
> +
> +struct iommu_debug_metadate {
> +	atomic_t ref;
> +};

s/metadate/metadata/

Will

