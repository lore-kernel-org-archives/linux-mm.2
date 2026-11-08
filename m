Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E66606A334
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Th5tIDew
Received: by kanga.kvack.org (Postfix)
	id D84816B05B3; Sun,  8 Nov 2026 06:05:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B7E6B05B4; Sun,  8 Nov 2026 06:05:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71706B05B5; Sun,  8 Nov 2026 06:05:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E80A6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:05:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECD9480474
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:05:24 +0000 (UTC)
X-FDA: 85411670568.16.78C0B51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41706140006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:05:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Th5tIDew;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794135923;
	b=SYMMPupmjDP1yJMRZ2As1fALqu9VpC/Ewda6g+QRjTwi+QZaLbE2T/FgDjTeY5o9IO0gRt
	Nl9pD7bLD2sz8pMRnL/mQQpDgjbvXgvVAGZdoNHUQNoCRyivYJfknqhH0VXH/fodhudVlS
	B/pZk7+7cUleF07KVSceWsZ30QNV0DY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Th5tIDew;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794135923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GTPSw8yoiId+WhJTx6l9BtpcfJ94gwfuNXWiBrjWA4=;
	b=fEXIGG9eH30oVgLa1o4VugWRPSt8p/TtTDrfPVO/m6HxaYpmL3fXnJy0h1ki6fxJGHMpXr
	/ZtcI1TLwLoHYW7JVhfUSKylzJJ4gz3YfH1NPTKC+dMsZ4ppE3dwmMLa7wpwyKYB1TFuAO
	a/Bt/JWC82/AIO74+UyxVyiZ+SOvpgc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACE1E42A06;
	Sun,  8 Nov 2026 11:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7741F1F0089F;
	Sun,  8 Nov 2026 11:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794135921;
	bh=5GTPSw8yoiId+WhJTx6l9BtpcfJ94gwfuNXWiBrjWA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Th5tIDewprZendX4fGigw2vL+8B1sr/APy/gtFAfVfQbS6Lk2IhTZpZA5WLxIvgtJ
	 j/L5UqaKKe48k3fkMYGmV6bII35mRZZbn6CwZnuzuiCAzemSUUXvNoELHQ2ONuX4iL
	 UTro6N5WVRrvVYbuoHwHPeoK3huWHGz9+LEO25VRTXpW3BkKMf5L0mJDWuZFvZCaLp
	 rQIs2ITzWhuEBZJtF9A+ErJoBM+350SBMkJ6vpoNJHIa18H8plUq/3CaNZWmHMywZd
	 VKrluIioL8pbB880mGbp917rCZDAWn59BtwIBa7rEcyQJRC3/MQeiSi2IX/BKMHJSb
	 gTOT1W1JropBQ==
Date: Sun, 8 Nov 2026 13:05:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc: robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	m.szyprowski@samsung.com, robin.murphy@arm.com,
	baoquan.he@linux.dev, pasha.tatashin@soleen.com,
	pratyush@kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, kexec@lists.infradead.org
Subject: Re: [PATCH 3/4] mm/cma: reject CMA areas that overlap the kernel
 image
Message-ID: <avBXZ8iW2XPyVbmF@kernel.org>
References: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
 <20261103162429.2053989-4-radhey.shyam.pandey@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103162429.2053989-4-radhey.shyam.pandey@amd.com>
