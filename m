Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4790EE20AB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1EBF6B0005; Fri,  6 Feb 2026 10:19:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCCAE6B0089; Fri,  6 Feb 2026 10:19:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9346B0092; Fri,  6 Feb 2026 10:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC0F96B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:19:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61C58140254
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:19:49 +0000 (UTC)
X-FDA: 84414391698.30.68E7582
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 48A0B180011
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:19:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aywzXuhD;
	spf=pass (imf06.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770391187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChC6m5WfVroGjS9ENqi35nDBudi2mtW1bc10jN5JpMM=;
	b=smwQQ5yArBzeP0lY3nyl8qVuq+TMbV26D8R9405/BRnIy2/Nq1sK44fTogcYNGmCBVjME/
	M27pHhUNfR8rOXWNOXAgAyUKWxXAB+8YmwikJHpV+PK2a0EvEbunb+6/Gp1wuU2bpqeGKt
	Tm/b40T42WaSDI2E0A7PBIdcWm/gEvk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aywzXuhD;
	spf=pass (imf06.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770391187; a=rsa-sha256;
	cv=none;
	b=c8sUmG2fcLtxZAn+ZFbACWxnh2Mgp4+9yfjpyMHnnJIuyh2ELcWowZicWW7TqRcyfAJk12
	6YQoXS5XxgPDVih3/hVFHhvxwtl6HyaBkwK1vx9pmJLbBuXnfaCaHfjmtvOyADRvecx9A7
	2qjMDIc3hVMaJDcFlVJfiRAQI6XZAm8=
Date: Fri, 6 Feb 2026 15:19:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770391184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ChC6m5WfVroGjS9ENqi35nDBudi2mtW1bc10jN5JpMM=;
	b=aywzXuhD3aIRl8d7DfaV1A4HZXwVjqvlCIQ3oXkRUMWqETv6Fnc28cJp0x4vYuQGoNZP7+
	COR3c6t8nqalS9d43VhLxDSGTWIjGkRXjKp/Wy5GOwnvvY+KVi+1+6FwRnBLRWb+V351o4
	FPmWoT/JsuNl2LGBhfueWqgH+YiY3nM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Nhat Pham <nphamcs@gmail.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: zswap: add per-memcg stat for incompressible
 pages
Message-ID: <iphymajz5xn6cbntby7z5s3eioraigs4doqylijoljfhzrexup@f23vxl2deyfr>
References: <20260206072220.144008-1-jiayuan.chen@linux.dev>
 <20260206072220.144008-2-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206072220.144008-2-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 48A0B180011
X-Stat-Signature: b9ketzj5n1wbdp118cupe6idkum586xj
X-Rspam-User: 
X-HE-Tag: 1770391187-772568
X-HE-Meta: U2FsdGVkX1+FQFl6bTQuv+724LJIQw5BrGfJQrCAipu0hLKdZ9XWgRzvCDNvv1Zry5Ecxyi1ig6nOvvZVrhTNSo7tPlKXJG0Vp5dz11PQCX92TM+HP/IxvLmmfAhaS2W8QAzvJx9arMFGhImbOxC9QbbxZniLPjKY2a60v0W25d8MuRNPzCOJgKToYRQb/P4ys7YER5v/Yv/NZidQWGO93ZGXkYpRuGRJCqhjUDDZqn1B72JpLVRzw9WTk2EbwBWQmmX9WlJya2n/MEnYdI0tTJpwowTeXnjOgdkcZAqs/WQ2y1KigWjLclKMnG6Fp0roYr1deKVuX+i5MaNKbGzJSKM5EhGxeob9huS72xnobvhGDngUZZWqh0L4ELUtvh8Pv1DkU/lpJUsNVmhHiYs7oVqv1G0nIjx4RkB/cgf91F1z1AjDlUL8ynm/wjLn8jNYrXyWXI4IiBjAaa2WGGrtp741/G6ouUFaKQIc3c8pPPovlk2XDjgqUOH2BgKDFIH4bGRiHY2CfaC9yEa+o76hFkcsEFwJa6ywcPBl8kmeM0ks/OIQ0hz0tkLag0yOHvM3/9bPqyohEPq7jSxFXxxFKQ/TsUw1BLH4m1qjAEMxzfxjKC64plXv/LJnNMTKCNQa+zV9fg9WJLK+trACP4AHpFIrb9UxGArvPY9gDLTOKe6X8km1zW7YVrOq9KDrOHz2AJRLkaQktxapgyn0DOwieBsCA9aRYxZPZLYlhRQ7cp/5XyYqaVkTTMeoKraGAJw+ikbiTFjGBxvfqZh8XDj4wLBw2BKGJRLONtxJwSnjtyKfL5q6Y2Al4kw5kip8DCpBF3bocISseC7qzKQLtloG2X7+puzB6V6HEYKboF6ona1neNgO0Ra7Ygxw7tx9vhwj/DmujMsfzTT9Veor8enG2TQ8fVwTZPCLbTppxtAJTnhC/UXlz8dXF0kvMc760LonOnwhiVfz8bMauyMtiA
 AxGet9Ow
 VTztJumS/1Kgl76d6CeEguA0/9ju/jmuYqYaaJnVg6p/HRr1Ste2L0I/4gHlGjFUUEpPo44g8+vglLUmMY6ha+jIfgbVE+R4LplcR/Y8pAEQNZ/RpbqaLJcF5ylzjQTjYEhYl6pKxDmfVi+obrkoI6JOclX33fsP2rrG6ThWCG+TIQVAyqmsS+o6og4/s+q+Fb9JCQKbJU7fcWls9YzJMUULutHTBsw4RLDVJvbhaKVqGTJXPGQM6UKy6rtdi3rPMRr1/AGrF8+pSBlXyjlqotd7QIPmlQSn+9DVq2qV54VkCUrssAn02uy0O1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 03:22:15PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> The global zswap_stored_incompressible_pages counter was added in commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
> to track how many pages are stored in raw (uncompressed) form in zswap.
> However, in containerized environments, knowing which cgroup is
> contributing incompressible pages is essential for effective resource
> management [1].
> 
> Add a new memcg stat 'zswap_incomp' to track incompressible pages per
> cgroup. This helps administrators and orchestrators to:
> 
> 1. Identify workloads that produce incompressible data (e.g., encrypted
>    data, already-compressed media, random data) and may not benefit from
>    zswap.
> 
> 2. Make informed decisions about workload placement - moving
>    incompressible workloads to nodes with larger swap backing devices
>    rather than relying on zswap.
> 
> 3. Debug zswap efficiency issues at the cgroup level without needing to
>    correlate global stats with individual cgroups.
> 
> While the compression ratio can be estimated from existing stats
> (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> "uniformly poor compression" and "a few completely incompressible pages
> mixed with highly compressible ones". The zswap_incomp stat provides
> direct visibility into the latter case.
> 
> [1]: https://lore.kernel.org/linux-mm/CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com/
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 5 +++++
>  include/linux/memcontrol.h              | 1 +
>  mm/memcontrol.c                         | 8 ++++++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 7f5b59d95fce..78a329414615 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1737,6 +1737,11 @@ The following nested keys are defined.
>  	  zswpwb
>  		Number of pages written from zswap to swap.
>  
> +	  zswap_incomp
> +		Number of incompressible pages currently stored in zswap
> +		without compression. These pages could not be compressed to
> +		a size smaller than PAGE_SIZE, so they are stored as-is.
> +
>  	  thp_fault_alloc (npn)
>  		Number of transparent hugepages which were allocated to satisfy
>  		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index b6c82c8f73e1..d8ec05dd5d43 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -39,6 +39,7 @@ enum memcg_stat_item {
>  	MEMCG_KMEM,
>  	MEMCG_ZSWAP_B,
>  	MEMCG_ZSWAPPED,
> +	MEMCG_ZSWAP_INCOMP,
>  	MEMCG_NR_STAT,
>  };
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 007413a53b45..a6b6cf5f1aeb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -341,6 +341,7 @@ static const unsigned int memcg_stat_items[] = {
>  	MEMCG_KMEM,
>  	MEMCG_ZSWAP_B,
>  	MEMCG_ZSWAPPED,
> +	MEMCG_ZSWAP_INCOMP,
>  };
>  
>  #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
> @@ -1346,6 +1347,7 @@ static const struct memory_stat memory_stats[] = {
>  #ifdef CONFIG_ZSWAP
>  	{ "zswap",			MEMCG_ZSWAP_B			},
>  	{ "zswapped",			MEMCG_ZSWAPPED			},
> +	{ "zswap_incomp",		MEMCG_ZSWAP_INCOMP		},
>  #endif
>  	{ "file_mapped",		NR_FILE_MAPPED			},
>  	{ "file_dirty",			NR_FILE_DIRTY			},
> @@ -5458,6 +5460,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
>  	memcg = obj_cgroup_memcg(objcg);
>  	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
>  	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> +	/* size == PAGE_SIZE means compression failed, page is incompressible */

I think the comment is not very useful, but maybe not worth sending a
new version. Otherwise LGTM:

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> +	if (size == PAGE_SIZE)
> +		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
>  	rcu_read_unlock();
>  }
>  
> @@ -5481,6 +5486,9 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
>  	memcg = obj_cgroup_memcg(objcg);
>  	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
>  	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
> +	/* size == PAGE_SIZE means compression failed, page is incompressible */
> +	if (size == PAGE_SIZE)
> +		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, -1);
>  	rcu_read_unlock();
>  }
>  
> -- 
> 2.43.0
> 

