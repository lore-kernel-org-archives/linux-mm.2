Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD08606D811
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IMVFroQ1
Received: by kanga.kvack.org (Postfix)
	id B4DC66B05B2; Tue,  3 Nov 2026 11:01:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B262F6B05B8; Tue,  3 Nov 2026 11:01:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A656A6B05B9; Tue,  3 Nov 2026 11:01:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 800476B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:01:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0867E12049F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:01:15 +0000 (UTC)
X-FDA: 85394272110.20.A0938E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C438C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:01:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IMVFroQ1;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793721673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSyuWChpGynvLRHVjaO/iLjkmV2JYaTq3nj516QvjuM=;
	b=H33oucygtieNnlHZ5MGn4jIYC3HT5aw+Dlhq9pU1iyL3V7ycPkceffrMOp58+mJ68ja578
	boJI773JCLfoSQQFfRe/mife2hFKvbsP9sfZXppeuouML/g+vhRFYf18izrY7ZqQJmthnJ
	HKID4DK1OSwwY50WPJ3PdS4HAJH7Vd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793721673;
	b=M4QmUrDtAh2riArgQK1kzsMa5WYvF4D1yT+5yL7FjVLft0ChmpEuQ2ivFB9epQev6Ozzg2
	hhMk90wWwHWFB7CEBjM5W9yCsLhBMvrS0VPNiCIdWuyZ10+D92Ygbaz52qkFKd1vVbfrYs
	u0931Z3Fp7rYFPvxeqsJ4/BMzPO5cVE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IMVFroQ1;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FFB141950;
	Tue,  3 Nov 2026 16:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD601F000C1;
	Tue,  3 Nov 2026 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793721672;
	bh=PSyuWChpGynvLRHVjaO/iLjkmV2JYaTq3nj516QvjuM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IMVFroQ1qx1z6bfBCYYz2bd8YHfKv5JB8R3RCU2WD1829BGMlrHnRpsj+rN4xW3vd
	 ZHbnv7fZjTfyrBTs/osD2c56v7mzj5rkowlYlds9EKi9XFi9qNHQA59tC1YV+3WDX9
	 +NBpWvuqgOcrnCNFqbYFU3q0mPYQdazovNqWNMSixO/UKk2+G5tY6j/E1YpuqVwfV9
	 zArRzpk0pAAyrJVt5qr2GHNQqvb6FXHKeuhiM20TrQH1TprTy9ER+nGvf4xM6LtL+5
	 wPS7M2ctjVhyFjN3Lr7BxkWryUmDi+wIBrA7mBrsP0ghIhLE8r2vVU4lGuxKfppnOx
	 vSXb6Ati0bilA==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Chen Pei <cp0613@linux.alibaba.com>,  George
 Guo <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>,  Sourabh
 Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 2/2] kho: fix bootmem sizing
