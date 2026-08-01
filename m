Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A87DC54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 09:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284986B007B; Sat,  1 Aug 2026 05:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DB46B0088; Sat,  1 Aug 2026 05:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5E26B008A; Sat,  1 Aug 2026 05:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB57B6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 05:36:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6CCF6140171
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 09:36:29 +0000 (UTC)
X-FDA: 85052195298.15.D2B00F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C038E4000B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 09:36:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZaAr1pW;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785576987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=709PrRE4T6mqHxV2NldJPDtfXEbe8pwqFIDr7kni5hQ=;
	b=62zLh+8WCLXMChFEegSsszf2ZB2D6tDJ/DTS+dPnGhtwkmGu00nD7Twf0f4DOgW5CgiWbz
	ShBDclJC3nnhX+wZbh9j5HzTfW6UiAf7l/jHSR1QBovXgF1ZSJPvAfo9sqvQMm3dGK+Vix
	AYrF0WAqeqxd8+jfSyY0pCNTVUd0gFE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785576987;
	b=g0sZcvvPlhsD3Dz3PnUMe1pP1YBO1KXy7AMUuB8/gjCVdp1kuOtH8kYb43Fi4lXRD31plW
	0ibauN65VcNi7ZqqgKeoSeMbHb8k0gMcT9zCc1uPVOYHmVbxfLxAYRLINYMgtN0/5WNcBJ
	WPYd/77VFQ4UdZ5IubtaPoAOV7hinmA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZaAr1pW;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED59E454F5;
	Sat,  1 Aug 2026 09:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154941F00AC4;
	Sat,  1 Aug 2026 09:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785576981;
	bh=709PrRE4T6mqHxV2NldJPDtfXEbe8pwqFIDr7kni5hQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mZaAr1pWTIuDLBtCszvPR8u1+iDcJ95gaenhrfArddi5Uu4gBhXOIyw/4zH7JfxXI
	 5l2zs5HbYWmIj6FsSB00mOpWBEvqjRrOmyozQlsFES9VE3iwdUSkINUJKb/0E5iHC9
	 dkT/beAsMUAHwXIYHraJ/X8arV7DA2dxu/t+94Ds5t23AN9ys2S1+g6wc96k3RKRf2
	 3qMIAMLEyZ+6d+hMmPIRtHkaB70dB18NWQBxjcyzRzMo2dcBoxiiGR8zd/xfxGqw22
	 Eb/w8ugVZkU5p18je3Sc34gGWTAqVH6v/nWLiwUvTFeTDFZYN18droYQ6KA/dE8+E6
	 zn6/ma2FuClxw==
