Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F68FEDA1F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 20:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F786B0088; Tue, 17 Mar 2026 16:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307446B008A; Tue, 17 Mar 2026 16:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243F56B008C; Tue, 17 Mar 2026 16:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1462C6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:00:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C024E1A035D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:00:05 +0000 (UTC)
X-FDA: 84556621170.12.1FDC7D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA11D20002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:00:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKGd0sMP;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773777604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=088UT2grgG1Ya1RFANL/bQYEbatd0FsMrt+fGhUVOjs=;
	b=SfIokAzrFOu2LXJ+wKlMoXQWs3F6GLYSU6Ab01RbLGgmFum2EgjVZ/lUSSr2bbT4jBifN2
	bm9UQwBWSiNrGuY64GVlWo/q9xrZgCBiZvIlFttnt8F0FeiL2W/urcKgUG+E153uAeqmyT
	j4XY5uVwUQgxNmCDWiqv1zHVMdOLtAI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKGd0sMP;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773777604; a=rsa-sha256;
	cv=none;
	b=hRmA9VCuubMP2915cHS+aUOQQSkSw79Jut3e20coDjVckq9sr67IwfJBcku40O2sSkZsT/
	NRGl6fNMK5ZVxgJCpuDAoCzLeRVTtD4yXmG6SKZ62ypdZfUXOiSYQQ0ZN9Br3MVk20tAKb
	1I7GimbA+97NtiYIRHPvojMOBD7tJnU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8DE640D5B;
	Tue, 17 Mar 2026 20:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBFAC4CEF7;
	Tue, 17 Mar 2026 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773777602;
	bh=aMcAv71YOkkFD+ju6rmRuDp0ZfzNN0oX5ZYRoLlaqM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MKGd0sMPoOpRVFAvsPtlMPnbCySVNbT0yywJFqBvpiy0zWYqxgnuY+ZsiMZUGejJy
	 at8VEBsz4BvVz59tpwJzURVLDNBxEux9bzvwu034bpHA68XAWcVDIfU19lOboFHxXs
	 11Zhcykek8uAPKp/TVQUWRMO+eysqaOD1ioKfdb6Qo4ut4eF4J8ac0N0jctfHvmNKy
	 KGj0TMwBINqpF+dExGqEdAXsNbXMJtK5K1lwSlg0I0QaxlAaWdEob3Pl4N+cFa+9pY
	 sFgLrQUApIcg1iu5bMgUTS1W68KTWAJL/6v/YHinLLaG4DvTRJD/fi6lmM9hXS4I3x
	 P7nShZRDiUeJA==
Date: Tue, 17 Mar 2026 20:00:00 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 12/14] mm/sparse: move sparse_init_one_section() to
 internal.h
Message-ID: <f063704a-ffb4-4273-aa6a-ded3a565a891@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-13-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-13-david@kernel.org>
X-Stat-Signature: 5m38iszhqx5wfqpjwkp3aqdsximzr8u5
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: EA11D20002
X-HE-Tag: 1773777603-618201
X-HE-Meta: U2FsdGVkX19INE2yGC1ovIrd1VF54YFJ56rZmS4csEhTGU2OVkU0BmX7LM0nm8cKYTOh4kYCR2ShPYAbaBnuf+rXi3x40sEqAAvMhAeTRxr4daFECl8QEv+W9Ck56hj5sJ5qbJYyRpEGQGiKMPCuUFopZVtcV0gwnaD0Y5qnM1yH4fmGDr+xu5LrMEPH67sy1Ic0ov0wXblwaQfK0BFuqMm8708rnixGNU/JCDOSeHnsz/3UUGCd02IK0W0nt8KJd299+rdty48CkA81zdXQ+9sWjd4dQIPi9yepMC5IL58a1JhDteZ2awKn2ygg/bHsUzjdfcBnfTlj7lDb2c/0dIl2OoPViRUxQi/T1yenh49ZFMvMGBH/SFlJdabk6kMehqn5IeNgDtOrbk8PRLbwA7otpBna30J9F3OeQQGs9TAFkwSw77IQVx7vp1mIX+jasbknUVskRHbwb6ebYGUKRvnJ42ENvtw9c7rJOZAv41pQGZDsSRRwLHNKzMNGRpdIOO0/JVZ2PQNCdnlqD/kD7XQWj00d5+xzIhL6ogIxjTFIa4Buvp0xcVJgxVGM9QuKJsxE5GokyvpC5D+hikCl7WUrEETKNDYo6+z3ESKPGdc5k16Nyzi2RTNfF18/H0YK1zOHpG2Oy0psy19NCNAUvzbwWGkn0LlGQ8IPvlcxoUsdWIljFJwnPyLZQpu/jgnNlkdRPkq0emd/9H9jV6yxtGiX8FPM7iLuvZatJo0t4+01QRZeN9YamDVEY91i8sQ8G+itSZ2tu6dfi1NEWxywy2H6v7NSnMbHaTYLJcmCHwaqkq6ALiVa7uvbD6lGjHow0Rny9kQxhGXxmxdR5APt0gJg8C9w9mZA9Bd9CUIe5x0iXKA2OIlvXx4pi5VFJZiCHfOvUlex6DYl815nTI4b9BzmPtwsd6M3GUFtr8fMtHl+e388iHNU5eOVSYSJyTR8Ncp94GK4jGX/qp+Iwii
 tR1dT/Jn
 6dxma4HjjqBvxwSL0xbe656z4MM2dteEGUWecPvNqf1Cc3wZqPeidYZ/KfF0Rt1a59THrepLHVJhMoNDBvd+jOZ9/0JfqEXuM5apCvXZxDbjvn1/8aAoJiHvxioRizyc08BQH46nZtC/u6gshdFe1DU29uYmcxERmV0g3qq/zw3L8ZCt1Usnv1NObzKPliJJs5oBPmwsGBVMiMoAnHLPHZZxfQVwg5ismy7W+uEAxnZDT1DqExN3VgkCOgQVVhzjpb85jK8vILRe/sde0ciXCV2O8AFmtar4vkA6D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:50PM +0100, David Hildenbrand (Arm) wrote:
> While at it, convert the BUG_ON to a WARN_ON, avoid long lines, and merge
> sparse_encode_mem_map() into sparse_init_one_section().
>
> Clarify the comment a bit, pointing at page_to_pfn().
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Don't need a long line to merge my:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Here!

> ---
>  include/linux/mmzone.h |  2 +-
>  mm/internal.h          | 22 ++++++++++++++++++++++
>  mm/sparse.c            | 24 ------------------------
>  3 files changed, 23 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index b694c69dee04..dcbbf36ed88c 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2008,7 +2008,7 @@ struct mem_section {
>  	/*
>  	 * This is, logically, a pointer to an array of struct
>  	 * pages.  However, it is stored with some other magic.
> -	 * (see sparse.c::sparse_init_one_section())

What::the::hell::was::this::before, we're not C++ developers!!

> +	 * (see sparse_init_one_section())
>  	 *
>  	 * Additionally during early boot we encode node id of
>  	 * the location of the section here to guide allocation.
> diff --git a/mm/internal.h b/mm/internal.h
> index 5f5c45d80aca..bcf4df97b185 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -965,6 +965,28 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
>   */
>  #ifdef CONFIG_SPARSEMEM
>  void sparse_init(void);
> +
> +static inline void sparse_init_one_section(struct mem_section *ms,
> +		unsigned long pnum, struct page *mem_map,
> +		struct mem_section_usage *usage, unsigned long flags)
> +{
> +	unsigned long coded_mem_map;
> +
> +	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
> +
> +	/*
> +	 * We encode the start PFN of the section into the mem_map such that
> +	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
> +	 * from the page pointer to obtain the PFN.
> +	 */
> +	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
> +	VM_WARN_ON(coded_mem_map & ~SECTION_MAP_MASK);

Maybe VM_WARN_ON_ONCE()?

> +
> +	ms->section_mem_map &= ~SECTION_MAP_MASK;
> +	ms->section_mem_map |= coded_mem_map;
> +	ms->section_mem_map |= SECTION_HAS_MEM_MAP | flags;

I mean this is pretty nitty but prefer 'flags | SECTION_HAS_MEM_MAP' to
show you appended to the flags :P

> +	ms->usage = usage;
> +}
>  #else
>  static inline void sparse_init(void) {}
>  #endif /* CONFIG_SPARSEMEM */
> diff --git a/mm/sparse.c b/mm/sparse.c
> index b5a2de43ac40..6f5f340301a3 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -256,30 +256,6 @@ static void __init memblocks_present(void)
>  		memory_present(nid, start, end);
>  }
>
> -/*
> - * Subtle, we encode the real pfn into the mem_map such that
> - * the identity pfn - section_mem_map will return the actual
> - * physical page frame number.
> - */
> -static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long pnum)
> -{
> -	unsigned long coded_mem_map =
> -		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
> -	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
> -	BUG_ON(coded_mem_map & ~SECTION_MAP_MASK);
> -	return coded_mem_map;
> -}
> -
> -static void __meminit sparse_init_one_section(struct mem_section *ms,
> -		unsigned long pnum, struct page *mem_map,
> -		struct mem_section_usage *usage, unsigned long flags)
> -{
> -	ms->section_mem_map &= ~SECTION_MAP_MASK;
> -	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum)
> -		| SECTION_HAS_MEM_MAP | flags;
> -	ms->usage = usage;
> -}
> -
>  static unsigned long usemap_size(void)
>  {
>  	return BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS) * sizeof(unsigned long);
> --
> 2.43.0
>

