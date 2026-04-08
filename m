Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 425B71073CBC
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C296B008A; Wed,  8 Apr 2026 10:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723DB6B008C; Wed,  8 Apr 2026 10:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660DC6B0092; Wed,  8 Apr 2026 10:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5989E6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:03:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E009616012A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:03:25 +0000 (UTC)
X-FDA: 84635555970.07.0C5BC22
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 726D1140021
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:03:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uF9YVPoA;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775657001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imGrul+C5vLlXrsDsW6/7MXfYzG50a3heIIE95FfoQc=;
	b=s8TQbRSg7H20Ev4o7zs+2M16Q2eMHL3e6s4w9cj2kFExCZAad4tNlsacdxArOePhWeYXfV
	x+gjEIkQrHZ4OSizoRa9FIKnELDEQNxbvxX1yEJlrCtB0D8TU1fg3meh94qNStSHAyqPfD
	kYCrWCsLPgFcJqP00UMiZwOU6ZTawuk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uF9YVPoA;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775657001; a=rsa-sha256;
	cv=none;
	b=QhvYZYCLTbCgV25/b9odPftWu896oyIzAlAICNbj6TaEGT52hwsOVG/mcUue1bCCZhz58n
	+TOLTd44yAM3vaOatBII3Of0xyGe7Y9odfZmRAsjTClOQbs3W4T2mcpgaEu5uo9paQv7O2
	rQVEPbnIH0aPmWTZLSCTGlyUyoMwqSw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB44A267F;
	Wed,  8 Apr 2026 07:03:12 -0700 (PDT)
