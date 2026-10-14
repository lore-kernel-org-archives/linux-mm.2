Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFDFCC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4BC6B0088; Wed, 14 Oct 2026 04:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E696B008A; Wed, 14 Oct 2026 04:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546616B008C; Wed, 14 Oct 2026 04:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3392D6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:29:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B44461604A0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:29:09 +0000 (UTC)
X-FDA: 85320556818.26.F36D956
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 347B118000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:29:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SOprjAZn;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791966548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLz0WUS0mrx3dTeeDzKSgLGzynaLhzlb5S5tCNSjP/8=;
	b=jNkvGSyqKkv2NLMklcZUZ1SdfMqJUH3fmX/6JPjwJwAZ8/y6m5EKUCjD4Z6FUej8aWdGM+
	Pr5WYVDp6RzcuhLIsrCFmY7TiCArxGGiSzS8xaDtf05SrLfRAKqi0wTvRKMnMNUEWg4G6N
	59myOzm5cOEwPRyuZ1I91/sXR1kvw64=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791966548;
	b=q1gNrPhHbQcyNgc9H01fNH0BYkweJ8C8JGJEvydXyaC4hBpiVO5pM79h5wyaIf0PaxmIZ9
	cNhfiDSzPIULMgXa12D0tB4ehlTRsjEc5MSRgC0p0nkj8fCDV2cnudCgXJNOCdx5vSjTX4
	59J+8mCjyjGaLfvrGkN365XsRHKOyK4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SOprjAZn;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADB0C1595;
	Wed, 14 Oct 2026 01:29:02 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DCA23F7B4;
	Wed, 14 Oct 2026 01:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791966546; bh=uqP6rvffea+dKh44Kw66QNsZgkM+k15AAqbFFCdBQzc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SOprjAZnLFxQFUNswPjzKV3NyMvAa+cqELDDxOZy/T2dOvzLPhV8MisYlsgcPMyj0
	 QXcwMypubhur4Jr+wLDVasbysZkUEWzY4V2UTmjifL3aIeOBnZTwPI0O/w+IYUUpV3
	 4bepahBapz844zPgcczmYHn0Xjy/RiE8Co1chppI=
