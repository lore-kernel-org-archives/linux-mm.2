Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7545BF43848
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72E86B0088; Wed, 15 Apr 2026 11:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49A56B0089; Wed, 15 Apr 2026 11:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86E26B008C; Wed, 15 Apr 2026 11:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA0C16B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:53:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F5EA14043D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:53:38 +0000 (UTC)
X-FDA: 84661235316.16.921668E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C20B380010
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:53:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DlGLUOug;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776268416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Eah7MTKP3MQv1T3pNJu3Q/x/mQvB0bQiXwPwwnBgAU=;
	b=0I4htZZ2DUka9cVrK1BXshDUxs3qjaeV97NqkwmJpbFgfffnbMxHYKI/TKKxhyVknKrB5+
	a1V+9mHdmXr91YIVolH0LYzVr3WVZhEBW2fPswA9nIIg7CCBGRUuxHr+HZP/HrIG+2QjIv
	BTCx8fnwmviq5mpYZ1mMrT3GsgTOg7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776268416; a=rsa-sha256;
	cv=none;
	b=zy6Kj4KzDLtCV8mrxCMWOMq3WcNvl3ahCJNkKKTXALXkX7vBmWLQip9Szfq6lvefWvi9e/
	4UK++sbozo0I1rqFLysMWvFBJDIjoqWOZyfa6V4kZR2dRG9p4v0JlslZixbcHwlXziIfbS
	KNessozxnlKvCg2hdVi17L6H6NcuWdc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DlGLUOug;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB0BB600AE;
	Wed, 15 Apr 2026 15:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A646C19424;
	Wed, 15 Apr 2026 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776268415;
	bh=pF5Ty1TKfbXQTKmLGalKXImAXtzwkULsJDc+vi4BCZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DlGLUOuga1MKiMMANQa+Xk/NacVG+N3rBbJfCtnyo19AEl1tE+4MksQOwjbEhbhPp
	 jW7SzH/5Nyz1ZO+tC4wvPydch5UTMHICyGDxlOJm3ceDJeRhFvHkZ+8+LsUtLzoyhz
	 32fmq9wPfWG550vpxwBSqtJPFwaqyFBz7UFdwAH7je4GAH6yNHCNBfXGpn+pPkFSwb
	 bx8T3rxSf1V08O+tncqh6acRwlEE0HsKP0+zmeWypjdet9c+vb+WXyd9YyI4LRlEoe
	 Zdr9LirARf4S4xVxQIGPC3feUCBDloz+XHbrlXpQK1a912jqlO4/aLE6DCRJa98/Lt
	 DPukwP+gwpx0A==
Date: Wed, 15 Apr 2026 18:53:25 +0300
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
Subject: Re: [PATCH v2 1/6] mm/sparse-vmemmap: Fix vmemmap accounting
 underflow
Message-ID: <ad-0dcuaoC9LKDEF@kernel.org>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
 <20260415111412.1003526-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415111412.1003526-2-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: C20B380010
