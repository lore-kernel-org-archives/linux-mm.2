Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8572C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAAB66B008A; Sat, 26 Sep 2026 05:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E828F6B008C; Sat, 26 Sep 2026 05:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D994F6B0092; Sat, 26 Sep 2026 05:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B52D16B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:07:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2305240817
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:07:06 +0000 (UTC)
X-FDA: 85255334052.21.4B828F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 724C440002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:07:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lf0MJXkU;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790413624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MN7/YNmFykM+Q/E4Xx2sgObdvP7k1Pyx2eBjEnQm+E=;
	b=M2JD39PEjT1tkVMWad/XRhvCkmUDFl1CWZJet+csNGu87/ACtFdbyGjOwJ2AkSXTLF9wqR
	0wdtNLw7aoRhhmxwhk7JR7auZf0lAKDs9V6rrmtJynXYCPQGN7sWzSoVOhR+iqtxctZwKj
	mzSsobbMtUljqh698gu8xB2p0hmveBQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lf0MJXkU;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790413624;
	b=Dmd+QIu50YEv3zFWBq1bD+EiPLVjCHRba7Cr11HSt/2XcnIZl+9KkREHF5O6MMmUe4DThb
	hPePPWoqHrl/vPbGhOrJNa392JTE2LrhjF86ScOJ57YwfDGL3+bOtytZrzpLTYg65zVub9
	O56epOptTTnl6JvTIxUPYRQT5Rzb3sc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9964543EEC;
	Sat, 26 Sep 2026 09:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491B71F000FF;
	Sat, 26 Sep 2026 09:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790413623;
	bh=0MN7/YNmFykM+Q/E4Xx2sgObdvP7k1Pyx2eBjEnQm+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lf0MJXkUoYjmOO8Zwb8vIvA5uxqyFRr42qmD8bpiiuuc+YlAQbA5FZg6WmohA2S2W
	 BcPl9Ua2Y0vA4e5sWNQ3N6sorsf4zmkGr6JurTKOEYK2RyUDThaUTviF8/8BfUJI/p
	 8Y4Z+1XRSq0Vk1au3yRFRfptTt1kf1NiZ5T5g//k6ePXa/exIUNtQWRqREzz8jscJU
	 fH+5pnTW869euEUnAZfj/UmTB5EJDr9D7CJC0N1XSRyWETcOOFTKXG7X0rmY6kKoRv
	 hVimUOo8K8gOAtJioFv225DwUSJ/4Je4ZgWAWEl5vBmdYO0/4AftlodYCTfj+23udv
	 ecAcwpbb0lQ8Q==
Date: Sat, 26 Sep 2026 12:06:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: kexec@lists.infradead.org, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	George Guo <guodongtai@kylinos.cn>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kho: fix global scratch size calculation
Message-ID: <areLMLTC-bO1zcXP@kernel.org>
References: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 724C440002
X-Stat-Signature: f3zu7is3qjfx6ztyg6bbeh7tnegk17ro
X-HE-Tag: 1790413624-525255
X-HE-Meta: U2FsdGVkX1/cuVmCv3etvJBJ6R+G//UNI+D2kM7L1PJf5WL69PF3js7u0L2C+51zldJ7TCBpTUYHwZUO5DXvmHsBxpzz0QinSl3bHJs1rFgCmZWDbdsIXFOmkp3qZwsiJ4OsXmGiTlPjBKwum8y+DRHthNt0yodzNWqDJvsLujcllR6oIia/tY/al2/ynNnqxlSxbjwSXo7yQqn1t1NNzPmytCbV1uYA33Fk1lCzVfDcWyCj+N1TWS4QngptKCPc39xTtkLzTsvnWbao/idoMtRPyOhmm5l7OZAvdsRqfD+XJLVMv6mXGNhNoVKB0yvuNWh+btUy8jEJmfQp5jtmr6QtjbtCYtpHfv1bTiPgqL9C/pZpVT0XYmhcVzAM24sztjnnDyWhafozy078H+KTnakLCcNcJSyP4JU/XaShjjv8qy2U9PjgFUQKKW+2wQdG/cC5zvfc81ak0V1GATYe2WN3oRAgyPpQnNScA1HcGn7PDIcq6/7qx0tVS4xR//1Jq+uax+SG35LvMqdl0qGFU1H2ff/BJLBLZAAnUeju43YnCl3imJ2M5nxLbR88ummbYZA6XU18u9A3O9rQLioZzcSa32dboYeNkzCUQhgRRehxoVXyiBd3xXiCvmi9Oo4M/ujjiyotBVYc3fcY7nvqrAahTkzPDteXxz3Rkp9VmI1GaDJoWKWgtRzX5elNo73mMW98JVCNQ2Et7y4rWt4KFvsP0IjetdTd8oc56BVJN9EngHb3uI09BHFADNy99DqpMdwQnC5Xg6sKcjqdeL/j5nanjDU32c/3sVqcFhe0k/nNYng+dSJxh3DT2YvTKQY7dL1mZb92NyMuxpVhHEvsOazE2qSqjFHpURCnSM+g4BpgJ8rc4gRtraTjbhDdYeVGX/6L7WE7I9WsX1+YNJH7JTh3cJwcHS1g6QkLXzvGzD0/Al9JgWWltTpjwZCKGEK5OKyVcrc1uo1EiTHObF2
 YFwDLlt0
 I7EIagI8XY/jB3+vSzuMR8iDqe6wsvbHYim4hX4PpxnAzvFpOGDXxwnKgOXEB5Sz9hjh2GR7Ktkm6e5Dx7tcPvh4r0u9oT/8hB/YTLCR4KV4lSSTYL9ENIUnSvTcUfWJcBQZ2h95EzYv3ibtT8jFh21DAQW+ZB+crMnlYmCvek9L6h1XtUwf8YKm6tHWIl8kb2cxr94rzDHMZwx6YTeFnWtn2koyzKuYphidciLGUHQ5SPAfmSo/YwXvYyxmpF4sW8eL5s3FrSgoJTPtcqt8CYvUt/MQJ6OVJpYvGv8RHMgZrR2phoAWQP8yC6HgCxD03JvNrhneBpswM/PHSs6GftiZ+qBgCFrs+6OjMIA8VCbZHwCOa1hsjT/mBJZCvfuzkYkm9FyCYj+hwBsgvZlVCmh0/qWybTDZswmuRo0QTDS+3EqU91jOMBT+pdJNYiGmaoy6fro8itJFivd0oRorUnGESy9HYA7IP5UowUCahDroNR+YDVTofh1cbUCeQ66jpZhVk4bdsbf4TB6Gf4DDckDg94CDJpFQnvUIsLoqVrYjpZqBVfYUUxuOjikJuO+d7ZiE0gprEA6S9XMWPDB9ppEkvV9bNalAfPnxG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sourabh,

