Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E919FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 06:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872116B0093; Tue, 28 Apr 2026 02:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823036B0095; Tue, 28 Apr 2026 02:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7113C6B0096; Tue, 28 Apr 2026 02:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61AF76B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:57:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E43DD1B9412
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:57:00 +0000 (UTC)
X-FDA: 84707057400.24.AD8C5EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3B5D7C000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:56:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhDcpnNh;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777359419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pN8lwMEMUKE6fLRDbfBi5SwwXfSZd6/phLXUVKiAbUY=;
	b=xrBT2mVqjKgaew99lGvbH5TUm0dB2csP9otnKzXorr4sEcY8VMxPA3dGgVfW4WwNMq8ixs
	vndp747DTVSiB+ajPxKAn4JdYTrmQJWGhuTDIR6aHO5euhRFrgoR6udBcKGoooijng8qao
	M/PWeCRtK3UY+FWlPcmavN/J/u2yjsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777359419; a=rsa-sha256;
	cv=none;
	b=EAmPDPX5di1EDkOzxIHgXFcwKQU002cgT6CbWVXMJGixqSJYeIsSm3k2OtbJXCHy58DnL7
	vimfc1q4G5QJizjc0WdowxTKJiKoUPtzykNJRe1TNSybiK4aBWGHTLjKeLJqS9v0E7aIi9
	oNM8wNPh+en0fvn1VrgQC8/EtpfJLBU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhDcpnNh;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A9B2437AA;
	Tue, 28 Apr 2026 06:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9236AC2BCB6;
	Tue, 28 Apr 2026 06:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777359418;
	bh=1V4TENqnFf/Ppcn/URrmHTYv7JS1tp4lOcKYXeX/qQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rhDcpnNhXg3VFM3rIQ8P9HEfk7yNT1kNtmGQA//PASZJYF5qFVLU3rJQKIjHPMvMe
	 HNf+ZqUWVIec+QOX6efzQXIJgyVTzJ3SajalcZfX9oSShcsx1S6liBquLNTUSEkPWh
	 4Cyc/D7lLdtCoLQMQXAl64utOCjpMSIyeJ8zLhZtFS5/mgoy0dRpWXclxIvDKnysUq
	 SpCE7vcf08EM3C8UiLJLQfn69JGz6zNVXPFlXdd3w/0cNuTpygcfyKvh5PaIqr59MO
	 bLVRmTTn9+akih5Vt7HEV1f7qS8w3zDaa2o4t4+vuoIOLVGu4TF+GObYA5jWj8WQ8M
	 JqMpETW6OQY+A==
Date: Tue, 28 Apr 2026 08:56:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/49] mm: panic on memory allocation failure in
 sparse_init_nid()
Message-ID: <afBaMEBoR_35Fblc@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-10-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-10-songmuchun@bytedance.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B5D7C000E
X-Rspam-User: 
X-Stat-Signature: og8z3cc4ccujt7txur4wfi6pyt7k4bkh
X-HE-Tag: 1777359419-898154
X-HE-Meta: U2FsdGVkX19Lfp11OV6HPk0Gw5NOxpn2bSiIO+Mp9sJad1zwW7uOKUIZd2AYeK+TiY+kKQXh2kS42JeHwtO0q988rS1rA5+FZB+uD05ZCP8/MOZIrFkUCY0tgdes1ieYOHtzCDPGYsQJXmqQ0n5VCKVzhUppfUH9Em0m+wVaUvaJ6rF3A2L9i2kgPfGU3Wufo3ObOYTvZzLzCPjgHFV6njim8G/2htcHFU6bxlGNGM5JsPRGWzIrHqNt7+jnBKWdGRzZ3UVAeHlvaItKxTfRrPRbzMIMmNXc3Z3UxodknD0BYjB+o+ytGmxrcEOhBnm72DbEYk6kI0E9VQK0LUftglbPWabu6koICJdoAb62/FEF30VV9D7lzCiQ0Z2OaW654jJmpK3mS6zbW0jthB2HXwpUq69YYyTQPecf/Wv/ijGCJ2LIAAIefHv9WZwbS42rp9oZnJooGFkGFKVi2H0ZD3MOvBkcZFDCzXvqOJWjNw9EcfZ9iXmUoZ7BWGezbQhmRzZdMvdemDuGzmvED/YF+xMaDVC7qvYnyneOaRc/mCZlwzi1Ra8zT2ZJ7Un36U5lUfgrwceaQXG9iEqL/UWt/kS+SKlxoYxhROtHW4Cqg2LK125uzvp/tmE2vqP5j5tXBGaLbKbj4DcUvBhqqy9Ntd4esgsYphOvpQPDV+B5yHEXneV5OVzGqOJ0/QeWRUwIX1Jaat4i9wflEvOu5SPhIM/6S7eBCyxdZLy5a8xaXVoqQoCCVX4KxONY7eEBq6IgyGsNJsqMeas4kzhbjzWDr6BzkOglI325k6AUvz0xQuV68V7bDEHyVXtPXNKKcSDtGAIylzi8gndcG9dv7FYxDQSQwmvvqmCGel2yXaqLcbsZtBRHaTu5yZ2S0M6yCQ6qF1IzsCSOTbxRz0nuFZP1QYIEMrL+BDw646l7EnS6ybpjU6h5Nh4YZGKC4fvNymQtky8i11Qq8YKVQcXAuEY
 860GOmzA
 /asMVBjEWnfE/8uJPonM/hIsjDvsUlkGIE35cBF4kgpjpljQUlibBvPlX1KvtHS34ghHUQr3TkVRA2OUSTcdCjO/hqVlrV+V85K1+HjUgVhuyqaSaBl1R95rSrbFZUv1oCZdhm1M7dnJPgoQN1L9DrCL87hccSyPHHxiv4THZSSgK8ZGZORHxwoulFfBgBRJEwOGNmfO8dcUcwDFJixE6o2Y1MrBUB7SX8xehWBDnBhcfzSLZyJ+fpuBsVA7sE6mSpoBLkyw7wCevMIbw8B8alfl90eq5iVuPzG17E4wiqxZPreRhtLJaSvRV8LhIVO14u6yuPmZ056gNFBSG04rv78LiNetGOuQDPBF6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:52:00PM +0800, Muchun Song wrote:
> When vmemmap pages allocation or usemap allocation fails, sparse_init_nid()
> currently only marks the corresponding section as non-present. However,
> subsequent code like memmap_init() iterating over PFNs does not check for
> non-present sections, leading to invalid memory access (additional,
> subsection_map_init() accessing the unallocated usemap as well).
> 
> It is complex to audit and fix all boot-time PFN iterators to handle these
> partially initialized sections correctly. Since vmemmap and usemap allocation
> failures are extremely rare during early boot, the more appropriate approach
> is to expose the problem as early as possible.
> 
> Therefore, use BUG_ON() to panic immediately if allocation fails, instead of
> attempting a partial recovery that leads to obscure crashes later.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/sparse.c | 37 ++++++++-----------------------------
>  1 file changed, 8 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index effdac6b0ab1..5c12b979a618 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -354,19 +354,15 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>  				   unsigned long map_count)
>  {
>  	unsigned long pnum;
> -	struct page *map;
> -	struct mem_section *ms;
> -
> -	if (sparse_usage_init(nid, map_count)) {
> -		pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
> -		goto failed;
> -	}
>  
> +	if (sparse_usage_init(nid, map_count))
> +		panic("The node[%d] usemap allocation failed\n", nid);

Please consider using memblock_alloc_or_panic() in sparse_usage_init(), it
would simplify the code even more.

>  	sparse_buffer_init(map_count * section_map_size(), nid);
>  
>  	sparse_vmemmap_init_nid_early(nid);
>  
>  	for_each_present_section_nr(pnum_begin, pnum) {
> +		struct mem_section *ms;
>  		unsigned long pfn = section_nr_to_pfn(pnum);
>  
>  		if (pnum >= pnum_end)
> @@ -374,16 +370,12 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>  
>  		ms = __nr_to_section(pnum);
>  		if (!preinited_vmemmap_section(ms)) {
> +			struct page *map;
> +
>  			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
> -					nid, NULL, NULL);
> -			if (!map) {
> -				pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
> -				       __func__, nid);
> -				pnum_begin = pnum;
> -				sparse_usage_fini();
> -				sparse_buffer_fini();
> -				goto failed;
> -			}
> +							nid, NULL, NULL);
> +			if (!map)
> +				panic("Populate section (%ld) on node[%d] failed\n", pnum, nid);
>  			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
>  							   PAGE_SIZE));
>  			sparse_init_early_section(nid, map, pnum, 0);
> @@ -391,19 +383,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>  	}
>  	sparse_usage_fini();
>  	sparse_buffer_fini();
> -	return;
> -failed:
> -	/*
> -	 * We failed to allocate, mark all the following pnums as not present,
> -	 * except the ones already initialized earlier.
> -	 */
> -	for_each_present_section_nr(pnum_begin, pnum) {
> -		if (pnum >= pnum_end)
> -			break;
> -		ms = __nr_to_section(pnum);
> -		if (!preinited_vmemmap_section(ms))
> -			ms->section_mem_map = 0;
> -	}
>  }
>  
>  /*
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

