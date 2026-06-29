Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD5DC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83CE16B0005; Mon, 29 Jun 2026 02:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE826B0088; Mon, 29 Jun 2026 02:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704856B008A; Mon, 29 Jun 2026 02:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9E76B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:47:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A61041C69AE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:47:17 +0000 (UTC)
X-FDA: 84932018514.02.E4D33D4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id A3A3520002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:47:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=L1ipuc6p;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782715636;
	b=IiaKG3IoycuVNYrswibU8cxk+upDh5tCyk4i80jfgXulEPAtMK3nt5vk1AoS/Gc+Ep31uS
	mzTtY6rLFwu9WVLTjb4eFMVyCEzOgb0lkjq/chs/v6xVJynOUtQo1bCLZS8tKlFl1grG0e
	wyXLHL/5JFAx8eJhIj4BpvinP7aJPas=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782715636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/fJt3NKLlyjvcFkI8VZNqRDO7ANl8HQ8B6aLmlQAi4=;
	b=CnZQERwx7qIOkY3I/6LQlq8NTWPQoWoFGScDpOenVuzFXScqM+CSrqVoaB4Br8Bu8fsHLc
	qJhpU6Oeytp7mchNlV1/xoBKxqw23+vOczr4JOrbzX0QepF9/60Fh026mnm1/lF1oWPm1O
	uzVZC2hjOuZi30DCM7FuQ1MOlXYmPX0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=L1ipuc6p;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2002E176B;
	Sun, 28 Jun 2026 23:47:10 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C1F03F85F;
	Sun, 28 Jun 2026 23:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782715634; bh=wG+BKRCh7EswG1NnBEIJLxPGzB+YZ6gQORqGiFpNlxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L1ipuc6pUg//TJm2iPvJ8j4e8NZzKbVkfx4X1O65glkyl1Z6AzAdvwnb9H9muTdJO
	 yIY6NujGnMcYEdyOgxBHRN6ZdFko2nQQ03RgGjxLf8sfQD0J/IMOFAieH7m5C84m1a
	 DYnT2j6Lc7v4DOn1UajCixH0dkmX1SKs8MWOtFHM=
Message-ID: <aecf8ea2-43e3-4aad-810a-120b036d8bc2@arm.com>
Date: Mon, 29 Jun 2026 12:17:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] mm/vmalloc: align vm_area so vmap() can batch
 mappings
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
 shanghaoqiang@xiaomi.com
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
 <20260618084726.1070022-7-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260618084726.1070022-7-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A3A3520002
