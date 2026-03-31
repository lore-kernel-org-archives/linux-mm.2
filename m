Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A7C10F92FD
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932436B0092; Tue, 31 Mar 2026 16:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9099D6B0095; Tue, 31 Mar 2026 16:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F356B0096; Tue, 31 Mar 2026 16:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA586B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:29:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBE688B39F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:29:09 +0000 (UTC)
X-FDA: 84607497618.27.8E4B54E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id CCC83140007
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:29:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQ6oC3vz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774988948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KTkQBINa5saDvWdadzna3hOOOA8qIAlvXqHIMEyXKM=;
	b=WUBjLZmoXb6U3x7bRpKbTBDRe+sdTIrjtoHHH+hV3NdVTfsOWAp0vz796Y8nKM502vqi+D
	rt95lQ5Tv+7sqDJAwloZ7nKmR4ial8DHevZ7NJGtbbeq6OxCtOfRutFAoi9vjHDRZnMqgr
	cZbtiEIDeaj113EJmcOA4vBX2axjGX0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774988948; a=rsa-sha256;
	cv=none;
	b=0s4uZBiOxlOXfQaAxdY33tnI8sA28G7DfRkfVxIz++IDygZ/1jGULm/uaXTABivFLJA6+s
	7bdpZXIiaEu8ny5bvk3u4zT+d/VwoatTMaVGMCRwiVE6GsIsS7cg+Y15S/NhtOplbw1eVw
	y8YZvnJ0Fpi4llrLZQ7aCH8sd34U/KU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQ6oC3vz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 99AF041AD0;
	Tue, 31 Mar 2026 20:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59882C19423;
	Tue, 31 Mar 2026 20:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774988946;
	bh=pKby/ZX2VmMWpNCCDNP2Wy4p5zuyG0QXqTXu3JUWTX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vQ6oC3vzb8AdJasj93sjco6igdBg8z9qx/+U8QqY5qEhJkbHvNJNW5ZhzMtnFvs2D
	 bSvzOEHAiGnHAv8KfsTkz2mg0DxEHjUR1vEPUX2f3zRYFWGXNO3dQX0lgM915mAcPO
	 sjiGHNtQH/nXUNaPRcg85tli/zb8Iw6I4m80PlZx4VKza8/qCXd/doB6nmENU8/9si
	 WoGn37PGC0xOJZ3WiDakDZKLmLpsm0FvuNWgx57LmLe4Gm5XKbnp6zBIfCnWEDejMM
	 HdYreEKZrAH2MZfSDA7f3RRlB82+alfnW2SMkD99zR5hsfUm/ZPAQIA27/CTyBk7Il
	 2uNTREtBD6hCA==
Message-ID: <32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
Date: Tue, 31 Mar 2026 22:29:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260331113023.2068075-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CCC83140007
X-Stat-Signature: jfaikfmnutb7dopfxhuzxmw35afikdyx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774988947-223262
X-HE-Meta: U2FsdGVkX18cxEAIhzbxPCQnTyNNW+jUc3AGJneVgeO++6ExOy+aHL+nShnxwqUkXLOToqi47A1hlh/UcVOhAyoY4XmRsGSNQObSXrPD3FlYlMKw18h/Q9ayIhBTnkevwaGNz1NgbM3lwl7kumtPwCNZ5JgfdQRzv1B9ODmBx1UDZKUx5vplHGnAl/XB1CSGpDDXyidr4XZATieBQjCaZ1obA4GCNVlf6T3o05XGdbPBk8SN1NOeoJ+et6lxEMeb7eqGBCHbiaKiBC4AiH+BHLIvN+nbBkXim2tA2RQKmyDxxoOze9K0VflutaLGoXNsBAFwajniPU+m3dIiwgzN0PAhvZS2l1btPSKpT09jzOpCQFhoXOgikMXxsxjZZiQOebqzQcvq3yUritfQ9AMjdViUrCf5dxl3HvCgB63RkFx5PPrm8gQdBKZfJyJZqrqo5liEEKUalPqLj2Y5kGmTwgGIMTODMMw72gpwoGZ30p6WMFVo+e23r5h1NvzKxLjUl9DByIoRz1B7wWvlcusqO/8F0H0dN/0k3ZlMZ4zi37Cm/5n7id5iwbPeLFVkJRz1nmYFjELIuIpxn2XQhTNEZFtDqDgepfemVDBhbIGMSyovYNzTyKRJ+0sixpwLj9Ms8sv8BbzRaTmFXpaLphi2xFTpCRzsjwcqPbkMJeCILDUfuTXOorqzqX3BsCFNJkFe8KdpcpbPBNGqFDkqzVgiYHJlvLd4em4rs4LXusn+ThlIewR6DCdiSn5xmw6eG8Jjmg6atWUgYkh5HmH7GhEdqyBJikTtV3V7em0UpsKqbI8yaHUYD/1JKMVfboZWoXbTwxU2BatJtWqJrEPaWrRdmSlAIFAGNqfZJmdhwVUE7afgS8PjHB4t1VeSWqgLrd+vJOcdtGqif5eE+fqYaeG2DgnoRUnZwb5EPoMdjIsCUSQ+tDNe9ic8QMiQ6VdHFoW8l20JpjPeXq1dB+xbq4v
 jRRCg8Kc
 4TryWWuPuLzGdVMSXJbe8JS7QRJ6cD3wApuaPeqVJoN51EA0lC2kSauyksvpi/NPYyZI6ZRtd5b5oVkhiWL0+pm/afSTG+HONhD+xZlsZrDX8E5krTXR66OvCS2/jI3TrPcul7gkRW/xF9m2+D2FXdww5A0Od7U98p1EKUes7eX8IWtI+Aq9gqLQhMU9yK4gDT8tv4rZ8TLzigufTaFESPqhYnfbdEhhR8b7Y6enX7Gf907IkJgZnWnUcOjc9LWpEYMe+uT/ZlLaZO4jMG4axDUZ755TktMfvqVGOPzKNeurqv41IvuLfXSM3HsHwjmGarhB69tBPTOUy5G0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 13:30, Muchun Song wrote:
> The comment in mmzone.h states that the alignment requirement
> is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
> pointer arithmetic (mem_map - section_nr_to_pfn()) results in
> a byte offset scaled by sizeof(struct page). Thus, the actual
> alignment provided by the second term is PFN_SECTION_SHIFT +
> __ffs(sizeof(struct page)).
> 
> Update the compile-time check and the mmzone.h comment to
> accurately reflect this mathematically guaranteed alignment by
> taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
> __ffs(sizeof(struct page)). This avoids the issue of the check
> being overly restrictive on architectures like powerpc where
> PFN_SECTION_SHIFT alone is very small (e.g., 6).
> 
> Also, remove the exhaustive per-architecture bit-width list from the
> comment; such details risk falling out of date over time and may
> inadvertently be left un-updated, while the existing BUILD_BUG_ON
> provides sufficient compile-time verification of the constraint.
> 
> No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
> the smaller limit on all existing architectures.
> 
> Fixes: def9b71ee651 ("include/linux/mmzone.h: fix explanation of lower bits in the SPARSEMEM mem_map pointer")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  include/linux/mmzone.h | 24 +++++++++---------------
>  mm/sparse.c            |  3 ++-
>  2 files changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7bd0134c241c..584fa598ad75 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2073,21 +2073,15 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
>  extern size_t mem_section_usage_size(void);
>  
>  /*
> - * We use the lower bits of the mem_map pointer to store
> - * a little bit of information.  The pointer is calculated
> - * as mem_map - section_nr_to_pfn(pnum).  The result is
> - * aligned to the minimum alignment of the two values:
> - *   1. All mem_map arrays are page-aligned.
> - *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
> - *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
> - *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
> - *      worst combination is powerpc with 256k pages,
> - *      which results in PFN_SECTION_SHIFT equal 6.
> - * To sum it up, at least 6 bits are available on all architectures.
> - * However, we can exceed 6 bits on some other architectures except
> - * powerpc (e.g. 15 bits are available on x86_64, 13 bits are available
> - * with the worst case of 64K pages on arm64) if we make sure the
> - * exceeded bit is not applicable to powerpc.
> + * We use the lower bits of the mem_map pointer to store a little bit of
> + * information. The pointer is calculated as mem_map - section_nr_to_pfn().
> + * The result is aligned to the minimum alignment of the two values:
> + *
> + * 1. All mem_map arrays are page-aligned.
> + * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest bits. Because
> + *    it is subtracted from a struct page pointer, the offset is scaled by
> + *    sizeof(struct page). This provides an alignment of PFN_SECTION_SHIFT +
> + *    __ffs(sizeof(struct page)).
>   */
>  enum {
>  	SECTION_MARKED_PRESENT_BIT,
> diff --git a/mm/sparse.c b/mm/sparse.c
> index dfabe554adf8..c2eb36bfb86d 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -269,7 +269,8 @@ static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long p
>  {
>  	unsigned long coded_mem_map =
>  		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
> -	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
> +	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + __ffs(sizeof(struct page)),
> +						PAGE_SHIFT));

If that would trigger, wouldn't the memmap of a memory section be
smaller than a single page?

Is this really something we should be concerned about? :)

-- 
Cheers,

David

