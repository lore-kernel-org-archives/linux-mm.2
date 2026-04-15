Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F46F43858
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864456B0005; Wed, 15 Apr 2026 12:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE326B0088; Wed, 15 Apr 2026 12:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F5C6B0089; Wed, 15 Apr 2026 12:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 543A56B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:16:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFBC016055D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:16:52 +0000 (UTC)
X-FDA: 84661293864.16.02D049F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 375C52000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:16:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s38oCA76;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776269811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=et7lNV/EK5ZapdM1wdvtSxAzbD4whSn1kk9KNgMMsng=;
	b=X/qrC0SBwVRydteqOmU10aF0lLkNqNCz+LieCuMMSFgU5Y9k3GsBPpJljpotiaF+43jFT1
	iRBGQy7Aaj+Thk+j+R5Mq20NZ+w/+w5i8ZiVMGMrEdLlhdfDioeNFfbcMn/DNVF1UlSge8
	us8s2qdQDR9HlgIbsOEEnwJ0AUD05sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776269811; a=rsa-sha256;
	cv=none;
	b=rlzKKp1e96kkishx+GLMWspmfA1E4bLBtNEFUK+ThHMA+mJpcIt/NgClwsEB7FRbXwUPRr
	40HgVHAySaQkTHPD/ePZVGtTl6l42WIS2fZ1OHNFjffwEY0QtiJGCA+pgENlgX/3h6DaPV
	4jidN30IKoMEFhpNbSXH9pNWGUtMs24=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s38oCA76;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1777043682;
	Wed, 15 Apr 2026 16:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BF6C19424;
	Wed, 15 Apr 2026 16:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776269809;
	bh=BYzmB8AMTn+l7fVaMR9XEBHosEJ+cHfReEz/ISoReJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s38oCA764aLQkbmWhMkN4zvvwN/6QqwzqM1bNOcd+01RXf02hI+6o8xXG0UNwE8DD
	 lfgmiEHUc+6/y/vWdbSx0SQ8rktpitZSCIwz8zdnzKQUW+Ns7gZyCsXeT6qWB+F2yu
	 ZtLPXWuYn8M+lIN8b9/VXlkgYy1W/Kfp3fHnQ/BI9FuCF+4C5FwLY+Z5VPmvCBtUrZ
	 ynMjTuanQS/unbHiJnV+M/OTolYTPW2ENyzDpvHfWyMLmjzzIveR0CtJWommhYk3Em
	 rqdU/qxfooRO1y84xZLSkniknZXsH7g9mVXjYey8SXAjmIf8uYEVE6EFD2rDS9iFBx
	 phiXWwy8SecSw==
Date: Wed, 15 Apr 2026 19:16:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: priyanshukumarpu@gmail.com
Cc: akpm@linux-foundation.org, changyuanl@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/memblock: fix stale NUMA reservation
 tests
Message-ID: <ad-57Iq8yat01OiN@kernel.org>
References: <20260413091458.774770-1-priyanshukumarpu@gmail.com>
 <20260415122731.1768912-1-priyanshukumarpu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415122731.1768912-1-priyanshukumarpu@gmail.com>
