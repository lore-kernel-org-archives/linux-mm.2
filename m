Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC70CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1147F8E0130; Thu, 18 Sep 2025 10:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5438E00F6; Thu, 18 Sep 2025 10:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5BD8E0130; Thu, 18 Sep 2025 10:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5C238E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:58:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 925E4118EC8
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:58:01 +0000 (UTC)
X-FDA: 83902675962.07.FD6ABCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 03B9A8000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:57:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3UZcSMD;
	spf=pass (imf02.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758207480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXWxdVsz8OIqRG69WHkwh2MIuKL0/P8rJq4IPOyC4VY=;
	b=oxJaMb9oeMxGQISbAMXKQE1WdNTvQPQkpWHhUaW+vydVXWPfa16MAlOvfv4rce02U6BJx3
	LPhf2EtNve63nm75fIsQvzejoJE0pZIFzoZt5bLnwh9TiyZzB9525UQd18w8mXqRu6zQem
	vpCtf9fy3yCwbZB+NQ5JJczsnwRqIWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758207480; a=rsa-sha256;
	cv=none;
	b=3tT2zQt781Pdm1xbWyVeaSZZ6cYP+PHA+RMCjpc3ICETWo/luBspsag1/IR0S68diiMU84
	zXkQ6P9uGA2InIfrReFlB4ZdnkgH+xXz1XdoMvUWLL+MJrjJZKx9RTYXlPig2LBjK/vpu1
	ysfMxR83YycJsLOkSOXcDjoLea46z0A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3UZcSMD;
	spf=pass (imf02.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 09DF0601D5;
	Thu, 18 Sep 2025 14:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2CEC4CEE7;
	Thu, 18 Sep 2025 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758207478;
	bh=9ptbDgx9yP30JQpxvmB423ylAWuRrb/kCJRElL8M6vw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d3UZcSMD22E0ZDun9Js4sfb9Q7YO2pN4OwP/ARhsg4W9XplFc4V5HpaFVNce1vQNg
	 zvyPJzQGxARz6drO1QKZwc0lDuj0oqMgbGFdOY7cUfhFLM8caCYMCpenLKJr/KRxod
	 vkGrg9x5BZ6izYWXrUGrCkzYK2YYcgINJ8O/+1xGyXt32SlWBAtemljm7E0ZpUt7hB
	 tJsuEOOLl+ixsfYK23QR41GUCz/XQFhYTYp3qoYPQbGQBn0k6/CmmF0O1zXatmxs6s
	 Z6+3dPT0BgiwKpPoN+heHxgIJbgLwTBc0V5uqVsmVhKw9wsssQM9skdZRnNZHKdPsZ
	 wdPv0t9HbPuxA==
Date: Thu, 18 Sep 2025 15:57:48 +0100
From: Will Deacon <will@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>, linux-hardening@vger.kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
Message-ID: <aMwd7IJVECEy8mzf@willie-the-truck>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
 <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
 <8f7b3f4e-bf56-4030-952f-962291e53ccc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f7b3f4e-bf56-4030-952f-962291e53ccc@arm.com>
X-Stat-Signature: ekztmcihcgj6brq8ezk4i5pnqj71nyof
X-Rspam-User: 
X-Rspamd-Queue-Id: 03B9A8000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1758207479-958950
X-HE-Meta: U2FsdGVkX1/gViJSv9XyQLk4MbYSe/TAXR0iMV6/B9VtDAgwoxgsGu64txY8hiaGXjcBI1zC3SoVAKptvtz6/g5EO/GWvPRIO8UFs+AuWBvszC+WJ1GHQl6k+DEB7/iY8ACkgJcyR+1bpP8TVYRxgSNMOODT4ZW4nc+ZR4FvTU0QSsR39BWdG0dH61yJF8Oj7aneBfYB1R4dBLUi+f28DJBL2njHNU9iucaTTeAqeapTYYh60HaH5go1M2zh9GLgdxxFLvorB2Lga8lTqkKpvFHQlDh05/FlMC1uMYMFXVu4robbTROZ5JEw7PaFF+yjU+cDN/0Q98JYMfyco8AeCdQGjAb2Y6SbJlS8VGhFVs3znDEI2iwI3qI9AZ4RYIcd6RjAMG7qHydgoPvokjpTJIKDRRtIWiEOKnfj/w1pxbQpWscbaJO7gQyqujHuGNgA+OQGjI2qvkJNcgfD8ZA0fmm4puGSbncI3wJm8xvfvvRSyopi/VqfGCDipLC/K8f/lOU2m4xuQ4cIW4gnbvhUJLl6tFDKgPPnv7eZNiGIY8bOsZn8tAFD6yCqYV58Xo3DGxT7Bmc9RBUSAkoF/W4xsYWkuAkdMghTV4WZy19JhSQzHMdv1tHqu5/MjRsez/AJeUzsnXeReb5vrIhgHBdHrxphaqv3BRaU6nVZ6wxV2mFzmn9pK0BatlcAfenDN9L/mJelG2Skh2iqovxZPyP10trL8X9UEyumnHrsT4DAVZjdiVUue/Q0ZHFmSrWy7SeYO+q0Xn4NLlIIp6XcalWfZ2xRERF+f2jAKSLWQrESLu85rqvTWM0D9lugyksDCaWoKf4c7ASOWapQr0hE5NqM3/YVD4rP+ARx3knz43cbDNaS2n/H8EMke0qBLVW47luAt4M+gTCjN1qOW4LBEy+BpREEA6L+O5Xbc3YHyYlgXKL9aPnijt3LK/gYVDLPxrWxkh2b/8kxNTA+Pb+rcqC
 6E8xpW78
 JVOEGCoJMDgURejgWrq8XpLTZ7qHoqYuBqz2UG5Y1ayytYk/9QlVeTAdoowyqrPwDIZF6YLs6GIIQ65OhoYQTKuGVgVC+GNzS10yWhkSK6rqy8/Ix21MfbVdUMhXE5gar2o5ZCyrP6s5/9GfqtPiobkRlXz0WYqmlmvXNIOjZqWNZGPp+0kOzGw3tt5DSIVRUrZSKXEUV4B0Ahr5uZm++n1w+0VlKUZg3/PYUbHiAQNfAmEptPQVK94/sJeU6xB1Wz/Ti
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 04:15:52PM +0200, Kevin Brodsky wrote:
> On 25/08/2025 09:31, Kevin Brodsky wrote:
> >>> Note: the performance impact of set_memory_pkey() is likely to be
> >>> relatively low on arm64 because the linear mapping uses PTE-level
> >>> descriptors only. This means that set_memory_pkey() simply changes the
> >>> attributes of some PTE descriptors. However, some systems may be able to
> >>> use higher-level descriptors in the future [5], meaning that
> >>> set_memory_pkey() may have to split mappings. Allocating page tables
> >> I'm supposed the page table hardening feature will be opt-in due to
> >> its overhead? If so I think you can just keep kernel linear mapping
> >> using PTE, just like debug page alloc.
> > Indeed, I don't expect it to be turned on by default (in defconfig). If
> > the overhead proves too large when block mappings are used, it seems
> > reasonable to force PTE mappings when kpkeys_hardened_pgtables is enabled.
> 
> I had a closer look at what happens when the linear map uses block
> mappings, rebasing this series on top of [1]. Unfortunately, this is
> worse than I thought: it does not work at all as things stand.
> 
> The main issue is that calling set_memory_pkey() in pagetable_*_ctor()
> can cause the linear map to be split, which requires new PTP(s) to be
> allocated, which means more nested call(s) to set_memory_pkey(). This
> explodes as a non-recursive lock is taken on that path.
> 
> More fundamentally, this cannot work unless we can explicitly allocate
> PTPs from either:
> 1. A pool of PTE-mapped pages
> 2. A pool of memory that is already mapped with the right pkey (at any
> level)
> 
> This is where I have to apologise to Rick for not having studied his
> series more thoroughly, as patch 17 [2] covers this issue very well in
> the commit message.
> 
> It seems fair to say there is no ideal or simple solution, though.
> Rick's patch reserves enough (PTE-mapped) memory for fully splitting the
> linear map, which is relatively simple but not very pleasant. Chatting
> with Ryan Roberts, we figured another approach, improving on solution 1
> mentioned in [2]. It would rely on allocating all PTPs from a special
> pool (without using set_memory_pkey() in pagetable_*_ctor), along those
> lines:
> 
> 1. 2 pages are reserved at all times (with the appropriate pkey)
> 2. Try to allocate a 2M block. If needed, use a reserved page as PMD to
> split a PUD. If successful, set its pkey - the entire block can now be
> used for PTPs. Replenish the reserve from the block if needed.
> 3. If no block is available, make an order-2 allocation (4 pages). If
> needed, use 1-2 reserved pages to split PUD/PMD. Set the pkey of the 4
> pages, take 1-2 pages to replenish the reserve if needed.
> 
> This ensures that we never run out of PTPs for splitting. We may get
> into an OOM situation more easily due to the order-2 requirement, but
> the risk remains low compared to requiring a 2M block. A bigger concern
> is concurrency - do we need a per-CPU cache? Reserving a 2M block per
> CPU could be very much overkill.
> 
> No matter which solution is used, this clearly increases the complexity
> of kpkeys_hardened_pgtables. Mike Rapoport has posted a number of RFCs
> [3][4] that aim at addressing this problem more generally, but no
> consensus seems to have emerged and I'm not sure they would completely
> solve this specific problem either.
> 
> For now, my plan is to stick to solution 3 from [2], i.e. force the
> linear map to be PTE-mapped. This is easily done on arm64 as it is the
> default, and is required for rodata=full, unless [1] is applied and the
> system supports BBML2_NOABORT. See [1] for the potential performance
> improvements we'd be missing out on (~5% ballpark). I'm not quite sure
> what the picture looks like on x86 - it may well be more significant as
> Rick suggested.

Just as a data point, but forcing the linear map down to 4k would likely
prevent us from being able to enable this on Android. We've measured a
considerable (double digit %) increase in CPU power consumption for some
real-life camera workloads when mapping the linear map at 4k granularity
thanks to the additional memory traffic from the PTW.

At some point, KFENCE required 4k granularity for the linear map, but we
fixed it. rodata=full requires 4k granularity, but there are patches to
fix that too. So I think we should avoid making the same mistake from
the start for this series.

Will