In-Reply-To: <20261103-kho-bootmem-sizing-v1-2-45aa74098f34@kernel.org> (Mike
	Rapoport's message of "Tue, 03 Nov 2026 13:49:50 +0200")
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
	<20261103-kho-bootmem-sizing-v1-2-45aa74098f34@kernel.org>
Date: Tue, 03 Nov 2026 17:01:08 +0100
Message-ID: <2vxz5wydnbuj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Stat-Signature: eix9y7s4jow1ybu68ft1p9r9fp39eek8
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 2C438C0005
X-Rspam-User: 
X-HE-Tag: 1793721673-263874
X-HE-Meta: U2FsdGVkX18riIoOyUlZXGZ94N4avmtVQ6OM+0OvWXwxeklGWAut20JRjHVLdNVuS+qCYiqjNro11LvFHXOdHS92oWS9h/xUCWOaaWKMnqJf0L/QPpZ8CNG+N3piQi4PMx8nte/WJBQIFwOMf1ED7trrjQNe0HUCF3Cm80mgGFhMAJXCFDYcyjsAfvi/IpiQW1ygBEFx7u0zpfmn/8BUHYu29jqht5i8sv0cdqP5CNOrOtHlN3c3vxB7WXOptCij9GRZnoqjyiqGCpHU5s21twatyJ91mrC4xYI3pN+7ZZ+FwVEBkKR9jKstBhHb+P/ceM9D+mU1wjjXQR1DflDZMy14bT2iAkJupPKrTbg3w9hKn/DcjqRTADwgsAuhJJLa3JZGQuDTq8+KLyAcgDxm1JkndkzZ/91pNpWkqO42ovbc7vk5+5qWXtvt4yMIFlQshJbW4tCbYs57JJ5Ry74bRXE6aQPTdcfHyNcC1LTkw0ikbvkGVPNIQGxrr3auTeCvX4GmFMeqcp5lAiZERqFBLKa8AmblVrRjB1wFvAG2s9FGFjVV9/uqyBXely+5pci/4gmlcl/yHgI7PrbJFpP/CKu41MwuUhwmxf0L6a+HywSYZAWgtWNXeI476L4iOiaW4Sn0AzqRDbtQmf1pPLZ0k0g5c5OSXasynrcX6oauUccxBjBfYEXfWZPb9BRiwAvDv3XVEEI5Y/SgBW3iLiOEqsSLELkLHjTFqrOf0SUFS2jCbYmeme5dFEoDfk9wml+Gzpxml1VAY5X0Gd8tFeVsOo2dTUSZXorTPQ/GwE5KHXZJ0hL2/LWc25XAV1AMEAmVBzdCRphFruS3hI89+zu11L/gaKi/gIQuR8pQA/i1+Sf9/77Wh0LCBT1TjRKbB4OXQVq4s6CdyYSPx8Fo149MvQqJ2bjreQK1RDFyfcg38zjy9k3An8GjtCg64e7LED3OGNhkWxMBIr9PzJUmeNq
 oB9MBJ3b
 UhoMd8JLm0OgstPrdAjSco5mm/BTC8eKrE+zT8kjS3qzqNGCcLuFD3lPlFQL25q/wNfu9pZL4nLqKOMMQM6vQTLrUBk9DCPzL0D3VS3rGGlwoezrC8uVZzm1ZGhnPxfcXkP+Zbnn5mhYnz2DzeZVrCFaUmwVK3Tz0decXPrAgEvzmAkA6QLqWQ6ijoqZRUWZPmttji4zgUK142aLnVtE/ls0MmAVkXSeW840hO2KpX+igqOa7YQUv9e3EbTvMjWauMpIu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

On Tue, Nov 03 2026, Mike Rapoport (Microsoft) wrote:

> Bootmem areas are sized from overlapping views of the memory reserved in
> memblock:
>
> * the global area is sized from all reserved memory, including memory
>   allocated on specific nodes, so on NUMA systems everything allocated
>   on a node is accounted in both the global area and the area of that
>   node.
> * per-node sizes are calculated after the lowmem and the global areas
>   are reserved. With CONFIG_NUMA=n all memblock regions belong to node 0,
>   so the lowmem and the global areas are accounted in the size of node 0
>   area and scaled once again.
>
> As a result, bootmem is about twice bigger than it should be on NUMA
> systems and about four times bigger with CONFIG_NUMA=n. On small systems
> reservation of the bootmem may fail and then KHO gets disabled.
>
> Make the areas cover separate parts of the reserved memory: the lowmem
> area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node areas
> cover allocations above it on each node and the global area covers
> allocations that are not bound to any node. Calculate all sizes before
> reserving any of the areas.
>
> With CONFIG_NUMA=n the global area becomes empty and it is not reserved.
>
> Bootmem sizes in MiB in x86 QEMU VMs, before -> after:
>
>                      CONFIG_NUMA=y     CONFIG_NUMA=n
>   1G,  1 node         176 ->   92       320 ->   80
>   4G,  1 node         508 ->  332      1264 ->  316
>   16G, 2 nodes       1268 ->  704      2944 ->  736
>   32G, 4 nodes       2296 -> 1224      5196 -> 1300
>   64G, 4 nodes       4344 -> 2248      9664 -> 2420
>
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Kexin Liu <liukexin@kylinos.cn>
> Reported-by: George Guo <guodongtai@kylinos.cn>
> Closes: https://lore.kernel.org/all/20260904025101.9959-1-dongtai.guo@linux.dev
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Closes: https://lore.kernel.org/all/20260922131217.698809-1-sourabhjain@linux.ibm.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks for the patch! My LLM caught an interesting problems that is
worth considering.

On arm64, ARCH_LOW_ADDRESS_LIMIT is arm64_dma_phys_limit - 1, and
dma_limits_init() sets the default value to PHYS_MASK + 1, and it can
also be memblock_end_of_dram() in some cases. So on arm64, it is
possible for lowmem to span the entire RAM.

Currently, that results in over-allocation of bootmem, and it ends up
being 4x what it should be. While obviously problematic, it should still
work. With this patch, all memory is in lowmem, and nothing ever goes to
per-node bootmem (except for the node that hosts the lowmem area).

All this is from reading the code, I haven't tried anything out yet.

Not sure how to fix this though. Should we perhaps use
min(ARCH_LOW_ADDRESS_LIMIT, U32_MAX) for the lowmem limit?

Also, a couple nitpicks below.

> ---
>  kernel/liveupdate/kexec_handover.c | 83 ++++++++++++++++++++------------------
>  1 file changed, 44 insertions(+), 39 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index f268c57413a7e..eaeb895bb7595 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -684,6 +684,7 @@ static unsigned int bootmem_scale __initdata = 200;
>  static phys_addr_t bootmem_size_global __initdata;
>  static phys_addr_t bootmem_size_pernode __initdata;
>  static phys_addr_t bootmem_size_lowmem __initdata;
> +static phys_addr_t bootmem_size_node[MAX_NUMNODES] __initdata;
>  
>  static int __init kho_parse_bootmem_size(char *p)
>  {
> @@ -753,29 +754,48 @@ static int __init kho_parse_bootmem_size(char *p)
>  }
>  early_param("kho_bootmem", kho_parse_bootmem_size);
>  
> +static phys_addr_t __init reserved_mem_size(phys_addr_t limit, int nid)
> +{
> +	return memblock_reserved_kern_size(limit, nid) -
> +	       memblock_reserved_hugetlb_size(limit, nid);
> +}
> +
> +static phys_addr_t __init bootmem_scale_size(phys_addr_t size)
> +{
> +	return size * bootmem_scale / 100;
> +}
> +
> +/*
> + * The lowmem area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node
> + * areas cover allocations above it on each node and the global area covers
> + * allocations that are not bound to any node.
> + *
> + * All sizes must be calculated before any area is reserved, otherwise the
> + * areas reserved first will be accounted in the sizes of the others.
> + */
>  static void __init bootmem_size_update(void)
>  {
> -	/*
> -	 * If fixed sizes are not provided via command line, calculate them now.
> -	 * Remove HugeTLB allocations from it because they never get allocated
> -	 * from bootmem.
> -	 */
> +	int nid;
> +
>  	if (bootmem_scale) {
> -		phys_addr_t size;
> -
> -		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
> -						   NUMA_NO_NODE);
> -		size -= memblock_reserved_hugetlb_size(ARCH_LOW_ADDRESS_LIMIT,
> -						       NUMA_NO_NODE);
> -		size = size * bootmem_scale / 100;
> -		bootmem_size_lowmem = size;
> -
> -		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						   NUMA_NO_NODE);
> -		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						       NUMA_NO_NODE);
> -		size = size * bootmem_scale / 100 - bootmem_size_lowmem;
> -		bootmem_size_global = size;
> +		phys_addr_t lowmem, global, size;
> +
> +		lowmem = reserved_mem_size(ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE);
> +		global = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE);
> +		global -= lowmem;

