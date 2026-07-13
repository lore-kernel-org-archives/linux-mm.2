Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E53C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983666B0120; Mon, 13 Jul 2026 12:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4A66B0141; Mon, 13 Jul 2026 12:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823306B0142; Mon, 13 Jul 2026 12:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5876B0120
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:36:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 664EB8C420
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:19:43 +0000 (UTC)
X-FDA: 84984113046.27.326E8C9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 84D73140008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:19:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eNOeX5wB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783955981;
	b=VQgKbFoRxLEkrD3hMeefSPpWQ0xmvxBN7QUnYSqPhc7VLNTZsgBG5IB3H1enQwg5Iqf1hA
	cPA+OrOsB/S2BdhaZlWgauarF1xrwENewKSpHCEU9c/xYinVigYtUgkhEXoSYAPP+hT3vA
	vls7iEqRmmKRxuZhZrkxFIh5lOCa8dk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eNOeX5wB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783955981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NaaRVxnBFj+SQ9aWp6Se6zorBMY3aLkJmBwF4iBsWUQ=;
	b=Bxu45saRyMxkzywUsY64+nRL5U3qu/vtPa7+saX0d6qHr+6DXfodqJ6TygAb2KLufa01E1
	9BfHh0834/S4KZF0TPl3Ftakj8UB9GfOIE6B2LsUfP39n5y6thvEsD5d61IhKZbJLlc3sY
	kY9bF1xWPZ8zqS5m5stSUpBWZX/PWio=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E8461576;
	Mon, 13 Jul 2026 08:19:36 -0700 (PDT)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F5B23F93E;
	Mon, 13 Jul 2026 08:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783955980; bh=6itNocGqdstfsGVwFY8Fldnsbq94BxJ1jweYynvGIyM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eNOeX5wBC+l/3/3tHLXTnRTariYyyEtBlRXR+rHI/BOZuLuOp6vUDOhXvIHFDkrhg
	 4mvmbYS8yYUrx8p84rbdDf/KcvkLxe5gops5cM9kGRNw7IWd8jHuVrQslZk+3VOU0D
	 tTRvCWvoP3paIHCoH71B9srt9i0aGKkHhZKhaS5E=
Message-ID: <aa5d2aa2-89c8-4b6c-9a28-5c22143277b0@arm.com>
Date: Mon, 13 Jul 2026 20:49:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 david@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>,
 Leo Yan <leo.yan@arm.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709073823.6643-6-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260709073823.6643-6-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84D73140008