X-Rspamd-Queue-Id: 375C52000D
X-Rspamd-Server: rspam07
X-Stat-Signature: mqmr55tityig8ba4f9k5k6xr95woumzd
X-Rspam-User: 
X-HE-Tag: 1776269810-640074
X-HE-Meta: U2FsdGVkX18cVXHL/Wx2/fIRXwiwxUG5xMBREjhdcfkzpBpkjpC/NmEVUn6s5RvmAYSbYZ3niscXj95mGKK/ADHs10U3i77IphK6XGbvG2lCwZgXsKY7DhLjdJ4zoi8HlR8ZO7YoIwl+kVAdea1ZZ26bfRUMjFWEslHXHCoz3WIeGoLRkDCv2nYNIMyxqopYyQaBwtcetrbRjLBYRybSIBmqnt83Joni3Dm+E5jzZphD9zIMb+pK8/wadC4RTaBmlf+f2N7VqcCU14lKviZAh03X5I5VbKHytBEcU4SrT00yVE+y9EBTsHQIOvAQzFlVYLoz1PSvVE3Co64II9jpCBO87Ypav9qpSu+CjuC/R6sLr5jOVjvAniHRLHLKVopNAbiqv3y5ARpRqm2ZjTQ+zPxyQFg11jGImL+k0pnpq6/aPEJHnTQ8d4VHehOrmyK34h1fayuzLG85PScYGoS0LP1otGFEjQtS4skMkN9T2J5JHB4HaO+iTt0jPVSGD3X9h96jDEwX6/ixutmggWIf2EwDj3bBe/cdEm0NFFkHyU0F5gjsPnhBfr6QwybQA80j9Z3u3/jEwX5NopTHEKH8nRPDEYYABhAg+psE6yMI8LvtN+m//FfF+4gjfjxysPY8iDtDe5OH72EEeQHOCPHwT5RPADllYH564ZbSaac0wB4CMN6JHpuIVgv7gXaQ3DJ0ZiZmQLorZQgFGWa1YcU+9vb/JSvrKfpqDJNV7+3K5OCjaLHlm5N6O5EsryaAIwkEmnCqq9CPIOqo0miGBzex7KleOrFeTNDE6fPMHsayqIaapptuYAbUMKslAZWNFi6qJZdakdGBMREd13YnRutDghERJWCLpieDnUVOacD01+R0wyt1BYkdu9m+ZLzlR9+vaA4UUHX/S+nBCJ6O7E1AZfZWKmWsMpERkaJMG8hi9i2VHUsWOwYPliJlK0fUhDYG157oZGF7T8hoR2G2krg
 Pz9eJWvI
 lQ2igXUt2/9JZZIAmalYuUxts0Dztw43Y3xqMVmUnEUNY+H1TxLAawuBS5J+N2vK2Yesc8p1Locfn/iygzdNByVojVCSs2VXTRP41tlEsqey/mXdnD/fBXdIHNHTqHsKjcdb2RYCg9D21ZENOJ303WhCZY7U0NUz0/D79IQoyi9gn8fJPHFj/jQllZ1JNGNDM6wsOMzpfsLoGXixa1rRPwpucpHvpPG6VIBOJcsAuMGcyQpcQMoaX17tKNG2Kj2FhctNJ3+gyRmGBLh7m1cajrgvv7OoaEHc3ksp1V9nCY6CmgKHu02B3hUYD8CV2Zev2c5VMSuP5gRmjq0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Please next time send v2 as a different mail rather than replying to v1 and
add description of the changes between the versions:

https://docs.kernel.org/process/submitting-patches.html#commentary

