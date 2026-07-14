Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F58DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 07:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4CB86B0005; Tue, 14 Jul 2026 03:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5A16B0088; Tue, 14 Jul 2026 03:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1546B008A; Tue, 14 Jul 2026 03:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 905AB6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:13:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E26221202BD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:13:23 +0000 (UTC)
X-FDA: 84986516286.14.93D9745
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5D8D180010
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:13:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Sz+oIaHu;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784013202;
	b=dlY3SFr9bXIqJ5GVp+BqeNc12szjLtqNCfO/CZN2apGLEEiWrwOXodjsZZvCaYvgXnlVnD
	kitF2p8o0HSv7fg8t1psUfwbvu/ztohsonxaM8phBO5NtMlxIBIXr5anceTGxai0aKMjiT
	jeeSEUNAirWUesuxypRBCnhrsV+j2VA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Sz+oIaHu;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784013202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEqHKQJnshBDwnqUujbHpW+soJYVZoj7reUsLZHK68o=;
	b=1oliiuEpqec6VHt6eQzw3soE5uYW15j/trFyAcQ3vLS9P+ZTzLxR0ENmvo0J92hw/S9iek
	3Z5/OVGMSQYKO9EUW9lY4GdFJDQZ58SE05cTtgyR9o5x0WvGNYTvWCftqsVd+/XIeqzZXf
	ALy8bknwhNXUq4UTekrzHTriFojyJBc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CE7D1477;
	Tue, 14 Jul 2026 00:13:16 -0700 (PDT)
Received: from [10.174.43.51] (unknown [10.174.43.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27E393F93E;
	Tue, 14 Jul 2026 00:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784013200; bh=vGgg3Qhk3LciFAKcCZtv6vtYBkSq7V8PiOHvlnoXqa4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Sz+oIaHuVKKjMMsFlz6Z9rbkRcgyv0VRQJBY+fbnoYAP1bz+y3BcSzbdYwuTwxQvr
	 1hreH7uBfrDuVGG5SXe2x+MKH8SPOl7Q6snfZh1IqWxIqk19CSMJCvpbYb0Zg8TbO9
	 Q+4vW3G/939zbf7aoKsejcM5n6Lyacx78l/pMqCE=
Message-ID: <bc4ab9da-0b16-4203-9901-4845323c3e5c@arm.com>
Date: Tue, 14 Jul 2026 12:43:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, david@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
 "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>,
 Leo Yan <leo.yan@arm.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709073823.6643-3-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260709073823.6643-3-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C5D8D180010
X-Stat-Signature: ybf6cehb1smkkkhyf8r363n4p8934seq
X-HE-Tag: 1784013201-248188
X-HE-Meta: U2FsdGVkX18/PI7MbnzPm/4lsfYe2iRBev98EQd+SBfaXIJfw3cOwX19AijnTZIiS/xr47+eOAUhjQ6/s/y3NspQW91fP1k+CAITJcP3HA9gqIktOQHi7Flwikb4quAtraeVLnOVsJZHql74no+f39soFEAbgSzdIvusVaqs3cGtaDRXWGmZUvxvT0moivm+diPON8XJD9RhiE4Kk/zS0yya0tMgZUimUZddaGa0JqE3dA1BE0A/wknxgPIHybItXbYHxVxYtt7nKJqwjIDBHBHhHC70fozUep1MJ5lOR1tqfxr3H0Hv2b0atZJnPnFmUa69NAN+CqbyzG7G5ztCXt+RWai2ddbU1lSlO5QFps7BbKc7rl5zaKZd4RoM19vG5XSOJOWW8+zoSi4ABJKszHSwlz/XxiIlPq5N82ezXaNHsUgQc3tPII8hoQryFtXP6H7L35ZywToPgv3OfQSNwbyYm1yxkAXIQ5sXXNO+lQBYnG3Vt7CddQILCCtFUFZdik0AxFQLYBCZI4CFV4Oysfh6gnwwZaClya1ziPJmDpWfjkVW6gdoDNmZxMvsw3/rN/K6xjbwZotbJRvaEmbdz/g7vdZUBc1GEzECOGAYqDzXGoCNQKkvlRf82hbVlpKWpXhXrWGfgM1vbIc7vtz8tTrX8TD4kIQeK8BltUq6hvNc77zGWuQaM3aLBTl9wKUDONmalItSHVXWetsHjA+1mjsITnvn5ypXBoAtJ4/PVk40eZHPkFWDppnUaUMw/CKB/wK7Si4pzZNSTTQmA0T6Rb2YL1MQLlTHUBLORLo75JxIuMf8LA57CUe+g6f3m6FPvJcwM+z6/R0bKdda+zzT4mXGgnIFelOBW1Bpm+dNcPIXFR7+o4qAJrjf2oAZZbwrUwAeHLcR0WVzQ5BHU57d9Diq0sf/d3VmbmCrDksMC6Au3cuGPDSbPCD4S16MgwPNnyeYs7TvYSMO2knGB/T
 5Aa7hLPf
 w/2HNUZt7XliECCeqIVIkcRrymCn3KNWuucfXY+TCws9GzrYSjpGPf6Q8W6AFXNVWJds1MGjIMGpestI+9VZ+0Ry9PpvoZRuYda+010GF20Y/06Tj9LML9QcwiznRD5d24ayg2IfIi+H+qH3aROIo8eoaNdpKUU7Pmfqm2wlaOn7vgZDwm5tr7k457kuNLoPdDiQJgMzCu6K9mp79MkQQmO0jE2s7KQ7NsMHnM/df15zsPsfZ3MeQ5gl19wMbQBZNJfpXltpFCSiqrHj56IazfvU7wfqdQvNrWhLnZTGFrStMz7T5G6YkWzerrghAfJzgvwVaoVPGrAGtVHap+AhaNFgW//QzWlcdBRbWATv240eYTXD/IoLAgwuX6fboHq/TAlm0+UUNaNIzT7uhMGaeyYpYu/4LiO7E3y/9YNvLxD2YLxPAfmxdzeCRKN6hsVsLOD3nN4dm2OmTAClpGH70uDD8uHsp/oBsX4BulZmXD50V020=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/07/26 1:08 PM, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> blocks, reducing both PTE setup and TLB flush iterations.

Too little commit description for the proposed change here.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> ---
>  arch/arm64/include/asm/vmalloc.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> index 4ec1acd3c1b34..7d9c7dc795c42 100644
> --- a/arch/arm64/include/asm/vmalloc.h
> +++ b/arch/arm64/include/asm/vmalloc.h
> @@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  						unsigned long end, u64 pfn,
>  						unsigned int max_page_shift)
>  {
> +	unsigned long size;
> +
>  	/*
>  	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
>  	 * aligned in both virtual and physical space, then we can pte-map the
> @@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>  	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
>  		return PAGE_SIZE;
>  
> -	return CONT_PTE_SIZE;
> +	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
> +	size = rounddown_pow_of_two(size);
> +	return size;

Please do explain the fact in a comment that huge pte mappings
upto PMD_SIZE are being allowed here, if the given block is
CONT_PTE_SIZE aligned.

IIUC arch_vmap_pte_range_map_size() gets used only when config
CONFIG_HUGETLB_PAGE is enabled. Hence should not these new huge
sizes being supported here also be added as valid HugeTLB sizes
thus updating __hugetlb_valid_size() and adding corresponding
new HugeTLB page sizes with hugetlb_add_hstate() ?

OR could arch_vmap_pte_range_map_size() and set_huge_pte_at()
can be updated for vmalloc without doing corresponding changes
into HugeTLB itself ?
>  }
>  
>  #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size


