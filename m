Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B54D7CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 20:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC9D8E0003; Wed,  1 Oct 2025 16:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094B78E0002; Wed,  1 Oct 2025 16:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBB98E0003; Wed,  1 Oct 2025 16:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF3308E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:50:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BC6FC0289
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:50:19 +0000 (UTC)
X-FDA: 83950738158.14.F7F1BA7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf04.hostedemail.com (Postfix) with ESMTP id 42B1C4000C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:50:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lebovFAQ;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759351817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+sY6hHXmQmAq3I5l+Bc3KZ+ZPYaRF/aEJFBBdkRFCM=;
	b=qhEwlXDaU+4AowkFSEsru6+DxeySQXcsvstHQ750PLmKPp/usy8uD6sdewtUBsSHsuGlnE
	rjIp6dVZBtePq7L5hLod3HXUG50wVAWnN7uvVmpxSzf4vbor/gXY8iebauPp872f2EArTY
	tTUM3qaKyAxC/npSb539nPOLDLR0oLo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lebovFAQ;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759351817; a=rsa-sha256;
	cv=none;
	b=8IWw0qoVzpBgtaEQShrmgX6dkzkQ4BwaMQc5qLwOwBZVSyinEWf4fzWxpaJ153N5E2yId6
	P/HZRX9a4HPVCxwXFY7ae7BPuHI5I2U3P9q8xG+a8GGPTHlmgWre0+wrMC13j2yZdmthSt
	xTniJUT6qmkwyUSFfCsyoUVJEhdsOQM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759351816; x=1790887816;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IB8uPb6EUBcGWblRPI+e7U2JqmalxFcJYmMrRUroNbE=;
  b=lebovFAQQNtbxcycmR7ZxUhnmAbNWmjdm1b59hQ4UU0T/+65gkyci0eM
   lc243CQBAmDV5fv0PenuALMOJJDA+TQjX0UkfUU4ONE92PHIQDoGE3jZ8
   HzwdJGI/Dvj0d9IcalB4Qt/Glzt2EGR1fv5ibd/oHZAKc2pONET4tg1RQ
   zxV4PkAYZQAFbNUonDk0XOduWtnxAr9iJHJ8dAXUmTvGr4Wcar7Se7Vhk
   xWj/WJWQgELpQK1GYTjRT9jM1XLbV7ZqbXicBLO3f34MH9/k4ezCl/OKK
   6eHGW5XcZSkqHTLuec0nQag5umTEtU+W0gEfsGtRq9HTSKwxFMLWe5fmX
   Q==;
X-CSE-ConnectionGUID: ToskuKLZQECiQ+Q1zBuLvA==
X-CSE-MsgGUID: xvKT4A82Q+K4l0XxlOSZOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61548716"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="61548716"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:50:14 -0700
X-CSE-ConnectionGUID: PphuQsj6R32nVbv8mRQWjA==
X-CSE-MsgGUID: Q6Riu27eRkCBy6UsEdHvtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="178166843"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.221]) ([10.125.109.221])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:50:14 -0700
Message-ID: <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
Date: Wed, 1 Oct 2025 13:50:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
To: Brendan Jackman <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
 mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
 david@redhat.com, derkling@google.com, junaids@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
 rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 42B1C4000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: iztagwu4dz1r8a6dk98komwnf6u988oq
