Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE9C606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b47bOC/3
Received: by kanga.kvack.org (Postfix)
	id 1F0786B05B6; Wed,  4 Nov 2026 11:29:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7FE6B05B8; Wed,  4 Nov 2026 11:29:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDF76B05B9; Wed,  4 Nov 2026 11:29:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFE806B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:29:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62CABC07AC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:29:54 +0000 (UTC)
X-FDA: 85397973108.05.3814BAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B49F4180006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:29:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b47bOC/3";
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793809792;
	b=Ow6MJXIxGZhkSbZnmt2/TIS8qDi82kaEWFxF9pDoQO/6X45krgz+krNFld5MHvBGA0+LKX
	S1W5RtSMqYUFhYdRWDllw5dNAYs8mrrKjDNMZJn0PEerc9F2gqRQupndC120aNoYO9SEEy
	b4xNbRkYWVSDrsOs2o0sUVqtrFLwvVs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b47bOC/3";
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793809792;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atDiQ1jLywCaP3AyVEImB+gZltQy0V8BagrbxL0rfyY=;
	b=nFucP0njPyBHQ9zlmFbpL01LcTAMUFQJpPqKbd0J4clp9mpdvOiX0eqicG6zyboTT+9leA
	yOVjArO53Y1lsllCItk8DYcb7Z9u+WUoXf2hFaIUuwIkFSTfe51gj+NxkIkh8IOhjdAmac
	YKwr7wFT9YgFfdZXtUTrNe9kFqug27Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDA4D43B36;
	Wed,  4 Nov 2026 16:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E471F000C1;
	Wed,  4 Nov 2026 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793809791;
	bh=atDiQ1jLywCaP3AyVEImB+gZltQy0V8BagrbxL0rfyY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b47bOC/3A0RxnUdzrGef+aXOt5L92xLNPUSE5A24szrut0A3kwfnv5GWFo0Rmw85F
	 5Tdc/bfgkA1gTlKdM81tunrILY6eokjbGK+/nznxio0+VmOHSS6yWR/K4pch4WGfao
	 X2DC1SLRl6EPej/gADIMREih6WMk3VAUk1SsSnmcGdsSUZUeYeijaW8I5LxE64siT8
	 WKftT+EeRQuUm7+D6LB06kaL/XBI+8Rm8ri7O6/5letBBW2NOtTNrGUsp40RnchhhW
	 pjkd+4ixoPoxzTj4L9EZ3vouC5W4EmnsmzbuEWe1yrwmAZZnqWDTtJ310ri2gkvA1J
	 g0SZpdQQQjhYg==
Message-ID: <sashiko-outbox-197614@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] mm/cma: reject CMA areas that overlap the kernel
 image
Reply-To: sashiko-reviews@lists.linux.dev
To: "Radhey Shyam Pandey" <radhey.shyam.pandey@amd.com>, robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, m.szyprowski@samsung.com, robin.murphy@arm.com, baoquan.he@linux.dev, pasha.tatashin@soleen.com, pratyush@kernel.org
Cc: devicetree@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, conor+dt@kernel.org
In-Reply-To: <20261103162429.2053989-4-radhey.shyam.pandey@amd.com>
References: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
 <20261103162429.2053989-4-radhey.shyam.pandey@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:29:50 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B49F4180006
X-Stat-Signature: 4z9pw6iodp9ajyyeko9ea4iytnrgtzkf
X-Rspam-User: 
X-HE-Tag: 1793809792-524760
X-HE-Meta: U2FsdGVkX1/0qh0EOwW05VCic5YFYEBCzp5ued0ZbzALwTjgC1QdR11FCgpTxeU1HX+nI7ZMNrsfBssA/BJVrdDdVZ7eF2o/sQrYBlrmyQy2pgGvbB8I34mdUVrKtkImA+3U0WpyoL2ExM20rqbQLAiJ0AAlFv8dHal0dPtDCvlLUrhbPtWAB9ONtqsLae3B2XD3bXhTEc136uQOpWm/1mkfSPLyYhLyyULV8RVYkWqT2a4A6X8NRGfrPZNjEMkMZlgh4GdedDhHGLpfTvDjFKRF4Q7zrR4pW1vcv5pcJWN090uOIZGPiSHVVFaWy1j/Id2oKuwMyj10Gu1RiTGeGeH34h1k84wwMai0lYaQ/V8ok08Z7PBWEYrC3iHIBWfduvDMWraiAF4WDbHMDYyiz/uWW1xYcAHictGq1P0rAq3bSAsd8+IJ1fUFtLBY0CufGA6nHAMGd+PF6O5XEXoT7iKXe8wlsZhPSNix2ZRIubjM6B2jpcbVL/F0ep8ZZASN8alVS/4VAmzlMuosFwBTICgnhVx+Mcm7/F7PlaNx5zhVoS3BUDyslMfueBWz1QtvmxEokdB0euOtVjRpY7Htm2KjGZTIJ2Legx9+tT/x30XHF3jdYqZ1SPlwrI8RR6fP1XpUxsqZN9Nk9DCcH82aRbMauccb786FCzNpcr0tMUTl8aBeW9ulAoAEFX0O3ssXBq+fxaltxpreCKtj1ct5nQAMj72SIYvGm1a0/tDIWPm64wqWgir7ULfxEQSFmlxmPZSzmF4Kuq2fslw1KhJnSHTeaZZZszC0XdJOhjTmaKAA3vawTpB7zOi0X+1ZJRV1MCwP7quCVLtFW1euLyIWxNaYruo03nZQIl9JzrrfuS6yXnOeYWvoORiphjUuseC8n6soXsVNzsuyLYxMG2NhVHkJ6mwnY17TdsfCGWEWY1AyYEWIoY1QXg1RO4RkDkO7/I3R5b+ItN73JSxFdtQ
 uCxPOnTf
 UeA+3CF0C3rTMRYX3fY1dTgEpXQOLUoPvCs07IbsTDKApj1uXEiH8bvJOZIzlrEcR921pv3VeTDLsS0a52cCSWJJIO4m/Qnp6zTHLnzn81bEBh6k/rF87ydN/skP6/Wq8ZfCBWPMOrWPX67rdjkD3YmMNc+5w2Dt/i96a6ndPnAuOzQF1RzH3hnXJ8iqW7TFGpJzlRPoOxujsg6AQBgJKlaiQ6D0cW1+2m6aEJ+svHjAWd1L8VRgT0i9g1Jo2ugF73FQc05XUcdbTcxDtDXl4uw4qyL/+rwVQ3eAw6m8zc0Hqj2OPBD34r66dr+cDyCn+kIZ38ZxVMPjUm5q2ys+OGgIw1s1ZP6TLfRyPaFpx89hK/+voPoCOFzCXdsV0iy2c05s3UimOoYDdLe/gSohYND+fH5LvshBucGdQ6TmtxdARB5F/yhfL7Pk6v5yo9ksugDQj8LKaxh8ln74QRCrLGD9aNdS3Z0bf2hJJDRZVHnJXjbFpAnOKTC1th4zbdDqMalYnB7vRvRvdljXfWEXHtPz4uWHclW28IuRYqH9S3Aao31p52HdVreMbnsNRXIRhUrq8+qOCUlX0hR7qmFtH4JPSmpbmyyhof/cLDJ7LV64U/n+PVuO97RBpmHUNOdteFsf4uzHNqP3NTI5L6kfV6q34a3lGKuFpp7yUVM/Hvrqv/gnoieMqUlSCol/u5tGG2mUm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm/cma: __pa_symbol(_text) triggers BUG() on arm32 DEBUG_VIRTUAL
