Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90F9CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 08:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F00B6B008C; Sat,  3 Oct 2026 04:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8006B0092; Sat,  3 Oct 2026 04:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD6A6B0096; Sat,  3 Oct 2026 04:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65CB16B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 04:08:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 799C38092B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:08:35 +0000 (UTC)
X-FDA: 85280588190.05.EC3F78B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D6D5F20003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:08:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGdjLO7h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791014913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhCXWf+F0kKIImkvMzPZcVKqpKPzzmNfLTmAIwKhi5U=;
	b=Yo3aoCvMVvH+0/CZXFFcNVgUmyzicB56utYqs+b1JWVRzv8M6phIXwk45yGJliaLvabo1f
	m8Ei8yZ+Z88Fnxev8ZzaowgaBSJexAVauJ1VH6ZXn+z48WGQqOJoYHCGexWmH/G1Uvthj4
	AImIyE76r1+NtdVh1WJVmBqeTqdJyhw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGdjLO7h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791014913;
	b=14xQloStroRiOz9vBNPwxEkKJM6TqoGkW0aAKuGVizeqNg1vGTKa0glckA3xcnkWvreU1B
	h54hjSEIz7RiajTAwbErpuZrgabUeUlL6R4H+22tG89p0eJbE/5OZhPxwZdxbTEkqqn9aR
	YgF2NEs8nEv899nDtNNyR8kF4ecs8vw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B668602C2;
	Sat,  3 Oct 2026 08:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63ED1F0089B;
	Sat,  3 Oct 2026 08:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791014913;
	bh=PhCXWf+F0kKIImkvMzPZcVKqpKPzzmNfLTmAIwKhi5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AGdjLO7hHmOhRag0vBx5sQqVyd+RlVq7IP4+6qDwZUTfovA4AJYzpewdSSQWLKaeL
	 IpOZLkyXTGTubJs/poT8lC0J3jf834xXHqPvi2yTe4mrrVQb+aUDnbYXxqp/iBRZRF
	 9GrQAnbemBXcwcSvjxuP24IQdAhD2Ry4ZKmaOlw5LHCHi9m8eCSm4FT1KIi0BZbMmS
	 F9i0XllekZXGkXH3ctDa4VU/kXVJfqR0uaterPWUAL0liqvHOJvF9LrGS9dLjib1Az
	 CoUcT9A1vO6CMkL3lNKrm1ftiM9RydTWKVhVESuMstXqbA7GLdo41lX19+iDpddiOw
	 FHSv/+XXGltpA==
Date: Sat, 3 Oct 2026 10:08:27 +0200
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
Message-ID: <asC3-4WNiTF3n7l1@kernel.org>
References: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
X-Rspamd-Queue-Id: D6D5F20003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: yu1tgyypczizqtuo7733iw7dgeym96x7
X-HE-Tag: 1791014913-272953
X-HE-Meta: U2FsdGVkX1/mc+tX1kvrbKWgzCrM3fk1emwDnQ1cgEtvk7jFZ4lHXjY4MAaPB4rUhcwN2PVPwusNpL5nsVPAxzDjUhS/sADFoPmKrDJlrdiYB7jnP50Wo5pFU0DhPhiKa0LyzKK5y+w3JzAenQdjh1fgyf+yXaMF/ad6iLjdmJl7y1hji2EeASQclWd5SuzfLx1T2joCR54Rb816KsbVV2biYZzF3bSxpeJxjYnCHpORFsFRGu25L3Z0w/nh8wSTeK5Xx0ZBzkydxOscfeIMjVAFIJ8uLEMssOUl8hkgzmXQTo/vgLtycol5LFjmbVyQPVXJdMaED+hqrnQGTiXG+f7pgTW2ojea9A4Ojf+La4TgdApGHZHTugfeOoPJrLmzoDFoV9MMzQQ+JGH9Lpm7SvJDCM4in8iXJJmSaCYd8yTKo5ivKMJlcIMGS/ligBEsPcTcLg/T+eWsVhKG4WRhLzwDg5J2IispSTd7RAy0yFJDUVxrYUdPOF1xOqvzvQJH2iVAGP6lE1gJHmL4/zEhDoo6Fv1uGNBUDAaC5ddh/OmTpgSdWiN7xX8fopA9S3rLN5hrdJo9o/IQA46kMRiU8thr178xQvZRm6BZIKhQ4EHj/tbKEjn5fTwYIVmE6XEWT3s/oSoqk5F6tNCWEe84rr/omcFG195Hrl2St74ZddMelZ84KawJfzlxw4c6K+4id4V3APE404v97UGuBr1l3XHBD7rOv+esz4xeTsH5+Pk5y34zb16mt4uA1Yw03arUXLRbDUx8Lxm2R9UcHr5a/Zog+96QjIB7DgK5bmQbcQp87YTxWweb3jEKzc1v26EZ18MQvLWK376oQyiQBAvN3PYZn23f+szbVwU0iazXCduTmxEhX53d4sMXlZOF6znf3apgQxWNCaFmBgmBBcUVJ6PTRGEhHRKX9G8rEd9XvhoCRq0pUKeDGFt4czOw3m4D1hmOQfS6SuSptMuc1AQ
 OhEVYvdJ
 ACYTtisFpUj3ezsAR41fFvuBiB5IP+zaazMwVLCCH9ME1D06oPjI6Kbjy+pc7WdbEB8YxOqo+fZXqsD79yTdvamARFr9K6hSxWG2aRlPgb4/U9EeZLOaYT3fVKjLTatF299NDccVLBCGE8dGbOUbTIHnIxAT9F/mXK9KeJBZ++pLuirg5GIZ6G/88iyFRXP1tIZa74Vuo6YmwGV51E2A2L1XIE3jDpYG9no9UY0P+BhvC70OYQ5BRsb3bqRStMRPRDOIOfCs2hlUS5XHyA4UK6CRKHqjjcqsU9vtL6n3dWUS1E1U92HG3kXiP05eMj+3hNuKWOhCSziscyV0MnhcmVhAd4zr+lMftm0dHVc2m7U6ZBYk2m0fQCsSC7+fT6XResij/mAN2CZhcQrEQ4qzt2PhH6/6PB22qeCdcfSmLRjvSD2EFXuBQXdGrDq0/NvqKFjjjJeBFHaU2CP1A97UaGqKpKKtf3aapOVjLrHoX9M3tx4pS4zP+pgaURk7EyeXT3iAtyGZN9rUJBOzdAbaxcCV4Mu12nBDZAgjXUvK4zDlo9/Zg/7gsf3o43RAJzqFh72r5O8+rUeW3CEkh78u91ZBtOxR/+dkpr4vo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

