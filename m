Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82836C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CFD66B00A2; Thu, 16 Jul 2026 11:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7526B00A7; Thu, 16 Jul 2026 11:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595C76B013B; Thu, 16 Jul 2026 11:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA4D6B00A2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:47:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F3CD1C0021
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:58:03 +0000 (UTC)
X-FDA: 84994340046.19.A3DF254
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B7CC040004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:58:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SV+2jgHv;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784199481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3DV0QU7OKveHee7CAK9wnIsCiPz/cIhJ0JoXZwda3Q=;
	b=sZdbWv77lwwvUPW99Q9dsJkfQQvopZSA6OdqvAuWI0WTM3T5K3nBg+qxzSJQsRUR2yoUTY
	GmJ3VGCSPwgECw9Y3I3jni5GWhkXKs4AbIyMrdAPZPOMEYgJe1Uo7yhnal2Jeb2m4p4xC2
	Qx0M2LT9c6vcqWxQbgrpjhsDkNByQso=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SV+2jgHv;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784199481;
	b=Y4Yy3yMqs5Ru/fGb4O9CxJuQq1zxynW3DBzZ/saPrAEjKhC3ZxmpxMnHFLxuyFXcp7Ov2i
	2xy5oEtmraBz+YCg/2S0LoIOzkS3OGDj3jpS1YusphcIfaZYeO7FW60B/+oUlllukxcASq
	w5N090S/XKwTbYhzKpLOiuNqjig+Ryw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 376F76001A;
	Thu, 16 Jul 2026 10:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039F51F000E9;
	Thu, 16 Jul 2026 10:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784199480;
	bh=B3DV0QU7OKveHee7CAK9wnIsCiPz/cIhJ0JoXZwda3Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SV+2jgHvm3cwka/ZjzR2gidMyixp8Rio6myMlJOZLyWHcM0oROEbzQoQOnBlNLzSq
	 vm6JyMEUc7KkReP/iP+qRPbroYuXeflQUqDVlHyKo1EaicuWMCLcuDnSfe6y+onhx+
	 6VgRHotFPAVmjA7+ujWfdHANeIz3L/YFCouQTnXxrob7Vr4So92cXSVzgrne/L1A/T
	 jyRw10Zy4mb9OZHB8tYIBU+Wrm30llgjMzNbZiVirOa2BwFASbyN9qto4/FJ+LS+xf
	 ApAHOENnTasusWGq38crDF4Bc8I5MF0qc9d5nqnFmmmSrtywP0sfTWtsFWqn2NAlWb
	 ZkbzU4xIvtfng==
Message-ID: <fbea7f50-ee00-4466-8788-1cc78303f5bc@kernel.org>
Date: Thu, 16 Jul 2026 12:57:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/7] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-7-jiangwen6@xiaomi.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715120813.3609949-7-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: khj9o9q94j19ssm36urb9xfobhn8sfeh
X-Rspamd-Queue-Id: B7CC040004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784199481-907137
X-HE-Meta: U2FsdGVkX19iQ3iJW1BJ7xjSWt3+C4A6Xkx3DiAw6/LLPbW009XeGrkICWGvHPiFWvOI8kt93XXgVk/h54ctyRK86wkE8abi5ItgudmmxkYuU4gOnIj+Cd6CGo3soAyBDOAwV3krwozwBmjYibNXQCUvpI86/2EPSlxZOJ0k4xTkFuMyWds/b3cOv1qV0rIhgdaR7JKJaMdGF57rAfxo8LEH3eUOBV3Ifpi1qmenH3odMxWUVJQIyELRU9CnD3XebD5n9knJ2BJPyvCzib/jRUJ9jBcT7Ow8zoCfOKgLZ2HlQ1llx/G+/S/jitiWQ7v0SDiBehcT9JpKxM0yHSBC7jp2lflKXlLsYB+13sFb2gnWAzsLQ4svSLpj8YWIe1OY+RSfY2tGFCEIN989rk3VtpiH5sLIRCYPHoeJ7ktJifIe3Hd6co62Df6i2WGNpBCQINbCFTOx7ynC4fKMX9UNBTE93N6EkWuvUcci1rSfYs0Fsg7VePcTh7V43Py8MWEB23EkAzc6RP2rWuGOkywBlWWKGJMnxbFG+nviDwIglICbjpWXAvUSfD2yqCas1xwN1rP1t2kCfYmNkIzhn5ADABqmaqEw3mqrTG813Cb4lPrjiHpHsWNdYkvYVSw1KDzlu0m3MtT/H72Oi6cJ4d3xVlNIRa3G2KIycAEY1fseU5SfvlmW6glEIv5+s/mWgsfDFYcUnAcSX5btzj7KDzoFWjwWaM1iaEPqZNnDw5RBonXd9cgavU2s6BaMU6Xf0+K3Tnq/cK5v8D4o3v9k4T64FSJivCGEZ1PJ830wmharBblYZyEMUQcE1qVpUzfDj143i/i4l5gidPAafd2N4gPCtITJlYhlEcuIv5O6MJZBa74A4u0bTRXcZefBTKBLLyhvhqhzM9F0XhQ7qcxMRvp4W+yK0gaAAwB9lN4hkuKqzKrz4LwFz/OSROt7anjnqL+hjKshzjZfprt4G/Plojd
 BYzBhwPz
 r6Gby1yxA+SpAQUU6Q+RDxTMCcH5ycefcAaBQODczTYXjyfa1lyB0NbG0vpeUHLWzoauSpt3Mq3Ss1fqGgIO1wneBRD1XXi6AqpiYEaKdSfqdaelDYSHU8X6vJ9xPpmAPtrTdN3NnZT84XDI7kkdOEwl3PEO76zXHCjaI6+9uVvBuJz4vSvyOv61JNMcrpkBIXmAm+RB+xwMvIpBDgwosA2zYBZOc0VhI++VP6ek7VS0nrdUKeK2RPgY5pXikJRWcGSeyPMTIHnhdwTs0URnnOFv7zC/m0s9kqRqhmpmNgJ3gWHgbBQgsLGlopT/niBWLlmtG0AUxTKV+X3PGA2NjIxBjxuMY7mIJ78yM1dCYZllqIrtu4xuGj7WbPBs2nh7QekyCgTYZUVpAqG5U7BZhfe/bimuT1/4hTlWmVbkJ5f0kJ8OY1yKTnDGY5DlJYCGuUkw9lHTB3pYwMdqyvvnEtE66FdJtspSJoiVbEH8UW0CjAN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 14:08, Wen Jiang wrote:
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
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 80 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a1e025120e9df..92f9cd5e9def5 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3557,6 +3557,84 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
>  	return arch_vmap_pte_supported_shift(size);
>  }
> 
> +static inline int get_vmap_batch_order(struct page **pages,
> +		pgprot_t prot, unsigned int max_steps, unsigned int idx)

