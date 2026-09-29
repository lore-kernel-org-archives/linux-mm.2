Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 946A4C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8291E6B0098; Tue, 29 Sep 2026 03:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9FF6B0099; Tue, 29 Sep 2026 03:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1EE6B009B; Tue, 29 Sep 2026 03:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37DBE6B0098
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:21:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8F67A67CB
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:21:36 +0000 (UTC)
X-FDA: 85265954592.10.41EF6D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1D06040005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:21:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Grj63Eom;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790666495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVzH9135wJ4QdeRKwEGZjDTmaDD7x+M+UkwMS7ATjN4=;
	b=IbdibUGLSI1dx6RCeQ77mz1/lGxIH7XY5CIb6j+ehZ25IjpYor7RIy4SBNKNh7EtHyPb5w
	db2t7ffGwqTt2vO0bAUVQX32C5fDELfNuAF4lGS3CK2GYEZGzhG8rah93CRJko5ogaAT1V
	dgXP6wdUMAWd6S/1vDu1ESw4l6B65MM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Grj63Eom;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790666495;
	b=ixCZ/EOfe9aoqAsrKWeYTAYlmlA1oVcL48pQhriaSQNwx8OEQizv74sCiA+bvy/QSTh0dI
	1j+5PEWu+6uvBn4kkoT/9PRhUjYTd1jx2PlDMfBq4/dMhmCm0f8YwdPL9IYyDQKs9Ru0I7
	1WkFL5MsZ/Sd9Ijid4QjxQKgtgz6HDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 93CAB60A62;
	Tue, 29 Sep 2026 07:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C591F000FF;
	Tue, 29 Sep 2026 07:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790666494;
	bh=jVzH9135wJ4QdeRKwEGZjDTmaDD7x+M+UkwMS7ATjN4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Grj63EomMmOFpWGNtNOisS3ON2mRVEMypsHP3ZZRNfWxdN61pkoauFTDOjgQFK62T
	 eVxgpKP6dJISPZQvvWkHjQjDrqp69WceyTkNA5XrrQS50WllfO+zpfgoFWdMOtZuWb
	 d5R/t1WHiQDDneBjPc9UbC4gnlkI2KYlcHF4WA631f8AsuQLZJ6HxJQm+8GiTIzHHb
	 5amDF0CEQLBDkIgdXW+xtT3ivF4XOvfTRKRCyLBbhSTR/49/vPbD3EmPEzu8cWK4pr
	 8yuR0p6ti1+jWnCDofwE/zlRGcdP2GUvWSIBzKnvVcEZyZlykkkTz+EO8c2NU9AaIy
	 7x0EbKwjy/qzA==
Message-ID: <36a93f95-2fb4-4310-bef2-88c12dbe7971@kernel.org>
Date: Tue, 29 Sep 2026 09:21:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/12] mm/sparse-vmemmap: allocate shared tail page
 array dynamically
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-3-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D06040005
X-Rspam-User: 
X-Stat-Signature: n6m9aime1hpj77n6p6pas7cm8fj3qd78
X-HE-Tag: 1790666494-973145
X-HE-Meta: U2FsdGVkX1/BRHNTl+zcr1CtIyFCGyphkETv6QGTp/71oIbzPt6Y0GlKd7csNGB02uNB72PULTYy3h+Lml/fu3C+o30YrKUAzuvZmEhpTW0Bd4i0RL0VLSe+XJNP0Ubwckr9MRXwWl2YGgQv6dCvJbhSMHfnO85jMHbYgsRQDRosJFjDNpsTPD4YYiv2CMe8gX/AifAfv877pKJtZrFAuEQZnWKUtOOpKhhQ1prVhUkM/h3M9/TDs7cabB+z5VepHEy0g0J89WdmTuQskmuvoovei0hXj2kGwgPY9kS/3Z9sXnkgtoitSOs8hj0eXlkVwEoGO528lwEq9jSfgbYd9iNqWYsWzRmIsCPq3lN8Wg8nL/mQa2IzY9HKUX15PMmexcHgNkAUXcAGe/6iCJd68SEL3btTJ04UWpdaDxf/L5PdDErNDDsrxItvZOHTEVjYeiAQWBsmCyO0SpHkqFEPi/dbsVNd/TBcFe5dG5+TZlU0DPgzHc0gxlHWfnSs8JuTZnwAYaJsmqXCtCYBnzNbtY0BkvVpi3XrnNJkX3cv1mwfNupRE0lX1MPgYi+WhLXtwMzC5wGFFi3Pat1jHFtFNwvvTF/A2rCGgVi178GPwbAtQCbvWXUW67bbgKPhKgsLBVvVJ2o5ddSMj0KSfyoat+db7T/AXYvvrYiMemmK/AZE9Vv2YZRfjZShfly9+UaKGEIqDfkn0LkYjSj2F++A134mbYOLwrBuw/FVVfSKV14hWg+n6y11qFOs03oCuW1fdJyZilcNS78X9Q3sltlA6mFNNj7m+jnsiy/rFpxlU3L2K3CBLlsBZ6VPQ0aK4ys/z4M0/bt6B1tJxx8RjU+WAiZv5OlrJ2ad6kHdicvebvZLsoEIqQG/8udlWSBY2GYMvP/n0j7WRZJa2GdbEy8v8Hw76i5UGVsB+Z4tOw7L0Ea5EZSiPX2pIKyrLnZwbTBzoZ5p8YWhZKH6lelaKk2
 j9LmeAo1
 0B8L/5ZR9qsZZcY9qHy7jJ49G+NxVDCUjYyomGWbULZVk3snjiac40oRCrXp6in2a74rMkP/R4HaxgUTaRWUfa2wP3h8C0aJnowuLrmdk+a553PuQOKwymK9eTmX8FSeDlOm0qTyXmSoe3tJsOAyP3fP3zJ1lzyEzbRXR/VcRy5VgHE1VJqrWepAVZuY+5Os4dvBazkx0bkCYbNj1L9SP2avzPVoKonIBEEEQrGG/QyzwVe8pEQffAPUqFrMEcGAmpp3FVozISf8GzKJyBJYWi5D8yXqMQN1uLP/q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") added the