Message-ID: <51e80f6f-debe-401d-9e9f-140d31d94033@arm.com>
Date: Wed, 14 Oct 2026 13:58:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/10] arm64/vmalloc: allow
 arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 baohua@kernel.org, chleroy@kernel.org, david@kernel.org,
 jiangwen6@xiaomi.com, leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
 ryan.roberts@arm.com
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-6-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261002090947.869220-6-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 347B118000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: dhizrtnihx3yawjtg56wr5jker3hdzrk
X-HE-Tag: 1791966547-813576
X-HE-Meta: U2FsdGVkX1/lHxMjjTZfRMwUAm5y8rdeiQMIFmU7+XpSCEiLUQWLqWreptuAP45PNrGzQebQ2I1JMP87LrHq7bI0xRvrsohHB0BCGZdnFrPvO3hxZewWlNGsH2vY2DfjMCC9rZSvFjAuOJQphcPQO+oKFg/Prk/rnh/xhpFtkqa3u/iprhG0gmO/EA6P4ukO3BnMeLHij7h9m80BuvQwQueWwvbu6FBfbKwbR0hgiGKL799j1Whnc+nC39f78tnEt9wYi92MqmpAAipJ2Bn3kgVnBGLa8TnzEsNiRqK4du3hWKRM9yjHwf2BOOdd2x6PUC4rTDWdXyz2SWfHPPBHEzLBz82WMKzTY/HQGji8WfPv1j7JhEop2N/Yy61SnkL3MKZuK0s3SMbYGdjKra7jPkf1X0NwiY1RaEYUcc1u/VvVrLlZrvRF68JG9WSum9dlGCljd0pDutM84a5VB0mqvYwf3c7glvAvX/OtogcOig7k/Ze/7w8eHHDMMF8KJ/hszwC3r0qp1qU0R5lUEB94+FYjUb7PResjVXGQSsB+ZtFNYktLdrvtiyqDS6NHeK/mtXTqancLfXEkrp69F20Gdpf8vJjAbs+99lfiGsC4zaYdV4FH3mYUeprZtUW4Kfmah3HT3BSXr3C+BQuEeqvugUvdAGd2f9qvjh3+X3O0vHiz5dplNB5dVjatYmWzSjcgF/hzWHn8YlKXsPzptX9aTo1Bx8wkmC2ho4poMuq6fbVVDyWYYeOwC+BzrHQ9QExXtNlKH9sO0xyDQ6gWmzTB+OuIgkD5to+6quA9mT/2F3bLRznA8X+y0aAMxqgdQvws7Nxa4juXKNmxY1F1duQvlw+oO2ZrWze1bBQMpJCh8cqEoSOPPUr0qzQl+X9CCsfga5FUUzqgdrCNA8wOb1sISE1oY3HLWJsr0MqhsugJDUSRU2VD/RfnEPxP2lslsiy2X78/ySE6vYEwzHNJLhW
 9j3u/rGp
 XWog2nsU1fef4tm2u9ACm8I03dUyh0ai3JXAUWSrAQcLi7K8B2EPTv6y2C1sFU7sxm0Xbsu59AZOl80C0WRDTm285TkX5hAKYK1WM4gPc5sm52A2LYNwiNoZlkuXpmGtI6ACs5URwFjF0hNP+EnlTJSgDdUcbU2iQq4m56odiPErobK5Y5XHFSgsHM9UR+XHglAmCiLLpHY3GMcIcImb4NIgbsz4FY7q2mjAo0wurRmAvKa7r4nUpaF+1yba7OFyU4w+HN6IA2vhWoljNfrutqU3WnR0i7IMDHOj6dxaUDwY0gw7y1kptDG381jHaf1r/4Z/O0kqnMWq5Q5ObHvZOhZthALqoTYbf5+1lI+pgDxpliC+n+DLv5QgMwd2gZMGmXBq7hWhoYVZtJLcA3KVBnmdlkMTosY5pinHClOGzbO8QYVuVvMX+CG6izhcuWNGSbgqm8I+MSTWSind7KbukcDowl4tQibISk60K5n/lxg2EKTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/10/26 2:39 pm, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> blocks, reducing both PTE setup and TLB flush iterations.
> 
> Previously the function returned a single CONT_PTE_SIZE for an aligned
> range, so the caller mapped one CONT_PTE block per iteration. Now, for a
> CONT_PTE_SIZE-aligned range, it returns the largest CONT_PTE-aligned size
> that fits within both the remaining range and the caller's max_page_shift,
> so a single pte_set_huge() call installs several CONT_PTE blocks at once.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> ---
>  arch/arm64/include/asm/vmalloc.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> index 4ec1acd3c1b34..c29704a19e276 100644
> --- a/arch/arm64/include/asm/vmalloc.h
> +++ b/arch/arm64/include/asm/vmalloc.h
> @@ -23,10 +23,12 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  						unsigned long end, u64 pfn,
>  						unsigned int max_page_shift)
>  {
> +	unsigned long size;
> +
>  	/*
> -	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
> -	 * aligned in both virtual and physical space, then we can pte-map the
> -	 * block using the PTE_CONT bit for more efficient use of the TLB.
> +	 * If the range is at least CONT_PTE_SIZE and naturally aligned in both
> +	 * virtual and physical space, return the largest CONT_PTE-aligned size
> +	 * that fits, for more efficient use of the TLB.
>  	 */
>  	if (max_page_shift < CONT_PTE_SHIFT)
>  		return PAGE_SIZE;
> @@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
>  		return PAGE_SIZE;
>  
> -	return CONT_PTE_SIZE;
> +	size = min(end - addr, 1UL << max_page_shift);

Okay so we have implicit PMD_SIZE capping due to (end - addr) being
clamped due to pmd_addr_end(), so we are safe.

Reviewed-by: Dev Jain <dev.jain@arm.com>


> +	size = round_down(size, CONT_PTE_SIZE);
> +	return size;
>  }
>  
>  #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size


