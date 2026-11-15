Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB19606A33B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 19:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XhLu85Ua
Received: by kanga.kvack.org (Postfix)
	id A9DDD6B05B0; Sun, 15 Nov 2026 14:20:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E676B05B5; Sun, 15 Nov 2026 14:20:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93DCA6B05B6; Sun, 15 Nov 2026 14:20:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7B36B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:20:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D671240807
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:20:29 +0000 (UTC)
X-FDA: 85438319778.02.7057A75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 412DB2000A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:20:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhLu85Ua;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794770428;
	b=Utg82MlRmozNPj6Wy5g/t6rKC80s1u14kIgtcuAvR6sbaZM+selTh3KfJG89+5qFeRoUSt
	+6WUcmWG4Htg1KK8KCXBMcS7koVoxXVfDOjvVy7eIukBgk9t8Z5fLRLOAkcOg2Z2L4IXy3
	sq4E+w2JEFKugptYmWDxL0Ce+RWt98U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XhLu85Ua;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794770428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLaQUPcYKxXkir2twg3fsW7g9Gg8lBOZ22Z32cylxH0=;
	b=YP1/iG5LNch77r9WVUivAzeltLqsGgSTqh35kmNMcduuqvXsodd2OzK+9LHPEi87mTld1k
	7T5iJr7bdGnMjfthto+Gf5o0fZcOtxw1NlizAD5V0IwqQpmxwgxji5QWsM+0jGKZC/g//G
	eCF9bMcCBscpQMcwmR2d70kKLwUAsoQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB737601CC;
	Sun, 15 Nov 2026 19:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC921F000C4;
	Sun, 15 Nov 2026 19:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794770427;
	bh=fLaQUPcYKxXkir2twg3fsW7g9Gg8lBOZ22Z32cylxH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XhLu85Ua2c6WZLlLlAlu41R/VyenJMuIzs9+HeEnHjow/dZUNr5fsUxv33MVe0xR9
	 NiqKgGZojOd6z653AmlAbwBWSNz0Y/J4dsO9oqMstKyh/UAzeOwqo1F24tatjYGczh
	 Q0qBu2kvlSa0F8oIVuhxCAoOMhwI/hK6jFz/WnzR0a+3Y8LmbXpxRwMM+kxXmZY1iq
	 25w3eguzUz3kcvSwQsQNl1CFRImzluQwZPqKEdduaE+/HXoeSbYwThL2YZMJLNU1I0
	 E3zvrbGwhP652mJ1OL7CToELmOQZpBOaxBkQTr+i8KiSeA8Qj626ksqR9/Ha+aLwjb
	 //TVlKyt3smmQ==
Date: Sun, 15 Nov 2026 21:20:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	m.szyprowski@samsung.com, jenswi@kernel.org, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org, mark.rutland@arm.com,
	robin.murphy@arm.com, hch@lst.de, ryan.roberts@arm.com,
	sumit.garg@kernel.org, sudeep.holla@kernel.org, ardb@kernel.org,
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] arm64: Add support for MEMBLOCK_PTEMAP
Message-ID: <avoF8IbOxVJ9Uh8Y@kernel.org>
References: <20261111110738.872947-1-vdonnefort@google.com>
 <20261111110738.872947-3-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111110738.872947-3-vdonnefort@google.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 412DB2000A
