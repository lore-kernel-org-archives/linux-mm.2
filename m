Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B80CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2578E0011; Wed, 20 Aug 2025 04:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B790F8E0007; Wed, 20 Aug 2025 04:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E338E0011; Wed, 20 Aug 2025 04:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95EAC8E0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:10:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 442A58349F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:10:04 +0000 (UTC)
X-FDA: 83796412728.18.67CD7D0
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id 99D6D1C0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:10:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nTvKw6Iu;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755677402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kU53JEnSe0Nw++617VLP4wrlRSYwLUGWBZDBSJ3y4E=;
	b=Vc9FabcZUDTOJ5lgW+XQIFkOv5MH58dCTqFxJuBMC7MN5K9BIXD3W5Z2RCyjLN+tltxYx2
	zL9As31lPs/rM3fdRKQmIxQc6otL50aGnV5H3fGGjUxwW2pqnvli3SPAA6E4eQg5kAuV+5
	GATdJnmvKcUZz6rFXnSIWAnbeO7cyGE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nTvKw6Iu;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755677402; a=rsa-sha256;
	cv=none;
	b=E0Ny5c3xevylz57NpVbWPwyZuj8KetZHnVHM1lkxaVv+x/5ecBdoO+X1eWZBzdGlwlTeo5
	BBZP4IsZ+JzsNi7Q54K/XTSrmBeC2+PClnCiI/3YCXBdHwfsgOCVq7WTFgudMPDgBIu5fO
	UbyyzJnwCIKZRKV6t5Ehlh0ft0jDp6E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 7D8A15C5FDE;
	Wed, 20 Aug 2025 08:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762BDC113D0;
	Wed, 20 Aug 2025 08:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755677401;
	bh=ZwBIaVwfHe/T7WlfARZdRvpXDhB+IehKv0D+1cs2k44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nTvKw6IuGKUCM074ZO6HCTXEBhK8E5DzlI1NkU+TKjtyZQ9NfmN5Jc00uTv6/kKXa
	 hWwxb3f4bADolcJPjWJGnr7BlVGitV9WGRgHoVDov0n0e81rrltgT7ztXG6CCOadAR
	 A/9LHOmnMv4XoTm46Wi6wryYMO+yr1ndcmZ7Z4+cM94l/e5t+Tfq4j7t3XSGLaYVJe
	 hdsr2Cqlnz6j/nkCAU/SqzZhmd/08f79LP5yPzmavyUjM0kJD/Dz7lE6I9jr9jrSuU
	 BqR8XE6QJRoOvke2raPIVYoNu93YDKztyJOOABw4QkrKbpYxFS6kv6Yy/F9OwC7Q8C
	 AdL744Lg9k08Q==
Date: Wed, 20 Aug 2025 11:09:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, nh-open-source@amazon.com
Subject: Re: [PATCH v2 2/2] efi: Support booting with kexec handover (KHO)
Message-ID: <aKWC0c3kliee8gtu@kernel.org>
References: <cover.1755643201.git.epetron@amazon.de>
 <9e80381d4fafc71d6e0c64d69a8b3ac9c8949865.1755643201.git.epetron@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e80381d4fafc71d6e0c64d69a8b3ac9c8949865.1755643201.git.epetron@amazon.de>
