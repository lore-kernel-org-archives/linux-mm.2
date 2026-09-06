Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65EF3C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 19:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494146B0088; Sun,  6 Sep 2026 15:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444816B008A; Sun,  6 Sep 2026 15:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A5F6B008C; Sun,  6 Sep 2026 15:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10A0D6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 15:33:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DEB81C08AA
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:33:23 +0000 (UTC)
X-FDA: 85184336286.01.043CCBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD81C16000B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:33:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOQ+l3C3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788723201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kNqOTPkZp3J7RemsYmMnYNi7t0didLL0edZoqZbuyw=;
	b=mKBkhq/um7SahGvFpX/saveiOkxBBJyq/osr2TaoDkG6CsTLVdtGqiIe0GySi79vIv3AVF
	thn4l6Zpfx9N97gt0AKlyqEp7mKPZLlpusFO7R6+SXu8Lz06Uru5Kb2Lgo4U33JhPIYb7D
	0rFWp0vdAscw5IQ883YxQ0YHx+VaPAY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOQ+l3C3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788723201;
	b=jZLEVRK8sELcgyRp5Tz5CjXHyvMdh2ZLHcoKLqfYy88j2uFOvf6v4NIk31Br/tvb5GNzAi
	km5CU5/mVHg21rRdyB8epOHl4N3FfFwCFI+Im3LqtbKUYD0KCgdzTf8TwVBYT5cnthbYDo
	c4RazB3t/K9XUMMLDVK59ssJF/kIwak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24BB3601F9;
	Sun,  6 Sep 2026 19:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2B71F00A3A;
	Sun,  6 Sep 2026 19:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788723200;
	bh=0kNqOTPkZp3J7RemsYmMnYNi7t0didLL0edZoqZbuyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UOQ+l3C3lLujBRXFNmIZbndVsdbScZNJL6O1tqSdqMjmQrjL6ZYziJuWgml1fG0Sf
	 YZjhOpebC9esQLeWBd/jXa9dy1aBOGM9VUfFMdkM1pq8Z2PBJM6ySVz5xzTC6IWHcr
	 hUPG4TiNf0iGjXu2vtdIdxNSmSj85hQyuGO+G/8KJIYORUlSuKuQuG/X9RChqR/x9Y
	 DsHFniEg6Ij/QnQKTcdYooZxqdcI9V1/aRc3LxVfuVuJOyhGvQIWOkfgrAxuFPAZe2
	 vs5e1PdKfZ70Pm/jfgXnCkSDYJMr9D6/FyFbnT3DbR7iuUbU7GjmYCz5kkL2F0VMoz
	 puMLclabJJmcQ==
Date: Sun, 6 Sep 2026 22:33:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org,
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/10] memblock: Introduce MEMBLOCK_LLMAP
Message-ID: <ap2_926WXr7uAYVX@kernel.org>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-2-vdonnefort@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902104712.2399797-2-vdonnefort@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD81C16000B
X-Stat-Signature: yqqnx93szga65u5skac4qqdpiwxw8mc6
X-Rspam-User: 
X-HE-Tag: 1788723201-993157
X-HE-Meta: U2FsdGVkX1+weMZ4GEOHay+Msw3z9xS8OlxRxLh3LHuPw5bFZOuqu6OHDHUEZVF0IBCDzL/5CQkA+ee+utB4jbJVjjwrvSsaXtt3wpw0rSel2YAC+PJv0UAGXJkRJ3n3PGc9fnKkZ9DcLRZ/4JmUe2jRjjJJk2xFp+vbSTaqpOLdg5zM/UaTBtf246FzRROdl2mUPW5CKs3D/JGMmIxLNRSANrY5F3fFRGIHaGEN6lGasdFk0OTm3IKdkWOsSEflgfkLcxsaaZReyk7tVudcxuYzYB9JytluXpcx0N2C5v9hhL2sfw9LHVgQ5fXI7h98gh7SnItSgx+88FgXTiSn6RMqIGDq2XcmnymgwhkUjxXhB86UM8LdiCzoMQk6a3Qr6tKa5Jw0iK3TUAlWPxlLDri7Xt1meJ3Wz15SjLd57iA1WuZKrP/C2wDgcwQijV77hcdlQPy5bHYU2fDX+pdO4jtB6Xw+gTgDiub57jKSQBOLEYHumrLK9lkPKjMVE3/jdAutEzigWpf+1YqZba4fNwnhqI1AvQgH/+DCBOGFWFnrl+5pHpH+wKBbrRome3vt5dBICa+Ds0ewdtwv1HXEBdDB2JwDsdHul+D+QNhv6royb6+YqgNeDNol23w034S0V0E3bGDL9sSsLpss/+EAYXv+dDwB4R8W+oOvEx78dhd97deHO/Vh7YQyp2w4qsKbt7o5YgPjin3/Riliba0M5T0ZsXhaG5UU4kWg7TZxo5/E2QEEipv2eTXPulNw+UX6n+nmHbaEd1XW5PLT2pwXUyyeTcYcKNDbWJuWGOEGYrqa4WT0aJtWIUKtkKxE68IoUyN+wGuOtduGZFBzLtsFb3TgqSjvfzziVahR0vlk84eKiUwKadwMjpYUAFVomLDMCK3SvDSoaKvUlbQpDGEaVVeyQgW9gnCA1CZbDFD9qpaoOqo8qposBZOKnPgJ1dmf4RFhSWO3Q26fGNQNh0A
 REC3infh
 YwbG+qN3flIX+aWYUTUqse9Gp212TJCcrv7bFILnitHM0rWcqdCXmTAIu2QKM/stNRoB03H3GUuewG5tl7l40ilGdH0PStFVNpxFjsAwSEKiqir53wSsW/fhbaaP28BU1fjhKSSVsT9GDIJJW9FHi0f7rmX5+m7TM3ZIr477dmJLAWSjuyHy769pzwwjEAZsjDHQlw+9AUwoRhwbsMcz4sO4ZKmnzglpku7egNDPpgf0uegH0LKd2N2Go7nbqwRM3DRiu6RVhJ1E1XaFCUtSxUyFktpwhgzCSQY+UPKt/3TOt4vZbj0cNtQrZgSjFInMfGCNOqBW1fNlPCnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 11:47:03AM +0100, Vincent Donnefort wrote:
> Keeping last-level mappings is interesting on some architectures as it
> allows mapping/unmapping pages from the kernel direct map without the
> risk of splitting blocks which, under the break-before-make rule, may
> trigger page-faults the kernel can't handle.
> 
> However, mapping the entire direct map at PTE-level is costly. So
> instead, create a new memblock flag MEMBLOCK_LLMAP to enable the system

I believe MEMBLOCK_PTE_MAP sounds more descriptive.

> to decide which region must be covered by mappings up to the last-level.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index d62db9e776cf..d40a5ded188d 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -52,6 +52,7 @@ extern unsigned long long max_possible_pfn;
>   * kernel that we know is good to use. It is the only memory that
>   * allocations may happen from in this phase.
>   * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
> + * @MEMBLOCK_LLMAP: memory region to be mapped using last-level mapping
>   */
>  enum memblock_flags {
>  	MEMBLOCK_NONE		= 0x0,	/* No special request */
> @@ -63,6 +64,7 @@ enum memblock_flags {
>  	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
>  	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
>  	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
> +	MEMBLOCK_LLMAP		= 0x100,/* last-level mapping */
>  };
>  
>  /**
> @@ -160,6 +162,8 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
>  int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
>  int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
>  int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
> +int memblock_mark_llmap(phys_addr_t base, phys_addr_t size);
> +int memblock_clear_llmap(phys_addr_t base, phys_addr_t size);
>  
>  void memblock_free(void *ptr, size_t size);
>  void reset_all_zones_managed_pages(void);
> @@ -306,6 +310,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
>  	return m->flags & MEMBLOCK_KHO_SCRATCH;
>  }
>  
> +static inline bool memblock_is_llmap(struct memblock_region *m)
> +{
> +	return m->flags & MEMBLOCK_LLMAP;
> +}
> +
>  int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
>  			    unsigned long  *end_pfn);
>  void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 9ce86349a29f..1591b50503ed 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1119,6 +1119,16 @@ int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size)
>   */
>  int __init_memblock memblock_mark_nomap(phys_addr_t base, phys_addr_t size)
>  {
> +	struct memblock_region *r;
> +
> +	memblock_cap_size(base, &size);
> +
> +	for_each_mem_region(r) {
> +		if (memblock_is_llmap(r) &&
> +		    memblock_addrs_overlap(base, size, r->base, r->size))
> +			return -EINVAL;
> +	}

I'm not very fond of implicit skips here. memblock has no idea what's the
caller intention, maybe it actually wants to change the memory from nomap
to pte-mapped.

I'd rather warn in memblock_is_nomap() and memblock_is_llmap() if they both
are set and let the caller deal with making sure they are not.

> +
>  	return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_NOMAP);
>  }
>  
> @@ -1204,6 +1214,45 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
>  				    MEMBLOCK_KHO_SCRATCH);
>  }
>  
> +/**
> + * memblock_mark_llmap - Mark a memory region with flag MEMBLOCK_LLMAP.
> + * @base: the base phys addr of the region
> + * @size: the size of the region
> + *
> + * If supported by the architecture, such region is mapped at the last-level in
> + * the kernel direct map.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +int __init_memblock memblock_mark_llmap(phys_addr_t base, phys_addr_t size)
> +{
> +	struct memblock_region *r;
> +
> +	memblock_cap_size(base, &size);
> +
> +	for_each_mem_region(r) {
> +		if (memblock_is_nomap(r) &&
> +		    memblock_addrs_overlap(base, size, r->base, r->size))
> +			return -EINVAL;
> +	}

same here

> +
> +	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> +				    MEMBLOCK_LLMAP);
> +}
> +
> +/**
> + * memblock_clear_llmap - Clear flag MEMBLOCK_LLMAP for a specified region.
> + * @base: the base phys addr of the region
> + * @size: the size of the region
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +int __init_memblock memblock_clear_llmap(phys_addr_t base, phys_addr_t size)
> +{
> +	return memblock_setclr_flag(&memblock.memory, base, size, 0,
> +				    MEMBLOCK_LLMAP);
> +}
> +
>  static bool should_skip_region(struct memblock_type *type,
>  			       struct memblock_region *m,
>  			       int nid, int flags)
> @@ -2886,6 +2935,7 @@ static const char * const flagname[] = {
>  	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
>  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
>  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
> +	[ilog2(MEMBLOCK_LLMAP)] = "LLMAP",
>  };
>  
>  static int memblock_debug_show(struct seq_file *m, void *private)
> -- 
> 2.55.0.970.g62bdec98f9-goog
> 

-- 
Sincerely yours,
Mike.

