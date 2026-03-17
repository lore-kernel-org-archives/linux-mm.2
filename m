Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32135FEDA1B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7674A6B0088; Tue, 17 Mar 2026 15:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717B06B008A; Tue, 17 Mar 2026 15:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606896B008C; Tue, 17 Mar 2026 15:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4EF6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:51:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 186AAB8947
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:51:39 +0000 (UTC)
X-FDA: 84556599918.22.E52350D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5C6251A0011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:51:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s1dQCYTe;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773777097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QS/mFA1khawZSH4y54LCF7F+h4yELEnh1Rx67TR0DmY=;
	b=PASAj0r6biunzx/OBMOSOAfu+qtn3stlV9nZzoFC3eIIpPKU425FI3bYplJwtRSkzUKHmY
	bqvSoh+mTx6iBVdF04LgbhKdvcN7x7RMK+xGxdgM9OE5lgFZ7o65eloG6pOk2XKWgSERzl
	ES5EHMAgb7lGyPyMfaAu8ZJXDOgJrtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773777097; a=rsa-sha256;
	cv=none;
	b=vhHqoj1LYdpZhJIer1HDKucWuvIJJrRfXrTteomLmPEdqGb94wKsvC5di9Kkv8k8PJq8St
	KqA8H66ghKtWv6m6IhtOIW6uMVcO/HBztQ2GtWqxkJ1VzQLsm+1Q89QY8waW9H/GY5Sc8+
	4wRzL6TeoAThwTT4CjuAa00KH6ly+3A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s1dQCYTe;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6053C42A14;
	Tue, 17 Mar 2026 19:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6424C4CEF7;
	Tue, 17 Mar 2026 19:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773777096;
	bh=iu2cOBnlv8s0sPRqFeh8Lvb5iEQfijsU+S3paiRMUPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s1dQCYTegDy2569WFfrMTmWIMTBZA/60RJwwnXYXwzqTP00HyOjBN3LLeq7rCa7Wg
	 q1sOkQuf/5w9FWqLuj0sgz1mGK+DT8GaQbzC+slmDgJPnucdTQH2Q2d5dX5ZQuV2KL
	 7Dxeq/EqYJ3B16Ko9V6xIaKpCODeLAOKWKtNx7aD6BcoGksdepPy+2y37VV+HKB3HI
	 Qze7nClTtHearOiCGQqKElBC+AFYEaE75cUkxIf6S2fSkiYxBF5VAlQZN5W9U1b6E5
	 E10NA/5deA2pIybcmP7TclZbYnkuatsA9g/CheKbXyLhCIOAPw2QGBzMy9av5PWYRP
	 VVjRnH7Mp3vvw==
Date: Tue, 17 Mar 2026 19:51:34 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 10/14] mm: prepare to move subsection_map_init() to
 mm/sparse-vmemmap.c
Message-ID: <cb710be1-5fec-409a-a017-c794ecad0382@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-11-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-11-david@kernel.org>
X-Stat-Signature: gemu3womm8d9aonfi3id67brxrfc8ttb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C6251A0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1773777097-714333
X-HE-Meta: U2FsdGVkX1/bxJsASaHxyFaGzGl8LgSuyake0h8xF6FApuPjdtCh9aBsqcO7+S0PS2AHz1Q+4+6uF/21K2oiMArCdHAVg+ceRMh9s4HsbHc96xr+amgnmlk+ACaPaQ7KbIHY5HI5dAWvQa8TNmvAoLGWoQgw3H2oV8JbR9cpD8TfFDziZTmy2D1cJCj3btdOSqZfZJ3B97ahW+aOdlt2fMkBCSB3PCk3FjsNfTjbrfOA1299hG4Y5WFq/g87+Ah2DIj7zvF/FnfOPngSDNfqCMmuyAESJT6nc4lc9GyI+a5+4zOcSKbUpDuahmH49qNx8O7yOzG2Cx9MOtURUbrXp8LsmonIiYgB5Qik1yE1QQmGT+cBs8rPXhbG7Sj+7AMD+gCd1Dxgn7ZEOaWKd8RiM+POHSBoJd6br4rZZDJTqPGsXQYxNMCTDUxQzXhACrzL8qCmfTEbzssnMYvSg8Zr1hJbCYUCL+bLkai1+CHtus10WfyNmotge8ykgVByJsiim+xzMn7tjHnZGui+mYeTRMG0mpcxhz70/EpBW99HijwTCwPMAmFL4OJ+4S6gFjoVYEGglB2/DtF5rxdLYMJMQEnfFVksUh3zIeUOk/MhUg60FSradCbYx9F+/WRfXpoP9TqdODnLe4rke8XzFz84Ttgw3sEc7whZkubOIjveXAUPDXe4Q7Dun5yMclUwIKhQ+/dLzhO1kSLUPAvjrOp3qdYZ+kgE3brHHrdey5c8uXB+AXD9wJCzaEuHTTCWQ/NLlyq2iTpJD1Rove0PjPXK3XBy4aY9MpRPvuRfb740e4mUiRllX7gWXyHkxc6vZsb/MAF+AmXGNgpPg/7FCEqZqrMeMn3IjFhKtkvP9+r+oMOrm0Vnz5o0omLDmd3wfcur3CKD1Ijv3G5qwQQrXW7Eqnsm9TLnL9ZOJ/jD9CJnO9J03VSnfkIkVCftHZjejxK7ndCHCrVzOgxWZlq92j2
 P8SlqtOz
 CVZMLnAG3HQqtwMlwSbALNrV4mEvHegUGW3a5vNn47QI4akEDxhaF8I/idMZ8fyFiPoIKAcHo72qQjUvpWalkUiQP/smrAk5drAb7yp+lcQb5B6yVcYZyQvygNOcEoumG9X824eeJumVTkzbbDuDP284Hh388VvtPTTqu0ozlZdqeQwYHwweDJzB0WHUQ0N/8HRDzUd9cyX90HDcb9dI/yLi5WV2YNixeCvsNJ6yWH4vgIHzWOLLCU0vUbgF/BONzFs+BIPZCeij++STsFTVkfjCoQHgv3+kv6BinaLKDAeVkjphCTVaqePBgRuyKFnIpJIER
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:48PM +0100, David Hildenbrand (Arm) wrote:
> We want to move subsection_map_init() to mm/sparse-vmemmap.c.
>
> To prepare for getting rid of subsection_map_init() in mm/sparse.c
> completely, use a static inline function for !CONFIG_SPARSEMEM_VMEMMAP.
>
> While at it, move the declaration to internal.h and rename it to
> "sparse_init_subsection_map()".