X-Rspam-User: 
X-Stat-Signature: curze3rk7g1rin5htyu5k6p55dbbrye8
X-HE-Tag: 1782715635-284177
X-HE-Meta: U2FsdGVkX18mOHkv+6trW1f1tCtKkmJC2vPnJCRMyxbj4OMtcAjahwntIG5HAre1+lzc4Sryb9kyYQ46fEIdQ8I0sTTWRHSuSJVL6DI0vQx0SkyfzfNyhKTP8QKzQGMeoalzjy00J1eVD5bbVI2S7/g9K/DuZwtzoAkmHlwUw3FtbQFCMiGcPejoR5Pa0Qc13ATdzk+jUE0GF5Uub6NFw1hLyQOJtU6HxNODy38QJLET5/RUvq8l0H176OzA1cGWlNEn6ydUqUE99qEAjdsDCbJ4zBnyJ3j8XOxvxoiuj4hcSjXs39aG5IH98kELYk1Cr+UqNTTWAqQ1M8czQW0l2UV46kMHmckYndmgYjlHG7pJoHwm++p0pBjrd2Ui7KIW+MsAFtGSPHBw76WR6GBmGHte95cbyMuKNiy5gpEEHVE4CeXyF6W92TdChEhTk2UBlWICRgWFf4nFMNjW1s/Y7/FVee0Kc0dYJY8UyAMBERMLivycNA1Ef51iIn2jOPiSDP7P86HCx/MiPx0APpeaM8HWhTbXj0+PfZRUVS0e72r46i1w90VaZ44rbVo1FWsAFQ82vJ+EpOJXSZDaR0w3vhGOuK2R8SN6OBF/03lBypoL154ZAsuQhMDhWvZp4kwDEJroEpVEj+6Cx+Sc8TpYXkBFBOVbHrMoHhubCziL4x5TN/UZcphThDRf+7S++K7e/YsqgBBerKQCMbHzOrkz2Q4c1hSXH0F7ZSJ6tTHzfsP2V2BAbHs988JdN0+3Lr1LBM83fzi/lWFgqETlRb0awBQgO5l8Rp1nIxqcUln6OiYV5B+nWhwHo62prPbSy5HnmojNcpCQswWB1DHabg0DJpWw5+ncKeVjEi9qN3KVl6X/JNVp3jy01MqPlmvhrGjEyh39vk/6pXvEdyhgf5QC8qRp0bypWkNjbT/ZLciQ5r3KkAbIAFUHgOaaosBQXJGnSamKy7i8svD7w1bpWQv
 gWxC7PmW
 2k+PHWrB1wUZ1+4Syja+U0CUerHkquFPIIfWEcinLuDNfRO7pepCLfW9w/D7CbotfgfWk7kSisw2PtBEE9Ug40hPxen4NGVBNqCGxq6J4NlTAgZSEwJPU+2BTxJWR56cTxji1trtBsbKJiRaI0h8cFdSjqkmyOLhNjwmLEJFustVIjk/j/7XsIrW91510Dsovci8p3O+MAayRb1ve4MXumh2Ex2USemq7TTW+IDzGY/j8HFtsJDJEYjyu/YLKM6o+x85Bw04eXJqRWUAtOXarfib8kTj+i4o+7crhMkXgUkAS/lw/psFQOrtYThuu8HEUBZHWMhZPhByEiVSzyPQvZI2dBweqsxL07npTqXSuIkfwGg89FGtK5oeGLv2vZzicSws+QhH0qFkPrHOe6zHJDSLIHAFuQMY/1M77Ykr2eYeKQgG/11HDM7IVsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/06/26 2:17 pm, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Try to align the vmap virtual address to PMD_SHIFT or a
> larger PTE mapping size hinted by the architecture, so
> contiguous pages can be batch-mapped when setting PMD or
> PTE entries.
> 
> Add __get_vm_area_node_aligned_caller() as a wrapper over
> __get_vm_area_node() to simplify repeated calls with fixed
> arguments.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index fffb885cb2158..bc9fa93e2bdc6 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3628,6 +3628,41 @@ static int vmap_batched(unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
> +		unsigned long align, unsigned long flags, const void *caller)

There are 3 similar functions below __get_vm_area_node: they are __get_vm_area_caller,
get_vm_area and get_vm_area_caller. You can put this one just below them.


> +{
> +	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
> +			VMALLOC_START, VMALLOC_END,
> +			NUMA_NO_NODE, GFP_KERNEL, caller);
> +}
> +
> +static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
> +		unsigned long flags, const void *caller)
> +{
> +	struct vm_struct *vm_area;
> +	unsigned int shift;
> +
> +	/* Try PMD alignment for large sizes */

This comment feels excessive. Can remove it.


> +	if (size >= PMD_SIZE) {

Need an arch_vmap_pmd_supported() check here.


> +		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
> +				flags, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	/* Try CONT_PTE alignment */

Comment feels excessive, and again no need to mention arm64 specific stuff here.
Just remove it.

> +	shift = arch_vmap_pte_supported_shift(size);
> +	if (shift > PAGE_SHIFT) {
> +		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
> +				flags, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	/* Fall back to page alignment */

This comment can also be dropped, but I am fine either way.


> +	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3666,7 +3701,7 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	size = (unsigned long)count << PAGE_SHIFT;
> -	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
> +	area = vmap_get_aligned_vm_area(size, flags, __builtin_return_address(0));

So the effect is that now we search for an aligned vm_struct unconditionally. Better
to mention in the commit message that we do not expect any significant overhead for
this.


>  	if (!area)
>  		return NULL;
>  


