Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B1EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B79646B00AF; Wed,  1 Jul 2026 03:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04056B00B0; Wed,  1 Jul 2026 03:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F27E6B00B1; Wed,  1 Jul 2026 03:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8EB6B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:54:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1B8E140288
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:54:22 +0000 (UTC)
X-FDA: 84939445164.30.6B5ED2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 285E82000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:54:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FPMJNrxy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782892461;
	b=hrhYJBsaFoSttLA8gmRG7N64x0YmAv+h3lrZk9Sz2sdJtHv+nY6ydBL6JmrRrvAV7A9wFX
	+rs5oU0RY3fkE7Adj/XQs1bmpMHLcejM4gbguwfhg5km1hpyd+2eFrYsZJh5pvkODpTb8W
	g3iupb47E79gxGJt4GPm1cLCFNPKiwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782892461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoGwCpoz9l+DaS9yK/T7aMyhiRavJfkssRFkVojsyeU=;
	b=UeuuFtu+TtR+JAw5mKl0QPFnWmWJcvGGhxk8pNtaJ9vzY8ROlPLoNh0jgoiVmI0Qx1ypjW
	DRQVk2pWGjTdrtU/ot8//1ByeyjBDxGd2vRDmv7XSQcUKfMBIwewFOeDBNaJ2feKWd7rr0
	MrEqL6JrGYbhGpFpDjCDwyK4ptCFBpI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FPMJNrxy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A10B9601D7;
	Wed,  1 Jul 2026 07:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529261F00A3A;
	Wed,  1 Jul 2026 07:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782892460;
	bh=OoGwCpoz9l+DaS9yK/T7aMyhiRavJfkssRFkVojsyeU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FPMJNrxyKsiNwu1e5dvMIa8aiWktThZ4oTvZuWEl/UwLIdXaJMCXh6FKTK4L0516+
	 sbZagLjisYsO7E5gKG00+R/P5l7U1dAeqLHGieYJo6h0ygrlxD43xFZo3OU3naopx9
	 Pa61i0hCt1hTvGYqaKVTClH3x9JwNkdC8DWLcNkgjl5V8QU9Dq2gqYPB0pIJhivGWi
	 aqYyw7u1bLhXIbuehVx3el4lmfgeKc7QpxyvtVK2PCBE7YCwomLsKsxcpJMAmhWCLT
	 2/FGiWnuHPfGyCgHSAh+xg1cAB6d01llOP8lcrDlLKvR73Us9Oo8mEWjIsTbyLi3SF
	 Uul1PhhqAWz5A==
