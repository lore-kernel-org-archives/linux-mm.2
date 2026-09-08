Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F494C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB5A6B00A2; Tue,  8 Sep 2026 05:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37AD56B00A3; Tue,  8 Sep 2026 05:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245CC6B00A4; Tue,  8 Sep 2026 05:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3A7C6B00A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:59:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75D1D404ED
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:59:32 +0000 (UTC)
X-FDA: 85190147784.01.CC4C041
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 660E220004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:59:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YR0UOmZK;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861570;
	b=VncV9FPGbvISs+Kk/2QllzU574sVGi9FhxnM1LSs9UFU0azPQhtXipD8++/GYLqXG8IaLd
	Cc4jPUgi9798FPE/IPi6TYgu6ef2TALXfsXDXU+tR2TxjJLB11kOUnHInYHpUulOy/QBJ6
	zHLyNCqA1g3d8JQG2ccJAgkhKQs5K/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHEe090zxcvX/G2IQLHQp9iXm/EoC7Qx7nHJQJ/rGtQ=;
	b=Dd87u6wQRQaH1bKv9K26XFakpuDWn/FB/qx5uOo+MRDD65jYNIpjpxZeSoANsEYugIVdNq
	d1NsOO99QpeIYFlrmo1UyZYALjbagSu17ef/HTUod3wRbGT/Q0Z0IU51wSicyyoovHPLFk
	HmVbR4MuJlslEZ/5baw/rCE0ZIZdyBg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YR0UOmZK;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E6391476;
	Tue,  8 Sep 2026 02:59:25 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CBC43F7B4;
	Tue,  8 Sep 2026 02:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788861569; bh=a/a9VuH1Pbu7fuqb4EF439JhWu4OMvquSWkjlVGi4tM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YR0UOmZKFbfAJ3SQSDswiFS+rXAWEo6USejgl07yJMtcUVzwUvoX92dfUQwwVpdX5
	 EaS2HlcY5AR9bV7tQg2bFaeizuNwDp69wiztfvHe7QfBZ8M2HAbZx4+U2VfjisKvus
	 ye1W5JquN+zfg/oiJuWT9J+cxec8MSXZ7ZVkbbDw=
Message-ID: <88b48587-1f3e-479b-ae9b-67aa643e2acb@arm.com>
Date: Tue, 8 Sep 2026 15:29:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-4-949b64a9f755@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-4-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 660E220004
X-Stat-Signature: o3xpnoibk7gxhjwcia3t8hqpmhyn7zhb
X-HE-Tag: 1788861570-617018
X-HE-Meta: U2FsdGVkX1/YFMSs5xgty8B5AlbWss2TFwIY6G5dgUI3c+xrm8uvQl574Q0hsTbu6nnqLwj79yrM0mBdSpssmHS/VKLGNKs7o6H6/qpthHriQPa1fp/zEZDSFP9fk5JwuTxhXia5M+R6EkgEB4Cdypt6YP5gpBRjaH3HNZ1+roPqZQ76nMP/cz0FF8AF1azJxVZfTSt9Afpo4JoIPt6s51Am05zJr2aZ/ehl6yun8M+/F74zLWki9vEDDc8iEUjywBN9i5IxPb1zmM9fJ2Flt+P/c0svzrY4FM9cShbDS/yUZrCkXGVZVPRBWIOISkTm9CIWmwLwb+ikxEwy8QmAPphDl7blDpRCuuhWRbKA+Yi7fvkX26lAo9bV5zUOL/QdI2IcBIFXPPdR8i8trJEeuYBzRvWrmonc2U2R3D+Rv0TMfGqGchPw3XC9RpROc0i5K8ZakjOcNtUojJsh9Z1C1qDdOCV14eIqJSl3/2KwZJOQSoR3jWvJGdwCKpJgK7WQbvaJcsAq9oMbiYWy5P6CDQevuh98O1nxqI4tsB8twtY18OH4u9lSEuYfMhgCHnLJJXgzSdM+n7AmWLrqgONaCaZo7Q9yZ0jykiFqZGG+rkNF17l2ZJ6D7IXvtIjwuclayLizVXe6kKxtShCf51BMBcp7VkKRI25qSX1vDSeiQx604lL3s5BNaiJf4Xd6ppgjVGuhlGVkyn72o3ywbnZDO5pmqNnQMDmiKpUDPtLLSFsTf53nw5aTVR2XVmMaao5BiAc7ilcqh43GFVKbc/AHSautAZi076KExgCrzXH0BY7nVs4QLrJWvztxf3a0uIQ5FU3yS/kyOidt61fCxcgqr9zgHFkQ8kmtZpxqpih6AgtpxBARmQnz7q5sUPIodKNnGxH2pUkqi3qbXJQoyr7tDLJBFOP67cO96if+r8njT9EVlW9yelTWZx9DmCy7M42bn6oG8AzvX+firqKAVSZ
 nwyvCdfs
 THvgDdfLz7UHAJDleXY91fFyBizNPa33LJolQwIgsE8RYCDS0jAK3Weuiihoh05AT44run5oBK+7Ll8GMBeNrUb29cwrtWPpK3/pkX29XQmTeERMSGA+2qxaZNcK1Z2y0xOl33N1BzUpQI33RN98QY4m7eyK6IBv/aPwLe4z7Q1jNnb6AXaTB8tPBvepzV1qaK41L4xPiykJFZ72IBYsGG4UzuEqbWYaxfqx18YyFwa7QWPzM22kQkRVHAlIlL539krrbp0nBJry32Fhpgoi73lfXThrxWQxqiZT5n3LgHhPWPaLuJjqwBWNeQDGVsmAKwLsHEFPH7jkLWUeYI5u4lp4glr7zi8UCuChQwAAFecZD3yY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/09/26 2:58 pm, Mike Rapoport (Microsoft) wrote:
> set_area_direct_map() always updates direct map alias permissions in
> single page increments.
> 
> For HUGE_VMAP areas it's suboptimal. Not only the loop in
> set_area_direct_map() needlessly has more iterations (e.g times 512 on
> x86), but it also causes fragmentation of the direct map that could be
> avoided for the HUGE_VMAP areas populated with large pages.

Correct, this would also help us on arm64 once we have ROX caches.


> 
> All pages in an area are always of the same order: either same-order
> large pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were
> successfully allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is
> cleared or when huge pages allocation fails and fallback path is taken.
> 
> Instead of updating the direct map permissions for every order-0 page in
> an area, use the area's page_order as the loop increment and update the
> large pages in one call to set_direct_map_{invalid,default}_noflush().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

LGTM:

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/vmalloc.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5506b180f5c27..6ed6c160abed7 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3367,12 +3367,15 @@ static inline void set_area_direct_map(const struct vm_struct *area,
>  				       int (*set_direct_map)(struct page *page,
>  							     unsigned int nr))
>  {
> -	unsigned long i;
> +	unsigned int nr = (1U << vm_area_page_order(area));
> +
> +	for (unsigned long i = 0; i < area->nr_pages; i += nr) {
> +		if (page_address(area->pages[i])) {
> +			int err = set_direct_map(area->pages[i], nr);
>  
> -	/* HUGE_VMALLOC passes small pages to set_direct_map */
> -	for (i = 0; i < area->nr_pages; i++)
> -		if (page_address(area->pages[i]))
> -			set_direct_map(area->pages[i], 1);
> +			WARN_ON_ONCE(err);
> +		}
> +	}
>  }
>  
>  /*
> 


