Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 179C1103E2EB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 13:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2CA6B0088; Thu, 12 Mar 2026 09:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769656B008A; Thu, 12 Mar 2026 09:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C966B008C; Thu, 12 Mar 2026 09:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 589546B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:42:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAFD81C234
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:42:26 +0000 (UTC)
X-FDA: 84537525492.09.9A499FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6345B4000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:42:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LIsdol+r;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773322945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5air7rPX61a9DzVTvCEGhpCI90axRvY9YBliQtC0cZI=;
	b=Ev1zrsKmWdESknxbZoYIllLJoEgp0RuwcHe3k+OnCqmrFZMw2v5f4ZeuRGSeh44uMcAfR3
	mE7uUk9W9RsWlnuIfqd1f8iQlF7L68NVdOITBmM4zkB+PunIEvoIrJuJ2tyd1JrnbUTS4w
	rkElUYZNppWRdMM5N9JGcbQ74zDO7HA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773322945; a=rsa-sha256;
	cv=none;
	b=tMtPO+dYoY+OD2XDojBLejAbRLGa46Z1jiKJLOtUwtSXDNwLu+my08M0gkhf4q+YuFrsHd
	odHLohVpCdczzYkuRzy7L90Gk5WNeNksq5W22up/F/ujvplhL/yJ9p8f3pekzj8J6xg4ct
	PK7vb5UET0EaFA2lAUoWkuD/HnZMXLg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LIsdol+r;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 257A641781;
	Thu, 12 Mar 2026 13:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114DEC4CEF7;
	Thu, 12 Mar 2026 13:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773322944;
	bh=eTmkpSmT2S+/I17rer4Asjeia4g7cvefyQ7YglIs0XM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LIsdol+rX5bsYIBDrjwtqkR7A1ECQGNtXwdiaQMKjNTsq9eYyPayAE1gaNbbBTfFj
	 Cj6JBzQ7z7ljJDyipOf5RJoDEAxpNMtYVCANiT9tzUe84Yz3rrS0h2k6SIFOHM85+t
	 z5UrftzPDkPuCMt9PqS4bjM1qdIdUYZqy2998tt1/XKe1ODKe3mNa2d2wEzbe9MXL9
	 AydUPq5LPXxMRw5eHzhNV1Ji0OTTGZch665qw5b8+4NDU+gpLEAw+oihmeHyVeDP4K
	 +XBu5/G9eZa/Fc4TPKnxHe/IA2lB2k+7kCxhFPrHEf+gW3fcZ7tbfffcOmRlGRvCjg
	 q71TQps115pkw==
Date: Thu, 12 Mar 2026 15:42:17 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Hubert Mazur <hmazur@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Stanislaw Kardach <skardach@google.com>,
	Michal Krawczyk <mikrawczyk@google.com>,
	Slawomir Rosek <srosek@google.com>, Ryan Neph <ryanneph@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] mm: fix race condition in the memory management
Message-ID: <abLCuVgqKhWI6hcl@kernel.org>
References: <20260312131438.361746-1-hmazur@google.com>
 <20260312131438.361746-2-hmazur@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312131438.361746-2-hmazur@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6345B4000A
