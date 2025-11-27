Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CB9CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 21:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974D16B0024; Thu, 27 Nov 2025 16:38:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94BF16B0029; Thu, 27 Nov 2025 16:38:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888AA6B008A; Thu, 27 Nov 2025 16:38:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 739E96B0024
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:38:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 057B2139F3F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:38:06 +0000 (UTC)
X-FDA: 84157700172.04.5B8E92F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 71E8818000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:38:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e30rOSDi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764279484; a=rsa-sha256;
	cv=none;
	b=lBpXtYZs+qdRGAuXXEWOP9/uyM8y1K4GBto13FCw6NjBkPyXfuf5KWTjOE8BhG2akDPJ0v
	avfed3rcHDE4EWYHuDc1n0braYHJVFIrkvmM2bbAZaYsuFsdyuUWAz9PHWoeLj+s7qSR/N
	gkmGVgqEQiFy8MN/cV5nO7dVqT83wag=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e30rOSDi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764279484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dR8waj0jkCRLvS+bHZRtWT4CHgPSjWCnOOWgXkWJ/pw=;
	b=D90jCn36wf9l3moHFgHhV1sLa01f8FIaG1cOOueLCfU8YVdufogs7kOypguMinlOEjT+fr
	kBl+sN6OYfryFH8YpXi4i24sgXeP+ZleIwFR820IpI2of51uUgK62ZEpwQsy9ZUFeNgirG
	6kgurl9foKEB3/ZUD2AK/HWycyExVYY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB0A760242;
	Thu, 27 Nov 2025 21:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C67C4CEF8;
	Thu, 27 Nov 2025 21:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764279483;
	bh=J/Cd6H6DLpMMXY1wyttaMvCbQYILdLOCg4qVpGR/P3c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=e30rOSDiIWlFkeJGoC6FSrfKFIV3ptx1axChrCfvSfpxBMreVwGBiCEuuvRwlb7g5
	 YPmAWAXLs494R51+c+p8IKr5sE+g45KoJAf4Wcc52k1jKRHIL3TfHw5+L5bG4ehp2f
	 kNjVG5nwvjgyXyf6nWsH5IQa21z6HgCC8n7t58fMrfkivkm6EEgQKqsQXOEuDcSkX1
	 p84Ea2jueBwKx6c2nPIfx88wt6FsUyZ8vMddY6WMdrnpclPQABdzt8wurozv7t/e7N
	 Uk9YdEN6o5sJWEitfSnpSSNTD6on63sOYcHJvfjZUpEyFyTtmyhyXe4kLIxdWvAl8D
	 UN2wH2lefe+Ig==
From: Pratyush Yadav <pratyush@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: rppt@kernel.org,  Andrew Morton <akpm@linux-foundation.org>,
  kas@kernel.org,  changyuanl@google.com,  graf@amazon.com,
  leitao@debian.org,  thevlad@meta.com,  pratyush@kernel.org,
  dave.hansen@linux.intel.com,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
In-Reply-To: <20251127203724.3177621-3-usamaarif642@gmail.com> (Usama Arif's
	message of "Thu, 27 Nov 2025 20:33:20 +0000")
References: <20251127203724.3177621-1-usamaarif642@gmail.com>
	<20251127203724.3177621-3-usamaarif642@gmail.com>
Date: Thu, 27 Nov 2025 22:37:55 +0100
Message-ID: <867bvbyx58.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71E8818000C
X-Stat-Signature: quugssb14uopifuczfqespiqb7g1kyxx
X-Rspam-User: 
X-HE-Tag: 1764279484-615564
X-HE-Meta: U2FsdGVkX1+OBNs7XXOmlxnXPzC1LC4SSDDEMweP4o8dtMda6qHVpZ/JpMI4kZnsL8zdKpWjO6QoLWc6hYRfkzsZuJ+ikLmWoQ54HGIcLQjU4Z045bZn00UHNuuOIPgghnyGKEMMBRyHh1TcC1XlK4c5MkkorLqZUne+SUUzLxFg8FUY3T9ymtzbD8R3jhxhpFw1CAPjF0pu2famIYeuyZvYM7LY9BIFAbrRg1z5ouEcXY8WucsSd0/iGcrBXzJDcHk1KUSV2skZ5WyvzokMq8Arn9Y9QnzmM3L3/ylAiZIGZOC9nAQAvbeDQLwXqksvQn0sbuzaVYPAYm5j6Ncb5Q3o7be1tZExE2JT/OKceTYGDfvQYTUQW1sBR9hm0A1F7FKP1km5L+3Zvks/JgpBGI9QS+tErXbIkyFkqIPTP42VSeAELMNrAkm73matJ3p/mOIJqa/Ed+UrsrYjoeD6H3YQftXGQoMseqg2xzAOAURpjkgWYfsow7c4R8sdiUiqTYrD8MT8ZCgVxJIJnicPJX7Mr50ENazlaEjIZX8A4Sf3MgmFa20SneZoWCP3O+P0mv5WdgwgOn1cJh2LNkgEicflFRfrXJiHDPbuQTwtQuyV4bj0AJCC3xQW556OqPMDHsoQzYA2r6atd6UgQqK6jdxziPz4UUAdrOWI009V5ccx54gZf8Zk52NdW4rllK66YCGSF5In72cS6AImZziw3UQEhdWSgY/X9TjUtKDQ1bY5wBIut4tBEwy74Fe1NMEfiAK1NuGqA3FCEfmVAa1hpx2arCT0BgeyyNnhHFw0HVjUOIIzSZtD2zxgHOYvh3ByNCwdf7c9HH173SKQbfIGOx7iYiN1qVEz5Mm7NWvK+3vf21yuB9FG1g3CmvGPyiOX9LPXel0YWoU33Pvy2qgoiO8JqCu4PuXAPOPjXiYZl5cpJ6NSsv3ferzikhGq9Rz+2x4lfwd54NZdWkzDZmT
 mnuezGCC
 DAq3ShhJTU9CQIBO+uzlUvDoCWnDoH3W2ofp6vYKDFHSrsM9tdn5sxU/D2GIb3tJmNSCds4F+X/8ZPcGemzaOZVNXuTMDAxiuZkX8kU8/yu8JUn9ekMYtOyWay+NXEP+0srx3pAqL70m1apVEhemRikpfSuO7cNui33fOrwPXdTTwNz4gUTsb0lVYS3bQfSld9Mfb00cFa1RKqhXcKLTjKw8HvWQGxc0rnklMb3Hw4Hbl5djrBNAMnUSETtw4D1gw9o/mSGVO7BsQSvmEew2N6/Z2dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27 2025, Usama Arif wrote:

> The scratch memory for kexec handover is used to bootstrap the
> kexec'ed kernel. It is only needed when CONFIG_KEXEC_HANDOVER
> is enabled and only if it is a KHO boot. Add checks to prevent
> marking a KHO scratch region unless needed.
>
> Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
> Reported-by: Vlad Poenaru <thevlad@meta.com>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
>  mm/memblock.c | 74 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 30 deletions(-)
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 8b13d5c28922a..8a2cebcfe0a18 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1114,36 +1114,6 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>  				    MEMBLOCK_RSRV_NOINIT);
>  }
>  
> -/**
> - * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
> - * @base: the base phys addr of the region
> - * @size: the size of the region
> - *
> - * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH will be considered
> - * for allocations during early boot with kexec handover.
> - *
> - * Return: 0 on success, -errno on failure.
> - */
> -__init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
> -{
> -	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> -				    MEMBLOCK_KHO_SCRATCH);
> -}
> -
> -/**
> - * memblock_clear_kho_scratch - Clear MEMBLOCK_KHO_SCRATCH flag for a
> - * specified region.
> - * @base: the base phys addr of the region
> - * @size: the size of the region
> - *
> - * Return: 0 on success, -errno on failure.
> - */
> -__init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
> -{
> -	return memblock_setclr_flag(&memblock.memory, base, size, 0,
> -				    MEMBLOCK_KHO_SCRATCH);
> -}
> -
>  static bool should_skip_region(struct memblock_type *type,
>  			       struct memblock_region *m,
>  			       int nid, int flags)
> @@ -2617,12 +2587,56 @@ static bool __init reserve_mem_kho_revive(const char *name, phys_addr_t size,
>  
>  	return true;
>  }
> +
> +/**
> + * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
> + * @base: the base phys addr of the region
> + * @size: the size of the region
> + *
> + * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH will be considered
> + * for allocations during early boot with kexec handover.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +__init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
> +{
> +	if (is_kho_boot())
> +		return memblock_setclr_flag(&memblock.memory, base, size, 1,
> +					    MEMBLOCK_KHO_SCRATCH);
> +	return 0;
> +}
> +
> +/**
> + * memblock_clear_kho_scratch - Clear MEMBLOCK_KHO_SCRATCH flag for a
> + * specified region.
> + * @base: the base phys addr of the region
> + * @size: the size of the region
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +__init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
> +{
> +	if (is_kho_boot())
> +		return memblock_setclr_flag(&memblock.memory, base, size, 0,
> +					    MEMBLOCK_KHO_SCRATCH);
> +	return 0;
> +}
>  #else
>  static bool __init reserve_mem_kho_revive(const char *name, phys_addr_t size,
>  					  phys_addr_t align)
>  {
>  	return false;
>  }
> +
> +__init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
> +{
> +	return 0;
> +}
> +
> +__init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
> +{
> +	return 0;
> +}

Nit: I don't think we need the alternate version here. When
CONFIG_KEXEC_HANDOVER is disabled, is_kho_boot() is

	static inline bool is_kho_boot(void)
	{
		return false;
	}

So the above functions work for both cases.

I would prefer to not have two variants, but I don't think it is a
blocker. Up to you.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>  #endif /* CONFIG_KEXEC_HANDOVER */
>  
>  /*

-- 
Regards,
Pratyush Yadav

