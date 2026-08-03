Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3617C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 22:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121A86B008A; Mon,  3 Aug 2026 18:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1F86B0092; Mon,  3 Aug 2026 18:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29A06B0093; Mon,  3 Aug 2026 18:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0E096B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:33:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69336A0854
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:33:20 +0000 (UTC)
X-FDA: 85061410560.26.6B574D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C7AAA100010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:33:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jhWGubsx;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785796398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zBzIQlhYJkUcdP0zgsu/KndrX4arY4rYTrRL6zaSuM=;
	b=ASBouFWQUAKIXjc733XxOrXvj591QEcZMQam5KD8b8ANpoDAWb+XAou2qiLz1WnjZpnkqX
	rWwq2mnt2WsBAZdjV0DWbfdz4VobVpyvyFjn9zwDW/4xpIFHddNzXNrqPvLw6wOgMhavda
	069NAvOGVQdYywoPJW3ppwXxvof8q1A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jhWGubsx;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785796398;
	b=p30wffeflHMSsq2W7aRgBevXl4H8ZvvKEGYg6OFHGWjYLjUk3zBuWNPPuBmp3GJQ47vynv
	sj40KVHjBRA67WmMWS4ktCAy1C9QAUJRlQR30RLGvV0CVJACCiJi9wV/ocBxHIdsthIlyT
	mIbR7LaT+b2ugq+Y/xrV7gbNLZ4e4Y0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40C1360A59;
	Mon,  3 Aug 2026 22:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004941F00A3A;
	Mon,  3 Aug 2026 22:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785796398;
	bh=/zBzIQlhYJkUcdP0zgsu/KndrX4arY4rYTrRL6zaSuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jhWGubsx0hIxnInyYVZYdjDxvK/3LN690IRGX/hPVDQ12pGBceWhjDIr1dr9OY/T1
	 Q7ayBE7zUnN78znoRQ7vBuB1al3NxIl2si3y3ShSlxUWuq8KR66IypraogmNMc5M5l
	 QU2Xt7XeWsIEtMt4DcjNP4kiyqa47lmGTr5JARpIiycIanibdWK3hzIcum20n+FJPv
	 9JXWzZbd66GHQpiGGC/dmd72IWkytEsrJAPqIHMsNJV7IFWK0Tp3lWBKGs+QObnU40
	 vn4F57ofrTv4y9yD0mxitvAB/jYcuUfdAPiXA7LHHjybFg9FxtOl+jmPhi2kvx5smG
	 CHbMsUcn+vFIw==
