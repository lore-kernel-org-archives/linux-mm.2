Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E20EE6817A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 12:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58CE76B0005; Tue, 17 Feb 2026 07:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53AF66B0089; Tue, 17 Feb 2026 07:32:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C326B008A; Tue, 17 Feb 2026 07:32:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE1A6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:32:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C134DC047F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:32:21 +0000 (UTC)
X-FDA: 84453886482.20.203371E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 146BC180008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:32:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TTDJuh7S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771331540; a=rsa-sha256;
	cv=none;
	b=33JoNvhub+TFOYrwBbborIDGWMzSo8W9kXhQX+imSs+3sKvdKlj7oa+fxGJ080aks6L2sO
	brztUOz3VoAS1SKTld+JoV8pxZPHjaBSh777MUyvexpEn9U3JeSC0aZp2rjo/5eMSuZWDY
	DeXNnJpwVPr48WeXPMSAyRzh8uIQbfc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TTDJuh7S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771331540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Guu0uFD9Md+Bi3xyfaSrzF4zB8sTGwzhlngvFhKj0U=;
	b=ChgtdWOxhPFd8OuyZaCp+3Hb93SFM4qbNY4o91rxQ/AtlzyTqCDxmUeriljKYH+I1ZC2YO
	X7svbOJkfhf9Jn1RiU2zqKUFpp3Evj+JSIrlU0Ex7SQ0WBepj29c6HDdoZgNIgq+1+0Oj7
	HTPLTZPz+4W67y5NA/NsSxtEFf7M8M4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFF3143A31;
	Tue, 17 Feb 2026 12:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABA4C4CEF7;
	Tue, 17 Feb 2026 12:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771331538;
	bh=XGKe3xLrxqa5O0/AFKQ14Hu+QmnUvBgtNHw4QV4Hjlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TTDJuh7Sb+ZtqW2IgnyFhLS7QGys6WVvniSspDeA3mYBkgDeiPnjy86qWqzuBsPj7
	 PrA83Jgo4Vx6yJqWMu8t4esI9xG68K4yu7OASXK2tdMZIFlibbN+6iTQPsLpZjV93g
	 kx5e1Ds8Z3rBI9BlL9IW8iAqO2KcFx9IU3bhG6pAbsBlLuFiQ8yEKOkXJ+Ae6vs7Ig
	 h6Z4EmX7WMeqOA9VkLJouFkvc4JZ/6fH7L/yebxKQB7zSPIBRlWfqj7HEHHQExlXIr
	 t0Z5FsHFgmkvs2mXngpidJWyQyxpN8+UCmgCkykena5Wa6Nl5qFq8N4HEWIiah0YjP
	 M1eC36XJFpTww==