X-Stat-Signature: 4qf5aeiqcbu4qegikmddimqa35wtthh7
X-Rspam-User: 
X-HE-Tag: 1794770428-533883
X-HE-Meta: U2FsdGVkX1/Aga8IMUvySam0ltar54t7/VyzAPRJ105l1lwqSxYmUa/tCdY4DdVO8kGueOFMeWvOt+mI0YJ24vW04m7ehfwcTyHit9q1S8FVCYRMbOx8LbOXM6ddGjp4ZLNOddgh5A6VBulaw5fIR8masSKYQcKHBLWcHfjMfFEwE/kW5K2pLBxRMivzNBCA1KW35DaSQyYOZw5yEM8WjsGIjrh2Y0LUJDHOwr9NSKtpCWf8/jwDWBQr2Scdq6QjB/0BYPhLP9+08zZXDKgFXBMJx1Wmcn0AKCbBJD8xims67fNy9ln3zfVo5GkL9GgBJbojQhjU1F+BN/3tPs3a+CakbHLeQrGsxcGlgpcFm7R6thOTyxRL+ZOdv58tfkmX0IhoGEQKjzbKdMQ2UYf6MItSy9XKvxXh2ZvwuLgMe8q3xXHCUU2532In2/7JgxUQMhmlm1hZqQJdkxG1vVGP28OdU/Ad0cMDvQR/ylk0ZmczKO3e/EN10jm0LzQ49HmZhxKxsJqTyCFT+t18UAvHMGXqimchtrKi73WKTYQu5gXMuAQKCzXaQlVLgJ/ryjEGveBQPuMNiZbAHgi+tOxzwHPckxwfJugpe8zteJ3pQiCz57o4DE5F9kvR7MXysIeP4SAL/DCpHgx3fePgHib0NXWN8zxlcGM5Vbv5/XTsDQf18taOIVKfJK80SaEV6qT2kLy7GljvMyPagwr5qVJlLEriGJTYGKVm5TipDhqHnK6+szndTlG81fOUkYIV59BU6TRuaz1BIGDxdlyXH162n7zp3Vug+eWsQn88dkZ8i8PODucqEbFwQwnKN3Sq5K1GeQWqaX8yEISp9zBhG1bIgwh00iVNW5/IPEgTOlhDu5eeUY3LKTZZ2tmpZTbU6rZr2lwnJA6q7oJerHmzgJTj1alK+544s90c7IzNpNpRj/dJE1/y99ybQR3JA81mOTq82HsqkUB0PB4u+kJ4lBa
 ohSRhft4
 9MuhxqwYZzzulmd7Lakjl81+mkytEVQWmxpG59HpBxTe0RC68qdoG225HOHyUu3i0ZmIZTM9D62a5rnpdiPHVciSj88SHPS2f2TFBxD4ea54A+jr9XV4zT4Et+64mbHG5eEYm9zK6WVXMBq736yfvjJ9wlUcxD5j+TJz0909fScso07TCX67wtOy+WMUBU5vkOn97ymHjOi2vlHaYkXBCkXTRVeJQU0JLe0+aCBfVwXn3/UqZAZ8ldUqnbMjrFfNiS+mUWpHx2THle//Rtt0LXY2mJ0G2+gu+rYRNC/q/jWO7LGvWwoZ2UEJE5yTkFIuvsg3XDv/KNVAHCL1mHybvZOOjBND9+WO86GECJzlrMTnwS18KRoPd65xRaq04e2wCCFoB+WcZCmCZcmiFYGxO4JeBBseBm8oJFsZcUSHlQLDUB/JN3iLEUllWVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:07:32AM +0000, Vincent Donnefort wrote:
> With the MEMBLOCK_PTEMAP flag, force a PTE-level mapping. This also

I'd expand this to "Force a PTE-level mapping for memblock regions with
MEMBLOCK_PTEMAP flag set".

> disables contiguous PTEs to make sure any page from the memblock can be

                                     and memblock region here ^

> safely unmapped from the linear map.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>  arch/arm64/mm/mmu.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 140520b351e2..a4cafafa1d82 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1184,9 +1184,8 @@ static void __init map_mem(void)
>  	phys_addr_t init_begin = __pa_symbol(__init_begin);
>  	phys_addr_t init_end = __pa_symbol(__init_end);
>  	phys_addr_t kernel_end = __pa_symbol(__bss_stop);
> -	phys_addr_t start, end;
>  	int flags = NO_EXEC_MAPPINGS;
> -	u64 i;
> +	struct memblock_region *r;
>  
>  	/*
>  	 * Setting hierarchical PXNTable attributes on table entries covering
> @@ -1226,9 +1225,14 @@ static void __init map_mem(void)
>  		       flags);
>  
>  	/* map all the memory banks */
> -	for_each_mem_range(i, &start, &end) {
> +	for_each_mem_region(r) {
> +		phys_addr_t start, end;
> +		int rflags = flags;
> +
> +		if (memblock_is_nomap(r))
> +			continue;
>  		/*
> -		 * for_each_mem_range may return sub-page-aligned boundaries
> +		 * for_each_mem_region may return sub-page-aligned boundaries
>  		 * after memblock_mark_nomap() splits regions at byte precision.
>  		 * __create_pgd_mapping_locked aligns phys down to PAGE_MASK,
>  		 * which could accidentally map no-map memory on the boundary.
> @@ -1237,17 +1241,21 @@ static void __init map_mem(void)
>  		 * regions. The cost is at most one page of unmapped gap at
>  		 * each boundary.
>  		 */
> -		start = PAGE_ALIGN(start);
> -		end = end & PAGE_MASK;
> +		start = PAGE_ALIGN(r->base);
> +		end = (r->base + r->size) & PAGE_MASK;

Nit: as we anyway change the assignment to end, PAGE_ALIGN_DOWN() is
slightly more explicit.

>  		if (start >= end)
>  			continue;
> +
> +		if (memblock_is_ptemap(r))
> +			rflags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
> +
>  		/*
>  		 * The linear map must allow allocation tags reading/writing
>  		 * if MTE is present. Otherwise, it has the same attributes as
>  		 * PAGE_KERNEL.
>  		 */
>  		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
> -			       flags);
> +			       rflags);
>  	}
>  }
>  
> -- 
> 2.56.0.542.g3ef89b7020-goog
> 

-- 
Sincerely yours,
Mike.