X-Stat-Signature: hzotukm6edos8f15eggdkoyzwzjn8qz7
X-Rspam-User: 
X-HE-Tag: 1773322945-62114
X-HE-Meta: U2FsdGVkX19jsvcB7NZtGFCfJNjtHWstyV1ABfDccfD5VcYHcWH4SxlS3qgTuzxv1JBW7JxpIKf8dRxerwv/0dQrGTP5Z79eXYza2n5NWRTFID+UdhESV0DXA7ItrJTak/7z5zNyGhd2CGP6529yvZ370Wl2LftgRzZxvgN7OwfVcAP1NRCg6AhlJipxGgJ6Lrjielmy4epbDuKLaWxHnODAM/JHnDaJY2RhOuoagD9xI7lLAnYKsGx7xpCP2rJ4nCIfi8iqscev1Yc2iQNOcBdxkDdt3JsybYahsEuolNy0cdPkx9c4edwrG9AqbN9EIByiqtGFkvY2mqrdKDQ2P+n/z9ESGnNHaqI3y3Og1xsm7eH3IhshysZfE4ZXWKcRKKB9TGDxp/UruDIye7lWmM7NY+9n5SpXnvBE6Rcg3F7/0mk6KoXRzirT+ptQbuxuwdjZd8tofW0imUgOoUbA7T49dYOdBqxaTH4dm7J83JgMDgpHG1/M2dvPr/YvxonJDk/ZjVxTks0XrnYxGbO4QgtF9UdNqu6a1b2pXAG4lBupKosNIpBcgFxva4Q412QdLAs+CJgV7RDMIPXDOtgRSRS4DTAwQ6avksFWX4+mJoGbIcdH9UZDzPzGvXTAaaDK5XT2YNxcfzmBOp/7iyeCbMZZDSyf7ZCAWlGX8b6J0Bo94xtm5rDW01Vpf7FSGYVkCjmuLjoc+Zrywwr7hvezm7r0GZCXoJcmeWOpR6Rkp5tPBh7X81Y+OeTda2PNAPgZGt5mXs5puw/qzpul22TKf3eHgSRHO5LM88LJTHizMTk8jpLxEh+37Ul4i1RwpZe6eJIY4GTuHOOjiNmnerR5Rc88gRahvWPwxX73BhTO16kySPNFxRDARPP74XqRiwmqifSavHd4pC/cXIy7WQ13KPXo1ezqPHbGSPIxvpkT+dpYo9vvThuyfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 01:14:38PM +0000, Hubert Mazur wrote:
> Subject: mm: fix race condition in the memory management

The prefix should be mm/execmem:
And this is not exactly a fix.

> When 'ARCH_HAS_EXECMEM_ROX' is being enabled the memory management
> system will use caching techniques to optimize the allocations. The
> logic tries to find the appropriate memory block based on requested
> size. This can fail if current allocations is not sufficient hence
> kernel allocates a new block large enough in regards to the request.
> After the allocation is done, the new block is being added to the
> free_areas tree and then - traverses the tree with hope to find the
> matching piecie of memory. The operations of allocating new memory and
> traversing the tree are not protected by mutex and thus there is a
> chance that some other process will "steal" this shiny new block. It's a

Does it actually happen in some environment or it's a theoretical issue?

> classic race condition for resources. Fix this accordingly by moving a
> new block of memory to busy fragments instead of free and return the
> pointer to memory. This simplifies the allocation logic since we don't
> firstly extend the free areas just to take it a bit later. In case the
> new memory allocation is required - do it and return to the caller.

It's hard to parse a single huge paragraph.
 
> Signed-off-by: Hubert Mazur <hmazur@google.com>
> ---
>  mm/execmem.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 810a4ba9c924..8aa44d19ec73 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -307,32 +302,35 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
>  	if (err)
>  		goto err_free_mem;
>  
> -	err = execmem_cache_add(p, alloc_size, GFP_KERNEL);
> +	/* Set new allocation as an already busy fragment */
> +	addr = (unsigned long)p;
> +	MA_STATE(mas, busy_areas, addr - 1, addr + 1);
> +	mas_set_range(&mas, addr, addr+size - 1);
> +
> +	mutex_lock(&execmem_cache.mutex);
> +	err = mas_store_gfp(&mas, (void *)addr, GFP_KERNEL);
> +	mutex_unlock(&execmem_cache.mutex);
> +
>  	if (err)
>  		goto err_reset_direct_map;
>  
> -	return 0;
> +	return p;

This is wrong. The caller asked for 'size' and got ALIGN(size, PMD_SIZE)
instead.

>  
>  err_reset_direct_map:
>  	execmem_set_direct_map_valid(vm, true);
>  err_free_mem:
>  	vfree(p);
> -	return err;
> +	return NULL;
>  }

-- 
Sincerely yours,
Mike.