Message-ID: <f291fabb-2f08-416b-a3b7-407eb6d872ae@kernel.org>
Date: Wed, 1 Jul 2026 09:54:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/16] mm: Remove __alloc_pages_node()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-13-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-13-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 285E82000A
X-Rspam-User: 
X-Stat-Signature: o9er1kfbkjyjnjpo3rdiztn1rppma1pw
X-HE-Tag: 1782892461-136807
X-HE-Meta: U2FsdGVkX18wlUjiXwZNFBMziEVyD1BqGiyQAGQ6vnkgA7cxXLwXx+PISXMt1ISyj8RsO2fNc4gVYKQ1p34zqicBOHNserJ+/X4ts5+4TlzI/7gCqU1iWzeCNm+H3a7dyVtJahk+Rd25Su8y/i/Nx8oBl5sxktbi1PcqI7QtmjQLNuaaC1zV7VCrt4pVRQzy3fgsLQK4xtxEdTrmcJadeMR6a8cXlX4FBHHyAnuZj+T3n/aBegwK2hn5L8F/FfJFztpdcPvTkf15g/oON0snL/xCSZf58drPqn6eA75EI/qRbMno7JvYvhDXtpVfw169BG8i9oXFvM+1b0T6aQ5z8aVmOEigPFxB5TvG+7yjbwCEtXrAAdywM0STSpfIzQ5RrwEDGISjCvbSQxUsYmrrsUI4TuA4ndu9+RQ21f5k8BniYFjWX5McX/LrBvq+77b44RU0glCFNJeLOJ8TP9qMN06lINZ41dD7xjscLHypYYDVF16+QOC6YxHn9oMA/kp7B77fKPzYJQkYDzDB0AzsWkhEZANPhATELmObMJszZAxnT0i65zctZhkMiX8dTKecSCIEDONxC0rubzZAXS32WhUBYzVigxYrb7oSCXOSszPMh6SCeAZ4Zw5D15hnWlpLgLvU6f0edtF8tgEJvO0DXxzMl4d6ag0cDQoSpwtOCJLGJ+Er1VDKYbx5iccZ4Brco8/Vttt054zI32ld9XPsUPziWdKmaWyjHn9oeyrQh4awoHpEGPeu+grtMYRBHLQ+j7N/+VmDBQwd+xlFeO+3nalJBFmDWmVYDCY4kEAh6ltIrumXwgUkssDVcNyGLx3r6Q6SNg5LLv7WbyXeDcGFrK3F0TS668bIUDkOnXSJmdTNZn4P+HvMvCtFDCBAnEEX9kundekI+S2NWrlYEfUtOG5yUgLQlPwfwWpg/1eCfCsKe/enoFY9SU1GrCkLsiz9YzGmekiybRm9yaMmPss
 e3TboVuj
 WAAUVyocfZ+aIBdw3EwNVKYP6FpaUqftKyB9Ftb2pS9YkkYD3e0DyuLOkAQeXvT1iV5e6YCDRiyTGDagqpAUVH6eIrD5vIrHumVaxr+G5O/b2DCqTMQoYP8FnVy5b/Y2XgLruW0t5axP3xi+ZdsLnesj6ch2p7Vste8VPOX4g2dDVZe4TZGyx9AI2JtbgQDSkDCF22HxK7uqkoufusB3aRyoJRhdMY5K8ifSw+zSmwp7vkkapz9XICvelOa+6n6OeVu3hHjgdXQwsrpg0dsqKm+pDgsLui2hziTCwF//yx7RPhZB+NGEl5VgRsWadvYeN16+fI85HeXBqp4JDt0MaRuK3HV0KwojRfdZ07FhLPfC30WfBiUpg+D0EoA4BbG9bxaghcUaf8EpCZas5tAXDI4prgQFCNO3aR0aF7clhj7djFmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:12, Brendan Jackman wrote:
> There were only a few users, which have been removed. The only advantage
> of this API over alloc_pages_node() is avoiding a single conditional
> branch. The disadvantages are:
> 
> 1. More API surface, more sources of confusion, more maintenance.
> 
> 2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node()
>    were using the result of cpu_to_node(); if the CPU gets hotplugged
>    out this will return NUMA_NO_NODE. If one of these paths fails to
>    protect against a concurrent hotplug then page_alloc.c will use
>    NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
>    memory corruption or other. With alloc_pages_node(), the code might
>    just work fine.
> 
> Ulterior motive: this frees up the __* variants of the allocator APIs to
> serve specifically for use as mm-internal API.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/gfp.h | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 01d6d2591f49e..3bf55a5f9143e 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -256,21 +256,6 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
>  	dump_stack();
>  }
>  
> -/*
> - * Allocate pages, preferring the node given as nid. The node must be valid and
> - * online. For more general interface, see alloc_pages_node().
> - */
> -static inline struct page *
> -__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
> -{
> -	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
> -	warn_if_node_offline(nid, gfp_mask);
> -
> -	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
> -}
> -
> -#define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_noprof(__VA_ARGS__))
> -
>  static inline
>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
>  {
> @@ -293,7 +278,10 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
>  	if (nid == NUMA_NO_NODE)
>  		nid = numa_mem_id();
>  
> -	return __alloc_pages_node_noprof(nid, gfp_mask, order);
> +	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
> +	warn_if_node_offline(nid, gfp_mask);
> +
> +	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
>  }
>  
>  #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))
> 


