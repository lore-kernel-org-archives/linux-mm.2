Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B0DDCA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 07:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D85F6B008A; Sat,  3 Oct 2026 03:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989546B008C; Sat,  3 Oct 2026 03:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877FE6B0092; Sat,  3 Oct 2026 03:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5613C6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 03:56:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 190E940928
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 07:56:15 +0000 (UTC)
X-FDA: 85280557110.16.2D151AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7FC6F20006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 07:56:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRLJc7Hy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791014173;
	b=S08/7EIQoKNEMvyWw+rBXiURrdCPjrHNrplongC4NWvO6gbgIHsWeySjpCEfSOvd5PlFWS
	UV+4l5qdcu/OSAsNv/vi+cS2D7jb5nlD19dZNihOIYgJ6CFyjVDFny77tUQJoCV9R+Hx6/
	9sVSb4I6wfA8poBIy7HJciszTjFTRow=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRLJc7Hy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791014173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPO4RM0i7SP/IETP8H+05lmtRukMrZzOkuL7g4aF8U4=;
	b=uV/UgQgWFLIqwlkmMHw5pQ9oVfmDx5Xi9yrRM2K6CEMlK6AnuPjdk0NuBBtEW6fs4TPKZH
	dkJTgRedKUzgPFzmcwTg7b3vCKT41le/1TJUXT6IMNRzQ/EhT/casrM3wDta3JSD1rCGPm
	rH5K8q/RngNG8dCUWpdCMoIdAkHDyzI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09447602C2;
	Sat,  3 Oct 2026 07:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E6A1F0089B;
	Sat,  3 Oct 2026 07:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791014172;
	bh=UPO4RM0i7SP/IETP8H+05lmtRukMrZzOkuL7g4aF8U4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VRLJc7HyEynjBACssz2mmFo30gjCyNt5Q471QjoAwHeXP5o4nCvfFp9iyqR2qwIYy
	 rdqKYt47RndMm6y1XcQ1FG8JEyO/28b1E10zVwA4k4cSfHfXz9a3q0FS4/ISdbLKOC
	 75jgXrEMNeuWwhSa8lOgEgKFM1e1ytwEe/cQK0NnbQgVRgoSaIE+nx/ug084XIddZN
	 yOIMS7FjC7SBakdQIeX3JIw7XCAE8j2vFG8jjmOCrjuhh2/LjnWS55aGmORTvWuvbJ
	 HE7kIH1M+QqWOfDYzLHCKurMsqEw4mKRNR1LmeCrzdw0+Lxe3xXPkdJgRE0FZ79p/q
	 JgL18ukxU0ciQ==
Date: Sat, 3 Oct 2026 09:56:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, dmatlack@google.com,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	dev.jain@arm.com, Pratyush Yadav <pratyush@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] memblock: use binary search to locate candidate
 regions
Message-ID: <asC1FwHVHOhBHDGK@kernel.org>
References: <20260926092448.4090401-1-tarunsahu@google.com>
 <20260926092448.4090401-2-tarunsahu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926092448.4090401-2-tarunsahu@google.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: qibi1zkmdedc4wdqrbqxb5tfj4ga83de
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FC6F20006
X-HE-Tag: 1791014173-902888
X-HE-Meta: U2FsdGVkX197KhDahG8XixWgmzEBxv90sOmADevs5Ubjr1l+xJ1U5eND3xB9GWFdCFi/7QSXCi9MP0/1pz/ARK1cwLWloNAOB6bDcQdoatmuJL7vlFrNa9hdpfpBKEOJWOQc/bqGA+PVXughA+Sp4pvu5KQ9k2tCWTWqXlnK38xgqIkYCV9MmqsS3o5iLhUNeHNioBLEnfoQnVYXgkWk1u/2wTxz/eKZZPnAMSUNA0sXRBf9ssXEIKLicNkxhEN2pgOhnhWmzdMJnvb0izYql3l/0wT1tC+QePSCTz5iXugJjj6UAVU0gg+PnAP/klZTvw6r2aEBHagcyMH9xXq3/VXstnr5+WhHK5xiggvj4Y29RgQGXH5/Z9/Be2QLpwajUF+AjluD7Vlg8YUzy+zgP2mBzTBzRpX50E611wIa7ydBgAeM7cK560PMGRSovdh9JG9ynhYP7II+5dW6ktlzPpZL+UyLNl1JGW3ri02jzIACdohETgD9X2T1QXkDcPEx7RP5tLr0S1XP2coO1/DdhIzxtzOgiUZVkYgi2mBslbJCAEM8lQJtc7x9jXN+5cYecJ/iJgmNMi+5scZt5MDcl8XlH2NXBJJCxtiNxAl43DUHFiTBLgapSOrwQvxdIiFxo9mxlMxBQBbq/lFpuRlVLZRVnrGvgzzyHEArtaDbaEznuVaH4kjldkCFgyfc6znBLC2J3XWKqqIJZP2Ff7SweK3cu+A1V0JZiFJdHqynwXla6tsbqOkUk1EzlsEv2IwlLAObjBji1U1GvR7C00XQbinJp8HXid+CzDFtNHC5BB+WldYWb3qJAUaAc7AKZWz4WIH4xiuU2nyL7Dmmtp4rW67eDdiQ8mWZr6UHwB9bEig1PatE8oa3AEZ4f5que7gzX/0XKUSWvU9v0APe//YqnSIw9E4JrYd7YgCM0JOUs6CA5QmaFQRx+6u16TcCgTHsA6WjMcmwdpg7Li/1skF
 K80I+Gwg
 GdBvD5tQ5q4+An9LSWAWxgswbVspP3t+74qGwU8Pwwv5EPHr8hrQWjUQVtIDgSG3JHMVlYktJGFwyJyKzA46p08ycvDwF7Hk4VZ163dLiQaQ0HxRXAoOLJJAL2dOsmgF/WeuM5Jaw+Ukg9VXRF0+MB+bVMzGx3fScs+0FWW+piacRvEpqDfBZOCcqoYXC3x+NuNFflu4MA+Y6+TZjY49+/E6flh6axhEMHnZyDKV2kLrw5QrJ6NCFmgxgHIzFUZ70GXyyUE74SGGh6j5QqAqykwPquSMXsU9XS2kdRY3gHEeB3hn4Gs99GKddgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 09:24:48AM +0000, Tarun Sahu wrote:
> Use binary search (memblock_bsearch_start) in memblock_add_range() and
> memblock_isolate_range() to locate candidate regions instead of linearly
> scanning from index 0.
> 
> Under heavy memory fragmentation (such as KHO page preservation registering
> hundreds of thousands of disjoint folios), scanning from index 0 on every
> insertion and isolation results in O(N^2) complexity, causing boot-time
> memory retrieval to take several minutes (~268s for 393k pages).
> 
> Using binary search reduces the worst-case complexity to O(N log N)
> (and O(N) for sequential appends), cutting KHO memory retrieval time
> from ~268s to ~50ms.
> 
> memblock_search() open codes the same binary search, so reimplement it on
> top of the new helper.
> 
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> 
>  mm/memblock.c | 53 +++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 37 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 59dda7d085f3..87c71435c80c 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -586,6 +586,33 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
>  	type->total_size += size;
>  }
>  
> +/**
> + * memblock_bsearch_start - Find the first region index where rend > base
> + * @type: memblock type to search
> + * @base: base physical address of the candidate range
> + *
> + * Returns the first region index that could potentially overlap @base.
> + */
> +static int __init_memblock memblock_bsearch_start(struct memblock_type *type,
> +						  phys_addr_t base)

I'd call it __memblock_search()

> +{
> +	int mid, low = 0;
> +	int high = type->cnt;
> +
> +	if (type->cnt && base >= type->regions[type->cnt - 1].base +
> +				 type->regions[type->cnt - 1].size)
> +		return type->cnt;

Using local variables would make it more readable IMHO.

> +
> +	while (low < high) {
> +		mid = (low + high) / 2;
> +		if (type->regions[mid].base + type->regions[mid].size <= base)
> +			low = mid + 1;
> +		else
> +			high = mid;
> +	}
> +	return low;
> +}
> +
>  /**
>   * memblock_add_range - add new memblock region
>   * @type: memblock type to add new region into
> @@ -609,7 +636,7 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>  	bool insert = false;
>  	phys_addr_t obase = base;
>  	phys_addr_t end = base + memblock_cap_size(base, &size);
> -	int idx, nr_new, start_rgn = -1, end_rgn;
> +	int idx, start_idx, nr_new, start_rgn = -1, end_rgn;
>  
>  	if (!size)
>  		return 0;
> @@ -644,8 +671,9 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>  	 */
>  	base = obase;
>  	nr_new = 0;
> +	start_idx = memblock_bsearch_start(type, base);
>  
> -	for (idx = 0; idx < type->cnt; idx++) {
> +	for (idx = start_idx; idx < type->cnt; idx++) {
>  		struct memblock_region *rgn = &type->regions[idx];
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
> @@ -809,7 +837,7 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>  					int *start_rgn, int *end_rgn)
>  {
>  	phys_addr_t end = base + memblock_cap_size(base, &size);
> -	int idx;
> +	int idx, start_idx;
>  
>  	*start_rgn = *end_rgn = 0;
>  
> @@ -821,7 +849,9 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>  		if (memblock_double_array(type, base, size) < 0)
>  			return -ENOMEM;
>  
> -	for (idx = 0; idx < type->cnt; idx++) {
> +	start_idx = memblock_bsearch_start(type, base);
> +
> +	for (idx = start_idx; idx < type->cnt; idx++) {
>  		struct memblock_region *rgn = &type->regions[idx];
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
> @@ -2062,19 +2092,10 @@ void __init memblock_mem_limit_remove_map(phys_addr_t limit)
>  
>  static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
>  {
> -	unsigned int left = 0, right = type->cnt;
> +	int idx = memblock_bsearch_start(type, addr);
>  
> -	do {
> -		unsigned int mid = (right + left) / 2;
> -
> -		if (addr < type->regions[mid].base)
> -			right = mid;
> -		else if (addr >= (type->regions[mid].base +
> -				  type->regions[mid].size))
> -			left = mid + 1;
> -		else
> -			return mid;
> -	} while (left < right);
> +	if (idx < type->cnt && addr >= type->regions[idx].base)
> +		return idx;
>  	return -1;
>  }
>  
> base-commit: 1f18d740165163910df64d3063e1ad31648bc5e0
> -- 
> 2.56.0.rc1.315.gc6ed9934b7-goog
> 

-- 
Sincerely yours,
Mike.

