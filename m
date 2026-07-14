Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28908C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B366B0098; Tue, 14 Jul 2026 01:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E3F6B009B; Tue, 14 Jul 2026 01:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFEB76B009D; Tue, 14 Jul 2026 01:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2DF66B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:05:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19C6BC01F2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:05:11 +0000 (UTC)
X-FDA: 84986193222.16.F209467
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 31DE780008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:05:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IskI8LYM;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784005509;
	b=hrlTdNTvNsMA5qSNkInGwVZPkzwDFoZYZMoGfWW1DrVoATR0hrx9FUvyJdigYgkSL3Vnv6
	Uy8xe/VDc6CL6BxbSOVUmAkHxP5/U0pZO3e8qPHF2RyTUDtJEMhXslC8L18eh0EVbk2ljk
	s3KS2kjMZ/oNhRrPBRVy+XF+uYx3COg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IskI8LYM;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784005509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRaYq/2pKzlXdYXFBCK443SOjoWqLtid9IHc6sh0FFs=;
	b=aZuFJL1F2G7JoloFySYC5aw9fTI3HuyTYgq7blwcri9dKbiLSE8dKOXyXcxz3XnHq4M6dL
	tWOOSP+8m2Yaj/Rr0XO6qyoJA/9be84wcUWpHx5MpbHfJVhmP5SmUDOHzSacCGgpGY4WSl
	zGE6LzyBn7GA7A99Bkp0fUNpj07Kcqw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E2101570;
	Mon, 13 Jul 2026 22:05:04 -0700 (PDT)
