Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13DD9CCA476
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 16:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416368E0010; Mon,  6 Oct 2025 12:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C73A8E0002; Mon,  6 Oct 2025 12:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5748E0010; Mon,  6 Oct 2025 12:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 111CB8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:02:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B02A81406A2
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:02:00 +0000 (UTC)
X-FDA: 83968155600.17.C499D56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EBC38A001E
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:01:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7qGExnU;
	spf=pass (imf25.hostedemail.com: domain of andi.shyti@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759766519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9whE+x2vuQpTCpSTMXXA3OoO0MAEGff39BxXPL4L/Ng=;
	b=xdASiHDL1NjkvWrpE9gSD5nrSdT2pp5dg4XT1SnIY/Y7x4FfrYQ3jJG7YRGBMKfS3zcA0D
	gwiLAwIcIKw2gWCIxasFLeINJNncA5rtwY2A++uAJnsUWsc3Jx+Kms1gJXdwbegyTN3SAt
	29yCDSA49bD47HGOG701c1F4W2y8Vxo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7qGExnU;
	spf=pass (imf25.hostedemail.com: domain of andi.shyti@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759766519; a=rsa-sha256;
	cv=none;
	b=Y2XeYUZVsZQi6UnXDNrRWm8h37h2yv3yyAr9TuDW9G59yucjc6x3pmuyCw0TSS89pnoZKg
	8NeMXxMu2AWmuDfgQrlbO2UBq2qWh3JMvlGHAuEmAq/1HBW0XBvY8Ou3xWYRIEJxJ/v+DP
	iSGyzjPwjZ6atOE6VXiw8tnyze2VJqE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F32C451C9;
	Mon,  6 Oct 2025 16:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8C5C4CEF5;
	Mon,  6 Oct 2025 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759766517;
	bh=gK0gwx/5nj8BxIOYpHUVKbNTrU6HPqVCyFo2NZIq2+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X7qGExnUygst8ikG9goN/tgOsUmyvjcgYxBGRVWOScnCNadcuWzvwAYa7xl0hNNqK
	 KCIeWJ5pJBUx7TxT8eJre9GkPzR8APx6WUmv7D/2djvoMp0qow9OhHqZjXr9opb93i
	 Ixks72TZ16TA6qZTuhTLIIXGXIo4fnfaG7uI0kDZPgDJ3O78gf73gNIbPd+QZqXG7V
	 AniUAE9YhLTxC4KJTHcDvdM8u4sbnz4brrxJzUpjVCqMdq2ejlACdLz9KdqVek2Zkk
	 zWJc+R3wkToxIbdNF3H01Mt+H1tBxGJuDZWVgZA79AukmuWmddv8zBwC1AfGBLeYnt
	 2FUCERGgr0lhA==
Date: Mon, 6 Oct 2025 18:01:53 +0200
From: Andi Shyti <andi.shyti@kernel.org>
To: =?utf-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Rob Herring <robh@kernel.org>, 
	Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>, 
	=?utf-8?B?TWHDrXJh?= Canal <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, =?utf-8?Q?Miko=C5=82aj?= Wasiak <mikolaj.wasiak@intel.com>, 
	Christian Brauner <brauner@kernel.org>, Nitin Gote <nitin.r.gote@intel.com>, 
	Andi Shyti <andi.shyti@linux.intel.com>, Christopher Healy <healych@amazon.com>, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-mm@kvack.org, kernel@collabora.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 01/10] drm/shmem-helper: Add huge page fault handler
Message-ID: <fbfii7x7ypvbsowp63zuayzykqmpjpdjvzjdpyswwhfttuwemd@wbs7qxp5zie6>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
 <20251004093054.21388-2-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251004093054.21388-2-loic.molinari@collabora.com>
X-Rspamd-Queue-Id: EBC38A001E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: k96536gokf783ii4ehg8x7t5xyjhkfgf
X-HE-Tag: 1759766518-313511
X-HE-Meta: U2FsdGVkX1+DcasiSLMjHD3mDA2oFQ9dVn91PZJ3XfJS2aBmCt+CMEwpkvdvOSfySjYH7OdA2G99k4zsVx0VWlYkaIn+2JEEDFKiXc/PlZdBiJER0OE5zn+wgsxE1E6UkuoOGiqwnQHQy+M+QAdNMpOU1uOxGwXGro+LU+R9zbavA/49Sfimq1ze/AhWlCENRzKdV3BZOnl4l5ywVXtcCnxTt99T3VZdWKq3S0lrb5otGvvbhICPIHlApGDsFGoQNv8JGBZSaiwEeumb0sqmoKQiJ2d4ird2fIQKOiXHS+bgCV3wvUFC0zxm51jcDgBYWxd5v31Ja6MY5uLKdymspbR0q1Gw+oxvneLJBNiOC3TZnduFSSSgijT/lFi3pjS9i5xZoZX47yOfoPJccumwttPYdOuYkeslhZS0Rksyt1Fsdg+CBLNpoERQjAuQd/tUNtGnKlSRqldKbNmZx0LGfDtVS10acS+RpWxr3E9BqVpkYU2Mg8yd4xBUY8Mv7vNhiaruZpMP6qZmTUroz4ZfsIrGrYW2CExEJ08Wlr4WXnbnYEJyvlvZbkUHOBlBnlCZp6XmdnkpvUaS/+hwVdeL25U/f3VFrRK4Fudu2NTxYr0VFxuU5kIflrzTEPUuE8ELPwEbeA64Gif9Vkzr6MfpUP2CbslD+KIWKw55+2BXfh+6NqUW+docOcj+qpHaS9rP5AZbW+5zy3fAPXQmkdCHpOFeDPxlIEDaq3b5RK9BxDQywiCI+mc7crSeLTFZv6/gwEYULmN+w6D5IpY1eTEzvufrGap1H31S0khMjIQObdkzVuJFLdsRmMivl4Hchs7mLkHlYdG+WNiuYauo7iPLpf+Lv6n7DGTfZ48gAj68pIoJlviTuW1st9zYfbwiP0h4Z+P0kyNBz8m5GeC80tYlIs3gQQgV9tSbjgxn0ccFRl7u4xyCT47/LjfcU6zXym43Uk7gnmV4Qto/Qp26l1E
 gIbsVab3
 JDrYcWoFTRZEvOU7pDiT3HqpVFBn9iaUlr3U+8X0fPRl6DSmauPdCa0LuEEVwKEEeAqI9W59s8ZIFy6MwIB2NahdmRCgp9qJ1V4LFHfuCL1AVCaEiGgeW5zTXOlSNksw7wJIsv/LJTsazwXZMJXCz0WLlL+pBLSXSzQGLGEMMrbvavbdfCKHJ9xxU8bE6J1mNvU0HoJ9N577Bld1O+ldRutmdW0+iP52wjqP3vYPH7NnV0Jj6uoiFUEPl1dmoxzWGM5uu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Loic,

...

> +					   unsigned int order)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct drm_gem_object *obj = vma->vm_private_data;
> @@ -582,6 +583,10 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	vm_fault_t ret;

we could initialize ret to VM_FAULT_FALLBACK and avoid the else's
and the default case.

>  	struct page *page;
>  	pgoff_t page_offset;
> +	unsigned long pfn;
> +#if defined(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) || defined(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP)
> +	unsigned long paddr;
> +#endif

we could declare paddr inside the switch case in order to avoid
some extra ifdefs.

>  	/* We don't use vmf->pgoff since that has the fake offset */
>  	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
> @@ -592,17 +597,57 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
>  	    shmem->madv < 0) {
>  		ret = VM_FAULT_SIGBUS;
> -	} else {
> -		page = shmem->pages[page_offset];
> +		goto out;
> +	}
>  
> -		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
> +	page = shmem->pages[page_offset];
> +	pfn = page_to_pfn(page);
> +
> +	switch (order) {
> +	case 0:

'0' needs to be defined, what does '0' mean? (I know what it
means, but for consistency I think it should have its own name).

Andi

> +		ret = vmf_insert_pfn(vma, vmf->address, pfn);
> +		break;

