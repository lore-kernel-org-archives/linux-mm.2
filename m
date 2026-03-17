Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD168FEDA0D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D26C6B0088; Tue, 17 Mar 2026 15:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283266B008A; Tue, 17 Mar 2026 15:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198EA6B008C; Tue, 17 Mar 2026 15:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06D276B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:25:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4735140358
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:25:56 +0000 (UTC)
X-FDA: 84556535112.08.4829197
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id F2BAF8000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:25:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i8zSkYT0;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773775555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PP9Eh6JtnYH2KlVvjFq4ShYXLfp8ASdgz/Cl5NAEHmk=;
	b=IxHEdehLkzd7Og7A0PmL7XyJy/wgZ/Kp7MEwXcT33BzGY/YwXWIqbd03PC2Ig87voxp8OQ
	OPsh71epn2WycEzYlBoq1Geprz9pJ/reX9AygV0fMdJu5+QNtlrGXlGUYyfPI3aiY/95fR
	wfQdNThbBBBXyfNG5cYmuPuEbe113DI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i8zSkYT0;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773775555; a=rsa-sha256;
	cv=none;
	b=ihArOzCOqq2l3YUhNisFIWsaO03NfoJBz7OX8U6h1F8vs5Fu/iDiWBYlqTGLrtwabPuBp+
	7gg4hOTWLZTZLsWHWrveMID0OqiwA0ilOMfge26CX9gLrv3qVhJ7rHstuzv0MiRg3hRwB9
	i7TN4E/mTrPHcZfEZ3IbyNy9B13m8uk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63A636132F;
	Tue, 17 Mar 2026 19:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAF7C4CEF7;
	Tue, 17 Mar 2026 19:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773775554;
	bh=4nu8KnljxRbFha6Sm+hHFFmTLLWdkRQvURvX7OtTurU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i8zSkYT04onwGSDnKuMXibm9w3O9f3hWleOil/LUrBsyi/oH3sNoAtISP7jy/gmjB
	 Vd6WMM4NuO4qgnRTU0j6jFuBedmmyjYTV6ez0WbHQojpkql9la1JIe4iEGdZ8dNi3L
	 4H+J6yUYN2VSQ0cTjGLGAPaFsUMbYnmgIYB2wxSaT9+9ikDDJ9DgpHNAXjh5xM87LW
	 FTQkt+KzEvJSlOQBRR6zwuzj3SUuPsLXOqzhU32oIJ+V3ti+j6Er9ZEx6pgretEFMv
	 RKqU2yS8fgfwpTCwWtqvEr8G+YjC0XYI9CWz33MMVGjC8w1+wEJDqMT/Y5yWCa9KBX
	 0q1oxBZwLAf/g==
