Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25965C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019A86B009F; Fri, 17 Jul 2026 12:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34006B00A6; Fri, 17 Jul 2026 12:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22E46B00A7; Fri, 17 Jul 2026 12:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2736B009F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:21:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20BE8801E3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:21:07 +0000 (UTC)
X-FDA: 84998782974.24.0610851
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 490084000C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:21:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a12utA6z;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784305265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEBrAHUFnk2FiioO0VpLsJTiSrnUVA33Eunb1QkbnAs=;
	b=B7OXT3t/yaeBsPkZqRW8qNENNouOoRm1jbYmELT4758N625KpNZIGe2anZcHsIfLGEoUHb
	MIRg7K6DyrQUYLV/o1nnrTxvYRHLYs2n891oSTejpflQ90gnBEu4lPiGIZfOMTWphBGCm6
	FkUj1VswRFZpbpkELQqO+yDtG06G0S4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a12utA6z;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784305265;
	b=qGfzlFNCJOFLQ2ihluW0w2HwoYArnwGUzyZKKR6NYrdEvYu/cjxIqn6XzhyPWMLkbz2nAi
	CXpGE9QbwWDYDX8BR604ea2oSHwnL++8wT5cARK4ZxctoKY/gQpsdU45vN1fCz2PFSxyQ+
	8jJNBc2ztpdwoUePOeoIKXxYCXV296s=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-80a123ef90aso31693297b3.0
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 09:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784305264; x=1784910064; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MEBrAHUFnk2FiioO0VpLsJTiSrnUVA33Eunb1QkbnAs=;
        b=a12utA6zOe4Hj5jTF3IObQbwAgtGjPY+BNQIMHo146yMrJZoam3wtraVS6Oglb034h
         vAweHBQROdFx+fGgVzCHMOG6qbkmaxq8GpuypoH2uHPs1ol3H2CHHBGvjZAURHQ82Ivc
         JI5eSqYPOzEaFFQU8LzwgN/Yi3XIdb8ngoNBHIZwId8xjz+/kkiYUgIHoN3Fs4oOQ81l
         1irAXUJiM294VLUVB7kcHgIZJ0bnpSxqgtwptGgSz+Jn1olzEMeZjqURMRHb/BeQ2q/G
         roPtAO9wm9O2cBN07MefDVEAdEpWKAtiR9thl1d8sN22pZh4Fxlrrd9nKDTOCn1kkWvs
         /+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784305264; x=1784910064;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MEBrAHUFnk2FiioO0VpLsJTiSrnUVA33Eunb1QkbnAs=;
        b=K7JVJLBEtdWzMvm/6XQzWXaZiBeRMGagGGMRjv5ewexHkvXn/5FFPrCLhQjBe56j/v
         FCDD0EEVQlEeuERl236VEh6eOJz8y48T+zmhZf8qj9Xr7d50WLHnp4YSag1vwy5zwVVL
         ytrsf0uhk+NECp4udF0dZ6chGVVGPT0SxseMKMroAG4ExdnKrq3OOpfEe4LoQQ3m6Qv8
         CbBo/2O9aYsIXrGFcyF+sStUJ28MumIHL7Oq6gVsY/c0Tt1eD2w4xEuue2/4zWYGzdFy
         pLQFOjXEfu2MZupt+NS2ERGtrG9W0noalM8KN14Ni2qX5cBHHyGX0Fwm4HZk1PDjxMkO
         AYXA==
X-Forwarded-Encrypted: i=1; AHgh+RqdY27LyMKDnsRPIC0HH7OXfDxXZBsZyXVC7Y3/ym/sA04oo5g4D2WqPQNSrx3oZ11FgJhX8cMzPg==@kvack.org
X-Gm-Message-State: AOJu0YxLm5A3aMBxi+tLvVWcKJxU+BRT034lCmH9CYNhwVJxqCxLrC9z
	IUHnXRGMmICPSKrKTFIJBzNYmFcSOCJRIoedTQJvzsdtrEO5pmjF86BG4WOLpOpm+Ks=
