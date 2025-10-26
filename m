Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2837CCD1A5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 16:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F928E0172; Sun, 26 Oct 2025 12:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47078E0150; Sun, 26 Oct 2025 12:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C108E0172; Sun, 26 Oct 2025 12:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8167E8E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 12:29:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2795858F6D
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:29:50 +0000 (UTC)
X-FDA: 84040801740.09.0EB9FC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 93C03140002
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:29:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oQ4SiShq;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761496188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXo3VMe4/7ip/N7qvlP++FAStAFtSKwSCrWdnL97kr8=;
	b=U6urqFbyeu2CjKtmfEkFVN0QudukOBvOI179b1gkdZzp6eZmirQyi/XeALDtagZTv8vA9/
	RlA2LkDH0WPODBIXWOpMCE41hyrJMopk5dGLX3ybceJ9qijtWwfkprLkMh3miHO1PPhkjt
	mZRkv7UMZgTyqIXmEwReA/9h3XufcZw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oQ4SiShq;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761496188; a=rsa-sha256;
	cv=none;
	b=Vg2mnerunEVCzjSOYVLMjOWdiIYY0yrjCxshR7cTUOvRFortmSJttM0reKhlk2E+bOl53Y
	FveD76onQOmDZTARDrpBVZpJh1TW4+6gyS5eaTFeMJFAdbgb+IVGaxHzoFFgo9zG3UgOUr
	e9GZIdj1QN8wLgbxO38+Vo0x/ScbiFg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E044A60306;
	Sun, 26 Oct 2025 16:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4175C4CEE7;
	Sun, 26 Oct 2025 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761496187;
	bh=sO0a7q5i7MeIpNSac1aJH83qJF+UpedUXSyygfAYUOE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oQ4SiShqErdQlNweJkeXuQAUrzvImzw7c+n0h00KfYxTBSa2swPH8us/GQ9Rn5P78
	 lPNe18Sld99k1WToJIgKtTs0dEiFgoLMpIlJAvC3zrYjw324NP96DqAXpDuuY4Gnqh
	 WKVUH0J+0DOdhYkMsVBV4biHJ3l17/X7CLW2MkucKYblQ7NAQ3Gv0XjwY2enKqKf1S
	 dZOYhAvqeZ86hPpTD7kbqGhB+QymcmtU24b6VxktHyzZHczsdwZzv0jXojyevYoaQV
	 +ct0siLBpjpEXLY58908awCeduA3BfqsV9BgyXLtrKtF783mOXvfHwug3LVoYRiM1b
	 bjnBa/AgwF4Ew==
Date: Sun, 26 Oct 2025 18:29:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCH v8 8/8] memblock: Unpreserve memory in case of error
Message-ID: <aP5Mcr9WCt5CHon6@kernel.org>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
 <20251024161002.747372-9-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024161002.747372-9-pasha.tatashin@soleen.com>
X-Stat-Signature: hq9zgazmoicg73z3bwb5xs5349dr5zou
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 93C03140002
X-HE-Tag: 1761496188-153993
X-HE-Meta: U2FsdGVkX1+YOSS6JiEkhpL3yAjYrt4FQFckq/0x5LkWKs/PT+z6Wb2B2qyiGsE0R8i9P503ixPFL8yuzSDIBeTYESJWY1hcJpPGVTSkpcynZMXA9x0GLPi5tYA3FwXp1XWm+fktSUO9/sc7bbYRYSnrnaXoKfYt9sMmIwRLsd6hBxLq+BXX8i7eSApn/DaHP1FGmLVpgkc+Paic1vv7tGkx5DRcA4m1S+yuz3rGpc1MocwumjijAKFLI4wz+a4eoR4kb9eKU0aar2EKNhcqmyVFj6Nd3chYXO8gEXbM8tJSyAggw5lzBsnAIfG2cS+4P6IzDA9A6X0Q7UBKzDsR/CGFVGz4sl2kvqKTgW6flXPEavlQFvgGIomIgX/SU6d9V4ZGiueeVf2KD9ubbC/U76nSYYmp7wLSzrQGQDdsoUwwIRlFn/mlTpcgrBL0KvkU+LzYK4tBHwnR2fX//XONO3+hNEEgXt98EQ/nAxmofBZq8u0QlcBR9MCNZY0BtJPYWXYrk/dg41zHjqE+IfrpPqx5gW3fS6YwD1HA7sn70VFC2bFLBjX7tMnRvnPHRztAgWoEHt1yYPD1r4cCLyh+UVl+h2QRS3b15lw5/sur6LHF7GqeMr/GGCMqWVi+RxgtWsZXmYZv3gAvvRxUwi3s80u4VNnrSAakdifRsgk6jrhcR0sFIC2tJGNF3ZtxugJA5dE6DSDDPQoh3YTt6ZSkI35jIiNww26qJgYWZavWbzYtam5iI7hZH7RjHNNNsnvWN4TddPE3e++GXGwyXIvqq7Ih2z5X5j+MW6eN0/KzlyYNi/dVFMtpPd+QbDaz9nhaDIB6Dbe5A5uFqyX3XSelNCQGmxEIj9IhPTwkytVKCbLaxkvAJzgxrjeK9/j8HLcxKFtQ8VPnmBkoBxc+TcLaKDRXQdd4HH8UO1K+Imvxa/x+AqIF6YJkVh942kaSSMNXONAdtf2zuZrYM7NFKeU
 aO8gEzFK
 YTXVMiqItAuNRpVn9pmyoz/zxT3sL6gXgUPEx8QihngH8BWWlEVHA7Xc7qScwlK5qZWsxkvgAT4hTtZFKVt+zAgPNPJhuiBA9RXnpJnv4Mm7zklSvKK0Q6piT4Lm/s2j/IWVmm84MywTmG9IJ7cstABNhwt7DSShyen719Fv8nnB/qVEQWYqY6WYIDLi8sWtz+DZGGGY99B9KNNwUAeWXp44i39OkGImHRxmnjlMU2DZl//ZFCvISNDWjhlja/YLD5aj9xXb8QGl1gKxWQPj0A7iny3bTZnY/RMOYv7+2h1/4d88=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 12:10:02PM -0400, Pasha Tatashin wrote:
> If there is an error half way through KHO memory preservation, we should
> rollback and unpreserve everything that is partially preserved.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  mm/memblock.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index e3bef9b35d63..5ceaa02af7d6 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2447,6 +2447,7 @@ int reserve_mem_release_by_name(const char *name)
>  
>  static int __init prepare_kho_fdt(void)
>  {
> +	bool fdt_folio_preserved = false;

fdt_preserved is enough IMHO.

>  	int err = 0, i;
>  	struct page *fdt_page;
>  	void *fdt;
> @@ -2462,12 +2463,14 @@ static int __init prepare_kho_fdt(void)
>  
>  	err |= fdt_begin_node(fdt, "");
>  	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
> -	for (i = 0; i < reserved_mem_count; i++) {
> +	for (i = 0; !err && i < reserved_mem_count; i++) {
>  		struct reserve_mem_table *map = &reserved_mem_table[i];
>  		struct page *page = phys_to_page(map->start);
>  		unsigned int nr_pages = map->size >> PAGE_SHIFT;
>  
> -		err |= kho_preserve_pages(page, nr_pages);
> +		err = kho_preserve_pages(page, nr_pages);
> +		if (err)
> +			break;

Please

	goto err_unpreserve;

>  		err |= fdt_begin_node(fdt, map->name);
>  		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
>  		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));

	if (err)
		goto err_unpreserve;

and drop !err from the loop condition.

> @@ -2477,12 +2480,27 @@ static int __init prepare_kho_fdt(void)
>  	err |= fdt_end_node(fdt);
>  	err |= fdt_finish(fdt);
>  
> -	err |= kho_preserve_folio(page_folio(fdt_page));
> -
>  	if (!err)
> +		err = kho_preserve_folio(page_folio(fdt_page));
> +
> +	if (!err) {
> +		fdt_folio_preserved = true;
>  		err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
> +	}
>  
>  	if (err) {
> +		int nr_reserve_map_preserved = i;

nr_preserved is clear enough.
Also let's declare it before the preservation loop and count it there. Than
we can make loop variable local which makes it safer against certain side
channel attacks. I.e the loop that preserves the memory would be

	for (unsigned int i = 0; i < reserve_mem_count; i++ nr_preserved++) 

> +
> +		for (i = 0; i < nr_reserve_map_preserved; i++) {
> +			struct reserve_mem_table *map = &reserved_mem_table[i];
> +			struct page *page = phys_to_page(map->start);
> +			unsigned int nr_pages = map->size >> PAGE_SHIFT;
> +
> +			kho_unpreserve_pages(page, nr_pages);
> +		}
> +		if (fdt_folio_preserved)
> +			kho_unpreserve_folio(page_folio(fdt_page));
> +
>  		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
>  		put_page(fdt_page);
>  	}
> -- 
> 2.51.1.821.gb6fe4d2222-goog
> 

-- 
Sincerely yours,
Mike.

