Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C0CC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E8C6B009F; Fri, 18 Sep 2026 04:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65AA6B00A0; Fri, 18 Sep 2026 04:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C696B00A1; Fri, 18 Sep 2026 04:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A57B06B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:08:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 303A61A05AE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:08:17 +0000 (UTC)
X-FDA: 85226155434.25.78590C4
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	by imf10.hostedemail.com (Postfix) with ESMTP id 21A6BC0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:08:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GYOIjE9T;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789718895;
	b=pEnNQlgFktujQ0iK/O3nVaNuuZxF20pb9WxBmcU5a/8u6CrbzIvG0LRYv89MOtXujVpFrF
	/HYcdphI/XH1+F8QPnf60gm2qpzq0MvCN2AcwCA97zfM6HKe+w/8v67yWDxLaWvk4e6UdN
	CahuBK3eNfAKmJq/8U962SHddjaFDRk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GYOIjE9T;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789718895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cm05iWolKHjPlNQoY8Tj98EKh/QANqizkq4K8fj4bGw=;
	b=OwbeiE0Ky6UrtY1NCnQOTwI01ASmfX9tH/1hw12ZCJnfFa87R7qTewGCVixEYWivKSOJRm
	/yivTGDh+7l6S+PorEq0MruPklQDXFtAA87QX/EljOgiLZk2JIMzSSwOHCcRLkzTyMdSb5
	w7mFXEs7YxFQz68G3/IXYKb/TCN0waw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xyISkBw574ZsXxKvu3xwdAxcFPyzjbZIs1ckRKr/QYs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789718893; v=1; x=1790323693;
 b=GYOIjE9TCS52kB3fasEHvocV/8o9kyickSQMkR89NrjEqDrcRo7nQvB/cqQnO+0Tj5dPpoTG
 nBygKi9DiR9Q8JDpWZYaeMzZhRwyJr700RwTNBDgmq+K6LMw5VsDWStD4oF15tqYBf9N6CpOzZE
 iQwloIBn/uTyOTtX1ltiWxJE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id e05f79cdbbeb581e;
	Fri, 18 Sep 2026 08:08:13 +0000
X-Mizu-Trace-ID: e05f79cdbbeb581e
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 16:08:10 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
	alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev,
	robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH v6 06/10] memblock: introduce MEMBLOCK_NODUMP flag
Message-ID: <aqzxavL91icLw-Xv@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-7-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-7-chenwandun1@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 21A6BC0002
X-Stat-Signature: o1o3m8fx9iikap7y17p8ua4inea63nuo
X-Rspam-User: 
X-HE-Tag: 1789718894-82566
X-HE-Meta: U2FsdGVkX18kinHp77wBGehKE+Lfi8oTHU0Z37BYqEzgBYfTBVu+6Zlf5rw+jx0g8rDnxFs1GesO610Y74cpk5zyp0/0yYwRRD4CvvhTOXmGDdZuvRQ32Rp/4seF5u157hB1pR/+BySVgDwVgOmVIHp53yCjg03HllBYLExf8xCgrWXZxmG7U9NOvdhMuzQT1HKVK2jSR6x//bNvYqCOckmOmgtHsJbrndXXzTSTK/PlUwlr6bCfPPm72/HqBZMbdeGBq/VwmYtbK+zQ0gLaV+OfYfDlqbyU+1XnxjCVAehwpPyWvbJg5Qnc419xAYsWYoq8qeIuYB39Szy8147BrmH8h2nrBeymi2JyHZcI28tTIs131u+TA1/VPnKylUN+RQokJIfRv8KZxOmfiGExTOOsmVN63Awc9wFa5VordcSdVYpmSk7RSu4O0avBJgaf510R2FkAgKqBSEc2v5UtEOAkKb6lZwiCaNk8gPOPQqKYACT9QUk/9HIZnD+4Hd1oqaY/MBYJ8jwZeBE3N/qppiKWC1rNli+MARfTOWoBx9TslWresCAU286SoK0pT+U3Ic/l9RKtDV7d21/K02W06RaV2RWHx77ad6wXJqMnb94a1kfILdEOEWV9jCUbkAYFsFKwml6ipLJfZNZQKkuvcdcukhR1AMaLjY2uyG/6+AYv/EpBRpUVQNxr+AefdCr7WWrOCLNIgu2Ppcsdj+uu1stUEtR5MHAx7/hPMufkfKYDFp0wI76wAOnuxS7guoPmg5LVckSwD9K0Pr0SQSFKX0PFZWZ1tnfWsK/pkHESBvmULj/LkvovCooUeZwRcJIqnIyWcZtil7FYAsEt7okroyjEPhsIwkWJzwu4VmH8Zg8PwLlN2n6Br3Db9xQNIPTzbDbQqk3fuv6xHxPaqNiDp8fmqIRCSfAx82mLLjEpkKssoAInbAqyvfMKQNxHmr1zWca1Fx28c3aklKcyJPW
 karJRNig
 CJ0Mp7s0JuiqmWkHs93p2EvsKIqbLSetGGCcgLeLQ4x+y/Ko9FVeAvZCdx6F+GV6uISWVjNLOJklmp6I2+tmrgPcDGApcDIc3dsxpWPxusLtO3D7s1+Ytl5eBfve2yW39Bjsi437TcZhGduTyO9R1/CfdPG01A6xtqe+OTWKPG9chDn/b+pNdCkg2cV8mkkmc812v8fug/PCk9XCtkVvNnpYtx8m2/qQo4WjFM77/MBhguUjvQ6t1oLTAeLI/HV/YrkkVQowNd3IiLMHM0csUorqsn8Ryg8E4tCFnpjuqwEqjE2Hjd8rNl779YaxwYm8SuSLbUQiafzA4r8+p2pAtjPqg9ida1zJSYBtD0INtayg1ScHBFM+NbyYxMMYXcZ/YrhtN8CsWc9VIiqDmGZjq1ccvBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 03:31pm, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Add MEMBLOCK_NODUMP to mark regions that should be excluded from