> per-zone vmemmap_tails array. Its size depends on MAX_FOLIO_ORDER, which
> had been moved to mmzone.h in preparation for the array.
> 
> PUD_ORDER is defined by linux/pgtable.h, which cannot be included from
> mmzone.h without creating an include cycle. It was therefore open-coded
> as PUD_SHIFT - PAGE_SHIFT.
> 
> This removed the dependency on PUD_ORDER, but not the underlying
> dependency on architecture page-table definitions. PUD_SHIFT is
> generally provided by architecture page-table headers, which are not
> guaranteed to have been included when mmzone.h is parsed.
> 
> The dependency remained hidden because vmemmap_tails was originally
> guarded by CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP. Under that condition,
> MAX_FOLIO_ORDER resolves to either MAX_PAGE_ORDER or the fixed HugeTLB
> limit, rather than the PUD_SHIFT-based definition.
> 
> Device DAX, however, does not require CONFIG_HUGETLB_PAGE. When it is
> converted to use section-based vmemmap optimization, MAX_FOLIO_ORDER can
> resolve to PUD_SHIFT - PAGE_SHIFT while it is being used to size
> vmemmap_tails. This would make struct zone depend on architecture
> page-table definitions being available when mmzone.h is parsed.
> 
> Replace the embedded array with a pointer and allocate it on first use.
> This moves the order-count evaluation into sparse-vmemmap.c, after the
> architecture page-table definitions are available, and removes the
> dependency from mmzone.h.
> 
> Removing the compile-time array also removes the original reason for
> keeping MAX_FOLIO_ORDER and the vmemmap optimization sizing definitions
> in mmzone.h. Follow-up cleanups can place each definition in the header
> owned by its respective subsystem.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v5:
> - Add this patch to fix the RISC-V build failure under the configuration
>   reported by the kernel test robot
> ---
>  include/linux/mmzone.h |  7 +------
>  mm/sparse-vmemmap.c    | 35 +++++++++++++++++++++++++++++++----
>  2 files changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index acd94cecc0d3..68807ff7f946 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -113,11 +113,6 @@
>  	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
>  #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
>  
> -#define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
> -	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
> -#define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
> -	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
> -
>  enum migratetype {
>  	MIGRATE_UNMOVABLE,
>  	MIGRATE_MOVABLE,
> @@ -1156,7 +1151,7 @@ struct zone {
>  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
>  	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
>  #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> -	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
> +	struct page **vmemmap_tails;
>  #endif
>  } ____cacheline_internodealigned_in_smp;
>  


[...]

>  struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
>  {
>  	void *addr;
> -	struct page *page;
> +	struct page *page, **pages;
>  	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
>  
>  	if (WARN_ON_ONCE(idx >= VMEMMAP_OPTIMIZATION_NR_ORDERS))
>  		return NULL;
>  
> -	page = READ_ONCE(zone->vmemmap_tails[idx]);
> +	pages = READ_ONCE(zone->vmemmap_tails) ? : vmemmap_tails_alloc(zone);

This reads much nicer if you handle the  READ_ONCE(zone->vmemmap_tails) inside
the function.

pages = vmemmap_tails(zone);

So just place the entire logic of obtaining the array in there.


Apart from that LGTM.

-- 
Cheers,

David

