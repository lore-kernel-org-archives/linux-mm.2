Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C77BC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F476B008A; Thu, 10 Sep 2026 08:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0C26B008C; Thu, 10 Sep 2026 08:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18006B0092; Thu, 10 Sep 2026 08:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D11026B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:52:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A7A81604F7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:52:37 +0000 (UTC)
X-FDA: 85197841554.06.058B273
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DA8E040006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:52:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeqCUcLM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789044756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xkj2AEIJUTs1kEBGyfC+T4+mC4iQhp2cUZ+Brvewmzw=;
	b=H+9LB7iwGxD7ja2idZvB3t/ggUict5V7FXHXA19n9PAw5Vms6o/sipvp1WW+V9io9KsVaM
	J5f4Ms0qRa6e6JZjAQ85Qp1ftD3Rww6xKI4/tJgyAezT2w1q7+xxkK4+ayOi0Pnh9xE6QU
	cRBYcnvwfi8zHbGf9VrLnuLOnKuE0Go=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789044756;
	b=VP5kJ0BzzdC/47ao8eS1+M5JPgdsACTp1cHtVXj3Dv/HJHSkfNGzQLWhmfbSO/e4lYVOMY
	vuftefhMecU9/XUFrbbRhwuGx/KIHqpxEgII0wsSoRsCeCLxkZ5l5Ig1yKjMJJkVqvLnzn
	LRRqqcljteaeExk1hLqf09ClDXeq4eI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeqCUcLM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09C0240060;
	Thu, 10 Sep 2026 12:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E051F000FF;
	Thu, 10 Sep 2026 12:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789044754;
	bh=Xkj2AEIJUTs1kEBGyfC+T4+mC4iQhp2cUZ+Brvewmzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CeqCUcLMGfRxLqY/XX/cbO647DQEZ6Mh7PWnYBSz+DKJeSPJ658VXN26O/AgJWLPD
	 /eflIiP/oB2t7cooFWq/hWvBbyg8b6p0bZyOYign06Zj42RT8NP+8gtPHWTOuyHdnl
	 lVlhN9jc7xufKTFPR0Ite0dlh++gl0Awo/ooQ+QxPaDWtgmEht6DzPIqomDJZOynNL
	 RBtZiW9Mlir9tOP2tBrLBx8f5E/kgt2mRtfdDNd9FUikkzVn+BGoFaAc4Sgn7FgeYC
	 0VBo5P4CCWTnWYoUNgz6muUp5UXnpgj3IakGl8zBZv+UrSi5ZUX4EVvfauJtFXR0wG
	 zEfJ96WE8dPOQ==
Date: Thu, 10 Sep 2026 13:52:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/12] mm/sparse: move mem_section init to
 sparse_extreme_init()
