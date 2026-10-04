Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24DACCA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 13:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35C06B0088; Sun,  4 Oct 2026 09:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6CD6B008A; Sun,  4 Oct 2026 09:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5186B0092; Sun,  4 Oct 2026 09:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB3846B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:47:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEFF7C0B51
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:47:11 +0000 (UTC)
X-FDA: 85285070262.15.E7E8431
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 31B54180007
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:47:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VxhHcyw1;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791121630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Anbtm+pdahgrR9ZC/t4cu36UZjvdx8AEA18HRuyx4U=;
	b=PniwWwbH9gAnZiS7CnBup4O7AZCJSiqUuXk79JRSN+dBCNZDDMvGyl4a+dnhSHMuFivR0L
	deNiJ1qjpsfAt49bSEV4RMwV5y2ZR+3ns6pCcHFir4FQsTUsKEbzCWiZlzOgLDx6EPZh7M
	8H9fagJzEcAl49HLLfkB/sjo3gCFtgo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VxhHcyw1;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791121630;
	b=IUcOTPHFK/LrrlmxX89WRgF32x7xMjN1h7civOh1DYe6kOtjooKjRPeHLKZciUQQdpmy3w
	+PhP6fGFyB2x3m9lnrIwOAwvqqtLzFZeWmex+4/InZVxHpweNwDJ/PqAo/+Z/CBthjFfGR
	urlvE8Outukqjj/SivEL3p7fu5+gId0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A8AB436EF;
	Sun,  4 Oct 2026 13:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915591F000FF;
	Sun,  4 Oct 2026 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791121629;
	bh=2Anbtm+pdahgrR9ZC/t4cu36UZjvdx8AEA18HRuyx4U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VxhHcyw17121mWewQWnFBlYu36WeLuxLz3s760/ygRpHOFWiW8bTFngobR3fAy91w
	 F1s4OP2siQlEdbeom+A0c7ukrdAI2zTErw1X22qTFMh7SIi7eE7iw4loPqsHFBobAu
	 68ewnymwJZ6caC1aE7V/FpxHLPVuPSJLcVQZ+xWsuEMefzBeD9b5Hx+ibfJgVHy5Md
	 dy/CqZy0oru33VHC2txLf1g9Wd5aS+/axHyLERZhV1qTikLOp6/f0mzSrNb8wT8VJc
	 S1XnWjiYpj1LRD3+fhTfaWIqZWUtBCe2ufRB0UoVE0z+MQ5gRpnb0kaEAhyKicwLYl
	 kvo/Uswz0DQbg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  dmatlack@google.com,  Mike Rapoport
 <rppt@kernel.org>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  dev.jain@arm.com,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] memblock: use binary search to locate candidate
 regions
In-Reply-To: <20260926092448.4090401-2-tarunsahu@google.com> (Tarun Sahu's
	message of "Sat, 26 Sep 2026 09:24:48 +0000")
References: <20260926092448.4090401-1-tarunsahu@google.com>
	<20260926092448.4090401-2-tarunsahu@google.com>
Date: Sun, 04 Oct 2026 15:47:05 +0200
Message-ID: <2vxz8q4dlgrq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 31B54180007
X-Rspam-User: 
X-Stat-Signature: hboqysw6qjmrfrb9heeurk3fy7wrqy64
X-HE-Tag: 1791121630-856040
X-HE-Meta: U2FsdGVkX18oSpeYEIimwqNLKX4zQiR+96CFukSAfqFSx5SqEvRSB0ZR5gjZgtjIfHHLhwXE5hACnAlreSUN2yEL2k2BERA/UB56UZPp6djgcEUIKh7ZUr17fyZFyJFjVS8rx4KfaaABIN5c12PIiFzEV64k3+KjVSNlrAlB/qy9J4ZNWM2vU2K4tkBSvFK3quf+EIHnrL0rwO2WZZFHeNhIKb8sLLn9FQJDrp9z4LSsT+MifBxf365YsAGSskMlT/opWRiVfjB+MkWLqCx3QT3Q5cT/Cbqdm6wQ/5iUMMjcK4X60oK1yqMKr1Xoud55pikHp5JFk3acxqWCg/A8RnGbIzVbxcATORW/tvEJ4t489GCf55FPsYuRMdKBk/bMCx7RJ4nHu9X0Pm4V9eey4CYDEqHFWzjCRcHsL0da3UXECUzcu++paghG8EV8gY6+0KrZyG1ftwT+RAHykoXA6OVLnMD1z+TJ20ZZzBx+WYfZi8X559XiTo2X5kCMLwqoa9NYqSR8vc5DFESolCx9X1vXSd2s94JrCNShsaQWEDH993Ub8olMM9ZZwukDcfmZZtyeN7TMsI/oCiWF3XJStR+T1cBwmKt0zz3/2a+rMXqsOC00w9hgbeZx+n/RrP2dDFbu/0hBWdhq+UXgltQooegyJVOuOnvInR3DY5sxMniPdA6K92VVlNxTsFExBp9TeR9GIpGwi1saeN1mGgcdw12VEW6uU0Nd7HNkjYghnJP+E8sTQ/r4OcEsoo9htLSgz0TbHH8J/Y+BQuW2Ww7FCQZcBdh5sWyCqcjGzB0+I7x8uQ/OWta4f9ZolK4XjVA7aW3pQOlPwmNiJ6Li0+uXuUElXfGYbU7tiUQxX6fybNc1hEkcAZXyAIx4WBs1eQfOILYVrsHg2j8Kp3Z0G218/MQmo1QxuxicVcm0y77EC0no1SwkGY554hYOud1+WNrqTKqQgqAp5KN7iU1kdDD
 UTfcksma
 gX9cVa1FpbNwKh3KyTCi3Dmpfs43dAh4YLuybv/VVtT6seIyOoHMUz8Lc9+5PaiXf32o2fLcF7Tn7KbojCcVWskPxf+QBR03IylU2GtcWoHRfJGQOLx6EK/rm+xCC+ARnDkdhkqnGRAtrGxloZyuqdp+3zZgnFSypAJTpbkhfLq7H/A8twSL4dpYa28Gw9GpJwukZBlgMGhFeuig7giJV6YAT8Ix4yGbCQ6r+kPHRSLNGMo9Em73qvYUSbedBfqDAAlSO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26 2026, Tarun Sahu wrote:

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
> +{
> +	int mid, low = 0;
> +	int high = type->cnt;
> +
> +	if (type->cnt && base >= type->regions[type->cnt - 1].base +
> +				 type->regions[type->cnt - 1].size)
> +		return type->cnt;

In some testing I did of this patch some time ago, I recall that this
check didn't have much of a difference on performance. The binary search
is the real optimization.

Do you think this check is worth keeping?

Other than this, I only have a couple minor nitpicks below.

Regardless of these small comments, this patch LGTM so feel free to add

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

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

Nit: why have start_idx as a separate variable? Why not assign idx to
the result of memblock_bsearch_start() directly?

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

Same here.

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

-- 
Regards,
Pratyush Yadav