X-Stat-Signature: ugea76cuegjwnffu1jee9mb9a55mnhxj
X-Rspamd-Queue-Id: 41706140006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794135923-260342
X-HE-Meta: U2FsdGVkX19Sgn34SClH2+AqCj+YjSYCukypVoZ7FAyYfgo1IiE3ugjmEek7V9c6qVUCnui+JMy7prFd17Xfr7n+ZFbweiQ1Cm8zgBpJlgc6IkaOXEwT+uNfVKqDB3pQHSCXL7NtVj50n0ZtinZWW9zSlEpAQZC0ZQIo1OZPpqFogMxM7XHnYywTH1zub9SNKROh+m/Z9HCaqcV+Nu+F/TmobQOTSvf73MsSrAm4fAQxNgQa6YGU5tx6jDrhL5y7nQ6Odcf30kGRdFfsGhZ1TPTH+wJ4+nlQYIOs81BzUXmb7s9ud3nmgmTOYMbH/oFvB1O83tnOUdUczDNvvBqTf6Gz99jXXp6avfWsBoKroqYomaQXiVcLmZUd6N3QQ293mVMNil0HEdaxZq6j0LuY3fce0xChuoK07XhfrMJ9XnFokUCaEHbHYvcgJyLCR/L1C6v46KgtBXbSrbkqbSpW4rGzL9Wg8VI9bAO1/wtls+5xbQ+rF+F6eOmM5rYezWrz4pGVSK6PZivq17MzQlmVDdtyZ/uPYXizK2eWsC+LYY/C6mQu9qJRdR0BgcDWE1dpWuIp99TuFgWXaJYzGHwJZvCRrMdo7nQLKKtbUFH4WYH4rFkvbcnU9ImMqsmgJ7NjLbPUTxcrblJwGPRbyJcCErFUEpnpkngyaU5d5lBSbkl1JKaPqFXC3Gvqxb3RLkm/+vNWbZ5FLFspVAt+5ghtmBVKaATnFUMf7Jb7Ct2amogshD2jV5xitV0cWdLISYdhzzqjdYNhFZFf0kTjW+xQaNx3pIXELKgtk81CUboOmgmpYVxHCOhAQ287YwXjhadBKtET4wn4ak9+XTRQQ0AT+2hfdVa/Msv81Aa5uWZqsO9uRUI672kOHfBxd15JbHFEtevaKP+D5+5uBixhrYFUWexXI7JXJuElL4wwelU+dGK8Rk0xE4w+sQDaz6j+DT5S3OxDO3WItfcAHRbTcuK
 vxpioigm
 E4ycQTVL8HYnDHuW2bcV5F3R1DMS9kTOsPMvNPmocztK+rTsIVRBZfWe/lFUtJrq7mwnHE0qdr41OOfo6AAxKLo8jk3EHY3JjrHY1GsmWp+tUubKvgVzmeu9alAzEWbZxfOr8fr0TA4TKilsNtqhffL2RYz6g7/q+GRrHrVBuU9bIyvGpSIl+t3QWVrtHH2BpnfmB+UkHmt59MmF1lfoubN/b8j/ZBs9itsZS/gbApbUibhPhVG9VfgwU+VoK1H4yCuOFkGuairzLmSzeOM7mnDm2gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Tue, Nov 03, 2026 at 09:54:28PM +0530, Radhey Shyam Pandey wrote:
> cma_init_reserved_mem() takes a base chosen by its caller and only requires
> that the range already be reserved, so an overlap with the kernel image is
> indistinguishable from the normal case. cma_activate_area() then clears
> PageReserved on those pages and frees them into MIGRATE_CMA, overriding the
> memblock_reserve() of [_text, _end), so live kernel text reaches userspace.
> kexec reached this until the fix this series builds on; a device tree
> placing a shared-dma-pool over where the bootloader loaded the kernel still
> can. Reject the overlap rather than let such a caller corrupt the kernel.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> ---
> Changes since RFC:
> - Drop Pratyush reviewed-by tag as there were few changes.
> - Trim the commit description.
> - Drop the redundant comment as suggested by Mike.
> - cma_overlaps_kernel_image() is kept as helpers in asm-generic/sections.h
>   are virtual-address helpers.
> ---
>  mm/cma.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 9c53b2b70dc8..3231a53161cd 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -31,6 +31,8 @@
>  #include <linux/kmemleak.h>
>  #include <trace/events/cma.h>
>  
> +#include <asm/sections.h>

You probably don't need this.

> +
>  #include "internal.h"
>  #include "cma.h"
>  #include "mm_init.h"
> @@ -68,6 +70,16 @@ bool cma_has_dynamic_base(const struct cma *cma)
>  	return test_bit(CMA_DYNAMIC_BASE, &cma->flags);
>  }
>  
> +static bool cma_overlaps_kernel_image(phys_addr_t base, phys_addr_t size)
> +{
> +	phys_addr_t end;
> +
> +	if (check_add_overflow(base, size, &end))
> +		return true;
> +
> +	return base < __pa_symbol(_end) && __pa_symbol(_text) < end;
> +}
> +
>  static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
>  					     unsigned int align_order)
>  {
> @@ -295,6 +307,15 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>  	if (!size || !memblock_is_region_reserved(base, size))
>  		return -EINVAL;
>  
> +	if (cma_overlaps_kernel_image(base, size)) {
> +		phys_addr_t text = __pa_symbol(_text);
> +		phys_addr_t end = __pa_symbol(_end);
> +
> +		pr_err("area %s (%pa, size %pa) overlaps kernel image [%pa-%pa]\n",
> +		       name ?: "(unnamed)", &base, &size, &text, &end);

We don't want to expose addresses of the kernel image.
I'd drop text, end, and probably even base from the printout.

> +		return -EBUSY;
> +	}
> +
>  	/*
>  	 * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
>  	 * needs pageblock_order to be initialized. Let's enforce it.
> -- 
> 2.44.4
> 

-- 
Sincerely yours,
Mike.

