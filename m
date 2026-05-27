Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C075FCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 05:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9D86B0005; Wed, 27 May 2026 01:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAAEF6B008A; Wed, 27 May 2026 01:43:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7D06B008C; Wed, 27 May 2026 01:43:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF73F6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:43:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 580C11204D3
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:43:20 +0000 (UTC)
X-FDA: 84812106960.24.8092C8E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3056920002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:43:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mAxCWDZs;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779860598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ikkV6QQjvmdEtsbaLRrdn+vkusNG4Ps4hZDblpGimw=;
	b=rd0J+b2uCHTiW0RGdhs0oh8QUNKCXoW+7ncXKq+lrk7ABy29larczqYmhqj1Q24DrpE/ND
	hpIwRUVy/CGIYXAhmvgZE9C/IkGa/XAGqjFZ2neMR+viOa3JKXsI5ZdfKN4alingxLuxWG
	3bOHIizEsIB/erymylntxULbTFietYA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mAxCWDZs;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779860598; a=rsa-sha256;
	cv=none;
	b=m8Qoac+NXMYwnhZ+wPoWh532ixDCjw2IkvpVRojwFRn+uMReRfCa+wHcHotvTHJrjIOHcr
	OeuKJ/v1cqhcNNkOkAy26owySh4uQ7Zllwr4gfrd7AZ1W4gnIK0V83mvivRjhMwBxHPjWk
	y4BB+xBPVYRFGbQK9ntszDJtUomDBvI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EA7A16F2;
	Tue, 26 May 2026 22:43:12 -0700 (PDT)
Received: from [10.164.19.7] (unknown [10.164.19.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22BAA3F632;
	Tue, 26 May 2026 22:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779860597; bh=kN7v8Yo/h9jLVzSWJYwp5pXMcuNhkzPz7FVEiIHcY5E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mAxCWDZsUUqwMXDxAEIrGKbX+vEH2ZtBW3H5sftYz90tkf+jWEvMRM58EXGsOd5OH
	 /4JoDFW3EvPipQtTEXBdiPAAkNZQh16kAU2D2kd2ukurqyQmjmDJGTzVRiTh1sjbeU
	 PCPEY+mYQKZo353Hglks4w84JtcVfQdZb2/VSHqU=
Message-ID: <9e3343c3-eef3-419b-868d-ab02dc66e47d@arm.com>
Date: Wed, 27 May 2026 11:13:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-3-jiangwenxiaomi@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260522053146.83209-3-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cnoh89js4hzzx7suz9iw3qrdepxzi1hm
X-Rspamd-Queue-Id: 3056920002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779860597-78090
X-HE-Meta: U2FsdGVkX1+9WJWxk1wOGBtLzaz1NU03UCx0royQuyXPJhW2KTSqIa6opUSvaGC+FXWRi5T/w5JNAm7hZERwL6w2NjEyO2Gq4p0qlSpJX6uFscoBqlXshXf1m021CYduhpoQE5j2C00y9xNU4vX2a5ODdUsiVHWlPVJxv67+4ZKXR/y3zzRwyzRm0qzdaFIjd3lLqbj4QkLJRUbN4QI11o5awMe4OZw/c37leb2/35qV5hD+uggcD5NzLosrPG8FyLAJQvzY8R6nA2kgg3cWGJ5mR6hwpm45A4OdE4QPOb8qt0zKSuYnr6IovhFNmVJZ+M++FP8X7TRo4K7MDyHLLlaubLiRs9psq2q37Ee608WGhj6E3s249H24oIsALyl+qXNWcEY8GeqpRaO7Ubwyral+emN7GrCXciCE4kBLL6w1NMdLyDVTW+Oe5/zy0UZJkuHvhiWnbbQV2dnkQEvX8ca1qrs9ysqzeVk7hW+aRJB28S8lvXd9Nx4upEAxEDYy3XVc40nlqTDGiJkrAudMmVOuzKhgXQCpwrcvjNuP6/mwuZqx6/z8xqGaD0YP4rwk6psoIY5CTBSSoO1ZogEkwy5LZrwA53kBoIO/LqvX5Jm78hqbV6jMT+QmmUsP0kD6Gd1oJjOG7FRELfkyztxXmrFk86/tzfDiBhF6Wuy//vBfdVocjZmj5jG/Fszp3jvWePfHXmTppur3YbZMJUgb9lP0vZL9dk/OvfM8SIifoSJzprQMiIrmwXNycLJ1jWB3EB1adZ6Ppv42Aws2fm54E+Zes3XOzt5ZvN5qlOYv4b5Wt/L9fZNzimfZZYbTAYzm4fJ6efMzyM2P8qJQUiSWufW4Rt+THbuFlENFcBOZw9+kMFuGLL97EAo4ADrl5Ainm0jfNwiRhgQz4zbCxohopBWocdL7cKudqH7dFJXsYVUN+MUUzfMGDQZzCbr6R+DnR0kEyxeRldNwDvxRUrL
 3Gafl0Va
 yrkD9NR5SKU4VT0GTig3Mv1Nl7T4HNaF/voglf6RBdpt9zKEQ8W8f4Q4YE1JZZaS2JmOcsOvVQ0hBY/3t1StxBuA5wM6Ge6/UB4olBo/oE5949wtY6uYmbhoZLARugqTsn2yZwacAkV8bg4zSottk2dNgmIddG3nvsMb+sdd2Agm0B65cCgeQR7fpUWqQ4Bo02sMFxYXtUS/HBQciRVCfmeK0khfZDFfCNOUPsrgfRAQPKgaep0vDX3qAmN5xEWbHqGQawOVPth9EcblEcMTF3sLULsZbjlvdTrKK90AYn3olqJgVRONj1poJ0lSbVmZbMXXtOhk2+lY4WFWZrhDhZfr1agVqlHHRN8eXarcGc3pFwG/+lBVLF6MbHeZdmO4XNaZpzm2Um1R6oSu57MWZDNSzV+mc63xPU2ICFwRq2GFLt8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/05/26 11:01 am, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE hugepages,

..."to batch across multiple CONT_PTE blocks"

> reducing both PTE setup and TLB flush iterations.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  arch/arm64/include/asm/vmalloc.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> index 4ec1acd3c1b34..787fd17b48e2c 100644
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
> +	size = 1UL << __fls(size);
> +	return size;
>  }
>  
>  #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size


