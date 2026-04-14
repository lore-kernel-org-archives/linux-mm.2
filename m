Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4990EF9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9825D6B0089; Tue, 14 Apr 2026 11:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9593E6B0092; Tue, 14 Apr 2026 11:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895F26B0093; Tue, 14 Apr 2026 11:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78B5A6B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:14:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 208B916015F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:14:13 +0000 (UTC)
X-FDA: 84657507186.23.767888A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6E77B140014
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:14:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mEymB5dr;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776179651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V010CmGkw8TaI5ao8y4FPUL4nvCOlZ3bvIIlfl+uzPY=;
	b=8kDEYncoKw15JOzoazknYhR8lsKpVgx0otrvT0WRx2kz+Wa5jwMDctDYSzTr0kWm9aLbJ/
	e8el8MMfrwckf014tEyGCMREwDUY5qoVY9NvRslW83uKlc0OHtsiWTmHCdDsNHFcpjGtF+
	8oFwfW67jtLINThjPaRyMAumIspZO+k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mEymB5dr;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776179651; a=rsa-sha256;
	cv=none;
	b=h0aJyWbOuuC+t8u/yqnPO2wDlQc3U8yI341NlzUQa94EvQFGwaWItdmG3aWY40j1/+P+3I
	zYcfEU6KYZHNYRlLRZpkkTLBoAXPallvKS3c5W+MqI7Uxp5tpfQs71gUjnblhg/Uv/7FoZ
	XHOS2U6fB05JifukT8yxfmHqHeHApQg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 953E9600AE;
	Tue, 14 Apr 2026 15:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64988C19425;
	Tue, 14 Apr 2026 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776179650;
	bh=0ob26VwLXMWHWDk+TZoajRbCcn/0UQ7s8UqtxLBZuJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mEymB5dr63U0EbprW0BwqEHA0dNm9M/HMCIegREI7w0BoCfXtLg9q013mcIPXQM8l
	 l2GtF4L0FVgpCJ5Ek4LRq1vxjWnypK8yC2LIPQ6qE56u8Ayqg6l15PP33//IcTIUVC
	 UnWIATP4zf1t1tfGAgC2UpJ279ZXLCrCBvePaDZa2tpOlJrwF/q1vKxE2W1JYa3IhD
	 cqYKh2/SyqwvYoqS5wD4BxPVud9d1NWMfECvFKvc/tBwtX1SGExe2Paw+O4TQ5dkfY
	 1ONtuyAsXmajUGl0P1SwGf/Hd96iOTJgdOI6qR5GsAIOQszM4YXCc52amdZnc2EiXh
	 Oa8F+s4oO4Wow==