Nit: Please add a short comment above this to explain why you remove
lowmem from global.

> +
> +		for_each_node_state(nid, N_MEMORY) {
> +			size = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, nid) -
> +			       reserved_mem_size(ARCH_LOW_ADDRESS_LIMIT, nid);
> +			bootmem_size_node[nid] = bootmem_scale_size(size);
> +			global -= size;

Nit: same here, a comment here would make it easier to understand.

> +		}
> +
> +		bootmem_size_lowmem = bootmem_scale_size(lowmem);
> +		bootmem_size_global = bootmem_scale_size(global);
> +	} else {
> +		for_each_node_state(nid, N_MEMORY)
> +			bootmem_size_node[nid] = bootmem_size_pernode;
>  	}
>  
>  	/*
> @@ -784,24 +804,9 @@ static void __init bootmem_size_update(void)
>  	 */
>  	bootmem_size_lowmem = round_up(bootmem_size_lowmem, BOOTMEM_ALIGNMENT_BYTES);
>  	bootmem_size_global = round_up(bootmem_size_global, BOOTMEM_ALIGNMENT_BYTES);
> -}
> -
> -static phys_addr_t __init bootmem_size_node(int nid)
> -{
> -	phys_addr_t size;
> -
> -	if (bootmem_scale) {
> -		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						   nid);
> -		/* Do not count HugeTLB pages. */
> -		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						       nid);
> -		size = size * bootmem_scale / 100;
> -	} else {
> -		size = bootmem_size_pernode;
> -	}
> -
> -	return round_up(size, BOOTMEM_ALIGNMENT_BYTES);
> +	for_each_node_state(nid, N_MEMORY)
> +		bootmem_size_node[nid] = round_up(bootmem_size_node[nid],
> +						  BOOTMEM_ALIGNMENT_BYTES);
>  }
>  
>  bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
> @@ -891,7 +896,7 @@ static void __init kho_reserve_bootmem(void)
>  	 * memoryless nodes, as we can not allocate bootmem areas there.
>  	 */
>  	for_each_node_state(nid, N_MEMORY) {
> -		if (kho_reserve_bootmem_area(&i, bootmem_size_node(nid),
> +		if (kho_reserve_bootmem_area(&i, bootmem_size_node[nid],
>  					     MEMBLOCK_ALLOC_ACCESSIBLE, nid)) {
>  			pr_err("Failed to reserve nid %d bootmem\n", nid);
>  			goto err_free_bootmem_areas;

-- 
Regards,
Pratyush Yadav