X-HE-Tag: 1759351816-453860
X-HE-Meta: U2FsdGVkX1/beehPsiMJc312/G/FzvtiODdu7pK3LyqHzHzB7XVs9w9R2IweWY2SAQKD351y8ttlrsG0xBuHKrzy43GNnLVgTTs+ZfaZquzbrR1Uam9lBd0Ksv7rKpkMzoILbZXRu1/HhDdper9u4jl9uu7lCQF2OPjBARvN834c5q9hCXQfsjIqn0DguyG/YOFyVOsgpn6Iz5N9GzVfDTRp4fqVBHqhiQVx7vEEwcmBz8rbQcMcrYKiuHaKrIuVvdP8BwZ7DU8M9BYGcuLuxMaWy1l20HqNAyFLHOR++vx6+sTAcMCDwTlG/t2T5Dbfxx2GYpwUPNMTX3L6MtB4hf/cJIx2NT/ZPUr6EHmk8GT1cCyrutxP3e/fp2XVGS13zMIfw/RjnnPZXe4L8mXK7f/AtYHul2iJ32S3/Grg57liKZWM1blpOOQlkg6CmPu8pNaTBsunHzY7TtdRPZBVEMaih+WlxJ+ozxjg1DvP1i3k5r+5Gl4/o3e80NlmQ0Kti1MeSIsN7KUVB6PWOe5NZIthxlTdfz+KL+nJYuLBcfU4bclB1yNwyoRcjttjeYqLQo6viUI1PpSJ1RMqIoHXkk1IB6oWvXNoNLBhjdLiOdIhfEG+zOt0yoJKSx2sK8UcgSWBsrf+hJtTzGr/y8XGyJQ+5hHgvxoU6FQ/3Lm+t2g0ALhlDYP1DA+SfdH7PwgUZPGe277VgI7khvAu/Qmx1o8S1+a73suBf8rGvv+YJtVn4XfdQOkJowlIx8/QMQwWbrxEIy5VQnG+8nx8r6FcovH5W6GploQ8XRghdJXZksBnqO5ybW0c3t6Y5PTWJ4GFWF2Oxx1Ab4cclULTLeCTpHGVizybQdSjHG0SO0WK/O1Gdylhkn2EPDG0/GLm3ssQO/VzVla03BlFooLWYa7FmDYNZt9hNmZWCak1niHhQKyaxGVSVPfbGDQ5qHe8v3oiwKN0ObyPZlUZ7f1fnZG
 cTXC3ora
 z5ofJwinmzJT8jIQ9/L0RP+jOKtL34SurUyibSaV5xliT59Jw/xQrU84QbsI4RUG4j4Gl2fQZ8KeQM+DcvdtK55HnUCIpl5zUPh2wsKlB9nWZdywGKtlXaih4zRfPwL7QlZ0yXUUGjRb8N42jfp7K06kMsRvve2+wxpNo5ybHSUdvGz9quUkYjfzIfeAxS7W/IL+uEDDyhaOmObQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/25 07:59, Brendan Jackman wrote:
> ASI has a separate PGD for the physmap, which needs to be kept in sync
> with the unrestricted physmap with respect to permissions.

So that leads to another thing... What about vmalloc()? Why doesn't it
need to be in the ASI pgd?

> +static inline bool is_direct_map(unsigned long vaddr)
> +{
> +	return within(vaddr, PAGE_OFFSET,
> +		      PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT));
> +}
>  
>  static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
>  			       int primary)
> @@ -1808,8 +1814,7 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
>  	 * one virtual address page and its pfn. TBD: numpages can be set based
>  	 * on the initial value and the level returned by lookup_address().
>  	 */
> -	if (within(vaddr, PAGE_OFFSET,
> -		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
> +	if (is_direct_map(vaddr)) {
>  		cpa->numpages = 1;
>  		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
>  		return 0;
> @@ -1981,6 +1986,27 @@ static int cpa_process_alias(struct cpa_data *cpa)
>  	return 0;
>  }
>  
> +/*
> + * Having updated the unrestricted PGD, reflect this change in the ASI
> + * restricted address space too.
> + */
> +static inline int mirror_asi_direct_map(struct cpa_data *cpa, int primary)
> +{
> +	struct cpa_data asi_cpa = *cpa;
> +
> +	if (!asi_enabled_static())
> +		return 0;
> +
> +	/* Only need to do this for the real unrestricted direct map. */
> +	if ((cpa->pgd && cpa->pgd != init_mm.pgd) || !is_direct_map(*cpa->vaddr))
> +		return 0;
> +	VM_WARN_ON_ONCE(!is_direct_map(*cpa->vaddr + (cpa->numpages * PAGE_SIZE)));
> +
> +	asi_cpa.pgd = asi_nonsensitive_pgd;
> +	asi_cpa.curpage = 0;

Please document what functionality this curpage=0 has. It's not clear.

> +	return __change_page_attr(cpa, primary);
> +}

But let's say someone is doing something silly like:

	set_memory_np(addr, size);
	set_memory_p(addr, size);

Won't that end up in here and make the "unrestricted PGD" have
_PAGE_PRESENT==1 entries?

Also, could we try and make the nomenclature consistent? We've got
"unrestricted direct map" and "asi_nonsensitive_pgd" being used (at
least). Could the terminology be made more consistent?

One subtle thing here is that it's OK to allocate memory here when
mirroring changes into 'asi_nonsensitive_pgd'. It's just not OK when
flipping sensitivity. That seems worth a comment.

>  static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>  {
>  	unsigned long numpages = cpa->numpages;
> @@ -2007,6 +2033,8 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>  		if (!debug_pagealloc_enabled())
>  			spin_lock(&cpa_lock);
>  		ret = __change_page_attr(cpa, primary);
> +		if (!ret)
> +			ret = mirror_asi_direct_map(cpa, primary);
>  		if (!debug_pagealloc_enabled())
>  			spin_unlock(&cpa_lock);
>  		if (ret)
> 

Is cpa->pgd ever have any values other than NULL or init_mm->pgd? I
didn't see anything in a quick grep.