Date: Mon, 3 Aug 2026 22:33:15 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 08/26] x86/mm: move LDT remap into mm-local region
Message-ID: <anEW1APDhN0UfPcD@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-8-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-8-6f5729aa9832@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C7AAA100010
X-Stat-Signature: kwgi4nj3s6j39543u4nrudamte7e7d1q
X-HE-Tag: 1785796398-985821
X-HE-Meta: U2FsdGVkX193oU0atN0ZefRZDxyMK8JX384b+wM33MM2VbN5I9WYKCzrtt5kQI4N/zkZWp3pjroNuLux2kltRfFmYpee6esOwaBeoAUXw3aU5f28dVM88O+H6o7vOxqCLE76amdMuHHoexCBkTk0Fb3n2K1MC4xpWoC8AsoWcYPha0iaeO/hCZzaaRYzjwsLdbGtyEvlXaqUYEHjjtuWWwRF5Mr/HOHVPMaWcMejce33OQe/OLcmYmtyJ8TScyvfR+cozwFbXZ/fvonGOTLLMTO+IEtX/JefNKFlp1147sbzMVUoeqHjbQ3yFsTsikIRt5dvQJcDkpHGejugN1nU0Fm91XWO0koXGUwin6tOVxHbU9inkKzoPX+ADYs1uQtHjuxcY3tSFHnPKEfveub+s708vt1b4+DcD5e2jCerJLax2iFeb0xpaFweu//B2r+KYG5edeL2kbYujjukUHQhFzySRcLCliHvDGU0Mo/rxvii9dCxzQY8XzY3s9mqNahdauE7o/arat7Iy3jIY1zwZ50BYmrQ1WIm4yy3Hr5GbqReoHZAaHrpYrQ+kr2ST1E/mRKVH4+FpdQP2Ie3yc9IxJsgjMJyQwGCYQVVM4tiFSUANx4ncRZINw7y8EcmMSI3Aou6YvE1v7BG4tGZQqvrY3Cmdh9FL7WQy9m6nqMMvdJ42zLwjRSx39Xp0hrQNd2pOrxoqUXGfTs3uJetA6ujvUe/svGWPD7FZJhd7yDi2yRMiZ2HaDBClwfo9+syPHBVWk5AJIA3mTvvkIC6iA4ds4Opt6/lAe5P76CGQnIwwwPjlpNkVa4AREUuj95MjtQboe2KReUCjjZ+6qU89rKlRMaoaEfHm6eLAItP/Ww76uLtU2lrRCmL/S7/BcDeDGh+UkFrXcTs/C2meiAlMgRrcrl/AubqTjfbMMOPmqKc2kieI5IUV6Pneq+kGKsqgqpM+dsBfAzU6Jur93jf9n9
 ZnEFogOD
 y5wE7l+F0r+CLwizgwFuNlfpbRDvHWbdiVF+fGU8D8gwSbAdzytT6ojVx9lz811AD/M5KAu/odmbsre/LU2PPW8WXm8fFsydK07ykT0XUK54YME8drN9TLF6RdAYlg1+EwTDpgOYNY4EDGjJ8fK60AwybMhw7EKUMrAaGgWhFyb8qRqD6V/n61TSU+stnTb2PSCS7HSXdLUqCWV/s5d+cCoTdGC51RqbwErlW2kh0F2Mv+OBrlzW+kT+5aE8FwMTskIIUaEMtuxXvXn3+HmDDjp0XGftE5p4LumeAsyl2aJVEYjE1v/c+WlFzyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:41PM +0000, Brendan Jackman wrote:
> Now that x86 processes have a general mm-local region, the LDT-specific
> management of the higher-level pagetables can mostly be replaced by just
> using the generic mm-local API.
> 
> Drop all management of pagetable allocation and freeing; that is now
> handled automatically by virtue of the pagetables being in the mm-local
> region.
> 
> Drop explicit logic to map LDTs into the user pagetables under PTI; that
> also happens automatically for this region.
> 
> Unify the sanity-checking logic between x86_64 and PAE: use the generic
> set_memory.c mechanism to walk pagetables. This means the
> sanity-checking is slightly more relaxed, since lookup_address_in_pgd()
> is more flexible than pgd_to_pmd_walk(), but this seems to be worth it
> for the simplified code. It means that ldt.c doesn't have to know about
> the exact structure of the mm-local region's pagetables.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
[..]
> diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
> index 40c5bf97dd5cc..685664c1ee770 100644
> --- a/arch/x86/kernel/ldt.c
> +++ b/arch/x86/kernel/ldt.c
> @@ -186,10 +186,16 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
>  
>  #ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
>  
> -static void do_sanity_check(struct mm_struct *mm,
> -			    bool had_kernel_mapping,
> -			    bool had_user_mapping)
> +static void sanity_check_ldt_mapping(struct mm_struct *mm)
>  {
> +	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
> +	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
> +	unsigned int k_level, u_level;
> +	bool had_kernel_mapping, had_user_mapping;
> +
> +	had_kernel_mapping = lookup_address_in_pgd(k_pgd, LDT_BASE_ADDR, &k_level);
> +	had_user_mapping   = lookup_address_in_pgd(u_pgd, LDT_BASE_ADDR, &u_level);
> +

As mentioned in the previous patch, this patch is difficult to review
with the current arrangement and patches 7 and 8 can probably be
structured in a better way.

The unification of sanity_check_ldt_mapping() by using
lookup_address_in_pgd() can also be done separately as part of that.

>  	if (mm->context.ldt) {
>  		/*
>  		 * We already had an LDT.  The top-level entry should already

