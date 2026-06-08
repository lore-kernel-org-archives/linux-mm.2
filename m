Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E87FCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C0B6B008C; Mon,  8 Jun 2026 11:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC366B0096; Mon,  8 Jun 2026 11:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D016B0098; Mon,  8 Jun 2026 11:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE2FE6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:37:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 933EB1C095B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:37:09 +0000 (UTC)
X-FDA: 84857148978.26.77461A6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9BF41A0002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:37:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="d0/nWOEC";
	spf=pass (imf15.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8MjpuiW4UVZFDzn32268k2v8y94maVlbn66DhAxaE0=;
	b=Yvme8pP13XBxzB/z6qAYEjlt78rr2oj39ZdYBsS0rgSYaO9qJpB3kjaIvA57FztQKfCifT
	OCqwaWZJrfKDRWTYnYqnmcg4Xc+EzA/HJAUYn57pYY+Ad3dXod/2bQYrfup9wNvmpTjOiI
	73W9XKsXbKRpdpk9fKGN+qpgVsG2wnE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780933028;
	b=iHfmg7Adz7KHHjDzs/RJ/Agpgk+oC6z6MS/Js1lPFe7kuarStEmyFcDAXbR7+YXS29C3QA
	1mc2Y3oPZLhS2Z2QmwH0JsGH/GMyolVtCD74L7z9a3Uow0KRjGL5A2rPU1xBP2UXRy063M
	RD5SToWyGVXtOsqFy8ATVJC2WsmGGF8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="d0/nWOEC";
	spf=pass (imf15.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B20D11E2F;
	Mon,  8 Jun 2026 08:37:01 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FB4D3FD80;
	Mon,  8 Jun 2026 08:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780933026; bh=Xu4EpoEVeMBr4+03yHgtOAgELj7OjAwLMfxBTH0IrbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d0/nWOECo2S/dhvr4nKDtkYkcWA+bUJVSZOhi0EsXdPJnQVMRplE1SOJFOTNAklR/
	 glKbWqMaGn/PnX4OeU7HHLIB9M755vR8t/aaCVQ8pVwpM/NRo4T2NuYK4y+yzqR1fg
	 O6He95z1esL+nbujmVR7gD/POR01aJyU++Dtg9wc=
Date: Mon, 8 Jun 2026 16:37:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kameron Carr <kameroncarr@linux.microsoft.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org, mhklinux@outlook.com,
	linux-coco@lists.linux.dev,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Message-ID: <aibhnnDFQTHWMEFe@arm.com>
References: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9BF41A0002
X-Stat-Signature: h5anutp8hk8zac877hoqasya1r918ehn
X-HE-Tag: 1780933027-810379
X-HE-Meta: U2FsdGVkX1/V9W+ecTVahSmSw70dkjzss6L712mpiidl1cfTPlR/I8RRVEoTOUk+XooUro9FGaPerf2kKUzn+1X8y+kAKxFN0M6WZkJkMh7zb15Wn7Z/5LwtWV80+dlLLUo6D4tvIiGnwxmNKdLlxefKJj4JsbQCqDeDLd3oz66g4rDg+WEF+Jihn4qUrNnHpIbt+u4MLOiYq/D52X2QhoQXiUYnAG9AbKKwfm8KQqLdVevviqEWAEGtv1NpxaRKd2ZCZwsN0ypJk7vO6DkyFFyyNwVtO6tdjG5Do7pcqGQbAvsaCGcCvUrXw1ZaMcxKDppu9RowCjduGyygbLk0QHoMlUUvs5CaJpSrmt3OuKd0mKogCRYiuYzJP6CGl7lWrzwOIiyzrcvlpsM2Z/7oZyNu13i6G+x/ke4eg18ozw8S5cIL/Q+TNQxvSAPJluz8JK0zi/XTerYbCzRZ4AlrIX25hPFggQWvnhvcOUIRgfX8/wf0JwLIQB1oR5y9puBZqt+TmgB2q0wcd858yGhFgjK9oNdLw7URd6izP50DD+6+uqchz/PcuPHiVitW+sPDcxWubE7KqHoEM6Odl7K2uK+WFdMNYxAureNpydaH1Q+ang4ce5nik8CGMPJ2uL2XqEf9cDjOZIwxX1acZdS5wXnMsyEiEC/YF5gg3POpI9pc0emyKYwzvMoGx7rLzedJk83Vj7ikpush+8Tf8eYnf9OfjkHgWtRBiM9j7d06FkJq/GMGfzQXjXS/YawEnufNeK9GJJuMmoQdsr6W2Y0bWYB9soQbDTQNtWt/KJX2fPP8tslAHsXfeWUCVwsNV000o9uKsHZmmk1dtqqvO0k6tXbXB3J1LuKRkKf9z44ZaXZx9n/ekioXzm6s8tHRxrn8smarYG7dXcUJq7Gy6S6PjpXAFZy49CwoOB85wShU8tF3+ifWcGXEMDxBp/IqF0sL2VLcls0We3ZCduW6gX3
 T7xK+Qwo
 XbZgueVN4V/7g44qtSm20hbK4xN7WJPyjq9JoEY+rGLaVtzaZkyuDfaHFqs94bPHy031faBAF6kEZLoDkQs+3Ixaov9KaMGo/GOcc02EpTzEOsqn385IsHkFd9raZE2dQwjZHs60ZqchDV4LwCO4huBgNa/N6aJ3kj1K5hTIPsrw0LAhRr+FVTOZuTg4/nwofZjgTkZtutgZhEO+PHF2LAWQxr9DNIycQeUlX+9uXo8YEGPFI6szZzY3DD7lgK8cu1yJRMpikDUKWO0A8Uw6BjXZNuA0xPw+hBPejnAZGOOZbzS/8OMSa3RY/95zjJFvhA5xC7bC6VyAMYa09rwAEKXP4RoBlvLsJ3b34zvN00Jr3BCO1RVElv8NbXL+0U4H/63xDl6LDqMTZ87dRsi949BtazXjCIrlOaIEGRAku/dvBfNdZUs35GdlaJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ linux-coco, Suzuki (for the arm64 behaviour)

On Thu, May 21, 2026 at 01:58:34PM -0700, Kameron Carr wrote:
> In confidential computing environments (arm64 CCA, x86 SEV/TDX), guest
> memory is encrypted by default and must be explicitly transitioned to a
> decrypted/shared state for host-visible access.  Calling
> set_memory_decrypted() on a vmalloc address is not supported, and not
> recommended as it would be inefficient to decrypt the pages after they
> have been mapped.
> 
> Add vmalloc_decrypted() and vzalloc_decrypted() which decrypt pages on
> the linear map before creating the vmalloc mapping via vmap(), so
> physical pages are never mapped with conflicting encryption attributes
> across aliases.  A new VM_DECRYPTED flag marks these allocations so that
> vfree() automatically re-encrypts pages before returning them to the
> page allocator.
> 
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Link: https://lore.kernel.org/linux-arm-kernel/ZmNJdSxSz-sYpVgI@arm.com/
> Signed-off-by: Kameron Carr <kameroncarr@linux.microsoft.com>
> ---
>  include/linux/vmalloc.h |   7 ++
>  mm/vmalloc.c            | 163 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 170 insertions(+)

There are a few Sashiko comments worth reviewing:

https://sashiko.dev/#/patchset/20260521205834.1012925-1-kameroncarr@linux.microsoft.com

[...]
> +/*
> + * Re-encrypt the linear-map alias of all pages backing a VM_DECRYPTED area.
> + * Best-effort: on per-block failure the loop continues so as many pages as
> + * possible are returned to the encrypted state.  Pages that fail to
> + * transition are left out of area->pages and leaked.
> + */
> +static int vm_pages_encrypt(struct vm_struct *area)
> +{
> +	unsigned int nr = 1U << vm_area_page_order(area);
> +	unsigned int i;
> +	unsigned int leaked;
> +	int ret = 0;
> +
> +	for (i = 0; i < area->nr_pages; i += nr) {
> +		int err = __vm_pages_enc_dec(area, i, nr, true);
> +
> +		if (err && !ret)
> +			ret = err;
> +	}
> +
> +	leaked = vm_compact_leaked_pages(area);
> +	if (leaked)
> +		pr_warn("vmalloc: re-encryption failed, leaked %u pages\n",
> +			leaked);
> +	return ret;
> +}
> +
> +/*
> + * Decrypt the linear-map alias of all pages backing a VM_DECRYPTED area.
> + * On failure, the already-decrypted prefix is rolled back to encrypted.
> + * Pages that fail either the initial decrypt or the rollback re-encrypt are
> + * left out of area->pages and leaked.
> + */
> +static int vm_pages_decrypt(struct vm_struct *area)
> +{
> +	unsigned int nr = 1U << vm_area_page_order(area);
> +	unsigned int i;
> +	unsigned int leaked;
> +	int ret = 0;
> +
> +	for (i = 0; i < area->nr_pages; i += nr) {
> +		ret = __vm_pages_enc_dec(area, i, nr, false);
> +		if (ret)
> +			goto rollback;
> +	}
> +	return 0;
> +
> +rollback:
> +	while (i) {
> +		i -= nr;
> +		__vm_pages_enc_dec(area, i, nr, true);
> +	}
> +
> +	leaked = vm_compact_leaked_pages(area);
> +	if (leaked)
> +		pr_warn("vmalloc: decryption failed, leaked %u pages\n",
> +			leaked);
> +	return ret;
> +}
> +
>  /**
>   * vfree - Release memory allocated by vmalloc()
>   * @addr:  Memory base address
> @@ -3457,6 +3554,9 @@ void vfree(const void *addr)
>  		return;
>  	}
>  
> +	if (unlikely(vm->flags & VM_DECRYPTED))
> +		vm_pages_encrypt(vm);

I think we still have the vmalloc aliases at this point as we lazily
reclaim them. We should call vm_unmap_aliases() before
vm_pages_encrypt(). It matches the x86 __set_memory_enc_pgtable() as
well with the explicit call to vm_unmap_aliases().

The vrealloc() path may have some issues as well but I haven't looked in
detail. Not sure it actually re-allocs decrypted pages. The simplest is
to reject vrealloc() for such vms until we have a use-case.

> +/**
> + * vzalloc_decrypted - allocate zeroed virtually contiguous decrypted memory
> + * @size:    allocation size
> + *
> + * Like vmalloc_decrypted(), but the memory is set to zero.
> + *
> + * Return: pointer to the allocated memory or %NULL on error
> + */
> +void *vzalloc_decrypted_noprof(unsigned long size)
> +{
> +	void *addr;
> +
> +	addr = __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
> +					   GFP_KERNEL,
> +					   pgprot_decrypted(PAGE_KERNEL),
> +					   VM_DECRYPTED, NUMA_NO_NODE,
> +					   __builtin_return_address(0));
> +	if (addr)
> +		memset(addr, 0, size);

Talking to Suzuki, the small window between set_memory_decrypted() and
memset() potentially exposing stale data is safe, at least for Arm CCA
as the memory would be scrubbed (there are other places in the kernel
where we do something similar). I assume that's also the case for other
architectures, although not sure what pKVM does.

-- 
Catalin