Received: from [10.164.148.52] (unknown [10.164.148.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22C9D3F7D8;
	Mon, 13 Jul 2026 22:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784005508; bh=qT2mgHMj6QJLWSA0zgmN/WGwxPyCB1BtgvzkcnB5MEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IskI8LYMi4GXyfPv7L8xPVpvWDxpiq8313AKc2M43sY5KWhxkTyocowGn4AGEEyJv
	 h44kaMYYonhUoEWFqSxZ0jdW4tTEI3H2Xaqo/l/lc9ViKG0y333AP70WBnwJ1SDx3L
	 9P/n83Am3WBMzsWH5EFM54C0a4T+luMARG5rJaxE=
Message-ID: <6b526275-0e43-413e-adfe-b466155d9ae0@arm.com>
Date: Tue, 14 Jul 2026 10:35:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 6/6] mm/vmalloc: align vm_area so vmap() can batch
 mappings
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 david@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>,
 Leo Yan <leo.yan@arm.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709073823.6643-7-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260709073823.6643-7-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 31DE780008
X-Rspam-User: 
X-Stat-Signature: z3umf6hassg4gy1xri61hgn55d1rq5ki
X-Rspamd-Server: rspam03
X-HE-Tag: 1784005509-52174
X-HE-Meta: U2FsdGVkX1/thahg0W0QmEQUDosB4GPkRGU128xE4hNSjWU7WuD3AAT1zKU6KcJaj2SbUj6Rbt23e61cw7xtzhKq3Bw7sw2IpZtMNaBbrvOJLkGuzYg0f4lRnDOXdILE55e0GqfUCriRZtOTNUvZqGxTv5TN+HcCMSqqXSiAIkl9pxvoQH6Yvh6bJL5UdHXIlxY6LOkJU0BUYBTnSBliUHKA+s8ZQTrXY/sAt3viA0NO9ZLGOXReElnbeDTPPelp7AiPo/MTEWrpcBbUdZ0CWMKQEuu3XmlMFW9NvGOCOYXsj9toLZASNtOU4OhGr/NH56BexB0iAmoEWplE13pSacIEIprb4ULNC15CfOjmyzUHHd6ieO0h4AkANPu9Fx4Vmv5HOKTflZ9JT4wWAlLa+qoSCUux67QN6v/J7tVuB4S+Wkm6YN85CgbMP7LpW6kWzFcDmDCF6noOFXxF0IlX6cClACIuVsDStqcvs+A8Q8jaNY491x7UUEiYeRBKgonIaIMXVfpe+rcH3HAsEl7YK52spzdj2wKM+dxfzYKZLly9QqnNRsa6zJMRGzQy70yB4itv12oPSiWAt7639WsrRH8GXr2aH6k7Td7AV9sznAIOkDrXuppyTWoSeO/mQ51BR1+56ByMCDcgxiC8xFS6ajKRiA/MqLatXN16j5050OqOV+ccUjn6bazmf6CU8ms8akurLx3tWMesC3klk9s+IMrBbC4upBfiaX2/wC2KS8uNBH0M59tHwX5NgTRgTloiSaBK13iPPB4udMJpn6bo2uiBbZ0cqoXA3VkwrvnZWsLwv69F4H6tZ4hmcl3S3Mn5DnkMWBS0PopzUVqpN/zWKgqQHnpKamn2BUVkWkydtcbqBtTdR5blkKx+cR2jqT5Dc9dRRTtwhbGFPqb00iey1MsQvWiEhGBDJSkzGmnvFv6K2ZCSYmnvoFguHNcmS+wc69qv/YQfdrK363izrpp
 TouGVCKu
 29BUitGZwO6TQh0QNddYnVuDvfnT87f7FgjxKsfS8aVhx1LG3LIwkRYtbYH8tBcuFwc25Iz2k114TnR9C8f5KcRpaQ5u7XUwZYDUALEVbS8q2jgHOtKLpsUH5mjdgaiCfZvyZOL/BPJX2ZatvQT3A4YutrFjA10+za0KoNKKBNipfW+BZbHKkc6GKNUxtN7bA9KdrsbCoU/vPUozSHosbU2iMvkC9A4Hv+on38H1AiRYVP5lVWLKdRlHr+hhWnH8TxT5n+Dp92ZB/mM21vHFVX1wIhYEN2Ksl6/1u36SL2xNzQp9C79EdZ98618/+UuR4rdjxfIWa/5r0XYa/x3x3EJ/WjzuOK33ZupdtVP135DCuXJo8iVcW8Mxv/QJdTlq/jckLHkuHFijtdRd28IvACEBvsiqGmJAAY1Io+Tsa3VnDbx8Ab52wok4GAbgA2byd1tyHnxykhXzdqrISu/xot0GU2IQ/QXxZuE0Z0YpeAHke4Vc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/07/26 1:08 pm, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Try to align the vmap virtual address to PMD_SHIFT or a
> larger PTE mapping size hinted by the architecture, so
> contiguous pages can be batch-mapped when setting PMD or
> PTE entries. We do not expect any significant overhead for
> this.
> 
> Add __get_vm_area_node_aligned_caller() as a wrapper over
> __get_vm_area_node() to simplify repeated calls with fixed
> arguments.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/vmalloc.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index db0492151ad08..2ac805cdf18ad 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3314,6 +3314,14 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
>  				  NUMA_NO_NODE, GFP_KERNEL, caller);
>  }
>  
> +static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
> +		unsigned long align, unsigned long flags, const void *caller)
> +{
> +	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
> +				  VMALLOC_START, VMALLOC_END,
> +				  NUMA_NO_NODE, GFP_KERNEL, caller);
> +}
> +
>  /**
>   * find_vm_area - find a continuous kernel virtual area
>   * @addr:	  base address
> @@ -3626,6 +3634,30 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
> +		unsigned long flags, pgprot_t prot, const void *caller)
> +{
> +	struct vm_struct *vm_area;
> +	unsigned int shift;
> +
> +	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE) {
> +		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
> +				flags, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	shift = arch_vmap_pte_supported_shift(size);
> +	if (shift > PAGE_SHIFT) {
> +		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
> +				flags, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3664,7 +3696,8 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	size = (unsigned long)count << PAGE_SHIFT;
> -	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
> +	area = vmap_get_aligned_vm_area(size, flags, prot,
> +				__builtin_return_address(0));
>  	if (!area)
>  		return NULL;
>  