Why pass in pages, idx when you can really just pass pages+idx?

And just call it "nr_pages" instead of "max_steps".

> +{
> +	unsigned long pfn;
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
> +	pfn = page_to_pfn(pages[idx]);
> +
> +	/* Limit order by pfn alignment */
> +	if (pfn > 0)
> +		order = min_t(int, order, __ffs(pfn));

Wouldn't it make sense to determine that before you call num_pages_contiguous?
Because then, you can just scan to that maximum instead of the given nr_pages.

> +
> +	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
> +		return 0;
> +
> +	return order;
> +}
> +
> +static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages)
> +{
> +	unsigned int count = (end - addr) >> PAGE_SHIFT;

"nr_pages" ? Also, can be const.

> +	unsigned int prev_shift = 0, idx = 0;
> +	unsigned long map_addr = addr, batch_end = addr;
> +	int err;
> +
> +	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> +					     PAGE_SHIFT, GFP_KERNEL);

Is the indentation on the second parameter line off?

> +	if (err)
> +		goto out;
> +
> +	for (unsigned int i = 0; i < count; ) {
> +		unsigned int shift = PAGE_SHIFT +
> +			get_vmap_batch_order(pages, prot, count - i, i);

Having two indices, i and idx, is just confusing.

The whole function is a bit overly complicated. Does it really buy us much to
batch over vmap_pages_range_noflush_walk() calling with the same shift?

> +
> +		if (!i)
> +			prev_shift = shift;
> +
> +		if (shift != prev_shift) {
> +			err = vmap_pages_range_noflush_walk(map_addr, batch_end,
> +					prot, pages + idx, prev_shift);
> +			if (err)
> +				goto out;
> +			prev_shift = shift;
> +			map_addr = batch_end;
> +			idx = i;
> +		}
> +
> +		/*
> +		 * Once small pages are encountered, the remaining pages
> +		 * are likely small as well.

"small pages" is odd. Maybe

"Once we fail to batch pages, we expect to fail batching for all remaining
pages, so just give up."

> +		 */
> +		if (shift == PAGE_SHIFT)
> +			break;
> +
> +		batch_end += 1UL << shift;
> +		i += 1U << (shift - PAGE_SHIFT);
> +	}
> +
> +	/* Remaining */
> +	if (map_addr < end)
> +		err = vmap_pages_range_noflush_walk(map_addr, end,
> +				prot, pages + idx, prev_shift);
> +
> +out:
> +	flush_cache_vmap(addr, end);
> +	return err;
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3600,8 +3678,8 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
> 
>  	addr = (unsigned long)area->addr;
> -	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> -				pages, PAGE_SHIFT) < 0) {
> +	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot),
> +				pages) < 0) {

Nit: single line would make that nicer to read.

-- 
Cheers,

David