Date: Tue, 17 Feb 2026 14:32:13 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
Message-ID: <aZRfzbSLGCkxx8fC@kernel.org>
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 146BC180008
X-Stat-Signature: zk7r7xdjx1ugqxqb84asin1xwmmhk8pk
X-HE-Tag: 1771331539-190525
X-HE-Meta: U2FsdGVkX1/yx/Ecvj/TSeZ5L8e5Cm7BzZEuPsdncg8eURR7y5Mr3JxpESz7Pkfj+uEBImym5aPk86KZj1Nmh8owbavIw3Be3sPNx23N0Ba/5gyCr2Y0e22h6qoHJk5ahKpWbvUXDDTWIGQfuDM9MJ0mfb4hmd3kyZDxqiqBoBbaxbt0DIf3DxMLVpK9VGQy7ERW2hDQrgzUyrA6xmxm3RZ+nYKfWO4SA426UvYR+f6QBcB/ZMl+bSUxXqDfsImgggUoeBIvXxSNDrJ9+f2TFcsIOf4qQ4UD45ab8d3msQDhgnJRadQ8YA3taqVt9cJyW/gCIxvUoNq0ELNzSex11bIiOPAkmnP5jcTm6faQVec6O+l92i29EE5nRUX0Ju7GpfjXw9jO4BCdqK4/bfMzSCY6R9kkLKTsUrL5OZeAk3UdqRYPW1K2mk642vwSDKE+rxcjJsbR58jk3excexMUiX62i4CzJrZq8c0ivwcLbTTlvLNBN8Nq5gD9vqGHLwAUBEtsP2yKkdl11cM0yneLfFwWplTz9rVv7kYpUGY6lcd27mZBzjQn2HsmOH4EIozYxbWN/2nTJgeEpOUICvkxN2Df/Z54/EfGo3byzc1n+nXlcxmP8WtC9W0viWB1TuVBip6oWM9Swdv6Ek5/oONygzemZdAm+kGL9JkglY+BD335p2fGVW4j6THpPozRY8Tycrbq8PONLaXnaTAOQOPJfvoT17H3aMmENUPkZhpLqBi9sths+45QrusOq805KeX0UgKpxDYAgeBiG2lEv00xetCR+ZqFEk50wFvst4Fe27kGqq9nG1Gn7/fc+iGW8WD9YRseTmEzPqHALIsmE4LNir9CJicjHqfyBcqKu2BEg0eQ+CJev1R6NIptbFwejti176G09bPEIBRF/883fErohs6WxAR/naaVKjIK9VJEzJthhTdITOI6KeNY7wz4qvPTez013xzOXCui3Nm2LL1
 DqOmbgGj
 5iuUvqx+bhVG0MBUeDp4O6hfEemk1LCegwAwNLG1MyHq2mg3AFHMAKjAd7yQujXCK1WAC5qctjxYAsScYYRjQlUozwQPk6C2h9e+QmNBgn9ga1bT3y3uF3ToGuhqinS/tE5lNoIov/qtARTfKv9IMoPevsS9pYfqw/oxsITAT1F800j/DSM7KHXbFYSzPZsgqUqkQaUA7OkDFCP0exqIWx00ZlD9zB+eXoxk0vA2UIS/aqfHf2FHRlv2y8wjRff4jGS5uvQqlTwjO9rxh1332LKE5ziCtmnEJoa3pmAJgl3doGiTWG3pyrsUi515YUC9TTv9o6Uj/rbaN77UooOvFQw5GcDyhL0cN6M4G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 07:28:12PM +1100, Benjamin Herrenschmidt wrote:
> We have two issues:
> 
> - One is we don't check for pfn_valid(). If this is called for
> a page corresponding to a big enough memory hole that we don't have
> allocated a corresponding sparsemem section for it, it will crash.
> 
> - Then, when using deferred struct page init, we can end up not
> freeing the pages at all. This happens routinely with some of the
> UEFI Boot Services memory, as soon as they fall above the threshold
> of pages whose initialization is deferred.
> 
> We can very easily hit the !early_page_initialised() test in
> memblock_free_pages() since the deferred initializer hasn't even
> started yet. As a result we drop the pages on the floor.
> 
> Now, memblock_free_late() should only ever be called for pages that
> are reserved, and thus for which the struct page has already been
> initialized by memmap_init_reserved_pages().... as long as we check
> for pfn_valid() as a big enough hole might cause entire sections of
> the mem_map to not be allocated at all.
> 
> So it should be safe to just free them normally and ignore the deferred
> initializer, which will skip over them as it skips over anything still
> in the memblock reserved list.
> 
> This helps recover something like 140MB of RAM on EC2 t3a.nano instances
> who only have 512MB to begin with (as to why UEFI uses that much, that's
> a question for another day).
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> v2. Reworked a bit to add the pfn_valid() check, remove the bogus memblock
> access in debug mode, and add a test of PageReserved() for sanity.
> 
> We could separately do a patch forcing UEFI Boot Services into
> memblock.memory but so far I haven't hit a case where that is necessary.
> 
>  mm/memblock.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 905d06b16348a..71eb25b68851e 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1770,9 +1770,14 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
>  	cursor = PFN_UP(base);
>  	end = PFN_DOWN(base + size);
>  
> +	/* Only free pages that were reserved */
>  	for (; cursor < end; cursor++) {
> -		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
> -		totalram_pages_inc();
> +		struct page *p;
> +		if (!pfn_valid(cursor))
> +			continue;
> +		p = pfn_to_page(cursor);
> +		if (!WARN_ON(!PageReserved(p)))

Took me a second with the double negation. I like

	if (WARN_ON(!PageReserved(p)))
		continue;

more.

> +			free_reserved_page(pfn_to_page(cursor));

We already have page here, no need to pfn_to_page() again  :)

I can fix those up when applying.

>  	}
>  }
>  
> -- 
> 2.43.0
> 
> 

-- 
Sincerely yours,
Mike.

