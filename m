Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE89DC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3AE56B0092; Thu, 10 Sep 2026 10:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4256B0095; Thu, 10 Sep 2026 10:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE5D6B0096; Thu, 10 Sep 2026 10:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0876B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:48:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E090FA039B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:48:05 +0000 (UTC)
X-FDA: 85198132530.29.C1DAB2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C602180016
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:48:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZS2dzQ+N;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789051684;
	b=UiiOGqE5TU5oxfi58zE8DO9B9TTJHsl950HPLBfI8WLZraZ42drn9ZfR69Sq3Di8TBiqjU
	OzmcameQJ+b1+QkfCVoys/QCVW+7TgiqzBb6G5KTUHfOazY0m6zFsfq8gk27ODWaRaDp2v
	EloxwPgRuhR5QyU/yEBFTzqTpRNZZ90=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZS2dzQ+N;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789051684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8LvULR1C7zHsgbEpOUrhn3DOAKTICCIgCcp9Moo1AI=;
	b=oRqh1QbPynIAPKL17MCmX8xB5FjjddJhYnFX9KonChcgnSyaSiZFmljTHIDro299SI4I7L
	YYlSB8j0ZhwNz/lUMKeUokmzoXY8rhALEra7ZnYXKojl0jd4cdmVII1HxHu3hBWRJgrisp
	PJ19+sNN+BeJZCcpnshfBdCVMEF4mAs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48613438A7;
	Thu, 10 Sep 2026 14:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601061F000FF;
	Thu, 10 Sep 2026 14:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789051683;
	bh=B8LvULR1C7zHsgbEpOUrhn3DOAKTICCIgCcp9Moo1AI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZS2dzQ+Np0U4OAn0VVXIzCeZ5ieBiFxzuXO32HXGZjox2imU5YQqAvF8SDv3+HvpB
	 NxKzJ7t53F+QsLxd/CAKfh/ceBGbni9Duv70Wf65QpPhB0zouKNuCKjxwxHBz7Ulrb
	 YX/D12ZD9xp4XqsIIVhy+Pz4Q98Vhg7jVxbdMioUiDrhm08tGlgTlHSNBC5ULoSm7P
	 RjDqnY3JtId+Xe4grDputbR5RuXHVt8PwdzEvcy+eynCsYB2Ookav39t3u54y4bkvh
	 iX1Yd4WaL2lpHCK6hln10VYqPdfl55bipsdfB0oRiHwHmEfLJXIjbCAbdjH9fkO7ly
	 YP/fvHYNEODkg==
Date: Thu, 10 Sep 2026 15:47:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/memory_hotplug: drop CONFIG_HAVE_ARCH_PFN_VALID
 handling from pfn_to_online_page()
