Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52777EA7941
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC786B0089; Wed,  4 Feb 2026 13:44:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA5E6B0092; Wed,  4 Feb 2026 13:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9116B0093; Wed,  4 Feb 2026 13:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 869866B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:44:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 308441B1AE5
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:44:58 +0000 (UTC)
X-FDA: 84407651076.13.0A9290D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 902D5C000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:44:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hbo8oTeR;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770230696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xE30DIF7aMl5fJFbfMHsATsjIo296bw/JVseiyW00cs=;
	b=2aDiCwQU8QRCUxPlqPfVQp1EO4xnSFPaN93K0HrPBpMeK2QQc5iEAaLq0ELJFmespjFN7u
	wF++b3zgIdX5zvn6CQ/oOn75IA9mPrjzsSeNppLGs/JBjz/mxBz8QdMP63VaAZMjUmETER
	uwN/+x3E8hYCqWVuOLhGd1QOG0ihyKI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770230696; a=rsa-sha256;
	cv=none;
	b=oUn0v6dRzfB36xf0XUBwn/CCxGqrB6Y48HV3PAI6yr9s6PxTdpYzx7c6mEklyPsO5pxEYv
	NG/dIkSfQLRZdu9J3UM/DUQW1LGYcgCeJ0UK+zD7NaXf/+uzwlhR8RJcIZEm2Rm+IrHcNf
	iSRgLGiVIAJ6We+XampGc4XYRRRqHHc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hbo8oTeR;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 83F3360010;
	Wed,  4 Feb 2026 18:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9977C4CEF7;
	Wed,  4 Feb 2026 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770230695;
	bh=sxzUvwz2+H6f2P/hcewo6WsZzK2JbK2OdANari5N7ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hbo8oTeRLq/G0/qNbB7YGWd3dqSCmtSDilBsD797FE8yTqU3sx0WcQ0oS9XbIIpUE
	 A1GWb4UWvEa2lM04K4NCr3r7qRI9cmv98vwCQgZVTms9IFLwe+y25M2E08EtQ5kXvU
	 TK/vUY9zjpNsqyq7VdV5gTZWHbI/+OiaQc22SSNijzPlesacMt+VEYZrtf5A9XAjj8
	 64ZUmYp1Uo1yret9r+Dq7qgLLV/WTAto0tXRshAdik+sxBzHCbBTvB711h3J8tuCnf
	 qjZNADObhwdt7CptI8g+ytiqygIxaDnlT0aWUKMEA2VDySzXf4rLHFIODj+3H4tvZv
	 xAjV+tyoF8VQg==
Date: Wed, 4 Feb 2026 20:44:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <aYOToJvAUU0dmW94@kernel.org>
References: <20251216084913.86342-1-epetron@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216084913.86342-1-epetron@amazon.de>
X-Rspamd-Queue-Id: 902D5C000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: pr9up8jno7maunpn8dymyp9qeaaumcue
X-HE-Tag: 1770230696-109607
X-HE-Meta: U2FsdGVkX1+YOz7D7ivkd9JpmJgwnib4jbxiCD3CQlXfnQAM6jkpsezSIY10QZ2WXLwcyE50Qb3ye9VYNOScicjI/Wdn3oaiqIwNCwIdiGB1prMP2z1NuBaUAkJnWtk17SfKyyBYWBE1xTOCOjFpO0M6z7ytVUyeYLh+QKwAAuZH+FO+12UpHLvJMedA36Bno9X4lE1uLW8FGskEq2saurU0CE0UJ4ERKSSGP+ZHc+2r8mIni3zmhfILG2tCFWml/sLmuq/EoQgvj/LOdivgHjqWv4uAMwLmKMmRD7AaB/oox8FyfOYs8ggU5vcXyVhrU1f1ziwAfrmhq8TGpTP4VAxiaRfCwF6ZRZ0kOrlS4sko59+xGjzs2adUtNBdGm6S+FA01EQ4vNvymeDY8mjwsnZoRf1WI0ncTvGVMthTdnf4P0wzLa3rtLDtlj1/rj6e644eZ4BOcFlb03yuXdfz80HRGMMikuN8o8vOl2YChOKROlLFDqcCMXB933WgjqOLHXCwq4rP+K0A1GfAGs6Fj9iPQEz4UvNi+Z/Pq/DONJ4uD82lGz/0PQv9RB5HgeAz2gzplH4Bw7QkpT/5Yvo4dqAKqQXJQOLTcDcqgrBFpSYjUZwOfTBQQ5XYMVgXev+xb8u/m4bGE9Oau9v7BoKSrrS8Tz0Muk5OmQDFrF1Cke9kQN9u3n5Tds9MKMU5dMI6VeN4VCxV0U44JgRgKHcrqKIdbGLPCIpFlLm9U0BToKOUYDSVNYrrm/MSu8GIgmI+S+iUH29nS/H3NDLTG4bnGiHbAsB/+RElYZXBGKR5db9rm9rNeHvBOfBHyfwD8eHitwaDplEY+OBAPHe8BcfYA07o0gFPGN2HhgRSel8TfNBkKUUHJUQtn9gPqAbw4gnvevVknpuP++cAJB1Sb55pcsWQyiVmZ7razXlwMJo6FJdddLqNCut5VkQ0F+aIZ2CgEukvsRZXnEsZU1RwSdM
 0eHnxEaO
 U/YoKA8CLuTdbrZmMQVJWmDUdCOmqPsHcvtdpeiF3SfUGvV6ZVkVsF2GMZFNPHKzVOUL8IWkgx2Z7OpAxR50H5beF1JFpUFlKEYJpVDTo9bNnjpud6+D4PQPaDzBl8u9H19gqr4X9DJU78Ef85PGKikr4ELH1Z4S3Z/y/VdDt22YVtmgMIMaS1V1qIyfQ6kRYoz/lrG8x+yiDAxi1H5mv11dMGsAXE8bHaX4SRDaRzMvSQl7DL54+VOX7qFwhw6dfILxg29Ou0CA8/ME8HzLAd7QXapMQoSAmxDmjB4lnvaq6a4uaGeJzBj6M6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Evangelos,