X-Stat-Signature: n4nntmep39dbc6tjpa7m1coc9ocry3ay
X-Rspam-User: 
X-Rspamd-Queue-Id: 99D6D1C0003
X-Rspamd-Server: rspam05
X-HE-Tag: 1755677402-329238
X-HE-Meta: U2FsdGVkX1+ykaHAAE0fd5LDXAIkOLltSgKpAS+12Bh2jJxeXfWzcs4qWcQS7mimdv9SpyK6/ZJ8oxHdAFKTu8TJMe+k/2FLUefd33WkUD/tUU99D69xciXx1U1wH2h/62Wgq5FV0i23+k6YPHlTwl2qM6rpjxnnIJrfgMx1pB+LcBETFdlC7xc59b3xVBYXof+LTAGAQ11rx5zMro5TqFLbQndEljY1O2iFPhfc+qhgpE7/8O95umWvWcXOBaNlKQQ0PchN4ZsCeSvAvfIpYZ1wSsgiSI/7HMdsHaBdeV3oLDb/HvlwXUAOcvz8Daxi4j4g1DGFUVxHnQjogSaVCbRKcEsaHhPXitKcKGgRabeqMvzDTqDglnsFtHtRGpMJIOm3Q/0pHT8l6SoC/zxumB3WNAgDzB+6lTS+GGPPkzp/bzANrTE54DqtmnAw+98lso4/Nt0dcgTgHqb7+Fm1myeAN2Bxi7JbegObPvimvF146+XI20if4UBF8CxmQCaUymw3eq+THfLZM86hYg9lBDYj5VLApvlWCODxFSrnQXiGDRaXK9fbo1JYRNMb/x+lU6RfxN1A/NmzPLRD+1C1Jm1q5dkK5rp30g9gyu95zKNzaDmc7nJFlreAj0j9UaSEX4/SowmhAHBm8BC6Qm3AUf0Q2T+BePCZrvctztjHabolPXCPxaxBHP7OKQH7tmAuIa4WEqsn8jEPztQLhj4sKjSczwLI7W43fvzjSb4qNKm+E8OkPZmzg2IgHUpJlRmxhGI0ECnQIiirQkBghnK1F8URpBZolxCls+/If9lcYE1EHoCvu9PJGnVgQ5tQMUritMSsJLd7IIdX4E0NgD2uxjpm6pwmHGfT+jls1YJyiAE11HOeOv0ashVhqjBlo1JwFG6DIK25tZCF3P/2r8vndXTjy1RI3s8aZVR0f/Da6yE19YWBc7viee3LotM1o5LZ8+DcxXvWgaNCfXKxd29
 09WmWpMZ
 S8Lb9T2JeReQNUZEhOonrkZG4i8WGh0dRTw4uYdL13f2Hrob91jTUG4taP1RNiw1V657C+YV+aJrUfK5XYhbVON/TtOZc1SgN4+GKIszEJnzjcxDVtmhUo2mbSR8zBbJjV42Fn5mn2c2J5SyLdS9YzUj8dAmAb4Mn4oaqIfUNbHYK8rb9MKLoWyq38QMmKHwhiTof1C937S+VnpleTbh/fj321yatOpy24lVxEMbGH2fqu3+sSI3Zt69m5+GRHZJ664O2P+gSfv+tvLAqJ6IqRlime9MLh8lQi+CJFUtUEN2Fryt+FLHDLR6Zrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 11:22:46PM +0000, Evangelos Petrongonas wrote:
> When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
> early during device tree scanning. After kexec, the new kernel
> exclusively uses this region for memory allocations during boot up to
> the initialization of the page allocator
> 
> However, when booting with EFI, EFI's reserve_regions() uses
> memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
> rebuilding them from EFI data. This destroys KHO scratch regions and
> their flags, thus causing a kernel panic, as there are no scratch
> memory regions.
> 
> Instead of wholesale removal, iterate through memory regions and only
> remove non-KHO ones. This preserves KHO scratch regions, which are
> good known memory, while still allowing EFI to rebuild its memory map.
> 
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---
> Changes in v2:
> 	- Replaced the for loop with for_each_mem_region
> 	- Fixed comment indentation
> 	- Amended commit message to specify that scratch regions
> 	are known good regions
> 
>  drivers/firmware/efi/efi-init.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
> index a00e07b853f2..99f7eecc320f 100644
> --- a/drivers/firmware/efi/efi-init.c
> +++ b/drivers/firmware/efi/efi-init.c
> @@ -12,6 +12,7 @@
>  #include <linux/efi.h>
>  #include <linux/fwnode.h>
>  #include <linux/init.h>
> +#include <linux/kexec_handover.h>
>  #include <linux/memblock.h>
>  #include <linux/mm_types.h>
>  #include <linux/of.h>
> @@ -164,12 +165,31 @@ static __init void reserve_regions(void)
>  		pr_info("Processing EFI memory map:\n");
>  
>  	/*
> -	 * Discard memblocks discovered so far: if there are any at this
> -	 * point, they originate from memory nodes in the DT, and UEFI
> -	 * uses its own memory map instead.
> +	 * Discard memblocks discovered so far except for KHO scratch
> +	 * regions. Most memblocks at this point originate from memory nodes
> +	 * in the DT and UEFI uses its own memory map instead. However, if
> +	 * KHO is enabled, scratch regions must be preserved.

I'd add that KHO scratch regions are good know memory here as well. With
that

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  	 */
>  	memblock_dump_all();
> -	memblock_remove(0, PHYS_ADDR_MAX);
> +
> +	if (is_kho_boot()) {
> +		struct memblock_region *r;
> +
> +		/* Remove all non-KHO regions */
> +		for_each_mem_region(r) {
> +			if (!memblock_is_kho_scratch(r)) {
> +				memblock_remove(r->base, r->size);
> +				r--;
> +			}
> +		}
> +	} else {
> +		/*
> +		 * KHO is disabled. Discard memblocks discovered so far:
> +		 * if there are any at this point, they originate from memory
> +		 * nodes in the DT, and UEFI uses its own memory map instead.
> +		 */
> +		memblock_remove(0, PHYS_ADDR_MAX);
> +	}
>  
>  	for_each_efi_memory_desc(md) {
>  		paddr = md->phys_addr;
> -- 
> 2.47.3

-- 
Sincerely yours,
Mike.