On Wed, Apr 15, 2026 at 12:27:31PM +0000, priyanshukumarpu@gmail.com wrote:
> From: Priyanshu Kumar <priyanshukumarpu@gmail.com>
> 
> memblock allocations now reserve memory with MEMBLOCK_RSRV_KERN and,
> on NUMA configurations, record the requested node on the reserved
> region. Several memblock simulator NUMA tests still expected merges
> that only worked before those reservation semantics changed, so the
> suite aborted even though the allocator behavior was correct.
> 
> Update the NUMA merge expectations in the memblock_alloc_try_nid()
> and memblock_alloc_exact_nid_raw() tests to match the current reserved
> region metadata rules. For cases that should still merge, create the
> pre-existing reservation with matching nid and MEMBLOCK_RSRV_KERN
> metadata. Also strengthen the memblock_alloc_node() coverage by
> checking the newly created reserved region directly instead of
> re-reading the source memory node descriptor.
> 
> Finally, drop the stale README/TODO notes that still claimed
> memblock_alloc_node() could not be tested.
> 
> The memblock simulator passes again with NUMA enabled after these
> updates.
> 
> Signed-off-by: Priyanshu Kumar <priyanshukumarpu@gmail.com>
> ---
>  tools/testing/memblock/README                 |  5 +----
>  tools/testing/memblock/TODO                   |  4 ++--
>  .../memblock/tests/alloc_exact_nid_api.c      |  6 +++---
>  tools/testing/memblock/tests/alloc_nid_api.c  | 21 +++++++++++++------
>  4 files changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/testing/memblock/README b/tools/testing/memblock/README
> index 7ca437d81806..b435f48d8a70 100644
> --- a/tools/testing/memblock/README
> +++ b/tools/testing/memblock/README
> @@ -104,10 +104,7 @@ called at the beginning of each test.
>  Known issues
>  ============
>  
> -1. Requesting a specific NUMA node via memblock_alloc_node() does not work as
> -   intended. Once the fix is in place, tests for this function can be added.
> -
> -2. Tests for memblock_alloc_low() can't be easily implemented. The function uses
> +1. Tests for memblock_alloc_low() can't be easily implemented. The function uses
>     ARCH_LOW_ADDRESS_LIMIT marco, which can't be changed to point at the low
>     memory of the memory_block.
>  
> diff --git a/tools/testing/memblock/TODO b/tools/testing/memblock/TODO
> index e306c90c535f..c13ad0dae776 100644
> --- a/tools/testing/memblock/TODO
> +++ b/tools/testing/memblock/TODO
> @@ -1,5 +1,5 @@
>  TODO
>  =====
>  
> -1. Add tests for memblock_alloc_node() to check if the correct NUMA node is set
> -   for the new region
> +1. Add tests for memblock_alloc_low() once the simulator can model
> +   ARCH_LOW_ADDRESS_LIMIT against the low memory in memory_block
> diff --git a/tools/testing/memblock/tests/alloc_exact_nid_api.c b/tools/testing/memblock/tests/alloc_exact_nid_api.c
> index 6e14447da6e1..0c46c73b5e04 100644
> --- a/tools/testing/memblock/tests/alloc_exact_nid_api.c
> +++ b/tools/testing/memblock/tests/alloc_exact_nid_api.c
> @@ -368,7 +368,7 @@ static int alloc_exact_nid_bottom_up_numa_part_reserved_check(void)
>  	max_addr = memblock_end_of_DRAM();
>  	total_size = size + r1.size;
>  
> -	memblock_reserve(r1.base, r1.size);
> +	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
>  	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
>  						     min_addr, max_addr,
>  						     nid_req);
> @@ -861,8 +861,8 @@ static int alloc_exact_nid_numa_reserved_full_merge_generic_check(void)
>  	min_addr = r2.base + r2.size;
>  	max_addr = r1.base;
>  
> -	memblock_reserve(r1.base, r1.size);
> -	memblock_reserve(r2.base, r2.size);
> +	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
> +	__memblock_reserve(r2.base, r2.size, nid_req, MEMBLOCK_RSRV_KERN);
>  
>  	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
>  						     min_addr, max_addr,
> diff --git a/tools/testing/memblock/tests/alloc_nid_api.c b/tools/testing/memblock/tests/alloc_nid_api.c
> index 562e4701b0e0..c23652727976 100644
> --- a/tools/testing/memblock/tests/alloc_nid_api.c
> +++ b/tools/testing/memblock/tests/alloc_nid_api.c
> @@ -1965,7 +1965,7 @@ static int alloc_nid_bottom_up_numa_part_reserved_check(void)
>  	max_addr = memblock_end_of_DRAM();
>  	total_size = size + r1.size;
>  
> -	memblock_reserve(r1.base, r1.size);
> +	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
>  	allocated_ptr = run_memblock_alloc_nid(size, SMP_CACHE_BYTES,
>  					       min_addr, max_addr, nid_req);
>  
> @@ -2412,8 +2412,8 @@ static int alloc_nid_numa_reserved_full_merge_generic_check(void)
>  	min_addr = r2.base + r2.size;
>  	max_addr = r1.base;
>  
> -	memblock_reserve(r1.base, r1.size);
> -	memblock_reserve(r2.base, r2.size);
> +	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
> +	__memblock_reserve(r2.base, r2.size, nid_req, MEMBLOCK_RSRV_KERN);
>  
>  	allocated_ptr = run_memblock_alloc_nid(size, SMP_CACHE_BYTES,
>  					       min_addr, max_addr, nid_req);
> @@ -2496,15 +2496,18 @@ static int alloc_nid_numa_split_all_reserved_generic_check(void)
>  
>  /*
>   * A simple test that tries to allocate a memory region through the
> - * memblock_alloc_node() on a NUMA node with id `nid`. Expected to have the
> - * correct NUMA node set for the new region.
> + * memblock_alloc_node() on a NUMA node with id `nid`. Expected to allocate
> + * the region within the requested node and mark the new reservation with the
> + * correct NUMA node.

This change is not related to the fix and I think it's adding too much
noise to the test in any case.

>   */
>  static int alloc_node_on_correct_nid(void)
>  {
>  	int nid_req = 2;
>  	void *allocated_ptr = NULL;
>  #ifdef CONFIG_NUMA
> +	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
>  	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
> +	phys_addr_t req_node_end = region_end(req_node);
>  #endif
>  	phys_addr_t size = SZ_512;
>  
> @@ -2515,7 +2518,13 @@ static int alloc_node_on_correct_nid(void)
>  
>  	ASSERT_NE(allocated_ptr, NULL);
>  #ifdef CONFIG_NUMA
> -	ASSERT_EQ(nid_req, req_node->nid);
> +	ASSERT_EQ(memblock.reserved.cnt, 1);
> +	ASSERT_EQ(new_rgn->size, size);
> +	ASSERT_EQ(new_rgn->base, (phys_addr_t)allocated_ptr);
> +	ASSERT_EQ(new_rgn->flags, MEMBLOCK_RSRV_KERN);
> +	ASSERT_EQ(nid_req, memblock_get_region_node(new_rgn));
> +	ASSERT_LE(req_node->base, new_rgn->base);
> +	ASSERT_LE(region_end(new_rgn), req_node_end);
>  #endif
>  
>  	test_pass_pop();
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