Why not init_sparse_subsection_map()??
Or sparse_init_map_subsection()????
Or <all other permutations>

Joking that's fine ;)

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

You've initialised the sparse subsection of my heart, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/mmzone.h |  3 ---
>  mm/internal.h          | 12 ++++++++++++
>  mm/mm_init.c           |  2 +-
>  mm/sparse.c            |  6 +-----
>  4 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7bd0134c241c..b694c69dee04 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2002,8 +2002,6 @@ struct mem_section_usage {
>  	unsigned long pageblock_flags[0];
>  };
>
> -void subsection_map_init(unsigned long pfn, unsigned long nr_pages);
> -
>  struct page;
>  struct page_ext;
>  struct mem_section {
> @@ -2396,7 +2394,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
>  #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
>  #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
>  #define pfn_in_present_section pfn_valid
> -#define subsection_map_init(_pfn, _nr_pages) do {} while (0)
>  #endif /* CONFIG_SPARSEMEM */
>
>  /*
> diff --git a/mm/internal.h b/mm/internal.h
> index f98f4746ac41..5f5c45d80aca 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -960,12 +960,24 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
>  		unsigned long, enum meminit_context, struct vmem_altmap *, int,
>  		bool);
>
> +/*
> + * mm/sparse.c
> + */
>  #ifdef CONFIG_SPARSEMEM
>  void sparse_init(void);
>  #else
>  static inline void sparse_init(void) {}
>  #endif /* CONFIG_SPARSEMEM */
>
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
> +#else
> +static inline void sparse_init_subsection_map(unsigned long pfn,
> +		unsigned long nr_pages)
> +{
> +}
> +#endif /* CONFIG_SPARSEMEM_VMEMMAP */
> +
>  #if defined CONFIG_COMPACTION || defined CONFIG_CMA
>
>  /*
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 969048f9b320..3c5f18537cd1 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1898,7 +1898,7 @@ static void __init free_area_init(void)
>  		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
>  			(u64)start_pfn << PAGE_SHIFT,
>  			((u64)end_pfn << PAGE_SHIFT) - 1);
> -		subsection_map_init(start_pfn, end_pfn - start_pfn);
> +		sparse_init_subsection_map(start_pfn, end_pfn - start_pfn);
>  	}
>
>  	/* Initialise every node */
> diff --git a/mm/sparse.c b/mm/sparse.c
> index b57c81e99340..7b0bfea73a9b 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -185,7 +185,7 @@ static void subsection_mask_set(unsigned long *map, unsigned long pfn,
>  	bitmap_set(map, idx, end - idx + 1);
>  }
>
> -void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
> +void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
>  {
>  	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
>  	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
> @@ -207,10 +207,6 @@ void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
>  		nr_pages -= pfns;
>  	}
>  }
> -#else
> -void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
> -{
> -}
>  #endif
>
>  /* Record a memory area against a node. */
> --
> 2.43.0
>

