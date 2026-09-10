Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213ECC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396AA6B0092; Thu, 10 Sep 2026 09:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347F66B009B; Thu, 10 Sep 2026 09:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CF06B009D; Thu, 10 Sep 2026 09:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 006996B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:46:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 960EB140521
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:46:23 +0000 (UTC)
X-FDA: 85197977046.14.889B045
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F36C14000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:46:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fvRVzZSB;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789047982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Oe0BvZm5FHOvWBkLD3sNkGjaEgWZ8qDgMjtwDlhRx4=;
	b=8hqCwy0OAp4oZFGlImkdfLKUxp1TU0dnHiiTZAD1nqh24VZ1fuCC+Gyid4GLFLMSXEHi7L
	lnQlSmNDFhxwRrVwVZl3fbo7vMKSxMEYix0tiFmyxo53UYqk0p4Dpr9oUK4qxAAPSy1BzU
	6WeV3GboGULVMKvY/GBfoDvRzLCatFI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789047982;
	b=Ic+BvgVwp8Fk/hj2yCEqQlYwPRJ4ySi/9CmukznV7eKSMCfU8H02rGWoLI/4LoFFKDIyOH
	p2jEdaPEnJ9krUyHyKjVvQ7F6qv7zkC3gWlgFmNw/TClyAbn03fY5wz/PWNm0R0EOJ0lXE
	P+eX8ZVF+DFjcd5qP+A5ijrpRUS8WyA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fvRVzZSB;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E23E6600E2;
	Thu, 10 Sep 2026 13:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C30C1F00893;
	Thu, 10 Sep 2026 13:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789047980;
	bh=/Oe0BvZm5FHOvWBkLD3sNkGjaEgWZ8qDgMjtwDlhRx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fvRVzZSBUred0+u9ZQGfr/eDwhY+FWpsp+KPRzqTc4UYs+y6VkFGW+G4q5kdf/fZo
	 AEEaXO2uGaKETeaPeRvLq1Nb7fO3l5h4s28rPYakOOGfPyl89tQinq/gc2TsS7axA7
	 RosUfXB0gXldHTtA0tddCh6NOIv2257dojEqJpHI2Rl8pkue7QktJTQN0KtBXMUq+y
	 ztvRaFlzTBgWV+3khp5WfVi459lxuuiRzYbq+27orKgkKhvl6cgNSQgmNBDd7LyEuV
	 VTC0WJ1MmjAjMu5MbcTHk88L7CPBn4OSwchrXgkkk+krTVK0J/L7YDqv5j/fdEz99i
	 4kEI4T3Rk+uLw==
Date: Thu, 10 Sep 2026 14:46:10 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/12] mm/sparse: rename and cleanup sparse_init_nid()
Message-ID: <aqK0S1OT5csJFIq1@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-4-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-4-008fc8d579fe@kernel.org>
X-Stat-Signature: k5foqg3zqezm3mnwmjbgw78dyiu6i47i
X-Rspam-User: 
X-Rspamd-Queue-Id: F36C14000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789047981-788183
X-HE-Meta: U2FsdGVkX1+R7le7bVhpTvJYtei1LGlIB4FgTAhLGLuqRBtupqQ2MKrnIjWykYXQJRvFg/7kaxUap9H8XHluowoLSsUqLJCYytcCUN8+ys+mYpHz19wVLHCZSaH3+hJ516wK8vg7CMQyKCxezeUpBt6qiPj2TjNY+Oj2qsPllj5xTuGW66PSCDnPpdqaZxRXmaiPZoHO7nIBK3hmh0RQWEezbik9kzoiUUTVx+QGQ9OJDxfaDLmIFmh9RU/tyPR7qLsQiEH3sgmrz2qed4ykXNuNDIJ1gcKn1gMyd9ldqRQCCW1Bota2moi31rk1GvIn0/28xXYuLRrHxN73DWWbHG0are7mxOzHRJj51atsAbprb4pbZQ+c7HNOhco0EDe/CKrxWGqZFNYG+83K03epo7l4CqNKAzM9D5baGSKN531K3b5FbtMfTkmcuFvqmCC/whYJkqpJraGQYZMzRnsQSUmBE26TQbxgGvpHUaeKHUgMsEMzuzdSF1bVgnydX/klWtsLaVgyyW5nV+scN62g68JLId5eBX2fAPylBEMEtJx+zh4sogfCFaD0fJ37WA3Y4GGnaVLUnynj1bP7dUpDda0pCIJ+17kMnA1R6j5zDciMFKYmz67C32DQ6VzEkfDSAWXXt1LQcjeGuBXY9hnuFGUD738k9OjSjTrtu33Z4KbI5eJgqP2kof1uQJpnQKXuOm30faYli1ejDm7ijR+dIrdbZToUQ4b5YiKIewyPfdM9Di0wQNxIuIL3UcbzmlCZvnld08LzQCLRRNgDSM5f3se6oMJM919973xDfwVFjseJS8yoTxNktR0l/vgXJFdg/oFNKUAQUSCqBrzvBqyRmvFv2tCVjRWFuGZ8C1GCIBWYAhSB6St7HZcKsVqVPFaRFDnHhUBxPLjUxcyW8uNnugj8bsYnMS/T0joAfUSwopswYYeIraFD23Z1wdQBg4iiTd2Lq8hbvdVCJ+1JJkD
 aNxg+0Pu
 dIQgWUn6rB7RsMiv9hrkUGpp5/hvJ8CzXiAGIDqy7JaAKyGzBIOcojvop+37D8EU3wd1HCnM40Hj7mEjF2VKOxd0fjN8EjdK9LU35JOuo+Z3GGrpvPU4IGBoFaPC39/A7s0nV6UWMYb/398Ht6o0azJ+Jk7O+h9pZztVsd8hkYP1iA1Q3uowhhptGLh7zWWYalyatyaBmCia8r54HezajCRhwAzUpEA45VVbXaHmsLBvGZcNpJeF9c30OeZ9vqiQuCwiXGJVeil8wii3BTFqLlszLZYV6UssKCHuHKwVW92x7RG0DYuZGPYhUBS+tjI5MnROY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:57PM +0200, David Hildenbrand (Arm) wrote:
> Let's rename it to "sparse_metadata_init_nid", avoid the "pnum" terminology
> and drop the function comment. Further, rename the "map" variable to
> "mem_map" for consistency with other functions.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, one nit below.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/sparse.c | 41 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index a85a9c3840f6c..f84bfceb53060 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -222,37 +222,34 @@ void __weak __meminit vmemmap_populate_print_last(void)
>  {
>  }
>
> -/*
> - * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
> - * And number of present sections in this node is map_count.
> - */
> -static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
> -				   unsigned long pnum_end,
> -				   unsigned long map_count)
> +static void __init sparse_metadata_init_nid(int nid,
> +		unsigned long start_section_nr, unsigned long end_section_nr,
> +		unsigned long nr_sections)
>  {
> -	unsigned long pnum;
>  	struct mem_section_usage *usage;
> +	unsigned long section_nr;
>
> -	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
> +	usage = memblock_alloc_node(nr_sections * mem_section_usage_size(),
>  				    SMP_CACHE_BYTES, nid);
>  	if (!usage)
>  		panic("Failed to allocate usemap for node %d\n", nid);
>
> -	for_each_present_section_nr(pnum_begin, pnum) {
> -		unsigned long pfn = section_nr_to_pfn(pnum);
> -		struct page *map;
> +	for_each_present_section_nr(start_section_nr, section_nr) {
> +		unsigned long pfn = section_nr_to_pfn(section_nr);

NIT: Could be const?

> +		struct page *mem_map;
>
> -		if (pnum >= pnum_end)
> +		if (section_nr >= end_section_nr)
>  			break;
>
> -		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
> -						nid, NULL, NULL);
> -		if (!map)
> -			panic("Failed to allocate memmap for section %lu\n", pnum);
> +		mem_map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid,
> +						    NULL, NULL);
> +		if (!mem_map)
> +			panic("Failed to allocate memmap for section %lu\n",
> +			      section_nr);
>  		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
>  							       NULL, NULL));
> -		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
> -					SECTION_IS_EARLY);
> +		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
> +					mem_map, usage, SECTION_IS_EARLY);
>  		usage = (void *)usage + mem_section_usage_size();
>  	}
>  }
> @@ -270,12 +267,14 @@ static void __init sparse_metadata_init(void)
>  			nr_sections++;
>  			continue;
>  		}
> -		sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
> +		sparse_metadata_init_nid(nid_begin, start_section_nr,
> +					 section_nr, nr_sections);
>  		nid_begin = nid;
>  		start_section_nr = section_nr;
>  		nr_sections = 1;
>  	}
> -	sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
> +	sparse_metadata_init_nid(nid_begin, start_section_nr, section_nr,
> +				 nr_sections);
>  }
>
>  /*
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