Received: from [10.164.148.132] (unknown [10.164.148.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E27483F632;
	Wed,  8 Apr 2026 07:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775656998; bh=mBcTI6iP+yGZjitLw/2y8VAoswxzOV+GzQFjaDM+rJE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uF9YVPoAWLM3ZMXDgsdRN7uBAZmC4m2DTAjbtsmHJSmKIqlnn0hpH/YV/zwN+CwCY
	 9Rv5VIummHWSwrF7YZboLxLu4ZY72hI3IuiMkoAaxfrPO3L6LgDecLOjy+RbhddIk4
	 kEdfUxyC3bvZI/toZbKG/FmOS94Lwrw731gFOf4Q=
Message-ID: <c54e12b0-1a35-48e1-b243-991de246a8ca@arm.com>
Date: Wed, 8 Apr 2026 19:33:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
 ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org,
 Xueyuan.chen21@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-6-baohua@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260408025115.27368-6-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 726D1140021
X-Stat-Signature: ugs6i9kdrpdwdih5p3mxr3n1ikmzg8yr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775657000-199227
X-HE-Meta: U2FsdGVkX1+zIXlZQpJAxWJp3QbxodxlBlwDiUfx/nHH4cmivbjGP895UEM2k59m5inCkpXVrSWvsU48yI8nsIkDK6wU1T5g9N7DGYhZBBoSstixiBIMVqfnrd72+nyVR2rN13xjUUjNaZsn93L0o9CBNgaFXNW6CTzieNseHUOGmZ8TPo/txi35949x5FD/FQPipXpj4wU9lZrYlMZZoPsNo6TPBWMn4GigA0Au5DLQTbGXXlkcroNZwle5az9kPd4OD9CGPsr7LByHl36hP/XIt/hhoC4jMm2QWPEEDlG3MbkGCJNsLCiitG2w/AI7b1IUV2z4z9xVrCcM0B/cr8Oeh5KRK5WS/j9O5JB3Un1xCzVPuy98Ch5OcoMWVTH8d+vK2Ha5gOZbd/NpugDI1G/ok3PG0GdPjTnNj1uKicHJki/hB7fC8ZuNI6b1HlqZijCTnMQigoPviED1WaM1WRPsMadqALDmc4Gp15J5BaTcv/v60r57ZSXoCrmwm+uu1T2E0Gcx0ThepiUOEnbGZAu1cBLV2uXXNUZzQl0RYc9Kwo8JW9xdnjAyek+zx45nPGb3zN4FWxeRqVaex4Ruq/9vTnwEnnkaKMeCVizQyKEXx0L084A1ncbEpPoE/2od/YF2DqenlEvRxTjje8unLhVlhLKnFPHRD6b37UhEXWBq+Zaaw49sGEJXU9BJ8nykOzjf3QjcHb6WAkvvzz9hEo+qQaUjeWKwdOezaCu19k4ZwMREHmMruO0wLXHI1ImIC3Y6EHoelN4uZgPnp+sOGOJ/WTpQLmzMfYAavXzvZST1uavCGNhPcKJ/QEuacKnVacUPuzgrcvJgIeaHSctacYvAoFmXFK1MFLrX10BslLjHk9mg6J+rW91k9eNXpbb5XwAAnI9476vh1iXDQCGf6c6QlX5HQA2ouzz/7XKi5JjPh5GqlZxzM0vkRLQXuAD3IDT804EkApbiNy6qjIZ
 wU5Se//Q
 SiEMRhS0RbRtvioCGdDfXFSCGiKkCxlfKuCAIDO/t9Hroag83dkoMUBYBpppbvk7l94OQyA4n+TCeiFdtFKHAQTumn4Sirtwh6W+9IPcQx3mWRXDcG8WrYtaHj3tVGfqgukQje09zwhHdneG1tRrDlQpcCUUM+P4H714cbJxoO1bhp8nyKUlNtlj8bXigpeHrV59KBYk8puxQP7m/GH0CjVIXKfHKka4Q3aFdtbJwjxzMiZFB6Fd0KrrUB/zqnfpAsO1ZZ9MK1bC3TGlsSd29IL/RGwcbKksM/+/NR1Av9sBWVRTPsS12ECn3OG4x8jOqURSVDW0bHpesm/cPB0TnlXO5emMH80/DfATy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> In many cases, the pages passed to vmap() may include high-order
> pages allocated with __GFP_COMP flags. For example, the systemheap
> often allocates pages in descending order: order 8, then 4, then 0.
> Currently, vmap() iterates over every page individually—even pages
> inside a high-order block are handled one by one.
> 
> This patch detects high-order pages and maps them as a single
> contiguous block whenever possible.
> 
> An alternative would be to implement a new API, vmap_sg(), but that
> change seems to be large in scope.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmalloc.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index eba436386929..e8dbfada42bc 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3529,6 +3529,53 @@ void vunmap(const void *addr)
>  }
>  EXPORT_SYMBOL(vunmap);
>  
> +static inline int get_vmap_batch_order(struct page **pages,
> +		unsigned int max_steps, unsigned int idx)
> +{
> +	unsigned int nr_pages;
> +
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
> +			ioremap_max_page_shift == PAGE_SHIFT)
> +		return 0;
> +
> +	nr_pages = compound_nr(pages[idx]);
> +	if (nr_pages == 1 || max_steps < nr_pages)
> +		return 0;

This assumes that the page array passed to vmap() will have compound pages
if it is a higher order allocation.

See rb_alloc_aux_page(). It gets higher-order allocations without passing
GFP_COMP.

That is why my implementation does not assume anything about the property
of the pages.

Also it may be useful to do regression-testing for the common case of
vmap() with a single page (assuming it is common, I don't know), in
which case we may have to special case it.

My implementation requires opting in with VM_ALLOW_HUGE_VMAP - I suspect
you may run into problems if you make vmap() do huge-mappings as best-effort
by default. I am guessing this because ...

Drivers can operate on individual pages, so vmalloc() calls split_page()
and then does the block/cont mappings. This same issue should be present
with vmap() too? In which case if we are to do huge-mappings by default
then we can do split_page() after detecting contiguous chunks.

But ... that may create problems for the caller of vmap() - vmap now
has the changed the properties of the pages.


> +
> +	if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
> +		return compound_order(pages[idx]);
> +	return 0;
> +}
> +
> +static int vmap_contig_pages_range(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages)
> +{
> +	unsigned int count = (end - addr) >> PAGE_SHIFT;
> +	int err;
> +
> +	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> +						PAGE_SHIFT, GFP_KERNEL);
> +	if (err)
> +		goto out;
> +
> +	for (unsigned int i = 0; i < count; ) {
> +		unsigned int shift = PAGE_SHIFT +
> +			get_vmap_batch_order(pages, count - i, i);
> +
> +		err = vmap_range_noflush(addr, addr + (1UL << shift),
> +				page_to_phys(pages[i]), prot, shift);
> +		if (err)
> +			goto out;
> +
> +		addr += 1UL << shift;
> +		i += 1U << (shift - PAGE_SHIFT);
> +	}
> +
> +out:
> +	flush_cache_vmap(addr, end);
> +	return err;
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3572,8 +3619,8 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	addr = (unsigned long)area->addr;
> -	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> -				pages, PAGE_SHIFT) < 0) {
> +	if (vmap_contig_pages_range(addr, addr + size, pgprot_nx(prot),
> +				pages) < 0) {
>  		vunmap(area->addr);
>  		return NULL;
>  	}


