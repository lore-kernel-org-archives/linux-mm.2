Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD64FED9F6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D636B00A2; Tue, 17 Mar 2026 13:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644B66B00A3; Tue, 17 Mar 2026 13:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B0A6B00A4; Tue, 17 Mar 2026 13:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 445AF6B00A2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:54:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FF048B037
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:54:29 +0000 (UTC)
X-FDA: 84556304658.21.09D9B59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1EC58C0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:54:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hbfn/CI/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773770068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbPYf/JDWOkHyWdUZ7z0R2RsxPthhRtNIHtBqeJA2XQ=;
	b=2g6nRMbh6lg6pOrONParagibHbQ7zVysJQ8sCwbxLYA2XMdY5DfsjAq6nUb1YMi7xsXnlS
	lrwEZ9HHMFoEMS/mfpgclDmz42C/hllmuQ0YC93ga3HMKOC145/UEXWS8FaTXRzdkPfctD
	dThm72or3s/t2UpnDDxKiG30tSHQqpk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773770068; a=rsa-sha256;
	cv=none;
	b=vdqLkTdd0rppQsURkLNbDXtULen3s/RsWeensKVx/gviw9KVN8eLbAYZMkqJQq9GOSKDUV
	gqFBcsjVFj7WRv51wXvn3ZzSvSwn32YRRyayrNSW0Ezetn9K3ytTweaP2fULhCHsx/rtjr
	O7C93c1419M0AITOH1/l/Nnt8MSFDz0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hbfn/CI/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1871540D69;
	Tue, 17 Mar 2026 17:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63F8C19424;
	Tue, 17 Mar 2026 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773770067;
	bh=YGGHNltRGX0FS2ePD1Sk35NmzG1l/R/IBlMBvqXxvkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hbfn/CI/zGXlDDVFdgHQOJzpQYu/E43aEwVYQIyT6d3HT0ilz3L36kDhD5yOx2nV6
	 9tg9T9rBrRu2ooljimGeAlr/VRxPn9U2ffLhBJRrRki3YBlELUHRJSdlaYhNgTswfI
	 qPTnvuLKYz8gS7Tgxd+EASQqairTfeIf6kB1uszkJs5Th7frKObV+oyll06xIbPdyX
	 37JkK2aNfQwTC1dhMJXnuHeBvy56fkx1qtwFY5g5WZxIS7tmmzQyPybA703YTH/p0c
	 /GzKzx94feRxtu+0z6dz5jh0ZTFPuqB4+g+808r4/63nS4eYzH3JPZWYporc0+1i2I
	 cM4F06lrW2LOA==
Date: Tue, 17 Mar 2026 17:54:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 05/14] mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP
 leftovers for CONFIG_MEMORY_HOTPLUG