Date: Tue, 17 Mar 2026 19:25:52 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 08/14] mm/sparse: remove sparse_decode_mem_map()
Message-ID: <8af7c994-14ac-4c9f-8c27-b35969440d80@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-9-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-9-david@kernel.org>
X-Rspamd-Queue-Id: F2BAF8000B
X-Stat-Signature: nirrmgc3uqktyr71pm4z97m6fgxc3kjs
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773775554-608502
X-HE-Meta: U2FsdGVkX1/8LNFc3Kypvz/V+qMYgMzGr8PRXbKFeKU+f20TZR10ka0EnKEsmeijWYay+G4SSpSz7NWo7w6O3yAnIyNQGuvxSwSl/O7QLMU4LjnKoBrjonsWRTTGal9b7J00Qt10d/xo7Enpnmx2+lYlNVFKXryUfBnrAJdIM0cytWgizOrxllkvoYOM25R6q4AU+AXVwrnGNfe6twWjw134W7OWk3g5VNltN2N6Ght9ClaqsRRcsn4z37LIV3fq2CHbGKjZPK+EgSddhKegH5mVMC89hkhYVwYYdZ+FJclmto3Pp0L1TU5Zx3EQCnuqtUvUx0haiYqo3jmKWsDtgg9L7B9KrUO1TRSUxbppQD54UIH0cYDa83ZHY6d7kR/QgvzqcjwnG8FArGCILaGCadXfNG/PvpwCnlZQ0r4BdCOkFbdzwNxvwLlFZyvQ+6fqeO9sQZ5oZCJHL4F6dnUtRyCmriTDKdoRaJx/6MudZPTV/NhtEPlR1cbZqoIG212D8l8W0b2ijr9tqE75hepfpGbtVk6+7xqu/nygHj34hjYWiXC/K082yhRVXBGrZrhTLR/fiDbv8CTrHa2XB5K1agpWhjnqARhKp87Nk5U+7IoB6jTFqVs+ABNYiwAdIqaXmgstX9KdhV/AEhqqDYXSWJk0aPrWd8IPKoYNirKLk9A0tzjt5u4FEAC7ek8MV4Sa7nWuY4srtm+0yd+knMo42+3WzBp/0oxlUl/65AOsldiCFsgeVEQGTQpM+qzcS8WzpxtmVXGO/6wQXr8mFIUKDdQBZguofICEt3IpCnjkMIoocqv8BTg1jbivM0DCnfW/4twSyiKdYOelULmKVxchyMh7VhqC0arTs2tJAnxcErirE5C/QwiOAGuvdqYy1mkd6xD/zqB94wQobWTesXOZXYDcqjNKeNEiHA29TecsG2aU1/l1b79i/b/1o79061Qs/yUCUmhUXEdkbq9ergp
 4lAw6BaK
 ak2lZZ8/bLCotpW7ZHjbkanP+mnGke3VAmfoC8CMn24TTkSi80uHfkoJdLyjQcyLWbrvjy/3WaNmQU+E/Em1H/qBVoBy3yBSRzNU/fIUxb9ixn0mVM57/UwG1G5CRknYcqb7jIswiYTMl6p8wsOxoanSpitCggkZ1THlozaLXplCS1VUQejcsXeBwG/sZEHYCAW6pknR9VU0A9tXdCHkTv/DWiKvryNq8WNtapHbTL4MOJxm20HhupYhHtXiXW3U88p65bcrFOOKSTeGsQuejH/WrQm/R+x13vheO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:46PM +0100, David Hildenbrand (Arm) wrote:
> section_deactivate() applies to CONFIG_SPARSEMEM_VMEMMAP only. So we can
> just use pfn_to_page() (after making sure we have the start PFN of the
> section), and remove sparse_decode_mem_map().
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

it's more like pfn_to_patch(), so that's a:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

From me!

> ---
>  include/linux/memory_hotplug.h |  2 --
>  mm/sparse.c                    | 16 +---------------
>  2 files changed, 1 insertion(+), 17 deletions(-)
>
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index e77ef3d7ff73..815e908c4135 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -308,8 +308,6 @@ extern int sparse_add_section(int nid, unsigned long pfn,
>  		struct dev_pagemap *pgmap);
>  extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
>  				  struct vmem_altmap *altmap);
> -extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
> -					  unsigned long pnum);
>  extern struct zone *zone_for_pfn_range(enum mmop online_type,
>  		int nid, struct memory_group *group, unsigned long start_pfn,
>  		unsigned long nr_pages);
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 636a4a0f1199..2a1f662245bc 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -274,18 +274,6 @@ static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long p
>  	return coded_mem_map;
>  }
>
> -#ifdef CONFIG_MEMORY_HOTPLUG
> -/*
> - * Decode mem_map from the coded memmap
> - */
> -struct page *sparse_decode_mem_map(unsigned long coded_mem_map, unsigned long pnum)
> -{
> -	/* mask off the extra low bits of information */
> -	coded_mem_map &= SECTION_MAP_MASK;
> -	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
> -}
> -#endif /* CONFIG_MEMORY_HOTPLUG */
> -
>  static void __meminit sparse_init_one_section(struct mem_section *ms,
>  		unsigned long pnum, struct page *mem_map,
>  		struct mem_section_usage *usage, unsigned long flags)
> @@ -758,8 +746,6 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>
>  	empty = is_subsection_map_empty(ms);
>  	if (empty) {
> -		unsigned long section_nr = pfn_to_section_nr(pfn);
> -
>  		/*
>  		 * Mark the section invalid so that valid_section()
>  		 * return false. This prevents code from dereferencing
> @@ -778,7 +764,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>  			kfree_rcu(ms->usage, rcu);
>  			WRITE_ONCE(ms->usage, NULL);
>  		}
> -		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
> +		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
>  	}
>
>  	/*
> --
> 2.43.0
>

Cheers, Lorenzo