--

commit efca63a89d010b4bf63ea1571c8931374f2ec14d
Author: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

mm/cma: reject CMA areas that overlap the kernel image

This commit updates cma_init_reserved_mem() to reject CMA regions that
overlap the kernel image range [_text, _end) so that cma_activate_area()
cannot free kernel image pages into MIGRATE_CMA.

> diff --git a/mm/cma.c b/mm/cma.c
> index 9c53b2b70dc8f..3231a53161cda 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -31,6 +31,8 @@
>  #include <linux/kmemleak.h>
>  #include <trace/events/cma.h>
> =20
> +#include <asm/sections.h>
> +
>  #include "internal.h"
>  #include "cma.h"
>  #include "mm_init.h"
> @@ -68,6 +70,16 @@ bool cma_has_dynamic_base(const struct cma *cma)
>  	return test_bit(CMA_DYNAMIC_BASE, &cma->flags);
>  }
> =20
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
> @@ -295,6 +307,15 @@ int __init cma_init_reserved_mem(phys_addr_t base, p=
hys_addr_t size,
>  	if (!size || !memblock_is_region_reserved(base, size))
>  		return -EINVAL;
> =20
> +	if (cma_overlaps_kernel_image(base, size)) {
> +		phys_addr_t text =3D __pa_symbol(_text);
> +		phys_addr_t end =3D __pa_symbol(_end);
> +
> +		pr_err("area %s (%pa, size %pa) overlaps kernel image [%pa-%pa]\n",
> +		       name ?: "(unnamed)", &base, &size, &text, &end);
> +		return -EBUSY;
> +	}

[Severity: High]
Is __pa_symbol(_text) safe to call in architecture-independent CMA code?

In include/asm-generic/sections.h, _text is noted as architecture-specific:

    * _text, _data: architecture specific, don't use them in arch-independe=
nt code

On 32-bit ARM, arch/arm/kernel/vmlinux.lds.S places _text at the start of
.head.text before _stext:

    .head.text : {
        _text =3D .;
        HEAD_TEXT
    }

while arch/arm/include/asm/memory.h defines KERNEL_START starting at _stext
(or _sdata on CONFIG_XIP_KERNEL):

    #ifdef CONFIG_XIP_KERNEL
    #define KERNEL_START		_sdata
    #else
    #define KERNEL_START		_stext
    #endif
    #define KERNEL_END		_end

When CONFIG_DEBUG_VIRTUAL=3Dy is enabled on 32-bit ARM, __pa_symbol(_text)
calls __phys_addr_symbol() in arch/arm/mm/physaddr.c:

    phys_addr_t __phys_addr_symbol(unsigned long x)
    {
        /* This is bounds checking against the kernel image only.
         * __pa_symbol should only be used on kernel symbol addresses.
         */
        VIRTUAL_BUG_ON(x < (unsigned long)KERNEL_START ||
                       x > (unsigned long)KERNEL_END);
        return __pa_symbol_nodebug(x);
    }

Because _text is below KERNEL_START on 32-bit ARM, won't calling
cma_init_reserved_mem() -> cma_overlaps_kernel_image() with
base < __pa_symbol(_end) trigger VIRTUAL_BUG_ON() during early boot?

In addition, on 32-bit ARM with CONFIG_XIP_KERNEL=3Dy (where _text is linked
in ROM below PAGE_OFFSET while only [_sdata, _end) is in RAM) and on sparc64
(where [_text, _end) is linked at KERNBASE rather than in the PAGE_OFFSET
linear map), won't __pa_symbol(_text) also compute bogus physical addresses
for the kernel image?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103162429.2053=
989-1-radhey.shyam.pandey@amd.com?part=3D3