> kdump vmcores.
> 
> The flag is meant for reserved memory that carries no data useful for
> crash analysis. Reusable reserved regions such as CMA may hold useful
> data, so these regions must not be marked MEMBLOCK_NODUMP. Subsequent
> patches wire this up for /reserved-memory and /memreserve/ entries.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> ---
>  include/linux/memblock.h |  9 +++++++++
>  mm/memblock.c            | 16 ++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index d62db9e776cf..b2fcf11fba2b 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
>   * kernel that we know is good to use. It is the only memory that
>   * allocations may happen from in this phase.
>   * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
> + * @MEMBLOCK_NODUMP: exclude from kdump vmcore. It carries no data useful
> + * for crash analysis (e.g. firmware carveouts).
>   */
>  enum memblock_flags {
>  	MEMBLOCK_NONE		= 0x0,	/* No special request */
> @@ -63,6 +65,7 @@ enum memblock_flags {
>  	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
>  	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
>  	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
> +	MEMBLOCK_NODUMP		= 0x100,/* exclude from kdump vmcore */
>  };
>  
>  /**
> @@ -160,6 +163,7 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
>  int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
>  int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
>  int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
> +int memblock_mark_nodump(phys_addr_t base, phys_addr_t size);
>  
>  void memblock_free(void *ptr, size_t size);
>  void reset_all_zones_managed_pages(void);
> @@ -306,6 +310,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
>  	return m->flags & MEMBLOCK_KHO_SCRATCH;
>  }
>  
> +static inline bool memblock_is_nodump(struct memblock_region *m)
> +{
> +	return m->flags & MEMBLOCK_NODUMP;
> +}
> +
>  int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
>  			    unsigned long  *end_pfn);
>  void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
> diff --git a/mm/memblock.c b/mm/memblock.c
> index f2952d725c10..2e87f39826dd 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1204,6 +1204,21 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
>  				    MEMBLOCK_KHO_SCRATCH);
>  }
>  
> +/**
> + * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
> + * @base: the base phys addr of the region
> + * @size: the size of the region
> + *
> + * Mark the region as not to be included in crash dumps.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
      ~~~~~~~~~~~~~~^
Is it impossible to use at runtime even thought it claims to be generic?


> +{
> +	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> +				    MEMBLOCK_NODUMP);
> +}
> +
>  static bool should_skip_region(struct memblock_type *type,
>  			       struct memblock_region *m,
>  			       int nid, int flags)
> @@ -2887,6 +2902,7 @@ static const char * const flagname[] = {
>  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
>  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
>  	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
> +	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
>  };
>  
>  static int memblock_debug_show(struct seq_file *m, void *private)
> -- 
> 2.43.0
> 