X-Gm-Gg: AfdE7ckn1dmDAsn7FjuYX0EGi2+WJs2yF1REbepA7/94uq39Qczu+cLnJIxMAob92aE
	6/KFNSbleVTxHY0BahwGpCykMz8rrBrii0hn3PBG2yt1smrT8Ep2mMLWP4og6LuHPPedvTBWwl1
	yIrOyCnXKbMNwijiD3wS3XWUO7uH0tme5TmKPaDf8030M2qXx+O5Vh0j0Z82+0VJ/RqAsfwQJYU
	qHzbcJG9ccjxa6kOJJkw2wGjvVyOTXGFddjEJw0Jq+ixTTnuUGHhHN6V4Snc0hogbjUXcDAfuWR
	8ozQ0p7rtMtxmvLUD5IjAGASchggUygfhmSAFixwqkY9131oFa3wQBjGbubcEni3wrKDuKOZVV1
	9QdSQGDwLfnmMDSSdGU4JlYZ+FflI9xOKqeu9d1kvWhuYGTpQsSlA/FpiHNm8HgZd+hVSgXCdMK
	KDOiU688FhDUP2+dqELSMacdSzWX6pmpv1Q74w9k0G6HS7eydPkui0YDubzVCaLW0toTKR/Zr7a
	/xlR469Z4go
X-Received: by 2002:a05:690c:c4e7:b0:80c:88b8:2dd9 with SMTP id 00721157ae682-81ef15ea910mr12966957b3.35.1784305264127;
        Fri, 17 Jul 2026 09:21:04 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ef42e89e8sm13834677b3.44.2026.07.17.09.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 09:21:03 -0700 (PDT)
Date: Fri, 17 Jul 2026 12:21:03 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Michal Clapinski <mclapinski@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Evangelos Petrongonas <epetron@amazon.de>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
Message-ID: <alpWWFo1gnxVnP7T@google.com>
References: <20260717134028.2880508-1-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717134028.2880508-1-mclapinski@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 490084000C
X-Stat-Signature: ac881s94cgrhdsdkgcp1tkh91b3fb4rf
X-HE-Tag: 1784305265-7980
X-HE-Meta: U2FsdGVkX18ad9d0xuZJNwIyuJ1AHM2Hc6mfxuj1x01Xfdw5H6FFUtYKm3kSaoUanjtzaTsHfhTlMdmmJCy+q1IKeoBsDulYkQPXEC3ADf7thTZrUJY62bRAGUsVq3pxD34Pgao52baZo4HsU7EIEBkxP3bTGYhh+kiGkOmOLq9V1hOKGtYuP/ST65HxgHWDnS1QJ4KGciSl+Td1GToqPnniKBJu3TqB5DRPQ3X+MlP3fgB+9UbjN1H+M/k5mDFs4H7yjQ86brBeVZaLb3MtkjWRDL6yzJ/OIRyRNfAbTq2o8H2GOwRrRHyFEebiwiYFqNL5r3VHsj5P+G9o5xrxgn7wGMXwcMHbeHCjCCAglEgieJiAwLtxRvbI7b3ywj0GIO4FBwLMq2j1q+3G77rQ7OTVD7+cyPk+BtPUsNCV0vVdbT7RqavH0KiU4Q55dWDa8jjEPFu0gHawYbZy7W1TG9EICbmRUcSOkg9a/yjo4h7dK9niT5JvVz+RcQsF53y7PIfUCWuYfhpYIa4OqF6rofuYmQ5F+62rq/F4S1GxnaOmvIHbMQSzEnhf6OXyGBYJTXtlG68CzziCvQzCRvY4ZKQjbFQPFlF0M54ZNybwj6yXJEamC7epVE4u5Qy/Y1vxlTUTMrl9xB+uQzI73IlKqt5cPgUdvdYpTv1FtsqPFbjySF+2lMT0Dsj6RfD9vK7ir4kg6HSGCiOL8vLKsJjyp+kzsJQ+tJTDvUvwYgkHRXGwKrLzswVtXVrwJixbklHaCj8YG2h1x46OVt/4IEChDFbhG+PJKlvkEaUCfyzjjKhJISqeTQvVgx60rhFC02kNZYqMkW7sxud9iMxzM1V17Ql06WLOkId1pY716D6f0c7WCsCwxbseAFQtBqIh1Q+4Bh0GyqVPH3x+Y9aIGpwRjo8NshWhPWquGBztConiTude7UGOk42dXNs0QZOB1DRdcKoGFDWeKAGpLNhPXyw
 K9EKLrf4
 mhMWseR3jsxItO5cyIhAmIm5z9xhEbKL0XTBLG0WC3BiziMJ5l1M2NtDEeEFi8hpnNfD9E7RIi7KwmFE357JQYgEFdiAfXNBXQrGrEU7MUWPfCwe1laRnxjIMJzSkLccomoAb5TjmtjRao936ymvUhJlRwrg+md7OxC82uiacAB99DYpPHGJIpIxKAqxpsrHtxswpic1u5v2Yc8MzP4zAR/ETbV493+d3ob+LWNjeVV4IAyUP/IenSbd/AA0fai2lD+88aJBB5HFK+dmkr0UDClAv/eReBiOMNciTMlj0t5CPK5QCFQHWeYcucHBzm65XExW2tBLHa9E40WYXXRocVinCE0LawBkwnlCN/0MANhjJGxTaT8uFFN+sMtkMOQ+x6Pur+ufYmwLvuVJEfamQKYRuFPC4Bswgp6i6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07-17 15:40, Michal Clapinski wrote:
> While booting with KHO, the following crash was observed:
> 
> BUG: unable to handle page fault for address: ff19164fffff8328
> RIP: 0010:__free_one_page+0x1a1/0x6b0
> Call Trace:
>  <TASK>
>  [<ffffffff913208bf>] free_one_page+0xaf/0x240
>  [<ffffffff93973288>] deferred_free_pages+0xa8/0xd0
>  [<ffffffff93971b4f>] deferred_init_memmap_chunk+0x10f/0x1b0
>  [<ffffffff9396e265>] padata_mt_helper+0x65/0xa0
>  [<ffffffff90fac402>] process_scheduled_works+0x202/0x410
>  [<ffffffff90fae739>] worker_thread+0x1f9/0x2d0
>  [<ffffffff90fb62fd>] kthread+0x27d/0x2f0
>  [<ffffffff90fae540>] ? __pfx_worker_thread+0x10/0x10
>  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
>  [<ffffffff90efdc55>] ret_from_fork+0x145/0x280
>  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
>  [<ffffffff90e2e46a>] ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> deferred_init_memmap_chunk() interleaves initialization of struct pages
> with freeing them. This works fine without KHO because free regions
> will never be neighbors. However, with KHO, free memory will be split
> into (free && scratch) and (free && !scratch), which can be neighbors.
> 
> KHO scratch is aligned to CMA_MIN_ALIGNMENT_PAGES pages but buddy looks
> at the neighborhood of MAX_ORDER_NR_PAGES pages. These values are
> configurable but CMA_MIN_ALIGNMENT_PAGES is always less or equal to
> MAX_ORDER_NR_PAGES. In the crashing configuration they were set as
> follows:
> CMA_MIN_ALIGNMENT_PAGES = 1 << 9
> MAX_ORDER_NR_PAGES = 1 << 10
> 
> So while freeing one chunk, buddy accessed uninitialized struct pages
> from another chunk, tried to merge the blocks and crashed.
> 
> To fix this, let's just align KHO scratch to MAX_ORDER_NR_PAGES pages.
> 
> Fixes: c6073743d0c7 ("kho: make preserved pages compatible with deferred struct page init")
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> ---
> Unfortunately, this is very hard to catch, so I don't have a good
> reproducer. But I run the code with the fix through extensive testing
> and it seems fine.
> I think I've never caught it before because enabling HUGETLB is what
> causes CMA_MIN_ALIGNMENT_PAGES to be 1 << 9, instead of 1 << 10.
> 
> If this passes review, please cherry-pick it to 7.2 so we don't release
> a broken kernel.