X-Rspam-User: 
X-Stat-Signature: px51w1d3dw6iwsijj7ucipmkgiy9gymp
X-Rspamd-Server: rspam03
X-HE-Tag: 1783955981-389966
X-HE-Meta: U2FsdGVkX19/06d9S9hKWdUv7+LHn7dT0JBUDV91NH2Z3hMalR+zTmaVIvxJytTffrlTQavKCjegAmYTp3fAL5gxN6UHDR21GHDRr2lOzVJe5GlK7QdVqhxrAVODqnn7q0PBnz+khKi9uhmSDVvXykoe8vfDDHzwIHhP0VN+2uQQOuySFLkrKz/4BsL3WvXGaPkmhoX/jEIZGyG1aDJ1on73H+vIYlVj4rtB3pbZgqDKy4Z/h5my/PyZ2Agk3DXkKpOAhEBI3RTodvP6WBGg0R4Vate9O/FUu6XjZ6aZBojbENQ9mDH5DadmMW8BEglApr23dneCGxqLJ0lMJxqgODzqerdU6tdhcIwANzS9Skqj5b+/fN8MluA0AYwG1MgzuX6mcaJQK8t8HXtX/kQ1YpmecMc+/le8Qk5PQ1rsJhG51Ki2cdkx741ddz0nSDKGLDhVxsAA2q0R8ryUeNttP3PePKg+w+CFkVrKItWI/d3KiThJsK8DSzJpaREdi04bzoNZ6tHT+MlclIzQK2QwxdBAN459kdg0YPhFQsrNnBOXHOTWnTrD+q0saTVWQV/x61h3HFJR9VScGyRL//zWtgUTcYb2GoGUR2JcQ6Uc0n+UIXwbd0efqJylEV7eXi+tugBdaSw8kzN+n3DOS1Lc9jBV7ToDjatJXKnCENHcmzv465CYk9C0qhtoKgQ+d5JLQ2jE0B0sYYnWL8pqqzEI1ZDq3LhMfTtaM1QMjmpNCrkQC7uSPSUofxqWVukW704slAjg3GgBd9JpFRspKZHKHLMkVObIxB3pLk7MbqcScVELCBv/AvlyCQu5v91oawYPsqnY1uAiHe5MvxZYJT19UWSg+oY1udomg5hBAVWFXr2jCRXAbLewGKl2JOB4HpbT4iZ/TlW6C8SauwxcanX/4m9f3zG1fyv7Gz0WoQPds3OtTeiZpEEve18/5ZTbg79Pxjkv+pWYsLxntOJ6x9W
 Dtglm3EJ
 5xd6u3jBI8y0uQFPMO+JOmd3d2X3O2OYbyYWLji5wM31txEJo3jUcBx9uRkheTcx20/HzYjMrLHEE8iZGwRfAC4C0RY9aAa6gDB/wTXfMg5GbKiL2G1FwD3YEaNXN69EsD8ZGAgpkWxdvQwzAk+eQIOR8BjI4HplhF3vHrTtE4m6CfOXC52FCjEzwMEt13RgBlnGJByUUyiOBEYAIiaG2gPDHR+ygwsZlRraiv0aGJXEm9mqYJ3mWo0avPpifR3xXV2P5n9A70i1oE2JOotu9bh/k27VLAEU9IMww7otzun2eW8o75wG69vaTapTNQinrXp79oMWF/BdhVjs7f8brWNfh1qYoiyTTjDJvzTbhok6+jizp+rmkvfIqO3eHGoMG1Ojj3w2n5RsAH4xxE9h/SbmcCIe6Ze1eE49fwZIxg+6v6zcyTK8T/a2XbGdUJUX//QlAjj5SU/FlOn4tepttT5yTtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/07/26 1:08 pm, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> In many cases, the pages passed to vmap() may include high-order
> pages. For example, the systemheap often allocates pages in descending
> order: order 8, then 4, then 0. Currently, vmap() iterates over every
> page individually—even pages inside a high-order block are handled
> one by one.
> 
> This patch detects physically contiguous pages (regardless of whether
> they are compound or non-compound) by scanning with
> num_pages_contiguous(), and maps them as a single contiguous block
> whenever possible. The mapping order is determined by taking the
> minimum of the contiguous page count and the pfn alignment, allowing
> graceful degradation when pfn alignment is less than the contiguous
> range.
> 
> Pages with the same page_shift are coalesced and mapped via
> vmap_pages_range_noflush_walk() to avoid page table rewalk.
> 
> As users typically allocate memory in descending orders (e.g.
> 8 → 4 → 0), once an order-0 page is encountered, we stop scanning
> for contiguous pages since subsequent pages are likely order-0 as well.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> ---
>  mm/vmalloc.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 85 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d2a4d649af549..db0492151ad08 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3543,6 +3543,89 @@ void vunmap(const void *addr)
>  }
>  EXPORT_SYMBOL(vunmap);
>  
> +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
> +{
> +	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
> +		return PMD_SHIFT;
> +
> +	return arch_vmap_pte_supported_shift(size);
> +}

Need to throw in a preparatory patch for this, which will (in addition to
introduction of the vm_shift() function) do:

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index afaa14ebf17bb..dac87e1cd484b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4175,10 +4175,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		 * supporting them.
 		 */

-		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
-			shift = PMD_SHIFT;
-		else
-			shift = arch_vmap_pte_supported_shift(size);
+		shift = vm_shift(prot, size);

 		align = max(original_align, 1UL << shift);
 	}



> +
> +static inline int get_vmap_batch_order(struct page **pages,
> +		pgprot_t prot, unsigned int max_steps, unsigned int idx)
> +{
> +	unsigned int nr_contig;
> +	int order;
> +
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
> +		return 0;
> +
> +	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
> +	if (nr_contig < 2)
> +		return 0;
> +
> +	order = ilog2(nr_contig);
> +
> +	/* Limit order by pfn alignment */
> +	order = min_t(int, order, __ffs(page_to_pfn(pages[idx])));

You missed Sashiko's point here :) the pfn may be zero and this
will blow up. You can just first derive the pfn and do the clamping
only when pfn > 0.



> +
> +	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
> +		return 0;
> +
> +	return order;
> +}
> +