On Tue, Sep 22, 2026 at 06:42:16PM +0530, Sourabh Jain wrote:
> KHO calculates the global scratch size based on memblock-reserved kernel
> memory. It passes NUMA_NO_NODE to memblock_reserved_kern_size() for
> this calculation.
> 
> When memblock_reserved_kern_size() is called with NUMA_NO_NODE, it
> counts both:
> 
> - memory reserved for a specific NUMA node
> - memory reserved with NUMA_NO_NODE
> 
> KHO needs to distinguish between these two types of reservations.
> When calculating the size of global scratch memory, KHO only needs to
> account for reservations made with NUMA_NO_NODE. Reservations made for
> a specific NUMA node must not be included in the global scratch size.
> 
> Add memblock_reserved_size_nid() to calculate reserved memory for a
> given reservation type and NUMA node. When NUMA_NO_NODE is passed, it
> counts only memory reserved with NUMA_NO_NODE.
> 
> Use the new API for lowmem, global, and per-node KHO scratch size
> calculations. For lowmem and global scratch, count only memory
> reservations that were made with NUMA_NO_NODE. For per-node scratch,
> count only memory reservations that were made with the corresponding
> NUMA node ID.
> 
> Remove memblock_reserved_hugetlb_size() since it has the same
> implementation as the new API and differs only in the memblock
> reservation flag being checked. The new API handles both kernel and
> HugeTLB reservations through its reservation type argument.
> 
> Define the new helper as a static function in the KHO implementation,
> since it is only used by KHO and has no users outside
> kernel/liveupdate/kexec_handover.c.
> 
> On powerpc, the difference can be seen in the scratch_len values
> reported by:
> 
> cat /sys/kernel/debug/kho/out/scratch_len
> 
> Before this change, the global scratch allocation was 0x12000000
> (288 MB):
> 
> 0x1000000   (16 MB)
> 0x12000000  (288 MB)  <- global allocation
> 0x5000000   (80 MB)
> 
> After this change, the global scratch allocation is 0xd000000
> (208 MB):
> 
> 0x1000000   (16 MB)
> 0xd000000   (208 MB)  <- global allocation
> 0x5000000   (80 MB)
> 
> The 80 MB difference is the per-node reservation that was previously
> being included in the global allocation.
> 
> The same issue also affects lowmem scratch memory, but its impact is
> limited because the lowmem scratch memory calculation is restricted to
> the first 4G of memory. The changes also cover the lowmem scratch
> memory case.
> 
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: George Guo <guodongtai@kylinos.cn>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> ---
>  include/linux/memblock.h           |  1 -
>  kernel/liveupdate/kexec_handover.c | 49 ++++++++++++++++++++++--------
>  mm/memblock.c                      | 22 --------------
>  3 files changed, 37 insertions(+), 35 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index d62db9e776cf..678fe466529a 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -487,7 +487,6 @@ static inline __init_memblock bool memblock_bottom_up(void)
>  phys_addr_t memblock_phys_mem_size(void);
>  phys_addr_t memblock_reserved_size(void);
>  phys_addr_t memblock_reserved_kern_size(phys_addr_t limit, int nid);
> -phys_addr_t memblock_reserved_hugetlb_size(phys_addr_t limit, int nid);
>  unsigned long memblock_estimated_nr_free_pages(void);
>  phys_addr_t memblock_start_of_DRAM(void);
>  phys_addr_t memblock_end_of_DRAM(void);
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 7c4d86daf86d..dc809e1e768c 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -752,6 +752,31 @@ static int __init kho_parse_scratch_size(char *p)
>  }
>  early_param("kho_scratch", kho_parse_scratch_size);
>  
> +static phys_addr_t __init_memblock memblock_reserved_size_nid(phys_addr_t limit, int nid,
> +							      enum memblock_flags region_type)
> +{

Why is this in kexec_handover.c and not in memblock.c?

> +	struct memblock_region *r;
> +	phys_addr_t total = 0;
> +
> +	for_each_reserved_mem_region(r) {
> +		phys_addr_t size = r->size;
> +
> +		if (r->base > limit)
> +			break;
> +
> +		if (r->base + r->size > limit)
> +			size = limit - r->base;
> +
> +#ifdef CONFIG_NUMA
> +		if (nid == memblock_get_region_node(r))
> +#endif

Do we really need the #ifdef here?

> +			if (r->flags & region_type)
> +				total += size;
> +	}
> +
> +	return total;
> +}
> +
>  static void __init scratch_size_update(void)
>  {
>  	/*

-- 
Sincerely yours,
Mike.