Message-ID: <ac577def-41d0-49e7-9dc3-4074bacbfc42@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-6-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-6-david@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1EC58C0005
X-Stat-Signature: 4c8geiofezg8kb7twixc5pdm4bjbt88n
X-Rspam-User: 
X-HE-Tag: 1773770067-840982
X-HE-Meta: U2FsdGVkX1/iQOKD1F5V9mYMgxAL0kolArj17i1uxxKY7nRWAHrU3xD4C1cS7wOUno2t+GarzjVEd38enG5ntsiTl4Z317ZieLrSLCmJmo6UwslY8nakTnn5PjMWG3fyVZVCi7xlEm+JfoY44nOUvQ7fhkhJRYKJaW0Bkka02TCfr8a/7sUNudHy0XdoBk4NylT5W2Aq1+IKpQsatKtj/ZzWdoGRvdt8At8IJVMfB2aoj1doCxQPkMIeevaaNf4L6Z+wDxGKZ5gFpKXB+ODsB38CLb6p8gsAHhGIdPeToaxvaO/AKBewnjpWwJSD+JVGVaXMBjsnSlV6FyXBZK6i6YLsxRp3JJiB5i67UckkGR/fe6DmKCWKaYxQP3Boj/STrRxTm0kp5MiXQ/ODh/YhiyF9QzKb+e9mErTCVwB19uSAlGhr1wu6d/hfbrK4vt5HnoAdGlIjOG3SXDMZcx4S7cfz8PauyefQK9OAz6M7IanChHcOLn7uz0+AjOwj261MX/Unc6H9VnAZJYPOE85IHb1DXgOJk6OH1pETlcEfm6A772UsJKfjcCcngu34Cw5r5XrRs7ZhBOCLG02W5UdwQolav3vdMIM8ZYKRUJadqEU+jtB6sNQ5j5jsqrWTpgjV5X+WdPd8eNhQIw6sQzaQV5rb6qqtrLIXKZDQNUBqwa60cDWEYeitcFsbmF1pyhw08zNNzPZJhplxwJPSynEjSiS0s01k8myVUiIrHjV7ZbQBKYcCCHMfJn3XrfWnA/7upd//3UAo9TANI0hhY/cpPWr95t6U7b5sm0gwWewGf8JGtycN0h3A+xotXdWg9WtAeWAVSFZR4VirJs54JQcRSgsJGWv6dDZ0/2CvWvqlqCEYCV4/QQUMrb6mGDzaQzGaLCiwqE9uHmGB8AUM20zwmbVSYUQV2wTbScJagmiORAvygMwOkmWi0s9JxrB4zSvIhsTSkVdHWregQbrltE1
 vXibScSV
 tWTbJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:43PM +0100, David Hildenbrand (Arm) wrote:
> CONFIG_MEMORY_HOTPLUG now depends on CONFIG_SPARSEMEM_SPARSEMEM. So
> let's remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers.

(As said on 6/14 that I inexplicably reviewed before this one) - might be worth
explicitly saying 'dead code' here to underline it.

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Sparsemem? More like sparsecode now! Right? RIGHT? Anyway,

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/sparse.c | 61 -----------------------------------------------------
>  1 file changed, 61 deletions(-)
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 93252112860e..636a4a0f1199 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -657,7 +657,6 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  	}
>  }
>
> -#ifdef CONFIG_SPARSEMEM_VMEMMAP
>  static struct page * __meminit populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap)
> @@ -729,66 +728,6 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
>
>  	return rc;
>  }
> -#else
> -static struct page * __meminit populate_section_memmap(unsigned long pfn,
> -		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> -		struct dev_pagemap *pgmap)
> -{
> -	return kvmalloc_node(array_size(sizeof(struct page),
> -					PAGES_PER_SECTION), GFP_KERNEL, nid);
> -}
> -
> -static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
> -		struct vmem_altmap *altmap)
> -{
> -	kvfree(pfn_to_page(pfn));
> -}
> -
> -static void free_map_bootmem(struct page *memmap)
> -{
> -	unsigned long maps_section_nr, removing_section_nr, i;
> -	unsigned long type, nr_pages;
> -	struct page *page = virt_to_page(memmap);
> -
> -	nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
> -		>> PAGE_SHIFT;
> -
> -	for (i = 0; i < nr_pages; i++, page++) {
> -		type = bootmem_type(page);
> -
> -		BUG_ON(type == NODE_INFO);
> -
> -		maps_section_nr = pfn_to_section_nr(page_to_pfn(page));
> -		removing_section_nr = bootmem_info(page);
> -
> -		/*
> -		 * When this function is called, the removing section is
> -		 * logical offlined state. This means all pages are isolated
> -		 * from page allocator. If removing section's memmap is placed
> -		 * on the same section, it must not be freed.
> -		 * If it is freed, page allocator may allocate it which will
> -		 * be removed physically soon.
> -		 */
> -		if (maps_section_nr != removing_section_nr)
> -			put_page_bootmem(page);
> -	}
> -}
> -
> -static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
> -{
> -	return 0;
> -}
> -
> -static bool is_subsection_map_empty(struct mem_section *ms)
> -{
> -	return true;
> -}
> -
> -static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
> -{
> -	return 0;
> -}
> -#endif /* CONFIG_SPARSEMEM_VMEMMAP */

So this was all dead code again? Ugh.

>
>  /*
>   * To deactivate a memory region, there are 3 cases to handle across
> --
> 2.43.0
>