Date: Sat, 1 Aug 2026 10:36:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
Message-ID: <am28pV2PEfHsi4p-@lucifer>
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C038E4000B
X-Stat-Signature: 85r3q6r9ctkocxxq9pfg9bdp4id11gfq
X-HE-Tag: 1785576987-765291
X-HE-Meta: U2FsdGVkX18JG+vxAK/X14tJEYSFxfrn8/ms6FxhT3apIDaxuXxcP9OCIWViSr0boJq17O4VmlywrwCjXlo/3N/uPF469dnGXgXDZF7i0yip1aH6V6D4Nxp87j2RCh4UDDzfedt+NQaqjxDHuw1qV0MLkN57LyLcJ7ZilIdWTVvop3RRXMJFMb3yR10ChZSljFLOjddeWg6OZIyKNOKhiXz++xsOEUvI0xvLzLhBT5GB5DITrxwjar/Cc+YJflJ9Ag6dZ20BWZoFIbFC9fLmyP5XCTUBFyF7ft4tTs8ICbzoSoxepWno9TQsuao+hsP//xXVgVNwptDK0crAhjvdBWhYL5bmcQhoetx4oqwps4uClKfob0mELF/1S0WhDt0jq/kB8SBMQfqE54pC+KR734tUEhkPljH893U+umsuTcsmK3YQeQccWlN0ShJD7/kNK42HAk/KB8dPSJcU12EyRnALZ2VNu/VdFzDW2o4Urv0zKY1Usm/nsJr9jVA/3MwlD8KJaavn/oHRRQaLjslU7rG3mT/DhGZgcQOLfMidgsoZ+FF5BfVO1P68Z3Xaw2FzelZWB/IaWO8utjBUeRz3S7pWNCWSN+7+kgpX/ns1kZnqMZ7ReQYVjuPof5fx1ByWX6czZSv5OKxh+lTEcmLxNkQz22oq/z0O/gcNJT7sbq0QSWb4bOOX0mHC5KIa6S2RZbJZG07JTEh86D3sCh45eXjHvr1mJA2CBxTw0LbN4w3B/fZplSzo75a5KRnzYedp9/++UwF8VN+RfBE+XOYm2vTW44sQX2LYGmrm29IzXZ6ub3AoA7IzmhoUHSB6781LsgTvnq9O00myGD0yHA2PUm9XTjOaIBvxU1iw2xatVmtpptvgxlpqyH0xIBQkcNlD5uIanmwmwwFLueoR2RuTiMk2nhM0ozNqpx0nmijIc9Pv5c1UjoDTB5FO4OIO7Wt2k03I/tbXI03ZqZDca/k
 t/taRlA9
 ftheMju0T4EGXjXlr4lcJ4OGmDSDDNs+TGf1aD3/xxBM3UcgSyaCX0/xVkWL9iQ08ZstZPz5ktwJTjXXkLZeH+J0D8zPY9BfnbCkVriBAh5uoVVWraUY6486HD2NCqtph7xXy7beJ7/2dGlJ/G2x8AwfsBahArVIJpKipG5NGwqIQtjyw/Htn4qs+lV/1YJrLPCXMEM60FLxqdnXnA/hZNhQkXkm+8XE33E9ZB5UWI/EwBTIAUf72W9UG1YZhiXDFA3lUWMe3/tOm4+7vV38dSrydxzzZOmUFlF690XoIHnjxIH+8+01ZqyMU5N/AVnNNPAsRejMy7CZslKcNnjwNDGvzkHLQdTbIGf5dCOPtN1satEo4999xWvdy9uwRKdPeHW64xKB3pcDEhFE3cO9n59F8SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:18:00PM -0400, Zi Yan wrote:
> During a pagecache folio split, an xarray node allocation can happen and
> needs to charge at folio's memcg instead of folio split invoker's memcg,
> because for example folio split can happen during reclaim and reclaim's
> active memcg might not be folio's memcg. Switch to folio's memcg at the
> beginning and switch back afterwards.

I assume this is the only allocation? I guess in general it makes sense to have
the folio's memcg be active here regardless.

>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")

Cc: stable?

> Signed-off-by: Zi Yan <ziy@nvidia.com>

Change seems reasonable overall.

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 04e8a6b553435..b9c2d8908e564 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4063,34 +4063,42 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>  	struct folio *end_folio = folio_next(folio);
>  	bool is_anon = folio_test_anon(folio);
> +	struct mem_cgroup *memcg, *old_memcg;
>  	struct address_space *mapping = NULL;
>  	struct anon_vma *anon_vma = NULL;
>  	int old_order = folio_order(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped = 0;
>  	enum ttu_flags ttu_flags = 0;
> -	int ret;
>  	pgoff_t end = 0;
> +	int ret;
>
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>
>  	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
>  		ret = -EINVAL;
> -		goto out;
> +		goto out_no_memcg;
>  	}
>
>  	if (new_order >= old_order) {
>  		ret = -EINVAL;
> -		goto out;
> +		goto out_no_memcg;
>  	}
>
>  	ret = folio_check_splittable(folio, new_order, split_type);
>  	if (ret) {
>  		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
> -		goto out;
> +		goto out_no_memcg;

This function really badly needs splitting up and probably some cleanup.h work :)

>  	}
>
> +	/*
> +	 * switch to folio's memcg as xarray node allocation can happen and
> +	 * needs to charge to it.
> +	 */
> +	memcg = get_mem_cgroup_from_folio(folio);
> +	old_memcg = set_active_memcg(memcg);
> +
>  	if (is_anon) {
>  		/*
>  		 * The caller does not necessarily hold an mmap_lock that would
> @@ -4231,6 +4239,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	if (mapping)
>  		i_mmap_unlock_read(mapping);
>  out:
> +	/* restore to caller's old_memcg */
> +	set_active_memcg(old_memcg);
> +	mem_cgroup_put(memcg);
> +out_no_memcg:
>  	xas_destroy(&xas);
>  	if (is_pmd_order(old_order))
>  		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