X-Rspamd-Server: rspam07
X-Stat-Signature: ukpq6w9j79sihufqagioc7s5oguyqi8h
X-Rspam-User: 
X-HE-Tag: 1776268416-469566
X-HE-Meta: U2FsdGVkX1+uZal7K93ue4KUJ4eRh1TLQJdAMfBW+/bDSCrVLRVG9s+vLBjKVLmHAMAC9ixPuLLJFmAkl9mW5iS/qTbaEn9GfWVOqkpZzcCCs7UvGXrN55ETdF+QFiCdscI6LQ0E8LunAAQAj5fA5jvcvyqZboHCSV+KvwO+Rvvs6LTVyz0kaeVmJxoSImJHokwRAmhLYB1xY+PnjtKKn7aVAbO+x9SYiU66yMQZKdKApcLIj3zXsRlo/uoy3sY1X5SGrwS+D9OLUSXk0zhJzUW10ZUDXOzK5JvEUkS+rMob8HQbwb0G+qwm0uL3EgxWv6FY9z+1t8Qm4hbp7PgelvwJ/1u8Z1dkMyry9xJp1eLZAMLycxSO9uYy5FZc8ITgNlo9V8ewdnHAmMb9/6Vq6dAmM2UpSREO5P8ukqAvvov5/g272CZiEsXwmYSdZMjOvNq0hrUstLcI1eiTQQsg5Kj5KflZVWDq8CsiNXhaCKOGX1x+Y5p4d3oc07zCvAPYcn9JWo1SS3+n4576YmraA9d/RP0Kxhu4vYKfGpMM/WfZqUkxSHhHmeU0iSw+9Mm7RBmdtrooriSjyy4cR8v9M0AKV4rzwxxjLUweTNtkDGuY5nvXOMGZYtaTEHlN1eC41whfIOy983lHUY1VovQNdP3+PNyh37wp6x0rVJsMrYkLI9tlQlwdraZaIcwes8qSLll+HulAYZMWTDYqqsdP0Lj5s7vj124YOun9T0hj04cxupadHt7y2zLd9vn45XCWiF5Dr9Ji7NbAwZXuj38g2MVe86EvFEGFfY4ze+7a1swyXwtYyPJOjO37C4p5zm/YfnoRPLtLFSLohlB+DwdlaFTqGZhOJ4X1PmXBh6/HLLNJ9x/yTfPQm8SQh4OTNxjoqgEF1Nbhk8CA5Iq51n8NdGgCc8covh38uQ1L/Jk9Z3jyqdRffA9Kw0tfSPHSX/yOvBH/uILmmrSraBdzz2t
 E7NxgBH/
 iqx0gjnhvEZXKLwztISohDQ0SkV6oJ+sSBlEVRUXgWvDi7dnq5U3OrcjLv+oppYKd4nmNB/us+1itMEfEPiwqsO+m2rukDPz3QAFcmK++hDoxxxwlWK7atC0BDm4lSvN8tug1wqM46wvhXMJwliv96Nak1UBcrhaVO3pMe+jo81CblMOeihzJoJXPyM81taAMdw8XfLL1aOCuGfX4GqMIZ/W3Y9MD4IvmpKdWn5esxsBRcljTTG4ef2qTeeYaywhOabdymk8xEwZmiYdy1ngHyoUQgVSCMH9glRGQh4QbxZVc+B0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 07:14:07PM +0800, Muchun Song wrote:
> In section_activate(), if populate_section_memmap() fails, the error
> handling path calls section_deactivate() to roll back the state. This
> causes a vmemmap accounting imbalance.
> 
> Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
> memmap pages are accounted for only after populate_section_memmap()
> succeeds. However, the failure path unconditionally calls
> section_deactivate(), which decreases the vmemmap count. Consequently,
> a failure in populate_section_memmap() leads to an accounting underflow,
> incorrectly reducing the system's tracked vmemmap usage.
> 
> Fix this more thoroughly by moving all accounting calls into the lower
> level functions that actually perform the vmemmap allocation and freeing:
> 
>   - populate_section_memmap() accounts for newly allocated vmemmap pages
>   - depopulate_section_memmap() unaccounts when vmemmap is freed
>   - free_map_bootmem() handles early bootmem section accounting
> 
> This ensures proper accounting in all code paths, including error
> handling and early section cases.
> 
> Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/sparse-vmemmap.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 6eadb9d116e4..a7b11248b989 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -656,7 +656,12 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap)
>  {
> -	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> +	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
> +						      pgmap);
> +
> +	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> +
> +	return page;
>  }
>  
>  static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
> @@ -665,13 +670,17 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
>  	unsigned long start = (unsigned long) pfn_to_page(pfn);
>  	unsigned long end = start + nr_pages * sizeof(struct page);
>  
> +	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
>  	vmemmap_free(start, end, altmap);
>  }
> +
>  static void free_map_bootmem(struct page *memmap)
>  {
>  	unsigned long start = (unsigned long)memmap;
>  	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
>  
> +	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
> +						  PAGE_SIZE)));
>  	vmemmap_free(start, end, NULL);
>  }
>  
> @@ -774,14 +783,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>  	 * The memmap of early sections is always fully populated. See
>  	 * section_activate() and pfn_valid() .
>  	 */
> -	if (!section_is_early) {
> -		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
> +	if (!section_is_early)
>  		depopulate_section_memmap(pfn, nr_pages, altmap);
> -	} else if (memmap) {
> -		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
> -							  PAGE_SIZE)));
> +	else if (memmap)
>  		free_map_bootmem(memmap);
> -	}
>  
>  	if (empty)
>  		ms->section_mem_map = (unsigned long)NULL;
> @@ -826,7 +831,6 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>  		section_deactivate(pfn, nr_pages, altmap);
>  		return ERR_PTR(-ENOMEM);
>  	}
> -	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
>  
>  	return memmap;
>  }
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