A changelog would be super helful here.

Pasha

> ---
>  kernel/liveupdate/kexec_handover.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 4834a809985a..175c08a6e41e 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -38,6 +38,16 @@
>  #include "../kexec_internal.h"
>  #include "kexec_handover_internal.h"
>  
> +/*
> + * This is the minimal alignment required by deferred struct page init.
> + * deferred_init_memmap_chunk frees memory to the buddy allocator, which looks
> + * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them.
> + * If KHO scratch is not aligned to that value, buddy can access uninitialized
> + * struct pages, which can cause a crash.
> + */
> +#define SCRATCH_ALIGNMENT_BYTES (PAGE_SIZE * MAX_ORDER_NR_PAGES)
> +static_assert(SCRATCH_ALIGNMENT_BYTES >= CMA_MIN_ALIGNMENT_BYTES);
> +
>  /* The magic token for preserved pages */
>  #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
>  
> @@ -640,8 +650,8 @@ static void __init scratch_size_update(void)
>  	 * Scratch areas are released as MIGRATE_CMA. Round them up to the right
>  	 * size.
>  	 */
> -	scratch_size_lowmem = round_up(scratch_size_lowmem, CMA_MIN_ALIGNMENT_BYTES);
> -	scratch_size_global = round_up(scratch_size_global, CMA_MIN_ALIGNMENT_BYTES);
> +	scratch_size_lowmem = round_up(scratch_size_lowmem, SCRATCH_ALIGNMENT_BYTES);
> +	scratch_size_global = round_up(scratch_size_global, SCRATCH_ALIGNMENT_BYTES);
>  }
>  
>  static phys_addr_t __init scratch_size_node(int nid)
> @@ -656,7 +666,7 @@ static phys_addr_t __init scratch_size_node(int nid)
>  		size = scratch_size_pernode;
>  	}
>  
> -	return round_up(size, CMA_MIN_ALIGNMENT_BYTES);
> +	return round_up(size, SCRATCH_ALIGNMENT_BYTES);
>  }
>  
>  /**
> @@ -692,7 +702,7 @@ static void __init kho_reserve_scratch(void)
>  	 * next kernel
>  	 */
>  	size = scratch_size_lowmem;
> -	addr = memblock_phys_alloc_range(size, CMA_MIN_ALIGNMENT_BYTES, 0,
> +	addr = memblock_phys_alloc_range(size, SCRATCH_ALIGNMENT_BYTES, 0,
>  					 ARCH_LOW_ADDRESS_LIMIT);
>  	if (!addr) {
>  		pr_err("Failed to reserve lowmem scratch buffer\n");
> @@ -705,7 +715,7 @@ static void __init kho_reserve_scratch(void)
>  
>  	/* reserve large contiguous area for allocations without nid */
>  	size = scratch_size_global;
> -	addr = memblock_phys_alloc(size, CMA_MIN_ALIGNMENT_BYTES);
> +	addr = memblock_phys_alloc(size, SCRATCH_ALIGNMENT_BYTES);
>  	if (!addr) {
>  		pr_err("Failed to reserve global scratch buffer\n");
>  		goto err_free_scratch_areas;
> @@ -721,7 +731,7 @@ static void __init kho_reserve_scratch(void)
>  	 */
>  	for_each_node_state(nid, N_MEMORY) {
>  		size = scratch_size_node(nid);
> -		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
> +		addr = memblock_alloc_range_nid(size, SCRATCH_ALIGNMENT_BYTES,
>  						0, MEMBLOCK_ALLOC_ACCESSIBLE,
>  						nid, true);
>  		if (!addr) {
> -- 
> 2.55.0.229.g6434b31f56-goog
> 