Message-ID: <aqLB0Fe_bCRSph9E@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-12-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-12-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C602180016
X-Stat-Signature: 5kgjh5ezi8hf9prmp9ne4mq1s5nmaz54
X-Rspam-User: 
X-HE-Tag: 1789051684-539500
X-HE-Meta: U2FsdGVkX19YGgUapqwMPQaMO9+saICT0RasG8rX1z8jDE5THv1UqN3izonJ7mxWh64of93AemJSPiBJt8dRuWp9FEY7wmh7kSnWbq7WPOocNe72nY/9AEUuNO2tNSd5kpeJ4KHVzXqHdWejH6dmEvhSZTZCLnnzqpdpT4hUFKMNSuRHrblWz9R/aVzEklrgd3pycqc8kpOwoKBcllrDJQtfZeU0k77QMnbQetdwDYepWBQ5hXwyVaYkys7C2SyLiMB4VGBlKAKhQzxobrzDTCZCMec0ZzcQkCBdehck2Gw5Mk5YvpobFvVNWQ5m6mwnSdQxhmTdtUV+PVmkR26kZEtplbPp/IwTt/RegkapA8ggKlryRJyj9MzAkilgdLQgnvqII6zX5hPzvb5an1TEjVC2zZuMAfKiF/kq84Hk4H80K40LTtGSta1f79YfP3OjNMcLZxvzU7F0oB2WEXKbqQT6DkJ5pA4QJ8cO7SgOXlSi3m+dCL3aol9+PSgpOIch1nXVQgAzk9VVyarvgOpfctHfcFiTij3mCg8jAwluH7WhafVovdGZEZfznqnlyRurXwLmWmkx8abrloPi/XzdeuaLfs93LWWHwUs5M7TM8iA6EdB4m+IYw3631d0Gix7Xbt7ZylYaHB0j8IlAS9VYIjaSNs8k5/ehx7Rj48aUMFKGUyQAl+c1mntRGO8dMOugqXKynacUKzEiCX0/Rqck8xSuwxJtF3WBXC5YFbWZpR7SiAypY0MP9yX+ufXP+pgZezO0+OTiB2EY/C7oKOLTwq6sJcPC/tYjAzEk9bPAZ3mJ3fQ4/HD6nVUkpIqY77kp6sL089uHDXOIuVl3zSBkAJaykh1o8VyRwKuz+D0cfEo+ttZa8bpnVkWFyI9pMFdI1mRNpuAiC0A072qYBmQRim3Ww2s2pK220FSNrbkQ5x8JqG2r+A79lxt+Fk+4yFznN/alyc5+8fn5rblnQYB
 hjfcv0et
 YPxJe34cDSvxUDobgGNR5ohyEGZ0wEXn0dVH5t+fThmwfumQ+0NTVTHsH5SYynx5V6B1QPa/VFhM7NFYXIPEujuTSryOsvUCXYYJbylS8kL+2kY148SERgaR+0V1AyJBzXJudiGoWz4WBIq6uUCYmWToJ+khErm8BGeU7MpXEufJhSwyezl5X+midtOW5OIqNA7yi1vf/dN3FVrdj0pQawv2KP218kRF7kKArJvAmKkh7ti5gfTfX4n25D+zL94eekSVUJuNy1sfTq7VBlIynHxM7ibVeVAH8CEw4yO5NkgZgL8a4G1vEJ/bTmTrjIyOox75ED2AstMK7DRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:05PM +0200, David Hildenbrand (Arm) wrote:
> Drop CONFIG_HAVE_ARCH_PFN_VALID handling, as CONFIG_HAVE_ARCH_PFN_VALID
> is never used with CONFIG_MEMORY_HOTPLUG, as the latter depends on
> CONFIG_SPARSEMEM_VMEMMAP. Make sure it stays that way.

So argument is:

mm/Makefile:

memory-hotplug-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o

Is memory_hotplug.c even compiled at all?

mm/Kconfig:

menuconfig MEMORY_HOTPLUG
	bool "Memory hotplug"
	select MEMORY_ISOLATION
	depends on SPARSEMEM_VMEMMAP
	depends on ARCH_ENABLE_MEMORY_HOTPLUG
	depends on 64BIT
	select NUMA_KEEP_MEMINFO if NUMA

$ cd arch
$ rg HAVE_ARCH_PFN_VALID
Kconfig
1762:config HAVE_ARCH_PFN_VALID

arm/Kconfig
94:	select HAVE_ARCH_PFN_VALID

arm/mm/init.c
121:#ifdef CONFIG_HAVE_ARCH_PFN_VALID

arm/include/asm/page.h
178:#ifdef CONFIG_HAVE_ARCH_PFN_VALID

m68k/Kconfig.cpu
23:	select HAVE_ARCH_PFN_VALID
40:	select HAVE_ARCH_PFN_VALID

arc/Kconfig
463:	select HAVE_ARCH_PFN_VALID

All of arm, m68k and arc are 32-bit arches so by definition MEMORY_HOTPLUG
can't be selected.

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

So LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory_hotplug.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index b428da66d279c..58ce35cb48f57 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -344,6 +344,8 @@ struct page *pfn_to_online_page(unsigned long pfn)
>  	struct dev_pagemap *pgmap;
>  	struct mem_section *ms;
>
> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID));

Haha nicest way of removing some later code I've seen. Just make it not compile
if such a thing happens :)

> +
>  	if (nr >= NR_MEM_SECTIONS)
>  		return NULL;
>
> @@ -351,13 +353,6 @@ struct page *pfn_to_online_page(unsigned long pfn)
>  	if (!online_section(ms))
>  		return NULL;
>
> -	/*
> -	 * Save some code text when online_section() +
> -	 * pfn_section_valid() are sufficient.
> -	 */
> -	if (IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) && !pfn_valid(pfn))
> -		return NULL;
> -
>  	if (!pfn_section_valid(ms, pfn))
>  		return NULL;
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