Message-ID: <aqKnDa6ukWwAXs19@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-1-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-1-008fc8d579fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DA8E040006
X-Stat-Signature: wfkmrm4m8xa4ehti5fnoc5xgs3yyo1po
X-HE-Tag: 1789044755-43333
X-HE-Meta: U2FsdGVkX1+kY2XDWzAY+XjNCJgHBlXMxAnXc5kKJg1gWlUrLfmc9zmGaohBMZ0+25D474XlivPl33jZ1K7nY7E3QCzY0IBANq0p2dwvRdarjXN39Jfp9MOZR1AGXu0YRNbuXmY0A4/g1fXLDU+siH6sjZl2uY/jjSHsuxTx0/7uIHKYLWKwlnBdoeej+Fa0f8JQztjw3naA8e2xhU74sRBQgOq1gT7F4VuBthP5BDFDLfOCK2xUoF1azAN0n/fJyxDttbWgg2fwXCWmGC4gjwQ7YlM1uMpMOshHO2FrhBlLt/sy22obKupvqSFD7jyU6JVSqJdGG6RlUPxM6VhvWG0xDvZladdJ2VUM0XJ3KVn9AJeW5VJpYYdbnrHqwAZPE/MSDeQSaSe8ZG3imGrEwTe5oXhfqSYPSAyxAHCW8LQYVDfEyhN04UDryEO+TaxNht5nF86KPqGFEIm9bDWc3pTAY4N7Wet9ONBDFgSPbvAQnwS0wsIhOe77OeUcD90fOBBkJppt7JvmSFUWThP6G/AS9Jli+lbbYUM56HtbReprRPagRxqotcoLyyrl4+2BSLSTb/bIlb2o/Fmw8yXSDxQ93nBs/leOX6w6ShOtrRAfcPldubASq2bBMZsnokWEja5ks9urHqzoqOdWBAeFnsj31DJbeWFl7zqwfTdQmyDuVQnnfrjqKJxf1sBgr6aAPFAZz/Mu4Mv+Xoi7SRReRwFftAePEMKBeNgj3/1r0M5yv3ZVNlmbnraMP//Dtl8Tfijf/biLFgkIBOlQSumXwldK5gPJzCQNLHkagNKQ9Rv91hA1GqR2dzZTp55lcd4gIr0usgzzCv66kd3E7nCbpbf6rRAfyRSmCjQM3csCykH8ucohSYDk6SScQ03oKY1OAks/GYUPRM+sBlTDOecJlHLPOb1WCjZCEdchqlgFmgo8EhfjjVlqxJe8rWm322uDqA1GZDUE50PpqH6oNdL
 6bpFPPIl
 9qYc3BZTG6VcWJDIM9/VzKWJIeU7slI5sP5+5bqFFmnjjLr8DgSuVinr8eXEqADv/9CSxFammOFmKtiRfEgv/bj9gox87dwIPEaVf5ezOBpwQN7k6BSxjcQLBwpPkGJll2h9ggcEBcU1/SaNWT/1rFGREobx39Hu3SsDHKLGhArZYHP+liFd8VlPRJfvVVLJbTjD6zw02L0Gz7hwc54frMlN+8Hu0MSWoMKzjcnSIKV315qKCviXe1HldqMrU+GzT4Jo8TtEXy4NFn6UuDOQhhoW84qfIdQixsqXzw8r3F0Orn+nC7X2KajwGE8DfaGk7qWEU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:54PM +0200, David Hildenbrand (Arm) wrote:
> Let's just avoid another pair of ifdef inside a function. While at it,
> switch to INTERNODE_CACHE_BYTES by just defining a fallback in cache.h
> as well, given that the x86 variant already provides one.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Nic ecleanup, one nit below.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/cache.h |  1 +
>  mm/sparse.c           | 19 ++++++++++++-------
>  2 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/cache.h b/include/linux/cache.h
> index e69768f50d532..b6e857b985bca 100644
> --- a/include/linux/cache.h
> +++ b/include/linux/cache.h
> @@ -89,6 +89,7 @@
>   */
>  #ifndef INTERNODE_CACHE_SHIFT
>  #define INTERNODE_CACHE_SHIFT L1_CACHE_SHIFT
> +#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)

NIT: 1UL?

>  #endif
>
>  #if !defined(____cacheline_internodealigned_in_smp)
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 9349ed6326c01..6a6d258862904 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -103,11 +103,22 @@ int __meminit sparse_index_init(unsigned long section_nr, int nid)
>
>  	return 0;
>  }
> +
> +static void __init sparse_extreme_init(void)
> +{
> +	const unsigned long size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> +
> +	mem_section = memblock_alloc_or_panic(size, INTERNODE_CACHE_BYTES);
> +}
>  #else /* !SPARSEMEM_EXTREME */
>  int __meminit sparse_index_init(unsigned long section_nr, int nid)
>  {
>  	return 0;
>  }
> +
> +static void __init sparse_extreme_init(void)
> +{
> +}
>  #endif
>
>  /*
> @@ -197,13 +208,7 @@ void __init sparse_sections_init(void)
>  	unsigned long start, end;
>  	int i, nid;
>
> -#ifdef CONFIG_SPARSEMEM_EXTREME
> -	unsigned long size, align;
> -
> -	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> -	align = 1 << (INTERNODE_CACHE_SHIFT);
> -	mem_section = memblock_alloc_or_panic(size, align);
> -#endif
> +	sparse_extreme_init();
>
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
>  		memory_present(nid, start, end);
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