Are you planning to send a v2?

On Tue, Dec 16, 2025 at 08:49:12AM +0000, Evangelos Petrongonas wrote:
> When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page
> initialization is deferred to parallel kthreads that run later
> in the boot process.
> 
> During KHO restoration, `deserialize_bitmap()` writes metadata for
> each preserved memory region. However, if the struct page has not been
> initialized, this write targets uninitialized memory, potentially
> leading to errors like:
> ```
> BUG: unable to handle page fault for address: ...
> ```
> 
> Fix this by introducing `kho_get_preserved_page()`,  which ensures
> all struct pages in a preserved region are initialized by calling
> `init_deferred_page()` which is a no-op when deferred init is disabled
> or when the struct page is already initialized.
> 
> Fixes: 8b66ed2c3f42 ("kho: mm: don't allow deferred struct page with KHO")
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---
> ### Notes
> @Jason, this patch should act as a temporary fix to make KHO play nice
> with deferred struct page init until you post your ideas about splitting
> "Physical Reservation" from "Metadata Restoration".
> 
> ### Testing
> In order to test the fix, I modified the KHO selftest, to allocate more
> memory and do so from higher memory to trigger the incompatibility. The
> branch with those changes can be found in:
> https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
> 
> In future patches, we might want to enhance the selftest to cover
> this case as well. However, properly adopting the test for this
> is much more work than the actual fix, therefore it can be deferred to a
> follow-up series.
> 
> In addition attempting to run the selftest for arm (without my changes)
> fails with:
> ```
> ERROR:target/arm/internals.h:767:regime_is_user: code should not be reached
> Bail out! ERROR:target/arm/internals.h:767:regime_is_user: code should not be reached
> ./tools/testing/selftests/kho/vmtest.sh: line 113: 61609 Aborted
> ```
> I have not looked it up further, but can also do so as part of a
> selftest follow-up.
> 
>  kernel/liveupdate/Kconfig          |  2 --
>  kernel/liveupdate/kexec_handover.c | 19 ++++++++++++++++++-
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index d2aeaf13c3ac..9394a608f939 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -1,12 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  
>  menu "Live Update and Kexec HandOver"
> -	depends on !DEFERRED_STRUCT_PAGE_INIT
>  
>  config KEXEC_HANDOVER
>  	bool "kexec handover"
>  	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
> -	depends on !DEFERRED_STRUCT_PAGE_INIT
>  	select MEMBLOCK_KHO_SCRATCH
>  	select KEXEC_FILE
>  	select LIBFDT
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 9dc51fab604f..78cfe71e6107 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -439,6 +439,23 @@ static int kho_mem_serialize(struct kho_out *kho_out)
>  	return err;
>  }
>  
> +/*
> + * With CONFIG_DEFERRED_STRUCT_PAGE_INIT, struct pages in higher memory
> + * regions may not be initialized yet at the time KHO deserializes preserved
> + * memory. This function ensures all struct pages in the region are initialized.
> + */
> +static struct page *__init kho_get_preserved_page(phys_addr_t phys,
> +						  unsigned int order)
> +{
> +	unsigned long pfn = PHYS_PFN(phys);
> +	int nid = early_pfn_to_nid(pfn);
> +
> +	for (int i = 0; i < (1 << order); i++)
> +		init_deferred_page(pfn + i, nid);
> +
> +	return pfn_to_page(pfn);
> +}
> +
>  static void __init deserialize_bitmap(unsigned int order,
>  				      struct khoser_mem_bitmap_ptr *elm)
>  {
> @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned int order,
>  		int sz = 1 << (order + PAGE_SHIFT);
>  		phys_addr_t phys =
>  			elm->phys_start + (bit << (order + PAGE_SHIFT));
> -		struct page *page = phys_to_page(phys);
> +		struct page *page = kho_get_preserved_page(phys, order);
>  		union kho_page_info info;
>  
>  		memblock_reserve(phys, sz);
> -- 
> 2.43.0
> 
> 
> 
> 
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597
> 

-- 
Sincerely yours,
Mike.