I looked again and this feels like a band-aid to me.

I think we need to step back and rethink the order of the
scratch/kho-bootmem sizing and consider how NUMA and lowmem are involved
there.
 
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
> @@ -762,17 +787,17 @@ static void __init scratch_size_update(void)
>  	if (scratch_scale) {
>  		phys_addr_t size;
>  
> -		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
> -						   NUMA_NO_NODE);
> -		size -= memblock_reserved_hugetlb_size(ARCH_LOW_ADDRESS_LIMIT,
> -						       NUMA_NO_NODE);
> +		size = memblock_reserved_size_nid(ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE,
> +						  MEMBLOCK_RSRV_KERN);
> +		size -= memblock_reserved_size_nid(ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE,
> +						   MEMBLOCK_RSRV_HUGETLB);
>  		size = size * scratch_scale / 100;
>  		scratch_size_lowmem = size;
>  
> -		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						   NUMA_NO_NODE);
> -		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						       NUMA_NO_NODE);
> +		size = memblock_reserved_size_nid(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE,
> +						  MEMBLOCK_RSRV_KERN);
> +		size -= memblock_reserved_size_nid(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE,
> +						   MEMBLOCK_RSRV_HUGETLB);
>  		size = size * scratch_scale / 100 - scratch_size_lowmem;
>  		scratch_size_global = size;
>  	}
> @@ -790,11 +815,11 @@ static phys_addr_t __init scratch_size_node(int nid)
>  	phys_addr_t size;
>  
>  	if (scratch_scale) {
> -		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						   nid);
> +		size = memblock_reserved_size_nid(MEMBLOCK_ALLOC_ANYWHERE, nid,
> +						  MEMBLOCK_RSRV_KERN);
>  		/* Do not count HugeTLB pages. */
> -		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						       nid);
> +		size -= memblock_reserved_size_nid(MEMBLOCK_ALLOC_ANYWHERE, nid,
> +						   MEMBLOCK_RSRV_HUGETLB);
>  		size = size * scratch_scale / 100;
>  	} else {
>  		size = scratch_size_pernode;
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 021db49eb7fc..9da748e774ea 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1900,28 +1900,6 @@ phys_addr_t __init_memblock memblock_reserved_size(void)
>  	return memblock.reserved.total_size;
>  }
>  
> -phys_addr_t __init_memblock memblock_reserved_hugetlb_size(phys_addr_t limit, int nid)
> -{
> -	struct memblock_region *r;
> -	phys_addr_t total = 0;
> -
> -	for_each_reserved_mem_region(r) {
> -		phys_addr_t size = r->size;
> -
> -		if (r->base > limit)
> -			break;
> -
> -		if (r->base + r->size > limit)
> -			size = limit - r->base;
> -
> -		if (nid == memblock_get_region_node(r) || !numa_valid_node(nid))
> -			if (r->flags & MEMBLOCK_RSRV_HUGETLB)
> -				total += size;
> -	}
> -
> -	return total;
> -}
> -
>  phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int nid)
>  {
>  	struct memblock_region *r;
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

