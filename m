Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C480ECCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C258E000B; Wed, 15 Oct 2025 04:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173578E0002; Wed, 15 Oct 2025 04:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0B38E000B; Wed, 15 Oct 2025 04:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC89B8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:21:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B6631A0B51
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:21:41 +0000 (UTC)
X-FDA: 83999654802.26.9D93D99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 74EBF20008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:21:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u55Z+EvM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516499; a=rsa-sha256;
	cv=none;
	b=NjFIG6mZQ5TBiPIB6OyBMW/LzyrE7OIfTSB1IGr50A8vwpgy7ft5xwnJk8fDYVvz8t+eco
	GDNfG4k5Kk/LlO3mIzmUHYdsErtGfdQrjjywSv06Ra2ZlW01Aki+HFBIIWTMifnbkihseC
	fBJju6JPDgVcpoJBqZ27LB+hig4oLSQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u55Z+EvM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEGpct1pPo/9AwrIfL7NwUZxzHtPRtYHvflLKg+Ai5E=;
	b=h6T7nsXyioMauiWEdd7E98vqICEN3/VG5ttQRd/kr8ay9HmkO0xWwOkOEqupEuzeJwoJDG
	XQ4fFK/D/IOBIydNcb/NHpzqRY+9DXFnErNwlrcfShIiAcQlGCWObrjSN36QXpVf32D/X6
	FYusYzyRfnWIFRs5s/NP3yjz6U8WBog=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CE9443901;
	Wed, 15 Oct 2025 08:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A175C4CEF8;
	Wed, 15 Oct 2025 08:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760516497;
	bh=aUyMg0r5Z6Pu1f8HinELT/IZMgwDZyyKT77Cbz9ISjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u55Z+EvMBzgWN6PmzJ4w2jPQk1OmAHY1Ltm98ZKLlILP6qsjXVlaDW1JPSjk/l4cC
	 6nixNt1kHAFbAioY7wPrDSkwrhzt0GQmM/RXf1fCLhyH9cJTQ7pNX5XTAdgTe/0KOS
	 UxccDGFrzDbf4ZakLZzrChf2iY+dxH4YZvQ+z2J8gq5kPm5XTJ14u0Cu7X9RvKVQgb
	 8mlcAQ802+06rdeKIocL1dphngXtsBd3GY3WqXYilMNlzD40b1bovdZJXNqmIYlESW
	 k/r0kWitA+2DjeieTpbzTW3MM4CvAG/K9slCPttLCvLO2CYRU3ictLCDx54x65PU1y
	 HCuaTguYdZYgg==
Date: Wed, 15 Oct 2025 11:21:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
Message-ID: <aO9ZiERHff7vQiBL@kernel.org>
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015053121.3978358-2-pasha.tatashin@soleen.com>
X-Stat-Signature: bzu3jx5qqpbbcxgozstwewhedfg9hygn
X-Rspamd-Queue-Id: 74EBF20008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760516499-736593
X-HE-Meta: U2FsdGVkX19HgECL5W6yCbZ4XwVwesWkaEq53l2gbamfKsmq24FaFmstL9HdM04ySlSPPCosLwYZNFU33A+TPYC7K/7o/0ry1HUoF6oy21LmHM5yE9t9mQ3SjlHj+gaDyAOLL/h5VCjJbhZJo9aQ9j2Q47zccd+CCAtHkQ63KAv2uI0o4PPJndH77H0xrFYCKWLtbzmUT5FLMecbck8ieY3b0EzentoDN4ls5raCHIFcXKTa553y4YNHrca7oMQGm+DpVdJs9z9RKhPI8xVM+PArqAQrujs7XJiNfKPnRqWNfLRv28cRzo7JPBMOmSsAlxhdjr8dkTzt3UktazPfG8lFuheR48dzND9kpTPhclFBJfuXex+d17kMkADcmZ6a3rFhbM/fZe5Vy8rUVAZY52b225JXBCLg6tRjT4fR4o6LvEiTaJ6RjSaFLh1rAyrvlrPqkUW44XG1vmttScvmzMUTU6mossGmehhlajN3WErau+WD/qKhkbLEY0WiXEc6I0w2aRPzxx9selQfvt60Prhfsx/7P/iqh+7QG5b5F7c9RHIue8mn9g6nhMJyr+g/IqWUWeHZaxhQ15i6CD5H3xTmXAt07Lt5jatezaZgfNcvIZxo9b2jNxfFAGlTIKRkcRp8f2w4wCU/BjkASF2w6D5u3a0YBOCcTpwhPGVFPe1ba5vLCrARrgaQp+hP5F1T19koxx5EJxSKciuuPapdSAIPIOxvoyZNekAA/4RO0TH/gKsDbFS5HhylXnZHzKLYK4IU3lBNI1RWUe3H07/Ov3fgyFmooJ1FaDtd1ktaz7eUj0olXrvy5KzcWSNmVxyXI2WkK3Wlk+81DhaMPAu+gxlzo9NzytmQ1mQqgn1HXoJ8OYqUDAQV3849guZ4SRnHr7xjoz8Wksm1/JuEvO90VRvYTaEMrQIfboJ6bFhU7C4yvfnxpenFZiqt96ctdDB4hisr7tOtNccdi/5NWh6
 803JdZ4C
 +19rRCyAMBpxgm3ZvL5VnbH5TQfdkhzhMrroQUv1f804LCASstgnxnQ0Y6h71XKNhQ2MGKRuNOuN7DFdyiLe/3tsE536uBz0ifa9NgvuL5H/5VE2FCcxmy5bdrg0C0+LJudnNWI2BgsWdA97Q9U9tm2f+37/IGxwC7W/N+RUTnpFxapsRS5+EouPRGc+jqz4wUSVl6D93xqyoYXvHDa0u4FMXBrtvy7qxMmPwubV5AKm57+IpfoICJ+++gUA+tetkclx5ZY9Drgl7TwIidB8kmcEQbta9oJW3kB+HN3Tp3IdUsDI8KKY9GmnH7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Wed, Oct 15, 2025 at 01:31:20AM -0400, Pasha Tatashin wrote:
>
> Subject: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or preserved memory in scratch area

Hmm, can't say I like liveupdate: kho: prefix. KHO: on it's own is shorter
and reflects that this is a KHO change rather than liveupdate.

> It is invalid for KHO metadata or preserved memory regions to be located
> within the KHO scratch area, as this area is overwritten when the next
> kernel is loaded, and used early in boot by the next kernel. This can
> lead to memory corruption.
> 
> Adds checks to kho_preserve_* and KHO's internal metadata allocators
> (xa_load_or_alloc, new_chunk) to verify that the physical address of the
> memory does not overlap with any defined scratch region. If an overlap
> is detected, the operation will fail and a WARN_ON is triggered. To
> avoid performance overhead in production kernels, these checks are
> enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/Kconfig                   | 15 ++++++++++

Feels like kernel/liveupdate/Makefile change is missing

>  kernel/liveupdate/kexec_handover.c          | 32 ++++++++++++++++++---
>  kernel/liveupdate/kexec_handover_debug.c    | 18 ++++++++++++
>  kernel/liveupdate/kexec_handover_internal.h |  9 ++++++
>  4 files changed, 70 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index 522b9f74d605..d119f4f3f4b1 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -27,4 +27,19 @@ config KEXEC_HANDOVER_DEBUGFS
>  	  Also, enables inspecting the KHO fdt trees with the debugfs binary
>  	  blobs.
>  
> +config KEXEC_HANDOVER_DEBUG
> +	bool "Enable Kexec Handover debug checks"
> +	depends on KEXEC_HANDOVER_DEBUGFS
> +	help
> +	  This option enables extra sanity checks for the Kexec Handover
> +	  subsystem.
> +
> +	  These checks verify that neither preserved memory regions nor KHO's
> +	  internal metadata are allocated from within a KHO scratch area.
> +	  An overlap can lead to memory corruption during a subsequent kexec
> +	  operation.
> +
> +	  If an overlap is detected, the kernel will print a warning and the
> +	  offending operation will fail. This should only be enabled for
> +	  debugging purposes due to runtime overhead.
>  endmenu
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 5da21f1510cc..ef1e6f7a234b 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -141,6 +141,11 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
>  	if (!elm)
>  		return ERR_PTR(-ENOMEM);
>  
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
> +		kfree(elm);

I think __free() cleanup would be better than this.

> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
>  	if (xa_is_err(res))
>  		res = ERR_PTR(xa_err(res));
> @@ -354,7 +359,13 @@ static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
>  
>  	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!chunk)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);

I don't think it's important to return -errno here, it's not that it's
called from a syscall and we need to set errno for the userspace.
BTW, the same applies to xa_load_or_alloc() IMO.

> +
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE))) {
> +		kfree(chunk);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	chunk->hdr.order = order;
>  	if (cur_chunk)
>  		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
> @@ -379,14 +390,17 @@ static int kho_mem_serialize(struct kho_out *kho_out)
>  	struct khoser_mem_chunk *chunk = NULL;
>  	struct kho_mem_phys *physxa;
>  	unsigned long order;
> +	int ret = -ENOMEM;
>  
>  	xa_for_each(&kho_out->track.orders, order, physxa) {
>  		struct kho_mem_phys_bits *bits;
>  		unsigned long phys;
>  
>  		chunk = new_chunk(chunk, order);
> -		if (!chunk)
> +		if (IS_ERR(chunk)) {
> +			ret = PTR_ERR(chunk);

... and indeed, -errno from new_chunk() juts makes things more complex :(

>  			goto err_free;
> +		}
>  
>  		if (!first_chunk)
>  			first_chunk = chunk;
> @@ -396,8 +410,10 @@ static int kho_mem_serialize(struct kho_out *kho_out)
>  
>  			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
>  				chunk = new_chunk(chunk, order);
> -				if (!chunk)
> +				if (IS_ERR(chunk)) {
> +					ret = PTR_ERR(chunk);
>  					goto err_free;
> +				}
>  			}
>  
>  			elm = &chunk->bitmaps[chunk->hdr.num_elms];
> @@ -414,7 +430,7 @@ static int kho_mem_serialize(struct kho_out *kho_out)
>  
>  err_free:
>  	kho_mem_ser_free(first_chunk);
> -	return -ENOMEM;
> +	return ret;
>  }
>  
>  static void __init deserialize_bitmap(unsigned int order,
> @@ -737,6 +753,9 @@ int kho_preserve_folio(struct folio *folio)
>  	const unsigned int order = folio_order(folio);
>  	struct kho_mem_track *track = &kho_out.track;
>  
> +	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
> +		return -EINVAL;
> +
>  	return __kho_preserve_order(track, pfn, order);
>  }
>  EXPORT_SYMBOL_GPL(kho_preserve_folio);
> @@ -784,6 +803,11 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
>  	unsigned long failed_pfn = 0;
>  	int err = 0;
>  
> +	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
> +					nr_pages << PAGE_SHIFT))) {
> +		return -EINVAL;
> +	}

Can't we check this in __kho_preseve_order() and not duplicate the code?

> +
>  	while (pfn < end_pfn) {
>  		const unsigned int order =
>  			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));

-- 
Sincerely yours,
Mike.

