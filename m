Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B1CC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71B26B0190; Tue, 18 Aug 2026 10:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A216D6B019D; Tue, 18 Aug 2026 10:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913766B019E; Tue, 18 Aug 2026 10:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDF46B019D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:16:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02B45A0281
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:16:22 +0000 (UTC)
X-FDA: 85114590246.18.87E1E91
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 55557140013
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:16:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EhPcYTo2;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwu9jgSx99aJy+siRwvjcYh450OUVDvHmhpw14uHA7s=;
	b=ucZiRf3WdQxClGl1kaXU+yIXGAvOtS558Mr0VITmY0g+TRubSvflBR2zaHOOiR1w4epNQX
	Owhei5Pqgt/JvBe5qs3jy9gCPdvQmpQxREGEckjcI99lM3YUOpm5D06D6o0wgGFq+EfEzs
	Bc6UPqMYwdoNi1RPYg7FMPXylDtRvyU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062581;
	b=myLlt489YOuHP1MdmPUPxAzSO4BXPYB1VFc9nTspV0u/M5RKj9Z9G6HY63e//5WFyEE0Gz
	FX3vePrheqAAGLf7QpwKfa2og9fquLq/1tbhrAH2M8eDnoST/S9UatFxQWctmIRjPUdN/X
	vUFwauxSTUtxb1WEOVavfHxOBxCUg78=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EhPcYTo2;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEEEF1516;
	Tue, 18 Aug 2026 07:16:16 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 872973F85F;
	Tue, 18 Aug 2026 07:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062580; bh=n2wKaJ7B0u+TOzRiWJjt2/jNzta6bxVIi/vLveRb+xM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EhPcYTo21sYUZH9+m6BG3jc3jRms3MDajrKqMQo3+J/Br/TT7Bx5wZisHVwYpinRs
	 vNmVPG9EUiMlKE4qll0V0DRk3wH2LxO3ltS9xRWlXNM6ILTsIElFg6wNQGUWdjxH6M
	 kKgzNHLQgUyEWcTSuxQrpZEPjKeGAT6HYZ7x/QZs=
Date: Tue, 18 Aug 2026 15:16:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Houghton <jthoughton@google.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Linu Cherian <linu.cherian@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>,
	Frank van der Linden <fvdl@google.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/18] arm64: Support hugetlb vmemmap optimization
Message-ID: <aoRpJxCMTQ-RvTKX@arm.com>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-11-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708031129.3503195-11-jthoughton@google.com>
X-Rspam-User: 
X-Stat-Signature: no9gr16pbe4iduznx1spyy9tpxp9z53u
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 55557140013
X-HE-Tag: 1787062581-313044
X-HE-Meta: U2FsdGVkX19bflFcl9rxvig4cXBpMBsZacF79+NwMZbsSe3vCcV3aE9jhR2OPWQ4oFnfIpUBSlH2AiM2hkwReg0IoXR7hDKPMM6jlPtaSPPD7iMBAdC07TXuS59tpOb6U6E8354NQWMpyK86nJOJPhmTX/cBd5qnmp39GYD6JKjzApLkV8q3jeA+vTLqkSW7viwXiVpfStNdoj7VkCEr98lVVJA02x3ijOCYKerU1h5fV1NYKXYR3B4VjPkg03MVLUR3kOH5QzWDOmKv2tbl/50Hhiq1By4agVi+Z7jrCYXAYPPh+hCjHYWtSqcBZUBcZ6LA8IKv6ZCYvh6Lb7L3GTdTnlFR3vH9Roea1JptFKoukLAoyCeVd/PGiYFrkpbN5EkhYVkrGsifpwPfF6T+VEW412SVelrUHYlPDobY6A3QcfTsMdYptmIt4e0KR5le2cz+FDWK73q4B0eUbbMFzs3gRCRXJ9WN3BTS9eUK2ZfNcp1rQC8clrbRd998WChPznHjnml2rAXE2OeWrHdbzXVBZhv8jqGvWPsWNq68Xp7qClEHEXci+RBHR8lRsjfT9RDbi8FWt26fros++8SAAOPK9eB8C/KH+Njyg4YcZp3wgGjrqA4u2exUmSZAT2OCd+MDgy/Wr2Mmkb0xdwpRnXLod9++UfPcnIu2tXv2WiFMdnEluaqULqig+oCS5Dk6SFbBeejbilGMizPDctHQRuuVEok4mh0EbdSwecIJWyXOMLK9kF4uT9TxriGRwCKahvrON9I92q6b0GZYmnYNvh2ZB/P/LFc3q3cGeN7BMVcsddw9whmPgaMoajYZ3t/e02D07+swXQtN+yIzj5yVTb0CCzDoTsrgw8kHrPtXbnFMIgD1Declwtrf+FCs5px0cYyt/UdkRZ0qs/Y9hYwjDsu2n4K13qcbjCGV2vWh8WTE5rnD23ihPqQAbuZO6VC7C4AIEmaSTh/NBeWyARn
 4vr7pIvI
 Ho9dQUHFDM3IdYBEfXYkPp6g9SHl3AGwxaQ1E2DPUzMBllkwLEYa2zK6YFKAlJNbUurf6mya/oazNcuxtrxGsTf5MgR9BUmIPgM3fAGThGcfciwSYe5iB48Il0BjAAWjn9XM7PSE8QdJNlWJRow7GzVfMitCv/ir4UXYsUClAgrs48WqwswTu3CqKilHEMwIRiVGiz8SLH3dEo8MCeey6fFGypBIr3FWzjMyGfR4jL/kA/XE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 03:11:20AM +0000, James Houghton wrote:
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b3afe0688919..cf4bd6bd7f11 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -259,6 +259,7 @@ config ARM64
>  	select USER_STACKTRACE_SUPPORT
>  	select VDSO_GETRANDOM
>  	select VMAP_STACK
> +	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_WANT_OPTIMIZE_HUGETLB_VMEMMAP

Nit: we try to keep this list alphabetically ordered.

>  	help
>  	  ARM 64-bit (AArch64) Linux support.
>  
> @@ -1607,6 +1608,17 @@ config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_VMEMMAP_ENABLE
>  
> +config ARM64_WANT_OPTIMIZE_HUGETLB_VMEMMAP
> +	bool "Enable support for HugeTLB Vmemmap Optimization (HVO)"
> +	default n

Nit: 'n' is the default already.

> +	depends on HUGETLB_PAGE && SPARSEMEM_VMEMMAP && ARM64_HW_AFDBM
> +	help
> +	  Enable support for HVO. When enabled, late-onlining of CPUs that do

I'd drop 'of', not sure how it reads better. Maybe just 'late CPUs ...
will not be onlined'.

> +	  not support features required by HVO will not be onlined if all boot
> +	  CPUs do have such support.
> +
> +	  If unsure, say N
> +
>  config HW_PERF_EVENTS
>  	def_bool y
>  	depends on ARM_PMU

-- 
Catalin