Date: Tue, 14 Apr 2026 18:14:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: priyanshukumarpu@gmail.com
Cc: akpm@linux-foundation.org, changyuanl@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/testing/memblock: fix stale NUMA reservation tests
Message-ID: <ad5ZvYLyC--CXPZY@kernel.org>
References: <20260413091458.774770-1-priyanshukumarpu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413091458.774770-1-priyanshukumarpu@gmail.com>
X-Rspamd-Queue-Id: 6E77B140014
X-Stat-Signature: 81t1xsxjh96wkxro8f6dxizaazse9aoo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776179651-684294
X-HE-Meta: U2FsdGVkX1/uAnFfBo8Th1NN77z0AEM3RlHtxPgIbM42QS3qTH1E63urSs19tDSVyo7KTGPuwXSuxl++E9CBv5YAID78tfBdfQ5Zio4QoQ5Nm6iVFugIhXS2rMWu4YDt5BkAl2WS3fhOH9ZUydXedM9aZJcpoEogMBRYkqJto2FwbCEXY6VtXPOrEQyaV2LbC79bJ6OuheBbEQG3SyvJu5LB8sBR7alYiYJDfivK4Invfc6ijnLlwPUTTm1Y7QAMSfMzSSf4Mj2XyfEmj4V0RgshlE7JC/hF6sOihBVvSUM7QfWuvoSxcwmRTGE6yB5Sf/QhzrRwx4iNEcJAdlGKIwoOEX2y/ea1U9Gcm5ipZSeDgnwZd1nw3GSp1XRed7aKJsHyDZdPvx8xoOJJMBgg9peAaFflYf1MX+x1h+ePhXGYY95BQDSEL4FJYDk0SB/+mx5hfwoNXPU5kusC3zIRS1e3wDUH/LSMg+cR1yKTz1UD1S2qTBgAHbyq3FV5og29CphavtqUiyZIejP10uSF1y293Ak/73wUgUvvImHNqBjpDMXRyCdGLe7PXFqU+zomiHs4hSE49xh3m7uhGnPC0Wws7YUQ+gMNxxpTc0MSqUgn5FQ+6t7yMaqpKj3u5909aOPrTYgLs1z1uzYbntLHSIz6Xpc3kcTsBOQKucOJpMjPx8dwSVF9b7drEGg4JzFBFY5vw4saOvIxUG+A4L4oPC5pwOp2wP6g/abcbARzIX4FgyRCnlx2VavkZghIDhXhpy4cMe9NuQZo45lGB5z5tfrD2xrGK9F7VZ/huq0NkDv7tEaFHHL9obVDGVu7NCOZqDCdwjhivlVKPb7rxePD6Aq0WrN61s5cb0s83dvtJEArM1m+8STtgW8BSb4Cs3ljIBNZviCyCh7fneU2ThNCJwnAJBmPsL0AsESstXTzeN0VYXJ4lEiXnI2z59GYqGS7eknSMDZmIyOz0spZGTT
 TrxzrjMF
 5MPaCD7xk6DG7NEqP0tShJItA7mmtrwWv6woAfirci+HyVymy6ZMq0aPBpTZdLEp6vuBcpk/hO7+oUDVujToGNrUKPm0n/qvfp+bdF8E8xWJtk92la0PqZN/lBH/n6TzC229Jwml88f4sr7jjSGhC2n+1/cXX/NTLEn7HMU/3DyQlBIBf5dfhTIJ6E1Sfkd/ESslzxCpw5ZqGTDItUP3JfGRiso6r/sMJp47BLvO6sZ7WhlaTTejD0wI2KKKUvVPEgHiFWml+zzDu1h6Bq8rqjI0zpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Apr 13, 2026 at 09:14:58AM +0000, priyanshukumarpu@gmail.com wrote:
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
>  tools/testing/memblock/README                 |  5 +--
>  tools/testing/memblock/TODO                   |  4 +-
>  .../memblock/tests/alloc_exact_nid_api.c      | 29 +++++++-----
>  tools/testing/memblock/tests/alloc_nid_api.c  | 44 +++++++++++++------
>  4 files changed, 53 insertions(+), 29 deletions(-)
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
> index 6e14447da6e1..3f5ab994f63a 100644
> --- a/tools/testing/memblock/tests/alloc_exact_nid_api.c
> +++ b/tools/testing/memblock/tests/alloc_exact_nid_api.c
> @@ -368,7 +368,8 @@ static int alloc_exact_nid_bottom_up_numa_part_reserved_check(void)
>  	max_addr = memblock_end_of_DRAM();
>  	total_size = size + r1.size;
>  
> -	memblock_reserve(r1.base, r1.size);
> +	ASSERT_EQ(0, __memblock_reserve(r1.base, r1.size, nid_req,
> +					MEMBLOCK_RSRV_KERN));

No need to check the return value here. 

>  	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
>  						     min_addr, max_addr,
>  						     nid_req);
> @@ -831,14 +832,17 @@ static int alloc_exact_nid_numa_large_region_generic_check(void)
>   *  |             | r2 |          new          | r1 |                  |
>   *  +-------------+----+-----------------------+----+------------------+
>   *
> - * Expect to merge all of the regions into one. The region counter and total
> - * size fields get updated.
> + * Expect to allocate the requested node as a separate kernel-reserved region.
> + * The neighboring reservations remain distinct because the new region records
> + * the requested NUMA node and MEMBLOCK_RSRV_KERN flag.

Please don't change the test. Just use MEMBLOCK_RSRV_KERN for the first
reserved region.

The same comment applies to other changes as well.

>   */
>  static int alloc_exact_nid_numa_reserved_full_merge_generic_check(void)
>  {
>  	int nid_req = 6;
>  	int nid_next = nid_req + 1;
> -	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
> +	struct memblock_region *left_rgn = &memblock.reserved.regions[0];
> +	struct memblock_region *new_rgn = &memblock.reserved.regions[1];
> +	struct memblock_region *right_rgn = &memblock.reserved.regions[2];

-- 
Sincerely yours,
Mike.

